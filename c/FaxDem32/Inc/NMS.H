#ifndef NMS_H_FILE
#define NMS_H_FILE

#ifndef  __cplusplus
    #error  "This include file must be used with C++ compiler!"
#endif  // __cplusplus



#include "nmstypes.h"
#include "ctadef.h"
#include "adidef.h"
#include "nfxdef.h"
#include "swidef.h"


#include "commcl.h"

typedef DWORD (* EVENT_CALLBACK) (CTA_EVENT * evptr, DWORD closure);

struct NMS_CONNECT{
    CTAHD m_ctahd;
    CTAQUEUEHD m_queueptr;
    HANDLE m_WaitMutex;
};


class CNmsTest
{
public:
      EXPDEF CNmsTest();

      int TestChannel(int board,  int nCh, TSTestResult *datas );
};

///////////////////////////////////////////////////////////////////////////////
class CNmsChannelInfo
{
public:
    CNmsChannelInfo();
    CNmsChannelInfo(DWORD dwBoardNum, DWORD dwStreamNum, DWORD dwTimeSlotNum );
    DWORD   GetBoardNum() { return m_dwBoardNum; }
    void    SetBoardNum( DWORD dwBoardNum ) { m_dwBoardNum = dwBoardNum; }
    DWORD   GetStreamNum() { return m_dwStreamNum; }
    void    SetStreamNum( DWORD dwStreamNum ) { m_dwStreamNum = dwStreamNum; }
    DWORD   GetTimeSlotNum() { return m_dwTimeSlotNum; }
    void    SetTimeSlotNum( DWORD dwTimeSlotNum ) { m_dwTimeSlotNum = dwTimeSlotNum; }
    DWORD   GetChannelNum() { return m_dwTimeSlotNum; }
    void    SetChannelNum( DWORD dwTimeSlotNum ) { m_dwTimeSlotNum = dwTimeSlotNum; }
    int     SetState(TEChannelState newState);
    TEChannelState GetState() { return m_State; };

    CNmsChannelInfo* m_pNext;
    CHAR      m_szDeviceName[32];
    CHAR      m_szLongDeviceName[32];

protected:

    DWORD     m_dwBoardNum;
    DWORD     m_dwStreamNum;
    DWORD     m_dwTimeSlotNum;
    TEChannelState m_State;
};

typedef CNmsChannelInfo* PCNmsChannelInfo;




class FAXAPI TCCommClassNms : public TCCommPure
{
    friend class TCFaxNormal;

public:
      EXPDEF TCCommClassNms();
      virtual EXPDEF ~TCCommClassNms();
      static PORTFAX CALLBACK CreateTCCommClass(LPSTR FaxShortName, LPSTR FileName);
      static void  InitNms();
      static void  ExitNms();

      static  int GetChannelNum( unsigned int board );
      static  int GetBoardNum() { return m_BoardNr; };
      static  TEChannelState GetChannelState( int board, int nChannel);

      int GetNrOfRings(){return dwNrRings;}
      virtual int ConnectPort( LPSTR pPortName, HANDLE );
      virtual int DisconnectPort();
      virtual int DisconnectPortEx(BOOL bDSR);
      CTAHD GetContextHandle(){return m_ctahd;}
      CTAQUEUEHD GetQueueHandle(){return m_queueptr;}

      FAXOBJ EXPDEF AbortFax();

      virtual void EXPDEF AutoAnswer( int RingNum=3 );
      virtual int EXPDEF AnswerNow( BOOL Manual=TRUE );

      virtual  void SetDigitNumber( int n );
      virtual  int SetDTMFDigits( int n, char Value );
      virtual  int GetDTMFDigits( LPSTR lpBuffer, int Max );
      int SetDigitTimers(int first, int next);
      void GetDID( LPSTR dstBuf );
      static void SetDID(int nDigits);

      int WaitForDigitPattern( LPCSTR pattern,  int nMaxDigits );

      bool SubmitFaxes();
      bool ReceiveFax();
      TETerminationStatus CallStatus;
      TETerminationStatus ConvertTermCode(int code);
      TETerminationStatus ConvertStatusCode(int code);
      bool    m_bSending;
      bool    m_bReceiving;

      bool    m_bStopWait;
      HANDLE  m_hWaitThread;
      HANDLE  m_hSendThread;
      HANDLE  m_hSendNow;
      HANDLE  m_hReceiveNow;

      BOOL OutOfService;
      static bool m_QXsupport;
      static char m_szProtocol[256];
      static int DIDDigitNum;
protected:
      static int m_BoardNr;
      static int m_Channels[128];


      static PCNmsChannelInfo m_pChannels;

      CTAHD m_ctahd;
      CTAQUEUEHD m_queueptr;
      PCNmsChannelInfo m_pChannel;

      HANDLE  m_VoiceMutex;

      static BOOL DetectNmsHardware();
      PCNmsChannelInfo SearchChannel( LPCSTR pPortName );
      static LONG CountAllChanOnBoard( DWORD dwBardNum, PCNmsChannelInfo *pHEAD );
      static BOOL OpenServices(CTAHD* ctahd, CTAQUEUEHD* queueptr, DWORD board, DWORD stream, DWORD timeslot, DWORD dwId);
      static BOOL CloseServices(CTAHD* ctahd, CTAQUEUEHD* queueptr, DWORD board, DWORD stream, DWORD timeslot);
      BOOL StartProtocol();
      virtual int InitialSetup();

      BOOL StartReceivePage();
      BOOL EndReceivePage();
      int EXPDEF  SendFax( FAXOBJ aFax, BOOL Manual );
      BOOL EXPDEF StartSend();
      
      void ReleaseCall();
      bool bRelease;
      int PhaseD();
      void Call();
      void Answer();
      
      //void PutToLog(LPCSTR Format, ...);
      
      void StopWait();

      bool WaitForDigits(bool& Stop, int NrOfDigits, LPSTR buffer, char delimiter = 'n' );
      
      void EXPDEF Terminate(TETerminationStatus inTStatus);

      NFX_DOC_PARMS* ConvertDocParams(NFX_DOC_PARMS* parms);
      NFX_TRANSMIT_PARMS* ConvertTransmitParams(NFX_TRANSMIT_PARMS* parms);

      int     m_nActPage;  // zero based page counter



      TETransmitPhase Phase;
      DWORD   dwNrRings;

      char* m_pDigits;
      char* m_pDIDDigits;
      char  m_szPattern[32];
      int NrOfDigits;
      int NrOfDIDDigits;
      int m_nFirstDigitTimeOut;
      int m_nNextDigitTimeOut;


      HANDLE  m_hSendFinished;
      HANDLE  m_hWaitStarted;
      HANDLE  m_hRingThread;

      static HANDLE m_hFileCreateMutex;
};

#endif