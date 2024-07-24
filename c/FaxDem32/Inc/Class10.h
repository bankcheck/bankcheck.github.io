#ifndef  __cplusplus
    #error  "This inlude file must use with C++ compiler!"
#endif  // __cplusplus

#ifndef __CL10CL_H
#define __CL10CL_H

//****************************************************************************
// Include
#include "commcl.h"
#include "commands.h"
#include "clonecl.h"
#include "class1.h"
//****************************************************************************
#include <queue>
#include "dump.h"

typedef std::queue<BYTE*>  BYTEPTRQUEUE;
class TCReadPortBufferQueue
{
public:
    TCReadPortBufferQueue();
    ~TCReadPortBufferQueue();
    void    AddBuffer(LPBYTE pBuffer, DWORD dwBufferSize);
    BYTE*   RemoveFirstBuffer();
private:
    BYTEPTRQUEUE m_Queue;
    HANDLE       m_hMutex;
};


class CFAXAPI TCCommClassOneZero : public TCCommPure
{
    friend class TMControl ;
public:
    //---------------------------------------------------------------------------------
    static PORTFAX CALLBACK  CreateTCCommClassOneZero(LPSTR FaxShortName, LPSTR FileName);
    //---------------------------------------------------------------------------------
    EXPDEF TCCommClassOneZero(LPSTR FaxName, LPSTR FileName);
    EXPDEF TCCommClassOneZero();


    virtual EXPDEF      ~TCCommClassOneZero();
	virtual BOOL EXPDEF GetCommand(int Num,LPSTR lpBuffer,int Max);
    virtual void        LocalInit();
    virtual int     WriteComm(HCOMDEV CommDev,const void far *lpvBuf , int cbWrite);
    virtual int     ReadComm(HCOMDEV CommDev,void far* lpvBuf , int cbWrite);    

    virtual void ReadThread();
    virtual void WriteThread();
    virtual void MainThread();
    virtual BOOL WritePort(HANDLE hDevice, LPBYTE pBuffer, DWORD dwMaxSize, DWORD& Written);


            void ReadBufferProcessingThread();

    virtual int  ConnectPort (LPSTR aPortName, HANDLE hDevice);
    virtual int  DisconnectPortEx (BOOL bDSR);
    WORD  SendProtocols ;
    WORD  RecProtocols  ;
    WORD  RemoteProtocols ;
    BYTE  RecDIS ;

    BYTE  TTDCS[128];
    HANDLE hWriteSemaphore;
    HANDLE hReadThread;
    HANDLE hWriteThread;
    HANDLE hMainThread;
    HANDLE hReadWriteMutex;
    HANDLE hReadBufferProcessingThread;
    TCReadPortBufferQueue m_ReadBufferQueue;
    BOOL   bSending;
    BOOL   bTerminateSent;
    BOOL   bStopComm;
    BOOL   BufferNumber0;
    BOOL   fWaitingOnWrite;
    BOOL   fWaitingOnRead;
protected:
    virtual void         PutBinCh(BYTE bCh);
    virtual void         FlushInputBuffer();
    virtual void         HandleTransparentCommand(BYTE bCh);
    virtual void         AddBinaryDataToTheReceiveBuffer(BYTE bCh);
    virtual void         SetStatus(TEModemStatus wSt);
    virtual TMControl*   mcInitialSetup();
    virtual TMControl*   mcResetModem();
	virtual TMControl*   mcWait();
	virtual TMControl*   mcTerminate();
	virtual TMControl*   mcSendFax();
    virtual TMControl*   mcAnswer();
};



class C10_SendHDLC:public C1_SendHDLC
{
protected:
    virtual int SendCommand(LPCSTR lpCommand){return MS_OK ;}
    virtual void EndBinarySend(){ DOut("%s: C10_SendHDLC::EndBinarySend():\n", NameOf());/*SetPortStatus(MST_BUSY);*/Port().SendEvent(MR_OK, 0, 0);}
    virtual TRetCode on_Restart();
};

class C10_ReceiveCommand:public C1_ReceiveCommand
{
protected:
    virtual int SendCommand(LPCSTR lpCommand){return MS_OK ;}
};


class C10_SendCommand:public C10_SendHDLC
{
public:
    BYTE bCode ;
    BOOL bLastFrame;
public:
    C10_SendCommand(BYTE bCode=0);
    TRetCode on_Start();
protected:
    virtual int SendCommand(LPCSTR lpCommand){return MS_OK ;}
};
//=======================================================
// Send +F34 command
//=======================================================

class TMSetF34: public TModemCommand
{
public:
	TMSetF34()	;
	TRetCode 	on_Error() ;
	inline LPCSTR NameOf(){return "Set 33.6 mode";};
};                           


//==========================================
// C1_ResetModem
//  Reset Class1 modem
//==========================================
class C10_ResetModem : public TMControls
{
public:
    _loadds C10_ResetModem(TCCommPort& rPort);
    TRetCode on_Start();

    inline LPCSTR NameOf() { return "Reset Modem 1.0" ;} ;
} ;

//==========================================
// C1_InitialSetup
//  Reset Class1 modem
//==========================================
class C10_InitialSetup : public TMControls
{
public:
    C10_InitialSetup(TCCommPort& rPort);
protected:
    TRetCode on_CodeEnd();
    TRetCode on_Start();
    inline LPCSTR NameOf() { return "Initial Setup 1.0" ;} ;
} ;


class C10_CheckCompat : public TMControls
{
public:
    C10_CheckCompat(TCCommPort& rPort);
    inline LPCSTR NameOf() { return "Check Compatibility 1.0" ;} ;
};



class TMGeneralReset10 : public TMControls
{
public:
	TMGeneralReset10(TCCommPort& Port);
	inline LPCSTR NameOf(){return "General Reset 1.0";};
};


//==========================================
// C1_Dial
// C1_DialFax
//==========================================

class C10_Dial : public C1_Dial
{
public:
    C10_Dial();
	virtual TRetCode on_F34() ;
protected:
    inline LPCSTR NameOf() { return "Dial 1.0" ;} ;
} ;

//==========================================
// C1_WaitForDIS or DTC
//==========================================
class C10_WaitForDIS : public C1_WaitForDIS
{
public:
    inline LPCSTR NameOf() { return "Wait For NSF/CSI/DIS 1.0" ;} ;
    
    virtual int SendCommand(LPCSTR lpCommand);
    virtual TRetCode on_Start();
    virtual TRetCode on_ReceiveData(LPBYTE lpData,int Size);
    virtual TRetCode on_EndBinaryReceive();
    virtual TRetCode on_ReceiveBinaryData(LPBYTE Buffer,int Size);
} ;

//=======================================
// Send DCS  Frame
//=======================================
class C10_SendDCS : public C10_SendHDLC
{
public:
    C10_SendDCS();
protected:
    TRetCode on_Start();
public:
    inline LPCSTR NameOf() { return "Send DCS 1.0" ;} ;
};


class C10_SendTSI : public C10_SendHDLC
{
public:
    C10_SendTSI();
protected:
    TRetCode on_Start();
    inline LPCSTR NameOf() { return "Send TSI 1.0" ;} ;
};


//=======================================
// Receive Replay
//=======================================

class C10_ReceiveReplay : public C10_ReceiveCommand
{
public:
    C10_ReceiveReplay();
protected:
    TRetCode on_Start() ;
    TRetCode on_Timeout();
    DWORD    dwTimeout();
    TRetCode on_EndBinaryReceive();
    inline LPCSTR NameOf() { return "Receive Replay 1.0" ;} ;
} ;


class CRcvTransparentCommand: public TMControl
{
public:
	CRcvTransparentCommand();
    TRetCode on_Start();
    TRetCode on_TransparentCommand(BYTE code);
    inline LPCSTR NameOf() { return "Wait for a transparent command 1.0" ;} ;
    BYTE GetReceivedCode(){return bCode;}
    BOOL WasCommandReceived(){return bCommandReceived;}
protected:
    BYTE bCode;
    BOOL bCommandReceived;
};


class C10RecvF34Speeds: public TMControls
{
public:
    CRcvTransparentCommand WaitForCommand;
    CRcvTransparentCommand WaitForPrimaryChannelSpeed;
    CRcvTransparentCommand WaitForControlChannelSpeed;
    TRetCode CheckCommand();
public:
	C10RecvF34Speeds(TCCommPort& rPort);
    inline LPCSTR NameOf() { return "Wait for V.34 Speeds 1.0" ;} ;
    BYTE nRetries;
};

//=======================================
// Send TRAINING
//=======================================

class C10_SendTraining : public TMControls
{
    BOOL  bGood ;
    BOOL  bDCS  ;

public:
    C1_SetSendMode      SetMode ;
    C10_SendDCS         SendDCS ;
    C10_ReceiveReplay   Replay ;
public:
    C10_SendTraining(TCCommPort& rPort);

    BOOL IsGood() ;
    BOOL IsDCS() ;

public:
    TRetCode on_Start();
    TRetCode on_CodeEnd();
    TRetCode on_ChainError();
    TRetCode on_End();
    inline LPCSTR NameOf() { return "Send Training 1.0" ;} ;
};



class C10_SendPhaseB : public TMControls
{
    C10_SendTSI        SendTSI ;
    C1_SendSUB        SendSUB ;  
    C1_SendPassword   SendPWD ;  
    C10_SendTraining   SendTraining ;
    int               nCount ;
public:
    C10_SendPhaseB(TCCommPort& rPort);

    TRetCode on_Start();
    TRetCode on_CodeEnd();

    inline LPCSTR NameOf() { return "Send: Negotiation 1.0" ;} ;
};


class C10_SendECMBlock  : public C1_SendPageData
{
    friend class C10_SendECMPage ;
protected:
    int    BlockNo ;    // Current Block No
    BYTE   FrameStatus[MAX_FRAMENUM] ; // Transmitted Frame Status
    int    nFrames    ;      // Number Of total Frames
    LPBYTE FrameBuffer ;    //
    int    FramePos    ;    // Next Frame Pos
    HANDLE hFrameBuffer ;
    BOOL   PageReaded ;
    int    FrameSize ;
    int    m_LastFrameSize;
	int	   pos_0x10_0x03;
    BOOL   bPageEnd ;

    int    FrameCount ;         // Transmitted Frame Count
    DWORD  dwLastEvent ;
    HdlcCtrl        Hc ;
public:
    C10_SendECMBlock();
    ~C10_SendECMBlock();

    TRetCode on_Start();
    TRetCode TransmitPageData(int MaxSize);
	void SendBinaryData(LPBYTE lpData,int nBytes);
    TRetCode on_Ok();
    TRetCode on_Timer();

    TRetCode on_End();

    BOOL   ReadPage();
    void   on_ReceivePPR(LPBYTE lpPPR);
    //void   SendBinaryData(LPBYTE lpData,int nBytes);
    inline LPCSTR NameOf() { return "Send ECM Block 1.0" ;} ;
    int i;
};

class C10_SendPPS : public C10_SendHDLC
{
    friend class C10_SendECMPage ;
protected:
    int  PageNo ;
    int  BlockNo ;
    int  SentFrames;
    BOOL bEndPage ;
    TEPostPageSignal EndCode ;
    DWORD dwTotalNrOfPages;

    int  nRetry ;
    BOOL bConnect ;
public:
    C10_SendPPS();
    TRetCode on_Start();
    inline LPCSTR NameOf() { return "Send PPS" ;} ;
    TRetCode on_Connect();
    TRetCode on_Timeout();
} ;


//==============================================
// Send ONE ECM Block
//==============================================
class C10_SwitchChannel: public TMControl
{
public:
    C10_SwitchChannel();
    C10_SwitchChannel(int CmdNum);
    TRetCode on_Start();
    inline LPCSTR NameOf() { return "Switch channel" ;} ;
    virtual TRetCode on_TransmitData();
protected:
	char szBuffer[64] ;
	int Num;

};

class C10_SwitchToPrimaryChannel: public C10_SwitchChannel
{
public:
    C10_SwitchToPrimaryChannel();
    inline LPCSTR NameOf() { return "Switch to primary channel" ;} ;
};


class C10_SwitchToControlChannel: public C10_SwitchChannel
{
public:
    C10_SwitchToControlChannel();
    inline LPCSTR NameOf() { return "Switch to control channel" ;} ;
};

//==============================================
// Send CTC Message
//==============================================
class C10_SendCTC : public C10_SendDCS
{
public:
    C10_SendCTC();
    TRetCode on_Start();

    inline LPCSTR NameOf() { return "Send CTC 1.0" ;} ;
};



//==============================================
// Send EOR Message
//==============================================

class C10_SendEOR : public C10_SendHDLC
{
public:
    BYTE bCode ;
public:
    C10_SendEOR();
    TRetCode on_Start();
    inline LPCSTR NameOf() { return "Send EOR 1.0" ;} 
};


//=========================
//  Send RR command
//=========================

class C10_SendRR : public C10_SendCommand
{
public:
    C10_SendRR();
    inline LPCSTR NameOf() { return "Send RR 1.0" ;} 
};


//==============================================
// Process EOR Messages
//==============================================

class C10_EcmEOR : public TMControls
{
    C10_SendEOR     SendEOR;
    C10_ReceiveReplay Replay ;
    int nResend ;
public:
    BOOL bYes ;
    TEPostPageSignal  EndCode ;
    BOOL PageEnd ;
public:
    C10_EcmEOR();
    TRetCode CheckReplay();
    TRetCode on_Start();
    inline LPCSTR NameOf() { return "Send EOR 1.0";} 
} ;


class C10_SendECMPage : public TMControls
{
    friend class C10_SendECMDocument ;
protected:
    //C1_StartSendPage    StartSend ;
    C10_SendECMBlock     SendBlock ;
    C10_SwitchToPrimaryChannel    SwitchToPrimary;   
    C10_SwitchToControlChannel    SwitchToControl;  
    C10RecvF34Speeds              WaitForF34Speeds;
    C10_SendPPS          SendPPS   ;
    C10_ReceiveReplay    Replay ;

    C10_EcmEOR            ProcessEOR ;

    C10_SendCTC          SendCTC    ;
    C10_ReceiveReplay    CTCReplay  ;
    C10_SendCommand      DCNCommand ;
    C10_SendRR           SendRR     ;
    TETerminationStatus  DCNStatus  ;


protected:
    int  PageNo ;
    int  ResendBlock ;
    int  nSendPPS     ;
    DWORD  dwRNRStart ;
    TEPostPageSignal EndCode ;

public:
    C10_SendECMPage(TCCommPort& rPort);
    TRetCode on_Start();
    TRetCode on_End();
    DWORD dwTimeout();

    TRetCode   CheckBlock();
    TRetCode   CheckPPS();
    TRetCode   CheckReplay();
    TRetCode   CheckRNR();
    TRetCode   CheckF34Reply();

    TRetCode   CheckEOR();

    TRetCode   CheckCTCReplay() ;

    TRetCode   on_CodeEnd();

    inline LPCSTR NameOf() { return "Send ECM Page 1.0" ;} ;

    DWORD dwTotalNrOfPages;

};


//==============================================
// Send ONE ECM Documents
//==============================================
class C10_SendECMDocument : public TMControls
{
    C10_SendECMPage   SendPage ;
public:
    C10_SendECMDocument(TCCommPort& rPort);

    TRetCode on_Start();
    TRetCode on_End();

    DWORD dwTotalNrOfPages;
    inline LPCSTR NameOf() { return "Send ECM Document 1.0" ;} ;
};


//=======================================
// Send Complex Document
//=======================================

class C10_SendComplexDocument : public TMControls
{
    C1_CheckECM          CheckECM ;
    C10_SendPhaseB       PhaseB  ;
    C10_SendECMDocument  SendECMDoc ;

public:
    C10_SendComplexDocument(TCCommPort& rPort);

    TRetCode on_Start();
    TRetCode on_End();

    TRetCode CheckECMDoc();
    TRetCode CheckDoc();
    TRetCode CheckMode();

    inline LPCSTR NameOf() { return "Send Complex Document 1.0" ;} ;
private:
    DWORD dwTotalNrOfPages;
};


class C10_SendDCN: public C10_SendCommand
{
public:
    C10_SendDCN();
    TRetCode on_Start();
    TRetCode on_Ok();
    DWORD dwTimeout();
    virtual void EndBinarySend(){ DOut("%s: C10_SendDCN::EndBinarySend():\n", NameOf());SetPortStatus(MST_BINARYRECEIVE);}
    TRetCode on_TransparentCommand(BYTE code);
    inline LPCSTR NameOf() { return "Send DCN 1.0";} ;
};


//=======================================================
// Send C10_SendFax command
//=======================================================
class C10_SendFax : public TMainControl
{
public:
    C10_SendFax(TCCommPort& rPort);
    C1_ModemCommand         SetClass ;
	TMSetF34			    SetF34;
	C10_Dial			    Dial10;
	C10_WaitForDIS		    WaitForDIS10;
    C10_SendComplexDocument SendDocuments10;  
    // T.30.C point
    C10_SendDCN             SendDCN10;

    C1_ReceiveDocument      ReceiveDocument ;


    C1_WaitForDIS           WaitForDIS ;
    C1_SendComplexDocument  SendDocuments;  
    C1_SendComplexG5Document SendG5Documents ;  //rz G5
    
    C1_SendDCN               SendDCN;

    DWORD                   DisWaitTime ;
    TRetCode on_Start();
    TRetCode on_CodeEnd();
    TRetCode on_End();
    TRetCode CheckSend() ;
    TRetCode CheckReceive() ;
    virtual TRetCode    CheckMode();
    virtual TRetCode    CheckDial();
    inline LPCSTR NameOf() { return "Send Fax 1.0" ;} ;
} ;

//=========================
//  C1_Terminate
//=========================
class C10_Terminate : public TMControls
{
public:
    C10_Terminate(TCCommPort& rPort);
protected:
    TRetCode on_CodeEnd();
    inline LPCSTR NameOf() { return "Terminate 1.0" ;} ;
} ;


//=======================================
// Send CFR
//=======================================

class C10_SendCFR : public C10_SendHDLC {

public:
   C10_SendCFR();
   TRetCode on_Start();
   inline LPCSTR NameOf() { return "Send CFR 1.0" ;} ;
} ;

//=======================================
// Send CSI
//=======================================

class C10_SendCSI : public C10_SendHDLC {

public:
   C10_SendCSI();
   TRetCode on_Start();
   inline LPCSTR NameOf() { return "Send CSI 1.0" ;} ;
} ;

//=======================================
// Send NSF
//=======================================

class C10_SendNSF : public C10_SendHDLC {

public:
   C10_SendNSF();
   TRetCode on_Start();
   inline LPCSTR NameOf() { return "Send NSF 1.0" ;} ;
} ;

class C10_SendDIS : public C10_SendHDLC
{
    int nSend ;
public:
    C10_SendDIS();
    TRetCode on_Start();

    void CreateDIS();
    inline LPCSTR NameOf() { return "Send DIS 1.0" ;} ;
};


//=====================================
//  Receive Training T.30.R
//=====================================

class C10_ReceivePhaseB : public TMControls
{
    C10_SendNSF             SendNSF ;
    C10_SendCSI             SendCSI ;
    C10_SendDIS             SendDIS ;

    //virtual int SendCommand(LPCSTR lpCommand);
public :
    BOOL bEnabled ;
    C10_ReceivePhaseB(TCCommPort& rPort) ;
    
    TRetCode on_Start() ;
    inline LPCSTR NameOf() { return "Receive Negotiation 1.0" ;} ;
} ;


//=====================================
//  Wait for DIS or DTC frame
//=====================================

class C10_WaitForDCS: public C10_ReceiveCommand
{
    BOOL    bDCS ;
    BOOL    bDTC ;
public:
    BYTE    CommandRec ;
    DWORD   dwTimeoutVal ;
public:
    C10_WaitForDCS();

    TRetCode on_Start();
    TRetCode on_EndBinaryReceive();
    TRetCode on_Connect();
    TRetCode on_Timeout();
    DWORD    dwTimeout();
public:
    BOOL IsDCS() {return bDCS ;} ;
    BOOL IsDTC() {return bDTC ;};


    inline LPCSTR NameOf() { return "Wait For DCS 1.0" ;} ;
} ;

//=====================================
//  Receive Training T.30.F (R)
//=====================================
class C10_ReceiveTraining : public TMControls
{
friend class C10_ReceiveDocument;

    C10_ReceivePhaseB      PhaseB  ;
    C10_WaitForDCS         WaitForDCS          ;
    C10_SendCFR            SendCFR ;

    DWORD                  dwStart ;

    int                    nDISCnt ;
public:
    BOOL bOk        ;
    BOOL bReceive   ;
    BYTE CommandRec ;
    BOOL bRecDCS    ;

public:
    C10_ReceiveTraining(TCCommPort& rPort) ;
    TRetCode on_Start();
    TRetCode on_Error();
    BOOL      IsReceive()    { return bReceive ; } ;

    TRetCode  CheckDCS();

    TRetCode  Restart();

    inline LPCSTR NameOf() { return "Receive Training" ;} ;
};


//==============================================
// Receive One ECM Block
//==============================================


class C10_ReceiveECMBlock : public C1_ReceivePage
{
protected:
    BYTE        FrameStatus[256] ;
    short       BlockNo ;
    //short     PageNo  ;

    HANDLE      hFrameBuffer ;
    LPBYTE      FrameBuffer  ;

    int         nFrames    ;
    int         MaxFrames  ;
    int         RecFrames ;
    int         FramePos    ;
    HdlcCtrl    HCtrl  ;
    LPBYTE      FCDBuffer ;
    int         RCPcnt ;

    int         FrameSize ;

public:

    C10_ReceiveECMBlock();
    ~C10_ReceiveECMBlock();

    TRetCode on_Start();
    TRetCode on_ReceiveBinaryData(LPBYTE lpBytes,int nSize);
    TRetCode on_EndBinaryReceive();
    virtual int SendCommand(LPCSTR lpCommand);

    void    StartNextBlock();
    BOOL    MakePPRFrame(LPBYTE lpRep,int Frames);
    TRetCode on_End();

    TRetCode on_TransparentCommand(BYTE code);
    inline LPCSTR NameOf() { return "Receive ECM Block 1.0" ;} ;
    BOOL bSwitchedToPrimary;
};

class C10_ReceivePPSEOP : public C10_ReceiveCommand {

public :

    BYTE    nFrames ;
    BYTE    nBlock  ;
    BYTE    nPage   ;

public:
    C10_ReceivePPSEOP();
    TRetCode on_Start();
    TRetCode on_End();
    TRetCode on_EndBinaryReceive();
    TRetCode on_ReceiveBinaryData(LPBYTE Buffer,int Size);
    DWORD dwTimeout();
    TEPostPageSignal GetCode();
    
    inline LPCSTR NameOf() { return "Receive PPS EOP 1.0" ;} ;
};

class C10_SendPPR: public C10_SendCommand
{
public:
    C10_SendPPR();
    TRetCode on_Start();
    void SetFrame(LPBYTE lpData,int Size);
    void SetCommand(BYTE bCode);
    inline LPCSTR NameOf() { return "Send PPS or MCF 1.0" ;} 

};

//=========================
//  Send RNR command
//=========================

class C10_SendRNR : public C10_SendCommand
{
public:
    C10_SendRNR();
    inline LPCSTR NameOf() { return "Send RNR 1.0" ;} ;
};


//=========================
//  WaitFor RNR command
//=========================

class C10_WaitForRNR : public C10_ReceiveCommand
{
public:
    C10_WaitForRNR();
    inline LPCSTR NameOf() { return "Wait For RNR 1.0" ;} ;
    TRetCode on_Ok();
    TRetCode on_Start();
    TRetCode on_Timeout();

};

//=========================
//  Wait For RR command
//=========================

class C10_WaitForRR : public C10_ReceiveCommand
{
public:
    BYTE Command;
    C10_WaitForRR();
    inline LPCSTR NameOf() { return "Wait For RR 1.0" ;} ;
    TRetCode on_Ok();
    TRetCode on_Start();
    TRetCode on_Timeout();
};


//=========================
//  Send RR command
//=========================

class C10_ReceiverBusy : public TMControls
{
    C10_WaitForRR       WaitForRR;
    C10_SendRNR         SendRNR;
public:
    BYTE GetCommand(){return WaitForRR.Command;}
    C10_ReceiverBusy();
    inline LPCSTR NameOf() { return "Receiver Busy 1.0" ;} ;
    TRetCode CheckRR();
};

//==============================================
// Waint for ERR or CTC message
//==============================================
class C10_WaitForCTC : public C10_ReceiveCommand
{

public:
    TRetCode  on_Start();
    TRetCode  on_End();
    inline LPCSTR NameOf() { return "Wait For CTC 1.0" ;} ;
};

//==============================================
// Receive One ECM Page
//==============================================

class C10_ReceiveECMPage : public TMControls
{
    friend class        C10_ReceiveDocument ;

    C10_ReceiveECMBlock   ReceiveECMBlock;
    C10_ReceivePPSEOP     ReceivePPSEOP  ;
    C10_SendPPR           SendPPR        ;

    C10_ReceiveReplay     ERRCommand     ;
    C10_SendCommand       ERRReplay      ;

    DWORD                dwErrTime ;

protected:
    int     PageNo ;
    int     BlockNo ;

    BOOL    bRetrain ;
    BOOL    bNextPage ;
    BOOL    bIsNextDoc ;
    BOOL    bPageGood ;
    BOOL    bBlockGood ;
    TEPostPageSignal EndCode ;
    int     nRetry ;

public:
    C10_ReceiveECMPage(TCCommPort& rPort);
    TRetCode on_Start();
    TRetCode CheckF34Reply();
    
    inline LPCSTR NameOf() { return "Receive ECM Page 1.0" ;} ;

protected:

    TRetCode CheckBlock();
    TRetCode CheckPPSEOP();
    TRetCode CheckPPR() ;
    TRetCode CheckReceiver() ;

    TRetCode CheckERRCommand();
    TRetCode EndERRCommand();
    void ProcessEndCode(TEPostPageSignal End);


public:
    BOOL IsNextPage() {return  bNextPage;};
    BOOL IsNextDoc()  {return  bIsNextDoc;};
    BOOL IsRetrain()  {return  bRetrain;};
    BOOL IsPageGood() {return  bPageGood;};
};

//=======================================
//  C10 Receive one or mode document
//=======================================

class C10_ReceiveDocument : public TMControls
{

    C10_ReceiveTraining  ReceiveTraining  ;
    //C1_RecPhaseD        PhaseD  ;
    C10_ReceiveECMPage   ReceiveECMPage ;
    //C1_WaitForDIS       WaitForDIS ;

    //C1_G5FileFormatNeg  G5FileFormatNeg;
public:
    BYTE   CommandRec ;

    C10_ReceiveDocument(TCCommPort& rPort);
protected:
    TRetCode on_Start();
    TRetCode on_CodeEnd();

    TRetCode CheckTraining();
//    TRetCode CheckPhaseD();
    TRetCode CheckECMPage();

    TRetCode CheckPage();   // TG

    inline LPCSTR NameOf() { return "Receive Document 1.0";}
} ;
 
//=========================
//  Wait for DCN command
//=========================

class C10_WaitForDCN : public C10_ReceiveCommand
{
public :
    C10_WaitForDCN();
protected:
    TRetCode on_Start();
    TRetCode on_Ok();
    TRetCode on_Timeout();
    TRetCode on_EndBinaryReceive();
    DWORD dwTimeout();
    inline LPCSTR NameOf() { return "Wait For DCN 1.0" ;} ;

    BOOL    bEOTSent;
} ;


//=========================
//  C10_Answer to Rings
//=========================

class C10_Answer : public TMainControl
{
    C1_ReceiveDocument          ReceiveDocument  ;
    C1_SendComplexDocument      SendDocument ;
    C1_WaitForDCN               WaitForDCN ;
    C1_ResetModem               ResetModem;

    C10_ReceiveDocument         ReceiveDocument10  ;
    C10_SendComplexDocument     SendDocument10 ;
    C10_WaitForDCN              WaitForDCN10 ;
    C10_ResetModem              ResetModem10;
public:
    C10_Answer(TCCommPort& rPort);

    TRetCode CheckReceiveDocument();
    TRetCode CheckSendDocument() ;
    TRetCode CheckAnswer();
    TRetCode CheckDCN();
    TRetCode on_Start();
    TRetCode on_CodeEnd();

    inline LPCSTR NameOf() { return "Answer 1.0" ;} ;
} ;


//=========================
//  C10_AutoAnswer
//=========================

class C10_AutoAnswer : public C1_ModemCommand
{
public:
    C10_AutoAnswer();

    TRetCode on_Start();
    TRetCode on_Connect();
    TRetCode on_Timeout();

    TRetCode on_No_Carrier();
    TRetCode on_No_Dialtone();
    TRetCode on_Busy();
    TRetCode on_Ring();
    TRetCode on_Ok();
    TRetCode on_F34();

    inline LPCSTR NameOf() { return "Auto Answer 1.0" ;} ;
} ;

#endif 
