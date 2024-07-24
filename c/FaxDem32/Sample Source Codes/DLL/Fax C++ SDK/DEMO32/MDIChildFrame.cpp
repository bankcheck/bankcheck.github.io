// MDIChildFrame.cpp : implementation file
//

#include "stdafx.h"
#include "demo.h"
#include "MDIChildFrame.h"
#include "port32.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMDIChildFrame

IMPLEMENT_DYNCREATE(CMDIChildFrame, CMDIChildWnd)

CMDIChildFrame::CMDIChildFrame()
{
}

CMDIChildFrame::~CMDIChildFrame()
{
}


BEGIN_MESSAGE_MAP(CMDIChildFrame, CMDIChildWnd)
	//{{AFX_MSG_MAP(CMDIChildFrame)
		// NOTE - the ClassWizard will add and remove mapping macros here.
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMDIChildFrame message handlers

BOOL CMDIChildFrame::PreCreateWindow(CREATESTRUCT& cs) 
{
	cs.lpszClass = ((CImgApp*)AfxGetApp())->m_szClassName;	
	return CMDIChildWnd::PreCreateWindow(cs);
}
