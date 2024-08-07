#ifndef __QIAstatDx_H
#define __QIAstatDx_H

#define _TRY_EXCEPTION_BLOCK_BEGIN() __try {

#define _TRY_EXCEPTION_BLOCK_END(code)  } \
                   __except (code) { \
                       AddToEventLog(EVENTLOG_ERROR_TYPE, \
                                    "File: %s, Line: %d, Exception: 0x%08lX", \
                                    __FILE__, __LINE__, GetExceptionCode()); \
                   }

#include <windows.h>
#include <sqlext.h>
#pragma comment(lib, "advapi32.lib")
#pragma comment(lib, "wsock32.lib")

#define MAX_CONN    SOMAXCONN

#define SOH         1
#define STX         2
#define ETX         3
#define EOT         4
#define ENQ         5
#define ACK         6
#define TAB         9
#define VT			11
#define DLE         16
#define DC1         17
#define DC2         18
#define DC3         19
#define NAK         21
#define SYN         22
#define ETB         23
#define FS	        28
#define CR          0x0D
#define LF          0x0A

typedef struct {
    SOCKET	s;
	char	ip[17];
	DWORD	dThreadID;
	HANDLE	hThread;
	//BOOL	bIdle;
} CLIENT;

extern OVERLAPPED   g_o;
extern char         g_szPrgName[80];
extern HANDLE       g_hServerStopEvent;
extern HANDLE       g_hCom;
extern BOOL         g_bQuit;
extern BOOL         g_bLog;
extern BOOL         g_bDebug;
extern BOOL         g_bOverwriteTNS;

extern char         g_szInBoxPath[260];
extern char         g_szBackupInBoxPath[260];
extern char         g_szOutBoxPath[260];
extern char         g_szTempPath[260];
extern char         g_szLogPath[260];
extern char         g_szTNSFileSource[260];
extern char         g_szTNSFileDest[260];

extern DWORD        g_dwSleep;
extern short		g_nPort;
extern short		g_nMaxRetry;
extern BOOL         g_bBackupInbox;
extern int			g_timeout;
extern SOCKET		g_server;
extern CLIENT	   *g_Client;
extern char			g_db[80];
extern int			g_nMaxClient;

SQLHDBC dbc;
SQLRETURN ret; /* ODBC API return status*/ 
SQLHENV env;
SQLINTEGER SQLerr;
SQLSMALLINT SQLmsglen;
char pStatus[10], pMsg[101];
SQLCHAR OutConnStr[255];
SQLSMALLINT OutConnStrLen;

int MainProc(void);
void WriteLog(char *fmt, ...);
int LoadRegVal(void);
int AddBslash(char *s);
VOID AddToEventLog(WORD type, LPTSTR lpszMsg, ...);
int DumpErrorData(int len, char *buf);
int RemoveSpace(char *buf);
int RemoveEndSpace(char *buf);
int TrimSpace(char *buf);
int SendPacket(int no, char *packet);
void close_client(int no);
char *ParseDelimiter (char *str, int idx, char delimiter, char *buf);
int ConvertCode(char *item, char *code);
int RevertCode(char *item, char *code);
int SendLine(int no, char *buf);
DWORD RecvThreadProc(LPVOID pParm);
unsigned char GetCheckSum(char *buf);
void dbconnect(void);
void dbdisconnect(void);
long insert_msg(int no, char* data);
void reply(long refid, int no);
void sendACK(int no, char* cntl_no);

#endif
