// logsview.h : header file
//
/////////////////////////////////////////////////////////////////////////////
// TSFaxBlock

/////////////////////////////////////////////////////////////////////////////
// CLogsView view

class CLogsView : public CView
{
    DECLARE_DYNCREATE(CLogsView)
protected:
    CLogsView();            // protected constructor used by dynamic creation

// Attributes
public:

// Operations
public:            
    BOOL    AddNewLine(TSViewFaxBlock *FaxBlock);
    //int     GetCurrentLine(); // return ID
    BOOL    DeleteLine( int ID );
    BOOL    DeleteAllLine();
    int     GetNotUsedID();
    int     GetItemCount();
    int     GetFName(int ID, LPSTR szName);
    // Printing...
    void    NewPage( CDC *pPrintDC, CRect *rcPage, int PageNum, int cyChar );
    void    WriteState();
    void    ClearState();

// Implementation
protected:
    virtual ~CLogsView();
    virtual void OnDraw(CDC* pDC);      // overridden to draw this view
    LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);
    void    DoingDelKey();
    void    DrawButton( LPSTR chTitle, LPDRAWITEMSTRUCT lpDrawItemStruct, CDC &DC );

    // Generated message map functions
protected:
    //{{AFX_MSG(CLogsView)
    afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
    afx_msg void OnDestroy();
    afx_msg void OnSize(UINT nType, int cx, int cy);
    afx_msg void OnDrawItem(int nIDCtl, LPDRAWITEMSTRUCT lpDrawItemStruct);
    afx_msg void OnMeasureItem(int nIDCtl, LPMEASUREITEMSTRUCT lpMeasureItemStruct);
    afx_msg int OnCompareItem(int nIDCtl, LPCOMPAREITEMSTRUCT lpCompareItemStruct);
    afx_msg void OnDeleteItem(int nIDCtl, LPDELETEITEMSTRUCT lpDeleteItemStruct);
    afx_msg void OnSortDate();
    afx_msg void OnSortTime();
    afx_msg void OnSortName();
    afx_msg void OnSortPage();
    afx_msg void OnSortNumber();
    afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
    afx_msg int  OnVKeyToItem(UINT nKey, CListBox *pListBox, UINT nIndex);
    afx_msg void OnSetFocus(CWnd *);
    afx_msg void OnUpdateFilePrint(CCmdUI* pCmdUI);
    afx_msg void OnFilePrint();
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()

    CListBox *ListBox;
    CBitmapButton  *btEmpty; 
    CBitmapButton  *btDate;
    CBitmapButton  *btTime;
    CBitmapButton  *btName;
    CBitmapButton  *btNumber;
    CBitmapButton  *btPage;

    int     iSortType;
    int     PageNumber;
    int     PrintActLine;
    CString strHeader;

    CFont   *m_fontOld;
    CFont   *m_fontPrint;
    UINT    m_nPreviewPage;

    void    ChangeSort(int Type);
};

/////////////////////////////////////////////////////////////////////////////
