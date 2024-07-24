#include <stdio.h>
#include <time.h>
#include "referralPDF.h"

int CheckFile(void)
{
    char path[260];
    WIN32_FIND_DATA data;
    HANDLE hFind;
    BOOL bFound;
	char inname[260];
	char outname[260];
	char bakname[260];

    while (1) {
		//WriteLog("Waiting for file...");

		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
			g_bQuit = TRUE;
			break;
		}

		sprintf(path, "%s*.pdf\0", g_szInBoxPath);
		hFind = FindFirstFile(path, &data);
		
		WriteLog("Search %s", path);

		if (hFind != INVALID_HANDLE_VALUE) {

			bFound = TRUE;
			while (bFound) {
				if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
					g_bQuit = TRUE;
					break;
				}

				WriteLog("processing %s", data.cFileName);

				if (data.cFileName[0] != '.' && (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0) {

					sprintf(inname, "%s%s\0", g_szInBoxPath, data.cFileName);
					sprintf(outname, "\\\\%s\\%s\\%s\0", g_szFileServer, g_szShare, data.cFileName);
					sprintf(bakname, "%s%s\0", g_szBackupPath, data.cFileName);

					if (CopyFile(inname, outname, FALSE) == 0) {
						WriteLog("Error copying file %s to %s", inname, outname);
						Sleep(g_sleep);

					} else {

						if (AddEntry(data.cFileName)) {

							if (g_bBackup)
								CopyFile(inname, bakname, FALSE);

							DeleteFile(inname);
						}
						
					}
				}

				bFound = FindNextFile(hFind, &data);
			}
			FindClose(hFind);
		}

		Sleep(g_sleep);

    }

    return 0;
}

