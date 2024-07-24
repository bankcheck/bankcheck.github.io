#include <stdio.h>
#include <string.h>
#include "labclnt.h"

int PutLine(int no, char *buf)
{
    int n;
    BOOL b;

_TRY_EXCEPTION_BLOCK_BEGIN()

    if (g_Client == NULL) return 0;
    b = g_Client[no].bCheck;
    g_Client[no].bCheck = FALSE;
    g_Client[no].tick = GetTickCount();
    g_Client[no].bCheck = b;
    if (g_Client[no].s == SOCKET_ERROR) return 0;
    n = send(g_Client[no].s, buf, strlen(buf), 0);
    if (n == 0 || n == SOCKET_ERROR)
        return 0;

_TRY_EXCEPTION_BLOCK_END(1)

    return n;
}

int GetLine(int no, char *buf, int bufsize)
{
    int n;
    char ch;
    int i;
    BOOL b;

_TRY_EXCEPTION_BLOCK_BEGIN()

    if (g_Client == NULL) return 0;
    if (g_Client[no].s == SOCKET_ERROR) return 0;
    i = 0;
    buf[0] = '\0';
    while (1) {
        b = g_Client[no].bCheck;
        g_Client[no].bCheck = FALSE;
        g_Client[no].tick = GetTickCount();
        g_Client[no].bCheck = b;
        n = recv(g_Client[no].s, &ch, 1, 0);
        if (n == 0 || n == SOCKET_ERROR)
	    return 0;
	buf[i++] = ch;
	if (ch == '\n' && buf[i-2] == '\r') {
	    buf[i-2] = '\0';
            break;
	}
	if (i >= bufsize) {
	    buf[i] = '\0';
            break;
	}
    }

_TRY_EXCEPTION_BLOCK_END(1)

    return i;
}

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

int GetResult(char *s)
{
    char buf[260];
    char *p;
    int result;

_TRY_EXCEPTION_BLOCK_BEGIN()

    result = -1;
    p = &buf[0];
    while (*s >= '0' && *s <= '9')
        *p++ = *s++;
    *p ='\0';
    if (p == buf) return result;
    result = atoi(buf);

_TRY_EXCEPTION_BLOCK_END(1)

    return result;
}

void dbconnect(void) {
////db connection
//
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
	SQLRETURN ret; /* Odbc_upd API return status*/ 
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

	WriteLog("DB disconnected.");
}

