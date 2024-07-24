// Interactive Voice SampleDlg.h : header file
//

#if !defined(AFX_INTERACTIVEVOICESAMPLEDLG_H__965DF3C8_1F3E_11D3_AFC0_0040F614A5A0__INCLUDED_)
#define AFX_INTERACTIVEVOICESAMPLEDLG_H__965DF3C8_1F3E_11D3_AFC0_0040F614A5A0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#define WM_MYTIMER    WM_USER+1
/////////////////////////////////////////////////////////////////////////////
// CInteractiveVoiceSampleDlg dialog
class CInteractiveVoiceSampleDlg : public CDialog
{
    enum {ivs_OPENPORT,
          ivs_IDLE,
          ivs_DIAL,
          ivs_ANSWER,
          ivs_HANGUP,
          ivs_PICKUP,
          ivs_PLAY,
          ivs_RECORD,
          ivs_SENDFAX,
          ivs_RECEIVEFAX,
          ivs_SENDDTMF,
          ivs_RECDTMF,
          ivs_TRANSFER,
          ivs_GENTONE};

    enum{rec_SWITCH,
         rec_CONNECT,
         rec_RECEIVING,
         rec_RETURN
    };

    enum{snd_SWITCH,
         snd_CONNECT,
         snd_SENDING,
         snd_RETURN
    };

// Construction
public:
	CInteractiveVoiceSampleDlg(CWnd* pParent = NULL);	// standard constructor
    ~CInteractiveVoiceSampleDlg();

    void    OnOpenPortProc(int event,long lParam);
    void    OnIdleProc(int event,long lParam);
    void    OnDialProc(int event,long lParam);
    void    OnAnswerProc(int event,long lParam);
    void    OnHangUpProc(int event,long lParam);
    void    OnPickUpProc(int event,long lParam);
    void    OnPlayProc(int event,long lParam);
    void    OnRecordProc(int event,long lParam);
    void    OnSendFaxProc(int event,long lParam);
    void    OnReceiveFaxProc(int event,long lParam);
    void    OnSendDTMFProc(int event,long lParam);
    void    OnReceiveDTMFProc(int event,long lParam);
    void    OnTransferProc(int event,long lParam);
    void    OnGenerateToneProc(int event,long lParam);

// Dialog Data
	//{{AFX_DATA(CInteractiveVoiceSampleDlg)
	enum { IDD = IDD_INTERACTIVEVOICESAMPLE_DIALOG };
	CButton	m_DIALOGIC;
	CButton	m_BROOK;
	CButton	m_COMM;
	CButton	m_NMS;
	CEdit	m_edNumber;
	CListBox	m_lbStatus;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CInteractiveVoiceSampleDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
    void    SetIdleProc();
    long    OnVoiceMsg(WPARAM event,LPARAM lParam);
    void    EnableControls(BOOL bEnabled1, BOOL bEnabled2);
    BOOL    CheckStatus();
    void    OnExit();

    void    OnSendSwitch(int event);
    void    OnSendConnect(int event);
    void    OnSendingFax(int event);
        
    void    OnReceiveSwitch(int event);
    void    OnReceiveConnect(int event);
    void    OnReceivingFax(int event);
    void    OnReturn2Voice(int event);
    void    OnFaxReceived(FAXOBJ faxObj);
    void    Return2Voice();

    void    StatusMsg(LPCSTR msg,...);

	HICON m_hIcon;
    MODEMOBJ    m_Modem;
    FAXOBJ      m_FaxObj;
    PORTFAX     m_pPortFax;
    int         m_nPrStatus;
    int         m_nSubStatus;
    CString     m_szMessage;
    BOOL        m_bRecFax;
    BOOL        m_bDoExit;
    BOOL        m_bTransfer;

    CBitmap     m_bmpComm;
    CBitmap     m_bmpBrook;
    CBitmap     m_bmpDialogic;
    CBitmap     m_bmpNMS;

    BOOL        bAutoScroll;
	BOOL		bBlindTranser;

    int         LastCustomTone;
	// Generated message map functions
	//{{AFX_MSG(CInteractiveVoiceSampleDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnDestroy();
	afx_msg void OnClose();
	afx_msg void OnDial();
	afx_msg void OnGenTone();
	afx_msg void OnHangup();
	afx_msg void OnPlaymsg();
	afx_msg void OnRecDtmf();
	afx_msg void OnReceivefax();
	afx_msg void OnRecmsg();
	afx_msg void OnSendDtmf();
	afx_msg void OnSendfax();
	afx_msg void OnStop();
	afx_msg void OnTransfer();
	afx_msg void OnChelp();
	afx_msg void OnAnswer();
	virtual void OnCancel();
	afx_msg void OnComm();
	afx_msg void OnBrook();
	afx_msg void OnDialogic();
	afx_msg void OnNms();
    afx_msg BOOL OnToolTips(UINT id,NMHDR * pTTTStruct,LRESULT * pResult);
	afx_msg void OnAutoscroll();
	afx_msg void OnClearlistbox();
	afx_msg void OnCopyclipboard();
	afx_msg void OnBlindTransfer();
	afx_msg void OnDetecttone();
	afx_msg void OnCloseport();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_INTERACTIVEVOICESAMPLEDLG_H__965DF3C8_1F3E_11D3_AFC0_0040F614A5A0__INCLUDED_)
