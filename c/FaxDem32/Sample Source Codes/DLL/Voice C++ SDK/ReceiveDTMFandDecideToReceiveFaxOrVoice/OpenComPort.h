#if !defined(AFX_OPENCOMPORT_H__267F4271_1CB6_11D3_AFB3_0040F614A5A0__INCLUDED_)
#define AFX_OPENCOMPORT_H__267F4271_1CB6_11D3_AFB3_0040F614A5A0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// OpenComPort.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// COpenComPort dialog

class COpenComPort : public CDialog
{
// Construction
public:
	COpenComPort(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(COpenComPort)
	enum { IDD = IDD_OPEN_PORT };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

//    void    OnVoiceMsg(MODEMOBJ Modem,int event);

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(COpenComPort)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:
    void    DestroyModemObject();
    void    EnableControls(BOOL bEnable);

	UINT        nMessage;

    int         m_nProgressStatus;
    BOOL        m_bWaitCursor;
    BOOL        m_bOpenPort;
    BOOL        m_bTesting;

    BOOL        m_bAutoDetect;
    int         m_nActType;
	TSVoiceTestResult	stTestResult;
	// Generated message map functions
	//{{AFX_MSG(COpenComPort)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	afx_msg BOOL OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message);
	afx_msg void OnTestModem();
	afx_msg void OnVoiceFormats();
	virtual void OnCancel();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_OPENCOMPORT_H__267F4271_1CB6_11D3_AFB3_0040F614A5A0__INCLUDED_)
