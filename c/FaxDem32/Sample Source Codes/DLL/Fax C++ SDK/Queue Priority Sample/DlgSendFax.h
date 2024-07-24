#if !defined(AFX_DLGSENDFAX_H__4B48A530_29F7_436E_8D5D_369B531E3F7E__INCLUDED_)
#define AFX_DLGSENDFAX_H__4B48A530_29F7_436E_8D5D_369B531E3F7E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// DlgSendFax.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CDlgSendFax dialog

class CDlgSendFax : public CDialog
{
// Construction
public:
	CDlgSendFax(CWnd* pParent = NULL);   // standard constructor
	
// Dialog Data
	//{{AFX_DATA(CDlgSendFax)
	enum { IDD = IDD_SENDFAX };
	CString	m_phonenum;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDlgSendFax)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	PORTFAX m_faxport;      // portfax
	int     iPort;          // port number for debug output          
	int     m_nSendMode;    // IDC_SENDQUEUE, IDC_SENDIMMEDIATE, IDC_SEND_MANUAL
	BOOL    TestDate();

	int pagesToSend; //to check if there is any page to send


	// Generated message map functions
	//{{AFX_MSG(CDlgSendFax)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	afx_msg void OnBrowse();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGSENDFAX_H__4B48A530_29F7_436E_8D5D_369B531E3F7E__INCLUDED_)
