// Voice Recording Sample.h : main header file for the VOICE RECORDING SAMPLE application
//

#if !defined(AFX_VOICERECORDINGSAMPLE_H__111AF046_2097_11D3_AFC4_0040F614A5A0__INCLUDED_)
#define AFX_VOICERECORDINGSAMPLE_H__111AF046_2097_11D3_AFC4_0040F614A5A0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

#define	MAX_PORTS		256

extern const TCHAR g_szSection[];
extern const TCHAR g_szRecTime[];
extern const TCHAR g_DefInDev[];
extern const TCHAR g_DefOutDev[];
extern char g_szExePath[MAX_PATH];
extern UINT VoiceMsg;

/////////////////////////////////////////////////////////////////////////////
// CVoiceRecordingSampleApp:
// See Voice Recording Sample.cpp for the implementation of this class
//

class CVoiceRecordingSampleApp : public CWinApp
{
public:
	CVoiceRecordingSampleApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CVoiceRecordingSampleApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CVoiceRecordingSampleApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

extern CVoiceRecordingSampleApp theApp;

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_VOICERECORDINGSAMPLE_H__111AF046_2097_11D3_AFC4_0040F614A5A0__INCLUDED_)
