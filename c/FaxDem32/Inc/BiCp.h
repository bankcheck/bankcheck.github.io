#ifndef _CP_H_
#define _CP_H_

#ifdef __cplusplus
extern "C" {
#endif

//Message list							Legal return values for this error(0-Handle it in DLL)
#define CPG_MESSAGE_CORRUPT_FILE	1	//IDOK(1)
#define CPG_MESSAGE_DELETE_ITEM		2	//IDYES(6), IDNO(7)
#define CPG_MESSAGE_PRINT_ERROR		3	//IDOK(1)
#define CPG_MESSAGE_SAVE_FILE		4	//IDYES(6), IDNO(7), IDCANCEL(2)
#define CPG_MESSAGE_ILLEGAL_RETURN_VALUE 5	//The return value does not affect
#define CPG_MESSAGE_CANT_LOAD_TIF32DLL	 6	//IDOK(1)
#define CPG_MESSAGE_CANT_LOAD_BITMANIDLL 7	//IDOK(1)
#define CPG_MESSAGE_CANT_LOAD_JPEGDLL    8	//IDOK(1)
#define CPG_MESSAGE_CANT_OPEN_FILE		 9	//IDOK(1)
#define CPG_MESSAGE_CANT_LOAD_BIPRINTDLL 10	//IDOK(1)
#define CPG_MESSAGE_CANT_LOAD_BIDISPDLL 11	//IDOK(1)

#define CPG_UNDEF       -1

// page size constants
#define A4_WIDTH        1728
#define A4_HEIGHT       2156

#define WND_X           0
#define WND_Y           0

#define CLIENT_DX       (int)(A4_WIDTH/5)
#define CLIENT_DY       (int)(A4_HEIGHT/5)

#define WND_DX          (CLIENT_DX+175)
#define WND_DY          (CLIENT_DY+78)

// fItem values for CpgTemplate
// You must set the buttons' flag if you want it on the editor
#define INEW            (1<<0)
#define ILOAD           (1<<1)
#define ISAVE           (1<<2)
#define ISAVEAS         (1<<3)
#define IEXIT           (1<<4)
#define IIMAGE          (1<<5)
#define IEDIT           (1<<6)
#define ISTATIC         (1<<7)
#define ILINE           (1<<8)
#define IELLIPSE        (1<<9)
#define IRECT           (1<<10)
#define IFONT           (1<<11)
#define ILINEW          (1<<12)
#define IGRID           (1<<13)
#define IZIN			(1<<14)
#define IZOUT			(1<<15)
#define ITOOL			(1<<16)
#define ICPSEND			(1<<17)		// this is not part of COMPLETE
#define IPRINT          (1<<18)
#define COMPLETE        (INEW|ILOAD|ISAVE|ISAVEAS|IEXIT|IIMAGE|IEDIT|ISTATIC|ILINE|IELLIPSE|IRECT|IFONT|ILINEW|IGRID|IZIN|IZOUT|ITOOL|IPRINT)


#define ID_SAVE         1
#define ID_BITMAP       2
#define ID_EDIT         3
#define ID_SEDIT        4
#define ID_FONT         5
#define ID_EXIT         6
#define ID_GROUP        7
#define ID_LINE         8
#define ID_ELLIPSE      9
#define ID_SLWIDTH      10
#define ID_LWIDTH       11
#define ID_RECT         12
#define ID_TIFF         13
#define ID_NEW          14
#define ID_GRID         15
#define ID_LOAD         16
#define ID_ZOOMIN       17
#define ID_ZOOMOUT      18
#define ID_TOOLCHK      19
#define ID_SAVEAS       20
#define ID_FITTOWIDTH   21
#define ID_FITTOWINDOW  22
#define ID_CPSEND		23
#define ID_PRINT        24
#define ID_ALIGN_TEXT_LEFT	25
#define ID_ALIGN_TEXT_CENTER	26
#define ID_ALIGN_TEXT_RIGHT	27
#define ID_COLOR         28
#define ID_FILLED        29
#define ID_HILITE        30

#define VSBWDT          18
#define ID_TOOLBAR		200

#define MAX_TOOL_BTN	22
#define MAX_ZOOM		8

// max length of the edit box in character
#define EDIT_LENGTH     4096

// default DPI to FAX
#define FAX_STANDARD    0   // 204x98  DPI
#define FAX_FINE        1   // 204x196 DPI
#define FAX_200_100		2   // 200x100  DPI
#define FAX_200_200     3   // 200x200 DPI
#define FAX_NORMAL		FAX_STANDARD

// values for cptype object field
#define T_USER          0
#define T_FROMNAME      1
#define T_FROMCOMP      2
#define T_FROMPHONE     3
#define T_FROMFAX       4
#define T_TONAME        5
#define T_TOCOMP        6
#define T_TOPHONE       7
#define T_TOFAX         8
#define T_DATE          9
#define T_SUBJ          10
#define T_COMM          11
#define T_TOTITLE		12
#define T_TODEP			13
#define T_TOADDR1		14
#define T_TOADDR2		15
#define T_TOCITY		16
#define T_TOSTATE		17
#define T_TOZIP			18
#define T_FINISH        19

#define CP_FILE_NORMAL     0
#define CP_FILE_TIFF_MONO  0
#define CP_FILE_GAMMA      1
#define CP_FILE_BICOM      2
#define CP_FILE_JPEG	   3
#define CP_FILE_JPEG_LAB   4

typedef INT      (CALLBACK *MessageFunc)(HWND,DWORD);
/*
Return values: 
0 -		Handle this message in DLL
Other - Please see the message list in this file
*/

// property of the Cover Page object
typedef struct
{
        long    lObjType;
        long    lObjId;
        long    lCpType;        // if edit_box  (= A_NOTE)
        int     lPosX;
        int     lPosY;
        int     lWidth;
        int     lHeight;
        long    lColor;
        int     lLine_Width;
        long    lLine_Type;
        long    lOnPage;
        LPSTR   pszTitle;       // if edit_box (= A_NOTE)
        LPSTR   pszText;
        LOGFONT sLogFont;
        LPSTR   lpFileName;     // if set new bitmap
        HBITMAP hBitmap;
} Cpg_Prop;

enum MessageType {MT_None, MT_Warning, MT_Error, MT_WarningYesNoCancel, MT_WarningOk};

// Cover Page object types
#ifndef __ANNO_H
enum
{
        A_WOUT=1,
        A_NOTE,
        A_STAMP,
        A_HILITE,
        A_LINE,
        A_RECT,
        A_CIRCLE,
        A_SNOTE
};
#endif

typedef long (CALLBACK *LPCOVERPROC)(long, HWND, UINT, WPARAM, LPARAM);


BOOL    CALLBACK CpgTemplate( char *fn, HWND hWnd, DWORD fItems, LPCOVERPROC lpCoverProc = NULL );

long    CALLBACK LoadCpgFile( LPSTR fn );
void    CALLBACK CloseCpg( long pCpg );

BOOL    CALLBACK SaveCpgFileToTiff( LPSTR cpgFn, LPSTR tiffFn, int FaxDpi, int nFileType = CP_FILE_NORMAL );
BOOL    CALLBACK SaveCpgToTiff( long pCpg, LPSTR tiffFn, int fFaxDpi, int nFileType = CP_FILE_NORMAL );
HANDLE  CALLBACK SaveCpgToDIB( long pCpg, int fFaxDpi, BOOL bEdit = FALSE );
BOOL    CALLBACK SaveCpgFile( long pCpg, char *fn );

BOOL    CALLBACK FindFirst( long pCpg, Cpg_Prop *Prop );
BOOL    CALLBACK FindNext( long pCpg, Cpg_Prop *Prop );
long    CALLBACK FindSetProp( long pCpg, Cpg_Prop *Prop );
BOOL    CALLBACK CpgObjGetProperty( long pCpg, Cpg_Prop *pProp );
long    CALLBACK CpgObjSetProperty( long pCpg, Cpg_Prop *pProp );

void    CALLBACK CpgOnPaint( long pCpg, HDC hDC );
BOOL    CALLBACK CpgOnLButtonDown( long pCpg, HWND hwnd, HDC hDC, WPARAM wParam, LPARAM LParam );
BOOL    CALLBACK CpgOnLButtonUp( long pCpg, HWND hwnd, HDC hDC, WPARAM wParam, LPARAM LParam );
void    CALLBACK CpgOnMouseMove ( long pCpg, HDC hDC, WPARAM wParam, LPARAM LParam );
BOOL    CALLBACK CpgOnLButtonDblClk( long pCpg, HWND hwnd, HDC hDC, WPARAM wParam, LPARAM lParam );
BOOL    CALLBACK CpgOnKeyDown( long pCpg, HWND wWnd, HDC hDC, WPARAM wParam, LPARAM LParam );
BOOL    CALLBACK CpgOnChar( long pCpg, HWND hwnd, HDC hDC, WPARAM wParam, LPARAM lParam );
void    CALLBACK CpgOnCreate( long pCpg );
void    CALLBACK MappingDC( HDC hdc, int clientx, int clienty );

HBITMAP CALLBACK LoadMonoBitmap( char *fn, int fTiffOrBmp );
void CALLBACK SetMessageFunction(MessageFunc pMessageFunc);

#ifdef __cplusplus
}
#endif

#endif
/*eof*/
