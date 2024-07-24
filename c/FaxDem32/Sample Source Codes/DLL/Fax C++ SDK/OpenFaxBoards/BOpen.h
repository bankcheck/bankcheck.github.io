#if !defined(AFX_BOPEN_H__6F4413D1_730E_456D_87D0_5204DCA55486__INCLUDED_)
#define AFX_BOPEN_H__6F4413D1_730E_456D_87D0_5204DCA55486__INCLUDED_

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
		// NOTE: the ClassWizard will add data members here
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

#endif // !defined(AFX_BOPEN_H__6F4413D1_730E_456D_87D0_5204DCA55486__INCLUDED_)
