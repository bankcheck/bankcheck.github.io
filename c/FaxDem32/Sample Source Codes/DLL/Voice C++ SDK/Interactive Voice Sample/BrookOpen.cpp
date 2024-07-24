// BrookOpen.cpp : implementation file
//

#include "stdafx.h"
#include <direct.h>

#include "Interactive Voice Sample.h"
#include "BrookOpen.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CBrookOpen dialog


CBrookOpen::CBrookOpen(CWnd* pParent /*=NULL*/)
	: CDialog(CBrookOpen::IDD, pParent)
{
    m_bWaitCursor = FALSE;
	//{{AFX_DATA_INIT(CBrookOpen)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CBrookOpen::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CBrookOpen)
	DDX_Control(pDX, IDC_CONFIG, m_edConfig);
	DDX_Control(pDX, IDC_TEST_RESULT, m_edTest);
	DDX_Control(pDX, IDC_CHANNEL_LIST, m_lbChannels);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CBrookOpen, CDialog)
	//{{AFX_MSG_MAP(CBrookOpen)
	ON_BN_CLICKED(IDC_TEST, OnTest)
	ON_WM_SETCURSOR()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CBrookOpen message handlers

void CBrookOpen::OnTest() 
{
char	szType[100];
int nChannel = m_lbChannels.GetCurSel();

	if( nChannel != -1 )
	{
		m_lbChannels.GetText(nChannel,szType);
		sscanf(szType,"CHANNEL%d",&nChannel);
		mdm_BT_GetChannelType(nChannel,szType,sizeof(szType));
	}
	else
	{
		strcpy(szType, "Select a channel");
	}

	m_edTest.SetWindowText(szType);
}

void CBrookOpen::OnVoiceMsg(int event)
{
    EndWaitCursor();
    m_bWaitCursor=FALSE;

	if( event == MFX_MODEM_OK )
    {
        CDialog::OnOK();
    }
    else
    {
		DestroyModemObject();
		EnableControls(TRUE);

        AfxMessageBox("Cannot open channel!");
    }
}

void CBrookOpen::OnOK() 
{
	    m_edConfig.GetWindowText(g_szBrookCfgFile,MAX_PATH);
	    mdm_BT_SetConfigFile(g_szBrookCfgFile);	 

MODEMOBJ Modem      = mdm_CreateModemObject(MOD_BROOKTROUT);

    if( Modem )
    {
    char    szPort[MAX_PATH];
    int     nChannel = m_lbChannels.GetCurSel();
	int     nRings = theApp.GetProfileInt(g_szSection,"Rings",1);

//	    DestroyModemObject();
		WritePrivateProfileString("Brooktrout","Config file",g_szBrookCfgFile,"Demo32.ini");


		m_lbChannels.GetText(nChannel,szPort);

	    m_bWaitCursor = TRUE;
	    BeginWaitCursor();

        Modem->SetModemLong((LONG)this);

        _chdir( g_szExePath );

		Modem->WaitForRings(nRings);
        if(!Modem->OpenPort(szPort)){
            AfxMessageBox("Cannot open channel!");
        }

        theApp.SetOpenModem(Modem);
    }
}

BOOL CBrookOpen::OnInitDialog() 
{
char	szTemp[20];
int		nChannels = 0;

	CDialog::OnInitDialog();
	
	char szTmp2[200];
	GetPrivateProfileString("Brooktrout","Config file","btcall.cfg",szTmp2,200,"Demo32.INI");
	m_edConfig.SetWindowText(szTmp2);

	for(int i = 0; i < MAX_BROOK_CHANNELS; i++ )
	{
		if( mdm_BT_IsChannelFree(i) )
		{
			sprintf(szTemp,"CHANNEL%d",i);
			m_lbChannels.InsertString(nChannels,szTemp);
			nChannels++;
		}
	}

	GetDlgItem(IDOK)->EnableWindow(nChannels != 0);
	GetDlgItem(IDC_TEST)->EnableWindow(nChannels != 0);

	m_edTest.SetWindowText( "Unknown modem" );	

	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CBrookOpen::DestroyModemObject()
{
	if( theApp.GetOpenModem() )
	{
		theApp.GetOpenModem()->DestroyModemObject();
		theApp.SetOpenModem(NULL);
	}
}

BOOL CBrookOpen::OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message) 
{
	// TODO: Add your message handler code here and/or call default
	if(m_bWaitCursor)
		return TRUE;
	else
		return CDialog::OnSetCursor(pWnd, nHitTest, message);
}

void CBrookOpen::EnableControls(BOOL bEnable)
{
    GetDlgItem(IDOK)->EnableWindow(bEnable);
    GetDlgItem(IDCANCEL)->EnableWindow(bEnable);
}
