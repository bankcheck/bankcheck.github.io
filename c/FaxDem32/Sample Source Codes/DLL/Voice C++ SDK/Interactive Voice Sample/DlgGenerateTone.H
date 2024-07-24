#if !defined(AFX_CGENTONE_H__8113B621_96FD_11D1_9EA8_444553540000__INCLUDED_)
#define AFX_CGENTONE_H__8113B621_96FD_11D1_9EA8_444553540000__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// cGenTone.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// cGenerateTone dialog

class cGenerateTone : public CDialog
{
// Construction
public:
	cGenerateTone(CWnd* pParent = NULL);   // standard constructor

	void	GetParameters(short &freq1, short &freq2, short &dur)
	{
		freq1	= nFreq1;
		freq2	= nFreq2;
		dur		= nDuration;
	};

// Dialog Data
	//{{AFX_DATA(cGenerateTone)
	enum { IDD = IDD_GEN_TONE };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(cGenerateTone)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	short	nFreq1;
	short	nFreq2;
	short	nDuration;

	// Generated message map functions
	//{{AFX_MSG(cGenerateTone)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CGENTONE_H__8113B621_96FD_11D1_9EA8_444553540000__INCLUDED_)
