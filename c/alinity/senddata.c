#include <stdio.h>
#include <string.h>
#include <time.h>
#include "alinity.h"

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

int SendFile(int no, char *sid)
{
    char buf[1024];
    FILE *in;
	char fname[260];
	char packet[2048];
	char DateTime[15];
	char name[40];
	char hospno[10];
	char sex;
	char priority;
	char *p;
    char code[20];
	char bakname[260];
	char *filename;
	time_t t;
    struct tm *tp;
	char	birth_date[9];
	//char OutFile[260];
	int seq;
	
	g_client[no].fp = fopen(g_client[no].fname, "a+");
	
	sprintf(fname, "%s%s", g_szInBoxPath, sid);

    WriteLog("Processing %s", fname);

    in = fopen(fname, "rt");
    if (in == NULL) {
        WriteLog("Can't open file: %s", fname);

		sprintf(packet, "H|\\^&||||||||||P\n\0");
		fwrite(packet, strlen(packet), sizeof(char), g_client[no].fp);
		WriteLog("Write file %s: %s", g_client[no].fname, packet);

		sprintf(packet, "Q|1|^%s||^^^ALL||||||||X\n\0", sid);
		fwrite(packet, strlen(packet), sizeof(char), g_client[no].fp);
		WriteLog("Write file %s: %s", g_client[no].fname, packet);

		sprintf(packet, "L|1\n\0");
		fwrite(packet, strlen(packet), sizeof(char), g_client[no].fp);
		WriteLog("Write file %s: %s", g_client[no].fname, packet);

		fclose(g_client[no].fp);
		WriteLog("Close file: %s", g_client[no].fname);

        return 0;
    }

    if (fgets(buf, 1024, in) == NULL){
        WriteLog("Can't open file: %s", fname);

		sprintf(packet, "H|\\^&||||||||||P\n\0");
		fwrite(packet, strlen(packet), sizeof(char), g_client[no].fp);
		WriteLog("Write file %s: %s", g_client[no].fname, packet);

		sprintf(packet, "Q|1|^%s||^^^ALL||||||||X\n\0", sid);
		fwrite(packet, strlen(packet), sizeof(char), g_client[no].fp);
		WriteLog("Write file %s: %s", g_client[no].fname, packet);

		sprintf(packet, "L|1\n\0");
		fwrite(packet, strlen(packet), sizeof(char), g_client[no].fp);
		WriteLog("Write file %s: %s", g_client[no].fname, packet);

		fclose(g_client[no].fp);
		WriteLog("Close file: %s", g_client[no].fname);

        return 0;
    }

    WriteLog("DATA: %s", buf);

	ParseDelimiter(buf, 1, '|', name);
	p = strchr(name, ',');
	*p = '^';

	ParseDelimiter(buf, 3, '|', hospno);

	if (ParseDelimiter(buf, 4, '|', &sex) == NULL)
		sex = 'U';

	ParseDelimiter(buf, 7, '|', birth_date);

	priority=*(strrchr(buf, '|')+1);
	
	time(&t);
	tp = localtime(&t);
	if (tp != NULL) {
		sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
			tp->tm_hour, tp->tm_min, tp->tm_sec);
	}

	sprintf(packet, "H|\\^&||||||||||P\n\0");
	fwrite(packet, strlen(packet), sizeof(char), g_client[no].fp);
	WriteLog("Write file %s: %s", g_client[no].fname, packet);

	sprintf(packet, "P|1|||%s|%s^||%s|%c|||||||||||||||||HKAH\n\0", hospno, name, birth_date, sex);
	fwrite(packet, strlen(packet), sizeof(char), g_client[no].fp);
	WriteLog("Write file %s: %s", g_client[no].fname, packet);
	
	seq = 1;

    while (1) {
        if (fgets(buf, 1024, in) == NULL) break;
        p = strtok(buf, " \t\r\n");
        
		if (p == NULL) continue;

		RevertCode(p, code);
		sprintf(packet, "O|%d|%s||^^^%s|||||||A||||||||||||||Q\n\0", seq++, sid, code);

		fwrite(packet, strlen(packet), sizeof(char), g_client[no].fp);
		WriteLog("Write file %s: %s", g_client[no].fname, packet);
    }

    sprintf(packet, "L|1\n\0");
	fwrite(packet, strlen(packet), sizeof(char), g_client[no].fp);
	WriteLog("Write file %s: %s", g_client[no].fname, packet);

    fclose(in);
	WriteLog("Close file: %s", fname);

	fclose(g_client[no].fp);
	WriteLog("Close file: %s", g_client[no].fname);

	if (g_bBackupInbox) {
		filename = strrchr(fname, '\\');
		filename++;
			
		sprintf(bakname, "%s%s\0", g_szBackupInBoxPath, filename);

		WriteLog("Moving file from %s to %s", fname, bakname);
		CopyFile(fname, bakname, FALSE);

		DeleteFile(fname);
	}

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
