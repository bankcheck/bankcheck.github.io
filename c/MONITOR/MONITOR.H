// Monitor.h : main header file for the MONITOR application
//

#if !defined(AFX_MONITOR_H__7ACB9AD9_CC30_11D1_B377_0080C85AF836__INCLUDED_)
#define AFX_MONITOR_H__7ACB9AD9_CC30_11D1_B377_0080C85AF836__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#ifndef __AFXWIN_H__
    #error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"       // main symbols

extern CEvent                   g_evtKill;

#define WM_THREADFINISHED       (WM_USER+101)


/////////////////////////////////////////////////////////////////////////////
// CMonitorApp:
// See Monitor.cpp for the implementation of this class
//

class CMonitorApp : public CWinApp
{
public:
    CMonitorApp();

// Overrides
    // ClassWizard generated virtual function overrides
    //{{AFX_VIRTUAL(CMonitorApp)
    public:
    virtual BOOL InitInstance();
    //}}AFX_VIRTUAL

// Implementation

    //{{AFX_MSG(CMonitorApp)
        // NOTE - the ClassWizard will add and remove member functions here.
        //    DO NOT EDIT what you see in these blocks of generated code !
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MONITOR_H__7ACB9AD9_CC30_11D1_B377_0080C85AF836__INCLUDED_)
