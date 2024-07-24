#include <stdio.h>
#include <string.h>
#include <time.h>
#include "UN2000_order.h"

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

int WriteBuffer(int no, char *seq, char *sid)
{
    char buf[1024];
    FILE *in, *out;
	char fname[260];
    char packet[2048];
	char DateTime[15];
	char name[40];
	char hospno[10];
	char sex;
	char priority;
	char *p;
	char bakname[260];
	char *filename;
	time_t t;
    struct tm *tp;
	char	birth_date[9];
	char OutFile[260];

	time(&t);
	tp = localtime(&t);
	if (tp != NULL) {
		sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
			tp->tm_hour, tp->tm_min, tp->tm_sec);
	}

	sprintf(OutFile, "%sbuf%d.dat", g_szTempPath, no);
	out = fopen(OutFile, "a+");

	if (out == NULL) {
		WriteLog("Cannot open file: %s", OutFile);		
        return 0;

	} else {

		priority = 'R';

		sprintf(fname, "%s%s", g_szInBoxPath, sid);

		in = fopen(fname, "rt");
		if (in != NULL) {
			if (fgets(buf, 1024, in) != NULL){
				WriteLog("DATA: %s", buf);

				ParseDelimiter(buf, 1, '|', name);
				p = strchr(name, ',');
				*p = '^';

				ParseDelimiter(buf, 3, '|', hospno);

				ParseDelimiter(buf, 4, '|', &sex);

				ParseDelimiter(buf, 7, '|', birth_date);

				priority=*(strrchr(buf, '|')+1);

				sprintf(packet, "P|%s||%s||%s^^\\^^^^||%s|%c||||||||||||||||\n\0", seq, hospno, name, birth_date, sex);

				fwrite(packet, strlen(packet), sizeof(char), out);
				WriteLog("Write file %s: %s", OutFile, packet);

			} else {
				WriteLog("Can't open file: %s", fname);
			    sprintf(packet, "P|%s||||^^^\\^^^^|||U||||||||||||||||\n\0", seq);
				fwrite(packet, strlen(packet), sizeof(char), out);
				WriteLog("Write file %s: %s", OutFile, packet);
			}

			WriteLog("Close file: %s", fname);
			fclose(in);
		} else {
			WriteLog("Can't open file: %s", fname);
			sprintf(packet, "P|%s||||^^^\\^^^^|||U||||||||||||||||\n\0", seq);
			fwrite(packet, strlen(packet), sizeof(char), out);
			WriteLog("Write file %s: %s", OutFile, packet);
		}

//		sprintf(packet, "O|1|%s||^^^RBC\\^^^NL RBC\\^^^EC\\^^^Squa.EC\\^^^Non SEC\\^^^Tran.EC\\^^^RTEC\\^^^CAST\\^^^Hy.CAST\\^^^Path.CAST\\^^^BACT\\^^^X'TAL\\^^^YLC\\^^^SPERM\\^^^MUCUS\\^^^WBC\\^^^WBC Clumps\\^^^RBC-Info.\\^^^UTI-Info.\\^^^BACT-Info.\\^^^SF_DSS_PxSF_FSC_P\\^^^HIST_SF_FSC_P\\^^^CW_SSH_AxCW_FSC_W\\^^^CW_FLL_AxCW_FSC_W\\^^^CB_FLH_PxCB_FSC_P\\^^^SF_FLL_WxSF_FLL_A\\^^^CW_FLH_PxCW_FSC_P\\^^^CW_SSH_PxCW_FLL_P\\^^^HIST_CW_SSH_P\\^^^C-URO\\^^^C-BLD\\^^^C-BIL\\^^^C-KET\\^^^C-GLU\\^^^C-PRO\\^^^C-PH\\^^^C-NIT\\^^^C-LEU\\^^^C-S.G.(Ref)\\^^^C-COLOR\\^^^C-CLOUD\\|%c||%s||||N|||||^^^^^|||||||||O||^^|||^",
//		sprintf(packet, "O|1|%s||^^^URO\\^^^BLD\\^^^BIL\\^^^KET\\^^^GLU\\^^^PRO\\^^^PH\\^^^NIT\\^^^LEU\\^^^S.G.(Ref)\\^^^COLOR\\^^^ColorRANK\\^^^CLOUD\\^^^RBC\\^^^WBC\\^^^WBC Clumps\\^^^EC\\^^^Squa.EC\\^^^Non SEC\\^^^CAST\\^^^Hy.CAST\\^^^Path.CAST\\^^^BACT\\^^^X'TAL\\^^^YLC\\^^^SPERM\\^^^MUCUS\\|%c||%s||||N|||||^^^^^|||||||||O||^^|||^",
		sprintf(packet, "O|1|%s||^^^URO\\^^^BLD\\^^^BIL\\^^^KET\\^^^GLU\\^^^PRO\\^^^PH\\^^^NIT\\^^^LEU\\^^^S.G.(Ref)\\^^^COLOR\\^^^CLOUD\\^^^RBC\\^^^WBC\\^^^WBC Clumps\\^^^EC\\^^^Squa.EC\\^^^Non SEC\\^^^CAST\\^^^Hy.CAST\\^^^Path.CAST\\^^^BACT\\^^^X'TAL\\^^^YLC\\^^^SPERM\\^^^MUCUS\\|%c||%s||||N|||||^^^^^|||||||||O||^^|||^",
			sid, priority, DateTime);

		fwrite(packet, strlen(packet), sizeof(char), out);
		WriteLog("Write file %s: %s", OutFile, packet);
	}

	WriteLog("Close file: %s", OutFile);
	fclose(out);

	if (g_bBackupInbox) {
		filename = strrchr(fname, '\\');
		filename++;
			
		sprintf(bakname, "%s%s\0", g_szBackupInBoxPath, filename);

		WriteLog("Moving file from %s to %s", fname, bakname);
		CopyFile(fname, bakname, FALSE);

		DeleteFile(fname);
	}

	return 1;
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