#include <stdio.h>
#include <string.h>
#include <time.h>
#include "c6000.h"

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

int SendFile(int seq, char LabNo[12], char *pos) {
	char bakname[260];
	char fname[260];
	char p[1024];

    sprintf(fname, "%s%s", g_szInBoxPath, LabNo);
	memset(p, '\0', 1024);
    
	Convertc6000Code(fname, seq, p, pos);
	
	if (g_bBackupInbox) {
		sprintf(bakname, "%s%s\0", g_szBackupInBoxPath, LabNo);
		WriteLog("Move file from %s to %s", fname, bakname);
		CopyFile(fname, bakname, FALSE);

		DeleteFile(fname);
	}
	
	return 1;
}

int SendData(void)
{
    WIN32_FIND_DATA data;
    HANDLE hFind;
    char path[260];
	char cmd[260];
    DWORD       dwLen;
	char buf[2048];
//	char packet[2048];
//	char databuf[2048];
    BOOL bFound;
	BOOL bNotSent;
//	DWORD i;
	FILE *fp;
    char OutFile[260];
	char *message;
//	char termcode;

	int seq;
	int len;
    
//	time_t t;
//	struct tm *tp;

//	int FrameNo;
//	char DateTime[14];

	char LabNo[12];
//check file to send

	if (g_mode == 1) {
		sprintf(path, "%s*", g_szInBoxPath);
		if (g_bDebug)
			WriteLog("Checking upload folder %s...", path);
		hFind = FindFirstFile(path, &data);

		seq = 1;

		if (hFind != INVALID_HANDLE_VALUE) {
			bNotSent = TRUE;
			bFound = TRUE;
			while (bFound) {
				if (g_bQuit) break;
				if (data.cFileName[0] != '.' && (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0) {

					sprintf(LabNo, "%s\0", data.cFileName);
					if (SendFile(seq, LabNo, "^^^^^\0")) {
						seq++;
						bNotSent = FALSE;
					}
				}
				bFound = FindNextFile(hFind, &data);
			}
			FindClose(hFind);
		}
	}

//Open buffer file
	sprintf(OutFile, "%s%s.dat", g_szTempPath, "outbuffer");

	fp = fopen(OutFile, "rt");
	if (fp == NULL) {
		return 0;
	}

//Send ENQ;
	while(1) {
	    if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
			g_bQuit = TRUE;
		    break;
		}

		cmd[0] = ENQ;
		cmd[1] = '\0';
		WriteLog("Send ENQ");
		SendChar(g_hCom, cmd, 1);
		FlushFileBuffers(g_hCom);

        if (ReadDataFromComm(&dwLen, buf) > 0)
            break;

		Sleep(1000);
    }

	if (g_bQuit) return 0;
	
	if (buf[0] == ENQ) {
		WriteLog("Receive ENQ");
		g_ls = LS_RECV;
		Sleep(1000);
		fclose(fp);
		return 0;
	}
	if (buf[0] == NAK) {
		WriteLog("Receive NAK");
		Sleep(1000);
		fclose(fp);
		return 0;
	}
	if (buf[0] != ACK) {
		WriteLog("Receive Packet: %s, expecting ACK ", buf);
		cmd[0] = NAK;
		cmd[1] = '\0';
		WriteLog("Send NAK");
		SendChar(g_hCom, cmd, 1);
		FlushFileBuffers(g_hCom);
		fclose(fp);
		return 0;
	}

	WriteLog("Receive ACK");

	message = (char*)malloc(2048);
	*message = '\0';
	//p = message;
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
	buf[0] = EOT;
	buf[1] = '\0';
	SendChar(g_hCom, buf, 1);
	FlushFileBuffers(g_hCom);

	DeleteFile(OutFile);
    
	return 0;
}

int SendPacket(char *buf)
{
	char	cmd[260];
    DWORD       dwLen;
	DWORD           dwStatus;
    COMSTAT         cs;
    DWORD           dwError, dwErrorFlag;

    if (g_bDebug)
		WriteLog("Checking port status...");

    if (GetCommModemStatus(g_hCom, &dwStatus) == FALSE) {
		dwError = GetLastError();
        ClearCommError(g_hCom, &dwErrorFlag, &cs);
        WriteLog("GetCommModemStatus() failed, code %ld, flag %ld", dwError, dwErrorFlag);
        return 1;
    }

    /*if ((dwStatus & MS_CTS_ON) == 0) {
		WriteLog("線路未連接, 請檢查線路...");
		return 1;
	}*/

	dwLen = 0;
	while (1) {
		while (1) {
			if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
				g_bQuit = TRUE;
				break;
			}

			WriteLog("Send: %s", buf);
			SendChar(g_hCom, buf, strlen(buf));
			FlushFileBuffers(g_hCom);

			if (ReadDataFromComm(&dwLen, cmd) > 0)
				break;

			Sleep(1000);
		}

		if (g_bQuit) return 1;
              
		if (cmd[0] == ACK) {
			WriteLog("Receive ACK");
			return 1;
		}
		else if (cmd[0] == NAK) {
			WriteLog("Receive NAK");
			Sleep(1000);
		}
		else if (cmd[0] == ENQ) {
			WriteLog("Receive ENQ");
			WriteLog("Send NAK");
			buf[0] = NAK;
			buf[1] = '\0';
			SendChar(g_hCom, buf, 1);
			FlushFileBuffers(g_hCom);
		}
		else{
			WriteLog("Receive Unknown Packet, send NAK");
			DumpErrorData(dwLen, cmd);
			buf[0] = NAK;
			buf[1] = '\0';
			SendChar(g_hCom, buf, 1);
			FlushFileBuffers(g_hCom);
		}
	}		        
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