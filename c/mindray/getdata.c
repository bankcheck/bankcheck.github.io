#include <stdio.h>
#include <string.h>
#include <time.h>
#include "MINDRAY.h"

void GetData(CLIENT *c)
{
    int nCount = 0;

    char message[4096];
    char buf[1024];
	char fname[260];

	char	server_reply[2000];
    int		recv_size;
    FILE	*out;
	int		i, j;


	while(1) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;

		if ((recv_size = recv(c->s, server_reply, 2000, 0)) != SOCKET_ERROR) {
			
			if (recv_size == 0) {
				break;
			}

			for (i = 0; i < recv_size; i++){

				if (server_reply[i] == VT) {
					sprintf(fname, "%s%lx", g_szOutBoxPath, GetTickCount());
					out = fopen(fname, "a+");

					if (out == NULL) {
						WriteLog("Cannot open file: %s", fname);
					} else {
						fwrite(c->name, strlen(c->name), sizeof(char), out);
					}

					j = 0;
				} else if (server_reply[i] == CR) {
					
					if (buf[j - 1] == FS) {
						buf[j - 1] = '\0';
					} else {
						buf[j] = '\0';
					}

					if (out == NULL) {
						WriteLog("Cannot open file: %s", fname);
					} else {
						WriteLog("RECV %s: %s", c->name, server_reply);
						fwrite(buf, strlen(buf), sizeof(char), out);
					}

					if (buf[j - 1] == FS) {
						fclose(out);
					}

				} else {
					buf[j] = server_reply[i];
					j++;
				}

			}
//Send ACK
			sprintf(message, "%c\0", ACK);
			SendPacket(c, message);
			
		} else {

			if (g_dwSleep != 0)
				Sleep(g_dwSleep);
						
			disconnect(c);
			if (ConnectServer(c) == 1) {
				WriteLog ("Fail to connect server");
				break;
			}

		}
	}

}