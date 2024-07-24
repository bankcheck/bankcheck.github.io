#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <tchar.h>
#include "service.h"
#include "labsrv.h"

// this event is signalled when the
// service should end
//
char    g_szProfile[260] = "labsrv.ini";
CLIENT *g_Client = NULL;
int     g_nMaxClient = 5;
HANDLE  g_hServerStopEvent = NULL;
short   g_nPort = 4921;
SOCKET  g_sd = SOCKET_ERROR;
DWORD	g_dwMaxIdle = 180000;
DWORD	g_dwSleepTime = 30000;
char    g_szPrgName[80] = "TAH LAB inbox server";
char    g_szRootPath[260] = "C:\\MOXA\\LABSRV\\";
char    g_szDataPath[260] = "C:\\MOXA\\";
BOOL	g_bLog = FALSE;
BOOL    g_bDebug = FALSE;
BOOL	g_bTimerQuit = TRUE;
BOOL    g_bBackup = FALSE;
BOOL    g_bQuit = FALSE;

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
    HANDLE hThread;
    DWORD threadID;
    BOOL bWinSock;
    BOOL bSuccess;
    struct sockaddr_in svr_addr, addr;
    int i;
    int len;
    SOCKET sd;

_TRY_EXCEPTION_BLOCK_BEGIN()

    ///////////////////////////////////////////////////
    //
    // Service initialization
    //

    bSuccess = FALSE;
    bWinSock = FALSE;
    g_Client = NULL;

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
    bWinSock = TRUE;

    g_Client = (CLIENT *)malloc(sizeof(CLIENT) * g_nMaxClient);
    if (g_Client == NULL) {
	AddToEventLog(EVENTLOG_ERROR_TYPE, "Failed to allocate memory.");
	goto cleanup;
    }
    for (i = 0; i < g_nMaxClient; i++) {
	g_Client[i].s = SOCKET_ERROR;
	g_Client[i].bCheck = FALSE;
	g_Client[i].tick = 0;
    }

    // report the status to the service control manager.
    //
    if (!ReportStatusToSCMgr(
	SERVICE_START_PENDING, // service state
	NO_ERROR,	       // exit code
	3000))		       // wait hint
	goto cleanup;

    hThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)TimerThreadProc,
			    0, 0, &threadID);
    if (hThread == INVALID_HANDLE_VALUE) {
        AddToEventLog(EVENTLOG_ERROR_TYPE, "Can't create timer thread.");
	goto cleanup;
    }

    g_sd = SOCKET_ERROR;
    g_sd = socket(AF_INET, SOCK_STREAM, 0);
    if (g_sd == SOCKET_ERROR) {
	AddToEventLog(EVENTLOG_ERROR_TYPE, "Can't open TCP socket.");
	goto cleanup;
    }

    // report the status to the service control manager.
    //
    if (!ReportStatusToSCMgr(
	SERVICE_START_PENDING, // service state
	NO_ERROR,	       // exit code
	3000))		       // wait hint
	goto cleanup;

    svr_addr.sin_family = AF_INET;
    svr_addr.sin_addr.s_addr = 0;
    svr_addr.sin_port = htons(g_nPort);
    if (bind(g_sd, (struct sockaddr *)&svr_addr, sizeof(svr_addr)) < 0) {
	AddToEventLog(EVENTLOG_ERROR_TYPE, "Can't bind local address.");
	goto cleanup;
    }

    // report the status to the service control manager.
    //
    if (!ReportStatusToSCMgr(
	SERVICE_START_PENDING, // service state
	NO_ERROR,	       // exit code
	3000))		       // wait hint
	goto cleanup;

    if (listen(g_sd, 5) < 0) {
	AddToEventLog(EVENTLOG_ERROR_TYPE, "listen() error.");
	goto cleanup;
    }
    len = sizeof(addr);

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

    while (1) {
        if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleepTime) == WAIT_OBJECT_0)
	    break;

        sd = accept(g_sd, (struct sockaddr *)&addr, &len);
	if (sd == SOCKET_ERROR) {
	    if (g_bQuit)
		break;
	    AddToEventLog(EVENTLOG_ERROR_TYPE, "accept() error.");
	    continue;
	}
	for (i = 0; i < g_nMaxClient; i++) {
	    if (g_Client[i].s == SOCKET_ERROR) {
		g_Client[i].tick = GetTickCount();
		g_Client[i].s = sd;
		break;
	    }
	}
	if (i >= g_nMaxClient) {
            WriteLog(-1, "Too many connections");
	    closesocket(sd);
	    continue;
	}
	hThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)RecvThreadProc,
				(LPVOID)i, 0, &threadID);
	if (hThread == INVALID_HANDLE_VALUE) {
	    AddToEventLog(EVENTLOG_ERROR_TYPE, "Can't create recv thread.");
	    g_Client[i].bCheck = FALSE;
	    g_Client[i].s = SOCKET_ERROR;
	    closesocket(sd);
	    continue;
	}
    }

cleanup:

    g_bQuit = TRUE;

    if (g_hServerStopEvent)
	CloseHandle(g_hServerStopEvent);

    while (g_bTimerQuit == FALSE)
	Sleep(1000);

    if (g_Client != NULL) {
	CLIENT *p;

	p = g_Client;
	g_Client = NULL;
	free(p);
    }

    if (bWinSock)
	WSACleanup();

    if (bSuccess)
        AddToEventLog(EVENTLOG_INFORMATION_TYPE, "%s Service Shutdown.", g_szPrgName);
    else
        AddToEventLog(EVENTLOG_ERROR_TYPE, "%s Service Startup Failed.", g_szPrgName);

    WriteLog(-1, "Shutdown");

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
        WriteLog(-1, "Stopping Service");
	SetEvent(g_hServerStopEvent);
        if (g_sd != SOCKET_ERROR) {
	    closesocket(g_sd);
	    g_sd = SOCKET_ERROR;
	}
    }

_TRY_EXCEPTION_BLOCK_END(1)

    return;
}
