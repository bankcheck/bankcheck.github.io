// MonDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Monitor.h"
#include "MonDlg.h"
#include "Display.h"
#include "ms_log.h"
#include <io.h>

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
    CAboutDlg();

// Dialog Data
    //{{AFX_DATA(CAboutDlg)
    enum { IDD = IDD_ABOUTBOX };
    //}}AFX_DATA

    // ClassWizard generated virtual function overrides
    //{{AFX_VIRTUAL(CAboutDlg)
    protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
    //}}AFX_VIRTUAL

// Implementation
protected:
    //{{AFX_MSG(CAboutDlg)
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
    //{{AFX_DATA_INIT(CAboutDlg)
    //}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CAboutDlg)
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
    //{{AFX_MSG_MAP(CAboutDlg)
    // No message handlers
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMonitorDlg dialog

CMonitorDlg::CMonitorDlg(CWnd* pParent /*=NULL*/)
    : CDialog(CMonitorDlg::IDD, pParent)
{
    //{{AFX_DATA_INIT(CMonitorDlg)
    // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
    // Note that LoadIcon does not require a subsequent DestroyIcon in Win32
    m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CMonitorDlg::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CMonitorDlg)
    // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CMonitorDlg, CDialog)
    //{{AFX_MSG_MAP(CMonitorDlg)
    ON_WM_SYSCOMMAND()
    ON_WM_PAINT()
    ON_WM_QUERYDRAGICON()
    ON_MESSAGE(WM_THREADFINISHED, OnThreadFinished)
    ON_WM_TIMER()
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMonitorDlg message handlers

BOOL CMonitorDlg::OnInitDialog()
{
    CDialog::OnInitDialog();

    // Add "About..." menu item to system menu.

    // IDM_ABOUTBOX must be in the system command range.
    ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
    ASSERT(IDM_ABOUTBOX < 0xF000);

    CMenu* pSysMenu = GetSystemMenu(FALSE);
    if (pSysMenu != NULL)
    {
        CString strAboutMenu;
        strAboutMenu.LoadString(IDS_ABOUTBOX);
        if (!strAboutMenu.IsEmpty())
        {
            pSysMenu->AppendMenu(MF_SEPARATOR);
            pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
        }
        pSysMenu->EnableMenuItem(SC_SIZE, MF_BYCOMMAND|MF_GRAYED);
        pSysMenu->EnableMenuItem(SC_ZOOM, MF_BYCOMMAND|MF_GRAYED);
    }

    // Set the icon for this dialog.  The framework does this automatically
    //  when the application's main window is not a dialog
    SetIcon(m_hIcon, TRUE);     // Set big icon
    SetIcon(m_hIcon, FALSE);        // Set small icon

    // TODO: Add extra initialization here

    char drive[_MAX_DRIVE];
    char dir[_MAX_DIR];
    char fname[_MAX_FNAME];
    char ext[_MAX_EXT];
    char szFile[260];

    _splitpath(__argv[0], drive, dir, fname, ext);
    if (drive[0] == '\0' && dir[0] == '\0') {
        char buf[1024];

        GetCurrentDirectory(260, buf);
        sprintf(szFile, "%s\\monitor.ini", buf);
    }
    else
        _makepath(szFile, drive, dir, "monitor", ".ini" );

    g_dwSleep = GetPrivateProfileInt("MOXA MONITOR", "Sleep", 1000, szFile);
    g_bLog = GetPrivateProfileInt("MOXA MONITOR", "Log", 0, szFile);
    GetPrivateProfileString("MOXA MONITOR", "LogPath",
                            "D:\\MOXA\\Log\\",
                            g_szLogPath, 260, szFile);
    AddBslash(g_szLogPath);
    GetPrivateProfileString("MOXA MONITOR", "FileMapping",
                            "MOXA_MONITOR",
                            g_szFileMapping, 260, szFile);
    // load ini-files

    char szProgID[80], szPort[80], szStatus[80];
    int nProgID, nPort, nStatus;

    nProgID = GetPrivateProfileInt("ProgID", "Length", 100, szFile);
    GetPrivateProfileString("ProgID", "String", "程式名稱", szProgID, 80, szFile);
    nPort = GetPrivateProfileInt("Port", "Length", 50, szFile);
    GetPrivateProfileString("Port", "String", "通訊埠", szPort, 80, szFile);
    nStatus = GetPrivateProfileInt("Status", "Length", 300, szFile);
    GetPrivateProfileString("Status", "String", "連線狀態", szStatus, 80, szFile);

    CListCtrl *pList;
    pList = (CListCtrl *)GetDlgItem(IDC_LIST_CH);
    if (pList != NULL) {
        int i;
        int item;

        pList->InsertColumn(0, szProgID, LVCFMT_CENTER, nProgID, 0);
        pList->InsertColumn(1, szPort, LVCFMT_CENTER, nPort, 1);
        pList->InsertColumn(2, szStatus, LVCFMT_LEFT, nStatus, 2);

        for (i = 0; i < MAX_PORT; i++) {
            item = pList->InsertItem(LVIF_TEXT, i, "", 0, 0, 0, NULL);
            pList->SetItem(item, 1, LVIF_TEXT, "", 0, 0, 0, NULL);
            pList->SetItem(item, 2, LVIF_TEXT, "", 0, 0, 0, NULL);
        }
    }

    InitDisplay(this);
    DispDateTime();
    m_nTimer = SetTimer(1, 1000, NULL);
    m_pThread = AfxBeginThread(ThreadProc, GetSafeHwnd());

    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CMonitorDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
    if ((nID & 0xFFF0) == IDM_ABOUTBOX)
    {
        CAboutDlg dlgAbout;
        dlgAbout.DoModal();
    }
    else
    {
        CDialog::OnSysCommand(nID, lParam);
    }
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CMonitorDlg::OnPaint()
{
    if (IsIconic())
    {
        CPaintDC dc(this); // device context for painting

        SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

        // Center icon in client rectangle
        int cxIcon = GetSystemMetrics(SM_CXICON);
        int cyIcon = GetSystemMetrics(SM_CYICON);
        CRect rect;
        GetClientRect(&rect);
        int x = (rect.Width() - cxIcon + 1) / 2;
        int y = (rect.Height() - cyIcon + 1) / 2;

        // Draw the icon
        dc.DrawIcon(x, y, m_hIcon);
    }
    else
    {
        CDialog::OnPaint();
    }
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CMonitorDlg::OnQueryDragIcon()
{
    return (HCURSOR) m_hIcon;
}

void CMonitorDlg::OnCancel()
{
    // TODO: Add extra cleanup here

    if (AfxMessageBox("Quit Interface Monitor?", MB_YESNO) == IDYES)
        g_evtKill.SetEvent();

    // CDialog::OnCancel();
}

void CMonitorDlg::OnOK()
{
    // TODO: Add extra validation here

    // CDialog::OnOK();
}

LONG CMonitorDlg::OnThreadFinished(UINT /*wParam*/, LONG /*lParam*/)
{
    // TODO: Add extra cleanup here

    CloseDisplay();
    KillTimer(m_nTimer);
    CDialog::OnOK();
    return 0;
}

void CMonitorDlg::DispDateTime(void)
{
    time_t t;
    struct tm *tp;
    char str[20];

    time(&t);
    tp = localtime(&t);
    if (tp == NULL) return;
    sprintf(str, "%4d/%02d/%02d", tp->tm_year+1900, tp->tm_mon+1, tp->tm_mday);
    GetDlgItem(IDC_STATIC_DATE)->SetWindowText(str);
    sprintf(str, "%02d:%02d:%02d", tp->tm_hour, tp->tm_min, tp->tm_sec);
    GetDlgItem(IDC_STATIC_TIME)->SetWindowText(str);
    return;
}

void CMonitorDlg::DispMessage(int no, char *szProgID, char *szPort, char *buf)
{
    CListCtrl *pList;
    int item;

    pList = (CListCtrl *)GetDlgItem(IDC_LIST_CH);
    if (pList == NULL) return;
    if (no > MAX_PORT) return;
    item = no;
    pList->SetItem(item, 0, LVIF_TEXT, szProgID, 0, 0, 0, NULL);
    pList->SetItem(item, 1, LVIF_TEXT, szPort, 0, 0, 0, NULL);
    pList->SetItem(item, 2, LVIF_TEXT, buf, 0, 0, 0, NULL);
    if (g_bLog && buf[0] != '.' && buf[0] != '\0') {
        FILE *fp;
        char fname[261];
        time_t t;
        struct tm *tp;

        time(&t);
        tp = localtime(&t);
        if (tp != NULL) {
            sprintf(fname, "%s02d%02d-%d.ch", g_szLogPath,
                tp->tm_mon+1, tp->tm_mday, no);
            fp = fopen(fname, "at");
            if (fp != NULL) {
            fprintf(fp, "%02d:%02d:%02d %s\n",
                        tp->tm_hour, tp->tm_min, tp->tm_sec,
                        buf);
            fclose(fp);
            }
        }
    }
    return;
}

void CMonitorDlg::OnTimer(UINT nIDEvent)
{
    // TODO: Add your message handler code here and/or call default

    DispDateTime();
    CDialog::OnTimer(nIDEvent);
}
