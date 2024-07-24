// FaxWithBrooktrout.h : main header file for the FAXWITHBROOKTROUT application
//

#if !defined(AFX_FAXWITHBROOKTROUT_H__D5ECED29_8C8E_4303_96D8_A077BF6FC5D9__INCLUDED_)
#define AFX_FAXWITHBROOKTROUT_H__D5ECED29_8C8E_4303_96D8_A077BF6FC5D9__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

#define MAX_FAXCHANNELS 100 // Brooktrout
#define RECEIVEPUSHED 5
#include "faxcpp.h"
#include "faxtype.h"

typedef struct tag_List
{
	PORTFAX portfax;
	FAXOBJ faxobj;
	short SR;
	struct tag_List* pNext;
	UINT timerID;
	CString channelName;
	long sentOK;
	long receivedOK;
	long sentERROR;
	long receivedERROR;
	bool currentlySending;
} LIST, *LPLIST; 

/////////////////////////////////////////////////////////////////////////////
// CFaxWithBrooktroutApp:
// See FaxWithBrooktrout.cpp for the implementation of this class
//

class CFaxWithBrooktroutApp : public CWinApp
{
public:
	CFaxWithBrooktroutApp();
	UINT        nMessage;
	LPSTR       BrooktroutChannels;
	PORTFAX     FaxPorts[MAX_FAXCHANNELS];
	LPLIST		list;
	void AddToList(PORTFAX portfax_,CString channelName_,FAXOBJ faxobj_, short SR_, bool currentlySending_);
	void DeleteList();
	void ChangeSR(PORTFAX portfax_);
	short GetSR(PORTFAX portfax_);
	FAXOBJ GetFaxObj(PORTFAX portfax_);
	FAXOBJ GetFaxObj(UINT timerID);

	PORTFAX GetPortFax(FAXOBJ faxobj_);
	CString GetChannelName(FAXOBJ faxobj_);
	CString GetChannelName(PORTFAX portfax_);
	void FaxEventText(LPSTR buf);
	void SetTimerID(PORTFAX portfax_,UINT timerID_);
	UINT GetTimerID(PORTFAX portfax_);
	bool GetCurrentlySending(PORTFAX portfax_);
	void SetCurrentlySending(PORTFAX portfax_, bool currentlySending_);
	UINT GetTimerCount();
	PORTFAX GetPortFax(UINT timerID_);
	void IncrementSentOK(PORTFAX portfax_);
	void IncrementReceivedOK(PORTFAX portfax_);
	void IncrementSentERROR(PORTFAX portfax_);
	void IncrementReceivedERROR(PORTFAX portfax_);
	long GetSentOK(PORTFAX portfax_);
	long GetReceivedOK(PORTFAX portfax_);
	long GetSentERROR(PORTFAX portfax_);
	long GetReceivedERROR(PORTFAX portfax_);
	bool Aborted;
	UINT timerCount;
	HANDLE hMutex;
// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFaxWithBrooktroutApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CFaxWithBrooktroutApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FAXWITHBROOKTROUT_H__D5ECED29_8C8E_4303_96D8_A077BF6FC5D9__INCLUDED_)
