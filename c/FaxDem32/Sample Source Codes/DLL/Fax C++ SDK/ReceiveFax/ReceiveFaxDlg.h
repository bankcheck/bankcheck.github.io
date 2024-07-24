// ReceiveFaxDlg.h : header file
//

#if !defined(AFX_RECEIVEFAXDLG_H__8BE783CC_EA64_42A4_BA7E_4BFB270500F7__INCLUDED_)
#define AFX_RECEIVEFAXDLG_H__8BE783CC_EA64_42A4_BA7E_4BFB270500F7__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CReceiveFaxDlg dialog

class CReceiveFaxDlg : public CDialog
{
// Construction
public:
	CReceiveFaxDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CReceiveFaxDlg)
	enum { IDD = IDD_RECEIVEFAX_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CReceiveFaxDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CReceiveFaxDlg)
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

#endif // !defined(AFX_RECEIVEFAXDLG_H__8BE783CC_EA64_42A4_BA7E_4BFB270500F7__INCLUDED_)
