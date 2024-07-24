#if !defined(AFX_DIALOGICOPEN_H__4FA659E3_1E05_11D3_AFB6_0040F614A5A0__INCLUDED_)
#define AFX_DIALOGICOPEN_H__4FA659E3_1E05_11D3_AFB6_0040F614A5A0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// DialogicOpen.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CDialogicOpen dialog

class CDialogicOpen : public CDialog
{

// Construction
public:
	CDialogicOpen(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CDialogicOpen)
	enum { IDD = IDD_DIALOGIC_OPEN };
	CComboBox	m_cbLineType;
	CListCtrl	m_ChannelList;
	CString	m_szProtocol;
	BOOL	m_bPAMD;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDialogicOpen)
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
	//{{AFX_MSG(CDialogicOpen)
	virtual void OnOK();
	virtual BOOL OnInitDialog();
	afx_msg void OnSelchangeLinetype();
	afx_msg void OnDblclkList1(NMHDR* pNMHDR, LRESULT* pResult);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DIALOGICOPEN_H__4FA659E3_1E05_11D3_AFB6_0040F614A5A0__INCLUDED_)
