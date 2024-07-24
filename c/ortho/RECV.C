#include <stdio.h>
#include <time.h>
#include "ortho.h"

int RecvProc(void)
{
    char path[260];
    WIN32_FIND_DATA data;
    HANDLE hFind;
    BOOL bFound;
	char filename[260];

    while (1) {
		WriteLog("Waiting for file...");

		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
			g_bQuit = TRUE;
			break;
		}

		sprintf(path, "%s*.upl", g_szTempPath);
		hFind = FindFirstFile(path, &data);

		if (hFind != INVALID_HANDLE_VALUE) {
			bFound = TRUE;
			while (bFound) {
				if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
					g_bQuit = TRUE;
					break;
				}
				if (data.cFileName[0] != '.' && (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0) {

					sprintf(filename, "%s%s\0", g_szTempPath, data.cFileName);
					GetData(filename);
				}
				bFound = FindNextFile(hFind, &data);
			}
			FindClose(hFind);
		}

    }

    return 0;
}
