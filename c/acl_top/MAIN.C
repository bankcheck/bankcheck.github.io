#include <stdio.h>
#include <time.h>
#include "acl_top.h"

int MainProc(void)
{
    int 	    nCount = 0;

    char message[4096];

	char	server_reply[2000];
    int		recv_size;
	int		i;

    while (1) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;
		
		if (!g_Client.connected) {
			if (ConnectServer(&g_Client) == 1) {
				if (g_dwSleep != 0)
					Sleep(g_dwSleep);

				continue;
			}
		}

//get response
		recv_size = recv(g_Client.s, server_reply, 2000, 0);
		if (recv_size > 0) {

			server_reply[recv_size] = '\0';

			for (i=0; i<recv_size; i++) {
				if (server_reply[i] == ENQ) {
					WriteLog("RECV ENQ");

					sprintf(message, "%c\0", ACK);
					SendLine(&g_Client, message);
					GetData();
					break;
				}
			}

			if (i == recv_size) {
				WriteLog("RECV (expecting ENQ): %c", server_reply);

				if (g_bDebug)
					DumpErrorData(recv_size, server_reply);
			}
			
			SendData();

		} else {
			disconnect(&g_Client);
		}
    }

    return 0;
}

