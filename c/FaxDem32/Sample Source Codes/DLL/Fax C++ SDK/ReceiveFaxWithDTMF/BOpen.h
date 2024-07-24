#if !defined(AFX_BOPEN_H__3929263B_5F4A_46CD_8E96_B71F52422C82__INCLUDED_)
#define AFX_BOPEN_H__3929263B_5F4A_46CD_8E96_B71F52422C82__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// BOpen.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CBOpen dialog

class CBOpen : public CDialog
{
// Construction
public:
	CBOpen(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CBOpen)
	enum { IDD = IDD_OPENBCHANNEL };
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CBOpen)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CBOpen)
	virtual BOOL OnInitDialog();
	afx_msg void OnBrowse();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_BOPEN_H__3929263B_5F4A_46CD_8E96_B71F52422C82__INCLUDED_)
