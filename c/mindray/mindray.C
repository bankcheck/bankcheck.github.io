#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <tchar.h>
#include <time.h>
#include "service.h"
#include "MINDRAY.h"

// this event is signalled when the
// service should end
//

char        g_szProgID[40] = "MINDRAY";
char        g_szPrgName[80] = "HKAH MINDRAY";
HANDLE      g_hServerStopEvent = NULL;
HANDLE      g_hCom = INVALID_HANDLE_VALUE;
BOOL        g_bQuit = FALSE;
BOOL        g_bLog = FALSE;
BOOL        g_bDebug = FALSE;
char        g_szADTInBoxPath[260] = "C:\\HL7\\MINDRAY\\INBOX\\";
char        g_szEMRInBoxPath[260] = "C:\\HL7\\MINDRAY\\INBOX\\";
char        g_szOutBoxPath[260] = "C:\\HL7\\MINDRAY\\OUTBOX\\";
char        g_szLogPath[260] = "C:\\HL7\\MINDRAY\\LOG\\";
char        g_szBackupInBoxPath[260] = "C:\\HL7\\MINDRAY\\INBOX.BAK\\";
DWORD       g_dwSleep = 1000;
DWORD       g_dwRecvWait = 60000;
OVERLAPPED  g_o;
CLIENT		g_ADT;
CLIENT		g_EMR;
char		g_szServer[80] = "139.168.200.1";
short		g_nADTPort = 5001;
short		g_nEMRPort = 5004;
short		g_nMaxRetry = 3;
int			g_timeout = 10000;

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

    HANDLE hThread;
    DWORD threadID;

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
	sprintf(g_ADT.name, "ADT");
	strcpy(g_ADT.ip, g_szServer);
	g_ADT.port = g_nADTPort;
	WriteLog("init");
	g_ADT.connected = FALSE;

	sprintf(g_EMR.name, "EMR");
	strcpy(g_EMR.ip, g_szServer);
	g_EMR.port = g_nEMRPort;
	g_EMR.connected = FALSE;

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

    //
    // End of initialization
    //
    ////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////
    //
    // Service is now running, perform work until shutdown
    //

    //MainProc();
    hThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)ADTThreadProc,
			    0, 0, &threadID);
    if (hThread == INVALID_HANDLE_VALUE) {
        AddToEventLog(EVENTLOG_ERROR_TYPE, "Can't create ADT thread.");
		goto cleanup;
    }

    hThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)EMRThreadProc,
			    0, 0, &threadID);
    if (hThread == INVALID_HANDLE_VALUE) {
        AddToEventLog(EVENTLOG_ERROR_TYPE, "Can't create EMR thread.");
		goto cleanup;
    }

    while (1) {
        if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 3000) == WAIT_OBJECT_0)
            break;
	}
cleanup:

    g_bQuit = TRUE;

    if (g_hServerStopEvent != NULL)
	CloseHandle(g_hServerStopEvent);

    if (g_o.hEvent != NULL)
        CloseHandle(g_o.hEvent);

	disconnect(&g_ADT);
	disconnect(&g_EMR);
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
