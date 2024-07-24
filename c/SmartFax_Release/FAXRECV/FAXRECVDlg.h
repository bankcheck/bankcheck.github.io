// FAXRECVDlg.h : header file
//

#if !defined(AFX_FAXRECVDLG_H__46F4BE01_25F3_49F2_A0F6_18FA254ED654__INCLUDED_)
#define AFX_FAXRECVDLG_H__46F4BE01_25F3_49F2_A0F6_18FA254ED654__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


/////////////////////////////////////////////////////////////////////////////
// CFAXRECVDlg dialog





class CFAXRECVDlg : public CDialog
{
// Construction
public:
	int TapiSendCMD(HCALL &hCall,HLINE &hline,const char *strCMD);
	bool RecvFaxInComPort();
	static void __stdcall  FillComboBox(DWORD dwDevice, const char *sLineName, const char *ComPort,unsigned long lParam);
	bool RecvFaxInTapi();
	void OnSmartFax(WPARAM wParam, LPARAM lParam);
	CFAXRECVDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CFAXRECVDlg)
	enum { IDD = IDD_FAXRECV_DIALOG };
	CComboBox	m_ModemList;
	CString	m_CIS;
	CString	m_Speed;
	int		m_iSpeed;
	BOOL	m_bIs2D;
	int		m_iClassType;
	int		m_iVolume;
	CString	m_sFileName;
	CString	m_sIdentifi;
	BOOL	m_bEcm;
	CString	m_sTakeTime;
	CString	m_sPage;
	BOOL	m_bAutoAnswer;
	int		m_iPort;
	CString	m_Stat;
	CString	m_sRemote;
	CString	m_Fax_data;
	int		m_nResolution;
	CString	m_Ani;
	//}}AFX_DATA


	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFAXRECVDlg)
	public:
	virtual BOOL DestroyWindow();
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;
	CString m_strSelModem;

	clock_t m_cCheckT ;
	int m_nTimes;
	bool m_bEcmFlag;
	int m_nPage;


	bool	m_bFaxing;
	

	// Generated message map functions
	//{{AFX_MSG(CFAXRECVDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnDestroy();
	afx_msg void OnFaxNow();
	afx_msg void OnCancelFAX();
	afx_msg void OnTimer(UINT nIDEvent);
	afx_msg void OnOpenFaxFile();
	afx_msg void OnAutoAnswer();
	afx_msg void OnStaticWww();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

extern CFAXRECVDlg *g_FaxDialog;

#endif // !defined(AFX_FAXRECVDLG_H__46F4BE01_25F3_49F2_A0F6_18FA254ED654__INCLUDED_)
