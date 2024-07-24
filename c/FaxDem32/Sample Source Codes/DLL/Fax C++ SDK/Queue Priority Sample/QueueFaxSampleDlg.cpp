// QueueFaxSampleDlg.cpp : implementation file
//

#include "stdafx.h"
#include "QueueFaxSample.h"
#include "QueueFaxSampleDlg.h"
#include "dlgFaxPortSetup.h"
#include "DlgFaxClose.h"
#include "DlgSendFax.h"
#include "BOpen.h"
#include "faxcpp.h"
#include "commcl.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#if defined(WIN32)
#define B_PORTNAME "Channel"
#define G_PORTNAME "Channel"
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();
	void VisitTo(CString*);

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	CStatic	m_cWebPage;
	CStatic	m_cMail;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);
	afx_msg void OnMouseMove(UINT nFlags, CPoint point);
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
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
	DDX_Control(pDX, IDC_WEB, m_cWebPage);
	DDX_Control(pDX, IDC_EMAIL, m_cMail);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
	ON_WM_CTLCOLOR()
	ON_WM_MOUSEMOVE()
	ON_WM_LBUTTONDOWN()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CQueueFaxSampleDlg dialog

CQueueFaxSampleDlg::CQueueFaxSampleDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CQueueFaxSampleDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CQueueFaxSampleDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CQueueFaxSampleDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CQueueFaxSampleDlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CQueueFaxSampleDlg, CDialog)
	//{{AFX_MSG_MAP(CQueueFaxSampleDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_COMMAND(ID_HELP_ABOUT, OnHelpAbout)
	ON_COMMAND(ID_HELP_FAXCSKDHELP, OnHelpFaxcskdhelp)
	ON_COMMAND(ID_FAX_OPEN_COMPORT, OnFaxOpenComport)
	ON_WM_CREATE()
	ON_WM_DESTROY()
	ON_COMMAND(ID_FAX_CLOSEPORTCHANNEL, OnFaxCloseportchannel)
	ON_COMMAND(ID_FAX_OPEN_BROOKTROUTCHANNEL, OnFaxOpenBrooktroutchannel)
	ON_COMMAND(ID_FILE_CLEAR, OnFileClear)
	ON_COMMAND(ID_FAX_SEND, OnFaxSend)
	ON_UPDATE_COMMAND_UI(ID_FAX_OPEN_COMPORT, OnUpdateFaxOpenComport)
	ON_UPDATE_COMMAND_UI(ID_FAX_OPEN_BROOKTROUTCHANNEL, OnUpdateFaxOpenBrooktroutchannel)
	ON_COMMAND(ID_FILE_EXIT, OnFileExit)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CQueueFaxSampleDlg message handlers

BOOL CQueueFaxSampleDlg::OnInitDialog()
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
	CListBox *evnt = (CListBox *) GetDlgItem(IDC_EVENTLIST);

	evnt->AddString("This sample will show how to send faxes with different priority. The sample will send ten faxes.");
	evnt->AddString("Each fax is created from a randomly loaded page from the \"Testqueue.tif\" file.");
	evnt->AddString("The priority level of the fax is set based on the random page number loaded TIFF file.");
	evnt->AddString("The fax objects are added to the queue. Higher priority faxes will be sent before lower priority faxes.");
	evnt->AddString("At the receiving end, the faxes should be received in priority order (higher first),");
	evnt->AddString("regardless of the random order the fax was put on the queue. To use the sample");
	evnt->AddString("open a COM port or fax channel than start sending the faxes using the \"Send\" menu item.");
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CQueueFaxSampleDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CQueueFaxSampleDlg::OnPaint() 
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
HCURSOR CQueueFaxSampleDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CQueueFaxSampleDlg::OnHelpAbout() 
{
	CAboutDlg dlgAbout;
	dlgAbout.DoModal();
	
}

HBRUSH CAboutDlg::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor) 
{
	HBRUSH hbr = CDialog::OnCtlColor(pDC, pWnd, nCtlColor);
	
	if (nCtlColor == CTLCOLOR_STATIC)
    {    
         if (pWnd == GetDlgItem(IDC_WEB) || pWnd==GetDlgItem(IDC_EMAIL))
              pDC->SetTextColor(RGB(0, 0, 255));
    }

	return hbr;
}

void CAboutDlg::OnMouseMove(UINT nFlags, CPoint point) 
{
	CRect rectWeb,rectMail;
	m_cWebPage.GetWindowRect(&rectWeb);
	m_cMail.GetWindowRect(&rectMail);
	ScreenToClient(rectWeb);
	ScreenToClient(rectMail);
	if (rectWeb.PtInRect(point) || rectMail.PtInRect(point))
		SetCursor(LoadCursor(NULL, MAKEINTRESOURCE(32649)));	
	CDialog::OnMouseMove(nFlags, point);
}

void CAboutDlg::OnLButtonDown(UINT nFlags, CPoint point) 
{
	CRect rectWeb,rectMail;
	CString web, mail="mailto:";
	m_cWebPage.GetWindowRect(&rectWeb);
	m_cMail.GetWindowRect(&rectMail);
	ScreenToClient(rectWeb);
	ScreenToClient(rectMail);
	if (rectWeb.PtInRect(point))
	{
		m_cWebPage.GetWindowText(web);
		VisitTo(&web);		
	}
	else if (rectMail.PtInRect(point))
	{
		m_cMail.GetWindowText(web);
		mail+=web;
		VisitTo(&mail);
	}	
	CDialog::OnLButtonDown(nFlags, point);
}

void CAboutDlg::VisitTo(CString *page)
{
	HINSTANCE hRet = ShellExecute( NULL, "open", page->GetBuffer(1024),
		NULL, NULL, SW_SHOWNORMAL );
	switch ((long)hRet)
	{
		case 0 : 
			AfxMessageBox("The operating system is out of memory or resources.");
			break;
		case ERROR_FILE_NOT_FOUND :
			AfxMessageBox("The specified file was not found.");
			break;
		case ERROR_PATH_NOT_FOUND :
			AfxMessageBox("The specified path was not found.");
			break;
		case ERROR_BAD_FORMAT :
			AfxMessageBox("The .exe file is invalid (non-Win32® .exe or error in .exe image).");
			break;
		case SE_ERR_ACCESSDENIED :
			AfxMessageBox("The operating system denied access to the specified file.");
			break;
		case SE_ERR_ASSOCINCOMPLETE :
			AfxMessageBox("The file name association is incomplete or invalid.");
			break;
		case SE_ERR_DDEBUSY :
			AfxMessageBox("The DDE transaction could not be completed because other DDE transactions were being processed.");
			break;
		case SE_ERR_DDEFAIL :
			AfxMessageBox("The DDE transaction failed.");
			break;
		case SE_ERR_DDETIMEOUT :
			AfxMessageBox("The DDE transaction could not be completed because the request timed out.");
			break;
		case SE_ERR_DLLNOTFOUND :
			AfxMessageBox("The specified dynamic-link library was not found.");
			break;
		case SE_ERR_NOASSOC :
			AfxMessageBox("There is no application associated with the given file name extension. This error will also be returned if you attempt to print a file that is not printable.");
			break;
		case SE_ERR_OOM :
			AfxMessageBox("There was not enough memory to complete the operation.");
			break;
		case SE_ERR_SHARE :
			AfxMessageBox("A sharing violation occurred.");
			break;
		case -1 : 
			AfxMessageBox("Invalid window state parameter.");
			break;
	}	
}

void CQueueFaxSampleDlg::OnHelpFaxcskdhelp() 
{
	HINSTANCE hRet = ShellExecute( NULL, "open", "..\\Help\\Black_Ice_Fax_C++_SDK_Help.chm",
		NULL, NULL, SW_SHOWNORMAL );	
	switch ((long)hRet)
	{
		case 0 : 
			AfxMessageBox("The operating system is out of memory or resources.");
			break;
		case ERROR_FILE_NOT_FOUND :
			AfxMessageBox("The specified file was not found.");
			break;
		case ERROR_PATH_NOT_FOUND :
			AfxMessageBox("The specified path was not found.");
			break;
		case ERROR_BAD_FORMAT :
			AfxMessageBox("The .exe file is invalid (non-Win32® .exe or error in .exe image).");
			break;
		case SE_ERR_ACCESSDENIED :
			AfxMessageBox("The operating system denied access to the specified file.");
			break;
		case SE_ERR_ASSOCINCOMPLETE :
			AfxMessageBox("The file name association is incomplete or invalid.");
			break;
		case SE_ERR_DDEBUSY :
			AfxMessageBox("The DDE transaction could not be completed because other DDE transactions were being processed.");
			break;
		case SE_ERR_DDEFAIL :
			AfxMessageBox("The DDE transaction failed.");
			break;
		case SE_ERR_DDETIMEOUT :
			AfxMessageBox("The DDE transaction could not be completed because the request timed out.");
			break;
		case SE_ERR_DLLNOTFOUND :
			AfxMessageBox("The specified dynamic-link library was not found.");
			break;
		case SE_ERR_NOASSOC :
			AfxMessageBox("There is no application associated with the given file name extension. This error will also be returned if you attempt to print a file that is not printable.");
			break;
		case SE_ERR_OOM :
			AfxMessageBox("There was not enough memory to complete the operation.");
			break;
		case SE_ERR_SHARE :
			AfxMessageBox("A sharing violation occurred.");
			break;
		case -1 : 
			AfxMessageBox("Invalid window state parameter.");
			break;
	}		
	
}


void CQueueFaxSampleDlg::OnFaxOpenComport() 
{
	CdlgFaxPortSetup dlgFaxPortSetup;

    dlgFaxPortSetup.DoModal();
	
}

int CQueueFaxSampleDlg::OnCreate(LPCREATESTRUCT lpCreateStruct) 
{
	CQueueFaxSampleApp *pApp = (CQueueFaxSampleApp *)AfxGetApp();
	if (CDialog::OnCreate(lpCreateStruct) == -1)
		return -1;

    if(SetupFaxDriver(NULL) || SetFaxMessage(this->m_hWnd))
        AfxMessageBox("Setting fax driver has failed!");
#if defined(WIN32)
    pApp->BrooktroutChannels = GetChannelInfo();
    pApp->m_nGammaChannel = G_GetChannelNum();
    pApp->m_nDialogicBoard = D_GetBoardNum();
	pApp->m_nBicomBoard = BCM_GetBoardNum();
    pApp->m_nCmtxChannels = C_GetChannelNum();
    pApp->m_nNmsBoard = NMS_GetBoardNum();

#else
    pApp->BrooktroutChannels = NULL;
    pApp->m_nGammaChannel = 0;
    pApp->m_nDialogicBoard = 0;
	pApp->m_nBicomBoard = 0;
	pApp->m_nCmtxChannels = 0;
    pApp->m_nNmsBoard = 0;
	
#endif
    if ( GetProfileInt("StartUp", "PulseDial", 0) )
    SetRuningMode(RNM_HALTINFRAME);

	// TODO: Add your specialized creation code here
	
	return 0;
}

void CQueueFaxSampleDlg::SetEventText(int iPort, LPSTR buf)
{
    char buf2[200];
	CQueueFaxSampleApp *App = (CQueueFaxSampleApp *)AfxGetApp();
	CListBox *evnt = (CListBox *) GetDlgItem(IDC_EVENTLIST);
    char timebuf[20];
    LPSTR ptime;

    ptime = _strtime(timebuf);

    if ( iPort>=0 && iPort<MAX_FAXPORTS ) {
#if defined(WIN32)
        if ( App->nComm[iPort] >= (MAX_COMPORTS+MAX_FAXCHANNELS) )
            wsprintf(buf2, "%s%i %s  %s",G_PORTNAME, App->nComm[iPort]-(MAX_COMPORTS+MAX_FAXCHANNELS), ptime, buf);
        else if ( App->nComm[iPort] >= MAX_COMPORTS )
            wsprintf(buf2, "%s%i %s  %s",B_PORTNAME, App->nComm[iPort]-MAX_COMPORTS, ptime, buf);
        else
#endif
            wsprintf(buf2, "COM%i %s  %s", App->nComm[iPort], ptime, buf);
        evnt->AddString(buf2);
    }
    else {
        wsprintf(buf2, "%s  %s", ptime, buf);
        evnt->AddString(buf2);
    }
    int nn = evnt->GetCount();
    if ( nn>200 ) {
        for(int kk=0; kk<5; kk++)
            evnt->DeleteString(0);
        evnt->SetCurSel(evnt->GetCount()-1);
    }
}

void CQueueFaxSampleDlg::OnDestroy() 
{
	CDialog::OnDestroy();

    CQueueFaxSampleApp *pApp = (CQueueFaxSampleApp *)AfxGetApp();

    for(int i=0;i<MAX_FAXPORTS;i++){
        if ( pApp->FaxPorts[i] ) {
            if ( pApp->FaxPorts[i]->IsOpen() ) {
                pApp->FaxPorts[i]->AbortFax();
            }
        }
    }
    
    KillFaxMessage(this->m_hWnd);
    EndOfFaxDriver(TRUE);
	
	// TODO: Add your message handler code here
	
}

void CQueueFaxSampleDlg::OnFaxCloseportchannel() 
{
	CDlgFaxClose dlgCloseFaxPort;

    dlgCloseFaxPort.DoModal();
}

void CQueueFaxSampleDlg::OnFaxOpenBrooktroutchannel() 
{
	
	CBOpen dlgOpenBrooktrout;

    dlgOpenBrooktrout.DoModal();
}

void CQueueFaxSampleDlg::OnFileClear() 
{
	CListBox *event=(CListBox*) GetDlgItem(IDC_EVENTLIST);
	event->ResetContent();
}


void CQueueFaxSampleDlg::OnFaxSend() 
{
	BOOL CanShow=FALSE;
	CQueueFaxSampleApp *pApp = (CQueueFaxSampleApp *)AfxGetApp();
	for(int i=0;i<MAX_FAXPORTS;i++){
        if ( pApp->FaxPorts[i] ) {
            if ( pApp->FaxPorts[i]->IsOpen() ) {
                CanShow=TRUE;
            }
        }
    }
	if (CanShow){
	CDlgSendFax dlgSendFax;

    dlgSendFax.DoModal();	}
	else AfxMessageBox("There is no open port or channel");
}


void CQueueFaxSampleDlg::OnUpdateFaxOpenComport(CCmdUI* pCmdUI) 
{
	CQueueFaxSampleApp *pApp = (CQueueFaxSampleApp *)AfxGetApp();
    BOOL bEnable = FALSE;

    for(int i=0;i<MAX_FAXPORTS;i++) {
        if (!pApp->FaxPorts[i]) {
            bEnable = TRUE ;
        } else {
            if (!pApp->FaxPorts[i]->IsOpen()){
                bEnable = TRUE ;
                break ;
            }
        }
    }
    pCmdUI->Enable(bEnable) ;	
}

void CQueueFaxSampleDlg::OnUpdateFaxOpenBrooktroutchannel(CCmdUI* pCmdUI) 
{
	CQueueFaxSampleApp         *pApp = (CQueueFaxSampleApp *)AfxGetApp();
    BOOL bEnable = FALSE;

    if ( pApp->BrooktroutChannels && pApp->BrooktroutChannels[0] )
                bEnable = TRUE ;
	else AfxMessageBox("There is no available Brooktrout channel!");
    pCmdUI->Enable(bEnable) ;
}

void CQueueFaxSampleDlg::OnFileExit() 
{
	CDialog::OnOK();
}

static LPSTR MakeTerminationText(TETerminationStatus TCode)
{
    switch(TCode){
		case TRM_NORMAL: 
			return "OK";
        case  TRM_NONE :
            return "Session not terminated" ;
        case TRM_ABORT :
            return "User Abort" ;
        case TRM_UNSPECIFIED :
            return "Unspecified error" ;
        case TRM_RINGBACK :
            return "Ringback detect" ;
        case TRM_NO_CARRIER :
            return "No carrier detected" ;
        case TRM_BUSY :
            return "The remote station is BUSY" ;
        case TRM_PHASE_A :
            return "Uspecified phase A error" ;
        case TRM_PHASE_B :
            return "Unspecified phase B error" ;
        case TRM_NO_ANSWER :
            return "No Answer" ;
        case TRM_NO_DIALTONE :
            return "No dialtone" ;
        case TRM_INVALID_REMOTE :
            return  "Remote modem cannot receive or send " ;
        case TRM_COMREC_ERROR :
            return "Command not received" ;
        case TRM_INVALID_COMMAND :
            return "Incvalid command received" ;
        case TRM_INVALID_RESPONSE :
            return "Invalid response received" ;
        case TRM_DCS_SEND :
            return "DCS send 3 times without answer" ;
        case TRM_DIS_RECEIVED :
            return "DIS received 3 times" ;
        case TRM_DIS_NOTRECEIVED :
            return "DIS not received" ;
        case TRM_TRAINING :
            return "Failure training in 2400 bit/s" ;
        case TRM_TRAINING_MINSPEED :
            return "Training failure : minimum speed reached." ;
        case TRM_PHASE_C  :
            return "Error in page transmission" ;
        case TRM_IMAGE_FORMAT :
            return "Unspecified image format" ;
        case TRM_IMAGE_CONVERSION :
            return "Image conversion error" ;
        case TRM_DTE_DCE_DATA_UNDERFLOW :
            return "DTE to DCE data underflow" ;
        case TRM_UNRECOGNIZED_CMD :
            return "Unrecognized transparent data command" ;
        case TRM_IMAGE_LINE_LENGTH:
            return "Image error line length wrong" ;
        case TRM_IMAGE_PAGE_LENGTH  :
            return "Page length wrong" ;
        case TRM_IMAGE_COMPRESSION :
            return "wrong compression mode" ;
        case TRM_PHASE_D :
            return "Unspecified phase D error" ;
        case TRM_MPS :
            return "No response to MPS" ;
        case TRM_MPS_RESPONSE :
            return "Invalid response to MPS" ;
        case TRM_EOP :
            return "No response to EOP" ;
        case TRM_EOP_RESPONSE :
            return "Invalid response to EOP" ;
        case TRM_EOM :
            return "No response to EOM" ;
        case TRM_EOM_RESPONSE :
            return "Invalid response to EOM" ;
        case TRM_UNABLE_TO_CONTINUE :
            return "Unable to continue after PIN or PPP" ;
        case TRM_T2_TIMEOUT :
            return "T.30 T2 timeout expected" ;
        case TRM_T1_TIMEOUT :
            return "T.30 T1 timeout expected" ;
        case TRM_MISSING_EOL :
            return "Missing EOL after 5 sec" ;
        case TRM_BAD_CRC :
            return "Bad CRC or Frame" ;
        case TRM_DCE_DTE_DATA_UNDERFLOW :
            return "DCE to DTE data underflow" ;
        case TRM_DCE_DTE_DATA_OVERFLOW :
            return "DCE to DTE data overflow" ;
        case TRM_INVALID_REMOTE_RECEIVE :
            return "Remote cannot receive" ;
        case TRM_INVALID_REMOTE_ECM :
            return "Invalid remote ECM mode " ;
        case TRM_INVALID_REMOTE_BFT:
            return "Invalid remote BFT mode" ;
        case TRM_INVALID_REMOTE_WIDTH:
            return "Invalid remote width" ;
        case TRM_INVALID_REMOTE_LENGTH :
            return "Invalid remote length" ;
        case TRM_INVALID_REMOTE_COMPRESS:
            return "Invalid remote compression " ;
        case TRM_INVALID_REMOTE_RESOLUTION :
            return "Invalid remote resolution" ;
        case TRM_NO_SEND_DOCUMET :
            return "No transmitting document" ;
        case TRM_PPS_RESPONSE :
            return "No response to PPS" ;
        case TRM_NOMODEM :
            return "No modem on com port" ;
        case TRM_INVALIDCLASS:
            return "Incompatible modem" ;
        case TRM_HUMANVOICE: //rz
            return "Human answer detected";
#if defined(WIN32)
        case TRM_B_FILEIO:
            return "Brooktrout: File I/O error occured." ;
        case TRM_B_FILEFORMAT:
            return "Brooktrout: Bad file format." ;
        case TRM_B_BOARDCAPABILITY:
            return "Brooktrout: Line card firmware does not support capability." ;
        case TRM_B_NOTCONNECTED:
            return "Brooktrout: Channel is not in proper state." ;
        case TRM_B_BADPARAMETER:
            return "Brooktrout: Bad parameter value used." ;
        case TRM_B_MEMORY:
            return "Brooktrout: Memory allocation error." ;
        case TRM_B_BADSTATE:
            return "Brooktrout: The channel is not in a required state." ;
        case TRM_B_NO_LOOP_CURRENT:
            return "Brooktrout: No loop current detected." ;
        case TRM_B_LOCAL_IN_USE:
            return "Brooktrout: Local phone in use." ;
        case TRM_B_CALL_COLLISION:
            return "Brooktrout: Ringing detected during dialing." ;
        case TRM_B_CONFIRM:
            return "Confirmation tone detected." ;
        case TRM_B_DIALTON:
            return "Dial tone detected; the dialing sequence did not brake dial tone." ;
        case TRM_B_G2_DETECTED:
            return "Group 2 fax machine detected. Remote fax machine is capable of sending and receiving G2 facsimiles only." ;
        case TRM_B_HUMAN:
            return "Answer (probable human) detected; does not match any other expected call progress signal patterns." ;
        case TRM_B_QUIET:
            return "After dialing the number, no energy detected on the line, possible dead line." ;
        case TRM_B_RECALL:
            return "Recall dial tone detected." ;
        case TRM_B_RNGNOANS:
            return "The remote end was ringing but did not answer." ;
        case TRM_B_SITINTC:
            return "Intercept tone detected; invalid telephone number or class of service restriction." ;
        case TRM_B_SITNOCIR:
            return "No circuit detected; end office or carrier originating failure; possible dead line." ;
        case TRM_B_SITREORD:
            return "Reorder tone detected; end office or carrier originating failure." ;
        case TRM_B_SITVACOE:
            return "Vacant tone detected; remote originating failure; invalid telephone number." ;
        case TRM_B_UNSPECIFIED:
            return "Brooktrout error." ;
        case TRM_B_NO_WINK:
            return "Brooktrout error : no wink." ;
        case TRM_B_RSPREC_VCNR:
            return "Brooktrout error : RSPREC invalid response received." ;
        case TRM_B_COMREC_DCN:
            return "Brooktrout error : DCN received in COMREC." ;
        case TRM_B_RSPREC_DCN:
            return "Brooktrout error : DCN received in RSPREC." ;
        case TRM_B_INCOMPAT_FMT:
            return "Brooktrout error : Incompatible fax formats." ;
        case TRM_B_INVAL_DMACNT:
            return "Brooktrout error : Invalid DMA count specified for transmitter." ;
        case TRM_B_FTM_NOECM:
            return "Brooktrout error : Binary File Transfer specified, but ECM not enabled on transmitter.";
        case TRM_B_INCMP_FTM:
            return "Brooktrout error : Binary File Transfer specified, but not supported by receiver.";
        // phase D hangup codes
        case TRM_B_RR_NORES:
            return "Brooktrout error : No response to RR after three tries." ;
        case TRM_B_CTC_NORES:
            return "Brooktrout error : No response to CTC, or response was not CTR." ;
        case TRM_B_T5TO_RR:
            return "Brooktrout error : T5 time out since receiving first RNR." ;
        case TRM_B_NOCONT_NSTMSG:
            return "Brooktrout error : Do not continue with next message after receiving ERR." ;
        case TRM_B_ERRRES_EOREOP:
            return "Brooktrout error : ERR response to EOR-EOP or EOR-PRI-EOP." ;
        case TRM_B_SE:
            return "Brooktrout error : RSPREC error." ;
        case TRM_B_EORNULL_NORES:
            return "Brooktrout error : No response received after third try for EOR-NULL." ;
        case TRM_B_EORMPS_NORES:
            return "Brooktrout error : No response received after third try for EOR-MPS." ;
        case TRM_B_EOREOP_NORES:
            return "Brooktrout error : No response received after third try for EOR-EOP." ;
        case TRM_B_EOREOM_NORES:
            return "Brooktrout error : No response received after third try for EOR-EOM." ;
        // receive phase B hangup codes
        case TRM_B_RCVB_SE:
            return "Brooktrout error : RSPREC error." ;
        case TRM_B_NORMAL_RCV:
            return "Brooktrout error : DCN received in COMREC." ;
        case TRM_B_RCVB_RSPREC_DCN:
            return "Brooktrout error : DCN received in RSPREC." ;
        case TRM_B_RCVB_INVAL_DMACNT:
            return "Brooktrout error : Invalid DMA count specified for receiver." ;
        case TRM_B_RCVB_FTM_NOECM:
            return "Brooktrout error : Binary File Transfer specified, but ECM supported by receiver." ;
        // receive phase D hangup codes
        case TRM_B_RCVD_SE_VCNR:
            return "Brooktrout error : RSPREC invalid response received." ;
        case TRM_B_RCVD_COMREC_VCNR:
            return "Brooktrout error : COMREC invalid response received." ;
        case TRM_B_RCVD_T3TO_NORESP:
            return "Brooktrout error : T3 time-out; no local response for remote voice interrupt." ;
        case TRM_B_RCVD_T2TO:
            return "Brooktrout error : T2 time-out; no command received after responding RNR." ;
        case TRM_B_RCVD_DCN_COMREC:
            return "Brooktrout error : DCN received for command received." ;
        case TRM_B_RCVD_COMREC_ERR:
            return "Brooktrout error : Command receive error." ;
        case TRM_B_RCVD_BLKCT_ERR:
            return "Brooktrout error : Receive block count error in ECM mode." ;
        case TRM_B_RCVD_PGCT_ERR:
            return "Brooktrout error : Receive page count error in ECM mode." ;



        case TRM_BI_OUTOFMEMORY:
            return "Bicom error: Insufficient memory to complete operation.";
        case TRM_BI_QUEUE_CORRUPTED:
            return "Bicom error: Queue structure is corrupted";
        case TRM_BI_INVALID_QUEUE:
            return "Bicom error: Queue handle is invalid";
        case TRM_BI_QUEUE_EMPTY:
            return "Bicom error: No documents in the given queue";
        case TRM_BI_DOCUMENT_NOT_FOUND:
            return "Bicom error: Attempted to delete document not in the queue.";
        case TRM_BI_NOCHANNEL:
            return "Bicom error: No Channel Open.";
        case TRM_BI_NO_LINE:
            return "Bicom error: No line.";
        case TRM_BI_RESOURCE_ERROR:
            return "Bicom error: Error allocating a fax resource.";
        case TRM_BI_NO_RESOURCES_AVAILABLE:
            return "Bicom error: No resource available.";
        case TRM_BI_BADFILENAME:
            return "Bicom error: Bad filename.";
        case TRM_BI_INVALIDRES:
            return "Bicom error: Invalid resoultion parameter.";
        case TRM_BI_INVALIDENCODING:
            return "Bicom error: Bad encoding.";
        case TRM_BI_CREATE_ERROR:
            return "Bicom error: Attempted to delete document not in the queue.";
        case TRM_BI_INVALID_PAGE_TYPE:
            return "Bicom error: Invalid page type.";
        case TRM_BI_INVALID_PAGE_LEN:
            return "Bicom error: Invalid page size.";
        case TRM_BI_NOQUEUE:
            return "Bicom error: No queue.";
        case TRM_BI_NOTRAININGRESP:
            return "Bicom error: Failed waiting for training response.";
        case TRM_BI_NORESPONSE:
            return "Bicom error: Timed out waiting for response to the Post Message signal.";
        case TRM_BI_BAD_RESOLUTION:
            return "Bicom error: Document resolution mismatch.";
        case TRM_BI_BADENCODING:
            return "Bicom error: Image encoding mismach.";
        case TRM_BI_NODOCUMENT:
            return "Bicom error: No document.";
//commetrex
        case TRM_CMTRX_BAD_ARGUMENT:
            return "Commetrex error: Bad argument.";
        case TRM_CMTRX_OUT_OF_MEMORY:
            return "Commetrex error: Out of memory.";
        case TRM_CMTRX_INVALID_PORT:
            return "Commetrex error: Invalid port.";
        case TRM_CMTRX_CONNECT_FAILED:
            return "Commetrex error: Connect failed.";
        case TRM_CMTRX_ALREADY_ACTIVE:
            return "Commetrex error: Port already active.";
        case TRM_CMTRX_NOT_ACTIVE:
            return "Commetrex error: Port not active.";
        case TRM_CMTRX_NEGOTIATION_FAILED:
            return "Commetrex error: Negotiation failed.";
        case TRM_CMTRX_NO_MORE_LICENSES:
            return "Commetrex error: No more licenses.";
        case TRM_CMTRX_NO_LICENSE:
            return "Commetrex error: No licenses.";
        case TRM_CMTRX_LICENSE_ALREADY_ALLOC:
            return "Commetrex error: License already allocated.";
        case TRM_CMTRX_QUEUE_EMPTY:
            return "Commetrex error: Queue empty.";
        case TRM_CMTRX_FILE_EXISTS:
            return "Commetrex error: File already exist.";
        case TRM_CMTRX_FILE_NOT_FOUND:
            return "Commetrex error: File not found.";
        case TRM_CMTRX_BAD_FILE_FORMAT:
            return "Commetrex error: Bad file format.";
        case TRM_CMTRX_INVALID_DOC:
            return "Commetrex error: Invalid document.";
        case TRM_CMTRX_QUEUE_TOO_LATE:
            return "Commetrex error: Queue modification too late.";
        case TRM_CMTRX_SESSION_FAILED:
            return "Commetrex error: Session failed.";
        case TRM_CMTRX_UNSUPPORTED:
            return "Commetrex error: Unsupported operation.";
        case TRM_CMTRX_OPEN_QUEUE_FAILED:
            return "Commetrex error: Open queue failed.";
        case TRM_CMTRX_BAD_PAGE_SIZE:
            return "Commetrex error: Bad page size.";
        case TRM_CMTRX_FILE_IO_FAILURE:
            return "Commetrex error: File I/O failure.";
        case TRM_CMTRX_CONVERSION_REQUIRED:
            return "Commetrex error: Conversion required.";
        case TRM_CMTRX_NO_MORE_DOCUMENTS:
            return "Commetrex error: No more documents.";
        case TRM_CMTRX_INCORRECT_LIBRARY_VERSION:
            return "Commetrex error: Incorrect library version.";
        case TRM_CMTRX_RATE_TOO_LOW:
            return "Commetrex error: Rate too low.";
        case TRM_CMTRX_QUEUE_OVERFLOW:
            return "Commetrex error: Queue overflow.";
        case TRM_CMTRX_ALREADY_ATTACHED:
            return "Commetrex error: Unknown error.";
        case TRM_CMTRX_IMAGE_RECEIVE_FAIL:
            return "Commetrex error: Image receive failed.";
        case TRM_CMTRX_CPCD_BUSY:
            return "Commetrex error: CPCD busy.";
        case TRM_CMTRX_FAILURE:
            return "Commetrex error: Unknown error.";
        case TRM_CMTRX_NO_FAX_RESOURCES:
            return "Commetrex error: No fax responde.";
        case TRM_CMTRX_NO_RESOURCE_ASSIGNED:
            return "Commetrex error: No resource assigned.";
        case TRM_CMTRX_NO_CPCD_PORT:
            return "Commetrex error: No CPCD port.";
        case TRM_CMTRX_NO_PASSWORD:
            return "Commetrex error: No password.";
        case TRM_CMTRX_MONITOR_MISSING:
            return "Commetrex error: Unknown error.";
        case TRM_CMTRX_MSEC_WAS_ALLOCATED:
            return "Commetrex error: Unknown error.";
        case TRM_CMTRX_DIS_REJECT_REQUESTED:
            return "Commetrex error: DIS reject requested.";
        case TRM_CMTRX_DIS_SIGNAL:
            return "Commetrex error: Out-of-band remote disconnect.";
        case TRM_CMTRX_DIS_CLEARDOWN_TONE:
            return "Commetrex error: In-band remote disconnect .";
        case TRM_CMTRX_DIS_RING_STUCK:
            return "Commetrex error: Incoming ring stuck to long.";
        case TRM_CMTRX_DIS_HOST_TIMEOUT:
            return "Commetrex error: Host did not respond in time.";
        case TRM_CMTRX_DIS_REMOTE_ABANDONED:
            return "Commetrex error: Loop-start inbound stopped ringing.";
        case TRM_CMTRX_DIS_TRANSFER:
            return "Commetrex error: Transfer completed .";
        case TRM_CMTRX_DIS_DIAL_FAILURE:
            return "Commetrex error: Dial had a failure.";
        case TRM_CMTRX_DIS_NO_WINK:
            return "Commetrex error: No wink when dialing out.";
        case TRM_CMTRX_DIS_NO_DIALTONE:
            return "Commetrex error: No dialtone to dialing out (LPS).";
        case TRM_CMTRX_OUTOFSERVICE:
            return "Commetrex error: Port out of service (Probably no line connected to the port).";
//nms
        case TRM_NMS_BAD_ARGUMENT:
            return "NMS error:Bad argument.";
        case TRM_NMS_FILE_EXISTS:
            return "NMS error:File already exist.";
        case TRM_NMS_FILE_NOT_FOUND:
            return "NMS error:File not found.";
        case TRM_NMS_INVALID_CTAHANDLE:
            return "NMS error:Invalid CTA handle.";
        case TRM_NMS_INVALID_HANDLE:
            return "NMS error:Invalid handle.";
        case TRM_NMS_BAD_FILE_FORMAT:
            return "NMS error:Bad file format.";
        case TRM_NMS_OUTOFSERVICE:
            return "NMS error:Port out of service (Probably no line connected to the port).";
        case TRM_NMS_NO_MORE_LICENSES:
            return "NMS error:No more licenses.";
        case TRM_NMS_FUNCTION_ACTIVE:
            return "NMS error:Function already active.";
        case TRM_NMS_QUEUE_EMPTY:
            return "NMS error: Queue empty.";
        case TRM_NMS_CONNECT_FAILED:
            return "NMS error:Connect failed.";
        case TRM_NMS_NEGOTIATION_FAILED:
            return "NMS error:Negotiation failed.";
        case TRM_NMS_NO_LICENSE:
            return "NMS error:No fax licenses.";
        case TRM_NMS_LICENSE_ALREADY_ALLOC:
            return "NMS error: Licese already allocated.";
        case TRM_NMS_SESSION_FAILED:
            return "NMS error:Session failed.";
        case TRM_NMS_OPEN_QUEUE_FAILED:
            return "NMS error:Open queue failed.";
        case TRM_NMS_BAD_PAGE_SIZE:
            return "NMS error:Bad page size.";
        case TRM_NMS_CONVERSION_REQUIRED:
            return "NMS error:Conversion required.";
        case TRM_NMS_NO_MORE_DOCUMENTS:
            return "NMS error:No more documents.";
        case TRM_NMS_RATE_TOO_LOW:
            return "NMS error: Transfer rate too low.";
        case TRM_NMS_BUFFER_UNDERRUN:
            return "NMS error:Buffer underrun.";
        case TRM_NMS_NO_MODEMS:
            return "NMS error:No modems.";
        case TRM_NMS_NO_PPM:
            return "NMS error:No PPM.";
        case TRM_NMS_NO_PPM_RESPONSE:
            return "NMS error:No PPM response.";
        case TRM_NMS_INCOMPATIBLE_RECEIVER:
            return "NMS error:Incompatible receiver.";
        case TRM_NMS_PROTOCOL_ERROR:
            return "NMS error:Protocol error.";
        case TRM_NMS_REMOTE_DCN:
            return "NMS error:Remote DCN.";

#endif
        }
        return "" ;
}

LRESULT CQueueFaxSampleDlg::DefWindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	PORTFAX pFax = NULL;
	CQueueFaxSampleApp *pApp = (CQueueFaxSampleApp *)AfxGetApp();
    if(message == pApp->nMessage)
    {
		CListBox *evnt = (CListBox *) GetDlgItem(IDC_EVENTLIST);
		pFax = (PORTFAX)lParam;
				
		if (pFax!=NULL)
		{
			int iPort = -1;
			for(int jj=0; jj<MAX_FAXPORTS; jj++)
				if(pApp->FaxPorts[jj] == pFax) 
				{
					iPort = jj;
					break;
				}
			if (iPort!=-1)
			{
				FAXOBJ faxobj=(FAXOBJ) lParam;
				switch(wParam)
				{
					case MFX_DIAL:
						pApp->FaxEventText(iPort, "---");
						pApp->FaxEventText(iPort, "Dialing...");
						break;
					case MFX_STARTSEND:
						pApp->FaxEventText(iPort, "Starting to send from queue...");
						break;
					case MFX_STARTPAGE:
						pApp->FaxEventText(iPort, "Starting page...");
						break;
					case MFX_ENDPAGE:
						pApp->FaxEventText(iPort, "Ending page...");
						break;
					case MFX_ENDSEND:
						pApp->FaxEventText(iPort, "Sending finished.");
						ClearFaxObj(faxobj);
						break;
					case MFX_TERMINATE:
						TSSessionParameters CSession ;
						GetSessionParameters(pFax,&CSession);
						pApp->FaxEventText(iPort, "Transmission terminated.");
						char buf[200];
						wsprintf(buf,"%s%s","Termination status: ",MakeTerminationText(CSession.TStatus));
						pApp->FaxEventText(iPort, buf);
						wsprintf(buf,"%s%i%s", "Connected for: ",CSession.dwConnectTime," milliseconds");
						pApp->FaxEventText(iPort, buf);
						break;

				}
			}
		}

    }
	return CDialog::DefWindowProc(message, wParam, lParam);
}
