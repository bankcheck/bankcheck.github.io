#include <stdio.h>
#include <time.h>
#include "Dim2.h"

int CheckSum(char *buf)
{
    char crcsum[3], xsum[3];
    char *p;
    unsigned char chksum;
    //char str[1024];

    p = buf;
    while (*p != STX && *p != '\0') p++;
    if (*p == '\0') {
        WriteLog("Invalid packet");
        DumpErrorData(strlen(buf), buf);
        return 0;
    }

    if (buf[0] != STX) {
        WriteLog("Invalid packet");
        DumpErrorData(strlen(buf), buf);
        return 0;
    }
//skip STX
	p++;

    //strcpy(str, p);
    //strcpy(buf, str);

	//checksum pointer
	buf = p;

    p = strrchr(buf, FS);
    if (p == NULL) {
	WriteLog("Invalid packet");
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

char *ParseDelimiter (char *str, int idx, char delimiter, char *buf)
{
    char *p1, *p2;
    int i;

    p1 = str;
    for (i = 0; i < idx; i++) {
        if (i)
            p1 = p2 + 1;
        p2 = strchr (p1, delimiter);
        if (p2 == NULL) {
            if (i == (idx - 1))
                p2 = str + strlen(str);
            else
                return NULL;
	}
    }
    memcpy(buf, p1, p2 - p1);
    buf[p2-p1] = '\0';
    return buf;
}

void Cobol_Format(char *format)
{
    char tmprtn[20];

    if (isdigit(format[0]) || format[0] == '.')
	sprintf(tmprtn, "%010.3f", atof(format));
    else
	sprintf(tmprtn, "%-10.10s", format);
    strcpy(format, tmprtn);
    return;
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
		
			if (g_buffer[0] != '\0') {
				WriteLog("Resend %s...", g_buffer);
				SendChar(g_hCom, buf, strlen(buf));
				FlushFileBuffers(g_hCom);
			}
			
			return 1;
		}
		else if (buf[0] == NAK) {
			WriteLog("Receive NAK");
			szData[0] = buf[0];
			szData[1] = '\0';
		
			if (g_buffer[0] != '\0') {
				WriteLog("Resend %s...", g_buffer);
				SendChar(g_hCom, buf, strlen(buf));
				FlushFileBuffers(g_hCom);
			}
			
			return 1;
		}
		else if (buf[0] == ACK) {
			WriteLog("Receive ACK");
			szData[0] = buf[0];
			szData[1] = '\0';
			return 1;
		}
        else {
            memcpy(&szData[nCount], buf, dwLen);
            nCount += dwLen;
            found = 0;
            for (i = 0; i < dwLen; i++) {
                if (buf[i] == ETX) {
					found = 1;
					break;
				}
			}
            if (found == 0) continue;
            szData[nCount] = '\0';
            if (g_bDebug) {
                WriteLog("length: %d", nCount);
                DumpErrorData(nCount, szData);
            }
		    WriteLog("Receive: %s", szData);
			break;
		}
	}

	return nCount;
}
	
int GetData(void)
{
    char cmd[260];
    char function;
    char token[260], value[260];
    char szData[1024];
    DWORD i;

	char LabNo[12];
	char DateTime[14];
	char unit[10];
	char error[2];
	DWORD TestCount;

    FILE *out;
	char fname[260];
    time_t t;
    struct tm *tp;
    char tmpbuf[260];
    szData[0] = '\0';

	if (ReceivePacket(szData) > 1) {

		if (CheckSum(szData)) {
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
		}

		function = szData[1];

//Poll
		if (function == 'P') {
			ParseDelimiter(szData, 4, FS, token);
//Send Request
			if ((token[0] == '1') && (g_mode == 1))
				SendData();
			else
				NoSend();
		}

//Request Acceptance
		if (function == 'M') {
			ParseDelimiter(szData, 2, FS, token);
//Accepted
			if (token[0] == 'A') {
				char bakname[260];
				char drive[_MAX_DRIVE];
				char dir[_MAX_DIR];
				char name[_MAX_FNAME];
				char ext[_MAX_EXT];

				time(&t);
				tp = localtime(&t);
				if (g_bBackupInbox) {
					if (tp != NULL) {
						_splitpath(g_fname, drive, dir, name, ext);
						sprintf(bakname, "%s%s%s\0", g_szBackupInBoxPath,name, ext);
						WriteLog("Moving file from %s to %s", g_fname, bakname);
						CopyFile(g_fname, bakname, FALSE);
					}
					DeleteFile(g_fname);
				}
				g_buffer[0] = '\0';
				g_fname[0] = '\0';
			}
//Rejected
			if (token[0] == 'R') {
//				char *name;
//				char bakname[260];

				ParseDelimiter(szData, 3, FS, token);
				WriteLog("Request Error, Reason Code: %s", token);

				/*time(&t);
				tp = localtime(&t);
				if (tp != NULL) {
					sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
						tp->tm_hour, tp->tm_min, tp->tm_sec);
					name = strrchr(g_fname, '_');
					sprintf(bakname, "%s%s%s\0", g_szInBoxPath, DateTime, name);
					WriteLog("Moving file from %s to %s", g_fname, bakname);
					CopyFile(g_fname, bakname, FALSE);
				}
				DeleteFile(g_fname);*/
				g_buffer[0] = '\0';
				g_fname[0] = '\0';
			}
		}

//Query Message
		if (function == 'I') {
			ParseDelimiter(szData, 2, FS, token);
			WriteLog("Receive Query Message: %s", token);
			sprintf(fname, "%s%s", g_szInBoxPath, token);
			if (!SendFile(fname)){
				WriteLog("File not found: %s", fname);
				sprintf(cmd, "N%c", FS);
				sprintf(tmpbuf, "%c%s%02X%c", STX, cmd, GetCheckSum(cmd), ETX);
				SendPacket(tmpbuf);
			}
		}

//Result Message
		if (function == 'R') {
			ParseDelimiter(szData, 4, FS, LabNo);
			strtok(LabNo, "\"*/:<>?\\|");

			WriteLog("LabNo: %s", LabNo);
			if (strlen(LabNo) == 0) {
				WriteLog("Error: Unknown LabNo: %s", LabNo);
				sprintf(cmd, "M%cR%c1%c", FS, FS, FS);
				sprintf(tmpbuf, "%c%s%02X%c", STX, cmd, GetCheckSum(cmd), ETX);
				SendPacket(tmpbuf);
				return 0;
			}

			ParseDelimiter(szData, 8, FS, token);
			sprintf(DateTime, "20%c%c", token[10], token[11]);
			sprintf(value, "%c%c", token[8], token[9]);
			strcat(DateTime, value);
			if (token[6] == ' ')
				token[6] = '0'; 
			sprintf(value, "%c%c", token[6], token[7]);
			strcat(DateTime, value);
			sprintf(value, "%c%c", token[4], token[5]);
			strcat(DateTime, value);
			sprintf(value, "%c%c", token[2], token[3]);
			strcat(DateTime, value);
			sprintf(value, "%c%c", token[0], token[1]);
			strcat(DateTime, value);
		
			ParseDelimiter(szData, 11, FS, token);
			TestCount = atoi(token);
			sprintf(fname, "%s%s_%s", g_szOutBoxPath, LabNo, DateTime);
			out = fopen(fname, "w");
			WriteLog("Save to %s", fname);

			//Prepare accept packet
			sprintf(cmd, "M%cA%c%c", FS, FS, FS);

			for (i=0;i<TestCount;i++) {
				ParseDelimiter(szData, 12+4*i, FS, token);
				ParseDelimiter(szData, 13+4*i, FS, value);
				ParseDelimiter(szData, 14+4*i, FS, unit);
				ParseDelimiter(szData, 15+4*i, FS, error);

				TrimSpace(error);
				if (strlen(error) > 0) {
					WriteLog("Result error, error code: %s", error);
				}

				TrimSpace(token);
				TrimSpace(value);
				ConvertRCode(token);      
                    
				sprintf(tmpbuf, "%s|%s\n", token, value);
				WriteLog("Result: %s", tmpbuf);

				if (out == NULL) {
					WriteLog("Cannot open file: %s", fname);

					//Prepare reject packet
					sprintf(cmd, "M%cR%c1%c", FS, FS, FS);
				} else
					fwrite(tmpbuf, strlen(tmpbuf), sizeof(char), out);
			}
			fclose(out);

			//send packet
			sprintf(tmpbuf, "%c%s%02X%c", STX, cmd, GetCheckSum(cmd), ETX);
			SendPacket(tmpbuf);
		}

//Calibration
		if (function == 'C') {
			sprintf(cmd, "M%cA%c%c", FS, FS, FS);
			sprintf(tmpbuf, "%c%s%02X%c", STX, cmd, GetCheckSum(cmd), ETX);
			SendPacket(tmpbuf);
		}

	}

	return 0;
}

