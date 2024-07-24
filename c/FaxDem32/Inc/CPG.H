#ifndef _CPG_H_
#define _CPG_H_

#include "bicp.h"

#define FLAG_EDIT	0
#define FLAG_FILL	1
#define FLAG_TIFF	2

enum ArangeText{Arange_Left, Arange_Center, Arange_Right};

#ifndef _COLOR_LINE_ENUMS_
#define _COLOR_LINE_ENUMS_

enum
{
        A_BLACK=0,
        A_GRAY,
        A_BLUE,
        A_RED,
        A_PURPLE,
        A_GREEN,
        A_LBLUE,
        A_YELLOW,
        A_LGRAY,
        A_WHITE
};

enum
{
        A_SIMPLE=0,
        A_ARROW,
        A_FILLED_ARROW,
        A_DB_ARROW,
        A_DB_FILLED_ARROW,
};

#endif

enum
{
	CPG_ERR_POS    = 1<<0,
	CPG_ERR_DIM    = 1<<1,
	CPG_ERR_COLOR  = 1<<2,
	CPG_ERR_LWIDTH = 1<<3,
	CPG_ERR_LTYPE  = 1<<4,
	CPG_ERR_STAMP  = 1<<5,
	CPG_ERR_FONT   = 1<<6
};

enum
{
	CPG_INS = 0,
	CPG_OVR,
	CPG_CHANGE_INS_OVR,
};

#ifdef __cplusplus
extern "C" {
#endif

long CALLBACK TemplateProc( HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam );
long CALLBACK CreateCpgHandle();
void CALLBACK DestroyCpgHandle(LONG pCpg);
long CALLBACK CreateCpgObj(LONG pCpg, int type);
long CALLBACK DeleteCpgObj(LONG pCpg, HDC hDC);
void CALLBACK CpgDrawAll(LONG pCpg, HDC hDC);
void CALLBACK CpgObjDraw(LONG pCpg, HDC hDC );
void CALLBACK CpgObjDrawFrame(LONG pCpg, HDC hDC);
long CALLBACK CpgObjSelect(LONG pCpg,int x,int y);
long CALLBACK CpgObjSelectNext(LONG pCpg);
void CALLBACK CpgObjDeselect(LONG pCpg,HDC hDC);
void CALLBACK CpgObjSelectLast(LONG pCpg);
void CALLBACK CpgObjSetPos(LONG pCpg,int x,int y);
void CALLBACK CpgObjSetSize(LONG pCpg,int w,int h);
void CALLBACK CpgObjSetColor(LONG pCpg,long c);
void CALLBACK CpgObjSetLineWidth(LONG pCpg,int w);
void CALLBACK CpgObjSetLineType(LONG pCpg,long t);
void CALLBACK CpgObjSetStampFile(LONG pCpg, char* pFileName);
void CALLBACK CpgObjSetStampBMP(LONG pCpg, HBITMAP hBitmap);
long CALLBACK CpgObjSetFont(LONG pCpg, LOGFONT *plf);
long CALLBACK CpgObjGetFont(LONG pCpg, LOGFONT *plf);
long CALLBACK CpgObjSetProperty(LONG pCpg, Cpg_Prop *pProp);
BOOL CALLBACK CpgObjGetProperty(LONG pCpg, Cpg_Prop *pProp);
void CALLBACK CpgObjGetPos(LONG pCpg,LPSIZE pPos);
void CALLBACK CpgObjGetSize(LONG pCpg,LPSIZE pSize);
void CALLBACK CpgObjGetRect(LONG pCpg,LPRECT pRect);
long CALLBACK CpgObjGetColor(LONG pCpg);
int CALLBACK CpgObjGetLineWidth(LONG pCpg);
long CALLBACK CpgObjGetLineType(LONG pCpg);
long CALLBACK CpgObjGetObjType(LONG pCpg);
LPSTR CALLBACK CpgObjGetText(LONG pCpg);
void CALLBACK CpgObjAddChar(LONG pCpg, char ch);
void CALLBACK CpgObjSetEditMode(LONG pCpg, int mode);
long CALLBACK SaveCpg(LONG pCpg, FILE *pFile);
long CALLBACK CpgObjPtInObj(LONG pCpg,int x ,int y);
void CALLBACK CpgSelectPage( LONG pCpg, long lPage );
long CALLBACK CpgGetSaveCount( LONG pCpg );
long CALLBACK CpgGetSaveData( LONG pCpg, void FAR *ptr, LONG lMax );
long CALLBACK CpgCreateOnLoad( void FAR * ptr, LONG lLength );
void CALLBACK CpgRotateObj90( LONG pCpg );
void CALLBACK CpgRotateObj180( LONG pCpg );
void CALLBACK CpgRotateObj270( LONG pCpg );
void CALLBACK CpgFlipHorizontalObj(LONG pCpg);
void CALLBACK CpgFlipVerticalObj(LONG pCpg);
void CALLBACK CpgGetVersion( char FAR * ptr, LONG len );

void CALLBACK CpgUISetExtent( long pCpg, DWORD dwW, DWORD dwH );
void CALLBACK CpgUIOnPaint( long pCpg, HDC hDC );
void CALLBACK CpgUIGetUpdateRect( long pCpg, RECT *rect );
void CALLBACK CpgUIRotate90( long pCpg );
void CALLBACK CpgUIRotate180( long pCpg );
void CALLBACK CpgUIRotate270( long pCpg );
void CALLBACK CpgUIFlipHorizontal( long pCpg );
void CALLBACK CpgUIFlipVertical( long pCpg );

BOOL CALLBACK CpgUIOnLButtonDown( long pCpg, HDC hDC, UINT nFlags, POINT point );
BOOL CALLBACK CpgUIOnLButtonUp( long pCpg, HDC hDC, UINT nFlags, POINT point);
BOOL CALLBACK CpgUIOnLButtonDblClk( HDC hDC, long pCpg, UINT nFlags, POINT point );
BOOL CALLBACK CpgUIOnMouseMove( long pCpg, HDC hDC, UINT nFlags, POINT point );
BOOL CALLBACK CpgUIOnKeyUp( long pCpg, HDC hDC, UINT nChar, UINT nRepCnt, UINT nFlags);
BOOL CALLBACK CpgUIOnKeyDown( long pCpg, HDC hDC, UINT nChar, UINT nRepCnt, UINT nFlags);
BOOL CALLBACK CpgUIOnChar( long pCpg, HDC hDC, UINT nChar, UINT nRepCnt, UINT nFlags );

BOOL CALLBACK CpgUISetColor( long pCpg, long lNewColor );
BOOL CALLBACK CpgUISetLineType( long pCpg, long lNewType );
BOOL CALLBACK CpgUISetFont( long pCpg, LOGFONT * lp );
BOOL CALLBACK CpgUISetLineWidth( long pCpg, long lNewLWidth );
BOOL CALLBACK CpgUISetImage( long pCpg, HBITMAP hBmp );
void CALLBACK CpgUISetNewObject( long pCpg, long lNewObj );
void CALLBACK CpgUISelect( long pCpg, HDC hDC );

void CALLBACK CpgUISetChange( long pCpg, BOOL b );
void CALLBACK CpgUIEnableUI( long pCpg, BOOL b );
void CALLBACK CpgUISetRecalc( long pCpg, BOOL b );
void CALLBACK CpgUIEnableDrawFrames( long pCpg, BOOL b );

long CALLBACK CpgUIGetLineWidth( long pCpg );
long CALLBACK CpgUIGetLineType( long pCpg );
long CALLBACK CpgUIGetColor( long pCpg );
long CALLBACK CpgUIGetType( long pCpg );
long CALLBACK CpgUIGetMode( long pCpg );

BOOL CALLBACK CpgUIGetSaved( long pCpg );
BOOL CALLBACK CpgUIIsChanged( long pCpg );
BOOL CALLBACK CpgUIGetEnableUI( long pCpg );

//IZ!!!
void CALLBACK CpgUISetId( long pCpg, long id );
long CALLBACK CpgUIGetId( long pCpg );
void CALLBACK CpgUISetCpType( long pCpg, long cptype );
long CALLBACK CpgUIGetCpType( long pCpg );
void CALLBACK CpgUISetTitle( long pCpg, LPSTR title );
LPSTR CALLBACK CpgUIGetTitle( long pCpg );
void CALLBACK CpgUISetFlag( long pCpg, int flag );
void CALLBACK CpgUISetGridValue( long pCpg, long v );
void CALLBACK CpgUISortEdit( long pCpg );
BOOL CALLBACK CpgUIFirstEdit( long pCpg, HDC hDC, POINT *point );
BOOL CALLBACK CpgUINextEdit( long pCpg, HDC hDC, POINT *point );
BOOL CALLBACK IsDLLRun();
BOOL CALLBACK GetColorFlag();
void CALLBACK SetColorFlag(BOOL bColor);

const char* CALLBACK GetMessageString(DWORD dwMessageCode);
const MessageType CALLBACK GetMessageType(DWORD dwMessageCode);
HWND CALLBACK GetDrawWindowHWND();
HDC CALLBACK GetDrawWindowsHDC();
BOOL CALLBACK CpgSetTextAlign( long pCpg, long iNewType );

void CALLBACK CpgSetFilled( long pCpg, BOOL bFilled);
BOOL CALLBACK CpgGetFilled( long pCpg);

//long CALLBACK SaveCpgInTiff(LONG pCpg, char *pFileName);
//void CALLBACK CpgUISetDpi( long pCpg, int mode );
//BOOL CALLBACK GetCpgIdStr( long pCpg, long id, LPSTR s );
//BOOL CALLBACK SetCpgIdStr( long pCpg, long id, LPSTR s );
//BOOL CALLBACK GetCpgIdTitle( long pCpg, long id, LPSTR s );
//BOOL CALLBACK SetCpgIdTitle( long pCpg, long id, LPSTR s );
//void CALLBACK CpgUIfOnChar( BOOL f );

#ifdef __cplusplus
}
#endif

#endif
