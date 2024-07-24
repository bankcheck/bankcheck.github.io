#include <stdio.h>
#include "IRIS.h"
#include "service.h"

#define MY_PROFILE  "IRIS"

int LoadRegVal(void)
{
    char drive[_MAX_DRIVE];
    char dir[_MAX_DIR];
    char fname[_MAX_FNAME];
    char ext[_MAX_EXT];
    char szFile[260];
    char buf[260];

    _splitpath(__argv[0], drive, dir, fname, ext);
    if (drive[0] == '\0' && dir[0] == '\0') {
        char buf[1024];

        GetCurrentDirectory(260, buf);
        sprintf(szFile, "%s\\%s.ini", buf, fname);
    }
    else
        _makepath(szFile, drive, dir, fname, ".ini" );

    g_bWriteSectorCup = GetPrivateProfileInt(MY_PROFILE, "WriteSectorCup", 0, szFile);
    
	//No need heartbeat here
	g_bCheckOnline = GetPrivateProfileInt(MY_PROFILE, "CheckOnline", 0, szFile);
	//g_bCheckOnline = 0;

    g_bReOpenPort = GetPrivateProfileInt(MY_PROFILE, "ReOpenPort", 0, szFile);
    g_bLog = GetPrivateProfileInt(MY_PROFILE, "Log", 0, szFile);
    g_bDebug = GetPrivateProfileInt(MY_PROFILE, "Debug", 0, szFile);
    g_bBackupInbox = GetPrivateProfileInt(MY_PROFILE, "BackupInbox", 0, szFile);
    GetPrivateProfileString(MY_PROFILE, "ProgID",
                            "IRIS", g_szProgID, 40, szFile);
    g_nMaxReadBufferSize = GetPrivateProfileInt(MY_PROFILE, "MaxReadBuffer", 8192, szFile);
    g_nMaxWriteBufferSize = GetPrivateProfileInt(MY_PROFILE, "MaxWriteBuffer", 8192, szFile);
    g_nComBaudRate = GetPrivateProfileInt(MY_PROFILE, "ComBaudRate", 9600, szFile);
    g_nComByteSize = GetPrivateProfileInt(MY_PROFILE, "ComByteSize", 8, szFile);
    GetPrivateProfileString(MY_PROFILE, "ComParity",
                            "NONE", buf, 260, szFile);
    if (stricmp(buf, "EVEN") == 0)
        g_nComParity = EVENPARITY;
    else if (stricmp(buf, "ODD") == 0)
        g_nComParity = ODDPARITY;
    else if (stricmp(buf, "MARK") == 0)
        g_nComParity = MARKPARITY;
    else
        g_nComParity = NOPARITY;
    GetPrivateProfileString(MY_PROFILE, "ComStopBits",
                            "1", buf, 260, szFile);
    if (stricmp(buf, "1.5") == 0)
        g_nComStopBits = ONE5STOPBITS;
    else if (stricmp(buf, "2") == 0)
        g_nComStopBits = TWOSTOPBITS;
    else
        g_nComStopBits = ONESTOPBIT;
    GetPrivateProfileString(MY_PROFILE, "LogPath",
                            "D:\\MOXA\\IRIS\\LOG\\", g_szLogPath, 260, szFile);
    AddBslash(g_szLogPath);
    GetPrivateProfileString(MY_PROFILE, "BackupInBoxPath",
                            "D:\\MOXA\\IRIS\\INBOX.BAK\\", g_szBackupInBoxPath, 260, szFile);
    AddBslash(g_szBackupInBoxPath);
    GetPrivateProfileString(MY_PROFILE, "InBoxPath",
                            "D:\\MOXA\\IRIS\\INBOX\\", g_szInBoxPath, 260, szFile);
    AddBslash(g_szInBoxPath);
    GetPrivateProfileString(MY_PROFILE, "InBoxDataPath",
                            "D:\\MOXA\\IRIS\\INBOX\\", g_szInBoxDataPath, 260, szFile);
    AddBslash(g_szInBoxDataPath);
    GetPrivateProfileString(MY_PROFILE, "OutBoxPath",
                            "D:\\MOXA\\IRIS\\OUTBOX\\", g_szOutBoxPath, 260, szFile);
    AddBslash(g_szOutBoxPath);
    GetPrivateProfileString(MY_PROFILE, "TempPath",
                            "D:\\MOXA\\IRIS\\TEMP\\", g_szTempPath, 260, szFile);
    AddBslash(g_szTempPath);

    GetPrivateProfileString(MY_PROFILE, "CodeFile",
                            "D:\\MOXA\\IRIS\\CODE.DAT", g_szCodeFile, 260, szFile);
    GetPrivateProfileString(MY_PROFILE, "RateFile",
                            "D:\\MOXA\\IRIS\\RATE.DAT", g_szRateFile, 260, szFile);

    g_nComPort = GetPrivateProfileInt(MY_PROFILE, "ComPort", 1, szFile);
    g_nMappingIndex = GetPrivateProfileInt(MY_PROFILE, "MappingIndex", 0, szFile);
    GetPrivateProfileString(MY_PROFILE, "FileMapping",
                            "MOXA_MONITOR", g_szFileMapping, 260, szFile);
    g_dwSleep = GetPrivateProfileInt(MY_PROFILE, "Sleep", 1000, szFile);
    g_dwRecvWait = GetPrivateProfileInt(MY_PROFILE, "RecvWait", 60000, szFile);

    GetPrivateProfileString(MY_PROFILE, "FilePre", "4", g_szFilePre, 2, szFile);
    g_nDayAgo = GetPrivateProfileInt(MY_PROFILE, "DayAgo", 2, szFile);
    g_InstrumentDate = GetPrivateProfileInt(MY_PROFILE, "UseInstrumentDate", 1, szFile);
    //g_Numeric = GetPrivateProfileInt(MY_PROFILE, "NumericResult", 1, szFile);
    g_mode = GetPrivateProfileInt(MY_PROFILE, "mode", 1, szFile);

    return 0;
}

