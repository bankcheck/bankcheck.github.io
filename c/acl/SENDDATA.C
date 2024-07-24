#include <stdio.h>
#include <string.h>
#include <time.h>
#include "acl.h"

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

//

int SendFile(int seq, char LabNo[12], BOOL bBackup) {
    char OutFile[260];
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
    int use_cmt;
    char code[20];
	char hospnum[12];
	int i;
/*
	time_t t;
	struct tm *tp;

	char DateTime[14];

	time(&t);
	tp = localtime(&t);
	
	if (tp != NULL)
		sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
				tp->tm_hour, tp->tm_min, tp->tm_sec);
*/
	sprintf(OutFile, "%s%s.dat", g_szTempPath, "outbuffer");
	ofp = fopen(OutFile, "w");
	if (ofp == NULL) {
		WriteLog("Cannot open file: %s", OutFile);
        return 0;
    }

    sprintf(fname, "%s%s", g_szInBoxPath, LabNo);

//
    ifp = fopen(fname, "rt");
    if (ifp == NULL) {
        WriteLog("Can't open file: %s", fname);
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
    
//	sprintf(str, "H|\\^&||||||||ACL9000||P|1|%s\n\0", FrameNo, DateTime);
//	fwrite(str, strlen(str), sizeof(char), ofp);

    sprintf(str, "P|%1d||%s||%s^^^||||||||||||||||||||||||||||||\n\0", seq, LabNo, name);

	fwrite(str, strlen(str), sizeof(char), ofp);

	i = 1;
	while (1) {
        if (fgets(buf, 1024, ifp) == NULL) break;
        p = strtok(buf, " \t\r\n");

        if (p == NULL) continue;

		if (g_bDebug)
			WriteLog("TESTCODE: %s", p);

        ConvertCode(p, code, &use_cmt);
		code[4] = '\0';

		if (priority == 'S')		
			sprintf(str, "O|%1d|%s||^^^%s|S||||||||||^|||||||||||O||||||\n\0", i, LabNo, code);
		else
			sprintf(str, "O|%1d|%s||^^^%s|||||||||||^|||||||||||O||||||\n\0", i, LabNo, code);

		fwrite(str, strlen(str), sizeof(char), ofp);
		i++;
    }

//	sprintf(str, "L|1|N\n\0");
//	fwrite(str, strlen(str), sizeof(char), ofp);

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

int SendData(void)
{
//    WIN32_FIND_DATA data;
//    HANDLE hFind;
//    char path[260];
	char cmd[260];
    DWORD       dwLen;
	char buf[260];
	char packet[247];
	char databuf[247];
//    BOOL bFound;
//	BOOL bNotSent;
	DWORD i;
	FILE *fp;
    char OutFile[260];
	char *message;

//	int seq;
    
	time_t t;
	struct tm *tp;

	int FrameNo;
	char DateTime[14];

//	char LabNo[12];

	time(&t);
	tp = localtime(&t);
	if (tp != NULL)
		sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
				tp->tm_hour, tp->tm_min, tp->tm_sec);
	
//check file to send

	if (g_mode == 1) {
		SendFolder();
/*
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
					if (SendFile(seq, LabNo)) {
						seq++;
						bNotSent = FALSE;
					}
				}
				bFound = FindNextFile(hFind, &data);
			}
			FindClose(hFind);
		}
*/
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

//send header
	FrameNo = 1;
    sprintf(databuf, "%1dH|\\^&||||||||ACL9000||P|1|%s%c%c\0", FrameNo, DateTime, CR, ETX);
	sprintf(packet, "%02X%c%c\0", GetCheckSum(databuf), CR, LF);
	strcat(databuf, packet);
	sprintf(packet, "%c%s\0", STX, databuf);
	SendPacket(packet);
	
//read buffer
	while (1) {
		if (fgets(buf, 2048, fp) == NULL) break;
		message = buf;
		i = 0;
		memset(packet, '\0', 247);

		while (*message != '\n') {
			packet[i] = *message;
			message++;
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

int SendFolder()
{
    WIN32_FIND_DATA data;
    HANDLE hFind;
    char path[260];
    BOOL bFound;
	int p;

	p = 1;
	
	sprintf(path, "%s*", g_szInBoxPath);
	
	hFind = FindFirstFile(path, &data);

	if (hFind != INVALID_HANDLE_VALUE) {
		bFound = TRUE;
		while (bFound) {
			if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
				break;

		    if (data.cFileName[0] != '.' && (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0) {

				SendFile(p++, data.cFileName, 1);
			}

	        bFound = FindNextFile(hFind, &data);

		}
		FindClose(hFind);
	}

    return 0;
}