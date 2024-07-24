#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "JVM.h"

long insert_msg(char* data)
{
    char program[8];
	char event[3];
	char message[4000];
	char filename[50];

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

	sprintf(program, "JVM\0");
	sprintf(event, "ALL\0");
	strcpy(message, data);
	sprintf(filename, "\0");

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
		g_Client.ip, sizeof(g_Client.ip), &Length);
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

void response(long refid)
{
    char message[4000];
	char message_id[20];
	char buf[4000];

	SQLINTEGER Length = SQL_NTS;
	SQLHSTMT stmt;

	SDWORD lmessage_id, lmessage;

	BOOL	bFirst;

	lmessage_id=lmessage=SQL_NTS;

_TRY_EXCEPTION_BLOCK_BEGIN()
	SQLCHAR SQL[300] = "select max(message_id) from hl7_header where refid = ?";

	ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt); 
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

//Bind Parameter1
	ret = SQLBindParameter(stmt, 1, SQL_PARAM_INPUT,
		SQL_C_LONG, SQL_INTEGER, 0, 0,
		&refid, 0, &Length);
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

//Prepare SQL1
	ret = SQLPrepare(stmt, SQL, SQL_NTS);
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

//Execute stmt1
	ret = SQLExecute(stmt);
	if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

//Bind Columns1
	ret=SQLBindCol(stmt,1,SQL_C_CHAR, message_id, 21, &lmessage_id);

	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("Binding message id error-%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
		return;
	}

	if (SQLFetch(stmt) == SQL_NO_DATA) {
		return;
	}

	if (lmessage_id == SQL_NULL_DATA) {
		WriteLog("message_id is null, refid=%d", refid);
		return;
	}

	strcpy(SQL, "select message from hl7_message where message_id = ? order by seq_no\0");

	ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt); 
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

//Bind Parameter2
	ret = SQLBindParameter(stmt, 1, SQL_PARAM_INPUT,
		SQL_C_CHAR, SQL_CHAR, 0, 0,
		message_id, sizeof(message_id), &Length);
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

//Prepare SQL2
	ret = SQLPrepare(stmt, SQL, SQL_NTS);
    if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

//Execute stmt2
	ret = SQLExecute(stmt);
	if (ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

//Bind Columns
	ret=SQLBindCol(stmt,1,SQL_C_CHAR, message, 4001, &lmessage);
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
		
		if (g_bDebug)
			WriteLog("DEBUG: %s", message);

		if (bFirst)
			sprintf(buf, "%c%s%c\0", VT, message, CR);
		else {
			SendLine(&g_Client, buf);
			sprintf(buf, "%s%c\0", message, CR);
		}

		bFirst = 0;
	}

//Add last terminate charachers			
	sprintf(buf, "%s%c%c\0", buf, FS, CR);
	SendLine(&g_Client, buf);

//Free stmt
	ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}
	
_TRY_EXCEPTION_BLOCK_END(1)

}
