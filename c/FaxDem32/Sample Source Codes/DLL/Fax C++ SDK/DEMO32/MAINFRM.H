// mainfrm.h : interface of the CMainFrame class
//
/////////////////////////////////////////////////////////////////////////////

/* Windows message group */
#define REGISTERMESSAGE     "COFAX message"
#define START_PORTPRINT     0       /* Message WPARAM, when StartDoc print */
#define END_PORTPRINT       1       /* Message WPARAM, when EndDoc print */
#define START_FILEPRINT     2       /* Start one file printing */
#define END_PAGEPRINT       3       /* End page printing */
#define GET_SENDHWND        4       /* LPARAM is Global handle, */

class CImgDoc;
class CMainFrame : public CMDIFrameWnd 
{
    DECLARE_DYNAMIC(CMainFrame)
public:
    CMainFrame();
        void SelectAnno( long l );

// Attributes
public:
    HDIB    m_hScanDIB;

// Operations
public:
    CStatusBar *GetStatusBarPtr() {return &m_wndStatusBar;}

// Implementation
public:
    virtual ~CMainFrame();
#ifdef _DEBUG
    virtual void AssertValid() const;
    virtual void Dump(CDumpContext& dc) const;
#endif
    BOOL IsAnyPortOpen(BOOL bClose, BOOL bAbort);

protected:  // control bar embedded members
    virtual     LRESULT WindowProc(UINT message, WPARAM wParam, LPARAM lParam);

    CStatusBar  m_wndStatusBar;
    CToolBar    m_wndToolBar;
    UINT        m_TimerID;
        DWORD       m_dwPlatformId;

    int         RecSaveInTiffFile(FAXOBJ FaxObj);
    int         RecSaveInFaxGroup(FAXOBJ FaxObj);
    int         RecBFT(FAXOBJ FaxObj);
    void        ReadFaxQueueu();
    LRESULT     FaxMsg(WPARAM wParam, LPARAM lParam);
    CImgDoc     *GetDocument();
    LRESULT     OnWmDDEInitiate(WPARAM wParam, LPARAM lParam);

// Generated message map functions
protected:
    //{{AFX_MSG(CMainFrame)
    afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
    afx_msg void OnDestroy();
    afx_msg void OnSize(UINT nType, int cx, int cy);
    afx_msg void OnEditPaste();
    afx_msg void OnUpdateEditPaste(CCmdUI* pCmdUI);
    afx_msg void OnUpdateIndicatorImageno(CCmdUI* pCmdUI);
    afx_msg void OnUpdateIndicatorImageTotal(CCmdUI* pCmdUI);
    afx_msg void OnPaletteChanged(CWnd* pFocusWnd);
    afx_msg BOOL OnQueryNewPalette();
    afx_msg void OnFaxPortSetup();
    afx_msg void OnUpdateFaxPortSetup(CCmdUI* pCmdUI);
    afx_msg void OnUpdateFaxPortClose(CCmdUI* pCmdUI);
    afx_msg void OnFaxPortClose();
    afx_msg void OnFaxAbort();
    afx_msg void OnUpdateFaxAbort(CCmdUI* pCmdUI);
    afx_msg void OnFaxEvent();
    afx_msg void OnUpdateFaxEvent(CCmdUI* pCmdUI);
    afx_msg void OnFaxRec();
    afx_msg void OnUpdateFaxRec(CCmdUI* pCmdUI);
    afx_msg void OnFaxConfig();
    afx_msg void OnUpdateFaxConfig(CCmdUI* pCmdUI);
    afx_msg void OnPhonebookEdit();
    afx_msg void OnPhonebookImport();
    afx_msg void OnPhonebookExport();
    afx_msg void OnTimer(UINT nIDEvent);
    afx_msg void OnUpdateFaxPortBrook(CCmdUI* pCmdUI);
    afx_msg void OnUpdateFaxPortGamma(CCmdUI* pCmdUI);
    afx_msg void OnUpdateDialogic(CCmdUI* pCmdUI);
    afx_msg void OnUpdateBicom(CCmdUI* pCmdUI);
    afx_msg void OnUpdateCMTX(CCmdUI* pCmdUI);
    afx_msg void OnUpdateNms(CCmdUI* pCmdUI);
	afx_msg void OnHideFaxmanager();
	afx_msg void OnUpdateHideFaxmanager(CCmdUI* pCmdUI);
    //}}AFX_MSG
#ifdef WIN32
    afx_msg void OnFaxPortBrook();
    afx_msg void OnFaxPortGamma();
    afx_msg void OnOpenDialogic();
    afx_msg void OnOpenBicom();
    afx_msg void OnOpenCMTX();
    afx_msg void OnOpenNms();
    afx_msg void OnDebugBrook();
    afx_msg void OnUpdateDebugBrook(CCmdUI* pCmdUI);
#endif

    DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
CStatusBar *GetGlobalStatusBar ();
/////////////////////////////////////////////////////////////////////////////
