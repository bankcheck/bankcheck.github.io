#ifndef DialogicGC_MODEM_INCLUDED
#define DialogicGC_MODEM_INCLUDED

#ifdef  _DIALOGIC_VOICE

#include "vgcdlg.h"


class   TCDialogicGCModem : public TCDialogicModem
{
public:
    TCDialogicGCModem();
    ~TCDialogicGCModem();

    bool    OpenPort(const char *pszPort);
    void    ClosePort();
    
    bool    OpenISDN  ( LPCSTR szPortName, LPCSTR DTI  );
    bool    OpenICAPI ( LPCSTR szPortName, LPCSTR DTI );

    int     SCRoute( int devh1, unsigned short devtype1, int devh2, unsigned short devtype2, unsigned char mode );
    int     SCUnRoute( int devh1, unsigned short devtype1, int devh2, unsigned short devtype2, unsigned char mode );


    int     AttachVoiceResource(CSCBusResource* pRes);
    int     AttachLineInterfaceResource(CSCBusResource* pRes);
    int     AttachFaxResource(CSCBusResource* pRes);
    int     AttachMSIResource(CSCBusResource* pRes);
    int     DetachVoiceResource(CSCBusResource* pRes);
    int     DetachLineInterfaceResource(CSCBusResource* pRes);
    int     DetachFaxResource(CSCBusResource* pRes);
    int     DetachMSIResource(CSCBusResource* pRes);
    
    long    GetLineType(){return m_LineType;}
    void    SetLineType(long LineType){m_LineType = LineType;}

    LPCSTR  GetProtocol(){return m_Protocol;}
    void    SetProtocol(LPCSTR Protocol){strcpy(m_Protocol,Protocol);}

    int     GetLineHandle() { return m_LineHandle; }

    bool    InitializeModem(BOOL);
    void    InterpretLine(TEVoiceEvent event);
    
    bool    DialInVoiceMode(const char *pszNumber, int nTime, BOOL bOffHook );
    bool    HangUp();
    bool    Answer();
    BOOL    SetHook(BOOL bOffHook);
    
    char*   DNIS(){return m_szDNIS;}
    char*   ANI(){return m_szANI;}
    bool    GetDIDDigits(LPSTR szDigitBuffers) 
    {
        if(szDigitBuffers)strcpy(szDigitBuffers, m_szDNIS); 
        return szDigitBuffers!=0;
    }

    CRN&    MyCRN(){return m_crn;}
    CRN&    MyOfferedCRN(){return m_Offered_crn;}

    void    SetClearingFlag() {m_bClearing=true;}
    void    ResetClearingFlag() {m_bClearing=false;}
    void    SetDialingFlag() {m_bDialing=true;}
    void    ResetDialingFlag() {m_bDialing=false;}
    bool    IsClearing(){return m_bClearing;}
    bool    IsDialing(){return m_bDialing;}
    long    ConnectVoicePort(LPCTSTR FaxName,LPCTSTR IniFile);
    void    DisconnectVoicePort(bool bVoiceMode = true);

    bool    GetCallerID(PTSCallerIDData CallerIDInfo);
    bool    GetANI(LPSTR buffer, long BufferSize);

    BOOL    CreateSingleFrequencyTone(unsigned int ToneID,  TSSingleToneTemplate ToneDef);
	BOOL    CreateDualFrequencyTone  (unsigned int ToneID,  TSDualToneTemplate   ToneDef);
	BOOL    CreateSingleFrequencyToneCadence(unsigned int ToneID,  TSSingleToneCadenceTemplate ToneDef);
	BOOL    CreateDualFrequencyToneCadence  (unsigned int ToneID,  TSDualToneCadenceTemplate   ToneDef);

    BOOL    MakeCallISDN(LPCTSTR lpszNumber);
protected:
    long    m_LineType;
    CRN     m_crn;
    CRN     m_Offered_crn;
    char    m_szDNIS[GC_ADDRSIZE];
    char    m_szANI[GC_ADDRSIZE];
    char    m_Protocol[64];
    bool    m_bClearing;
    bool    m_bDialing;
};

#endif  

#endif  