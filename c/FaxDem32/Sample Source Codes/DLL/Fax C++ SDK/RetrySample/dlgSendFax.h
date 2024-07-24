#if !defined(AFX_DLGSENDFAX_H__2096EEAF_E221_4A9B_B7B0_4942D067D216__INCLUDED_)
#define AFX_DLGSENDFAX_H__2096EEAF_E221_4A9B_B7B0_4942D067D216__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// dlgSendFax.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CdlgSendFax dialog

class CdlgSendFax : public CDialog
{
// Construction
public:
	CdlgSendFax(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CdlgSendFax)
	enum { IDD = IDD_SENDFAX };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CdlgSendFax)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CdlgSendFax)
	virtual BOOL OnInitDialog();
	afx_msg void OnBrowse();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGSENDFAX_H__2096EEAF_E221_4A9B_B7B0_4942D067D216__INCLUDED_)
