
// Status constants
#define STATUS_NOTHING      0
#define STATUS_WORKING      1
#define STATUS_ANSWER       2
#define STATUS_RECEIVE      4
#define STATUS_MANUAL       8
#define STATUS_SETUP        16
#define STATUS_OFFHOOK      32
#define STATUS_VOICE        64

// Baud rate constants
#define BR_NOCHANGE         1
#define BR_2400             2
#define BR_4800             3
#define BR_7200             4
#define BR_9600             5
#define BR_12000            6
#define BR_14400            7
#define BR_16800			8
#define BR_19200			9
#define BR_21600			10
#define BR_24000			11
#define BR_26400			12
#define BR_28800			13
#define BR_31200			14
#define BR_33600			15

// Resolution constants
#define RES_NOCHANGE        1
#define RES_98              2
#define RES_196             3

// Page width constants
#define WD_NOCHANGE         1
#define WD_1728             2
#define WD_2048             3
#define WD_2432             4
#define WD_1216             5
#define WD_864              6

// Page length constants
#define LN_NOCHANGE         1
#define LN_A4               2
#define LN_B4               3
#define LN_UNLIMITED        4

// Compression constants
#define CF_NOCHANGE         1
#define CF_1DMH             2
#define CF_2DMR             3
#define CF_UNCOMPRESSED     4
#define CF_2DMMR            5

// BFT cnstants
#define BF_NOCHANGE         1
#define BF_DISABLE          2
#define BF_ENABLE           3

// Error correction constants
#define EC_NOCHANGE         1
#define EC_DISABLE          2
#define EC_ENABLE           3

// Color constants
#define COL_NOCHANGE        1
#define COL_DISABLE         2
#define COL_ENABLE          3

// Color type
#define CTYPE_TRUECOLOR     1
#define CTYPE_GRAYSCALE     2

// Image type constants for set and get page
#define PAGE_FILE_BMP             1
#define PAGE_FILE_PCX             2
#define PAGE_FILE_DCX             3
#define PAGE_FILE_TGA             4
#define PAGE_FILE_JPEG            5
#define PAGE_FILE_TIFF_NOCOMP     6
#define PAGE_FILE_TIFF_PACKBITS   7
#define PAGE_FILE_TIFF_LZW        8
#define PAGE_FILE_TIFF_LZDIFF     9
#define PAGE_FILE_TIFF_G31DNOEOL  10
#define PAGE_FILE_TIFF_G31D       11
#define PAGE_FILE_TIFF_G31D_REV   12
#define PAGE_FILE_TIFF_G32D       13
#define PAGE_FILE_TIFF_G4         14
#define PAGE_FILE_ASCII           15
#define PAGE_FILE_DIRECT          16
#define PAGE_FILE_UNKNOWN         17
#define PAGE_MEMDIB               18

// Port capability constants
#define PC_MIN_COMPRESSION  1
#define PC_MAX_COMPRESSION  2
#define PC_ECM              3
#define PC_BINARY           4
#define PC_MIN_WIDTH        5
#define PC_MAX_WIDTH        6
#define PC_MIN_LENGTH       7
#define PC_MAX_LENGTH       8
#define PC_MIN_BAUD_SEND    9
#define PC_MAX_BAUD_SEND    10
#define PC_MIN_BAUD_REC     11
#define PC_MAX_BAUD_REC     12
#define PC_MIN_RESOLUTION   15
#define PC_MAX_RESOLUTION   16
#define PC_SENDPOLLING      17
#define PC_RECEIVEPOLLING   18
#define PC_COLORFAX         19
#define PC_RETURN_PAGE_FILE 20

// Fax parameter constants
#define FP_COMPRESSION      1
#define FP_ECM              2
#define FP_BINARY           3
#define FP_WIDTH            4
#define FP_LENGTH           5
#define FP_COLOR            6
#define FP_RESOLUTION       7
#define FP_PAGENUM          8
#define FP_SEND             9
#define FP_COLORTYPE       10
#define FP_TYPE            11

//Fax type constants
#define FT_NORMAL           1
#define FT_COLOR            2
#define FT_BFT              3

// Speaker mode
#define SMO_NEVER           0
#define SMO_ALWAYS          1
#define SMO_DIAL            2

// Speaker volume
#define SVO_LOW             0
#define SVO_MEDIUM          1
#define SVO_HIGH            2

// Error constants
#define FAX_ERR_SEND_FILE_NOT_EXISTS    -150
#define FAX_ERR_NO_VALID_COMMPORT       -151
#define FAX_ERR_COMMPORT_NOT_EXISTS     -152
#define FAX_ERR_CANNOT_CONNECT_PORT     -153
#define FAX_ERR_NO_FILE_TO_SEND         -154
#define FAX_ERR_NO_FAX_CREATED          -155
#define FAX_ERR_COMMPORT_ALREADY_INITIALIZED -156
#define FAX_ERR_MODEM_NOT_EXISTS        -157
#define FAX_ERR_NO_PHONE_NUMBER         -158
#define FAX_ERR_BAD_FAX_ID              -159
#define FAX_ERR_BAD_IMAGE_TYPE          -160
#define FAX_ERR_NO_FILENAME_SPECIFIED   -161
#define FAX_ERR_BAD_ASCII_FILE          -162
#define FAX_ERR_NO_HANDLE_SPECIFIED     -163
#define FAX_ERR_BAD_DIB_HANDLE          -164
#define FAX_ERR_NO_PORTS_OPEN           -165
#define FAX_ERR_UNRECOGNIZED_FILEFORMAT -166
#define FAX_ERR_TEST_FAILED             -167
#define FAX_ERR_BAD_FILENAME            -168
#define FAX_ERR_B_CHANNEL_BAD_TYPE      -169
#define FAX_ERR_NO_CONFIG_FILE          -170

// Termination codes
#define TER_NORMAL                  0   // Normal termination
#define TER_NONE                    1   // Session not terminated
#define TER_UNSPECIFIED             2   // Unspecified error
#define TER_RINGBACK                3   // Ringback detect
#define TER_ABORT                   4   // User abort
#define TER_NO_CARRIER              5   // No carrier detected
#define TER_BUSY                    6   // BUSY signal detect
#define TER_PHASE_A                 7   // Uspecified phase A error
#define TER_PHASE_B                 8   // Unspecified phase B error
#define TER_NO_ANSWER               9  // No Answer
#define TER_NO_DIALTONE             10  // No dialtone
#define TER_INVALID_REMOTE          11  // Remote modem cannot receive or send
#define TER_COMREC_ERROR            12  // IN_TRANSMIT Phase B
#define TER_INVALID_COMMAND         13  // Incvalid command received
#define TER_INVALID_RESPONSE        14  // Invalid response received
#define TER_DCS_SEND                15 // DCS send 3 times without answer
#define TER_DIS_SEND                16  // DIS send without answer
#define TER_DIS_RECEIVED            17  // DIS received 3 times
#define TER_DIS_NOTRECEIVED         18  // DIS not received
#define TER_TRAINING                19  // Failure training in 2400 bit/s
#define TER_TRAINING_MINSPEED       20  // Failure training minimal sendspeed reached
#define TER_PHASE_C                 21  // Error in page transmission
#define TER_IMAGE_FORMAT            22  // unspecified image format
#define TER_IMAGE_CONVERSION        23  // Image conversion error
#define TER_DTE_DCE_DATA_UNDERFLOW  24  // DTE to DCE data underflow
#define TER_UNRECOGNIZED_CMD        25  // Unrecognized transparent data command
#define TER_IMAGE_LINE_LENGTH       26  // Image error line length wrong
#define TER_IMAGE_PAGE_LENGTH       27  // Page length wrong
#define TER_IMAGE_COMPRESSION       28  // wrong compression mode
#define TER_PHASE_D                 29  // Unspecified phase d error
#define TER_MPS                     30  // No response to MPS
#define TER_MPS_RESPONSE            31  // Invalid response to MPS
#define TER_EOP                     32  // No response to EOM
#define TER_EOP_RESPONSE            33  // Invalid response to EOM
#define TER_EOM                     34  // No response to EOM
#define TER_EOM_RESPONSE            35    // Invalid response to EOM
#define TER_UNABLE_TO_CONTINUE      36    // Unable to continue after PIN or PPP
#define TER_T2_TIMEOUT              37    // T.30 T2 timeout expected
#define TER_T1_TIMEOUT              38    // T.30 T1 timeout expected
#define TER_MISSING_EOL             39    // Missing EOL after 5 sec
#define TER_BAD_CRC                 40    // Bad CRC or Frame
#define TER_DCE_DTE_DATA_UNDERFLOW  41    // DCE to DTE data underflow
#define TER_DCE_DTE_DATA_OVERFLOW   42    // DCE to DTE data overflow

#define TER_INVALID_REMOTE_RECEIVE  43  // Remote cannot receive
#define TER_INVALID_REMOTE_ECM      44  // Inv ECM
#define TER_INVALID_REMOTE_BFT      45  // Inv BFT
#define TER_INVALID_REMOTE_WIDTH    46  // Invalid width
#define TER_INVALID_REMOTE_LENGTH   47  // Invalid length
#define TER_INVALID_REMOTE_COMPRESS 48  // Compression
#define TER_INVALID_REMOTE_RESOLUTION 49 // Resolution
#define TER_INVALID_REMOTE_COLOR_MODE 50 // Remote cannot receive color faxes
#define TER_NO_SEND_DOCUMET         51  // No transmitting document
#define TER_PPS_RESPONSE            52  // No response to PPS
#define TER_NOMODEM                 53  // No modem on comm port
#define TER_INVALIDCLASS            54  // Incompatible modem

// Only for Brooktrout termination
#define TER_B_UNSPECIFIED           55  // Brooktrout
#define TER_B_FILEIO                56  // Brooktrout
#define TER_B_FILEFORMAT            57  // Brooktrout
#define TER_B_BOARDCAPABILITY       58  // Brooktrout
#define TER_B_NOTCONNECTED          59  // Brooktrout
#define TER_B_BADPARAMETER          60  // Brooktrout
#define TER_B_MEMORY                61  // Brooktrout
#define TER_B_BADSTATE              62  // Brooktrout
#define TER_B_TOOSOON               63  // Brooktrout
#define TER_B_NO_LOOP_CURRENT       64  // Brooktrout
#define TER_B_LOCAL_IN_USE          65  // Brooktrout
#define TER_B_CALL_COLLISION        66  // Brooktrout
#define TER_B_NO_WINK               67  // Brooktrout
// OriginateCall progress signals
#define TER_B_CONFIRM               68  // Confirmation tone
#define TER_B_DIALTON               69  // The dialing sequence did not break the dial tone
#define TER_B_G2_DETECTED           70  // Group 2 fax machine detected
#define TER_B_HUMAN                 71  // Answer (probable human ) detected
#define TER_B_QUIET                 72  // After dialing the number  no energy detected on the line; possible dead line
#define TER_B_RECALL                73  // Recall dial tone detected
#define TER_B_RNGNOANS              74  // Remote end was ringing but did not answer
#define TER_B_SITINTC               75  // Invalide telephone number or class of service restriction
#define TER_B_SITNOCIR              76  // No circuit detected, possible dead line
#define TER_B_SITREORD              77  // Reorder tone detected
#define TER_B_SITVACOE              78  // Remote originating failure; invalide telephone number

#define TER_B_RSPREC_VCNR           79
#define TER_B_COMREC_DCN            80
#define TER_B_RSPREC_DCN            81
#define TER_B_INCOMPAT_FMT          82
#define TER_B_INVAL_DMACNT          83
#define TER_B_FTM_NOECM             84
#define TER_B_INCMP_FTM             85
#define TER_B_RR_NORES              86
#define TER_B_CTC_NORES             87
#define TER_B_T5TO_RR               88
#define TER_B_NOCONT_NSTMSG         89
#define TER_B_ERRRES_EOREOP         90
#define TER_B_SE                    91
#define TER_B_EORNULL_NORES         92
#define TER_B_EORMPS_NORES          93
#define TER_B_EOREOP_NORES          94
#define TER_B_EOREOM_NORES          95
#define TER_B_RCVB_SE               96
#define TER_B_NORMAL_RCV            97
#define TER_B_RCVB_RSPREC_DCN       98
#define TER_B_RCVB_INVAL_DMACNT     99
#define TER_B_RCVB_FTM_NOECM        100

#define TER_B_RCVD_SE_VCNR          101
#define TER_B_RCVD_COMREC_VCNR      102
#define TER_B_RCVD_T3TO_NORESP      103
#define TER_B_RCVD_T2TO             104
#define TER_B_RCVD_DCN_COMREC       105
#define TER_B_RCVD_COMREC_ERR       106
#define TER_B_RCVD_BLKCT_ERR        107
#define TER_B_RCVD_PGCT_ERR         108

#define TER_HUMANVOICE              109 //rz

// Faxcard constants
#define CHANNEL_BROOKTROUT    1
#define CHANNEL_GAMMALINK     2

#define BROOKTROUT_PORTNAME "BChannel"
#define GAMMALINK_PORTNAME  "GChannel"

