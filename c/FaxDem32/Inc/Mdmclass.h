#ifndef MODEM_CLASS_H
#define MODEM_CLASS_H

#include        <stdio.h>
#include        <stdarg.h>

#include        "log.h"

#define MAX_COMMANDS_NUM        256     
#define MAX_REPLY_LEN           25
#define MAX_PARAM_SIZE          1024
#define ID_LEN                  20

#define M_UNKNOWN               "UNKNOWN"
#define M_ROCKWELL              "ROCKWELL"
#define M_USROBOTICS            "USROBOTICS"
#define M_DIALOGIC              "DIALOGIC"
#define M_BICOM                 "BICOM"
#define M_BROOKTROUT            "BROOKTROUT"
#define M_NMS                   "NMS"
#define M_LUCENT	            "LUCENT"
#define M_CIRRUSLOGIC           "CIRRUSLOGIC"
#define M_CONEXANT_HCF          "CONEXANTHCF"
#define M_GC_DIALOGIC           "GCDIALOGIC"

#define ASCII_BEL       0x07
#define ASCII_BS        0x08
#define ASCII_LF        0x0A
#define ASCII_CR        0x0D
#define ASCII_XON       0x11
#define ASCII_XOFF      0x13

extern long Wav8Hdr[12];
extern long Wav11Hdr[12];
//
//      Modem Shielded Commands
//
#define MDM_ENTER                       "\xd\xa"
#define MDM_DLE                         "\x10"
#define MDM_ETX                         MDM_DLE"\x3"
#define MDM_ANSWER_TONE                 MDM_DLE"a"
#define MDM_BUSY                        MDM_DLE"b"
#define MDM_CALLING_TONE                MDM_DLE"c"
#define MDM_DIAL_TONE                   MDM_DLE"d"
#define MDM_EDMCT                       MDM_DLE"e"
#define MDM_BAT                         MDM_DLE"f"      // Bell Answer Tone
#define MDM_ONHOOK                      MDM_DLE"h"
#define MDM_OVERRUN                     MDM_DLE"o"      // Overrun
#define MDM_RING	                    MDM_DLE"R"      
#define MDM_QUIET                       MDM_DLE"q"
#define MDM_SILENCE                     MDM_DLE"s"
#define MDM_OFFHOOK                     MDM_DLE"t"
#define MDM_OFFHOOK_LUCENT              MDM_DLE"h"
#define MDM_ONHOOK_LUCENT               MDM_DLE"H"
#define MDM_UNDERRUN                    MDM_DLE"u"      // Underrun
#define MDM_TIMING_MARK                 MDM_DLE"T"
#define MDM_DTMF_0                      MDM_DLE"0"
#define MDM_DTMF_1                      MDM_DLE"1"
#define MDM_DTMF_2                      MDM_DLE"2"
#define MDM_DTMF_3                      MDM_DLE"3"
#define MDM_DTMF_4                      MDM_DLE"4"
#define MDM_DTMF_5                      MDM_DLE"5"
#define MDM_DTMF_6                      MDM_DLE"6"
#define MDM_DTMF_7                      MDM_DLE"7"
#define MDM_DTMF_8                      MDM_DLE"8"
#define MDM_DTMF_9                      MDM_DLE"9"
#define MDM_DTMF_HASH                   MDM_DLE"#"
#define MDM_DTMF_STAR                   MDM_DLE"*"
#define MDM_DTMF_START                  MDM_DLE"/"
#define MDM_DTMF_STOP                   MDM_DLE"~"
#define MDM_CUSTOM_TONE                 MDM_DLE"@"
#define MDM_MSI_EVENT                   MDM_DLE"&"
#define MDM_GC_EVENT                    MDM_DLE"("

//
//      Standard Voice Commands
//
#define VC_VOICE_LINE                   "AT#VLS=%d"MDM_ENTER
#define VC_LUCENT_VOICE_LINE            "AT+VLS=%d"MDM_ENTER
#define VC_CIRRUS_VOICE_LINE            "AT+VLS=%d"MDM_ENTER
#define VC_HCF_VOICE_LINE               "AT+VLS=%d"MDM_ENTER
#define VC_ATTENTION                    "AT"MDM_ENTER
#define VC_HANGUP                       "ATH"MDM_ENTER
#define VC_RECEIVEFAX                   "ATA"MDM_ENTER
#define VC_ANSWER                       "ATA"MDM_ENTER

#define WRONG_RESPONSE(error,response)  (error | response << 16)

typedef struct
{
    const char              *szReply;
    TEVoiceEvent            nMessage;
}REPLYITEM;

typedef struct
{
    int     nFirstFreq;
    int     nSecondFreq;
    int     nDuration;
    int     nDevice;
    int     nAmp1;
    int     nAmp2;
}GENERATETONE;

#define VOCFILE_ID_UNKNOWN                      0xffffffff
#define VOCFILE_ID                              0x19730731
#define COMPRESSION_ID_LENGTH   50
typedef struct
{
    char    szCompiID[COMPRESSION_ID_LENGTH];
    char    cVBS;                   
    BOOL    bWAV;                   
    int     cDataFormat;    
    int     cSamplePerSec;  
}VOCFILEINFO;

typedef struct
{
    long            lVocID;        
    long            lCreateTime;
    unsigned long   lVersion;      
    long            lStructSize;   
}VOCFILEMAINSTR;

#define VOC_COMPID(a)   (a).szCompiID
#define VOC_VBS(a)      (a).cVBS
#define VOC_WAV(a)      (a).bWAV
#define VOC_ID(a)       (a).lVocID
#define VOC_VERSION(a)  (a).lVersion
#define VOC_SIZE(a)     (a).lStructSize
#define VOC_CREATE(a)   (a).lCreateTime
#define VOC_DATAF(a)    (a).cDataFormat
#define VOC_SAMPLE(a)   (a).cSamplePerSec

//      class prototypes
class   TCReply;
class   CVOICEAPI TCReplySeek;
class   TCBaseModemCommand;
class   CVOICEAPI TCModemClass;

// class declarations
class   TCReply
{
public:
    TCReply(REPLYITEM *pReply);
    ~TCReply(){};

    void    Init();
    bool    Process(char cRead);

    TCReply *pNext;
    char    szReply[MAX_REPLY_LEN];
    TEVoiceEvent    nMessage;
    int     nPos;
    int     nLen;
    bool    bStatus;
};

class TCReplySeek
{
public:
    TCReplySeek();
    ~TCReplySeek();

    void     Init();
    bool     SetReplies(REPLYITEM *replies);
    TCReply* Seek(char cRead);
    TCReply* Seek(TEVoiceEvent event); 

protected:
    TCReply* pReplies;
};

#ifdef  _DEBUG
    #define MAX_WAIT_TIME   10 * 1000
#else
    #define MAX_WAIT_TIME   10 * 1000
#endif

class   TCBaseModemCommand
{
public:
    enum
    {
        MCMD_NONE = 0, MCMD_FINISHED, MCMD_PROCESSED, MCMD_ERROR
    };

    TCBaseModemCommand(TCModemClass *modem, int time = MAX_WAIT_TIME, const void *param = NULL );
    virtual ~TCBaseModemCommand();

    virtual bool    Execute() = 0;
    virtual int     ProcessResponse(TCReply *reply);
    virtual int     RawData(unsigned char *lpszBuffer, int nLen);
    int             GetTimeOut();
    virtual bool    onTimeOut();   

    virtual bool    onError();     

    virtual bool    onTerminate(); 

    void    RestartTimer();


protected:

    DWORD   WriteComm(const char *lpBuffer, DWORD dwBytesToWrite);
    void    SetLineState(bool state);
    void    SetHangUp(bool hangup);
    void    SetVoiceLine(MDM_DEVICE nLine);
    int     GetSelectedLine();

    inline  void    InitComm();
    inline  void    SetWriteTrace(bool bTrace);
    inline  void    SetReadTrace(bool bTrace);
    inline  void    SendModemEvent(TEVoiceEvent Event);
    inline  void    SetModemError(int error, int param = 0);
    inline  int     GetVoiceHandle();
    inline  void    DisplayVoiceInfo();
    inline  void    DisplayVoiceInfo2();

    TCReply*        FindReply(unsigned char *lpszBuffer, int nLen, int &nIndex, TEVoiceEvent event = MEV_NO_RESPONSE);
    int             SetCommPortEx (UINT Baudrate, BOOL XonOut,BOOL XonIn , BOOL Dsr, BOOL Cts);
    void    SetStartTime();
    bool    bTerminated;
    int     nProgressStatus;
    char    szParam[MAX_PARAM_SIZE];
    int     nParam;
    int     nTime;
    TCModemClass    *Modem;
    HANDLE          hTerminate;
};

#define MODEM_CMD_LENGTH   64

class   TCModemClass
{
    friend  void    BaseModemThread(void *lpParam);
    friend  class   TCBaseModemCommand;
    friend  void    Modem_StartReadThread( void *lpParam);
    friend  void    Modem_BigReadThread(void *lpParam);
    friend  void    DisplayVoiceFileInfo(MODEMOBJ Modem, VOCFILEMAINSTR &vocFile, VOCFILEINFO &vocInfo);
    friend  class   TCNMSAnswer;


    HWND    hWindow;        

protected:
    TCModemClass(int nType);

public:
    enum
    {
        MM_DATA = 0, MM_COMMAND
    };

    virtual         ~TCModemClass();

    LPCSTR          GetModemTypeStr();
    int             GetModemType();
    void            SetVoiceMessage(HWND hWnd);

    virtual bool    OpenPort(const char *pszPort) = 0;
    virtual bool    ConnectPort(HANDLE hHandle,const char *pszPort);
    virtual bool    IsOpen() = 0;
    virtual void    ClosePort() = 0;
    virtual bool    InitializeModem(BOOL bRetVal = TRUE) = 0;
    virtual bool    IsPortUsed();
    virtual void    DestroyModemObject() = 0;

    void    SetModemLong(long dwNewLong);
    long    GetModemLong();

    void    ReOpenLog();
    void    EnableLog(BOOL bEnable);
    void    SetLogDir(LPCSTR lpStr);

    LPCSTR  GetPortName();

    virtual bool    SetSpeakerVolume(int volume);
    virtual int     GetSpeakerVolume();


    virtual bool    DialInVoiceMode(const char *pszNumber, int nTime, BOOL bOffHook = TRUE) = 0;
    virtual BOOL    SetHook(BOOL bOffHook);
    virtual bool    Answer() = 0;
    virtual bool    OnlineAnswer() = 0;
    virtual bool    WaitForRings(int nNumOfRings);          // -1 -> do not send message on RING
    // 0 -> sends message on every RING
    virtual long    ConnectVoicePort(LPCTSTR FaxName, LPCTSTR IniFile) = 0;
    virtual void    DisconnectVoicePort(bool bVoiceMode = true) = 0;
    long    GetFaxPort();

    virtual bool    EnterVoiceMode() = 0;
    virtual bool    EnterFaxMode() = 0;
    virtual bool    SetFaxSendMode(int nClassMode) = 0;
    virtual bool    SetFaxReceiveMode(int nClassMode) = 0;
    virtual bool    SendFaxNow(long Fax) = 0;
    virtual bool    ReceiveFaxNow() = 0;

    void    ResetRingCounter();
    virtual bool    HangUp() = 0;
    virtual bool    EnableDTMF() = 0;
    virtual bool    DisableDTMF() = 0;
    virtual bool    WaitForDTMF(PDTMFINFO DTMFInfo, UINT unTime) = 0;
    virtual bool    SendDTMF(PDTMFINFO DTMFInfo) = 0;
    virtual void    GetReceivedDTMF(PDTMFINFO DTMFInfo);
    virtual long    GetCurrentPlaybackByteOffset(){return false;}
    virtual bool    PlayVoice(PVOICEINFO pVoiceInfo) = 0;
    virtual bool    RecordVoice(PVOICEINFO pVoiceInfo) = 0;
    virtual bool    PlayVoiceExt(PVOICEINFOEXT pVoiceInfo) = 0;
    virtual bool    PlayVoiceExt2(PVOICEINFOEXT2 pVoiceInfo) {return false;}
    virtual bool    RecordVoiceExt(PVOICEINFOEXT pVoiceInfo) = 0;
    virtual bool    RecordVoiceExt2(PVOICEINFOEXT pVoiceInfo){return false;}
    virtual bool    TestVoiceCapabilities() = 0;
    virtual void    GetTestResult(TSVoiceTestResult *pTest);
    virtual bool    GenerateToneSignal(int firstFreq, int secondFreq, int duration, int device);
    virtual bool    GenerateToneSignalExt(int firstFreq, int secondFreq, int nAmplitude1, int nAmplitude2, int duration, int device) = 0;
    virtual BOOL    GenerateToneSignalExtDTMF(int firstFreq, int secondFreq, int nAmplitude1, int nAmplitude2, int duration, int device, int DTMFNum);
    virtual bool    TransferInboundCall(const char *pszNumber, BOOL bTransFlag, BOOL bDialTone, int nToneTime, char* szFlash, char* szCancel)=0;
    virtual bool    BlindTransferInboundCall(const char *pszNumber, BOOL bTransFlag, BOOL bDialTone, int nToneTime, char* szFlash, char* szCancel){return false;}

    virtual bool    SetHandsetAsLine(){ return false;};    // This function supported by USR only.

    virtual void    TerminateWait();        // terminates only the current wait state
    DWORD   GetLastError();
    virtual void    OnHook(bool OnHook);
    virtual bool    IsOnHook();

    void    SetMode(bool mode);     // raw data or command mode
    bool    GetLineState();


    void    TraceMsg(const char *pszFormat, ...);
    void    PutLog(unsigned short unClass, const char *pszFormat, ...);
    void    SetID(const char *pszID);
    int     GetSelectedLine();

    virtual bool    SetDIDDigitNumber(int nDigitNumber) = 0;
    virtual bool    GetDIDDigits(LPSTR szDigitBuffers) = 0;

    virtual bool    SetSilenceDetectionParams(enum MSD_SILENCEDETECTION Silence, int nMaxSilenceTime);
    virtual bool    SetDefVoiceParams(MDF_DATAFORMATS DataFormat,MSR_SAMPLING_RATES SamplingRate) = 0;
    virtual bool    SetFaxDetectionTimeout(int nMaxFaxDetectionTime);


    int     nSilenceDetection;
    int     nMaximumSilenceTime;
    int     nFaxDetectionTimeout;
    int     GetNrRings(){return nRingStatus;}

    TSReceivedVoiceData* m_hReceivedData;
    BOOL    m_bPartialVoiceData;
    virtual TSReceivedVoiceData*    GetReceivedVoiceData(){return m_hReceivedData;}
    virtual void    EnablePartialVoiceDataReporting(BOOL bEnable) {m_bPartialVoiceData = bEnable;}
    virtual void    DestroyPartialVoiceData();

    virtual bool    GetCallerID(PTSCallerIDData CallerIDInfo);
    virtual bool    GetANI(LPSTR buffer, long BufferSize);
    bool    SetParameters(DWORD dwOption, BOOL bValue);
    bool    GetParameters(DWORD dwOption);

    virtual BOOL    CreateSingleFrequencyTone(unsigned int ToneID,  TSSingleToneTemplate ToneDef);
    virtual BOOL    CreateDualFrequencyTone  (unsigned int ToneID,  TSDualToneTemplate   ToneDef);
    virtual BOOL    CreateSingleFrequencyToneCadence(unsigned int ToneID,  TSSingleToneCadenceTemplate ToneDef);
    virtual BOOL    CreateDualFrequencyToneCadence  (unsigned int ToneID,  TSDualToneCadenceTemplate   ToneDef);


    virtual bool    ParseCallerIDData(const char *lpBuffer, DWORD dwLen);

    virtual LPCSTR  GetVoiceFormatCommand(){return m_szVoiceFormat_Command;}
    virtual BOOL    GetVoiceFormatCommand(LPSTR Buffer, DWORD BufferLenght);
    virtual BOOL    SetVoiceFormatCommand(LPCSTR ModemCommand);
    
    virtual LPCSTR  GetCallerIDCommand(){return m_szCallerID_Command;}
    virtual BOOL    GetCallerIDCommand(LPSTR Buffer, DWORD BufferLenght);
    virtual BOOL    SetCallerIDCommand(LPCSTR ModemCommand);
    
    virtual BOOL    SetModemCommand(DWORD CommandID, LPCSTR ModemCommand);
    virtual BOOL    GetModemCommand(DWORD CommandID, LPSTR Buffer, DWORD BufferLenght);


    virtual BOOL    MSI_RingStation(BYTE RingNum);
    virtual BOOL    MSI_RingStationEx(BYTE RingNum, long DistinctiveRingID);
    virtual BOOL    MSI_RingStationCallerID(BYTE RingNum, long DistinctiveRingID, LPCSTR szCallerIDInfo);
    virtual BOOL    MSI_EstablishConference(int MSIBoardHandle, int ResType, int ConfAttr, int ConfPartyAttr, int* ConfID);
    virtual BOOL    MSI_AddToConference(int MSIBoardHandle, int ResType, int ConfID, int Attr);
    virtual BOOL    MSI_RemoveFromConference(int MSIBoardHandle, int ResType, int ConfID);
    virtual BOOL    MSI_SetConferencePartyAttr(int MSIBoardHandle, int ResType, int ConfID, int Attr);
    virtual BOOL    MSI_GetConferencePartyAttr(int MSIBoardHandle, int ResType, int ConfID, int* Attr);
    virtual BOOL    MSI_DeleteConference(int MSIBoardHandle, int ConfID);
    virtual BOOL    MSI_GenerateZipTone();
    virtual BOOL    MSI_SwitchMessageWaitingLight(BOOL On);
    virtual BOOL    MSI_SetStationVolume(int VolChange);

    bool    InitializeVOCFile(FILE*& outFile, VOICEINFOEXT* pVoiceInfo);
    bool    UpdateWAVHeader(FILE* outFile);
    bool    CheckVoiceFile(FILE*& inFile, VOICEINFOEXT* pVoiceInfo, VOCFILEMAINSTR& vocFile, VOCFILEINFO&  vocInfo, int& nFileLength, bool& bTerminated);
    BOOL    bValidStruct2;
protected:
    virtual bool    WasVoiceFormatCommandChanged(){return false;}
    virtual long    GetDefaultSamplingRate();    
    
    char                            szTraceBuffer[SIZE_QUEUE];
    int                             nIDLen;
    HANDLE                          hDebugEvent;
    bool                            bReadTrace;
    bool                            bWriteTrace;
    bool                            bClosePort;

    TCVLog                          Log;
    TCVLogFile                      ErrorLog;
    BOOL                            bLogEnabled;

    bool                            bStopWait;
    bool                            bHangUp;
    int                                     nModemType;
    MDM_DEVICE                      nVoiceLine;
    long                            pPortFax;
    bool                            bLineReleased;          // if #VLS=0 && (last command == atd || ath || atz) then
    // ata command is required or modem to get back the line

    HANDLE                          hMutex;
    HANDLE                          hExecSema;              // Incremented if there's a new modem command
    HANDLE                          hThreadID;              // handle of the BigModemThread() thread
    HANDLE                          hCmdFinished;           // Set if modem command is running
    // Modem command handlers and
    REPLYITEM                       *pReplies;
    bool                            bCommandEnable;
    TCBaseModemCommand              *pCommands[MAX_COMMANDS_NUM];
    TCBaseModemCommand* volatile    pActCmd;
    int     volatile                nFirstCommand;
    int                             nLastCommand;
    DWORD                           dwStartTime;            // command start time
    int                             nRingCounter;
    int                             nRingStatus;            // -1   - no message on RING
    DWORD                           dwLastRingTime;         // 0    - MEV_RING message on every RING detected
    DWORD                           dwError;                // last error code in the loword, param in the hiword
    int                             nSpkLevel;              // 0 - off, 1 - low, 2 - normal, 3 - load

    virtual void            SendModemEvent(TEVoiceEvent Event);
    inline  void            SetModemError(int error,int nParam = 0);


    virtual DWORD           WriteComm(const char *lpBuffer, DWORD dwBytesToWrite);

    void                    SetStartTime(bool bEnd = true);
    virtual void            SetReplies(REPLYITEM *replies) = 0;
    void                    FreeModemCommands();
    bool                    Execute(TCBaseModemCommand *command);

    virtual void            LocalInit();
    virtual void            StartThreads();
    void                    BigModemThread();
    void                    BigReadThread();
    HANDLE                  hReadEvent;

    virtual BOOL            SetCommPortEx (UINT Baudrate, BOOL XonOut,BOOL XonIn , BOOL Dsr, BOOL Cts);

    virtual void            BigWaitThread();
    int                     ReadCommBlock( LPSTR lpszBlock, int nMaxLength );

    virtual void            DestroyCurrentCommand();
    virtual void            InitComm();
    virtual void            InterpretLine(BYTE *lpszBuffer, int nLen);
    void                    DisplayVoiceInfo();
    void                    DisplayVoiceInfo2();

    bool    bMode;                                          // raw data or command mode
    char    szPort[MAX_PATH];
    BYTE    CommReadBuffer[SIZE_QUEUE];
    char    szWriteBuffer0[SIZE_QUEUE];
    char    szWriteBuffer1[SIZE_QUEUE];
    char    szReadBuffer[SIZE_QUEUE];
    BYTE    szReplyBuffer[SIZE_QUEUE];
    int     nReplyIndex;
    TCReplySeek     ReplySeek;

    bool            bPortTerminated;

    HANDLE          hDeviceID;
    HANDLE          hWriteEvent;
    OVERLAPPED      Os,OsRead,OsWrite;
    HANDLE          hReadThread,hTimeOutThread;
    COMSTAT         cs;
    bool            bOnHook;

    TSVLineStatus           LineStatus;
    TSVCommSetting          PortSet;
    VOICEINFOEXT            stVoiceInfo;
    VOICEINFOEXT2           stVoiceInfo2;
    
    TSVoiceTestResult   stTestResult;

    long                    lModemExtra;    // applications can store any data in this long

    DWORD     m_dwDIDDigitNum;
    char      m_szDIDDigits[256];

    DWORD m_DefDataFormat;
    DWORD m_DefSamplingRate;

    DWORD m_dwFlags;

    char  m_szCallerID_NAME[MODEM_CMD_LENGTH];
    char  m_szCallerID_TIME[MODEM_CMD_LENGTH];
    char  m_szCallerID_NMBR[MODEM_CMD_LENGTH];
    char  m_szCallerID_DATE[MODEM_CMD_LENGTH];
    char  m_szCallerID_MESG[MODEM_CMD_LENGTH];
    char  m_szCallerID_Command[MODEM_CMD_LENGTH];
    char  m_szVoiceFormat_Command[MODEM_CMD_LENGTH];
    TSCallerIDData  m_sCallerId;
    bool  m_bWaitForCallerID;
};

inline  void    TCModemClass::SetModemError(int error,int nParam)
{
    dwError = (error & 0xffff) | (nParam << 16);
}

inline  void    TCBaseModemCommand::SetWriteTrace(bool bTrace)
{
    Modem->bWriteTrace = bTrace;
};

inline  void    TCBaseModemCommand::SetReadTrace(bool bTrace)
{
    Modem->bReadTrace = bTrace;
};

inline  void    TCBaseModemCommand::SendModemEvent(TEVoiceEvent Event)
{
    Modem->SendModemEvent(Event);
}

inline  void    TCBaseModemCommand::SetModemError(int error,int param)
{
    Modem->SetModemError(error,param);
}

int     TCBaseModemCommand::GetVoiceHandle()
{
    return(int)Modem->hDeviceID;
}


void TCBaseModemCommand::InitComm()
{
    Modem->InitComm();
};

void    TCBaseModemCommand::DisplayVoiceInfo()
{
    Modem->DisplayVoiceInfo();
}

void    TCBaseModemCommand::DisplayVoiceInfo2()
{
    Modem->DisplayVoiceInfo2();
}

#endif 