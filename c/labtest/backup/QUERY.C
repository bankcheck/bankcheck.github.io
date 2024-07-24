#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "labtest.h"

void Query(void)
{
//For SQL:
	SQLINTEGER Length = SQL_NTS;
	SQLHSTMT stmt, stmt3;
	SQLCHAR SQL[600];
	SQLCHAR SQL3[600];
	SQLRETURN ret;
	SQLINTEGER SQLerr;
	SQLSMALLINT SQLmsglen;
	char pStatus[10], pMsg[101];

	char lab_num[8];
	char test[10];
	char k700[5];
	char path[255];
	char patient[50];
	char spec_code;
	char test_type;
	char mach_no;
	char priority[7];
	char hospnum[12];
	SDWORD llab_num, ltest, lk700, lpath, lpatient, lspec_code, lpriority, lhospnum, ltest_type, lmach_no;
//for file
    FILE *fp;
	char fname[260];
	char filebuf[260];
//find handle
    WIN32_FIND_DATA data;
    HANDLE hFind;
	
	llab_num=ltest=lk700=lpath=lpatient=lspec_code=lpriority=lhospnum=SQL_NTS;

//init:
	memset(patient, '\0', 50);
	memset(hospnum, '\0', 12);
//Download tests:
	sprintf(SQL, "select h.lab_num, m.path, h.patient, nvl(s.spec_code, 'S'), h.priority, h.hospnum, d.test_type, p.mach_no, d.test_num, p.code_k700 from labo_detail d, labm_prices p, labm_machine m, labo_masthead h, labm_spec_type s where d.TEST_NUM = p.code and s.spec_type = h.spec_type and p.test_type = m.mach_type and p.mach_no = m.mach_no and d.lab_num = h.lab_num and d.status = '3' and p.code_k700 is not null and int_ser='%s' and d.test_type = m.mach_type and d.result is null order by d.lab_num, m.path", g_Host);
//Allocate Handle stmt
	ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt); 
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return;
	}
//Prepare stmt
	ret = SQLPrepare(stmt, SQL, SQL_NTS);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return;
	}
//Execute stmt
	ret = SQLExecute(stmt);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return;
	}
//Bind Columns
	ret=SQLBindCol(stmt,1,SQL_C_CHAR, lab_num, 9, &llab_num);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return;
	}

	ret=SQLBindCol(stmt,2,SQL_C_CHAR, path, 256, &lpath);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return;
	}

	ret=SQLBindCol(stmt,3,SQL_C_CHAR, patient, 51, &lpatient);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return;
	}

	ret=SQLBindCol(stmt,4,SQL_C_CHAR, &spec_code, 2, &lspec_code);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return;
	}

	ret=SQLBindCol(stmt,5,SQL_C_CHAR, priority, 8, &lpriority);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return;
	}

	ret=SQLBindCol(stmt,6,SQL_C_CHAR, hospnum, 13, &lhospnum);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return;
	}

	ret=SQLBindCol(stmt,7,SQL_C_CHAR, &test_type, 2, &ltest_type);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return;
	}
	ret=SQLBindCol(stmt,8,SQL_C_CHAR, &mach_no, 2, &lmach_no);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return;
	}

	ret=SQLBindCol(stmt,9,SQL_C_CHAR, test, 11, &ltest);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return;
	}

	ret=SQLBindCol(stmt,10,SQL_C_CHAR, k700, 6, &lk700);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return;
	}	

	while (SQLFetch(stmt) != SQL_NO_DATA) {
		sprintf(fname, "%s%s\\inbox\\%s", g_szRoot, path, lab_num);
        hFind = FindFirstFile(fname, &data);
		if (hFind == INVALID_HANDLE_VALUE) {
//Close opened file
			if (fp != NULL) {
				fclose(fp);
			}
//Write file header
			fp = fopen(fname, "w");
			WriteLog("Writing instrument file: %s", fname);
			sprintf(filebuf, "%s|%c|%s|%s\n", patient, spec_code, hospnum, priority);
			WriteLog("%s", filebuf);
			fwrite(filebuf, strlen(filebuf), sizeof(char), fp);
		}
//Write instrument code
		sprintf(filebuf, "%s\n", k700);
		WriteLog("%s", filebuf);
		fwrite(filebuf, strlen(filebuf), sizeof(char), fp);

		sprintf(SQL3, "update labo_detail set status = 'D' where lab_num = ? and test_num = ? and status='3' and result is null");
//Allocate stmt3
		ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt3); 
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt3, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbconnect();
			continue;
		}
// Bind Parameters
		ret = SQLBindParameter(stmt3, 1, SQL_PARAM_INPUT, SQL_C_CHAR, SQL_CHAR, 0, 0, 
			lab_num, sizeof(lab_num), &llab_num);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt3, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbconnect();
			continue;
		}

		ret = SQLBindParameter(stmt3, 2, SQL_PARAM_INPUT, SQL_C_CHAR, SQL_CHAR, 0, 0,
			test, sizeof(test), &ltest);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt3, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbconnect();
			continue;
		}
//Prepare stmt3			
		ret = SQLPrepare(stmt3, SQL3, SQL_NTS);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt3, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbconnect();
			continue;
		}
//Execute stmt3
		ret = SQLExecute(stmt3);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt3, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbconnect();
			continue;
		}
//Free stmt3
		ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt3);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt3, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbconnect();
			continue;
		}
	}
	fclose(fp);
//Free stmt
	ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return;
	}
}
