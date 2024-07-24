// ReceiveDTMFandDecideToReceiveFaxOrVoiceDlg.h : header file
//

#if !defined(AFX_RECEIVEDTMFANDDECIDETORECEIVEFAXORVOICEDLG_H__3C0FDCD2_C4F7_4537_B641_12691BB55113__INCLUDED_)
#define AFX_RECEIVEDTMFANDDECIDETORECEIVEFAXORVOICEDLG_H__3C0FDCD2_C4F7_4537_B641_12691BB55113__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg dialog

class CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg : public CDialog
{

	enum {
		 ivs_IDLE,
		 ivs_ANSWER,
         ivs_HANGUP,
         ivs_RECORD,
         ivs_RECEIVEFAX,
         ivs_RECDTMF
	};

    enum{rec_SWITCH,
         rec_CONNECT,
         rec_RECEIVING,
         rec_RETURN
    };

// Construction
public:
	CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg(CWnd* pParent = NULL);	// standard constructor

    void    OnIdleProc(int event,long lParam);
    void    OnAnswerProc(int event,long lParam);
    void    OnHangUpProc(int event,long lParam);
    void    OnRecordProc(int event,long lParam);
    void    OnReceiveFaxProc(int event,long lParam);
    void    OnReceiveDTMFProc(int event,long lParam);

// Dialog Data
	//{{AFX_DATA(CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg)
	enum { IDD = IDD_RECEIVEDTMFANDDECIDETORECEIVEFAXORVOICE_DIALOG };
	CButton	m_hangUp;
	CListBox	m_lbStatus;
	CButton	m_NMS;
	CButton	m_DIALOGIC;
	CButton	m_BROOK;
	CButton	m_COMM;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
    void    SetIdleProc();
    long    OnVoiceMsg(WPARAM event,LPARAM lParam);
    void    EnableControls(BOOL bEnabled1, BOOL bEnabled2);
    BOOL    CheckStatus();
	void	OnExit();

    MODEMOBJ    m_Modem;
    PORTFAX     m_pPortFax;
    int         m_nPrStatus;
    BOOL        m_bTransfer;
    BOOL        m_bDoExit;
    int         m_nSubStatus;
    BOOL        bAutoScroll;
    CString     m_szMessage;

    void    OnFaxReceived(FAXOBJ faxObj);        
    void    OnReceiveSwitch(int event);
    void    OnReceiveConnect(int event);
    void    OnReceivingFax(int event);
    void    OnReturn2Voice(int event);
    void    Return2Voice();
    void    StatusMsg(LPCSTR msg,...);

	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CReceiveDTMFandDecideToReceiveFaxOrVoiceDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnDestroy();
	afx_msg void OnClose();
	afx_msg void OnComm();
	afx_msg void OnBrook();
	afx_msg void OnDialogic();
	afx_msg void OnNms();
	afx_msg void OnAnswer();
	afx_msg void OnStop();
	afx_msg void OnReceivefax();
	afx_msg void OnRecDtmf();
	afx_msg void OnClearlistbox();
	virtual void OnCancel();
	afx_msg void OnRecmsg();
	afx_msg void OnCloseport();
	afx_msg void OnChelp();
	afx_msg void OnHangupButton();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_RECEIVEDTMFANDDECIDETORECEIVEFAXORVOICEDLG_H__3C0FDCD2_C4F7_4537_B641_12691BB55113__INCLUDED_)
