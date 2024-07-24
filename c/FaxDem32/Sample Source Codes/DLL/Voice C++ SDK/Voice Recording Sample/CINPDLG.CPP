// cInpDlg.cpp : implementation file
//
#include "stdafx.h"

#include "Voice Recording Sample.h"
#include "cInpDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// cInputDialog dialog


cInputDialog::cInputDialog(CWnd* pParent /*=NULL*/)
	: CDialog(cInputDialog::IDD, pParent)
{
	pszDialog	= NULL;
	pszStatic	= NULL;
	pszEdit		= NULL;
	nEditLen	= 0;
	
	//{{AFX_DATA_INIT(cInputDialog)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void cInputDialog::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(cInputDialog)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}

void	cInputDialog::SetFields(const char *pdialog, const char *pstatic, char *pedit, int editlen)
{
	pszDialog	= pdialog;
	pszStatic	= pstatic;
	pszEdit		= pedit;
	nEditLen	= editlen;
}

BEGIN_MESSAGE_MAP(cInputDialog, CDialog)
	//{{AFX_MSG_MAP(cInputDialog)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// cInputDialog message handlers

BOOL cInputDialog::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	// TODO: Add extra initialization here
	if( pszDialog )
	{
		SetWindowText(pszDialog);
	}

	if( pszStatic )
	{
		SendDlgItemMessage(IDC_INPUT_MSG,WM_SETTEXT,0,(LPARAM)pszStatic);
	}

	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void cInputDialog::OnOK() 
{
	// TODO: Add extra validation here
int	nLen = SendDlgItemMessage(IDC_INPUT_EDIT,WM_GETTEXT,nEditLen,(LPARAM)pszEdit);
	
	if( !nLen )
	{
		AfxMessageBox("Empty string is not acceptable!");
	}
	else
	{
		CDialog::OnOK();
	}
}
