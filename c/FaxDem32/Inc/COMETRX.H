#ifndef  __cplusplus
    #error  "This include file must be used with C++ compiler!"
#endif  // __cplusplus

#ifndef __COMETRX_H
#define __COMETRX_H


extern "C" {
#pragma pack(8)
    #include "mseries.h" 
#pragma pack()
}
#include "commcl.h"




class CCommetrexTest
{
public:
	EXPDEF CCommetrexTest();

	int   TestChannel( int nCh, TSTestResult *datas );
};

///////////////////////////////////////////////////////////////////////////////
class CCommetrexChannelInfo
{
public:
    CCommetrexChannelInfo();
    CCommetrexChannelInfo(DWORD dwChannelNum, DWORD dwID, LPCSTR pName );
	void    InitChannel(int iBoard, int iChannelNum, char *pcName, TEChannelState State);
    DWORD   GetChannelNum() { return m_dwChan; }
    void    SetChannelNum( DWORD dwChannel ) { m_dwChan = dwChannel; }
    int     SetState(TEChannelState newState);
    void    SetDeviceID( DWORD DeviceId ) { m_dwDeviceId = DeviceId; };
    DWORD   GetDeviceID() { return m_dwDeviceId; };
    TEChannelState GetState() { return m_State; };

    CCommetrexChannelInfo* m_pNext;
    CHAR	m_szDeviceName[15];

protected:
    int 	m_dwDeviceId;
    int 	m_dwChan;
    TEChannelState m_State;               // Current state of this channel

};

typedef CCommetrexChannelInfo* PCCommetrexChannelInfo;




class FAXAPI TCCommClassCommetrex : public TCCommPure
{
    friend class TCFaxNormal;

public:
    EXPDEF TCCommClassCommetrex();
    virtual EXPDEF ~TCCommClassCommetrex();
    static PORTFAX CALLBACK CreateTCCommClass(LPSTR FaxShortName, LPSTR FileName);
    static void  InitCommetrex();
    static void  ExitCommetrex();

    static  int GetChannelNum() {return m_FaxChannelNr; };
    static  int GetBoardNum()   {return m_BoardNr; };
    static  TEChannelState GetChannelState(int nChannel);

    int GetNrOfRings(){return dwNrRings;}
    virtual int  ConnectPort( LPSTR pPortName, HANDLE );
    virtual int DisconnectPort();    
    virtual int DisconnectPortEx(BOOL bDSR);    
    MFCHD GetFaxHandle(){return m_FaxHandle;}

    FAXOBJ EXPDEF AbortFax();
    
    virtual void EXPDEF AutoAnswer( int RingNum=3 );
    virtual int EXPDEF AnswerNow( BOOL Manual=TRUE );

    virtual  void SetDigitNumber( int n );
    virtual  int SetDTMFDigits( int n, char Value );
    virtual  int GetDTMFDigits( LPSTR lpBuffer, int Max );
    int SetDigitTimers(int first, int next);
    void GetDID( LPSTR dstBuf );

    bool SubmitFaxes();
    bool ReceiveFax();
    TETerminationStatus CallStatus;
    TETerminationStatus ConvertTermCode(int code);
    TETerminationStatus ConvertStatusCode(int code);
    bool    m_bSending;
    bool    m_bReceiving;

    bool    m_bStopWait;
    HANDLE  m_hWaitThread;
    HANDLE  m_hSendThread;
    HANDLE  m_hSendNow;
    HANDLE  m_hReceiveNow;

    BOOL OutOfService;
protected:    
    static BOOL DetectCommetrexHardware();
    PCCommetrexChannelInfo SearchChannel( LPCSTR pPortName );
    static LONG InitializeChannel( DWORD dwChan, PCCommetrexChannelInfo *pCHAN );
    static LONG CountAllChanOnBoard( DWORD dwChanNum, PCCommetrexChannelInfo *pHEAD );
    
    virtual int InitialSetup();
    
    BOOL StartReceivePage();
    BOOL EndReceivePage();
    int EXPDEF  SendFax( FAXOBJ aFax, BOOL Manual );
    BOOL EXPDEF StartSend();
    
    int PhaseD();
    void Call();
    void Answer();

    void StopWait();   
    

    void EXPDEF Terminate(TETerminationStatus inTStatus);

    MFC_DOC_PARMS* ConvertDocParams(MFC_DOC_PARMS* parms);
    MFC_TRANSMIT_PARMS* ConvertTransmitParams(MFC_TRANSMIT_PARMS* parms);
    
    int     m_nActPage;  // zero based page counter
    
    PCCommetrexChannelInfo m_pChannel;
    static int m_BoardNr;
    static int m_FaxChannelNr;
    static PCCommetrexChannelInfo m_pChannels;
    
    TETransmitPhase Phase;
    MFCHD   m_FaxHandle;
    DWORD   dwNrRings;

    char* m_pDigits;
    int NrOfDigits;
    int m_nFirstDigitTimeOut;
    int m_nNextDigitTimeOut;

    
    HANDLE  m_hSendFinished;
    HANDLE  m_hWaitStarted;
    HANDLE  m_hRingThread;

};


#endif