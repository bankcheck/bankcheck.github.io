#include <stdio.h>
#include <string.h>
#include <time.h>
#include "c8000s1.h"

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

int SendFile(int seq, char sid[12], char *pos, int port)
{
	char bakname[260];
	char fname[260];
	char p[1024];

    sprintf(fname, "%s%s", g_szInBoxPath, sid);
	memset(p, '\0', 1024);
    
	SendC8000(fname, seq, p, pos, port);
	
	if (g_bBackupInbox) {
		sprintf(bakname, "%s%s\0", g_szBackupInBoxPath, sid);
		WriteLog("Move file from %s to %s", fname, bakname);
		CopyFile(fname, bakname, FALSE);

		DeleteFile(fname);
	}
	
	return 1;
}

int SendC8000(char *fname, int seq, char *order, char *pos, int port)
{
    FILE *fp;
	FILE *fp_out;
//    TESTLIST tests[MAX_TESTS];
    char buf[1024];
	char buf_out[1024];
    char test[1024];
	char OutFile[260];
    char *p;
    //char *tp;
//    int i;
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

	ParseDelimiter(buf, 3, '|', patno);

	ParseDelimiter(buf, 4, '|', sex);

	ParseDelimiter(buf, 5, '|', year);

	ParseDelimiter(buf, 6, '|', month);

	if (year[0] == '0')
		sprintf(age, "%s^M", month);
	else
		sprintf(age, "%s^Y", year);

	sprintf(OutFile, "%sbuf%d.dat", g_szTempPath, port);

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

		if (num > 0) {
			sprintf(buf, "\\^^^%s^1\0", code);
			strcat(test, buf);
		} else {
			sprintf(buf, "^^^%s^1\0", code);
			strcpy(test, buf);
		}
        num++;
    }
    fclose(fp);

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

int SendPacket(int no, char *packet)
{
	int		retry;
	char	client_reply[2000];
    int		recv_size;

	for (retry = 0; retry < g_nMaxRetry; retry++) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;

		SendLine(no, packet);

		if ((recv_size = recv(g_client[no].s, client_reply, 2000, 0)) != SOCKET_ERROR) {
			client_reply[recv_size] = '\0';

			if (client_reply[0] == ACK) {
				WriteLog("%d:%s RECV ACK", no, g_client[no].ip);
				return 1;
			} else if (client_reply[0] == NAK) {
				WriteLog("%d:%s RECV NAK", no, g_client[no].ip);
			} else {
				WriteLog("%d:%s RECV: %s", no, g_client[no].ip, client_reply);
			}
		}

		if (g_dwSleep != 0)
			Sleep(g_dwSleep);
	}
	return 0;
}
