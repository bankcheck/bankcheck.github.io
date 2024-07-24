#if !defined(AFX_HELPDIALOG_H__84B02179_F5F2_4EF1_B41A_0B60270C57EF__INCLUDED_)
#define AFX_HELPDIALOG_H__84B02179_F5F2_4EF1_B41A_0B60270C57EF__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// HelpDialog.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CHelpDialog dialog

class CHelpDialog : public CDialog
{
// Construction
public:
	CHelpDialog(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CHelpDialog)
	enum { IDD = IDD_CHELPDIALOG };
	CListBox	m_list1;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CHelpDialog)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	virtual BOOL OnInitDialog();
	//{{AFX_MSG(CHelpDialog)
		// NOTE: the ClassWizard will add member functions here
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_HELPDIALOG_H__84B02179_F5F2_4EF1_B41A_0B60270C57EF__INCLUDED_)
