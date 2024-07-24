#include <stdio.h>
#include <time.h>
#include "lx_20.h"

#define LS_INIT         0
#define LS_FREE         1
#define LS_UPLOAD       2

int RecvProc(void)
{
    DWORD           dwLen;
    char	    buf[1024];
    int 	    nCount = 0;
    DWORD	    dwStatus;
    COMSTAT	    cs;
    DWORD	    dwError, dwErrorFlag;
    int             line_state;
    int             re_start;

    line_state = LS_INIT;
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
                WriteLog("開啟通訊埠...");
            sprintf(szDevice, "\\\\.\\COM%d", g_nComPort);
            g_hCom = CreateFile(szDevice, GENERIC_READ | GENERIC_WRITE,
                                0, NULL, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, NULL);
            if (g_hCom == INVALID_HANDLE_VALUE) {
                WriteLog("Can't open comport '%s'.", szDevice);
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

            if (g_bDebug)
                WriteLog("清除通訊埠資料...");
            if (PurgeComm(g_hCom, PURGE_TXCLEAR) == FALSE) {
                dwError = GetLastError();
                ClearCommError(g_hCom, &dwErrorFlag, &cs);
                WriteLog("PurgeComm() failed, code %ld, flag %ld", dwError, dwErrorFlag);
                continue;
            }
        }

        if (g_bCheckOnline) {
            if (g_bDebug)
                WriteLog("檢查通訊埠狀態...");
            if (GetCommModemStatus(g_hCom, &dwStatus) == FALSE) {
                dwError = GetLastError();
                ClearCommError(g_hCom, &dwErrorFlag, &cs);
                WriteLog("GetCommModemStatus() failed, code %ld, flag %ld", dwError, dwErrorFlag);
                continue;
            }
            if ((dwStatus & MS_CTS_ON) == 0) {
                WriteLog("線路未連接, 請檢查線路...");
                line_state = LS_INIT;
                continue;
            }
        }

        if (line_state == LS_INIT) {
            WriteLog("啟動連線...");
            re_start = 0;
            while (1) {
                if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
                    g_bQuit = TRUE;
                    break;
                }
                if (g_bCheckOnline) {
                    if (g_bDebug)
                        WriteLog("檢查通訊埠狀態...");
                    if (GetCommModemStatus(g_hCom, &dwStatus) == FALSE) {
                        dwError = GetLastError();
                        ClearCommError(g_hCom, &dwErrorFlag, &cs);
                        WriteLog("GetCommModemStatus() failed, code %ld, flag %ld", dwError, dwErrorFlag);
                        line_state = LS_INIT;
                        re_start = 1;
                        break;
                    }
                    if ((dwStatus & MS_CTS_ON) == 0) {
                        WriteLog("線路未連接, 請檢查線路...");
                        line_state = LS_INIT;
                        re_start = 1;
                        break;
                    }
                }
                if (g_bDebug)
                    WriteLog("清除通訊埠資料...");
                if (PurgeComm(g_hCom, PURGE_TXCLEAR|PURGE_RXCLEAR) == FALSE) {
                    dwError = GetLastError();
                    ClearCommError(g_hCom, &dwErrorFlag, &cs);
                    WriteLog("PurgeComm() failed, code %ld, flag %ld", dwError, dwErrorFlag);
                    continue;
                }
                WriteLog("傳送 EOT SOH...");
                buf[0] = EOT;
                buf[1] = SOH;
                buf[2] = '\0';
                SendChar(g_hCom, buf, 2);
                FlushFileBuffers(g_hCom);
/*
                buf[0] = '\0';
                ReadDataFromComm(&dwLen, buf);
                if (g_bDebug) {
                    WriteLog("資料長度: %d", dwLen);
                    DumpErrorData(dwLen, buf);
                }
                if (dwLen == 0 || buf[0] != ACK)
                    continue;
                WriteLog("接收到 ACK");
                if (g_bDebug)
                    WriteLog("清除通訊埠資料...");
                if (PurgeComm(g_hCom, PURGE_TXCLEAR|PURGE_RXCLEAR) == FALSE) {
                    dwError = GetLastError();
                    ClearCommError(g_hCom, &dwErrorFlag, &cs);
                    WriteLog("PurgeComm() failed, code %ld, flag %ld", dwError, dwErrorFlag);
                    continue;
                }
*/
                strcpy(buf, "[00,800,01]99");
                WriteLog("傳送 %s...", buf);
                SendChar(g_hCom, buf, strlen(buf));
                buf[0] = '\0';
                ReadDataFromComm(&dwLen, buf);
                if (g_bDebug) {
                    WriteLog("資料長度: %d", dwLen);
                    DumpErrorData(dwLen, buf);
                }
                if (dwLen == 0 || buf[0] != ACK)
                    continue;
                WriteLog("接收到 ACK");
                break;
            }
            if (g_bQuit)
                break;
            if (re_start)
                continue;
            WriteLog("傳送 EOT...");
            buf[0] = EOT;
            buf[1] = '\0';
            SendChar(g_hCom, buf, 1);
            FlushFileBuffers(g_hCom);
            buf[0] = '\0';
            WriteLog("啟動連線完成.");
            line_state = LS_FREE;
        }

        g_bUpload = FALSE;
        re_start = 0;
        while (1) {
            WriteLog("等待接收連線資料...");
            if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
                g_bQuit = TRUE;
                break;
            }
            if (g_bCheckOnline) {
                if (g_bDebug)
                    WriteLog("檢查通訊埠狀態...");
                if (GetCommModemStatus(g_hCom, &dwStatus) == FALSE) {
                    dwError = GetLastError();
                    ClearCommError(g_hCom, &dwErrorFlag, &cs);
                    WriteLog("GetCommModemStatus() failed, code %ld, flag %ld", dwError, dwErrorFlag);
                    line_state = LS_INIT;
                    re_start = 1;
                    break;
                }
                if ((dwStatus & MS_CTS_ON) == 0) {
                    WriteLog("線路未連接, 請檢查線路...");
                    line_state = LS_INIT;
                    re_start = 1;
                    break;
                }
            }
            if (ReadDataFromComm(&dwLen, buf) > 0)
		break;
            if (line_state == LS_UPLOAD)
                continue;
            // Send data to CX
            SendDataToLX_20();
            if (g_bUpload) {
                g_bUpload = FALSE;
                buf[0] = EOT;
                buf[1] = SOH;
                dwLen = 2;
                break;
            }
        }
        if (g_bQuit)
            break;
        if (re_start)
            continue;

        if (g_bDebug) {
            WriteLog("資料長度: %d", dwLen);
            DumpErrorData(dwLen, buf);
        }

        if (buf[0] == EOT && buf[1] == SOH) {
            WriteLog("收到 EOT SOH, 傳送 ACK...");
            buf[0] = ACK;
            buf[1] = '\0';
            SendChar(g_hCom, buf, 1);
            FlushFileBuffers(g_hCom);
            buf[0] = '\0';
            line_state = LS_UPLOAD;
        }

        if (line_state != LS_UPLOAD) {
            if (buf[0] == '[') {
                WriteLog("未收到 EOT SOH [%s], 傳送 NAK...", buf);
                buf[0] = NAK;
                buf[1] = '\0';
                SendChar(g_hCom, buf, 1);  // missing EOT/SOH
                FlushFileBuffers(g_hCom);
                buf[0] = '\0';
                line_state = LS_UPLOAD;
            }
            else if (buf[0] == ENQ) {
                WriteLog("收到 ENQ, 傳送 NAK...");
                buf[0] = NAK;
                buf[1] = '\0';
                SendChar(g_hCom, buf, 1);  // missing EOT/SOH
                FlushFileBuffers(g_hCom);
                line_state = LS_INIT;
                continue;
            }
        }

        if (line_state == LS_UPLOAD) {
            // Get data CX
            GetDataFromLX_20();
            line_state = LS_FREE;
            continue;
        }
        line_state = LS_INIT;
    }

    return 0;
}
