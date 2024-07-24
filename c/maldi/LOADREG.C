#include <stdio.h>
#include "maldi.h"
#include "service.h"

#define MY_PROFILE  "maldi"

int LoadRegVal(void)
{
    char drive[_MAX_DRIVE];
    char dir[_MAX_DIR];
    char fname[_MAX_FNAME];
    char ext[_MAX_EXT];
    char szFile[260];

    _splitpath(__argv[0], drive, dir, fname, ext);
    if (drive[0] == '\0' && dir[0] == '\0') {
        char buf[1024];

        GetCurrentDirectory(260, buf);
        sprintf(szFile, "%s\\%s.ini", buf, fname);
    }
    else
        _makepath(szFile, drive, dir, fname, ".ini" );

    g_bWriteSectorCup = GetPrivateProfileInt(MY_PROFILE, "WriteSectorCup", 0, szFile);
    
    g_bLog = GetPrivateProfileInt(MY_PROFILE, "Log", 0, szFile);
    g_bDebug = GetPrivateProfileInt(MY_PROFILE, "Debug", 0, szFile);

    g_bBackupInbox = GetPrivateProfileInt(MY_PROFILE, "BackupInbox", 0, szFile);
    GetPrivateProfileString(MY_PROFILE, "ProgID",
                            "maldi", g_szProgID, 40, szFile);
    g_nMaxReadBufferSize = GetPrivateProfileInt(MY_PROFILE, "MaxReadBuffer", 8192, szFile);
    g_nMaxWriteBufferSize = GetPrivateProfileInt(MY_PROFILE, "MaxWriteBuffer", 8192, szFile);

    GetPrivateProfileString(MY_PROFILE, "LogPath",
                            "D:\\MOXA\\maldi\\LOG\\", g_szLogPath, 260, szFile);
    AddBslash(g_szLogPath);
    GetPrivateProfileString(MY_PROFILE, "BackupInBoxPath",
                            "D:\\MOXA\\maldi\\INBOX.BAK\\", g_szBackupInBoxPath, 260, szFile);
    AddBslash(g_szBackupInBoxPath);
    GetPrivateProfileString(MY_PROFILE, "InBoxPath",
                            "D:\\MOXA\\maldi\\INBOX\\", g_szInBoxPath, 260, szFile);
    AddBslash(g_szInBoxPath);
    GetPrivateProfileString(MY_PROFILE, "InBoxDataPath",
                            "D:\\MOXA\\maldi\\INBOX\\", g_szInBoxDataPath, 260, szFile);
    AddBslash(g_szInBoxDataPath);
    GetPrivateProfileString(MY_PROFILE, "OutBoxPath",
                            "D:\\MOXA\\maldi\\OUTBOX\\", g_szOutBoxPath, 260, szFile);
    AddBslash(g_szOutBoxPath);
    GetPrivateProfileString(MY_PROFILE, "TempPath",
                            "D:\\MOXA\\maldi\\TEMP\\", g_szTempPath, 260, szFile);
    AddBslash(g_szTempPath);

    GetPrivateProfileString(MY_PROFILE, "CodeFile",
                            "D:\\MOXA\\maldi\\CODE.DAT", g_szCodeFile, 260, szFile);
    GetPrivateProfileString(MY_PROFILE, "RateFile",
                            "D:\\MOXA\\maldi\\RATE.DAT", g_szRateFile, 260, szFile);
    GetPrivateProfileString(MY_PROFILE, "DiluteFile",
                            "D:\\MOXA\\maldi\\DILUTE.DAT", g_szDiluteFile, 260, szFile);

    g_nMappingIndex = GetPrivateProfileInt(MY_PROFILE, "MappingIndex", 0, szFile);
    GetPrivateProfileString(MY_PROFILE, "FileMapping",
                            "MOXA_MONITOR", g_szFileMapping, 260, szFile);

    g_InstrumentDate = GetPrivateProfileInt(MY_PROFILE, "UseInstrumentDate", 1, szFile);
    g_mode = GetPrivateProfileInt(MY_PROFILE, "mode", 1, szFile);

	g_bCheckDigit = GetPrivateProfileInt(MY_PROFILE, "CheckDigit", 0, szFile);

    g_nHeader = GetPrivateProfileInt(MY_PROFILE, "Header", -2, szFile);
	g_nFieldTotal= GetPrivateProfileInt(MY_PROFILE, "FieldTotal", 5, szFile);
	g_nOrganismIndex = GetPrivateProfileInt(MY_PROFILE, "OrganismIndex", 1, szFile);
	g_nScoreIndex = GetPrivateProfileInt(MY_PROFILE, "ScoreIndex", 4, szFile);

    return 0;
}

