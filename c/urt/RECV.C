#include <stdio.h>
#include "urt.h"
#include "service.h"
#include <sqlext.h>
#include <time.h>

int RecvProc(void)
{
	int				row = 0;
    char			buf[1024];

    FILE *fRow;
	FILE *fout;

	SQLHENV env;
	SQLHDBC dbc;
	SQLHSTMT stmt;
	SQLRETURN ret; /* ODBC API return status*/ 
	SQLCHAR SQL[500];
	SQLINTEGER SQLerr;
	SQLSMALLINT SQLmsglen;

	SQLCHAR OutConnStr[255];
	SQLSMALLINT OutConnStrLen;

	char pStatus[10], pMsg[101];

//bind parameter for SQL
	// field length parameters...
	//SDWORD lPREFIX, lMACHINE, lLOTNUM, lTEST, lRESULT, lROW;
	//lPREFIX=lMACHINE=lLOTNUM=lTEST=lRESULT=lROW=SQL_NTS;
	SDWORD lPREFIX=SQL_NTS;
	SDWORD lMACHINE=SQL_NTS;
	SDWORD lLOTNUM=SQL_NTS;
	SDWORD lTEST=SQL_NTS;
	SDWORD lRESULT=SQL_NTS;
	SDWORD lROW=SQL_NTS;

//result set
	char prefix[26];
	char machine[6];
	char lotnum[16];
	char test[6];
	char result[7];
	int  rownum;

	char labnum[8];
	char inst[7];
	char testMethod[12];
	char suffix[18];

    char fname[260];
    time_t t;
    struct tm *tp;
	char DateTime[15];
    char *p;
	int i;

//read row config
	fRow = fopen(g_szRowFile, "rt");
	if (fRow == NULL) {
		WriteLog("Config file not found: %s assume Row ID = %d", g_szRowFile, row);
	} else {
		fgets(buf, 1024, fRow);
		row = atoi(buf);
		WriteLog("Read row ID: %d", row);
		if (row < 0) row = 0;
		fclose(fRow);
	}

//sql connection
	ret = SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &env);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_ENV, env, 1,
		pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", &pStatus, &pMsg);
	}

	ret = SQLSetEnvAttr(env, SQL_ATTR_ODBC_VERSION, (SQLPOINTER*) SQL_OV_ODBC3, 0);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_ENV, env, 1,
		pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", &pStatus, &pMsg);
	}

	ret = SQLAllocHandle(SQL_HANDLE_DBC, env, &dbc);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
		pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", &pStatus, &pMsg);
	}

	ret = SQLDriverConnect(
		dbc, 
        NULL, 
        (SQLCHAR*) g_szServer, 
		SQL_NTS,
        OutConnStr,
        255, 
        &OutConnStrLen,
        SQL_DRIVER_NOPROMPT );
	
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
		pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", &pStatus, &pMsg);
	}

    while (1) {

		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0) {
			writeRowFile(row);
		    break;
		}
		
		ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt); 
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", &pStatus, &pMsg);
		}


		sprintf(SQL, "select 'Point|' || to_char(r.TEST_DATE, 'yyyymmddhhmiss') ||  '|1|' || nvl(s.QC_LEVEL, '1') || '|', m.mach_code, s.LOT_NUMBER,  p.code, r.result, r.row_num from labo_qc_sample s, labm_machine m, labo_qc_result r, labm_prices p where s.test_type = m.mach_type and s.EQUIPMENT = m.MACH_NO and s.test_type = r.TEST_TYPE and s.cntl_num = r.cntl_num and s.test_type = p.test_type and r.int_tcode = p.int_tcode and r.row_num > %d order by r.row_num", row);

		ret = SQLPrepare(stmt, SQL, SQL_NTS);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", &pStatus, &pMsg);
		}
	
		ret = SQLExecute(stmt);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", &pStatus, &pMsg);
		}

		ret=SQLBindCol(stmt,1,SQL_C_CHAR, prefix, sizeof(prefix), &lPREFIX);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", &pStatus, &pMsg);
		}

	    ret=SQLBindCol(stmt,2,SQL_C_CHAR, machine, sizeof(machine), &lMACHINE);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", &pStatus, &pMsg);
		}

		ret=SQLBindCol(stmt,3,SQL_C_CHAR,  lotnum, sizeof(lotnum), &lLOTNUM);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", &pStatus, &pMsg);
		}

		ret=SQLBindCol(stmt,4,SQL_C_CHAR,  test, sizeof(test), &lTEST);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", &pStatus, &pMsg);
		}

		ret=SQLBindCol(stmt,5,SQL_C_CHAR,  result, sizeof(result), &lRESULT);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", &pStatus, &pMsg);
		}

		ret=SQLBindCol(stmt,6,SQL_C_ULONG, &rownum, sizeof(int), &lROW);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
		}

		ret=SQLFetch(stmt);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO)
			continue;

//set output file name
		time(&t);
		tp = localtime(&t);

		if (tp != NULL) {
			sprintf(DateTime, "%04d%02d%02d%02d%02d%02d\0", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
					tp->tm_hour, tp->tm_min, tp->tm_sec);
		} else {
			sprintf(DateTime, "UniFlex\0");
		}

		sprintf(fname, "%s%s.txt\0", g_szOutBoxPath, DateTime);

		fout = fopen(fname, "at");
		if (fout == NULL) {
			WriteLog("Cannot open file: %s", fname);
			break;
		}

		for (i=0; i<g_page; i++) {
			if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
				break;

			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				writeRowFile(row);
				break;
			}

			row = rownum;

			strcpy (buf, machine);
			if (!ConvertCode(g_szMachFile, buf)) {
				ret=SQLFetch(stmt);
				continue;
			}

			
			ParseDelimiter(buf, 1, '|', labnum);
		    p = strrchr(buf, '|');
			strcpy (inst, p);

			strcpy (buf, test);
			if (!ConvertCode(g_szCodeFile, buf)) {
				ret=SQLFetch(stmt);
				continue;
			}

			ParseDelimiter(buf, 1, ',', testMethod);
		    p = strrchr(buf, ',');
			p++;
			strcpy (suffix, p);

			sprintf(buf, "%s%s|%s%s%s%s%s|\n", prefix, labnum, lotnum, testMethod, inst, suffix, result);
			fwrite(buf, strlen(buf), sizeof(char), fout);

			ret=SQLFetch(stmt);
		}
		fclose(fout);

		ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", &pStatus, &pMsg);
		}
    }

	ret=SQLDisconnect(dbc);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		ret = SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
		pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", &pStatus, &pMsg);
	}
    
	ret=SQLFreeHandle(SQL_HANDLE_DBC, dbc);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		ret = SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
		pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", &pStatus, &pMsg);
	}

    return 0;
}
