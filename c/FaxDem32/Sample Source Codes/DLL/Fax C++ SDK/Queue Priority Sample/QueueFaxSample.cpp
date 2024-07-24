// QueueFaxSample.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "QueueFaxSample.h"
#include "QueueFaxSampleDlg.h"
#include "faxcpp.h"
#include "commcl.h"
#include <direct.h>
#include "io.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CQueueFaxSampleApp

BEGIN_MESSAGE_MAP(CQueueFaxSampleApp, CWinApp)
	//{{AFX_MSG_MAP(CQueueFaxSampleApp)
	//}}AFX_MSG_MAP
	ON_COMMAND(ID_HELP, CWinApp::OnHelp)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CQueueFaxSampleApp construction

CQueueFaxSampleApp::CQueueFaxSampleApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CQueueFaxSampleApp object

CQueueFaxSampleApp theApp;

/////////////////////////////////////////////////////////////////////////////
// CQueueFaxSampleApp initialization

BOOL CQueueFaxSampleApp::InitInstance()
{
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

	CQueueFaxSampleDlg dlg;
	m_pMainWnd = &dlg;
	for(int jj=0; jj<MAX_FAXPORTS; jj++) {
        FaxPorts[jj] = NULL;
        nComm[jj] = 0;
        nRings[jj] = 0;
    }
	CreateDirs();
	fileName="Testqueue.tif";
	nMessage=RegisterWindowMessage(REG_FAXMESSAGE);
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

void CQueueFaxSampleApp::FaxEventText(int iPort, LPSTR buf)
{
    if(m_pMainWnd)
        ((CQueueFaxSampleDlg*)m_pMainWnd)->SetEventText(iPort, buf);
}
BOOL CQueueFaxSampleApp::CreateDirs()
{
    char    szModuleName[260];
    LPSTR   lpFileName;

    GetModuleFileName( AfxGetInstanceHandle(), szModuleName, sizeof(szModuleName) );
    lpFileName = _fstrrchr( szModuleName, '\\' );
    if ( !lpFileName )
        lpFileName = _fstrrchr( szModuleName, ':' );
    *(++lpFileName) = 0;
    m_szDemoPath = szModuleName;
    _fstrcat( szModuleName, "SEND" );
    mkdir( szModuleName );

    *lpFileName = 0;
    _fstrcat( szModuleName, "OUT" );
    mkdir( szModuleName );

    return 0;
}

HFILE CQueueFaxSampleApp::GetFileName( CString &szDir, CString &szExt, CString &szName )
{
    CString  szFile, szTime;
    DWORD    ctime;
    OFSTRUCT of;
    HFILE    hFile;

    time( (time_t*)&ctime );
    while ( 1 ) {
        ltoa( ctime, szTime.GetBuffer(64), 10 );
        szTime.ReleaseBuffer( -1 );
        szName = szDir ;
                szName += szTime.Right(8) ;
                szName += '.' ;
                szName +=  szExt;

        hFile = OpenFile( szName, &of, OF_EXIST );
        if ( hFile != HFILE_ERROR ) {
            ctime++;
        }
        else {
            hFile = OpenFile( szName, &of, OF_CREATE|OF_READWRITE );
            break;
        }
    }
    return hFile;
}
