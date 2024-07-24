#include <stdio.h>
#include <time.h>
#include "maldi.h"
/*
int CheckSum(char *buf)
{
    char crcsum[3], xsum[3];
    char *p;
    unsigned char chksum;
    //char str[1024];

    //WriteLog("檢核資料是否正確...");
    p = buf;
    while (*p != STX && *p != '\0') p++;
    if (*p == '\0') {
        WriteLog("Packet error");
        DumpErrorData(strlen(buf), buf);
        return 0;
    }

    if (buf[0] != STX) {
        WriteLog("Packet error");
        DumpErrorData(strlen(buf), buf);
        return 0;
    }

//skip STX
	p++;

	buf = p;

    p = strrchr(buf, ETX);

    if (p == NULL)
		p = strrchr(buf, ETB);

    if (p == NULL) {
		WriteLog("Packet error");
        DumpErrorData(strlen(buf), buf);
        return 0;
    }
    p++;
    
	memcpy(crcsum, p, 2);
    crcsum[2] = '\0';
    chksum = 0;

    while (1) {
        if (buf == p) break;
        chksum += *buf;
        buf++;
    }
    //chksum = 256-chksum;
    sprintf(xsum, "%02X", chksum);

	if (strcmp(crcsum, xsum) == 0) {
        //WriteLog("資料檢核碼正確!");
        return 1;
    }
    DumpErrorData(strlen(buf), buf);
    WriteLog("Checksum error! chksum:%s crcsum:%s", xsum, crcsum);
    return 0;
}
*/
int GetData(char fname[260])
{
	const char saperator[3] = ";\n\0";

	char LabNo[28];

    FILE *fp, *out;
	char tmpname[260];
    char tmpbuf[260];
	char *p;
	char buf[2048];
	char organism[80];
	char score[17];
	int i;

	fp = fopen(fname, "r");
	if (fp == NULL) {
		WriteLog("Cannot open file: %s", fname);
		return 0;
	}

	WriteLog("Process file: %s", fname);
	fseek(fp, 0, SEEK_SET);

	while (1) {
		if (fgets(buf, 2048, fp) == NULL) break;
		WriteLog("Content: %s", buf);

		i = g_nHeader;

		//ParseDelimiter(buf, 2, ';', LabNo);
		p = strtok(buf, saperator);
		strncpy(LabNo, p, 27);
		LabNo[27] = '\0';

		sprintf(tmpname, "%s%s", g_szOutBoxPath, LabNo);

		WriteLog("Save to %s", tmpname);
		out = fopen(tmpname, "w");
	
		while (p != NULL) {

			if (i % g_nFieldTotal == g_nOrganismIndex) {
				strcpy(organism, p);
			}

			if (i % g_nFieldTotal == g_nScoreIndex) {
				strcpy(score, p);

				if (out == NULL)
					WriteLog("Cannot open file: %s", tmpname);
				else {
					sprintf(tmpbuf, "%s|%s\n", organism, score);
					WriteLog("Result: %s", tmpbuf);
					fwrite(tmpbuf, strlen(tmpbuf), sizeof(char), out);
				}			
			}

			i ++;
			p = p + strlen(p) + 1;
			p = strtok(p, saperator);
		}
		fclose(out);		

	}

	fclose(fp);	
	
	return 1;
}

