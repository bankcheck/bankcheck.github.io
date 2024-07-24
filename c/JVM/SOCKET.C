#include <stdio.h>
#include "JVM.h"

int ConnectServer(CLIENT *c){
	struct sockaddr_in server;
//init
    c->s = socket(AF_INET, SOCK_STREAM, 0);
    if (c->s == SOCKET_ERROR) {
        WriteLog("Cannot initiate socket");
        
		if (g_dwSleep != 0)
            Sleep(g_dwSleep);
		
		disconnect(c);
		return 1;
    }
	WriteLog("Socket initiated");

//connect
	WriteLog("Connecting %s:%d", c->ip, c->port);

    server.sin_addr.s_addr = inet_addr(c->ip);
    server.sin_family = AF_INET;
    server.sin_port = htons( c->port );

    if (connect(c->s , (struct sockaddr *)&server , sizeof(server)) == SOCKET_ERROR) {
		WriteLog("Socket Error");
		closesocket(c->s);
		c->connected = FALSE;
        return 1;
	}

	setsockopt(c->s, SOL_SOCKET, SO_RCVTIMEO, (char *)&g_timeout, sizeof(int)); //setting the receive timeout

	WriteLog("Socket connected");
	c->connected = TRUE;
    return 0;
}

void disconnect(CLIENT *c) {
	closesocket(c->s);
	c->connected = FALSE;
	WriteLog("Socket disconnected");
}

int SendLine(CLIENT *c, char *buf) {
	char	message[10000];
	int		retry;

	strcpy(message, buf);
				
	retry = 0;
	while (retry < g_nMaxRetry) {

		if (!c->connected) {
			if (ConnectServer(c) == 1) {
				WriteLog ("Fail to connect server");
				return 1;
			}
		}

		if( send(c->s , message , strlen(message) , 0) < 0)	{
			WriteLog ("SEND failed: %s", message);
			disconnect(c);
			
			if (g_dwSleep != 0)
				Sleep(g_dwSleep);

		} else {
			if (strlen(message) == 1) {
				if (*message == ENQ)
					WriteLog ("SEND ENQ");
				else if (*message == ACK)
					WriteLog ("SEND ACK");
				else if (*message == NAK)
					WriteLog ("SEND NAK");
				else if (*message == EOT)
					WriteLog ("SEND EOT");
				else
					WriteLog ("SEND: %s", message);
			} else
				WriteLog ("SEND: %s", message);
			return 0;
		}
		
		
		retry++;
	}

	return 1;
};
