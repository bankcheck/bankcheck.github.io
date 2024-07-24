#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <tchar.h>
#include <time.h>
#include "service.h"
#include "FilmArray.h"

// this event is signalled when the
// service should end
//

char        g_szProgID[40] = "FilmArray";
int         g_nMaxReadBufferSize = 8192;
int         g_nMaxWriteBufferSize = 8192;
int         g_nComBaudRate = 9600;
int         g_nComByteSize = 8;
int         g_nComParity = NOPARITY;
int         g_nComStopBits = ONESTOPBIT;
int         g_nComPort = 1;
OVERLAPPED  g_o;
char        g_szPrgName[80] = "HKAH FilmArray";
HANDLE      g_hServerStopEvent = NULL;
//HANDLE      g_hCom = INVALID_HANDLE_VALUE;
BOOL        g_bWriteSectorCup = FALSE;
BOOL        g_bQuit = FALSE;
//BOOL        g_bUpload = FALSE;
BOOL        g_bLog = FALSE;
BOOL        g_bDebug = FALSE;
BOOL        g_bCheckDigit = FALSE;
BOOL        g_bCheckOnline = TRUE;
BOOL        g_bBackupInbox = FALSE;
char        g_szCodeFile[260] = "D:\\MOXA\\FilmArray\\CODE.DAT";
char        g_szTempPath[260] = "D:\\MOXA\\FilmArray\\TEMP\\";
char        g_szBackupPath[260] = "D:\\MOXA\\FilmArray\\BACKUP\\";
char        g_szInBoxPath[260] = "D:\\MOXA\\FilmArray\\INBOX\\";
char        g_szInBoxDataPath[260] = "D:\\MOXA\\FilmArray\\INBOX\\";
char        g_szOutBoxPath[260] = "D:\\MOXA\\FilmArray\\OUTBOX\\";
char        g_szLogPath[260] = "D:\\MOXA\\FilmArray\\LOG\\";
char        g_szRateFile[260] = "D:\\MOXA\\FilmArray\\RATE.DAT";
int         g_nMappingIndex = 0;
char        g_szFileMapping[260] = "MOXA_MONITOR";
DWORD       g_dwSleep = 1000;
DWORD       g_dwRecvWait = 60000;
char         g_szFilePre[2] = "4";
int          g_nDayAgo = 7;
int          g_nNowDay = 0;
char		g_buffer[1024];
char		g_fname[260];
int         g_InstrumentDate = 1;
//int         g_Numeric = 1;
int          g_ls = LS_FREE;
int			g_mode;
char         g_Detect[5];
char         g_NotDetect[5];
char         g_Equivoc[5];

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
//    COMMTIMEOUTS    timeout;
//    DCB             dcb;
//    DWORD           dwError, dwErrorFlag;
//    COMSTAT         cs;
//    char            szDevice[40];

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
/*
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
*/
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
/*
    if (g_hCom != INVALID_HANDLE_VALUE)
        CloseHandle(g_hCom);
*/
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
