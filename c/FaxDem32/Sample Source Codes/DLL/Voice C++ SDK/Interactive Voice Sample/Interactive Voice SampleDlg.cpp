// Interactive Voice SampleDlg.cpp : implementation file
//

#include "stdafx.h"
#include <io.h>
#include <direct.h>
#include "Interactive Voice Sample.h"
#include "Interactive Voice SampleDlg.h"
#include "BrookOpen.h"
#include "DialogicOpen.h"
#include "OpenComPort.h"
#include "NMSOpen.h"
#include "DlgSelectMsg.h"
#include "cInpDlg.h"
#include "Transfer.h"
#include "DlgWaitForDTMF.h"
#include "DlgGenerateTone.h"
#include "DlgHelp.h"
#include "detecttone.h"
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

typedef void(CInteractiveVoiceSampleDlg::*VOCMSG)(int,long);

VOCMSG  DlgMems[] = {
    &CInteractiveVoiceSampleDlg::OnOpenPortProc,
    &CInteractiveVoiceSampleDlg::OnIdleProc,
    &CInteractiveVoiceSampleDlg::OnDialProc,
    &CInteractiveVoiceSampleDlg::OnAnswerProc,
    &CInteractiveVoiceSampleDlg::OnHangUpProc,
    &CInteractiveVoiceSampleDlg::OnPickUpProc,
    &CInteractiveVoiceSampleDlg::OnPlayProc,
    &CInteractiveVoiceSampleDlg::OnRecordProc,
    &CInteractiveVoiceSampleDlg::OnSendFaxProc,
    &CInteractiveVoiceSampleDlg::OnReceiveFaxProc,
    &CInteractiveVoiceSampleDlg::OnSendDTMFProc,
    &CInteractiveVoiceSampleDlg::OnReceiveDTMFProc,
    &CInteractiveVoiceSampleDlg::OnTransferProc,
    &CInteractiveVoiceSampleDlg::OnGenerateToneProc,
};

void SetExt(char *pszFile, const char *pszExt)
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

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

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
// CInteractiveVoiceSampleDlg dialog

CInteractiveVoiceSampleDlg::CInteractiveVoiceSampleDlg(CWnd* pParent /*=NULL*/)
        : CDialog(CInteractiveVoiceSampleDlg::IDD, pParent)
{
    //{{AFX_DATA_INIT(CInteractiveVoiceSampleDlg)
            // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
    // Note that LoadIcon does not require a subsequent DestroyIcon in Win32
    m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
    m_nPrStatus = ivs_IDLE;
    m_nSubStatus = 0;
    m_bDoExit = FALSE;
    m_Modem = NULL;
    m_bTransfer=false;
    bAutoScroll = TRUE;
	bBlindTranser = FALSE;
    LastCustomTone = 0;
}

CInteractiveVoiceSampleDlg::~CInteractiveVoiceSampleDlg()
{
}

void CInteractiveVoiceSampleDlg::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CInteractiveVoiceSampleDlg)
    DDX_Control(pDX, IDC_DIALOGIC, m_DIALOGIC);
    DDX_Control(pDX, IDC_BROOK, m_BROOK);
    DDX_Control(pDX, IDC_COMM, m_COMM);
    DDX_Control(pDX, IDC_NMS, m_NMS);
    DDX_Control(pDX, IDC_DIAL_NUMBER, m_edNumber);
    DDX_Control(pDX, IDC_PORT_STATUS, m_lbStatus);
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CInteractiveVoiceSampleDlg, CDialog)
    //{{AFX_MSG_MAP(CInteractiveVoiceSampleDlg)
    ON_WM_SYSCOMMAND()
    ON_WM_PAINT()
    ON_WM_QUERYDRAGICON()
    ON_WM_DESTROY()
    ON_WM_CLOSE()
    ON_BN_CLICKED(IDC_DIAL, OnDial)
    ON_BN_CLICKED(IDC_GEN_TONE, OnGenTone)
    ON_BN_CLICKED(IDC_HANGUP, OnHangup)
    ON_BN_CLICKED(IDC_PLAYMSG, OnPlaymsg)
    ON_BN_CLICKED(IDC_REC_DTMF, OnRecDtmf)
    ON_BN_CLICKED(IDC_RECEIVEFAX, OnReceivefax)
    ON_BN_CLICKED(IDC_RECMSG, OnRecmsg)
    ON_BN_CLICKED(IDC_SEND_DTMF, OnSendDtmf)
    ON_BN_CLICKED(IDC_SENDFAX, OnSendfax)
    ON_BN_CLICKED(IDC_STOP, OnStop)
    ON_BN_CLICKED(IDC_TRANSFER, OnTransfer)
    ON_BN_CLICKED(IDCHELP, OnChelp)
    ON_BN_CLICKED(IDC_ANSWER, OnAnswer)
    ON_BN_CLICKED(IDC_COMM, OnComm)
    ON_BN_CLICKED(IDC_BROOK, OnBrook)
    ON_BN_CLICKED(IDC_DIALOGIC, OnDialogic)
    ON_BN_CLICKED(IDC_NMS, OnNms)
    ON_NOTIFY_EX( TTN_NEEDTEXT, 0, OnToolTips )
        ON_BN_CLICKED(IDC_AUTOSCROLL, OnAutoscroll)
        ON_BN_CLICKED(IDC_CLEARLISTBOX, OnClearlistbox)
        ON_BN_CLICKED(IDC_COPYCLIPBOARD, OnCopyclipboard)
	ON_BN_CLICKED(IDC_BLINDTRANSFER, OnBlindTransfer)
	ON_BN_CLICKED(IDC_DETECTTONE, OnDetecttone)
    ON_REGISTERED_MESSAGE(VoiceMsg,OnVoiceMsg)
	ON_BN_CLICKED(IDC_CLOSEPORT, OnCloseport)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CInteractiveVoiceSampleDlg message handlers

BOOL CInteractiveVoiceSampleDlg::OnInitDialog()
{
    CDialog::OnInitDialog();

    EnableToolTips(TRUE);

    EnableControls(FALSE, FALSE);
	GetDlgItem(IDC_CLOSEPORT)->EnableWindow(FALSE);
    ((CButton*)GetDlgItem(IDC_AUTOSCROLL))->SetCheck(1);
    m_COMM.SetIcon(theApp.LoadIcon(IDI_COMM));
    m_BROOK.SetIcon(theApp.LoadIcon(IDI_BROOK));
    m_DIALOGIC.SetIcon(theApp.LoadIcon(IDI_DIALOGIC));
    m_NMS.SetIcon(theApp.LoadIcon(IDI_NMS));

    StartCODEC(NULL,THREAD_PRIORITY_BELOW_NORMAL);
    SetupFaxDriver(NULL);
    SetupVoiceDriver(NULL);
    SetRuningMode(RNM_ALWAYSFREE);
    SetFaxMessage(m_hWnd);

    // Add "About..." menu item to system menu.
    // IDM_ABOUTBOX must be in the system command range.
    ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
    ASSERT(IDM_ABOUTBOX < 0xF000);

    CMenu* pSysMenu = GetSystemMenu(FALSE);
    if (pSysMenu != NULL)
    {
        CMenu   menuOpen;
        CString strAboutMenu;

        menuOpen.LoadMenu(IDR_OPEN_PORT);
        pSysMenu->AppendMenu(MF_SEPARATOR);
        pSysMenu->AppendMenu(MF_POPUP,(UINT)menuOpen.m_hMenu,"Open Port");

        strAboutMenu.LoadString(IDS_ABOUTBOX);
        if (!strAboutMenu.IsEmpty())
        {
                pSysMenu->AppendMenu(MF_SEPARATOR);
                pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
        }
    }

    SetIcon(m_hIcon, TRUE);                 // Set big icon
    SetIcon(m_hIcon, FALSE);                // Set small icon

    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CInteractiveVoiceSampleDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
    switch(nID & 0xFFF0)
    {
        case    IDM_ABOUTBOX:
        {
            CAboutDlg dlgAbout;
            dlgAbout.DoModal();
        }
        break;
        case    ID_OPENPORT_COMPORT:
        {
            OnComm();
        }
        break;
        case    ID_OPENPORT_BROOKTROUTCHANNEL:
        {
            OnBrook();
        }
        break;
        case    ID_OPENPORT_DIALOGICCHANNEL:
        {
            OnDialogic();
        }
        break;
        case    ID_OPENPORT_NMSCHANNEL:
        {
            OnNms();
        }
        break;
        default:
            CDialog::OnSysCommand(nID, lParam);
    }
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CInteractiveVoiceSampleDlg::OnPaint()
{
    if (IsIconic())
    {
        CPaintDC dc(this);
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

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CInteractiveVoiceSampleDlg::OnQueryDragIcon()
{
    return (HCURSOR) m_hIcon;
}

void CInteractiveVoiceSampleDlg::SetIdleProc()
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

long CInteractiveVoiceSampleDlg::OnVoiceMsg(WPARAM event,LPARAM lParam)
{
    (this->*DlgMems[m_nPrStatus])(event,lParam);
    if( event >= MFX_CUSTOM_TONE_1_ON && event <= MFX_CUSTOM_TONE_20_ON )
    {
        StatusMsg("Custom tone %d TONE_ON event", event-USER_DEFINED_CUSTOME_TONE_MSG_OFFSET);
    }
	else if( event >= MFX_CUSTOM_TONE_1_OFF && event <= MFX_CUSTOM_TONE_20_OFF )
    {
        StatusMsg("Custom tone %d TONE_OFF event", event-USER_DEFINED_CUSTOME_TONE_MSG_OFFSET-20);
    }
    return 0;
}

void CInteractiveVoiceSampleDlg::OnOpenPortProc(int event,long lParam)
{
    MODEMOBJ Modem = (MODEMOBJ)lParam;

    if( Modem == theApp.GetOpenModem() )
    {
        switch( Modem->GetModemType() )
        {
        case    MOD_STANDARD_ROCKWELL:
        case    MOD_CONEXANT_HCF:
        case    MOD_USR_SPORSTER:
        case    MOD_LUCENT:
        case    MOD_CIRRUSLOGIC:
        {
            COpenComPort *pOpen = (COpenComPort*)Modem->GetModemLong();
            pOpen->OnVoiceMsg(Modem,event);
        }
        break;

        case    MOD_DIALOGIC:
        {
            CDialogicOpen *pOpen = (CDialogicOpen*)Modem->GetModemLong();
            pOpen->OnVoiceMsg(event);
        }
        break;


        case    MOD_BROOKTROUT:
        {
            CBrookOpen *pOpen = (CBrookOpen*)Modem->GetModemLong();
            pOpen->OnVoiceMsg(event);
        }
        break;

        case    MOD_NMS:
        {
            CNMSOpen *pOpen = (CNMSOpen*)Modem->GetModemLong();
            pOpen->OnVoiceMsg(event);
        }
        break;
        }
    }
    else
    {
    }
}

void CInteractiveVoiceSampleDlg::OnIdleProc(int event,long /*lParam*/)
{
    switch( event )
    {
    case    MFX_MODEM_RING:
        StatusMsg("Incoming call was detected");
        char  szDID[256];
        memset(szDID,0,256);
        mdm_DID_GetDigits(m_Modem, szDID);
        if(strlen(szDID)>0) {
            StatusMsg("Received DID/DNIS digits:%s", szDID);
        }
        
        TSCallerIDData CallerIDInfo;
        memset(&CallerIDInfo, 0, sizeof(TSCallerIDData));
        mdm_GetCallerID(m_Modem, &CallerIDInfo);
        if( strlen((const char*)CallerIDInfo.szCallingDate)>0 || 
            strlen((const char*)CallerIDInfo.szCallingTime)>0 || 
            strlen((const char*)CallerIDInfo.szCallerID)>0 || 
            strlen((const char*)CallerIDInfo.szCallerName)>0 || 
            strlen((const char*)CallerIDInfo.szCalledNumber) ||
            strlen((const char*)CallerIDInfo.szMessage)>0 ) {
            StatusMsg("Caller ID received:");    
            if( strlen((const char*)CallerIDInfo.szCallingDate)>0  ) {
                StatusMsg("Calling Date:%s", CallerIDInfo.szCallingDate); 
            }
            if( strlen((const char*)CallerIDInfo.szCallingTime)>0  ) {
                StatusMsg("Calling Time:%s", CallerIDInfo.szCallingTime); 
            }
            if( strlen((const char*)CallerIDInfo.szCallerID)>0  ) {
                StatusMsg("Caller ID:%s", CallerIDInfo.szCallerID); 
            }
            if( strlen((const char*)CallerIDInfo.szCallerName)>0  ) {
                StatusMsg("Caller Name:%s", CallerIDInfo.szCallerName); 
            }
            if( strlen((const char*)CallerIDInfo.szCalledNumber)>0  ) {
                StatusMsg("Called Number:%s", CallerIDInfo.szCalledNumber); 
            }
            if( strlen((const char*)CallerIDInfo.szMessage)>0  ) {
                StatusMsg("Message:%s", CallerIDInfo.szMessage); 
            }
        }
        
        StatusMsg("Press the Answer button to answer the call");
        MessageBeep(MB_OK);
    break;
    case    MFX_ONHOOK:
        StatusMsg("The call was disconnected");
    break;
    case    MFX_ANSWER_TONE:
        StatusMsg("Fax answer tone was detected");
    break;
    case    MFX_SIT:
        StatusMsg("Special Intercept Tone was detected");
    break;
    case    MFX_CALLING_TONE:
        StatusMsg("Fax calling tone was detected");
    case  MFX_NO_CARRIER:
    case  MFX_NO_DIALTONE:
        StatusMsg("There is no dial tone");
        StatusMsg("Please check if a phone line ");
        StatusMsg("is connected to the modem");
    break;
    case    MFX_BUSY_TONE:
    case    MFX_BUSY:
        StatusMsg("The dialed number is busy");

    break;
    }

 
}

void CInteractiveVoiceSampleDlg::OnDialProc(int event,long /*lParam*/)
{
    BOOL bError = TRUE;

    switch(event)
    {
    case    MFX_ERROR:
    break;

    case    MFX_MODEM_OK:
//        StatusMsg("Dialing...");
        if( m_Modem->GetModemType() == MOD_STANDARD_ROCKWELL ||
            m_Modem->GetModemType() == MOD_USR_SPORSTER      ||
            m_Modem->GetModemType() == MOD_LUCENT            ||
            m_Modem->GetModemType() == MOD_CIRRUSLOGIC       ||
            m_Modem->GetModemType() == MOD_CONEXANT_HCF) {
            StatusMsg("");
            StatusMsg("Regular voice modems cannot detect if the called");
            StatusMsg("party has answered the call or hanged up the line");
            StatusMsg("");
            StatusMsg("When you want to hang up the line,");
            StatusMsg("please press the HangUp button.");
            return;
        }
        GetDlgItem(IDC_STOP)->EnableWindow(TRUE);
    return;

    case    MFX_ONHOOK:
        StatusMsg("Pick up the handset!");
    return;

    case    MFX_NO_ANSWER:
        StatusMsg("The called number doesn't answer");
        EnableControls(FALSE, TRUE);
        bError = FALSE;
    break;

    
    case    MFX_ANSWERING_MACHINE:
        StatusMsg("Answering machine was detected");
        EnableControls(FALSE, TRUE);
        bError = FALSE;
    break;
    case    MFX_OFFHOOK:
	case    MFX_VOICE_CONNECT:
        StatusMsg("Voice connection was established");
        EnableControls(FALSE, TRUE);
        bError = FALSE;
    break;

    case  MFX_NO_CARRIER:
    case  MFX_NO_DIALTONE:
        EnableControls(FALSE, TRUE);
        StatusMsg("There is no dial tone");
        bError = FALSE;
    break;
    case    MFX_BUSY_TONE:
    case    MFX_BUSY:
        EnableControls(FALSE, TRUE);
        StatusMsg("The called number is busy");
        bError = FALSE;
    break;
    case    MFX_SIT:
        EnableControls(FALSE, TRUE);
        StatusMsg("Special intercept tone was detected");
        bError = FALSE;
    break;
    case    MFX_ANSWER_TONE:
        StatusMsg("Fax answer tone was detected");
        EnableControls(FALSE, TRUE);
        bError = FALSE;
    break;
    }

    if( bError )
    {
        StatusMsg("Dial failed");
        MessageBeep(MB_ICONEXCLAMATION);
    }
    else
    {
        MessageBeep(MB_OK);
    }

    SetIdleProc();
}

void CInteractiveVoiceSampleDlg::OnAnswerProc(int event,long /*lParam*/)
{
BOOL bError = TRUE;

    switch(event)
    {
    case    MFX_MODEM_OK:
//        StatusMsg("Answering call...");
    return;

    case    MFX_ERROR:
    break;

    case    MFX_ONHOOK:
        StatusMsg("Pick up the handset");
    return;
    case    MFX_CALLING_TONE:
        StatusMsg("Fax calling tone was detected");
        EnableControls(FALSE, TRUE);
        bError = FALSE;
    break;

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
            StatusMsg("please press the HangUp button");
        }
        EnableControls(FALSE, TRUE);
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

void CInteractiveVoiceSampleDlg::OnHangUpProc(int event,long lParam)
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
                StatusMsg("Modem is ready to originate a call or answer incoming calls.");
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

void CInteractiveVoiceSampleDlg::OnPickUpProc(int event,long lParam)
{
    if( event == MFX_MODEM_OK )
    {
        SetIdleProc();
    }
    else
    {
        SetIdleProc();
    }
}

void CInteractiveVoiceSampleDlg::OnPlayProc(int event,long /*lParam*/)
{
    if( event == MFX_VPLAY_STARTED )
    {
        StatusMsg("Playing voice message was started");
    }
    else if( event == MFX_ONHOOK )
    {
        StatusMsg("Caller has hanged-up the line");
        m_Modem->TerminateWait();
    }
    else if( event == MFX_DTMF_RECEIVED )
    {
        StatusMsg("DTMF digit was received.");
        m_Modem->TerminateWait();
    }
    else if( event == MFX_CALLING_TONE )
    {
        if( !m_bRecFax )
        // do not terminate process more than 1 time!
        {
            StatusMsg("Fax calling tone was detected");
            m_Modem->TerminateWait();
            m_bRecFax = TRUE;
        }
    }
    else if( event == MFX_VPLAY_FINISHED )
    {
        if( m_Modem->GetModemType() == MOD_STANDARD_ROCKWELL )
        {
            unlink(m_szMessage);
        }
	if( (m_Modem->GetModemType() == MOD_USR_SPORSTER) )
        {
            char VoiceCmd[128];
            m_Modem->GetVoiceFormatCommand(VoiceCmd, 128);
            if(!stricmp(VoiceCmd, "AT#VSM=130,8000"MDM_ENTER))
                unlink(m_szMessage);
        }
        
        StatusMsg("Playing voice message was finished");
        SetIdleProc();
    }
    else
    {
        StatusMsg("Playing voice message failed");
        m_Modem->TerminateWait();
        SetIdleProc();
    }
}

void CInteractiveVoiceSampleDlg::OnRecordProc(int event,long /*lParam*/)
{
        if( event == MFX_VREC_STARTED )
        {
                StatusMsg("Recording voice message was started");
				GetDlgItem(IDC_CLOSEPORT)->EnableWindow(FALSE);
        }
        else if( event == MFX_ONHOOK )
        {
                StatusMsg("Remote side has hanged up the line");
                m_Modem->TerminateWait();
        }
        else if( event == MFX_DTMF_RECEIVED )
        {
            StatusMsg("DTMF digit was received");
            m_Modem->TerminateWait();
        }
        else if( event == MFX_VREC_FINISHED )
        {
			DTMFINFO        dtmfInfo;
			m_Modem->GetReceivedDTMF(&dtmfInfo);
			CString str;
			str.Format("Received DTMF digit(s): [%s]", DTMF_DTMF((&dtmfInfo)));
			StatusMsg(str);
            StatusMsg("Recording voice message was finished.");
            if( m_Modem->GetModemType() == MOD_STANDARD_ROCKWELL )
            {
                char    szTemp[MAX_PATH];
                strcpy(szTemp,m_szMessage);
                SetExt(szTemp,"VOC");

                DEBUGMSG("VOC2WAV: [%s]-[%s]",m_szMessage,szTemp);
                ConvertVOC2WAV(m_szMessage,szTemp,4,FREQ_11025,MODE_SYNC);
                if( access(szTemp,04) == 0 )
                {
                    unlink(m_szMessage);
                    MoveFile(szTemp,m_szMessage);
                }
            }
            if( (m_Modem->GetModemType() == MOD_USR_SPORSTER) )
            {
                char VoiceCmd[128];
                m_Modem->GetVoiceFormatCommand(VoiceCmd, 128);
                if(!stricmp(VoiceCmd, "AT#VSM=130,8000"MDM_ENTER))
                {
                    char    szTemp[MAX_PATH];
                    strcpy(szTemp,m_szMessage);
                    SetExt(szTemp,"USR");

                    DEBUGMSG("IMAADPCM2WAV: [%s]-[%s]",m_szMessage,szTemp);
                    ConvertIMAADPCMtoPCM(m_szMessage,szTemp,MODE_SYNC);
                    if( access(szTemp,04) == 0 )
                    {
                        unlink(m_szMessage);
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

void CInteractiveVoiceSampleDlg::OnSendFaxProc(int event,long lParam)
{
    switch(m_nSubStatus)
    {
    case    snd_SWITCH:
        OnSendSwitch(event);
    break;

    case    snd_CONNECT:
        OnSendConnect(event);
        break;
    case    snd_SENDING:
        OnSendingFax(event);
        break;
    case    snd_RETURN:
        OnReturn2Voice(event);
		if( m_Modem->HangUp() )
		{
			m_nPrStatus = ivs_HANGUP;
			m_nSubStatus = 0;
		}
        break;
    }
}

void CInteractiveVoiceSampleDlg::OnSendSwitch(int event)
{
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

        StatusMsg("Opening fax port [%s].", szFaxIniFile);
        m_pPortFax = (PORTFAX)m_Modem->ConnectVoicePort(MODEM_SHORT_NAME,szFaxIniFile);

        if( m_pPortFax )
        {

            m_nSubStatus = snd_CONNECT;
        }
        else
        {
            Return2Voice();
        }
    }
    else
    {
        StatusMsg("Cannot switch to fax mode!");
        Return2Voice();
    }
}

void CInteractiveVoiceSampleDlg::OnSendConnect(int event)
{
    if( event == MFX_CONNECT )
    {
        StatusMsg("Modem is in fax mode");
    }
    else if( event == MFX_IDLE )
    {
        TSModemCapabiliti       MCap;

        StatusMsg("Sending fax...");

        GetModemCapabiliti( m_pPortFax, &MCap );
        MCap.Ecm = ECM_DISABLE;
        SetupPortCapabilities( m_pPortFax, &MCap );

        if( m_Modem->SendFaxNow((LONG)m_FaxObj) )
        {
            m_nSubStatus = snd_SENDING;
        }
        else
        {
            StatusMsg("Sendind fax failed");
            Return2Voice();
        }
    }
    else
    {
        Return2Voice();
    }
}

void CInteractiveVoiceSampleDlg::OnSendingFax(int event)
{
    if(event == MFX_STARTSEND)
    {
    }
    else if(event == MFX_IDLE)
    {
        Return2Voice();
    }
    else if( event == MFX_ENDSEND )
    {
        ClearFaxObj(m_FaxObj);
        m_FaxObj = NULL;
    }
    else if(event == MFX_TERMINATE)
    // you can gain here the result of the transmission
    {
        TSSessionParameters Params;
        GetSessionParameters(m_pPortFax,&Params);
        StatusMsg("Fax termination status: [%d]", Params.TStatus);
    }
}

void CInteractiveVoiceSampleDlg::OnReceiveFaxProc(int event,long lParam)
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
			if( m_Modem->HangUp() )
			{
				m_nPrStatus = ivs_HANGUP;
				m_nSubStatus = 0;
			}
            break;
        }
    }
}

void CInteractiveVoiceSampleDlg::OnReceiveSwitch(int event)
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

void CInteractiveVoiceSampleDlg::OnReceiveConnect(int event)
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

void CInteractiveVoiceSampleDlg::OnReceivingFax(int event)
{
    if(event == MFX_STARTRECEIVE)
    {
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

void CInteractiveVoiceSampleDlg::OnFaxReceived(FAXOBJ faxObj)
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

    unlink(szFaxFile);

    StatusMsg( "Saving received fax as:" );
    StatusMsg( szFaxFile );
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
            }
        }

        FAXOBJ fax2=faxObj;
        faxObj = GetNextFax(faxObj);
        ClearFaxObj(fax2);
    }
    StatusMsg("Number of fax pages received: [%d]", pages);
}

void CInteractiveVoiceSampleDlg::OnReturn2Voice(int event)
{
    switch(event)
    {
    case    MFX_CONNECT:
        StatusMsg("Fax port was destroyed");
        break;
    case    MFX_IDLE:
    case    MFX_ONHOOK:
    case    MFX_OFFHOOK:
    case    MFX_ENDSEND:
        break;
    case    MFX_MODEM_OK:
        StatusMsg("Modem is in voice mode again.");
        SetIdleProc();
        break;

    default:
        StatusMsg("Modem couldn't return to voice mode!");
        SetIdleProc();
    }
}

void CInteractiveVoiceSampleDlg::Return2Voice()
{
    m_nSubStatus = rec_RETURN;
    m_Modem->DisconnectVoicePort();
}

void CInteractiveVoiceSampleDlg::OnSendDTMFProc(int event,long /*lParam*/)
{
    if( event == MFX_MODEM_OK )
    {
        StatusMsg("DTMF digits were sent");
    }
    else
    {
        StatusMsg("Sending DTMF digits failed");
    }
    SetIdleProc();
}

void CInteractiveVoiceSampleDlg::OnReceiveDTMFProc(int event,long lParam)
{
    if( event == MFX_DTMF_RECEIVED )
    {
        DTMFINFO        dtmfInfo;
        m_Modem->GetReceivedDTMF(&dtmfInfo);
        StatusMsg("Received DTMF digits: [%s].", DTMF_DTMF((&dtmfInfo)));
    }
    else if( event == MFX_CALLING_TONE )
    {
        StatusMsg("Fax calling tone detected");
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

void CInteractiveVoiceSampleDlg::OnTransferProc(int event,long lParam)
{
    if( event == MFX_MODEM_OK )
    {
        EnableControls(TRUE, FALSE);
        StatusMsg("Call transfer was successful");
    }
    else
    {
        StatusMsg("Call transfer was not successful");
    }
    SetIdleProc();
}

void CInteractiveVoiceSampleDlg::OnGenerateToneProc(int event,long lParam)
{
    if( event == MFX_MODEM_OK )
    {
        StatusMsg("Tone generation was successful");
    }
    else
    {
        if( event != MFX_ONHOOK &&
            event != MFX_OFFHOOK )
        {
            StatusMsg("Tone generation was not successful");
        }
        else
        {
            return;
        }
    }
    SetIdleProc();
}

void CInteractiveVoiceSampleDlg::EnableControls(BOOL bEnabled1, BOOL bEnabled2)
{
    GetDlgItem(IDC_DIAL_NUMBER)->EnableWindow(bEnabled1);
    GetDlgItem(IDC_DIAL)->EnableWindow(bEnabled1);
    GetDlgItem(IDC_ANSWER)->EnableWindow(bEnabled1);
    
    GetDlgItem(IDC_STOP)->EnableWindow(bEnabled2);
    GetDlgItem(IDC_PLAYMSG)->EnableWindow(bEnabled2);
    GetDlgItem(IDC_SENDFAX)->EnableWindow(bEnabled2);
    GetDlgItem(IDC_RECMSG)->EnableWindow(bEnabled2);
    GetDlgItem(IDC_RECEIVEFAX)->EnableWindow(bEnabled2);
    GetDlgItem(IDC_HANGUP)->EnableWindow(bEnabled2);
    GetDlgItem(IDC_SEND_DTMF)->EnableWindow(bEnabled2);
    GetDlgItem(IDC_REC_DTMF)->EnableWindow(bEnabled2);
    GetDlgItem(IDC_GEN_TONE)->EnableWindow(bEnabled2);
    GetDlgItem(IDC_DETECTTONE)->EnableWindow(bEnabled2);

    GetDlgItem(IDC_TRANSFER)->EnableWindow(bEnabled2&&m_bTransfer);
	if(m_Modem && (m_Modem->GetModemType() == MOD_DIALOGIC)) 
		GetDlgItem(IDC_BLINDTRANSFER)->EnableWindow(bEnabled2&&m_bTransfer);
	else
		GetDlgItem(IDC_BLINDTRANSFER)->EnableWindow(FALSE);



    m_COMM.EnableWindow(!bEnabled1);
    m_BROOK.EnableWindow(!bEnabled1);
    m_DIALOGIC.EnableWindow(!bEnabled1);
    m_NMS.EnableWindow(!bEnabled1);
}

BOOL CInteractiveVoiceSampleDlg::CheckStatus()
{
    if( !m_Modem )
    {
        AfxMessageBox("Please open a port!");
        return FALSE;
    }

    if( m_nPrStatus != ivs_IDLE )
    {
        AfxMessageBox("Modem is in use. Please wait!");
        return FALSE;
    }

    return TRUE;
}

void CInteractiveVoiceSampleDlg::OnDestroy()
{
        CDialog::OnDestroy();
}

void CInteractiveVoiceSampleDlg::OnClose()
{
        // TODO: Add your message handler code here and/or call default
        CDialog::OnClose();
}

void CInteractiveVoiceSampleDlg::OnDial()
{
    if( !CheckStatus() )
    {
        return;
    }

    CString szNumber;

    m_edNumber.GetWindowText(szNumber);

    if( szNumber.GetLength() == 0 )
    {
        AfxMessageBox("Please specify a phone number!");
        return;
    }
    StatusMsg("Dialing...");
    if( m_Modem->DialInVoiceMode(szNumber,20) )
    {
        m_nPrStatus = ivs_DIAL;
    }
}

void CInteractiveVoiceSampleDlg::OnAnswer()
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

void CInteractiveVoiceSampleDlg::OnHangup()
{
    if( !CheckStatus() )
    {
        return;
    }

    if( m_Modem->HangUp() )
    {
        m_nPrStatus = ivs_HANGUP;
        m_nSubStatus = 0;
    }
}


void CInteractiveVoiceSampleDlg::OnPlaymsg()
{
    if( !CheckStatus() )
    {
        return;
    }

    CDlgSelectMsg dlg(this);

    dlg.m_Modem=m_Modem;

    if( dlg.DoModal() != IDOK )
    {
        return;
    }

    m_szMessage = dlg.m_szMessage;

    VOICEINFO   voiceInfo;
    char            szVocFile[MAX_PATH];

    strcpy(szVocFile,m_szMessage);
        if( m_Modem->GetModemType() == MOD_STANDARD_ROCKWELL )
        {
                SetExt(szVocFile,"VOC");

                DEBUGMSG("WAV2VOC: [%s]-[%s]",m_szMessage,szVocFile);
                ConvertWAV2VOC(m_szMessage,szVocFile,4,MODE_SYNC);
                if( access(szVocFile,04) == 0 )
                {
                    m_szMessage = szVocFile;
                }
                else
                {
                    return;
                }
        }
        if( (m_Modem->GetModemType() == MOD_USR_SPORSTER) )
        {
            char VoiceCmd[128];
            m_Modem->GetVoiceFormatCommand(VoiceCmd, 128);
            if(!stricmp(VoiceCmd, "AT#VSM=130,8000"MDM_ENTER))
            {
                SetExt(szVocFile,"USR");

                DEBUGMSG("WAV2IMAADPCM: [%s]-[%s]",m_szMessage,szVocFile);
                ConvertPCMtoIMAADPCM(m_szMessage,szVocFile,MODE_SYNC);
                if( access(szVocFile,04) == 0 )
                {
                    m_szMessage = szVocFile;
                }
                else
                {
                    return;
                }
            }
        }
        
        memset(&voiceInfo,0,sizeof(voiceInfo));
        // play this message
        strcpy(voiceInfo.szFilename,m_szMessage);
        VOICE_NUM((&voiceInfo))         = 1;
        // selected device is the line
        VOICE_DEVICE((&voiceInfo))  = MDM_LINE;

        if( m_Modem->PlayVoice(&voiceInfo) )
        {
            m_nPrStatus = ivs_PLAY;
            m_bRecFax   = FALSE;
        }
}

void CInteractiveVoiceSampleDlg::OnRecmsg()
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

void CInteractiveVoiceSampleDlg::OnSendfax()
{
    if( !CheckStatus() )
    {
        return;
    }

    CFileDialog dlgOpen(TRUE);
    char        szFaxFile[MAX_PATH];
    char        szInitDir[MAX_PATH];

    *szFaxFile = 0;
    sprintf(szInitDir,"%s\\Fax.in",g_szExePath);

    dlgOpen.m_ofn.hwndOwner = m_hWnd;
    dlgOpen.m_ofn.lpstrFilter = "TIFF Image (*.tif)\0*.tif\0";
    dlgOpen.m_ofn.lpstrFile = szFaxFile;
    dlgOpen.m_ofn.lpstrInitialDir = szInitDir;
    dlgOpen.m_ofn.lpstrDefExt = "tif";
    dlgOpen.m_ofn.lpstrTitle = "Select Fax Document";

    if( dlgOpen.DoModal() != IDOK )
    {
        return;
    }

    try
    {
        struct TSFaxParam       sFaxParam ;
        union TUFaxImage        FaxPage ;
        int                                     nImages;

        nImages = GetNumberOfImagesInTiffFile((char*)LPCSTR(szFaxFile));
        StatusMsg("Creating fax object. Number of pages: [%d]", nImages);

        if( !nImages )
        {
            StatusMsg("TIFF file is empty!");
            throw 1;
        }

        memset(&sFaxParam,0,sizeof(sFaxParam));
        sFaxParam.PageNum       = nImages;
        sFaxParam.Resolut       = RES_196LPI ;
        sFaxParam.Width         = PWD_1728;
        sFaxParam.Length        = PLN_NOCHANGE ;
        sFaxParam.Compress      = DCF_1DMH ;
        sFaxParam.Binary        = BFT_DISABLE;
        sFaxParam.BitOrder      = BTO_FIRST_LSB ;
        sFaxParam.DeleteFiles       = TRUE ;
        sFaxParam.Send          = TRUE ;
        sFaxParam.Ecm           = ECM_DISABLE;
        m_FaxObj = CreateSendFax('N',&sFaxParam);

        memset(&FaxPage,0,sizeof(FaxPage));
        FaxPage.File = szFaxFile;
        if ( m_FaxObj )
        {
            int             iError;
            bool    bOK = true;

            for( int iPage=0; iPage<nImages; iPage++ )
            {
                FaxPage.Dib = LoadImageIntoDIB( (char*)LPCSTR(szFaxFile), iPage, &iError );
                iError              = SetFaxImagePage(m_FaxObj, iPage, IMT_MEM_DIB, &FaxPage,  0);
                if( iError < 0 )
                {
                    MessageBeep( MB_ICONSTOP );
                    StatusMsg("SetFaxImagePage() failed" );
                    throw 1;
                }
            }
        }

        if( m_Modem->SetFaxSendMode(1) )
        {
            m_nPrStatus = ivs_SENDFAX;
            m_nSubStatus = snd_SWITCH;
        }
        else
        {
            StatusMsg("SetFaxSendMode() failed!");
            throw 1;
        }
    }
    catch(int)
    {
        if( m_FaxObj )
        {
            ClearFaxObj( m_FaxObj );
            m_FaxObj = NULL;
        }
    }
}

void CInteractiveVoiceSampleDlg::OnReceivefax()
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

void CInteractiveVoiceSampleDlg::OnSendDtmf()
{
    if( !CheckStatus() )
    {
        return;
    }

    cInputDialog dlg(this);
    char    szDTMF[MMOD_DTMF_LEN];
    char    *pszDialog      = "Send DTMF Code";
    char    *pszStatic      = "Enter DTMF code to send";

    dlg.SetFields(pszDialog,pszStatic,szDTMF,sizeof(szDTMF));
    if( dlg.DoModal() != IDOK )
    {
        return;
    }

    DTMFINFO dtmfInfo;

    memset(&dtmfInfo,0,sizeof(dtmfInfo));

    strcpy(DTMF_DTMF((&dtmfInfo)),szDTMF);
    DTMF_NUM((&dtmfInfo)) = 1;

    if( m_Modem->SendDTMF(&dtmfInfo) )
    {
        StatusMsg("Sending DTMF digits");
        m_nPrStatus = ivs_SENDDTMF;
    }
}

void CInteractiveVoiceSampleDlg::OnRecDtmf()
{
    if( !CheckStatus() )
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
        m_nPrStatus = ivs_RECDTMF;
    }
}

void CInteractiveVoiceSampleDlg::OnGenTone()
{
    if( !CheckStatus() )
    {
        return;
    }

    if(m_Modem->GetModemType() == MOD_BROOKTROUT) {
        StatusMsg("Brooktrout boards do not support tone generation.");
        return;
    }

    cGenerateTone   dlg(this);

    if( dlg.DoModal() != IDOK )
    {
        return;
    }

    short   nFreq1,nFreq2,nDuration;

        dlg.GetParameters(nFreq1,nFreq2,nDuration);

    if( m_Modem->GenerateToneSignal( nFreq1,nFreq2,nDuration,MDM_LINE) )
    {
        StatusMsg("Generating dual tone...");
        m_nPrStatus = ivs_GENTONE;
    }
}

void CInteractiveVoiceSampleDlg::OnStop()
{
    if( m_Modem )
    {
        if( m_nPrStatus == ivs_SENDFAX || m_nPrStatus == ivs_RECEIVEFAX )
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

void CInteractiveVoiceSampleDlg::OnTransfer()
{
    if( !CheckStatus() )
    {
        return;
    }

    CTransferDlg dlg(this);

    if( dlg.DoModal() != IDOK )
    {
        return;
    }

	if(bBlindTranser)
	{
		if( m_Modem->BlindTransferInboundCall(CTransferDlg::szNumber,
										 TRUE,
										 TRUE,
										 0,
										 "&",
										 "&") )
		{
			StatusMsg("Transfering call(blind transfer)...");
			m_nPrStatus = ivs_TRANSFER;
		}
	}
	else
	{
		if( m_Modem->TransferInboundCall(CTransferDlg::szNumber,
										 TRUE,
										 TRUE,
										 0,
										 "&",
										 "&") )
		{
			StatusMsg("Transfering call(supervised transfer...");
			m_nPrStatus = ivs_TRANSFER;
		}
	}

}

void CInteractiveVoiceSampleDlg::OnChelp()
{
    CDlgHelp dlg(this);

    dlg.DoModal();
}


void CInteractiveVoiceSampleDlg::OnCancel()
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


void CInteractiveVoiceSampleDlg::OnExit()
{
	if( m_Modem  )
		m_Modem->ClosePort();
    KillFaxMessage(m_hWnd);
        EndOfVoiceDriver( TRUE );
    EndOfFaxDriver( TRUE );
    TerminateCODEC();
}

void CInteractiveVoiceSampleDlg::StatusMsg(LPCSTR msg,...)
{
    char    szTemp[1024];
    va_list pArg;

    va_start(pArg,msg);
    vsprintf(szTemp, msg, pArg);
    m_lbStatus.AddString(szTemp);

    DEBUGMSG(szTemp);
    va_end(pArg);

    if(bAutoScroll) {
        m_lbStatus.SetTopIndex(m_lbStatus.GetCount()-1);
    }
}

void CInteractiveVoiceSampleDlg::OnComm()
{
    if( !m_Modem )
    {
        COpenComPort dlg(this);

        m_nPrStatus = ivs_OPENPORT;
        if( dlg.DoModal() == IDOK )
        {
            m_Modem = theApp.GetOpenModem();
            m_bTransfer=FALSE;
            EnableControls(TRUE, FALSE);
            StatusMsg("Modem is ready to originate a call or answer incoming calls.");
        }
        SetIdleProc();
    }
    else
    {
        AfxMessageBox("Port is already open!");
    }
}

void CInteractiveVoiceSampleDlg::OnBrook()
{
    if( !m_Modem )
    {
        CBrookOpen dlg(this);

        m_nPrStatus = ivs_OPENPORT;
        if( dlg.DoModal() == IDOK )
        {
            m_Modem = theApp.GetOpenModem();
            m_bTransfer=TRUE;
            EnableControls(TRUE, FALSE);
            StatusMsg("Modem is ready to originate a call or answer incoming calls");
        }
        SetIdleProc();
    }
    else
    {
        AfxMessageBox("Port is already opened");
    }
}

void CInteractiveVoiceSampleDlg::OnDialogic()
{
    if( !m_Modem )
    {
        CDialogicOpen   dlg(this);

        m_nPrStatus = ivs_OPENPORT;
        if( dlg.DoModal() == IDOK )
        {
            m_Modem = theApp.GetOpenModem();
            m_bTransfer=TRUE;
            EnableControls(TRUE, FALSE);
            StatusMsg("Modem is ready to originate a call or answer incoming calls");
        }
        SetIdleProc();
    }
    else
    {
        AfxMessageBox("Port is already open!");
    }
}

void CInteractiveVoiceSampleDlg::OnNms()
{
    if( !m_Modem )
    {
        CNMSOpen    dlg(this);

        m_nPrStatus = ivs_OPENPORT;
        if( dlg.DoModal() == IDOK )
        {
            m_Modem = theApp.GetOpenModem();
            m_bTransfer=TRUE;
            EnableControls(TRUE, FALSE);
            StatusMsg("Modem is ready to originate a call or answer incoming calls");
        }
        SetIdleProc();
    }
    else
    {
        AfxMessageBox("Port is already open!");
    }
}

BOOL CInteractiveVoiceSampleDlg::OnToolTips(UINT id,NMHDR * pTTTStruct,LRESULT * pResult)
{
    TOOLTIPTEXT *pTTT   = (TOOLTIPTEXT *)pTTTStruct;
    UINT        nID     = pTTTStruct->idFrom;

    if (pTTT->uFlags & TTF_IDISHWND)
    {
        // idFrom is actually the HWND of the tool
        nID = ::GetDlgCtrlID((HWND)nID);
        if(nID)
        {
            pTTT->lpszText = MAKEINTRESOURCE(nID);
            pTTT->hinst = AfxGetResourceHandle();
            return(TRUE);
        }
    }

        return(FALSE);
}

void CInteractiveVoiceSampleDlg::OnAutoscroll()
{
    if(((CButton*)GetDlgItem(IDC_AUTOSCROLL))->GetCheck())
        bAutoScroll = TRUE;
    else
        bAutoScroll = FALSE;


}

void CInteractiveVoiceSampleDlg::OnClearlistbox()
{
        m_lbStatus.ResetContent();
}

void CInteractiveVoiceSampleDlg::OnCopyclipboard()
{

    CString szText;
    int itemnum = m_lbStatus.GetCount();
    if( itemnum > 0 ) {
        for(int i = 0; i<itemnum; ++i) {
            CString temp;
            m_lbStatus.GetText(i, temp);
            szText+=temp;
            szText+="\r\n";
        }
    }

    void * pMem;
    HANDLE hMem = ::GlobalAlloc(GMEM_MOVEABLE | GMEM_DDESHARE, szText.GetLength());
    if(!hMem)
        return;
    pMem = ::GlobalLock(hMem);
    if(!pMem){
        GlobalFree(hMem);
        return;
    }
    memcpy(pMem, szText.GetBuffer(szText.GetLength()), szText.GetLength());
    szText.ReleaseBuffer();
    ::GlobalUnlock(hMem);
    if(!OpenClipboard()) {
        GlobalFree(hMem);
        return;
    }
    ::EmptyClipboard();
    if(::SetClipboardData(CF_TEXT, hMem) != hMem) {
        GlobalFree(hMem);
        return;
    }
    hMem = NULL;
    ::CloseClipboard();

}

void CInteractiveVoiceSampleDlg::OnBlindTransfer() 
{
	if(((CButton*)GetDlgItem(IDC_BLINDTRANSFER))->GetCheck())
        bBlindTranser = TRUE;
    else
        bBlindTranser = FALSE;
}

void CInteractiveVoiceSampleDlg::OnDetecttone() 
{
	if(m_Modem && (m_Modem->GetModemType() != MOD_DIALOGIC)) 	
    {
        AfxMessageBox("Custom tone detection is supported with Dialogic boards only.");
        return;
    }
    CDetectTone DetectToneDlg;
    DetectToneDlg.SetToneID(++LastCustomTone);
    if(DetectToneDlg.DoModal() == IDOK)
    {
        if(DetectToneDlg.GetToneType() == 0) //single tone frequency
        {
            TSSingleToneTemplate ToneDef;
            
   	        ToneDef.iFreq = DetectToneDlg.GetFreq1();
	        ToneDef.iFreqDeviation=DetectToneDlg.GetFreq1Dev();
            ToneDef.iDetectionMode=DetectToneDlg.GetDetectionMode();

            if(!mdm_TONEDET_CreateSingleFrequencyTone(m_Modem, LastCustomTone, ToneDef))
                AfxMessageBox("Cannot add custom tone!. Modem error: %d", mdm_GetLastError(m_Modem));
        }
        else //dual tone frequency
        {
            TSDualToneTemplate ToneDef;
            
   	        ToneDef.iFreq1 = DetectToneDlg.GetFreq1();
	        ToneDef.iFreqDeviation1=DetectToneDlg.GetFreq1Dev();
            ToneDef.iFreq2=DetectToneDlg.GetFreq2();
	        ToneDef.iFreqDeviation2=DetectToneDlg.GetFreq2Dev();
            ToneDef.iDetectionMode=DetectToneDlg.GetDetectionMode();

            if(!mdm_TONEDET_CreateDualFrequencyTone(m_Modem, LastCustomTone, ToneDef))
                AfxMessageBox("Cannot add custom tone!. Modem error: %d", mdm_GetLastError(m_Modem));

			StatusMsg("Custom tone %d has been added to the channel's tone list.", LastCustomTone);
        }
    }

}

void CInteractiveVoiceSampleDlg::OnCloseport() 
{
	if ( m_Modem )
	{
		m_Modem->HangUp();
		m_Modem->ClosePort();
		StatusMsg("Port/channel closed.");
		m_Modem->DestroyModemObject();
		theApp.DeleteOpenModem();
		m_Modem = NULL;
		EnableControls(FALSE,FALSE);
		GetDlgItem(IDC_CLOSEPORT)->EnableWindow(FALSE);
	}	
}
