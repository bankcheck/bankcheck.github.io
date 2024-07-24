#ifndef VOICE_CPP_INCLUDED
#define VOICE_CPP_INCLUDED

#include        "voctype.h"
#include        "rockwell.h"
#include        "usrobix.h"

#include        "vdlogic.h"
#include        "BicomV.h"
#include        "Brook.h"
#include        "nmsv.h"
#include        "scbus.h"

VOICEAPI int                    VOICEAPI16              SetupVoiceDriver (LPSTR VocManDLLName);
VOICEAPI void                   VOICEAPI16              EndOfVoiceDriver (BOOL KillNow);
VOICEAPI int                    VOICEAPI16              SetVoiceMessage( MODEMOBJ Modem, HWND hWnd );
VOICEAPI void                   VOICEAPI16              GetVoiceCppVersionStr(LPSTR versionStr);
VOICEAPI DWORD                  VOICEAPI16              GetVoiceCppVersionNum();
VOICEAPI BOOL                   VOICEAPI16              DialogicSupport();

VOICEAPI void                   VOICEAPI16              mdm_SetLogDir(LPCSTR lpPath);

VOICEAPI MODEMOBJ               VOICEAPI16              mdm_CreateModemObject(int nModemType);
VOICEAPI void                   VOICEAPI16              mdm_DestroyModemObject(MODEMOBJ Modem);

VOICEAPI void                   VOICEAPI16              mdm_SetModemLong(MODEMOBJ Modem, long dwNewLong);
VOICEAPI long                   VOICEAPI16              mdm_GetModemLong(MODEMOBJ Modem);

VOICEAPI DWORD                  VOICEAPI16              mdm_GetLastError(MODEMOBJ Modem);
VOICEAPI LPCSTR                 VOICEAPI16              mdm_GetPortName(MODEMOBJ Modem);

VOICEAPI BOOL                   VOICEAPI16              mdm_SetSpeakerVolume(MODEMOBJ Modem, int volume);

VOICEAPI BOOL                   VOICEAPI16              mdm_OpenPort(MODEMOBJ Modem, LPCTSTR PortName);
VOICEAPI BOOL                   VOICEAPI16              mdm_IsPortOpen(MODEMOBJ Modem);
VOICEAPI void                   VOICEAPI16              mdm_ClosePort(MODEMOBJ Modem);
VOICEAPI BOOL                   VOICEAPI16              mdm_InitializeModem(MODEMOBJ Modem);
VOICEAPI BOOL                   VOICEAPI16              mdm_IsPortUsed(MODEMOBJ Modem);

VOICEAPI void                   VOICEAPI16              mdm_EnableLog(MODEMOBJ Modem, BOOL bEnable);
VOICEAPI void                   VOICEAPI16              mdm_SetLogDir(MODEMOBJ Modem, LPCTSTR lpszDir);

VOICEAPI BOOL                   VOICEAPI16              mdm_EnterVoiceMode(MODEMOBJ Modem);
VOICEAPI BOOL                   VOICEAPI16              mdm_EnterFaxMode(MODEMOBJ Modem);
VOICEAPI BOOL                   VOICEAPI16              mdm_SetFaxSendMode(MODEMOBJ Modem, int nClassMode);
VOICEAPI BOOL                   VOICEAPI16              mdm_SetFaxReceiveMode(MODEMOBJ Modem, int nClassMode);
VOICEAPI long                   VOICEAPI16              mdm_ConnectVoicePort(MODEMOBJ Modem, LPCTSTR FaxName, LPCTSTR IniFile);
VOICEAPI void                   VOICEAPI16              mdm_DisconnectVoicePort(MODEMOBJ Modem);
VOICEAPI BOOL                   VOICEAPI16              mdm_SendFaxNow(MODEMOBJ Modem, long Fax);
VOICEAPI long                   VOICEAPI16              mdm_GetFaxPort(MODEMOBJ Modem);
VOICEAPI BOOL                   VOICEAPI16              mdm_ReceiveFaxNow(MODEMOBJ Modem);

VOICEAPI BOOL                   VOICEAPI16              mdm_DialInVoiceMode(MODEMOBJ Modem, LPCTSTR lpszNumber, int nTime, BOOL bOffHook = TRUE);
VOICEAPI BOOL                   VOICEAPI16              mdm_SetHook(MODEMOBJ Modem, BOOL bOffHook);
VOICEAPI BOOL                   VOICEAPI16              mdm_Answer(MODEMOBJ Modem);
VOICEAPI BOOL                   VOICEAPI16              mdm_OnlineAnswer(MODEMOBJ Modem);
VOICEAPI BOOL                   VOICEAPI16              mdm_HangUp(MODEMOBJ Modem);
VOICEAPI BOOL                   VOICEAPI16              mdm_WaitForDTMF(MODEMOBJ Modem, PDTMFINFO pDTMFInfo, UINT unTime);
VOICEAPI BOOL                   VOICEAPI16              mdm_SendDTMF(MODEMOBJ Modem, PDTMFINFO pDTMFInfo);
VOICEAPI void                   VOICEAPI16              mdm_GetReceivedDTMF(MODEMOBJ Modem, PDTMFINFO pDTMFInfo);
VOICEAPI BOOL                   VOICEAPI16              mdm_EnableDTMF(MODEMOBJ Modem);
VOICEAPI BOOL                   VOICEAPI16              mdm_DisableDTMF(MODEMOBJ Modem);
VOICEAPI BOOL                   VOICEAPI16              mdm_WaitForRings(MODEMOBJ Modem, int nNumOfRings);
VOICEAPI void                   VOICEAPI16              mdm_TerminateWait(MODEMOBJ Modem);
VOICEAPI BOOL                   VOICEAPI16              mdm_TestVoiceModem(MODEMOBJ Modem);
VOICEAPI void                   VOICEAPI16              mdm_GetTestResult(MODEMOBJ Modem, TSVoiceTestResult *pTest);
VOICEAPI BOOL                   VOICEAPI16              mdm_PlayVoice(MODEMOBJ Modem, PVOICEINFO pVoiceInfo);
VOICEAPI BOOL                   VOICEAPI16              mdm_PlayVoiceExt(MODEMOBJ Modem, PVOICEINFOEXT pVoiceInfo);
VOICEAPI BOOL                   VOICEAPI16              mdm_PlayVoiceExt2(MODEMOBJ Modem, PVOICEINFOEXT2 pVoiceInfo);
VOICEAPI BOOL                   VOICEAPI16              mdm_RecordVoice(MODEMOBJ Modem, PVOICEINFO pVoiceInfo);
VOICEAPI BOOL                   VOICEAPI16              mdm_RecordVoiceExt(MODEMOBJ Modem, PVOICEINFOEXT pVoiceInfo);
VOICEAPI BOOL                   VOICEAPI16              mdm_RecordVoiceExt2(MODEMOBJ Modem, PVOICEINFOEXT pVoiceInfo);
VOICEAPI BOOL                   VOICEAPI16              mdm_GenerateToneSignal(MODEMOBJ Modem, int nFirstFreq, int nSecondFreq, int nDuration, int nDevice);
VOICEAPI BOOL                   VOICEAPI16              mdm_GenerateToneSignalExt(MODEMOBJ Modem, int firstFreq, int secondFreq, int nAmplitude1, int nAmplitude2, int duration, int device);
VOICEAPI BOOL                   VOICEAPI16              mdm_GenerateToneSignalExtDTMF(MODEMOBJ Modem, int firstFreq, int secondFreq, int nAmplitude1, int nAmplitude2, int duration, int device, int DTMFNum);
VOICEAPI BOOL                   VOICEAPI16              mdm_TransferInboundCall(MODEMOBJ Modem, const char *pszNumber, BOOL bTransFlag, BOOL bDialTone, int nToneTime, char* szFlash, char* szCancel);
VOICEAPI BOOL                   VOICEAPI16              mdm_BlindTransferInboundCall(MODEMOBJ Modem, const char *pszNumber, BOOL bTransFlag, BOOL bDialTone, int nToneTime, char* szFlash, char* szCancel);

VOICEAPI BOOL                   VOICEAPI16              mdm_SetSilenceDetectionParams(MODEMOBJ Modem, enum MSD_SILENCEDETECTION Silence, int nMaxSilenceTime);
VOICEAPI BOOL                   VOICEAPI16              mdm_SetFaxDetectionTimeout(MODEMOBJ Modem, int nTimeout);

VOICEAPI int                    VOICEAPI16              mdm_DID_SetDigitNumber(MODEMOBJ Modem, int nDigitNumber);
VOICEAPI int                    VOICEAPI16              mdm_DID_GetDigits(MODEMOBJ Modem, LPSTR szDigitBuffers);

VOICEAPI void                   VOICEAPI16              mdm_SetFlashHookTime(int nTime);

VOICEAPI int                    VOICEAPI16              mdm_D_GetBoardNum();
VOICEAPI int                    VOICEAPI16              mdm_D_GetChannelNum( int nBoard );
VOICEAPI BOOL                   VOICEAPI16              mdm_D_IsChannelFree( int nBoard, int nNum );
VOICEAPI int                    VOICEAPI16              mdm_TestDialogic(LPSTR szPort, TSTestResult FAR *ModemTest);
VOICEAPI int                    VOICEAPI16              mdm_GetDChannelIndex(int nBoard, int nChannel);
VOICEAPI int                    VOICEAPI16              mdm_D_GetLineType( MODEMOBJ Modem);
VOICEAPI int                    VOICEAPI16              mdm_D_SetLineType( MODEMOBJ Modem, int linetype );
VOICEAPI LPCSTR                 VOICEAPI16              mdm_D_GetProtocol( MODEMOBJ Modem);
VOICEAPI int                    VOICEAPI16              mdm_D_SetProtocol( MODEMOBJ Modem, LPSTR protocol );
VOICEAPI BOOL                   VOICEAPI16              mdm_D_MakeCallISDN(MODEMOBJ Modem, LPCTSTR lpszNumber);

VOICEAPI int                    VOICEAPI16              mdm_BCM_GetChannelType(int nBoard, int nChannel, PSTR pBuf, int len );
VOICEAPI int                    VOICEAPI16              mdm_BCM_GetChannelNum( int nBoard );
VOICEAPI BOOL                   VOICEAPI16              mdm_BCM_IsChannelFree( int nBoard, int nChannel );
VOICEAPI int                    VOICEAPI16              mdm_BCM_GetBoardNum();
VOICEAPI int                    VOICEAPI16              mdm_BCM_GetAllChannelNum();
VOICEAPI int                    VOICEAPI16              mdm_BCM_GetIndex( int nBoard, int nChannel );
VOICEAPI void                   VOICEAPI16              mdm_BCM_SetConfigFile( MODEMOBJ Modem, const char *pszFile );

VOICEAPI int                    VOICEAPI16              mdm_BT_GetChannelType(int nChannel, PSTR pBuf, int nLen );
VOICEAPI BOOL                   VOICEAPI16              mdm_BT_IsChannelFree( int nChannel );
VOICEAPI int                    VOICEAPI16              mdm_BT_GetAllChannelNum();
VOICEAPI void                   VOICEAPI16              mdm_BT_SetConfigFile(LPCSTR lpszConfig);


VOICEAPI int                    VOICEAPI16              mdm_NMS_GetChannelType(int nBoard, int nChannel, PSTR pBuf, int len );
VOICEAPI int                    VOICEAPI16              mdm_NMS_GetChannelNum( int nBoard );
VOICEAPI BOOL                   VOICEAPI16              mdm_NMS_IsChannelFree( int nBoard, int nChannel );
VOICEAPI int                    VOICEAPI16              mdm_NMS_GetBoardNum();
VOICEAPI int                    VOICEAPI16              mdm_NMS_GetAllChannelNum();
VOICEAPI int                    VOICEAPI16              mdm_NMS_SetProtocol(LPCSTR szProtocol);
VOICEAPI int                    VOICEAPI16              mdm_NMS_SetDIDDigitNumber(int DIDDigits);
VOICEAPI int                    VOICEAPI16              mdm_NMS_GetDIDDigits(LPCSTR szBuffer);

VOICEAPI bool                   VOICEAPI16              mdm_NMS_ConnectChannels(MODEMOBJ Modem1, MODEMOBJ Modem2);
VOICEAPI bool                   VOICEAPI16              mdm_NMS_DisconnectChannels(MODEMOBJ Modem1, MODEMOBJ Modem2);
VOICEAPI bool                   VOICEAPI16              mdm_NMS_ConnectDSPToLineInterface(MODEMOBJ Modem1, MODEMOBJ Modem2, int mode);
VOICEAPI bool                   VOICEAPI16              mdm_NMS_ConnectLineInterfaceToDSP(MODEMOBJ Modem1, MODEMOBJ Modem2, int mode);
VOICEAPI bool                   VOICEAPI16              mdm_NMS_DisconnectLineInterfaceFromDSP(MODEMOBJ Modem1, MODEMOBJ Modem2, int mode);
VOICEAPI bool                   VOICEAPI16              mdm_NMS_DisconnectDSPFromLineInterface(MODEMOBJ Modem1, MODEMOBJ Modem2, int mode);

VOICEAPI TSReceivedVoiceData*   VOICEAPI16              mdm_GetReceivedVoiceData(MODEMOBJ Modem);
VOICEAPI bool                   VOICEAPI16              mdm_EnablePartialVoiceDataReporting(MODEMOBJ Modem, BOOL bEnable);
VOICEAPI bool                   VOICEAPI16              mdm_DestroyPartialVoiceData(MODEMOBJ Modem);
VOICEAPI bool                   VOICEAPI16              mdm_EnablePartialVoiceDataReporting(MODEMOBJ Modem, BOOL bEnable);

VOICEAPI bool                   VOICEAPI16              mdm_GetCallerID(MODEMOBJ Modem, PTSCallerIDData CallerIDInfo);
VOICEAPI bool                   VOICEAPI16              mdm_GetANI(MODEMOBJ Modem, LPSTR buffer, long BufferSize);
VOICEAPI bool                   VOICEAPI16              mdm_SetParameters(MODEMOBJ Modem, DWORD dwOption, BOOL bValue);
VOICEAPI bool                   VOICEAPI16              mdm_GetParameters(MODEMOBJ Modem, DWORD dwOption);
//Dialogic SC BUS support functions

VOICEAPI int                    VOICEAPI16              mdm_SCBUS_SetResourceRoutingMode(int nMode = SCBUS_RESOURCE_ROUTING_AUTOMATIC);
VOICEAPI int                    VOICEAPI16              mdm_SCBUS_EnumerateResources( LPSTR pResourceName, int* nBufferSize, int nResourceType);
VOICEAPI int                    VOICEAPI16              mdm_SCBUS_GetResourceStatus( LPCSTR szResourceName , int nResourceType);
VOICEAPI int                    VOICEAPI16              mdm_SCBUS_OpenResource( LPCSTR szResourceName, SCBUSRES* lResHandle, int nResourceType, int nLineType, LPCSTR szProtocol);
VOICEAPI int                    VOICEAPI16              mdm_SCBUS_CloseResource( SCBUSRES lResHandle );
VOICEAPI int                    VOICEAPI16              mdm_SCBUS_AttachResourceToMODEMOBJ( MODEMOBJ modemobj, SCBUSRES lResHandle );
VOICEAPI int                    VOICEAPI16              mdm_SCBUS_DetachResourceFromMODEMOBJ( MODEMOBJ modemobj, SCBUSRES lResHandle );
VOICEAPI int                    VOICEAPI16              mdm_SCBUS_ListenTo(SCBUSRES lResListened , SCBUSRES lResListener, long Mode );
VOICEAPI int                    VOICEAPI16              mdm_SCBUS_StopListeningTo(SCBUSRES lResListened , SCBUSRES lResListener, long Mode );

VOICEAPI int                    VOICEAPI16              mdm_SCBUS_CreateSingleFrequencyTone(SCBUSRES lResHandle, unsigned int ToneID,  TSSingleToneTemplate ToneDef);
VOICEAPI int                    VOICEAPI16              mdm_SCBUS_CreateDualFrequencyTone(SCBUSRES lResHandle, unsigned int ToneID,  TSDualToneTemplate   ToneDef);
VOICEAPI int                    VOICEAPI16              mdm_SCBUS_CreateSingleFrequencyToneCadence(SCBUSRES lResHandle, unsigned int ToneID,  TSSingleToneCadenceTemplate ToneDef);
VOICEAPI int                    VOICEAPI16              mdm_SCBUS_CreateDualFrequencyToneCadence(SCBUSRES lResHandle, unsigned int ToneID,  TSDualToneCadenceTemplate   ToneDef);

VOICEAPI BOOL                   VOICEAPI16              mdm_TONEDET_CreateSingleFrequencyTone(MODEMOBJ Modem, unsigned int ToneID,  TSSingleToneTemplate ToneDef);
VOICEAPI BOOL                   VOICEAPI16              mdm_TONEDET_CreateDualFrequencyTone  (MODEMOBJ Modem, unsigned int ToneID,  TSDualToneTemplate   ToneDef);
VOICEAPI BOOL                   VOICEAPI16              mdm_TONEDET_CreateSingleFrequencyToneCadence(MODEMOBJ Modem, unsigned int ToneID,  TSSingleToneCadenceTemplate ToneDef);
VOICEAPI BOOL                   VOICEAPI16              mdm_TONEDET_CreateDualFrequencyToneCadence  (MODEMOBJ Modem, unsigned int ToneID,  TSDualToneCadenceTemplate   ToneDef);

VOICEAPI LPCSTR                 VOICEAPI16              mdm_GetCallerIDCommand(MODEMOBJ Modem);
VOICEAPI BOOL                   VOICEAPI16              mdm_SetCallerIDCommand(MODEMOBJ Modem, LPCSTR pszCommand);

VOICEAPI int                    VOICEAPI16              mdm_MSI_OpenBoard(BYTE BoardNumber);
VOICEAPI BOOL                   VOICEAPI16              mdm_MSI_CloseBoard(int BoardHandle);
VOICEAPI BOOL                   VOICEAPI16              mdm_MSI_RingStation(MODEMOBJ Modem, BYTE RingNum);
VOICEAPI BOOL                   VOICEAPI16              mdm_MSI_RingStationEx(MODEMOBJ Modem, BYTE RingNum, long DistinctiveRingID);
VOICEAPI BOOL                   VOICEAPI16              mdm_MSI_RingStationCallerID(MODEMOBJ Modem, BYTE RingNum, long DistinctiveRingID, LPCSTR szCallerIDInfo);
VOICEAPI BOOL                   VOICEAPI16              mdm_MSI_EstablishConference(MODEMOBJ Modem, int MSIBoardHandle, int ResType, int ConfAttr, int ConfPartyAttr, int* ConfID);
VOICEAPI BOOL                   VOICEAPI16              mdm_MSI_DeleteConference(MODEMOBJ Modem, int MSIBoardHandle, int ConfID);
VOICEAPI BOOL                   VOICEAPI16              mdm_MSI_AddToConference(MODEMOBJ Modem, int MSIBoardHandle, int ResType, int ConfID, int Attr);
VOICEAPI BOOL                   VOICEAPI16              mdm_MSI_RemoveFromConference(MODEMOBJ Modem, int MSIBoardHandle, int ResType, int ConfID);
VOICEAPI BOOL                   VOICEAPI16              mdm_MSI_SetConferencePartyAttr(MODEMOBJ Modem, int MSIBoardHandle, int ResType, int ConfID, int Attr);
VOICEAPI BOOL                   VOICEAPI16              mdm_MSI_GetConferencePartyAttr(MODEMOBJ Modem, int MSIBoardHandle, int ResType, int ConfID, int* Attr);
VOICEAPI BOOL                   VOICEAPI16              mdm_MSI_GenerateZipTone(MODEMOBJ Modem);
VOICEAPI BOOL                   VOICEAPI16              mdm_MSI_SwitchMessageWaitingLight(MODEMOBJ Modem, BOOL On);
VOICEAPI BOOL                   VOICEAPI16              mdm_MSI_SetStationVolume(MODEMOBJ Modem, int VolChange);


VOICEAPI DWORD                  VOICEAPI16              GetNumberOfLicensedPorts();

VOICEAPI BOOL                   VOICEAPI16              mdm_GetModemCommand(MODEMOBJ Modem, DWORD CommandID, LPSTR Buffer, DWORD BufferLength);
VOICEAPI BOOL                   VOICEAPI16              mdm_SetModemCommand(MODEMOBJ Modem, DWORD CommandID, LPCSTR ModemCommand);
VOICEAPI BOOL                   VOICEAPI16              mdm_SetDefVoiceParams(MODEMOBJ Modem,MDF_DATAFORMATS DataFormat,MSR_SAMPLING_RATES SamplingRate);
VOICEAPI long                   VOICEAPI16              mdm_GetCurrentPlaybackByteOffset(MODEMOBJ Modem);
#endif 