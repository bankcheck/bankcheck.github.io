// QueueFaxSampleDlg.h : header file
//

#if !defined(AFX_QUEUEFAXSAMPLEDLG_H__3DB04C46_8726_4C82_AB82_83E4AA68CB91__INCLUDED_)
#define AFX_QUEUEFAXSAMPLEDLG_H__3DB04C46_8726_4C82_AB82_83E4AA68CB91__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CQueueFaxSampleDlg dialog

class CQueueFaxSampleDlg : public CDialog
{
// Construction
public:
	CQueueFaxSampleDlg(CWnd* pParent = NULL);	// standard constructor
	void        SetEventText(int iPort, LPSTR buf);
// Dialog Data
	//{{AFX_DATA(CQueueFaxSampleDlg)
	enum { IDD = IDD_QUEUEFAXSAMPLE_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CQueueFaxSampleDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	virtual LRESULT DefWindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CQueueFaxSampleDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnHelpAbout();
	afx_msg void OnHelpFaxcskdhelp();
	afx_msg void OnFaxOpenComport();
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnDestroy();
	afx_msg void OnFaxCloseportchannel();
	afx_msg void OnFaxOpenBrooktroutchannel();
	afx_msg void OnFileClear();
	afx_msg void OnFaxSend();
	afx_msg void OnUpdateFaxOpenComport(CCmdUI* pCmdUI);
	afx_msg void OnUpdateFaxOpenBrooktroutchannel(CCmdUI* pCmdUI);
	afx_msg void OnFileExit();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_QUEUEFAXSAMPLEDLG_H__3DB04C46_8726_4C82_AB82_83E4AA68CB91__INCLUDED_)
