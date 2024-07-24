

// DISP.CPP : CDisp class
//
#pragma warning(disable: 4244 4005)

#include "stdafx.h"
extern "C" {
    #include    "magnify.h"
	#include "bidisp.h"
};


#include "magnifyw.h"
#include "disp.h"


IMPLEMENT_DYNCREATE(CDisp, CView)

CDisp::CDisp()
{
    m_zoom_select = FALSE;
    m_bDownM = FALSE;
    M_SetSizes(200, 100);
    mScale.top    = 10 ;
    mScale.left   = 30 ;
    mScale.bottom = 10 ;
    mScale.right  = 30 ;
    MagnifyWnd.SetScale( &mScale );
    b_MagnifyWnd = FALSE;

    SetRect(&rScale, 1, 1, 1, 1);
    SetRect(&sDisplay.rOrigo, 0, 0, 0, 0);
    wDisplayMode = DISP_SCALED;     // Default view mode
}

CDisp::~CDisp()
{
}

/*      DISPLAY     */

void CDisp::d_DispCreate()
{
    m_zoom_select = FALSE;
    DisplayWmCreate(m_hWnd, 0, 0, &sDisplay);
    CRect cMagn;
    GetClientRect(&cMagn);
    cMagn.right     = cMagn.left + 128 ;
    cMagn.bottom    = cMagn.top + 64 ;
    MagnifyWnd.Create(NULL,NULL,WS_CHILD|WS_BORDER|WS_THICKFRAME,cMagn,this,0,NULL);
//  MagnifyWnd.ShowWindow(SW_HIDE);
    b_MagnifyWnd = FALSE;
}

void CDisp::d_DispDestroy()
{
    DisplayWmDestroy(m_hWnd, 0, 0, &sDisplay);
}

void CDisp::d_DispStart(BOOL bNewDib, BOOL bNewOrigin)
{
    if(d_hDib==NULL)
        return;

    WORD wMode = wDisplayMode;

    if(bNewDib)
        wMode |= DISP_NEWDIB;

    if(bNewOrigin)
        SetRect(&sDisplay.rOrigo, 0, 0, 0, 0);

    DisplayDIBStart(m_hWnd, d_hDib, &sDisplay.rOrigo, &rScale, wMode, &sDisplay);
    d_SetMagnifyGlass();
}

void CDisp::d_DispDIBImageDC(CDC *pDC)
{
/*
    if (sDisplay.hDIBBitmap)
    {
                RECT  Rc;
                POINT Pt ;
        DisplayDIBImageDC(pDC->m_hDC, &sDisplay);
                pDC->SelectStockObject(BLACK_PEN);
                MapDisplayDC(pDC->m_hDC, &sDisplay);
                if (sDisplay.pDPIBitmap.x){
                        Pt.x = sDisplay.pDPIBitmap.x / 10 ;
                } else {
                        Pt.x = sDisplay.pDPIDC.x / 10 ;
                }
                if (sDisplay.pDPIBitmap.y) {
                        Pt.y = sDisplay.pDPIBitmap.y / 10 ;
                } else {
                        Pt.y = sDisplay.pDPIDC.y / 10 ;
                }
                Rc.left = 0 ;
                Rc.top  = 0 ;
                Rc.right  = sDisplay.pBitmapSize.x  ;
                Rc.bottom = sDisplay.pBitmapSize.y  ;

                pDC->MoveTo(Rc.left,Rc.top);
                pDC->LineTo(Rc.right,Rc.top);
                pDC->LineTo(Rc.right,Rc.bottom);
                pDC->LineTo(Rc.left,Rc.bottom);
                pDC->LineTo(Rc.left,Rc.top);

                pDC->SelectStockObject(NULL_PEN);
                pDC->SelectStockObject(DKGRAY_BRUSH);
                pDC->Rectangle(Rc.right,Rc.top+Pt.y,Rc.right+Pt.x,Rc.bottom+Pt.y);
                pDC->Rectangle(Rc.left+Pt.x,Rc.bottom,Rc.right+Pt.x,Rc.bottom+Pt.y);
    }
*/
    // Do not call CView::OnPaint() for painting messages
    if(d_hDib == NULL)
        return;

    
    //CPaintDC dc(this); // device context for painting
    RECT rc;
    GetClientRect(&rc);
//$$$
	SCROLLINFO scrollinfh;
	SCROLLINFO scrollinfv;

	scrollinfh.cbSize = sizeof(SCROLLINFO);
	scrollinfh.fMask = SIF_POS;

	scrollinfv.cbSize = sizeof(SCROLLINFO);
	scrollinfv.fMask = SIF_POS;

	BOOL reth=FALSE;
	BOOL retv=FALSE;
	reth = GetScrollInfo(SB_HORZ, &scrollinfh);
	retv = GetScrollInfo(SB_VERT, &scrollinfv);


	if( (!(wDisplayMode & DISP_FITTOWIDTH) && !(wDisplayMode & DISP_PREVIEW)) && ((scrollinfh.nPos==-1) || (scrollinfv.nPos==-1) || !retv || !reth)  )
	{
		HBRUSH hbr1 = GetSysColorBrush(COLOR_APPWORKSPACE);
		FillRect(pDC->m_hDC, &rc, hbr1);
	}

	if(wDisplayMode & DISP_FITTOWIDTH)
	{
		if(wDisplayMode & DISP_CENTER)
		{
			double imageaspect = (double)m_dwWidth / (double)m_dwHeight;
			int windowheight = (rc.right-rc.left) / imageaspect;

			if(windowheight<(rc.bottom-rc.top))
			{					
				RECT updaterect;
				updaterect.top = 0;
				updaterect.bottom = (rc.bottom-rc.top - windowheight)/2;
				updaterect.left = rc.left;
				updaterect.right = rc.right;
				HBRUSH hbr1 = GetSysColorBrush(COLOR_APPWORKSPACE);
				FillRect(pDC->m_hDC, &updaterect, hbr1);
				updaterect.top = (rc.bottom-rc.top + windowheight)/2;
				updaterect.bottom = rc.bottom;
				updaterect.left = rc.left;
				updaterect.right = rc.right;
				FillRect(pDC->m_hDC, &updaterect, hbr1);
			}
		}
		else
		{
			double imageaspect = (double)m_dwWidth / (double)m_dwHeight;
			int windowheight = (rc.right-rc.left) / imageaspect;

			if(windowheight<(rc.bottom-rc.top))
			{
				RECT updaterect;
				updaterect.top = windowheight;
				updaterect.bottom = rc.bottom;
				updaterect.left = rc.left;
				updaterect.right = rc.right;
				HBRUSH hbr1 = GetSysColorBrush(COLOR_APPWORKSPACE);
				FillRect(pDC->m_hDC, &updaterect, hbr1);
			}
		}
	}

	if(wDisplayMode & DISP_PREVIEW)
	{
		double imageaspect = (double)m_dwWidth / (double)m_dwHeight;
		double viewaspect = (double)(rc.right-rc.left) / (double)(rc.bottom-rc.top);
		if(imageaspect<viewaspect)
		{
			if(wDisplayMode & DISP_CENTER)
			{
				int windowwidth = (rc.bottom-rc.top) * imageaspect;
				if(windowwidth<(rc.right-rc.left))
				{
					RECT updaterect;
					updaterect.top = rc.top;
					updaterect.bottom = rc.bottom;
					updaterect.left = 0;
					updaterect.right = (rc.right-rc.left-windowwidth)/2;
					HBRUSH hbr1 = GetSysColorBrush(COLOR_APPWORKSPACE);
					FillRect(pDC->m_hDC, &updaterect, hbr1);
					updaterect.top = rc.top;
					updaterect.bottom = rc.bottom;
					updaterect.left = (rc.right-rc.left+windowwidth)/2;
					updaterect.right = rc.right;
					FillRect(pDC->m_hDC, &updaterect, hbr1);
				}
			}
			else
			{
				int windowwidth = (rc.bottom-rc.top) * imageaspect;
				if(windowwidth<(rc.right-rc.left))
				{
					RECT updaterect;
					updaterect.top = rc.top;
					updaterect.bottom = rc.bottom;
					updaterect.left = windowwidth;
					updaterect.right = rc.right;
					HBRUSH hbr1 = GetSysColorBrush(COLOR_APPWORKSPACE);
					FillRect(pDC->m_hDC, &updaterect, hbr1);
				}
			}
		}
		else
		{
			if(wDisplayMode & DISP_CENTER)
			{
				int windowheight = (rc.right-rc.left) / imageaspect;

				if(windowheight<(rc.bottom-rc.top))
				{
					RECT updaterect;
					updaterect.top = 0;
					updaterect.bottom = (rc.bottom-rc.top - windowheight)/2;
					updaterect.left = rc.left;
					updaterect.right = rc.right;
					HBRUSH hbr1 = GetSysColorBrush(COLOR_APPWORKSPACE);
					FillRect(pDC->m_hDC, &updaterect, hbr1);
					updaterect.top = (rc.bottom-rc.top + windowheight)/2;
					updaterect.bottom = rc.bottom;
					updaterect.left = rc.left;
					updaterect.right = rc.right;
					FillRect(pDC->m_hDC, &updaterect, hbr1);
				}
			}
			else
			{
				
				int windowheight = (rc.right-rc.left) / imageaspect;

				if(windowheight<(rc.bottom-rc.top))
				{
					RECT updaterect;
					updaterect.top = windowheight;
					updaterect.bottom = rc.bottom;
					updaterect.left = rc.left;
					updaterect.right = rc.right;
					HBRUSH hbr1 = GetSysColorBrush(COLOR_APPWORKSPACE);
					FillRect(pDC->m_hDC, &updaterect, hbr1);
				}
			}
		}
	}
//$$$
	
    DisplayDIBImageDC(pDC->m_hDC, &sDisplay);
	MapDisplayDC(pDC->m_hDC, &sDisplay);
}

void CDisp::d_ClearDib(BOOL bDeleteDib)
{
    DisplayWmDestroy(m_hWnd, 0, 0, &sDisplay);
    DisplayWmCreate(m_hWnd, 0, 0, &sDisplay);
    if(bDeleteDib)
    {
        if(d_hDib)
        {
            GlobalFree( d_hDib );
        }
        d_hDib = NULL;
    }
    InvalidateRect(NULL);
}

BOOL CDisp::d_SetNewDib(HDIB hDibPar)
{
    if(!hDibPar)
        return FALSE;

    d_hDib = hDibPar;
    d_DispStart(TRUE, TRUE);
    return  TRUE;
}

void CDisp::d_SetNewSize(UINT nType, int cx, int cy)
{
/*
    CView::OnSize(nType, cx, cy);
    if(d_hDib)
        DisplayWmSize(m_hWnd, nType, MAKELPARAM(cx, cy), &sDisplay);
*/
    if(d_hDib)
        DisplayWmSize(m_hWnd, nType, MAKELPARAM(cx, cy), &sDisplay);

	
    SCROLLINFO scrollinfv;
	scrollinfv.cbSize = sizeof(SCROLLINFO);
	scrollinfv.fMask = SIF_ALL;
    BOOL retv=FALSE;
	retv = GetScrollInfo(SB_VERT, &scrollinfv);

    SCROLLINFO scrollinfh;
	scrollinfh.cbSize = sizeof(SCROLLINFO);
	scrollinfh.fMask = SIF_ALL;
    BOOL reth=FALSE;
	reth = GetScrollInfo(SB_HORZ, &scrollinfh);

	static int x=0;
	static int y=0;

	if((wDisplayMode & DISP_FITTOWIDTH) || 
       (wDisplayMode & DISP_PREVIEW) ||
       (wDisplayMode & DISP_CENTER) ||
       ((x==0) && (y==0)) ||
       (retv && reth && (scrollinfv.nPos == scrollinfv.nMax) && (scrollinfv.nPos!=-1)  )||
       (reth && retv && (scrollinfh.nPos == scrollinfh.nMax) && (scrollinfh.nPos!=-1)  ))
	{
		RECT rect;
		GetClientRect(&rect);
		InvalidateRect(&rect, FALSE);
	}
	else
	{
		if( (y!=cy) && (x!=cx) )
		{
			CRgn rgn;
			POINT points[7];

			points[0].x = 0;
			points[0].y = y;
			points[1].x = x;
			points[1].y = y;
			points[2].x = x;
			points[2].y = 0;
			points[3].x = cx;
			points[3].y = 0;
			points[4].x = cx;
			points[4].y = cy;
			points[5].x = 0;
			points[5].y = cy;
			points[6].x = 0;
			points[6].y = y;
			
			
			rgn.CreatePolygonRgn(points, 7, ALTERNATE);

			InvalidateRgn(&rgn, FALSE);
		}
		else
		{
			if(y==cy)
			{
				RECT rect; 
				rect.left = x;
				rect.top = 0;
				rect.right = cx;
				rect.bottom = y;
				InvalidateRect(&rect, FALSE);
			}
			else if(x==cx)
			{
				RECT rect; 
				rect.left = 0;
				rect.top = y;
				rect.right = x;
				rect.bottom = cy;
				InvalidateRect(&rect, FALSE);
			}
		}
	}

	x=cx;
	y=cy;
}

void CDisp::d_SetNewPalette(CWnd *wnd, BOOL bBack)
{
    CDocument *pDoc = GetDocument();
    CClientDC appDC(wnd);
    CPalette pal;
    pal.Attach(sDisplay.hPal);
    CPalette *oldPalette = appDC.SelectPalette(&pal, bBack);
    if (oldPalette == NULL)
        return;
    UINT nColorsChanged = appDC.RealizePalette();
    if (nColorsChanged <= 0)
        return;
    pDoc->UpdateAllViews(NULL);
    appDC.SelectPalette(oldPalette, TRUE);
}

void CDisp::d_SetNewMode(UINT wMode)
{
    BOOL bNewOrigin = FALSE;
    switch(wMode)
    {
        case DISP_SCALED:
            wDisplayMode &= ~(DISP_PREVIEW | DISP_NORMAL | DISP_FITTOWIDTH | DISP_CENTER);
            wDisplayMode |= DISP_SCALED;
            break;
        case DISP_NORMAL:
            wDisplayMode &= ~(DISP_PREVIEW | DISP_SCALED | DISP_FITTOWIDTH | DISP_CENTER);
            wDisplayMode |= DISP_NORMAL;
            break;
        case DISP_FITTOWIDTH:
			bNewOrigin = TRUE;
            wDisplayMode &= ~(DISP_PREVIEW | DISP_NORMAL | DISP_SCALED | DISP_CENTER);
            wDisplayMode |= DISP_FITTOWIDTH;
            break;

        case DISP_PREVIEW:
            bNewOrigin = TRUE;
            wDisplayMode &= ~(DISP_SCALED | DISP_NORMAL | DISP_FITTOWIDTH | DISP_CENTER);
            wDisplayMode |= DISP_PREVIEW;
            break;

        case DISP_CENTER:
            wDisplayMode ^= DISP_CENTER;
            break;
    }
    if (!sDisplay.hDIBBitmap) return ;
    d_DispStart(FALSE, bNewOrigin);
    d_SetNewTitle();
}

void CDisp::d_UpdateDispMode(UINT wMode, CCmdUI* pCmdUI)
{
    BOOL bEnable = FALSE;
    int  nCheck = 0;
    CDocument *pDoc = GetDocument();
	if(wMode  != DISP_CENTER)
	{
		bEnable = (BOOL)(pDoc ? TRUE : FALSE);
		nCheck = (wDisplayMode & wMode) ? 1 : 0;
		pCmdUI->Enable(bEnable);
		pCmdUI->SetCheck(nCheck);
	}
	else
	{
		bEnable = (BOOL)((!(pDoc == NULL))&&(wDisplayMode & DISP_PREVIEW));
		nCheck = (wDisplayMode & wMode) ? 1 : 0;
		pCmdUI->Enable(bEnable);
		pCmdUI->SetCheck(nCheck);
	}
}

void CDisp::d_KillFitToWindowMode()
{
/*    if(wDisplayMode & DISP_PREVIEW)
    {
        wDisplayMode |= DISP_NORMAL;
        wDisplayMode &= ~DISP_PREVIEW;
    }
    sDisplay.wDisplayFormat = wDisplayMode;*/
    if(wDisplayMode & DISP_PREVIEW)
    {
       wDisplayMode |= DISP_NORMAL;
       wDisplayMode &= ~DISP_PREVIEW;
    }
	if(wDisplayMode & DISP_FITTOWIDTH)
    {
        wDisplayMode |= DISP_NORMAL;
        wDisplayMode &= ~DISP_FITTOWIDTH;
    }
    sDisplay.wDisplayFormat = wDisplayMode;    
}


/*      SCROLL      */

void CDisp::d_HorzScroll(UINT nSBCode, UINT nPos)
{
    if(d_hDib) {
        #ifdef WIN32
            DisplayWmHorzScroll(m_hWnd, MAKELPARAM(nSBCode, nPos), 0, &sDisplay);
        #else
            DisplayWmHorzScroll(m_hWnd, nSBCode, MAKELPARAM(nPos, 0), &sDisplay);
        #endif
    }
}

void CDisp::d_VertScroll(UINT nSBCode, UINT nPos)
{
    if(d_hDib)
#ifdef WIN32
        DisplayWmVertScroll(m_hWnd, MAKELPARAM(nSBCode, nPos), 0, &sDisplay);
#else
        DisplayWmVertScroll(m_hWnd, nSBCode, MAKELPARAM(nPos, 0), &sDisplay);
#endif
}

/*      ZOOM    */

void CDisp::d_StepZoom(ZOOMFLAG zoomflg)
{
    if (!sDisplay.hDIBBitmap) return ;
    BZoomStep(m_hWnd, &rScale, zoomflg, &m_zm, &sDisplay);
    d_DispZoom();
    return;
}

void CDisp::d_UpdateStepZoom(CCmdUI* pCmdUI)
{
    CDocument *pDoc = GetDocument();
    if (!sDisplay.hDIBBitmap) {
        pCmdUI->Enable(FALSE);
        return ;
    }

    pCmdUI->Enable((pDoc && d_hDib && !(wDisplayMode & DISP_PREVIEW) && !(wDisplayMode & DISP_FITTOWIDTH)));
}

void CDisp::d_DispZoom()
{
    if (!sDisplay.hDIBBitmap) return ;
    d_GetZoomData();
    d_DispStart(FALSE, FALSE);
}

void CDisp::d_GetZoomData() {
    CopyRect(&rScale, &m_zm.rScaleOut);
    SetRect(&sDisplay.rOrigo, 0, 0, 0, 0);
    sDisplay.rOrigo.left  = m_zm.pOrigoOut.x;
    sDisplay.rOrigo.top   = m_zm.pOrigoOut.y;
    d_SetNewTitle();
    return; }


void CDisp::d_StartZoom(UINT nFlags, CPoint &point, BOOL bLarge)
{
    if (!sDisplay.hDIBBitmap) return ;

    ZOOMFLAG zmflg = bLarge ? ZOOM_SELECT_LARGE : ZOOM_SELECT_SMALL;
    if(nFlags & MK_CONTROL)
        zmflg = ZOOM_SELECT_MOVE;
    if(nFlags & MK_SHIFT)
        zmflg = bLarge ? ZOOM_SELECT_PLUS : ZOOM_SELECT_MINUS;
    BZoomStart(m_hWnd, &point, &rScale, zmflg, &m_zm, FALSE);
    m_zoom_select = TRUE;
}

void CDisp::d_MoveZoom(CPoint &point)
{
    if (!sDisplay.hDIBBitmap) return ;
    if(m_zoom_select)
        BZoomUpdate(m_hWnd, &point, &m_zm);
}

void CDisp::d_StopZoom(CPoint &point)
{
    if(m_zoom_select)
    {
        BZoomEnd(m_hWnd, &point, &m_zm, &sDisplay);
        d_KillFitToWindowMode();
        d_DispZoom();
        m_zoom_select = FALSE;
    }
}


/*      MAGNIFY GLASS */

void CDisp::d_SetMagnifyGlass()
{
    if (!sDisplay.hBitmap) return ;
    MagnifyWnd.SetBitmap(sDisplay.hBitmap, sDisplay.hPal);
    MagnifyWnd.InvalidateRect(NULL, TRUE);
}

void CDisp::d_StartMagnify(UINT nFlags, CPoint &point)
{
    if (!sDisplay.hBitmap) return ;
    m_bDownM = TRUE ;
    M_StartMagnify(m_hWnd, sDisplay.hPal);
    d_MoveMagnify(nFlags, point);
    ptLast = point ;
    SetCapture() ;
}

void CDisp::d_MoveMagnify(UINT nFlags, CPoint &point)
{
    LPDISPLAYSTRUCT lpDisp = &sDisplay;
    BOOL bMove = FALSE;
    if (!m_bDownM)
        return ;
    if (!sDisplay.hBitmap) return ;

    CPoint ptBitmap  ;
    CRect  rcBitmap ;
    CRect  rcCalc ;

    if (nFlags & MK_SHIFT ) {
        if (ptLast.y+2 < point.y ) {
            bMove = TRUE;
            mScale.left = (mScale.left * 10) / 11  ;
            mScale.right = (mScale.right * 10)/ 11  ;
            if (mScale.left < 10 )
                mScale.left = 10 ;
            if (mScale.right < 10 )
                mScale.right = 10 ;
        }
        else if (ptLast.y-2 > point.y ) {
            bMove = TRUE;
            mScale.left = (mScale.left * 11) / 10  ;
            mScale.right = (mScale.right * 11)/ 10  ;
            if(mScale.left > 60)
                mScale.left = 60;
            if (mScale.right > 60 )
                mScale.right = 60 ;
        }
        if(bMove)
        {
            MagnifyWnd.SetScale( &mScale );
        }
        point = ptLast ;
        POINT ptScreen = point ;
        ClientToScreen(&ptScreen);
        SetCursorPos(ptScreen.x,ptScreen.y);
    }

    CDC *pDC  ;
    pDC = GetDC();
    ptBitmap.x = point.x;
    ptBitmap.y = point.y;

    MapDisplayDC(pDC->m_hDC,lpDisp);

    pDC->DPtoLP(&ptBitmap);

    MagnifyWnd.SetBitmapCenter(ptBitmap.x,ptBitmap.y);
    pDC->SetMapMode(MM_TEXT);
    ReleaseDC(pDC) ;

    if(bMove)
        MagnifyWnd.UpdateWindow();

    M_CalcRect(ptBitmap.x,ptBitmap.y,&mScale,&rcCalc) ;
    M_StretchBitmap((HBITMAP)lpDisp->hBitmap,rcCalc.left,rcCalc.top,rcCalc.Width(),rcCalc.Height());
    M_CopyBitmap(m_hWnd,point.x-M_GetWidth()/2,point.y-M_GetHeight()/2);

    ptLast = point ;
}

void CDisp::d_StopMagnify(CPoint &point)
{
    if(m_bDownM) {
        m_bDownM = FALSE ;
        M_StopMagnify();
        ReleaseCapture() ;
        CClientDC dc(this);
        MapDisplayDC(dc.m_hDC, &sDisplay);
        dc.DPtoLP(&point);
        MagnifyWnd.SetBitmapCenter(point.x ,point.y );
    }
}

void CDisp::d_ToggleMagnifyWnd()
{
    if(b_MagnifyWnd==FALSE)
    {
        b_MagnifyWnd = TRUE;
        MagnifyWnd.ShowWindow(SW_SHOW);
    }
    else
    {
        b_MagnifyWnd = FALSE;
        MagnifyWnd.ShowWindow(SW_HIDE);
    }
}

/*      TITLE   */

void CDisp::d_SetNewTitle() {
    CDocument *pDoc = GetDocument();
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

    if(wDisplayMode & DISP_NORMAL) {
        str = "Normal";
        bSc = TRUE; }
    else if(wDisplayMode & DISP_SCALED) {
        str = "Scale";
        bSc = TRUE; }
    else if(wDisplayMode & DISP_PREVIEW)
        str = "PreView";
    else if(wDisplayMode & DISP_FITSCREEN)
        str = "FitScreen";
    else if(wDisplayMode & DISP_FITTOWIDTH)
        str = "FitToWidth";
    if(wDisplayMode & DISP_CENTER)
        str2 = "Center";

    ii = wsprintf(pp, " | %s", str);
    if(str2)
        ii += wsprintf(&pp[ii], " %s", str2);
    if(bSc)
        ii += wsprintf(&pp[ii], " %i:%i", rScale.left, rScale.top);
    lstrcat(buf, pp);
    pDoc->SetTitle(buf);
    return; }

void CDisp::OnDraw(CDC* pDC)
{
    pDC = pDC;
}

void CDisp::d_SetHeight(DWORD dwHeight)
{
	m_dwHeight = dwHeight;
}

void CDisp::d_SetWidth(DWORD dwWidth)
{	
	m_dwWidth = dwWidth;
}

WORD CDisp::d_GetDisplayMode()
{
	return wDisplayMode;
}
