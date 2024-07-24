/* vmdmdoc.cpp : implementation of the CFaxDisplayView class  */
#include "stdafx.h"

#include "winflags.h"
#include <afxext.h>

#include "Voice Mail Sample.h"
#include "mainfrm.h"
#include "faxdoc.h"
#include "faxdocvw.h"
extern "C"
{
#include "bitiff.h"
}
#include "dibpal.h"

#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif

#define SetClassCursor(hWnd, value)  SetClassLong(hWnd, GCL_HCURSOR, (DWORD)value)
#define WM_DOREALIZE    (WM_USER+0)

/////////////////////////////////////////////////////////////////////////////
// CFaxDisplayView

IMPLEMENT_DYNCREATE(CFaxDisplayView, CView)

BEGIN_MESSAGE_MAP(CFaxDisplayView, CView)
    //{{AFX_MSG_MAP(CFaxDisplayView)
    ON_WM_HSCROLL()
    ON_WM_VSCROLL()
    ON_WM_SIZE()
    ON_COMMAND(IDM_SCALE_DPI, OnScaleDPI)
    ON_COMMAND(IDM_FITOWINDOW, OnFitowindow)
    ON_COMMAND(IDM_CENTERIMAGE, OnCenterimage)
    ON_UPDATE_COMMAND_UI(IDM_CENTERIMAGE, OnUpdateCenterimage)
    ON_UPDATE_COMMAND_UI(IDM_SCALE_DPI, OnUpdateScaleDPI)
    ON_WM_SETFOCUS()
    ON_WM_KILLFOCUS()
    ON_WM_LBUTTONDOWN()
    ON_MESSAGE(WM_DOREALIZE, OnDoRealize)
    ON_WM_PAINT()
    ON_WM_LBUTTONUP()
    ON_WM_MOUSEMOVE()
    ON_WM_RBUTTONDOWN()
    ON_WM_RBUTTONUP()
    ON_COMMAND(IDM_DISP_NORMAL, OnDispNormal)
    ON_UPDATE_COMMAND_UI(IDM_DISP_NORMAL, OnUpdateDispNormal)
    ON_WM_CREATE()
    ON_WM_DESTROY()
	ON_WM_KEYUP()
	ON_WM_KEYDOWN()
	ON_WM_CHAR()
	//}}AFX_MSG_MAP
    // Standard printing commands
//  ON_WM_PALETTECHANGED()
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CFaxDisplayView construction/destruction

CFaxDisplayView::CFaxDisplayView()
{
    // TODO: add construction code here
    m_bMapping  = FALSE;
    m_bDownM = FALSE;
    mScale.top    = 10 ;
    mScale.left   = 30 ;
    mScale.bottom = 10 ;
    mScale.right  = 30 ;
}

CFaxDisplayView::~CFaxDisplayView()
{
}

BOOL CFaxDisplayView::Create( LPCSTR lpszClassName, LPCSTR lpszWindowName, DWORD dwStyle, const RECT& rect, CWnd* 
        pParentWnd, UINT nID, CCreateContext* pContext )
{
    if( CWnd::Create(lpszClassName,lpszWindowName,dwStyle|WS_CLIPCHILDREN,rect,pParentWnd,nID,pContext) )
	{
		SetClassCursor(m_hWnd, NULL);
		SetCursor( LoadCursor(NULL,IDC_ARROW) );

		return TRUE;
	}
	return FALSE;
}       

/////////////////////////////////////////////////////////////////////////////
// CFaxDisplayView drawing

#define RECTWIDTH(lpRect)     ((lpRect)->right - (lpRect)->left)
#define RECTHEIGHT(lpRect)    ((lpRect)->bottom - (lpRect)->top)

void CFaxDisplayView::OnDraw(CDC* pDC)
{
    CFaxDisplayDoc* pDoc = GetDocument();
    pDC = pDC;

}

void CFaxDisplayView::OnPaint()
{
//  CPaintDC dc(this); // device context for painting
    
    // TODO: Add your message handler code here
    CFaxDisplayDoc* pDoc = GetDocument();
    
    if(pDoc->hDib==NULL) 
        return;

    CPaintDC dc(this); // device context for painting
    DisplayDIBImageDC(dc.m_hDC, &pDoc->sDisplay);
    MapDisplayDC(dc.m_hDC, &pDoc->sDisplay);
}

/////////////////////////////////////////////////////////////////////////////
// CFaxDisplayView printing

/////////////////////////////////////////////////////////////////////////////
// CFaxDisplayView diagnostics

#ifdef _DEBUG
void CFaxDisplayView::AssertValid() const
{
    CView::AssertValid();
}

void CFaxDisplayView::Dump(CDumpContext& dc) const
{
    CView::Dump(dc);
}

CFaxDisplayDoc* CFaxDisplayView::GetDocument() // non-debug version is inline
{
    ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CFaxDisplayDoc)));
    return (CFaxDisplayDoc*) m_pDocument;
}

#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CFaxDisplayView message handlers

void CFaxDisplayView::EnableView(CCmdUI* pCmdUI)
{
    CFaxDisplayDoc   *pDoc = GetDocument();
    
    pCmdUI->Enable((pDoc && pDoc->hDib) ? TRUE : FALSE);
}

BOOL CFaxDisplayView::SetNewDib(HDIB hDib, BOOL bSaveScroll)
{
    CFaxDisplayDoc   *pDoc = GetDocument();
    
    if(!hDib)
        return FALSE;
    if(pDoc) {
        RECT        rOrigin;
    
        rOrigin.left = rOrigin.right = rOrigin.top = rOrigin.bottom = 0;
        if(pDoc->hDib)
            GlobalFree(pDoc->hDib);
        pDoc->hDib = hDib;
        LPBITMAPINFOHEADER lpBmi = (LPBITMAPINFOHEADER)GlobalLock(hDib);

        if(lpBmi) 
		{
            pDoc->wHorizontalDPI = (UINT)((float)(lpBmi->biXPelsPerMeter)/ 39.37);
            pDoc->wVerticalDPI = (UINT)((float)(lpBmi->biYPelsPerMeter)/ 39.37);
            pDoc->wPlanes = lpBmi->biPlanes;
            pDoc->wBits = lpBmi->biBitCount;
            pDoc->dwWidth = lpBmi->biWidth;
            pDoc->dwHeight = lpBmi->biHeight;
            GlobalUnlock(hDib); 
        }
        pDoc->bChanged = TRUE;
        if(bSaveScroll) 
		{
            CopyRect(&rOrigin, &pDoc->sDisplay.rOrigo); 
		}
        DisplayDIBStart(m_hWnd, pDoc->hDib, &rOrigin, &pDoc->rScale,
                    pDoc->wDisplayMode | DISP_NEWDIB,
                    &pDoc->sDisplay);
                        
        return  TRUE;
    }
    return  FALSE; 
}

void CFaxDisplayView::AfterLoadImage()
{
    CFaxDisplayDoc *pDoc = GetDocument();
}

/////////////////////////////////////////////////////////////////////////////////
// Paint functions. 
/////////////////////////////////////////////////////////////////////////////////

LRESULT CFaxDisplayView::OnDoRealize(WPARAM wParam, LPARAM)
{
    CFaxDisplayDoc   *pDoc = GetDocument();
    
    if (pDoc->hDib ) 
    {
        if(pDoc->m_hPalette) 
        {
            CMainFrame* pAppFrame = (CMainFrame*) AfxGetApp()->m_pMainWnd;
            CClientDC appDC(pAppFrame);
            // All views but one should be a background palette.
            // wParam contains a handle to the active view, so the SelectPalette
            // bForceBackground flag is FALSE only if wParam == m_hWnd (this view)
            CPalette* oldPalette = appDC.SelectPalette(pDoc->m_hPalette, ((HWND)wParam) != m_hWnd);

            if (oldPalette != NULL) 
            {
                UINT nColorsChanged = appDC.RealizePalette();

                if (nColorsChanged > 0)
                    pDoc->UpdateAllViews(NULL);
                appDC.SelectPalette(oldPalette, TRUE);
            }
        }       
    }    
    return 0L;
}

void CFaxDisplayView::OnActivateView(BOOL bActivate, CView* pActivateView,
                    CView* pDeactiveView)
{
    CView::OnActivateView(bActivate, pActivateView, pDeactiveView);

    if (bActivate)
        OnDoRealize((WPARAM)m_hWnd, 0);   // same as SendMessage(WM_DOREALIZE);
}

void CFaxDisplayView::OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar)
{
    // TODO: Add your message handler code here and/or call default
    
    CFaxDisplayDoc   *pDoc = GetDocument();
    
    if(pDoc->hDib) 
    {
        DisplayWmHorzScroll(m_hWnd, MAKELPARAM(nSBCode,nPos), 0, &pDoc->sDisplay);
    } 

    pScrollBar = pScrollBar;
}       

void CFaxDisplayView::SetNewScreenPos() 
{
    CFaxDisplayDoc   *pDoc = GetDocument();
    int xPos = pDoc->m_zc.pScrollPos.x;
    int yPos = pDoc->m_zc.pScrollPos.y;
    if(xPos < 0)
        xPos = 0;
    if(xPos > (int)pDoc->dwWidth)
        xPos = (int)pDoc->dwWidth;
    if(yPos < 0)
        yPos = 0;
    if(yPos > (int)pDoc->dwHeight)
        yPos = (int)pDoc->dwHeight;
    if(pDoc->m_zc.bScrollExist & 1)        
        ShowScrollBar(SB_HORZ, TRUE);      
    if(pDoc->m_zc.bScrollExist & 2)        
        ShowScrollBar(SB_VERT, TRUE);      
    SetScrollPos(SB_HORZ, xPos, TRUE);
    SetScrollPos(SB_VERT, yPos, TRUE);
    return; 
}
    

void CFaxDisplayView::OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar)
{
    // TODO: Add your message handler code here and/or call default
    CFaxDisplayDoc   *pDoc = GetDocument();
    
    if(pDoc->hDib) 
    {
        DisplayWmVertScroll(m_hWnd, MAKELPARAM(nSBCode,nPos), 0, &pDoc->sDisplay);
    } 

    pScrollBar = pScrollBar;
}

void CFaxDisplayView::OnSize(UINT nType, int cx, int cy)
{
    CView::OnSize(nType, cx, cy);
    
    // TODO: Add your message handler code here
    CFaxDisplayDoc   *pDoc = GetDocument();
    
    if(pDoc->hDib) 
        DisplayWmSize(m_hWnd, nType, MAKELPARAM(cx, cy), &pDoc->sDisplay);
}

/////////////////////////////////////////////////////////////////////////////////////
// View bitmap functions. (View  Show Normal, Fit To Window, Center Image commands)
/////////////////////////////////////////////////////////////////////////////////////
void CFaxDisplayView::OnScaleDPI()
{
    // TODO: Add your command handler code here

CFaxDisplayDoc   *pDoc = GetDocument();

    pDoc->wDisplayMode &= ~(DISP_PREVIEW | DISP_NORMAL);
    pDoc->wDisplayMode |= DISP_SCALED;
    
    if(pDoc->hDib)
        DisplayDIBStart(m_hWnd, pDoc->hDib, &pDoc->sDisplay.rOrigo, &pDoc->rScale, 
                        pDoc->wDisplayMode, &pDoc->sDisplay);
    SetNewTitle();
}

void CFaxDisplayView::StartNewDib()
{
    CFaxDisplayDoc   *pDoc = GetDocument();
    DisplayDIBStart(m_hWnd, pDoc->hDib, &pDoc->sDisplay.rOrigo, &pDoc->rScale, 
                    pDoc->wDisplayMode, &pDoc->sDisplay);
}

void CFaxDisplayView::OnUpdateScaleDPI(CCmdUI* pCmdUI)
{
    // TODO: Add your command update UI handler code here
    
    CFaxDisplayDoc   *pDoc = GetDocument();

    pCmdUI->Enable(!(pDoc == NULL));
    if(pDoc)
        pCmdUI->SetCheck((pDoc->wDisplayMode & DISP_SCALED) ? TRUE : FALSE);
}

void CFaxDisplayView::OnDispNormal()
{
    // TODO: Add your command handler code here
    CFaxDisplayDoc   *pDoc = GetDocument();

    pDoc->wDisplayMode &= ~(DISP_PREVIEW | DISP_SCALED);
    pDoc->wDisplayMode |= DISP_NORMAL;
    
    if(pDoc->hDib)
    {
        DisplayDIBStart(m_hWnd, pDoc->hDib, &pDoc->sDisplay.rOrigo, &pDoc->rScale, 
                        pDoc->wDisplayMode, &pDoc->sDisplay);
    }    
    SetNewTitle();        
}

void CFaxDisplayView::OnUpdateDispNormal(CCmdUI* pCmdUI)
{
    // TODO: Add your command update UI handler code here
    CFaxDisplayDoc   *pDoc = GetDocument();
    pCmdUI->Enable(TRUE);
    
    if(pDoc)
        pCmdUI->SetCheck((pDoc->wDisplayMode & DISP_NORMAL) ? TRUE : FALSE);
    
}

void CFaxDisplayView::OnFitowindow()
{
    // TODO: Add your command handler code here
    
    CFaxDisplayDoc   *pDoc = GetDocument();
    RECT        rOrigin;

    rOrigin.left = rOrigin.right = rOrigin.top = rOrigin.bottom = 0;
    pDoc->wDisplayMode &= ~(DISP_SCALED | DISP_NORMAL);
    pDoc->wDisplayMode |= DISP_PREVIEW;
    
    if(pDoc->hDib)
    {
        DisplayDIBStart(m_hWnd, pDoc->hDib, &rOrigin, &pDoc->rScale, pDoc->wDisplayMode, &pDoc->sDisplay);
    }
    SetNewTitle();
}

/*void CFaxDisplayView::OnUpdateFitowindow(CCmdUI* pCmdUI)
{
    // TODO: Add your command update UI handler code here
    
    CFaxDisplayDoc   *pDoc = GetDocument();

    pCmdUI->Enable(!(pDoc == NULL));
    if(pDoc)
        pCmdUI->SetCheck((pDoc->wDisplayMode & DISP_PREVIEW) ? TRUE : FALSE);
} 
*/

void CFaxDisplayView::OnCenterimage()
{
    // TODO: Add your command handler code here
    
CFaxDisplayDoc   *pDoc = GetDocument();

    pDoc->wDisplayMode ^= DISP_CENTER;
    
    if(pDoc->hDib)
    {
        DisplayDIBStart(m_hWnd, pDoc->hDib, &pDoc->sDisplay.rOrigo, &pDoc->rScale, 
                        pDoc->wDisplayMode, &pDoc->sDisplay);
    }
    SetNewTitle();
}

void CFaxDisplayView::OnUpdateCenterimage(CCmdUI* pCmdUI)
{
    // TODO: Add your command update UI handler code here
    CFaxDisplayDoc   *pDoc = GetDocument();

    pCmdUI->Enable(!(pDoc == NULL));
    if(pDoc)
        pCmdUI->SetCheck((pDoc->wDisplayMode & DISP_CENTER) ? TRUE : FALSE);
}

/////////////////////////////////////////////////////////////////////////////////
// Bitmap manipulation functions. (Rotate, Flip commands)
/////////////////////////////////////////////////////////////////////////////////

static HDIB RotateDIBxx(HDIB hDibIn, int deg) 
{
    HDIB hDibOut = NULL;
    switch(deg) {
        case 90:
            hDibOut = RotateDIB90(hDibIn);
            break;
        case 180:
            hDibOut = RotateDIB180(hDibIn);
            break;
        case 270:
            hDibOut = RotateDIB270(hDibIn);
            break;
    }   /* switch */
    return hDibOut; 
}    

//IZ4!!!
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


typedef BOOL (CALLBACK FAR *FNBITMANI)(HBITMAP hBitmap);

static HDIB ThroughBitmap(HDIB hDibIn, FNBITMANI fn) {
    HDIB hDibOut = NULL;
    BOOL hh;
    HBITMAP hBitmap = ConvertDIBToBitmap(hDibIn);
    if(hBitmap==NULL)
        return NULL;
    hh = fn(hBitmap);
    if(hh==FALSE) {
        DeleteObject(hBitmap);
        return NULL; }
    // HPALETTE hPal = CreateDIBPalette(hDibIn);
    hDibOut = ConvertBitmapToDIB(hBitmap, NULL); 
    CopyDibDPI(hDibOut, hDibIn);
    DeleteObject(hBitmap);
    // if(hPal)
    //    DeleteObject(hPal);
    return hDibOut; 
}
    
/////////////////////////////////////////////////////////////////////////////////
// Status bar functions
/////////////////////////////////////////////////////////////////////////////////
//
// Update status bar when chils is changed.
//
void CFaxDisplayView::OnSetFocus(CWnd* pOldWnd)
{
    CView::OnSetFocus(pOldWnd);
}

//
// Clear the status window when child is cahnged.
//
void CFaxDisplayView::OnKillFocus(CWnd* pNewWnd)
{
    CView::OnKillFocus(pNewWnd);
}

//
// Add note to the current position.
//      
void CFaxDisplayView::SetNewTitle() {
    CFaxDisplayDoc   *pDoc = GetDocument();
    char buf[200];
    char pp[60];
    int jj, ii;
    LPSTR str = "????";
    LPSTR str2 = NULL;
    BOOL bSc = FALSE;
    buf[0] = 0;
    lstrcpy(buf, pDoc->GetTitle());
    for(jj=0; jj<sizeof(buf); jj++) {
        if(buf[jj]==0)
            break;
        if(buf[jj]=='|') {
            buf[jj]=0;
            break; }
    }   /* for */
    for(jj--; jj>0; jj--) {
        if(buf[jj]!=0x20)
            break;
        buf[jj] = 0; }    
    pp[0] = 0;
    
    if(pDoc->wDisplayMode & DISP_NORMAL) 
    {
        str = "Normal";
        bSc = TRUE; 
    }
    else if(pDoc->wDisplayMode & DISP_SCALED) 
    {
        str = "Scale";            
        bSc = TRUE; 
    }
    else if(pDoc->wDisplayMode & DISP_PREVIEW)
    {
        str = "PreView";            
    }
    else if(pDoc->wDisplayMode & DISP_FITSCREEN)
    {
        str = "FitScreen";            
    }
    if(pDoc->wDisplayMode & DISP_CENTER) 
    {
        str2 = "Center";
    }

    ii = wsprintf(pp, " | %s", str);        
    if(str2)
        ii += wsprintf(&pp[ii], " %s", str2);        
    if(bSc)        
        ii += wsprintf(&pp[ii], " %i:%i", pDoc->rScale.left, pDoc->rScale.top);        
    lstrcat(buf, pp);
    pDoc->SetTitle(buf);    
    return;
}

void CScrollConvert::OrigoToScroll(HWND hWnd, LPPOINT pOrigoBMP, LPRECT lprScroll) {
    POINT pClientBMP;
    RECT rc;
    long dx, dy, ltmp;
    
    SetRect(lprScroll, 0, 0, 0, 0);
    
    if(pScrollRange.x < 0 || pScrollRange.y < 0)
        return;
        
    GetClientRect(hWnd, &rc);
    pClientBMP.x = DC_TO_BMP(rc.right,  X_DCPerBitmap);            
    pClientBMP.y = DC_TO_BMP(rc.bottom, Y_DCPerBitmap);            
    
    dx = (long)(pSizeBitmap.x - pClientBMP.x);
    dy = (long)(pSizeBitmap.y - pClientBMP.y);
    if(dx > 0) {
        ltmp =  ((long)pScrollRange.x * (long)pOrigoBMP->x) / dx;
        lprScroll->right = (int)ltmp;  }
    if(dy > 0) {
        ltmp =  ((long)pScrollRange.y * (long)pOrigoBMP->y) / dy;
        lprScroll->bottom = (int)ltmp; }
        
    if(lprScroll->right < 0)
        lprScroll->right = 0;        
    if(lprScroll->right > pScrollRange.x)
        lprScroll->right = pScrollRange.x;        
        
    if(lprScroll->bottom < 0)
        lprScroll->bottom = 0;        
    if(lprScroll->bottom > pScrollRange.y)
        lprScroll->bottom = pScrollRange.y;        
        
    return;
}        

int CFaxDisplayView::OnCreate(LPCREATESTRUCT lpCreateStruct)
{

    if (CView::OnCreate(lpCreateStruct) == -1)
        return -1;

    CFaxDisplayDoc* pDoc = GetDocument();
    DisplayWmCreate(m_hWnd,0,0,&pDoc->sDisplay);
    
    return 0;
}

void CFaxDisplayView::OnDestroy()
{
    CView::OnDestroy();
    CFaxDisplayDoc* pDoc = GetDocument();
    DisplayWmDestroy(m_hWnd,0,0,&pDoc->sDisplay);
}

//IZ@@@----------------------------------

void CFaxDisplayView::KillFitToWindow()
{
    CFaxDisplayDoc   *pDoc = GetDocument();
    if(pDoc)
    {
        if(pDoc->wDisplayMode & DISP_PREVIEW)    
        {
            pDoc->wDisplayMode |= DISP_NORMAL;    
            pDoc->wDisplayMode &= ~DISP_PREVIEW;    
        }   
        pDoc->sDisplay.wDisplayFormat = pDoc->wDisplayMode;
    }   
}               

