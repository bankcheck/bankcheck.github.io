#if !defined(AFX_OPENDIALOGIC_H__9EB5D3CC_1D0C_45A0_803D_086CC92E3C2E__INCLUDED_)
#define AFX_OPENDIALOGIC_H__9EB5D3CC_1D0C_45A0_803D_086CC92E3C2E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// OpenDialogic.h : header file
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
	enum { IDD = IDD_DCHANNEL };
		// NOTE: the ClassWizard will add data members here
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

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_OPENDIALOGIC_H__9EB5D3CC_1D0C_45A0_803D_086CC92E3C2E__INCLUDED_)
