// FAXSEND.h : main header file for the FAXSEND application
//

#if !defined(AFX_FAXSEND_H__DCF63AD8_7AC6_45A6_8D78_377A3184090B__INCLUDED_)
#define AFX_FAXSEND_H__DCF63AD8_7AC6_45A6_8D78_377A3184090B__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CFAXSENDApp:
// See FAXSEND.cpp for the implementation of this class
//

class CFAXSENDApp : public CWinApp
{
public:
	CFAXSENDApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFAXSENDApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CFAXSENDApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FAXSEND_H__DCF63AD8_7AC6_45A6_8D78_377A3184090B__INCLUDED_)
