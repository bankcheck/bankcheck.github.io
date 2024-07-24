#include <stdio.h>
#include <string.h>
#include <time.h>
#include "phadia.h"

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

int SendFolder()
{
    WIN32_FIND_DATA data;
    HANDLE hFind;
    char path[260];
    BOOL bFound;
	int p;

	p = 0;
	
	sprintf(path, "%s*", g_szInBoxPath);
	
	hFind = FindFirstFile(path, &data);

	if (hFind != INVALID_HANDLE_VALUE) {
		bFound = TRUE;
		while (bFound) {
			if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
				break;

		    if (data.cFileName[0] != '.' && (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0) {

				SendFile(data.cFileName, p++);
			}

	        bFound = FindNextFile(hFind, &data);

		}
		FindClose(hFind);
	}

    return 0;
}

int SendFile(char *sid, int seq)
{
    char buf[1024];
    FILE *in, *out;
	char fname[260];
//	int	FrameNo;
//	char databuf[247];
	char packet[2048];
	char DateTime[15];
	char name[40];
	char hospno[10];
	char priority;
	char *p;
	char test[2048];
	char item[20];
	char bakname[260];
//	char client_reply[2000];
	char *filename;
	time_t t;
    struct tm *tp;
//    int		recv_size;
//    char message[4096];
//	short	retry;
	char	birth_date[9];
//	char OutFile[260];

	sprintf(fname, "%s%s", g_szInBoxPath, sid);

    WriteLog("Processing %s", fname);

    in = fopen(fname, "rt");
    if (in == NULL) {
        WriteLog("Can't open file: %s", fname);
        return 0;
    }

    if (fgets(buf, 1024, in) == NULL){
        WriteLog("Can't open file: %s", fname);
        return 0;
    }

    WriteLog("DATA: %s", buf);

	ParseDelimiter(buf, 1, '|', name);
	p = strchr(name, ',');
	*p = '^';

	ParseDelimiter(buf, 3, '|', hospno);

	ParseDelimiter(buf, 7, '|', birth_date);

	priority=*(strrchr(buf, '|')+1);
	
	time(&t);
	tp = localtime(&t);
	if (tp != NULL) {
		sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
			tp->tm_hour, tp->tm_min, tp->tm_sec);
	}
	
	test[0] = '\0';

    while (1) {
        if (fgets(buf, 1024, in) == NULL) break;
        p = strtok(buf, " \t\r\n");
        if (p == NULL) continue;
        WriteLog("TESTCODE: %s", p);
/*
		if (strlen(test) > 0)
			sprintf(item, "\\^^^%s^sIgE^1\0", p);
		else 
			sprintf(item, "^^^%s^sIgE^1\0", p);
*/
		if (strlen(test) > 0)
			sprintf(item, "\\^^^%s^\0", p);
		else 
			sprintf(item, "^^^%s^\0", p);

		strcat(test, item);
    }
	WriteLog("Close file: %s", fname);
    fclose(in);

	out = fopen(g_szOutBufferFile, "a+");

	if (out == NULL) {
		WriteLog("Cannot open file: %s", g_szOutBufferFile);
	} else {
		sprintf(packet, "P|%d|%s|%s\n\0", seq,  hospno, sid);
		fwrite(packet, strlen(packet), sizeof(char), out);
		WriteLog("Write file %s: %s", g_szOutBufferFile, packet);

		sprintf(packet, "O|1|%s^N^^||%s|||%s||||N||1||||||||||||O\n\0", sid, test, DateTime);
		fwrite(packet, strlen(packet), sizeof(char), out);
		WriteLog("Write file %s: %s", g_szOutBufferFile, packet);
	}

	WriteLog("Close file: %s", g_szOutBufferFile);
	fclose(out);

//	if (g_bBackupInbox) {
		filename = strrchr(fname, '\\');
		filename++;
			
		sprintf(bakname, "%s%s\0", g_szBackupInBoxPath, filename);

		WriteLog("Moving file from %s to %s", fname, bakname);
		CopyFile(fname, bakname, FALSE);

		DeleteFile(fname);
//	}

	return 1;
}

int SendPacket(char *packet)
{
	int		retry;
	char	client_reply[2000];
    int		recv_size;

	for (retry = 0; retry < g_nMaxRetry; retry++) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;

		SendLine(&g_Client, packet);

		if ((recv_size = recv(g_Client.s, client_reply, 2000, 0)) != SOCKET_ERROR) {
			client_reply[recv_size] = '\0';

			if (client_reply[0] == ACK) {
				WriteLog("RECV ACK");
				return 1;
			} else if (client_reply[0] == NAK) {
				DumpErrorData(strlen(packet), packet);
				WriteLog("RECV NAK");
			} else {
				WriteLog("RECV: %s", client_reply);
			}
		}

		if (g_dwSleep != 0)
			Sleep(g_dwSleep);
	}
	
	sprintf(packet, "%c\0", EOT);
	SendLine(&g_Client, packet);

	return 0;
}

int SendData()
{
//	char fname[260];
    FILE *fp;
	char	packet[1033];
	char	databuf[1033];
    char	buf[1024];
	char	client_message[2000];
    int		recv_size;
	time_t t;
    struct tm *tp;
	char DateTime[15];
	int		frame;

	time(&t);
	tp = localtime(&t);
	if (tp != NULL) {
		sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
			tp->tm_hour, tp->tm_min, tp->tm_sec);
	}

//Open buffer file
	WriteLog("Send data");

	fp = fopen(g_szOutBufferFile, "rt");
	if (fp != NULL) {
		WriteLog("Open: %s", g_szOutBufferFile);

//Send ENQ
		sprintf(packet, "%c\0", ENQ);
		SendLine(&g_Client, packet);
		
		if (g_Client.s == SOCKET_ERROR) {
			fclose(fp);
			WriteLog("Close: %s", g_szOutBufferFile);
			return 0;
		}

		if ((recv_size = recv(g_Client.s, client_message, 2000, 0)) != SOCKET_ERROR) {
			client_message[recv_size] = '\0';

			if (client_message[0] == ACK) {
				WriteLog("RECV ACK");

				sprintf(databuf, "1H|\\^&|||Host|||||||P|1|%s%c%c\0", DateTime, CR, ETX);
				sprintf(packet, "%c%s%02X%c%c\0", STX, databuf, GetCheckSum(databuf), CR, LF);
				
				if (SendPacket(packet) == 0) {
					fclose(fp);
					WriteLog("Close: %s", g_szOutBufferFile);
					return 0;
				}

				frame = 2;
				
				while (fgets(buf, 1024, fp) != NULL) {

					if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
						break;

					buf[strlen(buf)-1] = CR;
					buf[strlen(buf)] = '\0';

					sprintf(databuf, "%d%s%c%c\0", frame, buf, CR, ETX);

					sprintf(packet, "%c%s%02X%c%c\0", STX, databuf, GetCheckSum(databuf), CR, LF);

					if (SendPacket(packet) == 0)
						break;
							
					frame++;

					if (frame >= 8)
						frame = 0;
				}

				sprintf(databuf, "%dL|1|F%c%c\0", frame, CR, ETX);
				sprintf(packet, "%c%s%02X%c%c\0", STX, databuf, GetCheckSum(databuf), CR, LF);

				if (SendPacket(packet) == 0) {
					fclose(fp);
					WriteLog("Close: %s", g_szOutBufferFile);
					return 0;
				}
//Send EOT
				sprintf(packet, "%c\0", EOT);
				SendLine(&g_Client, packet);

				fclose(fp);
				WriteLog("Close: %s", g_szOutBufferFile);

				if (DeleteFile(g_szOutBufferFile))
					WriteLog("Delete: %s", g_szOutBufferFile);
				else
					WriteLog("Fail to delete: %s", g_szOutBufferFile);

				return 1;

			} else if (client_message[0] == NAK) {
				WriteLog("RECV NAK");
				fclose(fp);
				WriteLog("Close: %s", g_szOutBufferFile);
			} else {
				WriteLog("RECV: %s", client_message);
				fclose(fp);
				WriteLog("Close: %s", g_szOutBufferFile);
			}
		}
	}

	return 0;
}