/****************************************************************************/
/* bitmani.h (c) Copyright Black Ice Software, Inc.  1989 - 2001            */
/*           All Rights Reserved                                            */
/*           Unpublished and confidential material.                         */
/*           --- Do not Reproduce or Disclose ---                           */
/****************************************************************************/

#ifndef _BITMANI_H_
#define _BITMANI_H_

#define COMB_OPAQUE            0
#define COMB_TRANSPARENT       1


// Punch Hole Standards
#define EU5MM				0
#define USA1_4INCH			-1
#define USA9_32INCH			-2
#define USA11_32INCH		-3


typedef HGLOBAL HDIB;
typedef HGLOBAL HDIB32;

typedef struct tagXCoord {
    POINT pLeftTop;
    POINT pRightTop;
    POINT pRightBottom;
    POINT pLeftBottom;
} XCOORD;

/* COORD is used in WIN32 so we change COORD to XCOORD    NGY  */

typedef XCOORD far *  LPXCOORD;



typedef enum tag_IMGERR
{
    IOK,                  /* Operation was successful. */
    INOTENOUGHMEMORY,     /* Not enough memory to allocate block. */
    IDCCREATEERROR,       /* Unable to create DC. */
    IFILEOPENERROR,       /* Can't open file. */
    IFILEIOERROR,         /* General I/O error in reading or writing. */
    ICLIPOPENERROR,       /* Can't open clipboard. */
    ICLIPRECERROR,        /* Could not receive from clipboard. */
    IBITCOPYERROR,        /* Can't copy bits from bitmap. */
    IPARAMETERERROR,      /* Parameter error. */
    IFILEFORMAT,          /* Invalid file format. */
    ICREATEPALETTE,       /* Can't create palette. */
    ICREATEBITMAP,        /* Can't create bitmap. */
    IMETAMAPMODEERROR,    /* Mapping mode is improperly set in metafile. */
    IINVALIDBITSPIXEL,    /* Invalid bit/pixel value. */
    IFORMATNOTFOUND,      /* Format not found in clipboard file. */
    IGETOBJECT,           /* Can't get bitmap parameters. */
    IMETAERROR,           /* Can't create metafile. */
    ILOCKMEMORY,          /* Can't lock global memory. */
    IDIBCOMPRESSED,       /* DIB must be uncompressed. */
    ISIZEERROR,           /* Invalid DIB size. */
    IREJECTPARAM,         /* Paramater error in Dithering. */
    IBADBITPIXEL,         /* Bad bit/pixel value in DIB header. */
    IBADCAPIXPARAM,       /* The CAPIX algorithm creates only 1 or 4 bit image. */
    IMG_PRINTERDC,        /* Could not get printer DC. */
    IMG_PRINTERRASTER,    /* Device not capable to handle raster. */
    IMG_PRINTERAPPDC,     /* Could not get dispaly DC. */
    IMG_PRINTERESC4,      /* Escape failed SETABORTPROC. */
    IMG_PRINTERESC5,      /* Escape failed STARTDOC. */
    IMG_PRINTERESC6,      /* Escape failed NEXTBAND. */
    IMG_CLIPBOARD,        /* Clipboard error. */
    IMG_PRINTCANCEL,      /* User cancels the printing. */
    INOTHINGTODO,         /* Nothing to do. */
    IPAGENOTFOUND         /* Unable to find a scanned page for cropping. */
} TIMGERR;

typedef enum tag_LOADSAVEIMGERR
{
	LS_OK, // 0

	// COLORFAX, BITMAP, CLIPBOARD, WMF, EMF File
    LS_INOTENOUGHMEMORY,     /* Not enough memory to allocate block. */
    LS_IDCCREATEERROR,       /* Unable to create DC. */
    LS_IFILEOPENERROR,       /* Can't open file. */
    LS_IFILEIOERROR,         /* General I/O error in reading or writing. */
    LS_ICLIPOPENERROR,       /* Can't open clipboard. */
    LS_ICLIPRECERROR,        /* Could not receive from clipboard. */
    LS_IBITCOPYERROR,        /* Can't copy bits from bitmap. */
    LS_IPARAMETERERROR,      /* Parameter error. */
    LS_IFILEFORMAT,          /* Invalid file format. */
    LS_ICREATEPALETTE,       /* Can't create palette. */
    LS_ICREATEBITMAP,        /* Can't create bitmap. */
    LS_IMETAMAPMODEERROR,    /* Mapping mode is improperly set in metafile. */
    LS_IINVALIDBITSPIXEL,    /* Invalid bit/pixel value. */
    LS_IFORMATNOTFOUND,      /* Format not found in clipboard file. */
    LS_IGETOBJECT,           /* Can't get bitmap parameters. */
    LS_IMETAERROR,           /* Can't create metafile. */
    LS_ILOCKMEMORY,          /* Can't lock global memory. */
    LS_IDIBCOMPRESSED,       /* DIB must be uncompressed. */
    LS_ISIZEERROR,           /* Invalid DIB size. */
    LS_IREJECTPARAM,         /* Paramater error in Dithering. */
    LS_IBADBITPIXEL,         /* Bad bit/pixel value in DIB header. */
    LS_IBADCAPIXPARAM,       /* The CAPIX algorithm creates only 1 or 4 bit image. */
    LS_IMG_PRINTERDC,        /* Could not get printer DC. */
    LS_IMG_PRINTERRASTER,    /* Device not capable to handle raster. */
    LS_IMG_PRINTERAPPDC,     /* Could not get dispaly DC. */
    LS_IMG_PRINTERESC4,      /* Escape failed SETABORTPROC. */
    LS_IMG_PRINTERESC5,      /* Escape failed STARTDOC. */
    LS_IMG_PRINTERESC6,      /* Escape failed NEXTBAND. */
    LS_IMG_CLIPBOARD,        /* Clipboard error. */
    LS_IMG_PRINTCANCEL,      /* User cancels the printing. */
    LS_INOTHINGTODO,         /* Nothing to do. */
    LS_IPAGENOTFOUND,         /* Unable to find a scanned page for cropping. */ // 32

	// TIFF, CALS File
    LS_TNOTENOUGHMEMORY,       /* Not enough memory to allocate block. */
    LS_TBADOPENMODE,           /* Not T_READ or T_CREAT in OpenTiffFile(). */
    LS_TINDEXOUTOFRANGE,       /* Image or tag data index is out of range. */
    LS_TSTRIPOUTOFRANGE,       /* Strip index is out of range. */
    LS_TENDOFDATA,             /* Unexpected end of file in reading data. */
    LS_TFILEIOERROR,           /* General I/O error in reading or writing. */
    LS_TPATHTOOLONG,           /* Pathname is longer than MAXPATH. */
    LS_TNOTTIFFILE,            /* File has not a valid TIFF format. */
    LS_TBADTAG,                /* Invalid TIFF directory tag. */
    LS_TTOOFEWINFO,            /* Indispensable tags are missing. */
    LS_TUNKNOWNCOMPRESSION,    /* Image compression type is not known. */
    LS_TCOMPRESSIONFAILED,     /* Error during compression or decompression. */
    LS_TNOSUCHTAG,             /* Such tag is not defined. */
    LS_TBADBYTEORDER,          /* Invalid byte order ID in ModiTiffFileInfo(). */
    LS_TBADBITORDER,           /* Invalid BITORDER tag value. */
    LS_TBADNUMBEROFCOLORS,     /* Invalid BITSPERPIXEL tag value. */
    LS_TTOFEWCOLORINFO,        /* Color info is not enough. */
    LS_TNOTCALSFILE,           /* File has not a valid CALS format. */
    LS_TNOEOFB,                /* End of Facsimile Block is missing (EOFB). */
    LS_TBADEOFB,               /* Unexpected End of Facsimile Block (EOFB). */
    LS_TBADWIDTH,              /* Image width must be 1728 pixels (Can't save it). */
    LS_TNOJPEGDLL,             /* Module JPEG DLL is not found. */
    LS_TBADJPEGDLL,            /* Can't find a function in module JPEG DLL. */
    LS_TFORMATCLIPBOARD,       /* Clipboard format is not bitmap. */
    LS_TOPENCLIPBOARD,         /* Could not open clipboard. */
    LS_TRECEIVECLIPBOARD,      /* Could not receive bitmap from clipboard. */
    LS_TIMAGENOTREGISTERED,    /* Image is not registered. */
	LS_TNOBIDLGS,				  /* BiDlgs.dll does not exist. */	// 60

	// PCX DCX FILE
	LS_PCX_BUF_ALLOC,			// unable to allocate buffers
	LS_PCX_UNKNOWN_VERSION,		// uninterpreatable version
	LS_PCX_UNKNOWN_ENCODING,	// possibly PCX, but doesn't use ZSoft encoding
	LS_PCX_FILEOPEN,			// unable to open file
	LS_PCX_BITMAP,				// unable to create bitmap
	LS_PCX_CLIP_OPEN,			// unable to open clipboard
	LS_PCX_HDC,					// unable to create compatible DC
	LS_PCX_TOO_SPECIAL_FORMAT,	// too hardware dependent bitmap
	LS_PCX_BAD_PALETTE,			// error in reading palette info
	LS_PCX_ERROR_GLOCK,			// global and local lock error
	LS_PCX_ERROR_GALLOC,		// global and local alloc error
	LS_PCX_ERROR_USERFUNC,		// userfunction return with FALSE
	LS_PCX_ERROR_BITMAPFORMAT,	// PCX file and bitmap is not same type
	LS_PCX_ERROR_GETCLIPBOARD,	// error in GetClipboardData function
	LS_PCX_ERROR_READ,			// error in _lread
	LS_PCX_ERROR_WRITE,			// error in _lwrite
	LS_PCX_ERROR_IO,			// file I/O error
	LS_PCX_ERROR_COLORSPACE,	// Inavlid color space	
	LS_DCX_ERROR_INVALIDITEM,	// reference to non-exist item number
	LS_DCX_ERROR_BADFILETYPE,	// bad DCX file identifier
	LS_DCX_ERROR_BADOFFSET,		// bad item offset in DCX header
	LS_DCX_ERROR_DISKSPACE,		// not enough disk space for file operation
	LS_DCX_ERROR_DCXFULL,		// no empty entry in DCX header
	LS_DCX_ERROR_DELETEFILE,	// unable to delete file
	LS_DCX_ERROR_RENAMEFILE,	// unable to rename file
	LS_DCX_ERROR_EMPTY,			// no image in DCX-file				// 86

	// GIF File
    LS_GNOTENOUGHMEMORY,        // Not enough memory to allocate block.
    LS_GBADOPENMODE,            // Not G_READ or G_CREAT in OpenGifFile().
    LS_GINDEXOUTOFRANGE,        // Image index is out of range.
    LS_GENDOFDATA,              // Unexpected end of file in reading data.
    LS_GFILEIOERROR,            // General I/O error in reading or writting.
    LS_GPATHTOOLONG,            // Pathname is longer than MAXPATH.
    LS_GNOTGIFFILE,             // File has not a valid GIF format.
    LS_GCOMPRESSIONFAILED,      // Error during compression or decompression.
    LS_GBADNUMBEROFCOLORS,      // Invalid BITSPERPIXEL value.
    LS_GCLIPOPEN,                // Can't open clipboard				// 96

	// TGA File

   LS_TGA_ERROR_GALLOC,             /* error during global alloc */
   LS_TGA_ERROR_GLOCK,              /* error during global lock */
   LS_TGA_ERROR_LALLOC,             /* error during local alloc */
   LS_TGA_ERROR_LLOCK,              /* error during local lock */
   LS_TGA_ERROR_ORIG_GALLOC,        /* error during global alloc for TGAOriginalFile */
   LS_TGA_ERROR_ORIG_GLOCK,         /* error during global lock for TGAOriginalFile */
   LS_TGA_ERROR_SCAN_GALLOC,        /* error during global alloc for ScanLineTable */
   LS_TGA_ERROR_SCAN_GLOCK,         /* error during global lock for ScanLineTable */
   LS_TGA_ERROR_EXT_GALLOC,         /* error during global alloc for TGAExtDevArea */
   LS_TGA_ERROR_EXT_GLOCK,          /* error during global lock for TGAExtDevArea */
   LS_TGA_ERROR_EXT_SIZE,           /* extension area size incorrect */
   LS_TGA_ERROR_FILLEXT,            /* error during filling up extension are struct */
   LS_TGA_ERROR_DEV_GALLOC,         /* error during global alloc for Developer Area */
   LS_TGA_ERROR_DEV_GLOCK,          /* error during global lock for Developer Area */
   LS_TGA_ERROR_STAMP_GALLOC,       /* error during global alloc for Postage Stamp */
   LS_TGA_ERROR_STAMP_GLOCK,        /* error during global lock for Postage Stamp */
   LS_TGA_ERROR_CORR_GALLOC,        /* error during global alloc for Correction Table */
   LS_TGA_ERROR_CORR_GLOCK,         /* error during global lock for Correction Table */
   LS_TGA_ERROR_FILE_CORRUPTED,     /* file corrupted or incorrect format */
   LS_TGA_ERROR_NEWFILE_CORRUPTED,  /* New TGA file corrupted or incorrect
                                  * format above Original Area */
   LS_TGA_ERROR_NOT_NEW_FORMAT,     /* the given function cannot operate on
                                  * original or unknown TGA file format */
   LS_TGA_ERROR_NOT_ENCODED,        /* user hasn't run EncodeTGAFile function */
   LS_TGA_ERROR_BITMAP,             /* error in data of BitmapInfoHeader */
   LS_TGA_ERROR_IMAGETYPE,          /* unknow TGA image type */
   LS_TGA_ERROR_NO_CLRMAP,          /* no color map data in TGA file */
   LS_TGA_ERROR_NO_EXTAREA,         /* no extension area in TGA file */
   LS_TGA_ERROR_NO_DEV,             /* no developer area in TGA file */
   LS_TGA_ERROR_NO_CLRCORR,         /* no color correction table in TGA file */
   LS_TGA_ERROR_NO_STAMP,           /* No Postage Stamp Data in TGA file */
   LS_TGA_ERROR_BUF_GALLOC,         /* buffer alloc error */
   LS_TGA_ERROR_BUF_GLOCK,          /* buffer lock error */
   LS_TGA_ERROR_CONV,               /* conversation error */
   LS_TGA_ERROR_SCANLINE_GALLOC,    /* no space for scan line table */
   LS_TGA_ERROR_HDC,                /* hDC error */
   LS_TGA_ERROR_PALETTE,            /* palette creating error */
   LS_TGA_ERROR_SET_DIBITS,         /* SetDIBits error */
   LS_TGA_ERROR_GET_DIBITS,         /* GetDIBits error */
   LS_TGA_ERROR_CREAT_BITMAP,       /* CreateDIBitmap error */
   LS_TGA_ERROR_IO,                 /* File I/O error */
   LS_TGA_ERROR_DOSFILE,             /* must be added to dos error code */	// 136

   // PNG File
	LS_PNGERR_CREATE,				//unable to create file
	LS_PNGERR_OPEN,					//file not found
	LS_PNGERR_MEMORY,				//not enuogh memory
	LS_PNGERR_HANDLE,				//invalid bitmap or DIB handle
	LS_PNGERR_READING,				//error occured while loading
	LS_PNGERR_WRITING,				//error occured while saving
	LS_PNGERR_CREATEDIBITMAP,		//unable to create DIB
	LS_PNGERR_GETDIBITS,			//unable to get DIB
	LS_PNGERR_PALETTE,				//palette missing
	LS_PNGERR_BITDEPTHORALPHA,		//unsupported bit depth or alpha channel exist //146

	// PDF File
	LS_WINAPI_GETLASTERROR,		
	LS_INVALID_HANDLLS_VALUE,	
	LS_FILLS_ALREADY_EXISTS,
	LS_INVALID_IMAGLS_SIZE,
	LS_INVALID_BITSPERPIXEL,
	LS_INVALID_STRING,
	LS_NULL_POINTER,
	LS_ZERO_BYTES_TO_WRITE,
	LS_INVALID_DPI,
	LS_MEMORY_ALLOCATION_ERROR,
	LS_OBJECT_ALREADY_EXISTS,
	LS_TOO_MANY_OBJECTS,
	LS_INVALID_RESOURCLS_TYPE,
	LS_INVALID_STREAM_SIZE,
	LS_FILTER_NOT_SUPPORTED,
	LS_NEGATIVLS_VALUE,
	LS_TEMP_DIRECTORY_ERROR,
	LS_TEMPFILLS_ERROR,
	LS_INVALID_TIFF_DLL,
	LS_ENCODING_FAILED,
	LS_INVALID_JPEG_DLL,
	LS_INVALID_PARAMETER,
	LS_OPEN_FILLS_ERROR,
	LS_NOT_PDF_FILE,					
	LS_PDF_VERSION_NOT_SUPPORTED,
	LS_READ_FILLS_ERROR,
	LS_ERROR_DURING_DECOMPRESSION,
	LS_INVALID_PALETTE,
	LS_COMPRESSION_NOT_SUPPORTED,
	LS_CCITT_DECODING_FAILED,
	LS_INVALID_PAGLS_NUMBER,									
	LS_PDF_OBJECT_NOT_INITIALIZED_USLS_INITPDF,	// 178	

	LS_UNSPECIFIED_ERROR
} LOADSAVEIMGERR;



typedef struct tag_SIZE
{
    int         x;
    int         y;
} XYSIZE;

#ifndef RGB_LIMIT_STRUCT
#define RGB_LIMIT_STRUCT
typedef struct tagRGBLimit
{
	BYTE		lRed;
	BYTE		lGreen;
	BYTE		lBlue;
} RGBLIMIT;
#endif

typedef XYSIZE FAR *LPXYSIZE;

typedef struct tag_DibInfo
{
	long width;
	long height;
	int  bitCount;
	long dpiX;
	long dpiY;
	int  format;
} DIBINFO;

typedef DIBINFO FAR *LPDIBINFO;

typedef struct tagSIZEFLOAT
{
	float	sizeX;
	float	sizeY;
} SIZEFLOAT;

typedef SIZEFLOAT FAR *LPSIZEFLOAT;



typedef enum tag_FILEFORMAT {
    UNKNOWN_FILE,
    TIFF_FILE,
    PCX_FILE,
    DCX_FILE,
    GIF_FILE,
    TGA_FILE,
    BMP_FILE,
    WMF_FILE,
    CLP_FILE,
    FAX_FILE,
    ASCII_FILE,
    ALL_FILE,

    CALS_FILE,
    JPEG_FILE,
    PNG_FILE,
	EMF_FILE,
	PDF_FILE = 18,
} FILEFORMAT;

/* Bitmap functions */
HBITMAP  CALLBACK RotateBitmap90(HBITMAP hBitmapOld);
BOOL     CALLBACK RotateBitmap180(HBITMAP hBitmap);
HBITMAP  CALLBACK RotateBitmap270(HBITMAP hBitmapOld);
BOOL     CALLBACK InvertBitmap(HBITMAP hbitSource);
BOOL     CALLBACK FlipBitmapVertical(HBITMAP hBitmap);
BOOL     CALLBACK FlipBitmapHorizontal(HBITMAP hBitmap);
void     CALLBACK GetImageVersion(LPSTR lpBuffer, int nMaxByte);
HBITMAP  CALLBACK LoadBitmapFromFile(LPSTR szFileName);
BOOL     CALLBACK SaveBitmap(LPSTR szFile, HBITMAP hBitmap, HPALETTE hPal);

/* DIB functions */
HDIB CALLBACK CropDIB(HDIB hDib, long LeftPosition, long TopPosition, 
					  long RightPosition, long BottomPosition);
BOOL	 CALLBACK CutDIB(HDIB hDib, DWORD height, HDIB *hDib1, HDIB *hDib2);
HDIB	 CALLBACK SkewDIB(HDIB, BOOL, int, LPINT, LPXCOORD);
HANDLE	 CALLBACK LinearShearing(HANDLE hDIB1, double a, double b, LPINT nErr, BOOL bShowDialog, HWND hParent);

HDIB     CALLBACK ExpandCompressedDIB(HDIB);
HDIB     CALLBACK ScaleGrayDIB(HDIB, short, short, short, short, short, short, short);
HANDLE   CALLBACK Halftone(HANDLE hDIB, WORD nMethode, int nIntControl, LPWORD lpErrCode);
HANDLE   CALLBACK ConvColorDIBtoGrayscale(HANDLE hDIB1, UINT nMethode, BOOL bPsychovisual);
int		 CALLBACK IsImageBlank(HDIB hDib, int nRatio, RGBLIMIT sBlankLimit);
int		 CALLBACK IsImageBlack(HDIB hDib, int nRatio, RGBLIMIT sBlankLimit);
HDIB     CALLBACK CompressDIB(HDIB);
void	 CALLBACK InvertMonoDIB( HANDLE hDIB );
HANDLE   CALLBACK LoadDIBFromFile(LPSTR szFileName);
HANDLE   CALLBACK ReadDIBInfo(int fh);
BOOL     CALLBACK SaveDIB(LPSTR szFile, HANDLE hdib);
BOOL	 CALLBACK SetDIBDPI(HDIB hDib, UINT xDPI, UINT yDPI);

HANDLE CALLBACK RotateDIB90(HANDLE hbmOld);
HANDLE CALLBACK RotateDIB180(HANDLE hbmSource);
HANDLE CALLBACK RotateDIB270(HANDLE hbmOld);
HANDLE CALLBACK RotateDIB(HANDLE hDIB, double dIncrement);
BOOL   CALLBACK InvertDIBPalette(HANDLE hDib);

HANDLE   CALLBACK Convert8to24(HANDLE hDIB1);
HANDLE   CALLBACK ConvertBitmapToDIB(HBITMAP hBitmap, HPALETTE hPal);
HBITMAP  CALLBACK ConvertDIBToBitmap(HANDLE hDIB);
HPALETTE CALLBACK CreateDIBPalette(HANDLE hDIB);
HBITMAP  CALLBACK ConvertToMonochromeBitmap(HBITMAP hBm);
HDIB     CALLBACK ConvertToMonochromeDIB(HDIB hDIB, int nIntControl);
HANDLE   CALLBACK ConvertMonoDIBtoGrayscale(HANDLE hDIB1, UINT nMethode);
HANDLE   CALLBACK ConvMonoDIBtoGrayscale(HANDLE hDIB1, UINT nMethode);

HBITMAP  CALLBACK DuplicateBitmap(HBITMAP hbmOld);
HANDLE   CALLBACK DuplicateDIB(HANDLE hHandle);
HANDLE   CALLBACK ScaleDIB(HANDLE hDIB, UINT nMethode, XYSIZE nSize);

UINT  CALLBACK CombineBMP(int X, int Y, HBITMAP *hDest, HBITMAP hSrc, HBITMAP hMask, DWORD dwMode);
UINT  CALLBACK CombineDIB(int X, int Y, HANDLE *hDest, HANDLE hSrc, HANDLE hMask, DWORD dwMode);

VOID  CALLBACK Zoom(HWND hWnd, LONG lStartPos, LPRECT lprScale);

HANDLE	CALLBACK CreateEmptyDIB(SIZE lImageSize, LONG lXRes, LONG lYRes, BYTE byBitCount, BOOL bIsWhite);
HANDLE  CALLBACK CreateEmptyDIBByInchAndDPI(SIZEFLOAT lImageSizeInInch, LONG lXRes, LONG lYRes, BYTE byBitCount, BOOL bIsWhite);
HANDLE  CALLBACK CreateEmptyDIBByInchAndPixel(SIZEFLOAT lImageSizeInInch, SIZE lImageSize, BYTE byBitCount, BOOL bIsWhite);
HANDLE  CALLBACK CreateEmptyDIBByMMAndDPI(SIZE lImageSizeInMM, LONG lXRes, LONG lYRes, BYTE byBitCount, BOOL bIsWhite);
HANDLE  CALLBACK CreateEmptyDIBByMMAndPixel(SIZE lImageSizeInMM, SIZE lImageSize, BYTE byBitCount, BOOL bIsWhite);

/* ASCII file format */
HBITMAP    CALLBACK LoadASCIIFile(LPSTR lpszFileName, BOOL bAnsi);
HBITMAP    CALLBACK LoadASCIIIntoBitmap(HANDLE hMem);

/*  COLORFAX    file format     */
int        CALLBACK GetNumberOfImagesInFaxFile(LPSTR);
HDIB       CALLBACK LoadColorFaxPage(LPSTR, int, LPINT);

/* Clipboard format */

HBITMAP    CALLBACK LoadClipboardFormat(LPSTR lpszFileName, UINT wFormat);
BOOL       CALLBACK SaveClipboardFormat(LPSTR lpszFileName, HBITMAP hBitmap);

/* METAFILE format */
HBITMAP    CALLBACK LoadMetaFileIntoBitmap(LPSTR);
BOOL       CALLBACK SaveBitmapIntoMetaFile(HDC hDC, HBITMAP hBitmap, LPSTR lpszFileName );
BOOL       CALLBACK SaveBitmapIntoEnhMetaFile(HDC hDC, HBITMAP hBitmap, LPSTR lpszFileName );
BOOL       CALLBACK SaveDIBIntoMetaFile(LPSTR lpszFileName, HANDLE hDib );
BOOL	   CALLBACK SaveDIBIntoEnhMetaFile( LPSTR lpszFileName, HANDLE hDib );
HBITMAP  CALLBACK PlaceMetaFileIntoBMPFromCLP(HWND);
HANDLE   CALLBACK PlaceMetaFileIntoDIBFromCLP(HWND);
HBITMAP    CALLBACK DrawMetaFileIntoBitmap(HANDLE, int, int, BOOL);

/*  ALL         file format     */
HDIB       CALLBACK LoadImageIntoDIB(LPSTR, int, LPINT);
FILEFORMAT CALLBACK GetImageFormat(LPSTR);
BOOL       CALLBACK SaveDIBInImageFormat(LPSTR, HANDLE, int, int, int);
BOOL CALLBACK SaveDIBInImageFormatExt(LPSTR lpszName,
                                     HANDLE hDIB,
                                     int nFormat,
                                     int nImage,
                                     int nCompress,
									 int nFillOrder,
									 BOOL bDialog);
UINT CALLBACK GetNumberOfImagesInFile(LPSTR szFileName, LPINT lpnErr);
int CALLBACK GetImageInfoStructure(LPSTR szFileName, int nImage, LPDIBINFO dibInfo);

/* ERROR handling */
LPSTR CALLBACK BitmaniErrorString(LPSTR lpszErrorStr, int nError);
int   CALLBACK BitmaniError(void);
int   CALLBACK SetBitmaniError(int nError);


/* Other functions */
HANDLE CALLBACK FlipDIBVertical(HANDLE hDib);
HANDLE CALLBACK FlipDIBHorizontal(HANDLE hDib);

UINT     CALLBACK PaletteSize(LPSTR lpbi);
HPALETTE CALLBACK GetCurrentPalette(void);
BOOL     CALLBACK GetSystemPalette(RGBQUAD FAR *lpColor);

BOOL     CALLBACK GetLowMemStretch(void);
BOOL     CALLBACK SetLowMemStretch(BOOL bFlag);

VOID   CALLBACK ZoomRect(HWND hWnd, LONG lStartPos, LPRECT lprScale);

BOOL   CALLBACK SplitDIB(HANDLE hInputDIB, SIZE ItemSize, LPHANDLE lphOutDIBs, LPSIZE lpExtension);
HANDLE CALLBACK MergeDIBs(HANDLE hInputDIBs, SIZE Extension);

int CALLBACK DisplayGetStretchBltMode();
int CALLBACK DisplaySetStretchBltMode(int iNewDisplayStretchBltMode);

BOOL	CALLBACK	GetDIBPixelColor(HANDLE hDIB, DWORD x, DWORD y, COLORREF* pColor);
BOOL	CALLBACK	SetDIBPixelColor(HANDLE hDIB, DWORD x, DWORD y, COLORREF Color);
int		CALLBACK	LookupColorInDIBPalette(HDIB hDIB, COLORREF Color);

// 32 bit per pixel DIB handling functions
HDIB32 CALLBACK Load32BitDIB(LPCSTR pszFileName);
HDIB CALLBACK	Convert32BitDIBTo24Bit(HDIB32 hDib);
BOOL CALLBACK	Save32BitDIB(LPCSTR pszFileName, HDIB h24BitDib, HDIB32 h32BitDib);
BYTE CALLBACK	GetBMPBitDepth(LPCSTR pszFileName);
HDIB CALLBACK	LoadNonRGBDIB(LPCSTR pszFileName);
BOOL CALLBACK	SaveNonRGBDIB(LPCSTR pszFileName, HDIB hDib);
DWORD CALLBACK	GetDIBColorSpace(HDIB hDib);
DWORD CALLBACK	GetBMPColorSpace(LPCSTR pszFileName);

#endif /* _BITMANI_H_ */
