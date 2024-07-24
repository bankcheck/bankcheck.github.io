#include <stdio.h>
#include <string.h>
#include <time.h>
#include "c6000.h"

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

int Convertc6000Code(char *fname, int seq, char *order, char *pos)
{
    FILE *fp;
	FILE *fp_out;
    TESTLIST tests[MAX_TESTS];
    char buf[1024];
	char buf_out[1024];
    char test[1024];
	char OutFile[260];
    char *p;
    //char *tp;
    int use_cmt, i;
    char code[20];
	//char name[41];
	char fullname[260];

	char *LabNo;
	char priority;
	char sample;
	char sex[2];
	char year[3];
	char month[2];
	char age[5];
	char patno[12];
	int num;

	time_t t;
    struct tm *timep;

    time(&t);
    timep = localtime(&t);

	LabNo = strrchr(fname, '\\');
	if (strlen(LabNo) > 1) {
		LabNo++;
	} else {
		return 0;
	}

    //WriteLog("Âà´«ÀËÅç¥N½X...");
    fp = fopen(fname, "rt");
    if (fp == NULL) {
        WriteLog("Can't open file: %s", fname);
        return 0;
    }

    if (fgets(buf, 1024, fp) == NULL){
        WriteLog("Empty file: %s", fname);
        return 0;
    }

    if (g_bDebug)
	    WriteLog("DATA: %s", buf);

//Header Info
	priority=*(strrchr(buf, '|')+1);

	ParseDelimiter(buf, 1, '|', fullname);
	
	ParseDelimiter(buf, 2, '|', &sample);
	if ((sample == 'S') || (sample == 'P') || (sample == 'B'))
		sample = '1';
	else if (sample == 'U')
		sample = '2';
	else if (sample == 'C')
		sample = '3';
	else if (sample == 'X')
		sample = '4';
	else
		sample = '5';

	ParseDelimiter(buf, 3, '|', patno);

	ParseDelimiter(buf, 4, '|', sex);

	ParseDelimiter(buf, 5, '|', year);
	ParseDelimiter(buf, 6, '|', month);

	if (year[0] == '0')
		sprintf(age, "%s^M", month);
	else
		sprintf(age, "%s^Y", year);

	sprintf(OutFile, "%s%s.dat", g_szTempPath, "outbuffer");

	fp_out = fopen(OutFile, "at");
	if (fp_out == NULL) {
		WriteLog("Cannot open file: %s", OutFile);
	} 

	sprintf(buf_out, "H|\\^&|||ASTM-Host^||||||TSDWN^REPLY\n\0");
	fwrite(buf_out, strlen(buf_out), sizeof(char), fp_out);

	sprintf(buf_out, "P|1||%s|||||%s||||||%s\n\0", patno, sex, age);
	fwrite(buf_out, strlen(buf_out), sizeof(char), fp_out);

	num = 0;
	while (1) {
        if (fgets(buf, 1024, fp) == NULL) break;
        p = strtok(buf, " \t\r\n");

        if (p == NULL)
			continue;

		WriteLog("TESTCODE: %s", p);

        if (ConvertCode(p, code, &use_cmt) == 0)
			continue;

        strcpy(tests[num].code, code);

        num++;
    }
    fclose(fp);

	test[0] = '\0';

    for (i = 0; i < num; i++) {
		if (i > 0) {
			sprintf(buf, "\\^^^%s^1\0", tests[i].code);
			strcat(test, buf);
		} else {
			sprintf(buf, "^^^%s^1\0", tests[i].code);
			strcpy(test, buf);
		}
    }

	sprintf(buf_out, "O|1|%s|%s|%s|%c||%d%02d%02d%02d%02d%02d||||A||||%c||||||||||O\n\0", LabNo, pos, test, priority, 
		timep->tm_year+1900, timep->tm_mon+1, timep->tm_mday, timep->tm_hour, timep->tm_min, timep->tm_sec, sample);
	fwrite(buf_out, strlen(buf_out), sizeof(char), fp_out);
	
	sprintf(buf_out, "C|1|L|%s^^^^|G\n\0", fullname);
	fwrite(buf_out, strlen(buf_out), sizeof(char), fp_out);

	sprintf(buf_out, "L|1|N\n\0");
	fwrite(buf_out, strlen(buf_out), sizeof(char), fp_out);

	fclose(fp);
	fclose(fp_out);

    return 1;
}

