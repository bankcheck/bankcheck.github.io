// OpenComPortsDlg.h : header file
//

#if !defined(AFX_OPENCOMPORTSDLG_H__EE9431FD_7D8F_4370_9842_CE460BE78E5C__INCLUDED_)
#define AFX_OPENCOMPORTSDLG_H__EE9431FD_7D8F_4370_9842_CE460BE78E5C__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// COpenComPortsDlg dialog

class COpenComPortsDlg : public CDialog
{
// Construction
public:
	COpenComPortsDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(COpenComPortsDlg)
	enum { IDD = IDD_OPENCOMPORTS_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(COpenComPortsDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(COpenComPortsDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnDestroy();
	afx_msg void OnOpenport();
	afx_msg void OnCloseport();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_OPENCOMPORTSDLG_H__EE9431FD_7D8F_4370_9842_CE460BE78E5C__INCLUDED_)
