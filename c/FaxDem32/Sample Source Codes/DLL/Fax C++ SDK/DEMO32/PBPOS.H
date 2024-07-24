#if !defined(AFX_PBPOS_H__DA8066A1_8371_11D1_A015_0040F6A40C27__INCLUDED_)
#define AFX_PBPOS_H__DA8066A1_8371_11D1_A015_0040F6A40C27__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// PBPos.h : header file
//

#define MAX_FIELD	1000			// it must be larger than 998
#define	MAX_WORD	61


/////////////////////////////////////////////////////////////////////////////
// CPBPos dialog

class CPBPos : public CDialog
{
// Construction
public:
	CPBPos(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CPBPos)
	enum { IDD = IDD_PBPOSITION };
	CString	m_company;
	CString	m_name;
	CString	m_tel;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPBPos)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
public:
	BOOL bCustom;
	BOOL bItemsInListbox;

	int	 empty_records;
	int	 truncated_fields;
	int	 missing_fields;

	int  c_field;
	char fields[MAX_FIELD][MAX_WORD];

	BOOL LoadRecords(LPSTR buf);

protected:
	BOOL TestPositionNumber(CEdit *lpBoxNumber, int *conv_buf);

	// Generated message map functions
	//{{AFX_MSG(CPBPos)
	virtual BOOL OnInitDialog();
	afx_msg void OnCustom();
	afx_msg void OnDefault();
	virtual void OnOK();
	afx_msg void OnCheck1();
	afx_msg void OnSelchangeList1();
	afx_msg void OnButton1();
	afx_msg void OnButton2();
	afx_msg void OnButton3();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PBPOS_H__DA8066A1_8371_11D1_A015_0040F6A40C27__INCLUDED_)
