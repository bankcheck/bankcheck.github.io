#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "OmnicellZPM.h"

DWORD RecvThreadProc(LPVOID pParm)
{
    char	buf[1024];
    int		no;
	char	client_message[2000];
    int		recv_size;
	int		i, j;
	BOOL	bLast;
	long refid;

	time_t t;
    struct tm *tp;
	char	DateTime[15];
	char	tmpfname[260];
	char	fname[260];
	FILE	*out;

_TRY_EXCEPTION_BLOCK_BEGIN()

    no = (int)pParm;
	WriteLog("%d:Thread %d Started", no, g_client[no].dThreadID);
	out = NULL;

	while(1) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;

		if (g_client[no].bRestart) {
			g_client[no].bRestart = FALSE;
			WriteLog("%d:Thread %d Reset", no, g_client[no].dThreadID);
		}

		if (g_client[no].s != SOCKET_ERROR) {
		
//get response
			while ((recv_size = recv(g_client[no].s, client_message, 2000, 0)) != SOCKET_ERROR) {

				if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
					break;

				if (g_client[no].bRestart)
					break;

	  			client_message[recv_size] = '\0';

				if (g_bDebug)
					DumpErrorData(recv_size, client_message);

				if (recv_size == 0) {
					break;
				}

				for (i = 0; i < recv_size; i++){

					if (client_message[i] == VT) {
						j = 0;
								
						time(&t);
						tp = localtime(&t);
						if (tp != NULL) {
							sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
								tp->tm_hour, tp->tm_min, tp->tm_sec);
						}

						sprintf(tmpfname, "%sZPM_%s_%s", g_szTempPath, g_client[no].ip, DateTime);
						sprintf(fname, "%sZPM_%s_%s", g_szOutBoxPath, g_client[no].ip, DateTime);

						if (g_bFileMode) {
							if (out == NULL) {
								WriteLog("%d:Write to file: %s", no, tmpfname);
								sprintf(tmpfname, "%s%d", g_szTempPath, no);
								out = fopen(tmpfname, "w");
								WriteLog("%d:Write to file: %s", no, tmpfname);
							}
						}

					} else if (client_message[i] == CR) {
				
						if (buf[j - 1] == FS) {
							buf[j - 1] = '\0';
							bLast = 1;
						} else {
							buf[j] = '\0';
							bLast = 0;
						}

						if (strlen(buf) > 0 ) {
							WriteLog("%d:%s RECV: %s", no, g_client[no].ip, buf);

							if (g_bDatabaseMode) {
								refid = insert_msg(no, buf);
							}
							
							if (g_bFileMode) {
								if (out == NULL) {
									WriteLog("%d:Cannot open file: %s", no, tmpfname);
								} else {
									sprintf(buf, "%s\n", buf);
									fwrite(buf, strlen(buf), sizeof(char), out);
								}
							}							
						}

						j = 0;

					} else {
						buf[j] = client_message[i];
						j++;
					}

				}

			} 

			if (bLast) {
/*
				if (refid > 0)
					reply(refid, no);
*/
				sendACK(no);
				bLast = 0;

				if (g_bFileMode) {
					fclose(out);
					out = NULL;

					MoveFile(tmpfname, fname);
					WriteLog("%d:Move from %s to %s", no, tmpfname, fname);
				}

			}
		}
	}

	WriteLog("%d:Thread Exit", no);

    ExitThread(0);

_TRY_EXCEPTION_BLOCK_END(1)

    return 1;
}
