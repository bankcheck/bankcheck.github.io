#include <stdio.h>
#include <string.h>
#include <time.h>
#include "clinitek500.h"

int SendFile(char *fname)
{
    char buf[1024];
    char cmd[260];
    int done;
    DWORD dwLen;

    WriteLog("Processing %s", fname);
    if (ConvertClinitek500Code(fname, buf) == 0)
        return 0;

    done = 0;
    while (1) {
        if (g_bCheckOnline) {
            DWORD           dwStatus;
            COMSTAT         cs;
            DWORD           dwError, dwErrorFlag;

            if (g_bDebug)
                WriteLog("Checking port status...");
            if (GetCommModemStatus(g_hCom, &dwStatus) == FALSE) {
                dwError = GetLastError();
                ClearCommError(g_hCom, &dwErrorFlag, &cs);
                WriteLog("GetCommModemStatus() failed, code %ld, flag %ld", dwError, dwErrorFlag);
                return 1;
            }
            if ((dwStatus & MS_CTS_ON) == 0) {
                WriteLog("No physical connection...");
                return 1;
            }
        }
        WriteLog("Send EOT SOH...");
        cmd[0] = EOT;
        cmd[1] = SOH;
        cmd[2] = '\0';
        SendChar(g_hCom, cmd, 2);
        FlushFileBuffers(g_hCom);
        while (1) {
            if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
                g_bQuit = TRUE;
                break;
            }
            if (ReadDataFromComm(&dwLen, cmd) > 0)
                break;
        }
        if (g_bQuit) break;
        if ((cmd[0] == EOT && cmd[1] == SOH) ||
            (cmd[0] == '[') || (cmd[0] == ENQ)) {
            WriteLog("Receive EOT, SOH, '[' or ENQ %s", cmd);
            break;
        }
        if (cmd[0] == NAK) {
            WriteLog("Receive NAK...");
            Sleep(1000);
            continue;
        }
        else if (cmd[0] == ACK) {
            WriteLog("Receive ACK...");
            while (1) {
                if (g_bCheckOnline) {
                    DWORD           dwStatus;
                    COMSTAT         cs;
                    DWORD           dwError, dwErrorFlag;

                    if (g_bDebug)
                        WriteLog("Checking port status...");
                    if (GetCommModemStatus(g_hCom, &dwStatus) == FALSE) {
                        dwError = GetLastError();
                        ClearCommError(g_hCom, &dwErrorFlag, &cs);
                        WriteLog("GetCommModemStatus() failed, code %ld, flag %ld", dwError, dwErrorFlag);
                        return 1;
                    }
                    if ((dwStatus & MS_CTS_ON) == 0) {
                        WriteLog("No physical connection...");
                        return 1;
                    }
                }
                WriteLog("Send: %s...", buf);
                SendChar(g_hCom, buf, strlen(buf));
                FlushFileBuffers(g_hCom);
                while (1) {
                    if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
                        g_bQuit = TRUE;
                        break;
                    }
                    if (ReadDataFromComm(&dwLen, cmd) > 0)
                        break;
                    if (g_bCheckOnline) {
                        DWORD           dwStatus;
                        COMSTAT         cs;
                        DWORD           dwError, dwErrorFlag;

                        if (g_bDebug)
                            WriteLog("Checking port status...");
                        if (GetCommModemStatus(g_hCom, &dwStatus) == FALSE) {
                            dwError = GetLastError();
                            ClearCommError(g_hCom, &dwErrorFlag, &cs);
                            WriteLog("GetCommModemStatus() failed, code %ld, flag %ld", dwError, dwErrorFlag);
                            return 1;
                        }
                        if ((dwStatus & MS_CTS_ON) == 0) {
                            WriteLog("No physical connection...");
                            return 1;
                        }
                    }
                }
                if (g_bQuit) break;
                if (cmd[0] == NAK) {
                    WriteLog("Receive NAK...");
                    Sleep(1000);
                    continue;
                }
                else if (cmd[0] == ETX) {
                    WriteLog("Receive ETX, Receive EOT...");
                    cmd[0] = EOT;
                    cmd[1] = '\0';
                    SendChar(g_hCom, cmd, 1);
                    FlushFileBuffers(g_hCom);
                    done = 1;
                    break;
                }
            }
        }
        else {
			WriteLog("Receive Unknown Packet");
			DumpErrorData(8, cmd);
		}
        if (done) break;
    }
    if (done) {
        char bakname[260];
        time_t t;
        struct tm *tp;
        char drive[_MAX_DRIVE];
        char dir[_MAX_DIR];
        char name[_MAX_FNAME];
        char ext[_MAX_EXT];

        time(&t);
        tp = localtime(&t);
        if (tp != NULL) {
            _splitpath(fname, drive, dir, name, ext);
            sprintf(bakname, "%s%02d%02d%02d_%s%s\n", g_szBackupInBoxPath,
                              tp->tm_hour, tp->tm_min, tp->tm_sec, name, ext);
            WriteLog("Move file from %s to %s", fname, bakname);
            CopyFile(fname, bakname, FALSE);
        }
        DeleteFile(fname);
    }
    return 1;
}
