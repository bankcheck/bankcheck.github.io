/****************************************************************************/
/*            (c) Copyright Black Ice Software Inc.  1994.                  */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/*                                                                          */
/*  Target Name:    FAXCPP.DLL                                              */
/*                                                                          */
/****************************************************************************/
/*
  $Log:   K:\archive\faxsrc40\inc\commcl.h  $
 *
 *    Rev 4.41   17 Aug 1998 15:02:50   unknown
 *
 *    Rev 4.40   24 Mar 1998 12:23:30   Zoltan
 *
 *
 *    Rev 4.39   01 Dec 1997 14:12:38   Zoltan
 *
 *    Rev 4.37   26 Aug 1997 19:14:26   Gyuri
 * No change.
 *
 *    Rev 4.36   15 Jul 1997 15:07:52   Maroy
 *
 *
 *    Rev 4.35   28 May 1997 16:13:50   Maroy
 *
 * 7L
 *
 *    Rev 4.34   12 Feb 1997 15:02:30   joe
 *
 * DTMF for Brooktrout
 *
 *    Rev 4.33   03 Feb 1997 10:19:28   joe
 *
 * MH
 *
 *    Rev 4.32   10 Jan 1997 16:48:04   joe
 *
 * leak removed
 *
 *    Rev 4.31   03 Oct 1996 13:38:26   joe
 *
 *    Rev 4.30   19 Aug 1996 19:17:16   joe
 * 4.16
 *
 *    Rev 4.29   01 Aug 1996 14:31:38   joe
 *
 *    Rev 4.28   20 May 1996 19:27:10   joe
 *
 *    Rev 4.21   22 Mar 1996 15:48:28   Albert
 *
 *
 *    Rev 4.20   21 Mar 1996 16:34:44   Albert
 * No change.
 *
 *    Rev 4.12   20 Mar 1996 11:14:12   Albert
 *
 *
 *    Rev 4.11   19 Mar 1996 14:47:10   Albert
 *
 *    Rev 4.10   18 Mar 1996 17:50:04   Albert
 *
 *
 *    Rev 4.9   16 Mar 1996 12:14:14   joe
 * No change.
 *
 *    Rev 4.8   14 Mar 1996 15:07:12   Albert
 *
 *    Rev 4.7   12 Mar 1996 14:50:12   Albert
 * No change.
 *
 *    Rev 4.6   11 Mar 1996 20:25:10   Albert
 *
 *    Rev 4.5   09 Mar 1996 19:06:28   Albert
 * No change.
 *
 *    Rev 4.4   09 Mar 1996 12:45:04   Albert
 * No change.
 *
 *    Rev 4.3   08 Mar 1996 14:54:44   Albert
 * No change.
 *
 *    Rev 4.2   08 Mar 1996 11:36:44   Albert
 * y
 * D
 *
 *    Rev 4.1   05 Mar 1996 17:55:16   Albert
 *
 * Scanline Time fizxed
 *
 *    Rev 4.0   05 Mar 1996 10:12:24   Albert
 * Initial revision.
 *
 *    Rev 0.911   03 Mar 1996 13:37:20   Albert
 * Merged winth new FaxObj
 *
 *    Rev 0.910   02 Mar 1996 15:33:48   Albert
 * Win16 & Win32 first version
 *
 *    Rev 0.804   01 Mar 1996 13:19:06   Albert
 * Win16 working
 *
 *    Rev 0.803   21 Feb 1996 09:46:56   Albert
 *
 *
 *    Rev 0.802   15 Feb 1996 11:41:08   Albert
 *
 *    Rev 0.801   13 Feb 1996 12:41:20   Albert
 * No change.
 *
 *    Rev 0.800   08 Feb 1996 16:58:52   Albert
 * Initial revision.
*/

#ifndef __COMMCL_H
#define __COMMCL_H
#pragma pack(4)

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Include
#include "port32.h"
#include "faxtype.h"
#include "globerr.h"
#include "control1.h"

#define SIZE_QUEUE      4096
#define MAX_PORTID      0xFF

//****************************************************************************
typedef PORTFAX (CALLBACK * ProcCreateComm)(LPSTR FaxShortName, LPSTR FileName);

class TRegistFaxType;

extern UINT FaxMessage;

#define FMD_OPENCOM     0x80
#define FMD_CLOSECOM    0x81
#define FMD_OPENFILE    0x82
#define FMD_CLOSEFILE   0x83
#define FMD_STARTFAX    0x84
#define FMD_ABORTEXTERN 0x85
#define FMD_CONNECT     0x86
#define FMD_DISCONNECT  0x87

#define MAKE_WORD(h,l) ((WORD)(((h & 0x00FF) << 8) | (l & 0x00FF)))

// Flow Control constants
#define FLC_NOTHING     0
#define FLC_XONXOFF     1
#define FLC_DSR         2
#define FLC_CTS         4


#ifdef _THREAD


#define ERRCODE     DWORD
#define ERRDEV      INVALID_HANDLE_VALUE
#else

#define ERRCODE     int
#define ERRDEV      -1


#endif


//****************************************************************************
extern LPSTR (CALLBACK * pGetFaxManagerID)();
extern long (CALLBACK  * pFaxEventHandler)(void far *This, TEFaxEvent Event, LPARAM lParam);
extern BOOL (CALLBACK  * pHaltDlgProc)(HWND dlg, UINT Msg, WPARAM wParam, LPARAM lParam);
extern LPSTR (CALLBACK * pGetResourceNames)(TEFaxManagerRes Type);

//****************************************************************************

// TRegistFaxType
class TRegistFaxType
{
public:
    TRegistFaxType (LPSTR Type, ProcCreateComm Proc);
    static ProcCreateComm SearchFaxType (LPSTR Type);
    static void RemoveAll(void);
private:
    static TRegistFaxType *Search (LPSTR Type);

    char             FaxType[MAX_FAXTYPE];
    ProcCreateComm   FaxProc;
    TRegistFaxType   *Next;

    static TRegistFaxType *First;
};

//****************************************************************************

class CFAXAPI TCCommPure : public TCModemPort
{
    friend TCFaxNormal;
public:
    //------------------------------------------------------------------------
    static HWND HWindow;
    static HWND HHideWindow;
    static HWND HDialog;
    static TERuningMode RunMode;
    static TEPhaseCoverage PhaseCoverage;
#ifndef _THREAD
    BOOL   bProcess   ;
    BOOL   blEnableTasks;
#endif

    //------------------------------------------------------------------------
    TSLineStatus LineStatus ;
    TEFaxError   ErrorCode  ;
protected:
        //------------------------------------------------------------------------
    static ProcEvent    lpProcEvent;

    //------------------------------------------------------------------------
public:
    //------------------------------------------------------------------------
    static PORTFAX EXPDEF   CreateCommObj (LPSTR FaxName, LPSTR FileName);
    static int     EXPDEF   RegisterFaxType (LPSTR CppClassName, ProcCreateComm lpProc, TRegistFaxType** p );
    static int     EXPDEF   CommWinMain (HINSTANCE hCurrent, HINSTANCE hPrevious, LPSTR CmdLine, int CmdShow);
    static int     EXPDEF   ProcessMessage();
    static PORTFAX EXPDEF   SearchDeviceName(LPSTR PortName);
    static void    EXPDEF   RegistEvent (ProcEvent lpProc);
    static PORTFAX EXPDEF   GetFirst();
    static void    EXPDEF   SetDefaultStationID (LPCSTR StationID);
    static void    EXPDEF   EndOfDll ();

    //--------------------------------------------------------------------------------------
    static LRESULT CALLBACK CommWndProc (HWND hwnd, UINT Msg, WPARAM wParam, LPARAM lParam);
    //--------------------------------------------------------------------------------------

public:
    //-------------------------------------------------------------
    // Constructors
    //-------------------------------------------------------------
    EXPDEF TCCommPure();
    EXPDEF TCCommPure (LPSTR FaxName, LPSTR FileName);
    virtual EXPDEF ~TCCommPure ();
    //-------------------------------------------------------------
    // Public Member Functions
    //-------------------------------------------------------------

    virtual void EXPDEF     LoadSetting(LPSTR FaxName, LPSTR FileName); // Load setting from ini file

    virtual int  EXPDEF ConnectPort (LPSTR PortName, HANDLE = NULL);
    virtual int  EXPDEF DisconnectPort();
    virtual int  EXPDEF DisconnectPortEx (BOOL bDSR);
    virtual int  EXPDEF SetDSR(BOOL bDSR);
    virtual int  EXPDEF EnableFaxPort(BOOL Enable);
    virtual void EXPDEF GetPortStatus (TSPortStatus far * PortStatus);
    virtual HCOMDEV EXPDEF GetDeviceHandle();

    virtual BOOL    EXPDEF SetupCommPort(TSCommSetting& NewSet);
    virtual BOOL    EXPDEF GetCommPortSetting(TSCommSetting& ComSet);
//        virtual BOOL    EXPDEF IsPortVoice();
    DWORD   GetUserLongPort();
    void    SetUserLongPort(DWORD dwUser);


    virtual int         EXPDEF SetModemCommands (LPSTR StartFaxInit, LPSTR HangUp, LPSTR Dial, LPSTR Answer);

    virtual FAXOBJ      EXPDEF AbortFax ();
    PORTFAX             EXPDEF GetNext () ;

    virtual int         EXPDEF SendFax (FAXOBJ Fax, BOOL Manual=FALSE);
    virtual int         EXPDEF AnswerNow (BOOL Manual=TRUE);
    virtual void        EXPDEF AutoAnswer (int RingNum);

    virtual int         EXPDEF GetFaxCapability (TEFaxCapability Cap);
    virtual int         EXPDEF SetFaxCapability (TEFaxCapability Cap, int Value);

    virtual BOOL        EXPDEF IsOpen();
    virtual long        EXPDEF GetCurrentSpeed();
    static  void        EXPDEF SetStdDialMode(TEDialMode   NewMode ) ;
    virtual void        EXPDEF SetDialMode(TEDialMode   NewMode ) ;

            BOOL        EXPDEF GetLineStatus(TSLineStatus* lpStatus);
#if defined(WIN32)
    virtual int     SetHeader( LPSTR str );
    virtual void    SetHeaderType( BOOL bHeader );
    virtual int     GetErrorMessage( LPSTR lpBuffer );
    virtual inline int GetLastStatus() {
                            return 0; };
#endif

    /*
     *   DTMF
     */
    virtual  int    SetVoiceFile( LPSTR lpFileName );
    virtual  int    GetVoiceFile( LPSTR lpBuffer, int Max );
    virtual  int    SetVoiceTimeout( unsigned int WaitTime );
    virtual  unsigned int  GetVoiceTimeout();
    virtual  int    GetDTMFDigits( LPSTR lpBuffer, int Max );
    virtual  int    SetDTMFDigits( int n, char Value );
    virtual void    SetDigitNumber( int n );
    virtual  int    GetDigitNumber();
// g5
    virtual BOOL    GoG3();
    virtual void    CheckTurnAround();
    virtual void    CheckConfirmation();
    virtual void    OnCheckTurnAround(FAXOBJ FaxObj,TEG5ReplyNeg result);
    virtual void    OnReplyFileFormat(FAXOBJ FaxObj);
    virtual void    OnSendDocument(FAXOBJ FaxObj);
    virtual void    OnSendConfirmation(FAXOBJ FaxObj);
    virtual void    SetG3FaxObj(FAXOBJ faxobj);
    virtual FAXOBJ  GetG3FaxObj();
    virtual BOOL G5IsSendingG3(){return G5SendingG3;}
    virtual void    ReportG5EndSend();


    int UnLinkPort();

    void SetPrefix(char *prefix); 
    void GetPrefix(char *prefix); 
protected:
    HCOMDEV             DeviceID;
    DWORD               dwUserData;

    virtual void        LocalInit();

    virtual int         SetCommPort (UINT Baudrate, BOOL XonXoff, BOOL Dsr, BOOL Cts);
            int         SetCommPortEx(HCOMDEV DeviceID , UINT Baudrate,BOOL XonOut,BOOL XonIn, BOOL Dsr, BOOL Cts);

    virtual void        SetRemoteID (LPSTR RemoteID);
    virtual long        SendFaxEvent (TEFaxEvent Event, LPARAM lParam);
            BOOL        CheckParameterRange(  int Min, int Max, int Value );
    //------------------------------------------------------------------------]

    void EXPDEF         ProcessCommEvent(MSG &msg);





protected:
    void                        ReceiveComm ();



protected:


    static HWND         CreateFaxDialog();
    // Communication port functions
    virtual int     WriteComm(HCOMDEV CommDev,const void far *lpvBuf , int cbWrite);
    virtual int     ReadComm(HCOMDEV CommDev,void far* lpvBuf , int cbWrite);
    static HCOMDEV  OpenComm(LPCSTR lpPortName,int QueIn,int QueOut);
    static void     InitComm( HCOMDEV, int, int);
    static int      CloseComm(HCOMDEV hComDev);
    static int      FlushComm(HCOMDEV hComDev);
    static ERRCODE  GetCommError(HCOMDEV hComDev,COMSTAT *ComStat);
    static BOOL     EscapeCommFunction(HCOMDEV hComDev, DWORD dwFunc ) ;
    LRESULT                     SendMessage( HWND  hwnd,UINT  uMsg,WPARAM  wParam, LPARAM  lParam   );


        // Overloaded TCModemPort functions
protected:
        HCOMDEV EXPDEF  Open(LPCSTR lpDevName);
        HCOMDEV EXPDEF  Open(LPCSTR lpDevName, HANDLE);
        HCOMDEV EXPDEF  Close();
        int                             Write(LPBYTE lpData,int nBytes);
        int                             Read(LPBYTE lpData,int nBytes);
        BOOL    EXPDEF  IsPortOpen();
        HCOMDEV                 GetCommDevice();


        //===================================
        // Fax document management functions
        //====================================
        // SendFax
        //====================================

        virtual BOOL    StartFaxSend();
        virtual BOOL    EndFaxSend();
        virtual BOOL    StartSendPage(int PageNo);
        virtual BOOL    EndSendPage(int LineNum=-1);
        virtual int     ReadPageData(LPBYTE lpBuffer,int iSize);

        virtual BOOL    StartSendDocument();
        virtual BOOL    EndSendDocument();

        virtual BOOL    IsSendDocument() ;
        virtual BOOL    IsNewSendDocument();
        virtual BOOL    StartNextDocument() ;

        // Page management
        virtual int                       GetCurrentPage();
        virtual int                       GetSendPages();
        virtual TEPostPageSignal GetPostPageSignal();
        virtual int                       SetPageStatus(int nPage,TEPageStatus  Code);
        virtual TEPageStatus  GetPageStatus(int nPage);
        virtual int           GetFaxParam(TSFaxParam far &Param);
        virtual int           GetLineNum(int PageNo) ;
        virtual DWORD             GetSize(int PageNo);
        virtual void              SendMonoPages();

        //====================================
        // ReceiveFax
        //====================================
        virtual BOOL    StartFaxReceive();
        virtual BOOL    StartReceiveNextDocument();//rz 02-16-99
        virtual BOOL    EndFaxReceive();
        virtual BOOL    EndReceiveOneDocument();//rz 02-16-99
        virtual BOOL    StartReceiveDocument();
        virtual BOOL    EndReceiveDocument();
        virtual BOOL    StartReceivePage(int nPage);
        virtual BOOL    EndReceivePage(int LineNum);
        virtual void    WritePageData(LPBYTE lpBuffer,int nSize);

        void  EXPDEF    GetStationID(LPSTR lpBuffer,int iMax);

        virtual void    SetStatus(TEModemStatus wSt);
        
        void                    onStartDataSend();
        void                    onEndDataSend();
        void                    onStartDataReceive();
        void                    onEndDataReceive();


        void    EXPDEF Terminate(TETerminationStatus TStatus);

protected:
        // Port object list members
        static PORTFAX  First;                          // pointer to first fax port object
        PORTFAX                     Next;                           // pointer to next valid port

    // Communication  port members
        BOOL            bOpenAndClosePort;
        COMSTAT             cs;                                     // Last comm status
        TSCommSetting   PortSet ;

        // error object members
        static                  TCGlobError serr;               // for static member functions
        TCGlobError     xerr;                               // for normal member functions

        // fax document
        FAXOBJ              BaseFax;
		FAXOBJ              Fax;


        BYTE            CommReadBuffer[SIZE_QUEUE];

// Win 32
#ifdef _THREAD
    // Thread specific members
public:
    void                ThreadMain();
    void                CommFunction() ;
    void                EventFunction();
protected:
    //
    DWORD               dwThreadID    ;
    HANDLE              hThread       ;
    HANDLE              hEventThread  ;

    OVERLAPPED          Os          ;
    OVERLAPPED          OsWrite     ;
    OVERLAPPED          OsRead      ;

    char                szWriteBuffer0[SIZE_QUEUE] ;
    char                szWriteBuffer1[SIZE_QUEUE] ;
    char                szReadBuffer[SIZE_QUEUE] ;
        short                   nBuffers ;
    BOOL                bBufNo       ;
    DWORD               dwWriteSize0  ;
    DWORD               dwWriteSize1  ;
    HANDLE              hWriteThread ;
    HANDLE              hWriteEvent  ;
    HANDLE              hBuffer0 ;
    HANDLE              hBuffer1 ;
        BOOL            bDataMode ;

    HANDLE              hEndWriteThreadEvent;
    HANDLE              hEndStartThreadEvent;
#endif

public:     //rz disable port
    void            DisablePort(BOOL disable);
    BOOL            IsPortDisabled();
protected:
    BOOL            bDisabled; //rz
    char            szPrefix[32]; //rz
    FAXOBJ          G3FaxObj  ;     //rz
    BOOL            G5SendingG3;

};
//*****************************************************************************
struct TZeroNumber {
    char    left;
    char    right;
};

extern TZeroNumber ZeroNumber[256];
//*****************************************************************************
#pragma pack()
#endif  // __COMMCL_H
