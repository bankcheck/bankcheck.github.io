#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <tchar.h>
#include <time.h>
#include "service.h"
#include "OMNICELL.h"

// this event is signalled when the
// service should end
//

char        g_szProgID[40] = "OMNICELL";
char        g_szPrgName[80] = "HKAH OMNICELL";
HANDLE      g_hServerStopEvent = NULL;
HANDLE      g_hCom = INVALID_HANDLE_VALUE;
BOOL        g_bQuit = FALSE;
BOOL        g_bLog = FALSE;
BOOL        g_bDebug = FALSE;
char        g_szADTInBoxPath[260] = "C:\\HL7\\OMNICELL\\INBOX.ADT\\";
char        g_szRXFInBoxPath[260] = "C:\\HL7\\OMNICELL\\INBOX.RXF\\";
char        g_szRXPInBoxPath[260] = "C:\\HL7\\OMNICELL\\INBOX.RXP\\";
char        g_szLogPath[260] = "C:\\HL7\\OMNICELL\\LOG\\";
char        g_szBackupInBoxPath[260] = "C:\\HL7\\OMNICELL\\INBOX.BAK\\";
DWORD       g_dwSleep = 1000;
DWORD       g_dwRecvWait = 60000;
OVERLAPPED  g_o;
CLIENT		g_ADT;
CLIENT		g_RXF;
CLIENT		g_RXP;
char		g_szServer[80] = "139.168.200.1";
short		g_nADTPort = 5001;
short		g_nRXFPort = 5004;
short		g_nRXPPort = 5002;
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

	sprintf(g_RXF.name, "RXF");
	strcpy(g_RXF.ip, g_szServer);
	g_RXF.port = g_nRXFPort;
	g_RXF.connected = FALSE;

	sprintf(g_RXP.name, "RXP");
	strcpy(g_RXP.ip, g_szServer);
	g_RXP.port = g_nRXPPort;
	g_RXP.connected = FALSE;

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

    hThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)ADTThreadProc,
			    0, 0, &threadID);
    if (hThread == INVALID_HANDLE_VALUE) {
        AddToEventLog(EVENTLOG_ERROR_TYPE, "Can't create ADT thread.");
		goto cleanup;
    }

    hThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)RXFThreadProc,
			    0, 0, &threadID);
    if (hThread == INVALID_HANDLE_VALUE) {
        AddToEventLog(EVENTLOG_ERROR_TYPE, "Can't create RXF thread.");
		goto cleanup;
    }

    hThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)RXPThreadProc,
			    0, 0, &threadID);
    if (hThread == INVALID_HANDLE_VALUE) {
        AddToEventLog(EVENTLOG_ERROR_TYPE, "Can't create RXP thread.");
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
	disconnect(&g_RXF);
	disconnect(&g_RXP);
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
