#if !defined(AFX_DLGFAXCLOSE_H__170B7CC1_3B79_4697_954E_289975AE0D49__INCLUDED_)
#define AFX_DLGFAXCLOSE_H__170B7CC1_3B79_4697_954E_289975AE0D49__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// DlgFaxClose.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CDlgFaxClose dialog

class CDlgFaxClose : public CDialog
{
// Construction
public:
	CDlgFaxClose(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CDlgFaxClose)
	enum { IDD = IDD_CLOSEFAX };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDlgFaxClose)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CDlgFaxClose)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGFAXCLOSE_H__170B7CC1_3B79_4697_954E_289975AE0D49__INCLUDED_)
