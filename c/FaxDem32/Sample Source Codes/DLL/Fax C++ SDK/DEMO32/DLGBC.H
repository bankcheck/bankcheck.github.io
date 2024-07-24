#if !defined(AFX_DLGBC_H__4D7FDE91_6F1C_11D1_9ACE_0040053B1FE1__INCLUDED_)
#define AFX_DLGBC_H__4D7FDE91_6F1C_11D1_9ACE_0040053B1FE1__INCLUDED_
#include "resource.h"

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// DlgBc.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// COpenBicom dialog

class COpenBicom : public CDialog
{
// Construction
public:
	COpenBicom(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(COpenBicom)
	enum { IDD = IDD_OPENBCCHANNEL };
	CListCtrl	m_ChannelList;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(COpenBicom)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(COpenBicom)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGBC_H__4D7FDE91_6F1C_11D1_9ACE_0040053B1FE1__INCLUDED_)
