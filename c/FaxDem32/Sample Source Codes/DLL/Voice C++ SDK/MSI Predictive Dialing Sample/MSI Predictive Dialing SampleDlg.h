// MSI Predictive Dialing SampleDlg.h : header file
//

#if !defined(AFX_MSIPREDICTIVEDIALINGSAMPLEDLG_H__15107BC6_59A2_44E9_AC6F_E431187704B1__INCLUDED_)
#define AFX_MSIPREDICTIVEDIALINGSAMPLEDLG_H__15107BC6_59A2_44E9_AC6F_E431187704B1__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CMSIPredictiveDialingSampleDlg dialog

class CMSIPredictiveDialingSampleDlg : public CDialog
{
// Construction
public:
	CMSIPredictiveDialingSampleDlg(CWnd* pParent = NULL);	// standard constructor
	long OnVoiceMsg(WPARAM event,LPARAM lParam);

// Dialog Data
	//{{AFX_DATA(CMSIPredictiveDialingSampleDlg)
	enum { IDD = IDD_MSIPREDICTIVEDIALINGSAMPLE_DIALOG };
	CString	m_Phone;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMSIPredictiveDialingSampleDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	int m_hMSIBoardHandle;
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CMSIPredictiveDialingSampleDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnButtonExit();
	afx_msg void OnButtonInphone();
	afx_msg void OnButtonOutphone();
	afx_msg void OnButtonStart();
	afx_msg void OnDestroy();
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	char numToStr(int i);
	void CloseAllResources();
	BOOL AreThereAnyActivePorts();
	void Handle_MFX_VOICE_CONNECT(MODEMOBJ ModemID);
	void Handle_MFX_SIT(MODEMOBJ ModemID);
	void Handle_MFX_ONHOOK(MODEMOBJ ModemID);
	void Handle_MFX_NO_DIALTONE(MODEMOBJ ModemID);
	void Handle_MFX_NO_CARRIER(MODEMOBJ ModemID);
	void Handle_MFX_NO_ANSWER(MODEMOBJ ModemID);
	void Handle_MFX_MSI_STATIONONHOOK(MODEMOBJ ModemID);
	void Handle_MFX_MODEM_OK(MODEMOBJ ModemID);
	void Handle_MFX_HANGUP(MODEMOBJ ModemID);
	void Handle_MFX_CALLING_TONE(MODEMOBJ ModemID);
	void Handle_MFX_BUSY(MODEMOBJ ModemID);
	void Handle_MFX_ANSWER_TONE(MODEMOBJ ModemID);
	void Handle_MFX_MSI_STATIONOFFHOOK(MODEMOBJ ModemObj);
	int GetIdleLine();
	int GetNotConnectedMSI();
	int FindLineModemObject(MODEMOBJ ModemID);
	void DialNumber(MODEMOBJ);
	CString GetComboVoiceText(int i);
	CString GetComboLineText(int i);
	int GetComboVoiceTextLength(int i);
	int GetComboLineTextLength(int i);
	CString GetComboMSIText(int i);
	int GetComboMSITextLength(int i);
	void SetChanelsInComboBoxs();
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MSIPREDICTIVEDIALINGSAMPLEDLG_H__15107BC6_59A2_44E9_AC6F_E431187704B1__INCLUDED_)
