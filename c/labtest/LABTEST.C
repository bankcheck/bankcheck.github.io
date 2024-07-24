#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <tchar.h>
#include "service.h"
#include "labtest.h"
//#include <sqlext.h>

// this event is signalled when the
// service should end
//
char    g_szProfile[260] = "labtest.ini";
HANDLE  g_hServerStopEvent = NULL;
DWORD	g_dwMaxIdle = 180000;
DWORD	g_dwSleepTime = 30000;
DWORD   g_dwErrorSleepTime = 10000;
char    g_szPrgName[80] = "HKAH LAB test downloader";
char    g_szRootPath[260] = "C:\\MOXA\\LABtest\\";
char    g_szTempPath[260] = "C:\\MOXA\\LABtest\\TEMP\\";
BOOL	g_bLog = FALSE;
BOOL    g_bDebug = FALSE;
BOOL    g_bBackup = FALSE;
BOOL	g_bTimerQuit = TRUE;
BOOL	g_bQuit = FALSE;
char    g_szServer[80] = "139.168.200.1";
char    g_Host[15] = "139.168.200.1";
char    g_szRoot[260] = "C:\\";

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
    WSADATA wData;
    int err;
//    HANDLE hThread;
//    DWORD threadID;
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

    err = WSAStartup(0x101, &wData);
    if (err != 0) {
        AddToEventLog(EVENTLOG_ERROR_TYPE, "Initialize WinSock DLL failed.");
	goto cleanup;
    }

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

    while (1) {
        if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleepTime) == WAIT_OBJECT_0)
			break;
//test download
        Query();
//
    }

cleanup:

    g_bQuit = TRUE;

	dbdisconnect();

    if (g_hServerStopEvent != NULL)
	CloseHandle(g_hServerStopEvent);

    while (g_bTimerQuit == FALSE)
	Sleep(1000);

    WriteLog("Program Stopped");

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

    g_bQuit = TRUE;
    if (g_hServerStopEvent != NULL) {
        WriteLog("Stopping Service");
	SetEvent(g_hServerStopEvent);
    }

_TRY_EXCEPTION_BLOCK_END(1)

    return;
}
