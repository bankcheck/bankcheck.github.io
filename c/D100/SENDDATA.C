#include <stdio.h>
#include <string.h>
#include <time.h>
#include "D100.h"

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

int SendFile(char LabNo[12]) {
	char InFile[260];
    char OutFile[260];
	char bakname[260];
	char inbuf[1024];
	char outbuf[1024];
	FILE *ifp, *ofp;
	char hospnum[10];
	char patname[40];
	char birthday[9];
	char sex;
	char priority;
	char *p;

    sprintf(InFile, "%s%s", g_szInBoxPath, LabNo);
	ifp = fopen(InFile, "rt");
    if (ifp == NULL) {
        WriteLog("Can't open file: %s", InFile);
	    return 0;
    }

	sprintf(OutFile, "%s%s.dat", g_szTempPath, "outbuffer");
	ofp = fopen(OutFile, "a+");
	if (ofp == NULL) {
		WriteLog("Cannot open file: %s", OutFile);
		
		if (ifp != NULL) {
			fclose(ifp);
			ifp = NULL;
		}

        return 0;
    }

	memset(outbuf, '\0', 1024);
	
//	sprintf(outbuf, "H|\\^&\n\0");
//	fwrite(outbuf, strlen(outbuf), sizeof(char), ofp);
	
    if (fgets(inbuf, 1024, ifp) == NULL){
        WriteLog("Empty file: %s", InFile);
	    fclose(ofp);
	    return 0;
    }
	
	ParseDelimiter(inbuf, 1, '|', patname);
    p = strchr (patname, ',');
	*p = '^';
	ParseDelimiter(inbuf, 3, '|', hospnum);
	ParseDelimiter(inbuf, 4, '|', &sex);
	ParseDelimiter(inbuf, 7, '|', birthday);

	priority=*(strrchr(inbuf, '|')+1);

	if (priority != 'R')
		priority = 'S';

	sprintf(outbuf, "P|1|%s|||%s^^^||%s|%c|||||DR\n\0", hospnum, patname, birthday, sex);
	fwrite(outbuf, strlen(outbuf), sizeof(char), ofp);

//hard code only test 4 - HbA1c
	sprintf(outbuf, "O|1|%s||^^^4|%c||||||||||||||||||||Q\n\0", LabNo, priority);
	fwrite(outbuf, strlen(outbuf), sizeof(char), ofp);

//	sprintf(outbuf, "L|1|N\n\0");
//	fwrite(outbuf, strlen(inbuf), sizeof(char), ofp);

	fclose(ofp);
	ofp = NULL;

	fclose(ifp);
	ifp = NULL;

	sprintf(bakname, "%s%s\0", g_szBackupInBoxPath, LabNo);
	WriteLog("Move file from %s to %s", InFile, bakname);
	MoveFile(InFile, bakname);

	return 1;
}

int SendData(void)
{
	char cmd[260];
    DWORD       dwLen;
	char buf[260];
	char packet[247];
	char databuf[247];
	DWORD i;
	FILE *fp;
    char OutFile[260];
	char *message;    
	int FrameNo;

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

		Sleep(g_dwSleep);
    }

	if (g_bQuit) return 0;
	
	if (buf[0] == ENQ) {
		WriteLog("Receive ENQ");
		g_ls = LS_RECV;

		Sleep(g_dwSleep);
		
		fclose(fp);
		return 0;
	}
	if (buf[0] == NAK) {
		WriteLog("Receive NAK");

		Sleep(g_dwSleep);
		
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
    sprintf(databuf, "%1dH|\\^&%c%c\0", FrameNo, CR, ETX);

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
			i++;
			message++;
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
	int			retry = 0;

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
			
			Sleep(g_dwSleep);

			if (ReadDataFromComm(&dwLen, cmd) > 0)
				break;
		}

		if (g_bQuit) return 1;
              
		if (cmd[0] == ACK) {
			WriteLog("Receive ACK");
			return 1;
		}
		else if (cmd[0] == NAK) {
			WriteLog("Receive NAK");
			Sleep(g_dwSleep);
			retry ++;
			if (retry >= g_nMaxRetry)
				return 1;
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
			WriteLog("Receive Unknown Packet, retry");
			DumpErrorData(dwLen, cmd);
			Sleep(g_dwSleep);
			retry ++;
			if (retry >= g_nMaxRetry)
				return 1;
		}
	}		        
	return 0;
}