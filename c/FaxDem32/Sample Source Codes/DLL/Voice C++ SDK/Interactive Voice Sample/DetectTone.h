#if !defined(AFX_DETECTTONE_H__4CAE5617_DF45_4E7F_90CC_2CE87ADB1072__INCLUDED_)
#define AFX_DETECTTONE_H__4CAE5617_DF45_4E7F_90CC_2CE87ADB1072__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// DetectTone.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CDetectTone dialog

class CDetectTone : public CDialog
{
// Construction
public:
	CDetectTone(CWnd* pParent = NULL);   // standard constructor

    int GetFreq1(){ return m_dFreq1; }
    int GetFreq1Dev(){ return m_dFreq1Dev; }
    int GetFreq2(){ return m_dFreq2; }
    int GetFreq2Dev(){ return m_dFreq1Dev; }
    int GetDetectionMode();
    int GetToneType(){return m_iToneType;}
    void SetToneID(int ToneID);
    // Dialog Data
	//{{AFX_DATA(CDetectTone)
	enum { IDD = IDD_CUSTOMTONE };
	CString	m_DetectionMode;
	int		m_dFreq1;
	int		m_dFreq1Dev;
	int		m_dFreq2;
	int		m_dFreq2Dev;
	int		m_iToneType;
	CString	m_szToneID;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDetectTone)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
    int m_dToneID;
	// Generated message map functions
	//{{AFX_MSG(CDetectTone)
	virtual void OnOK();
	afx_msg void OnSingleTone();
	afx_msg void OnDualTone();
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DETECTTONE_H__4CAE5617_DF45_4E7F_90CC_2CE87ADB1072__INCLUDED_)
