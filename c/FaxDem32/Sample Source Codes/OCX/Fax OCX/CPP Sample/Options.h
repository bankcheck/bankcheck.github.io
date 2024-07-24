// Options.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// Options dialog

class Options : public CDialog
{
// Construction
public:
	Options(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(Options)
	enum { IDD = IDD_DIALOG1 };
	CString	m_phonenumber;
	CString	m_szFileName;
	//}}AFX_DATA
	int m_queue,m_nocomp;
	CString m_sendPort;
	BOOL fileFocus;

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(Options)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
    CStringList m_PortList;

	// Generated message map functions
	//{{AFX_MSG(Options)
	afx_msg void OnBrowse();
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	void AddComPortsToListBox( CString szPorts, CString szPre );
	void AddLinesToListBox( CString szPorts, CString szPre );
	DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CBrooktrout dialog

class CBrooktrout : public CDialog
{
// Construction
public:
	CBrooktrout(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CBrooktrout)
	enum { IDD = IDD_BROOKTROUT };
	CString	m_config;
	BOOL	m_bDTMF;
	BOOL	m_brHeader;
	CString	m_brLocalID;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CBrooktrout)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

	public:
    CString m_channels, m_szChannel;
// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CBrooktrout)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	afx_msg void OnBrowse();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CGamma dialog

class CGamma : public CDialog
{
// Construction
public:
	CGamma(CWnd* pParent = NULL);   // standard constructor

    CString m_channels, m_szChannel;

// Dialog Data
	//{{AFX_DATA(CGamma)
	enum { IDD = IDD_GAMMALINK };
	CString	m_config;
	long	m_rings;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CGamma)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CGamma)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

};
/////////////////////////////////////////////////////////////////////////////
// CCommPort dialog

class CCommPort : public CDialog
{
// Construction
public:
	CCommPort(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CCommPort)
	enum { IDD = IDD_INITCOMM };
	int		m_rings;
	BOOL	m_bHeader;
	CString	m_commports;
	CString	m_szLocalID;
	BOOL	m_bDebugEnbl;
	//}}AFX_DATA
	short m_FaxListIndex;
	CString m_ActPort;

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCommPort)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CCommPort)
	virtual BOOL OnInitDialog();
	afx_msg void OnTest();
	virtual void OnOK();
	afx_msg void OnDialtone();
	afx_msg void OnSelchangeFaxlist();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CPortClose dialog

class CPortClose : public CDialog
{
// Construction
public:
	CPortClose(CWnd* pParent = NULL);   // standard constructor
    CString m_szPorts, m_szBChannels, m_szGChannels;

// Dialog Data
	//{{AFX_DATA(CPortClose)
	enum { IDD = IDD_CLOSEPORT };
	CString	m_szPort;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPortClose)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
    void AddLines( CString szPorts, CString szPre );
	void AddComLines( CString szPorts, CString szPre );
	// Generated message map functions
	//{{AFX_MSG(CPortClose)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};
