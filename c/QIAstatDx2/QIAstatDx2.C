#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <tchar.h>
#include <time.h>
#include "service.h"
#include "QIAstatDx2.h"

// this event is signalled when the
// service should end
//

char        g_szPrgName[80] = "HKAH QIAstatDx2 Server";
HANDLE      g_hServerStopEvent = NULL;
HANDLE      g_hCom = INVALID_HANDLE_VALUE;
BOOL        g_bQuit = FALSE;
BOOL        g_bLog = FALSE;
BOOL        g_bDebug = FALSE;
BOOL        g_bBackupInbox = FALSE;
BOOL        g_bOverwriteTNS = FALSE;

char        g_szInBoxPath[260] = "C:\\HL7\\QIAstatDx2\\INBOX\\";
char        g_szLogPath[260] = "C:\\HL7\\QIAstatDx2\\LOG\\";
char        g_szBackupInBoxPath[260] = "C:\\HL7\\QIAstatDx2\\INBOX.BAK\\";
char        g_szOutBoxPath[260] = "C:\\HL7\\QIAstatDx2\\OUTBOX\\";
char        g_szTempPath[260] = "C:\\HL7\\QIAstatDx2\\TEMP\\";
char        g_szTNSFileSource[260] = "C:\\HL7\\QIAstatDx\\tnsnames.ora";
char        g_szTNSFileDest[260] = "C:\\oracle\\ora92\\network\\ADMIN\\tnsnames.ora";

DWORD       g_dwSleep = 1000;
OVERLAPPED  g_o;
short		g_nPort = 6001;
short		g_nMaxRetry = 3;
int			g_timeout = 10000;

SOCKET		g_server = SOCKET_ERROR;
CLIENT	    *g_Client;
int			g_nMaxClient = SOMAXCONN;

//db
char		g_db[80] = "139.168.200.1";

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
    BOOL			bNew;

//Winsock 
    WSADATA wData;
    int err;
	struct sockaddr_in server, addr;
	int			i;
	int			curr = 0;
	int			conn;

	SOCKET		*temp;
	DWORD		len;
	char		ip[17];

	//HANDLE		hThread;
/*
	WIN32_FIND_DATA data;
    HANDLE  hFind;
    char	path[260], fname[260];
    BOOL	bFound;
*/
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

    g_Client = (CLIENT *)malloc(sizeof(CLIENT) * g_nMaxClient);
    
	if (g_Client == NULL) {
		AddToEventLog(EVENTLOG_ERROR_TYPE, "Failed to allocate memory.");
		goto cleanup;
    }

    for (i = 0; i < g_nMaxClient; i++) {
		g_Client[i].s = SOCKET_ERROR;
		//g_Client[i].bIdle = TRUE;
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

    if (listen(g_server , g_nMaxClient) < 0) {
		AddToEventLog(EVENTLOG_ERROR_TYPE, "listen() error.");
		goto cleanup;
    }
	WriteLog("Listen to port %d", g_nPort);
	WriteLog("Allow maximum conection: %d", g_nMaxClient);

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

	for (i = 0; i < g_nMaxClient; i++) {
		close_client(i);

		g_Client[i].hThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)RecvThreadProc,
				(LPVOID)i, 0, &g_Client[i].dThreadID);

		if (g_Client[i].hThread == INVALID_HANDLE_VALUE) {
			AddToEventLog(EVENTLOG_ERROR_TYPE, "Can't create thread.");
			WriteLog("%d:Can't create thread", i);
		} else {
			WriteLog("%d:Thread %d Created", i, g_Client[i].dThreadID);
		}
	}
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

		temp = (SOCKET *)malloc(sizeof(SOCKET));

        *temp = accept(g_server, (struct sockaddr *)&addr, &len);

		if (*temp == SOCKET_ERROR) {
			if (g_bQuit)
			break;
			AddToEventLog(EVENTLOG_ERROR_TYPE, "accept() error.");
			continue;
		}

		strcpy(ip, inet_ntoa(addr.sin_addr));

		bNew = TRUE;

		for (i = 0; i < g_nMaxClient; i++) {
			if (strcmp(g_Client[i].ip, ip) == 0) {
				//close_client(i);
				conn = i;
				bNew = FALSE;
				break;
			}
		}
		
		if (bNew) {
			if (curr >= g_nMaxClient) {
				WriteLog("Too many connections, cannot accept %s", ip);
				continue;
			} else {
				conn = curr;
				curr++;

			}
		}

//		if (g_Client[conn].s == SOCKET_ERROR) {
		g_Client[conn].s = *temp;
		strcpy(g_Client[conn].ip, ip);
		setsockopt(g_Client[conn].s, SOL_SOCKET, SO_RCVTIMEO, (char *)&g_timeout, sizeof(int)); //setting the receive timeout
		WriteLog("Socket %d accepted, ip=%s, thread ID=%d", conn, g_Client[conn].ip, g_Client[conn].dThreadID);
//	    }

		temp = NULL;
    }

cleanup:

    g_bQuit = TRUE;
	dbdisconnect();

    if (g_hServerStopEvent != NULL)
	CloseHandle(g_hServerStopEvent);

    if (g_o.hEvent != NULL)
        CloseHandle(g_o.hEvent);

//disconnect
	closesocket(g_server);
    for (i = 0; i < g_nMaxClient; i++) {
		//CloseHandle(hThread);
		close_client(i);
		if (g_dwSleep != 0)
			Sleep(g_dwSleep);

		if (g_Client[i].dThreadID > 0) {
			TerminateThread(g_Client[i].hThread, 0);
			CloseHandle(g_Client[i].hThread);
			WriteLog("%d:Thread %d terminated", i, g_Client[i].dThreadID);
			g_Client[i].dThreadID = 0;
		}
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
