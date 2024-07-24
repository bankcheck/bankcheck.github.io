#ifndef __urt_H
#define __urt_H
#include <windows.h>

#pragma comment(lib, "advapi32.lib")
#define MY_PROFILE  "urt"

#define _TRY_EXCEPTION_BLOCK_BEGIN() __try {

#define _TRY_EXCEPTION_BLOCK_END(code)  } \
                   __except (code) { \
                       AddToEventLog(EVENTLOG_ERROR_TYPE, \
                                    "File: %s, Line: %d, Exception: 0x%08lX", \
                                    __FILE__, __LINE__, GetExceptionCode()); \
                   }

extern char         g_szProgID[40];
extern OVERLAPPED   g_o;
extern char         g_szPrgName[80];
extern HANDLE       g_hServerStopEvent;
extern BOOL         g_bWriteSectorCup;
extern BOOL         g_bQuit;
extern BOOL         g_bLog;
extern char         g_szCodeFile[260];
extern char         g_szRowFile[260];
extern char         g_szMachFile[260];
extern char         g_szOutBoxPath[260];
extern char         g_szLogPath[260];
extern char			g_szServer[260];
extern DWORD        g_dwSleep;
extern int			g_page;


int RecvProc(void);
void WriteLog(char *fmt, ...);
int LoadRegVal(void);
int AddBslash(char *s);
VOID AddToEventLog(WORD type, LPTSTR lpszMsg, ...);
int DumpErrorData(int len, char *buf);
int RemoveSpace(char *buf);
int RemoveEndSpace(char *buf);
int TrimSpace(char *buf);
void GetToken(char *str, char *token, int no);
void writeRowFile (int row);
int ConvertCode(char CodeFile[260], char *code);
char *ParseDelimiter (char *str, int idx, char delimiter, char *buf);

#endif
