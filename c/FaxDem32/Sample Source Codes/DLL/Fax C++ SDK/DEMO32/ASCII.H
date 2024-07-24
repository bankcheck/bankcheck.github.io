// ascii.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CAscii dialog

class CAscii : public CDialog
{
// Construction
public:
	CAscii(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CAscii)
	enum { IDD = IDD_ASCII2DIB };
	UINT	m_Height;
	UINT	m_LineSpace;
	CString	m_szTabs;
	UINT	m_Width;
	UINT	m_xDPI;
	UINT	m_xMargin;
	UINT	m_yDPI;
	UINT	m_yMargin;
	//}}AFX_DATA
	LOGFONT	m_lf;
	UINT	m_Measure;
	CHOOSEFONT m_cf;

// Implementation
protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support

	// Generated message map functions
	//{{AFX_MSG(CAscii)
	afx_msg void OnFontsel();
	afx_msg void OnMeter();
	afx_msg void OnInch();
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	afx_msg void OnFinefaxpage();
	afx_msg void OnStandardfaxpage();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};
