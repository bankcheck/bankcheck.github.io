#if !defined(AFX_BROOKOPEN_H__4FA659E0_1E05_11D3_AFB6_0040F614A5A0__INCLUDED_)
#define AFX_BROOKOPEN_H__4FA659E0_1E05_11D3_AFB6_0040F614A5A0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// BrookOpen.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CBrookOpen dialog

class CBrookOpen : public CDialog
{
// Construction
public:
	CBrookOpen(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CBrookOpen)
	enum { IDD = IDD_BROOK_OPEN };
	CEdit	m_edConfig;
	CStatic	m_edTest;
	CListBox	m_lbChannels;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CBrookOpen)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:
    void    DestroyModemObject();
    void    EnableControls(BOOL bEnable);

    BOOL        m_bWaitCursor;

	UINT        nMessage;

	// Generated message map functions
	//{{AFX_MSG(CBrookOpen)
	afx_msg void OnTest();
	virtual void OnOK();
	virtual BOOL OnInitDialog();
	afx_msg BOOL OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_BROOKOPEN_H__4FA659E0_1E05_11D3_AFB6_0040F614A5A0__INCLUDED_)
