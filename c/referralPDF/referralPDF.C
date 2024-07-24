#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <tchar.h>
#include "service.h"
#include "referralPDF.h"
//#include <sqlext.h>

// this event is signalled when the
// service should end
//
char    g_szProfile[260] = "referralPDF.ini";
HANDLE  g_hServerStopEvent = NULL;
int		g_sleep = 1000;
char    g_szDBServer[80] = "139.168.200.1";
char    g_szFileServer[80] = "139.168.200.1";
char    g_szPrgName[80] = "HKAH referral PDF upload service";
char    g_szLogPath[260] = "C:\\MOXA\\referralPDF\\log";
char    g_szBackupPath[260] = "C:\\MOXA\\referralPDF\\INBOX.BAK";
char    g_szInBoxPath[260] = "C:\\MOXA\\referralPDF\\INBOX";

BOOL    g_bDebug = FALSE;
BOOL    g_bBackup = FALSE;
BOOL	g_bQuit = FALSE;
char    g_szShare[80] = "lab";

//
//  FUNCTION: ServiceStart
//
//  PURPOSE: Actual code of the service
//	     that does the work.
//
//  PARAMETERS:
//    dwArgc   - number of command line arguments
//    lpszArgv - array of command line arguments
//
//  RETURN VALUE:
//    none
//
VOID ServiceStart (DWORD dwArgc, LPTSTR *lpszArgv)
{
    BOOL bSuccess;

_TRY_EXCEPTION_BLOCK_BEGIN()

    ///////////////////////////////////////////////////
    //
    // Service initialization
    //

    bSuccess = FALSE;

    // report the status to the service control manager.
    //
    if (!ReportStatusToSCMgr(
	SERVICE_START_PENDING, // service state
	NO_ERROR,	       // exit code
	3000))		       // wait hint
	goto cleanup;

    // create the event object. The control handler function signals
    // this event when it receives the "stop" control code.
    //
    g_hServerStopEvent = CreateEvent(
	NULL,	 // no security attributes
	TRUE,	 // manual reset event
	FALSE,	 // not-signalled
        SZSERVICENAME);   // no name

    if ( g_hServerStopEvent == NULL)
	goto cleanup;

    // report the status to the service control manager.
    //
    if (!ReportStatusToSCMgr(
	SERVICE_START_PENDING, // service state
	NO_ERROR,	       // exit code
	3000))		       // wait hint
	goto cleanup;

    LoadRegVal();

    // report the status to the service control manager.
    //
    if (!ReportStatusToSCMgr(
	SERVICE_START_PENDING, // service state
	NO_ERROR,	       // exit code
	3000))		       // wait hint
	goto cleanup;
/*
    hThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)TimerThreadProc,
			    0, 0, &threadID);
    if (hThread == INVALID_HANDLE_VALUE) {
        AddToEventLog(EVENTLOG_ERROR_TYPE, "Can't create timer thread.");
	goto cleanup;
    }
*/
    // report the status to the service control manager.
    //
    if (!ReportStatusToSCMgr(
	SERVICE_RUNNING,       // service state
	NO_ERROR,	       // exit code
	0))		       // wait hint
	goto cleanup;

    bSuccess = TRUE;
    AddToEventLog(EVENTLOG_INFORMATION_TYPE, "%s Service Startup.", g_szPrgName);

	dbconnect();

    //
    // End of initialization
    //
    ////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////
    //
    // Service is now running, perform work until shutdown
    //

    CheckFile();

cleanup:

    g_bQuit = TRUE;

	dbdisconnect();

    if (g_hServerStopEvent)
	CloseHandle(g_hServerStopEvent);

	Sleep(1000);

    if (bSuccess)
        AddToEventLog(EVENTLOG_INFORMATION_TYPE, "%s Service Shutdown.", g_szPrgName);
    else
        AddToEventLog(EVENTLOG_ERROR_TYPE, "%s Service Startup Failed.", g_szPrgName);

_TRY_EXCEPTION_BLOCK_END(1)

    return;
}


//
//  FUNCTION: ServiceStop
//
//  PURPOSE: Stops the service
//
//  PARAMETERS:
//    none
//
//  RETURN VALUE:
//    none
//
//  COMMENTS:
//    If a ServiceStop procedure is going to
//    take longer than 3 seconds to execute,
//    it should spawn a thread to execute the
//    stop code, and return.  Otherwise, the
//    ServiceControlManager will believe that
//    the service has stopped responding.
//
VOID ServiceStop()
{
_TRY_EXCEPTION_BLOCK_BEGIN()
    env = NULL;

    g_bQuit = TRUE;
    if (g_hServerStopEvent != NULL) {
        WriteLog("Stopping Service");
	SetEvent(g_hServerStopEvent);
    }

_TRY_EXCEPTION_BLOCK_END(1)

    return;
}
