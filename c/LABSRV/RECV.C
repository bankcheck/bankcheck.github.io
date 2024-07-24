#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "labsrv.h"

DWORD RecvThreadProc(LPVOID pParm)
{
    char buf[1024];
    char *p;
    int no;
    FILE *fp;
    char fname[260], tmpname[260];
    char prog[60], sid[60];

_TRY_EXCEPTION_BLOCK_BEGIN()

    no = (int)pParm;
    WriteLog(no, "Accept");

    g_Client[no].tick = GetTickCount();
    g_Client[no].bCheck = TRUE;

    sprintf(buf, "OK\r\n");
    if (PutLine(no, buf) == 0) {
        WriteLog(no, "Close");
	g_Client[no].bCheck = FALSE;
	closesocket(g_Client[no].s);
	g_Client[no].s = SOCKET_ERROR;
	ExitThread(0);
	return 0;
    }

    if (GetLine(no, buf, 1024) == 0) {
        WriteLog(no, "Close");
	g_Client[no].bCheck = FALSE;
	closesocket(g_Client[no].s);
	g_Client[no].s = SOCKET_ERROR;
	ExitThread(0);
	return 0;
    }

    WriteLog(no, "CMD: %s", buf);
    p = strtok(buf, " ,\t\r\n");
    if (p == NULL) {
        sprintf(buf, "ERR, no LAB\r\n");
        PutLine(no, buf);
        WriteLog(no, "Close");
	g_Client[no].bCheck = FALSE;
	closesocket(g_Client[no].s);
	g_Client[no].s = SOCKET_ERROR;
	ExitThread(0);
	return 0;
    }

    if (strcmp(p, "LAB") != 0) {
        sprintf(buf, "ERR, token (%s), need LAB\r\n", p);
        PutLine(no, buf);
        WriteLog(no, "Close");
	g_Client[no].bCheck = FALSE;
	closesocket(g_Client[no].s);
	g_Client[no].s = SOCKET_ERROR;
	ExitThread(0);
	return 0;
    }

    p = strtok(NULL, " ,\t\r\n");
    if (p == NULL) {
        sprintf(buf, "ERR, no PROG\r\n");
        PutLine(no, buf);
        WriteLog(no, "Close");
	g_Client[no].bCheck = FALSE;
	closesocket(g_Client[no].s);
	g_Client[no].s = SOCKET_ERROR;
	ExitThread(0);
	return 0;
    }
    strcpy(prog, p);

    p = strtok(NULL, " ,\t\r\n");
    if (p == NULL) {
        sprintf(buf, "ERR, no SID\r\n");
        PutLine(no, buf);
        WriteLog(no, "Close");
	g_Client[no].bCheck = FALSE;
	closesocket(g_Client[no].s);
	g_Client[no].s = SOCKET_ERROR;
	ExitThread(0);
	return 0;
    }
    strcpy(sid, p);

    sprintf(tmpname, "%sTEMP\\%08X%02d", g_szRootPath, GetTickCount(), no);
    fp = fopen(tmpname, "wb");
    if (fp == NULL) {
        sprintf(buf, "ERR, can't open file\r\n");
        PutLine(no, buf);
        WriteLog(no, "Can't open file %s", tmpname);
        WriteLog(no, "Close");
	g_Client[no].bCheck = FALSE;
	closesocket(g_Client[no].s);
	g_Client[no].s = SOCKET_ERROR;
	ExitThread(0);
	return 0;
    }

    sprintf(buf, "OK\r\n");
    if (PutLine(no, buf) == 0) {
        fclose(fp);
        WriteLog(no, "Close");
	g_Client[no].bCheck = FALSE;
	closesocket(g_Client[no].s);
	g_Client[no].s = SOCKET_ERROR;
	ExitThread(0);
	return 0;
    }

    while (1) {
        if (GetLine(no, buf, 1024) == 0)
            break;
        p = strtok(buf, " ,\t\r\n");
	if (p == NULL) continue;
        if (strcmp(p, "DATA") == 0) {
            p = strtok(NULL, "\r\n");
            if (p != NULL)
                fprintf(fp, "%s\r\n", p);
            sprintf(buf, "OK\r\n");
            PutLine(no, buf);
            continue;
        }
        if (strcmp(p, "END") == 0) {
            sprintf(buf, "OK\r\n");
            PutLine(no, buf);
            break;
        }
        WriteLog(no, "Unknown cmd: %s", p);
    }
    g_Client[no].bCheck = FALSE;
    closesocket(g_Client[no].s);
    g_Client[no].s = SOCKET_ERROR;
    WriteLog(no, "Close");

    fclose(fp);

    if (g_bBackup) {
        time_t t;
        struct tm *tp;
        char szToday[200];
        char str[200];

        time(&t);
        tp = localtime(&t);
        strftime(szToday, 200, "%y%m%d", tp);
        sprintf(buf, "%sBACKUP\\%s", g_szRootPath, szToday);
        CreateDirectory(buf, NULL);
        strftime(str, 200, "%H%M%S", tp);
        sprintf(fname, "%sBACKUP\\%s\\%s.%s.%s.txt", g_szRootPath,
                            szToday, str, prog, sid);
        unlink(fname);
        WriteLog(no, "Copy %s to %s", tmpname, fname);
        CopyFile(tmpname, fname, FALSE);
    }
    sprintf(fname, "%s%s\\INBOX\\%s", g_szDataPath, prog, sid);
    unlink(fname);
    WriteLog(no, "Move %s to %s", tmpname, fname);
    MoveFile(tmpname, fname);
    ExitThread(0);

_TRY_EXCEPTION_BLOCK_END(1)

    return 1;
}
