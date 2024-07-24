#include <stdio.h>
#include "MindrayEMR.h"

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
	
	close_client(no);

	return 1;
}

void close_client(int no) {

	if (g_client[no].dThreadID > 0) {
		TerminateThread(g_client[no].hThread, 0);
		CloseHandle(g_client[no].hThread);
		WriteLog("%d:Thread %d terminated", no, g_client[no].dThreadID);
		g_client[no].dThreadID = 0;
	}
/*
	if (g_client[no].out !=NULL) {
		WriteLog("%d:Close output file", no);
		fclose(g_client[no].out);
		g_client[no].out = NULL;
	}

	if (g_client[no].in !=NULL) {
		WriteLog("%d:Close input file", no);
		fclose(g_client[no].in);
		g_client[no].in = NULL;
	}
*/
	closesocket(g_client[no].s);
	g_client[no].s = SOCKET_ERROR;

	WriteLog("%d:%s closed", no, g_client[no].ip);
	sprintf(g_client[no].ip, "\0");
}