#if !defined(AFX_CDTMFDLG_H__FC7A2811_59E8_11D1_A129_0040F614A5A0__INCLUDED_)
#define AFX_CDTMFDLG_H__FC7A2811_59E8_11D1_A129_0040F614A5A0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
// cDTMFDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// cWaitForDTMFDlg dialog

class cWaitForDTMFDlg : public CDialog
{
// Construction
public:
	cWaitForDTMFDlg(CWnd* pParent = NULL);   // standard constructor

	void	GetDTMFInfo(DTMFINFO &dtmfInfo){ memcpy( &dtmfInfo, &DTMFInfo, sizeof(DTMFInfo)); };

// Dialog Data
	//{{AFX_DATA(cWaitForDTMFDlg)
	enum { IDD = IDD_WAITFORDTMF };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(cWaitForDTMFDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	DTMFINFO	DTMFInfo;

	// Generated message map functions
	//{{AFX_MSG(cWaitForDTMFDlg)
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CDTMFDLG_H__FC7A2811_59E8_11D1_A129_0040F614A5A0__INCLUDED_)
