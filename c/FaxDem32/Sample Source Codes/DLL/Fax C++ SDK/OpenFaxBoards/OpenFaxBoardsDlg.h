// OpenFaxBoardsDlg.h : header file
//

#if !defined(AFX_OPENFAXBOARDSDLG_H__E27E5808_4802_40B9_A1B6_0120335F9BA7__INCLUDED_)
#define AFX_OPENFAXBOARDSDLG_H__E27E5808_4802_40B9_A1B6_0120335F9BA7__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// COpenFaxBoardsDlg dialog

class COpenFaxBoardsDlg : public CDialog
{
// Construction
public:
	COpenFaxBoardsDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(COpenFaxBoardsDlg)
	enum { IDD = IDD_OPENFAXBOARDS_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(COpenFaxBoardsDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(COpenFaxBoardsDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnBrooktrout();
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnDestroy();
	afx_msg void OnDialogic();
	afx_msg void OnGammalink();
	afx_msg void OnNms();
	afx_msg void OnClose();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_OPENFAXBOARDSDLG_H__E27E5808_4802_40B9_A1B6_0120335F9BA7__INCLUDED_)
