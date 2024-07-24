// OpenFaxBoards.h : main header file for the OPENFAXBOARDS application
//

#if !defined(AFX_OPENFAXBOARDS_H__0ABDD534_4FBA_43CA_BD77_7DA657DEE1A7__INCLUDED_)
#define AFX_OPENFAXBOARDS_H__0ABDD534_4FBA_43CA_BD77_7DA657DEE1A7__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

#define MAX_FAXCHANNELS 100 // Brooktrout
#define MAX_GAMMACHANNELS 70 // GammaLink
#define MAX_DIALOGICCHANNELS 64 // Dialogic
#define MAX_NMSCHANNELS 128 //Nms
#define MAX_FAXPORTS    (MAX_FAXCHANNELS+MAX_GAMMACHANNELS+MAX_DIALOGICCHANNELS+MAX_NMSCHANNELS)

#include "faxcpp.h"
#include "faxtype.h"


/////////////////////////////////////////////////////////////////////////////
// COpenFaxBoardsApp:
// See OpenFaxBoards.cpp for the implementation of this class
//

class COpenFaxBoardsApp : public CWinApp
{
public:
	COpenFaxBoardsApp();
	PORTFAX     FaxPorts[MAX_FAXPORTS];
	int m_nDialogicBoard;
    int         m_nNmsBoard;
	int         m_nGammaChannel;
	LPSTR       BrooktroutChannels;

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(COpenFaxBoardsApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(COpenFaxBoardsApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_OPENFAXBOARDS_H__0ABDD534_4FBA_43CA_BD77_7DA657DEE1A7__INCLUDED_)
