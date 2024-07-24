#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <tchar.h>
#include "service.h"
#include "labclnt.h"

// this event is signalled when the
// service should end
//
char    g_szProfile[260] = "labclnt.ini";
CLIENT *g_Client = NULL;
int     g_nMaxClient = 5;
int     g_nMaxMachine = 1;
int     g_nCurMachine = 0;
HANDLE  g_hServerStopEvent = NULL;
short   g_nPort = 4921;
char    g_szServer[80] = "139.168.200.1";
SOCKET  g_sd = SOCKET_ERROR;
DWORD	g_dwMaxIdle = 180000;
DWORD	g_dwSleepTime = 30000;
DWORD   g_dwErrorSleepTime = 10000;
char    g_szPrgName[80] = "HKAH LAB result client";
char    g_szRootPath[260] = "C:\\MOXA\\LABCLNT\\";
BOOL	g_bLog = FALSE;
BOOL    g_bDebug = FALSE;
BOOL    g_bBackup = FALSE;
BOOL	g_bTimerQuit = TRUE;
BOOL	g_bQuit = FALSE;
int		g_nSeqDigit;

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
    WIN32_FIND_DATA data;
    HANDLE hFind;
    char title[260], buf[260];
    char path[260], fname[260], dir[260];
    char testdir[260];
    BOOL bCopyTest;
    char progname[260];
    BOOL bFound, bRunning;
    BOOL bSuccess;
    int i;
    int seq;
    char *p;

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
        g_Client[i].szFileName[0] = '\0';
        g_Client[i].szNo[0] = '\0';
        g_Client[i].szProg[0] = '\0';
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

        if (g_nCurMachine >= g_nMaxMachine) {
            g_nCurMachine = 0;
            g_nMaxMachine = GetPrivateProfileInt(MY_PROFILE, "MaxMachine", 0, g_szProfile);
        }
        sprintf(buf, "Machine%d", g_nCurMachine++);
        GetPrivateProfileString(MY_PROFILE, buf, "", title, 260, g_szProfile);
        if (title[0] == 0) continue;
        GetPrivateProfileString(title, "Directory", "", dir, 260, g_szProfile);
        AddBslash(dir);
        GetPrivateProfileString(title, "Program", "", progname, 260, g_szProfile);
        //seq = GetPrivateProfileInt(title, "Sequence", 1, g_szProfile);
        seq = 2;
        bCopyTest = GetPrivateProfileInt(title, "CopyTest", 0, g_szProfile);
        GetPrivateProfileString(title, "TestDirectory", "", testdir, 260, g_szProfile);
        AddBslash(testdir);

        switch (seq) {
            case 0:
                sprintf(path, "%s*-*", dir);
                break;

            case 1:
                sprintf(path, "%s*-*.*", dir);
                break;

            case 2:
            default:
                sprintf(path, "%s*", dir);
                break;
        }
        hFind = FindFirstFile(path, &data);
        if (hFind != INVALID_HANDLE_VALUE) {
            bFound = TRUE;
            while (bFound) {
                if (g_bQuit) break;
                if (data.cFileName[0] != '.' &&
                        (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0) {
                    sprintf(fname, "%s%s", dir, data.cFileName);
                    bRunning = FALSE;
                    for (i = 0; i < g_nMaxClient; i++) {
                        if (strcmp(g_Client[i].szFileName, fname) == 0) {
                            bRunning = TRUE;
                            break;
                        }
                    }
                    if (bRunning == FALSE) {
                        for (i = 0; i < g_nMaxClient; i++) {
                            if (g_Client[i].szFileName[0] == '\0')
                                break;
                        }
                        if (i < g_nMaxClient) {
                            g_Client[i].nSector = 0;
                            g_Client[i].nCup = 0;
                            if (seq == 0 || seq == 1) {
                                if (seq == 0)
                                    sprintf(buf, "%s.001", data.cFileName);
                                else
                                    strcpy(buf, data.cFileName);
                                p = strtok(buf, "-.");
                                if (p == NULL) {
                                    WriteLog("Can't get sector %s", data.cFileName);
                                    break;
                                }
                                g_Client[i].nSector = atoi(p);
                                p = strtok(NULL, ".");
                                if (p == NULL) {
                                    WriteLog("Can't get cup %s", data.cFileName);
                                    break;
                                }
                                g_Client[i].nCup = atoi(p);
                            }
                            else {
                                g_Client[i].nSector = 0;
                                g_Client[i].nCup = 0;
                            }
                            strcpy(g_Client[i].szNo, data.cFileName);
                            g_Client[i].bCheck = FALSE;
                            g_Client[i].s = SOCKET_ERROR;
                            g_Client[i].nSeq = seq;
                            g_Client[i].bCopyTest = bCopyTest;
                            strcpy(g_Client[i].szTestDir, testdir);
                            strcpy(g_Client[i].szProg, progname);
                            strcpy(g_Client[i].szFileName, fname);
                            /*if (g_bDebug) {
                                WriteLog("%d: Program: %s", i, g_Client[i].szProg);
                                WriteLog("%d: FileName: %s", i, g_Client[i].szFileName);
                                WriteLog("%d: No: %s", i, g_Client[i].szNo);
                            }
                            else
                                WriteLog("%d: FileName: %s", i, g_Client[i].szFileName);*/
                            WriteLog("FileName: %s", g_Client[i].szFileName);
                            hThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)SendThreadProc,
                                                    (LPVOID)i, 0, &threadID);
                            if (hThread == INVALID_HANDLE_VALUE) {
                                //AddToEventLog(EVENTLOG_ERROR_TYPE, "Can't create send thread.");
                                g_Client[i].bCheck = FALSE;
                                g_Client[i].s = SOCKET_ERROR;
                                g_Client[i].szFileName[0] = '\0';
                            }
                        }
                    }
                }
                bFound = FindNextFile(hFind, &data);
            }
            FindClose(hFind);
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

    /*if (bWinSock)
	WSACleanup();*/

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
