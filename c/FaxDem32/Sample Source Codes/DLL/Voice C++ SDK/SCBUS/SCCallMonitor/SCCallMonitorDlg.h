// SCCallMonitorDlg.h : header file
//

#if !defined(AFX_SCCALLMONITORDLG_H__42EC73C4_A694_11D4_B1F1_0040053DA77D__INCLUDED_)
#define AFX_SCCALLMONITORDLG_H__42EC73C4_A694_11D4_B1F1_0040053DA77D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CSCCallMonitorDlg dialog

class CSCCallMonitorDlg : public CDialog
{
        enum STATES{    STATE_STARTING, 
                    STATE_OPENINGPORTS, 
                    STATE_WAITING_FOR_CALL1, 
                    STATE_ANSWERING_CALL1, 
                    STATE_WAITING_FOR_CALL2, 
                    STATE_ANSWERING_CALL2, 
                    STATE_CONNECTED, 
                    STATE_FINISHING};

// Construction
public:
	CSCCallMonitorDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CSCCallSwitchDlg)
	enum { IDD = IDD_SCCALLSWITCH_DIALOG };
	CComboBox	m_cbVoiceRes2;
	CEdit	m_eProtocol2;
	CComboBox	m_cbLineType2;
	CComboBox	m_cbLineRes2;
	CEdit	m_eProtocol;
	CComboBox	m_cbLineType;
	CComboBox	m_cbVoiceRes;
	CComboBox	m_cbLineRes;
	CListBox	m_lbMessages;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSCCallMonitorDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
    void StatusMsg(LPCSTR msg,...);
    long OnVoiceMsg(WPARAM event,LPARAM lParam);


    SCBUSRES m_hLineHandle;
    SCBUSRES m_hVoiceHandle;

    SCBUSRES m_hLineHandle2;
    SCBUSRES m_hVoiceHandle2;


    MODEMOBJ m_hModemObj;
    MODEMOBJ m_hModemObj2;

    void RecordMessage(MODEMOBJ Modem);

    enum STATES m_n_States;

    bool bExit;
    bool bStop;

    bool bLine1Connected;
    bool bLine2Connected;

    bool bStopRecord1;
    bool bStopRecord2;

    void Hangup();
    void CloseResources();

    void EnableControls(BOOL Enabled);

    bool OpenCall1Resources();
    bool OpenCall2Resources();
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CSCCallMonitorDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnSelchangeLinetype();
	afx_msg void OnClear();
	afx_msg void OnCopy();
	afx_msg void OnHelp();
	afx_msg void OnSelchangeLinetype2();
	afx_msg void OnHangup1();
	afx_msg void OnHangup2();
	afx_msg void OnStart();
	virtual void OnCancel();
	afx_msg void OnStopwait();
	afx_msg void OnDestroy();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SCCALLMONITORDLG_H__42EC73C4_A694_11D4_B1F1_0040053DA77D__INCLUDED_)
