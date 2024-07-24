#include <stdio.h>
#include <string.h>
#include <time.h>
#include "smserver.h"

void GetData(int no, char *msg, char *fname)
{
    int nCount = 0;

//    char message[4096];
    char buf[1024];
	char tmpfname[260];
	char outfname[260];

//    int		recv_size;
	char	function;
	char	sid[12];
	char	DateTime[15];
	char	test[30];
	char	result[22];
    FILE	*out;
//    char	tmpbuf[260];
	char	*packet;
	char	*p;
	char	*q;
	char	flag[2];
	char	tmptest[30];
    char	token[260];
	char	comment[22];
	char	*end;
	char	sn[6];
	time_t	t;
	struct	tm *tp;
	double dResult;
	double dRate;

	function = msg[2];
	packet = msg;
	end = strchr(packet, CR);
	*end = '\0';
	DateTime[0] = '\0';

//Header
	if (function == 'H') {
		ParseDelimiter(packet, 5, '|', token);
		ParseDelimiter(token, 3, '^', sn);
		sprintf(fname, "%s\0", sn);
	}	

//sample information
	if (function == 'O') {
		ParseDelimiter(packet, 4, '|', token);
		ParseDelimiter(token, 3, '^', sid);
		TrimSpace(sid);
		strtok(sid, "\"* /:<>?\\|");
				
		time(&t);
		tp = localtime(&t);
		if (tp != NULL) {
			sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
				tp->tm_hour, tp->tm_min, tp->tm_sec);
		}

		if (sid[0] != '\0') {
			sprintf(fname, "%s\\%s_%s", fname, sid, DateTime);
		}
	}	

//Result
	if (function == 'R') {
		if (fname != NULL) {
			sprintf(tmpfname, "%s%s", g_szTempPath, fname);
			//sprintf(outfname, "%s%s\\%s_%s", g_szOutBoxPath, sn, sid, DateTime);
			WriteLog("Save to %s", tmpfname);
			out = fopen(tmpfname, "a");

			ParseDelimiter(packet, 3, '|', token);
			ParseDelimiter(token, 5, '^', tmptest);
			ParseDelimiter(packet, 4, '|', result);
			
			TrimSpace(tmptest);

			//flag
			flag[0] = '\0';
			ParseDelimiter(packet, 7, '|', flag);

			if (flag[0] == 'A') {
				q = strchr(tmptest, '?');

				if (q != NULL) {
					*q = '\0';
					sprintf(buf, "%s|FLAG\n", tmptest);
					WriteLog("Result: %s", buf);
						
					if (out == NULL) {
						WriteLog("Cannot open file: %s", tmpfname);
					} else {
						if (!(fwrite(buf, strlen(buf), sizeof(char), out)))
							WriteLog("Failed to write file %s : %s", fname, buf);
					}
				}

				if (strlen(result) == 0) {
					if (strncmp (tmptest,"ACTION_MESSAGE",14) != 0) {
						sprintf(buf, "%s|FLAG\n", tmptest);
						WriteLog("Result: %s", buf);
							
						if (out == NULL) {
							WriteLog("Cannot open file: %s", fname);
						} else {
							if (!(fwrite(buf, strlen(buf), sizeof(char), out)))
								WriteLog("Failed to write file %s : %s", fname, buf);
						}
					}
				}
			}

			//not writing unmatched tests
			if (ConvertCode(tmptest, test)) {
				TrimSpace(result);

				dRate = ConvertRate(test);
				dResult = atof(result) * dRate;
				sprintf(buf, "%s|%g\n", test, dResult);

				WriteLog("Result: %s", buf);
						
				if (out == NULL) {
					WriteLog("Cannot open file: %s", fname);
				} else {
					if (!(fwrite(buf, strlen(buf), sizeof(char), out)))
						WriteLog("Failed to write file %s : %s", fname, buf);
				}

			}

			if (out != NULL) {
				WriteLog("File closed: %s", fname);
				fclose(out);
				out = NULL;
			}

		}
	}

//Comment
	if (function == 'C') {

		if (fname != NULL) {
			sprintf(tmpfname, "%s%s", g_szTempPath, fname);
			//sprintf(outfname, "%s%s\\%s_%s", g_szOutBoxPath, sn, sid, DateTime);
			WriteLog("Save to %s", tmpfname);
			out = fopen(tmpfname, "a");

			p = strrchr(packet, '|');

			strcpy(comment, p);
			strtok(comment, "\\");
        
			q = strrchr(comment, '^');

			if (q != NULL) {

				if (strlen(q) > 1) {
					q++;
					sprintf(buf, "%s|FLAG\n", q);
					WriteLog("Result: %s", buf);
						
					if (out == NULL) {
						WriteLog("Cannot open file: %s", tmpfname);
					} else {
						if (!(fwrite(buf, strlen(buf), sizeof(char), out)))
							WriteLog("Failed to write file %s : %s", fname, buf);
					}
				}
			}

			while (*p != '\0') {
				p++;
				if (*p == '\\') {
					strcpy(comment, p);
					strtok(comment, "\\");
        
					q = strrchr(comment, '^');

					if (q != NULL) {

						if (strlen(q) > 1) {
							q++;
							sprintf(buf, "%s|FLAG\n", q);
							WriteLog("Result: %s", buf);
						
							if (out == NULL) {
								WriteLog("Cannot open file: %s", tmpfname);
							} else {
								if (!(fwrite(buf, strlen(buf), sizeof(char), out)))
									WriteLog("Failed to write file %s : %s", fname, buf);
							}
						}
					}
				}
			}	
/*

			q = strrchr(p, '^');

			if (q != NULL) {

				if (strlen(q) > 1) {
					q++;
					sprintf(buf, "%s|FLAG\n", q);
					WriteLog("Result: %s", buf);
						
					if (out == NULL) {
						WriteLog("Cannot open file: %s", tmpfname);
					} else {
						if (!(fwrite(buf, strlen(buf), sizeof(char), out)))
							WriteLog("Failed to write file %s : %s", fname, buf);
					}
				}
			}
*/
			if (out != NULL) {
				WriteLog("File closed: %s", fname);
				fclose(out);
				out = NULL;
			}

		}

	}

//Query
	if (function == 'Q') {

		ParseDelimiter(packet, 3, '|', token);
		ParseDelimiter(token, 3, '^', sid);
		TrimSpace(sid);
		strtok(sid, "\"* /:<>?\\|");
					
		SendFile(no, sid);

	}

	if (function == 'L') {
		sprintf(tmpfname, "%s%s", g_szTempPath, fname);
		sprintf(outfname, "%s%s", g_szOutBoxPath, fname);
		WriteLog("Moving file from %s to %s", tmpfname, outfname);
		CopyFile(tmpfname, outfname, FALSE);	
		DeleteFile(tmpfname);
	}
}