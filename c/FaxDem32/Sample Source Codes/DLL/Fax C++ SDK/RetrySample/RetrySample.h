// RetrySample.h : main header file for the RETRYSAMPLE application
//

#if !defined(AFX_RETRYSAMPLE_H__628ECF9C_EB41_4E02_9FF0_D10BDDF9E319__INCLUDED_)
#define AFX_RETRYSAMPLE_H__628ECF9C_EB41_4E02_9FF0_D10BDDF9E319__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

#define MAX_COMPORTS    128

#include "faxcpp.h"
#include "faxtype.h"
typedef struct tag_retryList
{
	PORTFAX portfax;
	FAXOBJ faxobj;
	UINT timerID;
	int numberOfRetries;
	bool currentlySending;
	struct tag_retryList* pNext;
} RETRYLIST, *LPRETRYLIST; 
/////////////////////////////////////////////////////////////////////////////
// CRetrySampleApp:
// See RetrySample.cpp for the implementation of this class
//

class CRetrySampleApp : public CWinApp
{
public:
	CRetrySampleApp();
	PORTFAX     FaxPorts[MAX_COMPORTS];
	CString		fileName;
	UINT        nMessage;
	LPRETRYLIST retrylist;
	UINT timerCount;
	bool AddToList(PORTFAX portfax_,FAXOBJ faxobj_);
	bool SetTimerID(FAXOBJ faxobj_, UINT timerID_);
	bool DeleteFromList(FAXOBJ faxobj_);
	int GetTimerID(FAXOBJ faxobj_);
	int GetRetryNumber(FAXOBJ faxobj_);
	bool IsFaxobjInList(FAXOBJ faxobj_);
	bool IsPortFaxInList(PORTFAX portfax_);
	bool SetCurrentlySending(FAXOBJ faxobj_,bool cs_);
	HANDLE hMutex;

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CRetrySampleApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CRetrySampleApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_RETRYSAMPLE_H__628ECF9C_EB41_4E02_9FF0_D10BDDF9E319__INCLUDED_)
