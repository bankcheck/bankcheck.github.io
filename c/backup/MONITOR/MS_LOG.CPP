#include "stdafx.h"
#include "Monitor.h"
#include "Display.h"
#include "ms_log.h"

typedef struct {
    char  szProgID[40];
    char  szPort[16];
    char  szBuf[200];
} MSG_DATA;

BOOL g_bLog = FALSE;
DWORD g_dwSleep = 1000;
char g_szLogPath[260] = "D:\\MOXA\\Log\\";
char g_szFileMapping[260] = "MOXA_MONITOR";

UINT ThreadProc(LPVOID pParam)
{
    HANDLE hMapping;
    MSG_DATA *pData;
    unsigned int i;

    hMapping = CreateFileMapping((void *)0xFFFFFFFF, NULL,
                                PAGE_READWRITE, 0, sizeof(MSG_DATA)*MAX_PORT,
                                g_szFileMapping);
    if (hMapping == INVALID_HANDLE_VALUE) {
        DispMessage(1, "系統訊息", "-----", "無法建立 FileMapping 物件!");
        ::PostMessage((HWND)pParam, WM_THREADFINISHED, 0, 0);
        return 0;
    }
    pData = (MSG_DATA *)MapViewOfFile(hMapping, FILE_MAP_WRITE,
                                      0, 0, sizeof(MSG_DATA)*MAX_PORT);
    if (pData == NULL) {
        CloseHandle(hMapping);
        DispMessage(0, "系統訊息", "-----", "無法連結 FileMapping 物件!");
        ::PostMessage((HWND)pParam, WM_THREADFINISHED, 0, 0);
        return 0;
    }
    memset(pData, 0, sizeof(MSG_DATA)*MAX_PORT);

    while (1) {
        if (::WaitForSingleObject(g_evtKill.m_hObject, g_dwSleep) == WAIT_OBJECT_0)
            break;
        for (i = 0; i < MAX_PORT; i++) {
            DispMessage(i, pData[i].szProgID, pData[i].szPort, pData[i].szBuf);
            Sleep(50);
        }
    }

    if (pData != NULL)
        UnmapViewOfFile(pData);
    if (hMapping != INVALID_HANDLE_VALUE)
        CloseHandle(hMapping);

    ::PostMessage((HWND)pParam, WM_THREADFINISHED, 0, 0);
    return 0;
}

int AddBslash(char *s)
{
    int len;

    len = strlen(s);
    if (len == 0) return 0;
    if (s[len-1] == '\\' || s[len-1] == '/') return 0;
    s[len++] = '\\';
    s[len] = '\0';
    return 1;
}

