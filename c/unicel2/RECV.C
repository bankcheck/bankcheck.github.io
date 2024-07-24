#include <stdio.h>
#include <time.h>
#include "unicel2.h"

int RecvProc(void)
{
    DWORD       dwLen;
    char	    buf[4096];
    char	    cmd[2];
    int 	    nCount = 0;
    DWORD	    dwStatus;
    COMSTAT	    cs;
    DWORD	    dwError, dwErrorFlag;
    int         re_start;

	//dwLen =0;
	//buf[0] = '\0';

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
                WriteLog("No Physical Connection...");
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

//get packets;
		g_ls = LS_FREE;
        while (1) {
            //WriteLog("等待接收連線資料...");
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
                WriteLog("No Physical Connection...");
                    re_start = 1;
                    break;
                }
            }

            if (ReadDataFromComm(&dwLen, buf) > 0)
				break;
        }

        if (g_bQuit)
            break;

        if (re_start)
            continue;

		if (buf[0] == ENQ){
			WriteLog("Send ACK");
			cmd[0] = ACK;
			cmd[1] = '\0';
			SendChar(g_hCom, cmd, 1);
			FlushFileBuffers(g_hCom);
			GetData();
		} else {
			buf[dwLen] = '\0';
			cmd[0] = NAK;
			cmd[1] = '\0';
			SendChar(g_hCom, cmd, 1);
			FlushFileBuffers(g_hCom);
			WriteLog("Receive Unknown Packet, send NAK");
			DumpErrorData(dwLen, buf);
		}
    }

    return 0;
}
