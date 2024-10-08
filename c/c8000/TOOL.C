#include <stdio.h>
#include <time.h>
#include "c8000.h"

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

int ConvertCode(char *item, char *code)
{
    char buf[1024];
    FILE *fp;
    char *p;

    strcpy(code, item);

    fp = fopen(g_szCodeFile, "rb");
    if (fp == NULL) {
        WriteLog("Can't open file %s", g_szCodeFile);
        return 0;
    }

    while (1) {
        if (fgets(buf, 1024, fp) == NULL) break;
        p = strtok(buf, " \t=,\r\n");
        if (p == NULL) continue;
        if (*p == '#' || *p == ';') continue;   // comment
        if (strcmp(item, p) == 0) {
            p = strtok(NULL, " \t=,\r\n");
            if (p == NULL) {
                WriteLog("Error setting for %s", item);
                continue;
            }
            strcpy(code, p);
            p = strtok(NULL, " \t=,\r\n");
            fclose(fp);
            return 1;
        }
    }
    fclose (fp);
    //WriteLog("Can't find setting for %s", item);
    return (0);
}