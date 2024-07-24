#include <stdarg.h>
#include <stdio.h>
#include <time.h>
#include "phadia.h"
#include "service.h"

typedef struct {
    char  szProgID[40];
    char  szPort[16];
    char  szBuf[200];
} MSG_DATA;

void WriteLog(char *fmt, ...)
{
    char buf[1024];
    va_list marker;
    char fname[260];
    FILE *fp;
    time_t t;
    struct tm *tp;
    static char szOldMsg[1024];
    char *p;

    va_start(marker, fmt);
    vsprintf(buf, fmt, marker);
    va_end(marker);

    if (strcmp(szOldMsg, buf) == 0) return;
    strcpy(szOldMsg, buf);

    p = strtok(buf, "\r\n");
    if (p == NULL)
        *p = '\0';

    if (g_bLog == FALSE) return;

    time(&t);
    tp = localtime(&t);
    if (tp != NULL) {
        sprintf(fname, "%s%02d%02d.log", g_szLogPath,
                        tp->tm_mon+1, tp->tm_mday);
        fp = fopen(fname, "at");
        if (fp != NULL) {
            fprintf(fp, "%02d:%02d:%02d %s\n", tp->tm_hour, tp->tm_min, tp->tm_sec, buf);
            fclose(fp);
        }
    }
    return;
}

VOID AddToEventLog(WORD type, LPSTR lpszMsg, ...)
{
    HANDLE  hEventSource;
    char buf[1024];
    va_list marker;
    LPSTR  lpszStrings[2];

    va_start(marker, lpszMsg);
    vsprintf(buf, lpszMsg, marker);
    va_end(marker);

    lpszStrings[0] = buf;
    hEventSource = RegisterEventSource(NULL, TEXT(SZSERVICENAME));

    if (hEventSource != NULL) {
        ReportEvent(hEventSource, // handle of event source
            type,                 // event type
            0,                    // event category
            1,                    // event ID
            NULL,                 // current user's SID
            1,                    // strings in lpszStrings
            0,                    // no bytes of raw data
            lpszStrings,          // array of error strings
            NULL);                // no raw data

        (VOID) DeregisterEventSource(hEventSource);
    }
    return;
}


