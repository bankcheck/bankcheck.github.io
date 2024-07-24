#include <stdio.h>
#include <time.h>
#include "ortho.h"

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

    //strcpy(str, p);
    //strcpy(buf, str);

	//checksum pointer
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

char *getline(char *buf, int len, FILE *fp)
{
    int i;
    char ch;

    i = 0;
    while (1) {
        if (feof(fp)) {
            if (i == 0) return NULL;
            buf[i] = '\0';
            return buf;
        }
        ch = fgetc(fp);
        buf[i++] = ch;
        if (ch == '\r' || ch == '\n') {
            buf[i] = '\0';
            return buf;
        }
        if (i == len) {
            buf[i] = '\0';
            return buf;
        }
    }
}
	
int GetData(char fname[260])
{
    char function;
    char szData[1024];

	char LabNo[12];
	char DateTime[15];
	char test[30];
	char result[22];

    FILE *fp, *out;
	char tmpname[260];
    char tmpbuf[260];
//	char *p;
	char *q;
	char *packet;
	char buf[2048];
    char code[200];
	BOOLEAN bSave;

    szData[0] = '\0';

	fp = fopen(fname, "r");
	if (fp == NULL) {
		WriteLog("Cannot open file: %s", fname);
		Sleep(g_sleep);
		return 1;
	}

	WriteLog("Process file: %s", fname);
	packet = malloc(2048);
	packet[0] = '\0';
	fseek(fp, 0, SEEK_SET);

	while (1) {
		if (fgets(buf, 2048, fp) == NULL) break;
		WriteLog("Content: %s", buf);

		strcpy(packet, buf);
		function = *buf;

//Header information
		if (function == 'H') {
			q = strrchr(packet, '|');
			q++;
			strcpy(DateTime, q);
			DateTime[14] = '\0';
		}
		
//patient information
		if (function == 'O') {

			ParseDelimiter(packet, 3, '|', LabNo);

			if (g_bCheckDigit) {
				RemoveEndChar(LabNo);
			}

		    strtok(LabNo, "\"*/:<>?\\|");

			ParseDelimiter(packet, 5, '|', code);

			bSave = ConvertRCode(code);
		}

//Query
		if ((function == 'Q') && (g_mode == 2)){
			ParseDelimiter(packet, 3, '|', LabNo);
		    strtok(LabNo, "\"*/:<>?\\|");
			
			//cut the '^' char
			q = LabNo;
			q++;
			sprintf (LabNo, "%s\0", q);
			SendFile(LabNo);
		}

//Result
		if (function == 'R') {
			if (LabNo[0] != '\0') {
				ParseDelimiter(packet, 4, '|', result);

				ParseDelimiter(packet, 3, '|', test);

/*Remove checkdigit for code39
				if (g_bCheckDigit) {
					strcpy(token, test);
					token[2] = '\0';
					if (!strcmp(token, "XM")) {
						RemoveEndChar(test);
					}
				}
*/
				TrimSpace(test);
				TrimSpace(result);

				if ( bSave ) {

					sprintf(tmpname, "%s%s_%s", g_szOutBoxPath, LabNo, DateTime);

					WriteLog("Save to %s", tmpname);
					out = fopen(tmpname, "a+");

					if (out == NULL) {
						WriteLog("Cannot open file: %s", tmpname);
						Sleep(g_sleep);
					} else {
						sprintf(tmpbuf, "%s|%s\n", test, result);
						fwrite(tmpbuf, strlen(tmpbuf), sizeof(char), out);
						fclose(out);
					}
				}

			}
		}
	}
	fclose(fp);

	if (g_bDebug == FALSE)
		unlink(fname);
	
	return 0;
}

