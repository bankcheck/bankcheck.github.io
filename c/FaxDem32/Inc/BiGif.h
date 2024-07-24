/****************************************************************************/
/* bigif.h     (c) Copyright Black Ice Software Inc.  1989 - 1991             */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/****************************************************************************/
/***************************************************************************
 Module
              c:\gif\gif.h

 Revision
              $Revision:   5.5  $

 Description
              Declaration of functions and macros used in GIF file manipulation.

 Notes
              The function definitions are in GIF.C .


      Rev 1.0   16 Feb 1991 Siklos_Gabor
   Initial revision.
***************************************************************************/

/* ---------------------------- Module Defines --------------------------- */

// OpenGifFile() nMode parameters.
#define G_READ     OF_READ                       /* 0 */
#define G_WRITE    OF_WRITE                      /* 1  Not used with OpenGifFile() */
#define G_APPEND   OF_READWRITE                   /* 2  Not used with OpenGifFile() */
#define G_CREATE   3

// Maximum length of a full file name.
#define MAXPATH 150

/* ----------------------------- Module Types ---------------------------- */

typedef HANDLE GIFFILE;                // GIF image chain structure handle.

// GIF local header structure
typedef struct GifLocalHeaderType {
    WORD iImageLeft;
    WORD iImageTop;
    WORD iImageWidth;
    WORD iImageHeight;
    BOOL bMFlag;                  /* IF MFlag THEN use local color map
                                              ELSE use global color map */
    BOOL bIFlag;                  /* IF IFlag THEN image in interlaced order
                                              ELSE image in sequential order */
    WORD iPixelSize;              /* Bits per Pixel */
    WORD iColorMapSize;           /* Number of Color Map Elements */
    RGBTRIPLE LocalColorMap[256];
} GifLocalHeader;

typedef GifLocalHeader FAR * LPGIFLOCALHDR;

typedef struct GifGlobalHeaderType {
    char cFileName[MAXPATH];       /* Associated filename */
    WORD iScreenWidth;
    WORD iScreenDepth;
    BYTE bPixelSize;                /* Bits per Pixel */
    BOOL bMFlag;                    /* IF MFlag THEN found GlobalColorMap
                                              ELSE not found              */
    BYTE bColorResolution;
    WORD iColorMapSize;             /* Number of Color Map Elements */
    BYTE bBackgroundColor;          /* Color index of screen background */
    RGBTRIPLE GlobalColorMap[256];
    WORD iNImages;
} GifGlobalHeader;

typedef GifGlobalHeader FAR * LPGIFGLOBALHDR;

/* GifError() return values. */
typedef enum tag_GIFERR {
     GOK,                     // Operation was successfull.
     GNOTENOUGHMEMORY,        // Not enough memory to allocate block.
     GBADOPENMODE,            // Not G_READ or G_CREAT in OpenGifFile().
     GINDEXOUTOFRANGE,        // Image index is out of range.
     GENDOFDATA,              // Unexpected end of file in reading data.
     GFILEIOERROR,            // General I/O error in reading or writting.
     GPATHTOOLONG,            // Pathname is longer than MAXPATH.
     GNOTGIFFILE,             // File has not a valid GIF format.
     GCOMPRESSIONFAILED,      // Error during compression or decompression.
     GBADNUMBEROFCOLORS,      // Invalid BITSPERPIXEL value.
     GCLIPOPEN                // Can't open clipboard
} TGIFERR;

#ifndef DEF_FILLPROC    /* (NGY) */
#define DEF_FILLPROC
#ifdef STRICT
typedef int (CALLBACK *FILLPROC)(LPSTR lpLineBuff, int nLine, LONG lParam);
#else
typedef int (CALLBACK *FILLPROC)();
#endif
#endif

/* --------------------------- Global Functions -------------------------- */

int     CALLBACK GetNumberOfImagesInGifFile(LPSTR lpszName);
//void    CALLBACK GetGifVersion(LPSTR, UINT);
int     CALLBACK GifError(void);
HBITMAP CALLBACK LoadGIFIntoBitmap(LPSTR lpszFileName, int nImage, int far *nErrCode);
HANDLE  CALLBACK LoadGIFIntoDIB(LPSTR  lpszFileName, int nImage, int far *nErrCode);
BOOL    CALLBACK SaveBitmapInGIFFormat(LPSTR lpszFileName, HBITMAP hBitmap, 
                                         int nImage, int far *nErrCode);
BOOL    CALLBACK SaveDIBInGIFFormat(LPSTR lpszFileName, HANDLE hDib, 
                                      int nImage, int far *nErrCode);


/*  Not documented functions    */

GIFFILE CALLBACK OpenGifFile(LPSTR lpszFileName, int nMode);
BOOL    CALLBACK CloseGifFile(GIFFILE hChain);
BOOL    CALLBACK DropGifImage(GIFFILE hChain, int nImage);
BOOL    CALLBACK GetGifGlobalInfo(GIFFILE hChain,
                                    LPGIFGLOBALHDR GifGlobalInfo);
BOOL    CALLBACK GetGifLocalInfo(GIFFILE hChain, int nImage,
                                   LPGIFLOCALHDR GifLocalInfo);
BOOL    CALLBACK DefineGifGlobalInfo(GIFFILE hChain, LPGIFGLOBALHDR Info);
BOOL    CALLBACK DefineGifLocalInfo(GIFFILE hChain, int nImage,
                                   LPGIFLOCALHDR  GifLocalInfo);
BOOL    CALLBACK ModiGifFileInfo(GIFFILE hChain, LPSTR lpszFileName);
BOOL    CALLBACK EncodeGifImage(GIFFILE hChain, int nImage, LONG lUserData,
                                  FILLPROC lpLineFn, BOOL sBar);
BOOL    CALLBACK DecodeGifImage(GIFFILE hchain, int nImage, LONG lUserData,
                                  FILLPROC lpLineFn, BOOL sBar);

BOOL    CALLBACK PutGIFToClipboard(HWND hWnd, HDC hDC, LPSTR lpszFileName,
                                     int far * nErrCode, int nImage);
BOOL    CALLBACK SaveGIFFileFromClipboard( LPSTR lpszFileName, int far * nErrCode, int nImage);

int     CALLBACK SetGifError(int nError);
LPSTR   CALLBACK GifErrorString(LPSTR lpszErrorStr, int nError);

void CALLBACK GetBiGIFFVersion(LPSTR lpBuffer, int nMaxByte);
/* ----------------------------- End of file ----------------------------- */

