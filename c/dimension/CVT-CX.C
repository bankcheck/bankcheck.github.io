#include <stdio.h>
#include <string.h>
#include <time.h>
#include "Dimension.h"

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

int ConvertDimensionCode(char *fname, char *databuf)
{
    FILE *fp;
    TESTLIST tests[MAX_TESTS];
    char buf[1024];
    char str[1024];
    char *p;
    char *tp;
    int use_cmt, i;
    char code[20];
    //char token[20];
    char comment[256];
    char comment1[26], comment2[26];
	char name[27];
	char *LabNo;
	char location[6];
	char priority;
	char sample_code;
	int num;

    //WriteLog("Âà´«ÀËÅç¥N½X...");
    fp = fopen(fname, "rt");
    if (fp == NULL) {
        WriteLog("Can't open file: %s", fname);
        return 0;
    }

    if (fgets(buf, 1024, fp) == NULL){
        WriteLog("Can't open file: %s", fname);
        return 0;
    }

    WriteLog("DATA: %s", buf);
//Header Info
    LabNo = strrchr(fname, '\\');
	LabNo++;

	if (*(strrchr(buf, '|')+1) == 'R')
		priority = '0';
	else
		priority = '1';

	tp = strtok(buf, "|");
	if (tp != NULL) {
		strcpy (name, tp);
		name[26] = '\0';
		tp = strtok (NULL, "|");
	}

	if (tp != NULL) {

		switch (*tp) {
			case 'S':
				sample_code = '1';
				break;
			case 'P':
				sample_code = '2';
				break;
			case 'U':
				sample_code = '3';
				break;
			case 'C':
				sample_code = '4';
				break;
			case 'B':
				sample_code = 'W';
				break;
			default: 
				sample_code = '1';
				break;
		}

		tp = strtok (NULL, "|");
	}

	location[0] = '\0';
    num = 0;
    comment[0] = '\0';

    while (1) {
        if (fgets(buf, 1024, fp) == NULL) break;
        p = strtok(buf, " \t\r\n");
        if (p == NULL) continue;
        WriteLog("TESTCODE: %s", p);

        if (!ConvertCode(p, code, &use_cmt))
			continue;

        strcpy(tests[num].code, code);
        //tests[num].value = 0;
        num++;

        if (use_cmt) {
            sprintf(str, "%-4s=%-7s", code, p);
            if (strlen(comment) < 40)
                strcat(comment, str);
        }
    }

    fclose(fp);

    i = strlen(comment);
    if (i > 25) {
        memcpy(comment1, comment, 25);
        comment1[25] = '\0';
        strcpy(comment2, &comment[25]);
        comment2[25] = '\0';
    }
    else {
        strcpy(comment1, comment);
        comment1[25] = '\0';
        comment2[0] = '\0';
    }
    memset(databuf, '\0', 1024);
    sprintf(buf, "D%c", FS);
    strcpy(databuf, buf);
    sprintf(buf, "0%c", FS);
    strcat(databuf, buf);
    sprintf(buf, "0%c", FS);
    strcat(databuf, buf);
    sprintf(buf, "A%c", FS);
    strcat(databuf, buf);
    sprintf(buf, "%s%c", name, FS);
    strcat(databuf, buf);
    sprintf(buf, "%s%c", LabNo, FS);
    strcat(databuf, buf);
    sprintf(buf, "%c%c", sample_code, FS);
    strcat(databuf, buf);
    sprintf(buf, "%s%c", location, FS);
    strcat(databuf, buf);
    sprintf(buf, "%c%c", priority, FS);
    strcat(databuf, buf);
    sprintf(buf, "1%c", FS);
    strcat(databuf, buf);
    sprintf(buf, "0%c", FS);
    strcat(databuf, buf);
    sprintf(buf, "1%c", FS);
    strcat(databuf, buf);
    sprintf(buf, "%d%c", num, FS);
    strcat(databuf, buf);
    for (i = 0; i < num; i++) {
        sprintf(buf, "%s%c", tests[i].code, FS);
        strcat(databuf, buf);
    }
    sprintf(buf, "%02X%c\0", GetCheckSum(databuf), ETX);
    strcat(databuf, buf);
	strcpy(buf, databuf);
    sprintf(databuf, "%c%s", STX, buf);

    return 1;
}

