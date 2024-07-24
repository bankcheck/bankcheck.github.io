#include <stdio.h>
#include <time.h>
#include "FilmArray.h"

void ProcessFile(char *xmlfname)
{
    char szData[1024];

	char sid[12];
	char DateTime[15];
	char test[40];
	char result[22];

	FILE *out;
	char fname[260];
	char buf[2048];

	time_t t;
    struct tm *tp;

    xmlDocPtr doc;
    xmlNodePtr curNode;  
//    xmlNodePtr dtNode;  
    xmlNodePtr sidNode;  
    xmlNodePtr resultNode;  
    xmlNodePtr testNode;
    xmlNodePtr valNode;
    xmlChar *szKey;

    szData[0] = '\0';

	doc = xmlReadFile(xmlfname,"UTF-8",XML_PARSE_RECOVER); 

	if (NULL == doc) 
    {  
       WriteLog("Document not parsed successfully.");     
       return; 
    } 

    curNode = xmlDocGetRootElement(doc); 
    if (NULL == curNode)
    { 
       WriteLog("empty document"); 
       xmlFreeDoc(doc); 
       return; 
    } 

//<aiMessage>
	if (!xmlStrcmp(curNode->name, BAD_CAST "aiMessage")) 
    {
/*
	//<header>
		dtNode = FindNode(curNode->xmlChildrenNode, "header");
		
		if (dtNode != NULL) {
		//<dateTime>
			dtNode = FindNode(dtNode->xmlChildrenNode, "dateTime");
			
			if (dtNode != NULL) {
				szKey = xmlNodeGetContent(dtNode);
				strcpy(DateTime, szKey);
				WriteLog("DateTime: %s", DateTime);
				xmlFree(szKey);
			} else {
				time(&t);
				tp = localtime(&t);
				if (tp != NULL) {
					sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
					tp->tm_hour, tp->tm_min, tp->tm_sec);
				}
			}
		}
*/
		time(&t);
		tp = localtime(&t);
		if (tp != NULL) {
			sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
			tp->tm_hour, tp->tm_min, tp->tm_sec);
		}

	//<requestResult>
		curNode = FindNode(curNode->xmlChildrenNode, "requestResult");
		
		if (curNode != NULL) {
		//<testOrder>
			curNode = FindNode(curNode->xmlChildrenNode, "testOrder");
		
			if (curNode != NULL) {
			//<specimen>
				sidNode = FindNode(curNode->xmlChildrenNode, "specimen");
			
				if (sidNode != NULL) {
				//<specimenIdentifier>
					sidNode = FindNode(sidNode->xmlChildrenNode, "specimenIdentifier");

					if (sidNode != NULL) {
						szKey = xmlNodeGetContent(sidNode);

						strcpy(sid, szKey);
						xmlFree(szKey);

						if ((g_bCheckDigit) && (strlen(sid) > 0))
							sid[strlen(sid) - 1] = '\0';

						WriteLog("sid: %s", sid);

						sprintf(fname, "%s%s_%s", g_szOutBoxPath, sid, DateTime);
						WriteLog("Save to %s", fname);
						out = fopen(fname, "wt");
					} else {
						return;
					}
				}

			//<test>
				curNode = FindNode(curNode->xmlChildrenNode, "test");

				if (curNode != NULL) {
				//<resultGroup>
					curNode = FindNode(curNode->xmlChildrenNode, "resultGroup");
					while (curNode != NULL) {
					//<result>
						resultNode = FindNode(curNode->xmlChildrenNode, "result");
						while (resultNode != NULL) {
						//<resultID>
							testNode = FindNode(resultNode->xmlChildrenNode, "resultID");
							if (testNode != NULL) {
							//<resultTestCode>
								testNode = FindNode(testNode->xmlChildrenNode, "resultTestCode");

								if (testNode != NULL) {
									szKey = xmlNodeGetContent(testNode);

									strcpy(test, szKey);
									ConvertRCode(test);

									WriteLog("test: %s", test);
									xmlFree(szKey);
						//<value>
									valNode = FindNode(resultNode->xmlChildrenNode, "value");
									if (valNode != NULL) {
							//<testResult>
										valNode = FindNode(valNode->xmlChildrenNode, "testResult");
										if (valNode != NULL) {
								//<observationValue>
											valNode = FindNode(valNode->xmlChildrenNode, "observationValue");
											if (valNode != NULL) {
												szKey = xmlNodeGetContent(valNode);
												strcpy(result, szKey);
												WriteLog("result: %s", result);
												xmlFree(szKey);
/*
												if (strncmp(result, "DETECT", 6) == 0)
													sprintf(buf, "%s|%s\n", test, g_Detect);
												else if (strcmp(result, "NOT_DETECT") == 0)
													sprintf(buf, "%s|%s\n", test, g_NotDetect);
												else
													sprintf(buf, "%s|%s\n", test, g_Equivoc);
*/
												if (strncmp(result, "DETECT", 6) == 0)
													sprintf(buf, "%s|%s\n", test, g_Detect);
												else
													sprintf(buf, "%s|%s\n", test, g_NotDetect);

												if (out == NULL)
													WriteLog("Cannot open file: %s", fname);
												else
													fwrite(buf, strlen(buf), sizeof(char), out);

											}//</observationValue>
										}//</testResult>
									}//</value>
								}//</resultTestCode>
							}//</resultID>

							resultNode = FindNode(resultNode->next, "result");
						}//</result>
						curNode = FindNode(curNode->next, "resultGroup");
					}//</resultGroup>

					if (out != NULL)
						fclose(out);

				}//</test>
			}//</testOrder>
		}//</requestResult>
	}//</aiMessage>

    xmlFreeDoc(doc);

	return;
}
