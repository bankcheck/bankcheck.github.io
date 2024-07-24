#include <stdio.h>
#include <string.h>
#include <time.h>
#include "GeneXpert2.h"

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

				SendFile(p++, data.cFileName, g_bBackupInbox);
			}

	        bFound = FindNextFile(hFind, &data);

		}
		FindClose(hFind);
	}

    return 0;
}

int SendFile(int seq, char LabNo[12], BOOL bBackup) {
	char bakname[260];
	char fname[260];
	FILE *ifp, *ofp;
    char buf[1024];
	char priority;
    char *tp;
	char fullname[260];
	char name[41];
    char str[1024];
    char *p;
    char code[20];
	char hospnum[12];
	int i;
	//char sex;
	//char dob[9];

	ofp = fopen(g_szOutBufferFile, "a");
	if (ofp == NULL) {
		WriteLog("Cannot open file: %s", g_szOutBufferFile);
        return 0;
    }

    sprintf(fname, "%s%s", g_szInBoxPath, LabNo);

    ifp = fopen(fname, "rt");
    if (ifp == NULL) {
        WriteLog("Can't open file: %s", fname);
		sprintf(str, "\0");
		fwrite(str, strlen(str), sizeof(char), ofp);
	    fclose(ofp);
	    return 0;
    }

    if (fgets(buf, 1024, ifp) == NULL){
        WriteLog("Empty file: %s", fname);
	    fclose(ofp);
	    return 0;
    }

	if (g_bDebug)
	    WriteLog("DATA: %s", buf);

//NAME, NAME|S|646215|F|41|9|19760517|ROUTINE		

	priority=*(strrchr(buf, '|')+1);

	ParseDelimiter(buf, 3, '|', hospnum);

	tp = strtok(buf, "|");
	strcpy (fullname, tp);
	ParseDelimiter(fullname, 1, ',', tp);
	if (strlen(tp) > 20)
		tp[20] = '\0';

	sprintf(name, "%s^\0", tp);
	ParseDelimiter(fullname, 2, ',', tp);
	TrimSpace(tp);
	
	if (strlen(tp) > 20)
		tp[20] = '\0';

	strcat (name, tp);

	//sex = 'U';

	//ParseDelimiter(buf, 4, '|', &sex);

	//ParseDelimiter(buf, 7, '|', dob);

    //sprintf(str, "P|%1d||%s||%s||%s|%c|||||||||||||||||||||||||||\n\0", seq, hospnum, name, dob, sex);

/*
	H|@^\|ab067bb88634475187eab185e5651fcb||LIS|||||GeneXpert PC^GeneXpert^1.9.32 demo||P|1394-97|20071121133420
	P|1|||p1
	O|1|s1||^^^FT|R|20071116133208|||||A||||ORH||||||||||Q
	O|2|s1||^^^BC|R|20071121104253|||||A||||ORH||||||||||Q
	L|1|F
*/

    sprintf(str, "P|%1d||%s|%s\n\0", seq, hospnum, name);

	fwrite(str, strlen(str), sizeof(char), ofp);

	i = 1;
	while (1) {
        if (fgets(buf, 1024, ifp) == NULL) break;
        p = strtok(buf, "msI%r \t\r\n");

        if (p == NULL) continue;

		if (g_bDebug)
			WriteLog("TESTCODE: %s", p);

        ConvertCode(g_szCodeFile, p, code);

		 //O|2|s1||^^^BC|R|20071121104253|||||A||||ORH||||||||||Q
		sprintf(str, "O|%1d|%s||^^^%s|%c||||||A||||ORH||||||||||Q\n\0", i, LabNo, code, priority);

		fwrite(str, strlen(str), sizeof(char), ofp);
		i++;
    }

    fclose(ofp);
	fclose(ifp);

	if (bBackup) {
		sprintf(bakname, "%s%s\0", g_szBackupInBoxPath, LabNo);
		WriteLog("Move file from %s to %s", fname, bakname);
		CopyFile(fname, bakname, FALSE);

		DeleteFile(fname);
	}
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

		if (g_bDebug)
			DumpErrorData(strlen(packet), packet);

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
	BOOL	noInfo;

	time(&t);
	tp = localtime(&t);
	if (tp != NULL) {
		sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
			tp->tm_hour, tp->tm_min, tp->tm_sec);
	}

//Open buffer file
//	WriteLog("Send data");

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

				sprintf(databuf, "1H|@^\\|%d||INFINITY48-24,SN110002890^GeneXpert^6.8|||||TWAH||P|1394-97|%s%c%c\0", g_nMsgID++, DateTime, CR, ETB);
				sprintf(packet, "%c%s%02X%c%c\0", STX, databuf, GetCheckSum(databuf), CR, LF);
				
				if (SendPacket(packet) == 0) {
					fclose(fp);
					WriteLog("Close: %s", g_szOutBufferFile);
					return 0;
				}

				frame = 2;
				
				noInfo = TRUE;

				while (fgets(buf, 1024, fp) != NULL) {

					if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
						break;
					
					if (strlen(buf) > 1)
						noInfo = FALSE;
					else
						continue;

					buf[strlen(buf)-1] = '\0';

					sprintf(databuf, "%d%s%c%c\0", frame, buf, CR, ETB);

					sprintf(packet, "%c%s%02X%c%c\0", STX, databuf, GetCheckSum(databuf), CR, LF);

					if (SendPacket(packet) == 0)
						break;
							
					frame++;

					if (frame >= 8)
						frame = 0;
				}

				if (noInfo)
					sprintf(databuf, "%dL|1|I%c%c\0", frame, CR, ETX);
				else
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

/*
int SendData()
{
    FILE *fp;
	char	packet[248];
	char	databuf[248];
    char	buf[1024];
	char	client_message[2000];
    int		recv_size;
	time_t t;
    struct tm *tp;
	char DateTime[15];
	int		frame;
	BOOL	noInfo;
	unsigned int i, j;

	time(&t);
	tp = localtime(&t);
	if (tp != NULL) {
		sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
			tp->tm_hour, tp->tm_min, tp->tm_sec);
	}

//Open buffer file
//	WriteLog("Send data");

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

				sprintf(databuf, "H|@^\\|%d||ACL-TOP|||||LIS-HOST||P|1394-97|%s%c%c\0", g_nMsgID++, DateTime, CR);

				frame = 1;
				
				i = strlen(databuf);

				noInfo = TRUE;

				while (fgets(buf, 1024, fp) != NULL) {

					if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
						break;
					
					if (strlen(buf) > 1)
						noInfo = FALSE;
					else
						continue;

					buf[strlen(buf)] = '\0';
					buf[strlen(buf)-1] = CR;

					for (j = 0; j < strlen(buf); j++){
						databuf[i++] = buf[j];

						if (i > 240) {
							databuf[240] = '\0';

							sprintf(packet, "%c%d%s%c%02X%c%c\0", STX, frame++, databuf, ETB, GetCheckSum(databuf), CR, LF);
							SendPacket(packet);

							if (frame >= 8)
								frame = 0;

							i = 0;
						}
					}
				}

				if (noInfo)
					sprintf(buf, "L|1|I%c\0", CR);
				else
					sprintf(buf, "L|1|F%c\0", CR);


				for (j = 0; j < strlen(buf); j++){
					databuf[i++] = buf[j];

					if (i > 240) {
						databuf[240] = '\0';

						sprintf(packet, "%c%d%s%c%02X%c%c\0", STX, frame++, databuf, ETB, GetCheckSum(databuf), CR, LF);
						SendPacket(packet);

						if (frame >= 8)
							frame = 0;

						i = 0;
					}
				}

				if (i > 0) {
					databuf[i] = '\0';
					sprintf(packet, "%c%d%s%c%02X%c%c\0", STX, frame, databuf, ETX, GetCheckSum(databuf), CR, LF);
					SendPacket(packet);
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
*/