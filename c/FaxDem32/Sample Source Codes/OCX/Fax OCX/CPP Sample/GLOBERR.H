/****************************************************************************/
/*            (c) Copyright Black Ice Software Inc.  1996.                  */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/*                                                                          */
/*                                                                          */
/****************************************************************************/


#ifndef __GLOBERR_H
#define __GLOBERR_H

#ifndef _FAXBASE_H
#include "faxbase.h"
#endif


FAXAPI void _export CALLBACK EnableFaxCPPDriverDebug(LPSTR lpErrorFile, BOOL bDebugWnd);


struct TSErrorTable
{
	int code;
	LPSTR txt;
};

class CFAXAPI TCGlobError
{        
public:
	TCGlobError();
	int        SetErrCode(int        code, LPSTR ErrStr, LPSTR fname, int nLine);
	TEFaxError SetErrCode(TEFaxError code, LPSTR ErrStr, LPSTR fname, int nLine);
	
	void StartFaxDriver();
	TCLog* ErrorLog ;	
	operator int ();

protected:
	int nError;
	static TSErrorTable errortab[];
	
	void MakeErrStr(int code, LPSTR ErrStr, LPSTR fname, int nLine, LPSTR buf, int blen);
public:
	void OutputStr(LPCSTR str);
};   

#endif	// __GLOBERR_H


