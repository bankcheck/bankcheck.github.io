// FaxWithBrooktroutDlg.h : header file
//

#if !defined(AFX_FAXWITHBROOKTROUTDLG_H__6AC87A82_BD85_4BCC_A442_0424FD20FB84__INCLUDED_)
#define AFX_FAXWITHBROOKTROUTDLG_H__6AC87A82_BD85_4BCC_A442_0424FD20FB84__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CFaxWithBrooktroutDlg dialog

class CFaxWithBrooktroutDlg : public CDialog
{
// Construction
public:
	CFaxWithBrooktroutDlg(CWnd* pParent = NULL);	// standard constructor
	void        SetEventText(LPSTR buf);
// Dialog Data
	//{{AFX_DATA(CFaxWithBrooktroutDlg)
	enum { IDD = IDD_FAXWITHBROOKTROUT_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFaxWithBrooktroutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CFaxWithBrooktroutDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnBrooktrout();
	afx_msg void OnClose();
	afx_msg void OnStartsession();
	afx_msg void OnStopsession();
	afx_msg void OnTimer(UINT nIDEvent);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FAXWITHBROOKTROUTDLG_H__6AC87A82_BD85_4BCC_A442_0424FD20FB84__INCLUDED_)
