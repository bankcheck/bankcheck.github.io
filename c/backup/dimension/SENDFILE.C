#include <stdio.h>
#include <string.h>
#include <time.h>
#include "Dimension.h"

int SendPacket(char *buf)
{
	char	cmd[260];

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

    /*if ((dwStatus & MS_CTS_ON) == 0) {
		WriteLog("線路未連接, 請檢查線路...");
		return 1;
	}*/

    WriteLog("Send: %s", buf);
    SendChar(g_hCom, buf, strlen(buf));
    FlushFileBuffers(g_hCom);

	/*dwLen = 0;
    while (1) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
			g_bQuit = TRUE;
            break;
        }
        if (ReadDataFromComm(&dwLen, cmd) > 0)
            break;
    }

	if (g_bQuit) return 1;*/
    
	ReceivePacket(cmd);
            
	if (cmd[0] == ACK) {
		return 1;
	}
	else if (cmd[0] == NAK) {
		WriteLog("Receive NAK");
		Sleep(1000);
	}
	else if (cmd[0] == ENQ) {
		WriteLog("Receive ENQ");
		WriteLog("Resend %s", buf);
		SendChar(g_hCom, buf, strlen(buf));
		FlushFileBuffers(g_hCom);
	}
	else{
		WriteLog("Receive Unknown Packet, send NAK");
        DumpErrorData(8, cmd);
		cmd[0] = NAK;
		cmd[1] = '\0';
		SendChar(g_hCom, cmd, 1);
		FlushFileBuffers(g_hCom);
	}
				        
	return 0;
}

int SendFile(char *fname)
{
    char buf[1024];

    WriteLog("Processing %s", fname);
    if (ConvertDimensionCode(fname, buf) == 0)
        return 0;
	
	if (SendPacket(buf)) {
		strcpy(g_buffer, buf);
		strcpy(g_fname, fname);
    } else {
		char bakname[260];
		time_t t;
		struct tm *tp;
		char *name;
		char DateTime[14];

		time(&t);
		tp = localtime(&t);
		if (tp != NULL) {

			sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
					tp->tm_hour, tp->tm_min, tp->tm_sec);

			name = strrchr(fname, '_');
			
			sprintf(bakname, "%s%s%s\0", g_szInBoxPath, DateTime, name);

			WriteLog("Moving file from %s to %s", fname, bakname);
			CopyFile(fname, bakname, FALSE);
		}
		DeleteFile(fname);

		g_buffer[0] = '\0';
		g_fname[0] = '\0';
	}
    return 1;
}
