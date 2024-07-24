#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <assert.h>
#include "rotem.h"
#include "cdecode.h"

/* arbitrary buffer size */
#define SIZE 100

void GetData(void)
{
    int nCount = 0;

    char output[1];
    char buf[1024];
	char outfname[260];
	char tmpfname[260];
	char imgfname[260];

	char	server_reply[250];
    int		recv_size;
	char	function;
	char	sid[20];
	char	DateTime[15];
	char	test[552];
	char	tmptest[30];
	char	unit[10];
	char	result[22];
    FILE	*out;
	char	*packet;
    char	token[260];
	char	*p, *q;
	char	*frame;
	char	*tmp;
	char	sidlist[140];
	int		seq;
	FILE*   imgFile;
	
	time_t t;
    struct tm *tp;

	int size = SIZE;
	/* set up a destination buffer large enough to hold the decoded data */
	char* decoded = (char*)malloc(1*size); /* ~3/4 x encoded */
	/* we need an encoder and decoder state */
	base64_decodestate ds;
	/* store the number of bytes encoded by a single call */
	int cnt;

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
		frame++;	

		function = *packet;

		if (strlen(packet) > 1024) {

			if (g_bDebug) {
 				WriteLog("packet too long to process(%d)", strlen(packet));
				DumpErrorData(strlen(packet), packet);
			}

			if ((function == 'R') && (g_bImg)) {
				sprintf(imgfname, "%s%s.jpeg", g_szTempPath, sid);
				imgFile = fopen(imgfname, "wb");

				ParseDelimiter(packet, 4, '|', tmp);

				p = strstr(tmp, "\\X0A\\");

		/*---------- START DECODING ----------*/
		/* initialise the encoder state */
				base64_init_decodestate(&ds);
				
				while (p) {
					cnt = p - tmp;

					memcpy(buf, tmp, cnt);
					buf[cnt] = '\0';

					if (g_bDebug)
						WriteLog("DEBUG IMG(%d): %s", cnt, buf);

					base64_decode_block(buf, cnt, decoded, &ds);
			/* output the encoded bytes to the output file */
					fwrite(decoded, sizeof(char), cnt, imgFile);
					
					tmp = p + 5;
                
					p = strstr(tmp, "\\X0A\\");
				}

				cnt = strlen(tmp);

				if (g_bDebug)
					WriteLog("DEBUG IMG(%d): %s", cnt, tmp);

				base64_decode_block(buf, cnt, decoded, &ds);
			/* output the encoded bytes to the output file */
				fwrite(decoded, sizeof(char), cnt, imgFile);
				
				free(decoded);
				fclose(imgFile);
			}
		
			continue;
		}
		
		WriteLog("PACKET: %s", packet);

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
			ParseDelimiter(packet, 3, '|', buf);
			ParseDelimiter(buf, 2, '^', sid);
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

//Result
		if (function == 'R') {

			if (sid[0] != '\0') {
				ParseDelimiter(packet, 4, '|', result);
				ParseDelimiter(packet, 5, '|', unit);

				ParseDelimiter(packet, 3, '|', token);
				ParseDelimiter(token, 4, '^', tmptest);

				ConvertRCode(g_szCodeFile, tmptest, test);

				TrimSpace(test);
				TrimSpace(unit);
				TrimSpace(result);

				//sprintf(buf, "%s%c|%s\n", test, unit[0], result);
				sprintf(buf, "%s|%s\n", test, result);
				WriteLog("Result: %s", buf);

				WriteLog("Save to %s", tmpfname);
				out = fopen(tmpfname, "a+");
				if (out == NULL)
					WriteLog("Cannot open file: %s", tmpfname);
				else {
					fwrite(buf, strlen(buf), sizeof(char), out);
					fclose(out);
				}

/*
				WriteLog("Save to %s", outfname);
				out = fopen(outfname, "a+");
				if (out == NULL)
					WriteLog("Cannot open file: %s", outfname);
				else {
					fwrite(buf, strlen(buf), sizeof(char), out);
					fclose(out);
				}
*/
			}
		}           

//Comment
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
/*
				WriteLog("Save to %s", outfname);
				out = fopen(outfname, "a+");
				if (out == NULL)
					WriteLog("Cannot open file: %s", outfname);
				else {
					fwrite(buf, strlen(buf), sizeof(char), out);
					fclose(out);
				}
*/
			}
		}


//End of transmission						
		if (function == 'L') {
			if (strlen(tmpfname) != 0) {
				WriteLog("Moving file from %s to %s", tmpfname, outfname);
				CopyFile(tmpfname, outfname, FALSE);	
				DeleteFile(tmpfname);
				Sleep(1000);
			}
		}

	}
	
}