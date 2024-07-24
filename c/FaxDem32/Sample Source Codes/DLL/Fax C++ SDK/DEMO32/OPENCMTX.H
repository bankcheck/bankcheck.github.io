#if !defined(AFX_OPENCMTX_H__B6CB6892_29C8_11D2_B023_0040053DA77D__INCLUDED_)
#define AFX_OPENCMTX_H__B6CB6892_29C8_11D2_B023_0040053DA77D__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// Opencmtx.h : header file
//
#include "resource.h"
/////////////////////////////////////////////////////////////////////////////
// COpencmtx dialog

class COpencmtx : public CDialog
{
// Construction
public:
	COpencmtx(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(COpencmtx)
	enum { IDD = IDD_CMTXCHANNEL };
	CListCtrl	m_ChannelList;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(COpencmtx)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(COpencmtx)
	virtual void OnOK();
	virtual void OnCancel();
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_OPENCMTX_H__B6CB6892_29C8_11D2_B023_0040053DA77D__INCLUDED_)
