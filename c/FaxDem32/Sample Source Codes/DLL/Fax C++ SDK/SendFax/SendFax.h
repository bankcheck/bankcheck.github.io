// SendFax.h : main header file for the SENDFAX application
//

#if !defined(AFX_SENDFAX_H__0FB14CEB_6C43_4C9A_B4EF_C150B66C78F4__INCLUDED_)
#define AFX_SENDFAX_H__0FB14CEB_6C43_4C9A_B4EF_C150B66C78F4__INCLUDED_

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
// CSendFaxApp:
// See SendFax.cpp for the implementation of this class
//

class CSendFaxApp : public CWinApp
{
public:
	CSendFaxApp();
	PORTFAX     FaxPorts[MAX_COMPORTS];
	CString		fileName;
	UINT        nMessage;
// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSendFaxApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CSendFaxApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SENDFAX_H__0FB14CEB_6C43_4C9A_B4EF_C150B66C78F4__INCLUDED_)
