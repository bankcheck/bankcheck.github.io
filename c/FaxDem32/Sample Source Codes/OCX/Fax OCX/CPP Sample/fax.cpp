// Machine generated IDispatch wrapper class(es) created by Microsoft Visual C++

// NOTE: Do not modify the contents of this file.  If this class is regenerated by
//  Microsoft Visual C++, your modifications will be overwritten.


#include "stdafx.h"
#include "fax.h"

/////////////////////////////////////////////////////////////////////////////
// CFAX

IMPLEMENT_DYNCREATE(CFAX, CWnd)

/////////////////////////////////////////////////////////////////////////////
// CFAX properties

CString CFAX::GetFaxFileName()
{
	CString result;
	GetProperty(0x1, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetFaxFileName(LPCTSTR propVal)
{
	SetProperty(0x1, VT_BSTR, propVal);
}

CString CFAX::GetLocalID()
{
	CString result;
	GetProperty(0x2, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetLocalID(LPCTSTR propVal)
{
	SetProperty(0x2, VT_BSTR, propVal);
}

short CFAX::GetRings()
{
	short result;
	GetProperty(0x3, VT_I2, (void*)&result);
	return result;
}

void CFAX::SetRings(short propVal)
{
	SetProperty(0x3, VT_I2, propVal);
}

BOOL CFAX::GetToneDial()
{
	BOOL result;
	GetProperty(0x4, VT_BOOL, (void*)&result);
	return result;
}

void CFAX::SetToneDial(BOOL propVal)
{
	SetProperty(0x4, VT_BOOL, propVal);
}

CString CFAX::GetPageFileName()
{
	CString result;
	GetProperty(0x5, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetPageFileName(LPCTSTR propVal)
{
	SetProperty(0x5, VT_BSTR, propVal);
}

long CFAX::GetFaxError()
{
	long result;
	GetProperty(0x6, VT_I4, (void*)&result);
	return result;
}

void CFAX::SetFaxError(long propVal)
{
	SetProperty(0x6, VT_I4, propVal);
}

CString CFAX::GetFaxType()
{
	CString result;
	GetProperty(0xb, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetFaxType(LPCTSTR propVal)
{
	SetProperty(0xb, VT_BSTR, propVal);
}

CString CFAX::GetAvailablePorts()
{
	CString result;
	GetProperty(0xc, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetAvailablePorts(LPCTSTR propVal)
{
	SetProperty(0xc, VT_BSTR, propVal);
}

CString CFAX::GetBrooktroutCFile()
{
	CString result;
	GetProperty(0xd, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetBrooktroutCFile(LPCTSTR propVal)
{
	SetProperty(0xd, VT_BSTR, propVal);
}

CString CFAX::GetGammaCFile()
{
	CString result;
	GetProperty(0xe, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetGammaCFile(LPCTSTR propVal)
{
	SetProperty(0xe, VT_BSTR, propVal);
}

CString CFAX::GetAvailableBrooktroutChannels()
{
	CString result;
	GetProperty(0xf, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetAvailableBrooktroutChannels(LPCTSTR propVal)
{
	SetProperty(0xf, VT_BSTR, propVal);
}

CString CFAX::GetAvailableGammaChannels()
{
	CString result;
	GetProperty(0x10, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetAvailableGammaChannels(LPCTSTR propVal)
{
	SetProperty(0x10, VT_BSTR, propVal);
}

CString CFAX::GetPortsOpen()
{
	CString result;
	GetProperty(0x11, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetPortsOpen(LPCTSTR propVal)
{
	SetProperty(0x11, VT_BSTR, propVal);
}

CString CFAX::GetBrooktroutChannelsOpen()
{
	CString result;
	GetProperty(0x12, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetBrooktroutChannelsOpen(LPCTSTR propVal)
{
	SetProperty(0x12, VT_BSTR, propVal);
}

CString CFAX::GetGammaChannelsOpen()
{
	CString result;
	GetProperty(0x13, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetGammaChannelsOpen(LPCTSTR propVal)
{
	SetProperty(0x13, VT_BSTR, propVal);
}

long CFAX::GetHDIB()
{
	long result;
	GetProperty(0x14, VT_I4, (void*)&result);
	return result;
}

void CFAX::SetHDIB(long propVal)
{
	SetProperty(0x14, VT_I4, propVal);
}

BOOL CFAX::GetHeader()
{
	BOOL result;
	GetProperty(0x15, VT_BOOL, (void*)&result);
	return result;
}

void CFAX::SetHeader(BOOL propVal)
{
	SetProperty(0x15, VT_BOOL, propVal);
}

long CFAX::GetFaxCppVersion()
{
	long result;
	GetProperty(0x16, VT_I4, (void*)&result);
	return result;
}

void CFAX::SetFaxCppVersion(long propVal)
{
	SetProperty(0x16, VT_I4, propVal);
}

CString CFAX::GetClassType()
{
	CString result;
	GetProperty(0x17, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetClassType(LPCTSTR propVal)
{
	SetProperty(0x17, VT_BSTR, propVal);
}

CString CFAX::GetManufacturer()
{
	CString result;
	GetProperty(0x18, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetManufacturer(LPCTSTR propVal)
{
	SetProperty(0x18, VT_BSTR, propVal);
}

CString CFAX::GetModel()
{
	CString result;
	GetProperty(0x19, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetModel(LPCTSTR propVal)
{
	SetProperty(0x19, VT_BSTR, propVal);
}

long CFAX::GetSpeakerMode()
{
	long result;
	GetProperty(0x1a, VT_I4, (void*)&result);
	return result;
}

void CFAX::SetSpeakerMode(long propVal)
{
	SetProperty(0x1a, VT_I4, propVal);
}

long CFAX::GetSpeakerVolume()
{
	long result;
	GetProperty(0x1b, VT_I4, (void*)&result);
	return result;
}

void CFAX::SetSpeakerVolume(long propVal)
{
	SetProperty(0x1b, VT_I4, propVal);
}

CString CFAX::GetHeaderLeft()
{
	CString result;
	GetProperty(0x1c, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetHeaderLeft(LPCTSTR propVal)
{
	SetProperty(0x1c, VT_BSTR, propVal);
}

CString CFAX::GetHeaderCenter()
{
	CString result;
	GetProperty(0x1d, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetHeaderCenter(LPCTSTR propVal)
{
	SetProperty(0x1d, VT_BSTR, propVal);
}

CString CFAX::GetHeaderRight()
{
	CString result;
	GetProperty(0x1e, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetHeaderRight(LPCTSTR propVal)
{
	SetProperty(0x1e, VT_BSTR, propVal);
}

CString CFAX::GetAvailableDialogicChannels()
{
	CString result;
	GetProperty(0x1f, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetAvailableDialogicChannels(LPCTSTR propVal)
{
	SetProperty(0x1f, VT_BSTR, propVal);
}

CString CFAX::GetDialogicChannelsOpen()
{
	CString result;
	GetProperty(0x20, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetDialogicChannelsOpen(LPCTSTR propVal)
{
	SetProperty(0x20, VT_BSTR, propVal);
}

CString CFAX::GetAvailableBicomChannels()
{
	CString result;
	GetProperty(0x21, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetAvailableBicomChannels(LPCTSTR propVal)
{
	SetProperty(0x21, VT_BSTR, propVal);
}

CString CFAX::GetBicomChannelsOpen()
{
	CString result;
	GetProperty(0x22, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetBicomChannelsOpen(LPCTSTR propVal)
{
	SetProperty(0x22, VT_BSTR, propVal);
}

CString CFAX::GetAvailableCmtrxChannels()
{
	CString result;
	GetProperty(0x23, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetAvailableCmtrxChannels(LPCTSTR propVal)
{
	SetProperty(0x23, VT_BSTR, propVal);
}

long CFAX::GetHeaderHeight()
{
	long result;
	GetProperty(0x7, VT_I4, (void*)&result);
	return result;
}

void CFAX::SetHeaderHeight(long propVal)
{
	SetProperty(0x7, VT_I4, propVal);
}

CString CFAX::GetCmtrxChannelsOpen()
{
	CString result;
	GetProperty(0x24, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetCmtrxChannelsOpen(LPCTSTR propVal)
{
	SetProperty(0x24, VT_BSTR, propVal);
}

CString CFAX::GetHeaderFaceName()
{
	CString result;
	GetProperty(0x25, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetHeaderFaceName(LPCTSTR propVal)
{
	SetProperty(0x25, VT_BSTR, propVal);
}

long CFAX::GetHeaderFontSize()
{
	long result;
	GetProperty(0x8, VT_I4, (void*)&result);
	return result;
}

void CFAX::SetHeaderFontSize(long propVal)
{
	SetProperty(0x8, VT_I4, propVal);
}

BOOL CFAX::GetGammaCfgNeeded()
{
	BOOL result;
	GetProperty(0x9, VT_BOOL, (void*)&result);
	return result;
}

void CFAX::SetGammaCfgNeeded(BOOL propVal)
{
	SetProperty(0x9, VT_BOOL, propVal);
}

CString CFAX::GetAvailableNMSChannels()
{
	CString result;
	GetProperty(0x26, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetAvailableNMSChannels(LPCTSTR propVal)
{
	SetProperty(0x26, VT_BSTR, propVal);
}

CString CFAX::GetNMSChannelsOpen()
{
	CString result;
	GetProperty(0x27, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetNMSChannelsOpen(LPCTSTR propVal)
{
	SetProperty(0x27, VT_BSTR, propVal);
}

CString CFAX::GetNMSProtocoll()
{
	CString result;
	GetProperty(0x28, VT_BSTR, (void*)&result);
	return result;
}

void CFAX::SetNMSProtocoll(LPCTSTR propVal)
{
	SetProperty(0x28, VT_BSTR, propVal);
}

BOOL CFAX::GetDisplayFaxManager()
{
	BOOL result;
	GetProperty(0xa, VT_BOOL, (void*)&result);
	return result;
}

void CFAX::SetDisplayFaxManager(BOOL propVal)
{
	SetProperty(0xa, VT_BOOL, propVal);
}

long CFAX::GetNMSDNISDigitNum()
{
	long result;
	GetProperty(0x29, VT_I4, (void*)&result);
	return result;
}

void CFAX::SetNMSDNISDigitNum(long propVal)
{
	SetProperty(0x29, VT_I4, propVal);
}

/////////////////////////////////////////////////////////////////////////////
// CFAX operations

long CFAX::ClearFaxObject(long FaxID)
{
	long result;
	static BYTE parms[] =
		VTS_I4;
	InvokeHelper(0x2a, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		FaxID);
	return result;
}

long CFAX::GetFaxPage(long FaxID, short PageNum, short Type, BOOL bAppend)
{
	long result;
	static BYTE parms[] =
		VTS_I4 VTS_I2 VTS_I2 VTS_BOOL;
	InvokeHelper(0x2b, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		FaxID, PageNum, Type, bAppend);
	return result;
}

long CFAX::SetFaxPage(long FaxID, short PageNum, short Type, short ImageNum)
{
	long result;
	static BYTE parms[] =
		VTS_I4 VTS_I2 VTS_I2 VTS_I2;
	InvokeHelper(0x2c, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		FaxID, PageNum, Type, ImageNum);
	return result;
}

long CFAX::SendFaxObj(long FaxID)
{
	long result;
	static BYTE parms[] =
		VTS_I4;
	InvokeHelper(0x2d, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		FaxID);
	return result;
}

long CFAX::CreateFaxObject(short Type, short PageNum, short Resolution, short Width, short Length, short Compression, short Binary, short Ecm, short ColorFax, short ColorType)
{
	long result;
	static BYTE parms[] =
		VTS_I2 VTS_I2 VTS_I2 VTS_I2 VTS_I2 VTS_I2 VTS_I2 VTS_I2 VTS_I2 VTS_I2;
	InvokeHelper(0x2e, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		Type, PageNum, Resolution, Width, Length, Compression, Binary, Ecm, ColorFax, ColorType);
	return result;
}

long CFAX::SetPortCapability(LPCTSTR Port, short Capability, short Data)
{
	long result;
	static BYTE parms[] =
		VTS_BSTR VTS_I2 VTS_I2;
	InvokeHelper(0x2f, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		Port, Capability, Data);
	return result;
}

short CFAX::GetPortCapability(LPCTSTR Port, short Capability)
{
	short result;
	static BYTE parms[] =
		VTS_BSTR VTS_I2;
	InvokeHelper(0x30, DISPATCH_METHOD, VT_I2, (void*)&result, parms,
		Port, Capability);
	return result;
}

long CFAX::EnableLog(LPCTSTR Port, BOOL bEnable)
{
	long result;
	static BYTE parms[] =
		VTS_BSTR VTS_BOOL;
	InvokeHelper(0x31, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		Port, bEnable);
	return result;
}

void CFAX::SetLogDir(LPCTSTR lpszLogDir)
{
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x32, DISPATCH_METHOD, VT_EMPTY, NULL, parms,
		 lpszLogDir);
}

void CFAX::SetFaxObjDir(LPCTSTR lpszFaxDir)
{
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x33, DISPATCH_METHOD, VT_EMPTY, NULL, parms,
		 lpszFaxDir);
}

CString CFAX::GetFaxCppVersionStr()
{
	CString result;
	InvokeHelper(0x34, DISPATCH_METHOD, VT_BSTR, (void*)&result, NULL);
	return result;
}

long CFAX::TestModem(LPCTSTR Port)
{
	long result;
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x35, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		Port);
	return result;
}

long CFAX::SetFaxParam(long FaxID, short ParamType, short Data)
{
	long result;
	static BYTE parms[] =
		VTS_I4 VTS_I2 VTS_I2;
	InvokeHelper(0x36, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		FaxID, ParamType, Data);
	return result;
}

long CFAX::GetFaxParam(long FaxID, short ParamType)
{
	long result;
	static BYTE parms[] =
		VTS_I4 VTS_I2;
	InvokeHelper(0x37, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		FaxID, ParamType);
	return result;
}

long CFAX::SetSpeakerMode(LPCTSTR Port, short SpkTurnOn, short SpkVolume)
{
	long result;
	static BYTE parms[] =
		VTS_BSTR VTS_I2 VTS_I2;
	InvokeHelper(0x38, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		Port, SpkTurnOn, SpkVolume);
	return result;
}

long CFAX::WriteFaxObject(long FaxID, LPCTSTR FileName)
{
	long result;
	static BYTE parms[] =
		VTS_I4 VTS_BSTR;
	InvokeHelper(0x39, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		FaxID, FileName);
	return result;
}

long CFAX::ReadFaxObject(long FaxID, LPCTSTR FileName)
{
	long result;
	static BYTE parms[] =
		VTS_I4 VTS_BSTR;
	InvokeHelper(0x3a, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		FaxID, FileName);
	return result;
}

short CFAX::SetPhoneNumber(long FaxID, LPCTSTR PhoneNumber)
{
	short result;
	static BYTE parms[] =
		VTS_I4 VTS_BSTR;
	InvokeHelper(0x3b, DISPATCH_METHOD, VT_I2, (void*)&result, parms,
		FaxID, PhoneNumber);
	return result;
}

CString CFAX::GetPhoneNumber(long FaxID)
{
	CString result;
	static BYTE parms[] =
		VTS_I4;
	InvokeHelper(0x3c, DISPATCH_METHOD, VT_BSTR, (void*)&result, parms,
		FaxID);
	return result;
}

long CFAX::GetPortStatus(LPCTSTR Port)
{
	long result;
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x3d, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		Port);
	return result;
}

long CFAX::CloseAllPorts()
{
	long result;
	InvokeHelper(0x3e, DISPATCH_METHOD, VT_I4, (void*)&result, NULL);
	return result;
}

long CFAX::DeleteAllObjects()
{
	long result;
	InvokeHelper(0x3f, DISPATCH_METHOD, VT_I4, (void*)&result, NULL);
	return result;
}

long CFAX::OpenPort(LPCTSTR PortName)
{
	long result;
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x40, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		PortName);
	return result;
}

long CFAX::ClosePort(LPCTSTR PortName)
{
	long result;
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x41, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		PortName);
	return result;
}

long CFAX::SetRings(LPCTSTR PortName, short RingNumber)
{
	long result;
	static BYTE parms[] =
		VTS_BSTR VTS_I2;
	InvokeHelper(0x42, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		PortName, RingNumber);
	return result;
}

short CFAX::GetRings(LPCTSTR PortName)
{
	short result;
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x43, DISPATCH_METHOD, VT_I2, (void*)&result, parms,
		PortName);
	return result;
}

long CFAX::SetPortID(LPCTSTR PortName, LPCTSTR LocalID)
{
	long result;
	static BYTE parms[] =
		VTS_BSTR VTS_BSTR;
	InvokeHelper(0x44, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		PortName, LocalID);
	return result;
}

CString CFAX::GetPortID(LPCTSTR PortName)
{
	CString result;
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x45, DISPATCH_METHOD, VT_BSTR, (void*)&result, parms,
		PortName);
	return result;
}

long CFAX::Abort(LPCTSTR PortName)
{
	long result;
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x46, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		PortName);
	return result;
}

long CFAX::SendNow(LPCTSTR PortName, long FaxID)
{
	long result;
	static BYTE parms[] =
		VTS_BSTR VTS_I4;
	InvokeHelper(0x47, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		PortName, FaxID);
	return result;
}

long CFAX::SetNext(long FaxID, long NextFaxID)
{
	long result;
	static BYTE parms[] =
		VTS_I4 VTS_I4;
	InvokeHelper(0x48, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		FaxID, NextFaxID);
	return result;
}

CString CFAX::GetDTMFDigits(LPCTSTR szPort)
{
	CString result;
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x49, DISPATCH_METHOD, VT_BSTR, (void*)&result, parms,
		szPort);
	return result;
}

short CFAX::RecvDTMF(LPCTSTR lpPort, short nDigits, long nTimeout)
{
	short result;
	static BYTE parms[] =
		VTS_BSTR VTS_I2 VTS_I4;
	InvokeHelper(0x4a, DISPATCH_METHOD, VT_I2, (void*)&result, parms,
		lpPort, nDigits, nTimeout);
	return result;
}

CString CFAX::GetLastPageFile(LPCTSTR PortName)
{
	CString result;
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x4b, DISPATCH_METHOD, VT_BSTR, (void*)&result, parms,
		PortName);
	return result;
}

long CFAX::GetNumberOfImages(LPCTSTR FileName, short FileType)
{
	long result;
	static BYTE parms[] =
		VTS_BSTR VTS_I2;
	InvokeHelper(0x4c, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		FileName, FileType);
	return result;
}

long CFAX::DisablePort(LPCTSTR PortName, BOOL Disabled)
{
	long result;
	static BYTE parms[] =
		VTS_BSTR VTS_BOOL;
	InvokeHelper(0x4d, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		PortName, Disabled);
	return result;
}

long CFAX::IsPortDisabled(LPCTSTR PortName)
{
	long result;
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x4e, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		PortName);
	return result;
}

long CFAX::GetLastGammaStatus(LPCTSTR PortName)
{
	long result;
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x4f, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		PortName);
	return result;
}

long CFAX::SendFaxNowTapi(long TapiID, long FaxID, long lpUserData)
{
	long result;
	static BYTE parms[] =
		VTS_I4 VTS_I4 VTS_I4;
	InvokeHelper(0x50, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		TapiID, FaxID, lpUserData);
	return result;
}

long CFAX::ReceiveNowTapi(long TapiID)
{
	long result;
	static BYTE parms[] =
		VTS_I4;
	InvokeHelper(0x51, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		TapiID);
	return result;
}

long CFAX::DetectDialTone(LPCTSTR Port)
{
	long result;
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x66, DISPATCH_METHOD, VT_I4, (void*)&result, parms,
		Port);
	return result;
}

CString CFAX::GetSetupString(short index)
{
	CString result;
	static BYTE parms[] =
		VTS_I2;
	InvokeHelper(0x67, DISPATCH_METHOD, VT_BSTR, (void*)&result, parms,
		index);
	return result;
}

CString CFAX::GetResetString(short index)
{
	CString result;
	static BYTE parms[] =
		VTS_I2;
	InvokeHelper(0x68, DISPATCH_METHOD, VT_BSTR, (void*)&result, parms,
		index);
	return result;
}

short CFAX::SetSetupString(LPCTSTR SetupStr, short index)
{
	short result;
	static BYTE parms[] =
		VTS_BSTR VTS_I2;
	InvokeHelper(0x69, DISPATCH_METHOD, VT_I2, (void*)&result, parms,
		SetupStr, index);
	return result;
}

short CFAX::SetResetString(LPCTSTR ResetStr, short index)
{
	short result;
	static BYTE parms[] =
		VTS_BSTR VTS_I2;
	InvokeHelper(0x6a, DISPATCH_METHOD, VT_I2, (void*)&result, parms,
		ResetStr, index);
	return result;
}

short CFAX::SetUserString(long FaxID, LPCTSTR UserString)
{
	short result;
	static BYTE parms[] =
		VTS_I4 VTS_BSTR;
	InvokeHelper(0x6b, DISPATCH_METHOD, VT_I2, (void*)&result, parms,
		FaxID, UserString);
	return result;
}

CString CFAX::GetUserString(long FaxID)
{
	CString result;
	static BYTE parms[] =
		VTS_I4;
	InvokeHelper(0x6c, DISPATCH_METHOD, VT_BSTR, (void*)&result, parms,
		FaxID);
	return result;
}

CString CFAX::GetLongName(short index)
{
	CString result;
	static BYTE parms[] =
		VTS_I2;
	InvokeHelper(0x6d, DISPATCH_METHOD, VT_BSTR, (void*)&result, parms,
		index);
	return result;
}