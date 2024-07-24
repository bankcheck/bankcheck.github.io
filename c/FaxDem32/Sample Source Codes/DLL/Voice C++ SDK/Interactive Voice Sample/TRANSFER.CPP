// Transfer.cpp : implementation file
//
#include "stdafx.h"
#include "Interactive Voice Sample.h"
#include "Transfer.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

char	CTransferDlg::szNumber[128]	= "";

/////////////////////////////////////////////////////////////////////////////
// CTransferDlg dialog


CTransferDlg::CTransferDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CTransferDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CTransferDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CTransferDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CTransferDlg)
	DDX_Control(pDX, IDC_NUMBER, m_edNumber);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CTransferDlg, CDialog)
	//{{AFX_MSG_MAP(CTransferDlg)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CTransferDlg message handlers

BOOL CTransferDlg::OnInitDialog() 
{
char	szTemp[10];

	CDialog::OnInitDialog();
	
	// TODO: Add extra initialization here
	m_edNumber.SetWindowText( szNumber );

	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CTransferDlg::OnOK() 
{
char	szTmpNum[128];

	m_edNumber.GetWindowText(szTmpNum,128);
	if( *szTmpNum )
	{
		strcpy(szNumber, szTmpNum);
		CDialog::OnOK();
	}
	else
	{
		AfxMessageBox("Please specify a number", MB_ICONINFORMATION);
	}
}
