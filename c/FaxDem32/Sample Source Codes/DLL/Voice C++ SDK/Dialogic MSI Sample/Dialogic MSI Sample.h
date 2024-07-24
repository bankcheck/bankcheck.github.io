// Dialogic MSI Sample.h : main header file for the DIALOGIC MSI SAMPLE application
//

#if !defined(AFX_DIALOGICMSISAMPLE_H__3BF7495F_2B21_41DB_8E1F_5C742BA33622__INCLUDED_)
#define AFX_DIALOGICMSISAMPLE_H__3BF7495F_2B21_41DB_8E1F_5C742BA33622__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CDialogicMSISampleApp:
// See Dialogic MSI Sample.cpp for the implementation of this class
//

class CDialogicMSISampleApp : public CWinApp
{
public:
	CDialogicMSISampleApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDialogicMSISampleApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CDialogicMSISampleApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DIALOGICMSISAMPLE_H__3BF7495F_2B21_41DB_8E1F_5C742BA33622__INCLUDED_)
