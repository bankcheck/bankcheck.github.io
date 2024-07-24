// Voice Recording Sample.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "Voice Recording Sample.h"
#include "Voice Recording SampleDlg.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

const TCHAR g_szRegKey[] = _T("BlackIce");

const TCHAR g_szSection[] = _T("Options");
const TCHAR g_szRecTime[] = _T("Message length");
const TCHAR g_DefInDev[] = _T("DeviceIn");
const TCHAR g_DefOutDev[] = _T("DeviceOut");

// registered message from Voice C++
UINT VoiceMsg = RegisterWindowMessage(REG_VOICEMESSAGE);

//
char g_szExePath[MAX_PATH];


/////////////////////////////////////////////////////////////////////////////
// CVoiceRecordingSampleApp

BEGIN_MESSAGE_MAP(CVoiceRecordingSampleApp, CWinApp)
	//{{AFX_MSG_MAP(CVoiceRecordingSampleApp)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG
	ON_COMMAND(ID_HELP, CWinApp::OnHelp)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CVoiceRecordingSampleApp construction

CVoiceRecordingSampleApp::CVoiceRecordingSampleApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CVoiceRecordingSampleApp object

CVoiceRecordingSampleApp theApp;

/////////////////////////////////////////////////////////////////////////////
// CVoiceRecordingSampleApp initialization

BOOL CVoiceRecordingSampleApp::InitInstance()
{
    char *pC;

	GetModuleFileName( GetModuleHandle(NULL), g_szExePath, MAX_PATH);
	pC = strrchr(g_szExePath, '\\');
	if( pC )
	{
		*pC = 0;
	}

	AfxEnableControlContainer();

	SetRegistryKey(_T(g_szRegKey));

	LoadStdProfileSettings(0);  // Load standard INI file options (including MRU)

	// Standard initialization
	// If you are not using these features and wish to reduce the size
	//  of your final executable, you should remove from the following
	//  the specific initialization routines you do not need.

#ifdef _AFXDLL
	Enable3dControls();			// Call this when using MFC in a shared DLL
#else
	Enable3dControlsStatic();	// Call this when linking to MFC statically
#endif

	CVoiceRecordingSampleDlg dlg;
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

