#include <stdio.h>
#include <string.h>
#include <time.h>
#include "ortho.h"

unsigned char GetCheckSum(char *buf)
{
    unsigned char chksum;

    chksum = 0;
    while (1) {
        if (*buf == '\0') break;
        chksum += *buf;
        buf++;
    }
    return chksum;
}

int SendFile(char LabNo[12]) {
    char OutFile[260];
	char bakname[260];
	char InFile[260];
    char str[1024];
	char DateTime[15];

	char lastname[260];
	char firstname[260];
	char hospnum[12];
	char priority;
    char buf[1024];
    char *p;
    char code[200];

	FILE *ifp, *ofp;
	
    time_t t;
    struct tm *tp;

    time(&t);
    tp = localtime(&t);

	sprintf(DateTime, "%4d%02d%02d%02d%02d%02d\0", tp->tm_year+1900,
		tp->tm_mon+1, tp->tm_mday, tp->tm_hour, tp->tm_min, tp->tm_sec);

	sprintf(OutFile, "%s%s.dnl", g_szTempPath, DateTime);

    sprintf(InFile, "%s%s", g_szInBoxPath, LabNo);
	if (g_bCheckDigit) {
		RemoveEndChar(InFile);
	}

    ifp = fopen(InFile, "rt");
    if (ifp == NULL) {
        WriteLog("Can't open file: %s", InFile);
        return 0;
    }

    if (fgets(buf, 1024, ifp) == NULL){
        WriteLog("Empty file: %s", InFile);
        return 0;
    }

	p = strtok(buf, ",|");

    if (p == NULL) {
		WriteLog("Error data format: %s", buf);
        return 0;
    }
	strcpy(lastname, p);

    p = strtok(NULL, "|");        
	if (p == NULL) {
		WriteLog("Error data format: %s", buf);
        return 0;
	}
	strcpy(firstname, p);

    p = strtok(NULL, "|");        
	if (p == NULL) {
		WriteLog("Error data format: %s", buf);
        return 0;
	}
    p = strtok(NULL, "|");        
	if (p == NULL) {
		WriteLog("Error data format: %s", buf);
        return 0;
	}
	strcpy(hospnum, p);

    p = strtok(NULL, "|");        
	if (p == NULL) {
		WriteLog("Error data format: %s", buf);
        return 0;
	}

	if (*p = 'R')
		priority = 'N';
	else
		priority = 'S';


	ofp = fopen(OutFile, "wt");
	if (ofp == NULL) {
		WriteLog("Cannot open file: %s", OutFile);
		Sleep(g_sleep);
        return 0;
    }
	WriteLog("Open file: %s", OutFile);

    sprintf(str, "H|\\^&|||LIS||||||||1|%s\n\0", DateTime);
	fwrite(str, strlen(str), sizeof(char), ofp);
	WriteLog("Write: %s", str);

	sprintf(str, "P|1|%s|||%s^%s|||||||||||||||||||||||||||||\n\0", hospnum, lastname, firstname);
	fwrite(str, strlen(str), sizeof(char), ofp);
	WriteLog("Write: %s", str);

	while (1) {
        if (fgets(buf, 1024, ifp) == NULL) break;
        p = strtok(buf, " \t\r\n");

		if (p == NULL)
			continue;

		if (!ConvertCode(p, code))
			continue;

		if (g_bDebug)
			WriteLog("TESTCODE: %s", code);
		
		sprintf(str, "O|1|%s||%s|%c|%s|||||||||CENTBLOOD|||||||||||||||\n\0", LabNo, code, priority, DateTime);
		fwrite(str, strlen(str), sizeof(char), ofp);
		WriteLog("Write: %s", str);
    }
	
    sprintf(str, "L|1|N\n\0");
	fwrite(str, strlen(str), sizeof(char), ofp);
	WriteLog("Write: %s", str);

    fclose(ofp);
	fclose(ifp);

	if (g_bBackupInbox) {
		sprintf(bakname, "%s%s\0", g_szBackupInBoxPath, LabNo);
	
		if (g_bCheckDigit) {
			RemoveEndChar(bakname);
		}

		WriteLog("Move file from %s to %s", InFile, bakname);
		CopyFile(InFile, bakname, FALSE);
		DeleteFile(InFile);
	}

	Sleep(1000);
	return 1;
}
