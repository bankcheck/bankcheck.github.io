#include <stdio.h>
#include <string.h>
#include <time.h>
#include "clinitek500.h"

unsigned char GetCheckSum(char *buf)
{
    unsigned char chksum;

    chksum = 0;
    while (1) {
        chksum += *buf;
        if (*buf == ']') break;
        buf++;
    }
    chksum = 256-chksum;
    return chksum;
}

int SendData(void)
{
    WIN32_FIND_DATA data;
    HANDLE hFind;
    char path[260], fname[260];
    BOOL bFound;

    sprintf(path, "%s*", g_szInBoxPath);
    if (g_bDebug)
        WriteLog("Checking upload folder %s...", path);
    hFind = FindFirstFile(path, &data);
    if (hFind != INVALID_HANDLE_VALUE) {
        bFound = TRUE;
        while (bFound) {
            if (g_bQuit) break;
            if (data.cFileName[0] != '.' &&
                    (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0) {
                sprintf(fname, "%s%s", g_szInBoxPath, data.cFileName);
                if (SendFile(fname))
                    break;
            }
            bFound = FindNextFile(hFind, &data);
        }
        FindClose(hFind);
    }
    if (g_bDebug)
        WriteLog("Upload completed.");

    return 0;
}
