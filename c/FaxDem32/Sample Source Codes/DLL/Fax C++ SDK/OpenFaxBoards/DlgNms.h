#if !defined(AFX_DLGNMS_H__2819871F_01F9_4089_9967_AA35357EA244__INCLUDED_)
#define AFX_DLGNMS_H__2819871F_01F9_4089_9967_AA35357EA244__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// DlgNms.h : header file
//

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
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGNMS_H__2819871F_01F9_4089_9967_AA35357EA244__INCLUDED_)
