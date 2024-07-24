#include <stdio.h>
#include "QIAstatDx.h"
#include "service.h"

#define MY_PROFILE  "QIAstatDx"

int LoadRegVal(void)
{
    char drive[_MAX_DRIVE];
    char dir[_MAX_DIR];
    char fname[_MAX_FNAME];
    char ext[_MAX_EXT];
    char szFile[260];

    _splitpath(__argv[0], drive, dir, fname, ext);

	sprintf(szFile, "%s%sQIAstatDx.ini", drive, dir);

    g_bLog = GetPrivateProfileInt(MY_PROFILE, "Log", 0, szFile);

    g_bDebug = GetPrivateProfileInt(MY_PROFILE, "Debug", 0, szFile);
        
	GetPrivateProfileString(MY_PROFILE, "LogPath",
                            "C:\\MOXA\\QIAstatDx\\LOG\\", g_szLogPath, 260, szFile);
    AddBslash(g_szLogPath);
    
	GetPrivateProfileString(MY_PROFILE, "InBoxPath",
                            "C:\\MOXA\\QIAstatDx\\INBOX\\", g_szInBoxPath, 260, szFile);
    AddBslash(g_szInBoxPath);
	
	GetPrivateProfileString(MY_PROFILE, "BackupInBoxPath",
                            "C:\\MOXA\\QIAstatDx\\INBOX.BAK\\", g_szBackupInBoxPath, 260, szFile);
    AddBslash(g_szBackupInBoxPath);

	GetPrivateProfileString(MY_PROFILE, "OutBoxPath",
                            "C:\\MOXA\\QIAstatDx\\OUTBOX\\", g_szOutBoxPath, 260, szFile);
    AddBslash(g_szOutBoxPath);

    GetPrivateProfileString(MY_PROFILE, "TempPath",
                            "C:\\MOXA\\QIAstatDx\\TEMP\\", g_szTempPath, 260, szFile);
    AddBslash(g_szTempPath);
    
	g_dwSleep = GetPrivateProfileInt(MY_PROFILE, "Sleep", 1000, szFile);
        
	g_nPort = GetPrivateProfileInt(MY_PROFILE, "Port", 0, szFile);
    
	g_nMaxRetry = GetPrivateProfileInt(MY_PROFILE, "Retry", 3, szFile);
	    
	g_bBackupInbox = GetPrivateProfileInt(MY_PROFILE, "BackupInbox", 0, szFile);
	
	g_timeout = GetPrivateProfileInt(MY_PROFILE, "timeout", 10000, szFile);
//db
	GetPrivateProfileString(MY_PROFILE, "Server",
                            "139.168.200.1", g_db, 260, szFile);

    g_nMaxClient = GetPrivateProfileInt(MY_PROFILE, "MaxClient", 5, szFile);

    g_bOverwriteTNS = GetPrivateProfileInt(MY_PROFILE, "OverwriteTNS", 0, szFile);

    GetPrivateProfileString(MY_PROFILE, "TNSFileSource",
                            "C:\\MOXA\\QIAstatDx\\tnsnames.ora", g_szTNSFileSource, 260, szFile);

    GetPrivateProfileString(MY_PROFILE, "TNSFileDest",
                            "C:\\oracle\\ora92\\network\\ADMIN\\tnsnames.ora", g_szTNSFileDest, 260, szFile);

    return 0;
}

