// logsfram.cpp : implementation file
//

#include "stdafx.h"
#include "faxcpp.h"        
#include "resource.h"
extern "C" {
	#include "bitiff.h"
}
#include "imgdoc.h"
#include "dialogs.h"
#include "faxdlg.h"
//#include "faxdoc.h"
#include "demo.h"
#include "logs.h"
#include "logsview.h"
#include "logsfram.h"

#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CLogsFrame

IMPLEMENT_DYNCREATE(CLogsFrame, CMDIChildWnd)

CLogsFrame::CLogsFrame()
{
}

CLogsFrame::~CLogsFrame()
{
}

BOOL CLogsFrame::OnCreateClient(LPCREATESTRUCT /*lpCreate*/, CCreateContext* pContext)
{   
    CLogs *pDoc = (CLogs *)pContext->m_pCurrentDoc;

    if ( !m_wndSplitter.CreateStatic( this, 2, 1, WS_CHILD|WS_VISIBLE, AFX_IDW_PANE_FIRST ) ) {
        TRACE("Failed to CreateStaticSplitter\n");
        return FALSE;
    }

    // add the first splitter pane - the default view in row 0
    if ( !m_wndSplitter.CreateView(0, 0, RUNTIME_CLASS(CLogsView), CSize(300, 200), pContext)) {
        TRACE("Failed to create first pane\n");
        return FALSE;
    }

    // add the second splitter pane - an input view in row 1
    if (!m_wndSplitter.CreateView(1, 0, RUNTIME_CLASS(CLogStatus), CSize(300, 100), pContext)) {
        TRACE("Failed to create second pane\n");
        return FALSE;
    }
    m_wndSplitter.SetRowInfo( 1, 200, 0 );
    SetActiveView( (CView*)m_wndSplitter.GetPane(0,0) );
    return TRUE;
}

BEGIN_MESSAGE_MAP(CLogsFrame, CMDIChildWnd)
    //{{AFX_MSG_MAP(CLogsFrame)
    //}}AFX_MSG_MAP
    ON_WM_CLOSE()
END_MESSAGE_MAP()

afx_msg void CLogsFrame::OnClose()
{               
    CloseWindow();
}

/////////////////////////////////////////////////////////////////////////////
// CLogStatus

IMPLEMENT_DYNCREATE(CLogStatus, CFormView)

CLogStatus::CLogStatus()
    : CFormView(CLogStatus::IDD)
{
    //{{AFX_DATA_INIT(CLogStatus)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}

CLogStatus::~CLogStatus()
{
}

void CLogStatus::DoDataExchange(CDataExchange* pDX)
{
    CFormView::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CLogStatus)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CLogStatus, CFormView)
    //{{AFX_MSG_MAP(CLogStatus)
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()

void CLogStatus::WriteDir( CString &szDir )
{
    SetDlgItemText( IDC_DIR, szDir );
}

void CLogStatus::WriteStatus( TSViewFaxBlock *vfb )
{
    SetDlgItemText( IDC_NAME, vfb->Name );
    SetDlgItemText( IDC_NUMBER, vfb->PhoneNumber );
    SetDlgItemText( IDC_PAGES, vfb->PageNumber );
    SetDlgItemText( IDC_SDATE, vfb->Date );
    SetDlgItemText( IDC_STIME, vfb->Time );
    SetDlgItemText( IDC_CDATE, vfb->CDate );
    SetDlgItemText( IDC_CTIME, vfb->CTime );
}

void CLogStatus::ClearStatus()
{
    SetDlgItemText( IDC_NAME, "" );
    SetDlgItemText( IDC_NUMBER, "" );
    SetDlgItemText( IDC_PAGES, "" );
    SetDlgItemText( IDC_SDATE, "" );
    SetDlgItemText( IDC_STIME, "" );
    SetDlgItemText( IDC_CDATE, "" );
    SetDlgItemText( IDC_CTIME, "" );
}
