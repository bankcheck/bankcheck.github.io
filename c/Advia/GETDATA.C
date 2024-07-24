#include <stdio.h>
#include <time.h>
#include "Advia.h"

int CheckSum(char *buf)
{
    unsigned char crcsum;
    char *p;
    unsigned char chksum;
    char str[2];

    p = buf;
    while (*p != STX && *p != '\0') p++;
    if (*p == '\0') {
        WriteLog("Invalid Packet!");
        DumpErrorData(strlen(buf), buf);
        return 0;
    }

    if (buf[0] != STX) {
        WriteLog("Invalid Packet!");
        DumpErrorData(strlen(buf), buf);
        return 0;
    }

//skip STX
	p++;

	buf = p;
	sprintf(str, "%c\0", ETX);
    p = strtok(buf, str);

    if (p == NULL) {
		WriteLog("Invalid Packet!");
        DumpErrorData(strlen(buf), buf);
        return 0;
    }

	while (*p != '\0') {
		crcsum = *p;
		p++;
	}
    
    chksum = 0;

    while (1) {
        if (buf == p) break;
        chksum = chksum^*buf;
        buf++;
    }

	if (chksum == ETX)
		chksum = 127;

	if (chksum == crcsum) {
        return 1;
    }

    DumpErrorData(strlen(buf), buf);
    WriteLog("Checksum Error! chksum:%c crcsum:%c", chksum, crcsum);
    return 0;
}

char *getline(char *buf, int len, FILE *fp)
{
    int i;
    char ch;

    i = 0;
    while (1) {
        if (feof(fp)) {
            if (i == 0) return NULL;
            buf[i] = '\0';
            return buf;
        }
        ch = fgetc(fp);
        buf[i++] = ch;
        if (ch == '\r' || ch == '\n') {
            buf[i] = '\0';
            return buf;
        }
        if (i == len) {
            buf[i] = '\0';
            return buf;
        }
    }
}

int ReceivePacket(char *szData)
{
	int	found;
    char buf[4096];
	int	nCount;
    DWORD dwLen;
    DWORD i;
	clock_t start, end;

	nCount = 0;

	memset(szData, '\0', 4096);

	start = clock();
    while (1) {
		memset(buf, '\0', 4096);
		dwLen = 0;

        while (1) {
	        if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
				g_bQuit = TRUE;
			    break;
			}
            
//			if (ReadDataFromComm(&dwLen, buf) > 0)
//                break;

			ReadDataFromComm(&dwLen, buf);
			if (dwLen > 0)
				break;

			end = clock();
			if ((end - start) > 20000) break;
        }

        if (g_bDebug) {
            WriteLog("length: %d", dwLen);
            DumpErrorData(dwLen, buf);
        }

        if (g_bQuit) break;

		if (dwLen == 0) {
			return 0;
		}

		if ((buf[0] == NAK) && (nCount == 0) && (dwLen == 1)) {
			WriteLog("Receive NAK");
			szData[0] = NAK;
			return 1;
		}

		if ((nCount == 0) && (dwLen == 1) && (buf[0] >= '0') && (buf[0] <= 'Z')) {
			WriteLog("Receive MT: %c", buf[0]);
			continue;
			//szData[0] = buf[0];
			//return 1;
		}

		found = 0;

        for (i = 0; i < dwLen; i++) {
			if (buf[i] == ETX) {
				szData[nCount] = ETX;
				found = 1;
				break;
			}
			else {
				szData[nCount] = buf[i];
			}
			nCount++;
		}

		if (g_bDebug) {
			DumpErrorData(nCount, szData);
        }

        if (found) {
			//DumpErrorData(nCount, szData);
			break;
		}
	}


	szData[nCount] = '\0';

	if (szData[0] == STX)
		WriteLog("Receive: %s", szData);

	return nCount;
}

int GetData(void)
{
    char cmd[260];
    char function;
    char szData[4096];

	char LabNo[15];
	char DateTime[14];
	//char unit[10];
	char test[30];
	char result[22];
	double dResult;
	//char error[2];

    FILE *out;
	char tmpname[260];
    //time_t t;
    //struct tm *tp;
    char tmpbuf[260];
	char *p;
	int NAKCnt;

	char packet[260];
	int size;
	boolean bFlag;

	NAKCnt = 0;
	size = 0;

	while (1) {
		if (g_bQuit) break;

		if (size > 0) {
			SendPacket(packet, size);
			Sleep (25);
		}
		
		memset(szData, '\0', 4096);
		if (ReceivePacket(szData) == 0) {
			continue;
		}

		Sleep (25);

		if (szData[0] == NAK) {

			NAKCnt ++;
			if (NAKCnt >= 2) {
				return 0;
			}
			continue;

		} else
			NAKCnt = 0;

		if (szData[0] != STX) {
			size = 0;
			continue;
		}

		memset(cmd, '\0', 260);
		g_MT = szData[1];
		cmd[0] = g_MT;
		cmd[1] = '\0';
    
		SendPacket(cmd, 1);

		//FlushFileBuffers(g_hCom);
		//WriteLog("Send MT: %s", cmd);

		function = szData[2];

		if (function == 'R') {
			p = &szData[18 - g_LabNoDigit];
			memcpy(LabNo, p, g_LabNoDigit);
			LabNo[g_LabNoDigit] = '\0';
//20110323 Arran filtered invalid labno characters
		    strtok(LabNo, "\"*/:<>?\\|");

			sprintf(DateTime, "20%c%c%c%c%c%c%c%c%c%c%c%c\0", 
				szData[42], szData[43], szData[36], szData[37], szData[39], szData[40], 
				szData[45], szData[46], szData[48], szData[49], szData[51], szData[52]);

			sprintf(tmpname, "%s%s_S%s", g_szOutBoxPath, LabNo, DateTime);
			WriteLog("Save to %s", tmpname);
			out = fopen(tmpname, "w");

			p = &szData[58];

			//WriteLog("Receive: %s", p);
			bFlag = 0;

			while ((*p != CR) && (*p != '\0')){
				if (*p == '|') {
					bFlag = !bFlag;
					p++;
					continue;
				}

				if (bFlag) {
					while (*p == ' ')
						p++;
					memcpy(test, p, 2);
					test[2] = '\0';
					sprintf(result, "FLAG\0");
					p += 2;
				} else {
					memcpy(test, p, 3);
					test[3] = '\0';
					TrimSpace(test);
					memcpy(result, p+3, 5);
					result[5] = '\0';
					TrimSpace(result);
					p += 9;
				}

				/*if (*p == '|') {
					memcpy(test, p+1, 2);
					test[2] = '\0';
					sprintf(result, "FLAG\0");
					p += 4;
				} else {
					memcpy(test, p, 3);
					test[3] = '\0';
					TrimSpace(test);
					memcpy(result, p+3, 5);
					result[5] = '\0';
					TrimSpace(result);
					p += 9;
				}*/
//flags
				if (ConvertFlag(test)) {
					strcat(test, result);
					sprintf (result, "FLAG\0");
				}
				else
					ConvertRCode(test);
				
				AddSpace(test);
				
				dResult = atof(result);
				if ((dResult == 0) && (result[0] != '0')) {
					sprintf(tmpbuf, "%s|%s\n", test, result);
					WriteLog("Result: %s", tmpbuf);
				} else {
					dResult = dResult * ConvertRate(test);
					sprintf(tmpbuf, "%s|%f\n", test, dResult);
					WriteLog("Result: %s", tmpbuf);
				} 

				if (out == NULL)
					WriteLog("Cannot open file: %s", tmpname);
				else
					fwrite(tmpbuf, strlen(tmpbuf), sizeof(char), out);
			}
			fclose(out);

			sprintf (tmpbuf, "%cZ                  0%c%c\0", GetMT(), CR, LF);
			sprintf (packet, "%c%s%c%c\0", STX, tmpbuf, GetCheckSum(tmpbuf), ETX);
			size = 26;
			continue;
		}

		if (function == 'S') {
			sprintf (tmpbuf, "%cS          %c%c\0", GetMT(), CR, LF);
			sprintf (packet, "%c%s%c%c\0", STX, tmpbuf, GetCheckSum(tmpbuf), ETX);
			size = 17;
			Sleep(5000);
		}
	}
	return 0;
}

int init(void) {
	char tmpbuf[260];
	char packet[260];
	//char szData[4096];
	DWORD dwLen;
	char buf[260];
	int found;
	DWORD i;

	g_MT = '0';

	//WriteLog("Init");
	while (1) {
		if (g_bQuit) break;

		while (1) {
			if (g_bQuit) break;

			sprintf (packet, "%c0I %c%c^%c\0", STX, CR, LF, ETX);
			SendChar(g_hCom, packet, 8);
			FlushFileBuffers(g_hCom);
		
			if (ReadDataFromComm(&dwLen, buf) > 0)
				break;
			//Sleep (25);
		}

		buf[dwLen] = '\0';
		//WriteLog("Receive: %s", buf);

		found = 0;
		for (i=0; i<dwLen; i++)
			if (buf[i] == '0') {
				found = 1;
				break;
			}
		if (found) break;
	}

	sprintf (tmpbuf, "1S          %c%c\0", CR, LF);
	sprintf (packet, "%c%s%c%c\0", STX, tmpbuf, GetCheckSum(tmpbuf), ETX);
	SendPacket(packet, 17);
	WriteLog("End Init");
	return 0;
}



/*int init(void) {
	char tmpbuf[260];
	char packet[260];
	char szData[4096];

	g_MT = '0';
	while (1) {
		if (g_bQuit) break;

		sprintf (tmpbuf, "%cS          %c%c\0", GetMT(), CR, LF);
		sprintf (packet, "%c%s%c%c\0", STX, tmpbuf, GetCheckSum(tmpbuf), ETX);
		SendPacket(packet, 17);

		ReceivePacket(szData);

		if (szData[0] == GetMT()){
			while(1) {
				if (g_bQuit) break;
				ReceivePacket(szData);
				if (szData[2] == 'S') {
					g_MT = szData[1];
					sprintf (packet, "%c\0", szData[1]);
					SendPacket (packet, 1);
					break;
				}
			}
			break;
		}
		else if (szData[0] == NAK)
			g_MT = GetMT();
		else if ((szData[2] == 'I') || (szData[2] == 'S')){
			g_MT = szData[1];
			sprintf (packet, "%c\0", szData[1]);
			SendPacket (packet, 1);
		}
		else{
			sprintf (packet, "%c\0", NAK);
			SendPacket (packet, 1);
		}
	}

	while(1) {
		if (g_bQuit) break;

		g_MT = '0';
		sprintf (packet, "%c0I %c%c^%c\0", STX, CR, LF, ETX);
		SendPacket(packet, 8);

		if ((ReceivePacket(szData) == 1) && (szData[0] == '0')) {
			sprintf (tmpbuf, "1S          %c%c\0", CR, LF);
			sprintf (packet, "%c%s%c%c\0", STX, tmpbuf, GetCheckSum(tmpbuf), ETX);
			SendPacket(packet, 17);
			return 0;
		}
	}
	return 0;
}*/