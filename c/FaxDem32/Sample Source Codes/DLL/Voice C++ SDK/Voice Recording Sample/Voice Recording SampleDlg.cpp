// Voice Recording SampleDlg.cpp : implementation file
//

#include "stdafx.h"
#include <direct.h>
#include <io.h>

#include "Voice Recording Sample.h"
#include "Voice Recording SampleDlg.h"
#include "OpenComPort.h"
#include "cInpDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

typedef void(CVoiceRecordingSampleDlg::*VOCMSG)(int);

VOCMSG DocMems[] = {
    &CVoiceRecordingSampleDlg::OnIdleProc,
    &CVoiceRecordingSampleDlg::OnPlayProc,
    &CVoiceRecordingSampleDlg::OnRecordProc,
    &CVoiceRecordingSampleDlg::OnReInitializeProc
};


void SetExt(char *pszFile, const char *pszExt)
{
    if( *pszFile )
    {
    char	*pC = strrchr(pszFile,'.');

        if( pC )
        {
            if( pszExt )
            {
                strcpy( ++pC, pszExt);
            }
            else
            {
                *pC = 0;
            }
        }
        else
        {
            if( pszExt )
            {
                strcat(pszFile,".");
                strcat(pszFile,pszExt);
            }
            else
            {
                *pC = 0;
            }
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
// CVoiceRecordingSampleDlg dialog

CVoiceRecordingSampleDlg::CVoiceRecordingSampleDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CVoiceRecordingSampleDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CVoiceRecordingSampleDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
    m_nPrStatus = vrs_IDLE;
    m_bDoExit = FALSE;
    m_Modem = NULL;
    m_bDoExit = FALSE;
    m_bRecord = FALSE;
    m_bPlay = FALSE;
    m_bStarted = FALSE;
}

void CVoiceRecordingSampleDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CVoiceRecordingSampleDlg)
	DDX_Control(pDX, IDC_VOICE_FILES, m_Files);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CVoiceRecordingSampleDlg, CDialog)
	//{{AFX_MSG_MAP(CVoiceRecordingSampleDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_OPEN, OnOpen)
    ON_REGISTERED_MESSAGE(VoiceMsg,OnVoiceMsg)
	ON_BN_CLICKED(IDC_VOICE_PLAY, OnVoicePlay)
	ON_BN_CLICKED(IDC_VOICE_CREATE, OnVoiceCreate)
	ON_BN_CLICKED(IDC_VOICE_DELETE, OnVoiceDelete)
	ON_LBN_DBLCLK(IDC_VOICE_FILES, OnVoicePlay)
	ON_BN_CLICKED(IDC_VOICE_STOP, OnVoiceStop)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CVoiceRecordingSampleDlg message handlers

BOOL CVoiceRecordingSampleDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

    dlgMsg.Create(IDD_MESSAGE,this);
    
char    szTemp[MAX_PATH];

    sprintf(szTemp,"%s\\Voice",g_szExePath);
    _mkdir(szTemp);

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here
    StartCODEC(NULL,THREAD_PRIORITY_BELOW_NORMAL);
	SetupVoiceDriver(NULL);

    BOOL bDevice = theApp.GetProfileInt(g_szSection,g_DefInDev,0);
    CheckRadioButton(IDC_IN_HANDSET,IDC_IN_MIC,IDC_IN_HANDSET + bDevice);
    bDevice = theApp.GetProfileInt(g_szSection,g_DefOutDev,0);
    CheckRadioButton(IDC_OUT_HANDSET,IDC_OUT_SPEAKER,IDC_OUT_HANDSET + bDevice);

    PostMessage(WM_COMMAND,MAKELPARAM(IDC_OPEN,BN_CLICKED),(LPARAM)GetDlgItem(IDC_OPEN)->m_hWnd);

	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CVoiceRecordingSampleDlg::UpdateFileList()
{
HANDLE			hSearch;
WIN32_FIND_DATA	FindData;
char            szTemp[MAX_PATH];

    m_Files.ResetContent();

	sprintf( szTemp, "%s\\Voice\\*.WAV", g_szExePath);
	DEBUGMSG("Gathering voice files from folder: [%s]", szTemp);

	if( (hSearch = FindFirstFile(szTemp,&FindData)) != INVALID_HANDLE_VALUE )
	{
        SetExt(FindData.cFileName,NULL);
        m_Files.AddString(FindData.cFileName);
		
		while( FindNextFile( hSearch, &FindData) )
		{
            SetExt(FindData.cFileName,NULL);
			m_Files.AddString(FindData.cFileName);
		}
		FindClose( hSearch );
	}
	else
	{
		DEBUGMSG("GetLastError(): [%ld]", GetLastError());
	}
}
	
LRESULT CVoiceRecordingSampleDlg::OnVoiceMsg(WPARAM event, LPARAM /*lParam*/)
{
    (this->*DocMems[m_nPrStatus])(event);
    return 0;
}

void CVoiceRecordingSampleDlg::OnOpen() 
{
COpenComPort    dlg(this);

    if( dlg.DoModal() == IDOK )
    {
        m_Modem = dlg.m_Modem;
        m_Modem->SetVoiceMessage( m_hWnd );
        if(m_Modem->GetModemType() == MOD_LUCENT || m_Modem->GetModemType() == MOD_CIRRUSLOGIC){\
            CheckRadioButton(IDC_IN_HANDSET, IDC_IN_MIC, IDC_IN_MIC);
            CheckRadioButton(IDC_OUT_HANDSET, IDC_OUT_SPEAKER, IDC_OUT_SPEAKER);        
            ((CButton*)GetDlgItem(IDC_OUT_HANDSET))->EnableWindow(FALSE);
            ((CButton*)GetDlgItem(IDC_OUT_SPEAKER))->EnableWindow(FALSE);
            ((CButton*)GetDlgItem(IDC_IN_HANDSET))->EnableWindow(FALSE);
            ((CButton*)GetDlgItem(IDC_IN_MIC))->EnableWindow(FALSE);
        }
        UpdateFileList();
    }
    else
    {
        CDialog::OnCancel();
    }
}

void CVoiceRecordingSampleDlg::OnExit()
{
	EndOfVoiceDriver( TRUE );
    TerminateCODEC();
}

void CVoiceRecordingSampleDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CVoiceRecordingSampleDlg::OnPaint() 
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

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CVoiceRecordingSampleDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CVoiceRecordingSampleDlg::SetIdle()
{
    // no active voice record/playback
    m_bStarted = FALSE;
    m_bPlay = FALSE;
    m_bRecord = FALSE;

    if( m_bDoExit )
    {
        OnExit();
        SaveOptions();
        CDialog::OnCancel();
    }
    m_nPrStatus = vrs_IDLE;
    EnableControls();
}

void CVoiceRecordingSampleDlg::OnIdleProc(int event)
{
}

void CVoiceRecordingSampleDlg::OnVoicePlay() 
{
int nMessage = m_Files.GetCurSel();

	if( nMessage > -1 )
	{
	int	nLine	= IsDlgButtonChecked(IDC_OUT_HANDSET) == BST_CHECKED  ? MDM_HANDSET : MDM_SPEAKER;

        m_bPlay = TRUE;
		if( nLine != m_Modem->GetSelectedLine() )
		{
			m_nCurrDevice = nLine;
			ReInitializePort();
		}
		else
		{
			PlayVoice();
		}
	}
}

void CVoiceRecordingSampleDlg::PlayVoice()
{
int nIndex = m_Files.GetCurSel();

    if( nIndex < 0 )
    {
        return;
    }

VOICEINFO   voiceInfo;
char		szVocFile[MAX_PATH];

    m_Files.GetText(nIndex,szVocFile);
    sprintf(m_szVocFile,"%s\\Voice\\%s.WAV",g_szExePath,szVocFile);

    strcpy(szVocFile,m_szVocFile);
	if( m_Modem->GetModemType() == MOD_STANDARD_ROCKWELL )
	{
		SetExt(szVocFile,"VOC");

		DEBUGMSG("WAV2VOC: [%s]-[%s]",m_szVocFile,szVocFile);
		ConvertWAV2VOC(m_szVocFile,szVocFile,4,MODE_SYNC);
		if( access(szVocFile,04) == 0 )
        {
            strcpy(m_szVocFile,szVocFile);
        }
        else
        {
            return;
		}
	}
	if( m_Modem->GetModemType() == MOD_USR_SPORSTER || m_Modem->GetModemType() == MOD_LUCENT)
	{
		SetExt(szVocFile,"USR");

		ConvertPCMtoIMAADPCM(m_szVocFile,szVocFile,MODE_SYNC);
		if( access(szVocFile,04) == 0 )
        {
            strcpy(m_szVocFile,szVocFile);
        }
        else
        {
            return;
		}
	}


    memset(&voiceInfo,0,sizeof(voiceInfo));
    // play this message
    strcpy(voiceInfo.szFilename,m_szVocFile);
    // selected device is the line
    VOICE_DEVICE((&voiceInfo))	= IsDlgButtonChecked(IDC_OUT_HANDSET) == BST_CHECKED ? MDM_HANDSET : MDM_SPEAKER;

    if( m_Modem->PlayVoice(&voiceInfo) )
    {
        m_nPrStatus = vrs_PLAY;
    }

    EnableControls();
}

void CVoiceRecordingSampleDlg::OnPlayProc(int event)
{
	if( event == MFX_VPLAY_STARTED )
	{
        DEBUGMSG("Playing greeting message started.");
        dlgMsg.ShowWindow(SW_HIDE);
        m_bStarted = TRUE;
    }
    else if( event == MFX_ONHOOK )
    {
        if( m_bStarted )
        {
            m_Modem->TerminateWait();
        }
        else
        {
            if( m_nCurrDevice == MDM_HANDSET )
            {
                dlgMsg.m_edMsg.SetWindowText("Pick up the handset");
                dlgMsg.ShowWindow(SW_SHOW);
            }
        }
    }
    else if( event == MFX_OFFHOOK )
    {
        if( !m_bStarted && m_nCurrDevice == MDM_HANDSET )
        {
            dlgMsg.m_edMsg.SetWindowText("Hang up the handset");
            dlgMsg.ShowWindow(SW_SHOW);
        }
    }
    else if( event == MFX_VPLAY_FINISHED )
    {
        m_bPlay = FALSE;
        m_bStarted = FALSE;
        dlgMsg.ShowWindow(SW_HIDE);
        DEBUGMSG("Playing greeting message finished");
		if( m_Modem->GetModemType() == MOD_STANDARD_ROCKWELL || m_Modem->GetModemType() == MOD_USR_SPORSTER || m_Modem->GetModemType() == MOD_LUCENT)
		{
			unlink(m_szVocFile);
		}

        SetIdle();
    }
    else
    {
        m_bPlay = FALSE;
        m_bStarted = FALSE;
        dlgMsg.ShowWindow(SW_HIDE);
        DEBUGMSG("Error occured while playing greeting message");
		if( m_Modem->GetModemType() == MOD_STANDARD_ROCKWELL || m_Modem->GetModemType() == MOD_USR_SPORSTER || m_Modem->GetModemType() == MOD_LUCENT)
		{
			unlink(m_szVocFile);
		}
        ReInitializePort();
    }
}

void CVoiceRecordingSampleDlg::OnVoiceCreate() 
{
cInputDialog dlg(this);
char    szName[MAX_PATH];
char    *pszDialog	= "Record Filename";
char    *pszStatic	= "Enter filename";

	dlg.SetFields(pszDialog,pszStatic,szName,MAX_PATH);
	if( dlg.DoModal() == IDOK )
	{
	int	nLine	= IsDlgButtonChecked(IDC_IN_HANDSET) == BST_CHECKED ? MDM_HANDSET : MDM_MICROPHONE;

        sprintf(m_szVocFile,"%s\\Voice\\%s.WAV",g_szExePath,szName);
        

        m_bRecord = TRUE;
		if( nLine != m_Modem->GetSelectedLine() )
		{
			m_nCurrDevice = nLine;
			ReInitializePort();
		}
		else
		{
			RecordVoice();
		}
	}
}

void CVoiceRecordingSampleDlg::RecordVoice()
{
VOICEINFO   VoiceInfo;

    memset(&VoiceInfo,0,sizeof(VOICEINFO));
    strcpy(VOICE_FILE((&VoiceInfo)),m_szVocFile);
    VOICE_DEVICE((&VoiceInfo))	= IsDlgButtonChecked(IDC_IN_HANDSET) == BST_CHECKED ? MDM_HANDSET : MDM_MICROPHONE;
    VOICE_TIME((&VoiceInfo))	= theApp.GetProfileInt(g_szSection,g_szRecTime,60);

    // record tone
    strcpy(VOICE_DTMF((&VoiceInfo)),"beep");

    if( m_Modem->RecordVoice(&VoiceInfo) )
    {
        m_nPrStatus = vrs_RECORD;
    }

    EnableControls();
}

void CVoiceRecordingSampleDlg::OnRecordProc(int event)
{
	if( event == MFX_VREC_STARTED )
	{
        dlgMsg.ShowWindow(SW_HIDE);
		DEBUGMSG("Recording voice mail started.");
        m_bStarted = TRUE;
	}
    else if( event == MFX_ONHOOK )
    {
        if( m_bStarted )
        {
            m_Modem->TerminateWait();
        }
        else
        {
            if( m_nCurrDevice == MDM_HANDSET )
            {
                dlgMsg.m_edMsg.SetWindowText("Pick up the handset");
                dlgMsg.ShowWindow(SW_SHOW);
            }
        }
    }
    else if( event == MFX_OFFHOOK )
    {
        if( !m_bStarted && m_nCurrDevice == MDM_HANDSET )
        {
            dlgMsg.m_edMsg.SetWindowText("Hang up the handset");
            dlgMsg.ShowWindow(SW_SHOW);
        }
    }
	else if( event == MFX_VREC_FINISHED )
	{
        m_bStarted = FALSE;
        dlgMsg.ShowWindow(SW_HIDE);
		DEBUGMSG("Recording voice mail finished.");
		if( m_Modem->GetModemType() == MOD_STANDARD_ROCKWELL )
		// convert this message to wav
		{
		char	szTemp[MAX_PATH];

			strcpy(szTemp,m_szVocFile);
			SetExt(szTemp,"VOC");

			DEBUGMSG("VOC2WAV: [%s]-[%s]",m_szVocFile,szTemp);
			ConvertVOC2WAV(m_szVocFile,szTemp,4,FREQ_11025,MODE_SYNC);
			if( access(szTemp,04) == 0 )
			{
				unlink(m_szVocFile);
				MoveFile(szTemp,m_szVocFile);
			}
        }
        if( m_Modem->GetModemType() == MOD_USR_SPORSTER || m_Modem->GetModemType() == MOD_LUCENT)
            
		{
		    char	szTemp[MAX_PATH];

			strcpy(szTemp,m_szVocFile);
			SetExt(szTemp,"USR");

			ConvertIMAADPCMtoPCM(m_szVocFile,szTemp,MODE_SYNC);
			if( access(szTemp,04) == 0 )
			{
				unlink(m_szVocFile);
				MoveFile(szTemp,m_szVocFile);
			}
        }
        UpdateFileList();
        SetIdle();
	}
	else if( event == MFX_ERROR )
	{
        m_bRecord = FALSE;
        dlgMsg.ShowWindow(SW_HIDE);
        DEBUGMSG("Error occurec while recording voice mail");
		ReInitializePort();
	}
}

void CVoiceRecordingSampleDlg::ReInitializePort()
{
    DEBUGMSG("Reinitializing modem");

    // no active voice record/playback
    m_bStarted = FALSE;

    EnableControls();
    
    m_nSubStatus = 0;
    m_nPrStatus = vrs_REINIT;
    m_Modem->HangUp();
}

void CVoiceRecordingSampleDlg::OnReInitializeProc(int event)
{
    if( m_nSubStatus == 0 )
    {
        if( event == MFX_MODEM_OK )
        {
            m_nSubStatus = 1;
            m_Modem->InitializeModem();
        }
        else
        {
            DEBUGMSG("Reinitializing modem failed");
            SaveOptions();
            //CDialog::OnCancel();
        }
    }
    else
    {
        if( event == MFX_MODEM_OK )
        {
            DEBUGMSG("Modem successfully reinitialized.");
            DEBUGMSG("============================================");
            if( !m_bDoExit )
            {
                if( m_bRecord )
                {
                    RecordVoice();
                }
                else if( m_bPlay )
                {
                    PlayVoice();
                }
                else
                {
		            m_Modem->WaitForRings(-1);
                    SetIdle();
                }
            }
            else
            {
                SaveOptions();
                CDialog::OnCancel();
            }
        }
        else
        {
            DEBUGMSG("Reinitializing modem failed");
            SaveOptions();
            CDialog::OnCancel();
        }
    }
}

void CVoiceRecordingSampleDlg::OnCancel() 
{
    if( m_nPrStatus == vrs_IDLE )
    {
        m_bDoExit = TRUE;
	    ReInitializePort();
    }
    else
    {
        m_Modem->TerminateWait();
        m_bDoExit = TRUE;
    }
}

void CVoiceRecordingSampleDlg::OnVoiceDelete() 
{
int nIndex = m_Files.GetCurSel();

    if( nIndex < 0 )
    {
        return;
    }

    if( AfxMessageBox("Do you really want to delete selected message?", MB_YESNO) == IDYES )
    {
    char    szName[MAX_PATH];

        m_Files.GetText(nIndex,szName);
        sprintf(m_szVocFile,"%s\\Voice\\%s.WAV",g_szExePath,szName);
        unlink(m_szVocFile);

        UpdateFileList();
    }
}

void CVoiceRecordingSampleDlg::OnVoiceStop() 
{
    m_Modem->TerminateWait();
}

void CVoiceRecordingSampleDlg::SaveOptions()
{
    theApp.WriteProfileInt(g_szSection,g_DefInDev,IsDlgButtonChecked(IDC_IN_MIC));
    theApp.WriteProfileInt(g_szSection,g_DefOutDev,IsDlgButtonChecked(IDC_OUT_SPEAKER));
}

void CVoiceRecordingSampleDlg::EnableControls()
{
BOOL bEnable = m_nPrStatus == vrs_IDLE;

    GetDlgItem(IDC_VOICE_PLAY)->EnableWindow(bEnable);
    GetDlgItem(IDC_VOICE_CREATE)->EnableWindow(bEnable);
    GetDlgItem(IDC_VOICE_DELETE)->EnableWindow(bEnable);
    GetDlgItem(IDCANCEL)->EnableWindow(bEnable);
    if(m_Modem->GetModemType() != MOD_LUCENT && m_Modem->GetModemType() != MOD_CIRRUSLOGIC){
        GetDlgItem(IDC_IN_HANDSET)->EnableWindow(bEnable);
        GetDlgItem(IDC_IN_MIC)->EnableWindow(bEnable);
        GetDlgItem(IDC_OUT_HANDSET)->EnableWindow(bEnable);
        GetDlgItem(IDC_OUT_SPEAKER)->EnableWindow(bEnable);
    }

    GetDlgItem(IDC_VOICE_STOP)->EnableWindow(!bEnable);
}
