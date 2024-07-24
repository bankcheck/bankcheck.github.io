#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "labtest.h"

void Query(void)
{
//For SQL:
	SQLINTEGER Length = SQL_NTS;
	SQLHSTMT stmt, stmt2, stmt3;
	SQLCHAR SQL[600];
	SQLCHAR SQL2[600];
	SQLCHAR SQL3[600];
	SQLRETURN ret;
	SQLINTEGER SQLerr;
	SQLSMALLINT SQLmsglen;
	SQLCHAR pStatus[10], pMsg[101];

	char lab_num[8];
	char test[10];
	char k700[11];
	char path[255];
//	char patient[90];
//	char spec_code;
//	char test_type;
//	char mach_no;
//	char priority[7];
//	char hospnum[16];
//	char sex;
//	char age[3];
//	char age_month[2];
	char header[250];
	char sample_id[17];
//	char birth_date[9];
//	char mach_code[6];

	SDWORD llab_num, ltest, lk700, lpath, lheader, lsample_id;
//for file
    FILE *fp;
	char fname[260];
	char tmpfname[260];
	char filebuf[260];

	llab_num=ltest=lk700=lpath=lheader=lsample_id=SQL_NTS;

//init:
	memset(header, '\0', 250);
	memset(sample_id, '\0', 17);

	memset(pStatus, '\0', 10);
	memset(pMsg, '\0', 101);

//Download tests:
	//sprintf(SQL, "select distinct h.lab_num, m.path, h.patient, nvl(s.spec_code, 'S'), h.priority, h.hospnum, d.test_type, p.mach_no, sex, to_char(age), to_char(age_month), d.sample_id, to_char(h.birth_date, 'yyyymmdd'), m.mach_code from labo_detail d, labm_prices p, labm_machine m, labo_masthead h, labm_spec_type s where d.TEST_NUM = p.code and s.spec_type = h.spec_type and p.test_type = m.mach_type and p.mach_no = m.mach_no and d.lab_num = h.lab_num and d.status = '3' and p.code_k700 is not null and int_ser='%s' and d.test_type = m.mach_type and d.result is null and d.sample_id is not null", g_Host);
	//sprintf(SQL, "select distinct h.lab_num, m.path, nvl(h.patient,','), nvl(s.spec_code, 'S'), h.priority, h.hospnum, sex, to_char(age), to_char(age_month), d.sample_id, to_char(h.birth_date, 'yyyymmdd') from labo_detail d, labm_prices p, labm_machine m, labo_masthead h, labm_spec_type s where d.TEST_NUM = p.code and s.spec_type = h.spec_type and p.test_type = m.mach_type and p.mach_no = m.mach_no and d.lab_num = h.lab_num and d.status = '3' and p.code_k700 is not null and int_ser='%s' and d.test_type = m.mach_type and d.result is null and d.sample_id is not null", g_Host);
	sprintf(SQL, "select distinct d.lab_num, m.path, f_download_pat_header(d.lab_num), d.sample_id from labo_detail d, labm_prices p, labm_machine m where d.TEST_NUM = p.code and p.test_type = m.mach_type and p.mach_no = m.mach_no and d.status = '3' and p.code_k700 is not null and int_ser='%s' and d.test_type = m.mach_type and d.result is null and d.sample_id is not null", g_Host);

//Allocate Handle stmt
	ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt); 
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
		return;
	}
//Prepare stmt
	ret = SQLPrepare(stmt, SQL, SQL_NTS);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
		return;
	}
//Execute stmt
	ret = SQLExecute(stmt);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
		return;
	}
//Bind Columns
	ret=SQLBindCol(stmt,1,SQL_C_CHAR, lab_num, 9, &llab_num);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("Binding lab_num error-%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
		return;
	}

	ret=SQLBindCol(stmt,2,SQL_C_CHAR, path, 256, &lpath);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("Binding path error-%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
		return;
	}

	ret=SQLBindCol(stmt,3,SQL_C_CHAR, header, 251, &lheader);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("Binding patient error-%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
		return;
	}

	ret=SQLBindCol(stmt,4,SQL_C_CHAR, sample_id, 18, &lsample_id);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("Binding age_month error-%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
		return;
	}

	while (SQLFetch(stmt) != SQL_NO_DATA) {
		sprintf(fname, "%s%s\\inbox\\%s", g_szRoot, path, sample_id);
		sprintf(tmpfname, "%s%s", g_szTempPath, sample_id);
		fp = fopen(tmpfname, "a");
		WriteLog("Writing instrument file: %s", tmpfname);

		if (fp == NULL) {
			WriteLog("Cannot open file: %s", tmpfname);
			continue;
		} else {
			sprintf(filebuf, "%s\n", header);
			WriteLog("%s", filebuf);
			fwrite(filebuf, strlen(filebuf), sizeof(char), fp);
		}

		//sprintf(SQL2, "select d.test_num, p.code_k700 from labo_detail d, labm_prices p where d.TEST_NUM = p.code and d.test_type = '%c' and p.mach_no = '%c' and p.code_k700 is not null and d.sample_id='%s'", test_type, mach_no, sample_id);
		sprintf(SQL2, "select d.test_num, p.code_k700 from labo_detail d, labm_prices p, labm_machine m where d.TEST_NUM = p.code and p.test_type = m.mach_type and p.mach_no = m.mach_no and p.code_k700 is not null and d.sample_id='%s' and m.path='%s'", sample_id, path);
//Allocate stmt2		
		ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt2); 
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt2, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("Allocate stmt2 %s:%s", pStatus, pMsg);			
		}

//Prepare stmt2
		ret = SQLPrepare(stmt2, SQL2, SQL_NTS);
	    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt2, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("Prepare stmt2 %s:%s", pStatus, pMsg);
		}

//Execute stmt2
		ret = SQLExecute(stmt2);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt2, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("Execute stmt2 %s:%s", pStatus, pMsg);
		}

//Bind Columns
		ret=SQLBindCol(stmt2,1,SQL_C_CHAR, test, 11, &ltest);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt2, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("Bind test %s:%s", pStatus, pMsg);
		}

		ret=SQLBindCol(stmt2,2,SQL_C_CHAR, k700, 12, &lk700);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt2, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("Bind k700 %s:%s", pStatus, pMsg);	
			dbdisconnect();
			dbconnect();

			if (fp != NULL) {
				fclose(fp);
				fp = NULL;
			}

			continue;
		}
			
		while (SQLFetch(stmt2) != SQL_NO_DATA) {

			if (fp == NULL) {
				WriteLog("Cannot open file: %s", tmpfname);
				continue;
			} else {
				sprintf(filebuf, "%s\n", k700);
				WriteLog("%s", filebuf);
				fwrite(filebuf, strlen(filebuf), sizeof(char), fp);
			}

			sprintf(SQL3, "update labo_detail set status = 'D' where sample_id = ? and test_num = ? and status='3' and result is null");

//Allocate stmt3
			ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt3); 
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt3, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("Allocate stmt3 %s:%s", pStatus, pMsg);
			}

// Bind Parameters
			ret = SQLBindParameter(stmt3, 1, SQL_PARAM_INPUT, SQL_C_CHAR, SQL_CHAR, 0, 0, 
				sample_id, sizeof(sample_id), &lsample_id);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt3, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("Bind sample_id %s:%s", pStatus, pMsg);
			}

			ret = SQLBindParameter(stmt3, 2, SQL_PARAM_INPUT, SQL_C_CHAR, SQL_CHAR, 0, 0,
				test, sizeof(test), &ltest);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt3, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("Bind test %s:%s", pStatus, pMsg);
			}

//Prepare stmt3			
			ret = SQLPrepare(stmt3, SQL3, SQL_NTS);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt3, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("Prepare stmt3	%s:%s", pStatus, pMsg);
			}

//Execute stmt3
			ret = SQLExecute(stmt3);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt3, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("Execute stmt3 %s:%s", pStatus, pMsg);
			}

//Free stmt3
			ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt3);
			if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
				SQLGetDiagRec(SQL_HANDLE_STMT, stmt3, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
				WriteLog("Free stmt3 %s:%s", pStatus, pMsg);
				dbdisconnect();
				dbconnect();
			}
		}

		if (fp != NULL) {
			fclose(fp);
			fp = NULL;
		}

		WriteLog("Moving file from %s to %s", tmpfname, fname);
		CopyFile(tmpfname, fname, FALSE);	
		DeleteFile(tmpfname);

//Free stmt2
		ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt2);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt2, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("Free stmt2 %s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
		}
	}
//Free stmt
	ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

}