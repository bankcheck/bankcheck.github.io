#if !defined(AFX_DLGSENDFAX_H__37E0E57D_CC01_4FCE_BB58_AB351C213A5D__INCLUDED_)
#define AFX_DLGSENDFAX_H__37E0E57D_CC01_4FCE_BB58_AB351C213A5D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// dlgSendFax.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// dlgSendFax dialog

class dlgSendFax : public CDialog
{
// Construction
public:
	dlgSendFax(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(dlgSendFax)
	enum { IDD = IDD_SEND };
	CListCtrl	m_channellist;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(dlgSendFax)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(dlgSendFax)
	virtual BOOL OnInitDialog();
	afx_msg void OnBrowse();
	afx_msg void OnConfirmnumber();
	afx_msg void OnConfirmfile();
	virtual void OnOK();
	afx_msg void OnReceive();
	afx_msg void OnConfirmnumberAll();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGSENDFAX_H__37E0E57D_CC01_4FCE_BB58_AB351C213A5D__INCLUDED_)
