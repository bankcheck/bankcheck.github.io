// imgvw.cpp : implementation of the CImgView class
//

#include "stdafx.h"
#include <afxext.h>


extern "C" {
	#include "bidib.h"
	#include "bidisp.h"
};

#pragma warning(disable:4103)

#include "faxcpp.h"

#include "resource.h"
#include "bitiff.h"
#include "imgdoc.h"
#include "dialogs.h"
#include "faxdlg.h"
#include "demo.h"
#include "mainfrm.h"

#include "magnifyw.h"
#include "disp.h"
#include "imgvw.h"

#pragma warning(disable:4001 4699 4135)


#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif

#ifdef WIN32
#define SetClassCursor(hWnd, value)  SetClassLong(hWnd, GCL_HCURSOR, (DWORD)value)
#else
#define SetClassCursor(hWnd, value)  SetClassWord(hWnd, GCW_HCURSOR, (WORD)value)
#endif

/////////////////////////////////////////////////////////////////////////////
// CImgView

IMPLEMENT_DYNCREATE(CImgView, CDisp)

BEGIN_MESSAGE_MAP(CImgView, CDisp)
    //{{AFX_MSG_MAP(CImgView)
    ON_WM_CREATE()
    ON_MESSAGE(WM_DOREALIZE, OnDoRealize)
    ON_WM_PAINT()
    ON_WM_HSCROLL()
    ON_WM_VSCROLL()
    ON_WM_SETFOCUS()
    ON_WM_KILLFOCUS()
    ON_WM_SIZE()
    ON_WM_LBUTTONDOWN()
    ON_WM_LBUTTONDBLCLK()
    ON_WM_LBUTTONUP()
    ON_WM_MOUSEMOVE()
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
    ON_WM_DESTROY()
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
    ON_WM_RBUTTONDOWN()
    ON_WM_RBUTTONUP()
    ON_UPDATE_COMMAND_UI(IDM_ZOOM_MODE, OnUpdateZoomMode)
    ON_UPDATE_COMMAND_UI(IDM_HALFTONE, OnUpdateHalftone)
    ON_UPDATE_COMMAND_UI(IDM_MAGNIFY, OnUpdateMagnify)
    ON_WM_KEYUP()
    ON_WM_KEYDOWN()
    ON_WM_CHAR()
        ON_WM_ERASEBKGND()
	ON_COMMAND(IDM_FITTOWIDTH, OnFittowidth)
	ON_UPDATE_COMMAND_UI(IDM_FITTOWIDTH, OnUpdateFittowidth)
	//}}AFX_MSG_MAP
    // Standard printing commands

END_MESSAGE_MAP()

BOOL FAR PASCAL IsGrayDIB(HANDLE hDibPar)
{
    BOOL            bRval = TRUE;
    LPBITMAPINFO    lpBmi;

    if(hDibPar) {
        lpBmi = (LPBITMAPINFO)GlobalLock(hDibPar);
        if(lpBmi) {
            if(lpBmi->bmiHeader.biSize == sizeof(BITMAPINFOHEADER)) {
                UINT    nColors;

                if(lpBmi->bmiHeader.biClrUsed != 0) {
                    for(nColors = 0; nColors < lpBmi->bmiHeader.biClrUsed; nColors++) {
                        if(lpBmi->bmiColors[nColors].rgbBlue != lpBmi->bmiColors[nColors].rgbGreen ||
                            lpBmi->bmiColors[nColors].rgbBlue != lpBmi->bmiColors[nColors].rgbRed)
                            bRval = FALSE;
                    }
                } else
                    bRval = FALSE;
            }
            GlobalUnlock(hDibPar);
        }
    }
    return  bRval;
}

// CImgView construction/destruction

CImgView::CImgView()
{

    bNoHourGlass = FALSE;
    bShowDPI = TRUE;
    bFitToWindow = FALSE;
         bFitToWidth  = FALSE;
         bFirstPaint=TRUE;
         bSizing=FALSE;
}

CImgView::~CImgView()
{
}

// CImgView diagnostics

#ifdef _DEBUG
void CImgView::AssertValid() const
{
    CView::AssertValid();
}

void CImgView::Dump(CDumpContext& dc) const
{
    CView::Dump(dc);
}

CImgDoc* CImgView::GetDocument() // non-debug version is inline
{
//    ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CImgDoc)));
    return (CImgDoc*) m_pDocument;
}

#endif //_DEBUG

BOOL CImgView::Create( LPCSTR lpszClassName, LPCSTR lpszWindowName, DWORD dwStyle, const RECT& rect, CWnd*
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

int CImgView::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
    if (CView::OnCreate(lpCreateStruct) == -1)
        return -1;

    d_DispCreate();
    return 0;
}

void CImgView::OnDestroy()
{
    CView::OnDestroy();
    d_DispDestroy();
}

void CImgView::OnPaint()
{
    CImgDoc * pDoc = (CImgDoc *)GetDocument();
    CPaintDC dc(this); // device context for painting

    d_SetHeight(pDoc->dwHeight);
	d_SetWidth(pDoc->dwWidth);
	d_DispDIBImageDC(&dc);
};

//      Status bar

void CImgView::OnSetFocus(CWnd* pOldWnd)
{
    CView::OnSetFocus(pOldWnd);

    // TODO: Add your message handler code here
    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
        return;

    CStatusBar  *pCStatusBar = GetGlobalStatusBar();
    char        String[20];

    wsprintf(String, "%d", pDoc->nCurrent+1);
    pCStatusBar->SetPaneText(pCStatusBar->CommandToIndex(ID_INDICATOR_IMAGENO),String, TRUE);
    wsprintf(String, "%d", pDoc->nImages);
    pCStatusBar->SetPaneText(pCStatusBar->CommandToIndex(ID_INDICATOR_IMAGETOTAL), String, TRUE);
	
	CString cszFileName = pDoc->szTiffFileName;
	
	if (cszFileName.Find('.')!=-1){
        if(pDoc->nImages > 1) {
            cszFileName += ":";
			wsprintf(String, "%d", pDoc->nCurrent+1);
            cszFileName += String;
	}
	pDoc->SetTitle(cszFileName);
	}

}

void CImgView::OnKillFocus(CWnd* pNewWnd)
{
    CView::OnKillFocus(pNewWnd);
    CStatusBar  *pCStatusBar = GetGlobalStatusBar();

    // TODO: Add your message handler code here
    pCStatusBar->SetPaneText(pCStatusBar->CommandToIndex(ID_INDICATOR_IMAGENO),"", TRUE);
    pCStatusBar->SetPaneText(pCStatusBar->CommandToIndex(ID_INDICATOR_IMAGETOTAL), "", TRUE);
}

// CImgView printing

BOOL CImgView::OnPreparePrinting(CPrintInfo* pInfo)
{
    return DoPreparePrinting(pInfo);
}

void CImgView::OnBeginPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
}

void CImgView::OnEndPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
}

void CImgView::EnableView(CCmdUI* pCmdUI)
{
    CImgDoc *pDoc = GetDocument();
    if(pDoc && pDoc->wBits!=24)
        pCmdUI->Enable( pDoc->m_hDib ? TRUE : FALSE );
    else
        pCmdUI->Enable( FALSE );
}

//  Display
void CImgView::wClearDib(BOOL bDeleteDib)
{
    d_ClearDib(bDeleteDib);
}

void CImgView::SetNewDib(HDIB hDibPar)
{
    if(hDibPar==NULL)
        return;
    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
        return;
    d_SetNewDib(hDibPar);
    LPBITMAPINFOHEADER  lpBmi = (LPBITMAPINFOHEADER)GlobalLock(hDibPar);
    if(lpBmi)
    {
        pDoc->wHorizontalDPI = (WORD)((float)(lpBmi->biXPelsPerMeter)/ 39.37);
        pDoc->wVerticalDPI = (WORD)((float)(lpBmi->biYPelsPerMeter)/ 39.37);
        pDoc->wPlanes = lpBmi->biPlanes;
        pDoc->wBits = lpBmi->biBitCount;

        pDoc->wDepth = (WORD)pDoc->wPlanes * pDoc->wBits;

        pDoc->dwWidth = lpBmi->biWidth;
        pDoc->dwHeight = lpBmi->biHeight;

        GlobalUnlock(hDibPar);
    }
}

void CImgView::OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar)
{
    d_HorzScroll(nSBCode, nPos);

    pScrollBar = pScrollBar;
    CImgDoc   *pDoc = GetDocument();
}

void CImgView::OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar)
{
    d_VertScroll(nSBCode, nPos);

    pScrollBar = pScrollBar;
    CImgDoc   *pDoc = GetDocument();
}

void CImgView::OnSize(UINT nType, int cx, int cy)
{
	CImgDoc * pDoc = (CImgDoc *)GetDocument();

	if (bFirstPaint)
      bFirstPaint=FALSE;
	else
      bSizing=TRUE;

    CView::OnSize(nType, cx, cy);

    d_SetNewSize(nType, cx, cy);
}


LRESULT CImgView::OnDoRealize(WPARAM wParam, LPARAM)
{
//  CWnd *wnd = AfxGetApp()->m_pMainWnd;
//    BOOL bBack = ( (HWND)wParam != m_hWnd );
//  d_SetNewPalette(wnd, bBack);
    CImgDoc *pDoc = GetDocument();

    if (pDoc->m_hDib) {
        if(pDoc->m_palDib) {
            CMainFrame* pAppFrame = (CMainFrame*) AfxGetApp()->m_pMainWnd;
            CClientDC appDC(pAppFrame);
            // All views but one should be a background palette.
            // wParam contains a handle to the active view, so the SelectPalette
            // bForceBackground flag is FALSE only if wParam == m_hWnd (this view)
            CPalette* oldPalette = appDC.SelectPalette(pDoc->m_palDib, ((HWND)wParam) != m_hWnd);

            if (oldPalette != NULL) {
                UINT nColorsChanged = appDC.RealizePalette();

                if (nColorsChanged > 0)
                    pDoc->UpdateAllViews(NULL);
                appDC.SelectPalette(oldPalette, TRUE);
            }
        }
    }
    return 0L;
}


void CImgView::OnActivateView(BOOL bActivate, CView* pActivateView,
                    CView* pDeactiveView)
{
    CView::OnActivateView(bActivate, pActivateView, pDeactiveView);
    if (bActivate)
        OnDoRealize((WPARAM)m_hWnd, 0);   // same as SendMessage(WM_DOREALIZE);
}

void CImgView::OnShowDpi()
{
    bFitToWindow = FALSE;
    if(bShowDPI)
    {
        d_SetNewMode(DISP_NORMAL);
        bShowDPI = FALSE;
    }
    else
    {
        d_SetNewMode(DISP_SCALED);
        bShowDPI = TRUE;
    }
    CImgDoc   *pDoc = GetDocument();
}

void CImgView::OnUpdateShowDpi(CCmdUI* pCmdUI)
{
    d_UpdateDispMode(DISP_SCALED, pCmdUI);
}

void CImgView::OnFitowindow()
{
    bShowDPI = FALSE;
    if(bFitToWindow)
    {
        d_SetNewMode(DISP_NORMAL);
        bFitToWindow = FALSE;
    }
    else
    {
        d_SetNewMode(DISP_PREVIEW);
        bFitToWindow = TRUE;
    }
    CImgDoc   *pDoc = GetDocument();
}

void CImgView::OnUpdateFitowindow(CCmdUI* pCmdUI)
{
    d_UpdateDispMode(DISP_PREVIEW, pCmdUI);
}

void CImgView::OnCenterimage()
{
    d_SetNewMode(DISP_CENTER);
    CImgDoc   *pDoc = GetDocument();
}

void CImgView::OnUpdateCenterimage(CCmdUI* pCmdUI)
{
    d_UpdateDispMode(DISP_CENTER, pCmdUI);
}

// Zoom functions. (View ZoomIn, ZoomOut commands)

void CImgView::OnZoomIn()
{
    d_StepZoom(ZOOM_STEP_LARGE);
    CImgDoc   *pDoc = GetDocument();
}

void CImgView::OnZoomOut()
{
    d_StepZoom(ZOOM_STEP_SMALL);
    CImgDoc   *pDoc = GetDocument();
}

void CImgView::OnUpdateZoomIn(CCmdUI* pCmdUI)
{
    d_UpdateStepZoom(pCmdUI);
}


void CImgView::OnUpdateZoomOut(CCmdUI* pCmdUI)
{
    d_UpdateStepZoom(pCmdUI);
}

void CImgView::OnZoomMode()
{
CImgApp *App = (CImgApp *)AfxGetApp();
CImgDoc *pDoc = (CImgDoc *)GetDocument();

    if(App->m_zoom_flag==FALSE)
    {
        if(App->m_magnify)
            OnMagnify();
        SetCursor(AfxGetApp()->LoadCursor(IDC_CUR_ZOOM) );
        App->m_zoom_flag = TRUE;
        d_KillFitToWindowMode();
    }
    else
    {
        SetCursor(AfxGetApp()->LoadCursor(IDC_CUR_ZOOM) );
        App->m_zoom_flag = FALSE;
    }
}

void CImgView::OnCustomZoom()
{
    CCustomZoom zdlg;
    zdlg.m_edit1 = rScale.left;
    zdlg.m_edit2 = rScale.top;
    int hh = zdlg.DoModal();
    if(hh!=IDOK)
        return;
    rScale.left = rScale.right  = zdlg.m_edit1;
    rScale.top  = rScale.bottom = zdlg.m_edit2;
    d_StepZoom(ZOOM_STEP_CUSTOM);
    CImgDoc   *pDoc = GetDocument();
}

void CImgView::OnZoomSteps()
{
    int hh;
    CZoomStep zstep;
    hh = zstep.DoModal();
    if(hh!=IDOK)
        return;
    CImgApp *App = (CImgApp *)AfxGetApp();
    App->SaveZoomINIFile();
    return;
}

void CImgView::OnUpdateZoomMode(CCmdUI* pCmdUI)
{
    CImgApp *App = (CImgApp *)AfxGetApp();
    CImgDoc   *pDoc = GetDocument();
    BOOL bEnabl = (BOOL)(pDoc ? TRUE : FALSE);
    BOOL bCheck = App->m_zoom_flag;
    if(bEnabl==FALSE)
        bCheck = FALSE;
    if(bEnabl==FALSE && App->m_zoom_flag)
        OnZoomMode();
    pCmdUI->Enable(bEnabl);
    pCmdUI->SetCheck(bCheck);
}

// Bitmap manipulation functions. (Rotate, Flip commands)

void CImgView::OnRotate90()
{
    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
        return;
    HDIB hDibNew;
    BeginWaitCursor();
    hDibNew = RotateDIB90(pDoc->m_hDib);
    pDoc->SetNewDib(hDibNew);
    EndWaitCursor();
}

void CImgView::OnUpdateRotate90(CCmdUI* pCmdUI)
{
    EnableView(pCmdUI);
}

void CImgView::OnRotate270()
{
    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
        return;
    HDIB hDibNew;
    BeginWaitCursor();
    hDibNew = RotateDIB270(pDoc->m_hDib);
    pDoc->SetNewDib(hDibNew);
    EndWaitCursor();
}

void CImgView::OnUpdateRotate270(CCmdUI* pCmdUI)
{
    EnableView(pCmdUI);
}

void CImgView::OnRotate180()
{
    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
        return;
    HDIB hDibNew;
    BeginWaitCursor();
    hDibNew = RotateDIB180(pDoc->m_hDib);
    EndWaitCursor();
    pDoc->SetNewDib(hDibNew);
}

void CImgView::OnUpdateRotate180(CCmdUI* pCmdUI)
{
    EnableView(pCmdUI);
}
/////////////////////////////////////////////////////////////////////////////////
// Rotate image by the specified angle. (View Rotate command)
//
void CImgView::OnViewRotate()
{
    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
        return;
    CDlgRotate dlgRotate;

    if(dlgRotate.DoModal() == IDOK) {   // Get method and angle for rotation.
        int     nError = 0;

        if(dlgRotate.nDegree) {
            HANDLE hDibNew;
            BeginWaitCursor();
			//Last 3 parameters commented out by Levente Nemethy (bidib.h RotateDIB has only 2 parameters)
            hDibNew = RotateDIB(pDoc->m_hDib, dlgRotate.nDegree/*, dlgRotate.nMethod, &nError, &sCoord*/);
            EndWaitCursor();
            pDoc->SetNewDib(hDibNew);
        }
    }
}

void CImgView::OnUpdateViewRotate(CCmdUI* pCmdUI)
{
    EnableView(pCmdUI);
}

// Flip image horizontally. (View Flip Horizontal command)

void CImgView::OnFlipHorizontal()
{
    HDIB    hDibNew;

    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
        return;
    BeginWaitCursor();
    hDibNew = FlipDIBHorizontal(pDoc->m_hDib);
    EndWaitCursor();
    pDoc->SetNewDib(hDibNew);
}

void CImgView::OnUpdateFlipHorizontal(CCmdUI* pCmdUI)
{
    EnableView(pCmdUI);
}

void CImgView::OnFlipVertical()
{
    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
        return;
    HDIB hDibNew;
    BeginWaitCursor();
    hDibNew = FlipDIBVertical(pDoc->m_hDib);
    EndWaitCursor();
    pDoc->SetNewDib(hDibNew);
}

void CImgView::OnUpdateFlipVertical(CCmdUI* pCmdUI)
{
    EnableView(pCmdUI);
}

// Invert image

void CImgView::OnViewInvert()
{
    CImgDoc *pDoc = GetDocument();
    if(pDoc->m_hDib==NULL)
        return;
    BOOL dibi=InvertDIBPalette(pDoc->m_hDib);       // Images can only be inverted, which has
    pDoc->UpdatePalette();
    d_DispStart(TRUE, FALSE);
}

void CImgView::OnUpdateViewInvert(CCmdUI* pCmdUI)
{
    // TODO: Add your command update UI handler code here
    EnableView(pCmdUI);
}

// Skew image  (View Skew... command)

void CImgView::OnViewSkew()
{
    CDlgSkew dlgSkew;

    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
        return;
    if(dlgSkew.DoModal() == IDOK) { // Get direction and value of skewing.
        XCOORD   pCoord;
        int     nError;
        HDIB    hDibNew;

        BeginWaitCursor();
        hDibNew = SkewDIB(pDoc->m_hDib, dlgSkew.bDirection, dlgSkew.nIncrement, &nError, &pCoord);
        EndWaitCursor();
        pDoc->SetNewDib(hDibNew);
    }
}

void CImgView::OnUpdateViewSkew(CCmdUI* pCmdUI)
{
    pCmdUI->Enable(TRUE);
}

// Scale image  (View Scale command)

void CImgView::OnViewScale()
{
    CDlgScale dlgScale;

    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
        return;
    dlgScale.pDoc = pDoc ;
    if(dlgScale.DoModal() == IDOK) {    // Get new size of image and
                                        // the method of scaling.
        XYSIZE  xySize;
        HDIB    hDibNew;

        xySize.x = dlgScale.wWidth;
        xySize.y = dlgScale.wHeight;
        BeginWaitCursor();
        hDibNew = ScaleDIB(pDoc->m_hDib, dlgScale.nMethod, xySize);
        pDoc->SetNewDib(hDibNew);
        EndWaitCursor();
    }
}

void CImgView::OnUpdateViewScale(CCmdUI* pCmdUI)
{
    pCmdUI->Enable(TRUE);
}

void CImgView::OnHalftone()
{
    HDIB hDibNew = NULL;
    WORD errcode;
    CImgDoc* pDoc = GetDocument();
    if(pDoc==NULL)
        return;
    CHalftoneDlg dlg;
    if( dlg.DoModal() == IDOK )
    {
        hDibNew = Halftone(pDoc->m_hDib, dlg.m_Methode, dlg.m_Intensity, &errcode);
        if(hDibNew)
            pDoc->SetNewDib(hDibNew);
    }
}

void CImgView::OnUpdateHalftone(CCmdUI* pCmdUI)
{
    CImgDoc* pDoc = GetDocument();
    BOOL bEnabl = FALSE;
    if(pDoc)
    {
        if( pDoc->wDepth!=1 )
            bEnabl = TRUE;
    }
    pCmdUI->Enable(bEnabl);
}

//      MOUSE

void CImgView::OnLButtonDown(UINT nFlags, CPoint point)
{
    CImgApp *App = (CImgApp *)AfxGetApp();

    if(App->m_zoom_flag)
        d_StartZoom(nFlags, point, TRUE);

    else if(App->m_magnify)
        d_StartMagnify(nFlags, point);

    CView::OnLButtonDown(nFlags, point);
}

void CImgView::OnLButtonUp(UINT nFlags, CPoint point)
{
    d_StopZoom(point);
    d_StopMagnify(point);

    CView::OnLButtonUp(nFlags, point);

    CImgApp *App = (CImgApp *)AfxGetApp();
}

void CImgView::OnRButtonDown(UINT nFlags, CPoint point)
{
    CImgApp *App = (CImgApp *)AfxGetApp();

    if(App->m_zoom_flag)
        d_StartZoom(nFlags, point, FALSE);

    else if(App->m_magnify)
        d_ToggleMagnifyWnd();

    CView::OnRButtonDown(nFlags, point);
}

void CImgView::OnRButtonUp(UINT nFlags, CPoint point)
{
    d_StopZoom(point);

    CView::OnRButtonUp(nFlags, point);
}

void CImgView::OnMouseMove(UINT nFlags, CPoint point)
{
    CView::OnMouseMove(nFlags, point);

    d_MoveZoom(point);
    d_MoveMagnify(nFlags, point);

    CImgApp *App = (CImgApp *)AfxGetApp();
}

void CImgView::OnLButtonDblClk( UINT nFlags, CPoint point )
{
    CImgDoc *pDoc = GetDocument();
    CImgApp *App = (CImgApp *)AfxGetApp();

    CView::OnLButtonDblClk(nFlags, point);

}

/////////////////////////////////////////////////////////////////////////////////
// Filter functions  (Tools commands)
/////////////////////////////////////////////////////////////////////////////////

void CImgView::OnViewColorToGray()
{
    // TODO: Add your command handler code here

    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
        return;
    CDlgColorToGray dlgColorToGray;
    HDIB hDibNew;

    dlgColorToGray.pDoc = pDoc;
    if(dlgColorToGray.DoModal() == IDOK) { // Asks paramters for the conversion
                                           // routines. (see: dialogs.cpp)
        BeginWaitCursor();
        if(pDoc->wDepth == 1)
            hDibNew = ConvMonoDIBtoGrayscale(pDoc->m_hDib, dlgColorToGray.nMethod);
        else
            hDibNew = ConvColorDIBtoGrayscale(pDoc->m_hDib, dlgColorToGray.nMethod,
                dlgColorToGray.bPsychovisual);
        EndWaitCursor();
        pDoc->SetNewDib(hDibNew);
        OnDoRealize((WPARAM)m_hWnd, 0);   // same as SendMessage(WM_DOREALIZE);
    }
}

void CImgView::OnUpdateViewColorToGray(CCmdUI* pCmdUI)
{
    // TODO: Add your command update UI handler code here


    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
    {
        pCmdUI->Enable( FALSE );
        return;
    }
    WORD    wDepth = pDoc->wDepth;

    pCmdUI->Enable(wDepth == 1 || wDepth == 4 || wDepth == 8);
}


void CImgView::OnImageConvTo24()
{
    // TODO: Add your command handler code here
    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
        return;
    HDIB    hDibNew;


    BeginWaitCursor();
    hDibNew = Convert8to24(pDoc->m_hDib);
    pDoc->SetNewDib(hDibNew);
    EndWaitCursor();
}

void CImgView::OnUpdateImageConvTo24(CCmdUI* pCmdUI)
{
    // TODO: Add your command update UI handler code here
    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
    {
        pCmdUI->Enable( FALSE );
        return;
    }

    pCmdUI->Enable(pDoc->wDepth == 8);    // Enables brightness for 8-bit images.
}

//      MAGNIFY
void CImgView::OnMagnify()
{
    // TODO: Add your command handler code here
    CImgApp *App = (CImgApp *)AfxGetApp();
    CImgDoc *pDoc = (CImgDoc *)GetDocument();

    if(App->m_magnify==FALSE)
    {
        if(App->m_zoom_flag)
            OnZoomMode();
        SetCursor(AfxGetApp()->LoadCursor(IDC_CUR_MAGNIFY) );
//        ChangeCustomCursor(m_hWnd, IDC_CUR_MAGNIFY, 1);
        App->m_magnify = TRUE;
//      MagnifyWnd.ShowWindow(SW_SHOW);
        App->ShowAllMagnifyWnd(SW_SHOW);
        b_MagnifyWnd = TRUE;
    }
    else
    {
        SetCursor(AfxGetApp()->LoadCursor(IDC_CUR_MAGNIFY) );
        App->m_magnify = FALSE;
        App->ShowAllMagnifyWnd(SW_HIDE);
        b_MagnifyWnd = FALSE;
    }
    m_bDownM = FALSE;

}

void CImgView::ShowMagnifyWnd(int nShow)
{
    MagnifyWnd.ShowWindow(nShow);
}

void CImgView::OnUpdateMagnify(CCmdUI* pCmdUI)
{
    // TODO: Add your command update UI handler code here

    CImgApp *App = (CImgApp *)AfxGetApp();
    CImgDoc *pDoc = GetDocument();
    BOOL bEnb = TRUE;
    BOOL bCheck = TRUE;
    if(pDoc==NULL)
        bCheck = bEnb = FALSE;

    if(App->m_magnify==FALSE)
        bCheck = FALSE;

    pCmdUI->Enable(bEnb);
    pCmdUI->SetCheck(bCheck);

}

void CImgView::OnKeyUp(UINT nChar, UINT nRepCnt, UINT nFlags)
{
    CView::OnKeyUp(nChar, nRepCnt, nFlags);
}

void CImgView::OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags)
{
CImgDoc *pDoc   = GetDocument();
CDC     *pDC    = GetDC();

    CView::OnKeyDown(nChar, nRepCnt, nFlags);
    if (!pDoc) return ;

    MapDisplayDC(pDC->m_hDC, d_GetDisplay());
    ReleaseDC(pDC);
}

void CImgView::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
{
CImgDoc *pDoc   = GetDocument();
CDC     *pDC    = GetDC();


    CView::OnChar(nChar, nRepCnt, nFlags);

    if (!pDoc) return ;

    MapDisplayDC(pDC->m_hDC, d_GetDisplay());
    ReleaseDC(pDC);
}

BOOL CImgView::OnEraseBkgnd(CDC* pDC)
{
	CImgDoc   *pDoc = GetDocument();
    
	if(bSizing)
        {
            bSizing=FALSE;
			CRect rect;
            GetClientRect(rect);
            if((d_GetDisplayMode() & DISP_FITTOWIDTH)||(d_GetDisplayMode() & DISP_PREVIEW))
				InvalidateRect(rect,FALSE);    
			return 1;
        }
        else
                return CDisp::OnEraseBkgnd(pDC);
}

BOOL CImgView::PreCreateWindow(CREATESTRUCT& cs)
{
	cs.lpszClass = ((CImgApp*)AfxGetApp())->m_szClassName;
	return CView::PreCreateWindow(cs);
}

void CImgView::OnFittowidth() 
{
    bFitToWindow = FALSE;
	bShowDPI = FALSE;
    if(bFitToWidth)
    {
        d_SetNewMode(DISP_NORMAL);
        bFitToWidth = FALSE;
    }
    else
    {
        d_SetNewMode(DISP_FITTOWIDTH);
        bFitToWidth = TRUE;
    }
    CImgDoc   *pDoc = GetDocument();
}

void CImgView::OnUpdateFittowidth(CCmdUI* pCmdUI) 
{
	d_UpdateDispMode(DISP_FITTOWIDTH, pCmdUI);	
}
