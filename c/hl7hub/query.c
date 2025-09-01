#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "hl7hub.h"

void Query(void)
{
//For SQL:
	SQLINTEGER Length = SQL_NTS;
	SQLHSTMT stmt, stmt2, stmt3;
	SQLCHAR SQL[500];
	SQLCHAR SQL2[500];
	SQLCHAR SQL3[500];
	SQLRETURN ret;
	SQLINTEGER SQLerr;
	SQLSMALLINT SQLmsglen;
	SQLCHAR pStatus[10], pMsg[101];

	char message_id[20];
	char recv_app[15];
	char event[3];
	char client_msgid[24];
	char message[4000];

	SDWORD lmessage_id, lrecv_app, levent, lmessage, lclient;
//for file
    FILE *fp;
	char fname[260];
	char tmpfname[260];
	char filebuf[1024];

	lmessage_id=lrecv_app=levent=lmessage=SQL_NTS;

//init:
	memset(message_id, '\0', 20);
	memset(recv_app, '\0', 15);
	memset(event, '\0', 3);
	memset(message, '\0', 4000);

	memset(pMsg, '\0', 101);

//Download tests:
	sprintf(SQL, "select message_id, recv_app, event, client || '_' || message_id from hl7_header where status = 'R' order by to_number(message_id)");

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
	ret=SQLBindCol(stmt,1,SQL_C_CHAR, message_id, 21, &lmessage_id);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("Binding message id error-%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
		return;
	}

	ret=SQLBindCol(stmt,2,SQL_C_CHAR, recv_app, 16, &lrecv_app);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("Binding recv_app error-%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
		return;
	}

	ret=SQLBindCol(stmt,3,SQL_C_CHAR, event, 4, &levent);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("Binding event error-%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
		return;
	}

	ret=SQLBindCol(stmt,4,SQL_C_CHAR, client_msgid, 25, &lclient);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("Binding client_msgid error-%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
		return;
	}

	while (SQLFetch(stmt) != SQL_NO_DATA) {

		sprintf(tmpfname, "%s%s", g_szTempPath, message_id);

		fp = fopen(tmpfname, "w");
		WriteLog("Writing temp file: %s", tmpfname);

		if (fp == NULL) {
			WriteLog("Cannot open file: %s", tmpfname);
			continue;
		} 

		sprintf(SQL2, "select message from hl7_message where message_id = '%s' order by seq_no", message_id);
//Allocate stmt2		
		ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt2); 
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt2, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
			return;
		}
//Prepare stmt2
		ret = SQLPrepare(stmt2, SQL2, SQL_NTS);
	    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt2, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
			return;
		}
//Execute stmt2
		ret = SQLExecute(stmt2);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt2, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
			return;
		}
//Bind Columns
		ret=SQLBindCol(stmt2,1,SQL_C_CHAR, message, 4001, &lmessage);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt2, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
			return;
		}
			
		while (SQLFetch(stmt2) != SQL_NO_DATA) {

			if (fp == NULL) {
				WriteLog("Cannot open file: %s", tmpfname);
				continue;
			} else {
				sprintf(filebuf, "%s\n", message);

				WriteLog("%s", filebuf);
				fwrite(filebuf, strlen(filebuf), sizeof(char), fp);
			}
		}

		fclose(fp);
		sprintf(fname, "%s%s\\inbox\\%s_%s", g_szRoot, recv_app, event, client_msgid);
		MoveFile(tmpfname, fname);
		WriteLog("Move from %s to %s", tmpfname, fname);

		sprintf(SQL3, "update hl7_header set status = 'D' where message_id = ?");
//Connect for update
		if (g_dwSleepTime > 0)
			Sleep(g_dwSleepTime);

//Allocate stmt3
		ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt3); 
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt3, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("Allocate stmt3 %s:%s", pStatus, pMsg);
		}

// Bind Parameters
		ret = SQLBindParameter(stmt3, 1, SQL_PARAM_INPUT, SQL_C_CHAR, SQL_CHAR, 0, 0, 
			message_id, sizeof(message_id), &lmessage_id);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt3, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("Bind Parameter1 %s:%s", pStatus, pMsg);
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
		}
	
		if (g_dwSleepTime > 0)
			Sleep(g_dwSleepTime);

//Free stmt2
		ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt2);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt2, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
			return;
		}
	}
//Free stmt
	ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
		return;
	}

	if (g_dwSleepTime > 0)
		Sleep(g_dwSleepTime);

}