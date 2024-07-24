// MainFrm.h : interface of the CMainFrame class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_MAINFRM_H__D4F3B00A_1CB1_11D3_AFB3_0040F614A5A0__INCLUDED_)
#define AFX_MAINFRM_H__D4F3B00A_1CB1_11D3_AFB3_0040F614A5A0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

class CMainFrame : public CMDIFrameWnd
{
	DECLARE_DYNAMIC(CMainFrame)
public:
	CMainFrame();

// Attributes
public:
    CStatusBar *GetStatusBarPtr() {return &m_wndStatusBar;}

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMainFrame)
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CMainFrame();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

    long    OnVoiceMsg(WPARAM event,LPARAM lParam);

protected:  // control bar embedded members
    void    CreateNewDoc();

	CStatusBar  m_wndStatusBar;
	CToolBar    m_wndToolBar;

// Generated message map functions
protected:
	//{{AFX_MSG(CMainFrame)
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnDestroy();
	afx_msg void OnUpdatePortOpen(CCmdUI* pCmdUI);
	afx_msg void OnVoicefaxOpenportComport();
	afx_msg void OnVoicefaxOpenportBrooktroutchannel();
	afx_msg void OnViewReceivedfaxes();
	afx_msg void OnVoicefaxOpenportDialogicchannel();
	afx_msg void OnVoicefaxOpenportNms();
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnMove(int x, int y);
	afx_msg void OnAnswerphoneConfig();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MAINFRM_H__D4F3B00A_1CB1_11D3_AFB3_0040F614A5A0__INCLUDED_)
