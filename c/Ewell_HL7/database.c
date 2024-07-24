#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "Ewell_HL7.h"

long insert_msg(char* data)
{
    char program[8];
	char event[3];
	char message[4000];
	char filename[50];
	char dest[16];

	long refid;

	SQLINTEGER Length = SQL_NTS;
	SQLHSTMT stmt;

	SQLCHAR SQL[200] = "{call HL7_RECV(?,?,?,?,?,?)}";
 /* 
  P_RECV_APP IN VARCHAR2,
  P_EVENT IN VARCHAR2,
  P_CLIENT IN VARCHAR2,
  P_MESSAGE IN VARCHAR2,
  P_FILENAME IN VARCHAR2,
  P_REFID OUT NUMBER
*/

_TRY_EXCEPTION_BLOCK_BEGIN()

	sprintf(program, "EWELL\0");
	sprintf(event, "ADT\0");
	strcpy(message, data);
	sprintf(filename, "\0");
	sprintf(dest, "EWELL-SERVER\0");
		
	ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt); 
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

// Bind Parameters
	ret = SQLBindParameter(stmt, 1, SQL_PARAM_INPUT,
		SQL_C_CHAR, SQL_CHAR, 0, 0,
		program, sizeof(program), &Length);
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

	ret = SQLBindParameter(stmt, 2, SQL_PARAM_INPUT,
		SQL_C_CHAR, SQL_CHAR, 0, 0,
		event, sizeof(event), &Length);
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

	ret = SQLBindParameter(stmt, 3, SQL_PARAM_INPUT,
		SQL_C_CHAR, SQL_CHAR, 0, 0,
		dest, sizeof(dest), &Length);
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

	ret = SQLBindParameter(stmt, 4, SQL_PARAM_INPUT,
		SQL_C_CHAR, SQL_CHAR, 0, 0,
		message, sizeof(message), &Length);
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

	ret = SQLBindParameter(stmt, 5, SQL_PARAM_INPUT,
		SQL_C_CHAR, SQL_CHAR, 0, 0,
		filename, sizeof(filename), &Length);
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}
	
	ret = SQLBindParameter(stmt, 6, SQL_PARAM_INPUT,
		SQL_C_LONG, SQL_INTEGER, 0, 0,
		&refid, 0, &Length);
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

	WriteLog("RECV: %s", message);

//Prepare SQL
	ret = SQLPrepare(stmt, SQL, SQL_NTS);
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

// Execute statement with parameters
	ret = SQLExecute(stmt);
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
		WriteLog("SQL FAILED: CALL HL7_RECV('EWELL','ADT','EWELL-SERVER',%s,null,out);", data);
	}

_TRY_EXCEPTION_BLOCK_END(1)

	ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt);
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

	return refid;	
}

void reply(long refid)
{
    char message[4000];
	char message_id[20];
	char buf[4000];

	SQLINTEGER Length = SQL_NTS;
	SQLHSTMT stmt, stmt2;

	SQLCHAR SQL[300] =  "select h.message_id, m.message from hl7_header h, hl7_message m where h.message_id = m.message_id and h.recv_app = 'EWELL' and event = 'ADT' and refid = ? order by m.seq_no";

	SDWORD lmessage_id, lmessage;

	BOOL	bFirst;

	lmessage_id=lmessage=SQL_NTS;

_TRY_EXCEPTION_BLOCK_BEGIN()

	ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt); 
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

//Bind Parameter
	ret = SQLBindParameter(stmt, 1, SQL_PARAM_INPUT,
		SQL_C_LONG, SQL_INTEGER, 0, 0,
		&refid, 0, &Length);
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

//Prepare SQL
	ret = SQLPrepare(stmt, SQL, SQL_NTS);
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

//Execute stmt
	ret = SQLExecute(stmt);
	if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

//Bind Columns
	ret=SQLBindCol(stmt,1,SQL_C_CHAR, message_id, 21, &lmessage_id);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("Binding message id error-%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
		return;
	}

	ret=SQLBindCol(stmt,2,SQL_C_CHAR, message, 4001, &lmessage);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 2, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("Binding message error-%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

	bFirst = 1;

	while (SQLFetch(stmt) != SQL_NO_DATA) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
		    break;
		
		if (bFirst)
			sprintf(buf, "%c%s%c\0", VT, message, CR);
		else
			sprintf(buf, "%s%c\0", message, CR);

		SendPacket(&g_ADT, buf);

		bFirst = 0;
	}

//Send last terminate charachers			
	sprintf(message, "%c%c\0", FS, CR);
	SendPacket(&g_ADT, message);

//Free stmt
	ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

//Update status
	sprintf(SQL, "update hl7_header set status = 'D' where message_id = ? and recv_app = 'EWELL' and event = 'ADT' ");

//Allocate stmt3
	ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt2); 
	if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt2, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

// Bind Parameters
	ret = SQLBindParameter(stmt2, 1, SQL_PARAM_INPUT, SQL_C_CHAR, SQL_CHAR, 0, 0, message_id, sizeof(message_id), &lmessage_id);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt2, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

//Prepare stmt			
	ret = SQLPrepare(stmt2, SQL, SQL_NTS);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt2, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

//Execute stmt
	ret = SQLExecute(stmt2);
	if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt2, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

//Free stmt
	ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt2);
	if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt2, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}
	
_TRY_EXCEPTION_BLOCK_END(1)

}

void dbconnect(void) {
////db connection
//
	WriteLog("DB connecting...");

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
        (SQLCHAR*) g_db, 
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

	WriteLog("DB connected");
////
}

void dbdisconnect(void) {
	//Disconnect
	SQLRETURN ret; /* Odbc_upd API return status*/ 
	SQLINTEGER SQLerr;
	SQLSMALLINT SQLmsglen;
	char pStatus[10], pMsg[101];

	WriteLog("DB disconnecting...");

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
}
