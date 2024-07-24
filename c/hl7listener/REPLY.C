#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "HL7LISTENER.h"

void reply(long refid, int no)
{
	char filename[42];
    char message[4000];

	SQLINTEGER Length = SQL_NTS;
	SQLHSTMT stmt;

	SQLCHAR SQL[200] =  "select h.event || '_'|| h.client || '_' || h.message_id, m.message from hl7_header h, hl7_message m where h.message_id = m.message_id and refid = ? order by m.seq_no";

	SDWORD lfilename, lmessage;

//for file
    FILE *fp;
	char fname[260];
	char tmpfname[260];
	char filebuf[1024];

	lfilename=lmessage=SQL_NTS;


_TRY_EXCEPTION_BLOCK_BEGIN()

	ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt); 
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

//Bind Parameter
	ret = SQLBindParameter(stmt, 1, SQL_PARAM_INPUT,
		SQL_C_LONG, SQL_INTEGER, 0, 0,
		&refid, 0, &Length);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

	ret = SQLPrepare(stmt, SQL, SQL_NTS);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
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
	ret=SQLBindCol(stmt,1,SQL_C_CHAR, filename, 43, &lfilename);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,	pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("Binding message id error-%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

	ret=SQLBindCol(stmt,2,SQL_C_CHAR, message, 4001, &lmessage);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1, pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("Binding recv_app error-%s:%s", pStatus, pMsg);
		dbdisconnect();
		dbconnect();
	}

	while (SQLFetch(stmt) != SQL_NO_DATA) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleepTime) == WAIT_OBJECT_0)
		    break;

		//WriteLog("message: %s", message);
		//WriteLog("filename: %s", filename);

		sprintf(tmpfname, "%s%s", g_szTempPath, filename);

		fp = fopen(tmpfname, "a");

		if (fp == NULL) {
			WriteLog("Cannot open file: %s", tmpfname);
		} else {
			sprintf(filebuf, "%s\n", message);
			WriteLog("%s", filebuf);
			fwrite(filebuf, strlen(filebuf), sizeof(char), fp);
		}
		
		fclose(fp);
	}

	sprintf(fname, "%s%s", g_Client[no].szInboxPath, filename);
	MoveFile(tmpfname, fname);
	WriteLog("Move from %s to %s", tmpfname, fname);

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
