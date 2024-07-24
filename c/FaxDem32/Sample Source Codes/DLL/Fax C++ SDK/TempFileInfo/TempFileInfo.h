// TempFileInfo.h : main header file for the TEMPFILEINFO application
//

#if !defined(AFX_TEMPFILEINFO_H__716D687B_046B_4C7B_BD81_BE6CCED1A1C8__INCLUDED_)
#define AFX_TEMPFILEINFO_H__716D687B_046B_4C7B_BD81_BE6CCED1A1C8__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CTempFileInfoApp:
// See TempFileInfo.cpp for the implementation of this class
//

#define FXT_NORMAL  'N'
#define FXT_BFT     'B'
#define FXT_COLOR   'C' 

class CTempFileInfoApp : public CWinApp
{
public:
	CTempFileInfoApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CTempFileInfoApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CTempFileInfoApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_TEMPFILEINFO_H__716D687B_046B_4C7B_BD81_BE6CCED1A1C8__INCLUDED_)
