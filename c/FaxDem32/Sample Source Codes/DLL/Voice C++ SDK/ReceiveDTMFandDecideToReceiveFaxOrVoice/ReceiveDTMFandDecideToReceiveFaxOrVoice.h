// ReceiveDTMFandDecideToReceiveFaxOrVoice.h : main header file for the RECEIVEDTMFANDDECIDETORECEIVEFAXORVOICE application
//

#if !defined(AFX_RECEIVEDTMFANDDECIDETORECEIVEFAXORVOICE_H__C813BD06_134D_4D33_AE46_EFF8B5F7B746__INCLUDED_)
#define AFX_RECEIVEDTMFANDDECIDETORECEIVEFAXORVOICE_H__C813BD06_134D_4D33_AE46_EFF8B5F7B746__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols
#define	MAX_PORTS		256

extern const TCHAR g_szSection[];
extern char g_szExePath[MAX_PATH];
extern char g_szBrookCfgFile[MAX_PATH];

#define MAX_FAXCHANNELS 100 // Brooktrout
#define MAX_GAMMACHANNELS 70 // GammaLink
#define MAX_DIALOGICCHANNELS 64 // Dialogic
#define MAX_NMSCHANNELS 128 //Nms
#define MAX_FAXPORTS    (MAX_FAXCHANNELS+MAX_GAMMACHANNELS+MAX_DIALOGICCHANNELS+MAX_NMSCHANNELS)
/////////////////////////////////////////////////////////////////////////////
// CReceiveDTMFandDecideToReceiveFaxOrVoiceApp:
// See ReceiveDTMFandDecideToReceiveFaxOrVoice.cpp for the implementation of this class
//

class CReceiveDTMFandDecideToReceiveFaxOrVoiceApp : public CWinApp
{
public:
	CReceiveDTMFandDecideToReceiveFaxOrVoiceApp();

    MODEMOBJ    GetOpenModem()const{ return m_OpenModem; }
    void        SetOpenModem(MODEMOBJ modem){ m_OpenModem = modem; }

    MODEMOBJ    m_OpenModem;

//	PORTFAX     FaxPorts[MAX_FAXCHANNELS];
	PORTFAX		FaxPort;
	int m_nDialogicBoard;
    int         m_nNmsBoard;
	int         m_nGammaChannel;
	LPSTR       BrooktroutChannels;
// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CReceiveDTMFandDecideToReceiveFaxOrVoiceApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CReceiveDTMFandDecideToReceiveFaxOrVoiceApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

extern CReceiveDTMFandDecideToReceiveFaxOrVoiceApp theApp;

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_RECEIVEDTMFANDDECIDETORECEIVEFAXORVOICE_H__C813BD06_134D_4D33_AE46_EFF8B5F7B746__INCLUDED_)
