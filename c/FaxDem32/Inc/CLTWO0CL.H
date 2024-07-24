/****************************************************************************/
/*            (c) Copyright Black Ice Software Inc.  1994.                  */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/*                                                                          */
/*                                                                          */
/****************************************************************************/

#ifndef  __cplusplus
    #error  "This inlude file must use with C++ compiler!"
#endif  // __cplusplus

#ifndef __CLTWO0CL_H
#define __CLTWO0CL_H

//****************************************************************************
// Include
#include "commcl.h"



//****************************************************************************
class CFAXAPI TCCommClassTwoZero : public TCCommPure
{
public:
    static PORTFAX CALLBACK CreateTCCommClass (LPSTR FaxShortName, LPSTR FileName);
    
    EXPDEF TCCommClassTwoZero (LPSTR FaxName, LPSTR FileName); 
    EXPDEF TCCommClassTwoZero ();
    virtual EXPDEF ~TCCommClassTwoZero();
			    
private:



protected:    

	TMControl*  mcInitialSetup();
	TMControl*  mcAnswer() ;
	TMControl*  mcSendFax();
	TMControl*  mcWait();
	TMControl*  mcTerminate();
	TMControl*  mcResetModem();  

	WORD   InterpretLine(LPCSTR lpLine);
	int    ParseLine(LPCSTR lpLine);

};

//****************************************************************************
#endif // __CLTWO0CL_H
