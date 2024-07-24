#ifndef __LABCLNT_H
#define __LABCLNT_H

#include <windows.h>
#pragma comment(lib, "advapi32.lib")
#pragma comment(lib, "wsock32.lib")

#define MY_PROFILE  "LABSRV"

#define _TRY_EXCEPTION_BLOCK_BEGIN() __try {

#define _TRY_EXCEPTION_BLOCK_END(code)  } \
                   __except (code) { \
                       AddToEventLog(EVENTLOG_ERROR_TYPE, \
                                    "File: %s, Line: %d, Exception: 0x%08lX", \
                                    __FILE__, __LINE__, GetExceptionCode()); \
                   }

typedef struct {
    SOCKET s;
    BOOL bCheck;
    DWORD tick;
} CLIENT;

extern char     g_szProfile[260];
extern CLIENT  *g_Client;
extern HANDLE   g_hServerStopEvent;
extern int      g_nMaxClient;
extern short    g_nPort;
extern SOCKET   g_sd;
extern DWORD    g_dwMaxIdle;
extern DWORD    g_dwSleepTime;
extern char     g_szPrgName[80];
extern char     g_szRootPath[260];
extern char     g_szDataPath[260];
extern BOOL     g_bLog;
extern BOOL     g_bDebug;
extern BOOL     g_bTimerQuit;
extern BOOL     g_bBackup;
extern BOOL     g_bQuit;

DWORD TimerThreadProc(LPVOID);
DWORD RecvThreadProc(LPVOID);

void WriteLog(int no, char *fmt, ...);
int LoadRegVal(void);
int AddBslash(char *s);
int PutLine(int no, char *buf);
int GetLine(int no, char *buf, int bufsize);
VOID AddToEventLog(WORD type, LPTSTR lpszMsg, ...);
int GetResult(char *s);

#endif
