#include <stdio.h>
#include "MindrayADT.h"
#include "service.h"

#define MY_PROFILE  "ADT"

int LoadRegVal(void)
{
    char drive[_MAX_DRIVE];
    char dir[_MAX_DIR];
    char fname[_MAX_FNAME];
    char ext[_MAX_EXT];
    char szFile[260];
//    char buf[1024];

    _splitpath(__argv[0], drive, dir, fname, ext);
/*	
    if (drive[0] == '\0' && dir[0] == '\0') {
        GetCurrentDirectory(260, buf);
        sprintf(szFile, "%s\\%s.ini", buf, fname);
    }
    else
        _makepath(szFile, drive, dir, fname, ".ini" );
*/
	sprintf(szFile, "%s%sMINDRAY.ini", drive, dir);


    g_bLog = GetPrivateProfileInt(MY_PROFILE, "Log", 0, szFile);
    g_bDebug = GetPrivateProfileInt(MY_PROFILE, "Debug", 0, szFile);
        
	GetPrivateProfileString(MY_PROFILE, "LogPath",
                            "C:\\HL7\\MINDRAY\\LOG.ADT\\", g_szLogPath, 260, szFile);
    AddBslash(g_szLogPath);
    
	GetPrivateProfileString(MY_PROFILE, "InBoxPath",
                            "C:\\HL7\\MINDRAY\\INBOX.ADT\\", g_szInBoxPath, 260, szFile);
    AddBslash(g_szInBoxPath);
	
	GetPrivateProfileString(MY_PROFILE, "BackupInBoxPath",
                            "C:\\HL7\\MINDRAY\\INBOX.BAK\\ADT\\", g_szBackupInBoxPath, 260, szFile);
    AddBslash(g_szBackupInBoxPath);

	GetPrivateProfileString(MY_PROFILE, "OutBoxPath",
                            "C:\\HL7\\MINDRAY\\OUTBOX\\", g_szOutBoxPath, 260, szFile);
    AddBslash(g_szOutBoxPath);

    GetPrivateProfileString(MY_PROFILE, "TempPath",
                            "C:\\MOXA\\MINDRAY\\TEMP\\", g_szTempPath, 260, szFile);
    AddBslash(g_szTempPath);
    
	g_dwSleep = GetPrivateProfileInt(MY_PROFILE, "Sleep", 1000, szFile);
        
	g_nPort = GetPrivateProfileInt(MY_PROFILE, "Port", 0, szFile);
    
	g_nMaxRetry = GetPrivateProfileInt(MY_PROFILE, "Retry", 3, szFile);
	    
	g_bBackupInbox = GetPrivateProfileInt(MY_PROFILE, "BackupInbox", 0, szFile);
	
	g_timeout = GetPrivateProfileInt(MY_PROFILE, "timeout", 1000, szFile);
    
    return 0;
}

