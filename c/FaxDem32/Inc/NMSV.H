#ifndef NMS_MODEM_INCLUDED
#define NMS_MODEM_INCLUDED

#ifdef  _NMS_VOICE


    #define NMS_PORTNAME    "NMS_B"
    #define MAX_NMS_CHANNELS        128

    #include "nmstypes.h"
    #include "ctadef.h"
    #include "adidef.h"
    #include "nfxdef.h"
    #include "swidef.h"

typedef DWORD (* EVENT_CALLBACK) (CTA_EVENT * evptr, DWORD closure);
    #define EVENT_WAIT_TIMEOUT    30000
    #define TERMINATE_WAIT(event, expected, cbret) \
  (((event).id == expected)                 || \
   ((cbret) != 0))


struct NMS_CONNECT
{
    CTAHD m_ctahd;
    CTAQUEUEHD m_queueptr;
    HANDLE m_WaitMutex;
};


//#include "mdmclass.h"
class   TCNMSModem;

class CNmsChannelInfo
{
public:
    CNmsChannelInfo();
    CNmsChannelInfo(DWORD dwBoardNum, DWORD dwStreamNum, DWORD dwTimeSlotNum );
    DWORD   GetBoardNum() { return m_dwBoardNum;}
    void    SetBoardNum( DWORD dwBoardNum ) { m_dwBoardNum = dwBoardNum;}
    DWORD   GetStreamNum() { return m_dwStreamNum;}
    void    SetStreamNum( DWORD dwStreamNum ) { m_dwStreamNum = dwStreamNum;}
    DWORD   GetTimeSlotNum() { return m_dwTimeSlotNum;}
    void    SetTimeSlotNum( DWORD dwTimeSlotNum ) { m_dwTimeSlotNum = dwTimeSlotNum;}
    DWORD   GetChannelNum() { return m_dwTimeSlotNum;}
    void    SetChannelNum( DWORD dwTimeSlotNum ) { m_dwTimeSlotNum = dwTimeSlotNum;}
    int     SetState(TEChannelState newState);
    TEChannelState GetState() { return m_State;};

    CNmsChannelInfo* m_pNext;
    CHAR      m_szDeviceName[32];
    CHAR      m_szLongDeviceName[32];

protected:

    DWORD     m_dwBoardNum;
    DWORD     m_dwStreamNum;
    DWORD     m_dwTimeSlotNum;
    TEChannelState m_State;
};

typedef CNmsChannelInfo* PCNmsChannelInfo;


class   TCNMSModem : public TCModemClass
{
    friend void NMS_WaitForRingThread(void *lParam);
    friend class TCNMSHangup;
public:
    TCNMSModem();
    ~TCNMSModem();

    static bool InitNms();
    static void ExitNms();
    static  int GetChannelType( int board, int nChannel, PSTR pBuf, int len );
    static  int GetChannelNum( int board );
    static  int GetBoardNum() { return m_BoardNr;};
    static BOOL IsChannelFree( int board, int channel );
    static  int GetAllChannelNum();

    static PCNmsChannelInfo m_pChannels;
    static char m_szProtocol[256];
    static int  nAllChannels;
    static int  m_Channels[128];        

    static bool    IsQXsupported(){return m_QXsupport;};

    bool    OpenPort(const char *pszPort);
    bool    IsOpen();
    void    ClosePort();
    bool    IsPortUsed();
    bool    InitializeModem(BOOL bReset = TRUE);
    void    DestroyModemObject();

    CTAHD   GetVoiceHandle(){return m_ctahd;}
    CTAQUEUEHD GetQueueHandle(){return m_queueptr;} 

    unsigned long&  GetRingThreadID(){ return lWaitForRingThread;};
    HANDLE  GetRingHandle(){ return hWaitForRing;};

    void    SetConfigFile(const char *pszConfig);

    PCNmsChannelInfo  GetChannelInfo(){return m_pChannel;}

    long    ConnectVoicePort(LPCTSTR FaxName,LPCTSTR IniFile);
    void    DisconnectVoicePort(bool bVoiceMode = true);
    bool    EnterVoiceMode();
    bool    EnterFaxMode();
    bool    SetFaxSendMode(int nClassMode);
    bool    SetFaxReceiveMode(int nClassMode);
    bool    SendFaxNow(long Fax);
    bool    ReceiveFaxNow();

    bool    DialInVoiceMode(const char *pszNumber, int nTime, BOOL bOffHook = TRUE);
    bool    Answer();
    bool    OnlineAnswer();
    bool    WaitForRings(int nNumOfRings);

    bool    HangUp();
    bool    EnableDTMF();
    bool    DisableDTMF();
    bool    WaitForDTMF(PDTMFINFO pDTMFInfo, UINT unTime);
    bool    SendDTMF(PDTMFINFO pDTMFInfo);
    bool    PlayVoice(PVOICEINFO pVoiceInfo);
    bool    RecordVoice(PVOICEINFO pVoiceInfo);
    bool    PlayVoiceExt(PVOICEINFOEXT pVoiceInfo);
    bool    RecordVoiceExt(PVOICEINFOEXT pVoiceInfo);
    bool    TestVoiceCapabilities();
    bool    GenerateToneSignalExt(int firstFreq, int secondFreq, int nAmplitude1, int nAmplitude2, int duration, int device);
    bool    TransferInboundCall(const char *pszNumber, BOOL bTransFlag, BOOL bDialTone, int nToneTime, char* szFlash, char* szCancel);


    bool    SetDIDDigitNumber(int nDigitNumber);
    bool    GetDIDDigits(LPSTR szDigitBuffers);
    bool    SetDefVoiceParams(MDF_DATAFORMATS DataFormat,MSR_SAMPLING_RATES SamplingRate);

//switching functions
    bool    ConnectDSPToLineInterface   (TCNMSModem* Modem=NULL, int mode = QUAD );
    bool    ConnectLineInterfaceToDSP   (TCNMSModem* Modem=NULL, int mode = QUAD );
    bool    DisconnectLineInterfaceFromDSP(TCNMSModem* modem=NULL, int mode = QUAD );
    bool    DisconnectDSPFromLineInterface(TCNMSModem* modem=NULL, int mode = QUAD );

    bool    ConnectChannels(TCNMSModem* modem);
    bool    DisconnectChannels(TCNMSModem* modem);

    bool    GetCallerID(PTSCallerIDData CallerIDInfo);
    bool    GetANI(LPSTR buffer, long BufferSize);
protected:
    static BOOL DetectNmsHardware();
    PCNmsChannelInfo SearchChannel( LPCSTR pPortName );
    static LONG CountAllChanOnBoard( DWORD dwBardNum, PCNmsChannelInfo pHEAD );
    static BOOL OpenServices(CTAHD* ctahd, CTAQUEUEHD* queueptr, DWORD board, DWORD stream, DWORD timeslot, DWORD dwId, SWIHD* swihd);
    static BOOL CloseServices(CTAHD* ctahd, CTAQUEUEHD* queueptr, DWORD board, DWORD stream, DWORD timeslot, SWIHD* swihd);
    BOOL StartProtocol();


    int TIMESLOT();
    int STREAM();
    int BOARD();

    int     InterpretLine(TEVoiceEvent event);
    void    LocalInit();
    void    StartThreads();
    void    SetReplies(REPLYITEM *replies);
    bool    ClearResponseBuffer();

    SWIHD                   m_swihd;
    CTAHD                   m_ctahd;
    CTAQUEUEHD              m_queueptr;
    PCNmsChannelInfo        m_pChannel;

    static int              m_BoardNr;
    static int              m_FaxChannelNr;
    unsigned long           lWaitForRingThread;

    int                     m_nChannel;

    HANDLE                  m_hWaitThread;
    HANDLE                  hWaitForRing;
    static  bool            m_QXsupport;

};

#endif  // _NMS_VOICE

#endif
