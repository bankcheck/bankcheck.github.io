// SendFaxDlg.cpp : implementation file
//

#include "stdafx.h"
#include "SendFax.h"
#include "SendFaxDlg.h"
#include "dlgFaxPortSetup.h"
#include "dlgFaxClose.h"
#include "dlgSendFax.h"
#include "commcl.h"

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
// CSendFaxDlg dialog

CSendFaxDlg::CSendFaxDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CSendFaxDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CSendFaxDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CSendFaxDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CSendFaxDlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CSendFaxDlg, CDialog)
	//{{AFX_MSG_MAP(CSendFaxDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_WM_CREATE()
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_OPENPORT, OnOpenport)
	ON_BN_CLICKED(IDC_CLOSEPORT, OnCloseport)
	ON_BN_CLICKED(IDC_SENDFAX, OnSendfax)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CSendFaxDlg message handlers

BOOL CSendFaxDlg::OnInitDialog()
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

void CSendFaxDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CSendFaxDlg::OnPaint() 
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
HCURSOR CSendFaxDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

int CSendFaxDlg::OnCreate(LPCREATESTRUCT lpCreateStruct) 
{
	if (CDialog::OnCreate(lpCreateStruct) == -1)
		return -1;
	
	if(SetupFaxDriver(NULL) || SetFaxMessage(this->m_hWnd))
        AfxMessageBox("Setting fax driver has failed!");
	
	return 0;
}

void CSendFaxDlg::OnDestroy() 
{
	CDialog::OnDestroy();
	
	CSendFaxApp *pApp = (CSendFaxApp *)AfxGetApp();

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

void CSendFaxDlg::OnOpenport() 
{
	bool isAvailablePort=false;
    char chFullName[15];

	for (int nCom = 0 ; nCom < MAX_COMPORTS ; nCom++) {
        sprintf( chFullName, "\\\\.\\COM%d", nCom+1 );
        HANDLE nCommPort =  CreateFile( chFullName, GENERIC_READ | GENERIC_WRITE,
                      0,                    // exclusive access
                      NULL,                 // no security attrs
                      OPEN_EXISTING,
                      FILE_ATTRIBUTE_NORMAL |
                      FILE_FLAG_OVERLAPPED, // overlapped I/O
	                  NULL )  ;
        if (nCommPort != INVALID_HANDLE_VALUE  ) {
            CloseHandle(nCommPort);
			isAvailablePort=true;
			break;
        }
    }	
	if (isAvailablePort)
	{
		CdlgFaxPortSetup dlgFaxPortSetup;
	    dlgFaxPortSetup.DoModal();	
	}
	else AfxMessageBox("There is no available port!");
}

void CSendFaxDlg::OnCloseport() 
{
	CDlgFaxClose dlgCloseFaxPort;

    dlgCloseFaxPort.DoModal();		
}

void CSendFaxDlg::OnSendfax() 
{
	CDlgSendFax dlgSendFax;

    dlgSendFax.DoModal();	
}


LRESULT CSendFaxDlg::DefWindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	PORTFAX pFax = NULL;

	CSendFaxApp *pApp = (CSendFaxApp *)AfxGetApp();
    if(message == pApp->nMessage)
    {
		switch(wParam)
				{
					case MFX_ENDSEND:

						FAXOBJ faxobj= (FAXOBJ) lParam;
	/*This function deletes the specified fax object.
	parameter: fax object
	*/
						ClearFaxObj(faxobj);
						break;			
				}


    }	
	
	return CDialog::DefWindowProc(message, wParam, lParam);
}
