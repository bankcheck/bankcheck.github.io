#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "alin2.h"

DWORD RecvThreadProc(LPVOID pParm)
{
    char	buf[1024];
//    char *p;
    int		no;
    FILE	*fp;
    char	fname[260];
//	char	bakname[260];
//    char prog[60], sid[60];
	char	client_message[2000];
    int		recv_size;
//	int		retry;
	int		frame;
	char	databuf[1033];
	char	packet[1033];
//	int		err;
//	DWORD	threadID;
//	char	fname[36];

_TRY_EXCEPTION_BLOCK_BEGIN()

    no = (int)pParm;
	WriteLog("Thread %d created, thread ID=%d", no, g_client[no].dThreadID);

	while(1) {
		if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
			break;

		if (g_client[no].s != SOCKET_ERROR) {
		
//get response
			if ((recv_size = recv(g_client[no].s, client_message, 2000, 0)) != SOCKET_ERROR) {
				client_message[recv_size] = '\0';
			
				WriteLog("%d: message received thread ID=%d, ip=%s", no, g_client[no].dThreadID, g_client[no].ip);

				if (client_message[0] == ENQ) {
					WriteLog("%d:%s RECV ENQ", no, g_client[no].ip);

					sprintf(buf, "%c\0", ACK);
					SendLine(no, buf);

					while(1) {
						if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
							break;

						if ((recv_size = recv(g_client[no].s, client_message, 2000, 0)) != SOCKET_ERROR) {
							if (g_bDebug)
								DumpErrorData(strlen(client_message), client_message);

							if (client_message[0] == EOT) {
								WriteLog("%d:%s RECV EOT", no, g_client[no].ip);

								if (client_message[1] == ENQ) {
									WriteLog("%d:%s RECV ENQ", no, g_client[no].ip);
					
							//Send ACK
									sprintf(buf, "%c\0", ACK);
									SendLine(no, buf);
									continue;
								} else
									break;
							}

							if (client_message[0] == ENQ) {
								WriteLog("%d:%s RECV ENQ (within session)", no, g_client[no].ip);
					
							//Send ACK
								sprintf(buf, "%c\0", ACK);
								SendLine(no, buf);
								continue;
							}

							client_message[recv_size] = '\0';

							WriteLog("%d:%s RECV: %s", no, g_client[no].ip, client_message);
//Send ACK
							sprintf(buf, "%c\0", ACK);
							SendLine(no, buf);
	
							GetData(no, client_message, fname);
						} else {
							WriteLog("%d:%s RECV ERROR", no, g_client[no].ip);
						}

					}

				} else {
					WriteLog("%d:%s RECV (expecting ENQ): %s", no, g_client[no].ip, client_message);
					DumpErrorData(strlen(client_message), client_message);
				}
								
				continue;
			} 

//Open buffer file
			sprintf(fname, "%sbuf%d.dat", g_szTempPath, no);
			fp = fopen(fname, "rt");
			if (fp != NULL) {
				WriteLog("%d:Open: %s", no, fname);

//Send ENQ
				sprintf(packet, "%c\0", ENQ);
				SendLine(no, packet);
		
				if (g_client[no].s == SOCKET_ERROR)
					break;

				if ((recv_size = recv(g_client[no].s, client_message, 2000, 0)) != SOCKET_ERROR) {
					client_message[recv_size] = '\0';

					if (client_message[0] == ACK) {
						WriteLog("%d:%s RECV ACK", no, g_client[no].ip);

						frame = 1;
						while (fgets(buf, 1024, fp) != NULL) {

							if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
								break;

							buf[strlen(buf)-1] = CR;
							buf[strlen(buf)] = '\0';

							sprintf(databuf, "%d%s%c\0", frame, buf, ETX);

							sprintf(packet, "%c%s%02X%c%c\0", STX, databuf, GetCheckSum(databuf), CR, LF);

							if (SendPacket(no, packet) == 0)
								break;
							
							frame++;

							if (frame >= 8)
								frame = 0;
						}
		
//Send EOT
						sprintf(packet, "%c\0", EOT);
						SendLine(no, packet);

						fclose(fp);
						WriteLog("%d:Close file: %s", no, fname);
						DeleteFile(fname);
						WriteLog("%d:Delete: %s", no, fname);

					} else if (client_message[0] == NAK)
						WriteLog("%d:%s RECV NAK", no, g_client[no].ip);
					else
						WriteLog("%d:%s RECV: %s", no, g_client[no].ip, client_message);

				}
			}
		}
	}
	WriteLog("%d: Thread Exit", no);
    ExitThread(0);

_TRY_EXCEPTION_BLOCK_END(1)

    return 1;
}
