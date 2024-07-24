// ReceiveDTMFandDecideToReceiveFaxOrVoice.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "ReceiveDTMFandDecideToReceiveFaxOrVoice.h"
#include "ReceiveDTMFandDecideToReceiveFaxOrVoiceDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

const TCHAR g_szRegKey[] = _T("BlackIce");

const TCHAR g_szSection[] = _T("Options");
/////////////////////////////////////////////////////////////////////////////
// CReceiveDTMFandDecideToReceiveFaxOrVoiceApp

BEGIN_MESSAGE_MAP(CReceiveDTMFandDecideToReceiveFaxOrVoiceApp, CWinApp)
	//{{AFX_MSG_MAP(CReceiveDTMFandDecideToReceiveFaxOrVoiceApp)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG
	ON_COMMAND(ID_HELP, CWinApp::OnHelp)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CReceiveDTMFandDecideToReceiveFaxOrVoiceApp construction

CReceiveDTMFandDecideToReceiveFaxOrVoiceApp::CReceiveDTMFandDecideToReceiveFaxOrVoiceApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CReceiveDTMFandDecideToReceiveFaxOrVoiceApp object

CReceiveDTMFandDecideToReceiveFaxOrVoiceApp theApp;

/////////////////////////////////////////////////////////////////////////////
// CReceiveDTMFandDecideToReceiveFaxOrVoiceApp initialization

BOOL CReceiveDTMFandDecideToReceiveFaxOrVoiceApp::InitInstance()
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
#ifndef _VISUALC8
	Enable3dControls();			// Call this when using MFC in a shared DLL
#endif
#else
	Enable3dControlsStatic();	// Call this when linking to MFC statically
#endif

	SetRegistryKey(_T(g_szRegKey));

	LoadStdProfileSettings(0);  // Load standard INI file options (including MRU)

	CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg dlg;
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
