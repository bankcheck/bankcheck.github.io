#if !defined(AFX_DLGC_H__79B20A41_2EA0_11D1_8258_0040F6982C20__INCLUDED_)
#define AFX_DLGC_H__79B20A41_2EA0_11D1_8258_0040F6982C20__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// Dlgc.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// COpenDialogic dialog

class COpenDialogic : public CDialog
{
// Construction
public:
	COpenDialogic(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(COpenDialogic)
	enum { IDD = IDD_OPENDCHANNEL };
	CListCtrl	m_ChannelList;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(COpenDialogic)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(COpenDialogic)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////
//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGC_H__79B20A41_2EA0_11D1_8258_0040F6982C20__INCLUDED_)
