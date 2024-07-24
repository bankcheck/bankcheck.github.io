#include <stdio.h>
#include <time.h>
#include "urt.h"

int RemoveSpace(char *buf)
{
    char str[2048];
    char *p;

    p = buf;
    while (*p == ' ' || *p == '\t' || *p =='\r' || *p =='\n') p++;
    strcpy(str, p);
    strcpy(buf, str);
    return 0;
}

int RemoveEndSpace(char *buf)
{
    int len;

    len = strlen(buf);
    len--;
    while (len >= 0) {
        if (buf[len] != ' ' && buf[len] != '\t' && buf[len] != '\r' && buf[len] != '\n')
            break;
        len--;
    }
    if (len < 0)
       buf[0] = '\0';
    else
       buf[len+1] = '\0';
    return 0;
}

int TrimSpace(char *buf)
{
    RemoveSpace(buf);
    RemoveEndSpace(buf);
    return 0;
}

int DumpErrorData(int len, char *buf)
{
    char *p;
    FILE *fp;
    char fname[260];
    int i;
    time_t t;
    struct tm *tp;

    time(&t);
    tp = localtime(&t);
    sprintf(fname, "%s%02d%02dERR.LOG", g_szLogPath, tp->tm_mon+1, tp->tm_mday);
    fp = fopen(fname, "ab");
    if (fp != NULL) {
        fprintf(fp, "%02d:%02d:%02d\r\n",
                tp->tm_hour, tp->tm_min, tp->tm_sec);
        fprintf(fp, "Data (%d):", len);
        p = buf;
        for (i = 0; i < len; i++)
            fprintf(fp, " %02X", 0x00FF & *p++);
        fprintf(fp, "\r\nValue: ");
        p = buf;
        for (i = 0; i < len; i++) {
            if (*p < 20)
                fprintf(fp, "<%d>", 0x00FF & *p++);
            else
                fprintf(fp, "%c", *p++);
        }
        fprintf(fp, "\r\n");
        fprintf(fp, "\r\n");
        fflush(fp);
        fclose(fp);
    }
    else
        WriteLog("Can't open %s", fname);
    return 0;
}

int AddBslash(char *s)
{
    int len;

    len = strlen(s);
    if (len == 0) return 0;
    if (s[len-1] == '\\' || s[len-1] == '/') return 0;
    s[len++] = '\\';
    s[len] = '\0';
    return 1;
}


void GetToken(char *str, char *token, int no)
{
    char *p;
    int i;

    i = 1;
    p = str;
    while (i < no) {
        if (*p == ',')
            i++;
        if (*p == '\0') break;
        p++;
    }
    if (i != no) {
        token[0] = '\0';
        return;
    }
    i = 0;
    token[i] = '\0';
    while (1) {
        if (*p == ',') break;
        if (*p == '\0') break;
        if (*p == '\r' || *p == '\n') break;
        token[i++] = *p++;
    }
    token[i] = '\0';
    TrimSpace(token);
    return;
}

void writeRowFile (int row) {
	char buf[260];
    FILE *fRow;
	fRow = fopen(g_szRowFile, "wt");
	sprintf(buf, "%d\n", row);
	fwrite(buf, strlen(buf), sizeof(char), fRow);
    fclose(fRow);
}

int ConvertCode(char CodeFile[260], char *code)
{
    char buf[1024];
    char val[256];
    FILE *fp;
    char *p;

    fp = fopen(CodeFile, "rb");
    if (fp == NULL) {
        WriteLog("Cannot open file: %s", CodeFile);
        return 0;
    }

    while (1) {
        if (fgets(buf, 1024, fp) == NULL) break;
        p = strtok(buf, " \t=,\r\n");
        if (p == NULL) continue;
        if (*p == '#' || *p == ';') continue;   // comment
        strcpy(val, p);
        p = strtok(NULL, " \t=\r\n");
        if (p == NULL) {
            WriteLog("Error setting for %s", code);
            continue;
        }
        if (strcmp(val, code) == 0) {
            strcpy(code, p);
            fclose(fp);
            return 1;
        }
    }
    fclose (fp);
    //WriteLog("Can't find setting for %s", code);
    return (0);
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
