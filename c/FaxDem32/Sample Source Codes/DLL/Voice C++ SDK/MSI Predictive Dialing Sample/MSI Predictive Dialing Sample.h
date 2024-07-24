// MSI Predictive Dialing Sample.h : main header file for the MSI PREDICTIVE DIALING SAMPLE application
//

#if !defined(AFX_MSIPREDICTIVEDIALINGSAMPLE_H__BD88878C_347B_45C5_B362_43655067CFF5__INCLUDED_)
#define AFX_MSIPREDICTIVEDIALINGSAMPLE_H__BD88878C_347B_45C5_B362_43655067CFF5__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CMSIPredictiveDialingSampleApp:
// See MSI Predictive Dialing Sample.cpp for the implementation of this class
//

class CMSIPredictiveDialingSampleApp : public CWinApp
{
public:
	CMSIPredictiveDialingSampleApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMSIPredictiveDialingSampleApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CMSIPredictiveDialingSampleApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MSIPREDICTIVEDIALINGSAMPLE_H__BD88878C_347B_45C5_B362_43655067CFF5__INCLUDED_)
