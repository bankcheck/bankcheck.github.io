#include <stdio.h>
#include <time.h>
#include "maldi.h"

int RecvProc(void)
{
    char path[260];
    WIN32_FIND_DATA data;
    HANDLE hFind;
    BOOL bFound;
	char filename[260];
	char bakname[260];
	char *tmpname;

    while (1) {
		WriteLog("Waiting for file...");

		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
			g_bQuit = TRUE;
			break;
		}
		sprintf(path, "%s*.csv", g_szInBoxDataPath);
		hFind = FindFirstFile(path, &data);
//		WriteLog("Search %s", path);

		if (hFind != INVALID_HANDLE_VALUE) {
			bFound = TRUE;
			while (bFound) {
				if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
					g_bQuit = TRUE;
					break;
				}

				if (data.cFileName[0] != '.' && (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0) {

					sprintf(filename, "%s%s\0", g_szInBoxDataPath, data.cFileName);
					
					WriteLog("file %s", filename);

					if (GetData(filename)) {
			
						if (g_bDebug) {
							tmpname = strrchr(filename, '\\');
							sprintf(bakname, "%s%s\0", g_szTempPath, ++tmpname);
							WriteLog("Moving file from %s to %s", filename, bakname);
							CopyFile(filename, bakname, FALSE);
						}

						DeleteFile(filename);
					}
				}

				bFound = FindNextFile(hFind, &data);
			}
			FindClose(hFind);
		}

    }

    return 0;
}
