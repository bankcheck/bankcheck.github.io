#include <stdio.h>
#include <string.h>
#include <time.h>
#include "infsend.h"

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
	short	retry;
    char	message[4096];
	char	server_reply[2000];
    int		recv_size;

//Send sample
	retry = 0;

	while(retry < g_nMaxRetry) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;

		sprintf(message, "%c\0", ENQ);
		SendLine(&g_Client, message);

		if ((recv_size = recv(g_Client.s, server_reply, 2000, 0)) != SOCKET_ERROR) {
			server_reply[recv_size] = '\0';

			if (server_reply[0] == ACK) {
				WriteLog("RECV ACK");
				return 1;
			} else if (server_reply[0] == NAK) {
				WriteLog("RECV NAK");									
				retry++;
			} else {
				WriteLog("RECV: %s", server_reply);
				retry++;
			}
		}

		if (g_dwSleep != 0)
			Sleep(g_dwSleep);
	}

	return 0;
}

int SendFile(char *filename)
{
    char buf[1024];
    FILE *fp, *bfp;
	char sid[20];
	char *q;
	int	FrameNo;
	char databuf[1024];
	char packet[1024];
	char DateTime[15];
	char name[40];
	char hospno[14];
	char priority;
	char *p;
    char code[15];
	char test[900];
	char item[20];
	char bakname[260];
	char fname[260];
	time_t t;
    struct tm *tp;

	sprintf(fname, "%s%s", g_szInBoxPath, filename);
	sprintf(bakname, "%s%s\0", g_szBackupInBoxPath, filename);

    WriteLog("Processing %s", fname);

    fp = fopen(fname, "rt");
    if (fp == NULL) {
        WriteLog("Can't open file: %s", fname);
        return 0;
    }

    bfp = fopen(bakname, "w");
    if (bfp == NULL) {
        WriteLog("Can't open file: %s", bakname);
	    fclose(fp);
        return 0;
    }

    if (fgets(buf, 1024, fp) == NULL){
        WriteLog("Can't read file: %s", fname);
	    fclose(fp);
	    fclose(bfp);
        return 0;
    }

	fwrite(buf, strlen(buf), sizeof(char), bfp);

    WriteLog("DATA: %s", buf);

    q = strrchr(fname, '\\');
	q++;

	strcpy(sid, q);
	strtok(sid, "_");

	if (strchr(buf, '|') == NULL){
        WriteLog("Wrong file format");
		sprintf(packet, "%c\0", EOT);
		SendLine(&g_Client, packet);
	    fclose(fp);
        return 0;
    }
		
	ParseDelimiter(buf, 1, '|', name);
	p = strchr(name, ',');
	*p = '^';

	ParseDelimiter(buf, 3, '|', hospno);

	//ParseDelimiter(buf, 4, '|', &sex);

	priority=*(strrchr(buf, '|')+1);

	FrameNo = 1;
	
	time(&t);
	tp = localtime(&t);
	if (tp != NULL) {
		sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
			tp->tm_hour, tp->tm_min, tp->tm_sec);
	}

	sprintf(databuf, "%1dH|\\^&|%d||HKAH^Lab|||||Infinity^Roche||P||%s%c%c\0", FrameNo, g_nMsgID, DateTime, CR, ETX);
	sprintf(packet, "%02X%c%c\0", GetCheckSum(databuf), CR, LF);
	strcat(databuf, packet);
	sprintf(packet, "%c%s\0", STX, databuf);
	
	if (SendPacket(packet) == 0) {
		disconnect(&g_Client);
					
		if (g_dwSleep != 0)
			Sleep(g_dwSleep);

		if (ConnectServer(&g_Client) == 1)
			WriteLog ("Fail to connect server");
	}

	FrameNo ++;

    sprintf(databuf, "%1dP|1|%s|%s||%s||||||||||||||||||%s||||||||||%c%c\0", FrameNo, sid, hospno, name, DateTime, CR, ETX);
	sprintf(packet, "%02X%c%c\0", GetCheckSum(databuf), CR, LF);
	strcat(databuf, packet);
	sprintf(packet, "%c%s\0", STX, databuf);
	
	if (SendPacket(packet) == 0) {
		disconnect(&g_Client);
					
		if (g_dwSleep != 0)
			Sleep(g_dwSleep);

		if (ConnectServer(&g_Client) == 1)
			WriteLog ("Fail to connect server");
	}

	test[0] = '\0';

    while (1) {
        if (fgets(buf, 1024, fp) == NULL) break;

		fwrite(buf, strlen(buf), sizeof(char), bfp);

        p = strtok(buf, " \t\r\n");
        if (p == NULL) continue;

        WriteLog("TESTCODE: %s", p);

		ConvertCode(p, code);

		if (strlen(test) > 0) {
			sprintf(item, "\\^^^%s\0", code);
		} else {
			sprintf(item, "^^^%s\0", code);
		}
        strcat(test, item);
    }

    fclose(fp);
	fclose(bfp);

	FrameNo ++;
    sprintf(databuf, "%1dO|1|%s||%s|%c|%s|||||A||||||||||||||O%c%c\0", FrameNo, sid, test, priority, DateTime, CR, ETX);
	sprintf(packet, "%02X%c%c\0", GetCheckSum(databuf), CR, LF);
	strcat(databuf, packet);
	sprintf(packet, "%c%s\0", STX, databuf);
	
	if (SendPacket(packet) == 0) {
		disconnect(&g_Client);
					
		if (g_dwSleep != 0)
			Sleep(g_dwSleep);

		if (ConnectServer(&g_Client) == 1)
			WriteLog ("Fail to connect server");
	}

	FrameNo ++;
	WriteLog ("Frame: %d", FrameNo);
	
    sprintf(databuf, "%1dL|1|N%c%c\0", FrameNo, CR, ETX);
	sprintf(packet, "%02X%c%c\0", GetCheckSum(databuf), CR, LF);
	strcat(databuf, packet);
	sprintf(packet, "%c%s\0", STX, databuf);
	
	if (SendPacket(packet) == 0) {
		disconnect(&g_Client);
					
		if (g_dwSleep != 0)
			Sleep(g_dwSleep);

		if (ConnectServer(&g_Client) == 1)
			WriteLog ("Fail to connect server");
	}

	sprintf(packet, "%c\0", EOT);
	SendLine(&g_Client, packet);

	g_nMsgID++;
	return 1;
}

int SendCancel(char *fname)
{
    char buf[1024];
    FILE *fp;
	char *sid;
	int	FrameNo;
	char databuf[247];
	char packet[247];
	char DateTime[15];
	char name[40];
	char hospno[10];
//	char sex;
	char priority;
	char *p;
	time_t t;
    struct tm *tp;

    WriteLog("Processing %s", fname);

    fp = fopen(fname, "rt");
    if (fp == NULL) {
        WriteLog("Can't open file: %s", fname);
        return 0;
    }

    if (fgets(buf, 1024, fp) == NULL){
        WriteLog("Can't open file: %s", fname);
        return 0;
    }

    WriteLog("DATA: %s", buf);

    sid = strrchr(fname, '\\');
	sid++;

	ParseDelimiter(buf, 1, '|', name);
	p = strchr(name, ',');
	*p = '^';

	ParseDelimiter(buf, 3, '|', hospno);

	//ParseDelimiter(buf, 4, '|', &sex);

	priority=*(strrchr(buf, '|')+1);

	FrameNo = 1;
	
	time(&t);
	tp = localtime(&t);
	if (tp != NULL) {
		sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
			tp->tm_hour, tp->tm_min, tp->tm_sec);
	}

	sprintf(databuf, "%1dH|\\^&|%d||HKAH^Lab|||||Infinity^Roche||P||%s%c%c\0", FrameNo, g_nMsgID, DateTime, CR, ETX);
	sprintf(packet, "%02X%c%c\0", GetCheckSum(databuf), CR, LF);
	strcat(databuf, packet);
	sprintf(packet, "%c%s\0", STX, databuf);
	
	if (SendPacket(packet) == 0) {
		disconnect(&g_Client);
					
		if (g_dwSleep != 0)
			Sleep(g_dwSleep);

		if (ConnectServer(&g_Client) == 1)
			WriteLog ("Fail to connect server");
	}

	FrameNo ++;

    sprintf(databuf, "%1dP|1|%s|%s||%s||||||||||||||||||%s||||||||||%c%c\0", FrameNo, sid, hospno, name, DateTime, CR, ETX);
	sprintf(packet, "%02X%c%c\0", GetCheckSum(databuf), CR, LF);
	strcat(databuf, packet);
	sprintf(packet, "%c%s\0", STX, databuf);
	
	if (SendPacket(packet) == 0) {
		disconnect(&g_Client);
					
		if (g_dwSleep != 0)
			Sleep(g_dwSleep);

		if (ConnectServer(&g_Client) == 1)
			WriteLog ("Fail to connect server");
	}

    fclose(fp);

	FrameNo ++;
    sprintf(databuf, "%1dO|1|%s||||%s|||||C||||||||||||||X%c%c\0", FrameNo, sid, DateTime, CR, ETX);
	sprintf(packet, "%02X%c%c\0", GetCheckSum(databuf), CR, LF);
	strcat(databuf, packet);
	sprintf(packet, "%c%s\0", STX, databuf);
	
	if (SendPacket(packet) == 0) {
		disconnect(&g_Client);
					
		if (g_dwSleep != 0)
			Sleep(g_dwSleep);

		if (ConnectServer(&g_Client) == 1)
			WriteLog ("Fail to connect server");
	}

	FrameNo ++;
    sprintf(databuf, "%1dL|1|N%c%c\0", FrameNo, CR, ETX);
	sprintf(packet, "%02X%c%c\0", GetCheckSum(databuf), CR, LF);
	strcat(databuf, packet);
	sprintf(packet, "%c%s\0", STX, databuf);
	
	if (SendPacket(packet) == 0) {
		disconnect(&g_Client);
					
		if (g_dwSleep != 0)
			Sleep(g_dwSleep);

		if (ConnectServer(&g_Client) == 1)
			WriteLog ("Fail to connect server");
	}

	sprintf(packet, "%c\0", EOT);
	SendLine(&g_Client, packet);

	g_nMsgID++;
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