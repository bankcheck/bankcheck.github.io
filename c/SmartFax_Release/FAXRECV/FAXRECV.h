// FAXRECV.h : main header file for the FAXRECV application
//

#if !defined(AFX_FAXRECV_H__6DE89DCF_E7DC_427C_85FB_7820B135D07A__INCLUDED_)
#define AFX_FAXRECV_H__6DE89DCF_E7DC_427C_85FB_7820B135D07A__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CFAXRECVApp:
// See FAXRECV.cpp for the implementation of this class
//

class CFAXRECVApp : public CWinApp
{
public:
	CFAXRECVApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFAXRECVApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CFAXRECVApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FAXRECV_H__6DE89DCF_E7DC_427C_85FB_7820B135D07A__INCLUDED_)
