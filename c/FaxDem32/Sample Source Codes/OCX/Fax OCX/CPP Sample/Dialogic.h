#if !defined(AFX_DIALOGIC_H__B4BAB8C2_0FC9_4FDB_BC1B_EA0E34588452__INCLUDED_)
#define AFX_DIALOGIC_H__B4BAB8C2_0FC9_4FDB_BC1B_EA0E34588452__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// Dialogic.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CDialogic dialog

class CDialogic : public CDialog
{
// Construction
public:
	CString m_selectedChannel;
	CString m_szChannels;
	CDialogic(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CDialogic)
	enum { IDD = IDD_DIALOGIC };
	BOOL	m_bDTMF;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDialogic)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CDialogic)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DIALOGIC_H__B4BAB8C2_0FC9_4FDB_BC1B_EA0E34588452__INCLUDED_)
