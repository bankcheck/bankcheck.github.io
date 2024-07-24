#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <tchar.h>
#include <time.h>
#include "service.h"
#include "c8000s1.h"

// this event is signalled when the
// service should end
//

char        g_szProgID[40] = "c8000s1";
char        g_szPrgName[80] = "HKAH C8000 Server2";
HANDLE      g_hServerStopEvent = NULL;
HANDLE      g_hCom = INVALID_HANDLE_VALUE;
BOOL        g_bQuit = FALSE;
BOOL        g_bLog = FALSE;
BOOL        g_bDebug = FALSE;
BOOL        g_bBackupInbox = FALSE;
char        g_szInBoxPath[260] = "C:\\MOXA\\sysmex\\INBOX\\";
char        g_szLogPath[260] = "C:\\MOXA\\sysmex\\LOG\\";
char        g_szBackupInBoxPath[260] = "C:\\MOXA\\sysmex\\INBOX.BAK\\";
char        g_szOutBoxPath[260] = "C:\\MOXA\\sysmex\\OUTBOX\\";
char        g_szCodeFile[260] = "D:\\MOXA\\sysmex\\CODE.DAT";
char        g_szTempPath[260] = "D:\\MOXA\\sysmex\\TEMP\\";
DWORD       g_dwSleep = 1000;
DWORD       g_dwRecvWait = 60000;
OVERLAPPED  g_o;
char		g_szServer[80] = "139.168.200.1";
unsigned short	g_nPort = 5001;
short		g_nMaxRetry = 3;
//short		g_nMsgID;
int			g_timeout = 10000;
int			g_mode;
int			g_flag = 100;

SOCKET		g_server = SOCKET_ERROR;
CLIENT		g_client[SOMAXCONN];
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
	struct sockaddr_in server, addr;
	int			i;
	int			curr = 0;
	SOCKET		temp;
	DWORD		len;
    HANDLE		hThread;
    DWORD		threadID;

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

//Init winsock
	err = WSAStartup(0x101, &wData);
    if (err != 0) {
        AddToEventLog(EVENTLOG_ERROR_TYPE, "Initialize WinSock DLL failed.");
		goto cleanup;
    }

	for (i = 0; i < SOMAXCONN; i++) {
		g_client[i].s = SOCKET_ERROR;
    }
      
    //Create a socket
    if((g_server = socket(AF_INET , SOCK_STREAM , 0 )) == INVALID_SOCKET)
    {
        AddToEventLog(EVENTLOG_ERROR_TYPE, "Could not create server socket : %d" , WSAGetLastError());
		WriteLog("Could not create server socket : %d" , WSAGetLastError());
		goto cleanup;
    }
  
	//Prepare the sockaddr_in structure
    server.sin_family = AF_INET;
    server.sin_addr.s_addr = INADDR_ANY;
    server.sin_port = htons( g_nPort );
      
    //Bind
    if( bind(g_server ,(struct sockaddr *)&server , sizeof(server)) == SOCKET_ERROR)
    {
        AddToEventLog(EVENTLOG_ERROR_TYPE, "Bind failed with error code : %d" , WSAGetLastError());
		WriteLog("Bind failed with error code : %d" , WSAGetLastError());
		goto cleanup;
    }

    // report the status to the service control manager.
    //
    if (!ReportStatusToSCMgr(
	SERVICE_START_PENDING, // service state
	NO_ERROR,	       // exit code
	3000))		       // wait hint
	goto cleanup;

    if (listen(g_server , SOMAXCONN) < 0) {
		AddToEventLog(EVENTLOG_ERROR_TYPE, "listen() error.");
		goto cleanup;
    }
	WriteLog("Listen to port %d", g_nPort);

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
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;

	    len = sizeof(addr);
        temp = accept(g_server, (struct sockaddr *)&addr, &len);
		if (temp == SOCKET_ERROR) {
			if (g_bQuit)
			break;
			AddToEventLog(EVENTLOG_ERROR_TYPE, "accept() error.");
			continue;
		}

		if (curr >= SOMAXCONN) 
			curr = 0;

		close_client(curr);

		g_client[curr].s = temp;
        g_client[curr].ip = inet_ntoa(addr.sin_addr);
		g_client[curr].tick = GetTickCount();

		WriteLog("Socket %d accepted, ip=%s", curr, g_client[curr].ip);

		hThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)RecvThreadProc,
				(LPVOID)curr, 0, &threadID);

		curr++;

		if (hThread == INVALID_HANDLE_VALUE) {
			AddToEventLog(EVENTLOG_ERROR_TYPE, "Can't create thread.");
			continue;
		}
    }

cleanup:

    g_bQuit = TRUE;

    if (g_hServerStopEvent != NULL)
	CloseHandle(g_hServerStopEvent);

    if (g_o.hEvent != NULL)
        CloseHandle(g_o.hEvent);

//disconnect
	closesocket(g_server);
    for (i = 0; i <= SOMAXCONN; i++) {
		close_client(i);
		if (g_dwSleep != 0)
			Sleep(g_dwSleep);
    }

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
_TRY_EXCEPTION_BLOCK_BEGIN()

    g_bQuit = TRUE;
    if (g_hServerStopEvent != NULL) {
        WriteLog("Stopping Service");
		SetEvent(g_hServerStopEvent);
		if (g_server != SOCKET_ERROR) {
			closesocket(g_server);
			g_server = SOCKET_ERROR;
		}
	}

_TRY_EXCEPTION_BLOCK_END(1)

    return;
}
