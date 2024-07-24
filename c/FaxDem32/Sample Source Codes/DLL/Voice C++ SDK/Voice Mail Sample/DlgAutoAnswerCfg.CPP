// cAnsCfg.cpp : implementation file
//
#include "stdafx.h"
#include "Voice Mail Sample.h"
#include "DlgAutoAnswerCfg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// cAnswerConfig dialog


cAnswerConfig::cAnswerConfig(CWnd* pParent /*=NULL*/)
	: CDialog(cAnswerConfig::IDD, pParent)
{
	//{{AFX_DATA_INIT(cAnswerConfig)
	m_szGreeting = _T("");
	m_nRecTime = 0;
	m_nRings = 0;
	//}}AFX_DATA_INIT
}


void cAnswerConfig::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(cAnswerConfig)
	DDX_Control(pDX, IDC_GREETING_MSG, m_edGreeting);
	DDX_Text(pDX, IDC_GREETING_MSG, m_szGreeting);
	DDX_Text(pDX, IDC_MAX_RECTIME, m_nRecTime);
	DDV_MinMaxInt(pDX, m_nRecTime, 1, 60);
	DDX_Text(pDX, IDC_MAX_RINGS, m_nRings);
	DDV_MinMaxInt(pDX, m_nRings, 1, 10);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(cAnswerConfig, CDialog)
	//{{AFX_MSG_MAP(cAnswerConfig)
	ON_BN_CLICKED(IDC_BROWSE, OnBrowse)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// cAnswerConfig message handlers

BOOL cAnswerConfig::OnInitDialog() 
{
	CDialog::OnInitDialog();

CString szTemp;
	
	// greeting message
	m_szGreeting = theApp.GetProfileString(g_szSection,g_szGreeting, "");
	// max rings
	m_nRings = theApp.GetProfileInt(g_szSection,g_szRings, 1);
	// max message duration
	m_nRecTime = theApp.GetProfileInt(g_szSection,g_szRecTime, 60);

    UpdateData(FALSE);
    	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void cAnswerConfig::OnBrowse() 
{
	// TODO: Add your control notification handler code here
char			*pC;
char			szInitialDir[MAX_PATH];
char			szFilename[MAX_PATH];
OPENFILENAME	ofn;

    m_edGreeting.GetWindowText(szFilename,sizeof(szFilename));
	if( m_szGreeting.GetLength() )
	{
		strcpy( szInitialDir, szFilename);
		pC = strrchr(szInitialDir,'\\');
		strcpy(szFilename,++pC);
		*pC = 0;
	}
	else
	{
        sprintf(szInitialDir,"\\%s\\Voice",g_szExePath);
	}
	
	memset(&ofn,0,sizeof(ofn));
	ofn.lStructSize		= sizeof(ofn); 
	ofn.hwndOwner		= m_hWnd; 
	ofn.lpstrFilter		= "Voice Message (*.wav)\0*.wav\0USRobotics files (*.usr)\0*.usr\0"; 
	ofn.nFilterIndex	= 1; 
	ofn.lpstrFile		= szFilename; 
	ofn.nMaxFile		= sizeof(szFilename); 
	ofn.lpstrInitialDir	= szInitialDir; 
	ofn.Flags			= OFN_FILEMUSTEXIST | OFN_NOREADONLYRETURN ; 
	ofn.lpstrDefExt		= "wav"; 
	if( GetOpenFileName(&ofn) )
	{
		SendDlgItemMessage(IDC_GREETING_MSG,WM_SETTEXT,0,(LPARAM)szFilename);
	}
}

void cAnswerConfig::OnOK() 
{
    if( UpdateData() )
    {
	    theApp.WriteProfileString(g_szSection,g_szGreeting, m_szGreeting);
		theApp.WriteProfileInt(g_szSection,g_szRings, m_nRings);
		theApp.WriteProfileInt(g_szSection,g_szRecTime, m_nRecTime);

		CDialog::OnOK();
    }
}
