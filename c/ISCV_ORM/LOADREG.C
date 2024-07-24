#include <stdio.h>
#include "ISCV_ORM.h"
#include "service.h"

#define MY_PROFILE  "ORM"

int LoadRegVal(void)
{
    char drive[_MAX_DRIVE];
    char dir[_MAX_DIR];
    char fname[_MAX_FNAME];
    char ext[_MAX_EXT];
    char szFile[260];
    char buf[1024];

    _splitpath(__argv[0], drive, dir, fname, ext);
	sprintf(fname, "ISCV");

    if (drive[0] == '\0' && dir[0] == '\0') {
        GetCurrentDirectory(260, buf);
        sprintf(szFile, "%s\\%s.ini", buf, fname);
    }
    else
        _makepath(szFile, drive, dir, fname, ".ini" );

    
    g_bLog = GetPrivateProfileInt(MY_PROFILE, "Log", 0, szFile);
    g_bDebug = GetPrivateProfileInt(MY_PROFILE, "Debug", 0, szFile);
    GetPrivateProfileString(MY_PROFILE, "ProgID",
                            "ISCV_ORM", g_szProgID, 40, szFile);
    GetPrivateProfileString(MY_PROFILE, "LogPath",
                            "C:\\HL7\\ISCV\\LOG\\", g_szLogPath, 260, szFile);
    AddBslash(g_szLogPath);

    GetPrivateProfileString(MY_PROFILE, "InBoxPath",
                            "C:\\HL7\\ISCV\\INBOX\\", g_szInBoxPath, 260, szFile);
    AddBslash(g_szInBoxPath);

	GetPrivateProfileString(MY_PROFILE, "BackupInBoxPath",
                            "C:\\HL7\\ISCV\\INBOX.BAK\\", g_szBackupInBoxPath, 260, szFile);
    AddBslash(g_szBackupInBoxPath);
    g_dwSleep = GetPrivateProfileInt(MY_PROFILE, "Sleep", 1000, szFile);
    g_dwRecvWait = GetPrivateProfileInt(MY_PROFILE, "RecvWait", 60000, szFile);
    GetPrivateProfileString(MY_PROFILE, "Server",
                            "139.168.200.1", g_szServer, 260, szFile);
    g_nPort = GetPrivateProfileInt(MY_PROFILE, "Port", 0, szFile);
    g_nMaxRetry = GetPrivateProfileInt(MY_PROFILE, "Retry", 3, szFile);
	g_timeout = GetPrivateProfileInt(MY_PROFILE, "timeout", 10000, szFile);

    return 0;
}

