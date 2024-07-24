// Display.h : Display header file for the WINVOICE application
//
#ifndef __AFXWIN_H__
        #error include 'stdafx.h' before including this file for PCH
#endif

#ifndef __DISPLAY_H__
#define __DISPLAY_H__

#include "MonDlg.h"

void InitDisplay(CMonitorDlg *p);
void CloseDisplay(void);
void DispMessage(int no, char *szProgID, char *szPort, char *buf);

#endif // __DISPLAY_H__
