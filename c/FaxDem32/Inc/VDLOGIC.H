#ifndef DIALOGIC_MODEM_INCLUDED
#define DIALOGIC_MODEM_INCLUDED

#ifdef  _DIALOGIC_VOICE

    #include        "srllib.h"
    #include        "dxxxlib.h"
    #include        "gclib.h"
    #include        "gcerr.h"
    #include        "faxlib.h"
    #include        "VDlgRcMng.h"
    #include        "time.h"

    #define NUM_CHANNELS_D160 16
    #define NUM_CHANNELS_D240 24
    #define NUM_CHANNELS_D320 32

extern long __cdecl GCChannelHandler( DWORD param );

class VCBoardInfo;
class VCChannelInfo;


class   TCDialogicModem : public TCModemClass
{
    friend  DWORD WINAPI ChannelThread( LPVOID param );
    friend  long __cdecl ChannelHandler( DWORD param );
    friend  long __cdecl GCChannelHandler( DWORD param );
public:
    TCDialogicModem(int nType);
    TCDialogicModem();
    ~TCDialogicModem();

    static  void InitDialogic();
    static  void ExitDialogic();
    static  int  GetChannelType( int board, int nChannel, PSTR pBuf, int len );
    static  int  GetChannelNum( int board );
    static  int  IsFaxBoard( int board );
    static  int  GetBoardNum() { return m_BoardNr;};
    static  TEChannelState GetChannelState( int board, int nChannel );
    static  int  GetAllChannelNum();
    static  int  GetIndex( int board, int nChannel );
    static  int  GetDTIName( int board, int nChannel, LPSTR dti );
    int          GetVoiceHandle() { return m_VoiceHandle;};
    int          GetLineHandle() { return m_LineHandle;};
    int          GetMSIHandle() { return m_MSIHandle;};


    long         GetCurrentPlaybackByteOffset(){return m_lByteOffset;}
    void         SetCurrentPlaybackByteOffset(long lOffset){m_lByteOffset = lOffset;}

    bool    OpenPort(const char *pszPort);
    bool    IsOpen();

    int     AttachVoiceResource(CSCBusResource* pRes);
    int     AttachLineInterfaceResource(CSCBusResource* pRes);
    int     AttachFaxResource(CSCBusResource* pRes);
    int     AttachMSIResource(CSCBusResource* pRes);
    int     DetachVoiceResource(CSCBusResource* pRes);
    int     DetachLineInterfaceResource(CSCBusResource* pRes);
    int     DetachFaxResource(CSCBusResource* pRes);
    int     DetachMSIResource(CSCBusResource* pRes);

    void    ClosePort();
    bool    IsPortUsed();
    bool    InitializeModem(BOOL bReset = TRUE);
    void    DestroyModemObject();

    long    ConnectVoicePort(LPCTSTR FaxName,LPCTSTR IniFile);
    void    DisconnectVoicePort(bool bVoiceMode = true);
    bool    EnterVoiceMode();
    bool    EnterFaxMode();
    bool    SetFaxSendMode(int nClassMode);
    bool    SetFaxReceiveMode(int nClassMode);
    bool    SendFaxNow(long Fax);
    bool    ReceiveFaxNow();

    bool    DialInVoiceMode(const char *pszNumber, int nTime, BOOL bOffHook = TRUE);
    BOOL    SetHook(BOOL bOffHook);
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
    bool    PlayVoiceExt2(PVOICEINFOEXT2 pVoiceInfo);
    bool    RecordVoiceExt(PVOICEINFOEXT pVoiceInfo);
    bool    RecordVoiceExt2(PVOICEINFOEXT pVoiceInfo);
    bool    TestVoiceCapabilities();
    bool    GenerateToneSignalExt(int firstFreq, int secondFreq, int nAmplitude1, int nAmplitude2, int duration, int device);
    BOOL    GenerateToneSignalExtDTMF(int firstFreq, int secondFreq, int nAmplitude1, int nAmplitude2, int duration, int device, int DTMFNum);
    bool    TransferInboundCall(const char *pszNumber, BOOL bTransFlag, BOOL bDialTone, int nToneTime, char* szFlash, char* szCancel);
    bool    BlindTransferInboundCall(const char *pszNumber, BOOL bTransFlag, BOOL bDialTone, int nToneTime, char* szFlash, char* szCancel);

    bool    SetDIDDigitNumber(int nDigitNumber) {return false;};
    bool    GetDIDDigits(LPSTR szDigitBuffers) {return false;};
    bool    SetDefVoiceParams(MDF_DATAFORMATS DataFormat,MSR_SAMPLING_RATES SamplingRate);

    bool    GetCallerID(PTSCallerIDData CallerIDInfo);


    BOOL    MSI_RingStation(BYTE RingNum);
    BOOL    MSI_RingStationEx(BYTE RingNum, long DistinctiveRingID);
    BOOL    MSI_RingStationCallerID(BYTE RingNum, long DistinctiveRingID, LPCSTR szCallerIDInfo);
    BOOL    MSI_EstablishConference(int MSIBoardHandle, int ResType, int ConfAttr, int ConfPartyAttr, int* ConfID);
    BOOL    MSI_AddToConference(int MSIBoardHandle, int ResType, int ConfID, int Attr);
    BOOL    MSI_RemoveFromConference(int MSIBoardHandle, int ResType, int ConfID);
    BOOL    MSI_SetConferencePartyAttr(int MSIBoardHandle, int ResType, int ConfID, int Attr);
    BOOL    MSI_GetConferencePartyAttr(int MSIBoardHandle, int ResType, int ConfID, int* Attr);
    BOOL    MSI_DeleteConference(int MSIBoardHandle, int ConfID);
    BOOL    MSI_GenerateZipTone();
    BOOL    MSI_SwitchMessageWaitingLight(BOOL On);
    BOOL    MSI_SetStationVolume(int VolChange);    

    int     MSI_ValidateConferenceAttr(int ConfAttr);
    int     MSI_ValidateConferencePartyAttr(int ConfPartyAttr);

    void    HandleError(long DevHandle, LPCSTR pszFailedFunctionName);

//SCBUS stuff
    static  int     SetResourceRoutingMode(int nMode = SCBUS_RESOURCE_ROUTING_AUTOMATIC);
    static  CVDlgRcMng* ResMng;
protected:
    void    InterpretLine(TEVoiceEvent event);
    int     InitialSetup();

    static  BOOL DetectDialogicHardware( BOOL bInit );

    void    LocalInit();
    void    StartThreads();
    void    SetReplies(REPLYITEM *replies);
    bool    ClearResponseBuffer();

    static  VCBoardInfo* m_pBoards;
    static  VCChannelInfo* m_pChannels;
    static  char m_caFaxLibVer[120];
    static  int m_BoardNr;
    static  int m_FaxChannelNr;


    int     m_nChannel;
    int     m_VoiceHandle;
    int     m_FaxHandle;
    int     m_LineHandle;
    int     m_MSIHandle;
    HANDLE  m_hWaitThread;
    DV_DIGIT dvt;
    
//SCBUS stuff
    static  int     m_nResourceRoutingMode;

    int     m_nConfID;
    int     m_nConfParty;
    long    m_lByteOffset;
    
};

#endif  // _DIALOGIC_VOICE
#endif  // DIALOGIC_MODEM_INCLUDED