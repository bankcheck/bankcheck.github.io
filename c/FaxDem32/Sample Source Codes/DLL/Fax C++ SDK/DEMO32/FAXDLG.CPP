// faxdlg.c : implementation file
//
/*
    $Log:   K:\archive\faxsrc40\demo41\faxdlg.cpp  $
 //
 //    Rev 4.58   24 Mar 1998 11:25:44   Zoltan
 //
 //    Rev 4.57   01 Dec 1997 10:44:46   Zoltan
 //
 //    Rev 4.54   17 Sep 1997 16:34:38   Gyuri
 //
 //    Rev 4.53   03 Sep 1997 15:14:56   Zsolt
 //
 //    Rev 4.52   26 Aug 1997 18:51:38   Gyuri
 // No change.
 //
 //    Rev 4.51   26 Aug 1997 18:28:28   Gyuri
 // latest
 //
 //    Rev 4.50   13 May 1997 15:23:38   Maroy
 //
 // header
 //
 //    Rev 4.49   17 Apr 1997 12:14:18   joe
 //
 //    Rev 4.48   22 Mar 1997 18:19:18   joe
 //
 //    Rev 4.47   15 Mar 1997 16:30:22   joe
 //
 // DIB leak removed from SendAllPage
 //
 //    Rev 4.46   05 Mar 1997 17:50:56   joe
 //
 //    Rev 4.45   12 Feb 1997 14:27:06   joe
 //
 //    Rev 4.44   03 Feb 1997 10:18:24   joe
 // coverpage
 //
 //    Rev 4.40   10 Oct 1996 16:18:42   joe
 //
 //    Rev 4.39   17 Sep 1996 10:21:12   joe
 //
 //    Rev 4.38   19 Aug 1996 19:15:38   joe
 // 4.16
 //
 //    Rev 4.36   02 Jul 1996 16:31:38   joe
 //
 //    Rev 4.35   02 Jul 1996 11:16:12   joe
 //
 //    Rev 4.34   27 Jun 1996 16:04:02   joe
 // warnings removed
 //
 //    Rev 4.33   25 Jun 1996 16:19:04   joe
 //
 //    Rev 4.32   19 Jun 1996 20:58:14   joe
 //
 //    Rev 4.31   18 Jun 1996 10:22:10   Gyuri
 // ecm_disable
 //
 //    Rev 4.30   15 Jun 1996 17:50:04   joe
 // new header
 //
 //    Rev 4.29   30 May 1996 15:54:54   joe
 //
 //    Rev 4.27   17 May 1996 15:40:18   joe
 // PNH support
 //
 //    Rev 4.2   30 Apr 1996 19:07:18   Gyuri
 //
 //    Rev 4.1   27 Apr 1996 15:18:16   Gyuri
 //
 //    Rev 1.13   29 Mar 1996 17:07:26   Gyuri
 // No change.
 //
 //    Rev 1.12   27 Mar 1996 14:45:34   joe
 //
 //    Rev 1.11   18 Mar 1996 17:51:08   Albert
 //
 //
 //    Rev 1.10   15 Mar 1996 11:21:20   joe
 //
 //    Rev 1.9   14 Mar 1996 10:46:28   Albert
 //
 //
 //    Rev 1.8   11 Mar 1996 14:10:16   joe
 //
 //    Rev 1.7   10 Mar 1996 19:02:08   joe
 //
 //    Rev 1.6   10 Mar 1996 13:31:34   Albert
 //
 //
 //    Rev 1.5   09 Mar 1996 19:56:12   Albert
 // No change.
 //
 //    Rev 1.4   09 Mar 1996 19:05:56   joe
 //
 //    Rev 1.0   02 Mar 1996 17:38:00   joe
 // Initial revision.
 //
 //    Rev 1.3   02 Mar 1996 17:15:28   joe
 //
 //
 //    Rev 1.2   02 Mar 1996 14:00:44   joe
 //
 //    Rev 1.1   27 Feb 1996 09:44:42   joe
 //
 //    Rev 1.0   22 Feb 1996 12:50:26   joe
 // Initial revision.
 //
 //    Rev 3.123   25 Jan 1996 17:19:24   joe
 //
 //
 //    Rev 3.122   25 Jan 1996 11:44:38   joe
 //
 //
 //    Rev 3.121   09 Jan 1996 15:59:06   joe
 //
 // Ascii text faxing.
 //
 //    Rev 3.120   18 Dec 1995 19:35:52   joe
 // Second debug flag in port setup dialog.
 //
 //    Rev 3.119   05 Dec 1995 13:46:18   joe
 //
 //
 //    Rev 3.118   04 Dec 1995 09:35:02   joe
 //
 //    Rev 3.117   22 Nov 1995 11:40:02   Albert
 // No change.
 //
 //    Rev 3.116   08 Nov 1995 11:27:28   Albert
 // Fix Immediate send
 //
 //    Rev 3.115   19 Oct 1995 21:20:00   joe
 //
 //
 //    Rev 3.114   19 Oct 1995 14:46:30   joe
 //
 //    Rev 3.113   18 Oct 1995 17:42:02   Gyuri
 //
 //
 //    Rev 3.112   16 Oct 1995 11:49:46   Gyuri
 // Fix COM1 check
 //
 //    Rev 3.111   04 Oct 1995 11:14:52   Albert
 // No dialog on CFR_USERABORT
 //
 //    Rev 3.110   14 Sep 1995 12:30:10   Albert
 // No change.
 //
 //    Rev 3.13   12 Sep 1995 16:25:00   Albert
 //
 // Save Init string before open port
 //
 //    Rev 3.12   11 Sep 1995 20:21:44   Albert
 // Fix INVALID_HANDLE_VALUE error
 //
 //    Rev 3.11   11 Sep 1995 11:35:36   Albert
 // Port to Win32
 //
 //    Rev 3.10   31 Aug 1995 17:34:48   Albert
 //
*/
#include "stdafx.h"

#include <stdio.h>
#include <stddef.h>
//#include <fstream.h>

#pragma warning(disable:4103)

#define _PROTOS_USED
extern "C" {
    #include    "bidib.h"
	#include "bitiff.h"
};

#include "faxbft.h"
#include "faxtype.h"
#include "faxcpp.h"
#include "commcl.h"
#include "resource.h"
#include "imgdoc.h"
#include "dialogs.h"
#include "faxdlg.h"
#include "mainfrm.h"
#include "demo.h"
#include "logs.h"
#include "BlockDoc.h"


#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif

#if defined(WIN32)
#define _fstrspn strspn
#define B_PORTNAME "Channel"
#define G_PORTNAME "Channel"
#endif

void SetPhbookFileName(LPSTR lpPhonePath);      /* from PHBDLG.CPP */

struct TFERTable
{
        int code;
        LPSTR txt;
};

static TFERTable errortab[] =
{
    { FER_MEMORIA               ,   "FER_MEMORIA"           } ,
    { FER_TOOLONG               ,   "FER_TOOLONG"           } ,
    { FER_FAXNOW                ,   "FER_FAXNOW"            } ,
    { FER_FILE                  ,   "FER_FILE"              } ,
    { FER_BADPARAM              ,   "FER_BADPARAM"          } ,
    { FER_BADFAX                ,   "FER_BADFAX"            } ,
    { FER_SYSTEM                ,   "FER_SYSTEM"            } ,
    { FER_RONGFORMAT            ,   "FER_RONGFORMAT"        } ,
    { FER_NOQUEUE               ,   "FER_NOQUEUE"           } ,
    { FER_ENCODE                ,   "FER_ENCODE"            } ,
    { FER_NOTIMPLEMENTED        ,   "FER_NOTIMPLEMENTED"    } ,
    { FER_BFTDECODE             ,   "FER_BFTDECODE"         } ,
    { FER_PORTDISABLE           ,   "FER_PORTDISABLE"       } ,
    { FER_PORTSYNC              ,   "FER_PORTSYNC"          } ,

    { FER_SYS_REGCLASS          ,   "FER_SYS_REGCLASS"      } ,
    { FER_SYS_CREATEWND         ,   "FER_SYS_CREATEWND"     } ,
    { FER_LOADIMG               ,   "FER_LOADIMG"           } ,
    { FER_SCALEIMG              ,   "FER_SCALEIMG"          } ,
    { FER_ENCOD_CCITT           ,   "FER_ENCOD_CCITT"       } ,
    { FER_DECOD_CCITT           ,   "FER_DECOD_CCITT"       } ,
    { FER_LOADMODULE            ,   "FER_LOADMODULE"        } ,
    { FER_CONNECT               ,   "FER_CONNECT"           } ,
    { FER_CREATEFAXOBJ          ,   "FER_CREATEFAXOBJ"      } ,

    { FER_BAD_PAGENUM           ,   "FER_BAD_PAGENUM"       } ,
    { FER_BAD_PAGEFNAME         ,   "FER_BAD_PAGEFNAME"     } ,
    { FER_BAD_BFTDATA           ,   "FER_BAD_BFTDATA"       } ,
    { FER_BAD_BFTDATAID         ,   "FER_BAD_BFTDATAID"     } ,
    { FER_BAD_BFTSIZE           ,   "FER_BAD_BFTSIZE"       } ,
    { FER_BAD_IMGTYPE           ,   "FER_BAD_IMGTYPE"       } ,
    { FER_BAD_IMGFILE           ,   "FER_BAD_IMGFILE"       } ,
    { FER_BAD_IMGMEM            ,   "FER_BAD_IMGMEM"        } ,
    { FER_BAD_FAXPORT           ,   "FER_BAD_FAXPORT"       } ,
    { FER_BAD_MODEMTEST         ,   "FER_BAD_MODEMTEST"     } ,

    { FER_FILE_OPEN             ,   "FER_FILE_OPEN"         } ,
    { FER_FILE_COPY             ,   "FER_FILE_COPY"         } ,
    { FER_FILE_WRITE            ,   "FER_FILE_WRITE"        } ,
    { FER_FILE_READ             ,   "FER_FILE_READ"         } ,
    { FER_FILE_NOEXIST          ,   "FER_FILE_NOEXIST"      } ,

    { 0                         ,   NULL      }
};

BOOL CopyDibDPIs(HDIB hDibOut, HDIB hDibInp)
{
    LPBITMAPINFOHEADER lpOut = NULL;
    LPBITMAPINFOHEADER lpInp = NULL;
    BOOL bRet = FALSE;

    lpOut = (LPBITMAPINFOHEADER)GlobalLock(hDibOut);
    lpInp = (LPBITMAPINFOHEADER)GlobalLock(hDibInp);
    if(lpOut==NULL || lpInp==NULL)
        goto leave;
    lpOut->biXPelsPerMeter = lpInp->biXPelsPerMeter;
    lpOut->biYPelsPerMeter = lpInp->biYPelsPerMeter;
    bRet = TRUE;
leave:
    if(lpOut)
        GlobalUnlock(hDibOut);
    if(lpInp)
        GlobalUnlock(hDibInp);
    return bRet;
}


LPSTR MakeFERText(int code)
{
    if(code == 0)
        return "No Error";

    TFERTable *cb;
    for ( int jj=0; jj<500; jj++ ) {
        cb = &errortab[jj];
        if ( cb->code==0 || cb->txt==NULL ) {
            break;
        }
        if ( cb->code==code ) {
            return cb->txt;
        }
    }
    return " ";
}

static LPSTR MakeTerminationText(TETerminationStatus TCode)
{
    switch(TCode){
        case  TRM_NONE :
            return "Session not terminated" ;
        case TRM_ABORT :
            return "User Abort" ;
        case TRM_UNSPECIFIED :
            return "Unspecified error" ;
        case TRM_RINGBACK :
            return "Ringback detect" ;
        case TRM_NO_CARRIER :
            return "No carrier detected" ;
        case TRM_BUSY :
            return "The remote station is BUSY" ;
        case TRM_PHASE_A :
            return "Uspecified phase A error" ;
        case TRM_PHASE_B :
            return "Unspecified phase B error" ;
        case TRM_NO_ANSWER :
            return "No Answer" ;
        case TRM_NO_DIALTONE :
            return "No dialtone" ;
        case TRM_INVALID_REMOTE :
            return  "Remote modem cannot receive or send " ;
        case TRM_COMREC_ERROR :
            return "Command not received" ;
        case TRM_INVALID_COMMAND :
            return "Incvalid command received" ;
        case TRM_INVALID_RESPONSE :
            return "Invalid response received" ;
        case TRM_DCS_SEND :
            return "DCS send 3 times without answer" ;
        case TRM_DIS_RECEIVED :
            return "DIS received 3 times" ;
        case TRM_DIS_NOTRECEIVED :
            return "DIS not received" ;
        case TRM_TRAINING :
            return "Failure training in 2400 bit/s" ;
        case TRM_TRAINING_MINSPEED :
            return "Training failure : minimum speed reached." ;
        case TRM_PHASE_C  :
            return "Error in page transmission" ;
        case TRM_IMAGE_FORMAT :
            return "Unspecified image format" ;
        case TRM_IMAGE_CONVERSION :
            return "Image conversion error" ;
        case TRM_DTE_DCE_DATA_UNDERFLOW :
            return "DTE to DCE data underflow" ;
        case TRM_UNRECOGNIZED_CMD :
            return "Unrecognized transparent data command" ;
        case TRM_IMAGE_LINE_LENGTH:
            return "Image error line length wrong" ;
        case TRM_IMAGE_PAGE_LENGTH  :
            return "Page length wrong" ;
        case TRM_IMAGE_COMPRESSION :
            return "wrong compression mode" ;
        case TRM_PHASE_D :
            return "Unspecified phase D error" ;
        case TRM_MPS :
            return "No response to MPS" ;
        case TRM_MPS_RESPONSE :
            return "Invalid response to MPS" ;
        case TRM_EOP :
            return "No response to EOP" ;
        case TRM_EOP_RESPONSE :
            return "Invalid response to EOP" ;
        case TRM_EOM :
            return "No response to EOM" ;
        case TRM_EOM_RESPONSE :
            return "Invalid response to EOM" ;
        case TRM_UNABLE_TO_CONTINUE :
            return "Unable to continue after PIN or PPP" ;
        case TRM_T2_TIMEOUT :
            return "T.30 T2 timeout expected" ;
        case TRM_T1_TIMEOUT :
            return "T.30 T1 timeout expected" ;
        case TRM_MISSING_EOL :
            return "Missing EOL after 5 sec" ;
        case TRM_BAD_CRC :
            return "Bad CRC or Frame" ;
        case TRM_DCE_DTE_DATA_UNDERFLOW :
            return "DCE to DTE data underflow" ;
        case TRM_DCE_DTE_DATA_OVERFLOW :
            return "DCE to DTE data overflow" ;
        case TRM_INVALID_REMOTE_RECEIVE :
            return "Remote cannot receive" ;
        case TRM_INVALID_REMOTE_ECM :
            return "Invalid remote ECM mode " ;
        case TRM_INVALID_REMOTE_BFT:
            return "Invalid remote BFT mode" ;
        case TRM_INVALID_REMOTE_WIDTH:
            return "Invalid remote width" ;
        case TRM_INVALID_REMOTE_LENGTH :
            return "Invalid remote length" ;
        case TRM_INVALID_REMOTE_COMPRESS:
            return "Invalid remote compression " ;
        case TRM_INVALID_REMOTE_RESOLUTION :
            return "Invalid remote resolution" ;
        case TRM_NO_SEND_DOCUMET :
            return "No transmitting document" ;
        case TRM_PPS_RESPONSE :
            return "No response to PPS" ;
        case TRM_NOMODEM :
            return "No modem on com port!" ;
        case TRM_INVALIDCLASS:
            return "Incompatible modem" ;
        case TRM_HUMANVOICE: //rz
            return "Human answer detected";
#if defined(WIN32)
        case TRM_B_FILEIO:
            return "Brooktrout: File I/O error occured." ;
        case TRM_B_FILEFORMAT:
            return "Brooktrout: Bad file format." ;
        case TRM_B_BOARDCAPABILITY:
            return "Brooktrout: Line card firmware does not support capability." ;
        case TRM_B_NOTCONNECTED:
            return "Brooktrout: Channel is not in proper state." ;
        case TRM_B_BADPARAMETER:
            return "Brooktrout: Bad parameter value used." ;
        case TRM_B_MEMORY:
            return "Brooktrout: Memory allocation error." ;
        case TRM_B_BADSTATE:
            return "Brooktrout: The channel is not in a required state." ;
        case TRM_B_NO_LOOP_CURRENT:
            return "Brooktrout: No loop current detected." ;
        case TRM_B_LOCAL_IN_USE:
            return "Brooktrout: Local phone in use." ;
        case TRM_B_CALL_COLLISION:
            return "Brooktrout: Ringing detected during dialing." ;
        case TRM_B_CONFIRM:
            return "Confirmation tone detected." ;
        case TRM_B_DIALTON:
            return "Dial tone detected; the dialing sequence did not brake dial tone." ;
        case TRM_B_G2_DETECTED:
            return "Group 2 fax machine detected. Remote fax machine is capable of sending and receiving G2 facsimiles only." ;
        case TRM_B_HUMAN:
            return "Answer (probable human) detected; does not match any other expected call progress signal patterns." ;
        case TRM_B_QUIET:
            return "After dialing the number, no energy detected on the line, possible dead line." ;
        case TRM_B_RECALL:
            return "Recall dial tone detected." ;
        case TRM_B_RNGNOANS:
            return "The remote end was ringing but did not answer." ;
        case TRM_B_SITINTC:
            return "Intercept tone detected; invalid telephone number or class of service restriction." ;
        case TRM_B_SITNOCIR:
            return "No circuit detected; end office or carrier originating failure; possible dead line." ;
        case TRM_B_SITREORD:
            return "Reorder tone detected; end office or carrier originating failure." ;
        case TRM_B_SITVACOE:
            return "Vacant tone detected; remote originating failure; invalid telephone number." ;
        case TRM_B_UNSPECIFIED:
            return "Brooktrout error." ;
        case TRM_B_NO_WINK:
            return "Brooktrout error : no wink." ;
        case TRM_B_RSPREC_VCNR:
            return "Brooktrout error : RSPREC invalid response received." ;
        case TRM_B_COMREC_DCN:
            return "Brooktrout error : DCN received in COMREC." ;
        case TRM_B_RSPREC_DCN:
            return "Brooktrout error : DCN received in RSPREC." ;
        case TRM_B_INCOMPAT_FMT:
            return "Brooktrout error : Incompatible fax formats." ;
        case TRM_B_INVAL_DMACNT:
            return "Brooktrout error : Invalid DMA count specified for transmitter." ;
        case TRM_B_FTM_NOECM:
            return "Brooktrout error : Binary File Transfer specified, but ECM not enabled on transmitter.";
        case TRM_B_INCMP_FTM:
            return "Brooktrout error : Binary File Transfer specified, but not supported by receiver.";
        // phase D hangup codes
        case TRM_B_RR_NORES:
            return "Brooktrout error : No response to RR after three tries." ;
        case TRM_B_CTC_NORES:
            return "Brooktrout error : No response to CTC, or response was not CTR." ;
        case TRM_B_T5TO_RR:
            return "Brooktrout error : T5 time out since receiving first RNR." ;
        case TRM_B_NOCONT_NSTMSG:
            return "Brooktrout error : Do not continue with next message after receiving ERR." ;
        case TRM_B_ERRRES_EOREOP:
            return "Brooktrout error : ERR response to EOR-EOP or EOR-PRI-EOP." ;
        case TRM_B_SE:
            return "Brooktrout error : RSPREC error." ;
        case TRM_B_EORNULL_NORES:
            return "Brooktrout error : No response received after third try for EOR-NULL." ;
        case TRM_B_EORMPS_NORES:
            return "Brooktrout error : No response received after third try for EOR-MPS." ;
        case TRM_B_EOREOP_NORES:
            return "Brooktrout error : No response received after third try for EOR-EOP." ;
        case TRM_B_EOREOM_NORES:
            return "Brooktrout error : No response received after third try for EOR-EOM." ;
        // receive phase B hangup codes
        case TRM_B_RCVB_SE:
            return "Brooktrout error : RSPREC error." ;
        case TRM_B_NORMAL_RCV:
            return "Brooktrout error : DCN received in COMREC." ;
        case TRM_B_RCVB_RSPREC_DCN:
            return "Brooktrout error : DCN received in RSPREC." ;
        case TRM_B_RCVB_INVAL_DMACNT:
            return "Brooktrout error : Invalid DMA count specified for receiver." ;
        case TRM_B_RCVB_FTM_NOECM:
            return "Brooktrout error : Binary File Transfer specified, but ECM supported by receiver." ;
        // receive phase D hangup codes
        case TRM_B_RCVD_SE_VCNR:
            return "Brooktrout error : RSPREC invalid response received." ;
        case TRM_B_RCVD_COMREC_VCNR:
            return "Brooktrout error : COMREC invalid response received." ;
        case TRM_B_RCVD_T3TO_NORESP:
            return "Brooktrout error : T3 time-out; no local response for remote voice interrupt." ;
        case TRM_B_RCVD_T2TO:
            return "Brooktrout error : T2 time-out; no command received after responding RNR." ;
        case TRM_B_RCVD_DCN_COMREC:
            return "Brooktrout error : DCN received for command received." ;
        case TRM_B_RCVD_COMREC_ERR:
            return "Brooktrout error : Command receive error." ;
        case TRM_B_RCVD_BLKCT_ERR:
            return "Brooktrout error : Receive block count error in ECM mode." ;
        case TRM_B_RCVD_PGCT_ERR:
            return "Brooktrout error : Receive page count error in ECM mode." ;



        case TRM_BI_OUTOFMEMORY:
            return "Bicom error: Insufficient memory to complete operation.";
        case TRM_BI_QUEUE_CORRUPTED:
            return "Bicom error: Queue structure is corrupted";
        case TRM_BI_INVALID_QUEUE:
            return "Bicom error: Queue handle is invalid";
        case TRM_BI_QUEUE_EMPTY:
            return "Bicom error: No documents in the given queue";
        case TRM_BI_DOCUMENT_NOT_FOUND:
            return "Bicom error: Attempted to delete document not in the queue.";
        case TRM_BI_NOCHANNEL:
            return "Bicom error: No Channel Open.";
        case TRM_BI_NO_LINE:
            return "Bicom error: No line.";
        case TRM_BI_RESOURCE_ERROR:
            return "Bicom error: Error allocating a fax resource.";
        case TRM_BI_NO_RESOURCES_AVAILABLE:
            return "Bicom error: No resource available.";
        case TRM_BI_BADFILENAME:
            return "Bicom error: Bad filename.";
        case TRM_BI_INVALIDRES:
            return "Bicom error: Invalid resoultion parameter.";
        case TRM_BI_INVALIDENCODING:
            return "Bicom error: Bad encoding.";
        case TRM_BI_CREATE_ERROR:
            return "Bicom error: Attempted to delete document not in the queue.";
        case TRM_BI_INVALID_PAGE_TYPE:
            return "Bicom error: Invalid page type.";
        case TRM_BI_INVALID_PAGE_LEN:
            return "Bicom error: Invalid page size.";
        case TRM_BI_NOQUEUE:
            return "Bicom error: No queue.";
        case TRM_BI_NOTRAININGRESP:
            return "Bicom error: Failed waiting for training response.";
        case TRM_BI_NORESPONSE:
            return "Bicom error: Timed out waiting for response to the Post Message signal.";
        case TRM_BI_BAD_RESOLUTION:
            return "Bicom error: Document resolution mismatch.";
        case TRM_BI_BADENCODING:
            return "Bicom error: Image encoding mismach.";
        case TRM_BI_NODOCUMENT:
            return "Bicom error: No document.";
//commetrex
        case TRM_CMTRX_BAD_ARGUMENT:
            return "Commetrex error: Bad argument.";
        case TRM_CMTRX_OUT_OF_MEMORY:
            return "Commetrex error: Out of memory.";
        case TRM_CMTRX_INVALID_PORT:
            return "Commetrex error: Invalid port.";
        case TRM_CMTRX_CONNECT_FAILED:
            return "Commetrex error: Connect failed.";
        case TRM_CMTRX_ALREADY_ACTIVE:
            return "Commetrex error: Port already active.";
        case TRM_CMTRX_NOT_ACTIVE:
            return "Commetrex error: Port not active.";
        case TRM_CMTRX_NEGOTIATION_FAILED:
            return "Commetrex error: Negotiation failed.";
        case TRM_CMTRX_NO_MORE_LICENSES:
            return "Commetrex error: No more licenses.";
        case TRM_CMTRX_NO_LICENSE:
            return "Commetrex error: No licenses.";
        case TRM_CMTRX_LICENSE_ALREADY_ALLOC:
            return "Commetrex error: License already allocated.";
        case TRM_CMTRX_QUEUE_EMPTY:
            return "Commetrex error: Queue empty.";
        case TRM_CMTRX_FILE_EXISTS:
            return "Commetrex error: File already exist.";
        case TRM_CMTRX_FILE_NOT_FOUND:
            return "Commetrex error: File not found.";
        case TRM_CMTRX_BAD_FILE_FORMAT:
            return "Commetrex error: Bad file format.";
        case TRM_CMTRX_INVALID_DOC:
            return "Commetrex error: Invalid document.";
        case TRM_CMTRX_QUEUE_TOO_LATE:
            return "Commetrex error: Queue modification too late.";
        case TRM_CMTRX_SESSION_FAILED:
            return "Commetrex error: Session failed.";
        case TRM_CMTRX_UNSUPPORTED:
            return "Commetrex error: Unsupported operation.";
        case TRM_CMTRX_OPEN_QUEUE_FAILED:
            return "Commetrex error: Open queue failed.";
        case TRM_CMTRX_BAD_PAGE_SIZE:
            return "Commetrex error: Bad page size.";
        case TRM_CMTRX_FILE_IO_FAILURE:
            return "Commetrex error: File I/O failure.";
        case TRM_CMTRX_CONVERSION_REQUIRED:
            return "Commetrex error: Conversion required.";
        case TRM_CMTRX_NO_MORE_DOCUMENTS:
            return "Commetrex error: No more documents.";
        case TRM_CMTRX_INCORRECT_LIBRARY_VERSION:
            return "Commetrex error: Incorrect library version.";
        case TRM_CMTRX_RATE_TOO_LOW:
            return "Commetrex error: Rate too low.";
        case TRM_CMTRX_QUEUE_OVERFLOW:
            return "Commetrex error: Queue overflow.";
        case TRM_CMTRX_ALREADY_ATTACHED:
            return "Commetrex error: Unknown error.";
        case TRM_CMTRX_IMAGE_RECEIVE_FAIL:
            return "Commetrex error: Image receive failed.";
        case TRM_CMTRX_CPCD_BUSY:
            return "Commetrex error: CPCD busy.";
        case TRM_CMTRX_FAILURE:
            return "Commetrex error: Unknown error.";
        case TRM_CMTRX_NO_FAX_RESOURCES:
            return "Commetrex error: No fax responde.";
        case TRM_CMTRX_NO_RESOURCE_ASSIGNED:
            return "Commetrex error: No resource assigned.";
        case TRM_CMTRX_NO_CPCD_PORT:
            return "Commetrex error: No CPCD port.";
        case TRM_CMTRX_NO_PASSWORD:
            return "Commetrex error: No password.";
        case TRM_CMTRX_MONITOR_MISSING:
            return "Commetrex error: Unknown error.";
        case TRM_CMTRX_MSEC_WAS_ALLOCATED:
            return "Commetrex error: Unknown error.";
        case TRM_CMTRX_DIS_REJECT_REQUESTED:
            return "Commetrex error: DIS reject requested.";
        case TRM_CMTRX_DIS_SIGNAL:
            return "Commetrex error: Out-of-band remote disconnect.";
        case TRM_CMTRX_DIS_CLEARDOWN_TONE:
            return "Commetrex error: In-band remote disconnect .";
        case TRM_CMTRX_DIS_RING_STUCK:
            return "Commetrex error: Incoming ring stuck to long.";
        case TRM_CMTRX_DIS_HOST_TIMEOUT:
            return "Commetrex error: Host did not respond in time.";
        case TRM_CMTRX_DIS_REMOTE_ABANDONED:
            return "Commetrex error: Loop-start inbound stopped ringing.";
        case TRM_CMTRX_DIS_TRANSFER:
            return "Commetrex error: Transfer completed .";
        case TRM_CMTRX_DIS_DIAL_FAILURE:
            return "Commetrex error: Dial had a failure.";
        case TRM_CMTRX_DIS_NO_WINK:
            return "Commetrex error: No wink when dialing out.";
        case TRM_CMTRX_DIS_NO_DIALTONE:
            return "Commetrex error: No dialtone to dialing out (LPS).";
        case TRM_CMTRX_OUTOFSERVICE:
            return "Commetrex error: Port out of service (Probably no line connected to the port).";
//nms
        case TRM_NMS_BAD_ARGUMENT:
            return "NMS error:Bad argument.";
        case TRM_NMS_FILE_EXISTS:
            return "NMS error:File already exist.";
        case TRM_NMS_FILE_NOT_FOUND:
            return "NMS error:File not found.";
        case TRM_NMS_INVALID_CTAHANDLE:
            return "NMS error:Invalid CTA handle.";
        case TRM_NMS_INVALID_HANDLE:
            return "NMS error:Invalid handle.";
        case TRM_NMS_BAD_FILE_FORMAT:
            return "NMS error:Bad file format.";
        case TRM_NMS_OUTOFSERVICE:
            return "NMS error:Port out of service (Probably no line connected to the port).";
        case TRM_NMS_NO_MORE_LICENSES:
            return "NMS error:No more licenses.";
        case TRM_NMS_FUNCTION_ACTIVE:
            return "NMS error:Function already active.";
        case TRM_NMS_QUEUE_EMPTY:
            return "NMS error: Queue empty.";
        case TRM_NMS_CONNECT_FAILED:
            return "NMS error:Connect failed.";
        case TRM_NMS_NEGOTIATION_FAILED:
            return "NMS error:Negotiation failed.";
        case TRM_NMS_NO_LICENSE:
            return "NMS error:No fax licenses.";
        case TRM_NMS_LICENSE_ALREADY_ALLOC:
            return "NMS error: Licese already allocated.";
        case TRM_NMS_SESSION_FAILED:
            return "NMS error:Session failed.";
        case TRM_NMS_OPEN_QUEUE_FAILED:
            return "NMS error:Open queue failed.";
        case TRM_NMS_BAD_PAGE_SIZE:
            return "NMS error:Bad page size.";
        case TRM_NMS_CONVERSION_REQUIRED:
            return "NMS error:Conversion required.";
        case TRM_NMS_NO_MORE_DOCUMENTS:
            return "NMS error:No more documents.";
        case TRM_NMS_RATE_TOO_LOW:
            return "NMS error: Transfer rate too low.";
        case TRM_NMS_BUFFER_UNDERRUN:
            return "NMS error:Buffer underrun.";
        case TRM_NMS_NO_MODEMS:
            return "NMS error:No modems.";
        case TRM_NMS_NO_PPM:
            return "NMS error:No PPM.";
        case TRM_NMS_NO_PPM_RESPONSE:
            return "NMS error:No PPM response.";
        case TRM_NMS_INCOMPATIBLE_RECEIVER:
            return "NMS error:Incompatible receiver.";
        case TRM_NMS_PROTOCOL_ERROR:
            return "NMS error:Protocol error.";
        case TRM_NMS_REMOTE_DCN:
            return "NMS error:Remote DCN.";

#endif
        }
        return "" ;
}


/////////////////////////////////////////////////////////////////////////////
// CDlgFaxPortSetup dialog

CDlgFaxPortSetup::CDlgFaxPortSetup(CWnd* pParent /*=NULL*/)
    : CDlg(CDlgFaxPortSetup::IDD, pParent)
{
    //{{AFX_DATA_INIT(CDlgFaxPortSetup)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}

void CDlgFaxPortSetup::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CDlgFaxPortSetup)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CDlgFaxPortSetup, CDialog)
    //{{AFX_MSG_MAP(CDlgFaxPortSetup)
    ON_CBN_SELCHANGE(IDC_FAXLIST, OnSelchangeFaxlist)
    ON_BN_CLICKED(IDC_DEBUG, OnClickedDebug)
    ON_BN_CLICKED(IDC_DRDEBUG, OnClickedDrDebug)
    ON_BN_CLICKED(IDC_TESTMODEM, OnTestmodem)
	ON_BN_CLICKED(IDC_TESTDIALTONE, OnTestdialtone)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


static  void LoadFaxNames(CDialog  *cDlg, BOOL bClose)
{
    CImgApp     *pApp = (CImgApp *)AfxGetApp();
    CListBox    *pPortBox = (CListBox *)cDlg->GetDlgItem(IDC_FAXPORTS);
    int         nWidth = 0;

    for ( int i = 0; i < MAX_FAXPORTS; i++) {
        if(pApp->FaxPorts[i])
        {
            if (pApp->FaxPorts[i]->IsOpen() || bClose)
            {
                TSSessionParameters CSession ;
                GetSessionParameters(pApp->FaxPorts[i],&CSession) ;
                CString cFax = CSession.PortName;
                cFax += ':' ;
                                cFax += CSession.ModemName;
                cFax +=  '.';
                cFax += CSession.FaxType;

                pPortBox->SetItemData(pPortBox->AddString(cFax), (DWORD)(i));
                if(cFax.GetLength() > nWidth)
                {
                    nWidth = cFax.GetLength();
                }
            }
        }
    }
    pPortBox->SetHorizontalExtent(8*nWidth);
    pPortBox->SetCurSel(0);
}

static  int GetPortNumber(CDialog *cDlg)
{
    int         iPort   = -1;
    CListBox    *pPortList = (CListBox *)cDlg->GetDlgItem(IDC_FAXPORTS);

    iPort = pPortList->GetCurSel();
    if(iPort >= 0)
        iPort = (int)pPortList->GetItemData(iPort);
    else
        iPort = -1;
    return iPort;
}

/////////////////////////////////////////////////////////////////////////////
// CDlgFaxPortSetup message handlers

BOOL CDlgFaxPortSetup::OnInitDialog()
{
    int CntPorts, nCom;
    char chFullName[15];

    CDlg::OnInitDialog();
    CImgApp *pApp = (CImgApp *)AfxGetApp();
#ifndef WIN32
    if ( pApp->FaxPorts[0] && pApp->FaxPorts[1] && pApp->FaxPorts[2] && pApp->FaxPorts[3]) {
        AfxMessageBox( "No free port to open!, Please close a port already open!" );
        EndDialog(FALSE);
        return  FALSE;
    }
#endif
    // Fill comm. port list box.
    CntPorts = 0 ;
    for ( nCom = 0 ; nCom < MAX_FAXPORTS ; nCom++) {
        char szCom[10];
        sprintf(szCom, "COM%1d", nCom+1);
#ifndef _THREAD
        int nCommPort = OpenComm( szCom, 32, 32 );
#else
        sprintf( chFullName, "\\\\.\\COM%d", nCom+1 );
        HANDLE nCommPort =  CreateFile( chFullName, GENERIC_READ | GENERIC_WRITE,
                      0,                    // exclusive access
                      NULL,                 // no security attrs
                      OPEN_EXISTING,
                      FILE_ATTRIBUTE_NORMAL |
                      FILE_FLAG_OVERLAPPED, // overlapped I/O
                      NULL )  ;

#endif

#ifndef _THREAD
        if (nCommPort >= 0  ) {
            CloseComm(nCommPort);
#else
        if (nCommPort != INVALID_HANDLE_VALUE  ) {
            CloseHandle(nCommPort);
#endif
            CntPorts++ ;
            //pApp->FaxPorts[nCom] = GetPortID(szCom);
            ((CListBox *)GetDlgItem(IDC_PORTLIST))->AddString(szCom);
        }
    }
    // Fill fax list box.
    UINT    nLength = 0;
    BOOL    First= TRUE;
    LPSTR   IniFileName;
    int     localFax= 0;
    IniFileName= "faxcpp1.ini";
    CComboBox    *pFaxList = (CComboBox *)GetDlgItem(IDC_FAXLIST);
    for(int nFaxes = 1; ;nFaxes++) {
        char szFax[128], szFaxName[128];

        sprintf(szFax, "Fax%d", ++localFax);

        if(!GetPrivateProfileString("Faxes", szFax, "", szFaxName, sizeof(szFaxName), IniFileName)) {
            if (!First) break;
            First= FALSE;
            IniFileName= "faxcpp2.ini";
            FaxFileOne= nFaxes;
            localFax = 0;
            continue;
        }
        if(!GetPrivateProfileString(szFaxName, "Long Name", "", szFaxName, sizeof(szFaxName), IniFileName)) {
            if (!First) break;
            First= FALSE;
            IniFileName= "faxcpp2.ini";
            FaxFileOne= nFaxes;
            localFax = 0;
            continue;
        }
        int nItem = pFaxList->AddString(szFaxName);
        pFaxList->SetItemData(nItem, nFaxes);
        if(strlen(szFaxName) > nLength)
            nLength = strlen(szFaxName);
    }
    ((CListBox *)GetDlgItem(IDC_PORTLIST))->SetCurSel(0);

    // Identification number. (own fax number)
    CString cId = pApp->GetProfileString("Fax", "Identification String", NULL);
    SetDlgItemText(IDC_IDSTRING, cId);

    // No, of ring before pick the phone up.
    UINT nRing = pApp->GetProfileInt("Fax", "Ring To Answer", 1);
    SetDlgItemInt(IDC_NOFRING, nRing, TRUE);

    // Header settings
    ((CButton *)GetDlgItem(IDC_HEADER))->SetCheck( pApp->GetProfileInt( "Fax", "Header", 1 ) );

    // Set defualt debug files and debug flags.
    ((CButton *)GetDlgItem(IDC_DEBUG))->SetCheck(FALSE);

    pFaxList->SetCurSel(pApp->GetProfileInt("Fax","Selected",0));
    OnSelchangeFaxlist();
    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CDlgFaxPortSetup::OnClickedDebug()
{

}

void CDlgFaxPortSetup::OnClickedDrDebug()
{

}

void CDlgFaxPortSetup::OnSelchangeFaxlist()
{
    // Load setup string of the selected fax.
    CComboBox *cFaxList =(CComboBox*)GetDlgItem(IDC_FAXLIST);
    char szFaxName[256];
    char szReset[64] ;

    int nFax= (int)cFaxList->GetItemData(cFaxList->GetCurSel());
    LPSTR IniFile= "faxcpp1.ini";
    if (nFax > FaxFileOne) {
        nFax-= FaxFileOne;
        IniFile= "faxcpp2.ini";
    }
    wsprintf(szFaxName, "Fax%d",  nFax);

    GetPrivateProfileString("Faxes", szFaxName, "", szFaxName, sizeof(szFaxName), IniFile);

    GetPrivateProfileString(szFaxName,"Reset String","ATZ",szReset,sizeof(szReset),IniFile);
    SetDlgItemText(IDC_RESET,szReset);

    if(!GetPrivateProfileString(szFaxName, "Setup String", "", szFaxName, sizeof(szFaxName), IniFile))
        szFaxName[0] = '\0';
    SetDlgItemText(IDC_SETUP, szFaxName);
}

void CDlgFaxPortSetup::OnChangeSetup()
{
    // TODO: Add your control notification handler code here

    // Save setup string if modified.
    char szFaxName[256];
    char szSetup[256];

    CComboBox *cFaxList =(CComboBox *)GetDlgItem(IDC_FAXLIST);
    GetDlgItemText(IDC_SETUP, szSetup, sizeof(szSetup));

    int nFax= (int)cFaxList->GetItemData(cFaxList->GetCurSel());
    LPSTR IniFile= "faxcpp1.ini";
    if (nFax > FaxFileOne) {
        nFax-= FaxFileOne;
        IniFile= "faxcpp2.ini";
    }
    wsprintf(szFaxName, "Fax%d",  nFax);
    GetPrivateProfileString("Faxes", szFaxName, "", szFaxName, sizeof(szFaxName), IniFile);

    WritePrivateProfileString(szFaxName, "Setup String", szSetup, IniFile);

}

void CDlgFaxPortSetup::OnChangeReset()
{
    // Save Reset string if modified.
    char szFaxName[256];
    char szReset[64],szNewReset[64] ;

    CComboBox *cFaxList =(CComboBox *)GetDlgItem(IDC_FAXLIST);

    int nFax= (int)cFaxList->GetItemData(cFaxList->GetCurSel());
    LPSTR IniFile= "faxcpp1.ini";
    if (nFax > FaxFileOne) {
        nFax-= FaxFileOne;
        IniFile= "faxcpp2.ini";
    }
    wsprintf(szFaxName, "Fax%d",  nFax);
    GetPrivateProfileString("Faxes", szFaxName, "", szFaxName, sizeof(szFaxName), IniFile);

    GetDlgItemText(IDC_RESET,szNewReset,sizeof(szNewReset));
    GetPrivateProfileString(szFaxName,"Reset String","ATZ",szReset,sizeof(szReset),IniFile);
    if (strncmp(szReset,szNewReset,sizeof(szReset))!=0) {
        WritePrivateProfileString(szFaxName, "Reset String", szNewReset, IniFile);
    }

}

void CDlgFaxPortSetup::OnOK()
{
    int       nFax, nRing, nBaud, SelectedFax, nEcm, nBft ;
    LPSTR     IniFile ;
    CListBox  *cPortList ;
    CComboBox *cFaxList ;
    char      szPortName[10];
    char      szFaxName[50];
    char      szReset[64] ;
    char      szStationID[21] ;

    CImgApp *   pApp  ;

    pApp = (CImgApp *)AfxGetApp();

    OnChangeSetup();
    OnChangeReset();

    cPortList =(CListBox *)GetDlgItem(IDC_PORTLIST);
    cPortList->GetText(cPortList->GetCurSel(), szPortName);

    // Get fax name,.
    cFaxList =(CComboBox*)GetDlgItem(IDC_FAXLIST);

    nFax= (int)cFaxList->GetItemData(cFaxList->GetCurSel());
    IniFile= "faxcpp1.ini";
    if (nFax > FaxFileOne) {
        nFax-= FaxFileOne;
        IniFile= "faxcpp2.ini";
    }
    wsprintf(szFaxName, "Fax%d",  nFax);
    GetPrivateProfileString("Faxes", szFaxName, "", szFaxName, sizeof(szFaxName), IniFile);

    SelectedFax = cFaxList->GetCurSel();
    pApp->WriteProfileInt("Fax","Selected",SelectedFax);

    // Get ID string and no. of ring to answer.
    GetDlgItemText(IDC_IDSTRING, szStationID, sizeof(szStationID));
    pApp->WriteProfileString("Fax", "Identification String", szStationID);
    SetMyID(szStationID);

    nRing = GetDlgItemInt(IDC_NOFRING, NULL, TRUE);
    pApp->WriteProfileInt("Fax", "Ring To Answer", nRing);
    // Get header string
    pApp->WriteProfileInt( "Fax", "Header", ((CButton *)GetDlgItem(IDC_HEADER))->GetCheck() );

    // Find and empty faxport.
    for ( int i = 0 ; i < MAX_FAXPORTS ; i++ ) {
        if (!pApp->FaxPorts[i] ) {
            pApp->FaxPorts[i] = ConnectPortExt(szPortName, szFaxName, IniFile);
            if(!pApp->FaxPorts[i]) {
                AfxMessageBox("Unable to connect port!");
                return;
            } else {
                pApp->nComm[i] = atoi(&szPortName[3]);
                pApp->FaxEventText(i, "Port Open");
                if ( ((CButton *)GetDlgItem(IDC_DEBUG))->GetCheck() ) {
                    EnableLog(pApp->FaxPorts[i],TRUE);
                } ;
                GetDlgItemText(IDC_RESET,szReset,sizeof(szReset)) ;
                SetModemCommands(pApp->FaxPorts[i],szReset,NULL,NULL,NULL);
                SetAutoAnswer(pApp->FaxPorts[i], nRing);
                pApp->nRings[i] = nRing;

                SetRuningMode(pApp->RunMode);

                SetSpeaker(pApp->FaxPorts[i], pApp->SpeakerMode, pApp->SpeakerVolume);
                SetDialMode( pApp->FaxPorts[i], TONE_DIAL );

                nBaud = pApp->GetProfileInt("Fax", "MAXBAUD", 4);
                nEcm = pApp->GetProfileInt("Fax", "Enable ECM Receive", ECM_ENABLE );
                nBft = pApp->GetProfileInt("Fax", "Enable BFT", BFT_DISABLE );
                if(nBaud<=0 || nBaud>=BDR_END)
                    nBaud = BDR_14400;
                SetPortCapabilities(pApp->FaxPorts[i], FDC_BAUD_SEND, nBaud);
                SetPortCapabilities(pApp->FaxPorts[i], FDC_BAUD_REC,  nBaud);
                SetPortCapabilities(pApp->FaxPorts[i], FDC_ECM, nEcm);
                SetPortCapabilities(pApp->FaxPorts[i], FDC_BINARY, nBft);
                SetStationID( pApp->FaxPorts[i], szStationID );

            }
            break;
        }
    }
    CDialog::OnOK();
}
/////////////////////////////////////////////////////////////////////////////
// CDlgSendFax dialog

CDlgSendFax::CDlgSendFax(CWnd* pParent /*=NULL*/)
    : CDlg(CDlgSendFax::IDD, pParent)
{
    //{{AFX_DATA_INIT(CDlgSendFax)
    m_phonenum = "";
    m_name = "";
    //}}AFX_DATA_INIT
}

void CDlgSendFax::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CDlgSendFax)
    DDX_Text(pDX, IDC_FAXNUMBER, m_phonenum);
    DDX_Text(pDX, IDC_NAME, m_name);
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CDlgSendFax, CDialog)
    //{{AFX_MSG_MAP(CDlgSendFax)
    ON_LBN_SELCHANGE(IDC_LIST1, OnSelchangeList1)
        ON_EN_CHANGE(IDC_FAXNUMBER, OnChangeFaxnumber)
        ON_BN_CLICKED(IDC_SEND_MANUAL, OnSendManual)
        ON_BN_CLICKED(IDC_SEND_POLLING, OnSendPolling)
        ON_BN_CLICKED(IDC_SENDIMMEDIATE, OnSendimmediate)
        ON_BN_CLICKED(IDC_SENDQUEUE, OnSendqueue)
	ON_EN_CHANGE(IDC_MONTH, OnChangeMonth)
	ON_EN_CHANGE(IDC_DAY, OnChangeDay)
	ON_EN_CHANGE(IDC_YEAR, OnChangeYear)
	ON_EN_CHANGE(IDC_HOUR, OnChangeHour)
	ON_EN_CHANGE(IDC_MINUTE, OnChangeMinute)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgSendFax message handlers

BOOL CDlgSendFax::OnInitDialog()
{
    struct  tm tim;
    time_t  now=time( NULL );
    CImgApp *pApp = (CImgApp *)AfxGetApp();

    GetDlgItem(IDOK)->EnableWindow(FALSE);


    if(pDoc->IsKindOf(RUNTIME_CLASS(CBlockDoc)))
    {
        strcpy(pDoc->szTiffFileName,"temp.tif");
        //SaveDIBInTiffFormat(pDoc->szTiffFileName, pDoc->m_hDib, TCOMP_CCITTG31D, FALSE);
        pDoc->m_bGroup=0;
    }
    CDlg::OnInitDialog();

    static char pbook_fname[_MAX_PATH] = "CF";
#ifndef WIN32
    if(!pApp->FaxPorts[0] && !pApp->FaxPorts[1] && !pApp->FaxPorts[2] && !pApp->FaxPorts[3]) {
        AfxMessageBox("No port exist for sending");
        EndDialog(FALSE);
        return  FALSE;
    }
#endif
    ::LoadFaxNames(this, FALSE);

    // Fill a lisstbox with the opened faxes.
//    CString cId = pApp->GetProfileString("Fax", "Fax Number", NULL);
//    SetDlgItemText(IDC_FAXNUMBER, cId);

    SetPhbookFileName(pbook_fname);         /* from PHBDLG.CPP */

    BOOL bOK = PB_PhoneBookExists(pbook_fname);
    if ( !bOK ) {
        if ( PB_CreatePhoneBook(pbook_fname) ) {
            AfxMessageBox( "Couldn't create phonebook database !" );
        }
    }
    m_hDB = PB_OpenPhoneBook(pbook_fname, &m_err);

    FillPhoneBook();

    CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
    if ( lst1 ) {
        int nn = lst1->GetCount();
        if ( nn > 0 ) {
            lst1->SetCurSel(0);
            OnSelchangeList1();
        }
    }
    ((CEdit *)GetDlgItem(IDC_NAME))->LimitText(32);
    ((CEdit *)GetDlgItem(IDC_FAXNUMBER))->LimitText(32);
    ((CEdit *)GetDlgItem(IDC_YEAR))->LimitText(4);
    ((CEdit *)GetDlgItem(IDC_MONTH))->LimitText(2);
    ((CEdit *)GetDlgItem(IDC_DAY))->LimitText(2);
    ((CEdit *)GetDlgItem(IDC_HOUR))->LimitText(2);
    ((CEdit *)GetDlgItem(IDC_MINUTE))->LimitText(2);
    tim = *localtime( &now );
    SetDlgItemInt( IDC_YEAR, tim.tm_year + 1900);
    SetDlgItemInt( IDC_MONTH, tim.tm_mon+1 );
    SetDlgItemInt( IDC_DAY, tim.tm_mday );
    SetDlgItemInt( IDC_HOUR, tim.tm_hour );
    SetDlgItemInt( IDC_MINUTE, tim.tm_min );

    CheckRadioButton(IDC_SENDQUEUE, IDC_SEND_POLLING, IDC_SENDQUEUE);
    CheckRadioButton(IDC_UNCOMPRESSED, IDC_COLOR, IDC_G31D );

   /* int onepage = pApp->GetProfileInt( "Fax", "OnePage", 1 );
    int nRadio = onepage ? IDC_RADIO2 : IDC_RADIO1;*/
    CheckRadioButton(IDC_RADIO1, IDC_RADIO2, IDC_RADIO1);

    int enableBFT = pApp->GetProfileInt( "Fax", "EnableBFT", 0 );
    int nCheck = enableBFT ? 1 : 0;

    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CDlgSendFax::OnCancel()
{
    ClosePhoneBook();
    CDialog::OnCancel();
}

BOOL CDlgSendFax::TestPhoneNumber()
{
    char lpPhone[70];
    lpPhone[0] = 0;
    GetDlgItemText(IDC_FAXNUMBER, lpPhone, sizeof(lpPhone));
    int ii = _fstrspn(lpPhone, "0123456789-(),#");
    int ln = lstrlen(lpPhone);
    BOOL bOK = (ii>=ln && ln) ? TRUE : FALSE;
    return bOK;
}

void CDlgSendFax::OnSelchangeList1()
{
    CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
    if(lst1==NULL || m_hDB==NULL)
        return;

    int index = lst1->GetCurSel();
    if(index<0)
        return;

    PB_ITEMHANDLE hItem = (PB_ITEMHANDLE)lst1->GetItemData(index);

    PB_ITEMREC data;
    _fmemset(&data, 0, sizeof(data) );
    m_err = PB_GetItem(m_hDB, hItem, &data);
    if ( m_err )
        return;

    SetDlgItemText(IDC_NAME, data.szName);
    SetDlgItemText(IDC_FAXNUMBER, data.szPhoneNum);

    m_szDName = data.szName;
    m_szDComp = data.szCompanyName;
}

void CDlgSendFax::FillPhoneBook(void)
{
    CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
    if ( lst1==NULL )
        return;

    lst1->ResetContent();
    if ( m_hDB ) {
        m_err = PB_EnumItemsInDB(m_hDB, DOWN, 0l, FillPerson, this);
    }
}

/*  static member function   Fill the person list box */
BOOL _export FAR PASCAL CDlgSendFax::FillPerson(PB_ITEMHANDLE hItem, LPVOID lpPar)
{
    PB_ERRORS  err;
    PB_ITEMREC data;
    CDlgSendFax FAR *cb = (CDlgSendFax FAR *)lpPar;    /* this pointer */

    if(hItem==NULL)
    {
        return TRUE;
    }

    err = PB_GetItem( cb->m_hDB, hItem, &data);
    if(err)
    {
        return FALSE;
    }

    cb->AddPersonList(&data, hItem);
    return TRUE;
}

int CDlgSendFax::AddPersonList(PB_LPITEMREC data, PB_ITEMHANDLE hItem)
{
    int index;
    CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
    if(lst1==NULL)
        return -1;

    index = lst1->AddString(data->szName);

    if(index>=0) {
        lst1->SetItemData(index, hItem);
    }

    return index;
}

void CDlgSendFax::ClosePhoneBook()
{
    if ( m_hDB ) {
        PB_ClosePhoneBook(m_hDB);
        m_hDB = NULL;
    }
}

#define SEND_TYPE_END      -1
#define SEND_TYPE_NORMAL    0
#define SEND_TYPE_BFT       1

int CDlgSendFax::qryOneFaxType(int jj)
{
    int nSiz;
    int nRet;
    if(pDoc->m_bGroup)
    {
        nSiz = pDoc->arStat.GetSize();
        if(jj>=nSiz)
            return SEND_TYPE_END;
        nRet = (pDoc->arStat.GetAt(jj)==STAT_BFT) ? SEND_TYPE_BFT : SEND_TYPE_NORMAL;
    }
    else
    {
        nRet = SEND_TYPE_NORMAL;
    }
    return nRet;
}

int CDlgSendFax::qryActPage()
{
    int nRet;
    if(pDoc->m_bGroup)
    {
        nRet = pDoc->nGroupCurrent;
    }
    else
    {
        nRet = pDoc->nCurrent;
    }
    return nRet;
}


int CDlgSendFax::qryFaxType(int pagefrom, int &pageto, int pagenum, BOOL &bNext, int &LastType)
{
    int ActType, tmp;
    if(pagefrom >= pagenum)
        return SEND_TYPE_END;

	int jj;
    for(jj=pagefrom; jj<pagenum; jj++)
    {
        if(bNext==0)
        {
            LastType = qryOneFaxType(jj);
            bNext = 1;
        }
        ActType = qryOneFaxType(jj);
        if(ActType==SEND_TYPE_END)
        {
            ActType = LastType;
            break;
        }
        if(ActType != LastType)
        {
            tmp = ActType;
            ActType = LastType;
            LastType = tmp;
            break;
        }
    }
    pageto = jj;
    return ActType;
}

int CDlgSendFax::qryMaxPage()
{
    int pagenum = 0;
    if ( pDoc->m_bGroup )
        pagenum = pDoc->arName.GetSize();
    else
        pagenum = pDoc->nImages;
    return pagenum;
}

HANDLE CDlgSendFax::qrySendPage(int iPage, CString &strFileName, BOOL bLoad)
{
    int nSiz, iImage, nError;
    HANDLE hDibLoc = NULL;
    LPSTR lpFileName = NULL;

    strFileName.Empty();

    if ( pDoc->m_bGroup ) {
        nSiz = pDoc->arName.GetSize();
        if(iPage>=nSiz)
            return NULL;
        strFileName = pDoc->arName.GetAt(iPage);
        iImage = 0;
    }
    else {
        strFileName = CString(pDoc->szTiffFileName);
        iImage = iPage;
    }
    if ( strFileName.IsEmpty() )
        return NULL;

    lpFileName = strFileName.GetBuffer( strFileName.GetLength()+1 );

    if(bLoad) {
        if ( GetImageFormat(lpFileName) == ASCII_FILE ) {
            hDibLoc = pDoc->m_hDibPages[iPage];
        }
        else
        hDibLoc = LoadImageIntoDIB(lpFileName, iImage, &nError);
    }
    return hDibLoc;
}

BOOL CDlgSendFax::SendNormalFax(int pagefrom, int pageto)
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    TSFaxParam  sFaxParam;
    FAXOBJ      faxobj ;
    BOOL        bColor ;

    bColor = FALSE ;
    if ( pagefrom >= pageto )
        return FALSE;

    sFaxParam.PageNum     = pageto - pagefrom;


    sFaxParam.Width       = PWD_1728;
    sFaxParam.Length      = PLN_A4;
    sFaxParam.Compress    = DCF_1DMH;
    sFaxParam.Binary      = BFT_NOCHANGE;
    sFaxParam.BitOrder    = BTO_FIRST_LSB;
    sFaxParam.Resolut     = RES_NOCHANGE;

/*
         if((pDoc->dwWidth==1728) && (pDoc->dwHeight==1100)
                        && (pDoc->wVerticalDPI<=100) && (pDoc->wVerticalDPI>=98))
                                sFaxParam.Resolut = RES_98LPI;
         if((pDoc->dwWidth==1728) && (pDoc->dwHeight==2200)
                        && (pDoc->wVerticalDPI<=200) && (pDoc->wVerticalDPI>=196))
                                sFaxParam.Resolut = RES_196LPI;                                                 //rz
*/
         GetDlgItemText( IDC_FAXNUMBER, &sFaxParam.RemoteNumber[0], sizeof(sFaxParam.RemoteNumber));
    pApp->WriteProfileString("Fax", "Fax Number", sFaxParam.RemoteNumber);
    sFaxParam.Send = TRUE;

    int nRadio = GetCheckedRadioButton( IDC_UNCOMPRESSED, IDC_COLOR );
    switch ( nRadio ) {
        case IDC_UNCOMPRESSED: sFaxParam.Compress = DCF_UNCOMPRESSED; break;
        case IDC_G31D:         sFaxParam.Compress = DCF_1DMH;         break;
        case IDC_G32D:         sFaxParam.Compress = DCF_2DMR;         break;
        case IDC_G4:
             sFaxParam.Compress = DCF_2DMMR;
             //sFaxParam.Ecm      = ECM_ENABLE;
             break;
        case IDC_COLOR:
             sFaxParam.Compress = DCF_1DMH;
             //sFaxParam.Ecm      = ECM_ENABLE;
             break;
        default :              sFaxParam.Compress = DCF_1DMH;         break;
    }

    if (nRadio != IDC_COLOR ) {
        faxobj = CreateSendFax('N', &sFaxParam);
        } else {
                faxobj = CreateSendFax(REGTYPE_COLORFAX, &sFaxParam);
                bColor = TRUE ;
        }

    if ( !faxobj ) {
        AfxMessageBox("CreateSendFax failed");
        pApp->FaxEventText(iPort, "CreateSendFax failed");
        return FALSE;
    }
    if ( !bColor && pApp->GetProfileInt( "Fax", "Header", NULL )
#if defined(WIN32)
                            && (m_faxport->IsComPort() || m_faxport->ComBoard()==BRD_BICOM || m_faxport->ComBoard()==BRD_COMMETREX /*|| m_faxport->ComBoard()==BRD_NMS*/)
#endif
                                      ) {
        TSHeaderContext header;
        TSSessionParameters sess;

        GetSessionParameters( m_faxport, &sess );
        wsprintf( header.lpszFrom, "From: %s To: %%f", sess.LocalID );
        wsprintf( header.lpszTo, "Page %%c of %%p" );
        wsprintf( header.lpszDateTimePage, "On: %%t, %%D");
        header.Height=25;
        for ( int i=0 ; i<3 ; i++ ) {
            strcpy( header.Record[i].FontFaceName , "Courier_New" ); 
            header.Record[i].FontSize = 8;
            header.Record[i].Weight = 0;
            header.Record[i].Italic = 0;
            header.Record[i].Underline = 0;
            header.Record[i].StrikeOut = 0;
        }
//        SetRect( &header.Record[0].Position,0,50, 52,100 );
//        SetRect( &header.Record[1].Position, 662,50, 1211,100 );
//        SetRect( &header.Record[2].Position, 1212,50, 1212+600,100 );
        SetRect( &header.Record[0].Position,  0, 0, 0, 0 );
        SetRect( &header.Record[1].Position, 0, 0, 0, 0);
        SetRect( &header.Record[2].Position, 0,0, 0, 0 );
        SetFaxHeader( faxobj, &header );
    }
    BOOL bRc = SendAllPage(faxobj, pagefrom, pageto, FALSE);
    return bRc ;
}


BOOL CDlgSendFax::SendBFTFax(int pagefrom, int pageto)
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    if(pagefrom >= pageto)
        return FALSE;

    TSFaxParam  sFaxParam;

    FAXOBJ faxobj = TCFaxNormal::CreateFaxObj(REGTYPE_BINARYFILE, TRUE);
    if(!faxobj)
    {
        AfxMessageBox("CreateSendFax failed");
        pApp->FaxEventText(iPort, "CreateSendFax failed");
        return FALSE;
    }

    faxobj->GetParam(sFaxParam);

    sFaxParam.PageNum  = pageto - pagefrom;
    sFaxParam.Binary   = BFT_ENABLE;
    sFaxParam.BitOrder = BTO_FIRST_LSB;
    sFaxParam.Ecm      = ECM_ENABLE;
    GetDlgItemText(IDC_FAXNUMBER, &sFaxParam.RemoteNumber[0], sizeof(sFaxParam.RemoteNumber));
    sFaxParam.Send = TRUE;

    faxobj->SetParam(sFaxParam);

    pApp->WriteProfileString("Fax", "Fax Number", sFaxParam.RemoteNumber);

    return SendAllPage(faxobj, pagefrom, pageto, TRUE);
}

BOOL CDlgSendFax::SendAllPage(FAXOBJ faxobj, int pagefrom, int pageto, BOOL bBFTflag)
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    char buf[300];
    LPSTR lpFileName = NULL;
    CString strFileName;
    HANDLE hDibLoc;

    TCBinaryParam BftObj;

    union TUFaxImage   sFaxPage;
    int iError = 0, startpage=0;
    BOOL bOk = TRUE;

    pApp->FaxEventText(iPort, "---");


    int jj, iPage;
    for ( jj=0 ; jj< pageto-pagefrom ; jj++ ) {
        iPage = jj + pagefrom;

        hDibLoc = qrySendPage(iPage, strFileName, !bBFTflag);

        lpFileName = strFileName.GetBuffer( strFileName.GetLength()+1 );

        if ( bBFTflag ) {
            char filebuf[200];
            char fname[_MAX_FNAME+_MAX_EXT+10];
            char fext[_MAX_EXT+10];

            if(lpFileName==NULL)
                lpFileName = "bftimage.im";

            lstrcpyn(filebuf, lpFileName, sizeof(filebuf)-3);
            _splitpath(filebuf, NULL, NULL, fname, fext);
            lstrcat(fname, fext);

            BftObj.WriteValue(BFD_filename, (LPBYTE)fname, lstrlen(fname)+1 );

            BftObj.WriteValue(BFD_data_file_content_FILE, (LPBYTE)filebuf, lstrlen(filebuf)+1);

            LPSTR lpParam = "IMAGE";
            BftObj.WriteValue(BFD_application_reference, (LPBYTE)lpParam, lstrlen(lpParam)+1);

            sFaxPage.BftObj = &BftObj;

            wsprintf(buf, "Setup page-%i for BFT  (%s)", iPage+1, lpFileName);
            pApp->FaxEventText(iPort, buf);
            iError = SetFaxImagePage(faxobj, jj, IMT_BFTOBJ, &sFaxPage,  0);
        }
        else {
            if ( lpFileName==NULL)
                lpFileName = "???";
            if ( hDibLoc==NULL ) {
                wsprintf(buf, "%i page not found", iPage+1);
                pApp->FaxEventText(iPort, buf);
                bOk = FALSE;
                break;
            }
            wsprintf(buf, "Setup page-%i for sending  (%s)", iPage+1, lpFileName);
            pApp->FaxEventText(iPort, buf);

            sFaxPage.Dib = hDibLoc;
            iError = SetFaxImagePage(faxobj, startpage+jj, IMT_MEM_DIB, &sFaxPage,  0);
        }
        if ( iError < 0 ) {
            wsprintf(buf, "SetFaxImagePage has failt, page:%i, error:%i %s",
                                                        iPage+1, iError, MakeFERText(iError) );
            pApp->FaxEventText(iPort, buf);
            bOk = FALSE;
            break;
        }

        if ( iError > 0 ) {
            wsprintf(buf, "SetFaxImagePage return code, page:%i, error:%i %s",
                                                         iPage+1, iError, MakeFERText(iError) );
            pApp->FaxEventText(iPort, buf);
        }
        if ( hDibLoc )
            GlobalFree( hDibLoc );
    }

    if(bOk==FALSE)
        return FALSE;

    return SendFaxObj(faxobj);
}

BOOL CDlgSendFax::TestDate()
{
    int year  = GetDlgItemInt(IDC_YEAR);
    int month = GetDlgItemInt(IDC_MONTH);
    int day   = GetDlgItemInt(IDC_DAY);
    int hour  = GetDlgItemInt(IDC_HOUR);
    int minut = GetDlgItemInt(IDC_MINUTE);
	
    struct  tm tim;
	time_t  now=time( NULL );
	tim = *localtime( &now );
    
    if(year < tim.tm_year+1900)
        return FALSE;

    if(month < 1 || month > 12)
        return FALSE;

    if(day < 1 || day > 31)
        return FALSE;

    if(hour < 0 || hour > 23)
        return FALSE;

    if(minut < 0 || minut > 59)
        return FALSE;

    return TRUE;
}

BOOL CDlgSendFax::SendFaxObject(FAXOBJ faxobj, BOOL bRealSend )
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    CLogs   *OutBox;
    CString szName;
    TSFaxParam sFaxParam;
    TSFaxHeader header;
    CFileException e;
    int     iError = 0;
    BOOL    bSend=FALSE;
    HFILE   hf;
    struct tm stm, ctm;
    time_t  lSendTime, CurTime=time(NULL);
    LPSTR   lpPhoneNum = m_phonenum.GetBuffer( m_phonenum.GetLength() );
    LPSTR   lpName = m_name.GetBuffer( m_name.GetLength() );

    if (!faxobj) return 1;

    ctm = *localtime( &CurTime );
    memset(&stm, 0, sizeof(stm));
    stm.tm_year  = GetDlgItemInt(IDC_YEAR)-1900;
    stm.tm_mon   = GetDlgItemInt(IDC_MONTH)-1;
    stm.tm_mday  = GetDlgItemInt(IDC_DAY);
    stm.tm_hour  = GetDlgItemInt(IDC_HOUR);
    stm.tm_min   = GetDlgItemInt(IDC_MINUTE);
    stm.tm_isdst = ctm.tm_isdst;

    lSendTime = mktime(&stm);

    if (lSendTime  <= 0)
        lSendTime = time(NULL);
    faxobj->GetParam(sFaxParam);
    sFaxParam.BitOrder = BTO_FIRST_LSB;
    sFaxParam.Send = TRUE;
    sFaxParam.DeleteFiles = TRUE ;

    faxobj->SetParam(sFaxParam);

    if ( bRealSend )
        OutBox = (CLogs*) pApp->LogDocument[LGT_OUTBOX] ;
    else
        OutBox = (CLogs*) pApp->LogDocument[LGT_POLLING] ;
    if ( !OutBox )
        return 1 ;

    hf = pApp->GetFileName( OutBox->m_szActDir, CString("tmp"), szName );

    memset( &header, 0, sizeof(TSFaxHeader) );
    header.bType        = faxobj->GetFaxType();
    header.wPageNum     = (WORD)sFaxParam.PageNum;
    header.bResolut     = (BYTE)sFaxParam.Resolut;
    header.bWidth       = (BYTE)sFaxParam.Width;
    header.bLength      = (BYTE)sFaxParam.Length;
    header.bCompress    = (BYTE)sFaxParam.Compress;
    header.bBinary      = (BYTE)sFaxParam.Binary;
    header.bBitOrder    = (BYTE)sFaxParam.BitOrder;
    header.bSend        = (BYTE)sFaxParam.Send;
    header.wRetry       = 1;
    header.wInterval    = 30;
    header.dwTransmitTime = 0;
    header.wSpeed       = 0;
    header.wStatus      = (BYTE)FXS_WAITSEND;
    header.wRefCnt      = 0;
    _fstrcpy( &header.RemoteNumber[0], lpPhoneNum );
    _fstrcpy( &header.szKey[0], "" );
    _fstrcpy( &header.szSubAddr[0], "" );
    _fstrcpy( &header.szName[0], lpName );
    _fstrcpy( &header.szCompany[0], "Company" );
    pApp->SetFaxTime( &header.CreateTime, &ctm);
    pApp->SetFaxTime( &header.SendTime, &stm);

    if ( faxobj->WriteHeader( hf, &header ) )
        return 1;
    if ( faxobj->WriteImgData( hf ) )
        return 1;

    if ( bRealSend ) {
        if ( lSendTime <= CurTime ) {
            for ( int i=0 ; i<MAX_FAXPORTS ; i++ ) {
                if ( pApp->FaxPorts[i] ) {
                    if ( pApp->FaxPorts[i]->IsOpen() ) {
                        LPSTR   lpName;
                        HGLOBAL hName;

                        hName = GlobalAlloc( GHND, 260 );
                        lpName = (LPSTR)GlobalLock( hName );
                        if ( lpName )
                            lstrcpy( lpName, szName );
                        GlobalUnlock( hName );
                        faxobj->UserData = (long)hName;
                        if ( PutFaxOnQueue(faxobj) >= 0 ) {
                            bSend = TRUE ;
                            header.wStatus = (BYTE)FXS_SENDING;
                            faxobj->WriteHeader( hf, &header );
                        }
                        break ;
                    }
                }
            }
        }
    }
    _lclose( hf );
    OutBox->UpdateViewLine( &header, szName.GetBuffer(szName.GetLength()) );
    if (!bSend)
        ClearFaxObj(faxobj);
    return 0;
}

BOOL CDlgSendFax::SendFaxObj(FAXOBJ faxobj)
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    int     iError = 0;
    char    buf[100];

    switch ( m_nSendMode ) {
        case IDC_SENDQUEUE:
            iError = SendFaxObject( faxobj, TRUE ) ;
            if ( iError == 0 )
                pApp->FaxEventText(iPort, "Fax has been sent to queue");
            break;

        case IDC_SENDIMMEDIATE:
            faxobj->UserData = 0;
            if ( faxobj->GetFaxType() == 'C' )
                SetPortCapabilities( m_faxport, FDC_ECM, ECM_ENABLE );
            iError = SendFaxNow( m_faxport, faxobj, FALSE);
            if ( iError==0 )
                pApp->FaxEventText(iPort, "Fax has been sent to port");
            break;

        case IDC_SEND_MANUAL:
            faxobj->UserData = 0;
            iError = SendFaxNow(m_faxport, faxobj, TRUE);
            if ( iError==0 )
                pApp->FaxEventText(iPort, "Fax has been sent without dialing");
            break;

        case IDC_SEND_POLLING:
            iError = SendFaxObject( faxobj, FALSE ) ;
            if ( iError == 0 )
                pApp->FaxEventText(iPort, "Fax has been sent to polling queue.");
            break;
    }
    if ( iError ) {
        wsprintf(buf, "Send Fax error:%i %s", iError, MakeFERText(iError));
        AfxMessageBox(buf);
        pApp->FaxEventText(iPort, buf);
    }
    return (iError) ? FALSE : TRUE;
}

void CDlgSendFax::xSendFax()
{
    CImgApp     *pApp = (CImgApp *)AfxGetApp();
    int         nBaud = pApp->GetProfileInt("Fax", "MAXBAUD", 4),
                nEcm = pApp->GetProfileInt("Fax", "Enable ECM Send", ECM_ENABLE ),
                nBft = pApp->GetProfileInt("Fax", "Enable BFT", BFT_DISABLE );
    int         nn = GetCheckedRadioButton(IDC_RADIO1, IDC_RADIO2),
                pagefrom = 0, pageto = 0, pagenum = qryMaxPage(), bNext = 0,
                LastType = 0, nType = 0;

    iPort = ::GetPortNumber(this);
    if ( iPort < 0  ||  iPort >=MAX_FAXPORTS )
        return;
    m_nSendMode = GetCheckedRadioButton(IDC_SENDQUEUE, IDC_SEND_POLLING);
    if ( m_nSendMode < IDC_SENDQUEUE )
        m_nSendMode = IDC_SENDQUEUE ;

    m_faxport = pApp->FaxPorts[iPort];
    if ( !m_faxport)
        return;

    if ( nBaud<=0 || nBaud>=BDR_END )
        nBaud = BDR_14400;
    SetPortCapabilities( m_faxport, FDC_BAUD_SEND, nBaud );
    SetPortCapabilities( m_faxport, FDC_BAUD_REC,  nBaud );
    SetPortCapabilities( m_faxport, FDC_ECM, nEcm );
    SetPortCapabilities( m_faxport, FDC_BINARY,  nBft );

    bAllPage = (nn==IDC_RADIO1) ? TRUE : FALSE;

//    BOOL bBFTenable = ((CButton *)GetDlgItem(IDC_CHECK1))->GetCheck();
    BOOL bBFTenable = TRUE;;

    CString cId = pApp->GetProfileString("Fax", "Identification String", NULL);
    SetStationID( m_faxport, cId.GetBuffer( cId.GetLength()+1 ) );

    BOOL bOk = FALSE;

    if ( bAllPage==FALSE ) {
        pagefrom =  qryActPage();
        pagenum = pagefrom + 1;
    }

    for(;;) {
        nType = qryFaxType(pagefrom, pageto, pagenum, bNext, LastType);

        if(nType==SEND_TYPE_END)
            break;
        if(nType==SEND_TYPE_NORMAL)
            bOk = SendNormalFax(pagefrom, pageto);
        else if(nType==SEND_TYPE_BFT)
            bOk = SendBFTFax(pagefrom, pageto);
        else
            break;

        pagefrom = pageto;
    }
}


extern BOOL OK;


void CDlgSendFax::OnOK()
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();

    if ( TestDate() ) {
        int nRadio = GetCheckedRadioButton(IDC_RADIO1, IDC_RADIO2);
        int onepage = nRadio==IDC_RADIO2 ? 1 : 0;
        pApp->WriteProfileInt("Fax", "OnePage", onepage);
    //    int nCheck = IsDlgButtonChecked(IDC_CHECK1);
        int nCheck = 1;
        pApp->WriteProfileInt("Fax", "EnableBFT", nCheck);

        BeginWaitCursor();

        GetDlgItemText( IDC_FAXNUMBER, m_phonenum.GetBuffer(64), 64 );
        GetDlgItemText( IDC_NAME, m_name.GetBuffer(64), 64 );
        m_phonenum.ReleaseBuffer( -1 );
        m_name.ReleaseBuffer( -1 );

        /*lpActDoc = pApp->m_hMainWnd->GetActiveDoc();
        if ( lpActDoc ) {
            if ( RUNTIME_CLASS(IsKindOf(CImgDoc)) && ((CImgDoc*)lpActDoc)->m_bGroup ) {
                m_bGroup = TRUE;
            }
        }*/

        //HDIB old;
        //HBITMAP hOldBmp;
        char oldFileName[256];
        HDIB hDb;

        strcpy(oldFileName,pDoc->szTiffFileName);
        int PointPosition;
#ifdef WIN32
        if(strchr(oldFileName,'.')!=NULL)
        {
                PointPosition=strchr(oldFileName,'.')-oldFileName;
                strcpy(oldFileName+PointPosition,"1.tif");
        }
        else
                strcat(oldFileName,"1.tif");
#else
        strcpy(oldFileName,"temp023.tif");
#endif
        int oldCurrent=pDoc->nCurrent;
        if(pDoc->nImages>1)pDoc->GoPage(0);

        for(int i=1;i<=pDoc->nImages;++i)
        {
               // hOldBmp = ConvertDIBToBitmap(pDoc->m_hDib);
                HBITMAP hBmp = ConvertDIBToBitmap(pDoc->m_hDib);
                HDC hDC1 = CreateDC("DISPLAY",NULL,NULL,NULL);
                HDC hDC = CreateCompatibleDC( hDC1 );
                HGDIOBJ hOld;

                hOld = SelectObject( hDC, hBmp );
                int nLogY = GetDeviceCaps(hDC,LOGPIXELSY);

                SelectObject(hDC,hOld);

                hDb = ConvertBitmapToDIB(hBmp, NULL);

                CopyDibDPIs( hDb, pDoc->m_hDib );
                //pDoc->SetNewDib( hDb );

                DeleteDC( hDC );
                DeleteDC( hDC1 );

                //char error[100];
                SaveDIBInTiffFormat(oldFileName, hDb, TCOMP_LZW, FALSE);
                if(pDoc->nImages>1)pDoc->GoPage(i%pDoc->nImages);
                if(hDb)
                    GlobalFree(hDb);
                if(hBmp)
                    DeleteObject(hBmp);
        }

        if(pDoc->nImages>1)pDoc->GoPage(oldCurrent);
        strcpy(oldFileName,pDoc->szTiffFileName);
#ifdef WIN32
        if(strchr(pDoc->szTiffFileName,'.')!=NULL)
        {
                PointPosition=strchr(pDoc->szTiffFileName,'.')-pDoc->szTiffFileName;
                strcpy(pDoc->szTiffFileName+PointPosition,"1.tif");
        }
        else
                strcat(pDoc->szTiffFileName,"1.tif");

#else
        strcpy(pDoc->szTiffFileName,"temp023.tif");
#endif
         int oldFileFormat=pDoc->m_nFileFormat;
        pDoc->m_nFileFormat=FORMAT_TIFF;
        xSendFax();
        #ifdef WIN32
                DeleteFile(pDoc->szTiffFileName);
        #else
                OFSTRUCT o;
            OpenFile(pDoc->szTiffFileName,&o,OF_DELETE);
        #endif
        strcpy(pDoc->szTiffFileName,oldFileName);
        pDoc->m_nFileFormat=oldFileFormat;
        //      old=ConvertBitmapToDIB(hOldBmp, NULL);
        //      CopyDibDPIs( old, hDb );
        //   pDoc->SetNewDib( old );
        /*
        if(pDoc->IsKindOf(RUNTIME_CLASS(CBlockDoc)))
        {
                        DeleteFile(pDoc->szTiffFileName);
        }

         */
        EndWaitCursor();

        ClosePhoneBook();
        CDialog::OnOK();
    }
}


/////////////////////////////////////////////////////////////////////////////
// CDlgFaxClose dialog

CDlgFaxClose::CDlgFaxClose(CWnd* pParent /*=NULL*/)
    : CDlg(CDlgFaxClose::IDD, pParent)
{
    //{{AFX_DATA_INIT(CDlgFaxClose)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}

void CDlgFaxClose::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CDlgFaxClose)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CDlgFaxClose, CDialog)
    //{{AFX_MSG_MAP(CDlgFaxClose)
	ON_LBN_SELCHANGE(IDC_FAXPORTS, OnSelchangeFaxports)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgFaxClose message handlers

BOOL CDlgFaxClose::OnInitDialog()
{
    CDlg::OnInitDialog();
    CImgApp *pApp = (CImgApp *)AfxGetApp();

    int i ;
    BOOL bOpen = FALSE ;
    for(i=0;i<MAX_FAXPORTS;i++)
    {
        if (pApp->FaxPorts[i])
        {
//            if (pApp->FaxPorts[i]->IsOpen())
//            {
                bOpen = TRUE ;
                break ;
//            }
        }
    }

    if(!bOpen) {        
        EndDialog(FALSE);
        return  FALSE;
    }
    ::LoadFaxNames(this, TRUE);
    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CDlgFaxClose::OnOK()
{	
    CImgApp     *pApp = (CImgApp *)AfxGetApp();
    CListBox    *pPortList = (CListBox *)GetDlgItem(IDC_FAXPORTS);
	ASSERT(pPortList != NULL);

	for (int n=0; n < pPortList->GetCount(); ++n)
	{
		if (pPortList->GetSel(n)) 
		{	
			BeginWaitCursor();
			int         iPort = n;
			if(iPort >= 0) 
			{
				// Close the port.
				if(!DisconnectPort(pApp->FaxPorts[iPort])) 
				{
					pApp->FaxPorts[iPort] = NULL;
					pApp->FaxEventText(iPort, "Port Close");
				}
				else AfxMessageBox("Port close error!");
			}
			EndWaitCursor();
			Sleep(200);
		}				
	}
    CDialog::OnOK();
}
/////////////////////////////////////////////////////////////////////////////
// CDlgAbortFax dialog

CDlgAbortFax::CDlgAbortFax(CWnd* pParent /*=NULL*/)
    : CDlg(CDlgAbortFax::IDD, pParent)
{
    //{{AFX_DATA_INIT(CDlgAbortFax)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}

void CDlgAbortFax::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CDlgAbortFax)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CDlgAbortFax, CDialog)
    //{{AFX_MSG_MAP(CDlgAbortFax)
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgAbortFax message handlers

BOOL CDlgAbortFax::OnInitDialog()
{
    CDlg::OnInitDialog();

    CImgApp *pApp = (CImgApp *)AfxGetApp();
#ifndef WIN32
    if(!pApp->FaxPorts[0] && !pApp->FaxPorts[1] && !pApp->FaxPorts[2] && !pApp->FaxPorts[3]) {
        AfxMessageBox("No port exist for abort");
        EndDialog(FALSE);
        return  FALSE;
    }
#endif
    ::LoadFaxNames(this, FALSE);
    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CDlgAbortFax::OnOK()
{
    CImgApp     *pApp = (CImgApp *)AfxGetApp();
    int         iPort = ::GetPortNumber(this);

    if(iPort >= 0) {
         AbortPort( pApp->FaxPorts[iPort] );
         pApp->FaxEventText( iPort, "Port Abort" );
    }

    CDialog::OnOK();
}


/////////////////////////////////////////////////////////////////////////////
// CFaxEvent dialog


CFaxEvent::CFaxEvent(CWnd* pParent /*=NULL*/)
    : CDlg(CFaxEvent::IDD, pParent)
{
    Create(IDD_FAXEVENT, pParent);

    //{{AFX_DATA_INIT(CFaxEvent)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}

void CFaxEvent::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CFaxEvent)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CFaxEvent, CDlg)
    //{{AFX_MSG_MAP(CFaxEvent)
    ON_BN_CLICKED(IDC_FCLEAR, OnFclear)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


static void MakeStatusText(WORD st, LPSTR buf)
{
    int ii = 0;
    buf[0] = 0;
    if(st==0)
    {
        lstrcpy(buf, "idle");
        return;
    }
    if(st & CST_WORKING)
        ii += wsprintf(&buf[ii], "working  ");
    if(st & CST_ANSWER)
        ii += wsprintf(&buf[ii], "answer  ");
    if(st & CST_RECEIVE)
        ii += wsprintf(&buf[ii], "receive  ");
    if(st & CST_MANUAL)
        ii += wsprintf(&buf[ii], "manual  ");
    if(st & CST_SETUP)
        ii += wsprintf(&buf[ii], "setup  ");
    return;
}

static LPSTR MakeErrorText(int nErrorCode)
{
    switch ( nErrorCode ) {
        case CFR_BUSY:
            return "Remote fax station is busy! (CFR_BUSY)";
        case CFR_NODIALTONE:
            return "No dialtone is detected! (CFR_NODIALTONE)";
        case CFR_NOANSWER:
            return "Remote station doesnt't answer! (CFR_NOANSWER)";
        case CFR_TIMEOUT:
            return "Timeout! (CFR_TIMEOUT)";
        case CFR_ERROR:
            return "Fax card returned an error! (CFR_ERROR)";
        case CFR_DRIVER:
            return "Driver detected an unsupported request! (CFR_DRIVER)";
        case CFR_BADANSWER:
            return "Unrecognize command has received (CFR_BADANSWER)";
        case CFR_BADREMOTEFAX:
            return "Unknown remote fax! (CFR_BADREMOTEFAX)";
        case CFR_SYSTEM:
            return "System call has failed! (CFR_SYSTEM)";
        case CFR_FAXBADDIRECTION:
            return "Collision detected! (CFR_FAXBADDIRECTION)";
        case CFR_COMM:
            return "Communication error! (CFR_COMM)";
        case CFR_BADLINE:
            return "CFR_BADLINE";
        case CFR_COMERROR:
            return "Comm port error! (CFR_COMERROR)";
        case CFR_USERABORT:
            return "User abort! (CFR_USERABORT)";
        case CFR_BAD_RES:
            return "Bad resolution! (CFR_BAD_RES)";
        case CFR_BAD_WIDTH:
            return "Bad page width! (CFR_BAD_WIDTH)" ;
        case CFR_BAD_LENGTH:
            return "Bad page length! (CFR_BAD_LENGTH)";
        case CFR_BAD_COMPRESS:
            return "Bad image compression! (CFR_BAD_COMPRESS)";
        case CFR_BAD_BFT:
            return "Bad BFT data! (CFR_BAD_BFT)";
        case CFR_BAD_ECM:
            return "Bad ECM! (CFR_BAD_ECM)";
        case CFR_HUMANVOICE:
            return "Human Voice detected! (CFR_HUMANVOICE)";
    }
    return "Unrecognized error!";
}


/////////////////////////////////////////////////////////////////////////////
// CFaxEvent message handlers


BOOL CFaxEvent::OnInitDialog()
{
    CDlg::OnInitDialog();

  // TODO: Add extra initialization here

    CListBox *lBox = (CListBox *)GetDlgItem(IDC_EVENTLIST);
    if(lBox)
    {
                lBox->SetHorizontalExtent(600);
        }

    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CFaxEvent::OnOK()
{
    ShowWindow(SW_HIDE);
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    pApp->bShowEvent = FALSE;
//    CDialog::OnOK();
}

void CFaxEvent::SetEventText(int iPort, LPSTR buf)
{
    char buf2[200];
    CListBox *evnt = (CListBox *)GetDlgItem(IDC_EVENTLIST);
    char timebuf[20];
    LPSTR ptime;

    ptime = _strtime(timebuf);

    if ( iPort>=0 && iPort<MAX_FAXPORTS ) {
        CImgApp *App = (CImgApp *)AfxGetApp();
#if defined(WIN32)
        if ( App->nComm[iPort] >= (MAX_COMPORTS+MAX_FAXCHANNELS) )
            wsprintf(buf2, "%s%i %s  %s",G_PORTNAME, App->nComm[iPort]-(MAX_COMPORTS+MAX_FAXCHANNELS), ptime, buf);
        else if ( App->nComm[iPort] >= MAX_COMPORTS )
            wsprintf(buf2, "%s%i %s  %s",B_PORTNAME, App->nComm[iPort]-MAX_COMPORTS, ptime, buf);
        else
#endif
            wsprintf(buf2, "COM%i %s  %s", App->nComm[iPort], ptime, buf);
        evnt->AddString(buf2);
    }
    else {
        wsprintf(buf2, "%s  %s", ptime, buf);
        evnt->AddString(buf2);
    }
    int nn = evnt->GetCount();
    if ( nn>200 ) {
        for(int kk=0; kk<5; kk++)
            evnt->DeleteString(0);
        evnt->SetCurSel(evnt->GetCount()-1);
    }
}

void CFaxEvent::RecFaxMessage(WPARAM wParam , LPARAM lParam)
{
    PORTFAX pFax = NULL;
    char buf[256];
    int nError = 0;

    CImgApp *App = (CImgApp *)AfxGetApp();
    LPSTR cMsg = " ";
    switch(wParam) {
        case MFX_RECEIVED:
            cMsg = "FAX RECEIVED";
            pFax = (PORTFAX)lParam;
            break;
        case MFX_ENDSEND:
            cMsg = "END OF FAX SEND";
            pFax = (PORTFAX)lParam;
            break;
        case MFX_ANSWER:
            cMsg = "ANSWER";
            pFax = (PORTFAX)lParam;
            break;
        case MFX_DIAL:
            cMsg = "DIAL";
            pFax = (PORTFAX)lParam;
            break;
        case MFX_HANGUP:
            cMsg = "HANGUP";
            pFax = (PORTFAX)lParam;
            break;
        case MFX_DONOTSEND:
            cMsg = "BFT did not send!";
            pFax = (PORTFAX)lParam;
            break;
        case MFX_TERMINATE:
            cMsg = "TERMINATE";
            pFax = (PORTFAX)lParam;

            break;

    }
    if(pFax==NULL)
        return;
    int kk = -1;
    for(int jj=0; jj<MAX_FAXPORTS; jj++) {
        if(App->FaxPorts[jj] == pFax) {
            kk = jj;
            break;
        }
    }
    if(wParam == MFX_TERMINATE) {
        static BOOL bShowMessage = FALSE ;
        int nEcm;

        nEcm = App->GetProfileInt( "Fax", "Enable ECM Receive", ECM_ENABLE );
        SetPortCapabilities( pFax, FDC_ECM, nEcm );

#ifdef WIN32
        if ( pFax->ComBoard() == BRD_GAMMALINK ) {
            int status = pFax->GetLastStatus();
            if ( !bShowMessage && status ) {
                char szMessage[256] ;

                bShowMessage = TRUE ;
                wsprintf(szMessage,"GammaLink termination status code: %d", status );
                MessageBox(szMessage,"FAX C++ ",MB_ICONSTOP);
                bShowMessage = FALSE ;
            }
        }
        else {
#endif
            TSSessionParameters CSession ;
            GetSessionParameters(pFax,&CSession);
            wsprintf(buf, "FAXMNG:  %s %d  %s", cMsg, nError, MakeTerminationText(CSession.TStatus) );
            if (!bShowMessage && (CSession.TStatus != TRM_ABORT) && CSession.TStatus != TRM_NORMAL ) {
                char szMessage[256] ;
                bShowMessage = TRUE ;

                wsprintf(szMessage," %s: Terminated\r%s",CSession.PortName, MakeTerminationText(CSession.TStatus));
                MessageBox(szMessage,"FAX C++ ",MB_ICONSTOP);
                bShowMessage = FALSE ;
                                }
                                if(CSession.TStatus==TRM_NOMODEM || CSession.TStatus==TRM_INVALIDCLASS)
                                {
                                        if(kk!=-1)
                                        {
                                                App->FaxPorts[kk]->DisconnectPort();
                                                delete(App->FaxPorts[kk]);
                                                App->FaxPorts[kk]=NULL;
                                        }

#ifdef WIN32
            }
#endif
        }
    } else {
        wsprintf(buf, "FAXMNG:  %s", cMsg);
    }

    SetEventText(kk, buf);
}

void CFaxEvent::OnFclear()
{
    // TODO: Add your control notification handler code here
    CListBox *evnt = (CListBox *)GetDlgItem(IDC_EVENTLIST);
    evnt->ResetContent();

}
/////////////////////////////////////////////////////////////////////////////
// CFaxRec dialog


CFaxRec::CFaxRec(CWnd* pParent /*=NULL*/)
    : CDialog(CFaxRec::IDD, pParent)
{
    //{{AFX_DATA_INIT(CFaxRec)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}

void CFaxRec::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CFaxRec)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CFaxRec, CDialog)
    //{{AFX_MSG_MAP(CFaxRec)
    ON_BN_CLICKED(IDCH_AUTOANSW, OnAutoansw)
    ON_EN_KILLFOCUS(IDEE_RINGS, OnKillfocusRings)
    ON_LBN_SELCHANGE(IDC_FAXPORTS, OnSelchangeFaxports)
    ON_BN_CLICKED(IDC_REC_MANUAL, OnRecManual)
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CFaxRec message handlers

BOOL CFaxRec::OnInitDialog()
{
    TSModemCapabiliti Cap ;

    CDialog::OnInitDialog();
    CImgApp *pApp = (CImgApp *)AfxGetApp();
#ifndef WIN32
    if(!pApp->FaxPorts[0] && !pApp->FaxPorts[1] && !pApp->FaxPorts[2] && !pApp->FaxPorts[3]) {
        AfxMessageBox("No port exist for receiving");
        EndDialog(FALSE);
        return  FALSE;
    }
#endif
    ::LoadFaxNames(this, FALSE);
    int iPort = GetPortNumber(this);
    if ( iPort < 0 )
        return FALSE;
    int nRing = pApp->nRings[iPort];
    SetDlgItemInt(IDEE_RINGS, nRing);
    CheckDlgButton(IDCH_AUTOANSW, nRing ? 1 : 0);
    GetCapabiliti(pApp->FaxPorts[iPort],&Cap) ;
    CheckDlgButton(IDC_RECPOLLING,Cap.ReceivePolling);

    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CFaxRec::OnAutoansw()
{
    int iPort = GetPortNumber(this);
    if(iPort<0)
        return;

    CImgApp *pApp = (CImgApp *)AfxGetApp();
    int nRing;

    UINT flg = IsDlgButtonChecked(IDCH_AUTOANSW);
    if(flg)
        nRing = pApp->nRings[iPort];
    else
        nRing = 0;

    GetDlgItem(IDEE_RINGS)->EnableWindow(flg);
    SetDlgItemInt(IDEE_RINGS, nRing);
    SetAutoAnswer(pApp->FaxPorts[iPort], nRing);

}

void CFaxRec::OnKillfocusRings()
{
    int iPort = GetPortNumber(this);
    if(iPort<0)
        return;

    CImgApp *pApp = (CImgApp *)AfxGetApp();
    int nRing;

    UINT flg = IsDlgButtonChecked(IDCH_AUTOANSW);
    if(flg==0)
        return;

    nRing = GetDlgItemInt(IDEE_RINGS);

    pApp->nRings[iPort] = nRing;
    SetAutoAnswer(pApp->FaxPorts[iPort], nRing);
}

void CFaxRec::OnSelchangeFaxports()
{
    int iPort ;
    TSModemCapabiliti Cap ;
    CImgApp *pApp ;

    pApp = (CImgApp *)AfxGetApp();

    iPort = GetPortNumber(this);
    if(iPort<0)  return;

    GetPortSetting(pApp->FaxPorts[iPort],&Cap) ;
    CheckDlgButton(IDC_RECPOLLING,Cap.ReceivePolling);

    OnAutoansw();
}

void CFaxRec::OnOK()
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();

    int iPort = ::GetPortNumber(this);

    int nRing = GetDlgItemInt(IDEE_RINGS);
    pApp->WriteProfileInt("Fax", "Ring To Answer", nRing);

    if(iPort>=0 && iPort<MAX_FAXPORTS)
        pApp->nRings[iPort] = nRing;

    TSModemCapabiliti Cap ;

    GetPortSetting(pApp->FaxPorts[iPort],&Cap) ;

    if ( IsDlgButtonChecked( IDC_RECPOLLING ) ) {
        Cap.ReceivePolling = TRUE ;
    } else {
        Cap.ReceivePolling = FALSE ;
    }
    SetupPortCapabilities(pApp->FaxPorts[iPort],&Cap);
    CDialog::OnOK();
}

void CFaxRec::OnRecManual()
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    int iPort = GetPortNumber(this);
    if ( iPort < 0 )
        return;

    int hh = ManualAnswer(pApp->FaxPorts[iPort]);
    if(hh)
        AfxMessageBox("Manual answer has failed");
    else
        pApp->FaxEventText(iPort, "Manual answer has started");

    CDialog::OnOK();
}
/////////////////////////////////////////////////////////////////////////////
// CFaxConfig dialog


CFaxConfig::CFaxConfig(CWnd* pParent /*=NULL*/)
    : CDlg(CFaxConfig::IDD, pParent)
{
    //{{AFX_DATA_INIT(CFaxConfig)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}

void CFaxConfig::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CFaxConfig)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CFaxConfig, CDlg)
    //{{AFX_MSG_MAP(CFaxConfig)
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CFaxConfig message handlers

BOOL CFaxConfig::OnInitDialog()
{
    CDlg::OnInitDialog();
    int act_mode, act_volume;
    CImgApp *pApp = (CImgApp *)AfxGetApp();

    switch(pApp->SpeakerMode) {
        case STO_NEVER:
                act_mode = IDC_STO_OFF;
                break;
        case STO_ALWAYS:
                act_mode = IDC_STO_ON;
                break;
        default:
                act_mode = IDC_STO_DIAL;
                break;
    }

    switch(pApp->SpeakerVolume) {
        case SPV_HIGHEST:
        case SPV_HIGH:
                act_volume = IDC_SPV_HIGH;
                break;
        case SPV_MEDIUM:
                act_volume = IDC_SPV_MEDIUM;
                break;
        default:
                act_volume = IDC_SPV_LOW;
                break;
    }

    TERuningMode rmode = GetRuningMode();
    int nRadio;

    switch(rmode)
    {
        case RNM_ALWAYSFREE:
            nRadio = IDC_RADIO1;
            break;
        case RNM_HALTINFRAME:
        default:
            nRadio = IDC_RADIO2;
            break;
        case RNM_HALTINFAX:
        case RNM_ALWAYSHALT:
            nRadio = IDC_RADIO3;
            break;
    }

    CheckRadioButton(IDC_STO_OFF, IDC_STO_DIAL, act_mode);
    CheckRadioButton(IDC_SPV_LOW, IDC_SPV_HIGH, act_volume);
    CheckRadioButton(IDC_RADIO1, IDC_RADIO3, nRadio);

    int nBaud = pApp->GetProfileInt("Fax", "MAXBAUD", 4);
    if(nBaud<=0 || nBaud>=BDR_END)
        nBaud = BDR_14400;
    CheckRadioButton(IDC_B2400, IDC_B33600, IDC_B2400+nBaud-1);

    nBaud = pApp->GetProfileInt("Fax", "Enable ECM Send", ECM_ENABLE );
    if(nBaud <= 0 || nBaud > ECM_ENABLE) nBaud = ECM_DISABLE;
    CheckDlgButton(IDC_ENABLEECMS, nBaud == ECM_ENABLE);

    nBaud = pApp->GetProfileInt("Fax", "Enable ECM Receive", ECM_ENABLE );
    if(nBaud <= 0 || nBaud > ECM_ENABLE) nBaud = ECM_DISABLE;
    CheckDlgButton(IDC_ENABLEECMR, nBaud == ECM_ENABLE);

    nBaud = pApp->GetProfileInt("Fax", "Enable BFT", BFT_DISABLE);
    if(nBaud <= 0 || nBaud > BFT_ENABLE) nBaud = BFT_DISABLE;
    CheckDlgButton(IDC_ENABLEBFT, nBaud == BFT_ENABLE);

    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CFaxConfig::OnOK()
{
    int act_mode = GetCheckedRadioButton(IDC_STO_OFF, IDC_STO_DIAL);
    int act_volume = GetCheckedRadioButton(IDC_SPV_LOW, IDC_SPV_HIGH);
    int act_runmode = GetCheckedRadioButton(IDC_RADIO1, IDC_RADIO3);

    CImgApp *pApp = (CImgApp *)AfxGetApp();
    BOOL ok = TRUE;

    switch(act_mode) {
        case IDC_STO_OFF:
            pApp->SpeakerMode = STO_NEVER;
            break;
        case IDC_STO_ON:
            pApp->SpeakerMode = STO_ALWAYS;
            break;
        case IDC_STO_DIAL:
            pApp->SpeakerMode = STO_DIAL;
            break;
        default:
            ok = FALSE;
            break;
    }

    switch(act_volume) {
        case IDC_SPV_LOW:
            pApp->SpeakerVolume = SPV_LOWEST;
            break;
        case IDC_SPV_MEDIUM:
            pApp->SpeakerVolume = SPV_MEDIUM;
            break;
        case IDC_SPV_HIGH:
            pApp->SpeakerVolume = SPV_HIGH;
            break;
        default:
            ok = FALSE;
            break;
    }

    int nBaudCtrl = GetCheckedRadioButton(IDC_B2400, IDC_B33600);
	char rr[20];
	sprintf(rr,"%d",nBaudCtrl);

    if(nBaudCtrl==0)
        nBaudCtrl = IDC_B14400;
    int nBaud = nBaudCtrl - IDC_B2400 + 1;
    pApp->WriteProfileInt("Fax",  "MAXBAUD", nBaud);

    int eEcm= IsDlgButtonChecked(IDC_ENABLEECMS);
    if (eEcm) eEcm= ECM_ENABLE;
    else eEcm= ECM_DISABLE;
    pApp->WriteProfileInt("Fax", "Enable ECM Send", eEcm);

    eEcm= IsDlgButtonChecked(IDC_ENABLEECMR);
    if (eEcm) eEcm= ECM_ENABLE;
    else eEcm= ECM_DISABLE;
    pApp->WriteProfileInt("Fax", "Enable ECM Receive", eEcm);

    int eBft= IsDlgButtonChecked(IDC_ENABLEBFT);
    if (eBft) eBft= BFT_ENABLE;
    else eBft= BFT_DISABLE;
    pApp->WriteProfileInt("Fax",  "Enable BFT", eBft);

    if ( ok ) {
        for(int jj=0; jj<MAX_FAXPORTS; jj++) {
            if ( pApp->FaxPorts[jj] ) {
                SetSpeaker(pApp->FaxPorts[jj], pApp->SpeakerMode, pApp->SpeakerVolume);
                SetPortCapabilities(pApp->FaxPorts[jj], FDC_BAUD_SEND, nBaud);
                SetPortCapabilities(pApp->FaxPorts[jj], FDC_BAUD_REC,  nBaud);

                SetPortCapabilities(pApp->FaxPorts[jj], FDC_ECM, eEcm);
                SetPortCapabilities(pApp->FaxPorts[jj], FDC_BINARY, eBft);
            }
        }
    }

    TERuningMode rmode;
    switch(act_runmode) {
        case IDC_RADIO1:
            rmode = RNM_ALWAYSFREE;
            break;
        case IDC_RADIO2:
        default:
            rmode = RNM_HALTINFRAME;
            break;
        case IDC_RADIO3:
            rmode = RNM_HALTINFAX;
            break;
    }
    SetRuningMode(rmode);

    CDialog::OnOK();
}

void CDlgFaxPortSetup::OnTestmodem()
{
    // TODO: Add your control notification handler code here

    TSTestResult ts;
    memset(&ts, 0, sizeof(ts));
    char buf[200];
    CString OutString ;

    SetCapture() ;

    CListBox *cPortList =(CListBox *)GetDlgItem(IDC_PORTLIST);
    char szPortName[10];
    memset(szPortName, 0, sizeof(szPortName));
    cPortList->GetText(cPortList->GetCurSel(), szPortName);
    BeginWaitCursor();
    int iError = FaxModemTest((LPSTR)szPortName, &ts);
    EndWaitCursor();
	
    if(iError==0)
    {
        LPSTR lpToken ;
        memset(buf,0,sizeof(buf));
        lstrcpy(buf,ts.ClassType);
        OutString =  "" ;
        for(lpToken = strtok(buf,",") ; lpToken ; lpToken = strtok(NULL,",")  ) {
            if (strcmp(lpToken,"0") == 0){
                if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
                OutString = OutString + "Data" ;
                continue ;
            }
		
            if (strcmp(lpToken,"1.0") == 0){
                if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
                OutString = OutString + "FAX Class 1.0" ;
                continue ;
            }
            if (strcmp(lpToken,"1") == 0){
                if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
                OutString = OutString + "FAX Class 1" ;
                continue ;
            }

            if (strcmp(lpToken,"2.0") == 0){
                if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
                OutString = OutString + "FAX Class 2.0" ;
                continue ;
            }
			if (strcmp(lpToken,"2.1") == 0){
                if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
                OutString = OutString + "FAX Class 2.1" ;
                continue ;
            }

            if (strcmp(lpToken,"2") == 0){
                if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
                OutString = OutString + "FAX Class 2" ;
                continue ;
            }

            if (strcmp(lpToken,"80") == 0){
                if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
                OutString = OutString + "Class 80" ;
                continue ;
            }

            if (strcmp(lpToken,"8") == 0){
                if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
                OutString = OutString + "Class 8" ;
                continue ;
            }

			if (strlen(lpToken)>0)
				if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
					OutString = OutString + "Class " + lpToken;
 
        }

        if (OutString.GetLength() > 0) {
            SetDlgItemText(IDC_TEST1,  OutString);
        } else {
            SetDlgItemText(IDC_TEST1,  ts.ClassType);
        }

        SetDlgItemText(IDC_TEST2, ts.Manufact);
        SetDlgItemText(IDC_TEST3,  ts.Model);
    }
    else
    {
        wsprintf(buf, "No modem on %s", (LPSTR)szPortName);
        SetDlgItemText(IDC_TEST1, buf);
        SetDlgItemText(IDC_TEST2, "");
        SetDlgItemText(IDC_TEST3, "");
    }
    ReleaseCapture();
}


/////////////////////////////////////////////////////////////////////////////
// CEnablePort dialog


CEnablePort::CEnablePort(CWnd* pParent /*=NULL*/)
    : CDlg(CEnablePort::IDD, pParent)
{
    //{{AFX_DATA_INIT(CEnablePort)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}

void CEnablePort::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CEnablePort)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CEnablePort, CDialog)
    //{{AFX_MSG_MAP(CEnablePort)
    ON_BN_CLICKED(IDC_ENABLEPORT, OnDisable)
    ON_LBN_SELCHANGE(IDC_FAXPORTS, OnSelchangeFaxports)
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CEnablePort message handlers

BOOL CEnablePort::OnInitDialog()
{
    CDlg::OnInitDialog();
    CImgApp *pApp = (CImgApp *)AfxGetApp();

    if ( !pApp->FaxPorts[0] && !pApp->FaxPorts[1] && !pApp->FaxPorts[2] && !pApp->FaxPorts[3]) {
        AfxMessageBox("No port exist for sending");
        EndDialog(FALSE);
        return  FALSE;
    }
    ::LoadFaxNames(this, FALSE);
    OnSelchangeFaxports();

    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CEnablePort::OnDisable()
{
    BOOL Enable= !IsDlgButtonChecked(IDC_ENABLEPORT);

    CImgApp     *pApp = (CImgApp *)AfxGetApp();
    int         iPort = ::GetPortNumber(this);
    if(iPort >= 0) {
        if (EnableFaxPort(pApp->FaxPorts[iPort], Enable) < 0) {
            AfxMessageBox("Enable Port Error!");
        }
    }
    Enable= IsFaxPortEnabled(pApp->FaxPorts[iPort]);
    CheckDlgButton (IDC_ENABLEPORT, Enable);
}

void CEnablePort::OnSelchangeFaxports()
{
    CImgApp     *pApp = (CImgApp *)AfxGetApp();
    int         iPort = ::GetPortNumber(this);
    if(iPort >= 0) {
        BOOL Enable= IsFaxPortEnabled(pApp->FaxPorts[iPort]);
        CheckDlgButton (IDC_ENABLEPORT, Enable);
    }

}

/////////////////////////////////////////////////////////////////////////////
// CPortSet dialog


CPortSet::CPortSet(CWnd* pParent /*=NULL*/)
    : CDialog(CPortSet::IDD, pParent)
{
    //{{AFX_DATA_INIT(CPortSet)
    m_szTime = "";
    m_szComm = "";
    //}}AFX_DATA_INIT
}

void CPortSet::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CPortSet)
    DDX_Control(pDX, IDC_COMBO1, m_NameList);
    DDX_Text(pDX, IDC_TIME, m_szTime);
    DDV_MaxChars(pDX, m_szTime, 64);
    DDX_Text(pDX, IDC_COMMAND, m_szComm);
    DDV_MaxChars(pDX, m_szComm, 64);
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPortSet, CDialog)
    //{{AFX_MSG_MAP(CPortSet)
    ON_LBN_SELCHANGE(IDC_COMBO1, OnSelChangeCombo1)
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPortSet message handlers
BOOL CPortSet::OnInitDialog()
{
    CDialog::OnInitDialog();

    m_wArrSize = 10;
    m_NameList.AddString( "String 1" );

    m_NameList.AddString( "String 2" );
    m_NameList.AddString( "String 3" );
    m_NameList.AddString( "String 4" );
    m_NameList.AddString( "String 5" );
    m_NameList.AddString( "String 6" );
    m_NameList.AddString( "String 7" );
    m_NameList.AddString( "String 8" );
    m_NameList.AddString( "String 9" );
    m_NameList.AddString( "String 10" );
    m_NameList.SetCurSel(0);

    m_CommArr.Add( CString("Command 1") );
    m_CommArr.Add( CString("Command 2") );
    m_CommArr.Add( CString("Command 3") );
    m_CommArr.Add( CString("Command 4") );
    m_CommArr.Add( CString("Command 5") );
    m_CommArr.Add( CString("Command 6") );
    m_CommArr.Add( CString("Command 7") );
    m_CommArr.Add( CString("Command 8") );
    m_CommArr.Add( CString("Command 9") );
    m_CommArr.Add( CString("Command 10") );

    m_TimeArr.Add( CString("Time 1") );
    m_TimeArr.Add( CString("Time 2") );
    m_TimeArr.Add( CString("Time 3") );
    m_TimeArr.Add( CString("Time 4") );
    m_TimeArr.Add( CString("Time 5") );
    m_TimeArr.Add( CString("Time 6") );
    m_TimeArr.Add( CString("Time 7") );
    m_TimeArr.Add( CString("Time 8") );
    m_TimeArr.Add( CString("Time 9") );
    m_TimeArr.Add( CString("Time 10") );
    m_szComm = m_CommArr[0];
    m_szTime = m_TimeArr[0];
    SetDlgItemText( IDC_TIME, m_szTime );
    SetDlgItemText( IDC_COMMAND, m_szComm );
    m_actual = 0;
    return TRUE;
}

void CPortSet::OnSelChangeCombo1()
{
    CImgApp     *pApp = (CImgApp *)AfxGetApp();
    int         sel = m_NameList.GetCurSel();

    GetDlgItemText( IDC_TIME, m_szTime.GetBuffer(64), 64 );
    GetDlgItemText( IDC_COMMAND, m_szComm.GetBuffer(64), 64 );
    m_szComm.ReleaseBuffer(-1);
    m_szTime.ReleaseBuffer(-1);
    m_CommArr.SetAt( m_actual, m_szComm );
    m_TimeArr.SetAt( m_actual, m_szTime );
    if ( sel != CB_ERR ) {
        m_szComm = m_CommArr[sel];
        m_szTime = m_TimeArr[sel];
        m_actual = sel;
        SetDlgItemText( IDC_TIME, m_szTime );
        SetDlgItemText( IDC_COMMAND, m_szComm );
    }
}
/////////////////////////////////////////////////////////////////////////////
// CPortSelect dialog


CPortSelect::CPortSelect(CWnd* pParent /*=NULL*/)
    : CDialog(CPortSelect::IDD, pParent)
{
    //{{AFX_DATA_INIT(CPortSelect)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}

void CPortSelect::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CPortSelect)
    DDX_Control(pDX, IDC_PORTLIST, m_PortList);
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPortSelect, CDialog)
    //{{AFX_MSG_MAP(CPortSelect)
        // NOTE: the ClassWizard will add message map macros here
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CPortSelect message handlers
BOOL CPortSelect::OnInitDialog()
{
    CDialog::OnInitDialog();
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    TSPortStatus sPortStatus;

    for ( int i = 0; i < MAX_FAXPORTS; i++) {
        if ( pApp->FaxPorts[i] ) {
            if ( pApp->FaxPorts[i]->IsOpen() ) {
                GetPortStatus(pApp->FaxPorts[i], &sPortStatus);
                m_PortList.SetItemData( m_PortList.AddString(sPortStatus.PortName), (DWORD)(i) );
            }
        }
    }
    return TRUE;
}

void CPortSelect::OnOK()
{
    m_wPort = (WORD)m_PortList.GetItemData( m_PortList.GetCurSel() );
    CDialog::OnOK();
}
/////////////////////////////////////////////////////////////////////////////
// CPolling dialog


CPolling::CPolling(CWnd* pParent /*=NULL*/)
    : CDialog(CPolling::IDD, pParent)
{
    //{{AFX_DATA_INIT(CPolling)
    m_name = "";
    m_phonenum = "";
    //}}AFX_DATA_INIT
}

void CPolling::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CPolling)
    DDX_Text(pDX, IDC_NAME, m_name);
    DDV_MaxChars(pDX, m_name, 64);
    DDX_Text(pDX, IDC_FAXNUMBER, m_phonenum);
    DDV_MaxChars(pDX, m_phonenum, 64);
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPolling, CDialog)
    //{{AFX_MSG_MAP(CPolling)
    ON_LBN_SELCHANGE(IDC_LIST1, OnSelchangeList1)
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CPolling message handlers

BOOL CPolling::OnInitDialog()
{
    CDialog::OnInitDialog();
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    static char pbook_fname[_MAX_PATH] = "CF";
#ifndef WIN32
    if(!pApp->FaxPorts[0] && !pApp->FaxPorts[1] && !pApp->FaxPorts[2] && !pApp->FaxPorts[3]) {
        AfxMessageBox("No port exist for sending");
        EndDialog(FALSE);
        return  FALSE;
    }
#endif
    ::LoadFaxNames(this, FALSE);

    SetPhbookFileName(pbook_fname);         /* from PHBDLG.CPP */

    m_hDB = PB_OpenPhoneBook(pbook_fname, &m_err);

    FillPhoneBook();

    CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
    if ( lst1 ) {
        int nn = lst1->GetCount();
        if ( nn > 0 ) {
            lst1->SetCurSel(0);
            OnSelchangeList1();
        }
    }
    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CPolling::OnCancel()
{
    ClosePhoneBook();
    CDialog::OnCancel();
}

BOOL CPolling::TestPhoneNumber()
{
    char lpPhone[70];
    lpPhone[0] = 0;
    GetDlgItemText(IDC_FAXNUMBER, lpPhone, sizeof(lpPhone));
    int ii = _fstrspn(lpPhone, "0123456789-() ,#");
    int ln = lstrlen(lpPhone);
    BOOL bOK = (ii>=ln && ln) ? TRUE : FALSE;
    return bOK;
}

void CPolling::OnSelchangeList1()
{
    CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
    if(lst1==NULL || m_hDB==NULL)
        return;

    int index = lst1->GetCurSel();
    if(index<0)
        return;

    PB_ITEMHANDLE hItem = (PB_ITEMHANDLE)lst1->GetItemData(index);

    PB_ITEMREC data;
    _fmemset(&data, 0, sizeof(data) );
    m_err = PB_GetItem(m_hDB, hItem, &data);
    if(m_err)
        return;

    SetDlgItemText(IDC_NAME, data.szName);
    SetDlgItemText(IDC_FAXNUMBER, data.szPhoneNum);
}

void CPolling::FillPhoneBook(void)
{
    CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
    if(lst1==NULL)
        return;

    lst1->ResetContent();
    if(m_hDB)
    {
        m_err = PB_EnumItemsInDB(m_hDB, DOWN, 0l, FillPerson, this);
    }
}

/*  static member function   Fill the person list box */
BOOL _export FAR PASCAL CPolling::FillPerson(PB_ITEMHANDLE hItem, LPVOID lpPar)
{
    PB_ERRORS  err;
    PB_ITEMREC data;
    CPolling FAR *cb = (CPolling FAR *)lpPar;    /* this pointer */

    if ( hItem==NULL )
        return TRUE;

    err = PB_GetItem( cb->m_hDB, hItem, &data);
    if ( err )
        return FALSE;

    cb->AddPersonList(&data, hItem);
    return TRUE;
}

int CPolling::AddPersonList(PB_LPITEMREC data, PB_ITEMHANDLE hItem)
{
    int index;
    CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
    if(lst1==NULL)
        return -1;

    index = lst1->AddString(data->szName);

    if(index>=0) {
        lst1->SetItemData(index, hItem);
    }

    return index;
}

void CPolling::ClosePhoneBook()
{
    if ( m_hDB ) {
        PB_ClosePhoneBook(m_hDB);
        m_hDB = NULL;
    }
}

#define SEND_TYPE_END      -1
#define SEND_TYPE_NORMAL    0
#define SEND_TYPE_BFT       1

BOOL CPolling::SendNormalFax()
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    TSFaxParam  sFaxParam;
    char    buf[256];

    sFaxParam.PageNum     = 0;
    sFaxParam.Resolut     = RES_NOCHANGE;
    sFaxParam.Width       = PWD_1728;
    sFaxParam.Length      = PLN_NOCHANGE;
    sFaxParam.Compress    = DCF_1DMH;
    sFaxParam.Binary      = BFT_NOCHANGE;
    sFaxParam.BitOrder    = BTO_FIRST_LSB;
    GetDlgItemText( IDC_FAXNUMBER, &sFaxParam.RemoteNumber[0], sizeof(sFaxParam.RemoteNumber));
    pApp->WriteProfileString("Fax", "Fax Number", sFaxParam.RemoteNumber);
    sFaxParam.Send = FALSE ;

    FAXOBJ faxobj = CreateSendFax('N', &sFaxParam);
    if ( !faxobj ) {
        AfxMessageBox("CreateSendFax failed");
        pApp->FaxEventText(iPort, "CreateSendFax failed");
        return FALSE;
    }
    int iError = SendFaxNow(m_faxport, faxobj, FALSE);
    if ( iError==0 )
        pApp->FaxEventText(iPort, "Fax has been sent to port");
    if ( iError ) {
        wsprintf(buf, "Send Fax error:%i %s", iError, MakeFERText(iError));
        AfxMessageBox(buf);
        pApp->FaxEventText(iPort, buf);
    }
    return (iError) ? FALSE : TRUE;
}

void CPolling::xSendFax()
{
    CImgApp     *pApp = (CImgApp *)AfxGetApp();
    int         nBaud = pApp->GetProfileInt("Fax", "MAXBAUD", 4);
    int         bNext = 0,
                LastType = 0, nType = 0;

    iPort = ::GetPortNumber(this);
    if ( iPort < 0  ||  iPort >=MAX_FAXPORTS )
        return;
    m_faxport = pApp->FaxPorts[iPort];
    if ( !m_faxport)
        return;
    if ( nBaud<=0 || nBaud>=BDR_END )
        nBaud = BDR_14400;
    SetPortCapabilities( m_faxport, FDC_BAUD_SEND, nBaud );
    SetPortCapabilities( m_faxport, FDC_BAUD_REC,  nBaud );
    CString cId = pApp->GetProfileString("Fax", "Identification String", NULL);
    SetStationID( m_faxport, cId.GetBuffer( cId.GetLength()+1 ) );
    SendNormalFax();
}

void CPolling::OnOK()
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();

    BeginWaitCursor();

    GetDlgItemText( IDC_FAXNUMBER, m_phonenum.GetBuffer(64), 64 );
    GetDlgItemText( IDC_NAME, m_name.GetBuffer(64), 64 );
    m_phonenum.ReleaseBuffer( -1 );
    m_name.ReleaseBuffer( -1 );
    xSendFax();

    EndWaitCursor();

    ClosePhoneBook();
    CDialog::OnOK();
}

#if defined(WIN32)
/////////////////////////////////////////////////////////////////////////////
// CBOpen dialog

CBOpen::CBOpen(CWnd* pParent /*=NULL*/)
    : CDialog(CBOpen::IDD, pParent)
{
    //{{AFX_DATA_INIT(CBOpen)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}


void CBOpen::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CBOpen)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CBOpen, CDialog)
    //{{AFX_MSG_MAP(CBOpen)
    ON_BN_CLICKED(IDC_TEST, OnTest)
    ON_LBN_SELCHANGE(IDC_CHANNELS, OnSelchangeChannels)
	ON_BN_CLICKED(IDC_BROWSE, OnBrowse)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CBOpen message handlers
BOOL CBOpen::OnInitDialog()
{
    int     nCh;
    CImgApp *pApp = (CImgApp *)AfxGetApp();

    CDialog::OnInitDialog();
    // checking for brooktrout channels
    for( nCh=0 ; nCh < MAX_FAXCHANNELS && pApp->BrooktroutChannels[nCh] ; nCh++ ) {
        if ( pApp->BrooktroutChannels[nCh] == 1 || // fax or tr114 channel
                        pApp->BrooktroutChannels[nCh] >= 3 ) {
            char szCom[20];

            if ( B_IsChannelFree( nCh ) ) {
                strcpy( szCom, B_PORTNAME );
                strcat( szCom, " " );
                _itoa( nCh, &szCom[ strlen(B_PORTNAME) ], 10 );
                //szCom[ strlen(B_PORTNAME) ] = (char)nCh+'0';
                ((CListBox *)GetDlgItem(IDC_CHANNELS))->AddString(szCom);
            }
        }
    }
    CString szTmp;
	char szTmp2[200];
	GetPrivateProfileString("Brooktrout","Config file","btcall.cfg",szTmp2,200,"Demo32.INI");

    SetDlgItemText( IDC_CFILE, szTmp2 );
    // No, of ring before pick the phone up.
    int nRing = pApp->GetProfileInt( "Brooktrout", "Header Type", 1 );
    if ( nRing == 1 )
        CheckRadioButton( IDC_HEADER, IDC_FOOTER, IDC_HEADER );
    else
        CheckRadioButton( IDC_HEADER, IDC_FOOTER, IDC_FOOTER );
    szTmp = pApp->GetProfileString( "Brooktrout", "Header", "" );
    SetDlgItemText(IDC_HDRSTRING, szTmp );

    // Identification number. (own fax number)
    CString cId = pApp->GetProfileString("Fax", "Identification String", NULL);
    SetDlgItemText(IDC_IDSTRING, cId);

	SendDlgItemMessage( IDC_CFILE, EM_LIMITTEXT, (WPARAM)255, 0L );
    SendDlgItemMessage( IDC_HDRSTRING, EM_LIMITTEXT, (WPARAM)60, 0L );
	SendDlgItemMessage( IDC_IDSTRING, EM_LIMITTEXT, (WPARAM)60, 0L );
    return TRUE;  // return TRUE unless you set the focus to a control
}

void CBOpen::OnTest()
{	
	CListBox* cPortList =(CListBox *)GetDlgItem(IDC_CHANNELS);
	ASSERT(cPortList != NULL);
	TSTestResult ts; 	
	char szPortName[10];

	memset(&ts, 0, sizeof(ts));				
	memset( szPortName, 0, sizeof(szPortName) );

	for (int n=0; n < cPortList->GetCount(); ++n)
	{		
		if (cPortList->GetSel(n)) 
		{			
			cPortList->GetText( n, szPortName );
			BeginWaitCursor();
			int iError = TestBrooktrout( (LPSTR)szPortName, &ts );
			EndWaitCursor();
			SetDlgItemText( IDC_TYPE, ts.Model );
		}		
	}
}

void CBOpen::OnOK()
{
    CListBox  *cPortList ;
    CEdit     *cEdit;
    char      szPortName[10], szCFile[MAX_PATH], szHeader[MAX_PATH];
    CImgApp   *pApp = (CImgApp *)AfxGetApp();
    int       nBaud, nEcm, nBft, sel, nRings ;
    TSSessionParameters CSession;
    char      szStationID[21] ;

    cPortList =(CListBox *)GetDlgItem( IDC_CHANNELS );

	cEdit =(CEdit *)GetDlgItem( IDC_CFILE );
	memset( szCFile, 0, sizeof(szCFile) );
	cEdit->GetLine( 0, szCFile, sizeof(szCFile) );

	if (!strlen(szCFile))
	{
		AfxMessageBox("You have to specify the path and name of the configuration file.", MB_ICONERROR);
		cEdit->SetFocus();
		return;
	}

	WritePrivateProfileString("Brooktrout","Config file",szCFile,"Demo32.ini");
	
	// Get ID string and no. of ring to answer.
	GetDlgItemText(IDC_IDSTRING, szStationID, sizeof(szStationID));
	pApp->WriteProfileString("Fax", "Identification String", szStationID);
	SetMyID(szStationID);

	BeginWaitCursor();

	for (int n=0; n < cPortList->GetCount(); ++n)
	{
		if (cPortList->GetSel(n)) 
		{	
			sel = n;
			if ( sel != LB_ERR ) {
				cPortList->GetText( sel, szPortName );
				cEdit =(CEdit *)GetDlgItem( IDC_HDRSTRING );
				memset( szHeader, 0, sizeof(szHeader) );
				cEdit->GetLine( 0, szHeader, sizeof(szHeader) );
				pApp->WriteProfileString( "Brooktrout", "Header", szHeader );

				// Find and empty faxport.
				for ( int i = 0 ; i < MAX_FAXPORTS ; i++ ) 
				{
					if ( !pApp->FaxPorts[i] ) 
					{
						pApp->FaxPorts[i] = ConnectPortExt(szPortName, NULL,szCFile);

						if ( !pApp->FaxPorts[i] ) {
							AfxMessageBox("Unable to connect port!");
							return;
						} 
						else 
						{
							pApp->nComm[i] = atoi( &szPortName[strlen(B_PORTNAME)] ) + MAX_COMPORTS;
							pApp->FaxEventText(i, "Port Open");
							SetRuningMode(pApp->RunMode);
							GetSessionParameters( pApp->FaxPorts[i], &CSession );
							pApp->nRings[i] = CSession.RingToAnswer;
							nRings = GetCheckedRadioButton( IDC_HEADER, IDC_FOOTER );
							pApp->FaxPorts[i]->SetHeaderType( nRings==IDC_HEADER );
							CString cHdr = pApp->GetProfileString( "Brooktrout", "Header", NULL );
							SetHeader( pApp->FaxPorts[i], cHdr.GetBuffer(250) );

							nBaud = pApp->GetProfileInt("Fax", "MAXBAUD", 4);
							nEcm = pApp->GetProfileInt("Fax", "Enable ECM Receive", ECM_ENABLE );
							nBft = pApp->GetProfileInt("Fax", "Enable BFT", BFT_DISABLE );
							if ( nBaud<=0 || nBaud>=BDR_END )
								nBaud = BDR_14400;
							SetPortCapabilities(pApp->FaxPorts[i], FDC_BAUD_SEND, nBaud);
							SetPortCapabilities(pApp->FaxPorts[i], FDC_BAUD_REC,  nBaud);
							SetPortCapabilities(pApp->FaxPorts[i], FDC_ECM, nEcm);
							SetPortCapabilities(pApp->FaxPorts[i], FDC_BINARY, nBft);
							SetPortCapabilities(pApp->FaxPorts[i], FDC_GET_DTMF, TRUE );
					
							CString cId = pApp->GetProfileString("Fax", "Identification String", NULL);
							SetStationID( pApp->FaxPorts[i], cId.GetBuffer( cId.GetLength()+1 ) );
						}
						break;
					}
				}				
			}
			Sleep(100);			
		}		
	}

	EndWaitCursor();

	CDialog::OnOK();
}

void CBOpen::OnSelchangeChannels()
{
    SetDlgItemText( IDC_TYPE, "" );
}


/////////////////////////////////////////////////////////////////////////////
// CDlgGOpen dialog


CDlgGOpen::CDlgGOpen(CWnd* pParent /*=NULL*/)
    : CDialog(CDlgGOpen::IDD, pParent)
{
    //{{AFX_DATA_INIT(CDlgGOpen)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}

void CDlgGOpen::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CDlgGOpen)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDlgGOpen, CDialog)
    //{{AFX_MSG_MAP(CDlgGOpen)
    ON_BN_CLICKED(IDC_TEST, OnTest)
    ON_EN_CHANGE(IDC_CONFIG, OnChangeConfig)
    ON_LBN_SELCHANGE(IDC_CHANNELS, OnSelchangeChannels)
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CDlgGOpen message handlers

BOOL CDlgGOpen::OnInitDialog()
{
    int     nCh;
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    CListBox *pLB;

    CDialog::OnInitDialog();

    pLB = (CListBox *)GetDlgItem(IDC_CHANNELS);
    for ( nCh=0 ; (nCh < MAX_GAMMACHANNELS) ; nCh++ ) {
        char szCom[20];

        if ( G_IsChannelFree( nCh ) ) {
            strcpy( szCom, G_PORTNAME );
            strcat( szCom, " " );
            _itoa( nCh, &szCom[ strlen(G_PORTNAME) ], 10 );
            pLB->AddString(szCom);
        }
    }

    if ( G_NeedConfig() ) {
        CString szTmp = pApp->GetProfileString( "GammaLink", "Config file", "" );
        SetDlgItemText( IDC_CONFIG, szTmp );
    }
    else
        GetDlgItem(IDC_CONFIG)->EnableWindow( FALSE );

    // Identification number. (own fax number)
    CString cId = pApp->GetProfileString("Fax", "Identification String", NULL);
    SetDlgItemText(IDC_IDSTRING, cId);
	((CEdit*)GetDlgItem(IDC_IDSTRING))->LimitText(60);


    pLB->SetCurSel(0);
    return TRUE;  // return TRUE unless you set the focus to a control
                  // EXCEPTION: OCX Property Pages should return FALSE
}

void CDlgGOpen::OnOK()
{
    CListBox  *cPortList ;
    CEdit     *cEdit;
    char      szPortName[10], szCFile[256];
    CImgApp   *pApp = (CImgApp *)AfxGetApp();
    int       sel, nRings ;
    TSSessionParameters CSession;
    char      szStationID[21] ;

    // Get ID string and no. of ring to answer.
    GetDlgItemText(IDC_IDSTRING, szStationID, sizeof(szStationID));
    pApp->WriteProfileString("Fax", "Identification String", szStationID);
    SetMyID(szStationID);


    cPortList =(CListBox *)GetDlgItem( IDC_CHANNELS );
    sel = cPortList->GetCurSel();
    if ( sel != LB_ERR ) {
        cPortList->GetText( sel, szPortName );

        cEdit =(CEdit *)GetDlgItem( IDC_CONFIG );
        memset( szCFile, 0, sizeof(szCFile) );
        cEdit->GetLine( 0, szCFile, sizeof(szCFile) );
        pApp->WriteProfileString( "GammaLink", "Config file", szCFile );

        for ( int i = 0 ; i < MAX_FAXPORTS ; i++ ) {
            if ( !pApp->FaxPorts[i] ) {
                pApp->FaxPorts[i] = ConnectChannel(szPortName, szCFile, BRD_GAMMALINK );

                if ( !pApp->FaxPorts[i] ) {
                    AfxMessageBox("Unable to connect channel!");
                    return;
                } else {
                    pApp->nComm[i] = atoi( &szPortName[strlen(G_PORTNAME)] ) + MAX_COMPORTS+MAX_FAXCHANNELS;
                    pApp->FaxEventText(i, "Port Open");
                    SetRuningMode(pApp->RunMode);
                    GetSessionParameters( pApp->FaxPorts[i], &CSession );
                    pApp->nRings[i] = CSession.RingToAnswer;

                    nRings = GetCheckedRadioButton( IDC_HEADER, IDC_HEADER );
                    G_SetHeader( pApp->FaxPorts[i], nRings );

                    CString cId = pApp->GetProfileString("Fax", "Identification String", NULL);
                    SetStationID( pApp->FaxPorts[i], cId.GetBuffer( cId.GetLength()+1 ) );
                }
                break;
            }
        }
    }
    CDialog::OnOK();
}

void CDlgGOpen::OnTest()
{
    CEdit     *cEdit;
    char      szCFile[256];
    TSTestResult ts;
    int i;

    memset(&ts, 0, sizeof(ts));
    CListBox *cPortList =(CListBox *)GetDlgItem(IDC_CHANNELS);
    char szPortName[10];
    memset( szPortName, 0, sizeof(szPortName) );
    i = cPortList->GetCurSel();
    if ( i != LB_ERR ) {
        cPortList->GetText( i, szPortName );
        BeginWaitCursor();

        cEdit =(CEdit *)GetDlgItem( IDC_CONFIG );
        memset( szCFile, 0, sizeof(szCFile) );
        cEdit->GetLine( 0, szCFile, sizeof(szCFile) );
        int iError = TestGammaLink( (LPSTR)szPortName, &ts, szCFile );
        EndWaitCursor();
        SetDlgItemText( IDC_TYPE, ts.Model );
    }
}

void CDlgGOpen::OnChangeConfig()
{
    char    buf[256];

    if ( GetDlgItemText( IDC_CONFIG, buf, 255 ) )
        GetDlgItem(IDC_TEST)->EnableWindow( TRUE );
    else
        GetDlgItem(IDC_TEST)->EnableWindow( FALSE );
}

void CDlgGOpen::OnSelchangeChannels()
{
    SetDlgItemText( IDC_TYPE, "" );
}

#endif //win32

void CDlgSendFax::OnChangeFaxnumber()
{
//rz if the faxnumber is valid it will  enable theh OK button

        if(TestPhoneNumber())
                GetDlgItem(IDOK)->EnableWindow(TRUE);
        else
                GetDlgItem(IDOK)->EnableWindow(FALSE);
        if((((CButton*)GetDlgItem(IDC_SEND_MANUAL))->GetCheck()==1)||(((CButton*)GetDlgItem(IDC_SEND_POLLING))->GetCheck()==1))
                GetDlgItem(IDOK)->EnableWindow(TRUE);

}

void CDlgSendFax::OnSendManual()
{
        // TODO: Add your control notification handler code here
    CButton *but=(CButton*)GetDlgItem(IDC_SEND_MANUAL);
    if(but->GetCheck())
    {
        CEdit *edit=(CEdit*)GetDlgItem(IDC_FAXNUMBER);
        edit->SetWindowText("");
              GetDlgItem(IDOK)->EnableWindow(TRUE);
    }


}

void CDlgSendFax::OnSendPolling()
{
        // TODO: Add your control notification handler code here
    CButton *but=(CButton*)GetDlgItem(IDC_SEND_POLLING);
    if(but->GetCheck())
    {
        CEdit *edit=(CEdit*)GetDlgItem(IDC_FAXNUMBER);
        edit->SetWindowText("");
              GetDlgItem(IDOK)->EnableWindow(TRUE);
    }

}

void CDlgSendFax::OnSendimmediate()
{
        // TODO: Add your control notification handler code here

        if(TestPhoneNumber())
                GetDlgItem(IDOK)->EnableWindow(TRUE);
        else
                GetDlgItem(IDOK)->EnableWindow(FALSE);

}

void CDlgSendFax::OnSendqueue()
{
        // TODO: Add your control notification handler code here
        if(TestPhoneNumber())
                GetDlgItem(IDOK)->EnableWindow(TRUE);
        else
                GetDlgItem(IDOK)->EnableWindow(FALSE);

}

void CDlgFaxPortSetup::OnTestdialtone() 
{
	// TODO: Add your control notification handler code here
    SetCapture();
    CListBox *cPortList =(CListBox *)GetDlgItem(IDC_PORTLIST);
    char szPortName[10];
    memset(szPortName, 0, sizeof(szPortName));
    cPortList->GetText(cPortList->GetCurSel(), szPortName);

    BeginWaitCursor();
    int iError =DetectDialTone((LPSTR)szPortName);
	EndWaitCursor();	
	if (1==iError)
		MessageBox("Dialtone Detected. ", "Test Dialtone", MB_ICONINFORMATION);
	else if (0==iError)
		MessageBox("No Dialtone! ", "Test Dialtone", MB_ICONSTOP);
	else if (-1==iError)
		MessageBox("No Modem on COM Port! ", "Test Dialtone", MB_ICONSTOP);
		
    ReleaseCapture();    
}

void CDlgSendFax::OnChangeMonth() 
{
	
	CString month;
    struct  tm tim;
	int newmonth;
	time_t  now=time( NULL );
	tim = *localtime( &now );
    GetDlgItem(IDC_MONTH)->GetWindowText(month);
	bool notNumber=false;
	for (int i=0;i<month.GetLength() && notNumber==false;i++)
		if ((char)(month[i])<48 || (char)month[i]>57) notNumber=true;
	newmonth=atoi(month);
	if (notNumber || newmonth<1 || newmonth>12) SetDlgItemInt( IDC_MONTH, tim.tm_mon+1 );
	

	// TODO: Add your control notification handler code here
	
}

void CDlgSendFax::OnChangeDay() 
{

	CString day;
    struct  tm tim;
	int newday;
	time_t  now=time( NULL );
	tim = *localtime( &now );
    GetDlgItem(IDC_DAY)->GetWindowText(day);
	bool notNumber=false;
	for (int i=0;i<day.GetLength() && notNumber==false;i++)
		if ((char)(day[i])<48 || (char)day[i]>57) notNumber=true;
	newday=atoi(day);
	if (notNumber || newday<1 || newday>31) SetDlgItemInt( IDC_DAY, tim.tm_mday );


	// TODO: Add your control notification handler code here
	
}

void CDlgSendFax::OnChangeYear() 
{

	CString year;
    struct  tm tim;
	int newyear;
	time_t  now=time( NULL );
	tim = *localtime( &now );
    GetDlgItem(IDC_YEAR)->GetWindowText(year);
	bool notNumber=false;
	for (int i=0;i<year.GetLength() && notNumber==false;i++)
		if ((char)(year[i])<48 || (char)year[i]>57) notNumber=true;
	newyear=atoi(year);
	if (notNumber || (newyear< tim.tm_year + 1900 && newyear>999)) SetDlgItemInt( IDC_YEAR, tim.tm_year + 1900 );
	// TODO: Add your control notification handler code here
	
}

void CDlgSendFax::OnChangeHour() 
{
	CString hour;
    struct  tm tim;
	int newhour;
	time_t  now=time( NULL );
	tim = *localtime( &now );
    GetDlgItem(IDC_HOUR)->GetWindowText(hour);
	bool notNumber=false;
	for (int i=0;i<hour.GetLength() && notNumber==false;i++)
		if ((char)(hour[i])<48 || (char)hour[i]>57) notNumber=true;
	newhour=atoi(hour);
	if (notNumber || newhour<0 || newhour >23) SetDlgItemInt( IDC_HOUR, tim.tm_hour );
	
	// TODO: Add your control notification handler code here
	
}

void CDlgSendFax::OnChangeMinute() 
{
	CString min;
    struct  tm tim;
	int newmin;
	time_t  now=time( NULL );
	tim = *localtime( &now );
    GetDlgItem(IDC_MINUTE)->GetWindowText(min);
	bool notNumber=false;
	for (int i=0;i<min.GetLength() && notNumber==false;i++)
		if ((char)(min[i])<48 || (char)min[i]>57) notNumber=true;
	newmin=atoi(min);
	if (notNumber || newmin<0 || newmin>59) SetDlgItemInt( IDC_MINUTE, tim.tm_min );	
	// TODO: Add your control notification handler code here
	
}

void CBOpen::OnBrowse() 
{
	LPSTR GroupFilterBuff =
    "Config Files (*.cfg)\0*.CFG\0"
    "All Files\0*.*\0";
	CFileDialog *dlgFile=new CFileDialog(TRUE);
	dlgFile->m_ofn.lpstrTitle = "Open";
	dlgFile->m_ofn.lpstrFilter = GroupFilterBuff;
	if (dlgFile->DoModal()==IDOK)
		SetDlgItemText( IDC_CFILE, /*dlgFile->m_ofn.lpstrFileTitle*/dlgFile->GetPathName());

	delete dlgFile;
}

void CDlgFaxClose::OnSelchangeFaxports() 
{
	// TODO: Add your control notification handler code here
	
}
