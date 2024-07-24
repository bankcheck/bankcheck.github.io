// QueueFaxSample.h : main header file for the QUEUEFAXSAMPLE application
//

#if !defined(AFX_QUEUEFAXSAMPLE_H__E8A7427E_5C5F_48ED_8262_650FF7A07DCC__INCLUDED_)
#define AFX_QUEUEFAXSAMPLE_H__E8A7427E_5C5F_48ED_8262_650FF7A07DCC__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef WIN32
#define MAX_FAXPORTS    4
#else
#define MAX_COMPORTS    128
#define MAX_FAXCHANNELS 100 // Brooktrout
#define MAX_FAXPORTS    (MAX_COMPORTS+MAX_FAXCHANNELS)
#endif

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

#ifdef WIN32
        #include "stdafx.h"
        #include "faxtype.h"
#endif
#include "QueueFaxSampleDlg.h"

/////////////////////////////////////////////////////////////////////////////
// CQueueFaxSampleApp:
// See QueueFaxSample.cpp for the implementation of this class
//

class CQueueFaxSampleApp : public CWinApp
{
public:
	CQueueFaxSampleApp();
	PORTFAX     FaxPorts[MAX_FAXPORTS];
	LPSTR       BrooktroutChannels;
    int         m_nGammaChannel;

    int         m_nDialogicBoard;

    int         m_nBicomBoard;
    int         m_nCmtxChannels;
    int         m_nNmsBoard;

	int         nRings[MAX_FAXPORTS];
	int         nComm[MAX_FAXPORTS];
	UINT        nMessage;
	CString     m_szDemoPath;
	TESpeakerTurnOn SpeakerMode;
    TESpeakerVolume SpeakerVolume;
	TERuningMode    RunMode;
	CString fileName;
	void FaxEventText(int iPort, LPSTR buf);
	BOOL        CreateDirs();
	HFILE       GetFileName(CString &, CString &, CString &);
// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CQueueFaxSampleApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CQueueFaxSampleApp)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_QUEUEFAXSAMPLE_H__E8A7427E_5C5F_48ED_8262_650FF7A07DCC__INCLUDED_)
