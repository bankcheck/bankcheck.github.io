// Interactive Voice Sample.h : main header file for the INTERACTIVE VOICE SAMPLE application
//

#if !defined(AFX_INTERACTIVEVOICESAMPLE_H__965DF3C6_1F3E_11D3_AFC0_0040F614A5A0__INCLUDED_)
#define AFX_INTERACTIVEVOICESAMPLE_H__965DF3C6_1F3E_11D3_AFC0_0040F614A5A0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

#define	MAX_PORTS		256
#define	MAX_DTMF_CODES	100

extern const TCHAR g_szSection[];
extern char g_szExePath[MAX_PATH];
extern char g_szBrookCfgFile[MAX_PATH];

/////////////////////////////////////////////////////////////////////////////
// CInteractiveVoiceSampleApp:
// See Interactive Voice Sample.cpp for the implementation of this class
//

class CInteractiveVoiceSampleApp : public CWinApp
{
public:
	CInteractiveVoiceSampleApp();

    MODEMOBJ    GetOpenModem()const{ return m_OpenModem; };
    void        SetOpenModem(MODEMOBJ modem){ m_OpenModem = modem; };

	void		DeleteOpenModem() { m_OpenModem = NULL; }

    MODEMOBJ    m_OpenModem;

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CInteractiveVoiceSampleApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CInteractiveVoiceSampleApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

extern CInteractiveVoiceSampleApp theApp;

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_INTERACTIVEVOICESAMPLE_H__965DF3C6_1F3E_11D3_AFC0_0040F614A5A0__INCLUDED_)
