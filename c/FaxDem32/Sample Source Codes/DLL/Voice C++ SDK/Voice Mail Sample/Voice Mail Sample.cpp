// Voice Mail Sample.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "Voice Mail Sample.h"

#include "MainFrm.h"
#include "ChildFrm.h"
#include "Voice Mail SampleDoc.h"
#include "Voice Mail SampleView.h"
#include "faxdoc.h"
#include "faxdocvw.h"
#include "Splash.h"
extern "C"
{
#include "bitiff.h"
};

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

const TCHAR g_szRegKey[] = _T("BlackIce");

const TCHAR g_szSection[] = _T("Options");
const TCHAR g_szFrameRect[] = _T("FrameRect");
const TCHAR g_szMaximized[] = _T("Maximized");
const TCHAR g_szRings[] = _T("Rings");
const TCHAR g_szGreeting[] = _T("Greeting Message");
const TCHAR g_szRecTime[] = _T("Message length");

// registered message from Voice/Fax C++
UINT VoiceMsg = RegisterWindowMessage(REG_FAXMESSAGE);
//
char g_szExePath[MAX_PATH];
char g_szBrookCfgFile[MAX_PATH] = "";

/////////////////////////////////////////////////////////////////////////////
// CVoiceMailSampleApp

BEGIN_MESSAGE_MAP(CVoiceMailSampleApp, CWinApp)
        //{{AFX_MSG_MAP(CVoiceMailSampleApp)
        ON_COMMAND(ID_APP_ABOUT, OnAppAbout)
                // NOTE - the ClassWizard will add and remove mapping macros here.
                //    DO NOT EDIT what you see in these blocks of generated code!
        //}}AFX_MSG_MAP
        // Standard file based document commands
        ON_COMMAND(ID_FILE_NEW, CWinApp::OnFileNew)
        ON_COMMAND(ID_FILE_OPEN, CWinApp::OnFileOpen)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CVoiceMailSampleApp construction

CVoiceMailSampleApp::CVoiceMailSampleApp()
{
        // TODO: add construction code here,
        // Place all significant initialization in InitInstance
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CVoiceMailSampleApp object

CVoiceMailSampleApp theApp;

/////////////////////////////////////////////////////////////////////////////
// CVoiceMailSampleApp initialization

BOOL CVoiceMailSampleApp::InitInstance()
{
        // CG: The following block was added by the Splash Screen component.
\
        {
\
                CCommandLineInfo cmdInfo;
\
                ParseCommandLine(cmdInfo);
\

\
                CSplashWnd::EnableSplashScreen(cmdInfo.m_bShowSplash);
\
        }
char *pC;

        GetModuleFileName( GetModuleHandle(NULL), g_szExePath, MAX_PATH);
        pC = strrchr(g_szExePath, '\\');
        if( pC )
        {
                *pC = 0;
        }

        AfxEnableControlContainer();

        // Standard initialization
        // If you are not using these features and wish to reduce the size
        //  of your final executable, you should remove from the following
        //  the specific initialization routines you do not need.

#ifdef _AFXDLL
        Enable3dControls();                     // Call this when using MFC in a shared DLL
#else
        Enable3dControlsStatic();       // Call this when linking to MFC statically
#endif

        // Change the registry key under which our settings are stored.
        // You should modify this string to be something appropriate
        // such as the name of your company or organization.
        SetRegistryKey(_T(g_szRegKey));

        LoadStdProfileSettings(0);  // Load standard INI file options (including MRU)
    LoadOptions();

        // Register the application's document templates.  Document templates
        //  serve as the connection between documents, frame windows and views.

        CMultiDocTemplate* pDocTemplate;
        pDocTemplate = new CMultiDocTemplate(
                IDR_MAINFRAME,
                RUNTIME_CLASS(CVoiceMailSampleDoc),
                RUNTIME_CLASS(CChildFrame), // custom MDI child frame
                RUNTIME_CLASS(CVoiceMailSampleView));
        AddDocTemplate(pDocTemplate);

        pDocTemplate = new CMultiDocTemplate(
                IDR_FAXDOC,
                RUNTIME_CLASS(CFaxDisplayDoc),
                RUNTIME_CLASS(CChildFrame), // custom MDI child frame
                RUNTIME_CLASS(CFaxDisplayView));
        AddDocTemplate(pDocTemplate);

        switch (m_nCmdShow)
        {
                case SW_RESTORE:
                case SW_SHOW:
                case SW_SHOWDEFAULT:
                case SW_SHOWNA:
                case SW_SHOWNOACTIVATE:
                case SW_SHOWNORMAL:
                case SW_SHOWMAXIMIZED:
                        if (m_bMaximized)
                                m_nCmdShow = SW_SHOWMAXIMIZED;
                        break;
        }

        // create main MDI Frame window
        CMainFrame* pMainFrame = new CMainFrame;
        if (!pMainFrame->LoadFrame(IDR_MAINFRAME))
                return FALSE;
        m_pMainWnd = pMainFrame;

        // Parse command line for standard shell commands, DDE, file open
        CCommandLineInfo cmdInfo;

    cmdInfo.m_nShellCommand = CCommandLineInfo::FileNothing;
        ParseCommandLine(cmdInfo);

        // Dispatch commands specified on the command line
        if (!ProcessShellCommand(cmdInfo))
                return FALSE;

        // The main window has been initialized, so show and update it.

    pMainFrame->ShowWindow(m_nCmdShow);
    pMainFrame->SetWindowPos(&CWnd::wndTop,0,0,0,0,SWP_NOSIZE|SWP_NOMOVE|SWP_SHOWWINDOW);
        pMainFrame->UpdateWindow();
    CSplashWnd::EnableSplashScreen(TRUE);
        CSplashWnd::ShowSplashScreen(pMainFrame);

        return TRUE;
}

void CVoiceMailSampleApp::SaveOptions()
{
        WriteProfileInt(g_szSection,g_szMaximized,m_bMaximized);
        WriteProfileBinary(g_szSection,g_szFrameRect,(BYTE*)&m_rectInitialFrame,sizeof(CRect));
}

void CVoiceMailSampleApp::LoadOptions()
{
BYTE* pb = NULL;
UINT nLen = 0;
TCHAR buf[2];

        buf[0] = NULL;
        GetLocaleInfo(GetUserDefaultLCID(), LOCALE_IMEASURE, buf, 2);
        m_bMaximized = GetProfileInt(g_szSection, g_szMaximized, (int)FALSE);

        if (GetProfileBinary(g_szSection, g_szFrameRect, &pb, &nLen))
        {
                ASSERT(nLen == sizeof(CRect));
                memcpy(&m_rectInitialFrame, pb, sizeof(CRect));
                delete pb;
        }
        else
                m_rectInitialFrame.SetRect(0,0,0,0);
}

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
        virtual BOOL OnInitDialog();
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
        //}}AFX_MSG_MAP
END_MESSAGE_MAP()

// App command to run the dialog
void CVoiceMailSampleApp::OnAppAbout()
{
        CAboutDlg aboutDlg;
        aboutDlg.DoModal();
}

/////////////////////////////////////////////////////////////////////////////
// CVoiceMailSampleApp commands

BOOL CAboutDlg::OnInitDialog()
{
        CDialog::OnInitDialog();

    char    szVersion[20];

    GetTiffVersion(szVersion, sizeof(szVersion));
    SetDlgItemText(IDC_TIFFVERSION, szVersion);
        GetImageVersion(szVersion, sizeof(szVersion));
    SetDlgItemText(IDC_IMAGE_VERSION, szVersion);
        GetFaxCppVersion(szVersion, sizeof(szVersion));
    SetDlgItemText(IDC_FAXCPP_VERSION, szVersion);
        GetVoiceCppVersionStr(szVersion);
        SetDlgItemText(IDC_VOICECPP_VERSION, szVersion);

        return TRUE;  // return TRUE unless you set the focus to a control
                      // EXCEPTION: OCX Property Pages should return FALSE
}

BOOL CVoiceMailSampleApp::PreTranslateMessage(MSG* pMsg)
{
        if (CSplashWnd::PreTranslateAppMessage(pMsg))
                return TRUE;

        // CG: The following line was added by the Splash Screen component.

       return CWinApp::PreTranslateMessage(pMsg);
}

int CVoiceMailSampleApp::ExitInstance()
{
        SaveOptions();

        return CWinApp::ExitInstance();
}
