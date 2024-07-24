#if !defined(AFX_NMSOPEN_H__94F157A5_458F_4B4A_BA8A_4971DE57E1EE__INCLUDED_)
#define AFX_NMSOPEN_H__94F157A5_458F_4B4A_BA8A_4971DE57E1EE__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// NMSOpen.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CNMSOpen dialog

class CNMSOpen : public CDialog
{
// Construction
public:
	void GetSelectedProtocoll(int nProtocolIndex, char * szProtocol, int maxSize);
	long didDigits;
	CString szProtocol;
	CString m_selectedChannel;
	CString m_szChannels;
	CNMSOpen(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CNMSOpen)
	enum { IDD = IDD_NMS };
	CSpinButtonCtrl	m_SpinDID;
	CComboBox	m_cbProtocol;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CNMSOpen)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CNMSOpen)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	afx_msg void OnDoubleclickedOk();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_NMSOPEN_H__94F157A5_458F_4B4A_BA8A_4971DE57E1EE__INCLUDED_)
