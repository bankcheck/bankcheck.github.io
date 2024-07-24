// ReceiveFax.h : main header file for the RECEIVEFAX application
//

#if !defined(AFX_RECEIVEFAX_H__59E2B4D0_F505_41FD_B1C4_8926CCC70682__INCLUDED_)
#define AFX_RECEIVEFAX_H__59E2B4D0_F505_41FD_B1C4_8926CCC70682__INCLUDED_

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
// CReceiveFaxApp:
// See ReceiveFax.cpp for the implementation of this class
//

class CReceiveFaxApp : public CWinApp
{
public:
	CReceiveFaxApp();
	PORTFAX     FaxPorts[MAX_COMPORTS];
	UINT        nMessage;

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CReceiveFaxApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CReceiveFaxApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_RECEIVEFAX_H__59E2B4D0_F505_41FD_B1C4_8926CCC70682__INCLUDED_)
