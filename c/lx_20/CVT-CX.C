#include <stdio.h>
#include <string.h>
#include <time.h>
#include "lx_20.h"

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
    WriteLog("Can't find setting for %s", code);
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

int ConvertLX_20Code(char *fname, char *databuf)
{
    FILE *fp;
    TESTLIST tests[MAX_TESTS];
    char buf[1024];
    char str[1024];
    int sector, cup, num, age;
    char *p;
    char sampleid[12], comment1[26], comment2[26], patientid[13];
    char sex[2];
    char comment[256];
    char code[20];
    int use_cmt, i;
    char token[20];
    char st[3];  // ST or RO
    char se[3];  // ST or RO

    WriteLog("轉換檢驗代碼...");
    fp = fopen(fname, "rt");
    if (fp == NULL) {
        WriteLog("Can't open file.");
        return 0;
    }

    fgets(buf, 1024, fp);
    WriteLog("DATA: %s", buf);
    sector = 0;
    cup = 0;
    age = 0;
    sampleid[0] = '\0';
    patientid[0] = '\0';
    sex[0] = '\0';
    GetToken(buf, sampleid, 1);
    GetToken(buf, patientid, 2);
    GetToken(buf, token, 3);
    sector = atoi(token);
    GetToken(buf, token, 4);
    cup = atoi(token);
    GetToken(buf, token, 5);
    age = atoi(token);
    GetToken(buf, sex, 6);
    GetToken(buf, st, 7);
    GetToken(buf, se, 8);

    if (age == 0)
        age = 20;

    num = 0;
    comment[0] = '\0';
    while (1) {
        if (fgets(buf, 1024, fp) == NULL) break;
        p = strtok(buf, " \t\r\n");
        if (p == NULL) continue;
        WriteLog("CODE: %s", p);
        if (ConvertCode(p, code, &use_cmt) == 0) {
            fclose(fp);
            WriteLog("Error for convert code");
            return 0;
        }
        strcpy(tests[num].code, code);
        tests[num].value = 0;
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

    memset(databuf, '\0', 282);
    strcpy(databuf, "[00,801,01,");     // device,stream,function
    sprintf(buf, "%04d,", sector);      //*sector
    strcat(databuf, buf);
    sprintf(buf, "%02d,", cup);         //*cup
    strcat(databuf, buf);
    sprintf(buf, "0,%2s,%2s,", st, se);         //updateflag,testtype,sampletype
    strcat(databuf, buf);
//    strcat(databuf, "0,RO,SE,");        // updateflag,testtype,sampletype
    sprintf(buf, "%-15s,", sampleid);   //*sample id
    strcat(databuf, buf);
    sprintf(buf, "%-20s,", "");         // control name
    strcat(databuf, buf);
    sprintf(buf, "%-12s,", "");         // QC Lot Number  新增
    strcat(databuf, buf);
    sprintf(buf, "%-25s,", comment1);   //*comment 1
    strcat(databuf, buf);
//    sprintf(buf, "%-25s,", comment2);   //*comment 2
//    strcat(databuf, buf);
    sprintf(buf, "%-18s,", "");         // last name
    strcat(databuf, buf);
    sprintf(buf, "%-15s,", "");         // first name
    strcat(databuf, buf);
    sprintf(buf, "%-1s,", "");          // middle init
    strcat(databuf, buf);
    sprintf(buf, "%-15s,", patientid);  //*patient id
    strcat(databuf, buf);
    sprintf(buf, "%-18s,", "");         // doctor
    strcat(databuf, buf);
    sprintf(buf, "%-8s,", "");          // draw date
    strcat(databuf, buf);
    sprintf(buf, "%-4s,", "");          // draw time
    strcat(databuf, buf);
    sprintf(buf, "%-20s,", "");         // location
    strcat(databuf, buf);
    sprintf(buf, "%03d,", age);         //*age
    strcat(databuf, buf);
    strcat(databuf, "5,");              // age unit
    sprintf(buf, "%-8s,", "");          // birthdate
    strcat(databuf, buf);
    sprintf(buf, "%-1s,", sex);         //*sex
    strcat(databuf, buf);
    sprintf(buf, "%-45s,", "");         // patient comment
    strcat(databuf, buf);
    sprintf(buf, "%-7s,", "");          // timedurvolume
    strcat(databuf, buf);
    sprintf(buf, "%-4s,", "");          // timedurperiod
    strcat(databuf, buf);
    sprintf(buf, "%-4s,", "");          // timedurcreatinine
    strcat(databuf, buf);
    sprintf(buf, "%-2s,", "");          // Timed Urine Creatinine Units
    strcat(databuf, buf);
    sprintf(buf, "%-6s,", "");          // timed urine area
    strcat(databuf, buf);
    sprintf(buf, "%03d", num);          //*number of test
    strcat(databuf, buf);

    for (i = 0; i < num; i++) {
        sprintf(buf, ",%-4s,%d", tests[i].code, tests[i].value);
        strcat(databuf, buf);
    }

    strcat(databuf, "]");

    sprintf(buf, "%02X\r\n", GetCheckSum(databuf));
    strcat(databuf, buf);

    return 1;
}

