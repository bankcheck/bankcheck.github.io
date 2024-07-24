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

#ifndef __CLONECL_H
#define __CLONECL_H

//****************************************************************************
// Include
#include "commcl.h"

//****************************************************************************
#define MAX_BINARY    1024
#define MAX_CMDARRY   4

// HDLC types
#define HDLC_DIS    0x80
#define HDLC_CSI    0x40
#define HDLC_NSF    0x20

#define HDLC_DTC    0x81
#define HDLC_CIG    0x41
#define HDLC_NSC    0x21

#define HDLC_DCS    0x82
#define HDLC_TSI    0x42
#define HDLC_NSS    0x22

#define HDLC_CFR    0x84
#define HDLC_FTT    0x44

#define HDLC_EOM    0x8E
#define HDLC_MPS    0x4E
#define HDLC_EOP    0x2E
#define HDLC_PRIEOM 0x9E
#define HDLC_PRIMPS 0x5E
#define HDLC_PRIEOP 0x3E

#define HDLC_MCF    0x8C
#define HDLC_RTP    0xCC
#define HDLC_RTN    0x4C

#define HDLC_DCN    0xFA
#define HDLC_CRP    0x1A

#define HDLC_CTC    0x12
#define HDLC_CTR    0xC4
#define HDLC_RR     0x6E
#define HDLC_PPR    0xBC
#define HDLC_RNR    0xEC
#define HDLC_ERR    0x1C
#define HDLC_PWD    0xA2  //rz  was 0x61
#define HDLC_SEP    0xC1
#define HDLC_SUB    0xC2  //rz  was 0x17
#define HDLC_PWDP   0x21



#define HDLC_PPS    0xBE
#define HDLC_PPSNULL    0x0000BEl
#define HDLC_PPSMPS     0x4E00BEl
#define HDLC_PPSEOP     0x2E00BEl
#define HDLC_PPSEOM     0x8E00BEl

#define HDLC_EOR    0xCE
#define HDLC_EORNULL    0x0000CEl
#define HDLC_EORMPS     0x4E00CEl
#define HDLC_EOREOP     0x2E00CEl
#define HDLC_EOREOM     0x8E00CEl

#define HDLC_FDM    0xFC

#define REPLAY_CMD  10
#define T1_TIME     35000
#define T2_TIME      3000
#define T3_TIME      1000
#define T4_TIME      4500
#define T5_TIME     60000

#define ECM_MAXFRAME    256


#define CP_V27    1
#define CP_V29    2
#define CP_V17    4
#define CP_V17WST 8
#define CP_V33    16

//****************************************************************************
class CFAXAPI TCCommClassOne : public TCCommPure
{
public:
        WORD  SendProtocols ;
        WORD  RecProtocols  ;
        WORD  RemoteProtocols ;
        BYTE  RecDIS ;
        BYTE  IsDCN ;

public:
    //---------------------------------------------------------------------------------
    static PORTFAX CALLBACK  CreateTCCommClassOne (LPSTR FaxShortName, LPSTR FileName);
    //---------------------------------------------------------------------------------
    EXPDEF TCCommClassOne (LPSTR FaxName, LPSTR FileName);
    EXPDEF TCCommClassOne ();

    virtual  EXPDEF ~TCCommClassOne();

        virtual BOOL EXPDEF GetCommand(int Num,LPSTR lpBuffer,int Max);
        virtual BOOL EXPDEF     StartWait() ;

protected:

        virtual TMControl*   mcInitialSetup();
        virtual TMControl*   mcResetModem();
        virtual TMControl*   mcAnswer() ;
        virtual TMControl*   mcSendFax();
        virtual TMControl*   mcWait();
        virtual TMControl*   mcTerminate();


};
#endif // __CLONECL_H
