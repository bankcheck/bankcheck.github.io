// imgdoc.cpp : implementation of the CImgDoc class
//
#define STRICT
#include "stdafx.h"
#include <io.h>

#include "v_config.h"
#include "string.h"

extern "C" {
	#include "bidib.h"
	#include "biprint.h"
	#include "bitiff.h"
	#include "bidisp.h"
    #include "cals.h"
#if JPEG_EXIST == 1
    #include "bijpeg.h"
#endif
};

#pragma warning(disable:4103)

#include "faxcpp.h"
#include "commcl.h"


#include "resource.h"

#include "magnifyw.h"
#include "disp.h"
#include "imgvw.h"
#include "inputvw.h"
#include "imgdoc.h"
#include "dialogs.h"
#include "faxdlg.h"
#include "demo.h"
#include "mainfrm.h"
#include "dibpal.h"
#include "ascii.h"


#ifdef WIN32
        #include <string.h>
#endif

#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CImgDoc

IMPLEMENT_DYNCREATE(CImgDoc, CDocument)

BEGIN_MESSAGE_MAP(CImgDoc, CDocument)
    //{{AFX_MSG_MAP(CImgDoc)
    ON_COMMAND(IDM_DIMENSIONS, OnDimensions)
    ON_COMMAND(IDM_PAGEFORWARD, OnPageForward)
    ON_UPDATE_COMMAND_UI(IDM_PAGEFORWARD, OnUpdatePageForward)
    ON_COMMAND(IDM_PAGEBACKWAD, OnPageBackwad)
    ON_UPDATE_COMMAND_UI(IDM_PAGEBACKWAD, OnUpdatePageBackwad)
    ON_COMMAND(ID_EDIT_COPY, OnEditCopy)
    ON_COMMAND(ID_EDIT_PASTE, OnEditPaste)
    ON_UPDATE_COMMAND_UI(ID_EDIT_COPY, OnUpdateEditCopy)
    ON_UPDATE_COMMAND_UI(ID_EDIT_PASTE, OnUpdateEditPaste)
    ON_COMMAND(IDM_EDIT_DELETE, OnEditDelete)
    ON_UPDATE_COMMAND_UI(IDM_EDIT_DELETE, OnUpdateEditDelete)
    ON_COMMAND(ID_FILE_SAVE, OnFileSave)
    ON_COMMAND(ID_FILE_SAVE_AS, OnFileSaveAs)
    ON_UPDATE_COMMAND_UI(ID_FILE_SAVE, OnUpdateFileSave)
    ON_UPDATE_COMMAND_UI(ID_FILE_SAVE_AS, OnUpdateFileSaveAs)
    ON_COMMAND(ID_FAX_SEND, OnFaxSend)
    ON_UPDATE_COMMAND_UI(ID_FAX_SEND, OnUpdateFaxSend)
    ON_COMMAND(ID_FILE_PRINT, OnFilePrint)
    ON_UPDATE_COMMAND_UI(ID_FILE_PRINT, OnUpdateFilePrint)
    ON_COMMAND(IDM_FITOWINDOW, OnFitowindow)
    ON_COMMAND(IDM_CENTERIMAGE, OnCenterimage)
    ON_COMMAND(IDM_ZOOMIN, OnZoomIn)
    ON_COMMAND(IDM_ZOOMOUT, OnZoomOut)
    ON_COMMAND(IDM_ROTATE90, OnRotate90)
    ON_COMMAND(IDM_ROTATE270, OnRotate270)
    ON_COMMAND(IDM_ROTATE180, OnRotate180)
    ON_COMMAND(IDM_FLIPHORIZONTAL, OnFlipHorizontal)
    ON_COMMAND(IDM_FLIPVERTICAL, OnFlipVertical)
    ON_COMMAND(IDM_VIEW_INVERT, OnViewInvert)
    ON_COMMAND(IDM_VIEW_ROTATE, OnViewRotate)
    ON_COMMAND(IDM_VIEW_SKEW, OnViewSkew)
    ON_COMMAND(IDM_VIEW_SCALE, OnViewScale)
    ON_COMMAND(IDM_VIEW_COLOR_TO_GRAY, OnViewColorToGray)
    ON_COMMAND(IDM_IMAGE_CONV_TO_24, OnImageConvTo24)
    ON_COMMAND(IDM_SHOW_DPI, OnShowDpi)
    ON_COMMAND(IDM_ZOOM_MODE, OnZoomMode)
    ON_COMMAND(IDM_CUSTOM_ZOOM, OnCustomZoom)                                    //
    ON_COMMAND(IDM_ZOOM_STEPS, OnZoomSteps)
    ON_COMMAND(IDM_HALFTONE, OnHalftone)
    ON_COMMAND(IDM_MAGNIFY, OnMagnify)
    ON_UPDATE_COMMAND_UI(IDM_CENTERIMAGE, OnUpdateCenterimage)
    ON_UPDATE_COMMAND_UI(IDM_FITOWINDOW, OnUpdateFitowindow)
    ON_UPDATE_COMMAND_UI(IDM_ZOOMIN, OnUpdateZoomIn)
    ON_UPDATE_COMMAND_UI(IDM_ZOOMOUT, OnUpdateZoomOut)
    ON_UPDATE_COMMAND_UI(IDM_ROTATE90, OnUpdateRotate90)
    ON_UPDATE_COMMAND_UI(IDM_ROTATE270, OnUpdateRotate270)
    ON_UPDATE_COMMAND_UI(IDM_ROTATE180, OnUpdateRotate180)
    ON_UPDATE_COMMAND_UI(IDM_FLIPHORIZONTAL, OnUpdateFlipHorizontal)
    ON_UPDATE_COMMAND_UI(IDM_FLIPVERTICAL, OnUpdateFlipVertical)
    ON_UPDATE_COMMAND_UI(IDM_VIEW_INVERT, OnUpdateViewInvert)
    ON_UPDATE_COMMAND_UI(IDM_VIEW_ROTATE, OnUpdateViewRotate)
    ON_UPDATE_COMMAND_UI(IDM_VIEW_SKEW, OnUpdateViewSkew)
    ON_UPDATE_COMMAND_UI(IDM_VIEW_SCALE, OnUpdateViewScale)
    ON_UPDATE_COMMAND_UI(IDM_VIEW_COLOR_TO_GRAY, OnUpdateViewColorToGray)
    ON_UPDATE_COMMAND_UI(IDM_IMAGE_CONV_TO_24, OnUpdateImageConvTo24)
    ON_UPDATE_COMMAND_UI(IDM_SHOW_DPI, OnUpdateShowDpi)
    ON_UPDATE_COMMAND_UI(IDM_ZOOM_MODE, OnUpdateZoomMode)
    ON_UPDATE_COMMAND_UI(IDM_HALFTONE, OnUpdateHalftone)
    ON_UPDATE_COMMAND_UI(IDM_MAGNIFY, OnUpdateMagnify)
    ON_COMMAND(ID_CLOSE_DOCUMENT, OnCloseDocument)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


BOOL CopyDibDPI(HDIB hDibOut, HDIB hDibInp)
{
    LPBITMAPINFOHEADER lpOut = NULL;
    LPBITMAPINFOHEADER lpInp = NULL;
    BOOL bRet = FALSE;

    lpOut = (LPBITMAPINFOHEADER)GlobalLock(hDibOut);
    lpInp = (LPBITMAPINFOHEADER)GlobalLock(hDibInp);
    if(lpOut==NULL || lpInp==NULL)
        goto leave;
    lpOut->biXPelsPerMeter = lpInp->biXPelsPerMeter;
    lpOut->biYPelsPerMeter = lpInp->biYPelsPerMeter;
    bRet = TRUE;
leave:
    if(lpOut)
        GlobalUnlock(hDibOut);
    if(lpInp)
        GlobalUnlock(hDibInp);
    return bRet;
}

/////////////////////////////////////////////////////////////////////////////
// CImgDoc construction/destruction

CImgDoc::CImgDoc()
{
    // TODO: add one-time construction code here
    nImages                     = 1;
    nCurrent            = 0;
    m_nFileFormat       = e_nFileFormat;
    bChanged            = FALSE;
    m_hDib                      = NULL;


    for ( int i=0 ; i<10 ; i++ )
        m_hDibPages[i] = NULL;

    m_palDib        = NULL;
    m_bGroup        = TRUE ;
    bFontSelected   = FALSE;

    ClearGroupInfo();
}

CImgDoc::CImgDoc(LPCSTR FileName)
{
    // TODO: add one-time construction code here
    nCurrent            = 0;
    m_nFileFormat       = e_nFileFormat;
    bChanged            = FALSE;


    for ( int i=0 ; i<10 ; i++ )
        m_hDibPages[i] = NULL;

    m_palDib        = NULL;
    m_bGroup        = TRUE ;
    bFontSelected   = FALSE;

    ClearGroupInfo();
         strcpy(szTiffFileName,FileName);
        m_bGroup=0;
if(strcmpi(FileName+strlen(FileName)-3,"tif")==0)
{

         nImages = (WORD)GetNumberOfImagesInTiffFile(szTiffFileName);
         m_hDib = LoadTiffIntoDIB(szTiffFileName, 0, FALSE);
         m_nFileFormat=FORMAT_TIFF;

}
else
{

        CAscii  AsciiDlg;
       FAXTOASCII Ascii2Bmp;
       int err;
       WORD    page_num;
       char    tabstr[128];
       HCURSOR hOldCur;
        lstrcpy( Ascii2Bmp.szFileName, szTiffFileName );
        memset( Ascii2Bmp.szTabArray, 0, sizeof(Ascii2Bmp.szTabArray) );
        if ( AsciiDlg.DoModal() == IDOK ) {
            Ascii2Bmp.nPageWidth  = AsciiDlg.m_Width;
            Ascii2Bmp.nPageLength = AsciiDlg.m_Height;
            Ascii2Bmp.nXmargin    = AsciiDlg.m_xMargin;
            Ascii2Bmp.nYmargin    = AsciiDlg.m_yMargin;
            Ascii2Bmp.nXDPI       = AsciiDlg.m_xDPI;
            Ascii2Bmp.nYDPI       = AsciiDlg.m_yDPI;
            Ascii2Bmp.nLineSpace  = AsciiDlg.m_LineSpace;
            Ascii2Bmp.nFlags      = 0;
            Ascii2Bmp.nFlags     |= AsciiDlg.m_Measure;
            lstrcpy( tabstr, AsciiDlg.m_szTabs.GetBuffer(256) );
            FillTabs( tabstr, &Ascii2Bmp );
            lstrcpy( Ascii2Bmp.szTypeFace, AsciiDlg.m_lf.lfFaceName );
            Ascii2Bmp.nFontPointSize = AsciiDlg.m_cf.iPointSize / 10;
            if ( AsciiDlg.m_lf.lfItalic )
                Ascii2Bmp.nFlags |= TEXT_ITALIC;
            if ( AsciiDlg.m_lf.lfWeight == FW_BOLD )
                Ascii2Bmp.nFlags |= TEXT_BOLD;
            Ascii2Bmp.lpLogFont = (LPLOGFONT)&AsciiDlg.m_lf;

            hOldCur = SetCursor(LoadCursor(NULL,IDC_WAIT));
            page_num = CreateDIBFaxPageFromASCII( (LPFAXTOASCII)&Ascii2Bmp, 10, m_hDibPages, &err );
            SetCursor( hOldCur );
                                m_nFileFormat=FORMAT_ASCII;
            if ( page_num && ( !err || err==ERROR_NOT_ENOUGH_SPACE ) ) {
                m_hDib = m_hDibPages[0];
                nImages = page_num;
            }
            else {
                AfxMessageBox( "Error converting ASCII to image !!!" );
                                }
                        }

}
m_bGroup=0;
}

CImgDoc::~CImgDoc()
{
    if(m_hDib)
    {
        GlobalFree(m_hDib);
        m_hDib = NULL;
    }
}

void CImgDoc::ClearGroupInfo()
{
    arName.RemoveAll();
    arType.RemoveAll();
    arStat.RemoveAll();
    GroupFileName.Empty();
    nGroupCurrent = 0;
}

/////////////////////////////////////////////////////////////////////////////
// Prints the last error occured in TIFF-SDK.
/////////////////////////////////////////////////////////////////////////////
void CImgDoc::PrintImgError(void)
{
    int     nError = TiffError();
    char    Buffer[80];

    if(nError) {
        TiffErrorString(Buffer, nError);
        AfxMessageBox(Buffer);
    }
}

BOOL CImgDoc::OnNewDocument()
{
    CMainFrame *pMainFrame = (CMainFrame *)AfxGetMainWnd();

    if ( !CDocument::OnNewDocument() )
        return FALSE;

    if ( pMainFrame->m_hScanDIB ) {
        CRect rOrigin, rScale( 1,1,1,1 ) ;
        POSITION ps    =  GetFirstViewPosition();
        CView *  pView =  GetNextView( ps );
        TRACE0( "NewDocument started.\n" );
        if ( pView->IsKindOf( RUNTIME_CLASS(CImgView) ) ){
            CImgView * pImgView = (CImgView*)pView;

            HWND hWnd = pImgView->m_hWnd;
            rOrigin.SetRectEmpty();
            m_hDib = pMainFrame->m_hScanDIB;
            pImgView->SetNewDib(m_hDib);
            bChanged = TRUE;
            SetModifiedFlag(TRUE);
            strcpy( szTiffFileName, "UNTITLED" );
            m_nFileFormat = FORMAT_BITMAP ;
            pMainFrame->m_hScanDIB = NULL;
            return TRUE ;
        }
        else
            return FALSE ;
    }
    return TRUE;
}

void CImgDoc::OnCloseDocument()
{
    int i;

    for ( i=0 ; i<10 ; i++ ) {
        if ( m_hDibPages[i] ) {
            GlobalFree( (HGLOBAL)m_hDibPages[i] );
            m_hDibPages[i] = NULL;
        }
    }
    if ( m_palDib )
        delete m_palDib;
    CDocument::OnCloseDocument();
}


/////////////////////////////////////////////////////////////////////////////////
// Update status windows. Prints the number of the current image and the number
// of the images to the status window.
//
void CImgDoc::UpdateCapAndStatus(void)
{
    if(m_hDib) {

        //
        // Show current image number and total number of images on the status bar.
        //
        CStatusBar  *pCStatusBar = GetGlobalStatusBar();
        char        String[20];

        wsprintf(String, "%d", nCurrent+1);
        pCStatusBar->SetPaneText(pCStatusBar->CommandToIndex(ID_INDICATOR_IMAGENO),String, TRUE);
        wsprintf(String, "%d", nImages);
        pCStatusBar->SetPaneText(pCStatusBar->CommandToIndex(ID_INDICATOR_IMAGETOTAL), String, TRUE);

        //
        // Display image name and image number on the caption of the image window.
        //
        CString cszFileName = szTiffFileName;

        if(nImages > 1) {
            cszFileName += ":";
			wsprintf(String, "%d", nCurrent+1);
            cszFileName += String;
        }
	SetTitle(cszFileName);        
    }
}

void CImgDoc::FillTabs( char tabstr[128], LPFAXTOASCII lpbuff )
{
   char s[5];
   int  num, i;
   char *t, *p;

   t = tabstr;
   p = s;
   i = 0;
   while ( *t ) {
      if ( *t == ',' ) {
         *p = '\x0';
         num = atoi(s);
         lpbuff->szTabArray[i] = num;
         i++;
         t++;
         p = s;
      }
      else
        *p++ = *t++;
   }
   *p = '\x0';
   num = atoi(s);
   lpbuff->szTabArray[i] = num;
}

/////////////////////////////////////////////////////////////////////////////
// Loads the specified image from a file. If pszPathName is NULL the specified
// image will be loaded from the multi image file.
/////////////////////////////////////////////////////////////////////////////
void CImgDoc::LoadImage(const char *pszPathName, WORD nImage)
{
//    POSITION            ps = GetFirstViewPosition();
    HWND                hWnd =  qryImgHwnd();
    int                 nError;
    BOOL                bDialog = FALSE, bMessage=TRUE;

    if ( m_hDib && (m_nFileFormat !=FORMAT_ASCII) ) {
        GlobalFree(m_hDib);
        m_hDib = NULL;
    }

    if(pszPathName)
        lstrcpy(szTiffFileName, pszPathName);
         char FileNameNr[8],temp[8];
         wsprintf(FileNameNr,"%d",((CImgApp*)AfxGetApp())->m_nrUntitled);
         strncpy(temp,szTiffFileName+(lstrlen(szTiffFileName)-strlen("Untitled")-strlen(FileNameNr)),8);
    if((strlen(szTiffFileName) >= strlen("Untitled")) &&
        (!strcmp(temp, "Untitled"))) {
                         //
        // Get device independent bitmap from the clipboard.
        //
        if(OpenClipboard(hWnd)) {
            m_hDib = GetClipboardData(CF_DIB);
            CloseClipboard();
            if(m_hDib==NULL)
                return;

            HANDLE hDupDib = GlobalAlloc(GHND, GlobalSize(m_hDib));
            if(hDupDib) {
                LPVOID  lpszDib, lpszDupDib;

                lpszDib = GlobalLock(m_hDib);
                lpszDupDib = GlobalLock(hDupDib);

                if(lpszDib && lpszDupDib) {
                    hmemcpy(lpszDupDib, lpszDib, GlobalSize(m_hDib));
                    GlobalUnlock(hDupDib);
                    GlobalUnlock(m_hDib);
                    m_hDib = hDupDib;
                } else {
                    GlobalUnlock(hDupDib);
                    GlobalUnlock(m_hDib);
                    GlobalFree(hDupDib);
                    hDupDib = m_hDib = 0;
                }
            } else {
                m_hDib = 0;
            }
            bChanged = TRUE;
        }
    } else {

        //
        // Get device independent bitmap from imgae file.
        //
        if(m_nFileFormat == 0 || m_nFileFormat > FORMAT_ASCII)
            m_nFileFormat = 0;  // Load Recent File and All Files as unknown
        switch(m_nFileFormat) {
            case    FORMAT_TIFF:
                m_hDib = LoadTiffIntoDIB(szTiffFileName, nImage, bDialog);
                if(m_hDib)
                {
                    nImages = (WORD)GetNumberOfImagesInTiffFile(szTiffFileName);
                }
                break;
            case FORMAT_BITMAP:
                m_hDib = LoadDIBFromFile(szTiffFileName);
                break;
//            case FORMAT_COFAX:
//                m_hDib = LoadColorFaxPage(szTiffFileName, nImage, &nError);
//                if(m_hDib)
//                    nImages = (WORD)GetNumberOfImagesInFaxFile(szTiffFileName);
//                break;
            case FORMAT_ASCII:
                {
                CAscii  AsciiDlg;
                FAXTOASCII Ascii2Bmp;
                int err;
                WORD    page_num;
                char    tabstr[128];
                HCURSOR hOldCur;

                if ( m_hDibPages[0] ) {
                    if ( nImage <= nImages ) {
                        m_hDib = m_hDibPages[nImage];
                    }
                }
                else {
                    lstrcpy( Ascii2Bmp.szFileName, szTiffFileName );
                    memset( Ascii2Bmp.szTabArray, 0, sizeof(Ascii2Bmp.szTabArray) );
                    if ( AsciiDlg.DoModal() == IDOK ) {
                        Ascii2Bmp.nPageWidth  = AsciiDlg.m_Width;
                        Ascii2Bmp.nPageLength = AsciiDlg.m_Height;
                        Ascii2Bmp.nXmargin    = AsciiDlg.m_xMargin;
                        Ascii2Bmp.nYmargin    = AsciiDlg.m_yMargin;
                        Ascii2Bmp.nXDPI       = AsciiDlg.m_xDPI;
                        Ascii2Bmp.nYDPI       = AsciiDlg.m_yDPI;
                        Ascii2Bmp.nLineSpace  = AsciiDlg.m_LineSpace;
                        Ascii2Bmp.nFlags      = 0;
                        Ascii2Bmp.nFlags     |= AsciiDlg.m_Measure;
                        lstrcpy( tabstr, AsciiDlg.m_szTabs.GetBuffer(256) );
                        FillTabs( tabstr, &Ascii2Bmp );
                        lstrcpy( Ascii2Bmp.szTypeFace, AsciiDlg.m_lf.lfFaceName );
                        Ascii2Bmp.nFontPointSize = AsciiDlg.m_cf.iPointSize / 10;
                        if ( AsciiDlg.m_lf.lfItalic )
                            Ascii2Bmp.nFlags |= TEXT_ITALIC;
                        if ( AsciiDlg.m_lf.lfWeight == FW_BOLD )
                            Ascii2Bmp.nFlags |= TEXT_BOLD;
                        Ascii2Bmp.lpLogFont = (LPLOGFONT)&AsciiDlg.m_lf;

                        hOldCur = SetCursor(LoadCursor(NULL,IDC_WAIT));
                        page_num = CreateDIBFaxPageFromASCII( (LPFAXTOASCII)&Ascii2Bmp, 10, m_hDibPages, &err );
                        SetCursor( hOldCur );
                        if ( page_num && ( !err || err==ERROR_NOT_ENOUGH_SPACE ) ) {
                            m_hDib = m_hDibPages[0];
                            nImages = page_num;
                        }
                        else {
                            AfxMessageBox( "Error converting ASCII to image !!!" );
                        }
                    }
                    else {
                        bMessage=FALSE;
                    }
                }
                }
                break;
            case FORMAT_CALS:
                m_hDib = LoadCALSIntoDIB(szTiffFileName, bDialog);
                nImages = 1;
                break;

#if JPEG_EXIST == 1
            case FORMAT_JPEG:
                m_hDib = LoadJPEGIntoDIB(szTiffFileName);
                nImages = 1;
                break;
#endif

            default:
                // No image format is given, so try to recognize the image format
                // from the specified file.
                int nFormat = GetImageFormat(szTiffFileName);
                switch(nFormat) {
                    case TIFF_FILE:
                        m_nFileFormat = FORMAT_TIFF;
                        nImages = (WORD)GetNumberOfImagesInTiffFile(szTiffFileName);
                        break;
                    case BMP_FILE:
                        m_nFileFormat = FORMAT_BITMAP;
                        break;
//                    case FAX_FILE:
//                        m_nFileFormat = FORMAT_COFAX;
//                        nImages = (WORD)GetNumberOfImagesInFaxFile(szTiffFileName);
//                        break;
                    case ASCII_FILE:
                        m_nFileFormat = FORMAT_ASCII;
                        break;
                    case CALS_FILE:
                        m_nFileFormat = FORMAT_CALS;
                        break;

#if JPEG_EXIST == 1
                    case JPEG_FILE:
                        m_nFileFormat = FORMAT_JPEG;
                        break;
#endif   /* JPEG_EXIST */

                    default:
                        AfxMessageBox(IDS_UNKNOWNFORMAT);
                        m_nFileFormat = 0;
                }
                if(m_nFileFormat)  // We recognize the format of the file.
                    m_hDib = LoadImageIntoDIB(szTiffFileName, nImage, &nError);
                break;
        }
    }
    if(m_hDib)
        nCurrent = nImage;
    else if ( bMessage ) {
        AfxMessageBox(IDS_LOADERR);
        PrintImgError();
    }
    UpdateCapAndStatus();
    SetNewDib(NULL);

    // new DPI -> new default FONT
    bFontSelected = FALSE;
}

void CImgDoc::ClearDib()
{
    CImgView *pwi = qryImgView();
    if(pwi)
    {
        pwi->wClearDib(FALSE);
        if(m_hDib)
        {
            GlobalFree( m_hDib );
            m_hDib = NULL;
        }
    }
}

void CImgDoc::SetNewDib(HANDLE hDibPar)
{
    if(m_hDib && hDibPar)
    {
        GlobalFree( m_hDib );
        m_hDib = NULL;
    }

    if(hDibPar)
        m_hDib = hDibPar;

    UpdatePalette();

    CImgView *pwi = qryImgView();
    if(pwi)
    {
    LPBITMAPINFOHEADER  lpBmi;
    WORD                wHeight, wWidth;

        lpBmi = (LPBITMAPINFOHEADER)GlobalLock(m_hDib);
        if( lpBmi )
        {
            wHeight = (unsigned short)lpBmi->biHeight;
            wWidth = (unsigned short)lpBmi->biWidth;
        }
        GlobalUnlock(m_hDib);
        pwi->SetNewDib(m_hDib);
    }
}

void CImgDoc::SaveImage(const char *pszPathName, int p_nFileFormat)
{
    BOOL    bSuccess = FALSE;
    CString  cSave;
    int      nError = 0;

    cSave = szTiffFileName;

    if(pszPathName)
        strcpy(szTiffFileName, pszPathName);
        if(p_nFileFormat == 0)
            p_nFileFormat = m_nFileFormat;
    switch(p_nFileFormat) {
        case    FORMAT_TIFF:
            bSuccess = SaveDIBInTiffFormat(szTiffFileName, m_hDib, 0, TRUE);
            break;
        case FORMAT_BITMAP:
            bSuccess = SaveDIB(szTiffFileName, m_hDib);
            break;

        case FORMAT_CALS:
            bSuccess = SaveDIBInCALSFormat(szTiffFileName, m_hDib, NULL, NULL, TRUE);
            break;
                case FORMAT_GAMMA:                                //rz
            if(wBits*wPlanes==1 && dwWidth==1728        && wHorizontalDPI>198 && wHorizontalDPI<201
                                                                                                                        && ((wVerticalDPI>198 && wVerticalDPI<201)
                                                                                                                        ||  (wVerticalDPI>98  && wVerticalDPI<101)))
                                {
                                        bSuccess = SaveDIBInGammaTiffFile( szTiffFileName, m_hDib,CCITTG31D, FALSE, 2);
                                        //AfxMessageBox("Saved in GammaLink format!");
                                }
                else
                        AfxMessageBox("This image cannot be saved in GammaLink format!");
                        break;
        case FORMAT_BICOM:                                //rz
            if(wBits*wPlanes==1 && dwWidth==1728)
                                {
                                        bSuccess = SaveDIBInBicomTiffFile( szTiffFileName, m_hDib);
                                        //AfxMessageBox("Saved in GammaLink format!");
                                }
                    else
                                AfxMessageBox("This image cannot be saved in Biocm/NMS format!");
                        break;

#if JPEG_EXIST == 1
        case FORMAT_JPEG:
            if ( SaveDIBInJPEGFile(szTiffFileName, m_hDib, m_jpeg_qu) == 0 ) {
                                bSuccess = TRUE ;
                        } else {
                                bSuccess = FALSE ;
                        }
            break;
#endif


    }
    if(bSuccess) {
        nCurrent = 0;
        nImages = 1;
        UpdateCapAndStatus();
        if( p_nFileFormat==FORMAT_GAMMA || p_nFileFormat==FORMAT_BICOM)
            m_nFileFormat = FORMAT_TIFF;
        else
            m_nFileFormat = p_nFileFormat;
        SetModifiedFlag( FALSE );
    } else {
        strcpy(szTiffFileName, cSave);
        AfxMessageBox(IDS_SAVEFAILED);
        PrintImgError();
    }
    bChanged = FALSE;
}

static int FindImageType(char *ftype)
{
    static char *tab[] =
    {
        "BMP",
        "TIF",
        NULL
    };
    static int nret[] =
    {
        FORMAT_BITMAP,
        FORMAT_TIFF,
    };
    for(int jj=0; jj<10; jj++) {
        if(tab[jj]==NULL)
            break;
        if( stricmp(ftype, tab[jj])==0 )
            return nret[jj];
    }
    return 0;
}

static LPSTR MakeImageTypeText(int nType)
{
    switch(nType)
    {
        case FORMAT_BITMAP:
                return "BMP";
        case FORMAT_TIFF:
                return "TIF";
    }
    return "???";
}

static LPSTR MakeFaxStatText(int nStat)
{
    switch(nStat)
    {
        case STAT_MONO:
                return "MONO";
        case STAT_DITH:
                return "DITH";
        case STAT_BFT:
                return "BFT";
    }
    return "???";
}

//////////////////////////////////////////////////////////////////////////////////
// Load the first image from the specified file.
//

int CImgDoc::GetBitsPerPixel(LPSTR lpFileName)
{
    int nBits = 1;
    FILEFORMAT nType;
    BOOL bOk;
    DWORD data1, data2;
    nType = GetImageFormat(lpFileName);
    switch(nType)
    {
        case TIFF_FILE:
        {
            TIFFFILE hTiff = OpenTiffFile(lpFileName, T_READ);
            if(hTiff)
            {
                bOk = GetTiffImage(hTiff, 0);
                if(bOk)
                {
                    bOk = GetTiffImageInfo(hTiff, 0, BITSPERSAMPLE, &data1);
                    if(bOk)
                    {
                        bOk = GetTiffImageInfo(hTiff, 0, SAMPLESPERPIXEL, &data2);
                        if(bOk) {
                            nBits = (int)(LOWORD(data1) * LOWORD(data2));
                        } else {
                            nBits = (int)(LOWORD(data1));
                        }
                    }
                }
                CloseTiffFile(hTiff);
            }
            break;
        }

        case BMP_FILE:
        {
            OFSTRUCT of;
            HFILE hFile = OpenFile(lpFileName, &of, OF_READ);
            if(hFile>=0)
            {
                HANDLE hDibInfo = ReadDIBInfo(hFile);
                if(hDibInfo)
                {
                    LPBITMAPINFOHEADER lpBmp = (LPBITMAPINFOHEADER)GlobalLock(hDibInfo);
                    if(lpBmp)
                    {
                        nBits = lpBmp->biBitCount * lpBmp->biPlanes;
                        GlobalUnlock(hDibInfo);
                    }
                }
                _lclose(hFile);
            }
            break;
        }
    }
    return nBits;
}

BOOL CImgDoc::LoadFaxGroup(const char *grpfile)
{
    char buf[200];
    char section[50];
    CString str;
    int typ;

    ClearGroupInfo();

    strcpy(section, "BliceFax");
    GroupFileName = CString(grpfile);
    int nFiles = GetPrivateProfileInt(section, "Files", 0, grpfile);
    if(nFiles <=0 )
        return FALSE;

    int bitsGlob = GetPrivateProfileInt(section, "BitsPixel", 1, grpfile);
    int bitsLoc = 1;

    for(int jj=0; jj<nFiles; jj++)
    {
        wsprintf(section, "Page%i", jj+1);
        buf[0] = 0;
        GetPrivateProfileString(section, "Plane1", "", buf, sizeof(buf), grpfile);
        if(buf[0]==0)
            continue;

        str = CString(buf);
        arName.Add(str);

        bitsLoc = GetPrivateProfileInt(section, "BitsPixel", 0, grpfile);
        if(bitsLoc==0)
        {
            bitsLoc = GetBitsPerPixel(buf);         /* file name */
        }

        if(bitsLoc==1)
        {
            arStat.Add(STAT_MONO);
        }
        else
        {
            GetPrivateProfileString(section, "Fstat", "DITH", buf, sizeof(buf), grpfile);
            int nStat = ( stricmp(buf, "BFT")==0 ) ? STAT_BFT : STAT_DITH;
            arStat.Add((WORD)nStat);
        }

        buf[0] = 0;
        GetPrivateProfileString(section, "FileType", "", buf, sizeof(buf), grpfile);
        typ = 0;
        if(buf[0])
        {
            typ = FindImageType(buf);
        }
        arType.Add((WORD)typ);
    }

    CView *pwi = (CView *)qryImgView();
    UpdateAllViews(pwi, HINT_NEWGROUP);
    return TRUE;
}

BOOL CImgDoc::SaveFaxGroup(const char *grpfile)
{
    char buf[100];
    int nNum = arName.GetSize();
    CString str;
    WORD nType;
    LPSTR ptr;
    if(nNum < 1)
        return FALSE;

    if(access(grpfile, 0)==0)
        remove(grpfile);

    wsprintf(buf, "%d", nNum);
    WritePrivateProfileString("BliceFax", "Files", buf, grpfile);
    WritePrivateProfileString("BliceFax", "TotalPages",  buf, grpfile);
    WritePrivateProfileString("BliceFax", "FirstPage", "1", grpfile);

    char section[60];
    for(int jj=0; jj<nNum; jj++)
    {
        wsprintf(section, "Page%d", jj+1);
        str = arName.GetAt(jj);
        if( str.IsEmpty() )
            continue;
        ptr = str.GetBuffer( str.GetLength()+1);
        WritePrivateProfileString(section, "Plane1", ptr, grpfile);

        nType = arType.GetAt(jj);
        ptr = MakeImageTypeText(nType);
        WritePrivateProfileString(section, "FileType", ptr, grpfile);

        nType = arStat.GetAt(jj);
        ptr = MakeFaxStatText(nType);
        WritePrivateProfileString(section, "Fstat", ptr, grpfile);
    }
    return TRUE;
}


BOOL CImgDoc::OnOpenDocument(const char *pszPathName)
{
    char ext[_MAX_EXT];
    ext[0] = 0;
    _splitpath(pszPathName, NULL, NULL, NULL, ext);
    BOOL bOk;
    char *pName = NULL;
    if( stricmp(ext, ".FAX") == 0 )
    {
        m_bGroup = TRUE;
        bOk = LoadFaxGroup(pszPathName);
        if(bOk)
        {
            CString str;
            str = arName.GetAt(0);
            int ln = str.GetLength();
            if(ln)
            {
                m_nFileFormat = arType.GetAt(0);
                pName = str.GetBuffer(ln+1);
                LoadImage(pName, 0);
            }
        }
    }
    else
    {
        m_bGroup = FALSE;
        ClearGroupInfo();
        LoadImage(pszPathName, 0);
    }
    if (!pszPathName ) {
        m_bGroup = TRUE;
    }
    if(m_hDib)
        AfxGetApp()->AddToRecentFileList(pszPathName);
    return (m_hDib) ? TRUE : FALSE;
}

/////////////////////////////////////////////////////////////////////////////
// Set palette from the dib. (This function must be called when an operation
// is changed the pallette of the DIB.)
//
void CImgDoc::UpdatePalette( void )
{
    if ( m_hDib ) {
        if ( m_palDib)                // Delete old palette
            delete m_palDib;
        m_palDib = new CPalette;    // Create new palette
        if ( m_palDib ) {
            // Get palette from DIB.
            if(!::CreateDIBPalette(m_hDib, m_palDib) ) {
                delete m_palDib;
                m_palDib = NULL;
            }
        }
    }
}



/////////////////////////////////////////////////////////////////////////////
// CImgDoc serialization
/////////////////////////////////////////////////////////////////////////////

void CImgDoc::Serialize(CArchive& ar)
{
    if ( ar.IsStoring() ) {
        // TODO: add storing code here
    }
    else {
        // TODO: add loading code here
    }
}

/////////////////////////////////////////////////////////////////////////////
// CImgDoc diagnostics
/////////////////////////////////////////////////////////////////////////////

#ifdef _DEBUG
void CImgDoc::AssertValid() const
{
    CDocument::AssertValid();
}

void CImgDoc::Dump(CDumpContext& dc) const
{
    CDocument::Dump(dc);
}

#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
//                      CImgDoc COMMANDS
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
// Perfoms dimension dialog box (see dialog.cpp).
/////////////////////////////////////////////////////////////////////////////
void CImgDoc::OnDimensions()
{
    // TODO: Add your command handler code here
    CDimension dimensionsDlg;

    dimensionsDlg.pDoc = this;
    dimensionsDlg.DoModal();
}

/////////////////////////////////////////////////////////////////////////////
//                         Image Paging Functions.
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
// Views next image of multi image TIFF file.
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
// Load the next image from the current file.
void CImgDoc::OnPageForward()
{
	if (nCurrent+1<nImages)
	LoadImage(NULL, (WORD)nCurrent+1);
}

//rz
void CImgDoc::GoPage(int PageNr)
{
    if((PageNr>=0) && (PageNr<nImages))
         {
	         LoadImage(NULL, (WORD)PageNr);
         }
}
/////////////////////////////////////////////////////////////////////////////
// Load the previous image from the current file.
void CImgDoc::OnUpdatePageForward(CCmdUI* pCmdUI)
{
    pCmdUI->Enable((nImages) > 1 && (nCurrent < nImages-1));
}

/////////////////////////////////////////////////////////////////////////////
// Views previous image of multi image TIFF file.
/////////////////////////////////////////////////////////////////////////////
void CImgDoc::OnPageBackwad()
{
	if (nCurrent-1>-1)
	LoadImage(NULL, (WORD)nCurrent-1);
}

void CImgDoc::OnUpdatePageBackwad(CCmdUI* pCmdUI)
{
    pCmdUI->Enable((nImages > 1) && (nCurrent > 0));
}

/////////////////////////////////////////////////////////////////////////////
//                      Clipborard Functions.
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
// Copy device independent bitmap to clipboard.
/////////////////////////////////////////////////////////////////////////////
void CImgDoc::OnEditCopy()
{
    HWND        hWnd;
    HDIB        hDupDib;

    hWnd = qryImgHwnd();

    if (m_hDib) {

        //
        // Duplicate device independent bitmap.
        //
        hDupDib = GlobalAlloc(GHND, GlobalSize(m_hDib));
        if(hDupDib) {
            LPVOID  lpszDib, lpszDupDib;

            lpszDib = GlobalLock(m_hDib);
            lpszDupDib = GlobalLock(hDupDib);

            if(lpszDib && lpszDupDib) {
                hmemcpy(lpszDupDib, lpszDib, GlobalSize(m_hDib));
                GlobalUnlock(hDupDib);
                GlobalUnlock(m_hDib);
            } else {
                GlobalUnlock(hDupDib);
                GlobalUnlock(m_hDib);
                GlobalFree(hDupDib);
                hDupDib = 0;
            }

            //
            // Copy to clipboard.
            //
            if(hDupDib && OpenClipboard(hWnd) && EmptyClipboard()) {
                SetClipboardData(CF_DIB, hDupDib);
                CloseClipboard();
            }
        }
    }
}

void CImgDoc::OnUpdateEditCopy(CCmdUI* pCmdUI)
{
    // TODO: Add your command update UI handler code here
    pCmdUI->Enable();
}

/////////////////////////////////////////////////////////////////////////////
// Paste device independent bitmap into a new document window.
/////////////////////////////////////////////////////////////////////////////
void CImgDoc::OnEditPaste()
{
         char FileName[20];
         wsprintf(FileName,"Untitled%d",((CImgApp *)AfxGetApp())->m_nrUntitled);
    AfxGetApp()->OpenDocumentFile(FileName);
         ++((CImgApp *)AfxGetApp())->m_nrUntitled;

}


void CImgDoc::OnUpdateEditPaste(CCmdUI* pCmdUI)
{
    pCmdUI->Enable(IsClipboardFormatAvailable(CF_DIB));
}

/////////////////////////////////////////////////////////////////////////////
// Clear clipboard.
/////////////////////////////////////////////////////////////////////////////
void CImgDoc::OnEditDelete()
{
    if ( OpenClipboard( qryImgHwnd() )  ) {
        EmptyClipboard();
        CloseClipboard();
    }
}

void CImgDoc::OnUpdateEditDelete(CCmdUI* pCmdUI)
{
    pCmdUI->Enable(m_hDib != 0);
}

/////////////////////////////////////////////////////////////////////////////
// Save file functions (File Save SaveAs commands.
/////////////////////////////////////////////////////////////////////////////
void CImgDoc::OnFileSave()
{
    if((strlen(szTiffFileName) >= strlen("Untitled")) &&
        !strcmp(szTiffFileName + (strlen(szTiffFileName) - strlen("Untitled")), "UNTITLED")) {
        //
        // The image was pasted.
        //
        OnFileSaveAs();
    } else
        SaveImage(NULL, 0);
}

void CImgDoc::OnFileSaveAs()
{
    CImgApp         *pApp = (CImgApp *)AfxGetApp();

    //
    // Get form file name.
    //
    CString         newName;
    int             l_nFileFormat;

    l_nFileFormat = pApp->MySaveFileName(newName, IDS_SAVEFILE, SaveFilterBuff,
          OFN_HIDEREADONLY, FALSE, &m_jpeg_qu);

	switch(l_nFileFormat){
	case 2: newName+=".bmp";break;
	case 3: newName+=".tif";break;
	case 4: newName+=".cal";break;
	case 5: newName+=".jpg";break;
	case 6: newName+=".tif";break;
	case 7: newName+=".tif";break;
	}
    if(l_nFileFormat)
        SaveImage(newName, l_nFileFormat);
    e_nFileFormat = l_nFileFormat;
}


void CImgDoc::OnUpdateFileSave(CCmdUI* pCmdUI)
{
    // TODO: Add your command update UI handler code here
    pCmdUI->Enable(m_hDib != 0);
}

void CImgDoc::OnUpdateFileSaveAs(CCmdUI* pCmdUI)
{
    pCmdUI->Enable(m_hDib != 0);
}


void CImgDoc::OnFaxSend()
{
    CDlgSendFax dlgFaxSend;

    dlgFaxSend.pDoc = this;
    dlgFaxSend.DoModal();
}

void CImgDoc::OnUpdateFaxSend(CCmdUI* pCmdUI)
{
    CImgApp         *pApp = (CImgApp *)AfxGetApp();
    BOOL bEnable = FALSE ;
    for(int i=0;i<MAX_FAXPORTS;i++){
        if (pApp->FaxPorts[i]){
            if (pApp->FaxPorts[i]->IsOpen()){
                bEnable = TRUE ;
                break ;
            }
        }
    }


//    pCmdUI->Enable( IsAnyPortOpen() ) ;
    pCmdUI->Enable( bEnable ) ;
}

CImgView *CImgDoc::qryImgView()
{
    POSITION pos = GetFirstViewPosition();
    CView *pw = GetNextView(pos);
    if(pw)
    {
        if( pw->IsKindOf(RUNTIME_CLASS(CImgView)) )
        {
            CImgView *pwi = (CImgView *)pw;
            return pwi;
        }
    }
    return NULL;
}

HWND CImgDoc::qryImgHwnd()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        return pwi->m_hWnd;
    return NULL;
}

void CImgDoc::OnFilePrint()
{
    int     nPageCnt ;
    GPRINT  sPrint;
    HDIB    hOldDib ;
    int     nCurPage ;
    RECT    rScale;

    SetRect(&rScale, 1, 1, 1, 1);
    hOldDib  = m_hDib ;
    nCurPage = nCurrent ;

    sPrint.bDisplay = TRUE;
    sPrint.bCenterVertImg = FALSE;
    sPrint.bCenterHorizImg = FALSE;
    sPrint.bScalePage = FALSE;
    sPrint.nNumCopies = 1;
    sPrint.bConvertCtoB = FALSE;
    sPrint.bStretchPage = TRUE;
    sPrint.bAllPage = TRUE ;
    sPrint.bUseDPI  = FALSE;

//    CImgApp *pApp     = (CImgApp *)AfxGetApp();
        HDC             hDC             = NULL;
//    HDC hdc = pApp->GetPrinterDC();

    if(! PrepareToPrint(AfxGetMainWnd()->m_hWnd, hDC, &sPrint,szTiffFileName,nImages)  ) {
        if(sPrint.bAllPage)
        {
            for(nPageCnt=0;nPageCnt< nImages; nPageCnt++)
            {
                LoadImage(szTiffFileName,(WORD) nPageCnt);
                if (!m_hDib)
                {
                    break ;
                }
                if( PrintDIBPage(m_hDib, NULL, &rScale,nPageCnt,0,0) )
                {
                    break ;
                }
            }
        }
        else
        {
            PrintDIBPage(m_hDib, NULL, &rScale,nCurPage,0,0)  ;
        }
    }

    EndPrint( hDC );

    if (sPrint.bAllPage)
    {
        LoadImage(szTiffFileName, (WORD)nCurPage) ;
    }
}

void CImgDoc::OnUpdateFilePrint(CCmdUI* pCmdUI)
{
    pCmdUI->Enable(m_hDib != 0);
}

void _loadds CImgDoc::OnCloseTWdoc()
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
//     AfxGetMainWnd()->EnableWindow(TRUE);
    AfxGetMainWnd()->SetFocus();
}

BOOL CImgDoc::IsAnyPortOpen()
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();

    TSPortStatus st;

    BOOL bOpen;

    for(int i=0;i<MAX_FAXPORTS;i++)
    {
        if (pApp->FaxPorts[i]==NULL)
        {
            continue;
        }

        bOpen = pApp->FaxPorts[i]->IsOpen();
        GetPortStatus(pApp->FaxPorts[i], &st);

        if(bOpen && st.Status==CST_NOTHING)
        {
            return TRUE;
        }
    }
    return FALSE ;
}

    /* imgvw */

void CImgDoc::OnShowDpi()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnShowDpi();
}
/**
void CImgDoc::OnShowPix()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnShowPix();
}
**/
void CImgDoc::OnFitowindow()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnFitowindow();
}
void CImgDoc::OnCenterimage()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnCenterimage();
}
void CImgDoc::OnZoomIn()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnZoomIn();
}
void CImgDoc::OnZoomOut()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnZoomOut();
}
void CImgDoc::OnZoomMode()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnZoomMode();
}
void CImgDoc::OnCustomZoom()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnCustomZoom();
}
void CImgDoc::OnZoomSteps()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnZoomSteps();
}
void CImgDoc::OnMagnify()
{
    CImgView *pwi = qryImgView();
    if(pwi)
    {
        pwi->SetFocus();
        pwi->OnMagnify();
    }
}

void CImgDoc::OnViewColorToGray()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnViewColorToGray();
}
void CImgDoc::OnImageConvTo24()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnImageConvTo24();
}

void CImgDoc::OnFlipHorizontal()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnFlipHorizontal();
}
void CImgDoc::OnFlipVertical()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnFlipVertical();
}
void CImgDoc::OnViewInvert()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnViewInvert();
}
void CImgDoc::OnRotate90()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnRotate90();
}
void CImgDoc::OnRotate180()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnRotate180();
}
void CImgDoc::OnRotate270()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnRotate270();
}
void CImgDoc::OnViewRotate()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnViewRotate();
}
void CImgDoc::OnViewScale()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnViewScale();
}
void CImgDoc::OnViewSkew()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnViewSkew();
}

void CImgDoc::OnHalftone()
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnHalftone();
}

void CImgDoc::OnUpdateShowDpi(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateShowDpi(pCmdUI);
}
/**
void CImgDoc::OnUpdateShowPix(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateShowPix(pCmdUI);
}
**/
void CImgDoc::OnUpdateCenterimage(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateCenterimage(pCmdUI);
}
void CImgDoc::OnUpdateFitowindow(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateFitowindow(pCmdUI);
}
void CImgDoc::OnUpdateZoomIn(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateZoomIn(pCmdUI);
}
void CImgDoc::OnUpdateZoomOut(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateZoomOut(pCmdUI);
}
void CImgDoc::OnUpdateZoomMode(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateZoomMode(pCmdUI);
}

void CImgDoc::OnUpdateRotate90(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateRotate90(pCmdUI);
}
void CImgDoc::OnUpdateRotate270(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateRotate270(pCmdUI);
}
void CImgDoc::OnUpdateRotate180(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateRotate180(pCmdUI);
}
void CImgDoc::OnUpdateViewRotate(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateViewRotate(pCmdUI);
}
void CImgDoc::OnUpdateFlipHorizontal(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateFlipHorizontal(pCmdUI);
}
void CImgDoc::OnUpdateFlipVertical(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateFlipVertical(pCmdUI);
}
void CImgDoc::OnUpdateViewInvert(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateViewInvert(pCmdUI);
}

void CImgDoc::OnUpdateViewSkew(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateViewSkew(pCmdUI);
}
void CImgDoc::OnUpdateViewScale(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateViewScale(pCmdUI);
}
void CImgDoc::OnUpdateViewColorToGray(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateViewColorToGray(pCmdUI);
}
void CImgDoc::OnUpdateImageConvTo24(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateImageConvTo24(pCmdUI);
}
void CImgDoc::OnUpdateHalftone(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateHalftone(pCmdUI);
}
void CImgDoc::OnUpdateMagnify(CCmdUI* pCmdUI)
{
    CImgView *pwi = qryImgView();
    if(pwi)
        pwi->OnUpdateMagnify(pCmdUI);
}
void  CImgDoc::SetActiveDoc()
{
    POSITION pos= GetFirstViewPosition();
    CView *View= (CView *)GetNextView(pos);
    ((CMDIChildWnd*)(View->GetParent()))->MDIActivate();
    OpenIcon(((CMDIChildWnd*)(View->GetParent()))->m_hWnd) ;
}

BOOL CImgDoc::SaveModified()
{
    int nAnswer = IDNO;

    if ( bChanged ) {
        nAnswer = AfxMessageBox(IDS_CLOSEDOCUMENT, MB_ICONEXCLAMATION|MB_YESNOCANCEL);
        if ( nAnswer == IDCANCEL )
            return FALSE;
        if ( nAnswer == IDYES )
            OnFileSaveAs();
    }
/*    if ( nAnswer != IDCANCEL ) {
        for ( i=0 ; i<10 ; i++ ) {
            if ( m_hDibPages[i] ) {
                GlobalFree( (HGLOBAL)m_hDibPages[i] );
                m_hDibPages[i] = NULL;
            }
        }
        if ( m_palDib )
            delete m_palDib;
    }*/
    return TRUE;
}

void  _loadds CImgDoc::OnDone(HANDLE hDIB,LPCSTR lpFileName)
{
    BOOL                bSuccess, bOk;
    LPBITMAPINFOHEADER  lpBmi     ;
    lpBmi = (LPBITMAPINFOHEADER) GlobalLock(hDIB) ;
    LPSTR lpTmp ;
    char   szBuffer[256] ;
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    CDocTemplate* pTemplate = GetDocTemplate();
    CString str;

    bOk = pTemplate->GetDocString( str, CDocTemplate::docName );
    if ( bOk ) {
        if ( str == CString("Img") ) {
            ((CMainFrame*)(pApp->m_pMainWnd))->m_hScanDIB = hDIB;
            pTemplate->OpenDocumentFile(NULL);
        }
        else if ( str == CString("FAX") ) {
#ifdef WIN32
            GetTempFileName( pApp->szAppPath, "SCAN", 0, szBuffer );
#else
            GetTempFileName( pApp->szAppPath[0], "SCAN", 0, szBuffer );
#endif
            lpTmp = strrchr(szBuffer,'.') ;
            if ( lpTmp )
                strcpy(lpTmp,".tif");
            bSuccess = SaveDIBInTiffFormat(szBuffer, hDIB, 0, TRUE);
            if (bSuccess) {
                POSITION pos = GetFirstViewPosition();
                CView* pView = GetNextView( pos );
                while (pView) {
                    if (pView->IsKindOf(RUNTIME_CLASS(CInputView))){
                        CString fName(szBuffer) ;
                        CInputView * pInputView = (CInputView * )pView ;
                        pInputView->AddFile(fName,FORMAT_TIFF);
                        pView = NULL ; // End of loop
                    } else {
                        pView = GetNextView( pos );
                    }
                }
            }
            lpFileName = lpFileName;
            GlobalUnlock(hDIB);
            GlobalFree(hDIB);
        }
    }
}

void CImgDoc::InvalidateRect( LPRECT lpr, BOOL b )
{
    POSITION pos = GetFirstViewPosition();
    CView* pFirstView;
    while( (pFirstView = GetNextView( pos )) != NULL )
        pFirstView->InvalidateRect( lpr, b );
}


