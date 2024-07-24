#if !defined(AFX_NMSOPEN_H__712E9B62_D30D_11D2_B1AA_0040053DA77D__INCLUDED_)
#define AFX_NMSOPEN_H__712E9B62_D30D_11D2_B1AA_0040053DA77D__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// NMSOpen.h : header file
//
#include <afxcmn.h>

/////////////////////////////////////////////////////////////////////////////
// CNMSOpen dialog

class CNMSOpen : public CDialog
{
// Construction
public:
	CNMSOpen(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CNMSOpen)
	enum { IDD = IDD_NMS_OPEN };
	CComboBox	m_cbProtocol;
	CEdit	m_DID;
	CSpinButtonCtrl	m_DIDSpin;
	CListCtrl	m_ChList;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CNMSOpen)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
	//}}AFX_VIRTUAL

// Implementation
protected:
    void    DestroyModemObject();
    void    EnableControls(BOOL bEnable);
	void	GetSelectedProtocoll(int nProtocolIndex, char * szProtocol, int maxSize);
	void	OnOK1(NMHDR* param1, LRESULT* param2);		//because VC 7.0

    BOOL    m_bWaitCursor;

	UINT        nMessage;

	// Generated message map functions
	//{{AFX_MSG(CNMSOpen)
	virtual void OnOK();
	virtual BOOL OnInitDialog();
	afx_msg BOOL OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_NMSOPEN_H__712E9B62_D30D_11D2_B1AA_0040053DA77D__INCLUDED_)
