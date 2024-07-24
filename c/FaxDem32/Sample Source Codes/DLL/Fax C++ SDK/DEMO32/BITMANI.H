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

#define DISP_NORMAL            4
#define DISP_PREVIEW           8
#define DISP_INVERT           32
#define DISP_SCALED           64
#define DISP_ZOOMED           64
#define DISP_CENTER          128
#define DISP_FITSCREEN       256
#define DISP_NOVERTSCROLL    512
#define DISP_NOHORZSCROLL   1024
#define DISP_NEWDIB         2048
#define DISP_FITTOWIDTH     4096

/* These are only for SCREEN zoom */
#define BIS_SCALENORMAL        4
#define BIS_FITTOSCREEN        8
#define BIS_DRAFT             16
#define BIS_INVERT            32

typedef HGLOBAL HDIB;

typedef struct tagXCoord {
    POINT pLeftTop;
    POINT pRightTop;
    POINT pRightBottom;
    POINT pLeftBottom;
} XCOORD;

/* COORD is used in WIN32 so we change COORD to XCOORD    NGY  */

typedef XCOORD far *  LPXCOORD;

typedef struct tagDISPLAYSTRUCT
{
    RECT     rOrigo;         /* Bitmap left top coordinate on display */
    UINT     wDisplayFormat; /* Display Format Bitfield */
    RECT     rcScrollRange;  /* Scroll Ranges Min Max */
    POINT    pScrollPos;     /* Scroll Position */
    RECT     rcScale;
    POINT    pOffset;        /* Display Offset in Client coordinates */
    POINT    pBitmapSize;    /* Bitmap Size in Pixels */
    int      biBitCount;     /* Bits per Pixel */
    RECT     rcClient;       /* Viewport Client Rectangle */
    POINT    ptOrg;          /* Window Origin */
    POINT    pDPIDC;         /* Viewport Resolution */
    POINT    pDPIBitmap;     /* Bitmap Resolution */
    HPALETTE hPal;           /* DIB Palette */
    HDIB     hDIBBitmap;     /* DIB Handle */
    HBITMAP  hBitmap;        /* Bitmap Handle */
    WORD     wInternal;      /* Internal Flags */
    void     *StretchFunc;
    long     StretchData;
} DISPLAYSTRUCT, FAR *LPDISPLAYSTRUCT;


typedef struct _Print
{
    BOOL  bDisplay;          /* TRUE - Display dialog box */
    BOOL  bCenterVertImg;    /* Center image vertically */
    BOOL  bCenterHorizImg;   /* Center image horizontally */
    BOOL  bScalePage;        /* Scale image to page */
    int   nNumCopies;        /* Number of copies should be printed */
    BOOL  bConvertCtoB;      /* Convert color image to black & white */
    BOOL  bStretchPage;      /* Stretch to page */
    BOOL  bAllPage;          /* Print all pages */
    BOOL  bUseDPI;           /* Use DPI to scale image */
    BOOL  bNotDispCancel;    /* Not display print cancel dialog */
} GPRINT;

typedef GPRINT FAR *LPGPRINT;

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


#define MAX_SCALE_STEP    10    /* max number of steps for BZOOM */
#define MAX_SCALE_BASE    1000  /* max base for BZOOM */

typedef struct tagZOOMSTEP
{
    int num;                    /* itemnumber in a step */
    int step[MAX_SCALE_STEP];
} ZOOMSTEP;

typedef ZOOMSTEP FAR *LPZOOMSTEP;

typedef enum enumZOOMFLAG
{
    ZOOM_SELECT = 0x10,
    ZOOM_SELECT_MOVE,           /* only scroll */
    ZOOM_SELECT_LARGE,          /* select a rectange or step larger */
    ZOOM_SELECT_SMALL,          /* select a rectangle or step smaller */
    ZOOM_SELECT_PLUS,
    ZOOM_SELECT_MINUS,
    
    ZOOM_STEP = 0x20,
    ZOOM_STEP_CUSTOM,           /* set custom scale (not step) */
    ZOOM_STEP_LARGE,            /* not select rectangle and step larger */
    ZOOM_STEP_SMALL,            /* not select rectangle and step larger */
    ZOOM_STEP_PLUS,
    ZOOM_STEP_MINUS,
} ZOOMFLAG;

typedef struct tagZOOMSTRUCT
{
    ZOOMFLAG zoomflg;
    RECT  rScaleOut;
    POINT pOrigoOut;
    BOOL  bMouseScreen;
    RECT  rSelectW;
    RECT  rScaleInp;
    BOOL  bSelectStart;
} ZOOMSTRUCT;

typedef ZOOMSTRUCT FAR *LPZOOMSTRUCT;

/* This is only for SCREEN zoom */
typedef struct tagZOOMSCREEN
{
    UINT wScreenFormat;         /* BIS_xxx */
    double X_DCPerBitmap;       /* equal to DISPLAYSTRUCT->X_DCPerBitmap */
    double Y_DCPerBitmap;       /* equal to DISPLAYSTRUCT->Y_DCPerBitmap */
    POINT pSizeBitmap;          /* equal to DISPLAYSTRUCT->pSizeBitmap */
    POINT pDPIDC;               /* equal to DISPLAYSTRUCT->X_pDPIDC */
    POINT pDPIBitmap;           /* equal to DISPLAYSTRUCT->X_pDPIBitmap */
    POINT pOrigoDC;
    POINT pOrigoBMP;
    POINT pScrollPos;           /* scroll pos output */
    POINT pScrollRange;
    BOOL  bScrollExist;         /* 1:HORZ,  2:VERT  3:BOTH   (output) */
} ZOOMSCREEN;

typedef ZOOMSCREEN FAR *LPZOOMSCREEN;

#ifndef _NOTE_DEFINED_
#define _NOTE_DEFINED_
typedef struct tagNote
{
    BOOL bOnHead;          /* The note is stored in the TIFF header. */
    BOOL bOpaque;          /* The note is stored on the image. */
    HGLOBAL hStr;          /* ASCII text sored as note. */
    RECT rRect;            /* The note area on the image. */
    HANDLE hDIB;           /* The Device independent bitmap. */
} NOTESTRUCT;

typedef NOTESTRUCT FAR * LPNOTESTRUCT;
#endif

typedef struct tag_SIZE
{
    int         x;
    int         y;
} XYSIZE;

typedef XYSIZE FAR *LPXYSIZE;

/* Group A - Bitmap functions */
VOID CALLBACK DisplayImage(HWND hWnd, HBITMAP hBitmap, HPALETTE hPal, LPRECT lprScroll,
                           LPPOINT lpptDPI, LPRECT lprScale, WORD wDisplayFormat);

UINT CALLBACK DisplayStart(HWND hWnd, HBITMAP hBitmap, HPALETTE hPal, LPPOINT lpptDPI,
                           LPRECT lprScroll, LPRECT lprScale, UINT wDisplayFormat,
                           LPDISPLAYSTRUCT cb);

UINT CALLBACK DisplayImageDC(HDC hdc, LPDISPLAYSTRUCT cb);

HANDLE CALLBACK PrinterSetup(HWND hWnd);

int CALLBACK PrintImage(HWND hWnd, HDC hPrnDC, HBITMAP hBitmap, HPALETTE hPal,
                        LPSTR lpImgName, LPPOINT lpptDPI, LPGPRINT lpPrint, LPRECT lprScale);

HBITMAP  CALLBACK RotateBitmap90(HBITMAP hBitmapOld);
BOOL     CALLBACK RotateBitmap180(HBITMAP hBitmap);
HBITMAP  CALLBACK RotateBitmap270(HBITMAP hBitmapOld);
BOOL     CALLBACK InvertBitmap(HBITMAP hbitSource);
BOOL     CALLBACK FlipBitmapVertical(HBITMAP hBitmap);
BOOL     CALLBACK FlipBitmapHorizontal(HBITMAP hBitmap);
void     CALLBACK GetImageVersion(LPSTR lpBuffer, int nMaxByte);

/* Group B - DIB functions */
HDIB CALLBACK CropDIB(HDIB hDib, long LeftPosition, long TopPosition, 
					  long RightPosition, long BottomPosition);
HDIB CALLBACK CleanImage(HDIB hDib, int percent, BOOL bSlow);
BOOL CALLBACK CutDIB(HDIB hDib, DWORD height, HDIB *hDib1, HDIB *hDib2);
VOID CALLBACK DisplayDIBImage(HWND hWnd, HANDLE hDIB, LPRECT lprScroll, LPRECT lprScale,
                              WORD wDisplayFormat);

UINT CALLBACK DisplayDIBStart(HWND hWnd, HDIB hDIB, LPRECT lprScroll, LPRECT lprScale,
                             UINT wDisplayFormat, LPDISPLAYSTRUCT cb);

UINT CALLBACK DisplayDIBImageDC(HDC hdc, LPDISPLAYSTRUCT cb);

LRESULT CALLBACK DisplayWmHorzScroll(HWND hWnd, WPARAM wParam, LPARAM lParam, LPDISPLAYSTRUCT cb);
LRESULT CALLBACK DisplayWmVertScroll(HWND hWnd, WPARAM wParam, LPARAM lParam, LPDISPLAYSTRUCT cb);
LRESULT CALLBACK DisplayWmPaint(HWND hWnd, LPDISPLAYSTRUCT cb);
LRESULT CALLBACK DisplayWmSize(HWND hWnd, WPARAM wParam, LPARAM lParam, LPDISPLAYSTRUCT cb);
LRESULT CALLBACK DisplayWmDestroy(HWND hWnd, WPARAM wParam, LPARAM lParam, LPDISPLAYSTRUCT cb);
LRESULT CALLBACK DisplayWmCreate(HWND hWnd, WPARAM wParam, LPARAM lParam, LPDISPLAYSTRUCT cb);
void    CALLBACK MapDisplayDC(HDC hDC,LPDISPLAYSTRUCT cb);
void    CALLBACK DisplayNote(HDC hDc,LPDISPLAYSTRUCT lpView,LPNOTESTRUCT lpNote);
LRESULT CALLBACK DisplaySetScrollPos(HWND hWnd, LPDISPLAYSTRUCT lpView, LPPOINT ptPos);

int CALLBACK PrintDIB(HWND hWnd, HDC hPrnDC, HANDLE hDib, LPSTR lpImgName, LPPOINT lpptDPI,
                      LPGPRINT lpPrint, LPRECT lprScale);
HDIB CALLBACK SkewDIB(HDIB, BOOL, int, LPINT, LPXCOORD);
HDIB     CALLBACK ExpandCompressedDIB(HDIB);
HDIB     CALLBACK ScaleGrayDIB(HDIB, short, short, short, short, short, short, short);
HANDLE   CALLBACK Halftone(HANDLE hDIB, WORD nMethode, int nIntControl, LPWORD lpErrCode);
HANDLE   CALLBACK ConvColorDIBtoGrayscale(HANDLE hDIB1, UINT nMethode, BOOL bPsychovisual);

/* New Print functions */
int  CALLBACK PrepareToPrint(HWND hWnd,HDC hPrnDC,LPGPRINT lpPrint,LPSTR   lpImgName,UINT nMaxPage);
int  CALLBACK PrintDIBPage(HANDLE  hDib,LPPOINT lpptDPI,LPRECT  lprScale, UINT PageNo,int xStart,int yStart);
void CALLBACK PrintPageContinue(void);
int  CALLBACK EndPrint(HDC hPrnDC);

/* BITMAP file format */
HBITMAP  CALLBACK LoadBitmapFromFile(LPSTR szFileName);
HANDLE   CALLBACK LoadDIBFromFile(LPSTR szFileName);
HANDLE   CALLBACK ReadDIBInfo(int fh);
BOOL     CALLBACK SaveBitmap(LPSTR szFile, HBITMAP hBitmap, HPALETTE hPal);
BOOL     CALLBACK SaveDIB(LPSTR szFile, HANDLE hdib);

HANDLE CALLBACK RotateDIB90(HANDLE hbmOld);
HANDLE CALLBACK RotateDIB180(HANDLE hbmSource);
HANDLE CALLBACK RotateDIB270(HANDLE hbmOld);
BOOL   CALLBACK InvertDIBPalette(HANDLE hDib);

HANDLE   CALLBACK Convert8to24(HANDLE hDIB1);
HANDLE   CALLBACK ConvertBitmapToDIB(HBITMAP hBitmap, HPALETTE hPal);
HBITMAP  CALLBACK ConvertDIBToBitmap(HANDLE hDIB);
HPALETTE CALLBACK CreateDIBPalette(HANDLE hDIB);
HBITMAP  CALLBACK ConvertToMonochromeBitmap(HBITMAP hBm);
HANDLE   CALLBACK ConvertMonoDIBtoGrayscale(HANDLE hDIB1, UINT nMethode);
HANDLE   CALLBACK ConvMonoDIBtoGrayscale(HANDLE hDIB1, UINT nMethode);


HBITMAP  CALLBACK DuplicateBitmap(HBITMAP hbmOld);
HANDLE   CALLBACK DuplicateDIB(HANDLE hHandle);
HANDLE   CALLBACK ScaleDIB(HANDLE hDIB, UINT nMethode, XYSIZE nSize);

UINT  CALLBACK CombineBMP(int X, int Y, HBITMAP *hDest, HBITMAP hSrc, HBITMAP hMask, DWORD dwMode);
UINT  CALLBACK CombineDIB(int X, int Y, HANDLE *hDest, HANDLE hSrc, HANDLE hMask, DWORD dwMode);

VOID  CALLBACK Zoom(HWND hWnd, LONG lStartPos, LPRECT lprScale);

/* ERROR handling */
LPSTR CALLBACK BitmaniErrorString(LPSTR lpszErrorStr, int nError);
int   CALLBACK BitmaniError(void);
int   CALLBACK SetBitmaniError(int nError);

/* New ZOOM functions for DIB */
void CALLBACK BZoomStart  (HWND hWnd, LPPOINT ptMouse, LPRECT lprScale, ZOOMFLAG zoomflg,
                           LPZOOMSTRUCT zm, BOOL bMouseScreen);
void CALLBACK BZoomUpdate (HWND hWnd, LPPOINT ptMouse, LPZOOMSTRUCT zm);
void CALLBACK BZoomEnd    (HWND hWnd, LPPOINT ptMouse, LPZOOMSTRUCT zm, LPDISPLAYSTRUCT cb);
void CALLBACK BZoomStep   (HWND hWnd, LPRECT lprScale, ZOOMFLAG zoomflg, LPZOOMSTRUCT zm,
                           LPDISPLAYSTRUCT cb);

BOOL CALLBACK BZoomSetScaleSteps(int base, LPZOOMSTEP enlarge, LPZOOMSTEP reduce);
int  CALLBACK BZoomGetScaleSteps(LPZOOMSTEP enlarge, LPZOOMSTEP reduce);

/* New ZOOM functions for SCREEN */
void CALLBACK BZoomScreenEnd(HWND hWnd, LPPOINT ptMouse, LPZOOMSTRUCT zm, LPZOOMSCREEN zc);
void CALLBACK BZoomScreenStep(HWND hWnd, LPRECT lprScale, ZOOMFLAG zoomflg, LPZOOMSTRUCT zm,
                              LPZOOMSCREEN zc);

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

HANDLE CALLBACK CropToEdges(HANDLE hDIB, double dThreshold, LPDWORD lpdwStartX, int nBorder, BOOL bWhitePage, BOOL bMultiPage);
HANDLE CALLBACK DeskewDIB(HANDLE hDIB, DWORD dwStartX, BOOL bWhitePage);

#endif /* _BITMANI_H_ */
