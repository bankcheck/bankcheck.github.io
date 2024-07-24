// OCXDEMO.h : main header file for the OCXDEMO application
//

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"       // main symbols

class CFAX;

/////////////////////////////////////////////////////////////////////////////
// COCXDEMOApp:
// See OCXDEMO.cpp for the implementation of this class
//

class COCXDEMOApp : public CWinApp
{
public:
	COCXDEMOApp();

    CFAX *m_pFax;
	CString PortsAndClasses;

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(COCXDEMOApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(COCXDEMOApp)
	afx_msg void OnAppAbout();
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////
