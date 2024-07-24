#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "labclnt.h"

DWORD SendThreadProc(LPVOID pParm)
{
    int no;
    FILE *fp;
    //LPHOSTENT hp;
    //struct in_addr ip;
    //struct sockaddr_in addr;
    //DWORD *pa;
    char buf[2048], str[2048];
    char *p;
    //short port;
    char server[260];
    char test[30];
    char seq[14];
	char result[12];
	char labno[12];
	char machine[12];

	SQLINTEGER Length = SQL_NTS;
	SQLHENV env;
	SQLHDBC dbc;
	SQLHSTMT stmt;
	SQLCHAR SQL[200] = 
		"insert into LABO_INTERFACE (LAB_NUM, SEQ_NUM, CODE_K700, RESULT, MACH_CODE)values (?,?,?,?,?)";
	SQLRETURN ret; /* ODBC API return status*/ 
		
	SQLINTEGER SQLerr;
	SQLSMALLINT SQLmsglen;
	char pStatus[10], pMsg[101];

	SQLCHAR OutConnStr[255];
    SQLSMALLINT OutConnStrLen;

_TRY_EXCEPTION_BLOCK_BEGIN()

    no = (int)pParm;
	strcpy(machine, g_Client[no].szProg);

	p = strrchr(g_Client[no].szFileName, '\\');
	p++;
	strcpy(labno, p);
	p = strtok(labno, ".\0");
	strcpy(labno, p);
	labno[8] = '\0';

	p = strrchr(g_Client[no].szFileName, '\\');
	p = p + strlen(p) - g_nSeqDigit;
	strcpy(seq, p);

    if (g_bDebug) {
        WriteLog("Program: %s", g_Client[no].szProg);
        WriteLog("FileName: %s", g_Client[no].szFileName);
        //WriteLog("No: %s", g_Client[no].szNo);
        //WriteLog("Seq: %d", g_Client[no].nSeq);
        WriteLog("CopyTest: %d", g_Client[no].bCopyTest);
        WriteLog("TestDir: %s", g_Client[no].szTestDir);
    }
    else
        WriteLog("FileName: %s", g_Client[no].szFileName);
    
	strcpy(server, g_szServer);

    /*port = g_nPort;
    hp = gethostbyname(server);
    if (hp == NULL) {
        ip.s_addr = inet_addr(server);
	if (ip.s_addr == INADDR_NONE) {
            WriteLog(no, "Can't get IP for %s", server);
            if (g_dwErrorSleepTime != 0)
                Sleep(g_dwErrorSleepTime);
            g_Client[no].szFileName[0] = '\0';
	    return 0;
	}
    }
    else {
	pa = (DWORD *)hp->h_addr_list[0];
	ip.s_addr = *pa;
    }*/

    fp = fopen(g_Client[no].szFileName, "rb");
    if (fp == NULL) {
        WriteLog("Can't open %s", g_Client[no].szFileName);
        if (g_dwErrorSleepTime != 0)
            Sleep(g_dwErrorSleepTime);
        g_Client[no].szFileName[0] = '\0';
        return 0;
    }

    /*
	g_Client[no].s = socket(AF_INET, SOCK_STREAM, 0);
    if (g_Client[no].s == SOCKET_ERROR) {
        WriteLog(no, "Can't open TCP socket");
        fclose(fp);
        if (g_dwErrorSleepTime != 0)
            Sleep(g_dwErrorSleepTime);
        g_Client[no].szFileName[0] = '\0';
        return 0;
    }
	

    g_Client[no].tick = GetTickCount();
    g_Client[no].bCheck = TRUE;

    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = ip.s_addr;
    addr.sin_port = htons(port);

    if (connect(g_Client[no].s, (LPSOCKADDR)&addr, sizeof(addr)) != 0) {
        WriteLog(no, "Can't connect to %s:%d", server, port);
        g_Client[no].bCheck = FALSE;
        if (g_dwErrorSleepTime != 0)
            Sleep(g_dwErrorSleepTime);
        g_Client[no].szFileName[0] = '\0';
        fclose(fp);
	return 0;
    }

    if (GetLine(no, buf, 1024) == 0) {
        WriteLog(no, "Can't get response");
        g_Client[no].bCheck = FALSE;
        closesocket(g_Client[no].s);
        g_Client[no].s = SOCKET_ERROR;
        if (g_dwErrorSleepTime != 0)
            Sleep(g_dwErrorSleepTime);
        g_Client[no].szFileName[0] = '\0';
        fclose(fp);
        return 0;
    }
    if (memcmp(buf, "OK", 2) != 0) {
        WriteLog(no, "ERR: %s", buf);
        g_Client[no].bCheck = FALSE;
        closesocket(g_Client[no].s);
        g_Client[no].s = SOCKET_ERROR;
        if (g_dwErrorSleepTime != 0)
            Sleep(g_dwErrorSleepTime);
        g_Client[no].szFileName[0] = '\0';
        fclose(fp);
        return 0;
    }

    if (g_Client[no].nSeq == 0 || g_Client[no].nSeq == 1)
        sprintf(buf, "LAB,%s,%d,%d,%d\r\n", g_Client[no].szProg, g_Client[no].nSector,
                                     g_Client[no].nCup, g_Client[no].nSeq);
    else
        sprintf(buf, "LAB,%s,%d,%d,%d,%s\r\n", g_Client[no].szProg, g_Client[no].nSector,
                                     g_Client[no].nCup, g_Client[no].nSeq,
                                     g_Client[no].szNo);
    WriteLog(no, "CMD: %s", buf);
    if (PutLine(no, buf) == 0) {
        WriteLog(no, "ERR: %s", buf);
        g_Client[no].bCheck = FALSE;
        closesocket(g_Client[no].s);
        g_Client[no].s = SOCKET_ERROR;
        if (g_dwErrorSleepTime != 0)
            Sleep(g_dwErrorSleepTime);
        g_Client[no].szFileName[0] = '\0';
        fclose(fp);
	return 0;
    }
*/
    while (1) {
        if (fgets(str, 256, fp) == NULL) break;
		
		p = strtok(str, "|\n\r\0");

		if (p != NULL) {
			strcpy(test, p);
			p = strtok(NULL, "|\n\r\0");
		} else {
			continue;
		}

		if (p != NULL) {
			strcpy(result, p);
		} else {
			continue;
		}

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
	
		/*ret = SQLConnect(dbc, "seed", SQL_NTS,
			"lis", SQL_NTS,
			"laboratory", SQL_NTS);*/
		ret = SQLDriverConnect(
                dbc, 
                NULL, 
                (SQLCHAR*) server, 
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

		ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt); 
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
		}

// Bind Parameters
		ret = SQLBindParameter(stmt, 1, SQL_PARAM_INPUT,
			SQL_C_CHAR, SQL_CHAR, 0, 0,
			labno, sizeof(labno), &Length);
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
		}

		ret = SQLBindParameter(stmt, 2, SQL_PARAM_INPUT,
			SQL_C_CHAR, SQL_CHAR, 0, 0,
			seq, sizeof(seq), &Length);
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
		}

		ret = SQLBindParameter(stmt, 3, SQL_PARAM_INPUT,
			SQL_C_CHAR, SQL_CHAR, 0, 0,
			test, sizeof(test), &Length);
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
		}

		ret = SQLBindParameter(stmt, 4, SQL_PARAM_INPUT,
			SQL_C_CHAR, SQL_CHAR, 0, 0,
			result, sizeof(result), &Length);
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
		}

		ret = SQLBindParameter(stmt, 5, SQL_PARAM_INPUT,
			SQL_C_CHAR, SQL_CHAR, 0, 0,
			machine, sizeof(machine), &Length);
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
		}

		WriteLog("labno=%s seq=%s test=%s result=%s machine=%s", labno, seq, test, result, machine);

//Prepare SQL
		ret = SQLPrepare(stmt, SQL, SQL_NTS);
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
		}
// Execute statement with parameters
		ret = SQLExecute(stmt);
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
		}
		ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt);
        if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
				pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
		}
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
	}
	

	/*if (p == NULL) {
            WriteLog(no, "ERROR: %s", str);
            g_Client[no].bCheck = FALSE;
            closesocket(g_Client[no].s);
            g_Client[no].s = SOCKET_ERROR;
            if (g_dwErrorSleepTime != 0)
                Sleep(g_dwErrorSleepTime);
            g_Client[no].szFileName[0] = '\0';
            fclose(fp);
	    return 0;
	}

        sprintf(buf, "DATA,%s\r\n", p);
        if (PutLine(no, buf) == 0) {
            WriteLog(no, "DATA: %s", p);
            g_Client[no].bCheck = FALSE;
            closesocket(g_Client[no].s);
            g_Client[no].s = SOCKET_ERROR;
            if (g_dwErrorSleepTime != 0)
                Sleep(g_dwErrorSleepTime);
            g_Client[no].szFileName[0] = '\0';
            fclose(fp);
	    return 0;
	}
        if (GetLine(no, buf, 1024) == 0) {
            WriteLog(no, "Can't get response");
            g_Client[no].bCheck = FALSE;
            closesocket(g_Client[no].s);
            g_Client[no].s = SOCKET_ERROR;
            if (g_dwErrorSleepTime != 0)
                Sleep(g_dwErrorSleepTime);
            g_Client[no].szFileName[0] = '\0';
            fclose(fp);
            return 0;
        }
        if (memcmp(buf, "OK", 2) != 0) {
            WriteLog(no, "ERR: %s", buf);
            g_Client[no].bCheck = FALSE;
            closesocket(g_Client[no].s);
            g_Client[no].s = SOCKET_ERROR;
            if (g_dwErrorSleepTime != 0)
                Sleep(g_dwErrorSleepTime);
            g_Client[no].szFileName[0] = '\0';
            fclose(fp);
            return 0;
        }
    }

    sprintf(buf, "END\r\n");
    if (PutLine(no, buf) == 0) {
        WriteLog(no, "END");
        g_Client[no].bCheck = FALSE;
        closesocket(g_Client[no].s);
        g_Client[no].s = SOCKET_ERROR;
        if (g_dwErrorSleepTime != 0)
            Sleep(g_dwErrorSleepTime);
        g_Client[no].szFileName[0] = '\0';
        fclose(fp);
	return 0;
    }

    if (GetLine(no, buf, 1024) == 0) {
        WriteLog(no, "Can't get response");
        g_Client[no].bCheck = FALSE;
        closesocket(g_Client[no].s);
        g_Client[no].s = SOCKET_ERROR;
        if (g_dwErrorSleepTime != 0)
            Sleep(g_dwErrorSleepTime);
        g_Client[no].szFileName[0] = '\0';
        fclose(fp);
        return 0;
    }
    if (memcmp(buf, "OK", 2) != 0) {
        WriteLog(no, "ERR: %s", buf);
        g_Client[no].bCheck = FALSE;
        closesocket(g_Client[no].s);
        g_Client[no].s = SOCKET_ERROR;
        if (g_dwErrorSleepTime != 0)
            Sleep(g_dwErrorSleepTime);
        g_Client[no].szFileName[0] = '\0';
        fclose(fp);
        return 0;
    }
*/

    fclose(fp);
    if (g_Client[no].bCopyTest != 0 && g_Client[no].szTestDir[0] != '\0') {
        char drive[_MAX_DRIVE];
        char dir[_MAX_DIR];
        char fname[_MAX_FNAME];
        char ext[_MAX_EXT];

        _splitpath(g_Client[no].szFileName, drive, dir, fname, ext);
        _makepath(buf, "", g_Client[no].szTestDir, fname, ext);
        CopyFile(g_Client[no].szFileName, buf, FALSE);
        WriteLog("CopyFile %s to %s", g_Client[no].szFileName, buf);
    }
    if (g_bBackup) {
        time_t t;
        struct tm *tp;
        char szToday[200];

        time(&t);
        tp = localtime(&t);
        strftime(szToday, 200, "%y%m%d", tp);
        sprintf(buf, "%sBACKUP\\%s", g_szRootPath, szToday);
        CreateDirectory(buf, NULL);
        strftime(str, 200, "%H%M%S", tp);
        if (g_Client[no].nSeq == 2)
            sprintf(buf, "%sBACKUP\\%s\\%s.%s.%s.txt", g_szRootPath, szToday,
                                         str, g_Client[no].szProg,
                                         g_Client[no].szNo);
        else
            sprintf(buf, "%sBACKUP\\%s\\%s.%s.%04d-%04d.txt", g_szRootPath, szToday,
                                         str, g_Client[no].szProg,
                                         g_Client[no].nSector, g_Client[no].nCup);

        MoveFile(g_Client[no].szFileName, buf);
        WriteLog("MoveFile %s to %s", g_Client[no].szFileName, buf);
    }
	WriteLog("Delete FIle: %s", g_Client[no].szFileName);
    unlink(g_Client[no].szFileName);
    g_Client[no].bCheck = FALSE;
    //closesocket(g_Client[no].s);
    //g_Client[no].s = SOCKET_ERROR;
    g_Client[no].szFileName[0] = '\0';
	
_TRY_EXCEPTION_BLOCK_END(1)

    return 1;
}

