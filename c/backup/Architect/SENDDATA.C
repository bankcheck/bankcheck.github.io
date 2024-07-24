#include <stdio.h>
#include <string.h>
#include <time.h>
#include "Architect.h"

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
    WIN32_FIND_DATA data;
    HANDLE hFind;
    char path[260], fname[260], OutFile[260];
	char cmd[260];
    DWORD       dwLen;
	char buf[260];
	char packet[247];
	char databuf[247];
	char p[1024];
	char o[1024];
    BOOL bFound;
	BOOL bNotSent;
	DWORD i;
	FILE *fp;
	int seq;
    
	time_t t;
    struct tm *tp;

	int FrameNo;
	char DateTime[14];

	char bakname[260];
	char *name;
//check file to send
    sprintf(path, "%s*", g_szInBoxPath);
    if (g_bDebug)
        WriteLog("Checking upload folder %s...", path);
    hFind = FindFirstFile(path, &data);

	sprintf(OutFile, "%s%s.dat", g_szTempPath, "outbuffer");
	seq = 1;

    if (hFind != INVALID_HANDLE_VALUE) {
		bNotSent = TRUE;
        bFound = TRUE;
        while (bFound) {
            if (g_bQuit) break;
            if (data.cFileName[0] != '.' && (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0) {
                sprintf(fname, "%s%s", g_szInBoxPath, data.cFileName);
				memset(p, '\0', 1024);
				memset(o, '\0', 1024);
                if (ConvertArchitectCode(fname, seq, p, o)) {
					seq++;
					fp = fopen(OutFile, "a+");
					if (fp == NULL) {
						WriteLog("Cannot open file: %s", OutFile);
					} else {
						fwrite(p, strlen(p), sizeof(char), fp);
						fwrite(o, strlen(o), sizeof(char), fp);
						fclose(fp);
					}
					time(&t);
					tp = localtime(&t);

					if (tp != NULL) {
						sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
							tp->tm_hour, tp->tm_min, tp->tm_sec);
						name = strrchr(fname, '_');

						sprintf(bakname, "%s%s%s\0", g_szBackupInBoxPath, DateTime, name);
						WriteLog("Move file from %s to %s", fname, bakname);
						CopyFile(fname, bakname, FALSE);
					}
					DeleteFile(fname);

					bNotSent = FALSE;
				}
            }
            bFound = FindNextFile(hFind, &data);
        }
        FindClose(hFind);
    }

//Open buffer file
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

//send header
	FrameNo = 1;
    sprintf(databuf, "%1dH|\\^&||||||||||P|1%c%c\0", FrameNo, CR, ETX);
	sprintf(packet, "%02X%c%c\0", GetCheckSum(databuf), CR, LF);
	strcat(databuf, packet);
	sprintf(packet, "%c%s\0", STX, databuf);
	SendPacket(packet);
	
//read buffer
	while (1) {
		if (fgets(buf, 2048, fp) == NULL) break;

		i = 0;
		memset(packet, '\0', 247);

		while (buf[i] != '\n') {
			packet[i] = buf[i];
			i++;
			if (i > 239) {
				i = 0;
				FrameNo++;
				if (FrameNo > 7)
					FrameNo = 0;
				sprintf(databuf, "%1d%s%c%c\0", FrameNo, packet, CR, ETB);
				sprintf(packet, "%02X%c%c\0", GetCheckSum(databuf), CR, LF);
				strcat(databuf, packet);
				sprintf(packet, "%c%s\0", STX, databuf);
				SendPacket(packet);
				memset(packet, '\0', 247);
			}
		}

		FrameNo++;
		if (FrameNo > 7)
			FrameNo = 0;
		sprintf(databuf, "%1d%s%c%c\0", FrameNo, packet, CR, ETX);
		sprintf(packet, "%02X%c%c\0", GetCheckSum(databuf), CR, LF);
		strcat(databuf, packet);
		sprintf(packet, "%c%s\0", STX, databuf);
		SendPacket(packet);
	}
    
	fclose(fp);

	FrameNo++;
	if (FrameNo > 7)
		FrameNo = 0;
	sprintf(databuf, "%1dL|1%c%c\0", FrameNo, CR, ETX);
	sprintf(packet, "%02X%c%c\0", GetCheckSum(databuf), CR, LF);
	strcat(databuf, packet);
	sprintf(packet, "%c%s\0", STX, databuf);
	SendPacket(packet);
		
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