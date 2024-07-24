/* vmdmdoc.cpp : implementation of the CFaxDisplayDoc class */
#include "stdafx.h"

#include "winflags.h"
#include "Voice Mail Sample.h"

#include "faxdoc.h"
#include "faxdocvw.h"
#include "mainfrm.h"
extern "C"
{
#include "bitiff.h"
}
#include "dibpal.h"
  
#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CFaxDisplayDoc

IMPLEMENT_DYNCREATE(CFaxDisplayDoc, CDocument)

BEGIN_MESSAGE_MAP(CFaxDisplayDoc, CDocument)
    //{{AFX_MSG_MAP(CFaxDisplayDoc)
    ON_COMMAND(IDM_PAGEFORWARD, OnPageForward)
    ON_UPDATE_COMMAND_UI(IDM_PAGEFORWARD, OnUpdatePageForward)
    ON_COMMAND(IDM_PAGEBACKWAD, OnPageBackwad)
    ON_UPDATE_COMMAND_UI(IDM_PAGEBACKWAD, OnUpdatePageBackwad)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFaxDisplayDoc construction/destruction

CFaxDisplayDoc::CFaxDisplayDoc()
{
    // TODO: add one-time construction code here
    hDib = 0;
    m_bMono = FALSE;
    SetRect(&rScale, 1, 1, 1, 1);
    SetRect(&sDisplay.rOrigo, 0, 0, 0, 0);
    wDisplayMode = DISP_SCALED;     // Default view mode
    nImages = 1;
    nCurrent = 0;
    wScreenMode = BIS_SCALENORMAL;  // Default view mode for decompress to screen.
    sNote.bOnHead = FALSE;
    sNote.hStr = 0;
    bChanged = FALSE;
    dwCompression = NOCOMPRESSION;
    m_hPalette = NULL;
    wHorizontalDPI = 0;
    wVerticalDPI = 0;
    sNote.bOpaque = TRUE;
    bFontSelected   = FALSE;
}

CFaxDisplayDoc::~CFaxDisplayDoc()
{
    if(hDib)        // Delete device independent bitmap asscociated to the actual document.
        GlobalFree(hDib);
    if(sNote.hStr)
        GlobalFree(sNote.hStr);
    if(m_hPalette)
        delete m_hPalette;
}

/////////////////////////////////////////////////////////////////////////////
// Prints the last error occured in TIFF-SDK.
/////////////////////////////////////////////////////////////////////////////
void CFaxDisplayDoc::PrintTiffError(void)
{
    int     nError = TiffError();
    char    Buffer[80];

    if(nError) {
        TiffErrorString(Buffer, nError);
        AfxMessageBox(Buffer);
    }
}

void CFaxDisplayDoc::OnCloseDocument()
{
	CDocument::OnCloseDocument();
}

static void SetDibDPI(HDIB hDib, UINT xDPI, UINT yDPI) {
    LPBITMAPINFOHEADER lpB;
    lpB = (LPBITMAPINFOHEADER)GlobalLock(hDib);
    if(lpB==NULL)
        return;
    lpB->biXPelsPerMeter = (LONG)( (double)xDPI * 39.37 + 0.5 );
    lpB->biYPelsPerMeter = (LONG)( (double)yDPI * 39.37 + 0.5 );
    GlobalUnlock(hDib);
    return; 
}

//
// Load TIFF image.
//
void CFaxDisplayDoc::LoadTIFFImage(UINT nImage)
{
TIFFFILE            hChain;
LONG                dwDPI;
DWORD               dwValue;
BITMAPINFOHEADER    lpBmi;
    

    hChain = OpenTiffFile(szTiffFileName, T_READ);
    if(hChain) 
	{
        if(GetTiffImage(hChain, nImage)) 
		{
            nImages = (UINT)NumberOfTiffImages(hChain, ALLVERSIONS);
            //
            // Get image dimension.
            //
            if(GetTiffDimensions(hChain, nImage, &lpBmi)!=TOK) 
			{
                PrintTiffError();               /* NGY */
                CloseTiffFile(hChain);
                return; 
			}
                
            dwWidth = lpBmi.biWidth;
            dwHeight = lpBmi.biHeight;
            //
            // Get image resolution.
            //
            GetTiffImageDPI(hChain, nImage, &dwDPI);
            wHorizontalDPI = LOWORD(dwDPI);
            wVerticalDPI = HIWORD(dwDPI);
            //
            // Get image color information.
            //
            GetTiffImageInfo(hChain, nImage, BITSPERSAMPLE, &dwValue);
            wBits = (UINT)dwValue;
            GetTiffImageInfo(hChain, nImage, SAMPLESPERPIXEL, &dwValue);
            wPlanes = (UINT)dwValue;
            //
            // Get compression info.
            //
            GetTiffImageInfo(hChain, nImage, COMPRESSION, &dwCompression);
            switch(dwCompression) 
			{
                case CCITT_GROUP3:
                    dwPredictor = 0L;
                    GetTiffImageInfo(hChain, nImage, GROUP3OPTIONS, &dwPredictor);
                    break;
                case LZW_COMPRESSION:
                    dwPredictor = 1L;       /* NGY */
                    GetTiffImageInfo(hChain, nImage, PREDICTOR, &dwPredictor);
                    break;
            }
        } 
		else 
		{
            PrintTiffError();
        }

	HDIB	hNewDib = hNewDib = LoadTiffIntoDIB(szTiffFileName, nImage,0);

        if(hNewDib)
        {
            LPBITMAPINFOHEADER  lpBmi;
            WORD                wplane,wbit;
            int                 x_dpi;

            if(hDib) GlobalFree(hDib);

            lpBmi = (LPBITMAPINFOHEADER)GlobalLock(hNewDib);
            wplane = lpBmi->biPlanes;
            wbit = lpBmi->biBitCount;
            if(lpBmi->biXPelsPerMeter && lpBmi->biYPelsPerMeter)
                x_dpi = (int)( lpBmi->biYPelsPerMeter/(float)39.37 + 0.5 );
            else
                x_dpi = 0;
            GlobalUnlock(hNewDib);
            hDib = hNewDib;
        }
        else
            PrintTiffError();

        CloseTiffFile(hChain);
        nCurrent = nImage;

     } 
     else
     {
        PrintTiffError();
     }
}

/////////////////////////////////////////////////////////////////////////////
// Loads the specified image from a file. If pszPathName is NULL the specified
// image will be loaded from the multi image file.
/////////////////////////////////////////////////////////////////////////////
void CFaxDisplayDoc::LoadImage(const char *pszPathName, UINT nImage)
{
POSITION            ps = GetFirstViewPosition();
HWND                hWnd =  GetNextView(ps)->m_hWnd;

    if(pszPathName)
	{
        lstrcpy(szTiffFileName, pszPathName);
    }

    LoadTIFFImage(nImage);
    
    if (hDib)  GetInfoFromDIB();
    bFontSelected   = FALSE;
}
    
BOOL CFaxDisplayDoc::GetInfoFromDIB( void )
{
    POSITION            ps = GetFirstViewPosition();
    HWND                hWnd =  GetNextView(ps)->m_hWnd;
    LPBITMAPINFOHEADER  lpBmi;

    if(hDib)
    {
        lpBmi = (LPBITMAPINFOHEADER)GlobalLock(hDib);
        if(lpBmi)
        {
            //
            // Get essential image information from the DIB.
            //
            if(wHorizontalDPI==0 && lpBmi->biXPelsPerMeter)   
                wHorizontalDPI = (UINT)((float)(lpBmi->biXPelsPerMeter)/ 39.37);
            if(wVerticalDPI==0 && lpBmi->biYPelsPerMeter)     
                wVerticalDPI = (UINT)((float)(lpBmi->biYPelsPerMeter)/ 39.37);
            wPlanes = lpBmi->biPlanes;
            wBits = lpBmi->biBitCount;
            dwWidth = lpBmi->biWidth;
            dwHeight = lpBmi->biHeight;
            GlobalUnlock(hDib);

            RECT rOrigin;
            SetRect(&rOrigin, 0, 0, 0, 0);

            //
            // Display the image.
            //
            m_hPalette = new CPalette;

            if(!::CreateDIBPalette(hDib, m_hPalette))
            {
                delete m_hPalette;
                m_hPalette = NULL;
            }
            DisplayDIBStart(hWnd, hDib, &rOrigin, &rScale, wDisplayMode | DISP_NEWDIB, &sDisplay);

            POSITION pos = GetFirstViewPosition();
            CView *pw = GetNextView(pos);
            if(pw)
            {
                if( pw->IsKindOf(RUNTIME_CLASS(CFaxDisplayView)) )
                {
                    CFaxDisplayView *pwi = (CFaxDisplayView *)pw;
                    pwi->AfterLoadImage();  
                }   
            }            

        }
        else
        {
            GlobalUnlock(hDib);
            GlobalFree(hDib);
            hDib = 0;
            return FALSE ;
        }
    }
    return(TRUE); 
}

void CFaxDisplayDoc::SetNewDib(HANDLE hDibPar)
{
    if(hDib && hDibPar)
    {
        GlobalFree( hDib );
        hDib = NULL;
    }

    UpdatePalette();

    CFaxDisplayView *pwi = (CFaxDisplayView*)qryImgView();
    if(pwi)
    {
        pwi->SetNewDib(hDibPar,FALSE);
    }
}

BOOL CFaxDisplayDoc::OnOpenDocument(const char *pszPathName)
{
    LoadImage(pszPathName, 0);
    if(hDib)
        AfxGetApp()->AddToRecentFileList(pszPathName);
    return (hDib ) ? TRUE : FALSE;
}

/////////////////////////////////////////////////////////////////////////////
// Set palette from the dib. (This function must be called when an operation
// is changed the pallette of the DIB.)
//
void CFaxDisplayDoc::UpdatePalette(void )
{
    if(hDib) 
    {
        if(m_hPalette)                // Delete old palette
            delete m_hPalette;
        m_hPalette = new CPalette;    // Create new palette
        if(m_hPalette) 
        {
            // Get palette from DIB.
            if(!::CreateDIBPalette(hDib, m_hPalette)) 
            {
                delete m_hPalette;
                m_hPalette = NULL;
            }
        }
    }
}

/////////////////////////////////////////////////////////////////////////////
// CFaxDisplayDoc serialization
/////////////////////////////////////////////////////////////////////////////

void CFaxDisplayDoc::Serialize(CArchive& ar)
{
    if (ar.IsStoring())
    {
        // TODO: add storing code here
    }
    else
    {
        // TODO: add loading code here
    }
}
                     
                     

/////////////////////////////////////////////////////////////////////////////
// CFaxDisplayDoc diagnostics
/////////////////////////////////////////////////////////////////////////////

#ifdef _DEBUG
void CFaxDisplayDoc::AssertValid() const
{
    CDocument::AssertValid();
}

void CFaxDisplayDoc::Dump(CDumpContext& dc) const
{
    CDocument::Dump(dc);
}

#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
//                      CFaxDisplayDoc COMMANDS
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
// Views next image of multi image TIFF file.
/////////////////////////////////////////////////////////////////////////////
void CFaxDisplayDoc::OnPageForward()
{
    // TODO: Add your command handler code here
    LoadImage(NULL, nCurrent+1);
}

void CFaxDisplayDoc::OnUpdatePageForward(CCmdUI* pCmdUI)
{
    // TODO: Add your command update UI handler code here
    pCmdUI->Enable((nImages) > 1 && (nCurrent < nImages-1));
}

/////////////////////////////////////////////////////////////////////////////
// Views previous image of multi image TIFF file.
/////////////////////////////////////////////////////////////////////////////
void CFaxDisplayDoc::OnPageBackwad()
{
    // TODO: Add your command handler code here

    LoadImage(NULL, nCurrent-1);
}

void CFaxDisplayDoc::OnUpdatePageBackwad(CCmdUI* pCmdUI)
{
    // TODO: Add your command update UI handler code here
    pCmdUI->Enable((nImages > 1) && (nCurrent > 0));
}

/////////////////////////////////////////////////////////////////////////////
//                      Clipborard Functions.
/////////////////////////////////////////////////////////////////////////////

CView* CFaxDisplayDoc::qryImgView()
{
POSITION    pos = GetFirstViewPosition();
CView       *pw = GetNextView(pos);

    if(pw)
    {
        if( pw->IsKindOf(RUNTIME_CLASS(CFaxDisplayView)) )
        {
            CFaxDisplayView *pwi = (CFaxDisplayView *)pw;
            return pwi;
        }
    }
    return NULL;
}

void CFaxDisplayDoc::InvalidateRect( LPRECT lpr, BOOL b )
{
    POSITION pos = GetFirstViewPosition();
    CView* pFirstView;
    while( (pFirstView = GetNextView( pos )) != NULL )
        pFirstView->InvalidateRect( lpr, b );
}

