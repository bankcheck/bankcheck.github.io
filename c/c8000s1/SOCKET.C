#include <stdio.h>
#include "c8000s1.h"

int SendLine(int no,  char *buf) {
	char	message[1027];
	int		retry;

	strcpy(message, buf);
				
	retry = 0;
	while (retry < g_nMaxRetry) {

		if( send(g_client[no].s , message , strlen(message) , 0) < 0)	{
			WriteLog ("%d:%s SEND failed: %s", no, g_client[no].ip, message);
			
			if (g_dwSleep != 0)
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

	return 1;
};

void close_client(int no) {
	char fname[260];
	if (g_client[no].ip != NULL) {
		closesocket(g_client[no].s);
		g_client[no].s = SOCKET_ERROR;
		WriteLog("%d:%s closed", no, g_client[no].ip);
	}
	sprintf(fname, "%sbuf%d.dat", g_szTempPath, no);
	DeleteFile(fname);
}
