#if !defined(AFX_CINPDLG_H__A716C771_3EF4_11D1_87AA_0040F614A5A0__INCLUDED_)
#define AFX_CINPDLG_H__A716C771_3EF4_11D1_87AA_0040F614A5A0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// cInpDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// cInputDialog dialog

class cInputDialog : public CDialog
{
// Construction
public:
	cInputDialog(CWnd* pParent = NULL);   // standard constructor

	void	SetFields(const char *pdialog, const char *pstatic, char *pedit, int editlen);
// Dialog Data
	//{{AFX_DATA(cInputDialog)
	enum { IDD = IDD_INPUT };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(cInputDialog)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation

protected:
	const char	*pszDialog;
	const char	*pszStatic;
	char		*pszEdit;
	int			nEditLen;
	
	// Generated message map functions
	//{{AFX_MSG(cInputDialog)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CINPDLG_H__A716C771_3EF4_11D1_87AA_0040F614A5A0__INCLUDED_)
