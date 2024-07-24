
#ifndef  __cplusplus
    #error  "This inlude file must be used with C++ compiler!"
#endif  // __cplusplus

#ifndef __BICOM_H
#define __BICOM_H



#define SENDING     1
#define RECEIVING   2
#define FINISH      3



#include "commcl.h"

///////////////////////////////////////////////////////////////////////////////
static int m_nDeviceID;
#define BFXINT int
class FAXAPI TCCommClassBicom : public TCCommPure
{
    friend class TCFaxNormal;
	friend int WaitForCall();

public:
    static PORTFAX CALLBACK CreateTCCommClass(LPSTR FaxShortName, LPSTR FileName);
        EXPDEF TCCommClassBicom();
    virtual EXPDEF ~TCCommClassBicom();

    char        m_szNum[MAX_CALLNUMBER];
    int         m_PageNo ;
    int         nRings;

    unsigned int GetVoiceHandle() { return m_VoiceHandle; };
    unsigned int GetFaxHandle()   { return m_FaxHandle;   };


    static void InitBicom();
    static void ExitBicom();
	
    static unsigned char* CheckBicom();

    static  int GetChannelType( int board, int nChannel, PSTR pBuf, int len );
    static  int GetChannelNum( unsigned int board );
    static  int GetBoardNum() { return m_BoardNr; };
    static  TEChannelState GetChannelState( int board, int nChannel);
    static  int GetAllChannelNum();

    virtual int ConnectPort( LPSTR PortName, HANDLE = NULL);
    virtual int DisconnectPort();
    virtual int DisconnectPortEx(BOOL bDSR);

    virtual void EXPDEF AutoAnswer( int RingNum=1 );
    virtual int EXPDEF AnswerNow( BOOL Manual=TRUE );

    TETerminationStatus TCCommClassBicom::ConvertTermCode(int code);
    virtual BOOL EXPDEF SetupPortCapabilities( TSModemCapabiliti &NewModemCap );
    virtual FAXOBJ EXPDEF AbortFax();
    virtual BOOL IsOpen();

    // DTMF
    virtual  void SetDigitNumber( int n );
    virtual  int SetDTMFDigits( int n, char Value );
    virtual  int GetDTMFDigits( LPSTR lpBuffer, int Max );
    virtual  int SetVoiceFile(LPCSTR File){strcpy(VoxFile,(LPSTR)File);return 0;}
    int SetDigitTimers(int first, int next);
    void GetDID( LPSTR dstBuf );
    virtual void SetStationID( LPCSTR lpBuffer );

	static void SetLineEventHandle(void *lpfnHandler);

    char VoxFile[MAX_PATH];
    char* m_pDigits;
    int NrOfDigits;
    int m_nFirstDigitTimeOut;
    int m_nNextDigitTimeOut;
    void WaitForDTMF();

    bool SubmitFaxes();
    bool ReceiveFax();

    int EndDocument();
    int PhaseD();

    int ConversionComplete();

    virtual BOOL StartReceivePage();
    virtual BOOL EndReceivePage();

    void    EXPDEF Terminate(TETerminationStatus TStatus);
    virtual int InitialSetup();
    virtual int ResetModem();


    virtual BOOL EXPDEF StartAnswer();
    virtual BOOL EXPDEF StartSend();
    virtual int  EXPDEF SendFax( FAXOBJ aFax, BOOL Manual=FALSE );

    int EXPDEF GetBicomStatus(struct BFX_FaxStatus* status);

    void SetActPage(int iPageNum){m_nActPage=iPageNum;}
    int  GetActPage(int iPageNum){return m_nActPage;}

    bool CheckBicom(unsigned char* path);

    HANDLE GetHSendFinished(){return m_hSendFinished;}
    long GetSendQueue(){return m_hSendQueue;}
    long GetReceiveQueue(){return m_hReceiveQueue;}
    TETerminationStatus CallStatus;

    int StartFax();

    bool    m_bStopWait;
    char PortName[256];

    HANDLE  m_hWaitThread;
    HANDLE  m_hSendThread;
    HANDLE  m_hSendNow;
    HANDLE  m_hReceiveNow;
    long    m_hSendQueue;
    long    m_hReceiveQueue;

protected:

    HANDLE  m_hConversionFinished;
    HANDLE  m_hSendFinished;
    HANDLE  m_hWaitStarted;

	static PVOID	lpfnEventHandler;
	static unsigned char szSuppPath[MAX_PATH];


    bool    m_bSending;
    bool    m_bReceiving;
    int     m_nActPage;  // zero based page counter
    PCBicomChannelInfo m_pChannel;
    unsigned int m_VoiceHandle;
    unsigned int m_FaxHandle;



    void    StopWait();
    static LONG    InitializeChannel( DWORD dwBoardNum, DWORD dwChan, PCBicomChannelInfo *pCHAN );
    static LONG    CountAllChanOnBoard( DWORD dwBoardNum, PCBicomChannelInfo *pHEAD );
    static bool EXPDEF DetectBicomHardware();
    PCBicomChannelInfo SearchChannel( LPCSTR pPortName );
    TEBaudRate ConvertSpeed( LPCSTR Rate );
    LPSTR ConvertSpeed( TEBaudRate Rate );

    void Call();


    static int m_BoardNr;
    static int m_FaxChannelNr;
    static PCBicomChannelInfo m_pChannels;


};

#endif
