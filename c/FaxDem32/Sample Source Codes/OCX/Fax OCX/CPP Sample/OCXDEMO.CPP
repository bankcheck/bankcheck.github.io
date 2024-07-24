// OCXDEMO.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "OCXDEMO.h"

#include "MainFrm.h"
#include "OCXDEMOD.h"
#include "OCXDEMOV.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// COCXDEMOApp

BEGIN_MESSAGE_MAP(COCXDEMOApp, CWinApp)
        //{{AFX_MSG_MAP(COCXDEMOApp)
        ON_COMMAND(ID_APP_ABOUT, OnAppAbout)
                // NOTE - the ClassWizard will add and remove mapping macros here.
                //    DO NOT EDIT what you see in these blocks of generated code!
        //}}AFX_MSG_MAP
        // Standard file based document commands
        ON_COMMAND(ID_FILE_NEW, CWinApp::OnFileNew)
        ON_COMMAND(ID_FILE_OPEN, CWinApp::OnFileOpen)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// COCXDEMOApp construction

COCXDEMOApp::COCXDEMOApp()
{
        // TODO: add construction code here,
        // Place all significant initialization in InitInstance
	PortsAndClasses="";
}

/////////////////////////////////////////////////////////////////////////////
// The one and only COCXDEMOApp object

COCXDEMOApp theApp;

/////////////////////////////////////////////////////////////////////////////
// COCXDEMOApp initialization

BOOL COCXDEMOApp::InitInstance()
{
        AfxEnableControlContainer();

        // Standard initialization
        // If you are not using these features and wish to reduce the size
        //  of your final executable, you should remove from the following
        //  the specific initialization routines you do not need.

        LoadStdProfileSettings(1);  // Load standard INI file options (including MRU)

        // Register the application's document templates.  Document templates
        //  serve as the connection between documents, frame windows and views.

        
        AddDocTemplate(new CSingleDocTemplate(
                IDR_MAINFRAME,
                RUNTIME_CLASS(COCXDEMODoc),
                RUNTIME_CLASS(CMainFrame),       // main SDI frame window
                RUNTIME_CLASS(COCXDEMOView)));


        // Parse command line for standard shell commands, DDE, file open
        CCommandLineInfo cmdInfo;
        ParseCommandLine(cmdInfo);

        // Dispatch commands specified on the command line
        if (!ProcessShellCommand(cmdInfo))
                return FALSE;
        return TRUE;
}

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
		void VisitTo(CString*);
        CAboutDlg();

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

// App command to run the dialog
void COCXDEMOApp::OnAppAbout()
{
        CAboutDlg aboutDlg;
        aboutDlg.DoModal();
}

/////////////////////////////////////////////////////////////////////////////
// COCXDEMOApp commands

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