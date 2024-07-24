#if !defined(AFX_DLGMESSAGE_H__111AF050_2097_11D3_AFC4_0040F614A5A0__INCLUDED_)
#define AFX_DLGMESSAGE_H__111AF050_2097_11D3_AFC4_0040F614A5A0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// DlgMessage.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CDlgMessage dialog

class CDlgMessage : public CDialog
{
// Construction
public:
	CDlgMessage(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CDlgMessage)
	enum { IDD = IDD_MESSAGE };
	CStatic	m_edMsg;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDlgMessage)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CDlgMessage)
		// NOTE: the ClassWizard will add member functions here
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGMESSAGE_H__111AF050_2097_11D3_AFC4_0040F614A5A0__INCLUDED_)
