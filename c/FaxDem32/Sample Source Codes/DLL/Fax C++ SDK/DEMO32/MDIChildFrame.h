#if !defined(AFX_MDICHILDFRAME_H__3DBAE802_5191_48B5_B847_2912389B3007__INCLUDED_)
#define AFX_MDICHILDFRAME_H__3DBAE802_5191_48B5_B847_2912389B3007__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// MDIChildFrame.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CMDIChildFrame frame

class CMDIChildFrame : public CMDIChildWnd
{
	DECLARE_DYNCREATE(CMDIChildFrame)
protected:
	CMDIChildFrame();           // protected constructor used by dynamic creation

// Attributes
public:

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMDIChildFrame)
	protected:
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
	//}}AFX_VIRTUAL

// Implementation
protected:
	virtual ~CMDIChildFrame();

	// Generated message map functions
	//{{AFX_MSG(CMDIChildFrame)
		// NOTE - the ClassWizard will add and remove member functions here.
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MDICHILDFRAME_H__3DBAE802_5191_48B5_B847_2912389B3007__INCLUDED_)
