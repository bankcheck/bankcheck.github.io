#ifndef __PCS_ADT_H
#define __PCS_ADT_H

#include <windows.h>
#pragma comment(lib, "advapi32.lib")
#pragma comment(lib, "wsock32.lib")

#define MAX_PORT    32

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

#define _TRY_EXCEPTION_BLOCK_BEGIN() __try {

#define _TRY_EXCEPTION_BLOCK_END(code)  } \
                   __except (code) { \
                       AddToEventLog(EVENTLOG_ERROR_TYPE, \
                                    "File: %s, Line: %d, Exception: 0x%08lX", \
                                    __FILE__, __LINE__, GetExceptionCode()); \
                   }

typedef struct {
	char	name[4];
    SOCKET	s;
	char	ip[80];
	short	port;
	BOOL	connected;
} CLIENT;

extern char         g_szProgID[40];
extern OVERLAPPED   g_o;
extern char         g_szPrgName[80];
extern HANDLE       g_hServerStopEvent;
extern HANDLE       g_hCom;
extern BOOL         g_bQuit;
extern BOOL         g_bLog;
extern BOOL         g_bDebug;

extern char         g_szADTInBoxPath[260];
extern char         g_szRXFInBoxPath[260];
extern char         g_szRXPInBoxPath[260];

extern char         g_szBackupInBoxPath[260];
extern char         g_szLogPath[260];
extern DWORD        g_dwSleep;
extern DWORD        g_dwRecvWait;

extern CLIENT		g_ADT;
extern CLIENT		g_RXF;
extern CLIENT		g_RXP;
extern char			g_szServer[80];
extern short		g_nADTPort;
extern short		g_nRXFPort;
extern short		g_nRXPPort;
extern short		g_nMaxRetry;
extern int			g_timeout;

//int MainProc(void);
void WriteLog(char *fmt, ...);
int LoadRegVal(void);
int AddBslash(char *s);
VOID AddToEventLog(WORD type, LPTSTR lpszMsg, ...);
int DumpErrorData(int len, char *buf);
int RemoveSpace(char *buf);
int RemoveEndSpace(char *buf);
int TrimSpace(char *buf);
int SendPacket(CLIENT *c, char *buf);
int ConnectServer(CLIENT *c);
void disconnect(CLIENT *c);
char *ParseDelimiter (char *str, int idx, char delimiter, char *buf);

DWORD ADTThreadProc(LPVOID);
DWORD RXFThreadProc(LPVOID);
DWORD RXPThreadProc(LPVOID);

#endif
