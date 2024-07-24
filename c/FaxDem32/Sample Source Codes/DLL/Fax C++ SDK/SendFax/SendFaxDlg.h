// SendFaxDlg.h : header file
//

#if !defined(AFX_SENDFAXDLG_H__6E051C8D_FAA6_43B4_A7B4_367CEAC0B687__INCLUDED_)
#define AFX_SENDFAXDLG_H__6E051C8D_FAA6_43B4_A7B4_367CEAC0B687__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CSendFaxDlg dialog

class CSendFaxDlg : public CDialog
{
// Construction
public:
	CSendFaxDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CSendFaxDlg)
	enum { IDD = IDD_SENDFAX_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSendFaxDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	virtual LRESULT DefWindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CSendFaxDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnDestroy();
	afx_msg void OnOpenport();
	afx_msg void OnCloseport();
	afx_msg void OnSendfax();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SENDFAXDLG_H__6E051C8D_FAA6_43B4_A7B4_367CEAC0B687__INCLUDED_)
