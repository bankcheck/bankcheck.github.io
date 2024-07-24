#ifndef __200P_1_H
#define __200P_1_H

#include <windows.h>
#pragma comment(lib, "advapi32.lib")

#define MAX_PORT    32

#define SOH         1
#define STX         2
#define ETX         3
#define EOT         4
#define ENQ         5
#define ACK         6
#define TAB         9
#define DLE         16
#define DC1         17
#define DC2         18
#define DC3         19
#define NAK         21
#define SYN         22
#define CR          0x0D
#define LF          0x0A

extern char         g_szProgID[40];
extern int          g_nMaxReadBufferSize;
extern int          g_nMaxWriteBufferSize;
extern int          g_nComBaudRate;
extern int          g_nComByteSize;
extern int          g_nComParity;
extern int          g_nComStopBits;
extern int          g_nComPort;
extern OVERLAPPED   g_o;
extern char         g_szPrgName[80];
extern HANDLE       g_hServerStopEvent;
extern HANDLE       g_hCom;
extern BOOL         g_bQuit;
extern BOOL         g_bLog;
extern BOOL         g_bDebug;
extern BOOL         g_bReOpenPort;
extern BOOL         g_bCheckOnline;
extern char         g_szTempPath[260];
extern char         g_szDataPath[260];
extern char         g_szLogPath[260];
extern int          g_nMappingIndex;
extern char         g_szFileMapping[260];
extern DWORD        g_dwSleep;
extern DWORD        g_dwRecvWait;

int RecvProc(void);
int ProcessDataFile(char *fname);
void WriteLog(char *fmt, ...);
int DispMessage(char *buf);
int LoadRegVal(void);
int AddBslash(char *s);
VOID AddToEventLog(WORD type, LPTSTR lpszMsg, ...);
int GetChar(HANDLE hCom, char *buf);
int SendChar(HANDLE hCom, char *buf, int len);
int DumpErrorData(int len, char *buf);
int ReadDataFromComm(DWORD *pdwLen, char *buf);

#endif
