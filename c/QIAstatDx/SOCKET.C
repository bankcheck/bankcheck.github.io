#include <stdio.h>
#include <time.h>
#include "QIAstatDx.h"

int SendLine(int no,  char *buf) {
	char	message[1027];
	int		retry;

	strcpy(message, buf);
				
	retry = 0;
	while (retry < g_nMaxRetry) {
		if (retry > 0)
			WriteLog ("%d:%s Retry %d", no, g_Client[no].ip, retry);

		if( send(g_Client[no].s , message , strlen(message) , 0) < 0)	{
			WriteLog ("%d:%s SEND failed: %s", no, g_Client[no].ip, message);
			
			if (g_bDebug)
				DumpErrorData(strlen(message), message);
			
			if (g_dwSleep > 0)
				Sleep(g_dwSleep);

		} else {
			if (strlen(message) == 1) {
				if (*message == ENQ)
					WriteLog ("%d:%s SEND ENQ", no, g_Client[no].ip);
				else if (*message == ACK)
					WriteLog ("%d:%s SEND ACK", no, g_Client[no].ip);
				else if (*message == NAK)
					WriteLog ("%d:%s SEND NAK", no, g_Client[no].ip);
				else if (*message == EOT)
					WriteLog ("%d:%s SEND EOT", no, g_Client[no].ip);
				else
					WriteLog ("%d:%s SEND: %s", no, g_Client[no].ip, message);
			} else {
			
				if (g_bDebug)
					DumpErrorData(strlen(message), message);

				WriteLog ("%d:%s SEND: %s", no, g_Client[no].ip, message);
			}
			return 0;
		}	
		
		retry++;
	}
	
	//close_client(no);

	return 1;
}

void sendACK(int no, char* cntl_no) {
	char buf[4000];

	time_t t;
    struct tm *tp;

	char	DateTime[15];

	time(&t);
	tp = localtime(&t);
	
	if (tp != NULL) {
		sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
			tp->tm_hour, tp->tm_min, tp->tm_sec);
	}

	sprintf(buf, "%cMSH|^~\\&|hkah||QIAstatDx||%s||ACK^R22^ACK|%s|P|2.5||||||UNICODE UTF-8%cMSA|AA|%s%c%c%c", VT, DateTime, cntl_no, CR, cntl_no, CR, FS, CR);
	SendLine(no, buf);
}

void close_client(int no) {	
	char	tmpname[260];

	if (g_Client[no].s  != SOCKET_ERROR) {
		closesocket(g_Client[no].s);
		g_Client[no].s = SOCKET_ERROR;
		WriteLog("%d:%s closed", no, g_Client[no].ip);
	}

	sprintf(tmpname, "%sbuffer%d", g_szTempPath, no);
	DeleteFile(tmpname);
}