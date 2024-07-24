#include <stdarg.h>
#include <stdio.h>
#include <time.h>
#include "labsrv.h"
#include "service.h"

void WriteLog(int no, char *fmt, ...)
{
    char buf[1024];
    va_list marker;
    char fname[260];
    FILE *fp;
    time_t t;
    struct tm *tp;
    char *p;

_TRY_EXCEPTION_BLOCK_BEGIN()

    if (g_bLog == FALSE) return;

    va_start(marker, fmt);
    vsprintf(buf, fmt, marker);
    va_end(marker);

    p = strtok(buf, "\r\n");

    time(&t);
    tp = localtime(&t);
    if (tp != NULL) {
        sprintf(fname, "%slog\\%02d%02d-%03d.log", g_szRootPath,
                        tp->tm_mon+1, tp->tm_mday, no+1);
        fp = fopen(fname, "ab");
        if (fp != NULL) {
            fprintf(fp, "%02d:%02d:%02d %s\r\n", tp->tm_hour, tp->tm_min, tp->tm_sec, p);
            fclose(fp);
        }
    }

_TRY_EXCEPTION_BLOCK_END(1)

    return;
}

VOID AddToEventLog(WORD type, LPSTR lpszMsg, ...)
{
    HANDLE  hEventSource;
    char buf[1024];
    va_list marker;
    LPSTR  lpszStrings[2];

_TRY_EXCEPTION_BLOCK_BEGIN()

    va_start(marker, lpszMsg);
    vsprintf(buf, lpszMsg, marker);
    va_end(marker);

    WriteLog(-1, buf);

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

_TRY_EXCEPTION_BLOCK_END(1)

    return;
}

