#include <stdio.h>
#include <string.h>
#include "hl7hub.h"

int AddBslash(char *s)
{
    int len;

_TRY_EXCEPTION_BLOCK_BEGIN()

    len = strlen(s);
    if (len == 0) return 0;
    if (s[len-1] == '\\' || s[len-1] == '/') return 0;
    s[len++] = '\\';
    s[len] = '\0';

_TRY_EXCEPTION_BLOCK_END(1)

    return 1;
}

void dbconnect(void) {
////db connection
//
	SQLRETURN ret; /* Odbc API return status*/ 
	SQLINTEGER SQLerr;
	SQLSMALLINT SQLmsglen;
	char pStatus[10], pMsg[101];

	WriteLog("Connecting DB...");

	ret = SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &env);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_ENV, env, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
	}

	ret = SQLSetEnvAttr(env, SQL_ATTR_ODBC_VERSION, (SQLPOINTER*) SQL_OV_ODBC3, 0);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_ENV, env, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
	}

	ret = SQLAllocHandle(SQL_HANDLE_DBC, env, &dbc);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
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
		WriteLog("%s:%s", pStatus, pMsg);
	}
////
}

void dbdisconnect(void) {
	//Disconnect
	SQLRETURN ret; /* Odbc API return status*/ 
	SQLINTEGER SQLerr;
	SQLSMALLINT SQLmsglen;
	char pStatus[10], pMsg[101];

    ret=SQLDisconnect(dbc);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		ret = SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
	}

    ret=SQLFreeHandle(SQL_HANDLE_DBC, dbc);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		ret = SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
	}
	dbc = NULL;
	
	ret=SQLFreeHandle(SQL_HANDLE_ENV, env);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		ret = SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
	}
    env = NULL;

	WriteLog("DB disconnected");

	if (g_dwSleepTime > 0)
		Sleep(g_dwSleepTime);
}