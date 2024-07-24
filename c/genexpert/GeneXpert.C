#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <tchar.h>
#include <time.h>
#include "service.h"
#include "GeneXpert.h"

// this event is signalled when the
// service should end
//

char        g_szProgID[40] = "GeneXpert";
char        g_szPrgName[80] = "HKAH GeneXpert Service";
HANDLE      g_hServerStopEvent = NULL;
HANDLE      g_hCom = INVALID_HANDLE_VALUE;
BOOL        g_bQuit = FALSE;
BOOL        g_bLog = FALSE;
BOOL        g_bDebug = FALSE;
char        g_szFlagFile[260] = "C:\\MOXA\\GeneXpert\\FLAG.DAT";
char        g_szLogPath[260] = "C:\\MOXA\\GeneXpert\\LOG\\";
char        g_szOutBoxPath[260] = "C:\\MOXA\\GeneXpert\\OUTBOX\\";
char		g_szTempPath[260];
char		g_szInBoxPath[260];
char        g_szCodeFile[260] = "C:\\MOXA\\GeneXpert\\CODE.DAT";
char        g_szOutBufferFile[260] = "C:\\MOXA\\GeneXpert\\TEMP\\BUF.DAT";
DWORD       g_dwSleep = 1000;
DWORD       g_dwRecvWait = 60000;
OVERLAPPED  g_o;
CLIENT		g_Client;
char		g_szServer[80] = "139.168.200.1";
short		g_nPort = 5001;
short		g_nMaxRetry = 3;
unsigned long g_nMsgID;
int			g_timeout = 10000;
char        g_szBackupInBoxPath[260];
BOOL        g_bBackupInbox;
char        g_Pos[5];
char        g_Neg[5];
int			g_buffer = 16000;

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

//Winsock 
	WSADATA wData;
    int err;

    ///////////////////////////////////////////////////
    //
    // Service initialization
    //

    bSuccess = FALSE;

    g_o.hEvent = NULL;

    LoadRegVal();
    WriteLog("Starting...");

//Init winsock
	strcpy(g_Client.ip, g_szServer);
	g_Client.port = g_nPort;
	g_Client.connected = FALSE;

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

	DeleteFile(g_szOutBufferFile);

    //
    // End of initialization
    //
    ////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////
    //
    // Service is now running, perform work until shutdown
    //

    MainProc();

cleanup:

    g_bQuit = TRUE;

    if (g_hServerStopEvent != NULL)
	CloseHandle(g_hServerStopEvent);

    if (g_o.hEvent != NULL)
        CloseHandle(g_o.hEvent);

	disconnect(&g_Client);
	WSACleanup();

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
