#if !defined(AFX_DLGSENDFAX_H__FECC7150_414C_43CF_972D_FE8A238FEEA3__INCLUDED_)
#define AFX_DLGSENDFAX_H__FECC7150_414C_43CF_972D_FE8A238FEEA3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// DlgSendFax.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CDlgSendFax dialog

class CDlgSendFax : public CDialog
{
// Construction
public:
	CDlgSendFax(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CDlgSendFax)
	enum { IDD = IDD_SENDFAX };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDlgSendFax)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CDlgSendFax)
	virtual BOOL OnInitDialog();
	afx_msg void OnBrowse();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGSENDFAX_H__FECC7150_414C_43CF_972D_FE8A238FEEA3__INCLUDED_)
