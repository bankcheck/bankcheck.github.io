#if !defined(AFX_FAXCONFIG_H__C8460B17_33A1_4955_912D_2D06B04E5E33__INCLUDED_)
#define AFX_FAXCONFIG_H__C8460B17_33A1_4955_912D_2D06B04E5E33__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// FaxConfig.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CFaxConfig dialog

class CFaxConfig : public CDialog
{
// Construction
public:
	CFaxConfig(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CFaxConfig)
	enum { IDD = IDD_FAXCONFIG };
	int		m_speakerVolume;
	int		m_speakerMode;
	BOOL	m_Ecm;
	BOOL	m_BFT;
	int		m_BaudRate;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFaxConfig)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CFaxConfig)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FAXCONFIG_H__C8460B17_33A1_4955_912D_2D06B04E5E33__INCLUDED_)
