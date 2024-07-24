/****************************************************************************/
/* cals.c   (c) Copyright Black Ice Software Inc.  1989 - 1995              */
/*                  All Rights Reserved                                     */
/*                  Unpublished and confidential material.                  */
/*                  --- Do not Reproduce or Disclose ---                    */
/****************************************************************************/
/****************************************************************************
  Module

  Revision

  Description
        CALS prototypes and declarations

  Notes
        None

  History
 *
 *    Rev 1.0   10 Jan 1995  NGY
 *
**********************************************************************************/

#define CALS_REC_LEN    128         /* record length */
#define CALS_REC_NUM    16          /* number of records */ 
#define CALS_HEAD_LEN   (CALS_REC_LEN * CALS_REC_NUM) 

#define CALS_REC_srcdocid   "srcdocid: "
#define CALS_REC_dstdocid   "dstdocis: "
#define CALS_REC_txtfilid   "txtfileid: "
#define CALS_REC_figid      "figid: "
#define CALS_REC_scrgph     "scrgph: "
#define CALS_REC_doccls     "doccls: "
#define CALS_REC_rtype      "rtype: "       
#define CALS_REC_rorient    "rorient: "
#define CALS_REC_rpelcnt    "rpelcnt: "
#define CALS_REC_rdensty    "rdensty: "
#define CALS_REC_notes      "notes: "  

#define CALS_REC_dtype      "dtype: "       /* MIL-STD-1840B page 24 */
#define CALS_REC_ntype      "ntype: "       /* MIL-R-28002A  page 4 */
#define CALS_REC_rdensity   "rdensity: "    /* from some sample images (may be misspell) */

typedef struct tagCALSINFO {
    DWORD rtype;                        /* only '1' is valid */
    DWORD rorient[2];               
    DWORD rpelcnt[2];                   /* X,Y size */
    DWORD rdensty;                      /* dor per inch */
} CALSINFO;     

typedef CALSINFO FAR *LPCALSINFO;

typedef struct tagCALSNOTE {
    LPSTR lpSrcdocid;
    LPSTR lpDstdocid;
    LPSTR lpTxtfilid;
    LPSTR lpFigid;
    LPSTR lpScrgph; 
    LPSTR lpDoccls;
    LPSTR lpNotes;
} CALSNOTE;

typedef CALSNOTE FAR *LPCALSNOTE;


HANDLE CALLBACK ReadCALSHead(LPSTR lpFileName);
LPSTR  CALLBACK FindCALSRecord(LPSTR lpMem, LPSTR rname);
BOOL   CALLBACK ReadCALSInfo(LPSTR lpFileName, LPCALSINFO lpCals);
HANDLE CALLBACK ReadCALSNote(LPSTR lpFileName, LPCALSNOTE lpNote);

HANDLE CALLBACK DefineCALSHead(LPCALSINFO lpCals, LPCALSNOTE lpNote);

HANDLE CALLBACK LoadCALSIntoDIB(LPSTR lpFileName, BOOL bDispInfo);
BOOL   CALLBACK SaveDIBInCALSFormat(LPSTR lpFileName, HANDLE hDib, LPCALSNOTE lpNote,
                                    LPINT lpOrient, BOOL bEditDialog);

int    CALLBACK ShowCALSInfo(HWND hWparent, LPSTR lpFileName);
int    CALLBACK EditCALSHead(HWND hWparent, LPSTR lpFileName, LPSTR lpMem);

BOOL   CALLBACK DecompressCALSToScreen(HWND   hWnd,
                                       HDC    hDC,
                                       LPSTR  lpFileName,
                                       LPRECT lprScale,
                                       UINT   wMode);

