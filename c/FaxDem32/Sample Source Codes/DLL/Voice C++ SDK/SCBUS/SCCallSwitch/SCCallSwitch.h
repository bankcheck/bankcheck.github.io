// SCCallSwitch.h : main header file for the SCCALLSWITCH application
//

#if !defined(AFX_SCCALLSWITCH_H__42EC73C2_A694_11D4_B1F1_0040053DA77D__INCLUDED_)
#define AFX_SCCALLSWITCH_H__42EC73C2_A694_11D4_B1F1_0040053DA77D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CSCCallSwitchApp:
// See CSCCallSwitch.cpp for the implementation of this class
//

class CSCCallSwitchApp : public CWinApp
{
public:
	CSCCallSwitchApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSCCallSwitchApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CSCCallSwitchApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SCCALLSWITCH_H__42EC73C2_A694_11D4_B1F1_0040053DA77D__INCLUDED_)
