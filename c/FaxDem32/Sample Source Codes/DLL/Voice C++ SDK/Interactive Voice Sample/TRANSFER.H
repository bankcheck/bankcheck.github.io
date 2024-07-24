#if !defined(AFX_TRANSFER_H__0BF50FC1_3765_11D2_9B98_444553540000__INCLUDED_)
#define AFX_TRANSFER_H__0BF50FC1_3765_11D2_9B98_444553540000__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// Transfer.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CTransferDlg dialog

class CTransferDlg : public CDialog
{
// Construction
public:
	CTransferDlg(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CTransferDlg)
	enum { IDD = IDD_TRANSFER };
	CEdit	m_edNumber;
	//}}AFX_DATA


	static char	szNumber[128];

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CTransferDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CTransferDlg)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_TRANSFER_H__0BF50FC1_3765_11D2_9B98_444553540000__INCLUDED_)
