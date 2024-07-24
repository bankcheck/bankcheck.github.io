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

#ifndef __CLTWOCL_H
#define __CLTWOCL_H

//****************************************************************************
// Include
#include "commcl.h"
//****************************************************************************

//****************************************************************************

//****************************************************************************
class CFAXAPI TCCommClassTwo : public TCCommPure
{
public:
    static PORTFAX CALLBACK CreateTCCommClass (LPSTR FaxShortName, LPSTR FileName);
    EXPDEF TCCommClassTwo (LPSTR FaxName, LPSTR FileName);
	EXPDEF TCCommClassTwo ();
    virtual EXPDEF ~TCCommClassTwo();

protected:
	void	Init();
	virtual TMControl* mcInitialSetup();
	virtual TMControl* mcResetModem();  
	virtual TMControl* mcAnswer() ;
	virtual TMControl* mcSendFax();
	virtual TMControl* mcWait();
	virtual TMControl* mcTerminate();

};
//****************************************************************************
#endif // __CLTWOCL_H
