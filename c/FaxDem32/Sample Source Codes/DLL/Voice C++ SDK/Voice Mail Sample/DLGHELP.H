#if !defined(AFX_DLGHELP_H__EAA30460_220F_11D3_AFC6_0040F614A5A0__INCLUDED_)
#define AFX_DLGHELP_H__EAA30460_220F_11D3_AFC6_0040F614A5A0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// DlgHelp.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CDlgHelp dialog

class CDlgHelp : public CDialog
{
// Construction
public:
	CDlgHelp(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CDlgHelp)
	enum { IDD = IDD_HELP };
	CRichEditCtrl	m_cTextCtrl;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDlgHelp)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CDlgHelp)
	virtual BOOL OnInitDialog();
	afx_msg void OnClose();
	afx_msg void OnShowWindow(BOOL bShow, UINT nStatus);
	afx_msg void OnSize(UINT nType, int cx, int cy);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGHELP_H__EAA30460_220F_11D3_AFC6_0040F614A5A0__INCLUDED_)
