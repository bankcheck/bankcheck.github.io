// SCSendFaxDlg.h : header file
//

#if !defined(AFX_SCSENDFAXDLG_H__42EC73C4_A694_11D4_B1F1_0040053DA77D__INCLUDED_)
#define AFX_SCSENDFAXDLG_H__42EC73C4_A694_11D4_B1F1_0040053DA77D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CSCSendFaxDlg dialog

class CSCSendFaxDlg : public CDialog
{
    enum STATES{    STATE_STARTING, 
                    STATE_OPENINGPORTS, 
                    STATE_DIALING, 
                    STATE_SWITCHING_TO_FAX_MODE, 
                    STATE_STARTSENDINGFAX, STATE_SENDINGFAX, 
                    STATE_RETURNTOVOICEMODE, 
                    STATE_FINISHING};

// Construction
public:
	CSCSendFaxDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CSCSendFaxDlg)
	enum { IDD = IDD_SCSENDFAX_DIALOG };
	CEdit	m_eFaxNr;
	CEdit	m_eTiffFile;
	CEdit	m_eProtocol;
	CComboBox	m_cbLineType;
	CComboBox	m_cbVoiceRes;
	CComboBox	m_cbFaxRes;
	CComboBox	m_cbLineRes;
	CListBox	m_lbMessages;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSCSendFaxDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
    void StatusMsg(LPCSTR msg,...);
    long OnVoiceMsg(WPARAM event,LPARAM lParam);


    SCBUSRES m_hLineHandle;
    SCBUSRES m_hVoiceHandle;
    SCBUSRES m_hFaxHandle;

    CString  m_szTiffFile;
    CString  m_szFaxNr;

    MODEMOBJ m_hModemObj;

    enum STATES m_n_States;
    FAXOBJ   m_FaxObj;
    PORTFAX  m_pPortFax;

    void Return2VoiceMode();
    void Hangup();
    void CloseResources();
    bool CreateFaxObject();
    void DestroyFaxObject();
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CSCSendFaxDlg)
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

#endif // !defined(AFX_SCSENDFAXDLG_H__42EC73C4_A694_11D4_B1F1_0040053DA77D__INCLUDED_)
