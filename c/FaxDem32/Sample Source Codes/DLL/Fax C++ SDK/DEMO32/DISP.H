

typedef HANDLE HDIB;

class CDisp : public CView
{          

protected: // create from serialization only
	CDisp();
    DECLARE_DYNCREATE(CDisp)
	
public:    
	WORD d_GetDisplayMode();
	void d_SetWidth(DWORD dwWidth);
	void d_SetHeight(DWORD dwHeight);
	DWORD m_dwWidth;
	DWORD m_dwHeight;
	~CDisp();
	
    DISPLAYSTRUCT   sDisplay;       // Display structure for paint, scroll and
    
    HDIB			d_hDib;			// Actual DIB
    WORD            wDisplayMode;   // Detemines the display mode of the image.
    RECT            rScale;         // Rectangle for scaling the image on paint.
    
/*			MAGNIFY				*/
    BOOL			m_bDownM;
	RECT 			mScale;
	POINT 			ptLast;
    CMagnifyWnd 	MagnifyWnd ;
    BOOL 			b_MagnifyWnd;


/*			ZOOM				*/

    ZOOMSTRUCT 		m_zm;        
    BOOL        	m_zoom_select;
    
	void d_DispCreate();
	void d_DispDestroy();
	
	void d_DispStart(BOOL bNewDib, BOOL bNewOrigin);
	void d_DispDIBImageDC(CDC *pDC);
	
	void d_ClearDib(BOOL bDeleteDib);
	BOOL d_SetNewDib(HDIB hDibPar);
	void d_SetNewSize(UINT nType, int cx, int cy);
	void d_SetNewPalette(BOOL bBack);
	void d_SetNewPalette(CWnd *wnd, BOOL bBack);
	void d_SetNewMode(UINT wMode);
	void d_UpdateDispMode(UINT wMode, CCmdUI* pCmdUI);
	void d_KillFitToWindowMode();
	
	void d_HorzScroll(UINT nSBCode, UINT nPos);
	void d_VertScroll(UINT nSBCode, UINT nPos);
	
	void d_StepZoom(ZOOMFLAG zoomflg) ;
	void d_UpdateStepZoom(CCmdUI* pCmdUI);
	void d_DispZoom();
	void d_GetZoomData();
	void d_StartZoom(UINT nFlags, CPoint &point, BOOL bLarge);
	void d_MoveZoom(CPoint &point);
	void d_StopZoom(CPoint &point);
	
	void d_SetMagnifyGlass();
	void d_StartMagnify(UINT nFlags, CPoint &point);
	void d_MoveMagnify(UINT nFlags, CPoint &point);
	void d_StopMagnify(CPoint &point);
	void d_ToggleMagnifyWnd();
	
	void d_SetNewTitle();

    HBITMAP d_GetBitmap( void ) { return( sDisplay.hBitmap ); };
    LPDISPLAYSTRUCT d_GetDisplay( void ) { return( &sDisplay ); };

protected:	    
	virtual void OnDraw(CDC* pDC);
};
