#ifndef	BROOK_MODEM_INCLUDED
#define	BROOK_MODEM_INCLUDED

#define	MAX_BROOK_CHANNELS	96

#ifdef	_BROOK_VOICE

//****************************************************************************
//
//	Don't touch this typedef and these defines (***ST***)
//
typedef struct
{
    DWORD   dwData;
    BTLINE  *lp;
}PORTPARAM;
    #define	DATAPARAM(p)	((PORTPARAM*)(p))->dwData
    #define	LINEPARAM(p)	((PORTPARAM*)(p))->lp
    #define	PRM_MODE_ANSWER	1


#define BI_BTLINE void

typedef struct {
    int status;
    int line_status;
} BI_RES;

typedef struct {
    FILE *fp;
    int bytes_reversed;
    long cur_offset_offset;
    int page_num;
    long strip_offsets;
    int offset_ft;
    long strip_bytecounts;
    int count_ft;
    long num_strips;
    int fillorder;
    struct BI_ifd_field *fields;
    long bytes_in_strip;
    long cur_strip_offset;
    int width;
    int resolution;
} BI_TFILE;

typedef struct _BI_args_fax
{
    int             force_res;
    int             resolution;
    unsigned        fmt;
    unsigned char  *buf;
    unsigned        size;
    BI_RES          res;
	int				end_mode;
    int             placement;
    int             insert_mode;
    const char     *label;
    unsigned        selector;
    int             width;
    unsigned        bft_type;
    int             xmit_mode;  
    char            remote_id[21];
    char            subaddress[21];
    int             force_eom;  
    const char     *local_id;
    BI_TFILE       *r_tp;
    int             expect_another;
}BI_args_fax;

typedef struct {
    int call_type;
    char dest_id[MAX_DID2];
    /* The rest are ISDN only */
#define called_party_number dest_id
    char called_party_subaddress[MAX_DID2];
    char calling_party_number[MAX_DID2];
    char calling_party_subaddress[MAX_DID2];
    char redir_number[MAX_DID2];
    int redir_reason;
} BI_CALL_RES;

typedef struct _BI_args_telephone
{
    const char     *db_file;
    char           *raw_number;
    long            wait_time;
    int             reason;
    const char     *phonenum;
    int             call_protocol_code;
    int     (* func)(BTLINE *lp, char *arg);
    char           *arg;
    unsigned char	type;
    unsigned char	data;
    BI_RES          res;
    long            timeout;
    int				call_mode;
    BI_CALL_RES     call_res;
}BI_args_telephone;

typedef struct _BI_args_tone {
    BI_RES res;
	int digit;
    long millisecs;//
    int tone_type;
    int toneid;//
    int volume;//
    unsigned count;
    struct cpgen_signal_info *signal_info;
    int decode_flag;//
    int tone_cp;//
}BI_args_tone;

typedef struct _BI_args_speech {
    BI_RES res;//
    unsigned coding_fmt;//
    unsigned rate;//
    unsigned bits_per_samp;//
    unsigned afe_rate;//
    unsigned data_fmt;//
	long timeout;
	long silence_timeout;
	int s_compr;
    int (* func)(BTLINE *lp, char *arg);//
    char *arg;//
    unsigned char *buf;
	unsigned size;
    const char *fname;//
    unsigned agc_value;//
    int use_agc;//
    int playf_cont;//
}BI_args_speech;

typedef struct {
    char short_msg[31];
    char long_msg[129];
} BI_BTERR;


//****************************************************************************

class   TCBrookModem : public TCModemClass
{
    friend int  BrInterruptFunction(BTLINE *lp, char *arg);
    friend void LineThread(PVOID lpdwParam);
    friend void WaitForRingThread(void *lParam);
    friend void BT_CALLBACK MyIntrFunc(BTLINE *lp, long timestamp, unsigned cmd, unsigned dat, unsigned char *fifo);

public:
    TCBrookModem();
    ~TCBrookModem();

    static bool InitBrook();
    static void ExitBrook();
    static void SetConfigFile(LPCSTR lpszConfig);

    static  int GetChannelType( int nChannel, PSTR pBuf, int len );
    static BOOL IsChannelFree( int channel );
    static  int GetAllChannelNum();
    static  int nAllChannels;

    bool    OpenPort(const char *pszPort);
    bool    IsOpen();
    void    ClosePort();
    bool    IsPortUsed();
    bool    InitializeModem(BOOL bReset = TRUE);
    void    DestroyModemObject();
    int     GetVoiceHandle() { return m_VoiceHandle;};

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

    void    TerminateWait();

    static char     szConfig[MAX_PATH];

    unsigned long&  GetRingThreadID(){ return lWaitForRingThread;};
    HANDLE          GetRingHandle(){ return hWaitForRing;};

    BTLINE* GetBTLine(){ return lp;};
    int     GetChannelIndex(){ return nChannel;};

    bool    SetDIDDigitNumber(int nDigitNumber) {return false;};
    bool    GetDIDDigits(LPSTR szDigitBuffers);
    bool    SetDefVoiceParams(MDF_DATAFORMATS DataFormat,MSR_SAMPLING_RATES SamplingRate);
static BOOL	m_bCallControlInitialized;
    BOOL        m_bBadFile;		//TG 09/07/06
protected:
    int     InterpretLine(TEVoiceEvent event);
    int     InitialSetup();
    void    LocalInit();
    void    StartThreads();
    void    SetReplies(REPLYITEM* replies){ pReplies = replies;};
    bool    ClearResponseBuffer(){ return true;};

    BTLINE  *lp;
    int     nChannel;

    bool    bAnswered;

    static int      m_BoardNr;
    static ULONG    mHandleThread;
    static  char    *m_pChannels;
    static  TCBrookModem*   ChannelList[MAX_BROOK_CHANNELS];

    HANDLE  hWaitForRing;
    unsigned long   lWaitForRingThread;

    int     m_VoiceHandle;

    ConfigBrooktrout m_cfg;

public:
	bool    GetCallerID(PTSCallerIDData CallerIDInfo);
protected:
	BI_CALL_RES m_callInfo;
};

#endif
#endif 