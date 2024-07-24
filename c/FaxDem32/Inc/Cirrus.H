#ifndef	Cirrus_MODEM_INCLUDED
#define	Cirrus_MODEM_INCLUDED

#include	"mdmclass.h"

//------------------------------------------
//		Cirrus modem class declaration
//------------------------------------------
class   TCCirrusModem   : public TCModemClass
{
public:
    TCCirrusModem();

    bool    OpenPort(const char *pszPort);
    bool    ConnectPort(HANDLE hHandle,const char *pszPort);
    bool    IsOpen();
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
    bool    Answer();
    bool    OnlineAnswer();
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

    bool    SetDIDDigitNumber(int) {return false;};
    bool    GetDIDDigits(LPSTR) {return false;};
    bool    SetDefVoiceParams(MDF_DATAFORMATS DataFormat,MSR_SAMPLING_RATES SamplingRate);
protected:

    void    LocalInit();
    void    StartThreads();
    void    SetReplies(REPLYITEM *replies);
    bool    ClearResponseBuffer();
    bool    WasVoiceFormatCommandChanged();
};

#endif 