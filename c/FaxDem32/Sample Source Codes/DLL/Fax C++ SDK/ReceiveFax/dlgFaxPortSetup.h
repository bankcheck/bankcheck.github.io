#if !defined(AFX_DLGFAXPORTSETUP_H__A7B7C7F5_A647_4CF5_800E_D2B1B1CC94DB__INCLUDED_)
#define AFX_DLGFAXPORTSETUP_H__A7B7C7F5_A647_4CF5_800E_D2B1B1CC94DB__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// dlgFaxPortSetup.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CdlgFaxPortSetup dialog

class CdlgFaxPortSetup : public CDialog
{
// Construction
public:
	CdlgFaxPortSetup(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CdlgFaxPortSetup)
	enum { IDD = IDD_PORTSETUP };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CdlgFaxPortSetup)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CdlgFaxPortSetup)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGFAXPORTSETUP_H__A7B7C7F5_A647_4CF5_800E_D2B1B1CC94DB__INCLUDED_)