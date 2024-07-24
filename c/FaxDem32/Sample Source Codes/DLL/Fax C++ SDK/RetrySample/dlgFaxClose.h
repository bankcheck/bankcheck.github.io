#if !defined(AFX_DLGFAXCLOSE_H__48137987_E561_4435_83C1_D5A17375297F__INCLUDED_)
#define AFX_DLGFAXCLOSE_H__48137987_E561_4435_83C1_D5A17375297F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// dlgFaxClose.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CdlgFaxClose dialog

class CdlgFaxClose : public CDialog
{
// Construction
public:
	CdlgFaxClose(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CdlgFaxClose)
	enum { IDD = IDD_CLOSEFAX };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CdlgFaxClose)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CdlgFaxClose)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGFAXCLOSE_H__48137987_E561_4435_83C1_D5A17375297F__INCLUDED_)
