#ifndef __hl7hub_H
#define __hl7hub_H

#include <windows.h>
//#include <sql.h>
#include <sqlext.h>
//#include <sqlca.h>
#include <time.h>

#pragma comment(lib, "advapi32.lib")
#pragma comment(lib, "wsock32.lib")

#define MY_PROFILE  "hl7hub"

#define _TRY_EXCEPTION_BLOCK_BEGIN() __try {

#define _TRY_EXCEPTION_BLOCK_END(code)  } \
                   __except (code) { \
                       AddToEventLog(EVENTLOG_ERROR_TYPE, \
                                    "File: %s, Line: %d, Exception: 0x%08lX", \
                                    __FILE__, __LINE__, GetExceptionCode()); \
                   }

extern char     g_szProfile[260];
extern DWORD    g_dwMaxIdle;
extern DWORD    g_dwSleepTime;
extern DWORD    g_dwErrorSleepTime;
extern char     g_szRootPath[260];
extern BOOL     g_bLog;
extern BOOL     g_bDebug;
extern BOOL     g_bBackup;
extern BOOL     g_bQuit;
extern char     g_Host[15];
extern char     g_szRoot[260];
extern char     g_szPrgName[80];
extern char     g_szServer[80];
extern char     g_szTempPath[260];

SQLHDBC dbc;
SQLHENV env;
SQLCHAR OutConnStr[255];
SQLSMALLINT OutConnStrLen;

//DWORD TimerThreadProc(LPVOID);
//DWORD SendThreadProc(LPVOID);
void Query(void);

void WriteLog(char *fmt, ...);
int LoadRegVal(void);
int AddBslash(char *s);
//int PutLine(int no, char *buf);
//int GetLine(int no, char *buf, int bufsize);
VOID AddToEventLog(WORD type, LPTSTR lpszMsg, ...);
//int GetResult(char *s);
void dbconnect(void);
void dbdisconnect(void);

#endif
