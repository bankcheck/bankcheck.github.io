// vmdmdoc.h : interface of the CFaxDisplayDoc class
//
/////////////////////////////////////////////////////////////////////////////
extern "C"
{
    #include    "cals.h"
	#include "bidisp.h"
	#include "bidib.h"
}

BOOL WINAPI CreateDIBPalette(HDIB hDIB, CPalette* pPal);

class CFaxDisplayDoc : public CDocument
{
protected: // create from serialization only
    CFaxDisplayDoc();
    DECLARE_DYNCREATE(CFaxDisplayDoc)

// Attributes
public:
// Operations
public:
    ZOOMSCREEN      m_zc;
    UINT            wDisplayMode;   // Detemines the display mode of the image.
    RECT            rScale;         // Rectangle for scaling the image on paint.
    DISPLAYSTRUCT   sDisplay;       // Display structure for paint, scroll and

    HDIB            hDib;           // Handle to a device independent bitmap for
                                    // storing the image.
                                    // resize.
    BOOL            m_bMono;        // the image was originally monochrome
    UINT            nImages;        // Number of images in the Tiff file.
    UINT            nCurrent;       // The current image.   
    DWORD           dwWidth;        // Horizontal size of the image.
    DWORD           dwHeight;       // Vertical size of the image.
    UINT            wHorizontalDPI; // Resolution of image in horizontal direction.
    UINT            wVerticalDPI;   // Resolution of image in vertical direction.
    UINT            wPlanes;        // Number of planes in the image.
    UINT            wBits;          // Number of bits of a pixel in the image.
    char            szTiffFileName[256];    // Name of the TIFF file.
    
    long            lOffset;        // File offset for CCITT and MMR images.
    int             nFillOrder;     // Bit fill order for CCITT and MMR images.
    UINT            wByteOrder;     // Byte order for CCITT and MMR images.
    UINT            wScreenMode;    // View mode for decompress to screen.
    NOTESTRUCT      sNote;          // Note structure for TIFF images.
    BOOL            bChanged;       // Image changed flag.
    DWORD           dwCompression;  // Compression type of the TIFF image.
    DWORD           dwPredictor;    // Extended compresson mode of the TIFF image.
    CPalette        *m_hPalette;    // Palette of the DIB.
    int             m_jpeg_qu;
// Implementation
public:
    virtual ~CFaxDisplayDoc();
    virtual void Serialize(CArchive& ar);   // overridden for document i/o
    virtual BOOL OnOpenDocument(const char *pszPathName);
	virtual void UpdatePalette(void );
    virtual void OnCloseDocument();
			BOOL GetInfoFromDIB();
#ifdef _DEBUG
    virtual void AssertValid() const;
    virtual void Dump(CDumpContext& dc) const;
#endif
protected:

// Generated message map functions
protected:
    //{{AFX_MSG(CFaxDisplayDoc)
    afx_msg void OnPageForward();
    afx_msg void OnUpdatePageForward(CCmdUI* pCmdUI);
    afx_msg void OnPageBackwad();
    afx_msg void OnUpdatePageBackwad(CCmdUI* pCmdUI);
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
private:
    void    PrintTiffError(void);
    void    LoadTIFFImage(UINT nImage);
    void    LoadCALSImage(HWND hWnd);
    void    LoadImage(const char *pszPathName, UINT nImage);
	void	SetNewDib(HANDLE hDibPar);
	CView*	qryImgView();
	void	InvalidateRect( LPRECT lpr, BOOL b );

	BOOL	bFontSelected;
};

/////////////////////////////////////////////////////////////////////////////

extern int e_nFileFormat;           /* NGY */
extern LPSTR AllFilterBuff;         /* NGY */
extern LPSTR FormFilterBuff;        /* NGY */   
