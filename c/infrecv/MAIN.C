#include <stdio.h>
#include <time.h>
#include "infrecv.h"

int MainProc(void)
{
    int 	    nCount = 0;

    char message[4096];

	char	server_reply[2000];
    int		recv_size;

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
			
			if (server_reply[0] == ENQ) {
				WriteLog("RECV ENQ");

				sprintf(message, "%c\0", ACK);

				if (SendLine(&g_Client, message) != 0)
					continue;

				GetData();
			} else {
				WriteLog("RECV (expecting ENQ): %s", server_reply);
			}

			continue;
		} else {
			disconnect(&g_Client);
		}
    }

    return 0;
}

