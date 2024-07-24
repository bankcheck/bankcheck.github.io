// ReceiveFaxWithDTMFDlg.h : header file
//

#if !defined(AFX_RECEIVEFAXWITHDTMFDLG_H__C7F91933_1BCA_4607_B02B_1D25DAF4D093__INCLUDED_)
#define AFX_RECEIVEFAXWITHDTMFDLG_H__C7F91933_1BCA_4607_B02B_1D25DAF4D093__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CReceiveFaxWithDTMFDlg dialog

class CReceiveFaxWithDTMFDlg : public CDialog
{
// Construction
public:
	CReceiveFaxWithDTMFDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CReceiveFaxWithDTMFDlg)
	enum { IDD = IDD_RECEIVEFAXWITHDTMF_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CReceiveFaxWithDTMFDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CReceiveFaxWithDTMFDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnDestroy();
	afx_msg void OnBrooktrout();
	afx_msg void OnClose();
	afx_msg void OnDialogic();
	afx_msg void OnGammalink();
	afx_msg void OnNms();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_RECEIVEFAXWITHDTMFDLG_H__C7F91933_1BCA_4607_B02B_1D25DAF4D093__INCLUDED_)
