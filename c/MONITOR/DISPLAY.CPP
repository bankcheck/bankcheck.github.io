#include "stdafx.h"
#include "Monitor.h"
#include "MonDlg.h"
#include "Display.h"

static CMonitorDlg *pWnd = NULL;

void InitDisplay(CMonitorDlg *p)
{
    pWnd = p;
    return;
}

void CloseDisplay(void)
{
    pWnd = NULL;
    return;
}

void DispMessage(int no, char *szProgID, char *szPort, char *buf)
{
    if (pWnd == NULL) return;
    pWnd->DispMessage(no, szProgID, szPort, buf);
    return;
}

