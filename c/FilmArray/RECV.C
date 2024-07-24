#include <stdio.h>
#include <time.h>
#include "FilmArray.h"

void RecvProc(void)
{
    WIN32_FIND_DATA	data;
    HANDLE			hFind;
    BOOL			bFound;
	char			fname[260];
	char			bakname[260];
	char			path[260];

	while (1) {

		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;


		sprintf(path, "%sFilmArray_*.xml\0", g_szTempPath);
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

					sprintf(fname, "%s%s\0", g_szTempPath, data.cFileName);
					ProcessFile(fname);
					if (g_bDebug) {
						sprintf(bakname, "%s%s\0", g_szBackupPath, data.cFileName);
						CopyFile(fname, bakname, FALSE);
					}	
					DeleteFile(fname);
				}

				bFound = FindNextFile(hFind, &data);
			}
			FindClose(hFind);
		}

    }

}
