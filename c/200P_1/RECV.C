#include <stdio.h>
#include <time.h>
#include "200p_1.h"

int CheckSum(char *buf)
{
    char tmp[3], sum[3];
    unsigned int checksum;
    char *p, *q;

    //WriteLog("檢核資料是否正確...");
    checksum = 0;
    p = strrchr(buf, ETX);
    if (p == NULL) {
		WriteLog("Packet error!");
		return 0;
    }
    *p = '\0';
    strcpy(tmp, p-2);
    *(p-2) = '\0';
    q = buf;
    while (*q != '\0') {
	if (*q != STX)
	    checksum += *q;
	q++;
    }
    checksum &= 0x00ff;
    sprintf(sum, "%02X", checksum);
    if (strcmp(sum, tmp) == 0) {
		//WriteLog("資料檢核碼正確!");
		return 1;
    }
		WriteLog("Checksum error");
    return 0;
}

int RecvProc(void)
{
    DWORD	    i, dwLen;
    char	    buf[1024];
    char	    str[1024];
    FILE	    *fp;
    char	    fname[260];
    char	    *p;
    int 	    found;
    char	    szData[1024];
    int 	    nCount = 0;
    DWORD	    dwStatus;
    COMSTAT	    cs;
    DWORD	    dwError, dwErrorFlag;

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

	szData[0] = 0;
	nCount = 0;
	found = 0;
	buf[0] = DC1;
	buf[1] = '\0';
	SendChar(g_hCom, buf, 1);
	FlushFileBuffers(g_hCom);

	while (1) {
	    if (ReadDataFromComm(&dwLen, buf) == 0)
		break;
	    memcpy(&szData[nCount], buf, dwLen);
	    if (g_bDebug) {
		WriteLog("length: %d", dwLen);
		DumpErrorData(dwLen, buf);
	    }
	    nCount += dwLen;
	    for (i = 0; i < dwLen; i++) {
			if (buf[i] == ETX) {
				found = 1;
				break;
			}
	    }
	    if (found == 1) break;
	}
	if (found == 0) continue;

        memcpy(str, szData, nCount);
	if (CheckSum(szData) == 0) {
            DumpErrorData(nCount, str);
            buf[0] = NAK;
            buf[1] = '\0';
            SendChar(g_hCom, buf, 1);
            FlushFileBuffers(g_hCom);
            continue;
	}
	sprintf(fname, "%s%lx.dat", g_szTempPath, GetTickCount());
	fp = fopen(fname, "ab");
	if (fp == NULL) {
	    WriteLog("Cannot open file: %s", fname);
            buf[0] = NAK;
            buf[1] = '\0';
            SendChar(g_hCom, buf, 1);
            FlushFileBuffers(g_hCom);
            continue;
	}
	p = szData;
	while (*p == STX || *p == CR || *p == LF) p++;
	fwrite(p, strlen(p), 1, fp);
	fclose(fp);
	WriteLog("Save to temp file: %s", fname);
	PurgeComm(g_hCom, PURGE_TXCLEAR);
	buf[0] = ACK;
	buf[1] = '\0';
	SendChar(g_hCom, buf, 1);
	FlushFileBuffers(g_hCom);
	ProcessDataFile(fname);
    }

    return 0;
}
