// SCFollowMeDlg.h : header file
//

#if !defined(AFX_SCFOLLOWMEDLG_H__42EC73C4_A694_11D4_B1F1_0040053DA77D__INCLUDED_)
#define AFX_SCFOLLOWMEDLG_H__42EC73C4_A694_11D4_B1F1_0040053DA77D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CSCFollowMeDlg dialog

class CSCFollowMeDlg : public CDialog
{
    enum STATES{    STATE_STARTING, 
                    STATE_OPENINGPORTS, 
                    STATE_WAITING_FOR_CALL,
                    STATE_ANSWERING_CALL,
                    STATE_DIALING, 
                    STATE_CONNECTED,
                    STATE_FINISHING_DIALING,
                    STATE_FINISHING};

// Construction
public:
	CSCFollowMeDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CSCFollowMeDlg)
	enum { IDD = IDD_SCFOLLOWME_DIALOG };
	CComboBox	m_cbVoiceRes2;
	CEdit	m_eProtocol2;
	CComboBox	m_cbLineType2;
	CComboBox	m_cbLineRes2;
	CEdit	m_eProtocol;
	CComboBox	m_cbLineType;
	CComboBox	m_cbVoiceRes;
	CComboBox	m_cbLineRes;
	CListBox	m_lbMessages;
	CString	m_szFollowMeNr;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSCFollowMeDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
    void StatusMsg(LPCSTR msg,...);
    long OnVoiceMsg(WPARAM event,LPARAM lParam);


    bool OpenCall1Resources();
    bool OpenCall2Resources();

    SCBUSRES m_hLineHandle;
    SCBUSRES m_hVoiceHandle;
    SCBUSRES m_hLineHandle2;
    SCBUSRES m_hVoiceHandle2;

    MODEMOBJ m_hModemObj;
    MODEMOBJ m_hModemObj2;

    enum STATES m_n_States;

    bool bExit;

    void CloseResources();
    void EnableControls(BOOL Enabled);
    void HangUp();
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CSCFollowMeDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnSelchangeLinetype();
	afx_msg void OnStart();
	afx_msg void OnClear();
	afx_msg void OnCopy();
	afx_msg void OnHelp();
	afx_msg void OnSelchangeLinetype2();
	afx_msg void OnDestroy();
	afx_msg void OnFinish();
	afx_msg void OnStopwaiting();
	afx_msg void OnCancel();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SCFOLLOWMEDLG_H__42EC73C4_A694_11D4_B1F1_0040053DA77D__INCLUDED_)
