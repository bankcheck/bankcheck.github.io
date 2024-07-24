#include <stdio.h>
#include <time.h>
#include "IRIS.h"

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

int ReceivePacket(char *szData)
{
	int	found;
    char buf[2048];
	int	nCount;
    DWORD dwLen;
    DWORD i;
	
	szData[0] = '\0';
	nCount = 0;
	dwLen = 0;

    while (1) {
        while (1) {
	        if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, 0) == WAIT_OBJECT_0) {
				g_bQuit = TRUE;
			    break;
			}
            if (ReadDataFromComm(&dwLen, buf) > 0)
                break;
        }

        if (g_bDebug) {
            WriteLog("length: %d", dwLen);
            DumpErrorData(dwLen, buf);
        }

        if (g_bQuit) break;

		if (buf[0] == ENQ) {
			WriteLog("Receive ENQ");
			szData[0] = buf[0];
			szData[1] = '\0';			
			return 1;
		}
		else if (buf[0] == NAK) {
			WriteLog("Receive NAK");
			szData[0] = buf[0];
			szData[1] = '\0';
			return 1;
		}
		else if (buf[0] == ACK) {
			WriteLog("Receive ACK");
			szData[0] = buf[0];
			szData[1] = '\0';
			return 1;
		}
		else if (buf[0] == EOT) {
			WriteLog("Receive EOT");
			szData[0] = buf[0];
			szData[1] = '\0';
			return 1;
		}
        else {
            memcpy(&szData[nCount], buf, dwLen);
            nCount += dwLen;
            for (i = 0; i < dwLen; i++) {
                if (buf[i] == STX) {
					found = 0;
				}
                if (buf[i] == ETX) {
					found = 1;
				}
                if (buf[i] == ETB) {
					found = 1;
				}
                if ((buf[i] == LF) && (found == 1)) {
					found = 2;
				}
			}

            if (found < 2) continue;

            szData[nCount] = '\0';
            
			if (g_bDebug) {
                WriteLog("length: %d", nCount);
                DumpErrorData(nCount, szData);
            }
		    WriteLog("Receive: %s", szData);
			break;
		}
	}

	return nCount;
}
	
int GetData(void)
{
    char cmd[260];
    char szData[1024];

	char LabNo[12];
	char DateTime[15];
	char test[30];
	char result[22];

    FILE *fp, *xmlfp;
	FILE *out;
	char fname[260], xmlfname[260];
	char tmpname[260];
    char tmpbuf[260];
	char *p;
	char *message;
	char buf[2048];

	char xml;

	int x;
	//char specimen;

    xmlDocPtr doc;
    xmlNodePtr curNode;  
    xmlChar *szKey;
	xmlNodePtr ResultNode;

    szData[0] = '\0';

	sprintf(tmpname, "%s%lx", g_szTempPath, GetTickCount());
	sprintf(fname, "%s.dat", tmpname);
	sprintf(xmlfname, "%s.xml", tmpname);

	WriteLog("Write to temp file: %s", fname);
	fp = fopen(fname, "w+b");
	if (fp == NULL) {
		WriteLog("Cannot open file: %s", fname);
		return 1;
	}

	while (ReceivePacket(szData) > 0) {
		if (szData[0] == ENQ){
			WriteLog("Send ACK");
			cmd[0] = ACK;
			cmd[1] = '\0';
			SendChar(g_hCom, cmd, 1);
			FlushFileBuffers(g_hCom);
			continue;
		}

		if (szData[0] == EOT){
			break;
		}
		
		if (CheckSum(szData)) {
			WriteLog("Send ACK");
			cmd[0] = ACK;
			cmd[1] = '\0';
			SendChar(g_hCom, cmd, 1);
			FlushFileBuffers(g_hCom);
            WriteLog("Packet accepted: %s", szData);
			fwrite(szData, strlen(szData), sizeof(char), fp);
			fflush(fp);
		} else {
			WriteLog("Send NAK");
			cmd[0] = NAK;
			cmd[1] = '\0';
			SendChar(g_hCom, cmd, 1);
			FlushFileBuffers(g_hCom);
            WriteLog("Packet rejected: %s", szData);
		}
	}

	xmlfp = fopen(xmlfname, "wt");

	WriteLog("Process temp file");
	fseek(fp, 0, SEEK_SET);

	while (1) {
		if (fgets(buf, 2048, fp) == NULL) break;
		if (buf[0] == EOT) break;
		WriteLog("Content: %s", buf);

		message = buf;
		while ((*message != STX) && (*message != '\0'))
			message++;
		
		message+=2;
		
		while ((*message != ETB) &&  (*message != ETX)) {
			sscanf(message, "%2X", &x);
			message += 4;
			
			xml = x;

			fwrite(&xml, 1, sizeof(char), xmlfp);
		}
	}

	fclose(fp);
	fclose(xmlfp);

	WriteLog("Process XML file");
	doc = xmlReadFile(xmlfname,"UTF-8",XML_PARSE_RECOVER); 

	if (NULL == doc) 
    {  
       WriteLog("Document not parsed successfully.");     
       return  1; 
    } 

    curNode = xmlDocGetRootElement(doc); 
    if (NULL == curNode)
    { 
       WriteLog("empty document"); 
       xmlFreeDoc(doc); 
       return 1; 
    } 
//<IRISPing> - Ping
    if (!xmlStrcmp(curNode->name, BAD_CAST "IRISPing")) {
		WriteLog("Received IRISPing");
		SendPing();
	}

//<SA> - result
    else if (!xmlStrcmp(curNode->name, BAD_CAST "SA")) 
    {
		if (bFindProp(curNode, "ID", LabNo)) {
			strtok(LabNo, "\"* /:<>?\\|");
			WriteLog("LabNo: %s", LabNo);
		}
/*		
		if (bFindProp(curNode, "BF", buf)) {
			specimen = *buf;
			WriteLog("Specimen: %s-%c", buf, specimen);
		}
*/
		if (bFindProp(curNode, "ADTS", buf)) {
			p = strtok(buf, "-: ");
		    if (p != NULL) {
				strcpy(DateTime, p); //year
				p = strtok(NULL, "-: "); 
			}
		    if (p != NULL) {
				strcat(DateTime, p); //month
				p = strtok(NULL, "-: "); 
			}
		    if (p != NULL) {
				strcat(DateTime, p); //day
				p = strtok(NULL, "-: ");
			}
		    if (p != NULL) {
				strcat(DateTime, p); //hour
				p = strtok(NULL, "-: "); 
			}
		    if (p != NULL) {
				strcat(DateTime, p); //minute
				p = strtok(NULL, "-: "); 
			}
		    if (p != NULL) {
				strcat(DateTime, p); //second
			}

			WriteLog("TestDate: %s", DateTime);
		}
		
		sprintf(tmpname, "%s%s_%s", g_szOutBoxPath, LabNo, DateTime);

		WriteLog("Save to %s", tmpname);
		out = fopen(tmpname, "wt");

		curNode = FindNode(curNode->xmlChildrenNode, "AC");
		while (curNode != NULL) {
			ResultNode = FindNode(curNode->xmlChildrenNode, "AR");
			while (ResultNode != NULL) {
				if (bFindProp(ResultNode, "Key", test)) {
					szKey = xmlNodeGetContent(ResultNode);
					strcpy(result, szKey);
					xmlFree(szKey);
				
					sprintf(tmpbuf, "%s|%s\n", test, result);
					WriteLog("Result: %s", tmpbuf);
	
					if (out == NULL)
						WriteLog("Cannot open file: %s", tmpname);
					else {
						fwrite(tmpbuf, strlen(tmpbuf), sizeof(char), out);
					}
				}
				ResultNode = FindNode(ResultNode->next, "AR");
			}
			curNode = FindNode(curNode->next, "AC");
		}

		if (out != NULL)
			fclose(out);
	}

//<ChemQC>
    else if (!xmlStrcmp(curNode->name, BAD_CAST "ChemQC")) 
    {
		if (bFindProp(curNode, "NAME", LabNo)) {
			strtok(LabNo, "\"* /:<>?\\|");
			WriteLog("LabNo: %s", LabNo);
		}
		
		if (bFindProp(curNode, "ADTS", buf)) {
			p = strtok(buf, "-: ");
		    if (p != NULL) {
				strcpy(DateTime, p); //year
				p = strtok(NULL, "-: "); 
			}
		    if (p != NULL) {
				strcat(DateTime, p); //month
				p = strtok(NULL, "-: "); 
			}
		    if (p != NULL) {
				strcat(DateTime, p); //day
				p = strtok(NULL, "-: ");
			}
		    if (p != NULL) {
				strcat(DateTime, p); //hour
				p = strtok(NULL, "-: "); 
			}
		    if (p != NULL) {
				strcat(DateTime, p); //minute
				p = strtok(NULL, "-: "); 
			}
		    if (p != NULL) {
				strcat(DateTime, p); //second
			}

			WriteLog("TestDate: %s", DateTime);
		}
		
		sprintf(tmpname, "%s%s_U%s", g_szOutBoxPath, LabNo, DateTime);

		WriteLog("Save to %s", tmpname);
		out = fopen(tmpname, "wt");

		curNode = FindNode(curNode->xmlChildrenNode, "QCR");
		while (curNode != NULL) {
			if (bFindProp(curNode, "Key", test)) {
				szKey = xmlNodeGetContent(curNode);
				strcpy(result, szKey);
				xmlFree(szKey);
				
				sprintf(tmpbuf, "%s|%s\n", test, result);
				WriteLog("Result: %s", tmpbuf);
	
				if (out == NULL)
					WriteLog("Cannot open file: %s", tmpname);
				else {
					fwrite(tmpbuf, strlen(tmpbuf), sizeof(char), out);
				}
			}
			curNode = FindNode(curNode->next, "QCR");
		}

		if (out != NULL)
			fclose(out);
	}


//<CQC> - Microscopic QC
    else if (!xmlStrcmp(curNode->name, BAD_CAST "CQC")) 
    {
		if (bFindProp(curNode, "ID", LabNo)) {
			strtok(LabNo, "\"* /:<>?\\|");
			WriteLog("LabNo: %s", LabNo);
		}
		
		if (bFindProp(curNode, "ADTS", buf)) {
			p = strtok(buf, "-: ");
		    if (p != NULL) {
				strcpy(DateTime, p); //year
				p = strtok(NULL, "-: "); 
			}
		    if (p != NULL) {
				strcat(DateTime, p); //month
				p = strtok(NULL, "-: "); 
			}
		    if (p != NULL) {
				strcat(DateTime, p); //day
				p = strtok(NULL, "-: ");
			}
		    if (p != NULL) {
				strcat(DateTime, p); //hour
				p = strtok(NULL, "-: "); 
			}
		    if (p != NULL) {
				strcat(DateTime, p); //minute
				p = strtok(NULL, "-: "); 
			}
		    if (p != NULL) {
				strcat(DateTime, p); //second
			}

			WriteLog("TestDate: %s", DateTime);
		}
		sprintf(tmpname, "%s%s_U%s", g_szOutBoxPath, LabNo, DateTime);

		WriteLog("Save to %s", tmpname);
		out = fopen(tmpname, "wt");

		curNode = FindNode(curNode->xmlChildrenNode, "COUNT");
		szKey = xmlNodeGetContent(curNode);
		strcpy(result, szKey);
		xmlFree(szKey);
		
		sprintf(tmpbuf, "COUNT|%s\n", result);
		WriteLog("Result: %s", tmpbuf);

		if (out == NULL)
			WriteLog("Cannot open file: %s", tmpname);
		else {
			fwrite(tmpbuf, strlen(tmpbuf), sizeof(char), out);
		}

		if (out != NULL)
			fclose(out);
	}

    xmlFreeDoc(doc);

	if (g_bDebug == FALSE) {
		unlink(fname);
		unlink(xmlfname);
	}
	
	return 0;
}


//bool bFindContent 