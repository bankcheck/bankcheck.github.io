unit Main;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, OleCtrls, shellapi,
  FAXLib_TLB;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Commands1: TMenuItem;
    Comm1: TMenuItem;
    Send1: TMenuItem;
    Close1: TMenuItem;
    About1: TMenuItem;
    AboutOCXdemo1: TMenuItem;
    EventListBox: TListBox;
    Clear1: TMenuItem;
    N1: TMenuItem;
    FAX1: TFAX;
    OnlineHelp: TMenuItem;
    function  Errors(ErrorCode:integer):String;
    function  MakeTerminationText(TCode:integer):String;
    procedure FileExit(Sender: TObject);
    procedure AboutOCXdemo1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure ClickSend1(Sender: TObject);
    procedure CreateMain(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OnEndPage(Sender: TObject; const szPort: WideString;
      lPageNumber: Integer);
    procedure OnTerminate(Sender: TObject; const lpPort: WideString;
      lStatus: Integer; sPageNo: Smallint; ConnectTime: Integer;
      const szDID, szDTMF: WideString);
    procedure OnEndSend(Sender: TObject; const PortName: WideString;
      FaxID: Integer; const RemoteID: WideString);
    procedure FAX1_Dial(Sender: TObject; const PortName: WideString);
    procedure FAX1StartPage(Sender: TObject; const szPort: WideString;
      lPageNumber: Integer);
    procedure FAX1StartSend(Sender: TObject; const PortName: WideString);
    procedure FAX1TerminateExt(Sender: TObject; const lpPort: WideString;
      lStatus: Integer; sPageNo: Smallint; ConnectTime: Integer;
      const szDID, szDTMF, szSubaddress: WideString);
    procedure Clear1Click(Sender: TObject);
    procedure OnlineHelpClick(Sender: TObject);
    procedure Comm1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Commands1Click(Sender: TObject);
end;
const

{ Status constants}
            STATUS_NOTHING  =    0   ;
            STATUS_WORKING  =    1   ;
            STATUS_ANSWER   =    2   ;
            STATUS_RECEIVE  =    4   ;
            STATUS_MANUAL   =    8   ;
            STATUS_SETUP    =    16  ;
            STATUS_OFFHOOK  =    32  ;
            STATUS_VOICE    =    64  ;

{ Baud rate constants }
            BR_NOCHANGE     =    1   ;
            BR_2400         =    2   ;
            BR_4800         =    3   ;
            BR_7200         =    4   ;
            BR_9600         =    5   ;
            BR_12000        =    6   ;
            BR_14400        =    7   ;
            BR_16800        =    8   ;
            BR_19200        =    9   ;
            BR_21600        =   10   ;
            BR_24000        =   11   ;
            BR_26400        =   12   ;
            BR_28800        =   13   ;
            BR_31200        =   14   ;
            BR_33600        =   15   ;

{ Resolution constants     }
            RES_NOCHANGE    =    1   ;
            RES_98          =    2   ;
            RES_196         =    3   ;

{ Page width constants      }
            WD_NOCHANGE     =    1   ;
            WD_1728         =    2   ;
            WD_2048         =    3   ;
            WD_2432         =    4   ;
            WD_1216         =    5   ;
            WD_864          =    6   ;

{ Page length constants      }
            LN_NOCHANGE      =   1   ;
            LN_A4            =   2   ;
            LN_B4            =   3   ;
            LN_UNLIMITED     =   4   ;

{ Compression constants      }
            CF_NOCHANGE      =  1    ;
            CF_1DMH          =   2   ;
            CF_2DMR          =   3   ;
            CF_UNCOMPRESSED  =   4   ;
            CF_2DMMR         =   5   ;

{ BFT cnstants               }
            BF_NOCHANGE      =   1   ;
            BF_DISABLE       =   2   ;
            BF_ENABLE        =   3   ;

{ Error correction constants }
            EC_NOCHANGE      =   1   ;
            EC_DISABLE       =   2   ;
            EC_ENABLE        =   3   ;

{ Color constants            }
            COL_NOCHANGE     =   1   ;
            COL_DISABLE      =   2   ;
            COL_ENABLE       =   3   ;

{ Color type          }
            CTYPE_TRUECOLOR  =   1   ;
            CTYPE_GRAYSCALE  =   2   ;

{ Image type constants for set and get page}
            PAGE_FILE_BMP    =         1   ;
            PAGE_FILE_PCX    =         2   ;
            PAGE_FILE_DCX    =         3   ;
            PAGE_FILE_TGA    =         4   ;
            PAGE_FILE_JPEG   =         5   ;
            PAGE_FILE_TIFF_NOCOMP  =   6   ;
            PAGE_FILE_TIFF_PACKBITS =  7   ;
            PAGE_FILE_TIFF_LZW      =  8   ;
            PAGE_FILE_TIFF_LZDIFF   =  9   ;
            PAGE_FILE_TIFF_G31DNOEOL = 10  ;
            PAGE_FILE_TIFF_G31D      = 11  ;
            PAGE_FILE_TIFF_G31D_REV  = 12  ;
            PAGE_FILE_TIFF_G32D      = 13  ;
            PAGE_FILE_TIFF_G4        = 14  ;
            PAGE_FILE_ASCII          = 15  ;
            PAGE_FILE_DIRECT         = 16  ;
            PAGE_FILE_UNKNOWN        = 17  ;
            PAGE_MEMDIB              = 18  ;


{ Port capability constants   }
            PC_MIN_COMPRESSION = 1         ;
            PC_MAX_COMPRESSION = 2         ;
            PC_ECM             = 3         ;
            PC_BINARY          = 4         ;
            PC_MIN_WIDTH       = 5         ;
            PC_MAX_WIDTH       = 6         ;
            PC_MIN_LENGTH      = 7         ;
            PC_MAX_LENGTH      = 8         ;
            PC_MIN_BAUD_SEND   = 9         ;
            PC_MAX_BAUD_SEND   = 10        ;
            PC_MIN_BAUD_REC    = 11        ;
            PC_MAX_BAUD_REC    = 12        ;
            PC_MIN_RESOLUTION  = 15        ;
            PC_MAX_RESOLUTION  = 16        ;
            PC_SENDPOLLING     = 17        ;
            PC_RECEIVEPOLLING  = 18        ;
            PC_COLORFAX        = 19        ;

{ Fax parameter constants       }
            FP_COMPRESSION     = 1         ;
            FP_ECM             = 2         ;
            FP_BINARY          = 3         ;
            FP_WIDTH           = 4         ;
            FP_LENGTH          = 5         ;
            FP_COLOR           = 6         ;
            FP_RESOLUTION      = 7         ;
            FP_PAGENUM         = 8         ;
            FP_SEND            = 9         ;
            FP_COLORTYPE       =10         ;
            FP_TYPE            =11         ;

{Fax type constants            }
            FT_NORMAL          = 1         ;
            FT_COLOR           = 2         ;
            FT_BFT             = 3         ;

{ Speaker mode                  }
            SMO_NEVER           =0         ;
            SMO_ALWAYS          =1         ;
            SMO_DIAL            =2         ;

{ Speaker volume                }
            SVO_LOW             =0         ;
            SVO_MEDIUM          =1         ;
            SVO_HIGH            =2         ;

{ Error constants               }
            FAX_ERR_SEND_FILE_NOT_EXISTS =   -150;
            FAX_ERR_NO_VALID_COMMPORT    =   -151;
            FAX_ERR_COMMPORT_NOT_EXISTS  =   -152;
            FAX_ERR_CANNOT_CONNECT_PORT  =   -153;
            FAX_ERR_NO_FILE_TO_SEND      =   -154;
            FAX_ERR_NO_FAX_CREATED       =   -155;
            FAX_ERR_COMMPORT_ALREADY_INITIALIZED =-156 ;
            FAX_ERR_MODEM_NOT_EXISTS     =   -157      ;
            FAX_ERR_NO_PHONE_NUMBER      =   -158      ;
            FAX_ERR_BAD_FAX_ID           =   -159      ;
            FAX_ERR_BAD_IMAGE_TYPE       =   -160      ;
            FAX_ERR_NO_FILENAME_SPECIFIED =  -161      ;
            FAX_ERR_BAD_ASCII_FILE        =  -162      ;
            FAX_ERR_NO_HANDLE_SPECIFIED   =  -163      ;
            FAX_ERR_BAD_DIB_HANDLE        =  -164      ;
            FAX_ERR_NO_PORTS_OPEN         =  -165      ;
            FAX_ERR_UNRECOGNIZED_FILEFORMAT =-166      ;
            FAX_ERR_TEST_FAILED             =-167      ;
            FAX_ERR_BAD_FILENAME            =-168      ;
            FAX_ERR_B_CHANNEL_BAD_TYPE      =-169      ;
            FAX_ERR_NO_CONFIG_FILE          =-170      ;
            FAX_ERR_DEMO_VERSION_IS_SINGLEPORT=-171    ;
            FAX_ERR_DEMO_VERSION_IS_SINGLEPAGE=-172    ;

{ Termination codes                         }
            TER_NORMAL      =            0  ; { Normal termination}
            TER_NONE        =            1  ; { Session not terminated}
            TER_UNSPECIFIED =            2  ; { Unspecified error      }
            TER_RINGBACK    =            3  ; { Ringback detect         }
            TER_ABORT       =            4 ; { User abort             }
            TER_NO_CARRIER  =            5  ; { No carrier detected    }
            TER_BUSY        =            6  ; { BUSY signal detect     }
            TER_PHASE_A     =            7  ; { Uspecified phase A error }
            TER_PHASE_B     =            8  ; { Unspecified phase B error }
            TER_NO_ANSWER   =            9 ; { No Answer                 }
            TER_NO_DIALTONE =            10 ; { No dialtone               }
            TER_INVALID_REMOTE  =        11 ; { Remote modem cannot receive or send }
            TER_COMREC_ERROR    =        12 ; { IN_TRANSMIT Phase B    }
            TER_INVALID_COMMAND =        13 ; { Incvalid command received }
            TER_INVALID_RESPONSE=        14 ; { Invalid response received  }
            TER_DCS_SEND        =        15 ; { DCS send 3 times without answer }
            TER_DIS_SEND        =        16 ; { DIS send without answer          }
            TER_DIS_RECEIVED    =        17 ; { DIS received 3 times             }
            TER_DIS_NOTRECEIVED =        18 ; { DIS not received                 }
            TER_TRAINING        =        19 ; { Failure training in 2400 bit/s   }
            TER_TRAINING_MINSPEED =      20 ; { Failure training minimal sendspeed reached}
            TER_PHASE_C           =      21 ; { Error in page transmission       }
            TER_IMAGE_FORMAT      =      22 ; { unspecified image format         }
            TER_IMAGE_CONVERSION  =      23 ; { Image conversion error           }
            TER_DTE_DCE_DATA_UNDERFLOW = 24 ; { DTE to DCE data underflow        }
            TER_UNRECOGNIZED_CMD       = 25 ; { Unrecognized transparent data command}
            TER_IMAGE_LINE_LENGTH      = 26 ; { Image error line length wrong }
            TER_IMAGE_PAGE_LENGTH      = 27 ; { Page length wrong                }
            TER_IMAGE_COMPRESSION      = 28 ; { wrong compression mode           }
            TER_PHASE_D                = 29  ;{ Unspecified phase d error        }
            TER_MPS                    = 30 ; { No response to MPS               }
            TER_MPS_RESPONSE           = 31 ; { Invalid response to MPS          }
            TER_EOP                    = 32 ;  { No response to EOM               }
            TER_EOP_RESPONSE           = 33;  { Invalid response to EOM          }
            TER_EOM                    = 34 ; { No response to EOM               }
            TER_EOM_RESPONSE           = 35 ;   { Invalid response to EOM        }
            TER_UNABLE_TO_CONTINUE     = 36 ;   { Unable to continue after PIN or PPP }
            TER_T2_TIMEOUT             = 37 ;   { T.30 T2 timeout expected            }
            TER_T1_TIMEOUT             = 38 ;   { T.30 T1 timeout expected            }
            TER_MISSING_EOL            = 39 ;   { Missing EOL after 5 sec             }
            TER_BAD_CRC                = 40 ;   { Bad CRC or Frame                    }
            TER_DCE_DTE_DATA_UNDERFLOW = 41 ;   { DCE to DTE data underflow           }
            TER_DCE_DTE_DATA_OVERFLOW  = 42 ;   { DCE to DTE data overflow            }
            TER_INVALID_REMOTE_RECEIVE = 43 ; { Remote cannot receive                 }
            TER_INVALID_REMOTE_ECM     = 44 ;  { Inv ECM                               }
            TER_INVALID_REMOTE_BFT     = 45 ;  { Inv BFT                               }
            TER_INVALID_REMOTE_WIDTH   = 46 ;  { Invalid width                         }
            TER_INVALID_REMOTE_LENGTH  = 47 ; { Invalid length                        }
            TER_INVALID_REMOTE_COMPRESS = 48;  { Compression                          }
            TER_INVALID_REMOTE_RESOLUTION =49; { Resolution                          }
            TER_INVALID_REMOTE_COLOR_MODE =50 ;{ Remote cannot receive color faxes    }
            TER_NO_SEND_DOCUMET         =51 ;{ No transmitting document              }
            TER_PPS_RESPONSE            =52  ;{ No response to PPS                    }
            TER_NOMODEM                 =53  ;{ No modem on com port                  }
            TER_INVALIDCLASS            =54  ;{ Incompatible modem                    }
{ Only for Brooktrout termination       }
            TER_B_UNSPECIFIED           =55  ;{ Brooktrout                            }
            TER_B_FILEIO                =56  ;{ Brooktrout                            }
            TER_B_FILEFORMAT            =57  ;{ Brooktrout                            }
            TER_B_BOARDCAPABILITY       =58  ;{ Brooktrout                            }
            TER_B_NOTCONNECTED          =59  ;{ Brooktrout                            }
            TER_B_BADPARAMETER          =60  ;{ Brooktrout                            }
            TER_B_MEMORY                =61  ;{ Brooktrout                            }
            TER_B_BADSTATE              =62  ;{ Brooktrout                            }
            TER_B_TOOSOON               =63  ;{ Brooktrout                            }
            TER_B_NO_LOOP_CURRENT       =64  ;{ Brooktrout                            }
            TER_B_LOCAL_IN_USE          =65  ;{ Brooktrout                            }
            TER_B_CALL_COLLISION        =66  ;{ Brooktrout                            }
            TER_B_NO_WINK               =67  ;{ Brooktrout                            }
{ OriginateCall progress signals        }
            TER_B_CONFIRM               =68  ;{ Confirmation tone                      }
            TER_B_DIALTON               =69  ;{ The dialing sequence did not break the dial tone   }
            TER_B_G2_DETECTED           =70  ;{ Group 2 fax machine detected          }
            TER_B_HUMAN                 =71  ;{ Answer (probable human ) detected     }
            TER_B_QUIET                 =72  ;{ After dialing the number  no energy detected on the line; possible dead line}
            TER_B_RECALL                =73  ;{ Recall dial tone detected             }
            TER_B_RNGNOANS              =74 ;{ Remote end was ringing but did not answer }
            TER_B_SITINTC               =75  ;{ Invalide telephone number or class of service restriction }
            TER_B_SITNOCIR              =76  ;{ No circuit detected, possible dead line                   }
            TER_B_SITREORD              =77  ;{ Reorder tone detected                                     }
            TER_B_SITVACOE              =78  ;{ Remote originating failure; invalide telephone number     }

            TER_B_RSPREC_VCNR           =79  ;
            TER_B_COMREC_DCN            =80  ;
            TER_B_RSPREC_DCN            =81  ;
            TER_B_INCOMPAT_FMT          =82  ;
            TER_B_INVAL_DMACNT          =83  ;
            TER_B_FTM_NOECM             =84  ;
            TER_B_INCMP_FTM             =85  ;
            TER_B_RR_NORES              =86  ;
            TER_B_CTC_NORES             =87  ;
            TER_B_T5TO_RR               =88  ;
            TER_B_NOCONT_NSTMSG         =89  ;
            TER_B_ERRRES_EOREOP         =90  ;
            TER_B_SE                    =91  ;
            TER_B_EORNULL_NORES         =92  ;
            TER_B_EORMPS_NORES          =93  ;
            TER_B_EOREOP_NORES          =94  ;
            TER_B_EOREOM_NORES          =95  ;

            TER_B_RCVB_SE               =96  ;
            TER_B_NORMAL_RCV            =97  ;
            TER_B_RCVB_RSPREC_DCN       =98  ;
            TER_B_RCVB_INVAL_DMACNT     =99 ;
            TER_B_RCVB_FTM_NOECM        =100 ;
            TER_B_RCVD_SE_VCNR          =101 ;
            TER_B_RCVD_COMREC_VCNR      =102 ;
            TER_B_RCVD_T3TO_NORESP      =103 ;
            TER_B_RCVD_T2TO             =104 ;
            TER_B_RCVD_DCN_COMREC       =105 ;
            TER_B_RCVD_COMREC_ERR       =106 ;
            TER_B_RCVD_BLKCT_ERR        =107 ;
            TER_B_RCVD_PGCT_ERR         =108 ;
            TER_HUMANVOICE              =109 ;

{ Faxcard constants                     }
            CHANNEL_BROOKTROUT    =1         ;
            CHANNEL_GAMMALINK     =2         ;

            BROOKTROUT_PORTNAME = 'BChannel' ;
            GAMMALINK_PORTNAME  = 'GChannel' ;


var
  MainForm: TMainForm;


implementation

uses OpenDlg, SendDlg, AboutDlg, CloseDlg;

{$R *.DFM}

function TMainForm.Errors(ErrorCode:integer):String;
begin
     case ErrorCode of
          FAX_ERR_SEND_FILE_NOT_EXISTS:
          Errors := 'The specified file doesn’t exist.';

          FAX_ERR_NO_VALID_COMMPORT:
          Errors := 'The specified communication port is invalid.';

          FAX_ERR_COMMPORT_NOT_EXISTS:
          Errors := 'The specified communication port doesn’t exist.';

          FAX_ERR_CANNOT_CONNECT_PORT:
          Errors := 'The connect to the port was unsuccessful.';

          FAX_ERR_NO_FILE_TO_SEND:
          Errors := 'No file was specified for sending.';

          FAX_ERR_NO_FAX_CREATED:
          Errors := 'The creation of the fax object failed.';

          FAX_ERR_COMMPORT_ALREADY_INITIALIZED:
          Errors := 'The specified communication port was already initialized.';

          FAX_ERR_MODEM_NOT_EXISTS:
          Errors := 'An invalid fax modem type was specified.';

          FAX_ERR_NO_PHONE_NUMBER:
          Errors := 'No phone number was specified for SetPhoneNumber function.';

          FAX_ERR_BAD_FAX_ID:
          Errors := 'Invalid fax ID was specified.';

          FAX_ERR_BAD_IMAGE_TYPE:
          Errors := 'Invalid image type was specified for SetFaxPage method.';

          FAX_ERR_NO_FILENAME_SPECIFIED:
          Errors := 'Invalid image filename was specified for SetFaxPage method.';

          FAX_ERR_BAD_ASCII_FILE:
          Errors := 'The attempt to open or convert the ASCII data to image was unsuccessful.';

          FAX_ERR_NO_HANDLE_SPECIFIED:
          Errors := 'There was no DIB handle specified before SetFaxPage method.';

          FAX_ERR_BAD_DIB_HANDLE:
          Errors := 'Invalid DIB handle was specified before SetFaxPage method.';

          FAX_ERR_NO_PORTS_OPEN:
          Errors := 'There weren’t any ports open before an operation (SendFaxObj) which needed one.';

          FAX_ERR_UNRECOGNIZED_FILEFORMAT:
          Errors := 'The OCX wasn’t able to recognize the format of the specified image file.';

          FAX_ERR_TEST_FAILED:
          Errors := 'The modem test on the specified COM port was unsuccessful.';

          FAX_ERR_BAD_FILENAME:
          Errors := 'Invalid filename specified.';

          FAX_ERR_B_CHANNEL_BAD_TYPE:
          Errors := 'The specified Brooktrout fax channel has no faxing capability.';

          FAX_ERR_NO_CONFIG_FILE:
          Errors := 'No configuration file was specified before opening a Brooktrout or GammaLink fax channel.';

          FAX_ERR_DEMO_VERSION_IS_SINGLEPORT:
          Errors := 'The DEMO version of the Fax OCX supports only 4 fax ports.';

          FAX_ERR_DEMO_VERSION_IS_SINGLEPAGE:
          Errors := 'The DEMO version of the Fax OCX supports only 1 page faxes.';
     else
          Errors := IntToStr(errorcode);
    end;
end;
function TMainForm.MakeTerminationText(TCode:integer):String;
begin
    MakeTerminationText:= '';
    case  TCode of
          TER_NONE :
            MakeTerminationText:= 'Session not terminated' ;
          TER_ABORT :
            MakeTerminationText:= 'User Abort' ;
          TER_UNSPECIFIED :
            MakeTerminationText:= 'Unspecified error' ;
          TER_RINGBACK :
            MakeTerminationText:= 'Ringback detect' ;
          TER_NO_CARRIER :
            MakeTerminationText:= 'No carrier detected' ;
          TER_BUSY :
            MakeTerminationText:= 'The remote station is BUSY' ;
          TER_PHASE_A :
            MakeTerminationText:= 'Uspecified phase A error' ;
          TER_PHASE_B :
            MakeTerminationText:= 'Unspecified phase B error' ;
          TER_NO_ANSWER :
            MakeTerminationText:= 'No Answer' ;
          TER_NO_DIALTONE :
            MakeTerminationText:= 'No dialtone' ;
          TER_INVALID_REMOTE :
            MakeTerminationText:=  'Remote modem cannot receive or send ' ;
          TER_COMREC_ERROR :
            MakeTerminationText:= 'Command not received' ;
          TER_INVALID_COMMAND :
            MakeTerminationText:= 'Incvalid command received' ;
          TER_INVALID_RESPONSE :
            MakeTerminationText:= 'Invalid response received' ;
          TER_DCS_SEND :
            MakeTerminationText:= 'DCS send 3 times without answer' ;
          TER_DIS_RECEIVED :
            MakeTerminationText:= 'DIS received 3 times' ;
          TER_DIS_NOTRECEIVED :
            MakeTerminationText:= 'DIS not received' ;
          TER_TRAINING :
            MakeTerminationText:= 'Failure training in 2400 bit/s' ;
          TER_TRAINING_MINSPEED :
            MakeTerminationText:= 'Training failure : minimum speed reached.' ;
          TER_PHASE_C  :
            MakeTerminationText:= 'Error in page transmission' ;
          TER_IMAGE_FORMAT :
            MakeTerminationText:= 'Unspecified image format' ;
          TER_IMAGE_CONVERSION :
            MakeTerminationText:= 'Image conversion error' ;
          TER_DTE_DCE_DATA_UNDERFLOW :
            MakeTerminationText:= 'DTE to DCE data underflow' ;
          TER_UNRECOGNIZED_CMD :
            MakeTerminationText:= 'Unrecognized transparent data command' ;
          TER_IMAGE_LINE_LENGTH:
            MakeTerminationText:= 'Image error line length wrong' ;
          TER_IMAGE_PAGE_LENGTH  :
            MakeTerminationText:= 'Page length wrong' ;
          TER_IMAGE_COMPRESSION :
            MakeTerminationText:= 'wrong compression mode' ;
          TER_PHASE_D :
            MakeTerminationText:= 'Unspecified phase D error' ;
          TER_MPS :
            MakeTerminationText:= 'No response to MPS' ;
          TER_MPS_RESPONSE :
            MakeTerminationText:= 'Invalid response to MPS' ;
          TER_EOP :
            MakeTerminationText:= 'No response to EOP' ;
          TER_EOP_RESPONSE :
            MakeTerminationText:= 'Invalid response to EOP' ;
          TER_EOM :
            MakeTerminationText:= 'No response to EOM' ;
          TER_EOM_RESPONSE :
            MakeTerminationText:= 'Invalid response to EOM' ;
          TER_UNABLE_TO_CONTINUE :
            MakeTerminationText:= 'Unable to continue after PIN or PPP' ;
          TER_T2_TIMEOUT :
            MakeTerminationText:= 'T.30 T2 timeout expected' ;
          TER_T1_TIMEOUT :
            MakeTerminationText:= 'T.30 T1 timeout expected' ;
          TER_MISSING_EOL :
            MakeTerminationText:= 'Missing EOL after 5 sec' ;
          TER_BAD_CRC :
            MakeTerminationText:= 'Bad CRC or Frame' ;
          TER_DCE_DTE_DATA_UNDERFLOW :
            MakeTerminationText:= 'DCE to DTE data underflow' ;
          TER_DCE_DTE_DATA_OVERFLOW :
            MakeTerminationText:= 'DCE to DTE data overflow' ;
          TER_INVALID_REMOTE_RECEIVE :
            MakeTerminationText:= 'Remote cannot receive' ;
          TER_INVALID_REMOTE_ECM :
            MakeTerminationText:= 'Invalid remote ECM mode ' ;
          TER_INVALID_REMOTE_BFT:
            MakeTerminationText:= 'Invalid remote BFT mode' ;
          TER_INVALID_REMOTE_WIDTH:
            MakeTerminationText:= 'Invalid remote width' ;
          TER_INVALID_REMOTE_LENGTH :
            MakeTerminationText:= 'Invalid remote length' ;
          TER_INVALID_REMOTE_COMPRESS:
            MakeTerminationText:= 'Invalid remote compression ' ;
          TER_INVALID_REMOTE_RESOLUTION :
            MakeTerminationText:= 'Invalid remote resolution' ;
          TER_NO_SEND_DOCUMET :
            MakeTerminationText:= 'No transmitting document' ;
          TER_PPS_RESPONSE :
            MakeTerminationText:= 'No response to PPS' ;
          TER_NOMODEM :
            MakeTerminationText:= 'No modem on com port' ;
          TER_INVALIDCLASS:
            MakeTerminationText:= 'Incompatible modem' ;
          TER_B_FILEIO:
            MakeTerminationText:= 'Brooktrout: File I/O error occured.' ;
          TER_B_FILEFORMAT:
            MakeTerminationText:= 'Brooktrout: Bad file format.' ;
          TER_B_BOARDCAPABILITY:
            MakeTerminationText:= 'Brooktrout: Line card firmware does not support capability.' ;
          TER_B_NOTCONNECTED:
            MakeTerminationText:= 'Brooktrout: Channel is not in proper state.' ;
          TER_B_BADPARAMETER:
            MakeTerminationText:= 'Brooktrout: Bad parameter value used.' ;
          TER_B_MEMORY:
            MakeTerminationText:= 'Brooktrout: Memory allocation error.' ;
          TER_B_BADSTATE:
            MakeTerminationText:= 'Brooktrout: The channel is not in a required state.' ;
          TER_B_NO_LOOP_CURRENT:
            MakeTerminationText:= 'Brooktrout: No loop current detected.' ;
          TER_B_LOCAL_IN_USE:
            MakeTerminationText:= 'Brooktrout: Local phone in use.' ;
          TER_B_CALL_COLLISION:
            MakeTerminationText:= 'Brooktrout: Ringing detected during dialing.' ;
          TER_B_CONFIRM:
            MakeTerminationText:= 'Confirmation tone detected.' ;
          TER_B_DIALTON:
            MakeTerminationText:= 'Dial tone detected; the dialing sequence did not brake dial tone.' ;
          TER_B_G2_DETECTED:
            MakeTerminationText:= 'Group 2 fax machine detected. Remote fax machine is capable of sending and receiving G2 facsimiles only.' ;
          TER_B_HUMAN:
            MakeTerminationText:= 'Answer (probable human) detected; does not match any other expected call progress signal patterns.' ;
          TER_B_QUIET:
            MakeTerminationText:= 'After dialing the number, no energy detected on the line, possible dead line.' ;
          TER_B_RECALL:
            MakeTerminationText:= 'Recall dial tone detected.' ;
          TER_B_RNGNOANS:
            MakeTerminationText:= 'The remote end was ringing but did not answer.' ;
          TER_B_SITINTC:
            MakeTerminationText:= 'Intercept tone detected; invalid telephone number or class of service restriction.' ;
          TER_B_SITNOCIR:
            MakeTerminationText:= 'No circuit detected; end office or carrier originating failure; possible dead line.' ;
          TER_B_SITREORD:
            MakeTerminationText:= 'Reorder tone detected; end office or carrier originating failure.' ;
          TER_B_SITVACOE:
            MakeTerminationText:= 'Vacant tone detected; remote originating failure; invalid telephone number.' ;
          TER_B_UNSPECIFIED:
            MakeTerminationText:= 'Brooktrout error.' ;
          TER_B_NO_WINK:
            MakeTerminationText:= 'Brooktrout error : no wink.' ;
          TER_B_RSPREC_VCNR:
            MakeTerminationText:= 'Brooktrout error : RSPREC invalid response received.' ;
          TER_B_COMREC_DCN:
            MakeTerminationText:= 'Brooktrout error : DCN received in COMREC.' ;
          TER_B_RSPREC_DCN:
            MakeTerminationText:= 'Brooktrout error : DCN received in RSPREC.' ;
          TER_B_INCOMPAT_FMT:
            MakeTerminationText:= 'Brooktrout error : Incompatible fax formats.' ;
          TER_B_INVAL_DMACNT:
            MakeTerminationText:= 'Brooktrout error : Invalid DMA count specified for transmitter.' ;
          TER_B_FTM_NOECM:
            MakeTerminationText:= 'Brooktrout error : Binary File Transfer specified, but ECM not enabled on transmitter.';
          TER_B_INCMP_FTM:
            MakeTerminationText:= 'Brooktrout error : Binary File Transfer specified, but not supported by receiver.';
        // phase D hangup codes
          TER_B_RR_NORES:
            MakeTerminationText:= 'Brooktrout error : No response to RR after three tries.' ;
          TER_B_CTC_NORES:
            MakeTerminationText:= 'Brooktrout error : No response to CTC, or response was not CTR.' ;
          TER_B_T5TO_RR:
            MakeTerminationText:= 'Brooktrout error : T5 time out since receiving first RNR.' ;
          TER_B_NOCONT_NSTMSG:
            MakeTerminationText:= 'Brooktrout error : Do not continue with next message after receiving ERR.' ;
          TER_B_ERRRES_EOREOP:
            MakeTerminationText:= 'Brooktrout error : ERR response to EOR-EOP or EOR-PRI-EOP.' ;
          TER_B_SE:
            MakeTerminationText:= 'Brooktrout error : RSPREC error.' ;
          TER_B_EORNULL_NORES:
            MakeTerminationText:= 'Brooktrout error : No response received after third try for EOR-NULL.' ;
          TER_B_EORMPS_NORES:
            MakeTerminationText:= 'Brooktrout error : No response received after third try for EOR-MPS.' ;
          TER_B_EOREOP_NORES:
            MakeTerminationText:= 'Brooktrout error : No response received after third try for EOR-EOP.' ;
          TER_B_EOREOM_NORES:
            MakeTerminationText:= 'Brooktrout error : No response received after third try for EOR-EOM.' ;
        // receive phase B hangup codes
          TER_B_RCVB_SE:
            MakeTerminationText:= 'Brooktrout error : RSPREC error.' ;
          TER_B_NORMAL_RCV:
            MakeTerminationText:= 'Brooktrout error : DCN received in COMREC.' ;
          TER_B_RCVB_RSPREC_DCN:
            MakeTerminationText:= 'Brooktrout error : DCN received in RSPREC.' ;
          TER_B_RCVB_INVAL_DMACNT:
            MakeTerminationText:= 'Brooktrout error : Invalid DMA count specified for receiver.' ;
          TER_B_RCVB_FTM_NOECM:
            MakeTerminationText:= 'Brooktrout error : Binary File Transfer specified, but ECM supported by receiver.' ;
        // receive phase D hangup codes
          TER_B_RCVD_SE_VCNR:
            MakeTerminationText:= 'Brooktrout error : RSPREC invalid response received.' ;
          TER_B_RCVD_COMREC_VCNR:
            MakeTerminationText:= 'Brooktrout error : COMREC invalid response received.' ;
          TER_B_RCVD_T3TO_NORESP:
            MakeTerminationText:= 'Brooktrout error : T3 time-out; no local response for remote voice interrupt.' ;
          TER_B_RCVD_T2TO:
            MakeTerminationText:= 'Brooktrout error : T2 time-out; no command received after responding RNR.' ;
          TER_B_RCVD_DCN_COMREC:
            MakeTerminationText:= 'Brooktrout error : DCN received for command received.' ;
          TER_B_RCVD_COMREC_ERR:
            MakeTerminationText:= 'Brooktrout error : Command receive error.' ;
          TER_B_RCVD_BLKCT_ERR:
            MakeTerminationText:= 'Brooktrout error : Receive block count error in ECM mode.' ;
          TER_B_RCVD_PGCT_ERR:
            MakeTerminationText:= 'Brooktrout error : Receive page count error in ECM mode.' ;
          TER_HUMANVOICE ://rz
            MakeTerminationText:= 'Human answer detected';

    end;

end;

procedure TMainForm.AboutOCXdemo1Click(Sender: TObject);
var dlg:TAboutForm;
begin
     dlg:=TAboutForm.Create(self);
     dlg.ShowModal;
     dlg.free;
end;

procedure TMainForm.FileExit(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.Close1Click(Sender: TObject);
var dlg:TClosePort;
begin
     dlg:=TClosePort.Create(self);
     dlg.ShowModal;
     dlg.free;
end;

procedure TMainForm.ClickSend1(Sender: TObject);
var dlg:TSendFax;
begin
        dlg:=TSendFax.Create(self);
        dlg.ShowModal;
        dlg.free;
end;

procedure TMainForm.CreateMain(Sender: TObject);
begin
    FAX1.CloseAllPorts;
    EventListBox.Items.Add('This sample shows how to send a fax using a COM port.');
    EventListBox.Items.Add('To open a COM port choose "Open Com Port..." from Fax menu');
    EventListBox.Items.Add('and select from the available ports. To send a fax select "Send..."');
    EventListBox.Items.Add('from Fax menu, specify the file you would like to send and the');
    EventListBox.Items.Add('destination phone number. You can send the fax using the selected');
    EventListBox.Items.Add('port if checking "Immediate" radio button or put the fax in queue');
    EventListBox.Items.Add('by checking "Queue" button.');
    EventListBox.Items.Add('To close a port choose "Close Com Port..." from Fax menu and');
    EventListBox.Items.Add('select from the open ports.');
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FAX1.CloseAllPorts;
end;

procedure TMainForm.OnEndPage(Sender: TObject; const szPort: WideString;
  lPageNumber: Integer);
  var line : string;
begin
    line := 'Ending page ' + IntToStr(lPageNumber) + ' on port ' + szPort;
    MainForm.EventListBox.Items.Add(line);
end;


procedure TMainForm.OnTerminate(Sender: TObject; const lpPort: WideString;
  lStatus: Integer; sPageNo: Smallint; ConnectTime: Integer; const szDID,
  szDTMF: WideString);
  var portType:string;
begin
     portType:=copy(lpPort,1,1);
     if (lStatus<>TER_NORMAL)and(portType<>'G') then
             MessageDlg(MakeTerminationText(lStatus),mtWarning,[mbOK],0);
end;

procedure TMainForm.OnEndSend(Sender: TObject; const PortName: WideString;
  FaxID: Integer; const RemoteID: WideString);
begin
     MainForm.FAX1.ClearFaxObject(FaxID);
end;

procedure TMainForm.FAX1_Dial(Sender: TObject;const PortName: WideString);
var  line: string;
begin
    line := 'Dialing on ' + PortName;
    MainForm.EventListBox.Items.Add(line);
end;

procedure TMainForm.FAX1StartPage(Sender: TObject;
  const szPort: WideString; lPageNumber: Integer);
  var line:String;
begin
    line := 'Starting page ' + IntToStr(lPageNumber) + ' on port ' + szPort;
    MainForm.EventListBox.Items.Add(line);
end;

procedure TMainForm.FAX1StartSend(Sender: TObject;
  const PortName: WideString);
  var line:String;
begin
    line := 'Starting to send on ' + PortName;
    MainForm.EventListBox.Items.Add(line);
end;

procedure TMainForm.FAX1TerminateExt(Sender: TObject;
  const lpPort: WideString; lStatus: Integer; sPageNo: Smallint;
  ConnectTime: Integer; const szDID, szDTMF, szSubaddress: WideString);
  var line:String;
begin
    line := 'Transmission terminated on ' + lpPort;
    MainForm.EventListBox.Items.Add(line);
    line := '   -  Termination status : ' + FAX1.ReturnErrorString(lStatus) + ', Connected for ' + IntToStr(ConnectTime) + ' milliseconds, DID: ' + szDID + ', DTMF: ' + szDTMF + ',Subaddress: ' + szSubaddress;
    MainForm.EventListBox.Items.Add(line);
    if Length(szDID)>0 then
             MainForm.EventListBox.Items.Add('DID received on ' + lpPort + ': ' + szDID);
    if Length(szDTMF)>0 then
             MainForm.EventListBox.Items.Add('DTMF received on '+lpPort + ': ' + szDTMF);
end;

procedure TMainForm.Clear1Click(Sender: TObject);
begin
   EventListBox.Clear;
end;

procedure TMainForm.OnlineHelpClick(Sender: TObject);
var
   bRet : Integer;
begin
   bRet := ShellExecute(handle, 'open', '..\Help\Black_Ice_Fax_C++_OCX_Help.chm', nil, nil, 1);
   if bRet <= 32 then
     begin
        bRet := ShellExecute(handle, 'open', 'Black_Ice_Fax_C++_OCX_Help.chm', nil, nil, 1);
        if bRet <= 32 then MessageDlg('The Black_Ice_Fax_C++_OCX_Help.chm help file was not found', mtError,[mbOK],0);
     end;
end;

procedure TMainForm.Comm1Click(Sender: TObject);
var dlg:TCommPortInit;
begin
     dlg:=TCommPortInit.Create(self);
     dlg.ShowModal;
     dlg.free;
end;
procedure TMainForm.FormActivate(Sender: TObject);
begin
        EventListBox.Align:=alClient;
end;

procedure TMainForm.Commands1Click(Sender: TObject);
begin
     if (Length(MainForm.FAX1.AvailablePorts) > 0) then
        MainForm.Comm1.Enabled := True
     else MainForm.Comm1.Enabled:=False;
end;

end.

