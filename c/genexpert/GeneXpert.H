#ifndef __GeneXpert_H
#define __GeneXpert_H

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

typedef struct {
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
extern char         g_szFlagFile[260];
extern char         g_szOutBoxPath[260];
extern char         g_szLogPath[260];
extern char         g_szCodeFile[260];
extern char			g_szTempPath[260];
extern char			g_szInBoxPath[260];
extern char         g_szBackupInBoxPath[260];
extern char			g_szOutBufferFile[260];
extern BOOL         g_bBackupInbox;
extern DWORD        g_dwSleep;
extern DWORD        g_dwRecvWait;
extern CLIENT		g_Client;
extern char			g_szServer[80];
extern short		g_nPort;
extern short		g_nMaxRetry;
extern unsigned long g_nMsgID;
extern int			g_timeout;
extern char         g_Pos[5];
extern char         g_Neg[5];
extern int			g_buffer;

int MainProc(void);
void WriteLog(char *fmt, ...);
int LoadRegVal(void);
int AddBslash(char *s);
VOID AddToEventLog(WORD type, LPTSTR lpszMsg, ...);
int DumpErrorData(int len, char *buf);
int RemoveSpace(char *buf);
int RemoveEndSpace(char *buf);
int TrimSpace(char *buf);
int SendPacket(char *packet);
int ConnectServer(CLIENT *c);
void disconnect(CLIENT *c);
char *ParseDelimiter (char *str, int idx, char delimiter, char *buf);
void GetData(void);
int ConvertCode(char *file, char *item, char *code);
int ConvertRCode(char *file, char *code, char *item);
int SendLine(CLIENT *c, char *buf);
int SendData(void);
int SendFolder(void);
int SendFile(int seq, char LabNo[12], BOOL bBackup);

#endif
