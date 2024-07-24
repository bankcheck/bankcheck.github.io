#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "HL7LISTENER.h"
//#include <sqlext.h>

DWORD SendThreadProc(LPVOID pParm)
{
    int no;
    FILE *fp;
    char message[4000];
    char data[4000];
    char *p;
    char program[16];
	char filename[260];
	char backupfile[260];
	char event[3];
	char client[16];

	long refid;

	SQLINTEGER Length = SQL_NTS;
	SQLHSTMT stmt;

	SQLCHAR SQL[200] = "{call HL7_RECV(?,?,?,?,?,?)}";


_TRY_EXCEPTION_BLOCK_BEGIN()

    no = (int)pParm;
	strcpy(program, g_Client[no].szProg);

	p = strrchr(g_Client[no].szFileName, '\\');
	p++;
	strcpy(filename, p);

	ParseDelimiter(filename, 1, '_', event);
	ParseDelimiter(filename, 2, '_', client);

    fp = fopen(g_Client[no].szFileName, "r");
    if (fp == NULL) {
        WriteLog("Can't open %s", g_Client[no].szFileName);
        if (g_dwErrorSleepTime != 0)
            Sleep(g_dwErrorSleepTime);
        g_Client[no].szFileName[0] = '\0';
        return 0;
    }

    while (1) {
        if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleepTime) == WAIT_OBJECT_0)
		    break;

        if (fgets(data, 4000, fp) == NULL) break;

		p = strtok(data, "\n\0");
		if (p != NULL) {
			strcpy(message, p);
		} else {
			continue;
		}
		
		ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt); 
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
			continue;
		}

// Bind Parameters
		ret = SQLBindParameter(stmt, 1, SQL_PARAM_INPUT,
			SQL_C_CHAR, SQL_CHAR, 0, 0,
			g_Client[no].szProg, sizeof(g_Client[no].szProg), &Length);
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
			continue;
		}

		ret = SQLBindParameter(stmt, 2, SQL_PARAM_INPUT,
			SQL_C_CHAR, SQL_CHAR, 0, 0,
			event, sizeof(event), &Length);
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
			continue;
		}

		ret = SQLBindParameter(stmt, 3, SQL_PARAM_INPUT,
			SQL_C_CHAR, SQL_CHAR, 0, 0,
			client, sizeof(client), &Length);
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
			continue;
		}

		ret = SQLBindParameter(stmt, 4, SQL_PARAM_INPUT,
			SQL_C_CHAR, SQL_CHAR, 0, 0,
			message, sizeof(message), &Length);
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
			continue;
		}

		ret = SQLBindParameter(stmt, 5, SQL_PARAM_INPUT,
			SQL_C_CHAR, SQL_CHAR, 0, 0,
			filename, sizeof(filename), &Length);
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
			continue;
		}
	
		ret = SQLBindParameter(stmt, 6, SQL_PARAM_INPUT,
			SQL_C_LONG, SQL_INTEGER, 0, 0,
			&refid, 0, &Length);
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
			continue;
		}

		WriteLog("%s: %s", program, message);

//Prepare SQL
		ret = SQLPrepare(stmt, SQL, SQL_NTS);
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
			continue;
		}
// Execute statement with parameters
		ret = SQLExecute(stmt);
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
			continue;
		}
		ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt);
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
			continue;
		}
	}

    fclose(fp);

	if (g_Client[no].bResponse)
		reply(refid, no);

    if (g_bBackup) {
        time_t t;
        struct tm *tp;

        time(&t);
        tp = localtime(&t);
		
		sprintf(backupfile, "%s%02d%02d%02d%02d%02d", g_szBackupPath, tp->tm_mon+1, tp->tm_mday, tp->tm_hour, tp->tm_min, tp->tm_sec);
        CopyFile(g_Client[no].szFileName, backupfile, FALSE);
        WriteLog("Copy File %s to %s", g_Client[no].szFileName, backupfile);
    }

    CopyFile(g_Client[no].szFileName, g_Client[no].szBackupFile, FALSE);
    WriteLog("Copy File %s to %s", g_Client[no].szFileName, g_Client[no].szBackupFile);

	WriteLog("Delete FIle: %s", g_Client[no].szFileName);
    unlink(g_Client[no].szFileName);

    g_Client[no].szFileName[0] = '\0';
	
_TRY_EXCEPTION_BLOCK_END(1)

    return 1;
}
