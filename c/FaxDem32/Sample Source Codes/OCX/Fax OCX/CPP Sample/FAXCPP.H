/****************************************************************************/
/*            (c) Copyright Black Ice Software Inc.  1994.                  */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/*                                                                          */
/*                                                                          */
/****************************************************************************/

#ifndef __FAXCPP_H
#define __FAXCPP_H
#pragma pack(4)

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Include
#include "port32.h"
#include "faxtype.h"

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  Port functions
#ifdef  __cplusplus
extern "C" {
#endif  // __cplusplus

typedef HANDLE HDIB;

FAXAPI PORTFAX FAXAPI16 ConnectPort (LPSTR PortName, LPSTR FaxName);
FAXAPI PORTFAX FAXAPI16 ConnectPortExt (LPSTR PortName, LPSTR FaxName, LPSTR IniFileName);
//-> change for tapi start <--
FAXAPI PORTFAX FAXAPI16 ConnectPortHandle (LPSTR PortName, HANDLE, LPSTR FaxName);
FAXAPI PORTFAX FAXAPI16 ConnectPortHandleExt (LPSTR PortName, HANDLE, LPSTR FaxName, LPSTR IniFileName);
//-> change for tapi end <--
FAXAPI PORTFAX FAXAPI16 GetPortID (LPSTR PortName);
FAXAPI int FAXAPI16     DisconnectPort(PORTFAX Port);

FAXAPI int FAXAPI16     EnableFaxPort(PORTFAX Port, BOOL Enable);
FAXAPI int FAXAPI16     IsFaxPortEnabled(PORTFAX Port); // 0 - Disable; 1 - Enable; <0 Error
FAXAPI int FAXAPI16     SetModemCommands (PORTFAX Port, LPSTR StartFaxInic, LPSTR HangUp, LPSTR Dial, LPSTR Answer);


////////////////////////////////////////////////////////////////////////////////////////////////


FAXAPI  PORTFAX FAXAPI16 CreatePort(LPSTR lpClassName);
FAXAPI  int     FAXAPI16 ConnectToCommPort(PORTFAX Port,LPCSTR lpCommPortName);
FAXAPI  int     FAXAPI16 DisconnectToCommPort(PORTFAX Port,BOOL bDSR);
FAXAPI  void    FAXAPI16 DeleteCommPort(PORTFAX Port);
FAXAPI  int     FAXAPI16 LoadPortSetting(LPSTR lpModem,LPSTR lpIniFileName);
FAXAPI  BOOL    FAXAPI16 IsPortOpen(PORTFAX Port);
FAXAPI  HCOMDEV FAXAPI16 GetDeviceHandle(PORTFAX Port);
FAXAPI  BOOL    FAXAPI16 IsPortVoice(PORTFAX Port);
FAXAPI  DWORD   FAXAPI16 GetUserLongPort(PORTFAX Port);
FAXAPI  void    FAXAPI16 SetUserLongPort(PORTFAX Port, DWORD dwUser);

////////////////////////////////////////////////////////////////////////////////////////////////

FAXAPI int   FAXAPI16   SetModemCommand( PORTFAX Port, int CommandNum,LPSTR lpCommand);
FAXAPI int   FAXAPI16   SetCommandTimeout( PORTFAX Port, int CommandNUm,DWORD dwMiliSec);
FAXAPI int   FAXAPI16   GetModemCommand( PORTFAX Port, int CommandNum ,LPSTR lpBuffer,int cbBuffer);
FAXAPI DWORD FAXAPI16   GetCommandTimeout( PORTFAX Port, int CommandNum);

FAXAPI int EXPDEF
SetupCommPort(
PORTFAX Port,
#ifndef __cplusplus
struct
#endif
TSCommSetting far *NewSet);

FAXAPI int EXPDEF
GetCommPortSetting(
PORTFAX Port,
#ifndef __cplusplus
struct
#endif
TSCommSetting *ComSet);

FAXAPI int EXPDEF
SetupPortCapabilities(
PORTFAX Port,
#ifndef __cplusplus
struct
#endif
TSModemCapabiliti far *NewModemCap );

FAXAPI int EXPDEF
GetPortSetting( PORTFAX Port,
#ifndef __cplusplus
struct
#endif
TSModemCapabiliti far *PortSet );

FAXAPI int EXPDEF
GetModemCapabiliti( PORTFAX Port,
#ifndef __cplusplus
struct
#endif
TSModemCapabiliti far *ModemCap );

FAXAPI int EXPDEF
GetModemCapability( PORTFAX Port,
#ifndef __cplusplus
struct
#endif
TSModemCapability far *ModemCap );

FAXAPI int EXPDEF
GetCapabiliti( PORTFAX Port,
#ifndef __cplusplus
struct
#endif
TSModemCapabiliti far *NewModemCap );

FAXAPI int EXPDEF
GetCapability( PORTFAX Port,
#ifndef __cplusplus
struct
#endif
TSModemCapability far *NewModemCap );

FAXAPI int EXPDEF
GetRemoteModemCapabiliti( PORTFAX Port,
#ifndef __cplusplus
struct
#endif
TSModemCapabiliti far *ModemCap );

FAXAPI int EXPDEF
GetRemoteModemCapability( PORTFAX Port,
#ifndef __cplusplus
struct
#endif
TSModemCapability far *ModemCap );

FAXAPI int EXPDEF
GetSessionParameters( PORTFAX Port,
#ifndef __cplusplus
struct
#endif
TSSessionParameters far* theSession );

//================================================================
FAXAPI int FAXAPI16     EnableLog(PORTFAX Port,BOOL bEnable);
FAXAPI void FAXAPI16    SetLogDir(LPCSTR lpPath);
FAXAPI void FAXAPI16    CommentLog(PORTFAX Port,LPCSTR lpStr);
FAXAPI void FAXAPI16    EnableBitOrderDetect( void);
FAXAPI void FAXAPI16    DisableBitOrderDetect( void);

///////////////////////////////////////////////////////////////////////////////////////////////
FAXAPI void FAXAPI16    DisablePort(PORTFAX Port, BOOL disable);

FAXAPI void FAXAPI16    SetPrefix(PORTFAX Port, char* prefix);
FAXAPI void FAXAPI16    GetPrefix(PORTFAX Port, char* prefix);

FAXAPI BOOL FAXAPI16    IsSubaddressEnabled(PORTFAX Port);
FAXAPI void FAXAPI16    EnableSubaddress(PORTFAX Port, BOOL enabled);

FAXAPI void FAXAPI16    GetPortStatus (PORTFAX Port, struct TSPortStatus far * PortStatus);
FAXAPI void FAXAPI16    AbortPort (PORTFAX Port);
FAXAPI void FAXAPI16    DeleteAllPort();
FAXAPI int  FAXAPI16    GetNumberOfPorts (PORTFAX far *Port);
FAXAPI int  FAXAPI16    PortCapabilities (PORTFAX Port, enum TEFaxCapability Cap);
FAXAPI int  FAXAPI16    SetPortCapabilities (PORTFAX Port, enum TEFaxCapability Cap, int Value);

FAXAPI int  FAXAPI16    EnableTasks (PORTFAX Port, BOOL Enable);
FAXAPI int  FAXAPI16    SetSpeaker (PORTFAX Port, enum TESpeakerTurnOn SpkTurnOn, enum TESpeakerVolume SpkVolume);

// Send FAX
FAXAPI FAXOBJ FAXAPI16  CreateSendFax (char FaxType, struct TSFaxParam far * Param);
FAXAPI int FAXAPI16     SetFaxImagePage (FAXOBJ Fax, int PageNum, enum TEImageType Type, union TUFaxImage far * PageImage, int ImageNum);
FAXAPI int FAXAPI16     GetAllFaxType (LPSTR FaxTypes);
FAXAPI int FAXAPI16     PutFaxOnQueue (FAXOBJ Fax);
FAXAPI int FAXAPI16     SendFaxNow(PORTFAX Port, FAXOBJ Fax, BOOL Manual);
FAXAPI int FAXAPI16     SetNextFax( FAXOBJ Fax, FAXOBJ NextFax );
FAXAPI FAXOBJ FAXAPI16  GetNextFax( FAXOBJ Fax );
FAXAPI char FAXAPI16    GetFaxType( FAXOBJ Fax );

// Receive FAX
FAXAPI int FAXAPI16     SetFaxMessage (HWND hWnd);
FAXAPI int FAXAPI16     KillFaxMessage (HWND hWnd);
FAXAPI int FAXAPI16     GetFaxParam (FAXOBJ Fax, struct TSFaxParam far * Param);
FAXAPI int FAXAPI16     GetFaxImagePage (FAXOBJ Fax, int PageNum, enum TEImageType Type, union TUFaxImage far * PageImage, BOOL Append);
FAXAPI int FAXAPI16     ManualAnswer (PORTFAX Port);
FAXAPI void FAXAPI16    SetAutoAnswer (PORTFAX Port, int RingNum); // -1 never
FAXAPI int FAXAPI16     GetDTMFDigits( FAXOBJ Fax, LPSTR pBuff, int nr );

// QUEUE service function
FAXAPI FAXOBJ FAXAPI16    GetObjFromSendQueue ();
FAXAPI FAXOBJ FAXAPI16    GetObjFromReceiveQueue ();
FAXAPI FAXOBJ FAXAPI16    GetNextFaxQueueObj (FAXOBJ lastObj);
FAXAPI void FAXAPI16      ClearFaxObj (FAXOBJ Fax);

FAXAPI int FAXAPI16     Read(FAXOBJ Fax, HFILE hFile);
FAXAPI int FAXAPI16     Write(FAXOBJ Fax, HFILE hFile);
FAXAPI int FAXAPI16     ReadHeader(FAXOBJ Fax, HFILE hFile);
FAXAPI int FAXAPI16     WriteHeader(FAXOBJ Fax, HFILE hFile);
FAXAPI int FAXAPI16     ReadHeaderExt(FAXOBJ Fax, HFILE hFile, struct TSFaxHeader far *Header);
FAXAPI int FAXAPI16     WriteHeaderExt(FAXOBJ Fax, HFILE hFile, struct TSFaxHeader far *Header);
FAXAPI int FAXAPI16     ReadImgData(FAXOBJ Fax, HFILE hFile);
FAXAPI int FAXAPI16     WriteImgData(FAXOBJ Fax, HFILE hFile);
FAXAPI int FAXAPI16     SetFaxHeader(FAXOBJ Fax, struct TSHeaderContext far *lpContext);

// Other functions
FAXAPI void FAXAPI16      SetMyID (LPSTR MyID);
FAXAPI void FAXAPI16      SetStationID(PORTFAX Port,LPCSTR lpStr);

FAXAPI int FAXAPI16       SetupFaxDriver (LPSTR FaxManDLLName);
FAXAPI void FAXAPI16      EndOfFaxDriver (BOOL KillNow);
FAXAPI int FAXAPI16       SetFaxObjDir(LPSTR FaxObjDir);
FAXAPI UINT FAXAPI16      GetFaxCppVersion(LPSTR String, int Size);
FAXAPI void FAXAPI16      SetRuningMode( enum TERuningMode RunMode);
FAXAPI void  FAXAPI16     SetPhaseCoverage( enum TEPhaseCoverage aPhaseCoverage);
FAXAPI
#ifndef __cplusplus
enum
#endif
TERuningMode
FAXAPI16 GetRuningMode();

FAXAPI void FAXAPI16      PostRegMessage (UINT Msg, WPARAM wParam, LPARAM lParam);
FAXAPI HWND FAXAPI16      GetFaxSystemDialogBox();
FAXAPI int  FAXAPI16      FaxModemTest(LPSTR Port, struct TSTestResult far *ModemTest);
//FZ 05.07.2004 Dialton detection 
FAXAPI int FAXAPI16      DetectDialTone(LPSTR Port);
/////////////////
FAXAPI int  FAXAPI16      SetDialMode( PORTFAX Port, enum TEDialMode NewMode);
FAXAPI long FAXAPI16      FaxEventHandler (void far * ThisPtr, enum TEFaxEvent Event, LPARAM lParam);

#if defined(WIN32)
// functions for Brooktrout
FAXAPI BOOL    FAXAPI16   IsBrooktrout();
FAXAPI BOOL    FAXAPI16   B_IsBrooktrout();
FAXAPI int     FAXAPI16   B_SetHeader( PORTFAX Port, LPSTR lpText );
FAXAPI int     FAXAPI16   B_SetHeaderType( PORTFAX Port, BOOL bType );
FAXAPI int     FAXAPI16   SetHeader( PORTFAX Port, LPSTR lpText );
FAXAPI int     FAXAPI16   SetHeaderType( PORTFAX Port, BOOL bType );
FAXAPI char *  FAXAPI16   GetChannelInfo();
FAXAPI char *  FAXAPI16   B_GetChannelInfo();
FAXAPI BOOL    FAXAPI16   IsChannelFree(int num);
FAXAPI BOOL    FAXAPI16   B_IsChannelFree(int num);
FAXAPI int     FAXAPI16   EnableDebug( enum TEDebugMode Mode );
FAXAPI int     FAXAPI16   B_EnableDebug( enum TEDebugMode Mode );
FAXAPI int     FAXAPI16   B_DialDBCheck( PORTFAX Port, LPSTR lpDBFile, LPSTR lpNumber,
                                  long *lpWaitTime, int *lpReason );
FAXAPI int     FAXAPI16   B_GetDID( PORTFAX Port, LPSTR lpDstBuf );
FAXAPI int     FAXAPI16   B_SetDigitNumber( PORTFAX Port, int n );
FAXAPI int     FAXAPI16   B_SetVoiceTimeout( PORTFAX Port, int n );
FAXAPI int     FAXAPI16   B_SetVoiceFile( PORTFAX Port, LPSTR lpVoiceFile );

// functions for GammaLink
FAXAPI BOOL    FAXAPI16   IsGamma();
FAXAPI BOOL    FAXAPI16   G_IsGamma();
FAXAPI BOOL    FAXAPI16   G_IsChannelFree(int num);
FAXAPI int     FAXAPI16   G_GetChannelNum();
FAXAPI int     FAXAPI16   G_SetHeader( PORTFAX Port, BOOL bHeader );
FAXAPI int     FAXAPI16   G_GetLastStatus( PORTFAX Port );
FAXAPI BOOL    FAXAPI16   G_NeedConfig();

// functions for Dialogic API

FAXAPI BOOL    FAXAPI16   D_IsChannelFree( int board, int num );
FAXAPI int     FAXAPI16   D_GetChannelNum( int board );
FAXAPI int     FAXAPI16   D_GetBoardNum();
FAXAPI int     FAXAPI16   D_HeaderMode( PORTFAX Port, WORD wMode );
FAXAPI int     FAXAPI16   D_HeaderDateFormat( PORTFAX Port, enum TEDialogicDateMode format );
FAXAPI int     FAXAPI16   D_HeaderDateTimeString( PORTFAX Port, LPSTR pDateString );
FAXAPI int     FAXAPI16   D_HeaderStartPage( PORTFAX Port, WORD page );
FAXAPI int     FAXAPI16   D_HeaderTimeFormat( PORTFAX Port, enum TEDialogicTimeMode format );
FAXAPI int     FAXAPI16   D_HeaderUser1( PORTFAX Port, LPSTR pUserLine );
FAXAPI int     FAXAPI16   D_HeaderUser2( PORTFAX Port, LPSTR pUserLine );
FAXAPI void    FAXAPI16   D_Disable( BOOL b );

// functions for Bicom API
FAXAPI int     FAXAPI16   BCM_SetVoiceFile( PORTFAX Port, LPCSTR lpVoiceFile );
FAXAPI int     FAXAPI16   BCM_SetDigitTimers( PORTFAX Port, int first, int next);
#ifdef  __cplusplus
FAXAPI int     FAXAPI16   BCM_GetChannelState( PORTFAX Port, int board, int nChannel, enum TEChannelState& state );
#endif
FAXAPI int     FAXAPI16   BCM_TestChannel( PORTFAX Port, int board, int nChannel,  struct TSTestResult* pResult );
FAXAPI unsigned char* FAXAPI16 BCM_CheckBicom();
FAXAPI int     FAXAPI16   BCM_GetBoardNum();
FAXAPI int     FAXAPI16   BCM_GetChannelNum( int board );
FAXAPI BOOL    FAXAPI16   BCM_IsChannelFree( int board, int num);
FAXAPI int     FAXAPI16   BCM_GetDTMFDigits(PORTFAX Port, LPSTR lpBuffer, int Max);
FAXAPI void    FAXAPI16   BCM_SetEventHandler(PVOID lpfnHandler);
//FAXAPI int     FAXAPI16   BCM_SetDigitNumber( PORTFAX Port, int n );
FAXAPI int     FAXAPI16   TestBicom( LPSTR szPort, struct TSTestResult* ModemTest );

// functions for Commetrex API
FAXAPI int     FAXAPI16   C_SetVoiceFile( PORTFAX Port, LPCSTR lpVoiceFile );
FAXAPI int     FAXAPI16   C_SetDigitTimers( PORTFAX Port, int first, int next);
#ifdef  __cplusplus
FAXAPI int     FAXAPI16   C_GetChannelState( PORTFAX Port, int nChannel, enum TEChannelState& state );
#endif
FAXAPI int     FAXAPI16   C_TestChannel( PORTFAX Port, int nChannel, struct TSTestResult* pResult );
FAXAPI int     FAXAPI16   C_GetBoardNum();
FAXAPI int     FAXAPI16   C_GetChannelNum( );
FAXAPI BOOL    FAXAPI16   C_IsChannelFree( int num);
FAXAPI int     FAXAPI16   C_GetDTMFDigits(PORTFAX Port, LPSTR lpBuffer, int Max);
FAXAPI int     FAXAPI16   TestCommetrex( LPSTR szPort, struct TSTestResult* ModemTest );

// functions for Nms API
FAXAPI int     FAXAPI16   NMS_GetBoardNum();
FAXAPI int     FAXAPI16   NMS_GetChannelNum( int board );
FAXAPI BOOL    FAXAPI16   NMS_IsChannelFree( int board, int num);
FAXAPI int     FAXAPI16   NMS_SetDigitTimers( PORTFAX Port, int first, int next);
FAXAPI int     FAXAPI16   NMS_GetChannelState(PORTFAX Port,int nBoard, int nChannel);
FAXAPI int     FAXAPI16   NMS_TestChannel(PORTFAX Port, int nBoard, int nChannel, struct TSTestResult* pResult );
FAXAPI int     FAXAPI16   NMS_GetDTMFDigits(PORTFAX Port, LPSTR lpBuffer, int Max);
FAXAPI int     FAXAPI16   TestNms( LPSTR szPort, struct TSTestResult* ModemTest );
FAXAPI BOOL    FAXAPI16   NMS_SetProtocol( char* protocol);
FAXAPI void    FAXAPI16   NMS_SetDIDDigitNumber( int nDigits );
FAXAPI int     FAXAPI16   NMS_WaitForDigitPattern(PORTFAX Port, LPCSTR pattern,  int nMaxDigits );
// general functions for fax cards
#ifdef _WIN32
FAXAPI int     FAXAPI16   ComBoard( PORTFAX Port );
#endif // _WIN32
FAXAPI PORTFAX FAXAPI16   ConnectChannel(LPSTR ChName, LPSTR CfgName, enum TEBoardType board);
FAXAPI int     FAXAPI16   TestGammaLink(LPSTR szPort, struct TSTestResult FAR *ModemTest, LPSTR lpCfgFile );
FAXAPI int     FAXAPI16   TestBrooktrout(LPSTR szPort, struct TSTestResult FAR *ModemTest);
FAXAPI int     FAXAPI16   TestDialogic(LPSTR szPort, struct TSTestResult FAR *ModemTest);
FAXAPI int     FAXAPI16   GetDID( PORTFAX Port, LPSTR lpDstBuf );
FAXAPI int     FAXAPI16   SetDigitNumber( PORTFAX Port, int n );
FAXAPI int     FAXAPI16   SetVoiceTimeout( PORTFAX Port, int n );
FAXAPI int     FAXAPI16   SetVoiceFile( PORTFAX Port, LPCSTR lpVoiceFile );

FAXAPI void    FAXAPI16   InitSessionParameters( struct TSSessionParameters FAR *theSession);
FAXAPI void    FAXAPI16   SetSessionParameters( struct TSSessionParameters FAR *theSession,
                                                struct TSFaxParam FAR *Param );
#define InitModemCapabiliti InitModemCapability
FAXAPI void    FAXAPI16   InitModemCapability( struct TSModemCapability FAR *ModemCap );
FAXAPI void    FAXAPI16   InitFaxParam( struct TSFaxParam FAR *param );

#endif
FAXAPI BOOL FAXAPI16  GoG3(PORTFAX Port);
FAXAPI BOOL FAXAPI16  G5ConfirmationEnabled(PORTFAX Port);
FAXAPI int FAXAPI16  G5EnableConfirmation(PORTFAX Port, BOOL comf);
FAXAPI int FAXAPI16  OnCheckTurnAround(PORTFAX Port, FAXOBJ faxobj,enum TEG5ReplyNeg result);
FAXAPI int FAXAPI16  OnSendDocument(PORTFAX Port, FAXOBJ faxobj);
FAXAPI int FAXAPI16  OnSendConfirmation(PORTFAX Port, FAXOBJ faxobj);
FAXAPI int FAXAPI16  SetG3FaxObj(PORTFAX Port, FAXOBJ faxobj);
FAXAPI FAXOBJ FAXAPI16  GetG3FaxObj(PORTFAX Port);

FAXAPI LPSTR FAXAPI16 ReturnErrorString(enum TETerminationStatus TCode);
FAXAPI DWORD FAXAPI16 GetNumberOfLicensedPorts();

#ifdef  __cplusplus
}
#endif  // __cplusplus

//*****************************************************************************
#pragma pack()
#endif  // __FAXCPP_H

