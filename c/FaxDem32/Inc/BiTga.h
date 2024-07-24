/*--------------------------------------------------------------------------
 *              (c) Copyright Black Ice Software Inc.  1989 - 1992
 *                    All Rights Reserved
 *                    Unpublished and confidential material.
 *                    --- Do not Reproduce or Disclose ---
 *
 *-- Program name : TGASDK.DLL
 *-- Module name  : TGA_SDK.H
 *-- Project name : TGA SDK
 *-- Description  : header file for TGA SDK
 *-- Environment  : MS-DOS, MS WINDOWS 3.0, MSC 6.0
 *-- Author       : PROSPER Bt.
 *-- Revisions    :
 *--------------------------------------------------------------------------*/


/* ------------------------- module defines ----------------------- */

/* OpenTGAFile () params */
#define TGA_READ        (LONG)( OF_READ)                  /* | OF_SHARE_DENY_WRITE) */
#define TGA_CREATE      (LONG)( OF_CREATE | OF_READWRITE) /* | OF_SHARE_EXCLUSIVE)  */
#define TGA_MODIFY      (LONG)( OF_READWRITE)             /* | OF_SHARE_EXCLUSIVE)  */
#define TGA_INFO        (LONG)( 0x80000000L | TGA_READ)
#define TGA_GET_STAMP   (LONG)( 0x40000000L | TGA_INFO)

/* image types */
#define TGA_NO_IMAGE          0
#define TGA_COLOR_MAP         1
#define TGA_TRUE_COLOR        2
#define TGA_BLACK_WHITE       3

#define TGA_UNCOMP            0x0
#define TGA_RLE_CODED         0x8

/* image orientation: value of ImageDescriptor.byImageOriginHor */
#define TGA_IMAGE_LEFT        0
#define TGA_IMAGE_RIGHT       1

/* image orientation: value of ImageDescriptor.byImageOriginVer */
#define TGA_IMAGE_BOTTOM            0
#define TGA_IMAGE_TOP               1

/* color map type */
#define TGA_NO_COLOR_MAP            0
#define TGA_COLOR_MAP_EXIST         1

/* TGA file format version */
#define TGA_FILE_FORMAT_UNKNOWN    0
#define TGA_FILE_FORMAT_ORIGIN     1
#define TGA_FILE_FORMAT_2          2

#define TGA_STAMP_MAX_SIZE           64
#define TGA_ID_STRING_LEN           256
#define STRING_LEN                   41    /* len of author's name */
#define COMM_LEN                     81    /* len of author's comment */

/* -------------------- TGA file data structures ------------------ */

typedef enum tagTGAError
{
   TGA_ERROR_OK= 0,              /* no error detected */

   TGA_ERROR_GALLOC,             /* error during global alloc */
   TGA_ERROR_GLOCK,              /* error during global lock */
   TGA_ERROR_LALLOC,             /* error during local alloc */
   TGA_ERROR_LLOCK,              /* error during local lock */

   TGA_ERROR_ORIG_GALLOC,        /* error during global alloc for TGAOriginalFile */
   TGA_ERROR_ORIG_GLOCK,         /* error during global lock for TGAOriginalFile */

   TGA_ERROR_SCAN_GALLOC,        /* error during global alloc for ScanLineTable */
   TGA_ERROR_SCAN_GLOCK,         /* error during global lock for ScanLineTable */

   TGA_ERROR_EXT_GALLOC,         /* error during global alloc for TGAExtDevArea */
   TGA_ERROR_EXT_GLOCK,          /* error during global lock for TGAExtDevArea */
   TGA_ERROR_EXT_SIZE,           /* extension area size incorrect */
   TGA_ERROR_FILLEXT,            /* error during filling up extension are struct */

   TGA_ERROR_DEV_GALLOC,         /* error during global alloc for Developer Area */
   TGA_ERROR_DEV_GLOCK,          /* error during global lock for Developer Area */

   TGA_ERROR_STAMP_GALLOC,       /* error during global alloc for Postage Stamp */
   TGA_ERROR_STAMP_GLOCK,        /* error during global lock for Postage Stamp */

   TGA_ERROR_CORR_GALLOC,        /* error during global alloc for Correction Table */
   TGA_ERROR_CORR_GLOCK,         /* error during global lock for Correction Table */

   TGA_ERROR_FILE_CORRUPTED,     /* file corrupted or incorrect format */
   TGA_ERROR_NEWFILE_CORRUPTED,  /* New TGA file corrupted or incorrect
                                  * format above Original Area */
   TGA_ERROR_NOT_NEW_FORMAT,     /* the given function cannot operate on
                                  * original or unknown TGA file format */
   TGA_ERROR_NOT_ENCODED,        /* user hasn't run EncodeTGAFile function */

   TGA_ERROR_BITMAP,             /* error in data of BitmapInfoHeader */
   TGA_ERROR_IMAGETYPE,          /* unknow TGA image type */
   TGA_ERROR_NO_CLRMAP,          /* no color map data in TGA file */
   TGA_ERROR_NO_EXTAREA,         /* no extension area in TGA file */
   TGA_ERROR_NO_DEV,             /* no developer area in TGA file */
   TGA_ERROR_NO_CLRCORR,         /* no color correction table in TGA file */
   TGA_ERROR_NO_STAMP,           /* No Postage Stamp Data in TGA file */

   TGA_ERROR_BUF_GALLOC,         /* buffer alloc error */
   TGA_ERROR_BUF_GLOCK,          /* buffer lock error */
   TGA_ERROR_CONV,               /* conversation error */

   TGA_ERROR_SCANLINE_GALLOC,    /* no space for scan line table */
   TGA_ERROR_HDC,                /* hDC error */
   TGA_ERROR_PALETTE,            /* palette creating error */

   TGA_ERROR_SET_DIBITS,         /* SetDIBits error */
   TGA_ERROR_GET_DIBITS,         /* GetDIBits error */
   TGA_ERROR_CREAT_BITMAP,       /* CreateDIBitmap error */

   TGA_ERROR_IO,                 /* File I/O error */


  /* MUST BE LAST ERROR CODE */
   TGA_ERROR_DOSFILE             /* must be added to dos error code */

} TTGAERRORS;
                 
/***                 
typedef struct tagImageDescriptor
{
   BYTE          byAlphaChannel   :4;  // attribute bits 
   BYTE          byImageOriginVer :1;  // image vertical orientation 
   BYTE          byImageOriginHor :1;  // image horizontal orientation 
   BYTE          byUnused         :2;  // must be zero 
} ImageDescriptor;                     // image descriptor bitfield 
****/    

//#define MSK_IMG_ALPHA   0xf
#define MSK_IMG_VER     0x10    
#define MSK_IMG_HOR     0x20
    

#ifdef STRICT
   typedef BOOL (CALLBACK *TGALINEPROC)(LPSTR, UINT, LONG);
#else
   typedef BOOL (CALLBACK *TGALINEPROC)();
#endif

typedef GLOBALHANDLE           GHTGAFILE;

/* ------------------ function prototypes ----------------- */

UINT      CALLBACK GetTGAError( void);
LPSTR     CALLBACK GetTGAErrorString( LPSTR, UINT);
UINT      CALLBACK SetTGAError( UINT);
//void      CALLBACK GetTGAVersion( LPSTR, UINT);
void CALLBACK GetBiTGAVersion(LPSTR lpBuffer, int nMaxByte);
HBITMAP   CALLBACK LoadTGAIntoBitmap( LPSTR lpszFileName, BOOL bDispInfo);
HANDLE    CALLBACK LoadTGAIntoDIB(LPSTR lpszFileName, BOOL bDispInfo);
BOOL      CALLBACK SaveBitmapInTGAFormat(LPSTR lpszFileName, HBITMAP hBitmap,
                                        HPALETTE hPal, BOOL bComp, BOOL bDispDlg);
BOOL      CALLBACK SaveDIBInTGAFormat(LPSTR lpszFileName, HANDLE hDIB, 
                                     BOOL bComp, BOOL bDispInfo);


/* not documented functions */

GHTGAFILE CALLBACK GetTGAFileInfo( LPSTR, BOOL);
BOOL    CALLBACK  CreateTGAExtStruct( GHTGAFILE);
BOOL    CALLBACK  RemoveTGAExtStruct( GHTGAFILE);
BOOL    CALLBACK  RemoveTGAFileInfo( GHTGAFILE);
GHTGAFILE CALLBACK OpenTGAFile( LPSTR, LONG);
BOOL    CALLBACK  CloseTGAFile( GHTGAFILE);
BOOL    CALLBACK  RenameTGAFile( GHTGAFILE, LPSTR, LPSTR);

BOOL    CALLBACK  GetTGADevDir( GHTGAFILE);
BOOL    CALLBACK  GetTGADevField( GHTGAFILE);
BOOL    CALLBACK  GetTGAClrCorrTable( GHTGAFILE);
BOOL    CALLBACK  GetTGAPostageStamp( GHTGAFILE);

/* (Not documented)   TGA_image-bitmap conversation */

HBITMAP CALLBACK  GetTGADimensions( GHTGAFILE, BOOL);
BOOL    CALLBACK  GetTGAClrMap( GHTGAFILE);
BOOL    CALLBACK  CopyTGAClrMapIntoRGBQuad( GHTGAFILE, RGBQUAD FAR *, int);
HPALETTE CALLBACK CopyTGAClrMapIntoPalette( GHTGAFILE);
BOOL    CALLBACK  DecodeTGAImage( GHTGAFILE, TGALINEPROC);
HBITMAP CALLBACK  CopyTGAStampIntoBitmap( GHTGAFILE);
HANDLE  CALLBACK  DecodeTGAImageIntoDIB( GHTGAFILE ghTGAFile, TGALINEPROC lpLineFn);

/* (Not documented)     bitmap-TGA_image conversation */

BOOL    CALLBACK  PutTGADimensions( HBITMAP, HPALETTE, GHTGAFILE);
BOOL    CALLBACK  PutTGADimensionsFromDIB( HANDLE hDIB, GHTGAFILE ghTGAFile);

BOOL    CALLBACK  EncodeTGAImage( GHTGAFILE, TGALINEPROC);
BOOL    CALLBACK  EncodeTGAImageFromDIB( GHTGAFILE, HANDLE, TGALINEPROC);

BOOL    CALLBACK  MakeTGAStamp( GHTGAFILE, HBITMAP);

/* ---------------------- hi-level functions ----------------------- */

HBITMAP CALLBACK  LoadTGAFileIntoBitmap( LPSTR lpszFileName, BOOL bDispInfo);

BOOL    CALLBACK  LoadTGAFileIntoClipboard( LPSTR lpszFileName, BOOL bDispInfo);

BOOL    CALLBACK  FlushTGALine( LPSTR lpLineBuff, UINT wLine, LONG lParam);
BOOL    CALLBACK  FillTGALine( LPSTR lpLineBuff, UINT wLine, LONG lParam);
BOOL    CALLBACK  LoadTGAFileInfoDlgProc (HWND, UINT, WPARAM, LPARAM);
BOOL    CALLBACK  SaveTGAFileInfoDlgProc (HWND, UINT, WPARAM, LPARAM);

BOOL    CALLBACK  SaveTGAFileFromBitmap( LPSTR lpszFileName, HBITMAP hBitmap,
                                    HPALETTE hPal, BOOL bComp, BOOL bDispDlg);


BOOL    CALLBACK  SaveTGAFileFromClipboard( LPSTR lpszFileName, BOOL bComp,
                                       BOOL bDispInfo);
HANDLE  CALLBACK  LoadTGAFileIntoDIB(LPSTR lpszFileName, BOOL bDispInfoa, TGALINEPROC lpfnUserFunc);



