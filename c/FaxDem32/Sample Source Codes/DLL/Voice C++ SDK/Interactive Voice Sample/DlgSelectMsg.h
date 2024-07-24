#if !defined(AFX_DLGSELECTMSG_H__68D654E2_1FD4_11D3_AFC1_0040F614A5A0__INCLUDED_)
#define AFX_DLGSELECTMSG_H__68D654E2_1FD4_11D3_AFC1_0040F614A5A0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// DlgSelectMsg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CDlgSelectMsg dialog

class CDlgSelectMsg : public CDialog
{
// Construction
public:
	CDlgSelectMsg(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CDlgSelectMsg)
	enum { IDD = IDD_SELECT_MSG };
	CListBox	m_lbFiles;
	//}}AFX_DATA

    CString m_szMessage;
    MODEMOBJ    m_Modem;
// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDlgSelectMsg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL
    
// Implementation
protected:
    
	// Generated message map functions
	//{{AFX_MSG(CDlgSelectMsg)
	afx_msg void OnSelect();
	virtual BOOL OnInitDialog();
	afx_msg void OnDblclkSendFiles();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGSELECTMSG_H__68D654E2_1FD4_11D3_AFC1_0040F614A5A0__INCLUDED_)
