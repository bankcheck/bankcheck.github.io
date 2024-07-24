#ifndef __ortho_H
#define __ortho_H

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
#define ETB         23
#define FS	        28
#define CR          0x0D
#define LF          0x0A

extern char         g_szProgID[40];
extern int          g_nMaxReadBufferSize;
extern int          g_nMaxWriteBufferSize;
extern OVERLAPPED   g_o;
extern char         g_szPrgName[80];
extern HANDLE       g_hServerStopEvent;
extern BOOL         g_bWriteSectorCup;
extern BOOL         g_bQuit;
extern BOOL         g_bLog;
extern BOOL         g_bDebug;
extern BOOL         g_bBackupInbox;
extern char         g_szCodeFile[260];
extern char         g_szRateFile[260];
extern char         g_szDiluteFile[260];
extern char         g_szTempPath[260];
extern char         g_szInBoxPath[260];
extern char         g_szBackupInBoxPath[260];
extern char         g_szInBoxDataPath[260];
extern char         g_szOutBoxPath[260];
extern char         g_szLogPath[260];
extern int          g_nMappingIndex;
extern char         g_szFileMapping[260];
extern char         g_szXMcode[20];
extern int          g_nDayAgo;
extern int          g_nNowDay;
extern int          g_InstrumentDate;
extern char			g_buffer[1024];
extern char			g_fname[260];
extern char			g_tmpfname[260];
extern int          g_ls;
extern int			g_mode;
extern BOOL			g_bCheckDigit;
extern int			g_sleep;

int RecvProc(void);
int ProcessDataFile(char *fname);
void WriteLog(char *fmt, ...);
int DispMessage(char *buf);
int LoadRegVal(void);
int AddBslash(char *s);
VOID AddToEventLog(WORD type, LPTSTR lpszMsg, ...);
int DumpErrorData(int len, char *buf);
int GetData(char fname[260]);
int RemoveSpace(char *buf);
int RemoveEndSpace(char *buf);
int TrimSpace(char *buf);
int RemoveSign(char *buf);
unsigned char GetCheckSum(char *buf);
int ConvertRCode(char *code);
double ConvertRate(char *code);
int Dilution(char *code);
void GetToken(char *str, char *token, int no);
int ReceivePacket(char *szData);
int SendPacket(char *buf);
char *ParseDelimiter (char *str, int idx, char delimiter, char *buf);
int ConvertCode(char *item, char *code);
void RemoveEndChar(char *buf);
int SendFile(char LabNo[12]);
#endif
