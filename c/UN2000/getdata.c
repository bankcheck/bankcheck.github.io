#include <stdio.h>
#include <string.h>
#include <time.h>
#include "UN2000.h"

void GetData(int no, char *msg, char *fname)
{
    int nCount = 0;

    char buf[1024];
	char tmpfname[260];
	char outfname[260];

	char	function;
	char	sid[12];
	char	DateTime[15];
	char	test[30];
	char	result[22];
	char	instrument[12];
    FILE	*out;
	char	*packet;
	char	tmptest[30];
    char	token[260];
    char	fmt[10];
//	char	tmpdir[260];
	char	*end;

	double  dResult;
	double	dRate;
	int		dec;

	time_t	t;
	struct	tm *tp;

	function = msg[2];
	packet = msg;
	end = strchr(packet, CR);
	*end = '\0';
	DateTime[0] = '\0';

//Order information
	if (function == 'O') {

		ParseDelimiter(packet, 3, '|', sid);
		TrimSpace(sid);
		strtok(sid, "\"* /:<>?\\|");
				
		time(&t);
		tp = localtime(&t);
		if (tp != NULL) {
			sprintf(DateTime, "%04d%02d%02d%02d%02d%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday,
				tp->tm_hour, tp->tm_min, tp->tm_sec);
		}

		if (sid[0] != '\0') {
			sprintf(fname, "%s_%s", sid, DateTime);
		}
	}	

//Result
	if (function == 'R') {
		if (fname != NULL) {

			ParseDelimiter(packet, 3, '|', token);
			ParseDelimiter(token, 4, '^', tmptest);
			ParseDelimiter(packet, 4, '|', token);
			ParseDelimiter(token, 1, '^', result);
			ParseDelimiter(token, 2, '^', fmt);
			ParseDelimiter(packet, 14, '|', instrument);

			if (isResult(fmt, instrument)) {
/*
For separate modules
				sprintf(tmpdir, "%s%s", g_szTempPath, instrument);
				CreateDirectory(tmpdir, NULL);
				sprintf(tmpfname, "%s\\%s", tmpdir, fname);
*/				
				TrimSpace(tmptest);

				ConvertCode(tmptest, test);

				TrimSpace(result);

				dRate = ConvertRate(test);
				dec	= getDecimal(test);

				if (isNumber(result) && (dRate != 1)) {

					dResult = atof(result) * dRate;
					if (dec < 0) 
						sprintf(buf, "%s|%f\n", test, dResult);
					else											
						sprintf(buf, "%s|%.*f\n", test, dec, dResult);

				} else {
					sprintf(buf, "%s|%s\n", test, result);
				}

				if (isNumber(result) && g_bSkipZeroResult) {
					dResult = atof(result);
					if (dResult == 0) {
						WriteLog("Skip result: %s", buf);
						return;
					}
				}

				sprintf(tmpfname, "%s%s", g_szTempPath, fname);
				WriteLog("Save to %s", tmpfname);
				out = fopen(tmpfname, "a");
						
				if (out == NULL) {
					WriteLog("Cannot open file: %s", fname);
				} else {
					WriteLog("Result: %s", buf);
					if (!(fwrite(buf, strlen(buf), sizeof(char), out)))
						WriteLog("Failed to write file %s : %s", fname, buf);
				}

				if (out != NULL) {
					fclose(out);
					out = NULL;
				}
			}
		}
	}

	if (function == 'L') {
/*
For separate modules
		MoveFolder();	
*/
		if (fname != NULL) {
			sprintf(tmpfname, "%s%s", g_szTempPath, fname);
			sprintf(outfname, "%s%s", g_szOutBoxPath, fname);
			WriteLog("Moving file from %s to %s", tmpfname, outfname);
			MoveFile(tmpfname, outfname);							
		}
	}
}

void MoveFolder(void)
{
    WIN32_FIND_DATA data, data2;
    BOOL bFound, bFound2;
    HANDLE hFind, hFind2;

	char subfolder[260];
	char srcPath1[260];
	char srcPath2[260];
	char in[260];
	char out[260];
	char outdir[260];	
	char tmpfname[260];
	char outfname[260];

    sprintf(in, "%s", g_szTempPath);
    sprintf(out, "%s", g_szOutBoxPath);
    sprintf(srcPath1, "%s*", in);

    hFind = FindFirstFile(srcPath1, &data);

    if (hFind != INVALID_HANDLE_VALUE) {
        bFound = TRUE;

        while (bFound) {
			if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
				break;

            if (data.cFileName[0] != '.' &&
				(data.dwFileAttributes == FILE_ATTRIBUTE_DIRECTORY)) {
			
                sprintf(subfolder, "%s%s\\", in, data.cFileName);
                sprintf(srcPath2, "%s*", subfolder);
				
				sprintf(outdir, "%s%s\\", out, data.cFileName);
				CreateDirectory(outdir, NULL);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				hFind2 = FindFirstFile(srcPath2, &data2);

				if (hFind2 != INVALID_HANDLE_VALUE) {
					bFound2 = TRUE;

					while (bFound2) {
						if (g_bQuit || WaitForSingleObject(g_hServerStopEvent, g_dwSleep) == WAIT_OBJECT_0)
							break;

						if (data2.cFileName[0] != '.' &&
							(data2.dwFileAttributes != FILE_ATTRIBUTE_DIRECTORY)) {
						
							sprintf(tmpfname, "%s%s", subfolder, data2.cFileName);
							sprintf(outfname, "%s%s", outdir, data2.cFileName);
							WriteLog("Moving file from %s to %s", tmpfname, outfname);
							MoveFile(tmpfname, outfname);							
						}

						bFound2 = FindNextFile(hFind2, &data2);
					}
					FindClose(hFind2);
				}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
			}

			bFound = FindNextFile(hFind, &data);
        }
        FindClose(hFind);
    }

}