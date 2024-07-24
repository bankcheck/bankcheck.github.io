#include <stdio.h>
#include <string.h>
#include <time.h>
#include "jack.h"

int SendPacket(char *buf)
{
	DWORD           dwStatus;
    COMSTAT         cs;
    DWORD           dwError, dwErrorFlag;

    if (g_bDebug)
		WriteLog("Checking Port Status...");

    if (GetCommModemStatus(g_hCom, &dwStatus) == FALSE) {
		dwError = GetLastError();
        ClearCommError(g_hCom, &dwErrorFlag, &cs);
        WriteLog("GetCommModemStatus() failed, code %ld, flag %ld", dwError, dwErrorFlag);
        return 1;
    }

    WriteLog("Send: %s", buf);
    SendChar(g_hCom, buf, strlen(buf));
    FlushFileBuffers(g_hCom);
    				        
	return 0;
}