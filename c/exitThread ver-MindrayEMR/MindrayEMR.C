#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <tchar.h>
#include <time.h>
#include "service.h"
#include "MindrayEMR.h"

// this event is signalled when the
// service should end
//

char        g_szPrgName[80] = "HKAH mindray EMR Server";
HANDLE      g_hServerStopEvent = NULL;
HANDLE      g_hCom = INVALID_HANDLE_VALUE;
BOOL        g_bQuit = FALSE;
BOOL        g_bLog = FALSE;
BOOL        g_bDebug = FALSE;
BOOL        g_bBackupInbox = FALSE;
char        g_szInBoxPath[260] = "C:\\HL7\\mindray\\INBOX\\";
char        g_szLogPath[260] = "C:\\HL7\\mindray\\LOG\\";
char        g_szBackupInBoxPath[260] = "C:\\HL7\\mindray\\INBOX.BAK\\";
char        g_szOutBoxPath[260] = "C:\\HL7\\mindray\\OUTBOX\\";
char        g_szTempPath[260] = "C:\\HL7\\mindray\\TEMP\\";

DWORD       g_dwSleep = 1000;
OVERLAPPED  g_o;
short		g_nPort = 6001;
short		g_nMaxRetry = 3;
int			g_timeout = 10000;

SOCKET		g_server = SOCKET_ERROR;
CLIENT		g_client[MAX_CONN];

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
    //HANDLE		hThread;
//    DWORD		threadID;
	char		ip[17];
//	BOOL		found;

	WIN32_FIND_DATA data;
    HANDLE  hFind;
    char	path[260], fname[260];
    BOOL	bFound;

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

	for (i = 0; i < MAX_CONN; i++) {
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

    if (listen(g_server , MAX_CONN) < 0) {
		AddToEventLog(EVENTLOG_ERROR_TYPE, "listen() error.");
		goto cleanup;
    }
	WriteLog("Listen to port %d", g_nPort);
	WriteLog("Allow maximum conection: %d", MAX_CONN);

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

		strcpy(ip, inet_ntoa(addr.sin_addr));

		for (i = 0; i < MAX_CONN; i++) {
			if (strcmp(g_client[i].ip, ip) == 0) {
				close_client(i);
				g_client[i].exit = FALSE;
			}
		}

		if (curr >= MAX_CONN) 
			curr = 0;

		close_client(curr);

		g_client[curr].s = temp;
		strcpy(g_client[curr].ip, ip);

		setsockopt(g_client[curr].s, SOL_SOCKET, SO_RCVTIMEO, (char *)&g_timeout, sizeof(int)); //setting the receive timeout

//Clear all files before process
		sprintf(fname, "%sEMR%d", g_szTempPath, curr);
		if (DeleteFile(fname) != 0) {
			WriteLog("%d:Delete file %s ", curr, fname);
		}
		
		sprintf(path, "%sEMR_%s_*", g_szInBoxPath, g_client[curr].ip);

		hFind = FindFirstFile(path, &data);
		if (hFind != INVALID_HANDLE_VALUE) {
			bFound = TRUE;
			
			while (bFound) {
				if (g_bQuit) break;

				if (data.cFileName[0] != '.' &&
				    (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0) {

					sprintf(fname, "%s%s", g_szInBoxPath, data.cFileName);

					if (DeleteFile(fname) != 0) {
						WriteLog("%d:Delete file %s ", curr, fname);
					} else {
						WriteLog("%d:Cannot delete file %s ", curr, fname);
					}
				
				}

				bFound = FindNextFile(hFind, &data);

			}
			
			FindClose(hFind);
		}
//
		while (g_client[i].exit) {
			if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
				break;

			if (g_dwSleep > 0)
				Sleep(g_dwSleep);
		}

		g_client[curr].hThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)RecvThreadProc,
			(LPVOID)curr, 0, &g_client[curr].dThreadID);

		if (g_client[curr].hThread == INVALID_HANDLE_VALUE) {
			AddToEventLog(EVENTLOG_ERROR_TYPE, "Can't create thread.");
			WriteLog("%d:Can't create thread for ip=%s, ", curr, g_client[curr].ip);
		} else {
			WriteLog("Socket %d accepted, ip=%s, thread ID=%d", curr, g_client[curr].ip, g_client[curr].dThreadID);
		}

		curr++;
    }

cleanup:

    g_bQuit = TRUE;

    if (g_hServerStopEvent != NULL)
	CloseHandle(g_hServerStopEvent);

    if (g_o.hEvent != NULL)
        CloseHandle(g_o.hEvent);

//disconnect
	closesocket(g_server);
    for (i = 0; i < MAX_CONN; i++) {
		CloseHandle(g_client[i].hThread);
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
