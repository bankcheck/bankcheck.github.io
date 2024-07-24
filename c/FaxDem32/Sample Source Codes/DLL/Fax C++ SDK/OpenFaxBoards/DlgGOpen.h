#if !defined(AFX_DLGGOPEN_H__87557A00_0856_4AE1_8D20_D0206974DA3D__INCLUDED_)
#define AFX_DLGGOPEN_H__87557A00_0856_4AE1_8D20_D0206974DA3D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// DlgGOpen.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CDlgGOpen dialog

class CDlgGOpen : public CDialog
{
// Construction
public:
	CDlgGOpen(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CDlgGOpen)
	enum { IDD = IDD_OPENGCHANNEL };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDlgGOpen)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CDlgGOpen)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGGOPEN_H__87557A00_0856_4AE1_8D20_D0206974DA3D__INCLUDED_)
