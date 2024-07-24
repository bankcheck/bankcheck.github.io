// TempFileInfoDlg.h : header file
//

#if !defined(AFX_TEMPFILEINFODLG_H__C7B97F26_A6B8_449F_8DA2_B7243E790D63__INCLUDED_)
#define AFX_TEMPFILEINFODLG_H__C7B97F26_A6B8_449F_8DA2_B7243E790D63__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CTempFileInfoDlg dialog

class CTempFileInfoDlg : public CDialog
{
// Construction
public:
	CTempFileInfoDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CTempFileInfoDlg)
	enum { IDD = IDD_TEMPFILEINFO_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CTempFileInfoDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;
	char m_tmpFile[MAX_PATH];


	// Generated message map functions
	//{{AFX_MSG(CTempFileInfoDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnTempfileinfoDialog();	
	afx_msg void OnBrowse();
	virtual void OnOK();
	afx_msg void OnSelchangeList1();
	afx_msg void OnSelectTempFile();
	virtual void OnCancel();	
	afx_msg void OnSaveInTiff();
	afx_msg void OnSave();
	afx_msg void OnOpen();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_TEMPFILEINFODLG_H__C7B97F26_A6B8_449F_8DA2_B7243E790D63__INCLUDED_)
