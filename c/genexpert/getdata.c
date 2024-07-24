#include <stdio.h>
#include <string.h>
#include <time.h>
#include "GeneXpert.h"

void GetData(void)
{
    int nCount = 0;

    char output[1];
    char buf[1024];
	char outfname[260];
	char tmpfname[260];

	char	server_reply[250];
    int		recv_size;
	char	function;
	char	sid[20];
	char	DateTime[15];

	char	tmpTest[30];
	char	test[40];
	char	analyte[20];
	char	resultName[10];
	char	tmpResult[300];
	char	result[256];
	char	status;

    FILE	*out;
	char	*packet;
    char	token[260];
	char	*q;
	char	*frame;
	char	*tmp;

	time_t t;
    struct tm *tp;

	frame = malloc(sizeof(char) * g_buffer);
	*frame =  '\0';

	while(1) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;

		if ((recv_size = recv(g_Client.s, server_reply, 2000, 0)) != SOCKET_ERROR) {

			if (g_bDebug)
				DumpErrorData(recv_size, server_reply);

			if (recv_size == 0) {
				disconnect(&g_Client);
				break;
			}

			if (server_reply[0] == EOT) {
				WriteLog("RECV EOT");
				break;
			}

			server_reply[recv_size - 5] = '\0';

			tmp = server_reply;
			tmp += 2;

			strcat(frame, tmp);
			WriteLog("RECV: %s", server_reply);
//Send ACK
			sprintf(output, "%c\0", ACK);
			SendLine(&g_Client, output);
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

	while (1) {
		if ((*frame == LF) || (*frame == '\0'))
			break;

		packet = frame;
		frame = strchr(frame, CR);
		*frame = '\0';

		WriteLog("PACKET: %s", packet);
		function = *packet;

//Header information
		if (function == 'H') {
			sprintf(tmpfname, "\0");
			sprintf(outfname, "\0");
			sprintf(sid, "\0");
			
			q = strrchr(packet, '|');
			q++;
			
			//user header time
			//strcpy(DateTime, q);
			//DateTime[14] = '\0';
		}
		
//patient information
		if (function == 'O') {
			ParseDelimiter(packet, 3, '|', sid);
			strtok(sid, "\"*/:<>?\\|");

			//use local time 20181026
			time(&t);
			tp = localtime(&t);
			if (tp != NULL) {
				sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
				tp->tm_hour, tp->tm_min, tp->tm_sec);
			}
			
			if (strlen(tmpfname) != 0) {
				WriteLog("Moving file from %s to %s", tmpfname, outfname);
				CopyFile(tmpfname, outfname, FALSE);	
				DeleteFile(tmpfname);
			}

			sprintf(tmpfname, "%s%s_%s", g_szTempPath, sid, DateTime);
			sprintf(outfname, "%s%s_%s", g_szOutBoxPath, sid, DateTime);
		}
			
//Query
		/*
		if (function == 'Q') {
			
			if (*(packet + strlen(packet) - 1) != 'A') {
	
				ParseDelimiter(packet, 3, '|', sidlist);

				seq = 1;

				q = strchr(sidlist,'@');

				while (q != NULL)
				{
					*q = '\0';
					
					p = strchr(sidlist,'^');

					if (p != NULL)
						strcpy(sid, p+1);
					else
						strcpy(sid, sidlist);

					if (g_bDebug)
						WriteLog("DEBUG: sid=%s", sid);

					SendFile(seq, sid, g_bBackupInbox);
					seq++;

					strcpy(sidlist, q + 1);
					q = strchr(sidlist,'@');
				}

				p = strchr(sidlist,'^');
				if (p != NULL)
					strcpy(sid, p+1);
				else
					strcpy(sid, sidlist);

				if (g_bDebug)
					WriteLog("DEBUG: sid=%s", sid);

				if (strcmp(sid, "ALL") == 0)
					SendFolder();
				else
					SendFile(seq, sid, g_bBackupInbox);
			}
		}
		*/

//Result
		if (function == 'R') {
			if (sid[0] != '\0') {

				memset(resultName, 10, '\0');
				memset(test, 30, '\0');
				status = '\0';

				ParseDelimiter(packet, 3, '|', token);
				ParseDelimiter(token, 4, '^', tmpTest);
				ParseDelimiter(token, 7, '^', analyte);
				ParseDelimiter(token, 8, '^', resultName);

				ParseDelimiter(packet, 4, '|', tmpResult);
				
				if (tmpResult[0] == '^') {
					ParseDelimiter(tmpResult, 2, '^', result);

				} else { 
					strtok(tmpResult, "^");
					strcpy(result, tmpResult);
/*
					if (strncmp(tmpResult, "POS", 3) == 0)
						strcpy(result, g_Pos);
					else if (strncmp(tmpResult, "DET", 3) == 0)
						strcpy(result, g_Pos);

					if (strncmp(tmpResult, "NEG", 3) == 0)
						strcpy(result, g_Neg);
					else if (strncmp(tmpResult, "NOT", 3) == 0)
						strcpy(result, g_Neg);
*/
					q = strstr(tmpResult, "POS");
					if (q)
						strcpy(result, g_Pos);
					else if (strncmp(tmpResult, "DET", 3) == 0)
						strcpy(result, g_Pos);

					q = strstr(tmpResult, "NEG");
					if (q)
						strcpy(result, g_Neg);
					else if (strncmp(tmpResult, "NOT", 3) == 0)
						strcpy(result, g_Neg);
				}

				ParseDelimiter(packet, 9, '|', &status);

				if (status == 'F') {

					ConvertRCode(g_szCodeFile, tmpTest, test);
					
					sprintf(buf, "%s|%s\n", test, result);
					WriteLog("Result: %s", buf);

					WriteLog("Save to %s", tmpfname);
					out = fopen(tmpfname, "a");

					if (out == NULL) {
						WriteLog("Cannot open file: %s", tmpfname);
					} else {
						fwrite(buf, strlen(buf), sizeof(char), out);
						fclose(out);
					}

				} else if ( resultName[0] == '\0' ) {

					ConvertRCode(g_szCodeFile, analyte, test);
					
					sprintf(buf, "%s|%s\n", test, result);
					WriteLog("Result: %s", buf);

					WriteLog("Save to %s", tmpfname);
					out = fopen(tmpfname, "a");

					if (out == NULL) {
						WriteLog("Cannot open file: %s", tmpfname);
					} else {
						fwrite(buf, strlen(buf), sizeof(char), out);
						fclose(out);
					}
				
				} else if ( strcmp(resultName, "Ct") == 0 ) {

					sprintf(tmpTest, "%sCT\0", analyte);

					ConvertRCode(g_szCodeFile, tmpTest, test);
					
					sprintf(buf, "%s|%s\n", test, result);
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

//Comment
/*
		if (function == 'C') {
			if (sid[0] != '\0') {
				ParseDelimiter(packet, 4, '|', buf);
				
				ParseDelimiter(buf, 2, '^', test);

				sprintf(buf, "%s|FLAG\n", test);
				WriteLog("Result: %s", buf);

				WriteLog("Save to %s", tmpfname);
				out = fopen(tmpfname, "a+");
				if (out == NULL)
					WriteLog("Cannot open file: %s", tmpfname);
				else {
					fwrite(buf, strlen(buf), sizeof(char), out);
					fclose(out);
				}
			}
		}
*/

//End of transmission						
		if (function == 'L') {
			if (strlen(tmpfname) != 0) {
				WriteLog("Moving file from %s to %s", tmpfname, outfname);
				CopyFile(tmpfname, outfname, FALSE);	
				DeleteFile(tmpfname);
				Sleep(1000);
			}
		}

		frame++;		
	}

}