#include <stdio.h>
#include <string.h>
#include <time.h>
#include "infrecv.h"

void GetData(void)
{
    int nCount = 0;

    char message[4096];
    char buf[1024];
	char fname[260];

	char	server_reply[2000];
    int		recv_size;
	char	function;
	char	sid[12];
	char	DateTime[15];
	char	test[30];
	char	result[22];
    FILE	*out;
//    char	tmpbuf[260];
	char	*packet;
	char	*q;
	char	flagcode[18];
	char	flag[10];

	char	tmpresult[15];
	char	tmptest[30];

    char	token[260];
	char	*end;
//	char	*inst;
//	time_t t;
//  struct tm *tp;

	while(1) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;

		if ((recv_size = recv(g_Client.s, server_reply, 2000, 0)) != SOCKET_ERROR) {
			
			if (recv_size == 0) {
				disconnect(&g_Client);
				break;
			}

			if (server_reply[0] == EOT) {
				WriteLog("RECV EOT");
				break;
			}

			server_reply[recv_size] = '\0';

//Send ACK
			WriteLog("RECV: %s", server_reply);

			sprintf(message, "%c\0", ACK);
			SendLine(&g_Client, message);

			if (strlen(server_reply) > 1) {
				function = server_reply[2];
				packet = server_reply;
				end = strchr(packet, CR);
				*end = '\0';

	//H information
				if (function == 'H') {
					ParseDelimiter(packet, 14, '|', DateTime);
					DateTime[14] = '\0';
				}	

	//sample information
				if (function == 'O') {
					ParseDelimiter(packet, 3, '|', sid);
					TrimSpace(sid);
					strtok(sid, "\"*/:<>?\\|");
				}	

	//Result
				if (function == 'R') {
					if (sid[0] != '\0') {
						ParseDelimiter(packet, 9, '|', token);
						if (strcmp(token, "F") == 0) {
							ParseDelimiter(packet, 4, '|', tmpresult);
							ParseDelimiter(packet, 7, '|', flagcode);
					
							q = strrchr(tmpresult, '^');
				
							if (q != NULL) {
								q++;
								strcpy(tmpresult, q);
							}
							
							if (ConvertCode(g_szFlagFile, flagcode, flag))
								sprintf(result, "%s\\%s\0", tmpresult, flag);
							else
								strcpy(result, tmpresult);

							ParseDelimiter(packet, 3, '|', token);
							ParseDelimiter(token, 4, '^', tmptest);
							strtok(tmptest, "//");
							TrimSpace(tmptest);
							ConvertCode(g_szCodeFile, tmptest, test);

							TrimSpace(result);

							sprintf(buf, "%s|%s\n", test, result);
							WriteLog("Result: %s", buf);
						
							ParseDelimiter(packet, 14, '|', token);	

							sprintf(fname, "%s%s\\%s_%s", g_szOutBoxPath, token, sid, DateTime);

							WriteLog("Save to %s", fname);

							out = fopen(fname, "a+");

							if (out == NULL) {
								WriteLog("Cannot open file: %s", fname);
							} else {
								fwrite(buf, strlen(buf), sizeof(char), out);
								fclose(out);
							}
						}
					}
				}

	/*End of transmission						
				if (function == 'L') {
					break;
				}
	*/
			}
		} else {

			if (g_dwSleep != 0)
				Sleep(g_dwSleep);
						
			disconnect(&g_Client);
			if (ConnectServer(&g_Client) == 1) {
				WriteLog ("Fail to connect server");
				break;
			}

		}
	}
}