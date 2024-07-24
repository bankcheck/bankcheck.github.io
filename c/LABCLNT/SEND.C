#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "labclnt.h"
//#include <sqlext.h>

DWORD SendThreadProc(LPVOID pParm)
{
    int no;
    FILE *fp;
    //LPHOSTENT hp;
    //struct in_addr ip;
    //struct sockaddr_in addr;
    //DWORD *pa;
    char buf[2048], str[2048];
    char *p;
    char *q;
    //short port;
    //char server[260];
    char test[500];
    char seq[14];
    char tmpseq[14];
	char result[22];
	char sid[21];
	//char labno[9];
	char machine[12];
	int intseq;
	int tmplen;
	int dup;
	char fluid_type[2];
	char tmpfile[260];

	SQLINTEGER Length = SQL_NTS;
	SQLHSTMT stmt;
	SQLCHAR SQL[200] = 
//		"insert into LABO_INTERFACE (LAB_NUM, SEQ_NUM, CODE_K700, RESULT, MACH_CODE, FLUID_TYPE)values (?,?,?,?,?,?)";
		"insert into LABO_INTERFACE (LAB_NUM, SEQ_NUM, CODE_K700, RESULT, MACH_CODE)values (?,?,?,?,?)";
	SQLCHAR SQL2[200];
		
//	SQLINTEGER SQLerr;
//	SQLSMALLINT SQLmsglen;
//	char pStatus[10], pMsg[101];

//	SQLCHAR OutConnStr[255];
//    SQLSMALLINT OutConnStrLen;

	SDWORD ldup;
	ldup = SQL_NTS;

_TRY_EXCEPTION_BLOCK_BEGIN()

    no = (int)pParm;
	strcpy(machine, g_Client[no].szProg);

	p = strrchr(g_Client[no].szFileName, '\\');

	p++;
	strcpy(sid, p);

	//q = strtok(sid, "_.\0");
	q = strtok(sid, "_\0");
	strcpy(sid, q);
	sid[20] = '\0';

	//strncpy(labno, sid, 8);

	fluid_type[0] = '\0';

	q = strrchr(p, '_');
	
	memset(seq, '\0', 14);

	if (q != NULL) {
		//fluid_type[0] = *++q;
		//fluid_type[1] = '\0';
		
		tmplen = strlen(++q);

		strcpy(seq, q);

		if (tmplen > g_nSeqDigit)
			q = q + tmplen - g_nSeqDigit;

		strcpy(tmpseq, q);
	}

	intseq = atoi(tmpseq);

	if (intseq > 0) {

		while (1) {
			sprintf(SQL2, "select count(*) from LABO_DOWNHEAD m inner join LABO_SAMPLE s on m.lab_num=s.lab_num where s.sample_id='%s' and seq_num ='%d'", sid, intseq);
			
			ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt); 
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("%s:%s", pStatus, pMsg);
				dbdisconnect();
				dbconnect();
				continue;
			}

			ret = SQLPrepare(stmt, SQL2, SQL_NTS);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("%s:%s", pStatus, pMsg);
				dbdisconnect();
				dbconnect();
				continue;
			}
		
			ret = SQLExecute(stmt);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("%s:%s", pStatus, pMsg);
				dbdisconnect();
				dbconnect();
				continue;
			}

			ret=SQLBindCol(stmt,1,SQL_C_ULONG, &dup, sizeof(int), &ldup);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("%s:%s", pStatus, pMsg);
				dbdisconnect();
				dbconnect();
				continue;
			}

			ret = SQLFetch(stmt); 
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("%s:%s", pStatus, pMsg);
				dbdisconnect();
				dbconnect();
				continue;
			}

			ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("%s:%s", pStatus, pMsg);
				dbdisconnect();
				dbconnect();
				continue;
			}

			if (dup == 0)
				break;
			else
				intseq++;
		}
		sprintf(seq, "%d\0", intseq);
	} 
	else {
		//fluid_type[0] = 'M';
	}

	if (strlen(seq) > 0) {
	//copy to tmp path;
		sprintf(tmpfile, "%sTEMP\\%s_%s", g_szRootPath, sid, seq);
		MoveFile(g_Client[no].szFileName, tmpfile);
		WriteLog("MoveFile %s to %s", g_Client[no].szFileName, tmpfile);

		fp = fopen(tmpfile, "rb");
		if (fp == NULL) {
			WriteLog("Can't open %s", tmpfile);
			if (g_dwErrorSleepTime != 0)
				Sleep(g_dwErrorSleepTime);
			tmpfile[0] = '\0';
			g_Client[no].szFileName[0] = '\0';
			return 0;
		}

		while (1) {
			if (fgets(str, 256, fp) == NULL) break;
			
			p = strtok(str, "|\n\r\0");

			if (p != NULL) {
				strcpy(test, p);
				p = strtok(NULL, "|\n\r\0");
			} else {
				continue;
			}

			if (p != NULL) {
				strcpy(result, p);
			} else {
				continue;
			}

			ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt); 
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("%s:%s", pStatus, pMsg);
				dbdisconnect();
				dbconnect();
				continue;
			}

	// Bind Parameters
			ret = SQLBindParameter(stmt, 1, SQL_PARAM_INPUT,
				SQL_C_CHAR, SQL_CHAR, 0, 0,
				sid, sizeof(sid), &Length);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("%s:%s", pStatus, pMsg);
				dbdisconnect();
				dbconnect();
				continue;
			}

			ret = SQLBindParameter(stmt, 2, SQL_PARAM_INPUT,
				SQL_C_CHAR, SQL_CHAR, 0, 0,
				seq, sizeof(seq), &Length);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("%s:%s", pStatus, pMsg);
				dbdisconnect();
				dbconnect();
				continue;
			}

			ret = SQLBindParameter(stmt, 3, SQL_PARAM_INPUT,
				SQL_C_CHAR, SQL_CHAR, 0, 0,
				test, sizeof(test), &Length);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("%s:%s", pStatus, pMsg);
				dbdisconnect();
				dbconnect();
				continue;
			}

			ret = SQLBindParameter(stmt, 4, SQL_PARAM_INPUT,
				SQL_C_CHAR, SQL_CHAR, 0, 0,
				result, sizeof(result), &Length);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("%s:%s", pStatus, pMsg);
				dbdisconnect();
				dbconnect();
				continue;
			}

			ret = SQLBindParameter(stmt, 5, SQL_PARAM_INPUT,
				SQL_C_CHAR, SQL_CHAR, 0, 0,
				machine, sizeof(machine), &Length);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("%s:%s", pStatus, pMsg);
				dbdisconnect();
				dbconnect();
				continue;
			}
	/*
			ret = SQLBindParameter(stmt, 6, SQL_PARAM_INPUT,
				SQL_C_CHAR, SQL_CHAR, 0, 0,
				fluid_type, sizeof(fluid_type), &Length);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("%s:%s", pStatus, pMsg);
				dbconnect();
				continue;
			}
	*/
	//		WriteLog("sid=%s seq=%s test=%s result=%s machine=%s fluid_type=%s", sid, seq, test, result, machine, fluid_type);
			WriteLog("sid=%s seq=%s test=%s result=%s machine=%s", sid, seq, test, result, machine);

	//Prepare SQL
			ret = SQLPrepare(stmt, SQL, SQL_NTS);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("%s:%s", pStatus, pMsg);
				dbdisconnect();
				dbconnect();
				continue;
			}
	// Execute statement with parameters
			ret = SQLExecute(stmt);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("%s:%s", pStatus, pMsg);
				dbdisconnect();
				dbconnect();
				continue;
			}
			ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("%s:%s", pStatus, pMsg);
				dbdisconnect();
				dbconnect();
				continue;
			}
		}

		fclose(fp);

	} else {
		WriteLog("Invalid file format");
		strcpy(tmpfile, g_Client[no].szFileName);
	}

	if (g_Client[no].bCopyTest != 0 && g_Client[no].szTestDir[0] != '\0') {
		char drive[_MAX_DRIVE];
		char dir[_MAX_DIR];
		char fname[_MAX_FNAME];
		char ext[_MAX_EXT];

		_splitpath(g_Client[no].szFileName, drive, dir, fname, ext);
		_makepath(buf, "", g_Client[no].szTestDir, fname, ext);
		CopyFile(tmpfile, buf, FALSE);
		WriteLog("CopyFile %s to %s", tmpfile, buf);
	}

	if (g_bBackup) {
		time_t t;
		struct tm *tp;
		char szToday[200];

		time(&t);
		tp = localtime(&t);
		strftime(szToday, 200, "%y%m%d", tp);
		sprintf(buf, "%sBACKUP\\%s", g_szRootPath, szToday);
		CreateDirectory(buf, NULL);
		strftime(str, 200, "%H%M%S", tp);
		if (g_Client[no].nSeq == 2)
			sprintf(buf, "%sBACKUP\\%s\\%s.%s.%s.txt", g_szRootPath, szToday,
											 str, g_Client[no].szProg,
											 g_Client[no].szNo);
		else
			sprintf(buf, "%sBACKUP\\%s\\%s.%s.%04d-%04d.txt", g_szRootPath, szToday,
											 str, g_Client[no].szProg,
											 g_Client[no].nSector, g_Client[no].nCup);

		MoveFile(tmpfile, buf);
		WriteLog("MoveFile %s to %s", tmpfile, buf);
	}

	WriteLog("Delete File: %s", tmpfile);
    unlink(tmpfile);
    g_Client[no].bCheck = FALSE;
    g_Client[no].szFileName[0] = '\0';
    tmpfile[0] = '\0';
	
_TRY_EXCEPTION_BLOCK_END(1)

    return 1;
}
