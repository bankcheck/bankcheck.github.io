#include <stdio.h>
#include <string.h>
#include <time.h>
#include "access.h"

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
        return 1;
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

int ConvertaccessCode(char *fname, int seq, char *patient, char *order)
{
    FILE *fp;
    TESTLIST tests[MAX_TESTS];
    char buf[1024];
    char str[1024];
    char *p;
    char *tp;
    int i;
    char code[20];
	char name[41];
	char fullname[260];

	char *LabNo;
	char priority;
	int num;

    //WriteLog("Âà´«ÀËÅç¥N½X...");
    fp = fopen(fname, "rt");
    if (fp == NULL) {
        WriteLog("Can't open file: %s", fname);
        return 0;
    }

    fgets(buf, 1024, fp);
    WriteLog("DATA: %s", buf);

//Header Info
    LabNo = strrchr(fname, '_');
	LabNo++;

	priority=*(strrchr(buf, '|')+1);

	tp = strtok(buf, "|");
	strcpy (fullname, tp);

	ParseDelimiter(fullname, 1, ',', tp);
	if (strlen(tp) > 20)
		tp[20] = '\0';
	sprintf(name, "%s^\0", tp);

	ParseDelimiter(fullname, 2, ',', tp);
	TrimSpace(tp);
	if (strlen(tp) > 20)
		tp[20] = '\0';

	strcat (name, tp);

    memset(str, '\0', 1024);
    sprintf(str, "P|%1d||%s||%s\n\0", seq, LabNo, name);
	strcpy (patient, str);
	
	num = 0;
	while (1) {
        if (fgets(buf, 1024, fp) == NULL) break;
        p = strtok(buf, " \t\r\n");
        if (p == NULL) continue;
        WriteLog("TESTCODE: %s", p);

        ConvertCode(p, code);

        strcpy(tests[num].code, code);
        //tests[num].value = 0;
        num++;
    }
    fclose(fp);

    memset(str, '\0', 1024);
    sprintf(buf, "O|1|%s||\0", LabNo);
    strcat(str, buf);

    for (i = 0; i < num; i++) {
		if (i > 0)
			sprintf(buf, "\\^^^%s\0", tests[i].code);
		else
			sprintf(buf, "^^^%s\0", tests[i].code);

        strcat(str, buf);
    }

	if (priority == 'R') {
	    sprintf(buf, "|||||||N||||||||||||||O\n\0");
	} else {
	    sprintf(buf, "|S||||||N||||||||||||||O\n\0");
	}

    strcat (str, buf);
	strcpy (order, str);

    return 1;
}

