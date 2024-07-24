#include <stdio.h>
#include <time.h>
#include "JVM.h"

int MainProc(void)
{
    int 	nCount = 0;

	char	server_reply[2000];
    int		recv_size;
	int		i, j;
	char	message[4000];
	long	refid;

	memset(message, '\0', 4000);
	j = 0;
	refid = 0;

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

//get data
		recv_size = recv(g_Client.s, server_reply, 2000, 0);

		if (recv_size > 0) {

			if (g_bDebug)
				DumpErrorData(recv_size, server_reply);

			server_reply[recv_size] = '\0';

			for (i=0; i<recv_size; i++) {
				if (server_reply[i] == VT) {
					memset(message, '\0', 4000);
					j = 0;
					refid = 0;

				} else if (server_reply[i] == CR) {
					if (strlen(message) > 0 ) {
					    //WriteLog("RECV: %s", message);
						refid = insert_msg(message);
						memset(message, '\0', 4000);
						j = 0;
					}
					
				} else if (server_reply[i] == FS) {

					if (g_bDebug) {
						Sleep(g_dwSleep);
						WriteLog("REFID: %d", refid);
					}

					if (refid != 0)
						response(refid);

					break;
					
				} else 
					message[j++] = server_reply[i];
				
			}

		} else {
			disconnect(&g_Client);
		}
    }

    return 0;
}

