#include <stdio.h>
#include <string.h>
#include <time.h>
#include "cobas.h"

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


int ConvertCode(char *item, char *code, int *comment)
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
            if (p == NULL)
                *comment = 0;
            else
                *comment = atoi(p);
            fclose(fp);
            return 1;
        }
    }
    fclose (fp);
    //WriteLog("Can't find setting for %s", item);
    return (0);
}

int ConvertcobasCode(char *fname, int seq, char *order, char *pos)
{
    FILE *fp;
    TESTLIST tests[MAX_TESTS];
    char buf[1024];
    char str[1024];
    char *p;
    //char *tp;
    int use_cmt, i;
    char code[20];
	//char name[41];
	//char fullname[260];

	char *LabNo;
	char priority;
	int num;

	char type;

	time_t t;
    struct tm *timep;

    time(&t);
    timep = localtime(&t);

	LabNo = strrchr(fname, '\\');
	if (strlen(LabNo) > 1) {
		LabNo++;
		sprintf(str, "O|1|%s|%s|\0", LabNo, pos);
	} else {
		//sprintf(str, "O|1||%s|\0", pos);
		return 0;
	}

    //WriteLog("Âà´«ÀËÅç¥N½X...");
    fp = fopen(fname, "rt");
    if (fp == NULL) {
        WriteLog("Can't open file: %s", fname);
	    sprintf(buf, "|R|%d%02d%02d%02d%02d%02d|||||N||||||||||||||Z\n\0", timep->tm_year+1900, timep->tm_mon+1, timep->tm_mday, timep->tm_hour, timep->tm_min, timep->tm_sec);
	    strcat (str, buf);
		strcpy (order, str);
        return 0;
    }

    if (fgets(buf, 1024, fp) == NULL){
        WriteLog("Empty file: %s", fname);
	    sprintf(buf, "|R|%d%02d%02d%02d%02d%02d|||||N||||||||||||||Z\n\0", timep->tm_year+1900, timep->tm_mon+1, timep->tm_mday, timep->tm_hour, timep->tm_min, timep->tm_sec);
	    strcat (str, buf);
		strcpy (order, str);
        return 0;
    }

    if (g_bDebug)
	    WriteLog("DATA: %s", buf);

//Header Info
	priority=*(strrchr(buf, '|')+1);

	num = 0;
	while (1) {
        if (fgets(buf, 1024, fp) == NULL) break;
        p = strtok(buf, " \t\r\n");

        if (p == NULL) continue;

        if (g_bDebug)
			WriteLog("TESTCODE: %s", p);

        ConvertCode(p, code, &use_cmt);

        strcpy(tests[num].code, code);

        num++;
    }
    fclose(fp);

    for (i = 0; i < num; i++) {
		if (i > 0)
			sprintf(buf, "\\^^^%s\0", tests[i].code);
		else
			sprintf(buf, "^^^%s\0", tests[i].code);

        strcat(str, buf);
    }

	if (g_mode == 2) {
		type = 'Q';
	} else {
		type = 'O';
	}

	if (i == 0)
		type = 'Z';

	if (priority == 'R') {
	    sprintf(buf, "|R|%d%02d%02d%02d%02d%02d|||||N||||||||||||||%c\n\0", timep->tm_year+1900, timep->tm_mon+1, timep->tm_mday, timep->tm_hour, timep->tm_min, timep->tm_sec, type);
	} else {
	    sprintf(buf, "|S|%d%02d%02d%02d%02d%02d|||||N||||||||||||||%c\n\0", timep->tm_year+1900, timep->tm_mon+1, timep->tm_mday, timep->tm_hour, timep->tm_min, timep->tm_sec, type);
	}

    strcat (str, buf);
	strcpy (order, str);

    return 1;
}

