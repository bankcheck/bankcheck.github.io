#include <stdio.h>
#include <time.h>
#include "Ruby.h"

int RemoveSpace(char *buf)
{
    char str[2048];
    char *p;

    p = buf;
    while (*p == ' ' || *p == '\t' || *p =='\r' || *p =='\n') p++;
    strcpy(str, p);
    strcpy(buf, str);
    return 0;
}

int RemoveEndSpace(char *buf)
{
    int len;

    len = strlen(buf);
    len--;
    while (len >= 0) {
        if (buf[len] != ' ' && buf[len] != '\t' && buf[len] != '\r' && buf[len] != '\n')
            break;
        len--;
    }
    if (len < 0)
       buf[0] = '\0';
    else
       buf[len+1] = '\0';
    return 0;
}

int TrimSpace(char *buf)
{
    RemoveSpace(buf);
    RemoveEndSpace(buf);
    return 0;
}

int DumpErrorData(int len, char *buf)
{
    char *p;
    FILE *fp;
    char fname[260];
    int i;
    time_t t;
    struct tm *tp;

    time(&t);
    tp = localtime(&t);
    sprintf(fname, "%s%02d%02dERR.LOG", g_szLogPath, tp->tm_mon+1, tp->tm_mday);
    fp = fopen(fname, "ab");
    if (fp != NULL) {
        fprintf(fp, "%02d:%02d:%02d\r\n",
                tp->tm_hour, tp->tm_min, tp->tm_sec);
        fprintf(fp, "Data (%d):", len);
        p = buf;
        for (i = 0; i < len; i++)
            fprintf(fp, " %02X", 0x00FF & *p++);
        fprintf(fp, "\r\nValue: ");
        p = buf;
        for (i = 0; i < len; i++) {
            if (*p < 20)
                fprintf(fp, "<%d>", 0x00FF & *p++);
            else
                fprintf(fp, "%c", *p++);
        }
        fprintf(fp, "\r\n");
        fprintf(fp, "\r\n");
        fflush(fp);
        fclose(fp);
    }
    else
        WriteLog("Can't open %s", fname);
    return 0;
}

int AddBslash(char *s)
{
    int len;

    len = strlen(s);
    if (len == 0) return 0;
    if (s[len-1] == '\\' || s[len-1] == '/') return 0;
    s[len++] = '\\';
    s[len] = '\0';
    return 1;
}

int GetChar(HANDLE hCom, char *buf)
{
    DWORD dwLen;
    COMSTAT cs;
    DWORD dwError, dwErrorFlag;
    int rc;

    if (hCom == INVALID_HANDLE_VALUE)
        return 0;

    dwLen = 0;
    ClearCommError(hCom, &dwErrorFlag, &cs);
    if (cs.cbInQue == 0)
        return 0;
    rc = ReadFile(hCom, buf, cs.cbInQue, &dwLen, &g_o);
    if (!rc) {
        dwError = GetLastError();
        if (dwError == ERROR_IO_PENDING) {
            while (!GetOverlappedResult(hCom, &g_o, &dwLen, TRUE)) {
                dwError = GetLastError();
                if (dwError != ERROR_IO_INCOMPLETE) {
                    ClearCommError(hCom, &dwErrorFlag, &cs);
                    WriteLog("ReadFile() failed, code %ld, flag %ld", dwError, dwErrorFlag);
                    break;
                }
            }
        }
        else {
            ClearCommError(hCom, &dwErrorFlag, &cs);
            WriteLog("ReadFile() failed, code %ld, flag %ld", dwError, dwErrorFlag);
        }
    }
    return dwLen;
}

int SendChar(HANDLE hCom, char *buf, int len)
{
    DWORD dwLen;
    int rc;
    COMSTAT cs;
    DWORD dwError, dwErrorFlag;

    if (hCom == INVALID_HANDLE_VALUE)
        return 0;

    rc = WriteFile(hCom, buf, len, &dwLen, &g_o);
    if (!rc) {
        dwError = GetLastError();
        if (dwError == ERROR_IO_PENDING) {
            while (!GetOverlappedResult(hCom, &g_o, &dwLen, TRUE)) {
                dwError = GetLastError();
                if (dwError != ERROR_IO_INCOMPLETE) {
                    ClearCommError(hCom, &dwErrorFlag, &cs);
                    WriteLog("WriteFile() failed, code %ld, flag %ld", dwError, dwErrorFlag);
                    break;
                }
            }
        }
        else {
            ClearCommError(hCom, &dwErrorFlag, &cs);
            WriteLog("WriteFile() failed, code %ld, flag %ld", dwError, dwErrorFlag);
        }
    }
    return rc;
}

int ReadDataFromComm(DWORD *pdwLen, char *buf)
{
    COMSTAT         cs;
    DWORD           dwLen;
    DWORD           dwError, dwErrorFlag;
    DWORD           dwEvtMask;
    HANDLE          WaitHandle[5];

    *pdwLen = 0;
    if (SetCommMask(g_hCom, EV_RXCHAR | EV_CTS) == 0) {
        dwError = GetLastError();
        ClearCommError(g_hCom, &dwErrorFlag, &cs);
        WriteLog("SetCommMask() failed, code %ld, flag %ld", dwError, dwErrorFlag);
        return 0;
    }
    WaitCommEvent(g_hCom, &dwEvtMask, &g_o);
    dwError = GetLastError();
    if (dwError == ERROR_IO_PENDING) {
        WriteLog("Waiting for incoming data...");
        WaitHandle[0] = g_hServerStopEvent;
        WaitHandle[1] = g_o.hEvent;
        while (1) {
            if (g_dwRecvWait != 0) {
                if (WaitForMultipleObjects(2, WaitHandle, FALSE, g_dwRecvWait) == WAIT_TIMEOUT) {
                    if (g_bDebug)
                        WriteLog("Timeout");
                    return 0;
                }
            }
            else
                WaitForMultipleObjects(2, WaitHandle, FALSE, INFINITE);
            if (g_bQuit)
                break;
            if (GetOverlappedResult(g_hCom, &g_o, &dwLen, FALSE))
                break;
            dwError = GetLastError();
            if(dwError != ERROR_IO_INCOMPLETE) {
                ClearCommError(g_hCom, &dwErrorFlag, &cs);
                WriteLog("WaitCommEvent() failed, code %ld, flag %ld", dwError, dwErrorFlag);
                return 0;
            }
        }
    }
    else if (dwError != ERROR_SUCCESS) {
        ClearCommError(g_hCom, &dwErrorFlag, &cs);
        WriteLog("WaitCommEvent() failed, code %ld, flag %ld", dwError, dwErrorFlag);
        return 0;
    }
    if (dwEvtMask & EV_RXCHAR) {
        *pdwLen = GetChar(g_hCom, buf);
        return 1;
    }
    return 0;
}

void GetToken(char *str, char *token, int no)
{
    char *p;
    int i;

    i = 1;
    p = str;
    while (i < no) {
        if (*p == ',')
            i++;
        if (*p == '\0') break;
        p++;
    }
    if (i != no) {
        token[0] = '\0';
        return;
    }
    i = 0;
    token[i] = '\0';
    while (1) {
        if (*p == ',') break;
        if (*p == '\0') break;
        if (*p == '\r' || *p == '\n') break;
        token[i++] = *p++;
    }
    token[i] = '\0';
    TrimSpace(token);
    return;
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