// SCReceiveFaxDlg.cpp : implementation file
//

#include "stdafx.h"
#include "SCReceiveFax.h"
#include "SCReceiveFaxDlg.h"
#include <io.h>
#include <direct.h>
#include "DlgHelp.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif
char g_szExePath[MAX_PATH];
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
// CSCReceiveFaxDlg dialog

CSCReceiveFaxDlg::CSCReceiveFaxDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CSCReceiveFaxDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CSCReceiveFaxDlg)
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
    m_hLineHandle   = -1;
    m_hVoiceHandle  = -1;
    m_hFaxHandle    = -1;
    m_hModemObj     =  0;
    m_n_States      =  STATE_STARTING;
    m_pPortFax      =  0;
    m_pPortFax      =  0;
}

void CSCReceiveFaxDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CSCReceiveFaxDlg)
	DDX_Control(pDX, IDC_PROTOCOL, m_eProtocol);
	DDX_Control(pDX, IDC_LINETYPE, m_cbLineType);
	DDX_Control(pDX, IDC_VOICERES, m_cbVoiceRes);
	DDX_Control(pDX, IDC_FAXRES  , m_cbFaxRes);
	DDX_Control(pDX, IDC_LINERES , m_cbLineRes);
	DDX_Control(pDX, IDC_MESSAGES, m_lbMessages);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CSCReceiveFaxDlg, CDialog)
	//{{AFX_MSG_MAP(CSCReceiveFaxDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_CBN_SELCHANGE(IDC_LINETYPE, OnSelchangeLinetype)
	ON_BN_CLICKED(IDC_BROSWE, OnBroswe)
	ON_BN_CLICKED(IDC_START, OnStart)
	ON_BN_CLICKED(IDC_CLEAR, OnClear)
	ON_BN_CLICKED(IDC_COPY, OnCopy)
    ON_REGISTERED_MESSAGE(VoiceMsg,OnVoiceMsg)
	ON_BN_CLICKED(IDC_HELP, OnHelp)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSCReceiveFaxDlg message handlers

BOOL CSCReceiveFaxDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.
    char *pC;
    GetModuleFileName( GetModuleHandle(NULL), g_szExePath, MAX_PATH);
    pC = strrchr(g_szExePath, '\\');
	if( pC )
	{
		*pC = 0;
	}

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
                    }
                    temp=temp + strlen(temp)+1;
                }
                m_cbLineRes.SetCurSel(0);
                delete [] szBuffer;
            }

        }
    }
    else {
        //without line interface resources there is no way to receive faxes, we have to exit the program
        AfxMessageBox("No Line Interface resource has been detected. In order to run this sample, you need to have at least one Dialogic line interface resource.");        
        OnCancel();
        return TRUE;
    }
    
    m_cbVoiceRes.AddString("No voice resource is needed");
    m_cbVoiceRes.SetCurSel(0);
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
                    }
                    temp=temp + strlen(temp)+1;
                }
                m_cbVoiceRes.SetCurSel(0);
                delete [] szBuffer;
            }
 
        }
    }

    if(mdm_SCBUS_EnumerateResources(NULL, &buffersize, SCBUS_RESOURCE_TYPE_FAX)==SCBUS_SUCCESS) 
    {
        if(buffersize>0) {
            szBuffer = new char[buffersize];
            if(szBuffer) {
                szBuffer[0]=0;
                char *temp=szBuffer;
                mdm_SCBUS_EnumerateResources(szBuffer, &buffersize, SCBUS_RESOURCE_TYPE_FAX);
                while(strlen(temp)>0) {
                    if(mdm_SCBUS_GetResourceStatus(temp, SCBUS_RESOURCE_TYPE_FAX)==SCBUS_RESOURCE_AVAILABLE){
                        m_cbFaxRes.AddString(temp);
                    }
                    temp=temp + strlen(temp)+1;
                }
                m_cbFaxRes.SetCurSel(0);
                delete [] szBuffer;
            }

        }
    }
    else {
        //without fax resources there is no way to receive faxes, we have to exit the program
        AfxMessageBox("No fax resource has been detected. In order to run this sample, you need to have at least one Dialogic/GammaLink fax resource.");        
        OnCancel();
        return TRUE;
    }

    m_cbLineType.SetCurSel(0);
    m_eProtocol.EnableWindow(FALSE);

    StatusMsg("Please select the resources you want to use, press the Receive Fax button");
    StatusMsg("and call the system.");
    
    m_n_States = STATE_STARTING;
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void  CSCReceiveFaxDlg::SaveReceivedFax(FAXOBJ faxObj)
{
    TSFaxParam      FaxParam;
    time_t          lTime;
    struct  tm      *localTime;
    CString     szFaxFile;
    TUFaxImage      faxImage;
    int pages = 0;

    
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
}

long CSCReceiveFaxDlg::OnVoiceMsg(WPARAM event,LPARAM lParam)
{

    switch( event )
    {
        case    MFX_MODEM_RING:
            StatusMsg("Incoming call was detected.");
            m_n_States = STATE_ANSWERING;
            m_hModemObj->OnlineAnswer();
        break;
        case MFX_RECEIVED:
            SaveReceivedFax((FAXOBJ)lParam);
            return 0;    
        case MFX_TERMINATE: {
            TSSessionParameters Params;
            GetSessionParameters(m_pPortFax,&Params);
            StatusMsg("Fax termination status: [%d]", Params.TStatus);
            return 0;    
        }
        case    MFX_IDLE:
            if( m_n_States == STATE_STARTRECEIVINGFAX )
            {
                StatusMsg("Receiving fax.....");
                if( m_hModemObj->ReceiveFaxNow() )
                {
                    m_n_States = STATE_RECEIVINGFAX;
                }
                else
                {
                    Return2VoiceMode();
                    StatusMsg("Receiving fax failed...");
                }
            }
            else if( m_n_States == STATE_RECEIVINGFAX )
            {
                Return2VoiceMode();
            }
        break;

        case    MFX_ERROR:
            if( (m_n_States == STATE_RETURNTOVOICEMODE) )
            {
                m_n_States = STATE_FINISHING;
                Hangup();
            }
            else if( m_n_States == STATE_FINISHING )
            {
                CloseResources();
            }
            break;
        case    MFX_MODEM_OK:
            if( m_n_States == STATE_RETURNTOVOICEMODE )
            {
                m_n_States = STATE_FINISHING;
                Hangup();
            }
            else if( (m_n_States == STATE_FINISHING ))
            {
                CloseResources();
            }
            return 0;

        case    MFX_CALLING_TONE:
        case    MFX_VOICE_CONNECT:
            if(m_n_States == STATE_ANSWERING)
            {
                StatusMsg("Call was answered.");
                StatusMsg("Switching to fax mode...");
                m_n_States = STATE_SWITCHING_TO_FAX_MODE;
                if(m_hVoiceHandle!=-1 )
                {
                    mdm_SCBUS_StopListeningTo(m_hLineHandle, m_hVoiceHandle, SCBUS_FULLDUPLEX);   
                }
                mdm_SCBUS_ListenTo(m_hLineHandle, m_hFaxHandle, SCBUS_FULLDUPLEX);   
                mdm_SCBUS_AttachResourceToMODEMOBJ(m_hModemObj, m_hFaxHandle);
                m_hModemObj->SetFaxSendMode(1);
            }
            else if(m_n_States == STATE_SWITCHING_TO_FAX_MODE)
            {
                m_pPortFax = (PORTFAX)m_hModemObj->ConnectVoicePort(MODEM_SHORT_NAME,"");

                if( m_pPortFax )
                {
                    m_n_States = STATE_STARTRECEIVINGFAX;
                }
                else
                {
                    m_n_States = STATE_FINISHING;
                    Hangup();
                }
            }
        break;
    break;

    }
    return 0;
}


void CSCReceiveFaxDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CSCReceiveFaxDlg::OnPaint() 
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
HCURSOR CSCReceiveFaxDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CSCReceiveFaxDlg::StatusMsg(LPCSTR msg,...)
{
    char    szTemp[1024];
    va_list pArg;

    va_start(pArg,msg);
    vsprintf(szTemp, msg, pArg);
    m_lbMessages.AddString(szTemp);
    va_end(pArg);

    m_lbMessages.SetTopIndex(m_lbMessages.GetCount()-1);
}

void CSCReceiveFaxDlg::OnSelchangeLinetype() 
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

void CSCReceiveFaxDlg::OnBroswe() 
{
    CFileDialog dlgOpen(TRUE);
    char        szFaxFile[MAX_PATH];


    *szFaxFile = 0;
    dlgOpen.m_ofn.hwndOwner = m_hWnd;
    dlgOpen.m_ofn.lpstrFilter = "TIFF Image (*.tif)\0*.tif\0";
    dlgOpen.m_ofn.lpstrFile = szFaxFile;
    dlgOpen.m_ofn.lpstrDefExt = "tif";
    dlgOpen.m_ofn.lpstrTitle = "Select Fax Document";
    dlgOpen.m_ofn.lpstrInitialDir = ".\\";

    if( dlgOpen.DoModal() != IDOK )
    {
        return;
    }

   	
}
void CSCReceiveFaxDlg::Return2VoiceMode()
{
    if(m_hModemObj) {
        m_hModemObj->DisconnectVoicePort();
        m_n_States = STATE_RETURNTOVOICEMODE;
    }
}

void CSCReceiveFaxDlg::Hangup()
{
    StatusMsg("Hanging up the line...");
    if(m_hModemObj) {
        m_hModemObj->HangUp();
        m_n_States = STATE_FINISHING;
    }
}

void CSCReceiveFaxDlg::CloseResources()
{
    StatusMsg("Closing resources...");
    if(m_hLineHandle != -1) {
        mdm_SCBUS_StopListeningTo(m_hLineHandle, m_hFaxHandle, SCBUS_FULLDUPLEX);
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
    if(m_hFaxHandle != -1) {
        mdm_SCBUS_DetachResourceFromMODEMOBJ(m_hModemObj, m_hFaxHandle);
        mdm_SCBUS_CloseResource(m_hFaxHandle);
        m_hFaxHandle = -1;
    }
    mdm_DestroyModemObject(m_hModemObj);
    m_hModemObj = NULL;
    m_n_States = STATE_STARTING;
    StatusMsg("Please select the resources you want to use, press the Receive Fax button");
    StatusMsg("and call the system.");
}

void CSCReceiveFaxDlg::OnStart() 
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
                return;
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
                    return;    
                }
                if(mdm_SCBUS_OpenResource( szVoiceResName.GetBuffer(128), &m_hVoiceHandle, SCBUS_RESOURCE_TYPE_VOICE, 0, 0)!=SCBUS_SUCCESS)
                {
                    StatusMsg("Opening voice resource: %s has failed", szVoiceResName.GetBuffer(128));
                    CloseResources();
                    return;
                }
            }
            else {
                if((linetype == LINETYPE_ANALOG))
                {
                    AfxMessageBox("With analog lines the line interface recource should be the same as the voice resource!");
                    CloseResources();
                    return;    
                }
                else if((linetype == LINETYPE_T1))
                {
                    AfxMessageBox("With T1 or E1 digital lines you must to specify a voice resource!");
                    CloseResources();
                    return;    
                }
            }
        }

        CString szFaxResName;
        if(m_hFaxHandle == -1) {
            m_cbFaxRes.GetLBText( m_cbFaxRes.GetCurSel(), szFaxResName );
            if(mdm_SCBUS_OpenResource( szFaxResName.GetBuffer(128), &m_hFaxHandle, SCBUS_RESOURCE_TYPE_FAX, 0, 0)!=SCBUS_SUCCESS)
            {
                StatusMsg("Opening fax resource: %s has failed", szFaxResName.GetBuffer(128));
                CloseResources();
                return;
            }
        }
    

        if(m_hVoiceHandle != -1)
        {
            if(mdm_SCBUS_ListenTo(m_hLineHandle, m_hVoiceHandle, SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
            {
                StatusMsg("Cannot route voice resource to the line interface.");
                CloseResources();
                return;
            }
        }
  
        m_hModemObj = mdm_CreateModemObject(MOD_DIALOGIC);
        if(!m_hModemObj) 
        {
            StatusMsg("Creating modem object failed");
            CloseResources();
            return;
        }
    
        if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hModemObj, m_hLineHandle)!=SCBUS_SUCCESS) {
            StatusMsg("Cannot attach line interface resource to modem object");
            CloseResources();
            return;
        }

        if(m_hVoiceHandle != -1) {
            if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hModemObj, m_hVoiceHandle)!=SCBUS_SUCCESS) {
                StatusMsg("Cannot attach voice resource to modem object");
                CloseResources();
                return;
            }
        }
        m_n_States = STATE_WAITINGFORCALLS;    
    }
    StatusMsg("Waiting for incoming calls...");
    mdm_WaitForRings(m_hModemObj, 1);
}

void CSCReceiveFaxDlg::OnClear() 
{
    m_lbMessages.ResetContent();
}

void CSCReceiveFaxDlg::OnCopy() 
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

void CSCReceiveFaxDlg::OnHelp() 
{
    CDlgHelp dlg(this);

    dlg.DoModal();	
}
