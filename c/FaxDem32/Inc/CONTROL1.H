#ifndef _CONTROL1_H
#define _CONTROL1_H

#include "faxbase.h"

#pragma pack(4)
#pragma warning(disable:4103)

typedef short TMEvent  ;
typedef short TMReturn ;

enum TRetCode {
                MS_OK=0,
                MS_END=-1,
                MS_TERMINATE=-2
} ;

enum TEModemStatus {
                MST_WAIT ,
                MST_BUSY ,
                MST_BINARYSEND ,
                MST_BINARYRECEIVE
} ;

typedef struct tagTSLineStatus {
        WORD    cbInCh ;
        WORD    cbOutCh ;
        DWORD   ReadTime ;
        DWORD   WriteTime ;
        WORD    CTS:1 ;
        WORD    DSR:1 ;
        WORD    CD:1  ;
        WORD    TR:1  ;
        WORD    SD:1  ;
        WORD    ERR:1 ;
} TSLineStatus ;

#ifndef ASSERT
#define ASSERT assert
#endif

#define MR_PORTFIRST     1

#define MR_MODEMFIRST  100
#define MR_CLASSFIRST  200
#define MR_APPFIRST    300


// Port Events

#define MR_RECEIVEDATA      1
#define MR_TRANSMITDATA     2
#define MR_TIMER            3
#define MR_COMERROR         4
#define MR_BREAK            5
#define MR_CONTINUE         6


// Modem Events
#define MR_SKIP             100
#define MR_OK               101
#define MR_CONNECT          102
#define MR_RING             103
#define MR_NO_CARRIER       104
#define MR_RECEIVELINE      105
#define MR_BINARYRECEIVE    106
#define MR_ENDBINARYRECEIVE 107
#define MR_BUSY             108
#define MR_ERROR            109
#define MR_TIMEOUT          110
#define MR_NO_DIALTONE      111
#define MR_CALLERID         112
#define MR_VOICE            113
#define MR_F34	            114
#define MR_TRASNPARENTCMD   115



#define  RESP_NONE          0
#define  RESP_OK            1
#define  RESP_CONNECT       2
#define  RESP_ERROR         3
#define  RESP_BUSY          4
#define  RESP_RING          5
#define  RESP_NO_CARRIER    6
#define  RESP_NO_DIALTONE   7
#define  RESP_NO_DIAL_TONE  8
#define  RESP_CALLERID      9
#define  RESP_OK_0          10
#define  RESP_VOICE         11 
#define  RESP_F34	        12 

#define  RESP_CLASSFIRST    32
#define  RESP_FAXCLASS      RESP_CLASSFIRST

#define  RESP_USERFIRST     64

#define  RESP_MAX          128


// Timeouts
#define TO_MAX 64

#define TO_DEFAULT 0

#define TO_TRAINING         1
#define TO_SEND_PHASE_C     2
#define TO_RECEIVE_PHASE_C  3
#define TO_DISCONNECT_PHASE_C   4

enum TEPostPageSignal  {
        PE_ERROR ,
        PE_NULL ,
        PE_MPS  ,
        PE_EOM ,
        PE_EOP
} ;



class CFAXAPI TCCommPort : public TCFaxObject
{
        friend class TMControl ;
        friend class C10_SendHDLC;
        friend class C10_SendECMBlock;
        friend class C10_SwitchChannel;
        friend class C10_SendDCN;
        friend class C10_Terminate;
        friend class C10_WaitForDCN;
public:
        DECLARECLASS(TCFaxObject,"TCCommPort",CID_COMPORT);
        friend class    TMControl ;
public:
        EXPDEF TCCommPort();
        EXPDEF ~TCCommPort();

        virtual void EXPDEF  ProcessCommEvent(MSG &msg);

        virtual HCOMDEV EXPDEF Open(LPCSTR lpDevName);
        virtual HCOMDEV EXPDEF Close();

        virtual BOOL    EXPDEF IsPortOpen();
        virtual BOOL    EXPDEF IsPortEnabled();
        virtual int             EXPDEF SetDSR(BOOL bDSR);

        virtual BOOL    EXPDEF IsPortVoice(){ return bVoicePort; };     // ***ST***

        virtual TEModemStatus       EXPDEF GetStatus();
        virtual TETransmitPhase EXPDEF GetPhase();
        virtual BOOL            EXPDEF GetLineStatus(TSLineStatus* lpStatus);

        BOOL WaitForIdle(DWORD dwMaxTime,HWND hWnd=NULL);

        virtual int         EXPDEF EnableFaxPort(BOOL Enable);

        virtual BOOL    EXPDEF SetupCommPort(TSCommSetting& NewSet);
        virtual BOOL    EXPDEF GetCommPortSetting(TSCommSetting& ComSet);

        virtual BOOL    EXPDEF SetupPortCapabilities(TSModemCapabiliti  &NewModemCap );
        virtual BOOL    EXPDEF GetPortSetting(TSModemCapabiliti  &PortSet );

        virtual BOOL    EXPDEF GetSessionParameters(TSSessionParameters &theSession);
        virtual BOOL    EXPDEF GetModemCapabiliti(TSModemCapabiliti  &ModemCap );
        virtual BOOL    EXPDEF GetRemoteModemCapabiliti(TSModemCapabiliti  &ModemCap );
        virtual BOOL    EXPDEF GetCapabiliti(TSModemCapabiliti  &NewModemCap );
        virtual BOOL    EXPDEF GetModemCapability(TSModemCapability  &ModemCap );
        virtual BOOL    EXPDEF GetRemoteModemCapability(TSModemCapability  &ModemCap );
        virtual BOOL    EXPDEF GetCapability(TSModemCapability  &NewModemCap );

        virtual BOOL    EXPDEF GetCommand(int Num,LPSTR lpBuffer,int Max);
        virtual DWORD   EXPDEF GetCommandTimeout(int Num);
        virtual BOOL    EXPDEF GetDialString(LPSTR lpBuffer,int Max);

        virtual BOOL    EXPDEF SetCommand(int Num,LPSTR lpCommand);
        virtual BOOL    EXPDEF SetCommandTimeout(int Num,DWORD dwTimeout);

        virtual BOOL    EXPDEF SetTimeout(int Num,DWORD dwTimeout);
        virtual DWORD   EXPDEF GetTimeout(int Num) ;

        virtual void    EXPDEF GetStationID(LPSTR lpBuffer,int iMax);
        virtual void    EXPDEF SetStationID(LPCSTR lpBuffer);

        virtual TETerminationStatus EXPDEF GetTerminationStatus();

        void    EXPDEF CommentLog(LPCSTR lpComment);
        virtual BOOL    EXPDEF SetResponseString(int Num,LPCSTR lpString,WORD wEvent);
        virtual BOOL    EXPDEF GetResponseString(int Num,LPSTR lpBuffer,int Max,WORD & wEvent);

#if defined(WIN32)
        inline  BOOL   IsComPort() {
                            return bTrueComPort; };
        TEBoardType ComBoard();
        void    SetComBoard( TEBoardType BType ) {
                            BoardType = BType; };

        virtual void ReturnPageFile( BOOL bReturn ) {};
        virtual BOOL IsPageFileReturned() { return FER_NOTIMPLEMENTED; };
        virtual int  GetLastPageFileName( LPSTR lpBuf, int size ) { return FER_NOTIMPLEMENTED; };

#endif
        //====================================
        //
        //====================================
    virtual void EXPDEF   EnableLog(BOOL bEnable);
        static void EXPDEF  SetLogDir(LPCSTR lpStr);

        static void EXPDEF InitDefaultSession();

    /*
     *   DTMF
     */
    virtual  int    SetVoiceFile( LPSTR lpFileName );
    virtual  int    GetVoiceFile( LPSTR lpBuffer, int Max );
    virtual  int    SetVoiceTimeout( unsigned int WaitTime );
    virtual  unsigned int  GetVoiceTimeout();
    virtual  int    GetDTMFDigits( LPSTR lpBuffer, int Max );
    virtual  int    SetDTMFDigits( int n, char Value );
    virtual void    SetDigitNumber( int n );
    virtual  int    GetDigitNumber();
    virtual void    GetDID( LPSTR dstBuf )  { dstBuf[0] = '\0';}


    virtual void    PutBinCh(BYTE bCh);
protected:
        virtual void    EXPDEF Terminate(TETerminationStatus TStatus);

        virtual HCOMDEV  GetCommDevice();
        virtual BOOL     SendCommand(LPCSTR lpCommand);

        virtual void     SendBinaryData(LPBYTE lpData,int nBytes);
        virtual void     EndBinarySend();

        virtual void     SetControl(TMControl *lpControl);


        virtual BOOL     InitNewSession();

        virtual void     SetStatus(TEModemStatus NewStatus);
        virtual void     SetPhase(TETransmitPhase Phase);

        virtual void     onStartDataSend();
        virtual void     onEndDataSend();
        virtual void     onStartDataReceive();
        virtual void     onEndDataReceive();

        virtual WORD     InterpretLine(LPCSTR lpLine);
        virtual void     Timer();

     // phisical read an write port
        virtual int         Read(LPBYTE lpData,int nBytes);
        virtual int     Write(LPBYTE lpData,int nBytes);

        
        virtual void    PutCmdCh(BYTE bCh);
        virtual void    FlushInputBuffer();

        virtual int     SendEvent(int Event ,DWORD Param1 , DWORD Param2  );
        virtual void    LineError();

        virtual BOOL    SetModemCapability(TSModemCapabiliti  &ModemCap );
        virtual BOOL    SetCurrentSession(TSSessionParameters &CurSess );
        virtual BOOL    SetRemoteModemCapabiliti(TSModemCapabiliti  &ModemCap );
        virtual BOOL    SetRemoteModemCapability(TSModemCapability  &ModemCap );

        virtual void    SetRemoteID (LPSTR aRemoteID);

        virtual TSSessionParameters& GetSession();

        virtual long SendFaxEvent (TEFaxEvent Event, LPARAM lParam);

        //===================================
        // Fax document management functions
        //====================================
        // SendFax
        //====================================

        virtual BOOL StartFaxSend();
        virtual BOOL EndFaxSend();
        virtual BOOL StartSendPage(int PageNo);
        virtual BOOL EndSendPage(int LineNum=-1);
        virtual int  ReadPageData(LPBYTE lpBuffer,int iSize);

        virtual BOOL StartSendDocument();
        virtual BOOL EndSendDocument();

        virtual BOOL IsSendDocument() ;
        virtual BOOL IsNewSendDocument();
        virtual BOOL StartNextDocument() ;

        // Page management
        virtual int           GetCurrentPage();
        virtual int           GetSendPages();
        virtual int           SetPageStatus(int nPage,TEPageStatus  Code);
        virtual TEPageStatus  GetPageStatus(int nPage);
        virtual int           GetFaxParam(TSFaxParam far &Param);
        virtual int           GetLineNum(int PageNo) ;
        virtual DWORD         GetSize(int PageNo);
        virtual void          SendMonoPages();

        //====================================
        // ReceiveFax
        //====================================
        virtual BOOL  StartFaxReceive();
        virtual BOOL  StartReceiveNextDocument();//rz 02-16-99
        virtual BOOL  EndFaxReceive();
        virtual BOOL  EndReceiveOneDocument();//rz 02-16-99
        virtual BOOL  StartReceiveDocument();
        virtual BOOL  EndReceiveDocument();
        virtual BOOL  StartReceivePage(int nPage);
        virtual BOOL  EndReceivePage(int LineNum);
        virtual void  WritePageData(LPBYTE lpBuffer,int nSize);
        virtual BOOL  IsReceiveDocument() ;

        //====================================
        // Overloadable  Fax object creation
        //====================================

        TCFaxNormal*  CreateReceiveFaxObj();
        TCFaxNormal*  CreateSendFax();


public:
        // Modem Action Commands
        virtual BOOL EXPDEF StartInitialSetup();
        virtual BOOL EXPDEF StartAnswer();
        virtual BOOL EXPDEF StartSend();
        virtual BOOL EXPDEF StartWait() ;

//rz these functions are used by G5 only
        BOOL IsPortBusy(){return G5_PortBusy;}                                //rz g5
        void SetBusyState(BOOL Busy){G5_PortBusy=Busy;}                       //rz g5
        BOOL IsG5Receiver(){return G5_Receiver;}                              //rz g5
        void SetG5Receiver(BOOL IsReceiver){G5_Receiver=IsReceiver;}          //rz g5
        TEG5Status GetG5Status();                                             //rz g5
        void SetG5Status(TEG5Status status);                                  //rz g5
                BOOL G5ConfirmationEnabled();                                                                             //rz g5
                virtual void    G5EnableConfirmation(BOOL conf);                      //rz g5
        virtual void    CheckTurnAround();
        virtual void    CheckConfirmation();
        virtual BOOL    GoG3();
        virtual BOOL G5IsSendingG3(){return FALSE;}
        virtual void    ReportG5EndSend(){return;}
//rz
        BOOL IsSubaddressEnabled(){return bSubAddress;}
        void EnableSubaddress(BOOL enabled){ bSubAddress=enabled;}

        virtual BOOL    GetV34Mode(){ return bV34Fax;}
        virtual void    SetV34Mode(BOOL V34Mode){ bV34Fax = V34Mode;}

        TCLog     Log ;

protected:
        // create Action controls
        virtual TMControl* mcInitialSetup();
        virtual TMControl* mcResetModem();
        virtual TMControl* mcAnswer() ;
        virtual TMControl* mcSendFax();
        virtual TMControl* mcWait();
        virtual TMControl* mcTerminate();


protected:
        // Data members

                BOOL                    bVoicePort;     // ***ST***

        TMControl       *mControl ;

        TSModemCapabiliti       PortSetting      ;
        TSModemCapabiliti   ModemCap         ; // This modem capabiliti
        TSModemCapabiliti   CurrentCap       ; // Enabled capabiliti
        TSModemCapabiliti   RemoteModemCap   ; // Remote modem capabiliti

static  TSSessionParameters SessionDefaults ;

        TSSessionParameters CurrentSession   ; // CurrentSession parameters
        TETerminationStatus TStatus          ; // Transmit termination status
        TETransmitPhase     TPhase           ; // Transmit Phase

#if defined(WIN32)
        BOOL   bTrueComPort;
        TEBoardType BoardType;
#endif

        // Document Messaging
        WORD   bStartSend:1     ;
        WORD   bStartSendDoc:1  ;
        WORD   bStartSendPage:1 ;

        WORD   bStartReceive :1 ;
        WORD   bStartReceiveDoc:1 ;
        WORD   bStartReceivePage: 1 ;

#ifdef _THREAD
        HEVENT hIdle ;
#endif

private:
        TMControl       *mJump ;
        int             nLevel ;
protected:
        // Error logging
        TCLogFile       ErrorLog ;
        DWORD           dwLogStart ;

//rz g5
        BOOL            G5_PortBusy;
        BOOL            G5_Receiver;
        BOOL            bG5_Confirmation; //rz
        BOOL            bSubAddress;
        BOOL            bConnectTimeAlreadySet;
        BOOL            bV34Fax;
} ;






class CFAXAPI TCModemPort : public TCCommPort
{
protected:
        TEModemStatus           Status  ;
        int             SizeQueue       ;

        char            LineBuffer[256] ;
        BYTE*           szOutputBuffer  ;
        BYTE*           szInputBuffer   ;

        int         nOutBufPtr      ;
        int         nInputBufPtr    ;
        int         nLineBufPtr         ;
        BOOL        LastDLE         ;

        TCStr       Commands[MC_MAX]      ;
        DWORD       CommandTime[MC_MAX]   ;

        TCStr       Responses[RESP_MAX] ;
        WORD        RespEvent[RESP_MAX] ;

        DWORD       dwTimeouts[TO_MAX] ;

public:
        EXPDEF TCModemPort();
        EXPDEF ~TCModemPort();
        virtual TEModemStatus   EXPDEF  GetStatus() ;


        virtual HCOMDEV EXPDEF Open(LPCSTR lpDevName);
        virtual HCOMDEV EXPDEF Close();
        virtual int      Write(LPBYTE lpData,int nBytes);
        virtual int      Read(LPBYTE lpData,int nBytes);

        virtual void     SetStatus(TEModemStatus NewStatus);

        virtual void    PutBinCh(BYTE bCh);
protected:
        virtual void    SendBinaryData(LPBYTE lpData,int nBytes);
        virtual void    EndBinarySend();

        virtual WORD    InterpretLine(LPCSTR lpLine);
        virtual void    Timer();

        
        virtual void    PutCmdCh(BYTE bCh);

        virtual void    ClearLineBuffer();
        virtual void    ClearInputBuffer();
        virtual void    ClearOutputBuffer();
        virtual void    FlushInputBuffer();

        virtual BOOL    SendCommand(LPCSTR lpCommand);
public:
        virtual BOOL    EXPDEF GetCommand(int Num,LPSTR lpBuffer,int Max);
        virtual DWORD   EXPDEF GetCommandTimeout(int Num);

        virtual BOOL    EXPDEF SetCommand(int Num,LPSTR lpCommand);
        virtual BOOL    EXPDEF SetCommandTimeout(int Num,DWORD dwTimeout);

        virtual BOOL    EXPDEF SetResponseString(int Num,LPCSTR lpString,WORD wEvent);
        virtual BOOL    EXPDEF GetResponseString(int Num,LPSTR lpBuffer,int Max,WORD & wEvent);

        virtual BOOL    EXPDEF SetTimeout(int Num,DWORD dwTimeout);
        virtual DWORD   EXPDEF GetTimeout(int Num) ;

    void StartDriver();
} ;


class CFAXAPI TMControl
{
        friend class TCCommPort ;
        friend class TCCommClassGamma ;
        friend class TMControls ;
        friend class TCCommClassOneZero ;
public:
        EXPDEF TMControl();
        EXPDEF TMControl(TCCommPort &Port);
        virtual EXPDEF ~TMControl();

        virtual void    EXPDEF  SetPort(TCCommPort &Port );
        virtual TRetCode EXPDEF Start();

protected:
        virtual  LPCSTR   NameOf() ;
        virtual HCOMDEV  GetCommDevice();
        virtual int  WritePort(LPBYTE lpData,int Size);
        virtual TRetCode  EventHandler(int Event ,DWORD Param1 , DWORD Param2  );

        virtual TRetCode  ProcessEvent(int Event ,DWORD Param1 , DWORD Param2  );

        virtual TSSessionParameters& GetSession();

        virtual TRetCode on_Start();
        virtual TRetCode on_Ok() ;
        virtual TRetCode on_Connect() ;
        virtual TRetCode on_Voice() ; //rz
        virtual TRetCode on_No_Carrier() ;
        virtual TRetCode on_Error();
        virtual TRetCode on_No_Dialtone() ;
        virtual TRetCode on_Busy() ;
        virtual TRetCode on_Ring() ;
        virtual TRetCode on_Timeout() ;
        virtual TRetCode on_Timer() ;
        virtual TRetCode on_ReceiveHdlc(BYTE code,LPSTR lpHdlcBuffer);
		virtual TRetCode on_F34() ;
        virtual TRetCode on_TransparentCommand(BYTE code) ;

        virtual TRetCode on_ReceiveBinaryData(LPBYTE Buffer,int Size);
        virtual TRetCode on_ReceiveLine(LPCSTR lpStr,int Size);
        virtual TRetCode on_EndBinaryReceive();
        virtual TRetCode on_TransmitData();
        virtual TRetCode on_Comerror(DWORD dwParam1,DWORD dwParam2);

        virtual TRetCode on_ReceiveData(LPBYTE lpData,int Size);


        virtual TRetCode on_End();
        virtual TRetCode on_Terminate();

        virtual TRetCode on_ChainEnd() ;
        virtual TRetCode on_ChainError();

        virtual DWORD dwTimeout()  ;
        virtual int   SendCommand(LPCSTR lpCommand);
        virtual WORD  InterpretLine(LPCSTR lpLine);

        // Log functions
        virtual void PutLog(WORD wClass,LPCBYTE lpByte,short nSize);
        virtual void PutLog(WORD wClass,WORD  wData);
        virtual void PutLog(WORD wClass,DWORD wData);
        virtual void PutLog(WORD wClass,LPCSTR lpStr);
        virtual void CommitLog();

        // Access CommPort
        virtual long    SendFaxEvent (TEFaxEvent Event, LPARAM lParam);
        virtual BOOL    SetModemCapability(TSModemCapabiliti  &ModemCap );
        virtual BOOL    SetCurrentSession(TSSessionParameters &CurSess );
        virtual BOOL    SetRemoteModemCapabiliti(TSModemCapabiliti  &ModemCap );
        virtual BOOL    GetCapabiliti(TSModemCapabiliti  &NewModemCap );
        virtual BOOL    GetModemCapabiliti(TSModemCapabiliti  &ModemCap );
		virtual BOOL    SetRemoteModemCapability(TSModemCapability  &ModemCap );
        virtual BOOL    GetCapability(TSModemCapability  &NewModemCap );
        virtual BOOL    GetModemCapability(TSModemCapability  &ModemCap );
        virtual void    LineError();

    virtual BOOL    SetPortStatus(TEModemStatus Status);
        virtual TEModemStatus   GetPortStatus( );
        virtual void    GetStationID(LPSTR lpBuffer,int iMax);

        virtual void   StartDataSend();
        virtual void   EndDataSend();
        virtual void   StartDataReceive();
        virtual void   EndDataReceive();
        virtual int        SetDSR(BOOL bDSR);



        // create Action controls
        virtual TMControl* mcInitialSetup();
        virtual TMControl* mcResetModem();
        virtual TMControl* mcAnswer() ;
        virtual TMControl* mcSendFax();
        virtual TMControl* mcWait();
        virtual TMControl* mcTerminate();



        virtual void    Terminate(TETerminationStatus TStatus);
        virtual TETerminationStatus GetTerminationStatus();
                // Fax document management

        //===================================
        // Fax document management functions
        //====================================
        // SendFax
        //====================================

        virtual void StartFaxSend();
        virtual void EndFaxSend();
        virtual void StartSendPage(int PageNo);
        virtual void EndSendPage(int LineNum=-1);
        virtual int  ReadPageData(LPBYTE lpBuffer,int iSize);

        virtual void StartSendDocument();
        virtual void EndSendDocument();
        virtual BOOL IsSendDocument() ;
        virtual BOOL IsNewSendDocument();
        virtual void StartNextDocument() ;

        // Page management
        virtual int                       GetCurrentPage();
        virtual int                       GetSendPages();
        virtual TEPostPageSignal GetPostPageSignal();
        virtual int                       SetPageStatus(int nPage,TEPageStatus  Code);
        virtual TEPageStatus  GetPageStatus(int nPage);
        virtual int           GetFaxParam(TSFaxParam far &Param);
        virtual int           GetLineNum(int PageNo) ;
        virtual DWORD             GetSize(int PageNo);
        virtual void              SendMonoPages();

        //====================================
        // ReceiveFax
        //====================================
        virtual void  StartFaxReceive();
        virtual void  StartReceiveNextDocument();//rz 02-16-99
        virtual void  EndFaxReceive();
        virtual void  EndReceiveOneDocument();//rz 02-16-99
        virtual void  StartReceiveDocument();
        virtual void  EndReceiveDocument();
        virtual void  StartReceivePage(int nPage);
        virtual void  EndReceivePage(int LineNum);
        virtual void  WritePageData(LPBYTE lpBuffer,int nSize);

        virtual BOOL  IsReceiveDocument() ;

        // DTMF management
        virtual  int    SetVoiceFile( LPSTR lpFileName );
        virtual  int    GetVoiceFile( LPSTR lpBuffer, int Max );
        virtual  int    SetVoiceTimeout( unsigned int WaitTime );
        virtual  unsigned int    GetVoiceTimeout();
        virtual  int    GetDTMFDigits( LPSTR lpBuffer, int Max );
        virtual  int    SetDTMFDigits( int n, char Value );
        virtual void    SetDigitNumber( int n );
        virtual  int    GetDigitNumber();

        virtual void    SetRemoteID (LPSTR aRemoteID);

        virtual void    SendBinaryData(LPBYTE lpData,int nBytes);
        virtual void    EndBinarySend();

        virtual TETransmitPhase GetPhase();
        virtual void  SetPhase(TETransmitPhase Phase);

        virtual TRetCode Call(TMControl* lpControl);

                void SessionChanged();
protected:
        TCCommPort & Port();


protected:
        DWORD           dwStart ;
        TMControl       *Chain ;

        TCCommPort  *FPort ;
} ;


class CFAXAPI TMControls : public TMControl
{
    friend TCCommClassOneZero;
protected:
        typedef TRetCode (TMControls::*EndControl)();

        TMControl  ** Code    ;
        BYTE       *CodeType  ;
        EndControl *Check    ;

        int         Max ;
        int         nCtrs ;
        int         Cur ;
        BOOL        bDeleteControls ;
        BYTE        Run:1 ;
public:
        EXPDEF TMControls(int MaxNum=64);
        EXPDEF ~TMControls();
        void    EXPDEF   SetPort(TCCommPort &Port );
        int             EXPDEF   Append(TMControl * tControl) ;
        int             EXPDEF   Append(TMControl & tControl) ;
protected:
        int               Append(TMControl * tControl,EndControl CtrlCheck) ;
        int               Append(TMControl & tControl,EndControl CtrlCheck) ;
        virtual BOOL      IsCodeEnd();
protected:

        TRetCode  EventHandler(int Event ,DWORD Param1 , DWORD Param2  );
        TRetCode  ProcessEvent(int Event ,DWORD Param1 , DWORD Param2  );
        TRetCode  on_Start();
        TRetCode  on_ChainError();

        virtual TRetCode on_Next();
        virtual TRetCode on_CodeEnd();
        virtual TRetCode Jump(TMControl* lpCode);
        virtual TRetCode Exit();

        virtual TRetCode on_End();
        virtual TRetCode on_Terminate();

} ;
#pragma pack()

#endif
