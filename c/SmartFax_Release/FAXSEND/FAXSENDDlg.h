// FAXSENDDlg.h : header file
//

#if !defined(AFX_FAXSENDDLG_H__64F32EA1_2D41_4A69_90BD_D4795568BF7E__INCLUDED_)
#define AFX_FAXSENDDLG_H__64F32EA1_2D41_4A69_90BD_D4795568BF7E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CFAXSENDDlg dialog

#include "..\include\SmarFaxh.h"




class CFAXSENDDlg : public CDialog
{
// Construction
public:
	CString GetFullPath(CString FileName);
	CString GetWorkPath();
	int ComPortSendFax();
	int TapiSendFax();
	static void __stdcall FillComboBox(DWORD dwDevice, const char *sLineName, const char *ComPort,unsigned long lParam);
	void OnSmartFax(WPARAM wParam, LPARAM lParam);
	CFAXSENDDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CFAXSENDDlg)
	enum { IDD = IDD_FAXSEND_DIALOG };
	CComboBox	m_ModemList;
	CString	m_CIS;
	CString	m_FaxFileName;
	CString	m_FaxNumber;
	CString	m_Speed;
	int		m_iSpeed;
	BOOL	m_bIs2D;
	BOOL	m_CreateHead;
	int		m_iClass;
	CString	m_sIdentifi;
	CString	m_sIdentif;
	CString	m_sTakeTime;
	long	m_nTimes;
	BOOL	m_bEcm;
	CString	m_sPage;
	int		m_iVolume;
	CString	m_Remote;
	CString	m_From;
	CString	m_Stat;
	CString	m_Fax_data;
	int		m_iPort;
	CString	m_To;
	int		m_nResolution;
	//}}AFX_DATA
	

	bool m_bEcmFlag;
	int  m_nPage;
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFAXSENDDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;
	SmartFaxObj g_hFax ;
	CString m_strSelModem;
	char m_iSelid;
	// Generated message map functions
	//{{AFX_MSG(CFAXSENDDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnSendFax();
	afx_msg void OnCancelFax();
	afx_msg void OnTimer(UINT nIDEvent);
	afx_msg void OnCreateHead();
	afx_msg void OnStaticWww();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

extern CFAXSENDDlg *g_FaxDialog;

#endif // !defined(AFX_FAXSENDDLG_H__64F32EA1_2D41_4A69_90BD_D4795568BF7E__INCLUDED_)
