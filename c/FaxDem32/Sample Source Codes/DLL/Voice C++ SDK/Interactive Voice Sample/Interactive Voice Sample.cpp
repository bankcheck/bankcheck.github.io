// Interactive Voice Sample.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "Interactive Voice Sample.h"
#include "Interactive Voice SampleDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

const TCHAR g_szRegKey[] = _T("BlackIce");

const TCHAR g_szSection[] = _T("Options");
const TCHAR g_szFrameRect[] = _T("FrameRect");
const TCHAR g_szMaximized[] = _T("Maximized");


/////////////////////////////////////////////////////////////////////////////
// CInteractiveVoiceSampleApp

BEGIN_MESSAGE_MAP(CInteractiveVoiceSampleApp, CWinApp)
	//{{AFX_MSG_MAP(CInteractiveVoiceSampleApp)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG
	ON_COMMAND(ID_HELP, CWinApp::OnHelp)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CInteractiveVoiceSampleApp construction

CInteractiveVoiceSampleApp::CInteractiveVoiceSampleApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CInteractiveVoiceSampleApp object

CInteractiveVoiceSampleApp theApp;

/////////////////////////////////////////////////////////////////////////////
// CInteractiveVoiceSampleApp initialization

BOOL CInteractiveVoiceSampleApp::InitInstance()
{
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
	Enable3dControls();			// Call this when using MFC in a shared DLL
#else
	Enable3dControlsStatic();	// Call this when linking to MFC statically
#endif

	SetRegistryKey(_T(g_szRegKey));

	LoadStdProfileSettings(0);  // Load standard INI file options (including MRU)

	CInteractiveVoiceSampleDlg dlg;
	m_pMainWnd = &dlg;
	int nResponse = dlg.DoModal();
	if (nResponse == IDOK)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with OK
	}
	else if (nResponse == IDCANCEL)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with Cancel
	}

	// Since the dialog has been closed, return FALSE so that we exit the
	//  application, rather than start the application's message pump.
	return FALSE;
}
