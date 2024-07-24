// Voice Recording SampleDlg.h : header file
//

#if !defined(AFX_VOICERECORDINGSAMPLEDLG_H__111AF048_2097_11D3_AFC4_0040F614A5A0__INCLUDED_)
#define AFX_VOICERECORDINGSAMPLEDLG_H__111AF048_2097_11D3_AFC4_0040F614A5A0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#include "DlgMessage.h"

/////////////////////////////////////////////////////////////////////////////
// CVoiceRecordingSampleDlg dialog

class CVoiceRecordingSampleDlg : public CDialog
{
    enum {vrs_IDLE,
          vrs_PLAY,
          vrs_RECORD,
          vrs_REINIT};

// Construction
public:
	CVoiceRecordingSampleDlg(CWnd* pParent = NULL);	// standard constructor

    void    OnOpenPortProc(int event);
    void    OnIdleProc(int event);
    void    OnPlayProc(int event);
    void    OnRecordProc(int event);
    void    OnDisconnectProc(int event);
    void    OnReInitializeProc(int event);

// Dialog Data
	//{{AFX_DATA(CVoiceRecordingSampleDlg)
	enum { IDD = IDD_VOICERECORDINGSAMPLE_DIALOG };
	CListBox	m_Files;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CVoiceRecordingSampleDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
    void    UpdateFileList();
    void    SetIdle();
    void    OnExit();
    void    ReInitializePort();
    void	RecordVoice();
    void	PlayVoice();
    void    SaveOptions();
    void    EnableControls();

    MODEMOBJ    m_Modem;
	HICON       m_hIcon;
    BOOL        m_bDoExit;
    int         m_nPrStatus;
    int         m_nSubStatus;
    char        m_szVocFile[MAX_PATH];
    int         m_nCurrDevice;
    BOOL        m_bRecord;
    BOOL        m_bPlay;
    BOOL        m_bStarted;

    CDlgMessage dlgMsg;

	// Generated message map functions
	//{{AFX_MSG(CVoiceRecordingSampleDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnOpen();
	virtual void OnCancel();
    afx_msg LRESULT OnVoiceMsg(WPARAM event, LPARAM lParam);
	afx_msg void OnVoicePlay();
	afx_msg void OnVoiceCreate();
	afx_msg void OnVoiceDelete();
	afx_msg void OnVoiceStop();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_VOICERECORDINGSAMPLEDLG_H__111AF048_2097_11D3_AFC4_0040F614A5A0__INCLUDED_)
