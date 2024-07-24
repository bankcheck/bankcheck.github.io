// magnifyw.cpp : implementation file
//

#include "stdafx.h"

#pragma warning(disable:4100 4103)

extern "C" {
	#include "bitiff.h"
	#include "bidisp.h"
};  
        
#include "faxcpp.h"        
  
#include "resource.h"  
#include "imgdoc.h"
#include "dialogs.h"
#include "faxdlg.h"
#include "demo.h"
#include "mainfrm.h"
#include "magnifyw.h"
#include "disp.h"
#include "imgvw.h"


#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMagnifyWnd

CMagnifyWnd::CMagnifyWnd()
{
    bDown = FALSE ;
}

CMagnifyWnd::~CMagnifyWnd()
{
}

BEGIN_MESSAGE_MAP(CMagnifyWnd, CWnd)
    //{{AFX_MSG_MAP(CMagnifyWnd)
    ON_WM_CREATE()
    ON_WM_SIZE()
    ON_WM_DESTROY()
    ON_WM_PAINT()
    ON_WM_LBUTTONDOWN()
    ON_WM_MOUSEMOVE()
    ON_WM_LBUTTONUP()
    ON_WM_LBUTTONDBLCLK()
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMagnifyWnd message handlers


int CMagnifyWnd::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
    if (CWnd::OnCreate(lpCreateStruct) == -1)
        return -1;
    _fmemset(&sDisplay,0,sizeof(sDisplay));     
    DisplayWmCreate(m_hWnd,0,0,&sDisplay);      
    sDisplay.rcScale.top    = 10 ;
    sDisplay.rcScale.left   = 30 ;
    sDisplay.rcScale.bottom = 10 ;    
    sDisplay.rcScale.right  = 30 ;
    sDisplay.wDisplayFormat = DISP_NORMAL | DISP_NOVERTSCROLL | DISP_NOHORZSCROLL;
    return 0;
}

void CMagnifyWnd::OnSize(UINT nType, int cx, int cy)
{
    CWnd::OnSize(nType, cx, cy);
    DisplayWmSize(m_hWnd,nType, MAKELPARAM(cx, cy),&sDisplay);      
}   

void CMagnifyWnd::SetScale(LPRECT lpScale)
{
    sDisplay.rcScale = *lpScale;
}


void CMagnifyWnd::OnDestroy()
{
    CWnd::OnDestroy();
    DisplayWmDestroy(m_hWnd,0,0,&sDisplay); 
}

void CMagnifyWnd::OnPaint()
{
    //CPaintDC dc(this); // device context for painting
    DisplayWmPaint(m_hWnd,&sDisplay);
}

void CMagnifyWnd::SetBitmap(HBITMAP hBitmap,HPALETTE hPal)
{
    DisplayStart ( m_hWnd,hBitmap,hPal,NULL,&sDisplay.rOrigo,&sDisplay.rcScale,
                    sDisplay.wDisplayFormat,&sDisplay ) ;

}
void CMagnifyWnd::SetBitmapCenter(int X,int Y)
{
    CClientDC dc(this);
    CRect  rcClient,rcBitmap ;
    
    MapDisplayDC(dc.m_hDC,&sDisplay);
    GetClientRect(&rcClient);
    dc.DPtoLP(&rcClient);
    rcBitmap.left  = X - rcClient.Width()/2 ;
    rcBitmap.top   = Y - rcClient.Height()/2 ;
    sDisplay.rOrigo.left = rcBitmap.left ;
    sDisplay.rOrigo.top  = rcBitmap.top ; 
    
    // Set New origin
    DisplayStart ( m_hWnd,sDisplay.hBitmap,sDisplay.hPal,NULL,&sDisplay.rOrigo,&sDisplay.rcScale,
                    sDisplay.wDisplayFormat,&sDisplay ) ;
    InvalidateRect(NULL,FALSE);

}
void CMagnifyWnd::OnLButtonDown(UINT nFlags, CPoint point)
{
    bDown = TRUE ;
    SetCapture() ;
    ptPrev = point ;   
    ClientToScreen(&ptPrev);
}

void CMagnifyWnd::OnMouseMove(UINT nFlags, CPoint point)
{
    if (!bDown) return ;
    CRect rcWnd ;
    GetWindowRect(&rcWnd) ; 
    ClientToScreen(&point);
    
    rcWnd.left += point.x-ptPrev.x ;
    rcWnd.right +=  point.x-ptPrev.x  ;
    rcWnd.top += point.y-ptPrev.y ;
    rcWnd.bottom += point.y-ptPrev.y  ;
    
    if (GetParent()){
        GetParent()->ScreenToClient(&rcWnd);
        MoveWindow(&rcWnd,TRUE);
        UpdateWindow();
        GetParent()->UpdateWindow();        
    }   
    ptPrev = point ;
}

void CMagnifyWnd::OnLButtonUp(UINT nFlags, CPoint point)
{
    bDown = FALSE ;
    ReleaseCapture() ;
}

void CMagnifyWnd::OnLButtonDblClk(UINT nFlags, CPoint point)
{
//  ShowWindow(SW_HIDE);    
}
