// imgvw.h : interface of the CImgView class
//
/////////////////////////////////////////////////////////////////////////////

class CImgView : public CDisp
{
protected: // create from serialization only
    DECLARE_DYNCREATE(CImgView)
    CImgView();

public:
    CImgDoc* GetDocument();

public:
    virtual ~CImgView();
    virtual void OnDraw(CDC* pDC);  // overridden to draw this view
    void    OnActivateView(BOOL bActivate, CView* pActivateView, CView* pDeactiveView);
                    
#ifdef _DEBUG
    virtual void AssertValid() const;
    virtual void Dump(CDumpContext& dc) const;
#endif

    // Printing support
protected:
    virtual BOOL OnPreparePrinting(CPrintInfo* pInfo);
    virtual void OnBeginPrinting(CDC* pDC, CPrintInfo* pInfo);
    virtual void OnEndPrinting(CDC* pDC, CPrintInfo* pInfo);
    
    BOOL Create( LPCSTR lpszClassName, LPCSTR lpszWindowName, DWORD dwStyle, const RECT& rect, CWnd* 
		pParentWnd, UINT nID, CCreateContext* pContext = NULL);
    

    // Private variables
private:
    void        EnableView(CCmdUI* pCmdUI);
        
    BOOL        bNoHourGlass;       // Enables or disables change cursor while image
    
// Generated message map functions
protected:
    //{{AFX_MSG(CImgView)
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnDestroy();
	
    afx_msg void OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
    afx_msg void OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
    afx_msg void OnSize(UINT nType, int cx, int cy);
    afx_msg void OnFitowindow();
    afx_msg void OnCenterimage();
    afx_msg void OnUpdateCenterimage(CCmdUI* pCmdUI);
    afx_msg void OnUpdateFitowindow(CCmdUI* pCmdUI);
    afx_msg void OnZoomIn();
    afx_msg void OnUpdateZoomIn(CCmdUI* pCmdUI);
    afx_msg void OnZoomOut();
    afx_msg void OnUpdateZoomOut(CCmdUI* pCmdUI);
    afx_msg void OnRotate90();
    afx_msg void OnUpdateRotate90(CCmdUI* pCmdUI);
    afx_msg void OnRotate270();
    afx_msg void OnUpdateRotate270(CCmdUI* pCmdUI);
    afx_msg void OnRotate180();
    afx_msg void OnUpdateRotate180(CCmdUI* pCmdUI);
    afx_msg void OnFlipHorizontal();
    afx_msg void OnUpdateFlipHorizontal(CCmdUI* pCmdUI);
    afx_msg void OnFlipVertical();
    afx_msg void OnUpdateFlipVertical(CCmdUI* pCmdUI);
    afx_msg void OnFilePrint();
    afx_msg void OnUpdateFilePrint(CCmdUI* pCmdUI);
    afx_msg void OnSetFocus(CWnd* pOldWnd);
    afx_msg void OnKillFocus(CWnd* pNewWnd);
    afx_msg void OnViewInvert();
    afx_msg void OnUpdateViewInvert(CCmdUI* pCmdUI);
    afx_msg LRESULT OnDoRealize(WPARAM wParam, LPARAM lParam);
    afx_msg void OnViewRotate();
    afx_msg void OnUpdateViewRotate(CCmdUI* pCmdUI);
    afx_msg void OnViewSkew();
    afx_msg void OnUpdateViewSkew(CCmdUI* pCmdUI);
    afx_msg void OnViewScale();
    afx_msg void OnUpdateViewScale(CCmdUI* pCmdUI);
    afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
    afx_msg void OnLButtonUp(UINT nFlags, CPoint point);
    afx_msg void OnMouseMove(UINT nFlags, CPoint point);
    afx_msg void OnViewColorToGray();
    afx_msg void OnUpdateViewColorToGray(CCmdUI* pCmdUI);
    afx_msg void OnImageConvTo24();
    afx_msg void OnUpdateImageConvTo24(CCmdUI* pCmdUI);
    afx_msg void OnLowmem();
    afx_msg void OnUpdateLowmem(CCmdUI* pCmdUI);
    afx_msg void OnShowDpi();
    afx_msg void OnUpdateShowDpi(CCmdUI* pCmdUI);
    afx_msg void OnShowPix();
    afx_msg void OnUpdateShowPix(CCmdUI* pCmdUI);
    afx_msg void OnZoomMode();
    afx_msg void OnCustomZoom();
    afx_msg void OnZoomSteps();
	afx_msg void OnRButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnRButtonUp(UINT nFlags, CPoint point);
	afx_msg void OnUpdateZoomMode(CCmdUI* pCmdUI);
	afx_msg void OnHalftone();
	afx_msg void OnUpdateHalftone(CCmdUI* pCmdUI);
	afx_msg void OnMagnify();
	afx_msg void OnUpdateMagnify(CCmdUI* pCmdUI);
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};

#ifndef _DEBUG  // debug version in imgvw.cpp
inline CImgDoc* CImgView::GetDocument()
   { return (CImgDoc*) m_pDocument; }
#endif

