// FAXSENDDlg.cpp : implementation file
//

#include "stdafx.h"
#include "FAXSEND.h"
#include "FAXSENDDlg.h"

#include "tapifax.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

CFAXSENDDlg *g_FaxDialog = NULL;



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
// CFAXSENDDlg dialog



CFAXSENDDlg::CFAXSENDDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CFAXSENDDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CFAXSENDDlg)
	m_CIS = _T("Ô¶³Ì:");
	m_FaxFileName = _T("Google.tif");

	m_FaxNumber = _T("02158552860"); 
	m_Speed = _T("");
	m_iSpeed = 0;
	m_bIs2D = TRUE;
	m_CreateHead = TRUE;
	m_iClass = 0;
	m_sIdentifi = _T("Éí·Ý:");
	m_sIdentif = _T("0987654321");
	m_sTakeTime = _T("");
	m_nTimes = 0 ;
	m_bEcm = TRUE;
	m_sPage = _T("0");
	m_iVolume = 0;
	m_Remote = _T("");
	m_From = _T("NETFBI");
	m_Stat = _T("");
	m_Fax_data = _T("");
	m_iPort = 0;
	m_To = _T("MAGGIE");
	m_bEcmFlag = false;	
	m_nResolution = 0;

	g_hFax = NULL ;

	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CFAXSENDDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CFAXSENDDlg)
	DDX_Control(pDX, IDC_MODEM_LIST, m_ModemList);
	DDX_Text(pDX, IDC_STATIC_CIS, m_CIS);
	DDX_Text(pDX, IDC_EDIT1, m_FaxFileName);
	DDX_Text(pDX, IDC_EDIT2, m_FaxNumber);
	DDX_Text(pDX, IDC_STATIC_SPEED, m_Speed);
	DDX_CBIndex(pDX, IDC_MODEM_LIST2, m_iSpeed);
	DDX_Check(pDX, IDC_2DCOMPRESS, m_bIs2D);
	DDX_Check(pDX, IDC_CREATE_HEAD, m_CreateHead);
	DDX_CBIndex(pDX, IDC_MODEM_LIST3, m_iClass);
	DDX_Text(pDX, IDC_IDENTIFI, m_sIdentifi);
	DDX_Text(pDX, IDC_EDIT3, m_sIdentif);
	DDX_Text(pDX, IDC_TIME, m_sTakeTime);
	DDX_Check(pDX, IDC_2DCOMPRESS2, m_bEcm);
	DDX_Text(pDX, IDC_PAGE, m_sPage);
	DDX_Slider(pDX, ID_SLIDER1, m_iVolume);
	DDX_Text(pDX, IDC_STATIC_REMOTE, m_Remote);
	DDX_Text(pDX, IDC_EDIT5, m_From);
	DDX_Text(pDX, IDC_STATIC_OP, m_Stat);
	DDX_Text(pDX, IDC_STATIC_FAX_DATA, m_Fax_data);
	DDX_CBIndex(pDX, IDC_MODEM_LIST4, m_iPort);
	DDX_Text(pDX, IDC_EDIT4, m_To);
	DDX_Radio(pDX, IDC_RADIO1, m_nResolution);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CFAXSENDDlg, CDialog)
	//{{AFX_MSG_MAP(CFAXSENDDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON1, OnSendFax)
	ON_BN_CLICKED(IDC_CANCEL_FAX, OnCancelFax)
	ON_WM_TIMER()
	ON_BN_CLICKED(IDC_CREATE_HEAD, OnCreateHead)
	ON_BN_CLICKED(IDC_STATIC_WWW, OnStaticWww)
	//}}AFX_MSG_MAP

		ON_MESSAGE(WM_SMARTFAX, OnSmartFax)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFAXSENDDlg message handlers

BOOL CFAXSENDDlg::OnInitDialog()
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
	
	// TODO: Add extra initialization here

	CSliderCtrl	*slider  = (CSliderCtrl	*)GetDlgItem(ID_SLIDER1);
	slider->SetRange(0,3);

	m_iVolume = 0;
	this->UpdateData(false);
	GetModemDeviceList((unsigned long )&m_ModemList,FillComboBox);


	m_ModemList.SetCurSel(0);		

	g_FaxDialog = this;

	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CFAXSENDDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CFAXSENDDlg::OnPaint() 
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
HCURSOR CFAXSENDDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}




EFaxSpeed GetSelSpeed(int Index)
{
	switch(Index)
	{
	case 0:
		return FS_1440;
	case 1:
		return FS_1200;
	case 2:
		return FS_9600;
	case 3:
		return FS_7200;
	case 4:
		return FS_4800;
	default:
		return FS_2400;
	}
}





EVolume GetFaxVolume(int Index)
{
	switch(Index)
	{
	case 0:
		return VO_OFF;
	case 1:
		return VO_LOW;
	case 2:
		return VO_MIDDLE;
	default :
		return VO_HIGH;	
	}
}


void CFAXSENDDlg::OnSendFax() 
{
	// TODO: Add your control notification handler code here

	this->UpdateData(TRUE);

	if(m_iPort==0)  // From Tapi 
	{
		int nSel =  m_ModemList.GetCurSel();
		DWORD dwDevice = m_ModemList.GetItemData(nSel);
		
		if(dwDevice >=0 )
		{
			InitializeTAPI(dwDevice);
			InitFaxTapiCall(g_hLine,g_hCall);
		}
		
		
	}else   // From ComPort
	{				
		ComPortSendFax();		
	}

	

	
	
}

void CFAXSENDDlg::OnSmartFax(WPARAM wParam, LPARAM lParam)
{

	static unsigned long faxdata = 0 ;
	
	this->UpdateData();

	switch(wParam)
	{

	case WM_FAXUSERCANCE:
		m_Stat =  "User Cancel Send fax...";
		//ShutdownTAPI();		
		break;

	case WM_FAXMISSIONOUTOVER:
		{
			ShutdownTAPI();
		
			GetDlgItem(IDC_BUTTON1)->EnableWindow(true);
			GetDlgItem(IDOK)->EnableWindow(true);
			GetDlgItem(IDC_CANCEL_FAX)->EnableWindow(false);

			if (lParam==0)
				m_Stat =  "Send fax successful";
			else if(lParam==888)
				m_Stat =  "Send fax failed(USER CANCEL)";
			else 
				m_Stat =  "Send fax failed";
			KillTimer(100);   
		}

		break;		


		
	case WM_FAXCHANGESTATE:					
		{

				switch(lParam)
				{

				case FAXINIT:

					m_bEcmFlag = false ;
					m_nTimes = 0 ;
					SetTimer(100,1000, 0); 
					m_Remote="";
					faxdata = 0;
					m_Fax_data.Format("%dK",0);	

					GetDlgItem(IDC_BUTTON1)->EnableWindow(false);
					GetDlgItem(IDOK)->EnableWindow(false);
					GetDlgItem(IDC_CANCEL_FAX)->EnableWindow(true);


					m_Stat =  "Init Device";
					this->UpdateData(false);
					break;
				case DIALFAX:
					m_Stat =  "Dialing...";
					break;
				case ANSWER:
					m_Stat =  "Answering...";
					break; 
				case NEGOTIATION:
					m_Stat =  "Negotiating...";
					break; 
				case TRAINING:
					m_Stat =  "Training....";
					break; 
			
			
				}
		}

		break; 
	case WM_FAXSETCIS:

		m_Remote.Format("%s",(char*)lParam );	
		m_Remote.TrimLeft(" ");
		m_Remote.TrimRight(" ");

		break; 

	case WM_FAXSENDPAGEDATA:
		faxdata+=(long)lParam;
		m_Fax_data.Format("%dK",faxdata/1024);							
		break;

	case WM_ACCEPTPAGE:
		m_Stat =  "Page accepted ...";
		
		break;
	case WM_REJECTPAGE:
		m_Stat =  "Page rejected ...";
		
		break;

	case WM_FAXSPEED:
		m_Speed.Format("%d%s",lParam,"00 bps");
		break;

	case WM_FAXPAGE:
		m_nPage = (int)lParam;
		m_sPage.Format("Page %d",m_nPage);
		break;

	case WM_FAXECM:
		m_bEcmFlag  =  lParam == 0 ? false : true ;
		break;

	case WM_FAXPROCESSPAGEDATA:				
	
    	m_Stat =  "Sending page ";
		
		switch(lParam)
		{
			case D1DMR:

				if(m_bEcmFlag)
					m_Stat +=  "(ECM MH)...";
				else
					m_Stat += "(1DMH)...";
			
				break;
			case D2DMR:
							
				if(m_bEcmFlag)
					m_Stat +=  "(ECM 2DMR)...";
				else
					m_Stat += "(2DMR)...";			

				break;			
			case D2DMMR:

				if(m_bEcmFlag)
					m_Stat +=  "(ECM MMR)...";
				else
					m_Stat += "(2DMMR)...";
				break;
		}
	    break;



	default:
		;
	}
	
	TRACE("OnSmartFax  wParam == %d ----- lParam == %d \n",wParam,lParam);
	this->UpdateData(false);


}


void CFAXSENDDlg::OnCancelFax() 
{

	AbortPort(&g_hFax);
	
}

void CFAXSENDDlg::OnTimer(UINT nIDEvent) 
{
	// TODO: Add your message handler code here and/or call default
	

	if(nIDEvent == 100 )
	{
		CTimeSpan ts(0,0,0,m_nTimes++);		
		m_sTakeTime.Format("%01d:%01d:%02d",ts.GetHours(),ts.GetMinutes(),ts.GetSeconds());
		this->UpdateData(false);
	}


	CDialog::OnTimer(nIDEvent);
}

void CFAXSENDDlg::FillComboBox(DWORD dwDevice, const char *sLineName, const char *ComPort, unsigned long lParam)
{

	CComboBox *ModemList = (CComboBox *)lParam;
	int index = ModemList->AddString(sLineName);
	ModemList->SetItemData(index,dwDevice);	

}

int CFAXSENDDlg::TapiSendFax()
{

 
	this->UpdateData();

	DWORD CurrentProcess = GetPriorityClass(GetCurrentProcess());


	SFaxParam *Sender =(SFaxParam *) new SFaxParam; 
	Sender->hFax = &g_hFax;

	Sender->hCall = g_hCall;
	Sender->hLine = g_hLine;


	
	strcpy(Sender->FileName,GetFullPath(m_FaxFileName));
	strcpy(Sender->FaxNumber,m_FaxNumber) ;

	Sender->Hwnd = this->GetSafeHwnd();
	Sender->Msg = WM_SMARTFAX;
	Sender->nComPort = m_iPort;
	
	Sender->Speed = GetSelSpeed(m_iSpeed);
	Sender->Is2D = m_bIs2D == TRUE ? U2D_ENABLE : U2D_DISABLE ;
	Sender->CreateHead = m_CreateHead == TRUE ? CH_ENABLE : CH_DISABLE;
	Sender->Class = m_iClass == 0 ? CLASS_1 : CLASS_2  ;
	strcpy(Sender->Identifi,m_sIdentif);
	Sender->Ecm = m_bEcm == TRUE ? ECM_ENABLE : ECM_DISABLE ;
	Sender->Volume =GetFaxVolume(m_iVolume) ;

	strcpy(Sender->From,m_From);
	strcpy(Sender->To,m_To);

	Sender->Resolution = m_nResolution == 0 ?  RE_FINE : RE_STANDARD ;
	Sender->nStartPage = 1 ;

	TapiSmartSendFax(BIRTH,NULL,Sender);
	delete Sender;
	
	return 0;
}


int CFAXSENDDlg::ComPortSendFax()
{

	this->GetDlgItem(IDC_BUTTON1)->EnableWindow(false);
	this->GetDlgItem(IDOK)->EnableWindow(false);
	this->UpdateData();

	SFaxParam *Sender =(SFaxParam *) new SFaxParam; 
	Sender->hFax = &g_hFax;

	strcpy(Sender->FileName,m_FaxFileName);
	strcpy(Sender->FaxNumber,m_FaxNumber) ;

	Sender->Hwnd = this->GetSafeHwnd();
	Sender->Msg = WM_SMARTFAX;
	Sender->nComPort = m_iPort;
    
	Sender->Speed = GetSelSpeed(m_iSpeed);
	Sender->Is2D = m_bIs2D == TRUE ? U2D_ENABLE : U2D_DISABLE ;
	Sender->CreateHead = m_bEcm == TRUE ? CH_ENABLE : CH_DISABLE;
	Sender->Class = m_iClass == 0  ? CLASS_1 : CLASS_2  ;
	strcpy(Sender->Identifi,m_sIdentif);
	Sender->Ecm = m_bEcm == TRUE ? ECM_ENABLE : ECM_DISABLE ;
	Sender->Volume = GetFaxVolume(m_iVolume) ;
	
	strcpy(Sender->From,m_From);
	strcpy(Sender->To,m_To);
	Sender->nStartPage = 1 ;
	Sender->Resolution = m_nResolution == 0 ?  RE_FINE : RE_STANDARD ;


	int rc = SmartSendFax(BIRTH,NULL,Sender);

	delete Sender;	

	return rc;
}



void CFAXSENDDlg::OnCreateHead() 
{
	// TODO: Add your control notification handler code here

	BOOL fEnable ;
	this->UpdateData();
	fEnable = m_CreateHead ;
	GetDlgItem(IDC_EDIT5)->EnableWindow(fEnable);
	GetDlgItem(IDC_EDIT4)->EnableWindow(fEnable);
	GetDlgItem(IDC_STATIC_FROM)->EnableWindow(fEnable);
	GetDlgItem(IDC_STATIC_TO)->EnableWindow(fEnable);
	
	
}

CString CFAXSENDDlg::GetWorkPath()
{
	char szPath[512];
	CString strTemp;
	int nPos;
	CString strWorkPath = _T( "" );
	
	GetModuleFileName( NULL , szPath , 512 );
	strTemp = szPath;
	nPos = strTemp.Find( '\\' );
	while( nPos != -1 )
	{
		strWorkPath += strTemp.Left( nPos + 1 );
		strTemp = strTemp.Right( strlen( strTemp ) - nPos -1 );
		nPos = strTemp.Find( '\\' );
	}

	return strWorkPath;

}

CString CFAXSENDDlg::GetFullPath(CString FileName)
{	
	int nPos = FileName.Find(':');

	if(nPos ==-1)
	{
		return GetWorkPath()+FileName;
	}
	return FileName;
	
	


}

void CFAXSENDDlg::OnStaticWww() 
{
	// TODO: Add your control notification handler code here
	ShellExecute(NULL,"open","http://www.i-enet.com",NULL,NULL,SW_SHOWNORMAL);
}
