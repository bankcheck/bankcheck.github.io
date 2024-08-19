// DlgMessage.cpp : implementation file
//

#include "stdafx.h"
#include "Voice Recording Sample.h"
#include "DlgMessage.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDlgMessage dialog


CDlgMessage::CDlgMessage(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgMessage::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDlgMessage)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CDlgMessage::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDlgMessage)
	DDX_Control(pDX, IDC_MESSAGE, m_edMsg);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDlgMessage, CDialog)
	//{{AFX_MSG_MAP(CDlgMessage)
		// NOTE: the ClassWizard will add message map macros here
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgMessage message handlers