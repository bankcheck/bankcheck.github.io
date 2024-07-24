#ifndef __referralPDF_H
#define __referralPDF_H

#include <windows.h>
//#include <sql.h>
#include <sqlext.h>
//#include <sqlca.h>

#pragma comment(lib, "advapi32.lib")
#pragma comment(lib, "wsock32.lib")

#define MY_PROFILE  "referralPDF"

#define _TRY_EXCEPTION_BLOCK_BEGIN() __try {

#define _TRY_EXCEPTION_BLOCK_END(code)  } \
                   __except (code) { \
                       AddToEventLog(EVENTLOG_ERROR_TYPE, \
                                    "File: %s, Line: %d, Exception: 0x%08lX", \
                                    __FILE__, __LINE__, GetExceptionCode()); \
                   }

extern char     g_szProfile[260];
extern HANDLE   g_hServerStopEvent;
extern char     g_szDBServer[80];
extern char     g_szFileServer[80];
extern char     g_szShare[80];
extern DWORD    g_dwMaxIdle;
extern char     g_szPrgName[80];
extern BOOL     g_bDebug;
extern BOOL     g_bBackup;
extern BOOL     g_bQuit;
extern char     g_szLogPath[260];
extern char     g_szBackupPath[260];
extern char     g_szInBoxPath[260];
extern int		g_sleep;

SQLHDBC dbc;
SQLRETURN ret; /* ODBC API return status*/ 
SQLHENV env;
SQLINTEGER SQLerr;
SQLSMALLINT SQLmsglen;
char pStatus[10], pMsg[101];
SQLCHAR OutConnStr[255];
SQLSMALLINT OutConnStrLen;

void WriteLog(char *fmt, ...);
int LoadRegVal(void);
int AddBslash(char *s);
VOID AddToEventLog(WORD type, LPTSTR lpszMsg, ...);
int AddEntry(char *s);
void dbconnect(void);
void dbdisconnect(void);
int CheckFile(void);
char *ParseDelimiter (char *str, int idx, char delimiter, char *buf);

#endif
