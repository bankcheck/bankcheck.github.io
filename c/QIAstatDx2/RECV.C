#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "QIAstatDx2.h"

DWORD RecvThreadProc(LPVOID pParm)
{
    char	buf[1024];
    int		no;
	char	client_message[2000];
    int		recv_size;
	int		i, j;
	long	refid;
	char	cntl_id[23];
	BOOL	bLast;

	char	fname[260];
/*
	char	line[1024];	
	char	header[3];
	FILE	*writefp;
	FILE    *readfp;
*/

_TRY_EXCEPTION_BLOCK_BEGIN()

    no = (int)pParm;
	WriteLog("%d:Thread %d Started", no, g_Client[no].dThreadID);

	sprintf(fname, "%sbuffer%d", g_szTempPath, no);
	bLast = 0;
	memset(cntl_id, '\0', 23);

	while(1) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;

		if (g_Client[no].s != SOCKET_ERROR) {
		
//get response
			while ((recv_size = recv(g_Client[no].s, client_message, 2000, 0)) != SOCKET_ERROR) {

				if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
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
						memset(cntl_id, '\0', 23);

					} else if (client_message[i] == CR) {

						if (buf[j - 1] == FS) {
							buf[j - 1] = '\0';
							bLast = 1;
						} else {
							buf[j] = '\0';
							bLast = 0;
						}

						if (strlen(buf) > 0 ) {							
							
							WriteLog("%d:%s RECV: %s", no, g_Client[no].ip, buf);							
							refid = insert_msg(no, buf);
/*
							strncpy(header, buf, 3);

							if (strncmp(header, "MSH", 3) == 0) {
								ParseDelimiter(buf, 10, '|', cntl_id);
							}

							writefp = fopen(fname, "at");
							if (writefp == NULL) {
								WriteLog("%d:Cannot open file: %s", no, fname);
							} else {
								sprintf(line, "%s\n", buf);
								fwrite(line, strlen(line), sizeof(char), writefp);
							}

							fclose(writefp);
*/
						}

						j = 0;
						memset(buf, '\0', 1024);
					} else {
						buf[j++] = client_message[i];
					}

				}
			} 

			if (bLast) {
				if (refid > 0)
					reply(refid, no);

				bLast = 0;
/*
				sendACK(no, cntl_id);	
				readfp = fopen(fname, "rt");
				
				WriteLog("%d:%s Import to db", no, g_Client[no].ip);
				while (fgets(line, 1024, readfp) != NULL) {
					line[strlen(line) - 1] = '\0';
					refid = insert_msg(no, line);
				}
				WriteLog("%d:%s Import completed", no, g_Client[no].ip);

				fclose(readfp);
				DeleteFile(fname);
*/
			}	

		}
	}

	WriteLog("%d:Thread Exit", no);

    ExitThread(0);

_TRY_EXCEPTION_BLOCK_END(1)

    return 1;
}
