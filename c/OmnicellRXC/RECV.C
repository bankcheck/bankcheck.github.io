#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "OmnicellRXC.h"

DWORD RecvThreadProc(LPVOID pParm)
{
    char	buf[1024];
    int		no;
	char	client_message[2000];
    int		recv_size;
	int		i, j;
	BOOL	bLast;
	long refid;

_TRY_EXCEPTION_BLOCK_BEGIN()

    no = (int)pParm;
	WriteLog("%d:Thread %d Create", no, g_client[no].dThreadID);

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

					for (i = 0; i < recv_size; i++){

						if (client_message[i] == VT) {
							j = 0;
						} else if (client_message[i] == CR) {
					
							if (buf[j - 1] == FS) {
								buf[j - 1] = '\0';
								bLast = 1;
							} else {
								buf[j] = '\0';
								bLast = 0;
							}

							if (strlen(buf) > 0 )
								refid = insert_msg(no, buf);

							j = 0;

						} else {
							buf[j] = client_message[i];
							j++;
						}

					}
			} 

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
