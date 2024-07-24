// ReceiveFaxWithDTMF.h : main header file for the RECEIVEFAXWITHDTMF application
//

#if !defined(AFX_RECEIVEFAXWITHDTMF_H__E1024A4B_FD68_44EE_89C8_B47AF2E39937__INCLUDED_)
#define AFX_RECEIVEFAXWITHDTMF_H__E1024A4B_FD68_44EE_89C8_B47AF2E39937__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

#define MAX_FAXCHANNELS 100

#include "faxcpp.h"
#include "faxtype.h"

#define MAX_FAXCHANNELS 100 // Brooktrout
#define MAX_GAMMACHANNELS 70 // GammaLink
#define MAX_DIALOGICCHANNELS 64 // Dialogic
#define MAX_NMSCHANNELS 128 //Nms
#define MAX_FAXPORTS    (MAX_FAXCHANNELS+MAX_GAMMACHANNELS+MAX_DIALOGICCHANNELS+MAX_NMSCHANNELS)

/////////////////////////////////////////////////////////////////////////////
// CReceiveFaxWithDTMFApp:
// See ReceiveFaxWithDTMF.cpp for the implementation of this class
//

class CReceiveFaxWithDTMFApp : public CWinApp
{
public:
	CReceiveFaxWithDTMFApp();
	PORTFAX     FaxPorts[MAX_FAXCHANNELS];
	int m_nDialogicBoard;
    int         m_nNmsBoard;
	int         m_nGammaChannel;
	LPSTR       BrooktroutChannels;
	UINT        nMessage;

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CReceiveFaxWithDTMFApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CReceiveFaxWithDTMFApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_RECEIVEFAXWITHDTMF_H__E1024A4B_FD68_44EE_89C8_B47AF2E39937__INCLUDED_)
