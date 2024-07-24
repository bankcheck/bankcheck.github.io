// FaxWithBrooktroutDlg.cpp : implementation file
//

#include "stdafx.h"
#include "faxcpp.h"
#include "faxclass.h"

#include "FaxWithBrooktrout.h"
#include "FaxWithBrooktroutDlg.h"
#include "DlgFaxClose.h"
#include "BOpen.h"
#include "dlgSendFax.h"
#include "commcl.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


#define TIMER_INTERVAL 30

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
	afx_msg void OnDestroy();
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
	ON_WM_DESTROY()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFaxWithBrooktroutDlg dialog

CFaxWithBrooktroutDlg::CFaxWithBrooktroutDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CFaxWithBrooktroutDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CFaxWithBrooktroutDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CFaxWithBrooktroutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CFaxWithBrooktroutDlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CFaxWithBrooktroutDlg, CDialog)
	//{{AFX_MSG_MAP(CFaxWithBrooktroutDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_WM_CREATE()
	ON_BN_CLICKED(IDC_BROOKTROUT, OnBrooktrout)
	ON_BN_CLICKED(IDC_CLOSE, OnClose)
	ON_BN_CLICKED(IDC_STARTSESSION, OnStartsession)
	ON_BN_CLICKED(IDC_STOPSESSION, OnStopsession)
	ON_WM_TIMER()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFaxWithBrooktroutDlg message handlers

BOOL CFaxWithBrooktroutDlg::OnInitDialog()
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
	GetDlgItem(IDC_STOPSESSION)->EnableWindow(FALSE);
	CListBox *evnt = (CListBox *) GetDlgItem(IDC_EVENTLIST);
	evnt->AddString("This sample waits for a fax to be received on a channel and sends a fax 30 seconds later on the same channel if receiving");
	evnt->AddString("was OK or sends a fax on a channel and waits for a call on the same channel if sending was succesfull.");
	evnt->AddString("");
	evnt->AddString("Use two instances of this sample, one to start receiving and one to start sending.");
	evnt->AddString("");
	evnt->AddString("If sending was not successfull on a channel it will try to send the fax again 30 seconds later.");
	evnt->AddString("");
	evnt->AddString("If receiving was not successfull on a channel it will wait for another fax to be received. Received faxes will not be saved!");
	evnt->AddString("");
	evnt->AddString("To open a Brooktrout channel push \"Open Brooktrout Channel\", select from the available channels");
	evnt->AddString("and specify the btcall.cfg file using the \"Browse\" button.");
	evnt->AddString("");
	evnt->AddString("To close a Brooktrout channel push \"Close Brooktrout Channel\" and select from the open channels.");
	evnt->AddString("");
	evnt->AddString("Push \"Start Session\" to start a sending or receiving session with the open Brooktrout channels.");
	evnt->AddString("");
	evnt->AddString("Push \"Abort Session\" button to abort the runing session.");
	evnt->AddString("");
	evnt->AddString("To start a session you have to specify a destination fax number and a file to be sent for every open channel.");
	evnt->AddString("Use the \"Browse\" button on the \"Send/Receive Fax\" dialog to specify the file to be sent and push the \"Confirm\" button");
	evnt->AddString("to add the file to the selected channel.");
	evnt->AddString("");
	evnt->AddString("Specify the destination number and push the \"Confirm\" button to add the number to the selected channel.");
	evnt->AddString("");
	evnt->AddString("Push the \"Receive\" button on the \"Send/Receive Fax\" dialog to start a session which receives before starting");
	evnt->AddString("the sending session.");
	evnt->AddString("");
	evnt->AddString("Push the \"Send\" button on the \"Send/Receive Fax\" dialog to start a session which sends.");
	evnt->AddString("");
	evnt->AddString("This listbox will contain only the last 200 messages. The whole log can be found at C:\\BrooktroutTest.log.");

	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CFaxWithBrooktroutDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CFaxWithBrooktroutDlg::OnPaint() 
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
HCURSOR CFaxWithBrooktroutDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

int CFaxWithBrooktroutDlg::OnCreate(LPCREATESTRUCT lpCreateStruct) 
{
	if (CDialog::OnCreate(lpCreateStruct) == -1)
		return -1;
	BeginWaitCursor();
	CFaxWithBrooktroutApp *pApp = (CFaxWithBrooktroutApp *)AfxGetApp();
	if(SetupFaxDriver(NULL)|| SetFaxMessage(this->m_hWnd))
        AfxMessageBox("Setting fax driver has failed!");	
	pApp->BrooktroutChannels = GetChannelInfo();

	char szCFile[256];
	int countChannels=0;
	char* pStr;
	HMODULE hModule;
	hModule=GetModuleHandle("Faxcpp32.dll");
	char		szFilename [MAX_PATH];
	GetModuleFileName( hModule,   szFilename, MAX_PATH );
	pStr = strrchr(szFilename, '\\');
	if (pStr)
			strcpy(pStr, "\\BrookInfo.ini");
	memset( szCFile, 0, sizeof(szCFile) );
	GetPrivateProfileString("Config file", "cfgFile", "", szCFile, sizeof(szCFile),szFilename);
	int ChannelNum=GetPrivateProfileInt("ChannelNum","ChannelNr",0,szFilename);
	if (( pApp->BrooktroutChannels && pApp->BrooktroutChannels[0]))
	{
		for(int nCh=0 ; nCh < MAX_FAXCHANNELS && pApp->BrooktroutChannels[nCh] ; nCh++ )
		{
			if (countChannels==ChannelNum && countChannels!=0) break;
			if ( pApp->BrooktroutChannels[nCh] == 1 || // fax or tr114 channel
			    pApp->BrooktroutChannels[nCh] >= 3 ) 
			{
				char szCom[20];
	            if ( B_IsChannelFree( nCh ) )
				{
					strcpy( szCom, "Channel" );
					_itoa( nCh, &szCom[ strlen("Channel") ], 10 );
				}
				else memset( szCom, 0, sizeof(szCom) );				
			}
		}	
	}	
	EndWaitCursor();
	return 0;
}

void CAboutDlg::OnDestroy() 
{
	CDialog::OnDestroy();
	
	CFaxWithBrooktroutApp *pApp = (CFaxWithBrooktroutApp *)AfxGetApp();

    for(int i=0;i<MAX_FAXCHANNELS;i++){
        if ( pApp->FaxPorts[i] ) {
            if ( pApp->FaxPorts[i]->IsOpen() ) {
                pApp->FaxPorts[i]->AbortFax();
            }
        }
    }
    KillFaxMessage(this->m_hWnd);
    EndOfFaxDriver(TRUE);		
}

void CFaxWithBrooktroutDlg::OnBrooktrout() 
{
	CBOpen dlgBrook;
	CFaxWithBrooktroutApp *pApp = (CFaxWithBrooktroutApp *)AfxGetApp();

	if ( pApp->BrooktroutChannels && pApp->BrooktroutChannels[0] )
		dlgBrook.DoModal();	
   	else AfxMessageBox("There is no available Brooktrout Channel!");	
}

void CFaxWithBrooktroutDlg::OnClose() 
{
	CDlgFaxClose dlgClose;
	dlgClose.DoModal();		
}

void CFaxWithBrooktroutDlg::OnStartsession() 
{
	CFaxWithBrooktroutApp *pApp = (CFaxWithBrooktroutApp *)AfxGetApp();
	dlgSendFax SendFax;
    int modal=SendFax.DoModal();
	if (modal==RECEIVEPUSHED || modal==IDOK)
	{
		GetDlgItem(IDC_STARTSESSION)->EnableWindow(FALSE);
		GetDlgItem(IDC_STOPSESSION)->EnableWindow(TRUE);
		GetDlgItem(IDC_CLOSE)->EnableWindow(FALSE);
	}
	pApp->Aborted=false;
}

LRESULT CFaxWithBrooktroutDlg::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	PORTFAX pFax = NULL;	
	char	buf[150];
	int		actTimer=-1;
	UINT	timerToKill = 0;
	CString				channel;
	FAXOBJ				Fax;
	TSSessionParameters CSession;

	memset(&buf, 0, 150);

	CFaxWithBrooktroutApp *pApp = (CFaxWithBrooktroutApp *)AfxGetApp();
	if(message == pApp->nMessage)
    {
		/*
		sprintf(buf,"wParam = %d, lParam = %d",wParam, lParam);
		pApp->FaxEventText(buf);
		*/
		switch(wParam)
		{
			case MFX_ANSWER:
				pFax = (PORTFAX)lParam;
				if (pFax!=NULL)
				{
					channel=pApp->GetChannelName(pFax);
					sprintf(buf,"%s: MFX_ANSWER received.",channel);
					pApp->FaxEventText(buf);
				}
				break;

			case MFX_DIAL:
				pFax = (PORTFAX)lParam;
				if (pFax!=NULL)
				{
					channel=pApp->GetChannelName(pFax);
					sprintf(buf,"%s: Dialing...",channel);
					pApp->FaxEventText(buf);
				}
				break;

			case MFX_STARTPAGE:
				pFax = (PORTFAX)lParam;
				if (pFax!=NULL)
				{
					GetSessionParameters(pFax,&CSession);
					channel=pApp->GetChannelName(pFax);
					sprintf(buf,"%s: Starting page %d.",channel,CSession.PageNo+1);
					pApp->FaxEventText(buf);
				}
				break;

			case MFX_ENDPAGE:
				pFax = (PORTFAX)lParam;
				if (pFax!=NULL)
				{
					channel=pApp->GetChannelName(pFax);
					GetSessionParameters(pFax,&CSession);
					sprintf(buf,"%s: Ending page %d.",channel,CSession.PageNo+1);
					pApp->FaxEventText(buf);
				}
				break;

			case MFX_RING:
				pFax = (PORTFAX)lParam;
				if (pFax!=NULL)
				{
					channel=pApp->GetChannelName(pFax);
					sprintf(buf,"%s: Ring detected.",channel);
					pApp->FaxEventText(buf);
				}
				
				break;

			case MFX_STARTSEND:
				pFax = (PORTFAX)lParam;
				if (pFax!=NULL)
				{
					channel=pApp->GetChannelName(pFax);
					sprintf(buf,"%s: Starting to send.",channel);
					pApp->FaxEventText(buf);
				}
				break;

			case MFX_STARTRECEIVE:
				pFax = (PORTFAX)lParam;
				if (pFax!=NULL)
				{
					channel=pApp->GetChannelName(pFax);
					sprintf(buf,"%s: Starting to receive.",channel);
					pApp->FaxEventText(buf);
				}
				break;

			case MFX_ENDSEND:
				Fax = (FAXOBJ)lParam;
				if (Fax!=NULL)
				{
					Fax->GetSessionParam(CSession);
					pFax = CSession.FaxPort;
					{	
						TSSessionParameters CSession;
						channel=pApp->GetChannelName(pFax);

						sprintf(buf,"%s: Sending OK. Waiting for a call...", channel);
						pApp->FaxEventText(buf);

						pApp->SetCurrentlySending(pFax, false);

						timerToKill = pApp->GetTimerID(pFax);
						if (timerToKill!=-1) 
						{
							KillTimer(timerToKill);
							sprintf(buf,"%s: Killing timer %d.",channel, timerToKill );
							pApp->FaxEventText(buf);
						}
						
						pApp->IncrementSentOK(pFax);
						sprintf(buf,"%s: SentOK: %d, SentERROR: %d, ReceivedOK: %d, ReceivedERROR: %d",channel,pApp->GetSentOK(pFax),pApp->GetSentERROR(pFax),pApp->GetReceivedOK(pFax),pApp->GetReceivedERROR(pFax));
						pApp->FaxEventText(buf);
					}
				}
				break;

			case MFX_RECEIVED:
				Fax = (FAXOBJ)lParam;
				if (Fax!=NULL)
				{
					Fax->GetSessionParam(CSession);
					pFax = CSession.FaxPort;
					if (pFax)
					{	
						channel=pApp->GetChannelName(pFax);

						sprintf(buf,"%s: Receiving OK. Waiting for %d seconds before sending.",channel, TIMER_INTERVAL);
						pApp->FaxEventText(buf);
						
						pApp->IncrementReceivedOK(pFax);
						
						
						actTimer = pApp->GetTimerID(pFax);
						SetTimer(actTimer, TIMER_INTERVAL*1000 ,NULL);
						sprintf(buf,"%s: Timer %d set to %d.", channel, actTimer, TIMER_INTERVAL);
						pApp->FaxEventText(buf);
						
						sprintf(buf,"%s: SentOK: %d, SentERROR: %d, ReceivedOK: %d, ReceivedERROR: %d",channel,pApp->GetSentOK(pFax),pApp->GetSentERROR(pFax),pApp->GetReceivedOK(pFax),pApp->GetReceivedERROR(pFax));
						pApp->FaxEventText(buf);
					}
					ClearFaxObj(Fax);
				}

				break;

			case MFX_TERMINATE:
				pFax = (PORTFAX)lParam;
				if (pFax!=NULL)
				{	
					channel=pApp->GetChannelName(pFax);
					GetSessionParameters(pFax,&CSession);
					if (CSession.TStatus != TRM_NORMAL)
					{
						if (CSession.TStatus != TRM_ABORT)
						{
							sprintf(buf,"%s: ERROR! Termination status: %s",channel,ReturnErrorString(CSession.TStatus));
							pApp->FaxEventText(buf);
							
							pApp->IncrementReceivedERROR(pFax);
							sprintf(buf,"%s: SentOK: %d, SentERROR: %d, ReceivedOK: %d, ReceivedERROR: %d",channel,pApp->GetSentOK(pFax),pApp->GetSentERROR(pFax),pApp->GetReceivedOK(pFax),pApp->GetReceivedERROR(pFax));
							pApp->FaxEventText(buf);
							

							pApp->SetCurrentlySending(pFax, false);
							sprintf(buf,"%s: Trying to send next: Timer set to %d.", channel, TIMER_INTERVAL);
							pApp->FaxEventText(buf);
							actTimer = pApp->GetTimerID(pFax);
							SetTimer(actTimer, TIMER_INTERVAL*1000 ,NULL);

						}
						else
						{
							UINT timerToKill=pApp->GetTimerID(pFax);
							if (timerToKill!=-1) 
							{	
								KillTimer(timerToKill);
								sprintf(buf,"%s: Timer %d killed.",channel, timerToKill);
								pApp->FaxEventText(buf);
							}
						}
					 }
				}
			break;
		}
		return 1;
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

void CFaxWithBrooktroutDlg::OnStopsession() 
{
	CFaxWithBrooktroutApp *pApp = (CFaxWithBrooktroutApp *)AfxGetApp();
	for(int i=0;i<MAX_FAXCHANNELS;i++){
        if ( pApp->FaxPorts[i] ) {
            if ( pApp->FaxPorts[i]->IsOpen() ) {
                pApp->FaxPorts[i]->AbortFax();
            }
        }
    }
	GetDlgItem(IDC_STARTSESSION)->EnableWindow(TRUE);
	GetDlgItem(IDC_STOPSESSION)->EnableWindow(FALSE);
	GetDlgItem(IDC_CLOSE)->EnableWindow(TRUE);
	pApp->Aborted=true;
}

void CFaxWithBrooktroutDlg::SetEventText(LPSTR buf)
{
    char buf2[200];
	CFaxWithBrooktroutApp *App = (CFaxWithBrooktroutApp *)AfxGetApp();
	CListBox *evnt = (CListBox *) GetDlgItem(IDC_EVENTLIST);
    char timebuf[20];
    LPSTR ptime;

    ptime = _strtime(timebuf);

    wsprintf(buf2, "%s  %s", ptime, buf);
        evnt->AddString(buf2);
    int nn = evnt->GetCount();
    if ( nn>100 ) {
		for(int i=0;i<5;i++)
			evnt->DeleteString(0);
        evnt->SetCurSel(evnt->GetCount()-1);
    }

	CHAR    szFName[512];
    HANDLE hf;
    DWORD dwWritten, dwPos;

    wsprintf( szFName, "BrooktroutTest.log");
    hf = CreateFile( szFName, GENERIC_READ|GENERIC_WRITE, 0, 0, OPEN_ALWAYS, FILE_ATTRIBUTE_ARCHIVE, 0 );
    if ( hf != INVALID_HANDLE_VALUE ) {
        dwPos = SetFilePointer( (HANDLE)hf, 0, 0, FILE_END );
        WriteFile( (HANDLE)hf, buf2, strlen(buf2), &dwWritten, NULL );
        WriteFile( (HANDLE)hf, "\r\n", 2, &dwWritten, NULL );
        CloseHandle( (HANDLE)hf );
    }
}

void CFaxWithBrooktroutDlg::OnTimer(UINT nIDEvent) 
{
	CFaxWithBrooktroutApp	*pApp;
	PORTFAX					portfax;
	char					buf[70];
	int						iError;
	CString					channel;
	FAXOBJ					faxobj;
	
	TSFaxParam				sFaxParam;
	
	pApp	= (CFaxWithBrooktroutApp *)AfxGetApp();
	portfax = pApp->GetPortFax(nIDEvent);

	if (portfax && !pApp->GetCurrentlySending(portfax) && !pApp->Aborted)
	{
		channel = pApp->GetChannelName(portfax);
		faxobj	= pApp->GetFaxObj(nIDEvent);
		if (faxobj)
		{
			memset(&sFaxParam, 0, sizeof(TSFaxParam));
			faxobj->GetParam(sFaxParam);

			sprintf(buf,"%s: Timer %d calls SendFaxNow(%s).",channel, nIDEvent, sFaxParam.RemoteNumber);
			pApp->FaxEventText(buf);

			iError	= SendFaxNow(portfax,faxobj,FALSE);
			if (iError!=0)
			{
				sprintf(buf,"%s: Cannot start sending! Error code: %d",channel,iError);
				pApp->FaxEventText(buf);
				pApp->SetCurrentlySending(portfax, false);
			}
			else 
			{
				pApp->SetCurrentlySending(portfax, true);
			}
		}
		else
		{
			sprintf(buf,"%s: FAXOBJ is invalid!",channel);
			pApp->FaxEventText(buf);
		}
	}	
	else
	{
		if (pApp->GetCurrentlySending(portfax))
		{
			CString channel = pApp->GetChannelName(portfax);
			sprintf(buf,"%s: CHANNEL IS CURRENTLY IN USE. Cannot start sending!",channel);
			pApp->FaxEventText(buf);
		}
	}

	CDialog::OnTimer(nIDEvent);
}
