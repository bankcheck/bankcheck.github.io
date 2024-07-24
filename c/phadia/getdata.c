#include <stdio.h>
#include <string.h>
#include <time.h>
#include "phadia.h"

void GetData(void)
{
    int nCount = 0;

    char message[4096];
    char buf[1024];
	char outfname[260];
	char tmpfname[260];

	char	server_reply[2000];
    int		recv_size;
	char	function;
	char	sid[12];
	char	DateTime[15];
	char	test[30];
	char	method[6];
	char	result[22];
	char	tmpResult[22];
    FILE	*out;
//    char	tmpbuf[260];
	char	*packet;
//	char	*q;
//	char	flagcode[5];
//	char	flag[10];
//	char	tmpresult[15];
    char	token[260];
	char	*end;
//	char	*inst;
	time_t t;
	struct tm *tp;

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

/*
			if (server_reply[0] == EOT) {
				WriteLog("RECV EOT");

				if (server_reply[1] == ENQ) {
					WriteLog("RECV ENQ");					
//Send ACK
					sprintf(message, "%c\0", ACK);
					SendLine(&g_Client, message);
					continue;
				} else
					break;
			}
*/

			server_reply[recv_size] = '\0';

//Send ACK
			WriteLog("RECV: %s", server_reply);

			sprintf(message, "%c\0", ACK);
			SendLine(&g_Client, message);
			function = server_reply[2];
			packet = server_reply;
			end = strchr(packet, CR);
			*end = '\0';

//H information
			if (function == 'H') {
				sprintf(tmpfname, "\0");
				sprintf(outfname, "\0");
				time(&t);
				tp = localtime(&t);
				if (tp != NULL) {
					sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
					tp->tm_hour, tp->tm_min, tp->tm_sec);
				}
			}

//sample information
			if (function == 'O') {
				ParseDelimiter(packet, 4, '|', sid);
				TrimSpace(sid);
				strtok(sid, "\"*/:<>?\\|^");

				//ParseDelimiter(packet, 8, '|', DateTime);
				//DateTime[14] = '\0';

				sprintf(tmpfname, "%s%s_%s", g_szTempPath, sid, DateTime);
				sprintf(outfname, "%s%s_%s", g_szOutBoxPath, sid, DateTime);
			}
			
			if (function == 'Q') {
				SendFolder();
			}

//Result                            
			if (function == 'R') {
				if (sid[0] != '\0') {

					ParseDelimiter(packet, 3, '|', token);
					ParseDelimiter(token, 4, '^', test);
					ParseDelimiter(token, 5, '^', method);
					strtok(test, "//");

					ParseDelimiter(packet, 4, '|', tmpResult);
					
					if (tmpResult[0] != '^') {
						strtok(tmpResult, "^");
					
						TrimSpace(test);
						TrimSpace(tmpResult);

						ConvertCode(g_szCodeFile, tmpResult, result);

						sprintf(buf, "%s^%s|%s\n", test, method, result);
						WriteLog("Result: %s", buf);

						WriteLog("Save to %s", tmpfname);
						out = fopen(tmpfname, "a");

						if (out == NULL) {
							WriteLog("Cannot open file: %s", tmpfname);
						} else {
							fwrite(buf, strlen(buf), sizeof(char), out);
							fclose(out);
						}
					
					}
				}
			}

//End of transmission						
			if (function == 'L') {

				if (strlen(tmpfname) != 0) {
					WriteLog("Moving file from %s to %s", tmpfname, outfname);
					CopyFile(tmpfname, outfname, FALSE);	
					DeleteFile(tmpfname);
				}

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