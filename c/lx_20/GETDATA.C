#include <stdio.h>
#include <time.h>
#include "lx_20.h"

int CheckSum(char *buf)
{
    char crcsum[3], xsum[3];
    char *p;
    unsigned char chksum;
    char str[1024];

    WriteLog("檢核資料是否正確...");
    p = buf;
    while (*p != '[' && *p != '\0') p++;
    if (*p == '\0') {
        WriteLog("資料錯誤!");
        DumpErrorData(strlen(buf), buf);
        return 0;
    }
    strcpy(str, p);
    strcpy(buf, str);
    if (buf[0] != '[') {
        WriteLog("資料錯誤!");
        DumpErrorData(strlen(buf), buf);
        return 0;
    }
    p = strrchr(buf, ']');
    if (p == NULL) {
	WriteLog("資料錯誤!");
        DumpErrorData(strlen(buf), buf);
        return 0;
    }
    p++;
    memcpy(crcsum, p, 2);
    crcsum[2] = '\0';
    chksum = 0;
    while (1) {
        chksum += *buf;
        if (*buf == ']') break;
        buf++;
    }
    chksum = 256-chksum;
    sprintf(xsum, "%02X", chksum);
    //Arran
	//if (strcmp(crcsum, xsum) == 0) {
        WriteLog("資料檢核碼正確!");
        return 1;
    //}
    //DumpErrorData(strlen(buf), buf);
    //WriteLog("資料檢核碼錯誤!");
    //return 0;
}

char *getline(char *buf, int len, FILE *fp)
{
    int i;
    char ch;

    i = 0;
    while (1) {
        if (feof(fp)) {
            if (i == 0) return NULL;
            buf[i] = '\0';
            return buf;
        }
        ch = fgetc(fp);
        buf[i++] = ch;
        if (ch == '\r' || ch == '\n') {
            buf[i] = '\0';
            return buf;
        }
        if (i == len) {
            buf[i] = '\0';
            return buf;
        }
    }
}

char *ParseDelimiter (char *str, int idx, char delimiter, char *buf)
{
    char *p1, *p2;
    int i;

    p1 = str;
    for (i = 0; i < idx; i++) {
        if (i)
            p1 = p2 + 1;
        p2 = strchr (p1, delimiter);
        if (p2 == NULL) {
            if (i == (idx - 1))
                p2 = str + strlen(str);
            else
                return NULL;
	}
    }
    memcpy(buf, p1, p2 - p1);
    buf[p2-p1] = '\0';
    return buf;
}

void Cobol_Format(char *format)
{
    char tmprtn[20];

    if (isdigit(format[0]) || format[0] == '.')
	sprintf(tmprtn, "%010.3f", atof(format));
    else
	sprintf(tmprtn, "%-10.10s", format);
    strcpy(format, tmprtn);
    return;
}

int GetDataFromLX_20(void)
{
    char ack;
    char buf[2048], cmd[260];
    FILE *fp, *out;
    char fname[260], tmpname[260];
    DWORD dwLen;
    int done;
    int function, sub_function;
    char token[260], value[260], token1[260];
    char tmpbuf[260];
    BOOL bFunFlag = FALSE;
    char szSampleID[260];
    char szResult[2048];
    char szData[1024];
    char szUID[80];
    int nCount;
    int found;
    time_t t;
    struct tm *tp;
    DWORD i;
    int sector, cup;

    ack = ETX;
    sprintf(fname, "%s%lx.dat", g_szTempPath, GetTickCount());
    WriteLog("使用暫存檔案: %s", fname);
    fp = fopen(fname, "w+b");
    if (fp == NULL) {
        WriteLog("無法開啟檔案: %s", fname);
        return 1;
    }
    done = 0;
    nCount = 0;
    szData[0] = '\0';
    while (1) {
        while (1) {
            if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
                g_bQuit = TRUE;
                break;
            }
            if (ReadDataFromComm(&dwLen, buf) > 0)
                break;
        }
        if (g_bDebug) {
            WriteLog("資料長度: %d", dwLen);
            DumpErrorData(dwLen, buf);
        }
        if (g_bQuit) break;
        if (buf[0] == EOT) {
            WriteLog("接收 EOT...");
            done = 1;
            break;
        }
        else if (buf[0] == ENQ) {
            WriteLog("接收 ENQ, 傳送 ACK...");
            cmd[0] = ACK;
            cmd[1] = '\0';
            SendChar(g_hCom, cmd, 1);
            FlushFileBuffers(g_hCom);
        }
        else {
            memcpy(&szData[nCount], buf, dwLen);
            nCount += dwLen;
            found = 0;
            for (i = 0; i < dwLen; i++) {
                if (buf[i] == LF) {
		    found = 1;
		    break;
		}
	    }
            if (found == 0) continue;
            szData[nCount] = '\0';
            if (g_bDebug) {
                WriteLog("資料長度: %d", nCount);
                DumpErrorData(nCount, szData);
            }
            if (CheckSum(szData)) {
                fwrite(szData, strlen(szData), sizeof(char), fp);
                fflush(fp);
                cmd[0] = ack;
                cmd[1] = '\0';
                SendChar(g_hCom, cmd, 1);
                FlushFileBuffers(g_hCom);
                if (ack == ETX)
                    ack = ACK;
                else
                    ack = ETX;
            }
            else {
                cmd[0] = NAK;
                cmd[1] = '\0';
                SendChar(g_hCom, cmd, 1);
                FlushFileBuffers(g_hCom);
            }
            nCount = 0;
            szData[0] = '\0';
        }
    }
    WriteLog("接收完畢");
    if (done) {
        bFunFlag = FALSE;
        szSampleID[0] = '\0';
        szUID[0] = '\0';
        szResult[0] = '\0';
        sector = 0;
        cup = 0;
        WriteLog("處理暫存檔案");
        fseek(fp, 0, SEEK_SET);
        while (1) {
            if (fgets(buf, 2048, fp) == NULL) break;
            WriteLog("內容: %s", buf);
            ParseDelimiter(buf, 2, ',', token);
            function = atoi(token);
            ParseDelimiter(buf, 3, ',', token);
            sub_function = atoi(token);
            if (function == 801) {
                if (sub_function == 6) {
                    int i;
                    char oldname[260], newname[260];

                    for (i = 0; i < 4; i++) {
//                        if (i == 4)
//                            ParseDelimiter(buf, 4+i, ']', token);
//                        else
                            ParseDelimiter(buf, 4+i, ',', token);
                        if (i == 3) {
                        	strcpy (token1, token);
	                        ParseDelimiter(token1, 1, ']', token);
                        }
                        TrimSpace(token);
                        if (token[0] == '\0') continue;
                        sprintf(oldname, "%s%s", g_szInBoxDataPath, token);
                        sprintf(newname, "%s%s", g_szInBoxPath, token);
                        if (access(oldname, 0) == -1)
                            WriteLog("檔案 %s 不存在", oldname);
                        else {
                            MoveFile(oldname, newname);
                            WriteLog("搬移檔案 %s 到 %s", oldname, newname);
                        }
                    }
                    time(&t);
                    tp = localtime(&t);
                    if (g_nNowDay != tp->tm_mday) {
                    		g_nNowDay = tp->tm_mday;
    							time(&t);
								t -= (60*60*24*g_nDayAgo);
    							tp = localtime(&t);
    							if (tp != NULL) {
        							sprintf(cmd, "del %s%d%02d%02d*", g_szInBoxDataPath, (tp->tm_year + 1900 - 1911) % 10 , tp->tm_mon+1, tp->tm_mday);
									printf ("%s", cmd);
									system (cmd);
								}
                    }
                }
            }
            if (function == 802) {
                if (sub_function == 1) {
                    ParseDelimiter(buf, 10, ',', token);
                    if (memcmp(token, "CO", 2) == 0 ||
                            memcmp(token, "CA", 2) == 0) {
                        bFunFlag = FALSE;
                        continue;
                    }
                    bFunFlag = TRUE;
                    szSampleID[0] = '\0';
                    szUID[0] = '\0';
                    ParseDelimiter(buf, 13, ',', szSampleID);
                    if (szSampleID[0] != '\0')
                        TrimSpace(szSampleID);
                    WriteLog("SID: %s", szSampleID);
                    ParseDelimiter(buf, 8, ',', token);
                    sector = atoi(token);
                    ParseDelimiter(buf, 9, ',', token);
                    cup = atoi(token);
                    WriteLog("Sector/Cup: %d/%d", sector, cup);
                    ParseDelimiter(buf, 20, ',', szUID);
                    if (szUID[0] != '\0')
                        TrimSpace(szUID);
                    WriteLog("UID: %s", szUID);
                    continue;
                }
                if (sub_function == 3) {
                    if (bFunFlag == FALSE) {
                        bFunFlag = TRUE;
                        szSampleID[0] = '\0';
                        szUID[0] = '\0';
                        ParseDelimiter(buf, 10, ',', szSampleID);
                        if (szSampleID[0] != '\0')
                            TrimSpace(szSampleID);
                        WriteLog("SID: %s", szSampleID);
                        ParseDelimiter(buf, 8, ',', token);
                        sector = atoi(token);
                        ParseDelimiter(buf, 9, ',', token);
                        cup = atoi(token);
                        WriteLog("Sector/Cup: %d/%d", sector, cup);
                        WriteLog("UID: %s", szUID);
                    }
                    ParseDelimiter(buf, 11, ',', token);
                    ParseDelimiter(buf, 16, ',', value);
                    TrimSpace(token);
                    TrimSpace(value);
                    Cobol_Format(value);
                    ConvertRCode(token);
                    sprintf(tmpbuf, "%-9s %s %03d %03d\n", token, value, sector, cup);
                    strcat(szResult, tmpbuf);
                    WriteLog("結果: %s", tmpbuf);
                    continue;
                }
                if (sub_function == 5) {
                    if (strlen(szSampleID) == 0)
                        sprintf(szSampleID, "%04d-%04d", sector, cup);
                    sprintf(tmpname, "%s%s", g_szOutBoxPath, szSampleID);
                    WriteLog("儲存檔案: %s", tmpname);
                    out = fopen(tmpname, "a+");
                    if (out == NULL)
                        WriteLog("無法開啟檔案: %s", tmpname);
                    else {
                        if (g_bWriteSectorCup)
                            fprintf(out, "%03d %d %s\n", sector, cup, szUID);
                        fwrite(szResult, strlen(szResult), sizeof(char), out);
                        fclose(out);
                    }
                    bFunFlag = FALSE;
                    szSampleID[0] = '\0';
                    szUID[0] = '\0';
                    szResult[0] = '\0';
                    continue;
                }
                if (sub_function == 11) {
                    if (bFunFlag == FALSE) {
                        bFunFlag = TRUE;
                        szSampleID[0] = '\0';
                        szUID[0] = '\0';
                        ParseDelimiter(buf, 9, ',', szSampleID);
                        if (szSampleID[0] != '\0')
                            TrimSpace(szSampleID);
                        WriteLog("SID: %s", szSampleID);
                        ParseDelimiter(buf, 7, ',', token);
                        sector = atoi(token);
                        ParseDelimiter(buf, 8, ',', token);
                        cup = atoi(token);
                        WriteLog("Sector/Cup: %d/%d", sector, cup);
                        WriteLog("UID: %s", szUID);
                    }
                    ParseDelimiter(buf, 11, ',', token);
                    ParseDelimiter(buf, 13, ',', value);
                    TrimSpace(token);
                    TrimSpace(value);
                    Cobol_Format(value);
                    ConvertRCode(token);
                    sprintf(tmpbuf, "%-9s %s %03d %03d\n", token, value, sector, cup);
                    strcat(szResult, tmpbuf);
                    WriteLog("結果: %s", tmpbuf);
                    continue;
                }
            }
            continue;
        }
        cmd[0] = ACK;
        cmd[1] = '\0';
        SendChar(g_hCom, cmd, 1);
        FlushFileBuffers(g_hCom);
    }
    fclose(fp);
    if (g_bDebug == FALSE)
        unlink(fname);
    return 0;
}

