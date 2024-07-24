#include <windows.h>

typedef HGLOBAL HDIB;

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

#define BI_PRINT_SCALE_IMAGE	0
#define BI_PRINT_STRETCH_IMAGE	1
#define BI_PRINT_USE_IMAGE_DPI	2

/* BiPrint error codes */

#define PR_ERR_NONE            0x0000      // None error
#define PR_ERR_BITMAP          0x0001      // No DIB or DDB support
#define PR_ERR_NODC            0x0002      // Invalid DC
#define PR_ERR_SETABORT        0x0003      // Error in SETABORTPROC escape
#define PR_ERR_STARTDOC        0x0004      // Error in STARTDOC escape
#define PR_ERR_NEXTBAND        0x0005      // Error in NEXTBAND escape
#define PR_ERR_BANDINFO        0x0006      // Error in BANDINFO escape
#define PR_ERR_CREATEBITMAP    0x0007      // Error in CreateBitmap()
#define PR_ERR_BITBLT          0x0008      // Error in BitBlt()
#define PR_ERR_STRETCHBLT      0x0009      // Error in StretchBlt()
#define PR_ERR_SETDIBS         0x000A      // Error in SetDIBits()
#define PR_ERR_SETDIBTODEV     0x000B      // Error in SetDIBitsToDevice()
#define PR_ERR_CREATEDC        0x000C      // Can't create DC
#define PR_ERR_CREATEDIB       0x000D      // Can't create DIB
#define PR_ERR_NEWFRAME        0x000E      // Error in NEWFRAME escape
#define PR_ERR_MAPPINGMODE     0x000F      // Error in specified Mapping mode
#define PR_ERR_DESTINATIONRECT 0x0010      // Error in specified destination rect
#define PR_ERR_FLAGERROR	   0x0011      // Error in specified BYTE flag
#define PR_ERR_OUTOFMEMORY	   0x0012	   // Out of memory	
#define PRN_ERR_PRINTCANCEL    0x0013	   // User cancels the printing
#define PRN_ERR_PRINTERDC	   0x0014	   // Could not get printer DC		


HANDLE CALLBACK PrinterSetup(HWND hWnd);
int     CALLBACK PrepareToPrint(HWND hWnd,HDC hPrnDC,LPGPRINT lpPrint,LPSTR   lpImgName,UINT nMaxPage);
int     CALLBACK PrintDIBPage(HANDLE  hDib,LPPOINT lpptDPI,LPRECT  lprScale, UINT PageNo,int xStart,int yStart);
void    CALLBACK PrintPageContinue(void);
int     CALLBACK EndPrint(HDC hPrnDC);
int     CALLBACK PrintImage(HWND hWnd, HDC hPrnDC, HBITMAP hBitmap, HPALETTE hPal,
                        LPSTR lpImgName, LPPOINT lpptDPI, LPGPRINT lpPrint, LPRECT lprScale);
int     CALLBACK PrintDIB(HWND hWnd, HDC hPrnDC, HANDLE hDib, LPSTR lpImgName, LPPOINT lpptDPI,
                        LPGPRINT lpPrint, LPRECT lprScale);
HDC		CALLBACK BiOpenPrinter(LPCSTR lpszPrinterName, CONST DEVMODE * lpInitData);
int		CALLBACK BiStartDoc(HDC hPrinterDC);
int		CALLBACK BiStartPage(HDC hPrinterDC);
int		CALLBACK BiEndPage(HDC hPrinterDC);
int		CALLBACK BiEndDoc(HDC hPrinterDC);
BOOL		CALLBACK BiClosePrinter(HDC hPrinterDC);
int		CALLBACK BiPrintImageExt(	HDC		hDC,
									HDIB  hDib,
							        LPRECT  lpRect,
								    BYTE bUnits);
int		CALLBACK BiPrintImage	(	HDC		hDC,
									HDIB  hDib,
								    BYTE bFlag);

void	CALLBACK GetBiPrintVersion(LPSTR lpBuffer, int nMaxByte);

long	CALLBACK BiPrintSetup(LPCTSTR pPrinterName, BOOL showDialog); 