#include <stdio.h>
#include <time.h>
#include "OMNICELL.h"

struct list
{
	char  name[260];
	struct list *next;
};

int MainProc(void)
{
    WIN32_FIND_DATA data;
    HANDLE hFind;
    char path[260];
    BOOL bFound;

	struct list *first;
	struct list *newnode;
	struct list *temp;
	char name[260];

    int 	    nCount = 0;

    FILE *fp;
    char message[4096];
    char buf[1024];
	char event[4];
	char fname[260];
	char bakname[260];
	char tmpname[260];

	CLIENT	*c;
	char	server_reply[2000];
    int		recv_size;
	short	retry;
	short	message_retry;
	BOOL	bSuccess;
	BOOL	bFirst;
	char	ADT[4] = "ADT\0";
	char	RXF[4] = "RXF\0";
	char	RXP[4] = "RXP\0";
	char	message_type[4];
	char	message_id[20];

    while (1) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;
		
		first = NULL;

		sprintf(path, "%s*", g_szInBoxPath);
        hFind = FindFirstFile(path, &data);
        if (hFind != INVALID_HANDLE_VALUE) {
            bFound = TRUE;
            while (bFound) {
                if (g_bQuit) break;

                if (data.cFileName[0] != '.' &&
                        (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) == 0) {

//Create sorted list
					sprintf(name, "%s", data.cFileName);

					if (first == NULL) {
						first = (struct list*)malloc(sizeof(struct list));
						sprintf(first->name, "%s", name);
						first->next = NULL;
					} else {
						newnode = (struct list*)malloc(sizeof(struct list));
						sprintf(newnode->name, "%s", name);
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

		message_retry = 0;
		while (first != NULL) {
			if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
				break;

			sprintf(fname, "%s%s", g_szInBoxPath, first->name);
			WriteLog("Read file: %s", fname);

			fp = fopen(fname, "rt");
			if (fp == NULL) {
				WriteLog("Can't open file: %s", fname);
				first = first->next;
				continue;
			}

			if (fgets(buf, 1024, fp) == NULL){
				WriteLog("File is empty. Backup message file", fname);
				fclose(fp);
				CopyFile(fname, bakname, FALSE);
				DeleteFile(fname);
				first = first->next;
				continue;
			}

			strcpy(event, buf);
			if (strncmp(event, ADT, 3) == 0) {
				c = &g_ADT;
			} else if (strncmp(event, RXF, 3) == 0) {
				c = &g_RXF;
			} else if(strncmp(event, RXP, 3) == 0) {
				c = &g_RXP;
			} else {
				WriteLog("Unsupported event: %s, backup message file", event);
				fclose(fp);
				CopyFile(fname, bakname, FALSE);
				DeleteFile(fname);
				first = first->next;
				continue;
			}

			bFirst = 1;
			while (fgets(buf, 1024, fp) != NULL) {
				if (bFirst)
					sprintf(message, "%c%s%c\0", VT, buf, CR);
				else
					sprintf(message, "%s%c\0", buf, CR);

				retry = 0;
				while (retry < g_nMaxRetry) {
					if (SendPacket(c, message) == 0)
						break;
			
					if (g_dwSleep != 0)
						Sleep(g_dwSleep);

					retry++;
				}

				bFirst = 0;
			}
			
			sprintf(message, "%c%c\0", FS, CR);
			retry = 0;
			while (retry < g_nMaxRetry) {
				if (SendPacket(c, message) == 0)
					break;
			
				if (g_dwSleep != 0)
					Sleep(g_dwSleep);

				retry++;
			}

			fclose(fp);

//get response
			bSuccess = 0;
			retry = 0;
			while (retry < g_nMaxRetry) {
				if ((recv_size = recv(c->s, server_reply, 2000, 0)) != SOCKET_ERROR) {

					if (recv_size == 0) {
						WriteLog("RECV empty message!");
						disconnect(c);
						break;
					}

					server_reply[recv_size] = '\0';

					WriteLog("RECV %s: %s", c->name, server_reply);

					bSuccess = 1;
					break;
				} else {
					WriteLog("RECV failed");
				}

				if (g_dwSleep != 0)
					Sleep(g_dwSleep);

				retry++;
			}

//Backup and remove message file
			if (bSuccess || (message_retry >= g_nMaxRetry)) {

				message_type[0] = '\0';

				ParseDelimiter(server_reply, 9, '|', message_type);

				if (strcmp(message_type, "ACK") == 0) {
					ParseDelimiter(server_reply, 10, '|', message_id);
					
					sprintf(tmpname, "%s%s", g_szInBoxPath, message_id);
					sprintf(bakname, "%s%s", g_szBackupInBoxPath, message_id);

					CopyFile(tmpname, bakname, FALSE);
					DeleteFile(fname);
				}

				message_retry = 0;
				first = first->next;

			} else {
				if (g_dwSleep != 0)
					Sleep(g_dwSleep);

				disconnect(c);
				WriteLog("Resend message");
				message_retry++;

			}
		}
    }

    return 0;
}

