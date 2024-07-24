#include <stdio.h>
#include "alinity.h"
#include "service.h"

#define MY_PROFILE  "alinity"

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
    
	GetPrivateProfileString(MY_PROFILE, "ProgID",
                            "sysmex", g_szProgID, 40, szFile);
    
	GetPrivateProfileString(MY_PROFILE, "LogPath",
                            "C:\\MOXA\\sysmex\\LOG\\", g_szLogPath, 260, szFile);
    AddBslash(g_szLogPath);
    
	GetPrivateProfileString(MY_PROFILE, "InBoxPath",
                            "C:\\MOXA\\sysmex\\INBOX\\", g_szInBoxPath, 260, szFile);
    AddBslash(g_szInBoxPath);
	
	GetPrivateProfileString(MY_PROFILE, "BackupInBoxPath",
                            "C:\\MOXA\\sysmex\\INBOX.BAK\\", g_szBackupInBoxPath, 260, szFile);
    AddBslash(g_szBackupInBoxPath);
    
	g_dwSleep = GetPrivateProfileInt(MY_PROFILE, "Sleep", 1000, szFile);

	g_heartbeat = GetPrivateProfileInt(MY_PROFILE, "Heartbeat", 60000, szFile);
        
	g_nPort = GetPrivateProfileInt(MY_PROFILE, "Port", 0, szFile);
    
	g_nMaxRetry = GetPrivateProfileInt(MY_PROFILE, "Retry", 3, szFile);
	
	GetPrivateProfileString(MY_PROFILE, "CodeFile",
                            "C:\\MOXA\\sysmex\\CODE.DAT", g_szCodeFile, 260, szFile);
    
	g_bBackupInbox = GetPrivateProfileInt(MY_PROFILE, "BackupInbox", 0, szFile);
	
	g_timeout = GetPrivateProfileInt(MY_PROFILE, "timeout", 10000, szFile);
    
	GetPrivateProfileString(MY_PROFILE, "OutBoxPath",
                            "C:\\MOXA\\sysmex\\OUTBOX\\", g_szOutBoxPath, 260, szFile);

    GetPrivateProfileString(MY_PROFILE, "TempPath",
                            "C:\\MOXA\\sysmex\\TEMP\\", g_szTempPath, 260, szFile);
    AddBslash(g_szTempPath);

    GetPrivateProfileString(MY_PROFILE, "RateFile",
                            "c:\\MOXA\\sysmex\\RATE.DAT", g_szRateFile, 260, szFile);

	g_mode = GetPrivateProfileInt(MY_PROFILE, "mode", 1, szFile);
	
	g_flag = GetPrivateProfileInt(MY_PROFILE, "flag", 100, szFile);

//	g_nMsgID = 1;
    return 0;
}

