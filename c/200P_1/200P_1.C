#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <tchar.h>
#include <time.h>
#include "service.h"
#include "200p_1.h"

// this event is signalled when the
// service should end
//

char        g_szProgID[40] = "200P_1";
int         g_nMaxReadBufferSize = 8192;
int         g_nMaxWriteBufferSize = 8192;
int         g_nComBaudRate = 9600;
int         g_nComByteSize = 8;
int         g_nComParity = NOPARITY;
int         g_nComStopBits = ONESTOPBIT;
int         g_nComPort = 1;
OVERLAPPED  g_o;
char        g_szPrgName[80] = "TAH 200P_1";
HANDLE      g_hServerStopEvent = NULL;
HANDLE      g_hCom = INVALID_HANDLE_VALUE;
BOOL        g_bQuit = FALSE;
BOOL        g_bLog = FALSE;
BOOL        g_bDebug = FALSE;
BOOL        g_bReOpenPort = FALSE;
BOOL        g_bCheckOnline = TRUE;
char        g_szTempPath[260] = "D:\\MOXA\\200P_1\\TEMP\\";
char        g_szDataPath[260] = "D:\\MOXA\\200P_1\\DATA\\";
char        g_szLogPath[260] = "D:\\MOXA\\200P_1\\LOG\\";
int         g_nMappingIndex = 0;
char        g_szFileMapping[260] = "MOXA_MONITOR";
DWORD       g_dwSleep = 1000;
DWORD       g_dwRecvWait = 60000;

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
    COMMTIMEOUTS    timeout;
    DCB             dcb;
    DWORD           dwError, dwErrorFlag;
    COMSTAT         cs;
    char            szDevice[40];

    ///////////////////////////////////////////////////
    //
    // Service initialization
    //

    bSuccess = FALSE;
    g_o.hEvent = NULL;

    LoadRegVal();
    WriteLog("啟動中...");

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

    sprintf(szDevice, "\\\\.\\COM%d", g_nComPort);
    g_hCom = CreateFile(szDevice, GENERIC_READ | GENERIC_WRITE,
                        0, NULL, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, NULL);
    if (g_hCom == INVALID_HANDLE_VALUE) {
        AddToEventLog(EVENTLOG_ERROR_TYPE, "Can't open comport '%s'.", szDevice);
	goto cleanup;
    }

    SetupComm(g_hCom, g_nMaxReadBufferSize, g_nMaxWriteBufferSize);

    if (!GetCommState(g_hCom, &dcb)) {
        dwError = GetLastError();
        ClearCommError(g_hCom, &dwErrorFlag, &cs);
        AddToEventLog(EVENTLOG_ERROR_TYPE, "GetCommState() failed, code %ld, flag %ld.", dwError, dwErrorFlag);
	goto cleanup;
    }

    dcb.BaudRate = g_nComBaudRate;
    dcb.ByteSize = (unsigned char)g_nComByteSize;
    dcb.Parity = (unsigned char)g_nComParity;
    dcb.StopBits = (unsigned char)g_nComStopBits;

    if (!SetCommState(g_hCom, &dcb)) {
        dwError = GetLastError();
        ClearCommError(g_hCom, &dwErrorFlag, &cs);
        AddToEventLog(EVENTLOG_ERROR_TYPE, "SetCommState() failed, code %ld, flag %ld.", dwError, dwErrorFlag);
	goto cleanup;
    }

    memset(&timeout, '\0', sizeof(COMMTIMEOUTS));
    timeout.ReadIntervalTimeout = MAXDWORD;
    timeout.WriteTotalTimeoutMultiplier = 5;
    timeout.WriteTotalTimeoutConstant = 50;

    if (!SetCommTimeouts(g_hCom, &timeout)) {
        dwError = GetLastError();
        ClearCommError(g_hCom, &dwErrorFlag, &cs);
        AddToEventLog(EVENTLOG_ERROR_TYPE, "SetCommTimeouts() failed, code %ld, flag %ld.", dwError, dwErrorFlag);
	goto cleanup;
    }

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

    if (g_hCom != INVALID_HANDLE_VALUE)
        CloseHandle(g_hCom);

    WriteLog("結束連線");

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
