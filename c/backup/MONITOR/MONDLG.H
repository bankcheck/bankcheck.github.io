// MonDlg.h : header file
//

#if !defined(AFX_MONDLG_H__7ACB9ADB_CC30_11D1_B377_0080C85AF836__INCLUDED_)
#define AFX_MONDLG_H__7ACB9ADB_CC30_11D1_B377_0080C85AF836__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

/////////////////////////////////////////////////////////////////////////////
// CMonitorDlg dialog

class CMonitorDlg : public CDialog
{
public:
    CWinThread *m_pThread;
    int m_nTimer;
    void DispDateTime(void);
    void DispMessage(int no, char *szProgID, char *szPort, char *buf);

// Construction
public:
    CMonitorDlg(CWnd* pParent = NULL);  // standard constructor

// Dialog Data
    //{{AFX_DATA(CMonitorDlg)
    enum { IDD = IDD_MONITOR_DIALOG };
        // NOTE: the ClassWizard will add data members here
    //}}AFX_DATA

    // ClassWizard generated virtual function overrides
    //{{AFX_VIRTUAL(CMonitorDlg)
    protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
    //}}AFX_VIRTUAL

// Implementation
protected:
    HICON m_hIcon;

    // Generated message map functions
    //{{AFX_MSG(CMonitorDlg)
    virtual BOOL OnInitDialog();
    afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
    afx_msg void OnPaint();
    afx_msg HCURSOR OnQueryDragIcon();
    virtual void OnCancel();
    virtual void OnOK();
    afx_msg LONG OnThreadFinished(UINT wParam, LONG lParam);
    afx_msg void OnTimer(UINT nIDEvent);
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MONDLG_H__7ACB9ADB_CC30_11D1_B377_0080C85AF836__INCLUDED_)
