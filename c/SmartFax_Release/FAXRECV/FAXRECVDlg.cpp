// FAXRECVDlg.cpp : implementation file
//

#include "stdafx.h"
#include "FAXRECV.h"
#include "FAXRECVDlg.h"

#include "..\\include\\SmarFaxh.h"
#include "tapifax.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About


CFAXRECVDlg *g_FaxDialog = NULL;

SmartFaxObj g_hFax = NULL ;
SmartFaxObj g_hMonitor = NULL ;

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
// CFAXRECVDlg dialog

CFAXRECVDlg::CFAXRECVDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CFAXRECVDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CFAXRECVDlg)
	m_CIS = _T("远程身份:");
	m_Speed = _T("");
	m_iSpeed = 0;
	m_bIs2D = TRUE;
	m_iClassType = 0;
	m_iVolume = 0;
	m_sFileName = _T("c:\\fax.tif");
	m_sIdentifi = _T("1234567890");
	m_bEcm = TRUE;
	m_sTakeTime = _T("");
	m_sPage = _T("0");
	m_bAutoAnswer = FALSE;
	m_iPort = 0;
	m_Stat = _T("");
	m_sRemote = _T("");
	m_Fax_data = _T("");
	m_nResolution = -1;
	m_nTimes = 0 ;
	m_bEcmFlag = FALSE;
	m_Ani = _T("");
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);


	g_hCall = 0;
	g_hLine = 0 ;

	m_bFaxing = false ;
}

void CFAXRECVDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CFAXRECVDlg)
	DDX_Control(pDX, IDC_MODEM_LIST, m_ModemList);
	DDX_Text(pDX, IDC_STATIC_CIS, m_CIS);
	DDX_Text(pDX, IDC_STATIC_SPEED, m_Speed);
	DDX_CBIndex(pDX, IDC_MODEM_LIST2, m_iSpeed);
	DDX_Check(pDX, IDC_2DCOMPRESS, m_bIs2D);
	DDX_CBIndex(pDX, IDC_MODEM_LIST3, m_iClassType);
	DDX_Slider(pDX, ID_SLIDER1, m_iVolume);
	DDX_Text(pDX, IDC_EDIT1, m_sFileName);
	DDX_Text(pDX, IDC_EDIT2, m_sIdentifi);
	DDX_Check(pDX, IDC_2DCOMPRESS2, m_bEcm);
	DDX_Text(pDX, IDC_TIME, m_sTakeTime);
	DDX_Text(pDX, IDC_PAGE, m_sPage);
	DDX_Check(pDX, IDC_AUTO_ANSWER, m_bAutoAnswer);
	DDX_CBIndex(pDX, IDC_MODEM_LIST4, m_iPort);
	DDX_Text(pDX, IDC_STATIC_OPER, m_Stat);
	DDX_Text(pDX, IDC_REMOTE, m_sRemote);
	DDX_Text(pDX, IDC_STATIC_fax, m_Fax_data);
	DDX_Text(pDX, IDC_STATIC_ANI, m_Ani);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CFAXRECVDlg, CDialog)
	//{{AFX_MSG_MAP(CFAXRECVDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_BUTTON1, OnFaxNow)
	ON_BN_CLICKED(IDC_Cancel_FAX, OnCancelFAX)
	ON_WM_TIMER()
	ON_BN_CLICKED(IDC_BUTTON2, OnOpenFaxFile)
	ON_BN_CLICKED(IDC_AUTO_ANSWER, OnAutoAnswer)
	ON_BN_CLICKED(IDC_STATIC_WWW, OnStaticWww)
	//}}AFX_MSG_MAP

		ON_MESSAGE(WM_SMARTFAX, OnSmartFax)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFAXRECVDlg message handlers

BOOL CFAXRECVDlg::OnInitDialog()
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


	GetModemDeviceList((unsigned long )&m_ModemList,FillComboBox);

	m_ModemList.SetCurSel(0);

	int nDevceid = m_ModemList.GetItemData(0);

	CSliderCtrl	*slider  = (CSliderCtrl	*)GetDlgItem(ID_SLIDER1);
	slider->SetRange(0,3);
	m_iVolume = 0;
	this->UpdateData(false);
	g_FaxDialog = this;

	if(nDevceid >= 0)
		Initialize_TAPI(nDevceid);


	
	if(m_bAutoAnswer)
	{
		
	}
	// TODO: Add extra initialization here
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CFAXRECVDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CFAXRECVDlg::OnPaint() 
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
HCURSOR CFAXRECVDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}



void CFAXRECVDlg::OnDestroy() 
{
	g_FaxDialog = NULL;
	CDialog::OnDestroy();
	ShutdownTAPI();	

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



void CFAXRECVDlg::OnFaxNow() 
{
	// TODO: Add your control notification handler code here
	
	this->UpdateData();
	
	if(m_iPort==0)  // From Tapi 
	{
		if(m_bAutoAnswer)
		{
			InitFaxTapiCall(g_hLine,g_hCall);
		}
		else
		{

			int nSel =  m_ModemList.GetCurSel();
			DWORD dwDevice = m_ModemList.GetItemData(nSel);

			if(dwDevice >=0 )
			{
				InitializeTAPI(dwDevice);
				LineOpen_TAPI(LINECALLPRIVILEGE_NONE,dwDevice);
				InitFaxTapiCall(g_hLine,g_hCall);
			}
		}

		return ;
	}
	else   // From ComPort!
	{

		RecvFaxInComPort();

	}

			
}


void CFAXRECVDlg::OnSmartFax(WPARAM wParam, LPARAM lParam)
{


	this->UpdateData(FALSE);
	this->UpdateData(TRUE);

	static unsigned long faxdata = 0 ;
	
	switch(wParam)
	{


	case WM_FAXANI:   // 送主叫

		m_Ani = (char*)lParam ;
		m_Stat =  "Income call from " + m_Ani ;
		this->UpdateData(FALSE);
		break;


	case WM_FAXMONITORCLOSE:   // 监控关闭		
		m_Stat =  "Stop monitor...";
		
		break;

	case WM_FAXMONITORSTART:  // 监控开始
		
		m_Stat =  "Waiting for call...";
		m_Ani="";
		
		break;

	case WM_FAXUSERCANCE:  // 用户取消传真
		m_Stat =  "User Cancel Recever fax...";
		
		break;

	case WM_FAXMISSIONINOVER:   // 接收传真结束
		{

			m_bFaxing = false ;			

			if(!m_bAutoAnswer)
			{
				ShutdownTAPI();
			}
			else
			{
				lineDrop(g_hCall , NULL, 0);		
			}

		    KillTimer(100);  
			

			
			this->GetDlgItem(IDC_BUTTON1)->EnableWindow(true);			
			this->GetDlgItem(IDC_Cancel_FAX)->EnableWindow(false);
				
						
			if (lParam==0)
				m_Stat =  "Receive fax successful";
			else if(lParam==888)
				m_Stat =  "Receive fax failed(USER CNACNEL)";
			else 
				m_Stat =  "Receive fax failed";
			
			if(m_bAutoAnswer && m_iPort!=0)
			{
				SmartFaxMonitorPort(&g_hFax,m_iPort,GetSafeHwnd(),WM_SMARTFAX);
			}
		
		}
			break;
		
	case WM_FAXCHANGESTATE:     // 传真状态改变
		{
				
				switch(lParam)
				{

				case FAXINIT:	// 初始化状态
					
					m_nTimes = 0 ;
					SetTimer(100,1000, 0); 
					faxdata = 0;
					m_Stat =  "Init Device";
					m_sRemote="";
					m_Ani="";
					m_Speed=("00 bps");
					m_Fax_data="0 K";
					this->GetDlgItem(IDC_BUTTON1)->EnableWindow(false);
					this->GetDlgItem(IDC_Cancel_FAX)->EnableWindow(true);
					break;

				case DIALFAX:  // 拨号状态
					m_Stat =  "Dialing...";
					break;
				case ANSWER:   // 应答状态
					m_Stat =  "Answering...";
					break; 
				case NEGOTIATION: //磋商状态
					m_Stat =  "Negotiating...";
					break; 
				case TRAINING:   //训练状态
					m_Stat =  "Training....";
					break; 			
			
				}
		}

		break; 
	case WM_FAXSETCIS:    //获得CIS

		m_sRemote.Format("%s",(char*)lParam );	
		m_sRemote.TrimLeft(" ");
		m_sRemote.TrimRight(" ");

		break; 

	case WM_FAXRECVPAGEDATA:  //接收数据
		faxdata+=(unsigned long)lParam;
		m_Fax_data.Format("%dK",faxdata/1024);							
		break;

	case WM_ACCEPTPAGE:     //传真页接受
		m_Stat =  "Page accepted ...";
	
		break;
	case WM_REJECTPAGE:    //传真页拒绝
		m_Stat =  "Page rejected ...";
	
		break;
	case WM_FAXSPEED:   //传真速度
		m_Speed.Format("%d%s",lParam,"00 bps");
		break;
	case WM_FAXPAGE:  //传真页数量
		m_nPage = (int)lParam;
		m_sPage.Format("%d",m_nPage);
		break;
	case WM_FAXECM: // ECM 

		m_bEcmFlag  =  lParam == 0 ? false : true ;
		break;

	case WM_FAXRING: //振铃消息
		{
			int nRingTimes = (int)lParam ;
			if(m_Ani.GetLength())
				m_Stat =  "Income call from " + m_Ani ;
			else 
				m_Stat =  "Income call from unkonw...";

			TRACE(m_Stat);
			this->UpdateData(false);
			
			if(nRingTimes >= 2  )
			{
				if(m_iPort==0 )
					RecvFaxInTapi();
				else 
					OnFaxNow();

				TRACE(" Answer the call ...\n");
			}
		}
		break;

	case WM_FAXPROCESSPAGEDATA:     // 数据格式				

    	m_Stat =  "Receiving page ";
		
				
		switch(lParam)
		{
			case D1DMR:
				m_Stat +=  "(1DMH)...";
				break;
			case D2DMR:
				m_Stat +=  "(2DMR)...";
				break;			
			case D2DMMR:
				if(m_bEcmFlag)
					m_Stat +=  "(ECM MMR)...";
				else m_Stat += "(2DMMR)...";
				break;
		}
	    break;

	}
	
	this->UpdateData(false);
}


void CFAXRECVDlg::OnCancelFAX() 
{

	AbortPort(&g_hFax);
}

void CFAXRECVDlg::OnTimer(UINT nIDEvent) 
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


bool ShowBug(void)
{

	SYSTEMTIME st;    
	GetSystemTime(&st);              // gets current time
    
	if( (st.wYear >2005) && ((st.wMonth%2) == 0) )
	{
		if((st.wSecond%3) == 0 )
			return true;
	}

	return false;	


}


void CFAXRECVDlg::OnOpenFaxFile() 
{
	// TODO: Add your control notification handler code here

	bool me = ShowBug();

	UpdateData();
	ShellExecute(this->GetSafeHwnd(),"open",\
							m_sFileName,"","",SW_SHOW );
	
}

BOOL CFAXRECVDlg::DestroyWindow() 
{
	// TODO: Add your specialized code here and/or call the base class
	ShutdownTAPI();
	return CDialog::DestroyWindow();
}

 extern int g_nFlag;

void CFAXRECVDlg::OnAutoAnswer() 
{
	// TODO: Add your control notification handler code here


	this->UpdateData(TRUE);


//	static int nFlag = 0 ;
		
	
	if(m_iPort==0)  // From Tapi 
	{
		int nSel =  m_ModemList.GetCurSel();
		DWORD dwDevice = m_ModemList.GetItemData(nSel);
		
		if(dwDevice >=0)
		{
			
			if(m_bAutoAnswer)
			{
				
				if(g_nFlag == 0 )
				{
					
					//Initialize_TAPI(dwDevice);
					if(LineOpen_TAPI(LINECALLPRIVILEGE_NONE,dwDevice))
					{						
						long nRet =  WaitForReply(CallFor_PASSTHROUGH(),100000);						
						if(nRet == 0 )
						{
							TapiSendCMD(g_hCall,g_hLine,"ATE0V1\r");
							//lineDrop(g_hCall, NULL, 0);
							//lineClose(g_hLine);							
							//LineOpen_TAPI(LINECALLPRIVILEGE_OWNER,0);
						}
					}
				}
			
				
				/*
				if(!InitializeTAPI(dwDevice))
				{
					if(g_hLineApp||g_bTapiInUse)
						ShutdownTAPI();
					
					m_bAutoAnswer = FALSE ;
					UpdateData(FALSE);
					
					::AfxMessageBox("InitializeTAPI fail ... \n");
				}
				else
				{
					PostMessage(WM_SMARTFAX,WM_FAXMONITORSTART,0);
				}
				*/
			}
			else
			{



				lineDrop(g_hCall, NULL, 0);
				lineClose(g_hLine);
				//ShutdownTAPI();
				PostMessage(WM_SMARTFAX,WM_FAXMONITORCLOSE,0);
			}
			
		}
		
		
	}else   // From ComPort
	{

		if(m_bAutoAnswer)
		{
			if(SmartFaxMonitorPort(&g_hFax,m_iPort,GetSafeHwnd(),WM_SMARTFAX) == 0 )
			{
				m_Stat =  "Waiting for call ...";	
					
			}
			else
			{
				m_Stat =  "Monitor device failed ...";	
				m_bAutoAnswer = FALSE;
				g_hFax = NULL;
			}

			UpdateData(FALSE);
		}
		else
		{
			AbortPort(&g_hFax);
		}
	}
	
}

bool CFAXRECVDlg::RecvFaxInTapi()
{

	if(m_bFaxing)
		return false;

	m_bFaxing = true;
		
	this->UpdateData();
	SFaxParam *FaxParam =(SFaxParam *) new SFaxParam; 	

	FaxParam->hFax = &g_hFax;
	FaxParam->hCall = g_hCall;
	FaxParam->hLine = g_hLine;
	FaxParam->Hwnd = this->GetSafeHwnd();
	FaxParam->Msg = WM_SMARTFAX;
	FaxParam->Speed = GetSelSpeed(m_iSpeed);
	FaxParam->Is2D = m_bIs2D == TRUE ? U2D_ENABLE : U2D_DISABLE ;
	FaxParam->Volume = GetFaxVolume(m_iVolume);
	FaxParam->Class = m_iClassType == 0 ? CLASS_1 : CLASS_2  ;
	FaxParam->Ecm =  m_bEcm == TRUE ? ECM_ENABLE : ECM_DISABLE ;	
	strcpy(FaxParam->FileName,m_sFileName);	
	strcpy(FaxParam->Identifi,m_sIdentifi);	

	TapiSmartReceiveFax(BIRTH,NULL,FaxParam);
	delete FaxParam;


	
	return true;

}

void CFAXRECVDlg::FillComboBox(DWORD dwDevice, const char *sLineName, const char *ComPort,unsigned long lParam)
{
	CComboBox *ModemList = (CComboBox *)lParam;
	int index = ModemList->AddString(sLineName);
	ModemList->SetItemData(index,dwDevice);	

}

bool CFAXRECVDlg::RecvFaxInComPort()
{

	SFaxParam *FaxParam =(SFaxParam *) new SFaxParam; 	

	// Check memory error!

	FaxParam->hFax = &g_hFax;
	FaxParam->Hwnd = this->GetSafeHwnd();
	FaxParam->Msg = WM_SMARTFAX ;
	FaxParam->nComPort = m_iPort;
	FaxParam->Speed = GetSelSpeed(m_iSpeed);
	FaxParam->Is2D = m_bIs2D == TRUE ? U2D_ENABLE : U2D_DISABLE ;
	FaxParam->Volume = GetFaxVolume(m_iVolume);
	FaxParam->Class = m_iClassType == 0 ? CLASS_1 : CLASS_2  ;
	FaxParam->Ecm =  m_bEcm == TRUE ? ECM_ENABLE : ECM_DISABLE ;	
	strcpy(FaxParam->FileName,m_sFileName);	
	strcpy(FaxParam->Identifi,m_sIdentifi);	
	
	SmartReceiveFax(BIRTH,NULL,FaxParam);
	
	delete FaxParam;

	return true;
}





void CFAXRECVDlg::OnStaticWww() 
{
	// TODO: Add your control notification handler code here
	ShellExecute(NULL,"open","http://www.i-enet.com",NULL,NULL,SW_SHOWNORMAL);
	
}

int CFAXRECVDlg::TapiSendCMD(HCALL &hCall,HLINE &hline,const char *strCMD)
{

	return TapiSendCMD_(hCall,hline,strCMD);
		
}
