// MS_LOG.h : header file for log
//

#ifndef __AFXWIN_H__
    #error include 'stdafx.h' before including this file for PCH
#endif

#ifndef __MS_LOG_H__
#define __MS_LOG_H__

#include <windows.h>

#define MAX_PORT    32

extern BOOL g_bLog;
extern DWORD g_dwSleep;
extern char g_szLogPath[260];
extern char g_szFileMapping[260];

int AddBslash(char *s);
UINT ThreadProc(LPVOID pParam);

#endif
