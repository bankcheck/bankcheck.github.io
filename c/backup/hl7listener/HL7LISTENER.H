#ifndef __HL7LISTENER_H
#define __HL7LISTENER_H

#include <windows.h>
//#include <sql.h>
#include <sqlext.h>
//#include <sqlca.h>

#pragma comment(lib, "advapi32.lib")
#pragma comment(lib, "wsock32.lib")

#define MY_PROFILE  "HL7LISTENER"

#define _TRY_EXCEPTION_BLOCK_BEGIN() __try {

#define _TRY_EXCEPTION_BLOCK_END(code)  } \
                   __except (code) { \
                       AddToEventLog(EVENTLOG_ERROR_TYPE, \
                                    "File: %s, Line: %d, Exception: 0x%08lX", \
                                    __FILE__, __LINE__, GetExceptionCode()); \
                   }

typedef struct {
    BOOL bCheck;
    DWORD tick;
    int nErrCount;
    char szProg[260];
    char szFileName[260];
    char szNo[260];
    char szBackupFile[260];
    char szInboxPath[260];
} CLIENT;

extern char     g_szProfile[260];
extern CLIENT  *g_Client;
extern HANDLE   g_hServerStopEvent;
extern int      g_nMaxClient;
extern int      g_nMaxProg;
extern int      g_nCurProg;
extern short    g_nPort;
extern char     g_szServer[80];
extern SOCKET   g_sd;
extern DWORD    g_dwMaxIdle;
extern DWORD    g_dwSleepTime;
extern DWORD    g_dwErrorSleepTime;
extern char     g_szPrgName[80];
extern char     g_szRootPath[260];
extern BOOL     g_bLog;
extern BOOL     g_bDebug;
extern BOOL     g_bBackup;
extern BOOL     g_bTimerQuit;
extern BOOL     g_bQuit;
extern char     g_szTempPath[260];
extern char     g_szBackupPath[260];

SQLHDBC dbc;
SQLRETURN ret; /* ODBC API return status*/ 
SQLHENV env;
SQLINTEGER SQLerr;
SQLSMALLINT SQLmsglen;
char pStatus[10], pMsg[101];
SQLCHAR OutConnStr[255];
SQLSMALLINT OutConnStrLen;

DWORD SendThreadProc(LPVOID);

void WriteLog(char *fmt, ...);
int LoadRegVal(void);
int AddBslash(char *s);
VOID AddToEventLog(WORD type, LPTSTR lpszMsg, ...);
void dbconnect(void);
void dbdisconnect(void);
char *ParseDelimiter (char *str, int idx, char delimiter, char *buf);
void reply(long refid, int no);

#endif
