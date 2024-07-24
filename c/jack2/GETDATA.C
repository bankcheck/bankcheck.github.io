#include <stdio.h>
#include <time.h>
#include "jack2.h"

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

	return nCount;
}
	
int GetData(void)
{
    char cmd[260];
    char szData[1024];
    char buf[1024];

	char LabNo[17];
	char Date[9];
	char Time[7];
	char result[7];

    FILE *out;
	char fname[260];
    char tmpbuf[260];
    char sample_no[4];

    szData[0] = '\0';

	if (ReceivePacket(szData) > 1) {

//Result Message
		if (szData[1] == '2') {
			strcpy(buf, szData);
			ParseDelimiter(buf, 9, ',', LabNo);
			TrimSpace(LabNo);

			strcpy(buf, szData);
			ParseDelimiter(buf, 16, ',', Date);

			strcpy(buf, szData);
			ParseDelimiter(buf, 17, ',', Time);

			strcpy(buf, szData);
			ParseDelimiter(buf, 3, ',', sample_no);

			if (strlen(LabNo) == 0) {
				sprintf(fname, "%s%s_%s%s", g_szOutBoxPath, sample_no, Date, Time);
			} else {
				sprintf(fname, "%s%s_%s%s", g_szOutBoxPath, LabNo, Date, Time);
			}

			out = fopen(fname, "w");
			WriteLog("Save to %s", fname);

			strcpy(buf, szData);
			ParseDelimiter(buf, 13, ',', result);
			TrimSpace(result);

			sprintf(tmpbuf, "%s|%s\n", g_testcode, result);
			WriteLog("Result: %s", tmpbuf);

			fwrite(tmpbuf, strlen(tmpbuf), sizeof(char), out);
			fclose(out);

//Send ACK
			sprintf(cmd, "%c%c%c\0", STX, ACK, ETX);
			WriteLog("ACK");
			SendPacket(cmd);

		} else {
//Send NAK
			sprintf(cmd, "%c%c%c\0", STX, NAK, ETX);
			WriteLog("NAK");
			SendPacket(cmd);

		}	
	}

	return 0;
}

