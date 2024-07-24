/****************************************************************************/
/*            (c) Copyright Black Ice Software Inc.  1994.                  */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/*                                                                          */
/*  Target Name:    FAXCPP.DLL                                              */
/*                                                                          */
/****************************************************************************/

#ifndef  __cplusplus
    #error  "This inlude file must use with C++ compiler!"
#endif  // __cplusplus

#ifndef __VCLONECL_H
#define __VCLONECL_H

#include	"clonecl.h"
 
//****************************************************************************
class CFAXAPI TCCommVoiceClassOne : public TCCommPure
{
public:
	WORD  SendProtocols ;
	WORD  RecProtocols  ;
	WORD  RemoteProtocols ;
	BYTE  RecDIS ;
	BYTE  IsDCN ;

public:
    //---------------------------------------------------------------------------------
    static PORTFAX CALLBACK  CreateTCCommVoiceClassOne (LPSTR FaxShortName, LPSTR FileName);
    //---------------------------------------------------------------------------------
    EXPDEF TCCommVoiceClassOne (LPSTR FaxName, LPSTR FileName); 
    EXPDEF TCCommVoiceClassOne ();
    
    virtual  EXPDEF ~TCCommVoiceClassOne();

	virtual BOOL EXPDEF GetCommand(int Num,LPSTR lpBuffer,int Max);
	virtual BOOL EXPDEF	StartWait() ;

	virtual int	 EXPDEF	DisconnectPort();
	virtual int	 EXPDEF	DisconnectPortEx (BOOL bDSR);
			void EXPDEF EnableLog(BOOL bEnable);

protected:

	virtual BOOL EXPDEF StartSend();

	virtual TMControl*   mcInitialSetup();
	virtual TMControl*   mcResetModem();  
	virtual TMControl*   mcAnswer() ;
	virtual TMControl*   mcSendFax();
	virtual TMControl*   mcWait();
	virtual TMControl*   mcTerminate();

    
};
#endif // __CLONECL_H
