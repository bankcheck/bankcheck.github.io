#include <stdio.h>
#include <time.h>
#include "access.h"

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
        WriteLog("Packet Error#1");
        DumpErrorData(strlen(buf), buf);
        return 0;
    }

    if (buf[0] != STX) {
        WriteLog("Packet Error#2");
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
		WriteLog("Packet Error#3");
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
    char buf[4096];
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
			WriteLog("receive ENQ");
			szData[0] = buf[0];
			szData[1] = '\0';			
			return 1;
		}
		else if (buf[0] == NAK) {
			WriteLog("receive NAK");
			szData[0] = buf[0];
			szData[1] = '\0';
			return 1;
		}
		else if (buf[0] == ACK) {
			WriteLog("receive ACK");
			szData[0] = buf[0];
			szData[1] = '\0';
			return 1;
		}
		else if (buf[0] == EOT) {
			WriteLog("receive EOT");
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
                DumpErrorData(nCount, szData);
            }
            
			//WriteLog("length: %d", nCount);
		    WriteLog("receive: %s", szData);
			break;
		}
	}

	return nCount;
}
	
int GetData(void)
{
    char cmd[260];
    char function;
    //char token[4096];
    char szData[4096];

	char LabNo[12];
	char DateTime[14];
	//char unit[10];
	char test[120];
	char result[22];
	//char error[2];

    FILE *fp, *out;
	char fname[260];
	char tmpname[260];
    time_t t;
    struct tm *tp;
    char tmpbuf[260];
	char *p;
	char buf[4096];
//	int i;
	double dResult;
	char *packet;
	char *message;

    szData[0] = '\0';

	sprintf(fname, "%s%lx.dat", g_szTempPath, GetTickCount());
	WriteLog("Temp file: %s", fname);
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
            WriteLog("Packet accepted");
			fwrite(szData, strlen(szData), sizeof(char), fp);
			fflush(fp);
			WriteLog("Send ACK");
			cmd[0] = ACK;
			cmd[1] = '\0';
			SendChar(g_hCom, cmd, 1);
			FlushFileBuffers(g_hCom);
		} else {
			WriteLog("Send NAK");
			cmd[0] = NAK;
			cmd[1] = '\0';
			SendChar(g_hCom, cmd, 1);
			FlushFileBuffers(g_hCom);
            WriteLog("Packet rejected");
		}
	}

	WriteLog("Process temp file");
	packet = malloc(2048);
	packet[0] = '\0';
	fseek(fp, 0, SEEK_SET);
	while (1) {
		if (fgets(buf, 2048, fp) == NULL) break;
		if (buf[0] == EOT) break;
		WriteLog("Content: %s", buf);

		message = buf;
		while ((*message != STX) && (*message != '\0'))
			message++;
		
		message+=2;

		function = *message;

		if (function == 'H') {
			out = NULL;
		}

		if (function == 'O') {
			//ParseDelimiter(message, 23, '|', DateTime);
			ParseDelimiter(message, 3, '|', cmd);
			p = strtok(cmd, "^ \"*/:<>?\\|!");

			strcpy(LabNo, p);

			time(&t);
			tp = localtime(&t);
			if (tp != NULL) {
				sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
					tp->tm_hour, tp->tm_min, tp->tm_sec);
			}
		}

		if (function == 'R') {
			if (LabNo != NULL) {
				ParseDelimiter(message, 3, '|', cmd);
				
				ParseDelimiter(cmd, 4, '^', test);

				ParseDelimiter(message, 4, '|', result);

				strtok(result, "!");

				TrimSpace(result);

				ConvertRCode(test);  

				dResult = atof(result);
				if ((dResult == 0) && (result[0] != '0')) {
					sprintf(tmpbuf, "%s|%s\n", test, result);
					WriteLog("Result: %s", tmpbuf);
				} else {
					dResult = dResult * ConvertRate(test);

					sprintf(tmpbuf, "%s|%f\n", test, dResult);

					WriteLog("Result: %s", tmpbuf);
				} 

				if (out == NULL) {
					sprintf(tmpname, "%s%s_S%s", g_szOutBoxPath, LabNo, DateTime);
					WriteLog("Save to: %s", tmpname);
					out = fopen(tmpname, "w");
				}

				if (out == NULL)
					WriteLog("Cannot open file: %s", tmpname);
				else
					fwrite(tmpbuf, strlen(tmpbuf), sizeof(char), out);
			}
		}
/*
		if (function == 'C') {
			if (LabNo != NULL) {
				ParseDelimiter(message, 4, '|', cmd);
				strcpy(test, cmd);

				sprintf(tmpbuf, "%s|FLAG\n", test);
				WriteLog("Result: %s", tmpbuf);

				if (out == NULL) {
					sprintf(tmpname, "%s%s_%s", g_szOutBoxPath, LabNo, DateTime);
					WriteLog("Save to: %s", tmpname);
					out = fopen(tmpname, "w");
				}

				if (out == NULL)
					WriteLog("Cannot open file: %s", tmpname);
				else
					fwrite(tmpbuf, strlen(tmpbuf), sizeof(char), out);
			}
		}
*/
//Query
		if (function == 'Q') {
			ParseDelimiter(message, 3, '|', cmd);
			ParseDelimiter(cmd, 2, '^', LabNo);
			SendFile(LabNo);
		}

		if (function == 'L') {
			if (out != NULL)
				fclose(out);

			break;
		}
	}

	fclose(fp);
	if (g_bDebug == FALSE)
		unlink(fname);
	
	return 0;
}