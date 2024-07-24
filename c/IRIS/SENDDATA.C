#include <stdio.h>
#include <string.h>
#include <time.h>
#include "IRIS.h"

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
//		memset(message, '\0', 2048);
		message = buf;
		i = 0;
		memset(packet, '\0', 247);

		while (*message != '\0') {
			packet[i] = *message;
			message++;
			i++;
			if (i > 239) {
				FrameNo++;
				if (FrameNo > 7)
					FrameNo = 0;
				sprintf(databuf, "%1d%s%c\0", FrameNo, packet, ETB);
				sprintf(packet, "%02X%c%c\0", GetCheckSum(databuf), CR, LF);
				strcat(databuf, packet);
				sprintf(packet, "%c%s\0", STX, databuf);
				SendPacket(packet);
				memset(packet, '\0', 247);
			}
		}
//for smaller frame
		FrameNo++;
		if (FrameNo > 7)
			FrameNo = 0;
		sprintf(databuf, "%1d%s%c\0", FrameNo, packet, ETX);
		sprintf(packet, "%02X%c%c\0", GetCheckSum(databuf), CR, LF);
		strcat(databuf, packet);
		sprintf(packet, "%c%s\0", STX, databuf);
		SendPacket(packet);
	}
    
	fclose(fp);

	if (g_bQuit) return 1;

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

void SendPing(void) {
	char fname[260];
	char buf[2048];
	FILE *fp;

	sprintf(fname, "%s%s.dat", g_szTempPath, "outbuffer");
	fp = fopen(fname, "a");
	sprintf(buf, "3C004900520049005300500069006E0067002F003E000D000A00\0");
	fwrite(buf, strlen(buf), sizeof(char), fp);
	fclose(fp);
}

void SendXML(char *fname) {
    char OutFile[260];
	FILE *fp, *xmlfp;
	char c;
	int x;
	char ASCII[4];
	char *message;
	char buf[2048];

	sprintf(OutFile, "%s%s.dat", g_szTempPath, "outbuffer");
	fp = fopen(OutFile, "a+");
	xmlfp = fopen(fname, "rb");
	fseek(xmlfp, 0, SEEK_SET);
	

	while (1) {
		memset(buf, '\0', 2048);
		if (fgets(buf, 2048, xmlfp) == NULL) break;

		message = buf;

		while (*message != '\0') {
			sscanf(message, "%c", &c);
			message++;
			x = c;
			sprintf (ASCII, "%02X00", x);
			fwrite(ASCII, 4, sizeof(char), fp);
		}
	}
	fclose(xmlfp);
	fclose(fp);
}