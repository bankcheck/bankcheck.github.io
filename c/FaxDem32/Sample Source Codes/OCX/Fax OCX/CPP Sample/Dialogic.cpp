// Dialogic.cpp : implementation file
//

#include "stdafx.h"
#include "ocxdemo.h"
#include "Dialogic.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDialogic dialog


CDialogic::CDialogic(CWnd* pParent /*=NULL*/)
	: CDialog(CDialogic::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDialogic)
	m_bDTMF = FALSE;
	//}}AFX_DATA_INIT
}


void CDialogic::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDialogic)
	DDX_Check(pDX, IDC_DTMF, m_bDTMF);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDialogic, CDialog)
	//{{AFX_MSG_MAP(CDialogic)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDialogic message handlers

BOOL CDialogic::OnInitDialog() 
{
	CDialog::OnInitDialog();

	CString	szPart;
    int     i, go=1;

    while ( go ) {
        i = m_szChannels.Find( ' ' );
        if ( i == -1 ) { go = 0; szPart = m_szChannels; }
        else szPart = m_szChannels.Left( i );
        LPSTR lpLine=szPart.GetBuffer(255);
        SendDlgItemMessage( IDC_DChannels, LB_ADDSTRING, 0, (LPARAM)lpLine );
        m_szChannels = m_szChannels.Right( m_szChannels.GetLength()-i-1 );
    }
    SendDlgItemMessage( IDC_DChannels, LB_SETCURSEL, 0, 0 );
	
	return TRUE;
}

void CDialogic::OnOK() 
{
	//selected channel to m_selectedChannel from IDC_DChannels
	CListBox * pList = (CListBox*)GetDlgItem(IDC_DChannels);
	if( pList )
	{
		int curSel = pList->GetCurSel();
		pList->GetText(curSel, m_selectedChannel);
	}
	
	CDialog::OnOK();
}
