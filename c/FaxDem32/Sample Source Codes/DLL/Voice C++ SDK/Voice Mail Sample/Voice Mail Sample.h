// Voice Mail Sample.h : main header file for the VOICE MAIL SAMPLE application
//

#if !defined(AFX_VOICEMAILSAMPLE_H__D4F3B006_1CB1_11D3_AFB3_0040F614A5A0__INCLUDED_)
#define AFX_VOICEMAILSAMPLE_H__D4F3B006_1CB1_11D3_AFB3_0040F614A5A0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"       // main symbols

#define	MAX_PORTS		256
#define	MAX_DTMF_CODES	100

extern UINT VoiceMsg;
extern const TCHAR g_szSection[];
extern char g_szExePath[MAX_PATH];
extern char g_szBrookCfgFile[MAX_PATH];
extern const TCHAR g_szSection[];
extern const TCHAR g_szRings[];
extern const TCHAR g_szGreeting[];
extern const TCHAR g_szRecTime[];

/////////////////////////////////////////////////////////////////////////////
// CVoiceMailSampleApp:
// See Voice Mail Sample.cpp for the implementation of this class
//

class CVoiceMailSampleApp : public CWinApp
{
public:
	CVoiceMailSampleApp();

    MODEMOBJ    GetOpenModem()const{ return m_OpenModem; };
    void        SetOpenModem(MODEMOBJ modem){ m_OpenModem = modem; };

    CRect       m_rectInitialFrame;
    BOOL        m_bMaximized;

protected:
    void    SaveOptions();
    void    LoadOptions();

    MODEMOBJ    m_OpenModem;

public:
// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CVoiceMailSampleApp)
	public:
	virtual BOOL InitInstance();
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	virtual int ExitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CVoiceMailSampleApp)
	afx_msg void OnAppAbout();
	afx_msg void OnHelp();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};
extern CVoiceMailSampleApp theApp;

class CDisplayIC : public CDC
{
public:
	CDisplayIC() { CreateIC(_T("DISPLAY"), NULL, NULL, NULL); }
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_VOICEMAILSAMPLE_H__D4F3B006_1CB1_11D3_AFB3_0040F614A5A0__INCLUDED_)
