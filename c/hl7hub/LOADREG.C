#include "hl7hub.h"
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

    g_bLog = GetPrivateProfileInt(MY_PROFILE, "Log", 0, g_szProfile);
    g_bDebug = GetPrivateProfileInt(MY_PROFILE, "Debug", 0, g_szProfile);

    g_dwMaxIdle = GetPrivateProfileInt(MY_PROFILE, "MaxIdle", 0, g_szProfile);
    g_dwSleepTime = GetPrivateProfileInt(MY_PROFILE, "SleepTime", 1000, g_szProfile);
    g_dwErrorSleepTime = GetPrivateProfileInt(MY_PROFILE, "ErrorSleepTime", 10000, g_szProfile);
    GetPrivateProfileString(MY_PROFILE, "Root",
                            "C:\\", g_szRoot, 260, g_szProfile);
    GetPrivateProfileString(MY_PROFILE, "RootPath",
                            "C:\\hl7hub\\", g_szRootPath, 260, g_szProfile);
    GetPrivateProfileString(MY_PROFILE, "Server",
                            "139.168.200.1", g_szServer, 260, g_szProfile);
    GetPrivateProfileString(MY_PROFILE, "TempPath",
                            "C:\\MOXA\\HL7HUB\\TEMP\\", g_szTempPath, 260, g_szProfile);
    AddBslash(g_szTempPath);

_TRY_EXCEPTION_BLOCK_END(1)

    return 0;
}
