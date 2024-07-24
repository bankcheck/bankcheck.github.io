#include <stdio.h>
#include "FilmArray.h"
#include "service.h"

#define MY_PROFILE  "FilmArray"

int LoadRegVal(void)
{
    char drive[_MAX_DRIVE];
    char dir[_MAX_DIR];
    char fname[_MAX_FNAME];
    char ext[_MAX_EXT];
    char szFile[260];
    char buf[1024];

    _splitpath(__argv[0], drive, dir, fname, ext);
    if (drive[0] == '\0' && dir[0] == '\0') {
        GetCurrentDirectory(260, buf);
        sprintf(szFile, "%s\\%s.ini", buf, fname);
    }
    else
        _makepath(szFile, drive, dir, fname, ".ini" );
    
    g_bLog = GetPrivateProfileInt(MY_PROFILE, "Log", 0, szFile);
    g_bDebug = GetPrivateProfileInt(MY_PROFILE, "Debug", 0, szFile);
    g_bCheckDigit = GetPrivateProfileInt(MY_PROFILE, "CheckDigit", 0, szFile);
    GetPrivateProfileString(MY_PROFILE, "ProgID",
                            "FilmArray", g_szProgID, 40, szFile);
    GetPrivateProfileString(MY_PROFILE, "LogPath",
                            "D:\\MOXA\\FilmArray\\LOG\\", g_szLogPath, 260, szFile);
    AddBslash(g_szLogPath);
    GetPrivateProfileString(MY_PROFILE, "BackupPath",
                            "D:\\MOXA\\FilmArray\\DEBUG\\", g_szBackupPath, 260, szFile);
    AddBslash(g_szBackupPath);
    GetPrivateProfileString(MY_PROFILE, "OutBoxPath",
                            "D:\\MOXA\\FilmArray\\OUTBOX\\", g_szOutBoxPath, 260, szFile);
    AddBslash(g_szOutBoxPath);
    GetPrivateProfileString(MY_PROFILE, "TempPath",
                            "D:\\MOXA\\FilmArray\\TEMP\\", g_szTempPath, 260, szFile);
    AddBslash(g_szTempPath);

    GetPrivateProfileString(MY_PROFILE, "Detect",
                            "500", g_Detect, 5, szFile);
    GetPrivateProfileString(MY_PROFILE, "NotDetect",
                            "0", g_NotDetect, 5, szFile);
    GetPrivateProfileString(MY_PROFILE, "Equivoc",
                            "250", g_Equivoc, 5, szFile);

	GetPrivateProfileString(MY_PROFILE, "CodeFile",
                            "C:\\MOXA\\FilmArray\\CODE.DAT", g_szCodeFile, 260, szFile);

    return 0;
}

