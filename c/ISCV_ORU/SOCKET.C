#include <stdio.h>
#include <time.h>
#include "ISCV_ORU.h"

int SendLine(int no,  char *buf) {
	char	message[1027];
	int		retry;

	strcpy(message, buf);
				
	retry = 0;
	while (retry < g_nMaxRetry) {
		if (retry > 0)
			WriteLog ("%d:%s Retry %d", no, g_client[no].ip, retry);

		if( send(g_client[no].s , message , strlen(message) , 0) < 0)	{
			WriteLog ("%d:%s SEND failed: %s", no, g_client[no].ip, message);
			
			if (g_bDebug)
				DumpErrorData(strlen(message), message);
			
			if (g_dwSleep > 0)
				Sleep(g_dwSleep);

		} else {
			if (strlen(message) == 1) {
				if (*message == ENQ)
					WriteLog ("%d:%s SEND ENQ", no, g_client[no].ip);
				else if (*message == ACK)
					WriteLog ("%d:%s SEND ACK", no, g_client[no].ip);
				else if (*message == NAK)
					WriteLog ("%d:%s SEND NAK", no, g_client[no].ip);
				else if (*message == EOT)
					WriteLog ("%d:%s SEND EOT", no, g_client[no].ip);
				else
					WriteLog ("%d:%s SEND: %s", no, g_client[no].ip, message);
			} else {
			
				if (g_bDebug)
					DumpErrorData(strlen(message), message);

				WriteLog ("%d:%s SEND: %s", no, g_client[no].ip, message);
			}
			return 0;
		}	
		
		retry++;
	}
	
	//close_client(no);
	WriteLog ("%d:%s SEND (FAIL):%s", no, g_client[no].ip, message);
	return 1;
}

void sendACK(int no) {
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

	sprintf(buf, "%cMSH|^~\\&|ISCV|HK|HKAH|HK|%s||ACK^O01|%d|P|2.3.1%c\0", VT, DateTime, g_nCntlNo++, CR);
	SendLine(no, buf);
	sprintf(buf, "MSA|AA|%c%c%c\0", CR, FS, CR);
	SendLine(no, buf);
}

void close_client(int no) {
	if (g_client[no].s  != SOCKET_ERROR) {
		closesocket(g_client[no].s);
		g_client[no].s = SOCKET_ERROR;
		WriteLog("%d:%s closed", no, g_client[no].ip);
	}
}