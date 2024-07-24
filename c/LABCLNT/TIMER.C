#include <stdio.h>
#include <stdlib.h>
#include "labclnt.h"

DWORD TimerThreadProc(LPVOID pParm)
{
    DWORD now;//, len, tick;
//    SOCKET s;
    int i;

_TRY_EXCEPTION_BLOCK_BEGIN()

    g_bTimerQuit = FALSE;
    while (1) {
        if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 3000) == WAIT_OBJECT_0)
            break;
        for (i = 0; i < g_nMaxClient; i++) {
            if (g_Client == NULL)
                break;
            if (g_Client[i].bCheck == FALSE)
                continue;
            if (g_Client[i].szFileName[0] == '\0')
                continue;
            now = GetTickCount();
            /*if (g_Client[i].s != SOCKET_ERROR) {
                tick = g_Client[i].tick;
                if (now >= tick)
                    len = now - tick;
                else
                    len = now;
                if (len > g_dwMaxIdle) {
                    WriteLog("Timeout %ld %ld %ld %ld",
                                    now, tick, len, g_dwMaxIdle);
                    s = g_Client[i].s;
                    g_Client[i].bCheck = FALSE;
                    g_Client[i].s = SOCKET_ERROR;
                    closesocket(s);
                }
            }*/
        }
    }
    /*for (i = 0; i < g_nMaxClient; i++) {
        if (g_Client[i].s != SOCKET_ERROR) {
            s = g_Client[i].s;
            g_Client[i].bCheck = FALSE;
            g_Client[i].s = SOCKET_ERROR;
            closesocket(s);
        }
    }*/
    g_bTimerQuit = TRUE;
    WriteLog("TimerThread Exit");
    ExitThread(0);

_TRY_EXCEPTION_BLOCK_END(1)

    return 0;
}

