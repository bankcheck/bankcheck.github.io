#include <stdio.h>
#include <string.h>
#include <time.h>
#include "Advia.h"

unsigned char GetCheckSum(char *buf)
{
    unsigned char chksum;

    chksum = 0;
    while (1) {
        if (*buf == '\0') break;
		
		chksum = chksum^*buf;
        buf++;
    }
	if (chksum == ETX)
		chksum = 127;
    return chksum;
}

unsigned char GetMT(void)
{
    unsigned char MT;

    MT = g_MT + 1;
	
	if (MT > 90)
		MT = '0';

    return MT;
}

int SendPacket(char *buf, int len)
{
//	char		cmd[4096];
//    DWORD       dwLen;
	DWORD           dwStatus;
    COMSTAT         cs;
    DWORD           dwError, dwErrorFlag;
	int		NAKCount;
	
//	clock_t start, end;

	NAKCount = 0;

    if (g_bDebug)
		WriteLog("Checking Port Status...");

    if (GetCommModemStatus(g_hCom, &dwStatus) == FALSE) {
		dwError = GetLastError();
        ClearCommError(g_hCom, &dwErrorFlag, &cs);
        WriteLog("GetCommModemStatus() failed, code %ld, flag %ld", dwError, dwErrorFlag);
        return 1;
    }

/*    if ((dwStatus & MS_CTS_ON) == 0) {
		WriteLog("線路未連接, 請檢查線路...");
		return 1;
	}*/

	//while (1) {


		WriteLog("Send: %s", buf);
		SendChar(g_hCom, buf, len);
		FlushFileBuffers(g_hCom);

/*		if (len <= 1)
			break;

		ReceivePacket(cmd);
	
		if (cmd[0] == NAK) {
			NAKCount ++;
			Sleep (5000);
		}
		else {
			break;
		}

		if (NAKCount >= 2)
			init();
	}*/

	//while (ReadDataFromComm(&dwLen, cmd) > 0)
	//	Sleep(100);
	


		//Sleep(1000);
		
		/*if (NAKCount > 0) return 1;

		dwLen = 0;
		cmd[0] = '\0';
		
		start = clock();
		while (1) {
			if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
				g_bQuit = TRUE;
				break;
			}

			if (ReadDataFromComm(&dwLen, cmd) > 0) break;

			end = clock();
			if (((double)(end - start)) > 5000) break;

			Sleep(1000);
		} 
        //DumpErrorData(dwLen, cmd);

		if (g_bQuit) return 1;
              
		if (cmd[0] == GetMT()) {
			WriteLog("接收 MT: %c", cmd[0]);
			break;
		}
		else if ((cmd[0] == NAK) && (NAKCount == 0)){
			WriteLog("接收 NAK");
			//return 1;
			NAKCount++;
			Sleep(1000);
		}
		else if (dwLen > 0) {
			//cmd[dwLen] = '\0';
			WriteLog("incorrect MT %c", cmd[0]);
			return 1;
		}
		else{
			/*cmd[dwLen] = '\0';
			WriteLog("接收 ?? %s", cmd);
			WriteLog("Length: %d", dwLen);
			WriteLog("No MT");
			return 1;
		}
	}*/		        
	return 0;
}