// RetrySampleDlg.h : header file
//

#if !defined(AFX_RETRYSAMPLEDLG_H__0719CDCB_CD53_4227_8BE0_C6ACF76270FB__INCLUDED_)
#define AFX_RETRYSAMPLEDLG_H__0719CDCB_CD53_4227_8BE0_C6ACF76270FB__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CRetrySampleDlg dialog

class CRetrySampleDlg : public CDialog
{
// Construction
public:
	CRetrySampleDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CRetrySampleDlg)
	enum { IDD = IDD_RETRYSAMPLE_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CRetrySampleDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CRetrySampleDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnDestroy();
	afx_msg void OnTimer(UINT nIDEvent);
	afx_msg void OnOpenport();
	afx_msg void OnCloseport();
	afx_msg void OnSendfax();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_RETRYSAMPLEDLG_H__0719CDCB_CD53_4227_8BE0_C6ACF76270FB__INCLUDED_)
