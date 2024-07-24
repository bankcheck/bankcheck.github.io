#ifndef TWAINIF_H
#define TWAINIF_H

#ifdef __cplusplus
extern "C" {
#endif

#define TWSCAN_VERSION 0x300

// Function return codes
#define  TW_OK                          0
#define  TW_GENERAL_ERROR       1
#define  TW_NOTOPEN             2
#define  TW_TRANSFERFAILURE 3
#define  TW_OPENDSMFAILURE      4
#define  TW_COMPATIBILITY   5
#define  TW_OPENDSFAILURE       6
#define  TW_CLOSEDSFAILURE  7
#define  TW_SELECTDSFAILURE 8
#define  TW_NOTWAINDLL      9
#define  TW_LOADED              10

typedef void (CALLBACK *TwainDoneFn)(void far * lpParam,HANDLE hDib,LPCSTR lpFileName);
typedef void (CALLBACK *TwainCloseFn)(void far * lpParam);
typedef void (CALLBACK *TwainErrorFn)(void far * lpParam,int wErrCode,LPCSTR lpMessage);


int  CALLBACK twInit(HWND hWnd);
int  CALLBACK twClose();
int  CALLBACK twTerminate();
int  CALLBACK twSelectSource();
int  CALLBACK twAcquire(LPCSTR lpFileName);
void CALLBACK twSetDoneFn(TwainDoneFn lpDoneFn,void FAR * lpParam);
void CALLBACK twSetCloseFn(TwainCloseFn lpCloseFn);
void CALLBACK twSetErrorFn(TwainErrorFn lpErrorFn);
BOOL CALLBACK twProcessMessage(LPMSG lpMsg);
WORD CALLBACK twGetVersion(LPSTR lpBuffer,int nBytes);

#ifdef __cplusplus
};
#endif

#endif
