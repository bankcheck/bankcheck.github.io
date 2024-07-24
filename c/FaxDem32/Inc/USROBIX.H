#ifndef	USROBOTICS_MODEM_INCLUDED
#define	USROBOTICS_MODEM_INCLUDED

#include	"mdmclass.h"

//------------------------------------------
//		Rockwell modem class declaration
//------------------------------------------
class   TCUSRoboticsModem   : public TCModemClass
{
public:
    TCUSRoboticsModem();

    bool    OpenPort(const char *pszPort);
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

    bool    SetHandsetAsLine();

    bool    SetDIDDigitNumber(int) {return false;};
    bool    GetDIDDigits(LPSTR) {return false;};
    bool    SetDefVoiceParams(MDF_DATAFORMATS DataFormat,MSR_SAMPLING_RATES SamplingRate);
    bool    ConnectPort(HANDLE hHandle,const char *pszPort);
protected:

    void    LocalInit();
    void    StartThreads();
    void    SetReplies(REPLYITEM *replies);
    bool    ClearResponseBuffer();
    bool    WasVoiceFormatCommandChanged();
};

#endif 