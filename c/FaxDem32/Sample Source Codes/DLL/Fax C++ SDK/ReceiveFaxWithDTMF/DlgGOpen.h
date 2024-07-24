#if !defined(AFX_DLGGOPEN_H__CC938A07_3021_467A_917C_F200D139B63B__INCLUDED_)
#define AFX_DLGGOPEN_H__CC938A07_3021_467A_917C_F200D139B63B__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// DlgGOpen.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CDlgGOpen dialog

class CDlgGOpen : public CDialog
{
// Construction
public:
	CDlgGOpen(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CDlgGOpen)
	enum { IDD = IDD_OPENGCHANNEL };
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDlgGOpen)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CDlgGOpen)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGGOPEN_H__CC938A07_3021_467A_917C_F200D139B63B__INCLUDED_)
