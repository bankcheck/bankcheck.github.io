// magnifyw.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CMagnifyWnd window

class CMagnifyWnd : public CWnd
{
// Construction
public:
	CMagnifyWnd();
	
// Attributes
public:

// Operations
public:
	void SetBitmap(HBITMAP hBitmap,HPALETTE hPal);
	void SetBitmapCenter(int X,int Y);
	void SetScale(LPRECT lpScale);
	
// Implementation
public:
	virtual ~CMagnifyWnd();

protected:
	// Generated message map functions
	//{{AFX_MSG(CMagnifyWnd)
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnDestroy();
	afx_msg void OnPaint();
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnMouseMove(UINT nFlags, CPoint point);
	afx_msg void OnLButtonUp(UINT nFlags, CPoint point);
	afx_msg void OnLButtonDblClk(UINT nFlags, CPoint point);
	
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()   
	
	DISPLAYSTRUCT sDisplay ;
	int   xCenter;
	int   yCenter;	
	
	CPoint  ptPrev ;
	BOOL    bDown  ;
	
};

/////////////////////////////////////////////////////////////////////////////
