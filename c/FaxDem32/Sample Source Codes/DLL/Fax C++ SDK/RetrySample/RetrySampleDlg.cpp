// RetrySampleDlg.cpp : implementation file
//

#include "stdafx.h"
#include "RetrySample.h"
#include "RetrySampleDlg.h"
#include "dlgFaxPortSetup.h"
#include "dlgFaxClose.h"
#include "dlgSendFax.h"
#include "commcl.h"
#include "faxclass.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

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
// CRetrySampleDlg dialog

CRetrySampleDlg::CRetrySampleDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CRetrySampleDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CRetrySampleDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CRetrySampleDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CRetrySampleDlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CRetrySampleDlg, CDialog)
	//{{AFX_MSG_MAP(CRetrySampleDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_WM_CREATE()
	ON_WM_DESTROY()
	ON_WM_TIMER()
	ON_BN_CLICKED(IDC_OPENPORT, OnOpenport)
	ON_BN_CLICKED(IDC_CLOSEPORT, OnCloseport)
	ON_BN_CLICKED(IDC_SENDFAX, OnSendfax)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CRetrySampleDlg message handlers

BOOL CRetrySampleDlg::OnInitDialog()
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
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CRetrySampleDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CRetrySampleDlg::OnPaint() 
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
HCURSOR CRetrySampleDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

int CRetrySampleDlg::OnCreate(LPCREATESTRUCT lpCreateStruct) 
{
	if (CDialog::OnCreate(lpCreateStruct) == -1)
		return -1;
	
	if(SetupFaxDriver(NULL) || SetFaxMessage(this->m_hWnd))
        AfxMessageBox("Setting fax driver has failed!");	
	return 0;
}

void CRetrySampleDlg::OnDestroy() 
{
	CDialog::OnDestroy();
	
	CRetrySampleApp *pApp = (CRetrySampleApp *)AfxGetApp();

    for(int i=0;i<MAX_COMPORTS;i++){
        if ( pApp->FaxPorts[i] ) {
            if ( pApp->FaxPorts[i]->IsOpen() ) {
                pApp->FaxPorts[i]->AbortFax();
            }
        }
    }
    KillFaxMessage(this->m_hWnd);
    EndOfFaxDriver(TRUE);		
}


void CRetrySampleDlg::OnTimer(UINT nIDEvent) 
{
/*******************Resending fax identified by nIDEvent (timerID)**************************/

	int iError;
	CRetrySampleApp *pApp = (CRetrySampleApp *)AfxGetApp();
	WaitForSingleObject(pApp->hMutex,INFINITE);
	LPRETRYLIST temp = pApp->retrylist;
	if (temp)
	{
	while (temp)
	{
			if (temp->timerID==nIDEvent)
			{
					if (temp->numberOfRetries>0 && !temp->currentlySending) 
					{
	/*if portfax is NULL, fax was put in queue. The sample puts it back again.*/
						temp->faxobj->ChainOutItem();
						iError=PutFaxOnQueue(temp->faxobj);
						if (iError!=0)
								pApp->DeleteFromList(temp->faxobj);
						else temp->currentlySending=true;
						--temp->numberOfRetries;
					}
				break;
			}
		temp=temp->pNext;
	}
	}
	ReleaseMutex(pApp->hMutex);			
	CDialog::OnTimer(nIDEvent);
}

void CRetrySampleDlg::OnOpenport() 
{
	CdlgFaxPortSetup dlgFaxPortSetup;

    dlgFaxPortSetup.DoModal();		
}

void CRetrySampleDlg::OnCloseport() 
{
	CdlgFaxClose dlgCloseFaxPort;

    dlgCloseFaxPort.DoModal();	
}

void CRetrySampleDlg::OnSendfax() 
{
	CdlgSendFax dlgSendFax;

    dlgSendFax.DoModal();	
}

LRESULT CRetrySampleDlg::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	PORTFAX pFax = NULL;

	CRetrySampleApp *pApp = (CRetrySampleApp *)AfxGetApp();
    if(message == pApp->nMessage)
    {
		pFax = (PORTFAX)lParam;
		if (pFax!=NULL)
		{
			int iPort = -1;
			for(int jj=0; jj<MAX_COMPORTS; jj++)
				if(pApp->FaxPorts[jj] == pFax) 
				{
					iPort = jj;
					break;
				}
			if (iPort!=-1)
			{
				switch(wParam)
				{
/******************************MFX_TERMINATE message received.******************************/
					case MFX_TERMINATE:
						WaitForSingleObject(pApp->hMutex,INFINITE);
						TSSessionParameters CSession;
						TSPortStatus portStatus;
						GetPortStatus(pFax,&portStatus);
						FAXOBJ faxobj= portStatus.Fax;
						GetSessionParameters(pFax,&CSession);
						pApp->SetCurrentlySending(faxobj,false);
						if (CSession.TStatus==TRM_BUSY){
/***********************Remote station is busy. Retrying to send in three minutes.***********/

	/*IsFaxObjInList function:
	  Parameter: fax object
	  Returns: true, if fax object is in the retrylist.
	           false, if retrylist is empty, fax object is NULL or fax object is not in the list.
	*/
							if (pApp->IsFaxobjInList(faxobj)==false)
							{
								pApp->AddToList(pFax,faxobj);

/*****************************Set a Timer for fax object for 3 minutes************************************/

								SetTimer(++pApp->timerCount,30000,NULL);
	/*SetTimerID function:
	  1. parameter: fax object
	  2. parameter: TimerID (integer value)
	  Returns: false, if retrylist is empty, fax object is NULL or fax object is not in the list.
			   true, if timerID was set.
	*/
								pApp->SetTimerID(faxobj,pApp->timerCount);
							}
							else
							{
								if (pApp->GetRetryNumber(faxobj)<=0)
								{
									int id=pApp->GetTimerID(faxobj);
									if (id!=-1)
										KillTimer(id);
									pApp->DeleteFromList(faxobj);
								}

							}


						}
						else
						{
/***********************************************************************************************/						{
/*Remote station was not busy. This sample only checks if the remote station is busy or not.
  If you would like to handle other terminations you have to verify and handle CSession.TStatus*/
/***********************************************************************************************/

	/*If remote station is not busy and the TimerId of the fax object is still set kill the timer
	  so the sample won't try to resend the fax 3 minutes later. Also delete faxobj from list.*/
							int id=pApp->GetTimerID(faxobj);
							if (id!=-1)
								KillTimer(id);
							pApp->DeleteFromList(faxobj);
							}
						}
						ReleaseMutex(pApp->hMutex);

						break;			
				}
			}
		}
		return 0l;

    }
	
	return CDialog::WindowProc(message, wParam, lParam);
}
