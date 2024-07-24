// vmdmvw.h : interface of the CFaxDisplayView class
//
/////////////////////////////////////////////////////////////////////////////

class CFaxDisplayView : public CView
{
protected: // create from serialization only
    CFaxDisplayView();
    DECLARE_DYNCREATE(CFaxDisplayView)

// Attributes
public:
    CFaxDisplayDoc* GetDocument();
	void UpdateSelectionRect();

	void KillFitToWindow();
	void StartNewDib();

// Operations
public:

// Implementation
public:
    virtual ~CFaxDisplayView();
    virtual void OnDraw(CDC* pDC);  // overridden to draw this view
    void    OnActivateView(BOOL bActivate, CView* pActivateView,
                    CView* pDeactiveView);

	void AfterLoadImage();
    BOOL SetNewDib(HDIB hDib, BOOL bSaveScroll);

#ifdef _DEBUG
    virtual void AssertValid() const;
    virtual void Dump(CDumpContext& dc) const;
#endif


    // Printing support
protected:
    BOOL Create( LPCSTR lpszClassName, LPCSTR lpszWindowName, DWORD dwStyle, const RECT& rect, CWnd* 
		pParentWnd, UINT nID, CCreateContext* pContext = NULL);
		
// Generated message map functions
protected:
    //{{AFX_MSG(CFaxDisplayView)
    afx_msg void OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
    afx_msg void OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
    afx_msg void OnSize(UINT nType, int cx, int cy);
    afx_msg void OnScaleDPI();
    afx_msg void OnFitowindow();
    afx_msg void OnCenterimage();
    afx_msg void OnUpdateCenterimage(CCmdUI* pCmdUI);
    afx_msg void OnUpdateFitowindow(CCmdUI* pCmdUI);
    afx_msg void OnUpdateScaleDPI(CCmdUI* pCmdUI);
    afx_msg void OnSetFocus(CWnd* pOldWnd);
    afx_msg void OnKillFocus(CWnd* pNewWnd);
    afx_msg LRESULT OnDoRealize(WPARAM wParam, LPARAM lParam);
    afx_msg void OnPaint();
    afx_msg void OnDispNormal();
    afx_msg void OnUpdateDispNormal(CCmdUI* pCmdUI);
	afx_msg int  OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnDestroy();
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
    // Private variables
private:
    void        EnableView(CCmdUI* pCmdUI);
//    void        Zoom(RECT *rScale, BOOL nMode);
    void        SetNewTitle();    
    void        SetNewScreenPos();
    
    BOOL		m_bDownM;
	RECT 		mScale ;
	POINT 		ptLast ;
	BOOL		m_bMapping;	//IZ!!!
	POINT		mapPtLast;
};

#ifndef _DEBUG  // debug version in vmdmvw.cpp
inline CFaxDisplayDoc* CFaxDisplayView::GetDocument()
   { return (CFaxDisplayDoc*) m_pDocument; }
#endif

/////////////////////////////////////////////////////////////////////////////

BOOL CopyDibDPI(HDIB hDibOut, HDIB hDibInp);

class CScrollConvert {
public:
    double X_DCPerBitmap;    
    double Y_DCPerBitmap;    
    POINT pSizeBitmap;
    POINT pScrollRange;
    void OrigoToScroll(HWND hWnd, LPPOINT pOrigoBMP, LPRECT lprScroll);
};     


#define DC_TO_BMP(pp, fact)    (int)( (double)pp / fact + 0.5)
#define BMP_TO_DC(pp, fact)    (int)( (double)pp * fact + 0.5)

