#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "referralPDF.h"

int AddEntry(char fname[260])
{
	char labno[10];
	char message[100] = "\0";

	SQLINTEGER Length = SQL_NTS;
	SQLHSTMT stmt;
	SQLCHAR SQL[200] = 
		"{call P_add_referral(?,?,?,?,?)}";

	SDWORD ldup;
	ldup = SQL_NTS;

_TRY_EXCEPTION_BLOCK_BEGIN()

	WriteLog("processing %s", fname);
	
	strcpy(labno, fname);
	strtok(labno, ".");

	//WriteLog("fname=%s, labno=%s, seq=%s, version=%s", fname, labno, seq, ver);

	ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt); 
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return 0;
	}

// Bind Parameters
	ret = SQLBindParameter(stmt, 1, SQL_PARAM_INPUT,
		SQL_C_CHAR, SQL_CHAR, 0, 0,
		labno, sizeof(labno), &Length);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return 0;
	}

	ret = SQLBindParameter(stmt, 2, SQL_PARAM_INPUT,
		SQL_C_CHAR, SQL_CHAR, 0, 0,
		g_szFileServer, sizeof(g_szFileServer), &Length);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return 0;
	}

	ret = SQLBindParameter(stmt, 3, SQL_PARAM_INPUT,
		SQL_C_CHAR, SQL_CHAR, 0, 0,
		g_szShare, sizeof(g_szShare), &Length);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return 0;
	}

	ret = SQLBindParameter(stmt, 4, SQL_PARAM_INPUT,
		SQL_C_CHAR, SQL_CHAR, 0, 0,
		fname, sizeof(fname), &Length);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return 0;
	}

	ret = SQLBindParameter(stmt, 5, SQL_PARAM_OUTPUT,
		SQL_C_CHAR, SQL_CHAR, 0, 0,
		message, sizeof(message), &Length);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return 0;
	}

//Prepare SQL
	ret = SQLPrepare(stmt, SQL, SQL_NTS);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return 0;
	}
// Execute statement with parameters
	ret = SQLExecute(stmt);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return 0;
	}

	ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbconnect();
		return 0;
	}

	if (strlen(message) > 0)
		WriteLog("%s", message);

_TRY_EXCEPTION_BLOCK_END(1)

    return 1;
}
