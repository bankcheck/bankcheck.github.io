#include <stdio.h>
#include <string.h>
#include <time.h>
#include "Dimension.h"

unsigned char GetCheckSum(char *buf)
{
    unsigned char chksum;

    chksum = 0;
    while (1) {
        if (*buf == '\0') break;
        chksum += *buf;
        buf++;
    }
    return chksum;
}

int SendData(void)
{
    WIN32_FIND_DATA data;
    HANDLE hFind;
    char path[260], fname[260];
	char cmd[260];
	char buf[260];
    BOOL bFound;
	BOOL bNotSent;

    sprintf(path, "%s*", g_szInBoxPath);
    if (g_bDebug)
        WriteLog("Checking upload folder %s", path);
    hFind = FindFirstFile(path, &data);

    if (hFind != INVALID_HANDLE_VALUE) {
		bNotSent = TRUE;
        bFound = TRUE;
        while (bFound) {
            if (g_bQuit) break;
            if (data.cFileName[0] != '.' &&
                    (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0) {
                sprintf(fname, "%s%s", g_szInBoxPath, data.cFileName);
                if (SendFile(fname)) {
					bNotSent = FALSE;
                    break;
				}
            }
            bFound = FindNextFile(hFind, &data);
        }
        FindClose(hFind);
    }
	if (bNotSent) {
        sprintf(cmd, "N%c", FS);
        sprintf(buf, "%c%s%02X%c", STX, cmd, GetCheckSum(cmd), ETX);
        SendPacket(buf);
	}

    if (g_bDebug)
        WriteLog("Upload Completed.");

    return 0;
}
