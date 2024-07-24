#include "patho.h"
#include <stdio.h>

int LoadRegVal(void)
{
    char drive[_MAX_DRIVE];
    char dir[_MAX_DIR];
    char fname[_MAX_FNAME];
    char ext[_MAX_EXT];

_TRY_EXCEPTION_BLOCK_BEGIN()

    _splitpath(__argv[0], drive, dir, fname, ext);
    if (drive[0] == '\0' && dir[0] == '\0') {
        char buf[1024];

        GetCurrentDirectory(260, buf);
        sprintf(g_szProfile, "%s\\%s.ini", buf, fname);
    }
    else
        _makepath(g_szProfile, drive, dir, fname, ".ini" );

	GetPrivateProfileString(MY_PROFILE, "LogPath",
                            "D:\\MOXA\\patho\\LOG\\", g_szLogPath, 260, g_szProfile);
    AddBslash(g_szLogPath);

    GetPrivateProfileString(MY_PROFILE, "BackupPath",
                            "D:\\MOXA\\patho\\INBOX.BAK\\", g_szBackupPath, 260, g_szProfile);
    AddBslash(g_szBackupPath);

    GetPrivateProfileString(MY_PROFILE, "InBoxPath",
                            "D:\\MOXA\\patho\\INBOX\\", g_szInBoxPath, 260, g_szProfile);
    AddBslash(g_szInBoxPath);

    g_bDebug = GetPrivateProfileInt(MY_PROFILE, "Debug", 0, g_szProfile);

    g_bBackup = GetPrivateProfileInt(MY_PROFILE, "Backup", 0, g_szProfile);

    GetPrivateProfileString(MY_PROFILE, "DBServer",
                            "139.168.200.1", g_szDBServer, 260, g_szProfile);
    
	GetPrivateProfileString(MY_PROFILE, "FileServer",
                            "139.168.200.1", g_szFileServer, 260, g_szProfile);

    GetPrivateProfileString(MY_PROFILE, "Share",
                            "lab", g_szShare, 260, g_szProfile);

    g_sleep = GetPrivateProfileInt(MY_PROFILE, "Sleep", 3000, g_szProfile);

_TRY_EXCEPTION_BLOCK_END(1)

    return 0;
}

