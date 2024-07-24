// DlgSelectMsg.cpp : implementation file
//

#include "stdafx.h"
#include "Interactive Voice Sample.h"
#include "DlgSelectMsg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDlgSelectMsg dialog


CDlgSelectMsg::CDlgSelectMsg(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgSelectMsg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDlgSelectMsg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CDlgSelectMsg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDlgSelectMsg)
	DDX_Control(pDX, IDC_SEND_FILES, m_lbFiles);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDlgSelectMsg, CDialog)
	//{{AFX_MSG_MAP(CDlgSelectMsg)
	ON_BN_CLICKED(IDC_SELECT, OnSelect)
	ON_LBN_DBLCLK(IDC_SEND_FILES, OnDblclkSendFiles)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgSelectMsg message handlers

void CDlgSelectMsg::OnSelect() 
{
    CString szTemp;

    m_lbFiles.GetText( m_lbFiles.GetCurSel(), szTemp );

    m_szMessage.Format("%s\\Voice\\%s",g_szExePath,LPCSTR(szTemp));

    CDialog::OnOK();
}

BOOL CDlgSelectMsg::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
    HANDLE			hSearch;
    char			szTemp[MAX_PATH];
    WIN32_FIND_DATA	FindData;

	sprintf( szTemp, "%s\\Voice\\*.*", g_szExePath);

	DEBUGMSG("Gathering filenames from folder: [%s]", szTemp);

	if( (hSearch = FindFirstFile(szTemp,&FindData)) != INVALID_HANDLE_VALUE )
	{
		do
		{
            if(strstr(FindData.cFileName,".WAV"))
                m_lbFiles.AddString(FindData.cFileName);
            
		}while( FindNextFile( hSearch, &FindData) );
		
		FindClose( hSearch );
	}
	else
	{
		DEBUGMSG("GetLastError(): [%ld]", GetLastError());
	}
	
    GetDlgItem(IDC_SELECT)->EnableWindow( m_lbFiles.GetCount() );
    m_lbFiles.SetCurSel(0);

	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CDlgSelectMsg::OnDblclkSendFiles() 
{
	// TODO: Add your control notification handler code here
	CString szTemp;

    m_lbFiles.GetText( m_lbFiles.GetCurSel(), szTemp );

    m_szMessage.Format("%s\\Voice\\%s",g_szExePath,LPCSTR(szTemp));

    CDialog::OnOK();
}
