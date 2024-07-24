// SCReceiveFaxDlg.h : header file
//

#if !defined(AFX_SCReceiveFaxDLG_H__42EC73C4_A694_11D4_B1F1_0040053DA77D__INCLUDED_)
#define AFX_SCReceiveFaxDLG_H__42EC73C4_A694_11D4_B1F1_0040053DA77D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CSCReceiveFaxDlg dialog

class CSCReceiveFaxDlg : public CDialog
{
// Construction
public:
    enum STATES{    STATE_STARTING, 
                    STATE_OPENINGPORTS, 
                    STATE_WAITINGFORCALLS, 
                    STATE_ANSWERING,
                    STATE_SWITCHING_TO_FAX_MODE, 
                    STATE_STARTRECEIVINGFAX, 
                    STATE_RECEIVINGFAX, 
                    STATE_RETURNTOVOICEMODE, 
                    STATE_FINISHING};
    CSCReceiveFaxDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CSCReceiveFaxDlg)
	enum { IDD = IDD_SCRECEIVEFAX_DIALOG };
	CEdit	m_eFaxNr;
	CEdit	m_eProtocol;
	CComboBox	m_cbLineType;
	CComboBox	m_cbVoiceRes;
	CComboBox	m_cbFaxRes;
	CComboBox	m_cbLineRes;
	CListBox	m_lbMessages;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSCReceiveFaxDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
    void StatusMsg(LPCSTR msg,...);
    long OnVoiceMsg(WPARAM event,LPARAM lParam);
    void Return2VoiceMode();
    void Hangup();
    void CloseResources();
    bool CreateFaxObject();
    void SaveReceivedFax(FAXOBJ faxobj);

    SCBUSRES m_hLineHandle;
    SCBUSRES m_hVoiceHandle;
    SCBUSRES m_hFaxHandle;

    MODEMOBJ m_hModemObj;

    enum STATES m_n_States;
    PORTFAX  m_pPortFax;

protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CSCReceiveFaxDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnSelchangeLinetype();
	afx_msg void OnBroswe();
	afx_msg void OnStart();
	afx_msg void OnClear();
	afx_msg void OnCopy();
	afx_msg void OnHelp();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SCReceiveFaxDLG_H__42EC73C4_A694_11D4_B1F1_0040053DA77D__INCLUDED_)
