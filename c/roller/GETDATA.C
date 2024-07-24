#include <stdio.h>
#include <string.h>
#include <time.h>
#include "roller.h"

int CheckSum(char *buf)
{
    return 1;
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

int GetData(void)
{
    char buf[2048], cmd[260];
    FILE *fp, *out;
    char fname[260], tmpname[260];
    DWORD dwLen;
    //int function;
	//char tmpfun[2];
    char token[5];
    char tmpbuf[260];
    BOOL bFunFlag = FALSE;
    //char szSampleID[260];
    //char Test[260];
    char szData[1024];
    int nCount;
    int found;
 	struct tm *tp;
	DWORD i;

	char sid[16];
	char DateTime[14];
	char test[30];
	int	 result;
	char *p;
	time_t t;

    nCount = 0;
    szData[0] = '\0';

	sprintf(fname, "%s%lx.dat", g_szTempPath, GetTickCount());
	WriteLog("Write to temp file: %s", fname);
	fp = fopen(fname, "w+b");
	if (fp == NULL) {
		WriteLog("Cannot open file: %s", fname);
		return 1;
	}

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

//Change here for different protocol

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

		p = szData;
		while(*p != '\0'){
			if (*p == STX)
				break;
			else
				p++;
		}

		strcpy(szData, p);

        if (CheckSum(szData)) {

            WriteLog("Packet accepted: %s", szData);
			fwrite(szData, strlen(szData), sizeof(char), fp);
			fflush(fp);

			szData[0]='\0';
			cmd[0] = ACK;
			cmd[1] = '\0';
			SendChar(g_hCom, cmd, 1);
			FlushFileBuffers(g_hCom);
        }
        else {
            WriteLog("Packet rejected: %s", szData);

            cmd[0] = NAK;
	        cmd[1] = '\0';
		    SendChar(g_hCom, cmd, 1);
		    FlushFileBuffers(g_hCom);
        }
        nCount = 0;
        szData[0] = '\0';
        
		sid[0] = '\0';
		DateTime[0] = '\0';
		test[0] = '\0';
		token[0] = '\0';

		WriteLog("Processing temp file");
		fseek(fp, 0, SEEK_SET);
		while (1) {
			if (fgets(buf, 2048, fp) == NULL) break;
			WriteLog("Content: %s", buf);

			time(&t);
			tp = localtime(&t);
			if (tp != NULL) {
				sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
				tp->tm_hour, tp->tm_min, tp->tm_sec);
			}

			p = buf;
				
			p += 4;

			strncpy(sid, p, 15);
			sid[15] = '\0';
			TrimSpace(sid);

			p += 21;

			strncpy(token, p, 4);
			token[4] = '\0';
			TrimSpace(token);
			result = atoi(token);

			sprintf(tmpbuf, "ESR|%d\n", result);
			WriteLog("Result: %s", tmpbuf);

			sprintf(tmpname, "%s%s_%s", g_szOutBoxPath, sid, DateTime);
			WriteLog("Save to %s", tmpname);
			out = fopen(tmpname, "w");
				
			if (out == NULL)
				WriteLog("Cannot open file: %s", tmpname);
			else {
				fwrite(tmpbuf, strlen(tmpbuf), sizeof(char), out);
				fclose(out);
			}
		}

		fclose(fp);
		if (g_bDebug == FALSE)
			unlink(fname);

		sprintf(fname, "%s%lx.dat", g_szTempPath, GetTickCount());
		WriteLog("Write to temp file: %s", fname);
		fp = fopen(fname, "w+b");
		if (fp == NULL) {
			WriteLog("Cannot open file: %s", fname);
			//DumpErrorData(strlen(fname), fname);
			return 1;
		}

    }
	
	return 0;
}

