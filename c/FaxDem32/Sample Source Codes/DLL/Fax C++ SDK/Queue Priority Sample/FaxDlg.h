#if !defined(AFX_DLGFAXPORTSETUP_H__9742489B_ABCF_4EBD_8F6C_A1D53FE0347A__INCLUDED_)
#define AFX_DLGFAXPORTSETUP_H__9742489B_ABCF_4EBD_8F6C_A1D53FE0347A__INCLUDED_

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
	afx_msg void OnSelchangeFaxlist();
	afx_msg void OnChangeSetup();
	afx_msg void OnChangeReset();
	virtual void OnOK();
	afx_msg void OnTestmodem();
	afx_msg void OnTestdialtone();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGFAXPORTSETUP_H__9742489B_ABCF_4EBD_8F6C_A1D53FE0347A__INCLUDED_)
