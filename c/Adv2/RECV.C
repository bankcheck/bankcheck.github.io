#include <stdio.h>
#include <time.h>
#include "adv2.h"

int RecvProc(void)
{
    //DWORD       dwLen;
    //char	    buf[4096];
    //char	    cmd[20];
    //char	    tmpbuf[20];

    int 	    nCount = 0;
    DWORD	    dwStatus;
    COMSTAT	    cs;
    DWORD	    dwError, dwErrorFlag;
    int         re_start;
	//DWORD			i;
	//int			found;

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
                WriteLog("Open Port...");

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

        }

        if (g_bCheckOnline) {
            if (g_bDebug)
                WriteLog("Checking Port Status...");
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
			WriteLog("Clear port data...");

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
            //if (ReadDataFromComm(&dwLen, buf) > 0)
			//	break;

			while (1) {
		        if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
					g_bQuit = TRUE;
				    break;
				}
				
				init();
				GetData();
			}

			/*sprintf (cmd, "%c0I %c%c^%c\0", STX, CR, LF, ETX);

			//if (SendPacket(cmd) == 0)
			//	break;
			
			SendChar(g_hCom, cmd, strlen(cmd));
			FlushFileBuffers(g_hCom);

			WriteLog("Send: %s", cmd);

			for (i=0;i<4;i++) {
				if (ReadDataFromComm(&dwLen, buf) > 0)
					break;
				if (g_bQuit)
					break;
			}
			if (dwLen > 0) {
				break;
			}*/
        }

        if (g_bQuit)
            break;

        if (re_start)
            continue;

		/*if (buf[0] == '0') {
			WriteLog("接收: 0");
			sprintf (tmpbuf, "%cS          %c%c\0", GetMT(), CR, LF);
			sprintf (cmd, "%c%s%c%c\0", STX, tmpbuf, GetCheckSum(tmpbuf), ETX);
		
			if (SendPacket(cmd, 17) == 1)
				break;
		}
		else if (buf[0] == STX){
			g_MT = buf[1];
			strcpy(tmpbuf, buf);
			nCount = dwLen;

		    while (1) {
				while (1) {
					if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
						g_bQuit = TRUE;
						break;
					}
            
					if (ReadDataFromComm(&dwLen, buf) > 0)
						break;
				}

				if (g_bQuit) break;

				memcpy(&tmpbuf[nCount], buf, dwLen);
				nCount += dwLen;

				found = 0;
				
				for (i = 0; i < dwLen; i++) {
					if (buf[i] == ETX) {
						found = 1;
					}
				}

				if (found) break;
			}

			tmpbuf[nCount] = '\0';
			WriteLog("接收: %s", tmpbuf);

			cmd[0] = g_MT;
			SendChar(g_hCom, cmd, 1);
			FlushFileBuffers(g_hCom);

			WriteLog("Send MT: %c", cmd[0]);
			if (tmpbuf[1] == 'S') {
				sprintf (tmpbuf, "%cS          %c%c\0", GetMT(), CR, LF);
				sprintf (cmd, "%c%s%c%c\0", STX, tmpbuf, GetCheckSum(tmpbuf), ETX);
		
				if (SendPacket(cmd, 17) == 1)
					break;
			}
			else {
				sprintf (cmd, "%c\0", NAK);
				SendChar(g_hCom, cmd, 1);
				FlushFileBuffers(g_hCom);
				WriteLog("Send NAK");
			}
		}
		else if (buf[0] == NAK) {
			continue;
		}
		else {
			WriteLog("接收 ??: %c%c", buf[0], buf[1]);
			sprintf (cmd, "%c\0", NAK);
			SendChar(g_hCom, cmd, 1);
			FlushFileBuffers(g_hCom);
			WriteLog("Send NAK");
		}

		while (1) {
			GetData();

			sprintf (tmpbuf, "%cS          %c%c\0", GetMT(), CR, LF);
			sprintf (cmd, "%c%s%c%c\0", STX, tmpbuf, GetCheckSum(tmpbuf), ETX);
		
			if (SendPacket(cmd, 17) == 1)
				break;
		}*/
    }

    return 0;
}
