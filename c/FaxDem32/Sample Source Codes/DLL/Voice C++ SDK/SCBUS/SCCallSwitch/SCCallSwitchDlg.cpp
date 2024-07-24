// SCCallSwitchDlg.cpp : implementation file
//

#include "stdafx.h"
#include "SCCallSwitch.h"
#include "SCCallSwitchDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


extern "C" {
    #include "bitiff.h"
}
#include "DlgHelp.h"
#define MODEM_SHORT_NAME    "GCLASS1(VOICE)"
// registered message from Voice/Fax C++
UINT VoiceMsg = RegisterWindowMessage(REG_FAXMESSAGE);

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
// CSCCallSwitchDlg dialog

CSCCallSwitchDlg::CSCCallSwitchDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CSCCallSwitchDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CSCCallSwitchDlg)
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
    m_hLineHandle   = -1;
    m_hVoiceHandle  = -1;
    m_hLineHandle2  = -1;
    m_hVoiceHandle2 = -1;
    
    m_hModemObj     =  0;
    m_hModemObj2    =  0;
    m_n_States      =  STATE_STARTING;

    bExit           =  false;
    bStop           =  false;

    bLine1Connected =  false;
    bLine2Connected =  false;

}

void CSCCallSwitchDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CSCCallSwitchDlg)
	DDX_Control(pDX, IDC_VOICERES2, m_cbVoiceRes2);
	DDX_Control(pDX, IDC_PROTOCOL2, m_eProtocol2);
	DDX_Control(pDX, IDC_LINETYPE2, m_cbLineType2);
	DDX_Control(pDX, IDC_LINERES2, m_cbLineRes2);
	DDX_Control(pDX, IDC_PROTOCOL, m_eProtocol);
	DDX_Control(pDX, IDC_LINETYPE, m_cbLineType);
	DDX_Control(pDX, IDC_VOICERES, m_cbVoiceRes);
	DDX_Control(pDX, IDC_LINERES , m_cbLineRes);
	DDX_Control(pDX, IDC_MESSAGES, m_lbMessages);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CSCCallSwitchDlg, CDialog)
	//{{AFX_MSG_MAP(CSCCallSwitchDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_CBN_SELCHANGE(IDC_LINETYPE, OnSelchangeLinetype)
	ON_BN_CLICKED(IDC_CLEAR, OnClear)
	ON_BN_CLICKED(IDC_COPY, OnCopy)
	ON_BN_CLICKED(IDC_HELP, OnHelp)
	ON_CBN_SELCHANGE(IDC_LINETYPE2, OnSelchangeLinetype2)
	ON_BN_CLICKED(IDC_HANGUP1, OnHangup1)
	ON_BN_CLICKED(IDC_HANGUP2, OnHangup2)
	ON_BN_CLICKED(IDC_BUTTON1, OnStart)
	ON_BN_CLICKED(IDC_STOPWAIT, OnStopwait)
    ON_REGISTERED_MESSAGE(VoiceMsg,OnVoiceMsg)
	ON_WM_DESTROY()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSCCallSwitchDlg message handlers

BOOL CSCCallSwitchDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

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
	
    
    EnableToolTips(TRUE);
    SetupFaxDriver(NULL);
    SetupVoiceDriver(NULL);
    SetRuningMode(RNM_ALWAYSFREE);
    SetFaxMessage(m_hWnd);

    SetForegroundWindow();

//let's set the resource routing mode to manual, so we can specify how we want to
//route resources
    mdm_SCBUS_SetResourceRoutingMode(SCBUS_RESOURCE_ROUTING_MANUAL);
//check for line interface resources
    char* szBuffer=0;
    int buffersize=0;
//first we have to query the size of the buffer which can accomodate the names of all
//line interface resource
    if(mdm_SCBUS_EnumerateResources(NULL, &buffersize, SCBUS_RESOURCE_TYPE_LINEINTERFACE)==SCBUS_SUCCESS) 
    {
        if(buffersize>0) {
            szBuffer = new char[buffersize];
            if(szBuffer) {
                szBuffer[0]=0;
                char *temp=szBuffer;
                mdm_SCBUS_EnumerateResources(szBuffer, &buffersize, SCBUS_RESOURCE_TYPE_LINEINTERFACE);
                while(strlen(temp)>0) {
                    if(mdm_SCBUS_GetResourceStatus(temp, SCBUS_RESOURCE_TYPE_LINEINTERFACE)==SCBUS_RESOURCE_AVAILABLE){
                        m_cbLineRes.AddString(temp);
						m_cbLineRes2.AddString(temp);

                    }
                    temp=temp + strlen(temp)+1;
                }
                m_cbLineRes.SetCurSel(0);
				m_cbLineRes2.SetCurSel(0);

                delete [] szBuffer;
            }

        }
    }
    else {
        //without line interface resources there is no way to send faxes, we have to exit the program
        AfxMessageBox("No Line Interface resource has been detected. In order to run this sample, you need to have at least one Dialogic line interface resource.");        
        OnCancel();
        return TRUE;
    }
    
    m_cbVoiceRes.AddString("No voice resource is needed");
    m_cbVoiceRes.SetCurSel(0);
    m_cbVoiceRes2.AddString("No voice resource is needed");
	m_cbVoiceRes2.SetCurSel(0);

    if(mdm_SCBUS_EnumerateResources(NULL, &buffersize, SCBUS_RESOURCE_TYPE_VOICE)==SCBUS_SUCCESS) 
    {
        if(buffersize>0) {
            szBuffer = new char[buffersize];
            if(szBuffer) {
                szBuffer[0]=0;
                char *temp=szBuffer;
                mdm_SCBUS_EnumerateResources(szBuffer, &buffersize, SCBUS_RESOURCE_TYPE_VOICE);
                while(strlen(temp)>0) {
                    if(mdm_SCBUS_GetResourceStatus(temp, SCBUS_RESOURCE_TYPE_VOICE)==SCBUS_RESOURCE_AVAILABLE){
                        m_cbVoiceRes.AddString(temp);
						m_cbVoiceRes2.AddString(temp);
                    }
                    temp=temp + strlen(temp)+1;
                }
                m_cbVoiceRes.SetCurSel(0);
				m_cbVoiceRes2.SetCurSel(0);
                delete [] szBuffer;
            }
 
        }
    }

    m_cbLineType.SetCurSel(0);
    m_eProtocol.EnableWindow(FALSE);
    m_cbLineType2.SetCurSel(0);
    m_eProtocol2.EnableWindow(FALSE);

    EnableControls(TRUE);
    GetDlgItem(IDC_HANGUP1)->EnableWindow(FALSE);
    GetDlgItem(IDC_HANGUP2)->EnableWindow(FALSE);
    GetDlgItem(IDC_BUTTON1)->EnableWindow(TRUE);
    GetDlgItem(IDC_STOPWAIT)->EnableWindow(FALSE);
    OnSelchangeLinetype();
    OnSelchangeLinetype2();

    StatusMsg("Please select the resources you want to use and press the Wait for a call button");
    
    m_n_States = STATE_STARTING;
	return TRUE;  // return TRUE  unless you set the focus to a control
}



void CSCCallSwitchDlg::CloseResources()
{
    StatusMsg("Closing resources...");
    if(m_hLineHandle != -1) {
        if(m_hVoiceHandle != -1)
            mdm_SCBUS_ListenTo(m_hLineHandle, m_hVoiceHandle, SCBUS_FULLDUPLEX);
        mdm_SCBUS_DetachResourceFromMODEMOBJ(m_hModemObj, m_hLineHandle);
        mdm_SCBUS_CloseResource(m_hLineHandle);
        m_hLineHandle = -1;
    }
    if(m_hVoiceHandle != -1) {
        mdm_SCBUS_DetachResourceFromMODEMOBJ(m_hModemObj, m_hVoiceHandle);
        mdm_SCBUS_CloseResource(m_hVoiceHandle);
        m_hVoiceHandle = -1;
    }
    
    mdm_DestroyModemObject(m_hModemObj);
    m_hModemObj = NULL;

    if(m_hLineHandle2 != -1) {
        if(m_hVoiceHandle2 != -1)
            mdm_SCBUS_ListenTo(m_hLineHandle2, m_hVoiceHandle2, SCBUS_FULLDUPLEX);
        mdm_SCBUS_DetachResourceFromMODEMOBJ(m_hModemObj2, m_hLineHandle2);
        mdm_SCBUS_CloseResource(m_hLineHandle2);
        m_hLineHandle2 = -1;
    }
    if(m_hVoiceHandle2 != -1) {
        mdm_SCBUS_DetachResourceFromMODEMOBJ(m_hModemObj2, m_hVoiceHandle2);
        mdm_SCBUS_CloseResource(m_hVoiceHandle2);
        m_hVoiceHandle2 = -1;
    }
    
    mdm_DestroyModemObject(m_hModemObj2);
    m_hModemObj2 = NULL;

    bLine1Connected = false;
    bLine2Connected = false;

    bStop           = false;

    EnableControls(TRUE);
    GetDlgItem(IDC_HANGUP1)->EnableWindow(FALSE);
    GetDlgItem(IDC_HANGUP2)->EnableWindow(FALSE);
    GetDlgItem(IDC_BUTTON1)->EnableWindow(TRUE);
    GetDlgItem(IDC_STOPWAIT)->EnableWindow(FALSE);
    OnSelchangeLinetype();
    OnSelchangeLinetype2();
    m_n_States = STATE_STARTING;
    if(bExit)	
        CDialog::OnCancel();
    else
        StatusMsg("Please select the resources you want to use and press the Wait for a call button");
}

long CSCCallSwitchDlg::OnVoiceMsg(WPARAM event,LPARAM lParam)
{
    BOOL bError = FALSE;
    switch(event)
    {
        case MFX_ERROR:
            return 0;
        case MFX_MODEM_OK:
            if(m_n_States == STATE_WAITING_FOR_CALL2)  {
                StatusMsg("Call was disconnected.");
                if(bStop)
                    CloseResources();
                else
                    m_n_States = STATE_WAITING_FOR_CALL1;
            }
            if(m_n_States == STATE_CONNECTED) {
                StatusMsg("Call was disconnected.");
                m_n_States = STATE_WAITING_FOR_CALL2;
            }
            return 0;
        case    MFX_MODEM_RING:
            StatusMsg("Incoming call was detected.");
            if(m_n_States == STATE_WAITING_FOR_CALL1)
                m_n_States = STATE_ANSWERING_CALL1;
            else if(m_n_States == STATE_WAITING_FOR_CALL2)
                m_n_States = STATE_ANSWERING_CALL2;
            if((long)lParam == (long)m_hModemObj) {
                bLine1Connected = true;
                m_hModemObj->OnlineAnswer();
            }
            else if((long)lParam == (long)m_hModemObj2) {
                bLine2Connected = true;
                m_hModemObj2->OnlineAnswer();
            }
            else
                StatusMsg("Incoming call on an unidentified resource.");
        break;
        case    MFX_VOICE_CONNECT:
            if(m_n_States == STATE_ANSWERING_CALL1)
            {
                StatusMsg("Call was answered, waiting for second call.");
                m_n_States = STATE_WAITING_FOR_CALL2;
                GetDlgItem(IDC_HANGUP1)->EnableWindow(TRUE);
            }
            else if(m_n_States == STATE_ANSWERING_CALL2)
            {
                m_n_States = STATE_CONNECTED;
                StatusMsg("Call was answered, connecting calls...");
                if(m_hVoiceHandle!=-1 )
                    mdm_SCBUS_StopListeningTo(m_hLineHandle, m_hVoiceHandle, SCBUS_FULLDUPLEX);
                if(m_hVoiceHandle2!=-1 )
                    mdm_SCBUS_StopListeningTo(m_hLineHandle2, m_hVoiceHandle2, SCBUS_FULLDUPLEX);
                mdm_SCBUS_ListenTo(m_hLineHandle, m_hLineHandle2, SCBUS_FULLDUPLEX);
                GetDlgItem(IDC_HANGUP2)->EnableWindow(TRUE);
            }
    }
    return 0;
}


void CSCCallSwitchDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CSCCallSwitchDlg::OnPaint() 
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
HCURSOR CSCCallSwitchDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CSCCallSwitchDlg::StatusMsg(LPCSTR msg,...)
{
    char    szTemp[1024];
    va_list pArg;

    va_start(pArg,msg);
    vsprintf(szTemp, msg, pArg);
    m_lbMessages.AddString(szTemp);
    va_end(pArg);

    m_lbMessages.SetTopIndex(m_lbMessages.GetCount()-1);
}

void CSCCallSwitchDlg::OnSelchangeLinetype() 
{
  	int nIndex = m_cbLineType.GetCurSel();

    if(nIndex == 0 || nIndex == 1){
        m_eProtocol.EnableWindow(FALSE);
        m_eProtocol.SetWindowText("");
    }
    else {
        m_eProtocol.EnableWindow(TRUE);
        m_eProtocol.SetWindowText("us_mf_io");
    }

}

bool CSCCallSwitchDlg::OpenCall1Resources()
{
    CString szLineResName;
    int linetype = LINETYPE_ANALOG;
    if(m_n_States <= STATE_OPENINGPORTS) {
        StatusMsg("Opening resources...");
        if(m_hLineHandle == -1) {
            m_cbLineRes.GetLBText( m_cbLineRes.GetCurSel(), szLineResName );
   
            int nIndex = m_cbLineType.GetCurSel();

            CString protocol;

            switch (nIndex){
                default:
                case 0:
                    linetype = LINETYPE_ANALOG;
                    break;
                case 1:
                    linetype = LINETYPE_ISDN;
                    break;
                case 2:
                    linetype = LINETYPE_T1;
                    m_eProtocol.GetWindowText(protocol);
                    break;
                case 3:
                    linetype = LINETYPE_E1;
                    m_eProtocol.GetWindowText(protocol);
                    break;
            }
            if(mdm_SCBUS_OpenResource( szLineResName.GetBuffer(128), &m_hLineHandle, SCBUS_RESOURCE_TYPE_LINEINTERFACE, linetype, protocol.GetBuffer(32))!=SCBUS_SUCCESS)
            {
                StatusMsg("Opening line interface resource: %s has failed", szLineResName.GetBuffer(128));
                CloseResources();
                return false;
            }
        }

        CString szVoiceResName;
        if(m_hVoiceHandle == -1) {
            m_cbVoiceRes.GetLBText( m_cbVoiceRes.GetCurSel(), szVoiceResName );
            if(szVoiceResName != "No voice resource is needed") {
                if((linetype == LINETYPE_ANALOG) && (( szVoiceResName != szLineResName )))
                {
                    AfxMessageBox("With analog lines the line interface recource should be the same as the voice resource.!");
                    CloseResources();
                    return false;  
                }
                if(mdm_SCBUS_OpenResource( szVoiceResName.GetBuffer(128), &m_hVoiceHandle, SCBUS_RESOURCE_TYPE_VOICE, 0, 0)!=SCBUS_SUCCESS)
                {
                    StatusMsg("Opening voice resource: %s has failed", szVoiceResName.GetBuffer(128));
                    CloseResources();
                    return false;
                }
            }
            else {
                if((linetype == LINETYPE_ANALOG))
                {
                    AfxMessageBox("With analog lines the line interface recource should be the same as the voice resource!");
                    CloseResources();
                    return false;
                }
                else if((linetype == LINETYPE_T1))
                {
                    AfxMessageBox("With T1 or E1 digital lines you must to specify a voice resource!");
                    CloseResources();
                    return false;
                }
            }
        }

        if(m_hVoiceHandle != -1)
        {
            if(mdm_SCBUS_ListenTo(m_hLineHandle, m_hVoiceHandle, SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
            {
                StatusMsg("Cannot route voice resource to the line interface.");
                CloseResources();
                return false;
            }
        }
  
        m_hModemObj = mdm_CreateModemObject(MOD_DIALOGIC);
        if(!m_hModemObj) 
        {
            StatusMsg("Creating modem object failed");
            CloseResources();
            return false;
        }
    
        if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hModemObj, m_hLineHandle)!=SCBUS_SUCCESS) {
            StatusMsg("Cannot attach line interface resource to modem object");
            CloseResources();
            return false;
        }

        if(m_hVoiceHandle != -1) {
            if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hModemObj, m_hVoiceHandle)!=SCBUS_SUCCESS) {
                StatusMsg("Cannot attach voice resource to modem object");
                CloseResources();
                return false;
            }
        }
        //m_n_States = STATE_DIALING;    
    }
    return true;
}


bool CSCCallSwitchDlg::OpenCall2Resources()
{
    CString szLineResName;
    int linetype = LINETYPE_ANALOG;
    if(m_n_States <= STATE_OPENINGPORTS) {
        if(m_hLineHandle2 == -1) {
            m_cbLineRes.GetLBText( m_cbLineRes2.GetCurSel(), szLineResName );
   
            int nIndex = m_cbLineType2.GetCurSel();

            CString protocol;

            switch (nIndex){
                default:
                case 0:
                    linetype = LINETYPE_ANALOG;
                    break;
                case 1:
                    linetype = LINETYPE_ISDN;
                    break;
                case 2:
                    linetype = LINETYPE_T1;
                    m_eProtocol.GetWindowText(protocol);
                    break;
                case 3:
                    linetype = LINETYPE_E1;
                    m_eProtocol.GetWindowText(protocol);
                    break;
            }
            if(mdm_SCBUS_OpenResource( szLineResName.GetBuffer(128), &m_hLineHandle2, SCBUS_RESOURCE_TYPE_LINEINTERFACE, linetype, protocol.GetBuffer(32))!=SCBUS_SUCCESS)
            {
                StatusMsg("Opening line interface resource: %s has failed", szLineResName.GetBuffer(128));
                CloseResources();
                return false;
            }
        }

        CString szVoiceResName;
        if(m_hVoiceHandle2 == -1) {
            m_cbVoiceRes.GetLBText( m_cbVoiceRes2.GetCurSel(), szVoiceResName );
            if(szVoiceResName != "No voice resource is needed") {
                if((linetype == LINETYPE_ANALOG) && (( szVoiceResName != szLineResName )))
                {
                    AfxMessageBox("With analog lines the line interface recource should be the same as the voice resource.!");
                    CloseResources();
                    return false;  
                }
                if(mdm_SCBUS_OpenResource( szVoiceResName.GetBuffer(128), &m_hVoiceHandle2, SCBUS_RESOURCE_TYPE_VOICE, 0, 0)!=SCBUS_SUCCESS)
                {
                    StatusMsg("Opening voice resource: %s has failed", szVoiceResName.GetBuffer(128));
                    CloseResources();
                    return false;
                }
            }
            else {
                if((linetype == LINETYPE_ANALOG))
                {
                    AfxMessageBox("With analog lines the line interface recource should be the same as the voice resource!");
                    CloseResources();
                    return false;
                }
                else if((linetype == LINETYPE_T1))
                {
                    AfxMessageBox("With T1 or E1 digital lines you must to specify a voice resource!");
                    CloseResources();
                    return false;
                }
            }
        }

        if(m_hVoiceHandle2 != -1)
        {
            if(mdm_SCBUS_ListenTo(m_hLineHandle2, m_hVoiceHandle2, SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
            {
                StatusMsg("Cannot route voice resource to the line interface.");
                CloseResources();
                return false;
            }
        }
  
        m_hModemObj2 = mdm_CreateModemObject(MOD_DIALOGIC);
        if(!m_hModemObj2) 
        {
            StatusMsg("Creating modem object failed");
            CloseResources();
            return false;
        }
    
        if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hModemObj2, m_hLineHandle2)!=SCBUS_SUCCESS) {
            StatusMsg("Cannot attach line interface resource to modem object");
            CloseResources();
            return false;
        }

        if(m_hVoiceHandle2 != -1) {
            if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hModemObj2, m_hVoiceHandle2)!=SCBUS_SUCCESS) {
                StatusMsg("Cannot attach voice resource to modem object");
                CloseResources();
                return false;
            }
        }

    }
    return true;
}


void CSCCallSwitchDlg::OnStart() 
{
    EnableControls(FALSE);
    GetDlgItem(IDC_HANGUP1)->EnableWindow(FALSE);
    GetDlgItem(IDC_HANGUP2)->EnableWindow(FALSE);
    GetDlgItem(IDC_BUTTON1)->EnableWindow(FALSE);
    GetDlgItem(IDC_STOPWAIT)->EnableWindow(TRUE);

    if(OpenCall1Resources()) {
        if(OpenCall2Resources()) {
            m_n_States = STATE_WAITING_FOR_CALL1;    
            StatusMsg("Waiting for incoming calls...");
            mdm_WaitForRings(m_hModemObj, 1);
            mdm_WaitForRings(m_hModemObj2, 1);
        }
    }
}

void CSCCallSwitchDlg::OnClear() 
{
    m_lbMessages.ResetContent();
}

void CSCCallSwitchDlg::OnCopy() 
{

    CString szText;
    int itemnum = m_lbMessages.GetCount();
    if( itemnum > 0 ) {
        for(int i = 0; i<itemnum; ++i) {
            CString temp;
            m_lbMessages.GetText(i, temp);
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

void CSCCallSwitchDlg::OnHelp() 
{
    CDlgHelp dlg(this);

    dlg.DoModal();	
}


void CSCCallSwitchDlg::OnSelchangeLinetype2() 
{
  	int nIndex = m_cbLineType2.GetCurSel();

    if(nIndex == 0 || nIndex == 1){
        m_eProtocol2.EnableWindow(FALSE);
        m_eProtocol2.SetWindowText("");
    }
    else {
        m_eProtocol2.EnableWindow(TRUE);
        m_eProtocol2.SetWindowText("us_mf_io");
    }

}

void CSCCallSwitchDlg::OnHangup1() 
{
	StatusMsg("Hanging up call 1...");
    if(m_hModemObj) {
        if(m_n_States == STATE_CONNECTED) {
            mdm_SCBUS_StopListeningTo(m_hLineHandle, m_hLineHandle2, SCBUS_FULLDUPLEX);
            if(m_hVoiceHandle!=-1 )
                mdm_SCBUS_ListenTo(m_hLineHandle, m_hVoiceHandle, SCBUS_FULLDUPLEX);
            if(m_hVoiceHandle2!=-1 )
                mdm_SCBUS_ListenTo(m_hLineHandle2, m_hVoiceHandle2, SCBUS_FULLDUPLEX);
            
        }
        bLine1Connected = false;
        m_hModemObj->HangUp();
        GetDlgItem(IDC_HANGUP1)->EnableWindow(FALSE);
    }
}

void CSCCallSwitchDlg::OnHangup2() 
{
	StatusMsg("Hanging up call 2...");
    if(m_hModemObj2) {
        if(m_n_States == STATE_CONNECTED) {
            mdm_SCBUS_StopListeningTo(m_hLineHandle, m_hLineHandle2, SCBUS_FULLDUPLEX);
            if(m_hVoiceHandle!=-1 )
                mdm_SCBUS_ListenTo(m_hLineHandle, m_hVoiceHandle, SCBUS_FULLDUPLEX);
            if(m_hVoiceHandle2!=-1 )
                mdm_SCBUS_ListenTo(m_hLineHandle2, m_hVoiceHandle2, SCBUS_FULLDUPLEX);
        }
        bLine2Connected = false;
        GetDlgItem(IDC_HANGUP2)->EnableWindow(FALSE);
        m_hModemObj2->HangUp();
    }
}

void CSCCallSwitchDlg::OnCancel() 
{
    bStop = true;
    bExit = true;
    if(bLine1Connected)
        OnHangup1();
    if(bLine2Connected)
        OnHangup2();
    if(!bLine1Connected && !bLine2Connected)
        CloseResources();
}


void CSCCallSwitchDlg::EnableControls(BOOL Enabled)
{
    GetDlgItem(IDC_LINERES)->EnableWindow(Enabled);
    GetDlgItem(IDC_LINERES2)->EnableWindow(Enabled);
    GetDlgItem(IDC_LINETYPE)->EnableWindow(Enabled);
    GetDlgItem(IDC_PROTOCOL)->EnableWindow(Enabled);
    GetDlgItem(IDC_LINETYPE2)->EnableWindow(Enabled);
    GetDlgItem(IDC_PROTOCOL2)->EnableWindow(Enabled);
    GetDlgItem(IDC_VOICERES)->EnableWindow(Enabled);
    GetDlgItem(IDC_VOICERES2)->EnableWindow(Enabled);
}

void CSCCallSwitchDlg::OnStopwait() 
{
    bStop = true;	
    if(bLine1Connected)
        OnHangup1();
    if(bLine2Connected)
        OnHangup2();

    if(!bLine1Connected && !bLine2Connected)
        CloseResources();
}

void CSCCallSwitchDlg::OnDestroy() 
{
    EndOfVoiceDriver(TRUE);
    CDialog::OnDestroy();
}
