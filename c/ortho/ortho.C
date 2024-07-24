#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <tchar.h>
#include <time.h>
#include "service.h"
#include "ortho.h"

// this event is signalled when the
// service should end
//

char        g_szProgID[40] = "ortho";
int         g_nMaxReadBufferSize = 8192;
int         g_nMaxWriteBufferSize = 8192;

OVERLAPPED  g_o;
char        g_szPrgName[80] = "HKAH ortho";
HANDLE      g_hServerStopEvent = NULL;
BOOL        g_bWriteSectorCup = FALSE;
BOOL        g_bQuit = FALSE;
BOOL        g_bLog = FALSE;
BOOL        g_bDebug = FALSE;
BOOL        g_bBackupInbox = FALSE;
char        g_szCodeFile[260] = "D:\\MOXA\\ortho\\CODE.DAT";
char        g_szTempPath[260] = "D:\\MOXA\\ortho\\TEMP\\";
char        g_szBackupInBoxPath[260] = "D:\\MOXA\\ortho\\INBOX.BAK\\";
char        g_szInBoxPath[260] = "D:\\MOXA\\ortho\\INBOX\\";
char        g_szInBoxDataPath[260] = "D:\\MOXA\\ortho\\INBOX\\";
char        g_szOutBoxPath[260] = "D:\\MOXA\\ortho\\OUTBOX\\";
char        g_szLogPath[260] = "D:\\MOXA\\ortho\\LOG\\";
char        g_szRateFile[260] = "D:\\MOXA\\ortho\\RATE.DAT";
char        g_szDiluteFile[260] = "D:\\MOXA\\ortho\\DILUTE.DAT";
int         g_nMappingIndex = 0;
char        g_szFileMapping[260] = "MOXA_MONITOR";
char         g_szXMcode[20] = "CROSSMATCHING";
int          g_nDayAgo = 7;
int          g_nNowDay = 0;
char		g_buffer[1024];
char		g_fname[260];
int         g_InstrumentDate = 1;
BOOL		g_bCheckDigit = FALSE;
int			g_mode;
int			g_sleep = 1000;
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
    BOOL            bSuccess;
    //DWORD           dwError, dwErrorFlag;
    //char            szDevice[40];

    ///////////////////////////////////////////////////
    //
    // Service initialization
    //

    bSuccess = FALSE;
    g_o.hEvent = NULL;

    LoadRegVal();
    WriteLog("Starting...");

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

    if (g_hServerStopEvent == NULL)
	goto cleanup;

    // report the status to the service control manager.
    //
    if (!ReportStatusToSCMgr(
	SERVICE_START_PENDING, // service state
	NO_ERROR,	       // exit code
	3000))		       // wait hint
	goto cleanup;

    // report the status to the service control manager.
    //
    if (!ReportStatusToSCMgr(
        SERVICE_START_PENDING, // service state
	NO_ERROR,	       // exit code
	3000))		       // wait hint
	goto cleanup;

    g_o.hEvent = CreateEvent(NULL, TRUE, FALSE, NULL);

    // report the status to the service control manager.
    //
    if (!ReportStatusToSCMgr(
	SERVICE_RUNNING,       // service state
	NO_ERROR,	       // exit code
	0))		       // wait hint
	goto cleanup;

    bSuccess = TRUE;
    AddToEventLog(EVENTLOG_INFORMATION_TYPE, "%s Service Startup.", g_szPrgName);

    //
    // End of initialization
    //
    ////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////
    //
    // Service is now running, perform work until shutdown
    //

    RecvProc();

cleanup:

    g_bQuit = TRUE;

    if (g_hServerStopEvent != NULL)
	CloseHandle(g_hServerStopEvent);

    if (g_o.hEvent != NULL)
        CloseHandle(g_o.hEvent);

    WriteLog("Program Stopped");

    if (bSuccess)
	AddToEventLog(EVENTLOG_INFORMATION_TYPE, "%s Service Shutdown.", g_szPrgName);
    else
	AddToEventLog(EVENTLOG_ERROR_TYPE, "%s Service Startup Failed.", g_szPrgName);
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
    g_bQuit = TRUE;
    if (g_hServerStopEvent != NULL) {
        WriteLog("Stopping Service");
	SetEvent(g_hServerStopEvent);
    }
    return;
}
