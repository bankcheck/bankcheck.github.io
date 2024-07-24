/****************************************************************************/
/* PNGDLL.H  (c) Copyright Black Ice Software Inc.  1989 - 1991             */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/****************************************************************************/


/* ----------------------------- Module Types ---------------------------- */


typedef HANDLE HDIB;


/* ---------------------------- SDK Functions ---------------------------- */


HDIB    CALLBACK LoadPNGIntoDIB(LPSTR lpszFileName, LPINT lpnError);
HBITMAP CALLBACK LoadPNGIntoBitmap(LPSTR lpszFileName, LPINT lpnError, POINT *pDPI, HPALETTE *phPal);
BOOL    CALLBACK SaveDIBInPNGFormat(LPSTR lpszFileName, HDIB hDIB, LPINT lpnError);
BOOL    CALLBACK SaveBitmapInPNGFormat(LPSTR lpszFileName, HBITMAP hBitmap, LPINT lpnError, POINT *pDPI, HPALETTE hPal);
LPSTR   CALLBACK GetErrorMsg(void);


/* ----------------------------- Error Codes ----------------------------- */


#define PNGERR_NOERROR          0
#define PNGERR_CREATE           1   //unable to create file
#define PNGERR_OPEN             2   //file not found
#define PNGERR_MEMORY           3   //not enuogh memory
#define PNGERR_HANDLE           4   //invalid bitmap or DIB handle
#define PNGERR_READING          5   //error occured while loading
#define PNGERR_WRITING          6   //error occured while saving
#define PNGERR_CREATEDIBITMAP   7   //unable to create DIB
#define PNGERR_GETDIBITS        8   //unable to get DIB
#define PNGERR_PALETTE          9   //palette missing
#define PNGERR_BITDEPTHORALPHA 10   //unsupported bit depth or alpha channel exist


void CALLBACK GetBiPNGVersion(LPSTR lpBuffer, int nMaxByte);
