
class CSplitterFrame : public CMDIChildWnd
{
	DECLARE_DYNCREATE(CSplitterFrame)
protected:
	CSplitterFrame();   // protected constructor used by dynamic creation

// Attributes
protected:
	CSplitterWnd m_wndSplitter;

// Implementation
public:
	virtual ~CSplitterFrame();
	virtual BOOL OnCreateClient(LPCREATESTRUCT lpcs, CCreateContext* pContext);

	// Generated message map functions
	//{{AFX_MSG(CSplitterFrame)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

