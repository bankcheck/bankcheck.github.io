#include <stdio.h>
#include <string.h>
#include <time.h>
#include "urt.h"

#define MAX_TESTS   30

typedef struct {
    char  code[10];
    int   value;
} TESTLIST;

int ConvertRCode(char *code)
{
    char buf[1024];
    char val[256];
    FILE *fp;
    char *p;

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
        strcpy(val, p);
        p = strtok(NULL, " \t=,\r\n");
        if (p == NULL) {
            WriteLog("Error setting for %s", code);
            continue;
        }
        if (strcmp(p, code) == 0) {
            strcpy(code, val);
            fclose(fp);
            return 1;
        }
    }
    fclose (fp);
    //WriteLog("Can't find setting for %s", code);
    return (0);
}

int ConvertCode(char *item, char *code, int *comment)
{
    char buf[1024];
    FILE *fp;
    char *p;

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
            if (p == NULL)
                *comment = 0;
            else
                *comment = atoi(p);
            fclose(fp);
            return 1;
        }
    }
    fclose (fp);
    WriteLog("Can't find setting for %s", item);
    return (0);
}