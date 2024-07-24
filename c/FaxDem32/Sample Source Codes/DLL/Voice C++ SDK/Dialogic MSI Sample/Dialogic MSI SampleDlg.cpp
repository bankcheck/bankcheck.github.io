// Dialogic MSI SampleDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Dialogic MSI Sample.h"
#include "Dialogic MSI SampleDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


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
// CDialogicMSISampleDlg dialog

CDialogicMSISampleDlg::CDialogicMSISampleDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CDialogicMSISampleDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDialogicMSISampleDlg)
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);


    m_dwVoiceResNum = 0;
    m_dwLineResNum  = 0;
    m_dwMSIResNum   = 0;
        
    m_hModemObj1    = 0;
    m_hModemObj2    = 0;
    m_hModemObj3    = 0;
    m_hModemObj4    = 0;

    m_hMSIModemObj1 = 0;
    m_hMSIModemObj2 = 0;
    m_hMSIModemObj3 = 0;
    m_hMSIModemObj4 = 0;


    m_hLineHandle1  = 0;
    m_hLineHandle2  = 0;
    m_hLineHandle3  = 0;
    m_hLineHandle4  = 0;
    

    m_hVoiceHandle1 = 0;
    m_hVoiceHandle2 = 0;
    m_hVoiceHandle3 = 0;
    m_hVoiceHandle4 = 0;

    m_hMSIHandle1   = 0;
    m_hMSIHandle2   = 0;
    m_hMSIHandle3   = 0;
    m_hMSIHandle4   = 0;

    m_hPhoneOffHook     = AfxGetApp()->LoadIcon(IDI_PHONEOFFHOOK);
    m_hPhoneOnHook      = AfxGetApp()->LoadIcon(IDI_PHONEONHOOK);
    m_hPhoneRing        = AfxGetApp()->LoadIcon(IDI_PHONERING);
    m_hPhoneDisabled    = AfxGetApp()->LoadIcon(IDI_PHONEDISABLED);

    for (int i=0; i<8; ++i)
    {
        StationInfo[i].MSIRes   = 0;
        StationInfo[i].VoiceRes = 0;
        StationInfo[i].LineRes  = 0;
        StationInfo[i].State  = STATION_ONHOOK;
        StationInfo[i].ConfID   = 0;
    }
    
    m_dwConfHostStation = 0;
    m_hMSIBoardHandle   = 0;

}

void CDialogicMSISampleDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDialogicMSISampleDlg)
	DDX_Control(pDX, IDC_MESSAGES, m_lbMessages);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CDialogicMSISampleDlg, CDialog)
	//{{AFX_MSG_MAP(CDialogicMSISampleDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_CLEAR, OnClear)
	ON_BN_CLICKED(IDC_CLIPBOARD, OnClipboard)
	ON_BN_CLICKED(IDC_BUTTONCONF1, OnButtonconf1)
	ON_BN_CLICKED(IDC_BUTTONCONF2, OnButtonconf2)
	ON_BN_CLICKED(IDC_BUTTONCONF3, OnButtonconf3)
	ON_BN_CLICKED(IDC_BUTTONCONF4, OnButtonconf4)
	ON_BN_CLICKED(IDC_BUTTONCONF5, OnButtonconf5)
	ON_BN_CLICKED(IDC_BUTTONCONF6, OnButtonconf6)
	ON_BN_CLICKED(IDC_BUTTONCONF7, OnButtonconf7)
	ON_BN_CLICKED(IDC_BUTTONCONF8, OnButtonconf8)
	ON_WM_DESTROY()
    ON_REGISTERED_MESSAGE(VoiceMsg,OnVoiceMsg)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDialogicMSISampleDlg message handlers

BOOL CDialogicMSISampleDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

    UpdateData(FALSE);
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
	
    
    SetupFaxDriver(NULL);
    SetupVoiceDriver(NULL);
    SetRuningMode(RNM_ALWAYSFREE);
    SetFaxMessage(m_hWnd);

    SetForegroundWindow();


    m_hMSIBoardHandle = mdm_MSI_OpenBoard(1);
//let's set the resource routing mode to manual, so we can specify how we want to
//route resources
    mdm_SCBUS_SetResourceRoutingMode(SCBUS_RESOURCE_ROUTING_MANUAL);
//check for MSI resources
    char* szBuffer=0;
    int buffersize=0;
   
    if(mdm_SCBUS_EnumerateResources(NULL, &buffersize, SCBUS_RESOURCE_TYPE_VOICE)==SCBUS_SUCCESS) 
    {
        if(buffersize>0) {
            szBuffer = new char[buffersize];
            if(szBuffer) {
                szBuffer[0]=0;
                char *temp=szBuffer;
                mdm_SCBUS_EnumerateResources(szBuffer, &buffersize, SCBUS_RESOURCE_TYPE_VOICE);
                while((strlen(temp)>0) && (m_dwVoiceResNum<4)) {
                    if(mdm_SCBUS_GetResourceStatus(temp, SCBUS_RESOURCE_TYPE_VOICE)==SCBUS_RESOURCE_AVAILABLE)
                    {
                        switch(m_dwVoiceResNum)
                        {
                            case 0:
                                if(mdm_SCBUS_OpenResource(temp, &m_hVoiceHandle1,  SCBUS_RESOURCE_TYPE_VOICE, 0, 0) == SCBUS_SUCCESS)
                                    ++m_dwVoiceResNum;
                                else
                                    m_hVoiceHandle1 = 0;
                                break;
                            case 1:
                                if(mdm_SCBUS_OpenResource(temp, &m_hVoiceHandle2,  SCBUS_RESOURCE_TYPE_VOICE, 0, 0) == SCBUS_SUCCESS)
                                    ++m_dwVoiceResNum;
                                else
                                    m_hVoiceHandle2 = 0;
                                break;
                            case 2:
                                if(mdm_SCBUS_OpenResource(temp, &m_hVoiceHandle3,  SCBUS_RESOURCE_TYPE_VOICE, 0, 0) == SCBUS_SUCCESS)
                                    ++m_dwVoiceResNum;
                                else
                                    m_hVoiceHandle3 = 0;
                                break;
                            case 3:
                                if(mdm_SCBUS_OpenResource(temp, &m_hVoiceHandle4, SCBUS_RESOURCE_TYPE_VOICE, 0, 0) == SCBUS_SUCCESS)
                                    ++m_dwVoiceResNum;
                                else
                                    m_hVoiceHandle4 = 0;
                                break;
                        }

                    }
                    temp=temp + strlen(temp)+1;
                }
                delete [] szBuffer;
            }
        }
    }
    else {
        AfxMessageBox("No voice resource has been detected. In order to run this sample, you need to have at least one voice resource.");        
        OnCancel();
        return TRUE;
    }
    
    if(mdm_SCBUS_EnumerateResources(NULL, &buffersize, SCBUS_RESOURCE_TYPE_MSI)==SCBUS_SUCCESS) 
    {
        if(buffersize>0) {
            szBuffer = new char[buffersize];
            if(szBuffer) {
                szBuffer[0]=0;
                char *temp=szBuffer;
                mdm_SCBUS_EnumerateResources(szBuffer, &buffersize, SCBUS_RESOURCE_TYPE_MSI);
                while((strlen(temp)>0) && (m_dwMSIResNum<4) && (m_dwMSIResNum<m_dwVoiceResNum)) {
                    if(mdm_SCBUS_GetResourceStatus(temp, SCBUS_RESOURCE_TYPE_MSI)==SCBUS_RESOURCE_AVAILABLE)
                    {
                        switch(m_dwMSIResNum)
                        {
                            case 0:
                                if(mdm_SCBUS_OpenResource(temp, &m_hMSIHandle1,  SCBUS_RESOURCE_TYPE_MSI, 0, 0) == SCBUS_SUCCESS)
                                {

                                    m_hMSIModemObj1 = mdm_CreateModemObject(MOD_DIALOGIC);
                                    if(!m_hMSIModemObj1) 
                                    {
                                        mdm_SCBUS_CloseResource(m_hMSIHandle1);
                                        m_hMSIHandle1 = 0;
                                        break;
                                    }
                                    if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hMSIModemObj1, m_hMSIHandle1)!=SCBUS_SUCCESS) 
                                    {
                                        
        
                                        mdm_SCBUS_CloseResource(m_hMSIHandle1);
                                        m_hMSIHandle1 = 0;
                                        break;
                                    }
									StationInfo[0].MSIRes   = m_hMSIHandle1;
                                    GetDlgItem(IDC_STATICMSI1)->EnableWindow(TRUE);
                                    GetDlgItem(IDC_STATUSMSI1)->EnableWindow(TRUE);
                                    
                                    GetDlgItem(IDC_STATUSMSI1)->SetWindowText(CString("MSI Extension 1 is ready..."));
                                    ++m_dwMSIResNum;
                                }
                                else
                                    m_hMSIHandle1 = 0;
                                break;
                            case 1:
                                if(mdm_SCBUS_OpenResource(temp, &m_hMSIHandle2,  SCBUS_RESOURCE_TYPE_MSI, 0, 0) == SCBUS_SUCCESS)
                                {
                                    m_hMSIModemObj2 = mdm_CreateModemObject(MOD_DIALOGIC);
                                    if(!m_hMSIModemObj2) 
                                    {
                                        mdm_SCBUS_CloseResource(m_hMSIHandle2);
                                        m_hMSIHandle1 = 0;
                                        break;
                                    }
                                    if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hMSIModemObj2, m_hMSIHandle2)!=SCBUS_SUCCESS) 
                                    {
                                        
                                        mdm_SCBUS_CloseResource(m_hMSIHandle2);
                                        m_hMSIHandle2 = 0;
                                        break;
                                    }
									StationInfo[1].MSIRes   = m_hMSIHandle2;
                                    GetDlgItem(IDC_STATICMSI2)->EnableWindow(TRUE);
                                    GetDlgItem(IDC_STATUSMSI2)->EnableWindow(TRUE);
                                    
                                    GetDlgItem(IDC_STATUSMSI2)->SetWindowText(CString("MSI Extension 2 is ready..."));
                                    ++m_dwMSIResNum;
                                }
                                else
                                    m_hMSIHandle2 = 0;
                                break;
                            case 2:
                                if(mdm_SCBUS_OpenResource(temp, &m_hMSIHandle3,  SCBUS_RESOURCE_TYPE_MSI, 0, 0) == SCBUS_SUCCESS)
                                {
                                    m_hMSIModemObj3 = mdm_CreateModemObject(MOD_DIALOGIC);
                                    if(!m_hMSIModemObj3) 
                                    {
                                        mdm_SCBUS_CloseResource(m_hMSIHandle3);
                                        m_hMSIHandle3 = 0;
                                        break;
                                    }
                                    if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hMSIModemObj3, m_hMSIHandle3)!=SCBUS_SUCCESS) 
                                    {
                                        
                                        mdm_SCBUS_CloseResource(m_hMSIHandle3);
                                        m_hMSIHandle3 = 0;
                                        break;
                                    }
									StationInfo[2].MSIRes   = m_hMSIHandle3;
                                    GetDlgItem(IDC_STATUSMSI3)->EnableWindow(TRUE);
                                    GetDlgItem(IDC_STATUSMSI3)->EnableWindow(TRUE);
                                    
                                    GetDlgItem(IDC_STATUSMSI3)->SetWindowText(CString("MSI Extension 3 is ready..."));
                                    ++m_dwMSIResNum;
                                }
                                else
                                    m_hMSIHandle3 = 0;
                                break;
                            case 3:
                                if(mdm_SCBUS_OpenResource(temp, &m_hMSIHandle4,  SCBUS_RESOURCE_TYPE_MSI, 0, 0) == SCBUS_SUCCESS)
                                {
                                    m_hMSIModemObj4 = mdm_CreateModemObject(MOD_DIALOGIC);
                                    if(!m_hMSIModemObj4) 
                                    {
                                        mdm_SCBUS_CloseResource(m_hMSIHandle4);
                                        m_hMSIHandle4 = 0;
                                        break;
                                    }
                                    if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hMSIModemObj4, m_hMSIHandle4)!=SCBUS_SUCCESS) 
                                    {
                                        
                                        mdm_SCBUS_CloseResource(m_hMSIHandle4);
                                        m_hMSIHandle4 = 0;
                                        break;
                                    }
									StationInfo[3].MSIRes   = m_hMSIHandle4;
                                    GetDlgItem(IDC_STATICMSI4)->EnableWindow(TRUE);
                                    GetDlgItem(IDC_STATUSMSI4)->EnableWindow(TRUE);
                                    
                                    GetDlgItem(IDC_STATUSMSI4)->SetWindowText(CString("MSI Extension 4 is ready..."));
                                    ++m_dwMSIResNum;
                                }
                                else
                                    m_hMSIHandle4 = 0;
                                break;
                        }

                    }
                    temp=temp + strlen(temp)+1;
                }
                delete [] szBuffer;
            }
        }
    }
    else {
        AfxMessageBox("No MSI resource has been detected. In order to run this sample, you need to have at least one MSI resource.");        
        OnCancel();
        return TRUE;
    }

    if(mdm_SCBUS_EnumerateResources(NULL, &buffersize, SCBUS_RESOURCE_TYPE_LINEINTERFACE)==SCBUS_SUCCESS) 
    {
        if(buffersize>0) {
            szBuffer = new char[buffersize];
            if(szBuffer) {
                szBuffer[0]=0;
                char *temp=szBuffer;
                mdm_SCBUS_EnumerateResources(szBuffer, &buffersize, SCBUS_RESOURCE_TYPE_LINEINTERFACE);
                while((strlen(temp)>0) && (m_dwLineResNum<4) && (m_dwLineResNum<m_dwVoiceResNum)) {
                    if(mdm_SCBUS_GetResourceStatus(temp, SCBUS_RESOURCE_TYPE_LINEINTERFACE)==SCBUS_RESOURCE_AVAILABLE)
                    {
                        switch(m_dwLineResNum)
                        {
                            case 0:
                                if(mdm_SCBUS_OpenResource(temp, &m_hLineHandle1,  SCBUS_RESOURCE_TYPE_LINEINTERFACE, 3, 0) == SCBUS_SUCCESS)
                                {

                                    m_hModemObj1 = mdm_CreateModemObject(MOD_DIALOGIC);
                                    if(!m_hModemObj1) 
                                    {
                                        mdm_SCBUS_CloseResource(m_hLineHandle1);
                                        m_hLineHandle1 = 0;
                                        break;
                                    }
                                    if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hModemObj1, m_hLineHandle1)!=SCBUS_SUCCESS) 
                                    {
                                        
                                        mdm_SCBUS_CloseResource(m_hLineHandle1);
                                        m_hLineHandle1 = 0;
                                        break;
                                    }
									StationInfo[4].LineRes   = m_hLineHandle1;
                                    if(m_hVoiceHandle1)
                                    {
                                        if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hModemObj1, m_hVoiceHandle1)!=SCBUS_SUCCESS) 
                                            break;

                                        StationInfo[4].VoiceRes   = m_hVoiceHandle1;

                                        if(mdm_SCBUS_ListenTo(m_hLineHandle1, m_hVoiceHandle1, SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
                                            break;
                                    }
                                    mdm_WaitForRings(m_hModemObj1, 1);
                                    GetDlgItem(IDC_STATICVOICE1)->EnableWindow(TRUE);
                                    GetDlgItem(IDC_STATUSVOICE1)->EnableWindow(TRUE);
                                    
                                    GetDlgItem(IDC_STATUSVOICE1)->SetWindowText(CString("Line 1 is ready..."));
                                    ++m_dwLineResNum;
                                }
                                else
                                    m_hLineHandle1 = 0;
                                break;
                            case 1:
                                if(mdm_SCBUS_OpenResource(temp, &m_hLineHandle2,  SCBUS_RESOURCE_TYPE_LINEINTERFACE, 3, 0) == SCBUS_SUCCESS)
                                {

                                    m_hModemObj2 = mdm_CreateModemObject(MOD_DIALOGIC);
                                    if(!m_hModemObj2) 
                                    {
                                        mdm_SCBUS_CloseResource(m_hLineHandle2);
                                        m_hLineHandle2 = 0;
                                        break;
                                    }
                                    if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hModemObj2, m_hLineHandle2)!=SCBUS_SUCCESS) 
                                    {
                                        
                                        mdm_SCBUS_CloseResource(m_hLineHandle2);
                                        m_hLineHandle2 = 0;
                                        break;
                                    }
									StationInfo[5].LineRes   = m_hLineHandle2;
                                    if(m_hVoiceHandle2)
                                    {
                                        if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hModemObj2, m_hVoiceHandle2)!=SCBUS_SUCCESS) 
                                            break;
                                        StationInfo[5].VoiceRes   = m_hVoiceHandle2;
                                        if(mdm_SCBUS_ListenTo(m_hLineHandle2, m_hVoiceHandle2, SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
                                            break;
                                    }
                                    mdm_WaitForRings(m_hModemObj2, 1);
                                    GetDlgItem(IDC_STATICVOICE2)->EnableWindow(TRUE);
                                    GetDlgItem(IDC_STATUSVOICE2)->EnableWindow(TRUE);
                                    
                                    GetDlgItem(IDC_STATUSVOICE2)->SetWindowText(CString("Line 2 is ready..."));
                                    ++m_dwLineResNum;
                                }
                                else
                                    m_hLineHandle2 = 0;
                                break;
                            case 2:
                                if(mdm_SCBUS_OpenResource(temp, &m_hLineHandle3,  SCBUS_RESOURCE_TYPE_LINEINTERFACE, 3, 0) == SCBUS_SUCCESS)
                                {

                                    m_hModemObj3 = mdm_CreateModemObject(MOD_DIALOGIC);
                                    if(!m_hModemObj3) 
                                    {
                                        mdm_SCBUS_CloseResource(m_hLineHandle3);
                                        m_hLineHandle3 = 0;
                                        break;
                                    }
                                    if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hModemObj3, m_hLineHandle3)!=SCBUS_SUCCESS) 
                                    {
                                        
                                        mdm_SCBUS_CloseResource(m_hLineHandle3);
                                        m_hLineHandle3 = 0;
                                        break;
                                    }
									StationInfo[6].LineRes   = m_hLineHandle3;
                                    if(m_hVoiceHandle3)
                                    {
                                        if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hModemObj3, m_hVoiceHandle3)!=SCBUS_SUCCESS) 
                                            break;
                                        StationInfo[6].VoiceRes   = m_hVoiceHandle3;
                                        if(mdm_SCBUS_ListenTo(m_hLineHandle3, m_hVoiceHandle3, SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
                                            break;
                                        
                                    }
                                    mdm_WaitForRings(m_hModemObj3, 1);
                                    GetDlgItem(IDC_STATICVOICE3)->EnableWindow(TRUE);
                                    GetDlgItem(IDC_STATUSVOICE3)->EnableWindow(TRUE);
                                    
                                    GetDlgItem(IDC_STATUSVOICE3)->SetWindowText(CString("Line 3 is ready..."));
                                    ++m_dwLineResNum;
                                }
                                else
                                    m_hLineHandle3 = 0;
                                break;
                            case 3:
                                if(mdm_SCBUS_OpenResource(temp, &m_hLineHandle4,  SCBUS_RESOURCE_TYPE_LINEINTERFACE, 3, 0) == SCBUS_SUCCESS)
                                {

                                    m_hModemObj4 = mdm_CreateModemObject(MOD_DIALOGIC);
                                    if(!m_hModemObj4) 
                                    {
                                        mdm_SCBUS_CloseResource(m_hLineHandle4);
                                        m_hLineHandle1 = 0;
                                        break;
                                    }
                                    if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hModemObj4, m_hLineHandle4)!=SCBUS_SUCCESS) 
                                    {
                                        
                                        mdm_SCBUS_CloseResource(m_hLineHandle4);
                                        m_hLineHandle4 = 0;
                                        break;
                                    }
									StationInfo[7].LineRes   = m_hLineHandle4;
                                    if(m_hVoiceHandle4)
                                    {
                                        if(mdm_SCBUS_AttachResourceToMODEMOBJ(m_hModemObj4, m_hVoiceHandle4)!=SCBUS_SUCCESS) 
                                            break;
                                        StationInfo[7].VoiceRes   = m_hVoiceHandle4;
                                        if(mdm_SCBUS_ListenTo(m_hLineHandle4, m_hVoiceHandle4, SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
                                            break;
                                    }
                                    mdm_WaitForRings(m_hModemObj4, 1);
                                    GetDlgItem(IDC_STATICVOICE4)->EnableWindow(TRUE);
                                    GetDlgItem(IDC_STATUSVOICE4)->EnableWindow(TRUE);
                                    
                                    GetDlgItem(IDC_STATUSVOICE4)->SetWindowText(CString("Line 4 is ready..."));
                                    ++m_dwLineResNum;
                                }
                                else
                                    m_hLineHandle4 = 0;
                                break;
                        }

                    }
                    temp=temp + strlen(temp)+1;
                }
                delete [] szBuffer;
            }
        }
    }
    
   



	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CDialogicMSISampleDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CDialogicMSISampleDlg::OnPaint() 
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
HCURSOR CDialogicMSISampleDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}


long CDialogicMSISampleDlg::OnVoiceMsg(WPARAM event,LPARAM lParam)
{
    BOOL bError = FALSE;
    //StatusMsg("Message: %d", event);
    switch(event)
    {
        case MFX_ERROR:
            return 0;
        case MFX_MODEM_OK:
            return 0;
        case MFX_MODEM_RING:
            Handle_MFX_RING((MODEMOBJ)lParam);
            break;
        case MFX_CALLING_TONE:
        case MFX_VOICE_CONNECT:
        {
            BYTE index = GetModemObjIndex((MODEMOBJ)lParam);
            if(StationInfo[index-1].State == STATION_ANSWERING)
            {
                WaitForDTMF((MODEMOBJ)lParam);

                SetStationState(index, STATION_OFFHOOK);
                StatusMsg("Dial 1, 2, 3, or 4 to connect to an extension.");
            }
            break;
        }
        case MFX_MSI_STATIONONHOOK:
            Handle_MFX_MSI_STATIONONHOOK((MODEMOBJ)lParam);
            break;
        case MFX_MSI_STATIONOFFHOOK:
            Handle_MFX_MSI_STATIONOFFHOOK((MODEMOBJ)lParam);
            break;
		case MFX_ONHOOK:
			Handle_MFX_ONHOOK((MODEMOBJ)lParam);
			break;
        case MFX_DTMF_RECEIVED:
        {
            DTMFINFO        dtmfInfo;
            mdm_GetReceivedDTMF((MODEMOBJ)lParam, &dtmfInfo);
            StatusMsg("Calling MSI extension: [%s].", DTMF_DTMF((&dtmfInfo)));
            BYTE ext = atoi(DTMF_DTMF((&dtmfInfo)));
            if((ext>=1) && (ext <=4))
            {
				if(StationInfo[ext-1].State == STATION_ONHOOK)
				{
					mdm_SetModemLong(GetModemObj(ext), GetModemObjIndex((MODEMOBJ)lParam));
					mdm_SetModemLong((MODEMOBJ)lParam, ext);
                
					if( !mdm_MSI_RingStation(GetModemObj(ext), 20))
						StatusMsg(" RInging MSI Extension %d failed", ext);
					else
						SetStationState(ext, STATION_RINGING);
				}
				else
				{
					WaitForDTMF((MODEMOBJ)lParam);
					StatusMsg("MSI extension: [%d] is BUSY.", ext);
				}
            }
            else if(ext==9)
            {
                BYTE index = GetModemObjIndex((MODEMOBJ)lParam);
                if(index<4)
                {
                    RestoreVoiceRes(index);
                    ConnectToFreeLineRes(index);
                }
            }
            else
                WaitForDTMF((MODEMOBJ)lParam);
            break;
        }
        case MFX_MSI_RINGOFFHOOK:
        {
            BYTE index = GetModemObjIndex((MODEMOBJ)lParam);

            if(index >0 && index<=4)
            {
                DWORD dwError=0;
                BYTE index2 = (BYTE)mdm_GetModemLong(GetModemObj(index));
                if(index2<=4)
                {
                    RestoreVoiceRes(index2);
                    if((dwError = mdm_SCBUS_ListenTo(GetMSIResHandle(index), GetMSIResHandle(index2), SCBUS_FULLDUPLEX))!=SCBUS_SUCCESS)
                        StatusMsg("Cannot connect MSI Station %d to MSI Station %d, %d", index2, index, dwError);
                }
                else
                {
                    if((dwError = mdm_SCBUS_StopListeningTo(GetLineResHandle(index2), GetVoiceResHandle(index2), SCBUS_FULLDUPLEX))!=SCBUS_SUCCESS)
                        StatusMsg("Line %d: Cannot disconnect Line interface %d from Voice resource %d, %d", index2, index2, index2, dwError);
                    if((dwError = mdm_SCBUS_ListenTo(GetLineResHandle(index2), GetMSIResHandle(index), SCBUS_FULLDUPLEX))!=SCBUS_SUCCESS)
                        StatusMsg("Cannot connect MSI Station %d to MSI Station %d, %d", index2, index, dwError);
                }
                
                mdm_SetModemLong(GetModemObj(index2), index); 
                SetStationState(index, STATION_CONNECTED);
                SetStationState(index2, STATION_CONNECTED);
            }
            break;
        }
        case MFX_MSI_RINGTERMINATED:
        {
            BYTE index = GetModemObjIndex((MODEMOBJ)lParam);
            SetStationState(index, STATION_ONHOOK);
            break;
        }
        case MFX_MSI_RINGSTOP:
        {
            BYTE index = GetModemObjIndex((MODEMOBJ)lParam);
            SetStationState(index, STATION_ONHOOK);
            break;
        }
    }
    return 0;
}


void CDialogicMSISampleDlg::StatusMsg(LPCSTR msg,...)
{
    char    szTemp[1024];
    va_list pArg;

    va_start(pArg,msg);
    vsprintf(szTemp, msg, pArg);
    m_lbMessages.AddString(szTemp);
    va_end(pArg);

    m_lbMessages.SetTopIndex(m_lbMessages.GetCount()-1);
}

void CDialogicMSISampleDlg::OnClear() 
{
    m_lbMessages.ResetContent();	
}

void CDialogicMSISampleDlg::OnClipboard() 
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

BYTE CDialogicMSISampleDlg::GetModemObjIndex(MODEMOBJ ModemObj)
{
    if(ModemObj == m_hMSIModemObj1)
        return 1;
     else if(ModemObj == m_hMSIModemObj2)
        return 2;
     else if(ModemObj == m_hMSIModemObj3)
        return 3;
     else if(ModemObj == m_hMSIModemObj4)
        return 4;
     else if(ModemObj == m_hModemObj1)
        return 5;
     else if(ModemObj == m_hModemObj2)
        return 6;
     else if(ModemObj == m_hModemObj3)
        return 7;
     else if(ModemObj == m_hModemObj4)
        return 8;
     else
        StatusMsg("Unknown modem object in GetModemObjIndex: %X", ModemObj);
     return 0;
}

MODEMOBJ CDialogicMSISampleDlg::GetModemObj(BYTE index)
{

    switch(index)
    {
        case 1:
            return m_hMSIModemObj1;
        case 2:
            return m_hMSIModemObj2;
        case 3:
            return m_hMSIModemObj3;
        case 4:
            return m_hMSIModemObj4;
        case 5:
            return m_hModemObj1;
        case 6:
            return m_hModemObj2;
        case 7:
            return m_hModemObj3;
        case 8:
            return m_hModemObj4;
        default:
            StatusMsg("Unknown modem object index in GetModemObj: %d", index);
    }
     return 0;
}

SCBUSRES CDialogicMSISampleDlg::GetMSIResHandle(BYTE index)
{

    switch(index)
    {
        case 1:
            return m_hMSIHandle1;
        case 2:
            return m_hMSIHandle2;
        case 3:
            return m_hMSIHandle3;
        case 4:
            return m_hMSIHandle4;
        default:
            StatusMsg("Unknown MSI resource index in GetMSIResHandle: %d", index);
    }
     return 0;
}


BYTE CDialogicMSISampleDlg::GetVoiceResIndex(SCBUSRES ResHandle)
{
    if(ResHandle)
    {
        if( ResHandle == m_hVoiceHandle1)
            return 1;
        if( ResHandle == m_hVoiceHandle2)
            return 2;
        if( ResHandle == m_hVoiceHandle3)
            return 3;
        if( ResHandle == m_hVoiceHandle4)
            return 4;
    }
    else
        StatusMsg("Unknown voice resource handle in GetVoiceResIndex: %d", ResHandle);

    return 0;
}

SCBUSRES CDialogicMSISampleDlg::GetVoiceResHandle(BYTE index)
{
    if(index>4)
        index=index-4;

    switch(index)
    {
        case 1:
            return m_hVoiceHandle1;
        case 2:
            return m_hVoiceHandle2;
        case 3:
            return m_hVoiceHandle3;
        case 4:
            return m_hVoiceHandle4;
        default:
            StatusMsg("Unknown voice resource index in GetVoiceResHandle: %d", index);
    }
     return 0;
}

BYTE CDialogicMSISampleDlg::FindVoiceRes(BYTE Index)
{
    if(Index>4)
        Index-=4;

    SCBUSRES hResHandle=-1;
    switch(Index)
    {
        case 1:hResHandle = m_hVoiceHandle1;break;
        case 2:hResHandle = m_hVoiceHandle2;break;
        case 3:hResHandle = m_hVoiceHandle3;break;
        case 4:hResHandle = m_hVoiceHandle4;break;
        default:
            StatusMsg("Unknown voice resource index in FindVoiceRes: %d", Index);
    }
    
    for(int i=1; i<=4;i++)
    {
        if( StationInfo[i-1].VoiceRes ==  hResHandle)
            return i;
    }
    return 0;
}


SCBUSRES CDialogicMSISampleDlg::GetLineResHandle(BYTE index)
{

    if(index>4)
        index=index-4;
    switch(index)
    {
        case 1:
            return m_hLineHandle1;
        case 2:
            return m_hLineHandle2;
        case 3:
            return m_hLineHandle3;
        case 4:
            return m_hLineHandle4;
        default:
            StatusMsg("Unknown line interface resource index in GetLineResHandle: %d", index);
    }
     return 0;
}



void CDialogicMSISampleDlg::WaitForDTMF(MODEMOBJ ModemObj)
{
    DTMFINFO DTMFInfo;
    memset(&DTMFInfo, 0, sizeof(DTMFInfo));
    DTMFInfo.nNumOfDTMF = 1;
    if(ModemObj)
        mdm_GenerateToneSignalExtDTMF(ModemObj, 350, 440, -20, -20, 600, MDM_LINE, 1);
}

DWORD CDialogicMSISampleDlg::GetStationIconID(BYTE index)
{
    switch(index)
    {
        case 1:
            return IDC_ICONMSI1;
        case 2:
            return IDC_ICONMSI2;
        case 3:
            return IDC_ICONMSI3;
        case 4:
            return IDC_ICONMSI4;
        case 5:
            return IDC_ICONVOICE1;
        case 6:
            return IDC_ICONVOICE2;
        case 7:
            return IDC_ICONVOICE3;
        case 8:
            return IDC_ICONVOICE4;
        default:
            StatusMsg("Unknown station icon index in GetStationIconID: %d", index);
    }
     return 0;

}

DWORD CDialogicMSISampleDlg::GetStationStatusID(BYTE index)
{
    switch(index)
    {
        case 1:
            return IDC_STATUSMSI1;
        case 2:
            return IDC_STATUSMSI2;
        case 3:
            return IDC_STATUSMSI3;
        case 4:
            return IDC_STATUSMSI4;
        case 5:
            return IDC_STATUSVOICE1;
        case 6:
            return IDC_STATUSVOICE2;
        case 7:
            return IDC_STATUSVOICE3;
        case 8:
            return IDC_STATUSVOICE4;
        default:
            StatusMsg("Unknown station icon index in GetStationStatusID: %d", index);
    }
     return 0;

}

DWORD CDialogicMSISampleDlg::GetConfButtonID(BYTE index)
{
    switch(index)
    {
        case 1:
            return IDC_BUTTONCONF1;
        case 2:
            return IDC_BUTTONCONF2;
        case 3:
            return IDC_BUTTONCONF3;
        case 4:
            return IDC_BUTTONCONF4;
        case 5:
            return IDC_BUTTONCONF5;
        case 6:
            return IDC_BUTTONCONF6;
        case 7:
            return IDC_BUTTONCONF7;
        case 8:
            return IDC_BUTTONCONF8;
        default:
            StatusMsg("Unknown station icon index in GetStationStatusID: %d", index);
    }
     return 0;

}


LPCSTR CDialogicMSISampleDlg::GetStationName(BYTE index)
{
    switch(index)
    {
        case 1:
            return "MSI Extension 1";
        case 2:
            return "MSI Extension 2";
        case 3:
            return "MSI Extension 3";
        case 4:
            return "MSI Extension 4";
        case 5:
            return "Line 1";
        case 6:
            return "Line 2";
        case 7:
            return "Line 3";
        case 8:
            return "Line 4";
        default:
            StatusMsg("Unknown station index in GetStationName: %d", index);
    }
     return 0;
}


void CDialogicMSISampleDlg::SetStationState(BYTE index, enum StationState State)
{
    DWORD dwIconID = GetStationIconID(index);
    DWORD dwStatusID = GetStationStatusID(index);

    switch(State)
    {
        case STATION_ONHOOK:
            ((CStatic*)GetDlgItem(dwIconID))->SetIcon(m_hPhoneOnHook);
            ((CButton*)GetDlgItem(GetConfButtonID(index)))->EnableWindow(FALSE);
            GetDlgItem(dwStatusID)->SetWindowText(CString(GetStationName(index)) + CString(" is ready..."));
            break;
        case STATION_OFFHOOK:
            ((CStatic*)GetDlgItem(dwIconID))->SetIcon(m_hPhoneOffHook);
            ((CButton*)GetDlgItem(GetConfButtonID(index)))->EnableWindow(TRUE);
            GetDlgItem(dwStatusID)->SetWindowText(CString(GetStationName(index)) + CString(" is Off Hook..."));
            break;
        case STATION_RINGING:
            ((CStatic*)GetDlgItem(dwIconID))->SetIcon(m_hPhoneRing);
            GetDlgItem(dwStatusID)->SetWindowText(CString(GetStationName(index)) + CString(" is ringing..."));
            break;
        case STATION_CONNECTED:
        {
            BYTE index2 = (BYTE)mdm_GetModemLong(GetModemObj(index));
            ((CStatic*)GetDlgItem(dwIconID))->SetIcon(m_hPhoneOffHook);
            CString statustxt;
            statustxt.Format("Connected to MSI Ext %d...", index2);
            GetDlgItem(dwStatusID)->SetWindowText(statustxt);
			((CButton*)GetDlgItem(GetConfButtonID(index)))->EnableWindow(FALSE);
            break;
        }
        case STATION_ANSWERING:
            ((CStatic*)GetDlgItem(dwIconID))->SetIcon(m_hPhoneRing);
            GetDlgItem(dwStatusID)->SetWindowText(CString(GetStationName(index)) + CString(" is answering call..."));
            break;
        case STATION_USED:
            ((CStatic*)GetDlgItem(dwIconID))->SetIcon(m_hPhoneDisabled);
            CString statustxt;
            statustxt.Format("Used by MSI Ext %d...", FindVoiceRes(index));
            GetDlgItem(dwStatusID)->SetWindowText(statustxt);
            break;

    }

    StationInfo[index-1].State = State;
}

void CDialogicMSISampleDlg::AttachFreeVoiceRes(BYTE index)
{

    int FreeVoiceRes = 0;
    
    for(int i=1; i<=4;++i)
    {
        if( StationInfo[i+4-1].VoiceRes  && (StationInfo[i+4-1].State == STATION_ONHOOK))
        {
            FreeVoiceRes = i;
            break;
        }
    }

    if(FreeVoiceRes)
    {
        if(mdm_SCBUS_DetachResourceFromMODEMOBJ(GetModemObj(FreeVoiceRes+4), GetVoiceResHandle(FreeVoiceRes))!=SCBUS_SUCCESS)
            StatusMsg("Cannot detach voice resource from Line %d", FreeVoiceRes);
        StationInfo[FreeVoiceRes+4-1].VoiceRes   = 0;
    
        if(mdm_SCBUS_AttachResourceToMODEMOBJ(GetModemObj(index), GetVoiceResHandle(FreeVoiceRes))!=SCBUS_SUCCESS)
            StatusMsg("Cannot attach voice resource to MSI Extension %d", index);
        StationInfo[index-1].VoiceRes   = GetVoiceResHandle(FreeVoiceRes);

        SetStationState(FreeVoiceRes+4, STATION_USED);

        if(mdm_SCBUS_StopListeningTo(GetLineResHandle(FreeVoiceRes), GetVoiceResHandle(FreeVoiceRes), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
            StatusMsg("Cannot disconnect Line Interface %d from Voice resource %d", FreeVoiceRes, FreeVoiceRes);
    
        if(mdm_SCBUS_ListenTo(GetMSIResHandle(index), GetVoiceResHandle(FreeVoiceRes), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
            StatusMsg("Cannot connect MSI Extension %d to Voice resource %d", index, FreeVoiceRes);
    }
    return ;
}

void CDialogicMSISampleDlg::ConnectToFreeLineRes(BYTE index)
{
    int FreeLineRes = 0;
    StatusMsg("Connecting to an outside line");   
    for(int i=1; i<=4;++i)
    {
        if( StationInfo[i+4-1].LineRes  && StationInfo[i+4-1].VoiceRes  && (StationInfo[i+4-1].State == STATION_ONHOOK))
        {
            FreeLineRes = i;
            break;
        }
    }

    if(FreeLineRes)
    {
        StatusMsg("Connecting to outside line %d", FreeLineRes+1);
    
        mdm_SetHook(GetModemObj(FreeLineRes+4), TRUE);

        SetStationState(FreeLineRes+4, STATION_CONNECTED);
		SetStationState(index, STATION_CONNECTED);

		mdm_SetModemLong(GetModemObj(FreeLineRes+4), index);
		mdm_SetModemLong(GetModemObj(index), FreeLineRes+4);

        if(mdm_SCBUS_StopListeningTo(GetLineResHandle(FreeLineRes), GetVoiceResHandle(FreeLineRes), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
            StatusMsg("Cannot disconnect Line Interface %d from Voice resource %d", FreeLineRes, FreeLineRes);
    
        if(mdm_SCBUS_ListenTo(GetMSIResHandle(index), GetLineResHandle(FreeLineRes), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
            StatusMsg("Cannot connect MSI Extension %d to Line Interface resource %d", index, FreeLineRes);
    }
    return ;
}

void CDialogicMSISampleDlg::RestoreVoiceRes(BYTE index)
{

    BYTE VoiceResHandleIndex = GetVoiceResIndex(StationInfo[index-1].VoiceRes);
    if(VoiceResHandleIndex)
    {
		
		mdm_TerminateWait(GetModemObj(index));

        if(mdm_SCBUS_DetachResourceFromMODEMOBJ(GetModemObj(index), StationInfo[index-1].VoiceRes)!=SCBUS_SUCCESS)
            StatusMsg("Cannot detach voice resource from MSI Station %d", index);
        StationInfo[index-1].VoiceRes   = 0;
    
        if(mdm_SCBUS_AttachResourceToMODEMOBJ(GetModemObj(VoiceResHandleIndex+4), GetVoiceResHandle(VoiceResHandleIndex))!=SCBUS_SUCCESS)
            StatusMsg("Cannot attach voice resource to Line %d", VoiceResHandleIndex);
        StationInfo[VoiceResHandleIndex+4-1].VoiceRes = GetVoiceResHandle(VoiceResHandleIndex);

		mdm_SetHook(GetModemObj(VoiceResHandleIndex+4), FALSE);
        SetStationState(VoiceResHandleIndex+4, STATION_ONHOOK);

        if(mdm_SCBUS_StopListeningTo(GetMSIResHandle(index), GetVoiceResHandle(VoiceResHandleIndex), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
            StatusMsg("Cannot disconnect MSI Extension %d from Voice resource %d", index, VoiceResHandleIndex);

        if(!StationInfo[VoiceResHandleIndex+4-1].ConfID)
            if(mdm_SCBUS_ListenTo(GetLineResHandle(VoiceResHandleIndex), GetVoiceResHandle(VoiceResHandleIndex), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
                StatusMsg("Cannot connect Line Interface %d to Voice resource %d", index, VoiceResHandleIndex);
		
		mdm_WaitForRings(GetModemObj(VoiceResHandleIndex+4), 1);
    }
    return ;
}


void CDialogicMSISampleDlg::Handle_MFX_MSI_STATIONOFFHOOK(MODEMOBJ ModemObj)
{
    DWORD dwError=0;
 
    BYTE index = GetModemObjIndex(ModemObj);
    if(index>4) //not a MSI modem object
        return;

    SetStationState(index, STATION_OFFHOOK);
    StatusMsg("MSI Extension %d is OFF Hook", index);
    
    AttachFreeVoiceRes(index);
    
    WaitForDTMF(ModemObj);

    StatusMsg("Dial 1, 2, 3, or 4 to call another extension or 9 for an outside line.");
           
}
void CDialogicMSISampleDlg::Handle_MFX_MSI_STATIONONHOOK(MODEMOBJ ModemObj)
{
    DWORD dwError=0;
    
    BYTE index = GetModemObjIndex(ModemObj);
    if(index>4) //not a MSI modem object
        return;

    
    StatusMsg("MSI Extension %d is ON Hook", index);


    if(StationInfo[index-1].ConfID)
        RemoveFromConference(index);

    if(StationInfo[index-1].State == STATION_OFFHOOK)
    {

        StatusMsg("Terminating");
        mdm_TerminateWait(GetModemObj(index));

        BYTE index2 = (BYTE)mdm_GetModemLong(ModemObj);
        if(index2)
            mdm_TerminateWait(GetModemObj(index2));
        
        RestoreVoiceRes(index);
    }
    if(StationInfo[index-1].State == STATION_RINGING)
    {
        mdm_TerminateWait(ModemObj);
    }
    if(StationInfo[index-1].State == STATION_CONNECTED)
    {
        BYTE index2 = (BYTE)mdm_GetModemLong(ModemObj);
        BYTE index3 = (BYTE)mdm_GetModemLong(GetModemObj(index2));
        if(index3)
        {
            if(index2<=4)
            {
                if((dwError = mdm_SCBUS_StopListeningTo(GetMSIResHandle(index), GetMSIResHandle(index2), SCBUS_FULLDUPLEX))!=SCBUS_SUCCESS)
                    StatusMsg("Cannot disconnect MSI Extension %d from MSI Extension %d, %d", index, index, index, dwError);
            }
            else
            {
                if((dwError = mdm_SCBUS_StopListeningTo(GetMSIResHandle(index), GetLineResHandle(index2), SCBUS_FULLDUPLEX))!=SCBUS_SUCCESS)
                    StatusMsg("Cannot disconnect MSI Extension %d from line interface %d, %d", index, index2, dwError);
                if((dwError = mdm_SCBUS_ListenTo(GetVoiceResHandle(index2), GetLineResHandle(index2), SCBUS_FULLDUPLEX))!=SCBUS_SUCCESS)
                    StatusMsg("Cannot connect voice resource %d to line interface %d, %d", index2, index2, dwError);
				mdm_SetHook(GetModemObj(index2), FALSE);
				SetStationState(index2, STATION_ONHOOK);

            }
            
        }
    }
    mdm_SetModemLong(GetModemObj(index), 0);
    SetStationState(index, STATION_ONHOOK);
	
    
}


void CDialogicMSISampleDlg::Handle_MFX_RING(MODEMOBJ ModemObj)
{
    DWORD dwError=0;
 
    BYTE index = GetModemObjIndex(ModemObj);
    if(index<=4) 
        return;

    SetStationState(index, STATION_RINGING);
    
    StatusMsg("Line %d is Ringing", index-4);
    
    mdm_OnlineAnswer(ModemObj);
    
    SetStationState(index, STATION_ANSWERING);

           
}

void CDialogicMSISampleDlg::CreateConference(BYTE index)
{
    

    MODEMOBJ modemobj = GetModemObj(index);
    BYTE ResType;
    if(index>4)
        ResType = SCBUS_RESOURCE_TYPE_LINEINTERFACE;
    else
        ResType = SCBUS_RESOURCE_TYPE_MSI;
    if(modemobj)
    {

        if(!mdm_MSI_EstablishConference(modemobj, m_hMSIBoardHandle, ResType, MSI_CONFERENCE_ATTR_NOTIFY_ON_ADD, MSI_CONFERENCE_PARTY_ATTR_NULL, &StationInfo[index-1].ConfID))
            StatusMsg("Cannot establish conference: %d", mdm_GetLastError(modemobj));
        else
        {
            StatusMsg("Conference established. ConferenceID: %d", StationInfo[index-1].ConfID);
            m_dwConfHostStation = index;
            for(int i=1;i<=8;i++)
            {
                if(i==index)
                    ((CButton*)GetDlgItem(GetConfButtonID(i)))->SetWindowText(CString("Delete Conference"));        
                else
                    ((CButton*)GetDlgItem(GetConfButtonID(i)))->SetWindowText(CString("Enter Conference"));
            }
        }
    }

}

void CDialogicMSISampleDlg::AddToConference(BYTE index)
{
    MODEMOBJ modemobj = GetModemObj(index);
    BYTE ResType;
    if(index>4)
        ResType = SCBUS_RESOURCE_TYPE_LINEINTERFACE;
    else
        ResType = SCBUS_RESOURCE_TYPE_MSI;
    if(modemobj)
    {
        if(!mdm_MSI_AddToConference(modemobj, m_hMSIBoardHandle, ResType, StationInfo[m_dwConfHostStation-1].ConfID , MSI_CONFERENCE_PARTY_ATTR_NULL))
            StatusMsg("Cannot add station station to the conference: %d", mdm_GetLastError(modemobj));
        else
        {
            StatusMsg("Station added to Conference ID: %d", StationInfo[m_dwConfHostStation-1].ConfID);
            ((CButton*)GetDlgItem(GetConfButtonID(index)))->SetWindowText(CString("Remove from conf"));
            StationInfo[index-1].ConfID = StationInfo[m_dwConfHostStation-1].ConfID;
        }
    }
}

void CDialogicMSISampleDlg::RemoveFromConference(BYTE index)
{
    MODEMOBJ modemobj = GetModemObj(index);
    BYTE ResType;
    if(index<=4)
        ResType = SCBUS_RESOURCE_TYPE_MSI;
    else
        ResType = SCBUS_RESOURCE_TYPE_LINEINTERFACE;
    if(modemobj)
    {
        if(m_dwConfHostStation != index)
        {
            if(!mdm_MSI_RemoveFromConference(modemobj, m_hMSIBoardHandle, ResType, StationInfo[m_dwConfHostStation-1].ConfID))
                StatusMsg("Cannot remove station from the conference: %d", mdm_GetLastError(modemobj));
            else
            {
                StatusMsg("Station removed from Conference ID: %d", StationInfo[index-1].ConfID);
                ((CButton*)GetDlgItem(GetConfButtonID(index)))->SetWindowText(CString("Enter Conference"));
                StationInfo[index-1].ConfID = 0;
			    if(index<=4)
				{
					AttachFreeVoiceRes(index);
					WaitForDTMF(modemobj);
				}

            }
        }
        else
        {
            for(int i=1; i<=8; i++)
            {
			    if(i<=4)
					ResType = SCBUS_RESOURCE_TYPE_MSI;
				else
					ResType = SCBUS_RESOURCE_TYPE_LINEINTERFACE;

                if((m_dwConfHostStation != i) && StationInfo[i-1].ConfID)
                {
                    modemobj = GetModemObj(i);
                    if(!mdm_MSI_RemoveFromConference(modemobj, m_hMSIBoardHandle, ResType, StationInfo[i-1].ConfID))
                        StatusMsg("Cannot remove station from the conference: %d", mdm_GetLastError(modemobj));
                    else
                    {
                        
                        StationInfo[i-1].ConfID = 0;
			            if(i<=4)
						{	
							AttachFreeVoiceRes(i);
							WaitForDTMF(GetModemObj(i));
						}
                    }
                }
				((CButton*)GetDlgItem(GetConfButtonID(i)))->SetWindowText(CString("Create Conference"));
            }
		    if(index<=4)
				ResType = SCBUS_RESOURCE_TYPE_MSI;
			else
				ResType = SCBUS_RESOURCE_TYPE_LINEINTERFACE;

            modemobj = GetModemObj(m_dwConfHostStation);
            if(!mdm_MSI_DeleteConference(modemobj, m_hMSIBoardHandle, StationInfo[m_dwConfHostStation-1].ConfID))
                StatusMsg("Cannot delete conference: %d", mdm_GetLastError(modemobj));
            else
            {
                ((CButton*)GetDlgItem(GetConfButtonID(index)))->SetWindowText(CString("Create Conference"));
                StationInfo[m_dwConfHostStation-1].ConfID = 0;
	            if(m_dwConfHostStation<=4)
				{
					AttachFreeVoiceRes(m_dwConfHostStation);
					WaitForDTMF(GetModemObj(m_dwConfHostStation));
				}
				m_dwConfHostStation = 0;
            }

        }
    }
}


void CDialogicMSISampleDlg::OnButtonconf1() 
{
    
    if(!m_dwConfHostStation)  //there is no active conference;
    {
        RestoreVoiceRes(1);
        CreateConference(1);
    }
    else
    {
        if(!StationInfo[0].ConfID) //not in conference
        {
            RestoreVoiceRes(1);
            AddToConference(1);
        }
        else                             //already in conference
        {
            RemoveFromConference(1);
        }
    }
}

void CDialogicMSISampleDlg::OnButtonconf2() 
{

   if(!m_dwConfHostStation)  //there is no active conference;
   {
       RestoreVoiceRes(2);
       CreateConference(2);
   }
   else
   {
        if(!StationInfo[1].ConfID) //not in conference
        {
            RestoreVoiceRes(2);
            AddToConference(2);
        }
        else                             //already in conference
        {
            RemoveFromConference(2);
        }
    }	
}

void CDialogicMSISampleDlg::OnButtonconf3() 
{
	if(!m_dwConfHostStation)  //there is no active conference;
    {
        RestoreVoiceRes(3);
        CreateConference(3);
    }
    else
    {
        if(!StationInfo[2].ConfID) //not in conference
        {
            RestoreVoiceRes(3);
            AddToConference(3);
        }
        else                             //already in conference
        {
            RemoveFromConference(3);
        }
    }
}

void CDialogicMSISampleDlg::OnButtonconf4() 
{
    if(!m_dwConfHostStation)  //there is no active conference;
    {
        RestoreVoiceRes(4);
        CreateConference(4);
    }
    else
    {
        if(!StationInfo[3].ConfID) //not in conference
        {
            RestoreVoiceRes(4);
            AddToConference(4);
        }
        else                             //already in conference
        {
            RemoveFromConference(4);
        }
    }	
	
}

void CDialogicMSISampleDlg::OnButtonconf5() 
{
    if(!m_dwConfHostStation)  //there is no active conference;
    {
        if(mdm_SCBUS_StopListeningTo(GetLineResHandle(5), GetVoiceResHandle(5), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
            StatusMsg("Cannot disconnect line interface 5 from Voice resource 5");
        CreateConference(5);
    }
    else
    {
        if(!StationInfo[4].ConfID) //not in conference
        {
            if(mdm_SCBUS_StopListeningTo(GetLineResHandle(5), GetVoiceResHandle(5), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
                StatusMsg("Cannot disconnect line interface 5 from Voice resource 5");
            AddToConference(5);
        }
        else                             //already in conference
        {
            RemoveFromConference(5);
            if(mdm_SCBUS_ListenTo(GetLineResHandle(5), GetVoiceResHandle(5), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
                StatusMsg("Cannot connect line interface 5 from Voice resource 5");
        }
    }	
	
}

void CDialogicMSISampleDlg::OnButtonconf6() 
{
    
    if(!m_dwConfHostStation)  //there is no active conference;
    {
        if(mdm_SCBUS_StopListeningTo(GetLineResHandle(6), GetVoiceResHandle(6), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
            StatusMsg("Cannot disconnect line interface 6 from Voice resource 6");
        CreateConference(6);
    }
    else
    {
        if(!StationInfo[5].ConfID) //not in conference
        {
            if(mdm_SCBUS_StopListeningTo(GetLineResHandle(6), GetVoiceResHandle(6), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
                StatusMsg("Cannot disconnect line interface 6 from Voice resource 6");
            AddToConference(6);
        }
        else                             //already in conference
        {
            RemoveFromConference(6);
            if(mdm_SCBUS_ListenTo(GetLineResHandle(6), GetVoiceResHandle(6), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
                StatusMsg("Cannot connect line interface 6 from Voice resource 6");
        }
    }	
	
}

void CDialogicMSISampleDlg::OnButtonconf7() 
{
    
    if(!m_dwConfHostStation)  //there is no active conference;
    {
        if(mdm_SCBUS_StopListeningTo(GetLineResHandle(7), GetVoiceResHandle(7), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
            StatusMsg("Cannot disconnect line interface 7 from Voice resource 7");
        CreateConference(7);
    }
    else
    {
        if(!StationInfo[6].ConfID) //not in conference
        {
            if(mdm_SCBUS_StopListeningTo(GetLineResHandle(7), GetVoiceResHandle(7), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
                StatusMsg("Cannot disconnect line interface 7 from Voice resource 7");
            AddToConference(7);
        }
        else
        {                           //already in conference
            RemoveFromConference(7);
            if(mdm_SCBUS_ListenTo(GetLineResHandle(7), GetVoiceResHandle(7), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
                StatusMsg("Cannot connect line interface 7 from Voice resource 7");
        }
    }	
	
}

void CDialogicMSISampleDlg::OnButtonconf8() 
{

    if(!m_dwConfHostStation)  //there is no active conference;
    {
        if(mdm_SCBUS_StopListeningTo(GetLineResHandle(8), GetVoiceResHandle(8), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
            StatusMsg("Cannot disconnect line interface 8 from Voice resource 8");
        CreateConference(8);
    }
    else
    {
        if(!StationInfo[7].ConfID) //not in conference
        {
            if(mdm_SCBUS_StopListeningTo(GetLineResHandle(8), GetVoiceResHandle(8), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
                StatusMsg("Cannot disconnect line interface 8 from Voice resource 8");
            AddToConference(8);
        }
        else                             //already in conference
        {
            RemoveFromConference(8);
            if(mdm_SCBUS_ListenTo(GetLineResHandle(8), GetVoiceResHandle(8), SCBUS_FULLDUPLEX)!=SCBUS_SUCCESS)
                StatusMsg("Cannot connect line interface 8 from Voice resource 8");

        }
    }	
	
}


void CDialogicMSISampleDlg::OnDestroy() 
{
	for(int i=1; i<=8; i++)
	{
		if( StationInfo[i-1].MSIRes )
		{
			mdm_SCBUS_CloseResource(StationInfo[i-1].MSIRes);
			mdm_SCBUS_DetachResourceFromMODEMOBJ(GetModemObj(i), StationInfo[i-1].MSIRes);
		}
		if( StationInfo[i-1].LineRes )
		{
			mdm_SCBUS_CloseResource(StationInfo[i-1].LineRes);
			mdm_SCBUS_DetachResourceFromMODEMOBJ(GetModemObj(i), StationInfo[i-1].LineRes);
		}
		if( StationInfo[i-1].VoiceRes )
		{
			mdm_SCBUS_CloseResource(StationInfo[i-1].VoiceRes);
			mdm_SCBUS_DetachResourceFromMODEMOBJ(GetModemObj(i), StationInfo[i-1].VoiceRes);
		}
		mdm_DestroyModemObject(GetModemObj(i));
	}

	EndOfVoiceDriver(TRUE);
	EndOfFaxDriver(TRUE);
	CDialog::OnDestroy();
}

void CDialogicMSISampleDlg::OnOK() 
{
	CDialog::OnOK();
}


void CDialogicMSISampleDlg::Handle_MFX_ONHOOK(MODEMOBJ ModemObj)
{
    DWORD dwError=0;
    
    BYTE index = GetModemObjIndex(ModemObj);
    if(index<=4) //not a line
        return;

    
    StatusMsg("Line %d is ON Hook", index-4);


    if(StationInfo[index-1].ConfID)
        RemoveFromConference(index);

    if(StationInfo[index-1].State == STATION_OFFHOOK)
    {
        mdm_TerminateWait(GetModemObj(index));
		mdm_HangUp(GetModemObj(index));
    }
    if(StationInfo[index-1].State == STATION_CONNECTED)
    {
        BYTE index2 = (BYTE)mdm_GetModemLong(ModemObj);
        BYTE index3 = (BYTE)mdm_GetModemLong(GetModemObj(index2));
        if(index3)
        {
            if((dwError = mdm_SCBUS_StopListeningTo(GetMSIResHandle(index2), GetLineResHandle(index), SCBUS_FULLDUPLEX))!=SCBUS_SUCCESS)
                StatusMsg("Cannot disconnect MSI Extension %d from line interface %d, %d", index2, index, dwError);
            if((dwError = mdm_SCBUS_ListenTo(GetVoiceResHandle(index), GetLineResHandle(index), SCBUS_FULLDUPLEX))!=SCBUS_SUCCESS)
                StatusMsg("Cannot connect voice resource %d to line interface %d, %d", index, index, dwError);
			mdm_HangUp(GetModemObj(index));
        }
		SetStationState(index2, STATION_OFFHOOK);
    }
    mdm_SetModemLong(GetModemObj(index), 0);
    SetStationState(index, STATION_ONHOOK);
	
    
}
