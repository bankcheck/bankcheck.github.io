#include <stdio.h>
#include <string.h>
#include <time.h>
#include "access.h"

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
			DumpErrorData(strlen(buf), buf);
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

int SendFile(char LabNo[12]) {
	char bakname[260];
	char fname[260];
	FILE *ifp, *ofp;
    char buf[1024];
	char priority;
    char *p;
	char fullname[320];
    char str[1024];
    char code[20];
	char hospnum[12];
	char sex;
	char dob[9];
	
	time_t t;
    struct tm *tp;
	char DateTime[15];
	
	char test[800];

	memset(test, '\0', 800);

	time(&t);  
	tp = localtime(&t);
	if (tp != NULL) {
		sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
			tp->tm_hour, tp->tm_min, tp->tm_sec);
	}

	ofp = fopen(g_szBufferFile, "w");
	if (ofp == NULL) {
		WriteLog("Cannot open file: %s", g_szBufferFile);
        return 0;
    }

    sprintf(str, "H|\\^&|||LIS|||||%s||P|1|%s\n\0", g_InstrumentID, DateTime);
	fwrite(str, strlen(str), sizeof(char), ofp);

    sprintf(fname, "%s%s", g_szInBoxPath, LabNo);

    ifp = fopen(fname, "rt");
    if (ifp == NULL) {
		sprintf(str, "L|1|F\n\0");
		fwrite(str, strlen(str), sizeof(char), ofp);

        WriteLog("Can't open file: %s", fname);
	    fclose(ofp);
	    return 0;
    }

    if (fgets(buf, 1024, ifp) == NULL){
		sprintf(str, "L|1|F\n\0");
		fwrite(str, strlen(str), sizeof(char), ofp);

        WriteLog("Empty file: %s", fname);
	    fclose(ofp);
	    return 0;
    }

	if (g_bDebug)
	    WriteLog("DATA: %s", buf);

//NAME, NAME|S|646215|F|41|9|19760517|ROUTINE		

	priority=*(strrchr(buf, '|')+1);

	ParseDelimiter(buf, 3, '|', hospnum);


	ParseDelimiter(buf, 1, '|', fullname);
//	p = strchr(fullname, ',');
//	*p = '^';

	sex = 'U';

	ParseDelimiter(buf, 4, '|', &sex);

	ParseDelimiter(buf, 7, '|', dob);

    sprintf(str, "P|1|%s|||%s||%s|%c||DR\n\0", hospnum, fullname, dob, sex);
	fwrite(str, strlen(str), sizeof(char), ofp);

	while (1) {
        if (fgets(buf, 1024, ifp) == NULL) break;

        p = strtok(buf, " \t\r\n");

        if (p == NULL) continue;

		if (g_bDebug)
			WriteLog("TESTCODE: %s", p);

        ConvertCode(p, code);

		if (strlen(test) > 0)
			sprintf(test, "%s\\^^^%s\0", test, code);
		else
			sprintf(test, "^^^%s\0", code);

    }

	sprintf(str, "O|1|%s||%s|%c||||||A||||Serum\n\0", LabNo, test, priority);
	fwrite(str, strlen(str), sizeof(char), ofp);

	sprintf(str, "L|1|F\n\0");
	fwrite(str, strlen(str), sizeof(char), ofp);

    fclose(ofp);
	fclose(ifp);

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
	char cmd[260];
    DWORD       dwLen;
	char buf[260];
	char packet[247];
	char databuf[247];
	FILE *fp;
	char *message;    
	char *p;    
	int FrameNo;

//Open buffer file
	fp = fopen(g_szBufferFile, "rt");
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

	FrameNo = 0;

//read buffer
	while (1) {
		if (fgets(buf, 2048, fp) == NULL) break;
		message = buf;
		memset(packet, '\0', 247);

		FrameNo ++;
		if (FrameNo > 7)
			FrameNo = 0;

		p = strchr(message, LF);
		*p = '\0';

		sprintf(databuf, "%1d%s%c%c\0", FrameNo, message, CR, ETX);
		sprintf(packet, "%02X%c%c\0", GetCheckSum(databuf), CR, LF);
		strcat(databuf, packet);
		sprintf(packet, "%c%s\0", STX, databuf);
		SendPacket(packet);
	}
    
	fclose(fp);

	if (g_bQuit) return 1;

    if (g_bDebug)
        WriteLog("Upload Completed.");

//Send EOT
	WriteLog("Send EOT");
	buf[0] = EOT;
	buf[1] = '\0';
	SendChar(g_hCom, buf, 1);
	FlushFileBuffers(g_hCom);

	DeleteFile(g_szBufferFile);
    
	return 0;
}
