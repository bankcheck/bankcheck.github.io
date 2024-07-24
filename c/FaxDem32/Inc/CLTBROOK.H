/****************************************************************************/
/*            (c) Copyright Black Ice Software Inc.  1994.                  */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/****************************************************************************/

#ifndef  __cplusplus
    #error  "This inlude file must be used with C++ compiler!"
#endif  // __cplusplus

#ifndef __CLTBROOK_H
#define __CLTBROOK_H

//****************************************************************************
// Include
#include "commcl.h"
#include "stdlib.h"

//****************************************************************************
#define BI_BTLINE void
#define BT_CALLBACK
#define HDR_HEADER 0
#define HDR_FOOTER 1

/* RES.status values */
#define BT_STATUS_OK	 		0
#define BT_STATUS_ERROR			2
#define BT_STATUS_ERROR_DIAL		3
#define BT_STATUS_ERROR_HANGUP		4
#define BT_STATUS_USER_TERMINATED	5
#define BT_STATUS_TIMEOUT		6
#define BT_STATUS_ALERT			7
#define BT_STATUS_VV			8


/* RES.line_status values */
/* if RES.status == BT_STATUS_ERROR */
#define APIERR_UNCLASSIFIED	0
/* An unclassified error */
#define APIERR_FILEIO		1
/* A file open/read/write error */
#define APIERR_FILEFORMAT	2
/* A file is not in the correct format */
#define APIERR_BOARDCAPABILITY	3
/* The hardware or firmware does not have a required capability */
#define APIERR_NOTCONNECTED	4
/* The channel is not in a connected state, but is required to be */
#define APIERR_BADPARAMETER	5
/* An invalid parameter has been passed */
#define APIERR_MEMORY		6
/* A memory allocation error occurred */
#define APIERR_BADSTATE		7
/* The channel is not in a required state */
#define APIERR_TOOSOON		8
/* Dialing was attempted too soon */
#define APIERR_BUSY		9
/* Resource busy */
#define APIERR_DRV_OPEN_ERROR	10
/* Driver open call failed, invalid channel or driver
   not correctly installed */
#define APIERR_DRV_IOCTL_ERROR	11
/* Driver call failed */
#define APIERR_VERSION		12
/* Incompatible driver version */
#define APIERR_INVALID_PORT	13
/* Invalid port; faxinit probably not run correctly */
#define APIERR_RINGING		14
/* Ringing during dialing attempt */
#define APIERR_INFOPKT_NESTING	15
/* Indir infopkt nesting level too deep */
#define APIERR_MAX_TAGS		16
/* Maximum number of TIFF tags exceeded */
#define APIERR_LOCK_FAILED	17
/* An attempt to gain a lock failed */

/* if RES.status == BT_STATUS_ERROR_DIAL */
#define DIAL_OK			257	/* Also possible for BT_STATUS_OK */
#define DIAL_NO_DIAL_TONE	258
#define DIAL_NO_LOOP_CUR	259
#define DIAL_LOCAL_IN_USE 	260
#define DIAL_TRUNK_BUSY 	261
#define DIAL_SLOT_BUSY	 	265
#define DIAL_CALL_COLLISION 	266
#define DIAL_NO_WINK	 	267
#define DIAL_ISDN_INVAL		268
#define DIAL_JP_REDIAL_FAIL	269
#define DIAL_UNKNOWN		500
#define MAX_KNOWN_DIAL_RESULT	0xc

/* RES.line_status values */
/* if RES.status == BT_STATUS_ERROR_HANGUP (0 thru 256 reserved) */
#define HNG_NORMAL_XMIT		0
#define HNG_RNG_DET		1
#define HNG_ABORT		2
#define HNG_NO_LOOP_CURRENT	3
#define HNG_ISDN_DISCONNECT	4
#define HNG_T1_TIMEOUT		11
#define HNG_XMITB_TIMEOUT	20
#define HNG_XMITB_NORM		21
#define HNG_XMITB_MISC		22
#define HNG_XMITB_COMREC_VCNR	23
#define HNG_XMITB_SE		24
#define HNG_XMITB_DCS_FTC	25
#define HNG_XMITB_DIS_FTC	26
#define HNG_XMITB_TRAINFAIL	27
#define HNG_XMITB_RSPREC_VCNR	28
#define HNG_XMITB_COMREC_DCN	29
#define HNG_XMITB_RSPREC_DCN	30
#define HNG_PHASEB_INCOMPAT_FMT	33
#define HNG_XMITB_INCOMPAT_FMT	33
#define HNG_XMITB_INVAL_DMACNT	34
#define HNG_XMITB_FTM_NOECM	35
#define HNG_XMITB_INCMP_FTM	36
#define HNG_XMITB_INCMP_EFF	37
#define HNG_XMITB_NOEFF		38
#define HNG_XMITD_RR_NORES	40
#define HNG_XMITD_CTC_NORES	41
#define HNG_XMITD_T5TO_RR	42
#define HNG_XMITD_NOCONT_NSTMSG	43
#define HNG_XMITD_ERRRES_EOREOP	44
#define HNG_XMITD_RTN_DCN	45
#define HNG_XMITD_PPR_EOR	46
#define HNG_XMITD_SE		51
#define HNG_XMITD_MPS_FTC	52
#define HNG_XMITD_MPS_VCNR	53
#define HNG_XMITD_EOP_FTC	54
#define HNG_XMITD_EOP_VCNR	55
#define HNG_XMITD_EOM_FTC	56
#define HNG_XMITD_EOM_VCNR	57
#define HNG_XMITD_RSPREC_DCN	60
#define HNG_XMITD_PPSNULL_NORES	61
#define HNG_XMITD_PPSMPS_NORES	62
#define HNG_XMITD_PPSEOP_NORES	63
#define HNG_XMITD_PPSEOM_NORES	64
#define HNG_XMITD_EORNULL_NORES	65
#define HNG_XMITD_EORMPS_NORES	66
#define HNG_XMITD_EOREOP_NORES	67
#define HNG_XMITD_EOREOM_NORES	68
#define HNG_RCVB_TIMEOUT	70
#define HNG_RCVB_SE		71
#define HNG_RCVB_MISC		72
#define HNG_T2_PNOTREC		73
#define HNG_RCVB_T1_TIMEOUT	74
#define HNG_NORMAL_RCV		75
#define HNG_RCVB_RSPREC_DCN	76
#define HNG_T2_TIMEOUT		77
#define HNG_RCVB_INVAL_DMACNT	78
#define HNG_RCVB_FTM_NOECM	79
#define HNG_RCVD_SE_VCNR	101
#define HNG_RCVD_COMREC_VCNR	102
#define HNG_RCVD_T3TO_NORESP	103
#define HNG_RCVD_T2TO		104
#define HNG_RCVD_DCN_COMREC	105
#define HNG_RCVD_COMREC_ERR	106
#define HNG_RCVD_BLKCT_ERR	107
#define HNG_RCVD_PGCT_ERR	108
#define HNG_INTERRUPT_ACK	240
#define HNG_COMM_FAULT		241
#define HNG_T30_HOLDUP		242
#define HNG_HOLDUP_DCN		243
#define HNG_HOLDUP_DCN_NON_FPAD	244
/* Fake hangup values, used for other errors of similar severity level */
#define HNG_ERROR_INTERRUPT	500
#define HNG_INTERRUPT_OVERRUN	501
#define HNG_UNEXPECTED_IRSDONE	502
#define HNG_IOCTL_ERROR		503
#define HNG_OVERLAY_DLOAD_ERR	504
#define HNG_MAX_TIMEOUT		505
/* Reserved for internal use */
#define HNG_RESERVED_1		900

/* final call progress results */
#define FCP_BASE		300	/* Not a CP value */
#define FCP_BUSY1		301
#define FCP_BUSY2		302
#define FCP_ROBUSY		303
#define FCP_RECALL		304
#define FCP_CONFIRM		305
#define FCP_PULSE		306
#define FCP_RING1		308
#define FCP_RING2		309
#define FCP_HUMAN		316
#define FCP_ANSWER		317
#define FCP_DIALTON		318
#define FCP_SILENCE		324
#define FCP_RNGNOANS		325
#define FCP_G2DETCT		326
#define FCP_SITINTC		327
#define FCP_QUIET		328
#define FCP_SITVACODE		329
#define FCP_SITREORD		330
#define FCP_SITNOCIR		331
#define FCP_CNGDETCT		332
#define FCP_RMTOFFHK		333
#define FCP_SPECIALCP		334
#define FCP_ANSWER_TONE_DETECT	339 /* Doesn't correspond to CS_ value */
#define FCP_UNKNOWN		340 /* Doesn't correspond to CS_ value */
#define FCP_ISDN_CALL_PROGRESS	348
#define FCP_ISDN_CALL_COLLISION	349


/* DebugModeSet bits */
#define DEBUG_NONE		0
#define DEBUG_PRINT_CMD		0x01
#define DEBUG_PRINT_INTR	0x02
#define DEBUG_MON		0x04
#define DEBUG_ERR		0x08
#define DEBUG_DEBUG		0x10
#define DEBUG_ALL		-1


/* LINE_... macros */
#define BOARD_TYPE_UNKNOWN	0
#define BOARD_TYPE_FAX		1
#define BOARD_TYPE_VOICE	2
#define BOARD_TYPE_TR114	3
#define BOARD_TYPE_TRUFAX	4

/* Resolutions */
#define RES_200H_100V	0
#define RES_200H_200V	1
#define RES_200H_400V	2
#define RES_300H_300V	3
#define RES_400H_400V	4
#define RES_NORMAL	RES_200H_100V
#define RES_FINE	RES_200H_200V
#define RES_600H_600V   5
#define RES_1200H_1200V 6
#define RES_300H_600V   7
#define RES_400H_800V   8
#define RES_600H_1200V  9
#define RES_100H_100V  10

/* Widths */
#define WIDTH_A4	0
#define WIDTH_B4	1
#define WIDTH_A3	2

/* Fax send/receive data formats */
#define FMT_MH_UNALIGN_MSB  0x00 /* MH data,  EOLS not byte-align, MSB order */
#define FMT_MH_UNALIGN_LSB  0x01 /* MH data,  EOLS not byte-align, LSB order */
#define FMT_MH_ALIGN_MSB    0x02 /* MH data,  EOLS byte-align,     MSB order */
#define FMT_MH_ALIGN_LSB    0x03 /* MH data,  EOLS byte-align,     LSB order */
#define FMT_MR_UNALIGN_MSB  0x04 /* MR data,  EOLS not byte-align, MSB order */
#define FMT_MR_UNALIGN_LSB  0x05 /* MR data,  EOLS not byte-align, LSB order */
#define FMT_MR_ALIGN_MSB    0x06 /* MR data,  EOLS byte-align,     MSB order */
#define FMT_MR_ALIGN_LSB    0x07 /* MR data,  EOLS byte-align,     LSB order */
#define FMT_MMR_UNALIGN_MSB 0x10 /* MMR data, EOLS not byte-align, MSB order */
#define FMT_MMR_UNALIGN_LSB 0x11 /* MMR data, EOLS not byte-align, LSB order */
#define FMT_MMR_ALIGN_MSB   0x12 /* MMR data, EOLS byte-align,     MSB order */
#define FMT_MMR_ALIGN_LSB   0x13 /* MMR data, EOLS byte-align,     LSB order */
#define FMT_ASCII	    0x08 /* Ascii data */
#define FMT_PCX_BILEVEL	    0x09 /* PCX data */
#define FMT_BINARY	    0x0a /* Binary data - reserved, not used */
#define FMT_SPACE	    0x0b /* Space, used internally */
#define FMT_PASS_THROUGH_LSB 0x16 /* Pass through LSB, used internally */
#define FMT_PASS_THROUGH_MSB 0x17 /* Pass through MSB, used internally */
/* Old data fmt types */
#define DATA_G3		FMT_MH_UNALIGN_MSB
#define DATA_ASCII	FMT_ASCII

struct dcs_info {
    unsigned char sent; /* Non-0 if sent, 0 if received */
    unsigned char Receiver_t4;
    unsigned char Data_Signalling_Rate;
    unsigned char Resolution;
    unsigned char TwoD_Coding;
    unsigned char Recording_Width;
    unsigned char Max_Recording_Length;
    unsigned char Min_Scan_Line_Time;
    
    /* The following fields are only set if the extend bit is on. */
    unsigned char Handshake_2400_bit;
    unsigned char Uncompressed_Mode;
    unsigned char Error_Correction_Mode;
    unsigned char Error_Limiting_Mode;
    unsigned char MMR;
    unsigned char Resolution_Unit;
    unsigned char Binary_File_Transfer;
    unsigned char Document_Transfer_Mode;
    unsigned char Edifact_Transfer;
    unsigned char Basic_Transfer_Mode;
    unsigned char Character_Mode;
    unsigned char Mixed_Mode;
    unsigned char Processable_Mode_26;
    unsigned char Store_And_Fwd_Internet_Fax;   /* 1 T.37 simple mode */
                                                /* 2 reserved */
    unsigned char Real_Time_Internet_Fax;       /* 3 T.38 */
                                                /* 4 reserved */
                                                /* 5 reserved */
                                                /* 6 invalid */
                                                /* 7 invalid */
                                                /* 8 reserved */

                                                /* 33 invalid */
                                                /* 34 set to "0" */
                                                /* 35 set to "0" */
    /* 36 T.43 lossless color/grayscale */
    unsigned char Lossless_Mode;
    /* 37 T.43 plane or strip interleaving */ 
    unsigned char Plane_Interleave_Mode;
    unsigned char ADPCM;                        /* 38 G.726 */
                                                /* 39 reserved */
    
    unsigned char Digital_Network;              /* 66 */
    unsigned char FullDuplex;                   /* 67 */
    unsigned char JPEG_Coding;                  /* 68 */
    unsigned char JPEG_FullColor;               /* 69 */
    unsigned char JPEG_Default_Tables;          /* 70 */
    unsigned char JPEG_12Bit;                   /* 71 */
                                                /* 72 extend */
    unsigned char JPEG_NoSubSampling;           /* 73 */
    unsigned char JPEG_CustomIlluminant;        /* 74 */
    unsigned char JPEG_CustomGamut;             /* 75 */
    unsigned char NA_Letter;                    /* 76 */
    unsigned char NA_Legal;                     /* 77 */
    unsigned char JBIG_Coding;                  /* 78 T.85 basic */
    unsigned char JBIG_L0;                      /* 79 T.85 optional L0 */
                                                /* 80 extend */
    unsigned char HKM_Key_Mgt;                  /* 81 */
    unsigned char RSA_Key_Mgt;                  /* 82 */
    unsigned char Override_Mode;                /* 83 */
    unsigned char HFX40_Cipher;                 /* 84 */
                                                /* 85 reserved */
                                                /* 86 reserved */
    unsigned char HFX40_Hashing;                /* 87 */
                                                /* 88 extend */
                                                /* 89 reserved */
                                                /* 90 reserved */
                                                /* 91 reserved */
    /* (92-94) T.44 Mixed Raster Content Mode */
    unsigned char MRC_Mode;
    /* 95 T.44 Page length max strip size */
    unsigned char MRC_Page_Length_Strips;
                                                /* 96 extend */
    /* 97 300H_300V or 400H_400V valid resolutions for color */
    /* 98 100H_100V color resolution */
    unsigned char PhaseC_BFT_Negotiations;      /* 99 */
                                                /* 100 set to "0" */
                                                /* 101 set to "0" */
    /* 102 Internet Routing Address */
    unsigned char IRA;
                                                /* 103 reserved */
                                                /* 104 extend */
    /* 105 600H_600V b&w or color */
    /* 106 1200H_1200V b&w or color */
                                                /* 107 300H_600V b&w only */
                                                /* 108 400H_800V b&w only */
                                                /* 109 600H_1200V b&w only */
                                                /* 110 reserved */
                                                /* 111 reserved */
                                                /* 112 extend */
};

/* Fax header insertion mode constants */
#define HDR_MODE_DISABLE 0x00
#define HDR_MODE_OVERLAY 0x01
#define HDR_MODE_REPLACE 0x02
#define HDR_MODE_INSERT  0x03

#define FSK_SUB_1	0xc2

#define BFT_NONE	0

#define CALL_PROTOCOL_FAX		1

/*
 * CCITT protocol tones
 */  
#define TONEID_CCITT_1	0	/* 462 Hz */
#define TONEID_CCITT_2	1	/* 1100 Hz */
#define TONEID_CCITT_3	2	/* 1650 Hz */
#define TONEID_CCITT_4	3	/* 1850 Hz */
#define TONEID_CCITT_5	4	/* 2100 Hz */

#define DTMF_16TONE		16

#define CODE_ADPCM	1

#define RATE_8000	1

#define BITS_4	2

/* Speech AFE sampling rates */
#define AFE_8000	0
#define AFE_9600	1

/* Speech data formats masks */
#define SPCH_MSB	0
#define SPCH_LSB	1

/* RES.line_status values for BfvLineWaitForCall() */
#define WAIT_FOR_CALL_OK		352
#define WAIT_FOR_CALL_TIMEOUT		353

/* CALL_RES.call_type values */
#define CALL_TYPE_DID	1
#define CALL_TYPE_RING	2
#define CALL_TYPE_LOCAL	3
#define CALL_TYPE_ISDN	4


enum line_state {
    LINE_STATE_IDLE,
    LINE_STATE_RINGING,
    LINE_STATE_CONNECTED,
    LINE_STATE_RCV_INFO,
    LINE_STATE_AWAIT_TRAINING,
    LINE_STATE_FAX_MODE,
    LINE_STATE_OFF_HOOK,
    LINE_STATE_TURNAROUND,
    LINE_STATE_RESETTING,
    LINE_STATE_HOLDUP,
    LINE_STATE_NOLOOP,
    LINE_STATE_VV,
    LINE_STATE_RETAIN
};

enum caps {
    /* Phone interface */
    /* Loop start interface */
    CAP_PHIF_ANALOG_LOOP_START,
    /* Centennial compatibility */
#define CAP_PHIF_LOOP_START CAP_PHIF_ANALOG_LOOP_START
    /* DID interface */
    CAP_PHIF_ANALOG_DID,
    /* Centennial compatibility */
#define CAP_PHIF_DID CAP_PHIF_ANALOG_DID
    /* MVIP interface */
    CAP_PHIF_MVIP,
    /* PEB interface */
    CAP_PHIF_PEB,
    /* MVIP or PEB interface. Centennial compatibility. */
    CAP_PHIF_MVIP_PEB,
    /* ISDN BRI interface */
    CAP_PHIF_ISDN_BRI,
    /* SCSA interface */
    CAP_PHIF_SCSA,
    /* Centennial compatibility */
#define CAP_PHIF_SCSA_PEB CAP_PHIF_SCSA
    /* H100 interface */
    CAP_PHIF_H100,
    /* T1 interface */
    CAP_PHIF_T1,
    /* Centennial compatibility */
#define CAP_PHIF_T1_ANALOG CAP_PHIF_T1
    /* E1 interface */
    CAP_PHIF_E1,
    /* PRI-E1 interface */
    CAP_PHIF_PRI_E1,
    /* PRI-T1 interface */
    CAP_PHIF_PRI_T1,
    /* AT-MODEM interface */
    CAP_PHIF_AT_MODEM,
    /* Can configure telephony attributes dynamically */
    CAP_DYN_TELEPH_CONFIG,

    /* Fax */
    /* Fax transmit/receive */
    CAP_FAX_XMIT,
    /* ECM capability */
    CAP_FAX_ECM,
    /* Can handle B4 and A3 widths, in addition to A4 */
    CAP_FAX_WIDTH,
    /* Can do "fax pad", per X.38 specs */
    CAP_FAX_PAD,
    /* Can transmit at 14400 and 12000 bps */
    CAP_FAX_SPEED_144,
    /* Can transmit/receive on the phone line in MMR format */
    CAP_FAX_MMR_XMIT,
    /* Can transmit/receive files stored in MMR format */
    CAP_FAX_MMR_FMT, 
    /* Can transmit/receive on the phone line in MR format and
       transmit/receive files stored in MR format. Centennial compatibility. */
    CAP_FAX_MR,
    /* Can transmit/receive on the phone line in MR format */
    CAP_FAX_MR_XMIT,
    /* Can transmit/receive files stored in MR format */
    CAP_FAX_MR_FMT, 
    /* BFT transmit/receive */
    CAP_BFT,
    /* Can transmit/receive files stored in PCX format */
    CAP_FAX_PCX_FMT,
    /* Native ASCII conversion */
    CAP_FAX_ASCII_NATIVE,
    /* Can transmit/receive the SUB, PWD, and SEP FSK signals */
    CAP_SUBPWDSEP,
    /* Supports fax page overlays */
    CAP_FAX_OVERLAY,
    /* Can force receive storage resolution */
    CAP_FAX_FORCE_RES,
    /* Handles high resolution faxes, 200x400, 300x300, 400x400 */
    CAP_FAX_2x4_3x3_4x4,
    /* Can add headers in overlay mode */
    CAP_FAX_HEADER_OVERLAY,
    /* G3 pass-through mode */
    CAP_FAX_G3_PT,
    /* JPEG pages (in pass-through style) */
    CAP_FAX_JPEG_PAGES,
    /* JBIG pages (in pass-through style) */
    CAP_FAX_JBIG_PAGES,
    /* JPEG format natively, for strips and storage formats */
    CAP_FAX_JPEG_NATIVE,
    /* JBIG format natively, for strips and storage formats */
    CAP_FAX_JBIG_NATIVE,
    /* T.43 Lossless color */
    CAP_FAX_LOSSLESS_COLOR,
    /* Independent local time for each channel */
    CAP_FAX_LOCAL_TIME,
    /* T.30 holdup */
    CAP_FAX_T30_HOLDUP,
    /* V.34 */
    CAP_FAX_V34,

    /* Speech */
    /* Speech playback. Note that all TR112 linecards will appear to have
       the speech playback capability, regardless of whether the option
       is installed on the cards. */
    CAP_SPEECH_PLAY,
    /* Speech recording */
    CAP_SPEECH_RECORD,
    /* Simultaneous speech playback and recording */
    CAP_SPEECH_SIMUL_PLAY_RECORD,
    /* Can play/record in Linear format */
    CAP_SPEECH_LINEAR,
    /* Can play/record in CVSD format */
    CAP_SPEECH_CVSD,
    /* Can play/record in ADPCM format */
    CAP_SPEECH_ADPCM,
    /* Can play/record in u-law PCM format */
    CAP_SPEECH_UPCM,
    /* Can play/record in OKI ADPCM format, obsolete */
    CAP_SPEECH_OKI_ADPCM,
    /* Can play/record in A-law PCM format */
    CAP_SPEECH_APCM, 
    /* Can play/record in Subband format */
    CAP_SPEECH_SUBBAND,
    /* Can play/record in G723-1 format */
    CAP_SPEECH_G723_1,
    /* Can play/record in G729-A format */
    CAP_SPEECH_G729_A,
    /* Can play/record in SX7300 format */
    CAP_SPEECH_SX7300,
    /* Can play/record in SX9600 format */
    CAP_SPEECH_SX9600,
    /* Can play/record in Rhetorex ADPCM format */
    CAP_SPEECH_RHET_ADPCM,
    /* Can play/record in MS GSM format */
    CAP_SPEECH_MS_GSM,
    /* Can play/record in DVI ADPCM format */
    CAP_SPEECH_DVI_ADPCM,
    /* Can play/record in GSM 6.10 format */
    CAP_SPEECH_GSM_610,
    /* Can play/record in GSM 6.60 format */
    CAP_SPEECH_GSM_660,
    /* Can play/record using raw data format */
    CAP_SPEECH_RAWDATA,

    /* Signal detection */
    /* Can detect MF tones */
    CAP_SIG_DET_MF,

    /* Signal generation */
    /* Can generate MF tones */
    CAP_SIG_GEN_MF,
    CAP_SIG_GEN_CP,
    CAP_SIG_GEN_CP_ADV,

    /* Network */
    CAP_NETWORK_CONFIG,CAP_NETWORK_QUERY,

    /* Capabilities used internally by the API library */
    CAP_FIRM_FLASH, CAP_FIRM_DYN_CTRL_PROC_APP, CAP_FIRM_DYN_DSP_LDR,
    CAP_FIRM_DYN_DSP_APP, CAP_CRIT_SEC, CAP_CRIT_SEC_RESP,
    CAP_SPEECH_FORMAT_INDEP, CAP_NVRAM_INITIALIZE, CAP_FTRL_DOWNLOAD,
    CAP_FTRL_QUERY, CAP_TELE_CTRL_PARAMS_SAVE,

    /* Terminator */
    CAP_TERMINATOR
};

#define BCONST const

#define BT_ZERO(item) memset((char *)&(item),0,sizeof(item))

typedef struct {
    int status;
    int line_status;
} BI_RES;

typedef struct {
    unsigned short tag;	/* Tag type, usually one of the TAG_... values */
    unsigned short field_type; /* Field type, one of the FT_... values */
    long count;		/* Number of values of the field type */
    long offset;	/* Offset for values, or the value(s) themselves */
}BI_ifd_field;

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


#define MAX_DID		256
#define MAX_NSF		256

typedef struct {
    int call_type;
    char dest_id[MAX_DID];
    /* The rest are ISDN only */
#define called_party_number dest_id
    char called_party_subaddress[MAX_DID];
    char calling_party_number[MAX_DID];
    char calling_party_subaddress[MAX_DID];
    char redir_number[MAX_DID];
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
    int     (* func)(BI_BTLINE *lp, char *arg);
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

#define PC_FIFO_NBYTES	10
#define LP_FIFO_NBYTES	10

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
    int (* func)(BI_BTLINE *lp, char *arg);//
    char *arg;//
    unsigned char *buf;
	unsigned size;
    const char *fname;//
    unsigned agc_value;//
    int use_agc;//
    int playf_cont;//
}BI_args_speech;

typedef struct _BI_args_tiff {
    BI_RES res;
    const char *fname;//
    const char *fmode;//
    BI_TFILE *tp;//
}BI_args_tiff;

typedef struct page_res {
    int page_complete_type;
    int continue_breaks;
    unsigned ascii_bytes;
    unsigned bad_lines;
    unsigned total_lines;
    unsigned total_rcv;
    unsigned bit_rate;
    unsigned page_status;
    unsigned char pc_fifo[PC_FIFO_NBYTES];
    unsigned sig_level;
    unsigned line_noise;
    unsigned sig_quality;
    unsigned char lp_fifo[LP_FIFO_NBYTES];
    unsigned char confirm_value;
    int direction;
    int resolution;
    int width;
    unsigned bft_type;
    unsigned long eff_page_type;
    struct page_res *next;
} BI_PAGE_RES;

typedef struct {
    int number_of_pages;
    int bad_pages;
    char remote_id[21];
    long duration;
    BI_PAGE_RES *reslist_head;
    BI_PAGE_RES *reslist_tail;
} BI_FAX_RES;

#define BTERR_SUPPORTED 1
typedef struct {
    char short_msg[31];
    char long_msg[129];
} BI_BTERR;



#define TMP_PKT_SIZE 1100
#define TMP_PKT_SIZE_LIMIT 1024
#define cmd_subcmd cmd_specifier

struct m_mill_addr {
    unsigned char mm_bFacility;
    unsigned char mm_bChannel;
    unsigned char mm_bModule;
    unsigned char mm_bMachine;
};
typedef struct m_mill_addr MILL_ADDR;

typedef void MILL_LINE;

struct BI_args_packet {
    BI_RES res;
    unsigned facility;
    unsigned cmd_verb;
    unsigned cmd_specifier;
    int prio;
    int incoming_flag;
    int no_hangup;
    unsigned timeout;
    unsigned char *cmd_buf;
    unsigned tag_id;
    unsigned tag_type;
    unsigned tag_len;
    unsigned char *tag_ptr;
    unsigned tag_data_len;
    unsigned char *tag_data_ptr;
    unsigned total_tag_len;
    unsigned var_value;
    unsigned flags;
    MILL_ADDR dest_addr;
    MILL_ADDR src_addr;
    unsigned cmd_len;
    unsigned pkt_len;
    unsigned char *pkt_buf;
    unsigned stored_len;
#ifndef PKTV1
    int sent;
#endif
    int dont_continue;
    unsigned char *data_parse_form_ptr;
    unsigned data_parse_form_len;
    unsigned bit_len;
    unsigned int_size;
    int ignore_data;
    int fac_src;
    unsigned char *orig_pkt_buf;
    unsigned orig_pkt_len;
    int clear_all;
    int already_parsed;
    int add_dbg_output;
    va_list *p_args_v;
    unsigned num_tags;
    int use_alt_chan;
    MILL_LINE *async_lp;
};


struct BI_args_cc
{
   int call_protocol_code;
   long timeout;
   char *phonenum;
   BI_RES res;
   int cause;
};

class FAXAPI TCCommClassBrookTR114 : public TCCommPure
{
public:
    static PORTFAX CALLBACK CreateTCCommClass(LPSTR FaxShortName, LPSTR FileName);
        EXPDEF TCCommClassBrookTR114( LPSTR CfgFileName );
    virtual EXPDEF ~TCCommClassBrookTR114();

    //CALL_BI_RES    m_cres;
    //BTERR       m_bterr;
    //INFO_BI_RES    m_ires;
    BI_RES      m_res;
    BI_FAX_RES     m_fres;
    char        m_szNum[MAX_CALLNUMBER];
    char        m_szSubAddress[MAX_CALLNUMBER];
    int         m_PageNo ;
    TMControl*  m_pWaitControl;
    TMControl*  m_pSendControl;
    TMControl*  m_pAnswerControl;
    TMControl*  m_pInitControl;
    TMControl*  m_pResetControl;
    TMControl*  m_pTerminate;			//BK 18/11/05
    HANDLE      m_hControl;     // mutex to exclude the different controls
    HANDLE      m_hWait;    // mutex to synchronize between SEND and WAIT threads
    HANDLE      m_hAbort;   // mutex to signal ABORTion
    HANDLE      m_hAbortDial; // mutex to synchronize ABORTing dial with abort
    HANDLE      m_hWaitThread, m_hAnswerThread, m_hSendThread;
    TECompression m_realcomp;
    BOOL        m_bBadFile;
    int         m_PageStatus, m_PagesSent, m_nActPage;
	BOOL		m_bIsReceiving;//EA
    static char *m_pChannels;
    BOOL        m_bTerminated;
	BOOL		m_bQuitWait;
    char        m_szDestDID[ MAX_DID ];

    // for Brooktrout dial database update
    BOOL     m_bHaveToUpdate;
    char     m_chUpdateNumber[80];  //MAX_PHONE_SIZE];
    char     m_chDialDB[_MAX_PATH];

//    inline      TFILE * GetG4File() { return m_pG4File; } ;
    inline  BI_BTLINE *GetBLinePtr() { return m_pLine; } ;
    inline  BOOL    GetRecFlag() { return bStartReceive ; } ;
    inline  BOOL    AbortDial() { return m_bAbortDial ; } ;

            int     GetErrorMessage( LPSTR lpBuffer );
            void    GetDID( LPSTR dstBuf );
            void    ErrorMessage( BI_RES *res );
            void    WritePageData( LPBYTE lpBuffer, int iSize );
            void    WriteFaxPage( int nActPage, LPCSTR Filename );
     static void    EXPDEF EnableDebug(TEDebugMode DebugMode);
    virtual int     EnableFaxPort(BOOL Enable);
    virtual int     ConnectPort( LPSTR PortName, HANDLE = NULL);
    virtual int     DisconnectPort();
    virtual int     DisconnectPortEx(BOOL bDSR);
    virtual FAXOBJ  EXPDEF AbortFax();
    virtual BOOL    IsOpen();
    virtual void    onStartDataSend();
    virtual BOOL    EndFaxSend();
    virtual BOOL    EndSendDocument();
    virtual BOOL    StartReceivePage();
    virtual BOOL    EndReceivePage();
    virtual BOOL    StartFaxReceive();
    virtual BOOL    EndFaxReceive();
    virtual BOOL    EndReceiveDocument();

    virtual void    SendBinaryData(LPBYTE lpData,int nBytes);
    virtual int     AnswerNow( BOOL Manual );
    virtual void    EXPDEF AutoAnswer (int RingNum);
    virtual int     ResetLine();
    virtual BOOL    SetupPortCapabilities(TSModemCapabiliti &NewModemCap );
    virtual void    SetStationID(LPCSTR lpBuffer);
    virtual void    EXPDEF SetDialMode(TEDialMode NewMode );
    virtual TETerminationStatus GetStatus( BI_RES *res, BOOL bSend );
    virtual int     CheckResult( BI_RES *res, BOOL bSend );
    virtual int     SetHeader( LPSTR str );
    virtual void    SetHeaderType( BOOL bHeader );
            void    StartControlSend();
            void    StartControlWait();
            void    StartControlAnswer();
            void    RestoreMaxCompression();
            void    SetMaxCompressionToDocument();
            void    SendEndPageEvent();
            int     DialDBCheck(LPSTR lpDBFile, LPSTR lpNumber, long *lpWaitTime, int *lpReason);
     static void    InitBrook();
     static void    ExitBrook();
     static BOOL    IsChannelFree( int num );
            void    StopAnswer();
            void    StopSend();
            void    StopWait();

             int    SetVoiceFile( LPSTR lpFileName );
             int    GetVoiceFile( LPSTR lpBuffer, int Max );
             int    SetVoiceTimeout( unsigned int WaitTime );
    unsigned int    GetVoiceTimeout();
             int    GetDTMFDigits( LPSTR lpBuffer, int Max );
             int    SetDTMFDigits( int n, char Value );
            void    SetDigitNumber( int n );
             int    GetDigitNumber() { return  m_cDTMFDigits; } ;
            VOID    DbgPrint( CHAR* format, ... );
             int    SendFax (FAXOBJ aFax, BOOL Manual );
    BI_args_fax m_args_fax;
    BI_args_telephone m_args_tel;

    BOOL    m_bOffHook;
static BOOL	m_bCallControlInitialized;
protected:
    BI_BTLINE*  m_pLine;
    BI_BTERR    m_Err;

    BOOL     m_bAbortDial;
    TCGlobError xerr;
    ConfigBrooktrout m_cfg;
    int      m_resolution, m_width, m_format, m_headertype;
    char     m_header[256];
    TCStr    m_strVoiceFile;
    char     m_strDigits[64];
    int      m_cDTMFDigits;

    TECompression m_lastmax;
    static TEDebugMode DebugMode;
//    void __cdecl LineInt( BI_BTLINE *lp, long tstamp,
//                unsigned cmd, unsigned dat, unsigned char *fifo );

    void    Init();
    void    SetSessionValues();
    void    SetEnvironment();
    void    GetPageParams();
    virtual BOOL        StartSendPage(int PageNo);
    virtual BOOL        EndSendPage(int PageNo);
    virtual BOOL        StartSendDocument();
    virtual void    LocalInit();
    virtual TMControl* mcInitialSetup();
    virtual TMControl* mcResetModem();
    virtual TMControl* mcAnswer() ;
    virtual TMControl* mcSendFax();
    virtual TMControl* mcWait();
    virtual TMControl* mcTerminate();
};


class FAXAPI TCCommClassBrookTR1034 : public TCCommPure
{
public:
    static PORTFAX CALLBACK CreateTCCommClass(LPSTR FaxShortName, LPSTR FileName);
        EXPDEF TCCommClassBrookTR1034( LPSTR CfgFileName );
    virtual EXPDEF ~TCCommClassBrookTR1034();

    //CALL_BI_RES    m_cres;
    //BTERR       m_bterr;
    //INFO_BI_RES    m_ires;
    BI_RES      m_res;
    BI_FAX_RES     m_fres;
    char        m_szNum[MAX_CALLNUMBER];
    char        m_szSubAddress[MAX_CALLNUMBER];
    int         m_PageNo ;
    TMControl*  m_pWaitControl;
    TMControl*  m_pSendControl;
    TMControl*  m_pAnswerControl;
    TMControl*  m_pInitControl;
    TMControl*  m_pResetControl;
    TMControl*  m_pTerminate;			//BK 18/11/05
    HANDLE      m_hControl;     // mutex to exclude the different controls
    HANDLE      m_hWait;    // mutex to synchronize between SEND and WAIT threads
    HANDLE      m_hAbort;   // mutex to signal ABORTion
    HANDLE      m_hAbortDial; // mutex to synchronize ABORTing dial with abort
    HANDLE      m_hWaitThread, m_hAnswerThread, m_hSendThread;
    TECompression m_realcomp;
    BOOL        m_bBadFile;
    int         m_PageStatus, m_PagesSent, m_nActPage;
	BOOL		m_bIsReceiving;//EA
    static char *m_pChannels;
    BOOL        m_bTerminated;
	BOOL		m_bQuitWait;
    char        m_szDestDID[ MAX_DID ];

    // for Brooktrout dial database update
    BOOL     m_bHaveToUpdate;
    char     m_chUpdateNumber[80];  //MAX_PHONE_SIZE];
    char     m_chDialDB[_MAX_PATH];

//    inline      TFILE * GetG4File() { return m_pG4File; } ;
    inline  BI_BTLINE *GetBLinePtr() { return m_pLine; } ;
    inline  BOOL    GetRecFlag() { return bStartReceive ; } ;
    inline  BOOL    AbortDial() { return m_bAbortDial ; } ;

            int     GetErrorMessage( LPSTR lpBuffer );
            void    GetDID( LPSTR dstBuf );
            void    ErrorMessage( BI_RES *res );
            void    WritePageData( LPBYTE lpBuffer, int iSize );
            void    WriteFaxPage( int nActPage, LPCSTR Filename );
     static void    EXPDEF EnableDebug(TEDebugMode DebugMode);
    virtual int     EnableFaxPort(BOOL Enable);
    virtual int     ConnectPort( LPSTR PortName, HANDLE = NULL);
    virtual int     DisconnectPort();
    virtual int     DisconnectPortEx(BOOL bDSR);
    virtual FAXOBJ  EXPDEF AbortFax();
    virtual BOOL    IsOpen();
    virtual void    onStartDataSend();
    virtual BOOL    EndFaxSend();
    virtual BOOL    EndSendDocument();
    virtual BOOL    StartReceivePage();
    virtual BOOL    EndReceivePage();
    virtual BOOL    StartFaxReceive();
    virtual BOOL    EndFaxReceive();
    virtual BOOL    EndReceiveDocument();

    virtual void    SendBinaryData(LPBYTE lpData,int nBytes);
    virtual int     AnswerNow( BOOL Manual );
    virtual void    EXPDEF AutoAnswer (int RingNum);
    virtual int     ResetLine();
    virtual BOOL    SetupPortCapabilities(TSModemCapabiliti &NewModemCap );
    virtual void    SetStationID(LPCSTR lpBuffer);
    virtual void    EXPDEF SetDialMode(TEDialMode NewMode );
    virtual TETerminationStatus GetStatus( BI_RES *res, BOOL bSend );
    virtual int     CheckResult( BI_RES *res, BOOL bSend );
    virtual int     SetHeader( LPSTR str );
    virtual void    SetHeaderType( BOOL bHeader );
            void    StartControlSend();
            void    StartControlWait();
            void    StartControlAnswer();
            void    RestoreMaxCompression();
            void    SetMaxCompressionToDocument();
            void    SendEndPageEvent();
            int     DialDBCheck(LPSTR lpDBFile, LPSTR lpNumber, long *lpWaitTime, int *lpReason);
     static void    InitBrook();
     static void    ExitBrook();
     static BOOL    IsChannelFree( int num );
            void    StopAnswer();
            void    StopSend();
            void    StopWait();

             int    SetVoiceFile( LPSTR lpFileName );
             int    GetVoiceFile( LPSTR lpBuffer, int Max );
             int    SetVoiceTimeout( unsigned int WaitTime );
    unsigned int    GetVoiceTimeout();
             int    GetDTMFDigits( LPSTR lpBuffer, int Max );
             int    SetDTMFDigits( int n, char Value );
            void    SetDigitNumber( int n );
             int    GetDigitNumber() { return  m_cDTMFDigits; } ;
            VOID    DbgPrint( CHAR* format, ... );
             int    SendFax (FAXOBJ aFax, BOOL Manual );
    BI_args_fax m_args_fax;
    BI_args_telephone m_args_tel;

    BOOL    m_bOffHook;
static BOOL	m_bCallControlInitialized;

static char     szConfig[MAX_PATH];

protected:
    BI_BTLINE*  m_pLine;
    BI_BTERR    m_Err;

    BOOL     m_bAbortDial;
    TCGlobError xerr;
    ConfigBrooktrout m_cfg;
    int      m_resolution, m_width, m_format, m_headertype;
    char     m_header[256];
    TCStr    m_strVoiceFile;
    char     m_strDigits[64];
    int      m_cDTMFDigits;

    TECompression m_lastmax;
    static TEDebugMode DebugMode;
//    void __cdecl LineInt( BI_BTLINE *lp, long tstamp,
//                unsigned cmd, unsigned dat, unsigned char *fifo );

    void    Init();
    void    SetSessionValues();
    void    SetEnvironment();
    void    GetPageParams();
    virtual BOOL        StartSendPage(int PageNo);
    virtual BOOL        EndSendPage(int PageNo);
    virtual BOOL        StartSendDocument();
    virtual void    LocalInit();
    virtual TMControl* mcInitialSetup();
    virtual TMControl* mcResetModem();
    virtual TMControl* mcAnswer() ;
    virtual TMControl* mcSendFax();
    virtual TMControl* mcWait();
    virtual TMControl* mcTerminate();
};

//****************************************************************************
#endif // __CLTBROOK_H
