// ReceiveDTMFandDecideToReceiveFaxOrVoiceDlg.cpp : implementation file
//

#include "stdafx.h"
#include <io.h>
#include <direct.h>
#include "ReceiveDTMFandDecideToReceiveFaxOrVoice.h"
#include "ReceiveDTMFandDecideToReceiveFaxOrVoiceDlg.h"

#include "BrookOpen.h"
#include "NMSOpen.h"
#include "DialogicOpen.h"
#include "OpenComPort.h"
#include "DlgWaitForDTMF.h"
#include "HelpDialog.h"
extern "C"
{
	#include "bitiff.h"
	#include "bidib.h"
}

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#define MODEM_SHORT_NAME    "GCLASS1(VOICE)"

// registered message from Voice/Fax C++
UINT VoiceMsg = RegisterWindowMessage(REG_FAXMESSAGE);
//
char g_szExePath[MAX_PATH];
char g_szBrookCfgFile[MAX_PATH] = "";


typedef void(CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::*VOCMSG)(int,long);

VOCMSG  DlgMems[] = {
    &CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnIdleProc,
    &CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnAnswerProc,
    &CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnHangUpProc,
    &CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnRecordProc,
    &CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnReceiveFaxProc,
    &CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnReceiveDTMFProc,
};

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

void SetExt(char *pszFile, int pszfSize, const char *pszExt)
{
    if( *pszFile )
    {
    char        *pC = strrchr(pszFile,'.');

        if( pC )
        {
            strcpy( ++pC, pszExt);
        }
        else
        {
            strcat(pszFile,".");
            strcat(pszFile,pszExt);
        }
    }
}

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg dialog

CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg)
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
    m_nPrStatus = ivs_IDLE;
    m_nSubStatus = 0;
    m_bDoExit = FALSE;
    m_Modem = NULL;
    m_bTransfer=false;
    bAutoScroll = TRUE;
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg)
	DDX_Control(pDX, IDC_HANGUP_BUTTON, m_hangUp);
	DDX_Control(pDX, IDC_PORT_STATUS, m_lbStatus);
	DDX_Control(pDX, IDC_NMS, m_NMS);
	DDX_Control(pDX, IDC_DIALOGIC, m_DIALOGIC);
	DDX_Control(pDX, IDC_BROOK, m_BROOK);
	DDX_Control(pDX, IDC_COMM, m_COMM);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg, CDialog)
	//{{AFX_MSG_MAP(CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_COMM, OnComm)
	ON_BN_CLICKED(IDC_BROOK, OnBrook)
	ON_BN_CLICKED(IDC_DIALOGIC, OnDialogic)
	ON_BN_CLICKED(IDC_NMS, OnNms)
	ON_BN_CLICKED(IDC_RECEIVEFAX, OnReceivefax)
	ON_BN_CLICKED(IDC_REC_DTMF, OnRecDtmf)
	ON_BN_CLICKED(IDC_CLEARLISTBOX, OnClearlistbox)
	ON_BN_CLICKED(IDC_RECMSG, OnRecmsg)
	ON_BN_CLICKED(IDC_CLOSEPORT, OnCloseport)
	ON_BN_CLICKED(IDC_CHELP, OnChelp)
    ON_REGISTERED_MESSAGE(VoiceMsg,OnVoiceMsg)
	ON_BN_CLICKED(IDC_HANGUP_BUTTON, OnHangupButton)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg message handlers

extern CReceiveDTMFandDecideToReceiveFaxOrVoiceApp theApp;

BOOL CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

    EnableToolTips(TRUE);

    EnableControls(FALSE, FALSE);
	GetDlgItem(IDC_CLOSEPORT)->EnableWindow(FALSE);
    m_COMM.SetIcon(theApp.LoadIcon(IDI_COMM));
    m_BROOK.SetIcon(theApp.LoadIcon(IDI_BROOK));
    m_DIALOGIC.SetIcon(theApp.LoadIcon(IDI_DIALOGIC));
    m_NMS.SetIcon(theApp.LoadIcon(IDI_NMS));

    StartCODEC(NULL,THREAD_PRIORITY_BELOW_NORMAL);
    SetupVoiceDriver(NULL);
    SetRuningMode(RNM_ALWAYSFREE);
	if(SetupFaxDriver(NULL) || SetFaxMessage(this->m_hWnd))
        AfxMessageBox("Setting fax driver has failed!");
	
	CReceiveDTMFandDecideToReceiveFaxOrVoiceApp *pApp = (CReceiveDTMFandDecideToReceiveFaxOrVoiceApp *)AfxGetApp();
	pApp->m_nDialogicBoard = D_GetBoardNum();
	pApp->BrooktroutChannels = GetChannelInfo();
	pApp->m_nNmsBoard = NMS_GetBoardNum();
	pApp->m_nGammaChannel = G_GetChannelNum();

    // Add "About..." menu item to system menu.
    // IDM_ABOUTBOX must be in the system command range.
    ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
    ASSERT(IDM_ABOUTBOX < 0xF000);

    SetIcon(m_hIcon, TRUE);                 // Set big icon
    SetIcon(m_hIcon, FALSE);                // Set small icon

    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::SetIdleProc()
{
    if( m_Modem )
    {
        m_Modem->WaitForRings( theApp.GetProfileInt(g_szSection,"Rings",3) );
    }

    if( m_bDoExit )
    {
        if(m_nPrStatus == ivs_IDLE) {
            OnExit();
            CDialog::OnCancel();
        }
        else {
            if( m_Modem && m_Modem->HangUp() )
            {
                m_nPrStatus = ivs_HANGUP;
                m_nSubStatus = -1;
                EnableControls(FALSE, FALSE);
                return;
            }
        }
    }
    m_nPrStatus = ivs_IDLE;
	GetDlgItem(IDC_CLOSEPORT)->EnableWindow(TRUE);
}

long CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnVoiceMsg(WPARAM event,LPARAM lParam)
{
    (this->*DlgMems[m_nPrStatus])(event,lParam);
    return 0;
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnIdleProc(int event,long /*lParam*/)
{
    switch( event )
    {
    case    MFX_MODEM_RING:
        StatusMsg("Incoming call was detected");

		// Get the caller ID information
		// Read the information into the TSCallerIDData structure
		TSCallerIDData CallerIDInfo;
		if (mdm_GetCallerID(m_Modem, &CallerIDInfo))
		{
			CString outputBuffer;

			outputBuffer = "Caller ID: ";
			outputBuffer += (LPSTR)CallerIDInfo.szCallerID;
			StatusMsg(outputBuffer);

			outputBuffer = "Caller Number: ";
			outputBuffer += (LPSTR)CallerIDInfo.szCalledNumber;
			StatusMsg(outputBuffer);

			outputBuffer = "Caller Name: ";
			outputBuffer += (LPSTR)CallerIDInfo.szCallerName;
			StatusMsg(outputBuffer);

			outputBuffer = "Call Date: ";
			outputBuffer += (LPSTR)CallerIDInfo.szCallingDate;
			StatusMsg(outputBuffer);

			outputBuffer = "Call Time: ";
			outputBuffer += (LPSTR)CallerIDInfo.szCallingTime;
			StatusMsg(outputBuffer);
		}
		// If error getting the caller ID data:
		else
			StatusMsg("CallerID information is not available.");

		char  szDID[256];
        memset(szDID,0,256);
        mdm_DID_GetDigits(m_Modem, szDID);
        if(strlen(szDID)>0) {
            StatusMsg("Received DID/DNIS digits:%s", szDID);
        }
		OnAnswer();
        MessageBeep(MB_OK);
    break;
    }

 
}
void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnReceiveDTMFProc(int event,long lParam)
{
    if( event == MFX_DTMF_RECEIVED )
    {
        DTMFINFO        dtmfInfo;
        m_Modem->GetReceivedDTMF(&dtmfInfo);
        StatusMsg("Received DTMF digits: [%s].", DTMF_DTMF((&dtmfInfo)));
    }
    else
    {
        if( event != MFX_ONHOOK &&
            event != MFX_OFFHOOK )
        {
            StatusMsg("Waiting for DTMF digits failed");
        }
        else
        {
            if( event == MFX_ONHOOK )
                StatusMsg("The call was disconnected");
            return;
        }
    }
    SetIdleProc();
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnReceiveFaxProc(int event,long lParam)
{
    if( event == MFX_RECEIVED )
    {
        OnFaxReceived((FAXOBJ)lParam);
    }
    else
    {
        switch(m_nSubStatus)
        {
        case    rec_SWITCH:
            OnReceiveSwitch(event);
        break;

        case    rec_CONNECT:
            OnReceiveConnect(event);
            break;
        case    rec_RECEIVING:
            OnReceivingFax(event);
            break;
        case    rec_RETURN:
            OnReturn2Voice(event);
			OnHangupButton();
            break;
        }
    }
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnRecordProc(int event,long /*lParam*/)
{
        if( event == MFX_VREC_STARTED )
        {
                StatusMsg("Recording voice message has started");
				GetDlgItem(IDC_CLOSEPORT)->EnableWindow(FALSE);
        }
        else if( event == MFX_DTMF_RECEIVED )
        {
            StatusMsg("DTMF digit received");
            m_Modem->TerminateWait();
        }
        else if( event == MFX_VREC_FINISHED )
        {
			DTMFINFO        dtmfInfo;
			m_Modem->GetReceivedDTMF(&dtmfInfo);
			CString str;
			str.Format("Received DTMF digit(s): [%s]", DTMF_DTMF((&dtmfInfo)));
			StatusMsg(str);
            StatusMsg("Recording voice message has finished.");
			str.Format("Voice file has saved to: %s",m_szMessage);
			AfxMessageBox(str);
            if( m_Modem->GetModemType() == MOD_STANDARD_ROCKWELL )
            {
                char    szTemp[MAX_PATH];
                strcpy(szTemp,m_szMessage);
                SetExt(szTemp,MAX_PATH,"VOC");

                ConvertVOC2WAV(m_szMessage,szTemp,4,FREQ_11025,MODE_SYNC);
                if( _access(szTemp,04) == 0 )
                {
                    _unlink(m_szMessage);
                    MoveFile(szTemp,m_szMessage);
                }
            }
            if( (m_Modem->GetModemType() == MOD_USR_SPORSTER) )
            {
                char VoiceCmd[128];
                m_Modem->GetVoiceFormatCommand(VoiceCmd, 128);
                if(!_stricmp(VoiceCmd, "AT#VSM=130,8000"MDM_ENTER))
                {
                    char    szTemp[MAX_PATH];
                    strcpy(szTemp,m_szMessage);
                    SetExt(szTemp,MAX_PATH,"USR");

                    ConvertIMAADPCMtoPCM(m_szMessage,szTemp,MODE_SYNC);
                    if( _access(szTemp,04) == 0 )
                    {
                        _unlink(m_szMessage);
                        MoveFile(szTemp,m_szMessage);
                    }
                }
            }
            SetIdleProc();
        }
        else if( event == MFX_ERROR )
        {
            StatusMsg("Recording voice message failed.");
            m_Modem->TerminateWait();
            SetIdleProc();
        }
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnAnswerProc(int event,long /*lParam*/)
{
BOOL bError = TRUE;

    switch(event)
    {
	case	MFX_MODEM_OK:
		return;
    case    MFX_ONHOOK:
        StatusMsg("Pick up the handset");
    return;

    case    MFX_OFFHOOK:
    case    MFX_VOICE_CONNECT:
        StatusMsg("Voice connection was established");
        if( m_Modem->GetModemType() == MOD_STANDARD_ROCKWELL ||
            m_Modem->GetModemType() == MOD_USR_SPORSTER      ||
            m_Modem->GetModemType() == MOD_LUCENT            ||
            m_Modem->GetModemType() == MOD_CIRRUSLOGIC       ||
            m_Modem->GetModemType() == MOD_CONEXANT_HCF) {

            StatusMsg("Regular voice modems cannot detect");
            StatusMsg("if the called party hanged up the line");
            StatusMsg("");
            StatusMsg("When you want to hang up the line,");
            StatusMsg("please press the \"Close port/channel\" button");
        }
        EnableControls(TRUE, TRUE);
        bError = FALSE;
    break;

    }

    if( bError )
    {
        StatusMsg("Answer failed");
        MessageBeep(MB_ICONEXCLAMATION);
    }
    else
    {
        MessageBeep(MB_OK);
    }

    SetIdleProc();
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnReturn2Voice(int event)
{
    switch(event)
    {
    case    MFX_CONNECT:
        StatusMsg("Fax port was destroyed");
        break;
    case    MFX_OFFHOOK:
    case    MFX_IDLE:
    case    MFX_ONHOOK:
		break;
    case    MFX_MODEM_OK:
//        StatusMsg("Modem is in voice mode again.");

        SetIdleProc();
        break;

    default:
        StatusMsg("Modem couldn't return to voice mode!");
        SetIdleProc();
    }
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::Return2Voice()
{
    m_nSubStatus = rec_RETURN;
    m_Modem->DisconnectVoicePort();
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnHangUpProc(int event,long lParam)
{
    if( m_nSubStatus == 0 )
    {
        if( event == MFX_MODEM_OK )
        {
            StatusMsg("The call was disconnected successfully");
            StatusMsg("Reinitializing modem...");
            m_nSubStatus = 1;
            if( !m_Modem->InitializeModem() )
            {
                SetIdleProc();
            }
        }
        else
        {
            StatusMsg("Disconnection was not successful");
            SetIdleProc();
        }
    }
    else
    {
        if( event == MFX_MODEM_OK )
        {
            EnableControls(TRUE, FALSE);
            if(!m_bDoExit)
                StatusMsg("Modem/channel is ready to answer incoming calls.");
        }
        else
        {
            StatusMsg("Disconnection was not successful");
        }
        if( m_nSubStatus == -1)
            m_nPrStatus = ivs_IDLE;
        SetIdleProc();
    }
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnReceiveSwitch(int event)
{
	GetDlgItem(IDC_CLOSEPORT)->EnableWindow(FALSE);
    if( event == MFX_VOICE_CONNECT )
    {
        char    szFaxIniFile[MAX_PATH];

        if( m_Modem->GetModemType() != MOD_BROOKTROUT )
        {
            sprintf(szFaxIniFile, "%s\\FAXCPP.INI", g_szExePath);
        }
        else
        {
            strcpy(szFaxIniFile,g_szBrookCfgFile);
        }

        StatusMsg("Creating fax port...");
        m_pPortFax = (PORTFAX)m_Modem->ConnectVoicePort(MODEM_SHORT_NAME,szFaxIniFile);

        if( m_pPortFax )
        {
            m_nSubStatus = rec_CONNECT;
        }
        else
        {
            m_Modem->DisconnectVoicePort();
        }
    }
    else
    {
        StatusMsg("Cannot switch to fax mode!");
        Return2Voice();
    }
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnReceiveConnect(int event)
{
    if( event == MFX_CONNECT )
    {
        StatusMsg("Modem is in fax mode");
    }
    else if( event == MFX_IDLE )
    {
        TSModemCapabiliti       MCap;

        StatusMsg("Receiving fax...");

        GetModemCapabiliti( m_pPortFax, &MCap );
        MCap.Ecm = ECM_DISABLE;
        SetupPortCapabilities( m_pPortFax, &MCap );

        if( m_Modem->ReceiveFaxNow() )
        {
                m_nSubStatus = rec_RECEIVING;
        }
        else
        {
            StatusMsg("Reveive fax failed");
            Return2Voice();
        }
    }
    else
    {
        Return2Voice();
    }
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnReceivingFax(int event)
{
    if(event == MFX_STARTRECEIVE)
    {
		GetDlgItem(IDC_CLOSEPORT)->EnableWindow(FALSE);
    }
    else if(event == MFX_IDLE)
    {
        Return2Voice();
    }
    else if(event == MFX_TERMINATE)
    // you can gain here the result of the transmission
    {
        TSSessionParameters Params;
        GetSessionParameters(m_pPortFax,&Params);
        StatusMsg("Fax termination status: [%d]", Params.TStatus);
    }
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnFaxReceived(FAXOBJ faxObj)
{
    TSFaxParam      FaxParam;
    time_t          lTime;
    struct  tm      *localTime;
    CString     szFaxFile;
    TUFaxImage      faxImage;
    int pages = 0;

    // make sure that the diretory exists
    szFaxFile = g_szExePath;
    szFaxFile += "\\Fax.In";
    _mkdir(szFaxFile);

    time( &lTime );
    localTime = localtime( &lTime );
    szFaxFile.Format("%s\\Fax.in\\REC_%d_%02d_%02d_%02d_%02d_%02d.TIF",
                            g_szExePath,
                            localTime->tm_year + 1900,
                            localTime->tm_mon + 1,
                            localTime->tm_mday,
                            localTime->tm_hour,
                            localTime->tm_min,
                            localTime->tm_sec);

    _unlink(szFaxFile);

    faxImage.File   = szFaxFile;

    while(faxObj) {
        if( GetFaxParam(faxObj,&FaxParam) == 0 )
        {

            if( FaxParam.PageNum > 0 )
            {
                bool            bAppend = true;
                bool            bOK     = true;


                for(int nPage = 0; bOK && nPage < FaxParam.PageNum; nPage++ )
                {
                    if( GetFaxImagePage(faxObj,nPage,IMT_FILE_TIFF_NOCOMP,&faxImage,bAppend) )
                    {
                        StatusMsg( "Error while saving received fax image!" );
                        bOK = false;
                    }
                    bAppend = true;
                    ++pages;
                }
				if ( bOK )
				{
					CString str;
					str.Format("Saving received fax as: %s",szFaxFile);
					StatusMsg("Number of fax pages received: [%d]", pages);
					AfxMessageBox(str);
				}
            }
        }

        FAXOBJ fax2=faxObj;
        faxObj = GetNextFax(faxObj);
        ClearFaxObj(fax2);
    }
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::EnableControls(BOOL bEnabled1, BOOL bEnabled2)
{
  
    GetDlgItem(IDC_RECMSG)->EnableWindow(bEnabled2);
    GetDlgItem(IDC_RECEIVEFAX)->EnableWindow(bEnabled2);
    GetDlgItem(IDC_REC_DTMF)->EnableWindow(bEnabled2);
	m_hangUp.EnableWindow(bEnabled2);

    m_COMM.EnableWindow(!bEnabled1);
    m_BROOK.EnableWindow(!bEnabled1);
    m_DIALOGIC.EnableWindow(!bEnabled1);
    m_NMS.EnableWindow(!bEnabled1);
}

BOOL CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::CheckStatus()
{
    if( !m_Modem )
    {
        return FALSE;
    }

    if( m_nPrStatus != ivs_IDLE )
    {
        return FALSE;
    }

    return TRUE;
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnDestroy()
{
        CDialog::OnDestroy();
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnClose()
{
        // TODO: Add your message handler code here and/or call default
        CDialog::OnClose();
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnComm() 
{
    if( !m_Modem )
    {
        COpenComPort dlg(this);

        if( dlg.DoModal() == IDOK )
        {
            m_Modem = theApp.GetOpenModem();
			m_bTransfer=FALSE;
            EnableControls(TRUE, FALSE);
			GetDlgItem(IDC_CLOSEPORT)->EnableWindow(TRUE);
            StatusMsg("Modem/channel is ready to answer incoming calls.");
        }
    }
    else
    {
        AfxMessageBox("Port is already open!");
    }	
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnBrook() 
{
	if ( !m_Modem )
	{
		CBrookOpen dlgBrook(this);
		CReceiveDTMFandDecideToReceiveFaxOrVoiceApp *pApp = (CReceiveDTMFandDecideToReceiveFaxOrVoiceApp *)AfxGetApp();

		if ( pApp->BrooktroutChannels && pApp->BrooktroutChannels[0] )
		{
			if ( dlgBrook.DoModal() == IDOK )
			{
				m_Modem = theApp.GetOpenModem();
				m_bTransfer=TRUE;
				EnableControls(TRUE, FALSE);
				GetDlgItem(IDC_CLOSEPORT)->EnableWindow(TRUE);
				StatusMsg("Modem/channel is ready to answer incoming calls");			
			}
		}
   		else AfxMessageBox("There is no available Brooktrout Channel!");	
	}
    else
    {
        AfxMessageBox("Port is already opened");
    }
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnDialogic() 
{
	if ( !m_Modem )
	{
		CDialogicOpen dlgDialogic(this);
		CReceiveDTMFandDecideToReceiveFaxOrVoiceApp *pApp = (CReceiveDTMFandDecideToReceiveFaxOrVoiceApp *)AfxGetApp();
		if ( pApp->m_nDialogicBoard )
		{
			if( dlgDialogic.DoModal() == IDOK )
			{
				m_Modem = theApp.GetOpenModem();
				m_bTransfer=TRUE;
				EnableControls(TRUE, FALSE);
				GetDlgItem(IDC_CLOSEPORT)->EnableWindow(TRUE);
				StatusMsg("Modem/channel is ready to answer incoming calls");
			}
		}
		else AfxMessageBox("There is no available Dialogic Channel!");	
	}
    else
    {
        AfxMessageBox("Port is already open!");
    }
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnNms() 
{
	if ( !m_Modem )
	{
		CNMSOpen dlgNMS(this);
		CReceiveDTMFandDecideToReceiveFaxOrVoiceApp *pApp = (CReceiveDTMFandDecideToReceiveFaxOrVoiceApp *)AfxGetApp();
		if ( pApp->m_nNmsBoard )
		{
			if( dlgNMS.DoModal() == IDOK )
			{
				m_Modem = theApp.GetOpenModem();
				m_bTransfer=TRUE;
				EnableControls(TRUE, FALSE);
				GetDlgItem(IDC_CLOSEPORT)->EnableWindow(TRUE);
				StatusMsg("Modem/channel is ready to originate a call or answer incoming calls");
			}
		}
		else AfxMessageBox("There is no available NMS Channel!");	
	}
	else
	{
		AfxMessageBox("Port is already open!");
	}
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnAnswer() 
{
    if( !CheckStatus() )
    {
        return;
    }
    StatusMsg("Answering call...");
    if( m_Modem->OnlineAnswer() )
    {
        m_nPrStatus = ivs_ANSWER;
    }
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnStop() 
{
    if( m_Modem )
    {
        if( m_nPrStatus == ivs_RECEIVEFAX )
        {
            StatusMsg("Aborting fax operation");
        }
        else
        {
            StatusMsg("Stopping... ");
        }
        m_Modem->TerminateWait();
    }
    else
    {
        AfxMessageBox("There is no port open");
    }
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnReceivefax() 
{
    if( !CheckStatus() )
    {
        return;
    }

    if( m_Modem->SetFaxReceiveMode(1) )
    {
        m_nPrStatus = ivs_RECEIVEFAX;
        m_nSubStatus = rec_SWITCH;
    }
    else
    {
        Return2Voice();
    }
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnRecDtmf() 
{
    if( !CheckStatus() && m_nPrStatus!=ivs_RECORD )
    {
        return;
    }

    cWaitForDTMFDlg dlg(this);

    if( dlg.DoModal() != IDOK )
    {
        return;
    }

    DTMFINFO        DTMFInfo;

    dlg.GetDTMFInfo( DTMFInfo );

    if( m_Modem->WaitForDTMF(&DTMFInfo,20) )
    {
        StatusMsg("Waiting for DTMF digits...");
		GetDlgItem(IDC_CLOSEPORT)->EnableWindow(FALSE);
        m_nPrStatus = ivs_RECDTMF;
    }
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnClearlistbox() 
{
        m_lbStatus.ResetContent();
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnCancel() 
{
    if(!m_Modem) {
        OnExit();
        CDialog::OnCancel();
    }
    if( m_nPrStatus == ivs_IDLE )
    {
        m_bDoExit = TRUE;
        if( m_Modem && m_Modem->HangUp() )
        {
            m_nPrStatus = ivs_HANGUP;
            m_nSubStatus = 1;
            EnableControls(FALSE, FALSE);
            GetDlgItem(IDCANCEL)->EnableWindow(FALSE);
        }

    }
    else
    {
        EnableControls(FALSE, FALSE);
        GetDlgItem(IDCANCEL)->EnableWindow(FALSE);
        m_bDoExit = TRUE;
        OnStop();
    }
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnExit()
{
	if( m_Modem  )
		m_Modem->ClosePort();
    KillFaxMessage(m_hWnd);
        EndOfVoiceDriver( TRUE );
    EndOfFaxDriver( TRUE );
    TerminateCODEC();
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::StatusMsg(LPCSTR msg,...)
{
    char    szTemp[1024];
    va_list pArg;

    va_start(pArg,msg);
    vsprintf(szTemp, msg, pArg);
    m_lbStatus.AddString(szTemp);

    va_end(pArg);

    if(bAutoScroll) {
        m_lbStatus.SetTopIndex(m_lbStatus.GetCount()-1);
    }
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnRecmsg() 
{
        if( !CheckStatus() )
        {
            return;
        }

        VOICEINFO       voiceInfo;
        DWORD           dwRetVal        = 0;
        BOOL            bOK             = TRUE;
        BOOL            bResult         = TRUE;
        time_t          lTime;
        struct  tm      *localTime;



        memset(&voiceInfo,0,sizeof(voiceInfo));

        time( &lTime );
        localTime = localtime( &lTime );

        memset(&voiceInfo,0,sizeof(voiceInfo));
    // record device
        VOICE_DEVICE((&voiceInfo))      = MDM_LINE;
    // stop on user request
        VOICE_DELIM((&voiceInfo)) = '#';
    // max record duration
        VOICE_TIME((&voiceInfo))        = theApp.GetProfileInt(g_szSection,"Message length",60);

        
        m_szMessage.Format("%s\\VOICE\\MAIL_%d_%02d_%02d_%02d_%02d_%02d.WAV",
                g_szExePath,
                localTime->tm_year + 1900,
                localTime->tm_mon + 1,
                localTime->tm_mday,
                localTime->tm_hour,
                localTime->tm_min,
                localTime->tm_sec);



    // message filename
    strcpy(VOICE_FILE((&voiceInfo)), m_szMessage);

    if( m_Modem->RecordVoice(&voiceInfo) )
    {
        m_nPrStatus = ivs_RECORD;
    }
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnCloseport() 
{
	if ( m_Modem )
	{
		m_Modem->ClosePort();
		StatusMsg("Port/channel closed.");
		m_Modem->DestroyModemObject();
		m_Modem = NULL;
		EnableControls(FALSE,FALSE);
		GetDlgItem(IDC_CLOSEPORT)->EnableWindow(FALSE);
	}
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnChelp() 
{
	CHelpDialog dlg;
	dlg.DoModal();
}

void CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg::OnHangupButton() 
{
    if( !CheckStatus() )
    {
        return;
    }

	StatusMsg("Modem is hanging up...");
    if( m_Modem->HangUp() )
    {
        m_nPrStatus = ivs_HANGUP;
        m_nSubStatus = 0;
    }	
}
