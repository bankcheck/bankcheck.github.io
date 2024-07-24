#include <stdio.h>
#include <string.h>
#include <time.h>
#include <direct.h>
#include "alinity.h"

void GetData(int no, char *msg, char *fname)
{
    int nCount = 0;

    char buf[1024];
	char tmpfname[260];
	char outfname[260];

	char	function;	
	char	sn[12];
	char	sid[12];
	char	DateTime[15];
	char	test[30];
	char	result[22];
    FILE	*out;
	char	*packet;
	char	*p;
	char	tmptest[30];
    char	token[260];
	char	*end;
	char	resultType;
	time_t	t;
	struct	tm *tp;
	double dResult;
	double dRate;
	int i;

	function = msg[2];
	packet = msg;
	end = strchr(packet, CR);
	*end = '\0';
	DateTime[0] = '\0';

//Header
	if (function == 'H') {
		ParseDelimiter(packet, 5, '|', token);
		ParseDelimiter(token, 3, '^', sn);
		sprintf(fname, "%s\\\0", sn);
		
		sprintf(tmpfname, "%s%s\0", g_szTempPath, sn);
		_mkdir(tmpfname);

		sprintf(outfname, "%s%s\0", g_szOutBoxPath, sn);
		_mkdir(outfname);
	}	

//sample information
	if (function == 'O') {
		ParseDelimiter(packet, 3, '|', sid);
		TrimSpace(sid);
		strtok(sid, "\"*/:<>?\\|");
				
		time(&t);
		tp = localtime(&t);
		if (tp != NULL) {
			sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
				tp->tm_hour, tp->tm_min, tp->tm_sec);
		}

		if (sid[0] != '\0') {
			sprintf(fname, "%s%s_%s", fname, sid, DateTime);
		}
	}	

//Result
	if (function == 'R') {
		if (fname != NULL) {
			sprintf(tmpfname, "%s%s", g_szTempPath, fname);
			//sprintf(outfname, "%s%s\\%s_%s", g_szOutBoxPath, sn, sid, DateTime);

			ParseDelimiter(packet, 3, '|', token);
			ParseDelimiter(token, 4, '^', tmptest);

			i = strlen(token) - 1;
			if (i > 0)
				resultType = token[i];

			if (resultType == 'F') {
				WriteLog("Save to %s", tmpfname);
				out = fopen(tmpfname, "a");

				ParseDelimiter(packet, 4, '|', result);
				
				TrimSpace(tmptest);

				ConvertCode(tmptest, test);
			
				TrimSpace(result);

				dRate = ConvertRate(test);
				if (dRate == 1) {
					sprintf(buf, "%s|%s\n", test, result);
					WriteLog("Result: %s", buf);
				} else {
					RemoveSign(result);
					dResult = atof(result) * dRate;
					sprintf(buf, "%s|%g\n", test, dResult);
					WriteLog("Result: %s", buf);
				} 
						
				if (out == NULL) {
					WriteLog("Cannot open file: %s", fname);
				} else {
					if (!(fwrite(buf, strlen(buf), sizeof(char), out)))
						WriteLog("Failed to write file %s : %s", fname, buf);
				}

				if (out != NULL) {
					WriteLog("File closed: %s", fname);
					fclose(out);
					out = NULL;
				}
			}

		}
	}

//Query
	if (function == 'Q') {

//2Q|1|^23111790A||^^^ALL||||||||O		
		ParseDelimiter(packet, 3, '|', token);
		//ParseDelimiter(token, 3, '^', sid);
		p = strrchr(token, '^');
		strcpy(sid, ++p);

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