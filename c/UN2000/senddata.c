#include <stdio.h>
#include <string.h>
#include <time.h>
#include "UN2000.h"

unsigned char GetCheckSum(char *buf)
{
    unsigned char chksum;

    chksum = 0;
    while (1) {
        if (*buf == '\0') break;
        chksum += *buf;
        buf++;
    }
    return chksum;
}

int SendPacket(int no, char *packet)
{
	int		retry;
	char	client_reply[2000];
    int		recv_size;

	for (retry = 0; retry < g_nMaxRetry; retry++) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;

		SendLine(no, packet);

		if ((recv_size = recv(g_client[no].s, client_reply, 2000, 0)) != SOCKET_ERROR) {
			client_reply[recv_size] = '\0';

			if (client_reply[0] == ACK) {
				WriteLog("%d:%s RECV ACK", no, g_client[no].ip);
				return 1;
			} else if (client_reply[0] == NAK) {
				WriteLog("%d:%s RECV NAK", no, g_client[no].ip);
			} else {
				WriteLog("%d:%s RECV: %s", no, g_client[no].ip, client_reply);
			}
		}

		if (g_dwSleep != 0)
			Sleep(g_dwSleep);
	}
	return 0;
}
