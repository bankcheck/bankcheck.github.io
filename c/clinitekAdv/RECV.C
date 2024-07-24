#include <stdio.h>
#include <time.h>
#include "clinitekAdv.h"

int RecvProc(void)
{
    DWORD       dwLen;
    char	    buf[1024];
    int 	    nCount = 0;
    DWORD	    dwStatus;
    COMSTAT	    cs;
    DWORD	    dwError, dwErrorFlag;
    int         re_start;

    re_start = 0;
    while (1) {

	if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
	    break;

        if (g_bReOpenPort) {
            COMMTIMEOUTS    timeout;
            DCB             dcb;
            char            szDevice[40];

            if (g_hCom != INVALID_HANDLE_VALUE) {
                CloseHandle(g_hCom);
                g_hCom = INVALID_HANDLE_VALUE;
                Sleep(1000);
            }

            if (g_bDebug)
                WriteLog("Open port...");

            sprintf(szDevice, "\\\\.\\COM%d", g_nComPort);
            g_hCom = CreateFile(szDevice, GENERIC_READ | GENERIC_WRITE,
                                0, NULL, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, NULL);
            if (g_hCom == INVALID_HANDLE_VALUE) {
                WriteLog("Can't open COM port '%s'.", szDevice);
                continue;
            }

            SetupComm(g_hCom, g_nMaxReadBufferSize, g_nMaxWriteBufferSize);

            if (!GetCommState(g_hCom, &dcb)) {
                dwError = GetLastError();
                ClearCommError(g_hCom, &dwErrorFlag, &cs);
                WriteLog("GetCommState() failed, code %ld, flag %ld.", dwError, dwErrorFlag);
                continue;
            }

            dcb.BaudRate = g_nComBaudRate;
            dcb.ByteSize = (unsigned char)g_nComByteSize;
            dcb.Parity = (unsigned char)g_nComParity;
            dcb.StopBits = (unsigned char)g_nComStopBits;

            if (!SetCommState(g_hCom, &dcb)) {
                dwError = GetLastError();
                ClearCommError(g_hCom, &dwErrorFlag, &cs);
                WriteLog("SetCommState() failed, code %ld, flag %ld.", dwError, dwErrorFlag);
                continue;
            }

            memset(&timeout, '\0', sizeof(COMMTIMEOUTS));
            timeout.ReadIntervalTimeout = MAXDWORD;
            timeout.WriteTotalTimeoutMultiplier = 5;
            timeout.WriteTotalTimeoutConstant = 50;

            if (!SetCommTimeouts(g_hCom, &timeout)) {
                dwError = GetLastError();
                ClearCommError(g_hCom, &dwErrorFlag, &cs);
                WriteLog("SetCommTimeouts() failed, code %ld, flag %ld.", dwError, dwErrorFlag);
                continue;
            }

        }

        if (g_bCheckOnline) {
            if (g_bDebug)
                WriteLog("Checking port status...");
            if (GetCommModemStatus(g_hCom, &dwStatus) == FALSE) {
                dwError = GetLastError();
                ClearCommError(g_hCom, &dwErrorFlag, &cs);
                WriteLog("GetCommModemStatus() failed, code %ld, flag %ld", dwError, dwErrorFlag);
                continue;
            }
            if ((dwStatus & MS_CTS_ON) == 0) {
                WriteLog("No physical connection...");
                continue;
            }
        }

        if (g_bDebug)
			WriteLog("Purge port...");

        if (PurgeComm(g_hCom, PURGE_TXCLEAR) == FALSE) {
            dwError = GetLastError();
            ClearCommError(g_hCom, &dwErrorFlag, &cs);
            WriteLog("PurgeComm() failed, code %ld, flag %ld", dwError, dwErrorFlag);
            continue;
        }

        re_start = 0;

		//Xon/Xoff line ready
		buf[0] = DC1;
		buf[1] = '\0';
		SendChar(g_hCom, buf, 1);
		FlushFileBuffers(g_hCom);

        while (1) {
            if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
                g_bQuit = TRUE;
                break;
            }
            if (g_bCheckOnline) {
                if (g_bDebug)
                    WriteLog("Checking port status...");
                if (GetCommModemStatus(g_hCom, &dwStatus) == FALSE) {
                    dwError = GetLastError();
                    ClearCommError(g_hCom, &dwErrorFlag, &cs);
                    WriteLog("GetCommModemStatus() failed, code %ld, flag %ld", dwError, dwErrorFlag);
                    re_start = 1;
                    break;
                }
                if ((dwStatus & MS_CTS_ON) == 0) {
                    WriteLog("No physical connection...");
                    re_start = 1;
                    break;
                }
            }
            if (ReadDataFromComm(&dwLen, buf) > 0)
				break;
        }

        if (g_bQuit){
			buf[0] = DC3;
			buf[1] = '\0';
			SendChar(g_hCom, buf, 1);
			FlushFileBuffers(g_hCom);
            break;
		}
        if (re_start)
            continue;

        if (g_bDebug) {
            WriteLog("length: %d", dwLen);
            DumpErrorData(dwLen, buf);
        }

        GetData();
    }

    return 0;
}
