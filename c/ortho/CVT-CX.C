#include <stdio.h>
#include <string.h>
#include <time.h>
#include "ortho.h"

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

	if ( strncmp(code, g_szXMcode, strlen(g_szXMcode)) == 0) {
		//WriteLog("DEBUG: CROSSMATCHING");
		return 1;
	}
    
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
			//WriteLog("DEBUG: Found");
            strcpy(code, val);
            fclose(fp);
            return 1;
        }
    }
    fclose (fp);

	//WriteLog("DEBUG: Not found");
    return 0;
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

int Dilution(char *code)
{
    char buf[1024];
    char val[256];
    FILE *fp;
    char *p;
	int dil;

    fp = fopen(g_szDiluteFile, "rb");
    if (fp == NULL) {
        WriteLog("Can't open file %s", g_szDiluteFile);
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
            dil = atoi(val);
            fclose(fp);
            return dil;
        }
    }
    fclose (fp);
    //WriteLog("Can't find setting for %s", code);
    return 0;
}

int ConvertCode(char *item, char *code)
{
    char buf[1024];
    FILE *fp;
    char *p, *q;
	BOOL XM = FALSE;

    strcpy(code, item);

	if (strncmp(item, g_szXMcode, strlen(g_szXMcode)) == 0) {
		XM = TRUE;
		strcpy(item, g_szXMcode);
	}

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
        
		if (strcmp(item, p) == 0) {
			
			p = strtok(NULL, "\t=,\r\n");
			TrimSpace(p);

			if (XM) {
				fclose(fp);
				q = code + strlen(g_szXMcode);
				sprintf(code, "%s%s", p, q);
				return 1;
			} else {
				fclose(fp);
				strcpy(code, p);
				return 1;
			}
        }
    }

    fclose (fp);
	if (XM)
		return 1;

    WriteLog("Can't find setting for %s", item);
    return 0;
}

