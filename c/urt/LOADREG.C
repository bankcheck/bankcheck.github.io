#include <stdio.h>
#include "urt.h"
#include "service.h"

#define MY_PROFILE  "urt"

int LoadRegVal(void)
{
    char drive[_MAX_DRIVE];
    char dir[_MAX_DIR];
    char fname[_MAX_FNAME];
    char ext[_MAX_EXT];
    char szFile[260];
 //   char buf[260];

    _splitpath(__argv[0], drive, dir, fname, ext);
    if (drive[0] == '\0' && dir[0] == '\0') {
        char buf[1024];

        GetCurrentDirectory(260, buf);
        sprintf(szFile, "%s\\%s.ini", buf, fname);
    }
    else
        _makepath(szFile, drive, dir, fname, ".ini" );

    g_bLog = GetPrivateProfileInt(MY_PROFILE, "Log", 0, szFile);
    GetPrivateProfileString(MY_PROFILE, "ProgID",
                            "urt", g_szProgID, 40, szFile);

    GetPrivateProfileString(MY_PROFILE, "LogPath",
                            "D:\\MOXA\\urt\\LOG\\", g_szLogPath, 260, szFile);
    AddBslash(g_szLogPath);

    GetPrivateProfileString(MY_PROFILE, "OutBoxPath",
                            "D:\\MOXA\\urt\\OUTBOX\\", g_szOutBoxPath, 260, szFile);
    AddBslash(g_szOutBoxPath);

    GetPrivateProfileString(MY_PROFILE, "CodeFile",
                            "D:\\MOXA\\urt\\CODE.DAT", g_szCodeFile, 260, szFile);
 
	GetPrivateProfileString(MY_PROFILE, "MachFile",
                            "D:\\MOXA\\urt\\MACH.DAT", g_szMachFile, 260, szFile);

    GetPrivateProfileString(MY_PROFILE, "RowFile",
                            "D:\\MOXA\\urt\\ROW.DAT", g_szRowFile, 260, szFile);

    g_dwSleep = GetPrivateProfileInt(MY_PROFILE, "Sleep", 300000, szFile);
    
	g_page = GetPrivateProfileInt(MY_PROFILE, "FileSize", 100, szFile);

    GetPrivateProfileString(MY_PROFILE, "Server",
                            "Driver={Oracle in OraDb10g_home1};Dbq=seed;UID=lis;PWD=laboratory",
							g_szServer, 260, szFile);

    return 0;
}

