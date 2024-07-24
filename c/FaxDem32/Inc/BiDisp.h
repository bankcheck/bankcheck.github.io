#ifndef BIDISP_H_INCLUDE
#define BIDISP_H_INCLUDE
#include "windows.h"

typedef HGLOBAL HDIB;

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
#define DISP_FITTOHEIGHT    8192

/* These are only for SCREEN zoom */
#define BIS_SCALENORMAL        4
#define BIS_FITTOSCREEN        8
#define BIS_DRAFT             16
#define BIS_INVERT            32

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


VOID CALLBACK DisplayImage(HWND hWnd, HBITMAP hBitmap, HPALETTE hPal, LPRECT lprScroll,
                           LPPOINT lpptDPI, LPRECT lprScale, WORD wDisplayFormat);

UINT CALLBACK DisplayStart(HWND hWnd, HBITMAP hBitmap, HPALETTE hPal, LPPOINT lpptDPI,
                           LPRECT lprScroll, LPRECT lprScale, UINT wDisplayFormat,
                           LPDISPLAYSTRUCT cb);

UINT CALLBACK DisplayImageDC(HDC hdc, LPDISPLAYSTRUCT cb);
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

/*  DISPLAY.C           */
UINT DisplayDIBInit(HWND hWnd, LPRECT lprScale, LPDISPLAYSTRUCT cb);


/* New ZOOM functions for DIB */
void CALLBACK BZoomStart  (HWND hWnd, LPPOINT ptMouse, LPRECT lprScale, ZOOMFLAG zoomflg,
                           LPZOOMSTRUCT zm, BOOL bMouseScreen);
void CALLBACK BZoomUpdate (HWND hWnd, LPPOINT ptMouse, LPZOOMSTRUCT zm);
void CALLBACK BZoomEnd    (HWND hWnd, LPPOINT ptMouse, LPZOOMSTRUCT zm, LPDISPLAYSTRUCT cb);
void CALLBACK BZoomStep   (HWND hWnd, LPRECT lprScale, ZOOMFLAG zoomflg, LPZOOMSTRUCT zm,
                           LPDISPLAYSTRUCT cb);

BOOL CALLBACK BZoomSetScaleSteps(int base, LPZOOMSTEP enlarge, LPZOOMSTEP reduce);
int  CALLBACK BZoomGetScaleSteps(LPZOOMSTEP enlarge, LPZOOMSTEP reduce);

void CALLBACK ZoomArea(HWND hWnd, LPRECT lpArea, LPRECT lprScale, ZOOMFLAG zoomflg, LPZOOMSTRUCT zm, BOOL bMouseScreen, LPDISPLAYSTRUCT cb);

/* New ZOOM functions for SCREEN */
void CALLBACK BZoomScreenEnd(HWND hWnd, LPPOINT ptMouse, LPZOOMSTRUCT zm, LPZOOMSCREEN zc);
void CALLBACK BZoomScreenStep(HWND hWnd, LPRECT lprScale, ZOOMFLAG zoomflg, LPZOOMSTRUCT zm,
                              LPZOOMSCREEN zc);

void CALLBACK GetBiDispVersion(LPSTR lpBuffer, int nMaxByte);

UINT CALLBACK RefreshDIB(HWND hWnd, HDIB hDIB, LPRECT lprScroll, LPRECT lprScale,
                             UINT wDisplayFormat, LPDISPLAYSTRUCT cb);


#endif