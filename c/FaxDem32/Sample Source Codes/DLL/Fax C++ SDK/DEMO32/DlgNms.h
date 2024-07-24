#if !defined(AFX_DLGNMS_H__AEAE9FB2_A6A5_11D2_B155_0040053DA77D__INCLUDED_)
#define AFX_DLGNMS_H__AEAE9FB2_A6A5_11D2_B155_0040053DA77D__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// DlgNms.h : header file
//
#include "resource.h"
/////////////////////////////////////////////////////////////////////////////
// CDlgNms dialog

class CDlgNms : public CDialog
{
// Construction
public:
	void GetSelectedProtocoll(int nProtocolIndex, char * szProtocol, int maxSize);
	CDlgNms(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CDlgNms)
	enum { IDD = IDD_OPENNMSCHANNEL };
	CComboBox	m_cbProtocol;
	CSpinButtonCtrl	m_DIDSpin;
	CEdit	m_DID;
	CListCtrl	m_ChannelList;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDlgNms)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CDlgNms)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGNMS_H__AEAE9FB2_A6A5_11D2_B155_0040053DA77D__INCLUDED_)
