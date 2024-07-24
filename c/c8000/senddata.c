#include <stdio.h>
#include <string.h>
#include <time.h>
#include "c8000.h"
#define MAX_TESTS   100

typedef struct {
    char  code[10];
    int   value;
} TESTLIST;

unsigned char GetCheckSum(char *buf)
{
    unsigned char chksum;

    chksum = 0;
    while (1) {
        if (*buf == '\0') break;
        chksum += *buf;
        buf++;
    }
    return chksum;
}

int SendData(void)
{
//    WIN32_FIND_DATA data;
//    HANDLE hFind;
//    char path[260];
	char cmd[2];
	char buf[2048];
//    BOOL bFound;
//	BOOL bNotSent;
	FILE *fp;
    char OutFile[260];
	char *message;

//	int seq;
	int len;
    int recv_size;
	char server_reply[2000];
	short retry;
//	char sid[12];

//Open buffer file
	sprintf(OutFile, "%s%s.dat", g_szTempPath, "outbuffer");

	fp = fopen(OutFile, "rt");
	if (fp == NULL) {
		return 0;
	}
	
	retry = 0;

//Send ENQ;
	while(1) {
	    if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
			g_bQuit = TRUE;
		    break;
		}

		sprintf(cmd, "%c\0", ENQ);
		SendLine(&g_Client, cmd);
					
		if ((recv_size = recv(g_Client.s, server_reply, 2000, 0)) != SOCKET_ERROR) {
			server_reply[recv_size] = '\0';

			if (server_reply[0] == ACK) {
				WriteLog("RECV ACK");
				break;
			} else if (server_reply[0] == NAK) {
				WriteLog("RECV NAK");
							
				if (retry < g_nMaxRetry) {
					if (g_dwSleep != 0)
						Sleep(g_dwSleep);
					retry++;
				} else {
					break;
				}

			} else {
				WriteLog("RECV: %s", server_reply);
			}

		}

		if (g_dwSleep != 0)
			Sleep(g_dwSleep);
	}

	message = (char*)malloc(2048);
	*message = '\0';

//read buffer
	while (1) {
		if (fgets(buf, 2048, fp) == NULL) break;
		WriteLog("Read buffer: %s", buf);

		strtok(buf, "\n");
		len = strlen(buf);

		buf[len] = CR;
		buf[len + 1] = '\0';

		strcat(message, buf);
	}
	fclose(fp);

	SendBuffer(message, 1);
		
	if (g_bQuit) return 1;

    if (g_bDebug)
        WriteLog("Upload Completed.");

//Send EOT
	WriteLog("Send EOT");
	sprintf(buf, "%c\0", EOT);
	SendLine(&g_Client, buf);

	DeleteFile(OutFile);
    
	return 0;
}

void SendBuffer(char *buf, int frameNo)
{
	char *p;
	char packet[241];
	char databuf[243];
	char frame[248];

	if (frameNo > 7)
		frameNo = 0;

	if (strlen(buf) > 240) {
		strncpy(packet, buf, 240);
		packet[240] = '\0';
		
		sprintf(databuf, "%1d%s%c\0", frameNo, packet, ETB);
		
		sprintf(frame, "%c%s%02X%c%c\0", STX, databuf, GetCheckSum(databuf), CR, LF);

		if (g_bDebug)
			DumpErrorData(240, frame);
		
		SendPacket(frame);

		p = buf + 240;
		SendBuffer(p, ++frameNo);

	} else {
		strcpy(packet, buf);

		sprintf(databuf, "%1d%s%c\0", frameNo, packet, ETX);

		sprintf(frame, "%c%s%02X%c%c\0", STX, databuf, GetCheckSum(databuf), CR, LF);

		if (g_bDebug)
			DumpErrorData(240, frame);

		SendPacket(frame);
	}
}

int SendFile(int seq, char sid[12], char *pos)
{
	char bakname[260];
	char fname[260];
	char p[1024];

    sprintf(fname, "%s%s", g_szInBoxPath, sid);
	memset(p, '\0', 1024);
    
	SendC8000(fname, seq, p, pos);
	
	if (g_bBackupInbox) {
		sprintf(bakname, "%s%s\0", g_szBackupInBoxPath, sid);
		WriteLog("Move file from %s to %s", fname, bakname);
		CopyFile(fname, bakname, FALSE);

		DeleteFile(fname);
	}
	
	return 1;
}

int SendC8000(char *fname, int seq, char *order, char *pos)
{
    FILE *fp;
	FILE *fp_out;
    TESTLIST tests[MAX_TESTS];
    char buf[1024];
	char buf_out[1024];
    char test[1024];
	char OutFile[260];
    char *p;
    //char *tp;
    int i;
    char code[20];
	//char name[41];
	char fullname[260];

	char *sid;
	char priority;
	//char sample;
	char sex[2];
	char year[3];
	char month[2];
	char age[5];
	char patno[12];
	int num;

	time_t t;
    struct tm *timep;

    time(&t);
    timep = localtime(&t);

	sid = strrchr(fname, '\\');
	if (strlen(sid) > 1) {
		sid++;
	} else {
		return 0;
	}

    //WriteLog("Âà´«ÀËÅç¥N½X...");
    fp = fopen(fname, "rt");
    if (fp == NULL) {
        WriteLog("Can't open file: %s", fname);
        return 0;
    }

    if (fgets(buf, 1024, fp) == NULL){
        WriteLog("Empty file: %s", fname);
        return 0;
    }

    if (g_bDebug)
	    WriteLog("DATA: %s", buf);

//Header Info
	priority=*(strrchr(buf, '|')+1);

	ParseDelimiter(buf, 1, '|', fullname);
/*	
	ParseDelimiter(buf, 2, '|', &sample);
	if ((sample == 'S') || (sample == 'P') || (sample == 'B'))
		sample = '1';
	else if (sample == 'U')
		sample = '2';
	else if (sample == 'C')
		sample = '3';
	else if (sample == 'X')
		sample = '4';
	else
		sample = '5';
*/
	ParseDelimiter(buf, 3, '|', patno);

	ParseDelimiter(buf, 4, '|', sex);

	ParseDelimiter(buf, 5, '|', year);
	ParseDelimiter(buf, 6, '|', month);

	if (year[0] == '0')
		sprintf(age, "%s^M", month);
	else
		sprintf(age, "%s^Y", year);

	sprintf(OutFile, "%s%s.dat", g_szTempPath, "outbuffer");

	fp_out = fopen(OutFile, "at");
	if (fp_out == NULL) {
		WriteLog("Cannot open file: %s", OutFile);
	} 

	sprintf(buf_out, "H|\\^&|||ASTM-Host^||||||TSDWN^REPLY\n\0");
	fwrite(buf_out, strlen(buf_out), sizeof(char), fp_out);

	sprintf(buf_out, "P|1||%s|||||%s||||||%s\n\0", patno, sex, age);
	fwrite(buf_out, strlen(buf_out), sizeof(char), fp_out);

	num = 0;
	while (1) {
        if (fgets(buf, 1024, fp) == NULL) break;
        p = strtok(buf, " \t\r\n");

        if (p == NULL) continue;

		WriteLog("TESTCODE: %s", p);

        ConvertCode(p, code);

        strcpy(tests[num].code, code);

        num++;
    }
    fclose(fp);

    for (i = 0; i < num; i++) {
		if (i > 0) {
			sprintf(buf, "\\^^^%s^1\0", tests[i].code);
			strcat(test, buf);
		} else {
			sprintf(buf, "^^^%s^1\0", tests[i].code);
			strcpy(test, buf);
		}
    }

//	sprintf(buf_out, "O|1|%s|%s|%s|%c||%d%02d%02d%02d%02d%02d||||A||||%c||||||||||O\n\0", LabNo, pos, test, priority, 
//		timep->tm_year+1900, timep->tm_mon+1, timep->tm_mday, timep->tm_hour, timep->tm_min, timep->tm_sec, sample);

	sprintf(buf_out, "O|1|%s|%s|%s|%c||%d%02d%02d%02d%02d%02d||||A||||||||||||||O\n\0", sid, pos, test, priority, 
		timep->tm_year+1900, timep->tm_mon+1, timep->tm_mday, timep->tm_hour, timep->tm_min, timep->tm_sec);
	fwrite(buf_out, strlen(buf_out), sizeof(char), fp_out);
	
	sprintf(buf_out, "C|1|L|%s^^^^|G\n\0", fullname);
	fwrite(buf_out, strlen(buf_out), sizeof(char), fp_out);

	sprintf(buf_out, "L|1|N\n\0");
	fwrite(buf_out, strlen(buf_out), sizeof(char), fp_out);

	fclose(fp);
	fclose(fp_out);

    return 1;
}

int SendPacket(char *packet)
{
	int		retry;
	char	server_reply[2000];
    int		recv_size;

	for (retry = 0; retry < g_nMaxRetry; retry++) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;

		SendLine(&g_Client, packet);

		if ((recv_size = recv(g_Client.s, server_reply, 2000, 0)) != SOCKET_ERROR) {
			server_reply[recv_size] = '\0';

			if (server_reply[0] == ACK) {
				WriteLog("RECV ACK");
				return 1;
			} else if (server_reply[0] == NAK) {
				WriteLog("RECV NAK");
			} else {
				WriteLog("RECV: %s", server_reply);
			}
		}

		if (g_dwSleep != 0)
			Sleep(g_dwSleep);
	}
	return 0;
}
