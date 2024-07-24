// Voice Mail SampleView.h : interface of the CVoiceMailSampleView class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_VOICEMAILSAMPLEVIEW_H__D4F3B010_1CB1_11D3_AFB3_0040F614A5A0__INCLUDED_)
#define AFX_VOICEMAILSAMPLEVIEW_H__D4F3B010_1CB1_11D3_AFB3_0040F614A5A0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

class CVoiceMailSampleView : public CView
{
protected: // create from serialization only
	CVoiceMailSampleView();
	DECLARE_DYNCREATE(CVoiceMailSampleView)

// Attributes
public:
	CVoiceMailSampleDoc* GetDocument();

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CVoiceMailSampleView)
	public:
	virtual void OnDraw(CDC* pDC);  // overridden to draw this view
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
	protected:
	virtual void OnUpdate(CView* pSender, LPARAM lHint, CObject* pHint);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CVoiceMailSampleView();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:
    CListCtrl   m_ModemEvent;

// Generated message map functions
protected:
	//{{AFX_MSG(CVoiceMailSampleView)
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnSize(UINT nType, int cx, int cy);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

#ifndef _DEBUG  // debug version in Voice Mail SampleView.cpp
inline CVoiceMailSampleDoc* CVoiceMailSampleView::GetDocument()
   { return (CVoiceMailSampleDoc*)m_pDocument; }
#endif

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_VOICEMAILSAMPLEVIEW_H__D4F3B010_1CB1_11D3_AFB3_0040F614A5A0__INCLUDED_)
