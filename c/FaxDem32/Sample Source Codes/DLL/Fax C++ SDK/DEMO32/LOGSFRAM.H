// logsfram.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CLogStatus form view

#ifndef __AFXEXT_H__
#include <afxext.h>
#endif

class CLogStatus;

/////////////////////////////////////////////////////////////////////////////
// CLogsFrame frame

class CLogsFrame : public CMDIChildWnd
{
    DECLARE_DYNCREATE(CLogsFrame)
protected:
    CLogsFrame();           // protected constructor used by dynamic creation

// Attributes
public:
    CSplitterWnd   m_wndSplitter;
    CLogStatus     *m_lpStatus;

// Operations
public:

// Implementation
protected:
    virtual ~CLogsFrame();
    virtual BOOL OnCreateClient(LPCREATESTRUCT lpcs, CCreateContext* pContext);

    // Generated message map functions
    //{{AFX_MSG(CLogsFrame)
    afx_msg void OnClose();
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};

class CLogStatus : public CFormView
{
    DECLARE_DYNCREATE(CLogStatus)
protected:
    CLogStatus();           // protected constructor used by dynamic creation

// Form Data
public:
    //{{AFX_DATA(CLogStatus)
    enum { IDD = IDD_STATUS };
        // NOTE: the ClassWizard will add data members here
    //}}AFX_DATA

// Attributes
public:
    void    WriteStatus( TSViewFaxBlock *vfb );
    void    ClearStatus();
    void    WriteDir( CString &szDir );

// Operations
public:

// Implementation
protected:
    virtual ~CLogStatus();
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
    // Generated message map functions
    //{{AFX_MSG(CLogStatus)
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};

