
#ifndef  __cplusplus
    #error  "This inlude file must be used with C++ compiler!"
#endif  // __cplusplus

#ifndef __DIALOGIC_H
#define __DIALOGIC_H

#include <srllib.h>
#include "commcl.h"
#include <dxxxlib.h>

#define MAX_BUF_SIZE    120
#define WINBUFFSIZE     512
#define MAXFILE         8
#define MAXFILELEN      256
#define MAXDIALLEN      20
#define MAXDEVNAMELEN   12
#define MAXHDRLEN       30
#define MAXIDLEN        20
#define BITMAP_WIDTH    16
#define BITMAP_HEIGHT   16
#define NUM_BITMAPS     2
#define BOARD_DESCR_LEN 30
#define REMOTEIDLEN     21

#define NUM_CHANNELS_D160 16
#define NUM_CHANNELS_D240 24
#define NUM_CHANNELS_D320 32

#define SENDING     1
#define RECEIVING   2
#define FINISH      3
#ifndef MANUAL
    #define MANUAL      4
#endif

#define VOCFILE_ID              0x19730731
#define COMPRESSION_ID_LENGTH   50

typedef struct
{
    char    szCompiID[COMPRESSION_ID_LENGTH];
    char    cVBS;           // Bits per sample
    BOOL    bWAV;           // Used by Dialogic and Bicom from version (3.1.0)
    int     cDataFormat;    // Used by Dialogic and Bicom from version (3.1.0)
    int     cSamplePerSec;  // Used by Dialogic and Bicom from version (3.1.0)
}VOCFILEINFO;

typedef struct
{
    long     lVocID;     // ID of the voice file ()
    long     lCreateTime;
    unsigned long   lVersion;// version number of the voice.dll that created this file
    long     lStructSize;    // size of structure VOCFILEINFO
}VOCFILEMAINSTR;

class CBoardInfo;
class CChannelInfo;

///////////////////////////////////////////////////////////////////////////////
class FAXAPI TCCommClassDialogic : public TCCommPure
{
    friend class TCFaxNormal;
public:
    static PORTFAX CALLBACK CreateTCCommClass(LPSTR FaxShortName, LPSTR FileName);
	EXPDEF TCCommClassDialogic();
    virtual EXPDEF ~TCCommClassDialogic();

    char        m_szNum[MAX_CALLNUMBER];
    int         m_PageNo ;
    int         GetVoiceHandle() { return m_VoiceHandle; };
    int         GetFaxHandle() { return m_FaxHandle; };
    HANDLE      m_hWaitThread;
    bool        m_bAnswerNow;

           bool SubmitFaxes();
           bool ReceiveFax();
    static void InitDialogic();
    static void ExitDialogic();
    static  int GetChannelType( int board, int nChannel, PSTR pBuf, int len );
    static  int GetChannelNum( int board );
    static  int GetBoardNum() { return m_BoardNr; };
    static TEChannelState GetChannelState( int board, int nChannel );
    static  int GetAllChannelNum();

    virtual int ConnectPort( LPSTR PortName, HANDLE = NULL);
    virtual int DisconnectPort();
    virtual int DisconnectPortEx(BOOL bDSR);
    virtual void EXPDEF AutoAnswer( int RingNum );
    virtual int EXPDEF AnswerNow( BOOL Manual=TRUE );
    virtual BOOL EXPDEF SetupPortCapabilities( TSModemCapabiliti &NewModemCap );
    virtual FAXOBJ EXPDEF AbortFax();
    virtual BOOL IsOpen();
    // DTMF
    virtual void SetDigitNumber( int n );
    virtual  int SetDTMFDigits( int n, char Value );
             int    SetVoiceFile( LPSTR lpFileName );
             int    GetVoiceFile( LPSTR lpBuffer, int Max );
    unsigned short FindDigMask(char cMask);
    virtual  int SetVoiceTimeout( unsigned int WaitTime );
    virtual  int GetDTMFDigits( LPSTR lpBuffer, int Max );
	virtual void GetDID( LPSTR dstBuf );
	virtual bool PlayFile();
    virtual bool ReadVoiceInfo();
            bool WaitForRestOfDigits();

    // header
    virtual  int HeaderMode( WORD mode );
    virtual  int HeaderDateFormat( TEDialogicDateMode format );
    virtual  int HeaderDateTimeString( LPSTR pDateString );
    virtual  int HeaderStartPage( WORD page );
    virtual  int HeaderTimeFormat( TEDialogicTimeMode format );
    virtual  int HeaderUser1( LPSTR pUserLine );
    virtual  int HeaderUser2( LPSTR pUserLine );

    virtual int InitialSetup();
	virtual int ResetModem();
	virtual int WaitForCall();
    virtual void SetStationID( LPCSTR lpBuffer );

            int PhaseB();
            int PhaseD();

    virtual BOOL EXPDEF StartAnswer();
    virtual BOOL EXPDEF StartSend();
    virtual int  EXPDEF SendFax( FAXOBJ aFax, BOOL Manual=FALSE );

protected:
    TETerminationStatus Call();
    void    StopWait();
	void    EXPDEF Terminate(TETerminationStatus TStatus);
    TETerminationStatus ConvertTermCode( int code );
    TEResolution ConvertRes( int DRes);
    TEPageWidth ConvertWidth( int DWidth );
    TEBaudRate ConvertSpeed( int DRate );
    TECompression ConvertCompression( int DCompression );
    int     RConvertWidth( TEPageWidth DWidth );
    int     RConvertSpeed( TEBaudRate DRate );
    void    SetFax40Capabilities( TSModemCapabiliti* cap );
    void    SetFax40ECapabilities( TSModemCapabiliti* cap );
    void    SetFax120Capabilities( TSModemCapabiliti* cap );
    bool    ReceiveDTMF();

    bool    m_bStopWait;
    bool    m_bDlgcHdr;
     int    m_nActPage;  // zero based page counter
    static BOOL DetectDialogicHardware( BOOL bInit );
    static int GetIndex( int board, int nChannel );
    int     m_inFile;
    TCStr    m_strVoiceFile;
	VOCFILEMAINSTR	m_vocFile;
	VOCFILEINFO		m_vocInfo;
	//PVOICEINFOEXT	m_pVoiceInfo;
	DV_DIGIT		m_dvd;

    virtual BOOL StartReceivePage();
    virtual BOOL EndReceivePage();

           int m_nChannel;
           int m_VoiceHandle;
           int m_FaxHandle;
           int m_digitnr; // number of DTMF digits to catch
           int m_DtmfTimeout;
         char* m_pDigits;

    static CBoardInfo* m_pBoards;
    static CChannelInfo* m_pChannels;
    static char m_caFaxLibVer[120];
    static int m_BoardNr;
    static int m_FaxChannelNr;
};

#endif
