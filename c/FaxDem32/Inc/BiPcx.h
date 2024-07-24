

/****************************************************************************/
/* bipcx.h   (c) Copyright Black Ice Software Inc.  1989 - 1991            */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/****************************************************************************/

// sc defines for original PCX functions
#define USE_PCX_PALETTE    /* put PCX color table into DIB color table   */
//#define HANDS_OFF_SCREEN   /* caller decides what to write to the screen */

/**********************************************************************
* Error Codes
**********************************************************************/
#define PCX_OK                   1
#define PCX_BUF_ALLOC            2   // unable to allocate buffers
#define PCX_UNKNOWN_VERSION      3   // uninterpreatable version
#define PCX_UNKNOWN_ENCODING     4   // possibly PCX, but doesn't use ZSoft encoding
#define PCX_FILEOPEN             5   // unable to open file
#define PCX_BITMAP               6   // unable to create bitmap
#define PCX_CLIP_OPEN            7   // unable to open clipboard
#define PCX_HDC                  8   // unable to create compatible DC
#define PCX_TOO_SPECIAL_FORMAT   9   // too hardware dependent bitmap

#define PCX_BAD_PALETTE         10   // error in reading palette info

#define PCX_ERROR_GLOCK         11   // global and local lock error
#define PCX_ERROR_GALLOC        12   // global and local alloc error
#define PCX_ERROR_USERFUNC      13   // userfunction return with FALSE
#define PCX_ERROR_BITMAPFORMAT  14   // PCX file and bitmap is not same type
#define PCX_ERROR_GETCLIPBOARD  15   // error in GetClipboardData function
#define PCX_ERROR_READ          16   // error in _lread
#define PCX_ERROR_WRITE         17   // error in _lwrite
#define PCX_ERROR_IO            18   // file I/O error
#define PCX_ERROR_COLORSPACE	19	 // Inavlid color space	

#define DCX_ERROR_INVALIDITEM   21   // reference to non-exist item number
#define DCX_ERROR_BADFILETYPE   22   // bad DCX file identifier
#define DCX_ERROR_BADOFFSET     23   // bad item offset in DCX header
#define DCX_ERROR_DISKSPACE     24   // not enough disk space for file operation
#define DCX_ERROR_DCXFULL       25   // no empty entry in DCX header
#define DCX_ERROR_DELETEFILE    26   // unable to delete file
#define DCX_ERROR_RENAMEFILE    27   // unable to rename file
#define DCX_ERROR_EMPTY             28    // no image in DCX-file


/* constants to identify which colormap to create */
#define WINDOWS_ON_CGA  1
#define WINDOWS_ON_HERC 2
#define WINDOWS_ON_EGA  3
#define WINDOWS_ON_VGA  4

#define PCX_RGB			   1  /* RGB image. */
#define PCX_YUV			   10  /* YUV image. */
#define PCX_CMY			   11  /* CMY image. */
#define PCX_YIQ			   13 /* YIQ image. */
#define PCX_HSV			   14 /* HSV image. */
#define PCX_HSI			   15 /* HSI image. */
#define PCX_XYZ			   16 /* XYZ image. */
#define PCX_LAB			   17 /* LAB image. */

#define DCX_RGB			   1  /* RGB image. */
#define DCX_YUV			   10  /* YUV image. */
#define DCX_CMY			   11  /* CMY image. */
#define DCX_YIQ			   13 /* YIQ image. */
#define DCX_HSV			   14 /* HSV image. */
#define DCX_HSI			   15 /* HSI image. */
#define DCX_XYZ			   16 /* XYZ image. */
#define DCX_LAB			   17 /* LAB image. */

#define MAX_DCXITEM  1022
#define DCX_FILEID  987654321L

typedef struct
    {
        DWORD  dcxid;
        LONG   tag[MAX_DCXITEM+1];
    } DCX_HEADER;
typedef DCX_HEADER far *  LPDCXHEADER;

typedef struct tag_pcx_header
   {
      unsigned char  Manufacturer,
                     Version,
                     Encoding,
                     BitsPerPixel;
      short          nLeft,            /*picture dimensions*/
                     nTop,
                     nRight,
                     nBottom,
                     nHorzDPI,         /*horizontal resolution (dpi)*/
                     nVertDPI;
      unsigned char  Colormap[48];
      char           Reserved,
                     NumOfPlanes;
      short          nBytesPerLine,
                     nPaletteInfo,
                     nHorzScrSize,
                     nVertScrSize;
      char           Dummy[54];
   } PCX_HEADER;

#ifdef STRICT
   typedef int (CALLBACK *FLUSHFARPROC)( LPSTR, UINT, UINT, HBITMAP, HDC, LPBITMAPINFO);
   typedef int (CALLBACK *FLUSHDIBFARPROC)( LPSTR, UINT, UINT, LPBITMAPINFO); 
   
   typedef int (CALLBACK *FILLFARPROC)( LPSTR, UINT, UINT, HBITMAP, HDC, LPBITMAP);
   typedef int (CALLBACK *FILLDIBFARPROC)( LPSTR, UINT, UINT, LPBITMAPINFO);
#else
   typedef int (CALLBACK *FLUSHFARPROC)();
   typedef int (CALLBACK *FLUSHDIBFARPROC)(); 
   
   typedef int (CALLBACK *FILLFARPROC)();
   typedef int (CALLBACK *FILLDIBFARPROC)();
#endif   

//void    CALLBACK GetPcxVersion(LPSTR lpBuffer, int nMaxByte);
LPSTR   CALLBACK GetPCXErrorString( LPSTR , int far *);
HANDLE  CALLBACK LoadPCXIntoDIB(LPSTR lpszFileName, int far *lpiError);
HBITMAP CALLBACK LoadPCXIntoBitmap( LPSTR lpszFileName, int far *lpiError);
BOOL    CALLBACK SaveBitmapInPCXFormat(LPSTR lpszFileName, HBITMAP hBitmap, int far *lpiError);
BOOL    CALLBACK SaveDIBInPCXFormat(LPSTR lpszFileName, HANDLE hDIB, int far *lpiError);
BOOL CALLBACK SaveNonRGBDIBInPCXFormat( LPSTR lpszFileName, HANDLE hDIB, int far *lpiError);
int CALLBACK GetPCXColorSpace(LPSTR lpszFileName);
HANDLE  CALLBACK LoadNonRGBPCXIntoDIB(LPSTR lpszFileName, int far *lpiError);

int      CALLBACK GetNumberOfImagesInDCXFile(LPSTR lpszFileName);
BOOL     CALLBACK MakeDCXFile( LPSTR lpszFileName, int far * lpiError);
HBITMAP  CALLBACK LoadDCXIntoBitmap(LPSTR lpszFileName, UINT wItem,int far *lpiError);
HANDLE   CALLBACK LoadDCXIntoDIB(LPSTR lpszFileName, UINT wItem,int far *lpiError);
HANDLE   CALLBACK LoadNonRGBDCXIntoDIB(LPSTR lpszFileName, UINT wItem,int far *lpiError);
BOOL     CALLBACK SaveBitmapInDCXFormat(LPSTR lpszFileName, HBITMAP hBitmap, int far * lpiError);
BOOL     CALLBACK SaveDIBInDCXFormat( LPSTR lpszFileName, HANDLE hDIB, int far * lpiError);
BOOL     CALLBACK SaveNonRGBDIBInDCXFormat( LPSTR lpszFileName, HANDLE hDIB, int far * lpiError);


/*  not documented functions    */

int     CALLBACK  LoadPCX(BOOL bSign, HDC hDC, LPSTR lpszFileName);
HPALETTE CALLBACK ReadPCXPalette( LPSTR lpszFileName, PCX_HEADER far *lpHeader, int far *lpiError);
BOOL    CALLBACK  PCXInfo(LPSTR lpszFileName, PCX_HEADER far *lpInfo,int far *lpiError);
BOOL    CALLBACK  PutPCXToClipboard( LPSTR lpszFileName,int far * lpiError);
BOOL    CALLBACK  SavePCXFileFromClipboard( LPSTR lpszFileName, int far *lpiError);
BOOL    CALLBACK  FlushPCXLine( LPSTR lpLineBuff, UINT wLineNo, UINT wLineCount, HBITMAP hBitmap, HDC hDC, LPBITMAPINFO lpBitmapInfo);
BOOL    CALLBACK  AppendBitmapToPCXFile( HBITMAP hBitmap, LPSTR lpszFileName, int far *lpiError);
HBITMAP CALLBACK  LoadPCXIntoBitmapFromMemory( LPSTR lpPCXStart, LONG lSize, int far *lpiError, FLUSHFARPROC lpfnUserFunc);

UINT     CALLBACK GetDCXInfo( LPSTR lpszFileName, int far * lpiError );
BOOL     CALLBACK DCXItemInfo(LPSTR lpszFileName, UINT wItem, PCX_HEADER far *lpInfo, int far *lpiError);
HBITMAP  CALLBACK LoadDCXItemToBitmap(LPSTR lpszFileName, UINT wItem,int far *lpiError, FLUSHFARPROC lpfnUserFunc);
HANDLE   CALLBACK LoadDCXItemToDIB(LPSTR lpszFileName, UINT wItem,int far *lpiError, FLUSHDIBFARPROC lpfnUserFunc);
BOOL     CALLBACK AddBitmapToDCXFile(HBITMAP hBitmap, LPSTR lpszFileName,int far * lpiError, FILLFARPROC lpfnUserFunc);
BOOL     CALLBACK AddDIBToDCXFile( HANDLE hDIB, LPSTR lpszFileName, int far * lpiError, FILLDIBFARPROC lpfnUserFunc);
BOOL     CALLBACK AddPCXFileToDCXFile( LPSTR lpszPCXFileName, LPSTR lpszDCXFileName, int far * lpiError);
BOOL     CALLBACK PutDCXItemToClipboard(LPSTR lpszFileName, UINT wItem, int far * lpiError);
BOOL     CALLBACK AddClipboardToDCXFile( LPSTR lpszFileName, int far *lpiError);
BOOL     CALLBACK DelItemFromDCXFile(LPSTR lpszFileName, UINT wItem, int far *lpiError);
HPALETTE CALLBACK ReadDCXItemPalette( LPSTR lpszFileName, UINT wItem, PCX_HEADER far *lpHeader, int far * lpiError);
BOOL     CALLBACK SelectPCXDlgProc(HWND hDlg, UINT iMessage, WPARAM wParam, LPARAM lParam);
UINT     CALLBACK SelectDCXItem( LPSTR lpszFileName, int FAR *lpiError);
HBITMAP  CALLBACK LoadDCXImage( LPSTR lpszFileName, int far * lpiError);
BOOL     CALLBACK DelDCXImage( LPSTR lpszFileName, int far *lpiError);
int CALLBACK GetDCXColorSpace(LPSTR lpszFileName, UINT nImage);

void CALLBACK GetBiPCXVersion(LPSTR lpBuffer, int nMaxByte);
