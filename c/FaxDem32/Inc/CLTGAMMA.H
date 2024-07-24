/****************************************************************************/
/*            (c) Copyright Black Ice Software Inc.  1994.                  */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/****************************************************************************/

#ifndef  __cplusplus
    #error  "This inlude file must be used with C++ compiler!"
#endif  // __cplusplus

#ifndef __CLTGAMMA_H
#define __CLTGAMMA_H

//****************************************************************************
// Include
#include "commcl.h"

//****************************************************************************

#define SENDING     1
#define RECEIVING   2
#define FINISH      3
#ifndef ERROR
    #define ERROR   4
#endif
#define MANUAL      5

typedef struct {
    int did_type;
    int digit_type;
    int ShutDown;
    TEErrorCorrect rec_ecm;
    TEErrorCorrect send_ecm;
    TEResolution res;
    TEBaudRate minrate;
    TEBaudRate maxrate;
    TESpeakerTurnOn speaker;
    TEImageType comp;
} G_Config;

class FAXAPI TCCommClassGamma : public TCCommPure
{
    friend DWORD WINAPI GammaChannelThread( LPVOID param );
	friend DWORD WINAPI FinishFaxReceptionThread( LPVOID param );
public:
    static PORTFAX CALLBACK CreateTCCommClass(LPSTR FaxShortName, LPSTR FileName);
	EXPDEF TCCommClassGamma(LPSTR CfgFileName);
    virtual EXPDEF ~TCCommClassGamma();

    char        m_szNum[MAX_CALLNUMBER];
    int         m_PageNo ;
    BOOL        m_bStopWait;
    BOOL        m_bFinishing;
    bool        m_bAnswerNow;
    TMControl*  m_pControl;
    HANDLE      m_hControl;     
    HANDLE      m_hWaitThread;
    static BOOL m_fNeedConfig;
    TECompression m_realcomp;

    static  int     InitGamma();
    static  void    ExitGamma();
            int     GetChannelNum() { return m_nLogicalChannel; };
            LPSTR   GetTiffName() { return m_szTiffName; };

    inline  BOOL    GetRecFlag() { return bStartReceive; } ;
    inline  BOOL    GetSendFlag() { return bStartSendDoc; } ;
    inline  BOOL    GetAbort() { return m_abort; } ;
    inline  G_Config *GetConfig() { return &m_cfg; } ;
    inline  static int GetAllChannelNum() { return m_AllChannelNum ; } ;
            int     GetStatus( CPRECORD *rec );

    virtual int	    EnableFaxPort(BOOL Enable);
            void    GetDID( LPSTR dstBuf );
    virtual int     ConnectPort( LPSTR PortName, HANDLE = NULL);
    virtual int	    DisconnectPort();
    virtual int	    DisconnectPortEx (BOOL bDSR);
    virtual FAXOBJ  EXPDEF AbortFax ();
    virtual BOOL    IsOpen();
    virtual BOOL    SetupPortCapabilities(TSModemCapabiliti &NewModemCap );
    virtual void    SetStationID(LPCSTR lpBuffer);
    virtual void	EXPDEF SetDialMode(TEDialMode NewMode );
    virtual  int    SetHeader( BOOL bHeader );
    virtual void	EXPDEF AutoAnswer (int RingNum);
    virtual  int    AnswerNow( BOOL Manual );
            void    StartControlSend();
            void    StartControlWait();
            void    StartControlAnswer();
     inline  int    GetLastStatus() { return m_LastStatus; };
     inline void    SetLastStatus(int newst) { m_LastStatus=newst; };
     static BOOL    IsChannelFree( int num );
     static TEBaudRate GetSpeed(int speed);
     static  int    GetSpeed(TEBaudRate speed);
    TETerminationStatus CheckError( int status );
             int    GetDigitNumber() { return  m_cDTMFDigits; } ;
            BOOL    SubmitDocument();
            void    DumpQueuerecord();
             int    GetDTMFDigits( LPSTR, int);
             int    SetDTMFDigits( int n, char Value );
             int    WaitForCall();
             int    InitialSetup();
            bool    SubmitFaxes();
            bool    ReceiveFax();
            void    on_ReceiveDIS(FaxDIS* theDIS);
            BOOL    on_ReceiveDCS(FaxDIS* theDCS);
            void    ReceiveSpeed(FaxDIS* theDCS);
             int    ResetModem();
             int    SendFax( FAXOBJ aFax, BOOL /*Manual*/ );
            BOOL    StartSend();
            BOOL    StartAnswer();
    virtual void EXPDEF ReturnPageFile( BOOL bReturn );
    virtual BOOL EXPDEF IsPageFileReturned();
    virtual int  EXPDEF GetLastPageFileName( LPSTR lpBuf, int size );
    
    int     m_nLogicalChannel;
    int     m_nThreadStarted;
#ifdef _DEBUG	
	void	DOut( char* format, ... );
	void	DOut(LPCSTR lpCstr);
#endif
protected:
    TCGlobError xerr;
    static int m_AllChannelNum;

    int     m_LastStatus;
    int     m_CurPage ;
    char    m_szTiffName[MAX_PATH];
    char    m_GammaDir[MAX_PATH];
    char    m_cfgFile[MAX_PATH];
    char    m_QueueFile[MAX_PATH];
    char    m_szGFName[MAX_PATH];
    char    m_szNameConstant[MAX_PATH];
    GFQRECORD m_qrec;
    GRT_EVENT m_event;
    G_Config m_cfg;
    BOOL    m_bBadFile;
    BOOL    m_bDeleteFile;
    BOOL    m_header;   // TRUE if header must be sent
    BOOL    m_abort;    // TRUE when we have to abort the actual 
                        // transmission at the next event
    BOOL    m_bReset;
	BOOL	m_bTerminateSent;
    char     m_strDigits[64];   // place for DTMF & DID info
    int      m_cDTMFDigits;     // no. of DTMF digits

	TETerminationStatus trmsts;

    TMControl *m_Jump;
    void	Init();
    void    SetSessionValues();
    void    StopAnswer();
    void    StopSend();
    void    StopWait();
    void    GetPageParams();
     int    ReadConfig();
     int    ReadRegistry();
    void    PurgeRecords();
	void    EXPDEF Terminate(TETerminationStatus TStatus);

    virtual BOOL 	StartSendDocument();
    virtual BOOL 	EndSendDocument();

    virtual BOOL    StartReceivePage(int nPage);
    virtual BOOL  	EndReceivePage(int LineNum);
    virtual BOOL    StartFaxReceive();
    virtual BOOL    EndFaxReceive();
	virtual void    LocalInit();
	long			m_dwCurRingNum;
};

#endif // __CLTGAMMA_H
