// dialogs.h : header file
//

#include "lwlbox.h"

/////////////////////////////////////////////////////////////////////////////
// CDlg dialog

class CDlg : public CDialog
{
// Construction
public:
    CDlg (UINT idd, CWnd *parent) : CDialog (idd, parent) {pDoc=NULL;};
    virtual BOOL OnInitDialog();
    CImgDoc *pDoc;
};

/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
// CDimension dialog


class CDimension : public CDlg
{
// Construction
public:
    CDimension(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
    //{{AFX_DATA(CDimension)
    enum { IDD = IDD_DIMENSIONS };
        // NOTE: the ClassWizard will add data members here
    //}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
    virtual BOOL OnInitDialog(void);
    
    // Generated message map functions
    //{{AFX_MSG(CDimension)
        // NOTE: the ClassWizard will add member functions here
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////
// CDlgRotate dialog

class CDlgRotate : public CDlg
{
// Construction
public:
    CDlgRotate(CWnd* pParent = NULL);   // standard constructor
    int nDegree;
    int nMethod;
        
// Dialog Data
    //{{AFX_DATA(CDlgRotate)
    enum { IDD = IDD_ROTATING };
        // NOTE: the ClassWizard will add data members here
    //}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CDlgRotate)
    virtual BOOL OnInitDialog();
    virtual void OnOK();
	afx_msg void OnChangeDegree();
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CDlgScale dialog

class CDlgScale : public CDlg
{
// Construction
public:
    CDlgScale(CWnd* pParent = NULL);    // standard constructor
    WORD    wWidth;
    WORD    wHeight;
    int     nMethod;
    
// Dialog Data
    //{{AFX_DATA(CDlgScale)
    enum { IDD = IDD_SCALING };
        // NOTE: the ClassWizard will add data members here
    //}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CDlgScale)
    virtual BOOL OnInitDialog();
    virtual void OnOK();
	afx_msg void OnChangeXAxis();
	afx_msg void OnChangeYAxis();
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CDlgSkew dialog

class CDlgSkew : public CDlg
{
// Construction
public:
    CDlgSkew(CWnd* pParent = NULL); // standard constructor
    int     nIncrement;
    BOOL    bDirection;
    
// Dialog Data
    //{{AFX_DATA(CDlgSkew)
    enum { IDD = IDD_SKEWING };
        // NOTE: the ClassWizard will add data members here
    //}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CDlgSkew)
    virtual BOOL OnInitDialog();
    virtual void OnOK();
	afx_msg void OnChangeDistance();
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CDlgColorToGray dialog

class CDlgColorToGray : public CDlg
{
// Construction
public:
    CDlgColorToGray(CWnd* pParent = NULL);  // standard constructor
    int     nMethod;                        // method of conversion
    BOOL    bPsychovisual;                  // enables psycological method

// Dialog Data
    //{{AFX_DATA(CDlgColorToGray)
    enum { IDD = IDD_COLOR2GRAY };
        // NOTE: the ClassWizard will add data members here
    //}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CDlgColorToGray)
    virtual BOOL OnInitDialog();
    virtual void OnOK();
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////
// CCustomZoom dialog

class CCustomZoom : public CDlg
{
// Construction
public:
    CCustomZoom(CWnd* pParent = NULL);  // standard constructor

// Dialog Data
    //{{AFX_DATA(CCustomZoom)
    enum { IDD = IDD_CUSTOM_ZOOM };
    int     m_edit1;
    int     m_edit2;
    //}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CCustomZoom)
    virtual BOOL OnInitDialog();
	afx_msg void OnChangeEdit1();
	afx_msg void OnChangeEdit2();
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CZoomStep dialog

class CZoomStep : public CDlg
{
// Construction
public:
    CZoomStep(CWnd* pParent = NULL);    // standard constructor

// Dialog Data
    //{{AFX_DATA(CZoomStep)
    enum { IDD = IDD_ZOOM_STEP };
        // NOTE: the ClassWizard will add data members here
    //}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CZoomStep)
    virtual BOOL OnInitDialog();
    virtual void OnOK();
    afx_msg void OnChangeBase();
	afx_msg void OnChangeEStepnum();
	afx_msg void OnChangeRStepnum();
	afx_msg void OnChangeE10();
	afx_msg void OnChangeE9();
	afx_msg void OnChangeE8();
	afx_msg void OnChangeE7();
	afx_msg void OnChangeE6();
	afx_msg void OnChangeE5();
	afx_msg void OnChangeE4();
	afx_msg void OnChangeE3();
	afx_msg void OnChangeE2();
	afx_msg void OnChangeR2();
	afx_msg void OnChangeR3();
	afx_msg void OnChangeR4();
	afx_msg void OnChangeR5();
	afx_msg void OnChangeR6();
	afx_msg void OnChangeR7();
	afx_msg void OnChangeR8();
	afx_msg void OnChangeR9();
	afx_msg void OnChangeR10();
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CMySave dialog

class CMySave : public CFileDialog
{
// Construction
public:
    void OnLBSelChangedNotify(UINT nIDBox, UINT iCurSel, UINT nCode);

    CMySave(BOOL flg);  
    int m_dlg_jpeg_qu;

// Dialog Data
    //{{AFX_DATA(CMySave)
    enum { IDD = IDD_MYSAVE };
        // NOTE: the ClassWizard will add data members here
    //}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CMySave)
    virtual BOOL OnInitDialog();
    afx_msg void On1();
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CHalftoneDlg dialog

class CHalftoneDlg : public CDlg
{
// Construction
public:
	CHalftoneDlg(CWnd* pParent = NULL);	// standard constructor
	
	int m_Methode;
	int m_Intensity;

// Dialog Data
	//{{AFX_DATA(CHalftoneDlg)
	enum { IDD = IDD_HALFTONE };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

// Implementation
protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support

	// Generated message map functions
	//{{AFX_MSG(CHalftoneDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnKillfocusEdit1();
	afx_msg void OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
	afx_msg void OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
	virtual void OnCancel();
	virtual void OnOK();
	afx_msg void OnChangeEdit1();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};
