#if !defined(AFX_VOICEFORMATS_H__F888F439_7101_43FD_BE08_4A138E32B86D__INCLUDED_)
#define AFX_VOICEFORMATS_H__F888F439_7101_43FD_BE08_4A138E32B86D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// VoiceFormats.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// VoiceFormats dialog

class CVoiceFormats : public CDialog
{
// Construction
public:
	CVoiceFormats(CWnd* pParent = NULL);   // standard constructor
	void SetText(LPCSTR szText) { m_szVoiceFormats = szText;}
// Dialog Data
	//{{AFX_DATA(CVoiceFormats)
	enum { IDD = IDD_VOICE_FORMATS };
	CString	m_szVoiceFormats;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CVoiceFormats)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CVoiceFormats)
		// NOTE: the ClassWizard will add member functions here
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_VOICEFORMATS_H__F888F439_7101_43FD_BE08_4A138E32B86D__INCLUDED_)
