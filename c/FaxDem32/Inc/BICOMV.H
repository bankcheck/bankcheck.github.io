#ifndef	BICOM_MODEM_INCLUDED
#define	BICOM_MODEM_INCLUDED

#ifdef	_BICOM_VOICE

// Bicom includes
extern "C" {
#include "bcmreg.h"
#include "Bcm32KMD.H"
#include "BCM32DLL.H"
#include "BICOMAPI.H"
}

    #define	BCM_PORTNAME	"BCM_MB"
    #define	MAX_BCM_CHANNELS	128

class   TCBicomModem;

enum GTDTONES
{
    GTD_DIAL = 0,
    GTD_BUSY,
    GTD_REORDER,
    GTD_RINGBACK,
    GTD_FAX,
    GTD_INTERCEPT, 
    GTD_MAX_TONES
};

typedef struct CHANNEL_TYPE 
{
    DWORD                   nDeviceId;
    DWORD                   dwBoard;
    DWORD                   dwChan;
    CHAR                    szDeviceName[15];
    CHAR                    szModel[BCM_MAX_NAME_SIZE];
    class   TCBicomModem    *pModem;
}MCHAN, *PMCHAN;


class   TCBicomModem : public TCModemClass
{
    friend void  LineThread(PVOID lpdwParam);

public:
    TCBicomModem();
    ~TCBicomModem();

    static bool InitBicom();
    static void ExitBicom();
    static  int GetChannelType( int board, int nChannel, PSTR pBuf, int len );
    static  int GetChannelNum( int board );
    static  int GetBoardNum() { return m_BoardNr;};
    static BOOL IsChannelFree( int board, int channel );
    static  int GetAllChannelNum();
    static  int GetIndex( int board, int nChannel );
    static MCHAN    Channels[MAX_BCM_CHANNELS];
    static  int nAllChannels;

    bool    OpenPort(const char *pszPort);
    bool    IsOpen();
    void    ClosePort();
    bool    IsPortUsed();
    bool    InitializeModem(BOOL bReset = TRUE);
    void    DestroyModemObject();
    int     GetVoiceHandle() { return m_VoiceHandle;};
    void    SetConfigFile(const char *pszConfig);

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

    bool    SetDIDDigitNumber(int nDigitNumber) {return false;};
    bool    GetDIDDigits(LPSTR szDigitBuffers) {return false;};
    bool    SetDefVoiceParams(MDF_DATAFORMATS DataFormat,MSR_SAMPLING_RATES SamplingRate);
protected:
    static bool InitializeChannel(DWORD  dwBoardNum, DWORD dwChan, const char *pszModel);
    static LONG StartAllChanOnBoard(DWORD dwBoardNum);

    static  BOOL WaitLineEventHandler(BCM_EVENT *EVT);

    void    ReadToneParams();

    void    LocalInit();
    void    StartThreads();
    void    SetReplies(REPLYITEM *replies);
    bool    ClearResponseBuffer();
    bool    ReadVoiceInfo();
    bool    WriteVoiceInfo();

    static int m_BoardNr;
    static int m_FaxChannelNr;
    static ULONG mHandleThread;

    static int      nDeviceId;
    int     m_nChannel;
    int     m_VoiceHandle;
    int     m_FaxHandle;
    HANDLE  m_hWaitThread;

    BCMTDB  ToneBlk[GTD_MAX_TONES];
    char    szConfig[MAX_PATH];
};

#endif	// _BICOM_VOICE

#endif
