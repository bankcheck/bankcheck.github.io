#include <stdio.h>
#include "UN2000.h"
#include "service.h"

#define MY_PROFILE  "UN2000"

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
                            "UN2000", g_szProgID, 40, szFile);
    
	GetPrivateProfileString(MY_PROFILE, "LogPath",
                            "C:\\MOXA\\UN2000\\LOG\\", g_szLogPath, 260, szFile);
    AddBslash(g_szLogPath);
    
	g_dwSleep = GetPrivateProfileInt(MY_PROFILE, "Sleep", 1000, szFile);
        
	g_nPort = GetPrivateProfileInt(MY_PROFILE, "Port", 0, szFile);
    
	g_nMaxRetry = GetPrivateProfileInt(MY_PROFILE, "Retry", 3, szFile);
	
	GetPrivateProfileString(MY_PROFILE, "CodeFile",
                            "C:\\MOXA\\UN2000\\CODE.DAT", g_szCodeFile, 260, szFile);
    	
	g_timeout = GetPrivateProfileInt(MY_PROFILE, "timeout", 10000, szFile);
    
	GetPrivateProfileString(MY_PROFILE, "OutBoxPath",
                            "C:\\MOXA\\UN2000\\OUTBOX\\", g_szOutBoxPath, 260, szFile);

    GetPrivateProfileString(MY_PROFILE, "TempPath",
                            "C:\\MOXA\\UN2000\\TEMP\\", g_szTempPath, 260, szFile);
    AddBslash(g_szTempPath);

    GetPrivateProfileString(MY_PROFILE, "RateFile",
                            "c:\\MOXA\\UN2000\\RATE.DAT", g_szRateFile, 260, szFile);
    
    GetPrivateProfileString(MY_PROFILE, "FormatFile",
                            "c:\\MOXA\\UN2000\\FORMAT.DAT", g_szFormatFile, 260, szFile);

	GetPrivateProfileString(MY_PROFILE, "DefaultFormat",
                            "RAW", g_ResultFormat, 11, szFile);
	
    g_bReset = GetPrivateProfileInt(MY_PROFILE, "Reset", 0, szFile);

    g_bSkipZeroResult = GetPrivateProfileInt(MY_PROFILE, "SkipZeroResult", 0, szFile);

    GetPrivateProfileString(MY_PROFILE, "DecimalMapping",
                            "c:\\MOXA\\UN2000\\DEC.DAT", g_szDecFile, 260, szFile);

    return 0;
}

