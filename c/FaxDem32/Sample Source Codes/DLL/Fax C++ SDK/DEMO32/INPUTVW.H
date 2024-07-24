    
    
class CImgDoc;    
    
// CInputView form view

class CInputView : public CFormView
{
    DECLARE_DYNCREATE(CInputView)
protected:
    CInputView();           // protected constructor used by dynamic creation
    
// Form Data
public:
    //{{AFX_DATA(CInputView)
//    enum { IDD = IDD_INPUTFORM };
    //}}AFX_DATA
    
    BOOL AddFile(CString & FileName,WORD nFileFormat);
// Attributes
public:
    CImgDoc* GetDocument();
    
// Operations
public:

// Implementation
protected:
    void    SetHorzExtent(CListBox *lBox);
    virtual ~CInputView();
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
    virtual void OnUpdate(CView* pSender, LPARAM lHint, CObject* pHint);
    void    OnInitialUpdate();
    BOOL    MakeListBoxRow(int nSel, LPSTR buf);
    void    RemoveOne(int nSel);
    BOOL    qryListbox(int &nSel, int &nSiz);
    void    UpdateButtons(int nSel, int nSiz);

    // Generated message map functions
    //{{AFX_MSG(CInputView)
    afx_msg void OnSelchangeList1();
    afx_msg void OnDblclkList1();
    afx_msg void OnRemove();
    afx_msg void OnAdd();
    afx_msg void OnBft();
    afx_msg void OnGrpsave();
    afx_msg void OnSize(UINT nType, int cx, int cy);
    afx_msg void OnShowWindow(BOOL bShow, UINT nStatus);
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
    
    int nRightMargin ;
    int nMinWidth    ;
    
};

/////////////////////////////////////////////////////////////////////////////
