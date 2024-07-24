#include <stdio.h>
#include <string.h>
#include <time.h>
#include "maldi.h"

#define MAX_TESTS   100

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
        p = strtok(buf, "\t=,\r\n");
		TrimSpace(p);
        if (p == NULL) continue;
        if (*p == '#' || *p == ';') continue;   // comment
        strcpy(val, p);
        p = strtok(NULL, "\t=,\r\n");
		TrimSpace(p);
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

double ConvertRate(char *code)
{
    char buf[1024];
    char val[256];
    FILE *fp;
    char *p;
	double rate;

    fp = fopen(g_szRateFile, "rb");
    if (fp == NULL) {
        WriteLog("Can't open file %s", g_szRateFile);
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
            rate = atof(val);
            fclose(fp);
            return rate;
        }
    }
    fclose (fp);
    //WriteLog("Can't find setting for %s", code);
    return 1;
}
