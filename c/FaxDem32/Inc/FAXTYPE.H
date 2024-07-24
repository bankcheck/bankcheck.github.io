/****************************************************************************/
/*            (c) Copyright Black Ice Software Inc.  1994.                  */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/*                                                                          */
/*                                                                          */
/****************************************************************************/

#ifndef __FAXTYPE_H
#define __FAXTYPE_H

#pragma pack(4)
#pragma warning(disable:4103)

#define FAXCPP_VERSION 0x1260

//****************************************************************************
#define REGTYPE_NORMALFAX   'N'
#define REGTYPE_BINARYFILE  'B'
#define REGTYPE_COLORFAX    'C'

#define MAX_PORTNAME        25
#define MAX_FAXLONGNAME     41
#define MAX_SETUPSTRING     100
#define MAX_STATIONID       21
#define MAX_CALLNUMBER      128  
#define MAX_FAXTYPE         41
#define MAX_SHORTFAX        21
#define MAX_FILENAME        260 //_MAX_PATH  (144)
#define MAX_MODEMCOMMAND    32
#define MAX_BROOKTROUT_TYPE 30	//EA 25


#define MAX_PASSWORD        20
#define MAX_CALLERID        20
#define MAX__NSF            80
#define MAX_DTMF            20
#define MAX_DNIS            32
#define MAX_SUBADRESS       64  
#define MAX_SEP             20


#define FER_MEMORIA         -20
#define FER_TOOLONG         -21
#define FER_FAXNOW          -22
#define FER_FILE            -23
#define FER_BADPARAM        -24
#define FER_BADFAX          -25
#define FER_SYSTEM          -26
#define FER_RONGFORMAT      -27
#define FER_NOQUEUE         -28
#define FER_ENCODE          -29
#define FER_NOTIMPLEMENTED  -30
#define FER_BFTDECODE       -31
#define FER_PORTDISABLE     -32
#define FER_PORTSYNC        -33
#define FER_PORTCLOSED      -34

/* FER_SYSTEM */
#define FER_SYS_REGCLASS        -40
#define FER_SYS_CREATEWND       -41
#define FER_LOADIMG             -42
#define FER_SCALEIMG            -43
#define FER_ENCOD_CCITT         -44
#define FER_DECOD_CCITT         -45
#define FER_LOADMODULE          -46
#define FER_CONNECT             -47
#define FER_CREATEFAXOBJ        -48
#define FER_COMPRESSION_FAILED  -49

/* FER_BADPARAM */
#define FER_BAD_PAGENUM         -60
#define FER_BAD_PAGEFNAME       -61
#define FER_BAD_BFTDATA         -62
#define FER_BAD_BFTDATAID       -63
#define FER_BAD_BFTSIZE         -64
#define FER_BAD_IMGTYPE         -66
#define FER_BAD_IMGFILE         -67
#define FER_BAD_IMGMEM          -68
#define FER_BAD_FAXPORT         -69
#define FER_BAD_MODEMTEST       -70
#define FER_BAD_BITSPERPIXEL    -71
#define FER_COMPRESSION         -72
#define FER_BAD_INDEX           -73
#define FER_NO_FIRMWARE         -74
#define FER_NO_SENDFLAG         -75

/* FER_FILE */
#define FER_FILE_OPEN           -80
#define FER_FILE_COPY           -81
#define FER_FILE_WRITE          -82
#define FER_FILE_READ           -83
#define FER_FILE_NOEXIST        -84
#define FER_FILE_SEEKERROR      -85


#define FER_INCOMPATIBLE_RESOLUTION     -100
#define FER_INCOMPATIBLE_WIDTH          -101
#define FER_INCOMPATIBLE_LENGTH         -102
#define FER_INCOMPATIBLE_COMPRESSION    -103
#define FER_INCOMPATIBLE_BFT_MODE       -104
#define FER_INCOMPATIBLE_ECM_MODE       -105
#define FER_INCOMPATIBLE_COLOR_MODE     -106
#define FER_SEND_POLLING_DISABLED       -107

/* Brooktrout */
#define FER_BROOK_CANT_DIAL      -120

/* GammaLink*/
// incompatible channel configuration
// (GFXSHUTDOWN in config file)
#define FER_GAMMA_BAD_LINE_CONFIG         -130
// incompatible channel configuration
// (GFXDID in config file)
#define FER_GAMMA_NONANALOG_LINE          -131
// incompatible receive output tiff format
// (GFXFORM in config file)
#define FER_GAMMA_INCOMPATIBLE_TIFF_FORMAT -132
#define FER_GAMMA_NOENVVAR                 -133

#define FER_NOT_ENOUGH_LICENSE             -134
//-----------------------------------------------/
//Dll error codes --added by Levente Nemethy
#define	FER_BIGIF_DLL_NOT_FOUND -135
#define FER_BIPCX_DLL_NOT_FOUND -136
#define FER_BITGA_DLL_NOT_FOUND -137

//-----------------------------------------------/
#define REG_FAXMESSAGE      "Fax C++ Message"
#define MFX_RECEIVED        0   // lParam = FAXOBJ
#define MFX_ENDSEND         1   // lParam = PORTFAX
#define MFX_ANSWER          3   // lParam = PORTFAX
#define MFX_DIAL            4   // lParam = PORTFAX
#define MFX_HANGUP          5   // lParam = PORTFAX
#define MFX_DONOTSEND       6   // lParam = FAXOBJ
#define MFX_MODEMTYPE       7   // lParam = HGLOBAL (TSTestResoult)
#define MFX_TERMINATE       8   // lParam = TerminationStatus
#define MFX_STARTPAGE       9   // lParam : LOWORD=pagenumber HIWORD=TRUE on send
#define MFX_ENDPAGE         10  // lParam : LOWORD=pagenumber HIWORD=TRUE on send
#define MFX_RING            11  // lParam = ring number
#define MFX_STARTSEND       12  // lParam = PORTFAX
#define MFX_STARTRECEIVE    13  // lParam = PORTFAX

#define MFX_CONNECT                      14  // lParam = TRUE connected, FALSE disconnected
#define MFX_IDLE                                 15  // lParam = NULL
#define MFX_IDRECEIVED      16  // lParam = PORTFAX

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
#define MFX_DTMF_HASH                                   67
#define MFX_DTMF_STAR                                   68

#ifdef _VOICE_OCX
#define MFX_PORT_OPEN                      100
#define MFX_VOICE_ANSWER                   101
#define MFX_VOICE_HANGUP                   102
#define MFX_DTMF_SENT                      103
#define MFX_ENDRECEIVE                     104
#define MFX_TONE_SENT                      105
#endif  //_VOICE_OCX

#define MFX_G5_TURNAROUND                  200
#define MFX_G5_REPLYFILEFORMAT             201
#define MFX_G5_SENDDOCUMENT                202
#define MFX_G5_ENDSEND                     203

#define MFX_HIDEFAXMANAGER                 204

#define MFX_DTMF_AVAILABLE                 205
#define MFX_PAGE_DATA_RECEIVED             205

#define DTMF_SEQ        "0123456789#*"

#define QUT_SEND            0
#define QUT_RECEIVE         1

//----------------------------------------------------------------------
#define  MC_RESET       0
#define  MC_INITSTING   1
#define  MC_HANGUP      2
#define  MC_SETCLASS    3
#define  MC_ECHOOFF     4
#define  MC_DIAL        5
#define  MC_ANSWER      6

#define  MC_SPEEKER_ON   7
#define  MC_SPEEKER_OFF  8
#define  MC_SPEEKER_DIAL 9

#define  MC_VOLUME_LOW   10
#define  MC_VOLUME_MED   11
#define  MC_VOLUME_HIGH  12

#define  MC_GETMANUFACT  13
#define  MC_TONE_PREFIX  14
#define  MC_PULSE_PREFIX 15
#define  MC_F34COMMAND	 16
#define  MC_F34SWITCHTOPRIMARYCHANNEL	 17
#define  MC_F34SWITCHTOCONTROLCHANNEL	 18

#define  MC_MAX          64


#define HEADER_BMWIDTH              1728
#define HEADER_BMHEIGHT             64
#define MAX_HEADER_CHARWIDTH        256


//----------------------------------------------------------------------------

typedef struct tagTSCommSetting {
        int   BaudRate ;
        WORD  FlowControl ;
        BYTE  StopBits ;
        BYTE  Parity  ;
        int   DsrTimeOut ;
        int   CtsTimeOut ;
} TSCommSetting ;



//----------------------------------------------------------------------------
enum TEG5ReplyNeg{ G5_NEG_CONTINUE, G5_NEG_AGREED, G5_NEG_FAILED};
enum TEG5Status{ G5_STATUS_IDLE, G5_STATUS_NEGOTIATION, G5_STATUS_SENDING, G5_STATUS_CONFIRMATION, G5_STATUS_EXITING, G5_STATUS_FAILED_TO_NEGOTIATE};
//----------------------------------------------------------------------------
                                    // lParam
enum TEFaxEvent{FEV_STARTDRV,       //0 Call the SetupFaxDriver, must create queues
                                    // 'This' param. is DialogBox handler
                FEV_ENDDRV,         //1 Call the EndOfFaxDriver, must delete queues
                                    // WARNING! 'This' param. is NULL
                FEV_ENABLETASKS,    //2 LOWORD - TRUE-enable, FALSE-disable; HIWORD - TERuningMode
                                    // ' This' param. is Dialog Box handler
                FEV_BEGINPORT,      //3 'This' param. always PORTFAX
                FEV_CONNECT,        //4  LOPARAM = TRUE connect, FALSE - disconnect
                FEV_RING,           //5  ring number
                FEV_DIAL,           //6  NULL
                FEV_ANSWER,         //7  NULL
                FEV_STARTSEND,      //8  Fax Session Number
                FEV_STARTRECEIVE,   //9  Fax Session Number
                FEV_ENDSEND,        //10 FAXOBJ (return FAXOBJ, next fax or NULL)
                FEV_ENDRECEIVE,     //11 FAXOBJ
                FEV_RECREMOTEID,    //12 NULL, remote ID - return == 0 : OK, < 0 terminate FAX
                FEV_STARTPAGE,      //13 LOWORD - Page num., HIWORD - (0-Receive, 1-Send)
                FEV_ENDPAGE,        //14 LOWORD - Page num., HIWORD - (0-Receive, 1-Send)
                FEV_ABORTFAX,       //15 BOOL Break
                FEV_ENDBREAK,       //16 NULL
                FEV_HANGUP,         //17 NULL
                FEV_VOICE,          //19 NULL
                FEV_TRANSMITDATA,   //20 Transmited Data Size in byte
                FEV_RECEIVEDATA,    //21 Received Data Size in byte
                FEV_MODEMCOM_ERROR,  //22 Modem not respond
                FEV_IDLE,            //23 Port enter idle state
                FEV_STATUSCHANGE,    //24
                FEV_TERMINATE,       //25

                FEV_ANSWER_INTERRUPT , // 26 -- return TRUE if break
                FEV_DIAL_INTERRUPT ,  // 27  -- return TRUE if break
                FEV_HANGUP_INTERRUPT , // 28 -- return TRUE if break
                FEV_POLLING_OBJECT , // 29 -- return SendFaxObject
                FEV_INVALID_COMMAND , // 30
                FEV_REC_PASSWORD           , // 31
                FEV_REC_SUBADDRESS  , // 32
                FEV_REC_SELPOLLING  , // 33
                FEV_REC_DTMF        , // 34
                FEV_REC_CALLERID    , // 35
//G5
                FEV_G5_TURNAROUND,     // 36 --  lParam FAXOBJ
                FEV_G5_REPLYFILEFORMAT,// 37 --  lParam FAXOBJ
                FEV_G5_SENDDOCUMENT,   // 38 --  lParam PORTFAX
                FEV_G5_ENDSEND,        // 39 --  lParam FAXOBJ

                                FEV_DTMF_AVAILABLE,

                FEV_PAGE_DATA_RECEIVED,

                                FEV_ENDPORT=64,
                                     // 'This' param. is TCQueue
                FEV_QUEUE_IN=65,     //64 PARTOBJ
                FEV_QUEUE_OUT,       //65 PARTOBJ

};

//----------------------------------------------------------------------------
#undef CST_OFFHOOK
enum TECommStatus{CST_NOTHING= 0,
                  CST_WORKING= 1,
                  CST_ANSWER = 2,
                  CST_RECEIVE= 4,
                  CST_MANUAL= 8,
                  CST_SETUP= 16,
                  CST_OFFHOOK= 32,
                  CST_VOICE= 64,
                  CST_DISABLED= 128   
                  };

enum TEBaudRate{ BDR_NOCHANGE, BDR_2400, BDR_4800, BDR_7200, BDR_9600, BDR_12000, BDR_14400,
                 BDR_16800, BDR_19200, BDR_21600, BDR_24000, BDR_26400, BDR_28800, BDR_31200, BDR_33600, BDR_END };
enum TEResolution{ RES_NOCHANGE, RES_98LPI, RES_196LPI };
enum TEPageWidth{ PWD_NOCHANGE, PWD_1728, PWD_2048, PWD_2432, PWD_1216, PWD_864 };
enum TEPageLength{ PLN_NOCHANGE, PLN_A4, PLN_B4, PLN_UNLIMITED };
enum TECompression{ DCF_NOCHANGE, DCF_1DMH, DCF_2DMR, DCF_UNCOMPRESSED, DCF_2DMMR };
enum TEErrorCorrect{ ECM_NOCHANGE, ECM_DISABLE, ECM_ENABLE };
enum TEBinaryFile{ BFT_NOCHANGE, BFT_DISABLE, BFT_ENABLE };
enum TEG5Messaging{ G5_NOCHANGE, G5_DISABLE, G5_ENABLE };

enum TEScanLine{ SLN_NOCHANGE, SLN_0N0F, SLN_5N5F, SLN_10N5F, SLN_10N10F, SLN_20N10F, SLN_20N20F,
                SLN_40N20F, SLN_40N40F, SLN_END };

enum TEBitOrder{ BTO_FIRST_LSB, BTO_LAST_LSB, BTO_BOTH };

enum TEColorFax      { CFAX_NOCHANGE,CFAX_DISABLE,CFAX_ENABLE } ;
enum TEColorType     { CFAX_TRUECOLOR,CFAX_GRAYSCALE } ;


enum TEImageType {IMT_NOTHING, IMT_MEM_DIRECT, IMT_MEM_BITMAP, IMT_MEM_DIB,
                  IMT_MEM_END, IMT_FILE_DIRECT, IMT_FILE_BMP, IMT_FILE_PCX,
                  IMT_FILE_DCX, IMT_FILE_GIF, IMT_FILE_TGA, IMT_FILE_TIFF_NOCOMP,
                  IMT_FILE_TIFF_PACKBITS, IMT_FILE_TIFF_LZW, IMT_FILE_TIFF_LZDIFF, IMT_FILE_TIFF_G31DNOEOL, IMT_FILE_TIFF_G31D,
                  IMT_FILE_TIFF_G31D_REV, IMT_FILE_TIFF_G31D_BICOM, IMT_FILE_TIFF_G32D, IMT_FILE_TIFF_G4, IMT_FILE_CLS,IMT_FILE_JPEG, IMT_FILE_END,
                  IMT_BFTOBJ};

enum TEDialMode { TONE_DIAL, PULSE_DIAL} ;
enum TEDebugMode { DBG_NONE, DBG_PRINT_CMD, DBG_PRINT_INTR, DBG_MON, DBG_ERR, DBG_DEBUG, DBG_ALL } ;
enum TESendMode { SEND_MH_ALWAYS, SEND_SPECIFIED_ONLY };
enum TEChannelState { STATE_IDLE, STATE_OPEN };

enum TEFaxError {CFR_NOTHING, CFR_BUSY, CFR_NODIALTONE, CFR_NOANSWER, CFR_TIMEOUT, CFR_ERROR,
                 CFR_DRIVER, CFR_BADANSWER, CFR_BADREMOTEFAX, CFR_SYSTEM, CFR_FAXBADDIRECTION,
                 CFR_COMM, CFR_BADLINE,CFR_COMERROR,CFR_USERABORT,
                 CFR_BAD_RES, CFR_BAD_WIDTH, CFR_BAD_LENGTH, CFR_BAD_COMPRESS,
                 CFR_BAD_BFT, CFR_BAD_ECM,
#if defined(WIN32)
                CFR_BROOK_NO_LOOP_CURRENT,
                CFR_BROOK_LOCAL_IN_USE,
                CFR_BROOK_CALL_COLLISION,
                CFR_BROOK_FILEIO,
                CFR_BROOK_FILEFORMAT,
                CFR_BROOK_BOARDCAPABILITY,
                CFR_BROOK_NOTCONNECTED,
                CFR_BROOK_BADPARAMETER,
                CFR_BROOK_MEMORY,
                CFR_BROOK_BADSTATE,
                CFR_BROOK_TOOSOON,
                CFR_BROOK_CONFIRM,
                CFR_BROOK_DIALTON,
                CFR_BROOK_G2_DETECTED,
                CFR_BROOK_HUMAN,
                CFR_BROOK_QUIET,
                CFR_BROOK_RECALL,
                CFR_BROOK_RNGNOANS,
                CFR_BROOK_SITINTC,
                CFR_BROOK_SITNOCIR,
                CFR_BROOK_SITREORD,
                CFR_BROOK_SITVACOE,
                CFR_BROOK_NO_WINK,

                CFR_BROOK_RSPREC_VCNR,
                CFR_BROOK_COMREC_DCN,
                CFR_BROOK_RSPREC_DCN,
                CFR_BROOK_INCOMPAT_FMT,
                CFR_BROOK_INVAL_DMACNT,
                CFR_BROOK_FTM_NOECM,
                CFR_BROOK_INCMP_FTM,

                CFR_BROOK_RR_NORES,
                CFR_BROOK_CTC_NORES,
                CFR_BROOK_T5TO_RR,
                CFR_BROOK_NOCONT_NSTMSG,
                CFR_BROOK_ERRRES_EOREOP,
                CFR_BROOK_SE,
                CFR_BROOK_EORNULL_NORES,
                CFR_BROOK_EORMPS_NORES,
                CFR_BROOK_EOREOP_NORES,
                CFR_BROOK_EOREOM_NORES,

                CFR_BROOK_RCVB_SE,
                CFR_BROOK_NORMAL_RCV,
                CFR_BROOK_RCVB_RSPREC_DCN,
                CFR_BROOK_RCVB_INVAL_DMACNT,
                CFR_BROOK_RCVB_FTM_NOECM,

                CFR_BROOK_RCVD_SE_VCNR,
                CFR_BROOK_RCVD_COMREC_VCNR,
                CFR_BROOK_RCVD_T3TO_NORESP,
                CFR_BROOK_RCVD_T2TO,
                CFR_BROOK_RCVD_DCN_COMREC,
                CFR_BROOK_RCVD_COMREC_ERR,
                CFR_BROOK_RCVD_BLKCT_ERR,
                CFR_BROOK_RCVD_PGCT_ERR,
#endif
                CFR_HUMANVOICE, 
#ifdef WIN32
        /*
         *  General termination status codes ( mostly for Dialogic )
         */
                CFR_HDLCCARR,               // Excessive HDLC carrier
                CFR_OPINTFAIL,              // Operator intervention failed
                CFR_CEDTONE,                // Remote CED tone is longer than 5 secs
                CFR_PNSUCRX,                // No PN_SUCCESS returned by modem during rcv
                CFR_NXTCMDRX,               // Timed out wtng for next receive page cmd
                CFR_NOCARRIERRX,            // Lost carrier during Fax receive
                CFR_NOEOLRX,                // Timed out waiting for EOL
                CFR_NOFAXRX,                // Timed out waiting for first line
                CFR_DCNRRDRX,               // Unexpected DCN after RR/RNR sequence
                CFR_DCNNORTNRX,             // DCN after requested retransmission
                CFR_DCNPHDRX,               // Unexpected DCN after EOM/MPS sequence
                CFR_DCNFAXRX,               // Unexpected DCN while wtng for EOM/EOP/MPS
                CFR_DCNDATARX,              // Unexpected DCN while wtng for Fax data
                CFR_WHYDCNRX,               // Unexpected DCN while waiting for DCS/DIS
                CFR_GOTDCSRX,               // DCS received while waiting for DTC
                CFR_INVALMMRTX,             // Invalid input MMR data
                CFR_NXTCMDTX,               // Timeout waiting for next send page cmd
                CFR_BADPGTX,                // DCN response after sending page
                CFR_GOTDCNTX,               // Got DCN while waiting for DIS
                CFR_BADPHASE,               // unexpected phase transition
                CFR_DRVERROR,               // Error inside Dialogic API
                CFR_DISCONNECT,             // Remote has disconnected
                CFR_RETRYDCN,               // Disconnected after specifed retries
                CFR_NOTIDLE,                // channel is not idle
                CFR_POLLED,                 // Received poll from remote
                CFR_NOPOLL,                 // Remote did not accept poll
                CFR_COMPAT,                 // Hardware incapable of transmitting at specified width
//Bicom
               CFR_BI_HARDWAREERROR,
               CFR_BI_INVALIDPARAMETER,
               CFR_BI_CHANNEL_BUSY,
               CFR_BI_INVALIDUSERBUFFER,
               CFR_BI_FATAL_ERROR,
               CFR_BI_OUTOFMEMORY,
               CFR_BI_QUEUE_CORRUPTED,
               CFR_BI_INVALID_QUEUE,
               CFR_BI_QUEUE_EMPTY,
               CFR_BI_DOCUMENT_NOT_FOUND,
               CFR_BI_FAX_NOT_ACTIVE,
               CFR_BI_NOCHANNEL,
               CFR_BI_NO_LINE,
               CFR_BI_INVALIDRES,
               CFR_BI_INVALIDENCODING,
               CFR_BI_CREATE_ERROR,
               CFR_BI_RESOURCE_ERROR,
               CFR_BI_FILEEXIST,
               CFR_BI_FNAME_TOO_BIG,
               CFR_BI_NO_RESOURCES_AVAILABLE,
               CFR_BI_BADFILENAME,
               CFR_BI_INVALID_PAGE_TYPE,
               CFR_BI_INVALID_PAGE_LEN,
               CFR_BI_NOQUEUE,
               CFR_BI_POLLING_ENABLED,
               CFR_BI_CALLBACK_ENABLED,
               CFR_BI_NOTRAININGRESP,
               CFR_BI_NORESPONSE,
               CFR_BI_BAD_RESOLUTION,
               CFR_BI_BADENCODING,
               CFR_BI_NODOCUMENT,
//commetrex
               CFR_CMTRX_BAD_ARGUMENT,
               CFR_CMTRX_OUT_OF_MEMORY,
               CFR_CMTRX_INVALID_PORT,
               CFR_CMTRX_CONNECT_FAILED,
               CFR_CMTRX_ALREADY_ACTIVE,
               CFR_CMTRX_NOT_ACTIVE,
               CFR_CMTRX_NEGOTIATION_FAILED,
               CFR_CMTRX_NO_MORE_LICENSES,
               CFR_CMTRX_NO_LICENSE,
               CFR_CMTRX_LICENSE_ALREADY_ALLOC,
               CFR_CMTRX_QUEUE_EMPTY,
               CFR_CMTRX_FILE_EXISTS,
               CFR_CMTRX_FILE_NOT_FOUND,
               CFR_CMTRX_BAD_FILE_FORMAT,
               CFR_CMTRX_INVALID_DOC,
               CFR_CMTRX_QUEUE_TOO_LATE,
               CFR_CMTRX_SESSION_FAILED,
               CFR_CMTRX_UNSUPPORTED,
               CFR_CMTRX_OPEN_QUEUE_FAILED,
               CFR_CMTRX_BAD_PAGE_SIZE,
               CFR_CMTRX_FILE_IO_FAILURE,
               CFR_CMTRX_CONVERSION_REQUIRED,
               CFR_CMTRX_NO_MORE_DOCUMENTS,
               CFR_CMTRX_INCORRECT_LIBRARY_VERSION,
               CFR_CMTRX_RATE_TOO_LOW,
               CFR_CMTRX_QUEUE_OVERFLOW,
               CFR_CMTRX_ALREADY_ATTACHED,
               CFR_CMTRX_IMAGE_RECEIVE_FAIL,
               CFR_CMTRX_CPCD_BUSY,
               CFR_CMTRX_FAILURE,
               CFR_CMTRX_NO_FAX_RESOURCES,
               CFR_CMTRX_NO_RESOURCE_ASSIGNED,
               CFR_CMTRX_NO_CPCD_PORT,
               CFR_CMTRX_NO_PASSWORD,
               CFR_CMTRX_MONITOR_MISSING,
               CFR_CMTRX_MSEC_WAS_ALLOCATED,
               CFR_CMTRX_DIS_REJECT_REQUESTED,
               CFR_CMTRX_DIS_SIGNAL,
               CFR_CMTRX_DIS_CLEARDOWN_TONE,
               CFR_CMTRX_DIS_RING_STUCK,
               CFR_CMTRX_DIS_HOST_TIMEOUT,
               CFR_CMTRX_DIS_REMOTE_ABANDONED,
               CFR_CMTRX_DIS_TRANSFER,
               CFR_CMTRX_DIS_DIAL_FAILURE,
               CFR_CMTRX_DIS_NO_WINK,
               CFR_CMTRX_DIS_NO_DIALTONE,
               CFR_CMTRX_OUTOFSERVICE,
//nms
               CFR_NMS_BAD_ARGUMENT,
               CFR_NMS_FILE_EXISTS,
               CFR_NMS_FILE_NOT_FOUND,
               CFR_NMS_INVALID_CTAHANDLE,  //INVALID CONTEXT HANDLE
               CFR_NMS_INVALID_HANDLE,     //INVALID DOC QUEUE HANDLE
               CFR_NMS_BAD_FILE_FORMAT,
               CFR_NMS_QUEUE_TOO_LATE,
               CFR_NMS_OUTOFSERVICE,
               CFR_NMS_NO_MORE_LICENSES,
               CFR_NMS_FUNCTION_ACTIVE,
               CFR_NMS_QUEUE_EMPTY,
               CFR_NMS_CONNECT_FAILED,
               CFR_NMS_NEGOTIATION_FAILED,
               CFR_NMS_NO_LICENSE,
               CFR_NMS_LICENSE_ALREADY_ALLOC,
               CFR_NMS_SESSION_FAILED,
               CFR_NMS_OPEN_QUEUE_FAILED,
               CFR_NMS_BAD_PAGE_SIZE,
               CFR_NMS_CONVERSION_REQUIRED,
               CFR_NMS_CHECK_BAD_LINES,
               CFR_NMS_CHECK_DIFF_ATTRIB,
               CFR_NMS_NO_MORE_DOCUMENTS,
               CFR_NMS_RATE_TOO_LOW,
               CFR_NMS_BUFFER_UNDERRUN,
               CFR_NMS_NO_MODEMS,
               CFR_NMS_NO_PPM,
               CFR_NMS_NO_PPM_RESPONSE,
               CFR_NMS_INCOMPATIBLE_RECEIVER,
               CFR_NMS_PROTOCOL_ERROR,
               CFR_NMS_REMOTE_DCN,

#endif
};

enum TEFaxCapability {FDC_SETCOMPRESS, FDC_ONLINECOMPRESS, FDC_ECM, FDC_BINARY, FDC_WIDTH,
                      FDC_LENGTH, FDC_BAUD_SEND, FDC_BAUD_REC, FDC_NONSTDFRAME, FDC_BITORDER, FDC_FAXPOLLING,
                      FDC_RESOLUTION, FDC_GET_DTMF, FDC_G5, FDC_SEND_PAGE_DATA};  

enum TERuningMode {RNM_ALWAYSFREE, RNM_HALTINFRAME, RNM_HALTINFAX, RNM_ALWAYSHALT};
enum TEPhaseCoverage { PHC_ALL, PHC_NOHANGUP};

enum TEFaxManagerRes {FMR_DIALOGBOX, FMR_CURSOR};

enum TESpeakerTurnOn {STO_NEVER, STO_DIAL, STO_ALWAYS, STO_COMM};
enum TESpeakerVolume {SPV_LOWEST, SPV_MEDIUM, SPV_HIGH, SPV_HIGHEST};


// Page transmission status codes
enum TEPageStatus {
        TPS_NONE =0 , // no processed
        TPS_MCF  =1 , // Page good
        TPS_RTN  =2 , // Page bad , retrain request
        TPS_RTP  =3 , // Page good , retrain request
        TPS_PIN  =4 , // Page bad , interrupt request
        TPS_PIP  =5   // Page good, interrupt request
} ;

enum TETerminationStatus {
        TRM_NORMAL=0 ,              //0 Normal termination
        TRM_NONE ,                  //1 Session not terminated
        TRM_UNSPECIFIED ,           //2 Unspecified error
        TRM_RINGBACK ,              //3 Ringback detect
        TRM_ABORT   ,               //4 User abort
        TRM_NO_CARRIER ,            //5 No carrier detected
        TRM_BUSY      ,             //6 BUSY signal detect
        TRM_PHASE_A ,               //7 Uspecified phase A error
        TRM_PHASE_B ,               //8 Unspecified phase B error
        TRM_NO_ANSWER ,             //9 No Answer
        TRM_NO_DIALTONE,            //10 No dialtone
        TRM_INVALID_REMOTE ,        //11 Remote modem cannot receive or send
        TRM_COMREC_ERROR ,          //12 IN_TRANSMIT Phase B
        TRM_INVALID_COMMAND  ,      //13 Invalid command received
        TRM_INVALID_RESPONSE ,      //14 Invalid response received
        TRM_DCS_SEND ,              //15 DCS send 3 times without answer
        TRM_DIS_SEND ,              //16 DIS send without answer
        TRM_DIS_RECEIVED ,          //17 DIS received 3 times
        TRM_DIS_NOTRECEIVED ,       //18 DIS not received
        TRM_TRAINING    ,           //19 Failure training in 2400 bit/s
        TRM_TRAINING_MINSPEED,      //20 Failure training minimal sendspeed reached
        TRM_PHASE_C  ,              //21 Error in page transmission
        TRM_IMAGE_FORMAT ,          //22 unspecified image format
        TRM_IMAGE_CONVERSION ,      //23 Image conversion error
        TRM_DTE_DCE_DATA_UNDERFLOW ,//24 DTE to DCE data underflow
        TRM_UNRECOGNIZED_CMD ,      //25 Unrecognized transparent data command
        TRM_IMAGE_LINE_LENGTH ,     //26 Image error line length wrong
        TRM_IMAGE_PAGE_LENGTH  ,    //27 Page length wrong
        TRM_IMAGE_COMPRESSION  ,    //28 wrong compression mode
        TRM_PHASE_D ,               //29 Unspecified phase d error
        TRM_MPS ,                   //30 No response to MPS
        TRM_MPS_RESPONSE ,          //31 Invalid response to MPS
        TRM_EOP ,                   //32 No response to EOM
        TRM_EOP_RESPONSE ,          //33 Invalid response to EOM
        TRM_EOM ,                   //34 No response to EOM
        TRM_EOM_RESPONSE ,          //35 Invalid response to EOM
        TRM_UNABLE_TO_CONTINUE ,    //36 Unable to continue after PIN or PPP
        TRM_T2_TIMEOUT ,            //37 T.30 T2 timeout expected
        TRM_T1_TIMEOUT ,            //38 T.30 T1 timeout expected
        TRM_MISSING_EOL ,           //39 Missing EOL after 5 sec
        TRM_BAD_CRC ,               //40 Bad CRC or Frame
        TRM_DCE_DTE_DATA_UNDERFLOW ,//41 DCE to DTE data underflow
        TRM_DCE_DTE_DATA_OVERFLOW  ,//42 DCE to DTE data overflow
        // Remote cant send or receive
        TRM_INVALID_REMOTE_RECEIVE  , //43 Remote cannot receive
        TRM_INVALID_REMOTE_ECM ,    //44 Inv ECM
        TRM_INVALID_REMOTE_BFT ,    //45 Inv BFT
        TRM_INVALID_REMOTE_WIDTH ,  //46 Invalid width
        TRM_INVALID_REMOTE_LENGTH , //47 Invalid length
        TRM_INVALID_REMOTE_COMPRESS, //48 Compression
        TRM_INVALID_REMOTE_RESOLUTION ,  //49 Resolution
        TRM_INVALID_REMOTE_COLOR_MODE , //50 Remote cannot receive color faxes
        TRM_NO_SEND_DOCUMET ,       //51 No transmitting document
        TRM_PPS_RESPONSE ,          //52 No response to PPS
        TRM_NOMODEM ,               //53 No modem on comm port
        TRM_INVALIDCLASS ,          //54 Incompatible modem
#if defined(WIN32)
        // Only for Brooktrout termination
        TRM_B_UNSPECIFIED,           //55 Brooktrout
        TRM_B_FILEIO ,              //56 Brooktrout
        TRM_B_FILEFORMAT ,          //57 Brooktrout
        TRM_B_BOARDCAPABILITY ,     //58 Brooktrout
        TRM_B_NOTCONNECTED ,        //59 Brooktrout
        TRM_B_BADPARAMETER ,        //60 Brooktrout
        TRM_B_MEMORY ,              //61 Brooktrout
        TRM_B_BADSTATE ,            //62 Brooktrout
        TRM_B_TOOSOON,              //63 Brooktrout
        TRM_B_NO_LOOP_CURRENT ,     //64 Brooktrout
        TRM_B_LOCAL_IN_USE ,        //65 Brooktrout
        TRM_B_CALL_COLLISION ,      //66 Brooktrout
        TRM_B_NO_WINK,              //67 Brooktrout
        // OriginateCall progress signals
        TRM_B_CONFIRM,              //68 Confirmation tone
        TRM_B_DIALTON,              //69 The dialing sequence did not break the dial tone
        TRM_B_G2_DETECTED,          //70 Group 2 fax machine detected
        TRM_B_HUMAN,                //71 Answer (probable human ) detected
        TRM_B_QUIET,                //72 After dialing the number, no energy detected on the line; possible dead line
        TRM_B_RECALL,               //73 Recall dial tone detected
        TRM_B_RNGNOANS,             //74 Remote end was ringing but did not answer
        TRM_B_SITINTC,              //75 Invalide telephone number or class of service restriction
        TRM_B_SITNOCIR,             //76 No circuit detected, possible dead line
        TRM_B_SITREORD,             //77 Reorder tone detected
        TRM_B_SITVACOE,             //78 Remote originating failure; invalide telephone number
        // phase B hangup codes
        TRM_B_RSPREC_VCNR,              //79
        TRM_B_COMREC_DCN,               //80
        TRM_B_RSPREC_DCN,               //81
        TRM_B_INCOMPAT_FMT,             //82
        TRM_B_INVAL_DMACNT,             //83
        TRM_B_FTM_NOECM,                //84
        TRM_B_INCMP_FTM,                //85
        // phase D hangup codes
        TRM_B_RR_NORES,                 //86
        TRM_B_CTC_NORES,                //87
        TRM_B_T5TO_RR,                  //88
        TRM_B_NOCONT_NSTMSG,            //89
        TRM_B_ERRRES_EOREOP,            //90
        TRM_B_SE,                       //91
        TRM_B_EORNULL_NORES,            //92
        TRM_B_EORMPS_NORES,             //93
        TRM_B_EOREOP_NORES,             //94
        TRM_B_EOREOM_NORES,             //95
        // receive phase B hangup codes
        TRM_B_RCVB_SE,                  //96
        TRM_B_NORMAL_RCV,               //97
        TRM_B_RCVB_RSPREC_DCN,          //98
        TRM_B_RCVB_INVAL_DMACNT,        //99
        TRM_B_RCVB_FTM_NOECM,           //100
        // receive phase D hangup codes
        TRM_B_RCVD_SE_VCNR,             //101
        TRM_B_RCVD_COMREC_VCNR,         //102
        TRM_B_RCVD_T3TO_NORESP,         //103
        TRM_B_RCVD_T2TO,                //104
        TRM_B_RCVD_DCN_COMREC,          //105
        TRM_B_RCVD_COMREC_ERR,          //106
        TRM_B_RCVD_BLKCT_ERR,           //107
        TRM_B_RCVD_PGCT_ERR,            //108
#endif
        TRM_HUMANVOICE, //Human voice detected       //109
#ifdef WIN32
        /*
         *  General termination status codes ( mostly for Dialogic )
         */
        TRM_HDLCCARR,               //110 Excessive HDLC carrier
        TRM_OPINTFAIL,              //111 Operator intervention failed
        TRM_CEDTONE,                //112 Remote CED tone is longer than 5 secs
        TRM_PNSUCRX,                //113 No PN_SUCCESS returned by modem during rcv
        TRM_NXTCMDRX,               //114 Timed out wtng for next receive page cmd
        TRM_NOCARRIERRX,            //115 Lost carrier during Fax receive
        TRM_NOEOLRX,                //116 Timed out waiting for EOL
        TRM_NOFAXRX,                //117 Timed out waiting for first line
        TRM_DCNRRDRX,               //118 Unexpected DCN after RR/RNR sequence
        TRM_DCNNORTNRX,             //119 DCN after requested retransmission
        TRM_DCNPHDRX,               //120 Unexpected DCN after EOM/MPS sequence
        TRM_DCNFAXRX,               //121 Unexpected DCN while wtng for EOM/EOP/MPS
        TRM_DCNDATARX,              //122 Unexpected DCN while wtng for Fax data
        TRM_WHYDCNRX,               //123 Unexpected DCN while waiting for DCS/DIS
        TRM_GOTDCSRX,               //124 DCS received while waiting for DTC
        TRM_INVALMMRTX,             //125 Invalid input MMR data
        TRM_NXTCMDTX,               //126 Timeout waiting for next send page cmd
        TRM_BADPGTX,                //127 DCN response after sending page
        TRM_GOTDCNTX,               //128 Got DCN while waiting for DIS
        TRM_BADPHASE,               //129 unexpected phase transition
        TRM_DRVERROR,               //130 Error inside Dialogic API
        TRM_DISCONNECT,             //131 Remote has disconnected
        TRM_RETRYDCN,               //132 Disconnected after specifed retries
        TRM_NOTIDLE,                //133 channel is not idle
        TRM_POLLED,                 //134 Received poll from remote
        TRM_NOPOLL,                 //135 Remote did not accept poll
        TRM_COMPAT,                 //136 Hardware incapable of transmitting at specified width and resolution
        //TRM_
        //TRM_
        //TRM_
        //TRM_
//Bicom termination codes
        TRM_BI_HARDWAREERROR,           //137
        TRM_BI_INVALIDPARAMETER,        //138
        TRM_BI_CHANNEL_BUSY,            //139
        TRM_BI_INVALIDUSERBUFFER,       //140
        TRM_BI_FATAL_ERROR,             //141
        TRM_BI_OUTOFMEMORY,             //142
        TRM_BI_QUEUE_CORRUPTED,         //143
        TRM_BI_INVALID_QUEUE,           //144
        TRM_BI_QUEUE_EMPTY,             //145
        TRM_BI_DOCUMENT_NOT_FOUND,      //146
        TRM_BI_FAX_NOT_ACTIVE,          //147
        TRM_BI_NOCHANNEL,               //148
        TRM_BI_NO_LINE,                 //149
        TRM_BI_INVALIDRES,              //150
        TRM_BI_INVALIDENCODING,         //151
        TRM_BI_CREATE_ERROR,            //152
        TRM_BI_RESOURCE_ERROR,          //153
        TRM_BI_FILEEXIST,               //154
        TRM_BI_FNAME_TOO_BIG,           //155
        TRM_BI_NO_RESOURCES_AVAILABLE,  //156
        TRM_BI_BADFILENAME,             //157
        TRM_BI_INVALID_PAGE_TYPE,       //158
        TRM_BI_INVALID_PAGE_LEN,        //159
        TRM_BI_NOQUEUE,                 //160
        TRM_BI_POLLING_ENABLED,         //161
        TRM_BI_CALLBACK_ENABLED,        //162
        TRM_BI_NOTRAININGRESP,          //163
        TRM_BI_NORESPONSE,              //164
        TRM_BI_BAD_RESOLUTION,          //165
        TRM_BI_BADENCODING,             //166
        TRM_BI_NODOCUMENT,              //167
//COMMETREX termination codes

        TRM_CMTRX_BAD_ARGUMENT,         //168
        TRM_CMTRX_OUT_OF_MEMORY,        //169
        TRM_CMTRX_INVALID_PORT,         //170
        TRM_CMTRX_CONNECT_FAILED,       //171
        TRM_CMTRX_ALREADY_ACTIVE,       //172
        TRM_CMTRX_NOT_ACTIVE,           //173
        TRM_CMTRX_NEGOTIATION_FAILED,   //174
        TRM_CMTRX_NO_MORE_LICENSES,     //175
        TRM_CMTRX_NO_LICENSE,           //176
        TRM_CMTRX_LICENSE_ALREADY_ALLOC,        //177
        TRM_CMTRX_QUEUE_EMPTY,          //178
        TRM_CMTRX_FILE_EXISTS,          //179
        TRM_CMTRX_FILE_NOT_FOUND,       //180
        TRM_CMTRX_BAD_FILE_FORMAT,      //181
        TRM_CMTRX_INVALID_DOC,          //182
        TRM_CMTRX_QUEUE_TOO_LATE,       //183
        TRM_CMTRX_SESSION_FAILED,       //184
        TRM_CMTRX_UNSUPPORTED,          //185
        TRM_CMTRX_OPEN_QUEUE_FAILED,    //186
        TRM_CMTRX_BAD_PAGE_SIZE,        //187
        TRM_CMTRX_FILE_IO_FAILURE,      //188
        TRM_CMTRX_CONVERSION_REQUIRED,  //189
        TRM_CMTRX_NO_MORE_DOCUMENTS,    //190
        TRM_CMTRX_INCORRECT_LIBRARY_VERSION,    //191
        TRM_CMTRX_RATE_TOO_LOW,         //192
        TRM_CMTRX_QUEUE_OVERFLOW,       //193
        TRM_CMTRX_ALREADY_ATTACHED,     //194
        TRM_CMTRX_IMAGE_RECEIVE_FAIL,   //195
        TRM_CMTRX_CPCD_BUSY,            //196
        TRM_CMTRX_FAILURE,              //197
        TRM_CMTRX_NO_FAX_RESOURCES,     //198
        TRM_CMTRX_NO_RESOURCE_ASSIGNED, //199
        TRM_CMTRX_NO_CPCD_PORT,         //200
        TRM_CMTRX_NO_PASSWORD,          //201
        TRM_CMTRX_MONITOR_MISSING,      //202
        TRM_CMTRX_MSEC_WAS_ALLOCATED,   //203
        TRM_CMTRX_DIS_REJECT_REQUESTED, //204
        TRM_CMTRX_DIS_SIGNAL,           //205
        TRM_CMTRX_DIS_CLEARDOWN_TONE,   //206
        TRM_CMTRX_DIS_RING_STUCK,       //207
        TRM_CMTRX_DIS_HOST_TIMEOUT,     //208
        TRM_CMTRX_DIS_REMOTE_ABANDONED, //209
        TRM_CMTRX_DIS_TRANSFER,         //210
        TRM_CMTRX_DIS_DIAL_FAILURE,     //211
        TRM_CMTRX_DIS_NO_WINK,          //212
        TRM_CMTRX_DIS_NO_DIALTONE,      //213
        TRM_CMTRX_OUTOFSERVICE,         //214

        TRM_G5_NEGFAILED,               //215
        TRM_G5_NOG5RECEIVER,            //216
        TRM_NOG3FAXOBJ,                 //217

//nms termination codes
        TRM_NMS_BAD_ARGUMENT,           //218
        TRM_NMS_FILE_EXISTS,            //219
        TRM_NMS_FILE_NOT_FOUND,         //220
        TRM_NMS_INVALID_CTAHANDLE,  //INVALID CONTEXT HANDLE    //221
        TRM_NMS_INVALID_HANDLE,     //INVALID DOC QUEUE HANDLE  //222
        TRM_NMS_BAD_FILE_FORMAT,        //223
        TRM_NMS_QUEUE_TOO_LATE,         //224
        TRM_NMS_OUTOFSERVICE,           //225
        TRM_NMS_NO_MORE_LICENSES,       //226
        TRM_NMS_FUNCTION_ACTIVE,        //227
        TRM_NMS_QUEUE_EMPTY,            //228
        TRM_NMS_CONNECT_FAILED,         //229
        TRM_NMS_NEGOTIATION_FAILED,     //230
        TRM_NMS_NO_LICENSE,             //231
        TRM_NMS_LICENSE_ALREADY_ALLOC,  //232
        TRM_NMS_SESSION_FAILED,         //233
        TRM_NMS_OPEN_QUEUE_FAILED,      //234
        TRM_NMS_BAD_PAGE_SIZE,          //235
        TRM_NMS_CONVERSION_REQUIRED,    //236
        TRM_NMS_CHECK_BAD_LINES,        //237
        TRM_NMS_CHECK_DIFF_ATTRIB,      //238
        TRM_NMS_NO_MORE_DOCUMENTS,      //239
        TRM_NMS_RATE_TOO_LOW,           //240
        TRM_NMS_BUFFER_UNDERRUN,        //241
        TRM_NMS_NO_MODEMS,              //242
        TRM_NMS_NO_PPM,                 //243
        TRM_NMS_NO_PPM_RESPONSE,        //244
        TRM_NMS_INCOMPATIBLE_RECEIVER,  //245
        TRM_NMS_PROTOCOL_ERROR,         //246
        TRM_NMS_REMOTE_DCN,             //247
#endif
        TRM_RESENDPAGE,                 //248 the current page was resent 3 times, no more resends allowed
};

enum TEHeaderType {
    HDR_NONE,
    HDR_TEXT,
    HDR_DIB,
};

enum TEBoardType {
    BRD_NONE,
    BRD_BROOKTROUT,
    BRD_GAMMALINK,
    BRD_DIALOGIC,
    BRD_BICOM,
    BRD_COMMETREX,
    BRD_NMS,
	BRD_BROOKTROUT_TR1034
};

enum TEDialogicBoard {
    BOARDTYPE_ANALOG,
    BOARDTYPE_DIGITAL,
};

enum TEDialogicDateMode {
    DDATE_FMT_0,    // Disable internal date generation;
    DDATE_FMT_1,    // Date appears as: MM-DD-YYYY
    DDATE_FMT_2,    // Date appears as: MM/DD/YYYY
    DDATE_FMT_3,    // Date appears as: DD-MM-YYYY
    DDATE_FMT_4,    // Date appears as: DD/MM/YYYY
    DDATE_FMT_5,    // Date appears as: YYYY-DD-MM
    DDATE_FMT_6,    // Date appears as: YYYY/DD/MM
    DDATE_FMT_7=15, // Date appears as: day month dd YYYY Example: Fri Sep 13 1986
};

enum TEDialogicTimeMode {
    DTIME_FMT_0,    // Disable internal time generation;
    DTIME_FMT_1,    // Time appears as: HH:MM am/pm (12 hour clock)
    DTIME_FMT_2,    // Time appears as: HH:MM (24 hour clock)
};

//****************************************************************************
#define NAME_CLASS1  "Command Class One"
#define NAME_CLASS10			"Command Class 1.0 33.6 Fax"
#define NAME_CLASS2  "Command Class Two"
#define NAME_CLASS20 "Command Class Two.zero"
#if defined(WIN32)
#define NAME_CLASSBROOK "Brooktrout Fax Card"
#define NAME_CLASSBROOKTR1034 "Brooktrout TR1034 Fax Card"
#define NAME_CLASSGAMMA "GammaLink Fax Card"
#define NAME_CLDIALOGIC "Dialogic Fax Card"
#define NAME_CLBICOM "Bicom Fax Card"
#define NAME_CLCOMMETREX "Commetrex Fax Board"
#define NAME_CLNMS "NMS Fax Board"
#define NAME_CHANNELBROOK "Brooktrout Channel"
#define NAME_CHANNELBROOKTR1034 "Brooktrout TR1034 Channel"
#define NAME_CHANNELGAMMA "Gamma Channel"
#define NAME_CHANNELBICOM "Bicom Channel"
#define NAME_CHANNELCOMMETREX "Commetrex Channel"
#define NAME_CHANNELNMS "NMS Channel"
#define NAME_VOICEFAX1  "Command Voice Class One"
#define NAME_CHANNELDIALOGIC "Dialogic Channel"
#endif // win32
//****************************************************************************
#define SaveFaxShortKey "Fax Short Name"
#define SavePortNameKey "Port Name"
#define SaveFileNameKey "File Name"
#define FaxFileName     "FAXCPP.INI"
#define FaxLongNameKey  "Long Name"
#define FaxSetupKey     "Setup String"
#define FaxTypeNameKey  "Fax Type Name"
#define COMBaudKey      "COM Max Baud Rate "
#define StopBitsKey     "Stop Bits"
#define ByteSizeKey     "Byte Size"
#define ParityKey       "Parity"
#define FlowControlKey  "Flow Control"
#define DsrTimeoutKey   "DSR Timeout"
#define CtsTimeoutKey   "CTS Timeout"
#define FaxCppManagerID "FAX C++ MANAGER"
#define BitOrderKey     "Bit Order"
//****************************************************************************

// values for Dialogic header attributes
#define DHDR_INSERT     0x00  // Hdr is inserted before image (default)
#define DHDR_DISABLE    0x01  // Hdr is disabled
#define DHDR_UNDERLINE  0x04  // Hdr is underlined
#define DHDR_BOLD       0x08  // Hdr is displayed in bold typeface
#define DHDR_FMT1       0x00  // Hdr format 1 (default)
#define DHDR_FMT2       0x10  // Hdr format 2 (use FC_HDRUSER2)

#ifdef  __cplusplus
class TCCommPure;
typedef TCCommPure far * PORTFAX;

class TCFaxNormal;
typedef TCFaxNormal far * FAXOBJ;

class TCFaxError;
typedef TCFaxError far * FAXERROR;

class far TCBinaryParam;
typedef TCBinaryParam far * PTCBinaryParam;

#else // not __cplusplus

struct TSCommPure ;
typedef struct TSCommPure far * PORTFAX;
struct TSFaxNormal ;
typedef struct TSFaxNormal far * FAXOBJ;
struct TSTFaxError ;
typedef struct TSTFaxError far * FAXERROR;
struct TCBinaryParam;
typedef struct TCBinaryParam far * PTCBinaryParam;

#endif  // __cplusplus

typedef long (CALLBACK * ProcEvent)(void far * This, enum TEFaxEvent Event, LPARAM lParam);

//****************************************************************************
//****************************************************************************

struct TSHeaderRecord
{
    char Name[32];
    char Type[32];
    char FontFaceName[32];
    int  FontSize;
    int  Weight;
    BYTE Italic;
    BYTE Underline;
    BYTE StrikeOut;
    RECT Position;
};

struct TSHeaderContext
{
  char lpszFrom[ MAX_HEADER_CHARWIDTH ];
  char lpszTo[ MAX_HEADER_CHARWIDTH ];
  char lpszDateTimePage[ MAX_HEADER_CHARWIDTH ];
  int  Resolution;
  struct TSHeaderRecord Record[3];
  int Height;
};

struct TSPortStatus
{
    char    PortName[MAX_PORTNAME];
    WORD    Status;
    FAXOBJ  Fax;
    BOOL    Break;
    char    IniFileName[MAX_FILENAME];
    char    FaxName[MAX_SHORTFAX];
    char    SetupString[MAX_SETUPSTRING];
    char    FaxType[MAX_FAXTYPE];
    int     FaxNumber;
    int     PageNumber;
    long    ByteNumber;
    long    BaudRate  ;
    BOOL    ECMActive ;
    BOOL    BFTActive ;
};

//----------------------------------------------------------------------------
struct TStandardParam
{
    enum TEBaudRate       Baud;
    enum TEResolution     Resolut;
    enum TEPageWidth      Width;
    enum TEPageLength     Length;
    enum TECompression    Compress;
    enum TEErrorCorrect   Correction;
    enum TEBinaryFile     Binary;
    enum TEScanLine       Scan;
         BOOL             IsTransmitFax;
};

//----------------------------------------------------------------------------
struct
#ifdef  __cplusplus
CFAXAPI
#endif
TSFaxParam
{
         int             PageNum;
    enum TEResolution    Resolut;
    enum TEPageWidth     Width;
    enum TEPageLength    Length;
    enum TECompression   Compress;
    enum TEBinaryFile    Binary;
    enum TEBitOrder      BitOrder;
    enum TEErrorCorrect  Ecm;
    enum TEColorFax      ColorFax;
    enum TEColorType     ColorType;
    enum TESendMode      SendMode;

	char				RemoteNumber[MAX_CALLNUMBER];
	BOOL				Send;
	BOOL				DeleteFiles;
	char				Password[MAX_PASSWORD]; //password
#if defined(__cplusplus) && !defined(__BORLANDC__)
    EXPDEF TSFaxParam();
#endif
	DWORD				Priority;	//EA the fax's priority
	char				UserString[MAX_PATH+1];
};

struct TSFaxTime
{
    WORD tm_sec;        /* seconds after the minute - [0,59] */
    WORD tm_min;        /* minutes after the hour - [0,59] */
    WORD tm_hour;       /* hours since midnight - [0,23] */
    WORD tm_mday;       /* day of the month - [1,31] */
    WORD tm_mon;        /* months since January - [0,11] */
    WORD tm_year;       /* years since 1900 */
    WORD tm_wday;       /* days since Sunday - [0,6] */
    WORD tm_yday;       /* days since January 1 - [0,365] */
    WORD tm_isdst;      /* daylight savings time flag */
};

#define KEYSIZE     20
#define SUBADDRSIZE 20
#define NAMESIZE    40



struct TSFaxHeader
{
    BYTE      bType;
    WORD      wPageNum;
    BYTE      bResolut;
    BYTE      bWidth;
    BYTE      bLength;
    BYTE      bCompress;
    BYTE      bBinary;
    BYTE      bBitOrder;
    BYTE      bEcm   ;
    BYTE      bColorFax ;
    BYTE      bColorType ;
    char      RemoteNumber[MAX_CALLNUMBER];
    BYTE      bSend;
    struct TSFaxTime CreateTime;
    struct TSFaxTime SendTime;
    WORD      wRetry;
    WORD      wInterval;
    DWORD     dwTransmitTime;
    WORD      wSpeed;
    WORD      wStatus;
    WORD      wRefCnt;
    char      szKey[ KEYSIZE+1 ];
    char      szSubAddr[ MAX_SUBADRESS+1 ];
    char      szName[ NAMESIZE ];
    char      szCompany[ NAMESIZE ];
    BYTE      bSendMode;
    char      Password[MAX_PASSWORD];
    char      szPad[512-482];
    char      szCustom[100]  ;
};

//----------------------------------------------------------------------------
union TUFaxImage
{
    HBITMAP Bitmap;
    HGLOBAL Memory;
    HGLOBAL Dib;
    LPCSTR   File;
    PTCBinaryParam  BftObj;
};

//----------------------------------------------------------------------------
// FZ 07.jul.2004.
typedef char CLASSTYPE[25];
typedef char MANUFACT[256];
typedef char MODEMMODEL[256];

struct TSTestResult
{
    CLASSTYPE  ClassType; // FZ 11.jun.2004. ClassType[20] -> ClassType[25]  because added Class 8 and Class 80. 
    MANUFACT   Manufact;
    MODEMMODEL Model;
};
//****************************************************************************


enum TETransmitPhase {
        T_PHASE_CLOSED ,
        T_PHASE_SETUP ,
        T_PHASE_IDLE ,
        T_PHASE_A ,
        T_PHASE_B ,
        T_PHASE_TRAINING ,
        T_PHASE_C ,
        T_PHASE_D ,
        T_PHASE_E
};
#define TSModemCapabiliti TSModemCapability
struct
#ifdef  __cplusplus
CFAXAPI
#endif
TSModemCapability {
        char            ModemName[MAX_FAXLONGNAME]  ;
        enum TEBaudRate      MinBaudSend ; // Minimum send baud rate
        enum TEBaudRate      MaxBaudSend ; // Maximum send baud rate

        enum TEBaudRate      MinBaudRec  ; // Minimum receive baud rate
        enum TEBaudRate      MaxBaudRec  ; // Maximum receive baud rate

        enum TEErrorCorrect  Ecm         ; // Ecm enabled
        enum TEBinaryFile    Bft         ; // Bft enabled

        enum TEPageWidth     MinWidth    ; // Minimum page width
        enum TEPageWidth     MaxWidth    ; // Maximum page width

        enum TEPageLength    MinLength   ; // Min page length
        enum TEPageLength    MaxLength   ; // Max page length

        BOOL            NoStdFrame     ;  // Non standard frame enabled
        BOOL            SendPolling    ;  // Send Polling enabled
        BOOL            ReceivePolling ;  // Receive Polling enabled

        enum TEResolution    MinResolut      ;  // Resolution
        enum TEResolution    MaxResolut      ;  // Resolution

        enum TEScanLine      MinScanLine     ; // Minimum scanline time
        enum TEScanLine      MaxScanLine     ; // Maximum scanline time

        enum TECompression   MinCompression  ;
        enum TECompression   MaxCompression  ;

        enum TEColorFax      ColorFax            ; // Color fax enable disable
        enum TEColorType     ColorType           ; // Full color enable disable

        BYTE            Protocols       ; // Protocols CP_V27-CP_V29-CP_V17

        BOOL            bSubAddress     ; // Sub Adressing
        BOOL            bPassword       ; // Password
        BOOL            bCallerID       ; // Caller ID
        BOOL            bDTMF           ; // Sub Address
        BOOL            bSelectivePolling ; // Selective Polling
        BOOL            bSendPageData    ; // send the page data received while the fax transmission is in progress
        enum TEG5Messaging   G5          ;//G5 support    
        BOOL            BftPolling;

#if defined(__cplusplus) && !defined(__BORLANDC__)
public:
        EXPDEF TSModemCapabiliti();
#endif
}  ;

struct
#ifdef  __cplusplus
CFAXAPI
#endif
TSSessionParameters
{
    char       PortName[MAX_PORTNAME ]    ;  // Comm Deice Name
    char       ModemName[MAX_FAXLONGNAME] ;  // the Modem name
    char       FaxType[MAX_FAXTYPE]       ;  // Used Class Name

    // Static Parameters
    enum TESpeakerTurnOn Speeker ;
    enum TESpeakerVolume Volume  ;
    enum TEDialMode DialMode ;
    enum TEBitOrder BitOrder     ; // Bit order
    short      RingToAnswer ; // Number of rings to answer
    BOOL       FastReset    ; // Enable Disable fast reset
    BOOL       Enabled      ; // BOOL Fax Port Enabled o

    enum TEResolution  Resolution  ; // Resolution
    enum TEBaudRate    Baud        ; // Minimum send baud rate
    enum TEPageWidth   Width       ; // Minimum page width
    enum TEPageLength  Length      ; // Min page length
    enum TECompression Compression ; // Compression
    enum TESendMode    SendMode    ; // What to send

    enum TEErrorCorrect Ecm        ; // Ecm enabled
    enum TEBinaryFile  Bft         ; // Bft enabled
    enum TEScanLine    ScanLine    ; // Scanline Time

    enum TEColorFax    ColorFax    ; // Color fax enable disable
    enum TEColorType   ColorType   ; // True color or grayscale

    BYTE          Polling     ; // Polling enabled  BOOL
    BYTE          Send            ; // Receive Fax
    BYTE          Receive     ; // Send Fax

    BYTE          Protocol    ; // Used protocol

    BYTE          SendNSF[MAX__NSF]   ; // Received Non Standard Frame
    short         SendNSFSize        ; // sizeof NSF Frame
    BYTE          SendNSC[MAX__NSF]   ; // Received Non Standard command
    short         SendNSCSize        ; // sizeof Non Standard command

    BYTE          RecNSF[MAX__NSF]   ; // Received Non Standard Frame
    short         RecNSFSize        ; // sizeof NSF Frame
    BYTE          RecNSC[MAX__NSF]   ; // Received Non Standard command
    short         RecNSCSize        ; // sizeof Non Standard command


    char          DialNumber[MAX_CALLNUMBER] ;  // DialString

    char          LocalID[MAX_STATIONID] ;    // LocalStation ID
    char          RemoteID[MAX_STATIONID] ;   // RemoteStation ID


    char          Password[MAX_PASSWORD+1] ;  // 0 terminated string
    char          CallerID[MAX_CALLERID+1] ;  // 0 terminated string
    char          SubAddress[MAX_SUBADRESS+1] ; // 0 terminated string
    char          DTMF[MAX_DTMF+1] ; // 0 terminated string
    char          SelectivePool[MAX_SEP+1] ; // 0 terminated string


    DWORD         SessionNo ;
    enum TETerminationStatus TStatus       ;
    enum TETransmitPhase     TPhase ;
    enum TETransmitPhase     TerminatedPhase ;

    short         LineErrors ;
    short         SessionsErrors ;

    //  Page Transmission Status

    DWORD         dwBytesInPage ;
    DWORD         dwTransmitBytes ;
    DWORD         dwToltalTransmitBytes ;
    short         LineCount  ;
    short         PageNo ;
    short         DocumentNo ;
    short         TotalSendPages ;
    short         TotalSendDocuments ;

    // Transmission Timers
    DWORD               dwSessionTime ;
    DWORD               dwConnectTime ;

    // Loggings
    BOOL                LogEnabled      ;

	
#if defined(__cplusplus) && !defined(__BORLANDC__)
public:
    EXPDEF TSSessionParameters();
    TSSessionParameters& operator = (TSFaxParam & Param);
#endif
    PORTFAX             FaxPort;   
    enum TEG5Messaging  G5;         
    BOOL                BftPolling; 
    enum TEG5Status     G5_Status;  

	char                DNIS[MAX_DNIS+1] ;
} ;

#if defined(WIN32)
typedef struct {
    int				country_code;
    int				max_pagelist_len;
    unsigned int	voice_timeout;
    int				dma_size;
    int				ced_override;
    int				cabs_override;
    char			font_file[128];
    unsigned char	error_mult;
    unsigned char	error_thresh;
    unsigned char	error_enable;
    unsigned char	voice_silence_thresh;
    unsigned char	voice_silence_wait;
    unsigned char	wink_or_immediate;
    unsigned char	v_lp_break;
	char			bt_cparm[128];
	//TR114
	unsigned char	did_digits; 
	unsigned char	switch_hook;
	unsigned char	did_variable;
	char			digital_file[MAX_PATH];
	char			isdn_file[MAX_PATH];
    char			firm16_file[128];
    char			firm164_file[128];
    char			firm164_2m_file[128];
    unsigned char	width_behavior;
    unsigned char	subpwdsep;
    // for API 3.7
    unsigned char	agc;
    unsigned char	btnsf;
    unsigned char	busy_ct;
    unsigned char	dtmf_playoff;
    unsigned char	dtmf_twist;
    unsigned char	min_length;
    unsigned char	missing_wait;
    char			v_play_gain;
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
} ConfigBrooktrout ; //EA 2004 Aug 30. (for API 3.3.0)




// reason return codes from DialDBCheck
#define DL_REASON_NONE              0
#define DL_REASON_WRONG_DELAY   1
#define DL_REASON_UNSUCC_DELAY  2
#define DL_REASON_BLACK_PRE         3
#define DL_REASON_BLACK_MANUAL  4
#define DL_REASON_BLACK_WRONG   5
#define DL_REASON_BLACK_UNSUCC  6
#define DL_REASON_BLACK_SUM         7
#define DL_REASON_WRONG_LMT         8
#define DL_REASON_UNSUCC_LMT    9
#define DL_REASON_SUM_LMT           10
#define DL_REASON_TRK_UNS_DELAY 11
#define DL_REASON_UNKNOWN           99

#endif

typedef struct {
    PORTFAX            Port        ;
    enum TEResolution  Resolution  ;
    enum TEPageWidth   Width       ;
    enum TECompression Compression ;
    long               lPageNumber ;
    long               lTotalReceivedData;
    long               lDataSize;
    HGLOBAL            hReceivedData;
} TSReceivedPageData;

#pragma pack()

#endif // __FAXTYPE_H
