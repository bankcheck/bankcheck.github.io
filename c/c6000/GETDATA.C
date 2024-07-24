#include <stdio.h>
#include <time.h>
#include <string.h>
#include "c6000.h"

int CheckSum(char *buf)
{
    char crcsum[3], xsum[3];
    char *p;
    unsigned char chksum;
    //char str[1024];

    //WriteLog("檢核資料是否正確...");
    p = buf;
    while (*p != STX && *p != '\0') p++;
    if (*p == '\0') {
        WriteLog("Packet error");
        DumpErrorData(strlen(buf), buf);
        return 0;
    }

    if (buf[0] != STX) {
        WriteLog("Packet error");
        DumpErrorData(strlen(buf), buf);
        return 0;
    }
//skip STX
	p++;

    //strcpy(str, p);
    //strcpy(buf, str);

	//checksum pointer
	buf = p;

    p = strrchr(buf, ETX);

    if (p == NULL)
		p = strrchr(buf, ETB);

    if (p == NULL) {
		WriteLog("Packet error");
        DumpErrorData(strlen(buf), buf);
        return 0;
    }
    p++;
    
	memcpy(crcsum, p, 2);
    crcsum[2] = '\0';
    chksum = 0;

    while (1) {
        if (buf == p) break;
        chksum += *buf;
        buf++;
    }
    //chksum = 256-chksum;
    sprintf(xsum, "%02X", chksum);

	if (strcmp(crcsum, xsum) == 0) {
        //WriteLog("資料檢核碼正確!");
        return 1;
    }
    DumpErrorData(strlen(buf), buf);
    WriteLog("Checksum error! chksum:%s crcsum:%s", xsum, crcsum);
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
    char buf[2048];
	int	nCount;
    DWORD dwLen;
    DWORD i;
	
	szData[0] = '\0';
	nCount = 0;
	dwLen = 0;

    while (1) {
        while (1) {
	        if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
				g_bQuit = TRUE;
			    break;
			}
            if (ReadDataFromComm(&dwLen, buf) > 0)
                break;
        }

        if (g_bDebug) {
            WriteLog("length: %d", dwLen);
            DumpErrorData(dwLen, buf);
        }

        if (g_bQuit) break;

		if (buf[0] == ENQ) {
			WriteLog("Receive ENQ");
			szData[0] = buf[0];
			szData[1] = '\0';			
			return 1;
		}
		else if (buf[0] == NAK) {
			WriteLog("Receive NAK");
			szData[0] = buf[0];
			szData[1] = '\0';
			return 1;
		}
		else if (buf[0] == ACK) {
			WriteLog("Receive ACK");
			szData[0] = buf[0];
			szData[1] = '\0';
			return 1;
		}
		else if (buf[0] == EOT) {
			WriteLog("Receive EOT");
			szData[0] = buf[0];
			szData[1] = '\0';
			return 1;
		}
        else {
            memcpy(&szData[nCount], buf, dwLen);
            nCount += dwLen;
            for (i = 0; i < dwLen; i++) {
                if (buf[i] == STX) {
					found = 0;
				}
                if (buf[i] == ETX) {
					found = 1;
				}
                if (buf[i] == ETB) {
					found = 1;
				}
                if ((buf[i] == LF) && (found == 1)) {
					found = 2;
				}
			}

            if (found < 2) continue;

            szData[nCount] = '\0';
            
			if (g_bDebug) {
                WriteLog("length: %d", nCount);
                DumpErrorData(nCount, szData);
            }
		    //WriteLog("Receive: %s", szData);
			break;
		}
	}

	return nCount;
}
	
int GetData(void)
{
    char cmd[260];
    char function;
    char token[260];
    char szData[1024];

	char LabNo[12];
	char DateTime[15];
	//char unit[10];
	char test[30];
	char result[22];
	//char error[2];

    FILE *fp, *out;
	char fname[260];
	char tmpname[260];
    //time_t t;
    //struct tm *tp;
    char tmpbuf[260];
	char *p;
	char *q;
//	char *ResultType;
	char *packet;
//	char *message;
	char buf[2048];
//	double dResult;
//	double dRate;
	unsigned int i;
	char flag[2];
	char tmpresult[15];

    szData[0] = '\0';
	buf[0] = '\0';

	sprintf(fname, "%s%lx.dat", g_szTempPath, GetTickCount());
	
	if (g_bDebug)
		WriteLog("Write to temp file: %s", fname);

	fp = fopen(fname, "w+b");
	if (fp == NULL) {
		WriteLog("Cannot open file: %s", fname);
		return 1;
	}

	while (ReceivePacket(szData) > 0) {
		if (szData[0] == ENQ){
			WriteLog("Send ACK");
			cmd[0] = ACK;
			cmd[1] = '\0';
			SendChar(g_hCom, cmd, 1);
			FlushFileBuffers(g_hCom);
			continue;
		}

		if (szData[0] == EOT){
			break;
		}
		
		if (CheckSum(szData)) {
			WriteLog("Receive: %s", szData);
			WriteLog("Send ACK");
			cmd[0] = ACK;
			cmd[1] = '\0';
			SendChar(g_hCom, cmd, 1);
			FlushFileBuffers(g_hCom);
//c6000 new code
			p = szData;
			while ((*p != '\0') && (*p != ETX) && (*p != ETB)) {

				if ((*p == STX) && (*p+2 != '\0')) {
					p+=2;
					strcat(buf, p);
				}

				if (*p == CR) {
					//WriteLog("packet: %s", buf);
					*p = '\0';
					fwrite(buf, strlen(buf), sizeof(char), fp);
					fflush(fp);
					strcpy(buf, p+1);
				}

				if ((*(p+1) == ETX) || (*(p+1) == ETB))
					for (i=0; i < strlen(buf); i++) {
						if ((buf[i] == ETX) || (buf[i] == ETB))
							buf[i] = '\0';
					}

				p++;
			}
//c6000 new code
		} else {
			WriteLog("Send NAK");
			cmd[0] = NAK;
			cmd[1] = '\0';
			SendChar(g_hCom, cmd, 1);
			FlushFileBuffers(g_hCom);
            WriteLog("Packet rejected: %s", szData);
		}
	} 
	
	if (g_bDebug)
		WriteLog("Process temp file");
	
	packet = malloc(2048);
	packet[0] = '\0';
	fseek(fp, 0, SEEK_SET);
	while (1) {
		if (fgets(buf, 2048, fp) == NULL) break;

//		if (buf[0] == EOT) break;

		WriteLog("Content: %s", buf);
/*
		message = buf;
		while ((*message != STX) && (*message != '\0'))
			message++;
		
		message+=2;

		strcat(packet, message);

		p = strrchr(packet, ETX);
		if (p == NULL) {
			sprintf(buf, "%c\0", ETB);
 			packet = strtok(packet, buf);
			continue;
		}
*/
		strcpy(packet, buf);
		function = packet[0];
//Header information
/*
		if (function == 'H') {
			q = strrchr(packet, '|');
			q++;
			strcpy(DateTime, q);
			DateTime[14] = '\0';
			//ParseDelimiter(packet, 13, '|', DateTime);
		}
*/
		
//patient information
		if (function == 'O') {
			ParseDelimiter(packet, 3, '|', LabNo);
			TrimSpace(LabNo);
		    strtok(LabNo, "\"*/:<>?\\|");
			ParseDelimiter(packet, 23, '|', DateTime);
			DateTime[14] = '\0';
		}

//Query
		if ((function == 'Q') && (g_mode == 2)){
			ParseDelimiter(packet, 3, '|', token); 
			ParseDelimiter(token, 3, '^', LabNo);
			strtok(LabNo, "\"*/:<>?\\|^");
			TrimSpace(LabNo);
			
			q = strchr(token+2, '^');
			SendFile(1, LabNo, q+1);
		}
		
//Result
		if (function == 'R') {
			if (LabNo[0] != '\0') {
				ParseDelimiter(packet, 4, '|', tmpresult);
				ParseDelimiter(packet, 7, '|', flag);
				
				q = strrchr(tmpresult, '^');
			
				if (q != NULL) {
					q++;
					strcpy(tmpresult, q);
				}

				if (strcmp(flag, "HH") == 0) {
					result[0] = '>';
					result[1] = '\0';
					strcat(result, tmpresult);
				} else if (strcmp(flag, "LL") == 0) {
					result[0] = '<';
					result[1] = '\0';
					strcat(result, tmpresult);
				} else {
					strcpy(result, tmpresult);
				}

				ParseDelimiter(packet, 3, '|', token);
				ParseDelimiter(token, 4, '^', test);
				strtok(test, "//");
				
				TrimSpace(test);
				TrimSpace(result);
				ConvertRCode(test);

				/*
				dRate = ConvertRate(test);
				if (dRate == 1) {
					sprintf(tmpbuf, "%s|%s\n", test, result);
					
					//if (g_bDebug)
						WriteLog("Result: %s", tmpbuf);

				} else {
					RemoveSign(result);
					dResult = atof(result) * dRate;
					sprintf(tmpbuf, "%s|%f\n", test, dResult);

					//if (g_bDebug)
						WriteLog("Result: %s", tmpbuf);
				} 
				*/

				sprintf(tmpbuf, "%s|%s\n", test, result);
				WriteLog("Result: %s", tmpbuf);

				sprintf(tmpname, "%s%s_%s", g_szOutBoxPath, LabNo, DateTime);

				if (g_bDebug)
					WriteLog("Save to %s", tmpname);

				out = fopen(tmpname, "a+");
				if (out == NULL) {
		            if (g_bDebug)
						WriteLog("Cannot open file: %s", tmpname);
				} else {
					fwrite(tmpbuf, strlen(tmpbuf), sizeof(char), out);
					fclose(out);
				}
			}
		}
		packet[0] = '\0';
	}

	fclose(fp);

	if (g_bDebug == FALSE)
		unlink(fname);
	
	return 0;
}

