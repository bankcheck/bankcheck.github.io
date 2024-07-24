#ifndef __TAPIFAX_H_
#define  __TAPIFAX_H_

#define MAX_ENUM_COUNT		6

/* Keys to IOCompletion port */
#define SRL_KEY       1
#define DM3_IPT_KEY   2
#define END_KEY       3
#define USEREVT_KEY   4

// All TAPI line functions return 0 for SUCCESS, so define it.
#define SUCCESS 0


extern HLINEAPP	g_hLineApp;
extern HANDLE    hIOCP;            /* handle for IO Completion port */


BOOL InitializeTAPI(DWORD dwDeviceID);
BOOL ShutdownTAPI();
LPTSTR FormatTapiError (long lError);
VOID FAR PASCAL  lineCallbackFunc(DWORD dwDevice, DWORD dwMsg, DWORD dwCallbackInstance, DWORD dwParam1, DWORD dwParam2, DWORD dwParam3);
LPTSTR FormatTapiError (long lError);



extern HLINE g_hLine ;
extern HCALL g_hCall ;

extern BOOL g_bShuttingDown ;
extern BOOL g_bStoppingCall ;
extern BOOL g_bInitializing ;
extern BOOL g_bTapiInUse ;

#endif // #ifndef __TAPI_H_