#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "MindrayEMR.h"

DWORD RecvThreadProc(LPVOID pParm)
{
    char	buf[1024];
    int		no;
/*
    char	fname[260];
    char	tmpfname[260];
	char	bakname[260];
*/
	char	client_message[2000];
    int		recv_size;
	//char	message[2000];
	int		i, j;
/*
	short	message_retry;

	WIN32_FIND_DATA data;
    HANDLE  hFind;
    char	path[260];
    BOOL	bFound;
	BOOL	bFirst;
*/
	BOOL	bLast;
	long refid;
/*
    time_t t;
    struct tm *tp;

	struct list *first;
	struct list *newnode;
	struct list *temp;

	struct list
	{
		char  name[260];
		struct list *next;
	};
*/

_TRY_EXCEPTION_BLOCK_BEGIN()

    no = (int)pParm;
	WriteLog("%d:Thread %d Create", no, g_client[no].dThreadID);
/*
	first = NULL;
	g_client[no].out = NULL;
*/
	while(1) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;

		if (g_client[no].s != SOCKET_ERROR) {
		
//get response
			while ((recv_size = recv(g_client[no].s, client_message, 2000, 0)) != SOCKET_ERROR) {

					if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
						break;

	  				client_message[recv_size] = '\0';

					if (g_bDebug)
						DumpErrorData(recv_size, client_message);

					if (recv_size == 0) {
						break;
					}

//capture special character
					if (recv_size == 1) {
						if (client_message[0] == ACK) {
							WriteLog("%d:%s RECV ACK", no, g_client[no].ip);
							break;
						} else if (client_message[0] == NAK) {
							WriteLog("%d:%s RECV NAK", no, g_client[no].ip);
							break;
						} 
					}

					for (i = 0; i < recv_size; i++){

						if (client_message[i] == VT) {
/*Change to db
							if (g_client[no].out == NULL) {
								sprintf(tmpfname, "%sEMR%d", g_szTempPath, no);
								g_client[no].out = fopen(tmpfname, "w");
								WriteLog("%d:Write to file: %s", no, tmpfname);
							}
*/
							j = 0;
						} else if (client_message[i] == CR) {
					
							if (buf[j - 1] == FS) {
								buf[j - 1] = '\0';
								bLast = 1;
							} else {
								buf[j] = '\0';
								bLast = 0;
							}
/*Change to db
							if (g_client[no].out == NULL) {
								WriteLog("%d:Cannot open file: %s", no, tmpfname);
							} else {
								WriteLog("%d:%s RECV: %s", no, g_client[no].ip, buf);
								sprintf(buf, "%s\n", buf);
								fwrite(buf, strlen(buf), sizeof(char), g_client[no].out);
							}

							if (bLast) {
								fclose(g_client[no].out);
								g_client[no].out = NULL;

								//Send ACK
								//sprintf(message, "%c\0", ACK);
								//SendLine(no, message);

								time(&t);
								tp = localtime(&t);

								if (tp != NULL) {

									sprintf(fname, "%sEMR_%s_%04d%02d%02d%02d%02d%02d", g_szOutBoxPath, g_client[no].ip, tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
										tp->tm_hour, tp->tm_min, tp->tm_sec);

								} else {

									sprintf(fname, "%sEMR_%s_%lx", g_szOutBoxPath, g_client[no].ip, GetTickCount());

								}

								MoveFile(tmpfname, fname);
								WriteLog("%d:Move from %s to %s", no, tmpfname, fname);
							}
*/
							if (strlen(buf) > 0 )
								refid = insert_msg(no, buf);

							j = 0;

						} else {
							buf[j] = client_message[i];
							j++;
						}

					}
			} 
/*
//Send
			if (first == NULL) {

				sprintf(path, "%sEMR_%s_*", g_szInBoxPath, g_client[no].ip);

				hFind = FindFirstFile(path, &data);
			    if (hFind != INVALID_HANDLE_VALUE) {
				    bFound = TRUE;
					while (bFound) {
						if (g_bQuit) break;

						if (data.cFileName[0] != '.' &&
						    (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0) {

//Create sorted list
							if (first == NULL) {
								first = (struct list*)malloc(sizeof(struct list));
								sprintf(first->name, "%s", data.cFileName);
								first->next = NULL;
							} else {
								newnode = (struct list*)malloc(sizeof(struct list));
								sprintf(newnode->name, "%s", data.cFileName);
								newnode->next = NULL;
		
								temp = first;
								while (temp->next != NULL) {
									if (atoi(newnode->name) < atoi(temp->next->name)) {
										newnode->next = temp->next;
										temp->next = newnode;
										break;
									}
									temp = temp->next;
								}

								if (newnode->next == NULL)
									temp->next = newnode;
							}
//
						}

						bFound = FindNextFile(hFind, &data);

					}
					FindClose(hFind);
				}

			} 
//
			message_retry = 0;
			if (first != NULL) {
				sprintf(fname, "%s%s", g_szInBoxPath, first->name);
				sprintf(bakname, "%s%s", g_szBackupInBoxPath, first->name);

				WriteLog("%d:Read file: %s", no, fname);
	
				g_client[no].in = fopen(fname, "rt");

				if (g_client[no].in == NULL) {

					WriteLog("Can't open file: %s", fname);
					first = first->next;

				} else {

					bFirst = 1;
					while (fgets(buf, 1024, g_client[no].in) != NULL) {

						if (bFirst)
							sprintf(message, "%c%s%c\0", VT, buf, CR);
						else
							sprintf(message, "%s%c\0", buf, CR);

						SendLine(no, message);

						bFirst = 0;
					}

//Send last terminate charachers			
					sprintf(message, "%c%c\0", FS, CR);
					SendLine(no, message);
					fclose(g_client[no].in);
					g_client[no].in = NULL;

					MoveFile(fname, bakname);
					WriteLog("%d:Backup inbox from %s to %s", no, fname, bakname);

					first = first->next;
				}
			}
*/
			if (bLast) {
				if (refid > 0)
					reply(refid, no);

				bLast = 0;
			}
		}
	}

	WriteLog("%d:Thread Exit", no);

    ExitThread(0);

_TRY_EXCEPTION_BLOCK_END(1)

    return 1;
}
