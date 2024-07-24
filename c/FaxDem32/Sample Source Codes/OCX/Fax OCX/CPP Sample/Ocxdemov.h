// OCXDEMOView.h : interface of the COCXDEMOView class
//
/////////////////////////////////////////////////////////////////////////////
#include "fax.h"
class COCXDEMOView : public CView
{
protected: // create from serialization only
	COCXDEMOView();
	DECLARE_DYNCREATE(COCXDEMOView)

// Attributes
public:
	COCXDEMODoc* GetDocument();
	CFAX	m_fax;
	LPSTR   BrooktroutChannels;
	BOOL    m_DebugBrook;
// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(COCXDEMOView)
	public:
	virtual void OnDraw(CDC* pDC);  // overridden to draw this view
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~COCXDEMOView();
	CString GetError(int errorCode);
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:
    LPSTR MakeTerminationText( long TCode );

    // Generated message map functions
protected:
	//{{AFX_MSG(COCXDEMOView)
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnSend();
	afx_msg void OnClose();
	afx_msg void OnInitBrook();
	afx_msg void OnUpdateInitBrook(CCmdUI* pCmdUI);
	afx_msg void OnInitComm();
	afx_msg void OnUpdateInitComm(CCmdUI* pCmdUI);
	afx_msg void OnInitGamma();
	afx_msg void OnUpdateInitGamma(CCmdUI* pCmdUI);
	afx_msg void OnDestroy();
	afx_msg void OnAnswer(LPCTSTR Port);
	afx_msg void OnStartSend(LPCTSTR PortName);
	afx_msg void OnEndSend(LPCTSTR PortName, long FaxID, LPCTSTR RemoteID);
	afx_msg void OnEndReceive(LPCTSTR PortName, long FaxID, LPCTSTR RemoteID);
	afx_msg void OnTerminate(LPCTSTR lpPort, long lStatus, short sPageNo, long ConnectTime, LPCTSTR szDID, LPCTSTR szDTMF);
	afx_msg void OnStartPage(LPCTSTR szPort, long lPageNumber);
	afx_msg void OnEndPage(LPCTSTR szPort, long lPageNumber);
	afx_msg void OnInitNmschannel();
	afx_msg void OnUpdateInitNmschannel(CCmdUI* pCmdUI);
	afx_msg void OnInitDialogicchannel();
	afx_msg void OnUpdateInitDialogicchannel(CCmdUI* pCmdUI);
	afx_msg void OnUpdateSend(CCmdUI* pCmdUI);
	afx_msg void OnUpdateClose(CCmdUI* pCmdUI);
	afx_msg void OnFaxConfig();
	afx_msg void OnFaxShowfaxmanager();
	afx_msg void OnUpdateFaxShowfaxmanager(CCmdUI* pCmdUI);
	afx_msg void OnUpdateBrookDebug(CCmdUI* pCmdUI);
	afx_msg void OnBrookDebug();
	DECLARE_EVENTSINK_MAP()
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

    CString m_szComPorts, m_szBChannels, m_szGChannels, m_szNMSChannels, m_szDialogicChannels;
	CString ActualFaxPort;
	int SpeakerMode,SpeakerVolume,BaudRate;
	BOOL Ecm,Bft,Debug,displayFaxManager;
    long    m_Objs[10];
    long    m_ObjNum;
};

#ifndef _DEBUG  // debug version in OCXDEMOView.cpp
inline COCXDEMODoc* COCXDEMOView::GetDocument()
   { return (COCXDEMODoc*)m_pDocument; }
#endif

/////////////////////////////////////////////////////////////////////////////
