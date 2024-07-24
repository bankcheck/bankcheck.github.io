#include <stdio.h>
#include <string.h>
#include <time.h>
#include "infsend.h"

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
    char	tmpbuf[260];
	char	*packet;
	char	*q;
	char	flag[2];
	char	tmpresult[15];
    char	token[260];

	while(1) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;

		if ((recv_size = recv(g_Client.s, server_reply, 2000, 0)) != SOCKET_ERROR) {
			server_reply[recv_size] = '\0';
//Send ACK
			sprintf(message, "%c\0", ACK);
			SendPacket(message);

			function = server_reply[2];
			packet = server_reply;

//patient information
			if (function == 'P') {
				ParseDelimiter(packet, 3, '|', sid);
				TrimSpace(sid);
				strtok(sid, "\"*/:<>?\\|");
				ParseDelimiter(packet, 23, '|', DateTime);
				DateTime[14] = '\0';
			}	
//Result
			if (function == 'R') {
				if (sid[0] != '\0') {
					ParseDelimiter(packet, 4, '|', tmpresult);
					ParseDelimiter(packet, 7, '|', flag);
				
					q = strrchr(tmpresult, '^');
			
					if (q != NULL) {
						q++;
						strcpy(tmpresult, q);
					}

					if (strcmp(flag, "HH") == 0) {
						result[0] = '>';
						result[1] = '\0';
						strcat(result, tmpresult);
					} else if (strcmp(flag, "LL") == 0) {
						result[0] = '<';
						result[1] = '\0';
						strcat(result, tmpresult);
					} else {
						strcpy(result, tmpresult);
					}

					ParseDelimiter(packet, 3, '|', token);
					ParseDelimiter(token, 4, '^', test);
					strtok(test, "//");
				
					TrimSpace(test);
					TrimSpace(result);
					//ConvertRCode(test);

					sprintf(buf, "%s|%s\n", test, result);
					WriteLog("Result: %s", buf);

					sprintf(fname, "%s%s_%s", g_szOutBoxPath, sid, DateTime);

					if (g_bDebug)
						WriteLog("Save to %s", fname);

					out = fopen(fname, "a+");

					if (out == NULL) {
						WriteLog("Cannot open file: %s", fname);
					} else {
						fwrite(tmpbuf, strlen(buf), sizeof(char), out);
						fclose(out);
					}
				}
			}

//End of transmission						
			if (function == 'L') {
				break;
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