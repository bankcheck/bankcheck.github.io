#include <stdio.h>
#include <time.h>
#include "infsend.h"

int MainProc(void)
{
    WIN32_FIND_DATA data;
    HANDLE hFind;
    char path[260], fname[260], bakname[260];
    BOOL bFound;

	while(1) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;

		sprintf(path, "%s*", g_szInBoxPath);
		hFind = FindFirstFile(path, &data);
		if (hFind != INVALID_HANDLE_VALUE) {

			bFound = TRUE;
			while (bFound) {
				if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
					break;

			    if (data.cFileName[0] != '.' &&
                        (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0) {

					sprintf(fname, "%s%s", g_szInBoxPath, data.cFileName);
/*
					sprintf(bakname, "%s%s\0", g_szBackupInBoxPath, data.cFileName);

					WriteLog("Backup file: %s...", fname);
					CopyFile(fname, bakname, FALSE);
*/
					if (!g_Client.connected) {
						ConnectServer(&g_Client);
					}

					if ((g_Client.connected) && (SendData() == 1)) {
						SendFile(data.cFileName);
						sprintf(bakname, "%s%s\0", g_szSuccessPath, data.cFileName);
						WriteLog("Moving file from %s to %s", fname, bakname);
						CopyFile(fname, bakname, FALSE);
					} else {
						sprintf(bakname, "%s%s\0", g_szBackupInBoxPath, data.cFileName);
						WriteLog("Backup file: %s...", fname);
						CopyFile(fname, bakname, FALSE);

						sprintf(bakname, "%s%s\0", g_szFailPath, data.cFileName);
						WriteLog("Moving file from %s to %s", fname, bakname);
						CopyFile(fname, bakname, FALSE);
					}

					if (DeleteFile(fname) == 0)
						WriteLog("Cannot delete file %s", fname);

				}

	            bFound = FindNextFile(hFind, &data);

		    }
			FindClose(hFind);
		}

	}

    return 0;
}

