#if !defined(AFX_CANSCFG_H__2F5AA901_3F08_11D1_87AA_0040F614A5A0__INCLUDED_)
#define AFX_CANSCFG_H__2F5AA901_3F08_11D1_87AA_0040F614A5A0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// cAnsCfg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// cAnswerConfig dialog

class cAnswerConfig : public CDialog
{
// Construction
public:
	cAnswerConfig(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(cAnswerConfig)
	enum { IDD = IDD_ANSWER_CONFIG };
	CEdit	m_edGreeting;
	CString	m_szGreeting;
	int		m_nRecTime;
	int		m_nRings;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(cAnswerConfig)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(cAnswerConfig)
	virtual BOOL OnInitDialog();
	afx_msg void OnBrowse();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CANSCFG_H__2F5AA901_3F08_11D1_87AA_0040F614A5A0__INCLUDED_)
