// OpenComPorts.h : main header file for the OPENCOMPORTS application
//

#if !defined(AFX_OPENCOMPORTS_H__46B493FF_3920_4962_88A7_A0933E71101C__INCLUDED_)
#define AFX_OPENCOMPORTS_H__46B493FF_3920_4962_88A7_A0933E71101C__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

#define MAX_COMPORTS    128

#include "faxcpp.h"
#include "faxtype.h"

/////////////////////////////////////////////////////////////////////////////
// COpenComPortsApp:
// See OpenComPorts.cpp for the implementation of this class
//

class COpenComPortsApp : public CWinApp
{
public:
	COpenComPortsApp();
	PORTFAX     FaxPorts[MAX_COMPORTS];


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(COpenComPortsApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(COpenComPortsApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_OPENCOMPORTS_H__46B493FF_3920_4962_88A7_A0933E71101C__INCLUDED_)
