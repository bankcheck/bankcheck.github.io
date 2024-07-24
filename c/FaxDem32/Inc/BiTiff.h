/****************************************************************************/
/* tiff.h   (c) Copyright Black Ice Software, Inc.  1989 - 2000             */
/*                           All Rights Reserved                            */
/*                  Unpublished and confidential material.                  */
/*                   --- Do not Reproduce or Disclose ---                   */
/****************************************************************************/
/****************************************************************************
 Module
      tiff.h

 Revision
      8.0

 Description
      Declaration of macros, data types and functions used in TIFF SDK.
*****************************************************************************/

#ifndef _TIFFSDK_H_
#define _TIFFSDK_H_

#define TIFFSDK

/* ---------------------------- Module Defines ---------------------------- */

/* TIFF tag identifiers. */
#define NEWSUBFILETYPE            254
#define SUBFILETYPE               255
#define IMAGEWIDTH                256
#define IMAGELENGTH               257
#define BITSPERSAMPLE             258
#define COMPRESSION               259
#define PHOTOMETRICINTERPRETATION 262
#define THRESHHOLDING             263
#define CELLWIDTH                 264
#define CELLLENGTH                265
#define FILLORDER                 266
#define DOCUMENTNAME              269
#define IMAGEDESCRIPTION          270
#define MAKE                      271
#define MODEL                     272
#define STRIPOFFSETS              273
#define ORIENTATION               274
#define SAMPLESPERPIXEL           277
#define ROWSPERSTRIP              278
#define STRIPBYTECOUNTS           279
#define MINIMUMVALUE              280
#define MAXIMUMVALUE              281
#define XRESOLUTION               282
#define YRESOLUTION               283
#define PLANARCONFIG              284
#define PAGENAME                  285
#define XPOSITION                 286
#define YPOSITION                 287
#define FREEOFFSETS               288
#define FREEBYTECOUNTS            289
#define GRAYRESPONSEUNITS         290
#define GRAYRESPONSECURVE         291
#define GROUP3OPTIONS             292
#define GROUP4OPTIONS             293
#define RESOLUTIONUNIT            296
#define PAGENUMBER                297
#define COLORRESPONSEUNIT         300
#define COLORRESPONSECURVES       301
#define SOFTWARE                  305
#define DATETIME                  306
#define ARTIST                    315
#define HOSTCOMPUTER              316
#define PREDICTOR                 317
#define WHITEPOINT                318
#define PRIMARYDHROMATICITIES     319
#define COLORMAP                  320
#define JPEGTABLES                347
#define EXISTINGTAGS              0   /* Special tag. See documentation. */
#define NOTEITTAG                 HOSTCOMPUTER

/* EXTENSION */
#define HALFTONEHINTS             321
#define TILEWIDTH                 322
#define TILELENGTH                323
#define TILEOFFSETS               324
#define TILEBYTECOUNTS            325

/* COLORIMETRY */
#define INKSET                    332
#define INKNAMES                  333
#define NUMBEROFINKS              334
#define DOTRANGE                  336
#define TARGETPRINTER             337
#define EXTRASAMPLES              338
#define SAMPLEFORMAT              339
#define SMINSAMPLEVALUE           340
#define SMAXSAMPLEVALUE           341
#define TRANSFERRANGE             342

/* JPEG */
#define JPEGPROC                    512
#define JPEGINTERCHANGEFORMAT       513
#define JPEGINTERCHANGEFORMATLENGTH 514
#define JPEGRESTARTINTERVAL         515
#define JPEGLOSLESSPREDICTORS       517
#define JPEGPOINTTRANSFORMS         518
#define JPEGQTABLES                 519
#define JPEGDCTABLES                520
#define JPEGACTABLES                521
#define YCBCRCOEFFICIENTS           529
#define YCBCRSUBSAMPLING            530
#define YCBCRPOSITIONING            531
#define REFERENCEBLACKWHITE         532

#define COPYRIGHT                 33432

/* Data types. */
#define BYTETYPE     1
#define ASCIITYPE    2
#define SHORTTYPE    3
#define LONGTYPE     4
#define RATIONALTYPE 5
#define OFFSETTYPE   9

/* Data type sizes in bytes. */
#define BYTESIZE     1
#define ASCIISIZE    1
#define SHORTSIZE    2
#define LONGSIZE     4
#define RATIONALSIZE 8
#define OFFSETSIZE   4

/* Image types as defined in tag NEWSUBFILETYPE. */
#define REDUCEDVERSION    1
#define APAGEOFAMULTIPAGE 2
#define TRANSPARENCYMASK  4

/* Extended image types used as filters with the above ones. */
#define NORMALVERSIONS    0
#define REGISTEREDTIFF    (1<<14)
#define ALLVERSIONS       (1<<15)

/* Image types as defined in tag SUBFILETYPE (not recommended any more). */
#define OLDFULLVER        1
#define OLDREDUCEDVER     2
#define OLDAPAGE          3

/* Compression types. */
#define NOCOMPRESSION     1
#define TIFF_CCITT        2
#define CCITT_GROUP3      3
#define CCITT_GROUP4      4
#define LZW_COMPRESSION   5
#define PACK_BITS         32773U
#define JPEG_COMPRESSION  6
#define JPEG7_COMPRESSION 7

/* Additional info on the compression algorithm. It can be OR-ed
   to the DWORD compression value as the high word. */
#define CCITT_1D         0
#define CCITT_2D         (1L << 16)
#define CCITT_UNCOMP     (2L << 16)
#define CCITT_FILLBITS   (4L << 16)
#define LZW_NORMAL       (1L << 16)
#define LZW_HORIZDIFF    (2L << 16)

/* TIFF type modifiers - special formats for SaveDIBInTiffFile. */
#define TSPEC_16BIT      (1 << 8)
#define TSPEC_12IN16BIT  (2 << 8)
#define TSPEC_CMYK       (3 << 8)
#define TSPEC_YCBCR      (4 << 8)

/* For saving TIFF files with High Level Functions.
   (SaveBitmapInTiffFile, SaveDIBInTiffFile, etc.) */
#define TCOMP_NOCOMP     201  /* Nocompression */
#define TCOMP_PACKBITS   202  /* Packbit */
#define TCOMP_LZW        203  /* LZW */
#define TCOMP_LZW_DIFF   204  /* LZW with differentiation */
#define TCOMP_CCITTG2    205  /* CCITT Group 3 1D NO EOL */
#define TCOMP_CCITTG31D  206  /* CCITT Group 3 1D */
#define TCOMP_CCITTG32D  207  /* CCITT Group 3 2D */
#define TCOMP_CCITTG4    208  /* CCITT Group 4 */
#define TCOMP_JPEG       209  /* JPEG 7*/
#define TCOMP_JPEG6      210  /* JPEG 6*/

/* For backward compatibility. */
#define NOCOMP      TCOMP_NOCOMP
#define PACKBITS    TCOMP_PACKBITS
#define LZW         TCOMP_LZW
#define LZW_DIFF    TCOMP_LZW_DIFF
#define CCITTG2     TCOMP_CCITTG2
#define CCITTG31D   TCOMP_CCITTG31D
#define CCITTG32D   TCOMP_CCITTG32D
#define CCITTG4     TCOMP_CCITTG4
#define JPEG_COMP   TCOMP_JPEG6

/* GROUP3OPTIONS flags */
#define G3OPT_DEFAULT1D	0L
#define G3OPT_FILLBITS	4L

/* Photometric interpretation values. */
#define PI_GREYSCALE       0  /* Greyscale or bilevel, 0 is white. */
#define PI_INV_GREYSCALE   1  /* Greyscale or bilevel, 0 is black. */
#define PI_RGBCOLOR        2  /* RGB image, (0,0,0) represents black. */
#define PI_PALETTECOLOR    3  /* Palette color image. See Colormap. */
#define PI_TRANSPMASK      4  /* Transparency mask. 1 defines visible plot. */
#define PI_CMYK            5  /* 4 component CMYK Image. */
#define PI_YCC             6  /* Y Cb Cr Image. */
#define PI_YUV			   10  /* YUV image. */
#define PI_CMY			   11  /* CMY image. */
#define PI_YIQ			   13 /* YIQ image. */
#define PI_HSV			   14 /* HSV image. */
#define PI_HSI			   15 /* HSI image. */
#define PI_XYZ			   16 /* XYZ image. */
#define PI_LAB			   17 /* LAB image. */

/* Maximum length of a full file name. */
#define MAXPATH MAX_PATH

/* Maximum number of images in a TIFF file. */
#ifdef WIN32
   #define MAXIMAGENUM 100000
#else
   #define MAXIMAGENUM 5000
#endif

/* OpenTiffFile() nMode parameters. */
#ifdef WIN32
#define T_READ     OF_READ       /* 0 */
#define T_WRITE    OF_WRITE      /* 1  Not used with OpenTiffFile() */
#define T_APPEND   OF_READWRITE  /* 2  Not used with OpenTiffFile() */
#define T_CREATE   3
#else
#define T_READ     READ          /* 0 */
#define T_WRITE    WRITE         /* 1  Not used with OpenTiffFile() */
#define T_APPEND   READ_WRITE    /* 2  Not used with OpenTiffFile() */
#define T_CREATE   3
#endif

/* Resolutionunit tag values. */
#define RES_IN_NODEF  1
#define RES_IN_INCH   2
#define RES_IN_CM     3

/* DecompressToScreen() image oriantation values. */
#define BIS_ROTATE90        1
#define BIS_ROTATE180       2
#define BIS_ROTATE270       3
#define BIS_SCALENORMAL     4
#define BIS_FITTOSCREEN     8
#define BIS_DRAFT          16
#define BIS_INVERT         32

#define DISP_NORMAL    4
#define DISP_PREVIEW   8
#define DISP_INVERT   32
#define DISP_ZOOMED   64
#define DISP_SCALED   64
#define DISP_CENTER  128


#define MAX_ERROR_LENGTH 60  /* For TiffErrorString(). */

/* Ascii to bitmap conversion. */
#define MEASURE_INCH            1
#define TEXT_ITALIC             2
#define TEXT_BOLD               4
#define MEASURE_METER           8

#define ERROR_INVALID_PARAM     1
#define ERROR_NOT_ENOUGH_SPACE  2
#define ERROR_FILE_NOT_OPEN     3
#define ERROR_NOT_ENOUGH_MEM    4

#define OUT_BMP                 10
#define OUT_DIB                 11


/* ----------------------------- Module Types ----------------------------- */

typedef HANDLE TIFFFILE;    /* TIFF image chain structure handle. */

#ifndef DEF_TIFFERR
#define DEF_TIFFERR
/* TiffError() return values. */
typedef enum tag_TIFFERR
{
    TOK,                    /* Operation was successfull. */
    TNOTENOUGHMEMORY,       /* Not enough memory to allocate block. */
    TBADOPENMODE,           /* Not T_READ or T_CREAT in OpenTiffFile(). */
    TINDEXOUTOFRANGE,       /* Image or tag data index is out of range. */
    TSTRIPOUTOFRANGE,       /* Strip index is out of range. */
    TENDOFDATA,             /* Unexpected end of file in reading data. */
    TFILEIOERROR,           /* General I/O error in reading or writing. */
    TPATHTOOLONG,           /* Pathname is longer than MAXPATH. */
    TNOTTIFFILE,            /* File has not a valid TIFF format. */
    TBADTAG,                /* Invalid TIFF directory tag. */
    TTOOFEWINFO,            /* Indispensable tags are missing. */
    TUNKNOWNCOMPRESSION,    /* Image compression type is not known. */
    TCOMPRESSIONFAILED,     /* Error during compression or decompression. */
    TNOSUCHTAG,             /* Such tag is not defined. */
    TBADBYTEORDER,          /* Invalid byte order ID in ModiTiffFileInfo(). */
    TBADBITORDER,           /* Invalid BITORDER tag value. */
    TBADNUMBEROFCOLORS,     /* Invalid BITSPERPIXEL tag value. */
    TTOFEWCOLORINFO,        /* Color info is not enough. */
    TNOTCALSFILE,           /* File has not a valid CALS format. */
    TNOEOFB,                /* End of Facsimile Block is missing (EOFB). */
    TBADEOFB,               /* Unexpected End of Facsimile Block (EOFB). */
    TBADWIDTH,              /* Image width must be 1728 pixels (Can't save it). */
    TNOJPEGDLL,             /* Module JPEG DLL is not found. */
    TBADJPEGDLL,            /* Can't find a function in module JPEG DLL. */
    TFORMATCLIPBOARD,       /* Clipboard format is not bitmap. */
    TOPENCLIPBOARD,         /* Could not open clipboard. */
    TRECEIVECLIPBOARD,      /* Could not receive bitmap from clipboard. */
    TIMAGENOTREGISTERED,    /* Image is not registered. */
	TNOBIDLGS,				/* BiDlgs.dll does not exist. */
	TBADPARAMS,				/* Parameter error */
	TBADDIB,				/* Bad (compressed) DIB */
	TFOUNDEOI,				/* Not PIW Format */
	TBADBPP,				/* Bits per pixel not supported */
	TBADIBUF,				/* Invalid Image Buffer Address */
	TBADHANDLE,				/* Invalid memory pointer or handle */
	TTIFFMOTYPE,			/* Can't append an Intel-type TIF to a Motorola-type TIF */
	TBADDIM,				/* Image format does not support width or length > 65535 */
} TIFFERR;
#endif

/* TIFF image chain information structure (used with GetTiffFileInfo()). */
typedef struct tag_TIFFHDR
{
    char    cFileName[MAXPATH];     /* Associated filename. */
    WORD    nByteOrder;             /* Byte order (High/Low). */
    int     iNImages;               /* Number of images in the file. */
    DWORD   dwFirstTID;             /* Offset of the 1st TID in the file. */
} TIFFHDR;

/* Data structure used to place a note on the image. */
#ifndef _NOTE_DEFINED_
#define _NOTE_DEFINED_
typedef struct tagNote
{
    BOOL bOnHead;          /* The note is stored in the TIFF header. */
    BOOL bOpaque;          /* The note is stored on the image. */
    HGLOBAL hStr;          /* ASCII text stored as note. */
    RECT rRect;            /* The note area on the image. */
    HANDLE hDIB;           /* The Device Independent Bitmap. */
} NOTESTRUCT;

typedef NOTESTRUCT FAR * LPNOTESTRUCT;
#endif

#ifndef DEF_FILLPROC
#define DEF_FILLPROC
#ifdef STRICT
typedef int (CALLBACK *FILLPROC)(LPSTR lpLineBuff, int nLine, LONG lParam);
#else
typedef int (CALLBACK *FILLPROC)(LPSTR lpLineBuff, int nLine, LONG lParam);
#endif
#endif

typedef BOOL (CALLBACK *PROGRESSPROC)(int nTotalNumberOfImages, int nCurrentImage, void* lpUser);

/* TIFF RATIONALETYPE structure. */
#ifndef DEF_RATIO
#define DEF_RATIO
typedef struct tag_RATIO
{
    DWORD    dwNumer;
    DWORD    dwDenom;
} RATIO;
#endif

typedef enum tagTFILEFORMAT
{
    E_FORMAT_AUTO,              /* Auto detect from file header. */
    E_FORMAT_TIFF,              /* TIFF. */
    E_FORMAT_CALS,              /* CALS. */
} TFILEFORMAT;

typedef enum tagAnnoSaveModes
{
	SAVE_ANNO_CREATE = 1,
	SAVE_ANNO_APPEND,
} ANNOSAVINGMODES;

/* Ascii to bitmap conversion. */
typedef struct tagFAXPAGE
{
    char            szFileName[256];
    unsigned int    nPageWidth;
    unsigned int    nPageLength;
    unsigned int    nXmargin;
    unsigned int    nYmargin;
    char            szTypeFace[128];
    unsigned int    nFontPointSize;
    unsigned int    nXDPI;
    unsigned int    nYDPI;
    unsigned int    nLineSpace;
    unsigned int    szTabArray[16];
    DWORD           nFlags;
    LPLOGFONT       lpLogFont;
} FAXTOASCII, FAR *LPFAXTOASCII;

#ifndef RGB_LIMIT_STRUCT
#define RGB_LIMIT_STRUCT
typedef struct tagRGBLimit
{
	BYTE		lRed;
	BYTE		lGreen;
	BYTE		lBlue;
} RGBLIMIT;
#endif

/* --------------------------- Global Functions --------------------------- */

/* GROUP A: Opening and Closing TIFF Files */

TIFFFILE CALLBACK OpenTiffFile(LPSTR lpszFileName, int iMode);
TIFFFILE CALLBACK OpenTiffInMemory(HANDLE hHndl, DWORD dwSize, int iMode);
BOOL     CALLBACK CloseTiffFile(TIFFFILE hChain);
HANDLE   CALLBACK GetMemoryTiffHandle(TIFFFILE hChain);

/* GROUP B: Registering and Dropping TIFF Images */

BOOL     CALLBACK GetTiffImage(TIFFFILE hChain, int iImage);
int      CALLBACK DefineTiffImage(TIFFFILE hChain);
BOOL     CALLBACK DropTiffImage(TIFFFILE hChain, int nImage);
BOOL     CALLBACK IsTiffImageRegistered(TIFFFILE hChain, int iImage);


/* GROUP C: Retrieving or Defining TIFF File and Image Information */

BOOL     CALLBACK AddTiffTagToImage(LPSTR lpsFileName, int nImage, UINT wTagID,
                      UINT wType, LPSTR lpData, DWORD dwCount);

BOOL     CALLBACK DeleteTiffTagOfImage(LPSTR lpsFileName, int nImage, UINT wTagID);
BOOL     CALLBACK GetTiffFileInfo(TIFFFILE hChain, TIFFHDR FAR *Info);
BOOL     CALLBACK ModiTiffFileInfo(TIFFFILE hChain, LPSTR lpszFileName,
                      int nByteOrder);

BOOL     CALLBACK GetTiffImageInfoBuffer(TIFFFILE hChain, int iImage, UINT wTagID,
                      HANDLE FAR *lphData, UINT FAR *lpwType, DWORD FAR *lpdwCount);

BOOL     CALLBACK GetTiffImageInfo(TIFFFILE hChain, int iImage, UINT wTagID,
                      LPVOID lpData);

LONG     CALLBACK GetTiffImageDPI(TIFFFILE hChain, int iImage, LPLONG lpDPI);
int      CALLBACK GetTiffDimensions(TIFFFILE hChain, int nImage,
                      LPBITMAPINFOHEADER lpBIH);

HPALETTE CALLBACK GetTiffImagePalette(LPSTR lpszFileName, int nImage);
HANDLE   CALLBACK GetTiffRGBQuad(TIFFFILE hChain, int nImage);
UINT     CALLBACK GetTiffRowsPerStrip(TIFFFILE hChain, int nImage);
UINT     CALLBACK GetTiffStripCount(TIFFFILE hChain, int nImage);
BOOL     CALLBACK DefineTiffImageInfoBuffer(TIFFFILE hChain, int nImage,
                      UINT wTagID, LPVOID lpData, UINT wType, DWORD dwCount);

BOOL     CALLBACK DefineTiffImageInfo(TIFFFILE hChain, int nImage,
                      UINT wTagID, UINT wType, LONG lData);

int      CALLBACK DefineGeneralTags(TIFFFILE hChain, int nImage, BITMAP Bm);
int      CALLBACK DefineSpecialTags(TIFFFILE hChain, int nImage, UINT wSpecial);
LONG     CALLBACK SetTiffImageDPI(TIFFFILE hChain, int nImage, long lDPI);
BOOL     CALLBACK IsRequiredTag(WORD wTag);


/* GROUP D: Image Coding and Decoding Functions */

BOOL     CALLBACK DecodeTiffImage(TIFFFILE hChain, int nImage, UINT wFirstStrip,
                      UINT wNumLines, LONG lUserData, FILLPROC lpLineFn);

BOOL     CALLBACK DecodeCcittImage(int nFile, UINT wWidth, UINT wLength,
                      DWORD dwCompression, LONG lUserData, FILLPROC lpLineFn);

BOOL     CALLBACK DecodeCcittImageFrom(int nFile, long lOffset, UINT wWidth,
                      UINT wHeight, DWORD dwCompression, int nFillOrder,
                      UINT wByteOrder, LONG lUserData, FILLPROC lpLineFn);

BOOL     CALLBACK EncodeTiffImage(TIFFFILE hChain, int nImage, LONG lUserData,
                      FILLPROC lpLineFn);

BOOL     CALLBACK EncodeCcittImage(int nFile, UINT wWidth, UINT wHeight,
                      DWORD dwCompression, LONG lUserData,
                      FILLPROC lpLineFn);

BOOL     CALLBACK EncodeCcittImageTo(int nFile, UINT wWidth, UINT wHeight,
                      int nFillOrder, UINT wByteOrder,
                      DWORD dwCompression, LONG lUserData,
                      FILLPROC lpLineFn);

BOOL     CALLBACK SetKfactor(UINT wNewKfactor);


/* GROUP E: Information and Error Handling Functions */

int      CALLBACK NumberOfTiffImages(TIFFFILE hChain, UINT wImageType);
VOID     CALLBACK GetTiffVersion(LPSTR lpBuffer, int nMaxByte);
int      CALLBACK TiffError(void);
int      CALLBACK SetTiffError(int nError);
LPSTR    CALLBACK TiffErrorString(LPSTR lpszErrorStr, int nError);


/* GROUP F: High Level Functions */

int      CALLBACK GetNumberOfImagesInTiffFile(LPSTR lpszName);
//BOOL     CALLBACK DecompressTiffToScreen(HWND hWnd, HDC hDC, LPSTR szFileName,
//                      int nImage, LPRECT lprScale, UINT wMode);

BOOL     CALLBACK DecompressToScreen(TFILEFORMAT nFormat, HWND hWnd, HDC hDC,
                      LPSTR lpFileName, int nImage, LPRECT lprScale, UINT wMode);

HBITMAP  CALLBACK LoadTiffChainIntoBitmap(TIFFFILE hChain, int nImage);
HANDLE  CALLBACK LoadTiffChainIntoDIB(TIFFFILE hChain, int nImage);
HBITMAP  CALLBACK LoadTiffIntoBitmap(LPSTR lpszFileName, int nImage,
                      BOOL bDispInfo);
HANDLE CALLBACK SaveTiffToMemory(HANDLE hTiffInMemory, HANDLE hDIB,
                      UINT wCompMode, int nFillOrder);

HANDLE   CALLBACK LoadTiffIntoDIB(LPSTR lpszFileName, int nImage,
                      BOOL bDispInfo);

HANDLE   CALLBACK LoadNonRGBTiffIntoDIB(LPSTR lpszFileName, int nImage);

BOOL     CALLBACK LoadTiffFileIntoClipboard(LPSTR lpszFileName, int nImage,
                      BOOL bDispInfo);

BOOL     CALLBACK SaveBitmapInCcittFile(LPSTR lpszFileName, HBITMAP hBitmap,
                      UINT wCompression);

BOOL     CALLBACK SaveBitmapInTiffFile(LPSTR lpszFileName, HBITMAP hBitmap,
                      UINT wCompMode, BOOL DisplayDlg);

BOOL     CALLBACK SaveBitmapInTiffFileExt(LPSTR lpszFileName, HBITMAP hBitmap,
                      UINT wCompMode, BOOL DisplayDlg, int nFillOrder);

BOOL     CALLBACK SaveDIBInTiffFile(LPSTR lpszFileName, HANDLE hDIB,
                      UINT wCompMode, BOOL DisplayDlg);

BOOL	CALLBACK SaveTiffForCiscoFormat(LPSTR lpszFileName, HANDLE hDIB,
                      UINT wCompMode, int nFillOrder, BOOL DisplayDlg);

BOOL	CALLBACK ConvertTiffToCiscoFormat(LPSTR lpszFileName);

BOOL     CALLBACK SaveDIBInTiffFileExt(LPSTR lpszFileName, HANDLE hDIB,
                      UINT wCompMode, BOOL DisplayDlg, int nFillOrder);

BOOL	 CALLBACK SaveNonRGBDIBInTiffFile( LPSTR   lpszFileName,
                                  HANDLE  hDIB);

BOOL     CALLBACK SaveDIBInBicomTiffFile(LPSTR lpszFileName, HANDLE hDIB);
BOOL     CALLBACK SaveDIBInDialogicTiffFile(LPSTR lpszFileName, HANDLE hDIB, UINT wCompMode);
BOOL     CALLBACK SaveDIBInGammaTiffFile(LPSTR lpszFileName, HANDLE hDIB, UINT wCompMode,
                      BOOL DisplayDlg, int nFillOrder);

BOOL     CALLBACK SaveDIBInNMSTiffFile(LPSTR lpszFileName, HANDLE hDIB);
BOOL     CALLBACK SaveTiffFileFromClipboard(LPSTR lpszFileName, UINT wCompMode,
                      BOOL DisplayDlg);

int		 CALLBACK GetTiffColorSpace(LPSTR pszFileName, int nImage);

/* These functions were created to unify naming conventions with Bitmani and Image SDK. */
/* Same as 'LoadTiffIntoBitmap()' */
HBITMAP  CALLBACK LoadTiffFileIntoBitmap(LPSTR lpszFileName, int nImage,
                      BOOL bDispInfo);

/* Same as 'SaveBitmapInTiffFile()' */
BOOL     CALLBACK SaveBitmapInTiffFormat(LPSTR lpszFileName, HBITMAP hBitmap,
                      UINT wCompMode, BOOL DisplayDlg);

/* Same as 'SaveDIBInTiffFile()' */
BOOL     CALLBACK SaveDIBInTiffFormat(LPSTR lpszFileName, HANDLE hDIB,
                      UINT wCompMode, BOOL DisplayDlg);

int      CALLBACK WriteTiffImageDirectory(TIFFFILE hChain, int nImage);
BOOL     CALLBACK CopyTiffImageInFile(LPSTR lpFileFrom, int nImageFrom,
                      LPSTR lpFileTo, int nMode);

BOOL     CALLBACK CopyTiffImage(TIFFFILE hTiffFrom, int nImageFrom, TIFFFILE hTiffTo);
LPSTR    CALLBACK AppendCCITTImageFile(LPSTR lpszDestFileName,
                      LPSTR lpszTIFFFileName, int nImage, int nSkipLinesCnt);

BOOL     CALLBACK UpdatePageNumbers(LPSTR lpszFileName, int nPages);
BOOL     CALLBACK InsertTiffImage(LPSTR lpszFileName, HANDLE hDIB, UINT wCompMode,
                      BOOL DisplayDlg, int nFillOrder, int nImage, BOOL bFast, BOOL bChange);

BOOL     CALLBACK DeleteTiffImage(LPSTR lpszFileName, int nImage, BOOL bFast);
BOOL     CALLBACK ReorderTiffFile(LPSTR lpszFileName);

BOOL	 CALLBACK SplitTiffFile(LPCSTR szSourceFileName, LPCSTR szNewFileName, int nImage, PROGRESSPROC lpCallBackFunction, void* lpUser);
BOOL	 CALLBACK CutTiffFile(LPCSTR szSourceFileName, LPCSTR szPrefixFileName, int nImage, PROGRESSPROC lpCallBackFunction, void* lpUser);
BOOL     CALLBACK MergeTiffFiles(LPCSTR szDestinationFileName, LPCSTR szFileName, PROGRESSPROC lpCallBackFunction, void* lpUser);
int		 CALLBACK FindBlankPage(LPCSTR szTiffFileName, int nRatio, int iPage, RGBLIMIT sBlankLimit);
int		 CALLBACK FindBlackPage(LPCSTR szTiffFileName, int nRatio, int iPage, RGBLIMIT sBlankLimit);

/* GROUP G: Annotation Functions */

long     CALLBACK LoadAnnotationFromTiff(LPSTR lpszFileName, UINT wTag);
BOOL     CALLBACK SaveAnnotationIntoTiff(LPSTR lpszFileName, long lAnno, UINT wTag);
BOOL	 CALLBACK SaveAnnotationIntoTiffExt( LPSTR lpszFileName, long lAnno, UINT wTag, BYTE bySaveMode, int iAnnoPage, int iTiffPage );


/* GROUP H: Text Functions */

UINT     CALLBACK CreateBMPFaxPageFromASCII(LPFAXTOASCII, UINT, HANDLE far *, int far *);
UINT     CALLBACK CreateDIBFaxPageFromASCII(LPFAXTOASCII, UINT, HANDLE far *, int far *);
UINT     CALLBACK CreateFaxPageFromASCII(LPFAXTOASCII, UINT, HANDLE far *, UINT, HBITMAP,
                      int far *);

UINT     CALLBACK CreateMultiPageFromASCII(LPFAXTOASCII lpAscii, UINT nMaxPages,
                      HANDLE far *szHandleArray, UINT bmp_dib, HBITMAP hDstBmp,
                      int yStart, int far *error);

HBITMAP  CALLBACK BitmapFormOverlay(LPSTR tiffFileName, LPFAXTOASCII textFile);
HANDLE   CALLBACK DIBFormOverlay(LPSTR tiffFileName, LPFAXTOASCII textFile);
int      CALLBACK DIBFormOverlayExt(LPSTR tiffFileName, LPFAXTOASCII lpTextFile,
                      HANDLE far *HandleArray, int nMaxPages, int yStart);

HBITMAP  CALLBACK BitmapTextOverlay(HBITMAP hBitmap, int nX, int nY,
                      LPSTR lpTextString, LPSTR lpFontTypeFace,
                      int nFontPointSize, int nXDPI, int nYDPI);

HANDLE   CALLBACK DIBTextOverlay(HANDLE hDib, int nX, int nY,
                      LPSTR lpTextString, LPSTR lpFontTypeFace,
                      int nFontPointSize);

#endif


/* ----------------------------- End of file ------------------------------ */
