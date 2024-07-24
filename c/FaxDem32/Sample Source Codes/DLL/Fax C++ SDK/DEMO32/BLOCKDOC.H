// blockdoc.h : hedader file
//

/////////////////////////////////////////////////////////////////////////////
// CBlockDoc document

class CBlockDoc : public CImgDoc
{
    DECLARE_SERIAL(CBlockDoc)
protected:
    CBlockDoc();            // protected constructor used by dynamic creation
// Attributes
public:
    BOOL    bPrintAndExit ;
    FAXOBJ  m_faxobj;
    int     m_LogType ;
    int     m_BlockID ;
    int     m_nBlockCurrent;
	CString m_tmpName;
    
// Operations
public:
   void    LoadFaxBlock(int Type,int ID, HFILE hBlockFile);
   virtual BOOL PrintAndExit();
   BOOL OnOpenDocument(const char *pszPathName);
	virtual void GoPage(int PageNr); //rz
// Implementation
protected:
    virtual ~CBlockDoc();
    virtual void Serialize(CArchive& ar);   // overridden for document i/o
    virtual BOOL OnNewDocument();
    
    // Generated message map functions
protected:
    //{{AFX_MSG(CBlockDoc)
    afx_msg void OnFileSave();
    afx_msg void OnUpdateFileSave(CCmdUI* pCmdUI);
    afx_msg void OnPageBackwad();
    afx_msg void OnUpdatePagebackwad(CCmdUI* pCmdUI);
    afx_msg void OnPageForward();
    afx_msg void OnUpdatePageforward(CCmdUI* pCmdUI);
    afx_msg void OnFileSaveAs();
    afx_msg void OnUpdateFileSaveAs(CCmdUI* pCmdUI);
	afx_msg void OnUpdateFaxSend(CCmdUI* pCmdUI);
    afx_msg void OnFilePrint();
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////
// CBlockFrame frame

class CBlockFrame : public CMDIChildWnd
{
    DECLARE_DYNCREATE(CBlockFrame)
protected:
    CBlockFrame();          // protected constructor used by dynamic creation

// Attributes
public:

// Operations
public:

// Implementation
protected:
    virtual ~CBlockFrame();

    // Generated message map functions
    //{{AFX_MSG(CBlockFrame)
        // NOTE - the ClassWizard will add and remove member functions here.
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////
