
/////////////////////////////////////////////////////////////////////////////
// CSearchBox window

class CSearchBox : public CComboBox
{
// Construction
public:
	CSearchBox();

// Attributes
public:
	int c_value;

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CSearchBox)
	public:
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CSearchBox();

	// Generated message map functions
protected:
	//{{AFX_MSG(CSearchBox)
		// NOTE - the ClassWizard will add and remove member functions here.
	//}}AFX_MSG

	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////
