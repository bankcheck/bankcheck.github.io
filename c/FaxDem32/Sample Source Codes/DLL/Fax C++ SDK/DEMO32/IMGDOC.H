// imgdoc.h : interface of the CImgDoc class
//
/////////////////////////////////////////////////////////////////////////////
#define HINT_NEWGROUP   10

#define STAT_MONO       1
#define STAT_DITH       2
#define STAT_BFT        3

class CImgView;

class CImgDoc : public CDocument 
{
protected: // create from serialization only
    CImgDoc();
    DECLARE_DYNCREATE(CImgDoc)

// Attributes
public:
    CImgDoc(LPCSTR FileName);	
    void    UpdatePalette( void );
    void    PrintImgError(void);
    BOOL    IsAnyPortOpen();
    void    SetActiveDoc();
    
    void    SetLineType( long l );
    void    InvalidateRect( LPRECT lpr, BOOL b );
    void    SetColor( long l );

// Operations
public:
    WORD            nImages;        // Number of images in the Tiff file.
    WORD            nCurrent;       // The current image.   
    char            szTiffFileName[256];    // Name of the TIFF file.
    int             m_nFileFormat;

    int             m_jpeg_qu;      



    DWORD           dwWidth;        // Horizontal size of the image.
    DWORD           dwHeight;       // Vertical size of the image.
    WORD            wHorizontalDPI; // Resolution of image in horizontal direction.
    WORD            wVerticalDPI;   // Resolution of image in vertical direction.
    WORD            wPlanes;        // Number of planes in the image.
    WORD            wBits;          // Number of bits of a pixel in the image.
    WORD            wDepth;         // wPlanes * wBits.

    BOOL            bChanged;       // Image changed flag.

    HANDLE          m_hDib;
    HANDLE          m_hDibPages[10];
    CPalette        *m_palDib;      // Palette of the device independent bitmap.    

    void            SetNewDib(HANDLE hDibPar);
    void            ClearDib();
    CImgView        *qryImgView();
    HWND            qryImgHwnd();

    BOOL            m_bGroup;       // group file        
    CString         GroupFileName;  // group file name
    CStringArray    arName;         // file name in group files 
    CWordArray      arStat;         // mono, color, bft 
    CWordArray      arType;         // TIFF, BMP
    int             nGroupCurrent;    
    
    void            ClearGroupInfo();

    
// Implementation
public:
    virtual ~CImgDoc();
    virtual void Serialize(CArchive& ar);   // overridden for document i/o
    virtual BOOL OnOpenDocument(const char *pszPathName);
    virtual void OnCloseDocument();
	 virtual void GoPage(int PageNr); //rz
#ifdef _DEBUG
    virtual void AssertValid() const;
    virtual void Dump(CDumpContext& dc) const;
#endif
    void    LoadImage(const char *pszPathName, WORD nImage);
    
    int     GetBitsPerPixel(LPSTR lpFileName);
    BOOL    LoadFaxGroup(const char *grpfile);
    BOOL    SaveFaxGroup(const char *grpfile);

protected:
    virtual BOOL    OnNewDocument();
    virtual BOOL    SaveModified();

    void _loadds OnCloseTWdoc();
    void _loadds OnDone(HANDLE hDib,LPCSTR lpFileName);

private:
    
    void    SaveImage(const char *pszPathName, int nFileFormat);
    void    UpdateCapAndStatus(void);
    void    FillTabs( char tabstr[128], LPFAXTOASCII lpbuff );
    
    BOOL    bFontSelected;  // user has to specify default font when using NOTE object 
                            // at first time

// Generated message map functions
protected:
    //{{AFX_MSG(CImgDoc)
    afx_msg void OnDimensions();
    afx_msg void OnPageForward();
    afx_msg void OnUpdatePageForward(CCmdUI* pCmdUI);
    afx_msg void OnPageBackwad();
    afx_msg void OnUpdatePageBackwad(CCmdUI* pCmdUI);
    afx_msg void OnEditCopy();
    afx_msg void OnEditPaste();
    afx_msg void OnUpdateEditCopy(CCmdUI* pCmdUI);
    afx_msg void OnUpdateEditPaste(CCmdUI* pCmdUI);
    afx_msg void OnEditDelete();
    afx_msg void OnUpdateEditDelete(CCmdUI* pCmdUI);
    afx_msg void OnFileSave();
    afx_msg void OnFileSaveAs();
    afx_msg void OnUpdateFileSave(CCmdUI* pCmdUI);
    afx_msg void OnUpdateFileSaveAs(CCmdUI* pCmdUI);
    afx_msg void OnFaxSend();
    afx_msg void OnUpdateFaxSend(CCmdUI* pCmdUI);
    afx_msg void OnFilePrint();
    afx_msg void OnUpdateFilePrint(CCmdUI* pCmdUI);
    afx_msg void OnFitowindow();
    afx_msg void OnCenterimage();
    afx_msg void OnZoomIn();
    afx_msg void OnZoomOut();
    afx_msg void OnRotate90();
    afx_msg void OnRotate270();
    afx_msg void OnRotate180();
    afx_msg void OnFlipHorizontal();
    afx_msg void OnFlipVertical();
    afx_msg void OnViewInvert();
    afx_msg void OnViewRotate();
    afx_msg void OnViewSkew();
    afx_msg void OnViewScale();
    afx_msg void OnViewColorToGray();
    afx_msg void OnImageConvTo24();
    afx_msg void OnShowDpi();
    afx_msg void OnZoomMode();
    afx_msg void OnCustomZoom();
    afx_msg void OnZoomSteps();
    afx_msg void OnDestroy();
    afx_msg void OnHalftone();
    afx_msg void OnMagnify();
    afx_msg void OnUpdateCenterimage(CCmdUI* pCmdUI);
    afx_msg void OnUpdateFitowindow(CCmdUI* pCmdUI);
    afx_msg void OnUpdateZoomIn(CCmdUI* pCmdUI);
    afx_msg void OnUpdateZoomOut(CCmdUI* pCmdUI);
    afx_msg void OnUpdateRotate90(CCmdUI* pCmdUI);
    afx_msg void OnUpdateRotate270(CCmdUI* pCmdUI);
    afx_msg void OnUpdateRotate180(CCmdUI* pCmdUI);
    afx_msg void OnUpdateFlipHorizontal(CCmdUI* pCmdUI);
    afx_msg void OnUpdateFlipVertical(CCmdUI* pCmdUI);
    afx_msg void OnUpdateViewInvert(CCmdUI* pCmdUI);
    afx_msg void OnUpdateViewRotate(CCmdUI* pCmdUI);
    afx_msg void OnUpdateViewSkew(CCmdUI* pCmdUI);
    afx_msg void OnUpdateViewScale(CCmdUI* pCmdUI);
    afx_msg void OnUpdateViewColorToGray(CCmdUI* pCmdUI);
    afx_msg void OnUpdateImageConvTo24(CCmdUI* pCmdUI);
    afx_msg void OnUpdateShowDpi(CCmdUI* pCmdUI);
    afx_msg void OnRButtonDown(UINT nFlags, CPoint point);
    afx_msg void OnRButtonUp(UINT nFlags, CPoint point);
    afx_msg void OnUpdateZoomMode(CCmdUI* pCmdUI);
    afx_msg void OnUpdateHalftone(CCmdUI* pCmdUI);
    afx_msg void OnUpdateMagnify(CCmdUI* pCmdUI);
    afx_msg void OnUpdateAcquire(CCmdUI* pCmdUI);
    afx_msg void OnUpdateSelectsource(CCmdUI* pCmdUI);
    afx_msg void OnSelectsource();
    afx_msg void OnAcquire();
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////
    
extern int e_nFileFormat;    
    
    
