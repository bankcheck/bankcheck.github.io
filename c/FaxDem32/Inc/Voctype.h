#ifndef VOICE_TYPE_INCLUDED
#define VOICE_TYPE_INCLUDED

#ifndef SIZE_QUEUE
    #define SIZE_QUEUE      4096
#endif

// Flow Control constants
#define FLC_NOTHING     0
#define FLC_XONXOFF     1
#define FLC_DSR         2
#define FLC_CTS         4

#ifndef ASSERT
    #define ASSERT assert
#endif

#define MMD_DATA                0
#define MMD_CLASS1              1
#define MMD_CLASS2              2
#define MMD_VOICE               8
#define MMD_VOICEVIEW   80

#ifndef ERRDEV
    #define ERRDEV                  INVALID_HANDLE_VALUE
#endif

#ifndef INVALID_HANDLE
    #define INVALID_HANDLE  (NULL)
#endif

#ifndef VOICEAPI
    #define VOICEAPI  __declspec(dllexport)
    #define CVOICEAPI  VOICEAPI
    #define VOICEAPI16 CALLBACK
    #define EXPDEF
#endif  // VOICEAPI

typedef unsigned char far const *LPCBYTE ;

enum TEModemTypes
{
    MOD_UNDEFINED = -1,
    MOD_STANDARD_ROCKWELL,
    MOD_USR_SPORSTER,
    MOD_DIALOGIC,
    MOD_BICOM,
    MOD_BROOKTROUT,
    MOD_NMS,
    MOD_LUCENT,
    MOD_CIRRUSLOGIC,
    MOD_CONEXANT_HCF
};

enum TEVModemStatus
{
    VMST_WAIT ,
    VMST_BUSY ,
    VMST_BINARYSEND ,
    VMST_BINARYRECEIVE
} ;

typedef struct tagTSVLineStatus
{
    WORD    cbInCh ;
    WORD    cbOutCh ;
    DWORD   ReadTime ;
    DWORD   WriteTime ;
    WORD    CTS:1 ;
    WORD    DSR:1 ;
    WORD    CD:1  ;
    WORD    TR:1  ;
    WORD    SD:1  ;
    WORD    ERR:1 ;
} TSVLineStatus ;

typedef struct tagTSVCommSetting
{
    int   BaudRate ;
    WORD  FlowControl ;
    BYTE  StopBits ;
    BYTE  Parity  ;
    int   DsrTimeOut ;
    int   CtsTimeOut ;
} TSVCommSetting ;



enum TEModemErrors
{
    MER_NONE = 0,                           //0-
    MER_UNKNOWN,                            //1-
    MER_WRONG_RESPONSE,                     //2-
    MER_NO_DTMF,                            //3-
    MER_INVALID_DTMF,                       //4- 
    MER_TIMEOUT,                            //5-
    MER_TERMINATED,                         //6-
    MER_WRITE_COMM,                         //7-
    MER_INTERNAL_ERROR,                     //8-
    MER_NO_CONNECT,                         //9-
    MER_NO_FAX_CONNECT,                     //10-
    MER_SEND_DTMF,                          //11-
    MER_VOICE_DEVICE,                       //12-
    MER_NO_VOICE_SUPPORT,                   //13-
    MER_UNKNOWN_MODEM,                      //14
    MER_WRONG_MODEM_TYPE,                   //15-
    MER_NOT_VOICE_MODEM,                    //16-
    MER_INVALID_VOC_FILE,                   //17-
    MER_INVALID_SPEAKER_VOLUME,             //18-
    MER_INVALID_MODEMOBJ,                   //19-
    MER_IO_ERROR,                           //20-
    MER_DIALOGIC_ERROR,                     //21-
    MER_UNSUPPORTED_COMMAND,                //22-
    MER_OUT_OF_MEMORY,                      //23-
    MER_INVALID_PARAMETER,                  //24-
    MER_CHANNEL_NOT_OPEN,                   //25-
    MER_TOO_MANY_TONEIDS,                   //26-
    MER_ZIP_TONES_DISABLED,                 //28-
    MER_INVALID_NUMBER_OF_PARTIES,          //29-
    MER_INVALID_CONFERENCE_NUMBER,          //30-
    MER_PARTY_ALREADY_ASSIGNED,             //32-
    MER_SEND_ZIP_TONE_FAILED,               //33-
    MER_CONFERENCE_IS_FULL,                 //34-
    MER_CONFERENCE_NOT_AVAILABLE,           //35-
    MER_PARTY_ALREADY_IN_CONFERENCE,        //36-
    MER_PARTY_NOT_IN_CONFERENCE,            //37-
    MER_CANNOT_REMOVE_PARTY_FROM_CONF,      //38-
    MER_INVALID_PARTY_ATTR,                 //39-
    MER_INVALID_STATION,                    //40-
    MER_CANNOT_RING_STATION_BUSY,           //41-
    MER_INVALID_CONFERENCE_ATTR,            //42-
    MER_PARTY_TYPE,                         //43-
    MER_STATION_NOT_CONNECTED,              //44-
    MER_CONFERENCE_LIMIT_EXCEEDED,          //45-
    MER_STATION_IS_ZIPPING,                 //46-
    MER_INVALID_RING_COUNT,                 //47-
    MER_CANNOT_RING_NONRINGING_BOARD,       //47-
    MER_BAD_RING_CADENCE_ID,                //48
    MER_NO_FAX_LICENSE,                     //49


};

enum TEVoiceEvent
{// modem events 'This' is always MODEMOBJ
    MEV_OK = 100,
    MEV_CONNECT,
    MEV_VOICE_CONNECT,
    MEV_ANSWER,
    MEV_STARTDIAL,
    MEV_ENDDIAL,
    MEV_VOICE_MODE,
    MEV_FAX_MODE,
    MEV_NO_CARRIER,
    MEV_RING,
    MEV_ERROR,
    MEV_NO_DIALTONE,
    MEV_BUSY,
    MEV_NO_ANSWER,
    MEV_DELAYED,
    MEV_BLACKLISTED,
    MEV_DTMF_RECEIVED,
//      Shielded statuses
    MEV_ANSWER_TONE,
    MEV_BUSY_TONE,
    MEV_CALLING_TONE,
    MEV_DIAL_TONE,
    MEV_EDMCT,
    MEV_BAT,
    MEV_ONHOOK,
    MEV_OVERRUN,
    MEV_QUIET,
    MEV_SILENCE,
    MEV_OFFHOOK,
    MEV_UNDERRUN,
    MEV_TIME_MARK,
//
    MEV_DTMF_0,
    MEV_DTMF_1,
    MEV_DTMF_2,
    MEV_DTMF_3,
    MEV_DTMF_4,
    MEV_DTMF_5,
    MEV_DTMF_6,
    MEV_DTMF_7,
    MEV_DTMF_8,
    MEV_DTMF_9,
    MEV_DTMF_HASH,
    MEV_DTMF_STAR,
//
    MEV_VREC_STARTED,
    MEV_VREC_FINISHED,
    MEV_VPLAY_STARTED,
    MEV_VPLAY_FINISHED,
    MEV_NO_RESPONSE,

    MEV_STOPPED,
    MEV_UNSPECIFIED,
    MEV_RINGBACK, 

    MEV_REORDER,
    MEV_DTMF_START,
    MEV_DTMF_STOP,
    MEV_SIT,
    MEV_VOICEDATA_RECEIVED,
    MEV_ANSWERING_MACHINE,

    MEV_CUSTOM_TONE_1_ON=250,
    MEV_CUSTOM_TONE_2_ON,
    MEV_CUSTOM_TONE_3_ON,
    MEV_CUSTOM_TONE_4_ON,
    MEV_CUSTOM_TONE_5_ON,
    MEV_CUSTOM_TONE_6_ON,
    MEV_CUSTOM_TONE_7_ON,
    MEV_CUSTOM_TONE_8_ON,
    MEV_CUSTOM_TONE_9_ON,
    MEV_CUSTOM_TONE_10_ON,
    MEV_CUSTOM_TONE_11_ON,
    MEV_CUSTOM_TONE_12_ON,
    MEV_CUSTOM_TONE_13_ON,
    MEV_CUSTOM_TONE_14_ON,
    MEV_CUSTOM_TONE_15_ON,
    MEV_CUSTOM_TONE_16_ON,
    MEV_CUSTOM_TONE_17_ON,
    MEV_CUSTOM_TONE_18_ON,
    MEV_CUSTOM_TONE_19_ON,
    MEV_CUSTOM_TONE_20_ON,
    MEV_CUSTOM_TONE_1_OFF,
    MEV_CUSTOM_TONE_2_OFF,
    MEV_CUSTOM_TONE_3_OFF,
    MEV_CUSTOM_TONE_4_OFF,
    MEV_CUSTOM_TONE_5_OFF,
    MEV_CUSTOM_TONE_6_OFF,
    MEV_CUSTOM_TONE_7_OFF,
    MEV_CUSTOM_TONE_8_OFF,
    MEV_CUSTOM_TONE_9_OFF,
    MEV_CUSTOM_TONE_10_OFF,
    MEV_CUSTOM_TONE_11_OFF,
    MEV_CUSTOM_TONE_12_OFF,
    MEV_CUSTOM_TONE_13_OFF,
    MEV_CUSTOM_TONE_14_OFF,
    MEV_CUSTOM_TONE_15_OFF,
    MEV_CUSTOM_TONE_16_OFF,
    MEV_CUSTOM_TONE_17_OFF,
    MEV_CUSTOM_TONE_18_OFF,
    MEV_CUSTOM_TONE_19_OFF,
    MEV_CUSTOM_TONE_20_OFF,
    MEV_MSI_STATIONONHOOK, 
    MEV_MSI_STATIONOFFHOOK, 
    MEV_MSI_HOOKFLASH, 
    MEV_MSI_RINGOFFHOOK, 
    MEV_MSI_RINGTERMINATED, 
    MEV_MSI_FIRSTRING, 
    MEV_MSI_RINGSTOP,
    MEV_MSI_ERROR, 
};

//----------------------------------------------------------------------------
//      This types and and structures may be defined in FAXTYPE.H
//----------------------------------------------------------------------------
#ifndef __FAXTYPE_H

//#pragma       message ("FAXTYPE.H not included yet!")
enum TEFaxCapability
{
    FDC_SETCOMPRESS, FDC_ONLINECOMPRESS, FDC_ECM, FDC_BINARY, FDC_WIDTH,
    FDC_LENGTH, FDC_BAUD_SEND, FDC_BAUD_REC, FDC_NONSTDFRAME, FDC_BITORDER, FDC_FAXPOLLING,
    FDC_RESOLUTION, FDC_GET_DTMF
};

enum TEBoardType
{
    BRD_NONE,
    BRD_BROOKTROUT,
    BRD_GAMMALINK,
    BRD_DIALOGIC,
    BRD_BICOM,
    BRD_NMS
};

enum TEHeaderType
{
    HDR_NONE,
    HDR_TEXT,
    HDR_DIB,
};

enum TEDialogicBoard
{
    BOARDTYPE_ANALOG,
    BOARDTYPE_DIGITAL,
};

enum TEChannelState
{
    STATE_IDLE, STATE_OPEN, STATE_FAX
};

struct TSTestResult
{
    char ClassType[20];
    char Manufact[256];
    char Model[256];
};

typedef struct
{
    int country_code;
    int max_pagelist_len;
    unsigned int voice_timeout;
    int dma_size;
    int ced_override;
    int cabs_override;
    char font_file[128];
    unsigned char error_mult;
    unsigned char error_thresh;
    unsigned char error_enable;
    unsigned char voice_silence_thresh;
    unsigned char voice_silence_wait;
    unsigned char wink_or_immediate;
    unsigned char did_digits;
    unsigned char switch_hook;
    unsigned char v_lp_break;
    char bt_cparm[128];
    char firm16_file[128];
    char firm164_file[128];
    char firm164_2m_file[128];
    unsigned char width_behavior;
    char digital_file[128];
    char isdn_file[128];
    unsigned char did_variable;
    unsigned char subpwdsep;
    // for API 3.7
    unsigned char agc;
    unsigned char btnsf;
    unsigned char busy_ct;
    unsigned char dtmf_playoff;
    unsigned char dtmf_twist;
    unsigned char min_length;
    unsigned char missing_wait;
    char v_play_gain;
	// for API 3.3.0
    char			call_control[MAX_PATH];
	unsigned char	badline_behavior;
	unsigned char	busy_dt_ct;
	int				ced_timeout;
	char			debug[128];
	unsigned char	dtmf_thresh;
	unsigned char	ecm_enable;
	unsigned char	eff_pt_caps;
	int				error_mult_rtp;
	unsigned char	fax_rtp_enable;
	char			id_string[64];
	unsigned char	line_compression;
	unsigned char	line_encoding;
	unsigned char	max_pagelist;
	unsigned char	max_timeout;
	unsigned char	max_width;
	unsigned char	restrict_res;
	int				silcompr_start;
	int				silcompr_middle;
	unsigned char	v_timeout;
	unsigned char	v34_2400_baud_ctrl;
	unsigned char	v34_ci_enable;
	unsigned char	v34_enable;
	unsigned char	width_res_behavior;
	unsigned char	num_rings;

} ConfigBrooktrout ;

#endif  // __FAXTYPE_H

typedef struct stTransfer
{
    char    szNumber[128];
    BOOL    bDialTone;
    BOOL    bTransFlag;
    BOOL    nToneTime;
    char        szFlash[128];
    char        szCancel[128];
}TRANSFER;

//enum TEVChannelState { STATE_IDLE, STATE_OPEN };

#ifdef  __cplusplus

// voice classes and structures
class CVOICEAPI TCModemClass;
typedef TCModemClass far * MODEMOBJ;
#endif  // __cplusplus

enum MDF_DATAFORMATS
{
    MDF_ADPCM = 0,          // used by dialog and bicom
    MDF_PCM,                // used by dialog and bicom
    MDF_MULAW,              // used by dialog only
    MDF_ALAW,               // used by dialog only
    MDF_OKI,                // used bicom only
    MDF_8BITLINEAR,         // used bicom only
    MDF_IMAADPCM,           // used by USR and Lucent modems
    MDF_UNKNOWN             // modem specific format
};
enum MSR_SAMPLING_RATES
{
    MSR_6KHZ = 0, MSR_7200, MSR_8KHZ, MSR_11KHZ, MSR_UNKNOWN
};

enum    MDM_DEVICE
{
    MDM_LINE                = 0,
    MDM_HANDSET             = 1,
    MDM_SPEAKER             = 2,
    MDM_MICROPHONE          = 3
};

#define MMOD_DATA                       0
#define MMOD_CLASS1                     1
#define MMOD_CLASS2                     2
#define MMOD_VOICE                      3
#define MMOD_VOICEVIEW          4

#define MMOD_DTMF_LEN   128
typedef struct
{
    char    szDTMF[MMOD_DTMF_LEN];
    int     nNumOfDTMF;
    char    cDelimiter;
}DTMFINFO, *PDTMFINFO;

typedef struct
{
    char            szFilename[MAX_PATH];
    MDM_DEVICE      nDevice;
    int             nTime;
    DTMFINFO        DTMFInfo;
}VOICEINFO, *PVOICEINFO;

typedef struct
{
    UINT            unSize;                                 // size of this structure
    char            szFilename[MAX_PATH];                   // voice filename
    MDM_DEVICE      nDevice;                                // I/O device
    int             nTime;                                  // amount of record time/
    // DTMF detection time
    // after voice message played
    BOOL            bBeep;                                  // Beep a sound before recording voice message
    int             nBeepTime;                              // Amount of beep time
    BOOL            bWAV;                                   // voice file is in WAV or VOC format (DIALOGIC only)
    int             nDataFormat;                            // ADPCM/PCM?MULAW/ALAW (DIALOGIC only)
    int             nSamplingRate;                          // 6/8/11KHz (DIALOGIC only)
    DTMFINFO        DTMFInfo;                               // DTMF info
}VOICEINFOEXT,  *PVOICEINFOEXT;

typedef struct
{
    UINT            unSize;                                 // size of this structure
    char            szFilename[MAX_PATH];                   // voice filename
    MDM_DEVICE      nDevice;                                // I/O device
    int             nTime;                                  // amount of record time/
    // DTMF detection time
    // after voice message played
    BOOL            bBeep;                                  // Beep a sound before recording voice message
    int             nBeepTime;                              // Amount of beep time
    BOOL            bWAV;                                   // voice file is in WAV or VOC format (DIALOGIC only)
    int             nDataFormat;                            // ADPCM/PCM?MULAW/ALAW (DIALOGIC only)
    int             nSamplingRate;                          // 6/8/11KHz (DIALOGIC only)
    DTMFINFO        DTMFInfo;                               // DTMF info
    long            nByteOffset;
    long            nByteLength;
}VOICEINFOEXT2,  *PVOICEINFOEXT2;

typedef struct
{
    char                Manufact[256];
    char                Model[256];
    char                Modes[10];
    char                VoiceFormats[1024];
}TSVoiceTestResult;

#define DTMF_DTMF(p)			p->szDTMF
#define DTMF_NUM(p)             p->nNumOfDTMF
#define DTMF_TIME(p)			p->nNumOfDTMF
#define DTMF_DELIM(p)			p->cDelimiter

#define VOICE_SIZE(p)			p->unSize
#define VOICE_DTMF(p)			p->DTMFInfo.szDTMF
#define VOICE_NUM(p)			p->DTMFInfo.nNumOfDTMF
#define VOICE_DELIM(p)			p->DTMFInfo.cDelimiter
#define VOICE_FILE(p)			p->szFilename
#define VOICE_TIME(p)			p->nTime
#define VOICE_DEVICE(p)			p->nDevice
#define VOICE_BEEP(p)			p->bBeep
#define VOICE_BEEPTM(p)			p->nBeepTime
#define VOICE_WAV(p)			p->bWAV
#define VOICE_DF(p)             p->nDataFormat
#define VOICE_SR(p)             p->nSamplingRate
#define VOICE_BYTEOFFSET(p)     p->nByteOffset
#define VOICE_BYTELENGTH(p)     p->nByteLength

#define TEST_MANUFACT(p)        p->Manufact
#define TEST_MODEL(p)           p->Model
#define TEST_MODES(p)           p->Modes
#define TEST_VOICE_FORMATS(p)   p->VoiceFormats

#define REG_VOICEMESSAGE      "Fax C++ Message"
#define MFX_VOICE_CONNECT       20
#define MFX_FAX_CONNECT         21
#define MFX_VOICE_MODE          24
#define MFX_FAX_MODE            25
#define MFX_NO_CARRIER          26
#define MFX_MODEM_RING          27
#define MFX_ERROR               28
#define MFX_NO_DIALTONE         29
#define MFX_BUSY                30
#define MFX_NO_ANSWER           31
#define MFX_DELAYED             32
#define MFX_BLACKLISTED         33
#define MFX_NO_RESPONSE         34
#define MFX_MODEM_OK            35
#define MFX_MODEM_ANSWER        36
#define MFX_DTMF_RECEIVED       37
#define MFX_VREC_STARTED        40
#define MFX_VREC_FINISHED       41
#define MFX_VPLAY_STARTED       42
#define MFX_VPLAY_FINISHED      43
#define MFX_ANSWER_TONE         44
#define MFX_BUSY_TONE           45
#define MFX_CALLING_TONE        46
#define MFX_DIAL_TONE           47
#define MFX_EDMCT                       48
#define MFX_BAT                         49
#define MFX_ONHOOK                      50
#define MFX_OVERRUN                     51
#define MFX_QUIET                       52
#define MFX_SILENCE                     53
#define MFX_OFFHOOK                     54
#define MFX_UNDERRUN            55
#define MFX_TIME_MARK           56

//
#define MFX_DTMF_0                      57
#define MFX_DTMF_1                      58
#define MFX_DTMF_2                      59
#define MFX_DTMF_3                      60
#define MFX_DTMF_4                      61
#define MFX_DTMF_5                      62
#define MFX_DTMF_6                      63
#define MFX_DTMF_7                      64
#define MFX_DTMF_8                      65
#define MFX_DTMF_9                      66
#define MFX_DTMF_HASH					67
#define MFX_DTMF_STAR                   68

#define MFX_PAGER_CONNECT               69  // st
#define MFX_REORDER                     70
#define MFX_SIT                         71
#define MFX_VOICEDATA_RECEIVED          72
#define MFX_ANSWERING_MACHINE			73




#ifdef  _VOICE_OCX
    #define MFX_PORT_OPEN                   100
    #define MFX_VOICE_ANSWER                101
    #define MFX_VOICE_HANGUP                102
    #define MFX_DTMF_SENT                   103
    #define MFX_ENDRECEIVE                  104
    #define MFX_TONE_SENT                   105
#endif  // _VOICE_OCX


#define MFX_CUSTOM_TONE_1_ON            250
#define MFX_CUSTOM_TONE_2_ON            251
#define MFX_CUSTOM_TONE_3_ON            252
#define MFX_CUSTOM_TONE_4_ON            253
#define MFX_CUSTOM_TONE_5_ON            254
#define MFX_CUSTOM_TONE_6_ON            255
#define MFX_CUSTOM_TONE_7_ON            256
#define MFX_CUSTOM_TONE_8_ON            257
#define MFX_CUSTOM_TONE_9_ON            258
#define MFX_CUSTOM_TONE_10_ON           259
#define MFX_CUSTOM_TONE_11_ON           260
#define MFX_CUSTOM_TONE_12_ON           261
#define MFX_CUSTOM_TONE_13_ON           262
#define MFX_CUSTOM_TONE_14_ON           263
#define MFX_CUSTOM_TONE_15_ON           264
#define MFX_CUSTOM_TONE_16_ON           265
#define MFX_CUSTOM_TONE_17_ON           266
#define MFX_CUSTOM_TONE_18_ON           267
#define MFX_CUSTOM_TONE_19_ON           268
#define MFX_CUSTOM_TONE_20_ON           269

#define MFX_CUSTOM_TONE_1_OFF           270
#define MFX_CUSTOM_TONE_2_OFF           271
#define MFX_CUSTOM_TONE_3_OFF           272
#define MFX_CUSTOM_TONE_4_OFF           273
#define MFX_CUSTOM_TONE_5_OFF           274
#define MFX_CUSTOM_TONE_6_OFF           275
#define MFX_CUSTOM_TONE_7_OFF           276
#define MFX_CUSTOM_TONE_8_OFF           277
#define MFX_CUSTOM_TONE_9_OFF           278
#define MFX_CUSTOM_TONE_10_OFF          279
#define MFX_CUSTOM_TONE_11_OFF          280
#define MFX_CUSTOM_TONE_12_OFF          281
#define MFX_CUSTOM_TONE_13_OFF          282
#define MFX_CUSTOM_TONE_14_OFF          283
#define MFX_CUSTOM_TONE_15_OFF          284
#define MFX_CUSTOM_TONE_16_OFF          285
#define MFX_CUSTOM_TONE_17_OFF          286
#define MFX_CUSTOM_TONE_18_OFF          287
#define MFX_CUSTOM_TONE_19_OFF          288
#define MFX_CUSTOM_TONE_20_OFF          289
#define MFX_MSI_STATIONONHOOK           290
#define MFX_MSI_STATIONOFFHOOK          291
#define MFX_MSI_HOOKFLASH               292
#define MFX_MSI_RINGOFFHOOK             293
#define MFX_MSI_RINGTERMINATED          294
#define MFX_MSI_FIRSTRING               295
#define MFX_MSI_RINGSTOP                296
#define MFX_MSI_ERROR                   297


#define MFX_LAST						500
#define DTMF_SEQ        "0123456789#*"


#define  LINETYPE_T1          1
#define  LINETYPE_E1          1
#define  LINETYPE_ISDN        2
#define  LINETYPE_ANALOG      3

enum MSD_SILENCEDETECTION
{
    MSD_DISABLED=0, MSD_LOW, MSD_MEDIUM, MSD_HIGH
};

#define SIMPLEX 0
#define DUPLEX  1
#define QUAD    2


typedef struct ReceivedVoiceData
{
    MODEMOBJ Modem;
    int Format;
    int Size;
    HANDLE hData;
}TSReceivedVoiceData, *PTSReceivedVoiceData;


#define MAX_CALLING_DATE_LENGTH     20
#define MAX_CALLING_TIME_LENGTH     20
#define MAX_CALLER_ID_LENGTH        20
#define MAX_CALLED_NUMBER_LENGTH    20
#define MAX_CALLER_NAME_LENGTH      255
#define MAX_MESG_LENGTH             255

typedef struct CallerIDData
{
    unsigned char szCallingDate[MAX_CALLING_DATE_LENGTH + 1];
    unsigned char szCallingTime[MAX_CALLING_TIME_LENGTH + 1];
    unsigned char szCallerID[MAX_CALLER_ID_LENGTH + 1];
    unsigned char szCallerName[MAX_CALLER_NAME_LENGTH + 1];
    unsigned char szCalledNumber[MAX_CALLED_NUMBER_LENGTH + 1];
    unsigned char szMessage[MAX_MESG_LENGTH + 1];
}TSCallerIDData, *PTSCallerIDData;

//parameter values that can be set with the SetParameter fuction
#define MDM_ENABLE_ANSVERING_MACHINE_DETECTION	0x00000001

//modem command IDs used by the SetModemCommand/GetModemCommand fuction
#define MDM_CMD_CALLER_ID		0x00000001
#define MDM_CMD_VOICE_FORMAT	0x00000002


typedef struct 
{
    unsigned int    iFreq;
    unsigned int    iFreqDeviation;
    unsigned int    iDetectionMode;
}TSSingleToneTemplate, *PTSSingleToneTemplate;


typedef struct 
{
    unsigned int    iFreq1;
    unsigned int    iFreqDeviation1;
    unsigned int    iFreq2;
    unsigned int    iFreqDeviation2;
    unsigned int    iDetectionMode;
}TSDualToneTemplate, *PTSDualToneTemplate;


typedef struct 
{
    unsigned int    iFreq;
    unsigned int    iFreqDeviation;
    unsigned int    iOnTime;
    unsigned int    iOnTimeDeviation;
    unsigned int    iOffTime;
    unsigned int    iOffTimeDeviation; 
    unsigned int    iRepeatCount;
}TSSingleToneCadenceTemplate, *PTSSingleToneCadenceTemplate;


typedef struct 
{
    unsigned int    iFreq1;
    unsigned int    iFreqDeviation1;
    unsigned int    iFreq2;
    unsigned int    iFreqDeviation2;
    unsigned int    iOnTime;
    unsigned int    iOnTimeDeviation;
    unsigned int    iOffTime;
    unsigned int    iOffTimeDeviation; 
    unsigned int    iRepeatCount;
}TSDualToneCadenceTemplate, *PTSDualToneCadenceTemplate;


#define USER_DEFINED_BASE_TONE_ID	              0  
#define USER_DEFINED_MAX_TONE_ID	              20  
#define USER_DEFINED_CUSTOME_TONE_MSG_OFFSET	  249-USER_DEFINED_BASE_TONE_ID  

#define TONE_DETECTION_MODE_LEADING   0x02  /* Leading Edge Detection */
#define TONE_DETECTION_MODE_TRAILING  0x04  /* Trailing Edge Detection */

#define TONE_DETECTION_MASK_TONEON    0x01  /* Tone ON Mask */
#define TONE_DETECTION_MASK_TONEOFF   0x02  /* Tone OFF Mask */


#define CALLER_ID_TAG_NAME          "NAME"
#define CALLER_ID_TAG_DATE          "DATE"
#define CALLER_ID_TAG_TIME          "TIME"
#define CALLER_ID_TAG_NMBR          "NMBR"
#define CALLER_ID_TAG_MESG          "MESG"


#define MSI_CONFERENCE_PARTY_ATTR_NULL   0x00   /* No attributes */ 
#define MSI_CONFERENCE_PARTY_ATTR_RO     0x01   /* Receive-only (monitor) mode */
#define MSI_CONFERENCE_PARTY_ATTR_TARIFF 0x02   /* Tariff Notification */

//#define MSI_CONFERENCE_PARTY_ATTR_DIG    0x04   /* Digital Front End */
#define MSI_CONFERENCE_PARTY_ATTR_COACH  0x08   /* Coach */
#define MSI_CONFERENCE_PARTY_ATTR_PUPIL  0x10   /* Pupil */

//#define MSI_CONFERENCE_PARTY_ATTR_NOAGC  0x20   /* Disable AGC */

#define MSI_CONFERENCE_ATTR_NULL                    0x00   /* Normal Attribute */
#define MSI_CONFERENCE_ATTR_NOTIFY_ON_ADD           0x01   /* Notify-on-Add mode */
#define MSI_CONFERENCE_ATTR_NO_NOTIFY_ON_ADD        0x02   /* Do not notify if party joins in RO or monitor */

#endif 