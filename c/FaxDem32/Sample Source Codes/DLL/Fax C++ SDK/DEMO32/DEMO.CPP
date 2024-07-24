// img.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include <direct.h>
#include <io.h>
#pragma warning(disable:4103)
extern "C" {
	#include "bidib.h"
	#include "bitiff.h"
	#include "bidisp.h"
	#include "bijpeg.h"
	#include "biprint.h"
};
#include "resource.h"
#include "faxcpp.h"
#include "globerr.h"
#include "imgdoc.h"
#include "magnifyw.h"
#include "disp.h"
#include "imgvw.h"
#include "dialogs.h"
#include "faxdlg.h"
#include "mainfrm.h"
#include "demo.h"
#include "splitter.h"
#include "logs.h"
#include "logsview.h"
#include "logsfram.h"
#include "blockdoc.h"
#include "commcl.h"
#include "MDIChildFrame.h"


#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif

int  e_nFileFormat;

#ifdef JPEG_EXIST
#undef JPEG_EXIST
#endif

#define JPEG_EXIST 1
#if JPEG_EXIST == 1

LPSTR SaveFilterBuff =
    "Bitmap Format\0*.BMP\0"
    "TIFF File Format\0*.TIF\0"
    "CALS Format\0*.CAL\0"
    "JPEG Format\0*.jpg\0"
	"GammaLink file\0*.*\0"
    "Bicom/NMS file\0*.*\0";

LPSTR GroupFilterBuff =
    "Bitmap Format\0*.BMP\0"
    "TIFF File Format\0*.TIF\0"
    "CALS Format\0*.CAL\0"
    "JPEG Format\0*.jpg\0"
    "ASCII Text File\0*.TXT\0";

LPSTR AllFilterBuff =
    "FAX group\0*.FAX\0"
    "Bitmap Format\0*.BMP\0"
    "TIFF File Format\0*.TIF\0"
    "CALS Format\0*.CAL\0"
    "JPEG Format\0*.jpg\0"
    "ASCII Text File\0*.TXT\0"
    "All Files\0*.*\0";

#else   /* JPEG_EXIST */

LPSTR SaveFilterBuff =
    "Bitmap Format\0*.BMP\0"
    "TIFF File Format\0*.TIF\0"
    "CALS Format\0*.CAL\0"
	"GammaLink file\0*.*\0"
    "Bicom/NMS file\0*.*\0";

LPSTR AllFilterBuff =
    "FAX group\0*.FAX\0"
    "Bitmap Format\0*.BMP\0"
    "TIFF File Format\0*.TIF\0"
    "CALS Format\0*.CAL\0"
    "ASCII Text File\0*.TXT\0"
    "All Files\0*.*\0";

LPSTR GroupFilterBuff =
    "Bitmap Format\0*.BMP\0"
    "TIFF File Format\0*.TIF\0"
    "CALS Format\0*.CAL\0"
    "ASCII Text File\0*.TXT\0";

#endif      /* JPEG_EXIST */


/////////////////////////////////////////////////////////////////////////////
// CImgApp

BEGIN_MESSAGE_MAP(CImgApp, CWinApp)
    //{{AFX_MSG_MAP(CImgApp)
    ON_COMMAND(ID_APP_ABOUT, OnAppAbout)
    ON_COMMAND(IDM_HELP_SEARCH, OnHelpSearch)
    ON_COMMAND(ID_FILE_OPEN, OnFileOpen)
    ON_COMMAND(IDM_TOOLS_FONT, OnToolsFont)
    ON_UPDATE_COMMAND_UI(IDM_TOOLS_FONT, OnUpdateToolsFont)
    ON_UPDATE_COMMAND_UI(ID_PORTSETUP, OnUpdatePortSetup)
    ON_UPDATE_COMMAND_UI(ID_FAX_POLL, OnUpdateFaxPoll)
    ON_COMMAND(ID_APP_EXIT, OnExitApplication)
    ON_COMMAND(ID_FAX_POLL, OnFaxPoll)
    ON_COMMAND(ID_PORTSETUP, OnPortsetup)
	ON_UPDATE_COMMAND_UI(IDM_SENDASCII, OnUpdateSendascii)
	ON_COMMAND(IDM_SENDASCII, OnSendascii)
	ON_COMMAND(ID_HELP_FAXCSDKHELP, OnHelpFaxcsdkhelp)
	//}}AFX_MSG_MAP
    // Standard file based document commands
    ON_COMMAND(ID_FILE_NEW, OnFileNew)
    ON_COMMAND(ID_FILE_OPEN, CWinApp::OnFileOpen)
    // Standard print setup command
    ON_COMMAND(ID_FILE_PRINT_SETUP, CWinApp::OnFilePrintSetup)
        ON_COMMAND(ID_HELP_INDEX, CWinApp::OnHelpIndex)
    ON_COMMAND(ID_HELP_USING, CWinApp::OnHelpUsing)
    ON_COMMAND(ID_HELP, CWinApp::OnHelp)
    ON_COMMAND(ID_CONTEXT_HELP, CWinApp::OnContextHelp)
    ON_COMMAND(ID_DEFAULT_HELP, CWinApp::OnHelpIndex)

END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CImgApp construction

CImgApp::CImgApp()
{
    m_FirstCall = TRUE;
    LogDocument[0]= NULL;
    LogDocument[1]= NULL;
    LogDocument[2]= NULL;
    LogDocument[3]= NULL;
    m_bFaxManagerVisible=TRUE;
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CImgApp object

CImgApp NEAR theApp;

/////////////////////////////////////////////////////////////////////////////
// CImgApp initialization

HINSTANCE Load3DCtrl(HINSTANCE hInstance)
{
    HINSTANCE hCTLInstance ;
    FARPROC fpRegister ;
    FARPROC fpAutoSubclass ;
        #ifndef WIN32
    hCTLInstance = LoadLibrary("ctl3d.dll") ;
        #else
        hCTLInstance = LoadLibrary("ctl3d32.dll") ;
        #endif
    if (hCTLInstance) {
        fpRegister = GetProcAddress(hCTLInstance,"Ctl3dRegister");
        if (fpRegister) {
            ((BOOL(WINAPI CALLBACK *)(HINSTANCE))fpRegister)(hInstance);
        }
        fpAutoSubclass = GetProcAddress(hCTLInstance,"Ctl3dAutoSubclass");
        if (fpAutoSubclass){
            ((BOOL(WINAPI CALLBACK*)(HINSTANCE))fpAutoSubclass)(hInstance);
        }
    }
    return hCTLInstance ;
}

HINSTANCE hInst3d = NULL ;

BOOL CImgApp::InitInstance()
{
   
	strcpy(m_szClassName , AfxRegisterWndClass( 0, 0, 0)); 
	m_nrUntitled=1;
	 // ***** Initialize the application to use 3D controls *****
    hInst3d = Load3DCtrl(AfxGetInstanceHandle()) ;

    // Standard initialization
    // If you are not using these features and wish to reduce the size
    // of your final executable, you should remove from the following
    // the specific initialization routines you do not need.
	
    for(int jj=0; jj<MAX_FAXPORTS; jj++) {
        FaxPorts[jj] = NULL;
        nComm[jj] = 0;
        nRings[jj] = 0;
    }

    nFaxSaveFormat = 0;

    bShowEvent = FALSE;
    m_DebugBrook = FALSE;
    dlgEvent = NULL;

    SpeakerMode = STO_DIAL;
    SpeakerVolume = SPV_LOWEST;

    RunMode = RNM_HALTINFRAME;
    SetRuningMode(RunMode);

    SetDialogBkColor();        // set dialog background color to gray
    LoadStdProfileSettings();  // Load standard INI file options (including MRU)

    // Register the application's document templates.  Document templates
    //  serve as the connection between documents, frame windows and views.

    AddDocTemplate(new CMultiDocTemplate(IDR_IMGTYPE,
            RUNTIME_CLASS(CImgDoc),
            RUNTIME_CLASS(CMDIChildFrame),        // standard MDI child frame
            RUNTIME_CLASS(CImgView)));

    AddDocTemplate(new CMultiDocTemplate(IDR_FAXTYPE,
            RUNTIME_CLASS(CImgDoc),
            RUNTIME_CLASS(CSplitterFrame),        // FAX frame
            RUNTIME_CLASS(CImgView)));

    AddDocTemplate(new CMultiDocTemplate(IDR_FAXBLOCKTYPE,
            RUNTIME_CLASS(CBlockDoc),
            RUNTIME_CLASS(CBlockFrame),        // fax block
            RUNTIME_CLASS(CImgView)));

    AddDocTemplate(new CMultiDocTemplate(IDR_POLLTYPE,
            RUNTIME_CLASS(CLogs),               // Logs document
            RUNTIME_CLASS(CLogsFrame),
            RUNTIME_CLASS(CLogsView)));

    AddDocTemplate(new CMultiDocTemplate(IDR_OUTLOGTYPE,
            RUNTIME_CLASS(CLogs),               // Logs document
            RUNTIME_CLASS(CLogsFrame),
            RUNTIME_CLASS(CLogsView)));

    AddDocTemplate(new CMultiDocTemplate(IDR_SENDLOGTYPE,
            RUNTIME_CLASS(CLogs),               // Logs document
            RUNTIME_CLASS(CLogsFrame),
            RUNTIME_CLASS(CLogsView)));

    AddDocTemplate(new CMultiDocTemplate(IDR_RECLOGTYPE,
            RUNTIME_CLASS(CLogs),               // Logs document
            RUNTIME_CLASS(CLogsFrame),
            RUNTIME_CLASS(CLogsView)));

    // create main MDI Frame window
    CMainFrame* pMainFrame = new CMainFrame;
    if (!pMainFrame->LoadFrame(IDR_MAINFRAME))
        return FALSE;

//    BOOL bOK = pMainFrame->LoadAccelTable( MAKEINTRESOURCE(IDR_MAINFRAME) );
    pMainFrame->ShowWindow(m_nCmdShow);
    pMainFrame->UpdateWindow();
    m_pMainWnd = pMainFrame;

    csFaceName = "Courier";     // Default font face name.
    nFontSize = 10;             // Default font size.

    CString cErrLog  = GetProfileString("FAXCPP DEBUG", "ERRLOGFILE",  "");
    int bDebugWindow = GetProfileInt("FAXCPP DEBUG", "DEBUGWINDOW", 0);

    LPSTR lpErrLog = NULL;
    int ln = cErrLog.GetLength();

    if(ln)
    {
        lpErrLog = cErrLog.GetBuffer(ln+1);
    }

    if(lpErrLog || bDebugWindow)
    {
        EnableFaxCPPDriverDebug( lpErrLog, bDebugWindow);
    }

    nMessage = RegisterWindowMessage(REG_FAXMESSAGE);

	if (m_lpCmdLine[0] != '\0') {
        // TODO: add command line processing here
    }

    _getcwd(szAppPath, sizeof(szAppPath));
    CreateDirs();
    OnFileNew();

    CString cStartupFile = GetProfileString("StartUp", "Image File", "TEST.FAX");
    if ( cStartupFile.GetLength() ) {
        if ( !access(cStartupFile, 0) ) {
            CDocument *pDoc = OpenDocumentFile(cStartupFile);
            if ( pDoc ) {
                BOOL pbMax;

                CMDIChildWnd *pMdi = ((CMDIFrameWnd *)m_pMainWnd)->MDIGetActive(&pbMax);
                if ( pMdi )
                    pMdi->ShowWindow( SW_SHOW );
            }
        }
    }
    return TRUE;
}

void CImgApp::OnFileNew()
{
    BOOL bOk;
    POSITION pos ;
#if (_MFC_VER < 0x400)
    pos = m_templateList.GetHeadPosition();
#else
    pos = GetFirstDocTemplatePosition();
#endif

    CDocTemplate* pTemplate = NULL;
    CString str;
    for (;;) {
#if     (_MFC_VER < 0x400)
        pTemplate = (CDocTemplate*)m_templateList.GetNext(pos);
#else
                pTemplate = GetNextDocTemplate(pos) ;
#endif

        if(pTemplate==NULL)
            break;
        bOk = pTemplate->GetDocString(str, CDocTemplate::docName);
        if(bOk==FALSE)
            break;
        if ( m_FirstCall ) {
            if (str==CString("SENDLOG")) {
                LogDocument[LGT_SEND]= pTemplate->OpenDocumentFile(NULL);
                if (LogDocument[LGT_SEND]) {
                    LogDocument[LGT_SEND]->SetTitle("Send Log");
                }
            }
            if (str==CString("POLLLOG")) {
                LogDocument[LGT_POLLING]= pTemplate->OpenDocumentFile(NULL);
                if (LogDocument[LGT_POLLING]) {
                    LogDocument[LGT_POLLING]->SetTitle("Poll Output Log");
                }
            }
            if (str==CString("RECLOG")) {
                LogDocument[LGT_RECEIVE]= pTemplate->OpenDocumentFile(NULL);
                if (LogDocument[LGT_RECEIVE]){
                    LogDocument[LGT_RECEIVE]->SetTitle("Receive Log");
                }
                break ;
            }
            if (str==CString("OUTLOG")) {
                LogDocument[LGT_OUTBOX]= pTemplate->OpenDocumentFile(NULL);
                if (LogDocument[LGT_OUTBOX]) {
                    LogDocument[LGT_OUTBOX]->SetTitle("Out Box");
                }
            }
        }
        else {
            if(str==CString("FAX")) {
                pTemplate->OpenDocumentFile(NULL);
                break;
            }
        }
    }
    m_FirstCall = FALSE;
}

void CImgApp::NewImage()
{
    BOOL bOk;
    POSITION pos ;
#if (_MFC_VER < 0x400)
    pos = m_templateList.GetHeadPosition();
#else
    pos = GetFirstDocTemplatePosition();
#endif

    CDocTemplate* pTemplate = NULL;
    CString str;
    for ( ;; ) {
#if     (_MFC_VER < 0x400)
        pTemplate = (CDocTemplate*)m_templateList.GetNext(pos);
#else
        pTemplate = GetNextDocTemplate(pos) ;
#endif
        if(pTemplate==NULL)
            break;
        bOk = pTemplate->GetDocString(str, CDocTemplate::docName);
        if ( bOk ) {
            if ( str==CString("Img") ) {
                pTemplate->OpenDocumentFile(NULL);
                break;
            }
        }
    }
}

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	void VisitTo(CString*);
    CAboutDlg();

// Dialog Data
    //{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	CStatic	m_cMail;
	CStatic	m_cWebPage;
	//}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
    //{{AFX_MSG(CAboutDlg)
    virtual BOOL OnInitDialog();
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);
	afx_msg void OnMouseMove(UINT nFlags, CPoint point);
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
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
	DDX_Control(pDX, IDC_EMAIL, m_cMail);
	DDX_Control(pDX, IDC_WEB, m_cWebPage);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
    //{{AFX_MSG_MAP(CAboutDlg)
	ON_WM_CTLCOLOR()
	ON_WM_MOUSEMOVE()
	ON_WM_LBUTTONDOWN()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

// App command to run the dialog
void CImgApp::OnAppAbout()
{
    CAboutDlg aboutDlg;
    aboutDlg.DoModal();
}

/////////////////////////////////////////////////////////////////////////////
// CImgApp commands

void CImgApp::OnHelpSearch()
{
    // TODO: Add your command handler code here
    char Str = 0;

    WinHelp((DWORD)(LPSTR(&Str)), HELP_PARTIALKEY);
}


int  nFileFormat;

int CImgApp::MyDoPromptFileName(CString& fileName, UINT nIDSTitle, LPSTR lpFilter,
    DWORD lFlags, BOOL bOpenFileDialog)
{
    CFileDialog *dlgFile = new CFileDialog(bOpenFileDialog);

    CString title;
    title.LoadString(nIDSTitle);

    dlgFile->m_ofn.Flags |= lFlags;

    dlgFile->m_ofn.nFilterIndex = e_nFileFormat;  // NGY
	dlgFile->m_ofn.lpstrFilter = lpFilter;

		//    LoadWorkDir(dlgFile);
    CString strdir = GetProfileString("StartUp", "WorkDir", "");
    dlgFile->m_ofn.lpstrInitialDir = strdir.GetBuffer(_MAX_PATH);


    dlgFile->m_ofn.hwndOwner = AfxGetApp()->m_pMainWnd->GetSafeHwnd();
    dlgFile->m_ofn.lpstrTitle = title;
    dlgFile->m_ofn.lpstrFile = fileName.GetBuffer(_MAX_PATH);


    int bRet = 0;
    int nn = dlgFile->DoModal();
    if(nn==IDOK)
    {
        bRet = (int)dlgFile->m_ofn.nFilterIndex;
        SaveWorkDir(dlgFile);
    }

    delete dlgFile;
    fileName.ReleaseBuffer();
    return bRet;
}

void CImgApp::SaveWorkDir(CFileDialog *dlgFile)
{
    char buf[_MAX_PATH], fdrive[_MAX_DRIVE];
    char fdir[_MAX_DIR];
    _splitpath(dlgFile->m_ofn.lpstrFile, fdrive, fdir, NULL, NULL);
    _makepath(buf, fdrive, fdir, NULL, NULL);
    int ln = lstrlen(buf);
    if(ln>2)
    {
        if(buf[ln-1]=='\\' || buf[ln-2]!=':')
        {
            buf[ln-1] = 0;
        }
    }
    WriteProfileString("StartUp", "WorkDir", buf);
}

int CImgApp::PromptFaxFileName(CString& fileName)
{
    int nType;
    nType = MyDoPromptFileName(fileName, IDS_OPENFILE, GroupFilterBuff,
                    OFN_HIDEREADONLY | OFN_FILEMUSTEXIST, TRUE);
    if(nType)
        nType++;
    return nType;
}

int CImgApp::PromptFaxSaveFileName(CString& fileName)
{

    static LPSTR lpFilter = "FAX group\0*.FAX\0"
                     "All Files\0*.*\0";

    UINT nIDSTitle = IDS_SAVEFILE;
    CMySave *dlgFile = new CMySave(FALSE);


    DWORD lFlags =OFN_HIDEREADONLY | OFN_OVERWRITEPROMPT;

    CString title;
    title.LoadString(nIDSTitle);

#ifdef WIN32
    OSVERSIONINFO  VersionInformation;
    VersionInformation.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
    GetVersionEx(&VersionInformation);
    if ( (VersionInformation.dwPlatformId == VER_PLATFORM_WIN32_NT && VersionInformation.dwMajorVersion < 4) ||
                     VersionInformation.dwPlatformId == VER_PLATFORM_WIN32s   )
    lFlags |= OFN_ENABLETEMPLATE; // Windows 3.X or NT 3.X
#else
    lFlags |= OFN_ENABLETEMPLATE;
#endif

    dlgFile->m_ofn.Flags |= lFlags;
    dlgFile->m_ofn.lpTemplateName = MAKEINTRESOURCE(IDD_MYSAVE);
    dlgFile->m_ofn.hInstance = AfxGetApp()->m_hInstance;

    dlgFile->m_ofn.nFilterIndex = 0;

    dlgFile->m_ofn.lpstrFilter = lpFilter;
    dlgFile->m_ofn.hwndOwner = AfxGetApp()->m_pMainWnd->GetSafeHwnd();
    dlgFile->m_ofn.lpstrTitle = title;
    dlgFile->m_ofn.lpstrFile = fileName.GetBuffer(_MAX_PATH);

    //    LoadWorkDir(dlgFile);
    CString strdir = GetProfileString("StartUp", "WorkDir", "");
    dlgFile->m_ofn.lpstrInitialDir = strdir.GetBuffer(_MAX_PATH);


    int bRet = FALSE;
    int nn = dlgFile->DoModal();
    if(nn==IDOK)
    {
        bRet = (int)dlgFile->m_ofn.nFilterIndex;
        SaveWorkDir(dlgFile);
    }

    delete dlgFile;
    fileName.ReleaseBuffer();
    return bRet;
}


int CImgApp::MySaveFileName(CString& fileName, UINT nIDSTitle, LPSTR lpFilter,
    DWORD lFlags, BOOL bOpenFileDialog, LPINT lpQuality)
{
    CMySave *dlgFile = new CMySave(bOpenFileDialog);

    CString title;
    title.LoadString(nIDSTitle);

#ifdef WIN32    
    OSVERSIONINFO  VersionInformation;
    VersionInformation.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
    GetVersionEx(&VersionInformation);
    if ( (VersionInformation.dwPlatformId == VER_PLATFORM_WIN32_NT && VersionInformation.dwMajorVersion < 4) ||
                     VersionInformation.dwPlatformId == VER_PLATFORM_WIN32s   )
    	lFlags |= OFN_ENABLETEMPLATE; // Windows 3.X or NT 3.X
#else
    lFlags |= OFN_ENABLETEMPLATE;
#endif    

    dlgFile->m_ofn.Flags |= lFlags;
    dlgFile->m_ofn.lpTemplateName = MAKEINTRESOURCE(IDD_MYSAVE);
    dlgFile->m_ofn.hInstance = AfxGetApp()->m_hInstance;

    dlgFile->m_ofn.nFilterIndex = e_nFileFormat - 1;

    dlgFile->m_ofn.lpstrFilter = lpFilter;
    dlgFile->m_ofn.hwndOwner = AfxGetApp()->m_pMainWnd->GetSafeHwnd();
    dlgFile->m_ofn.lpstrTitle = title;
    dlgFile->m_ofn.lpstrFile = fileName.GetBuffer(_MAX_PATH);


    int bRet = 0;
    int nn = dlgFile->DoModal();
    if(nn==IDOK)
    {
        bRet = (int)dlgFile->m_ofn.nFilterIndex+1;
        SaveWorkDir(dlgFile);
    }

    if(lpQuality)
        *lpQuality = dlgFile->m_dlg_jpeg_qu;

    delete dlgFile;
    fileName.ReleaseBuffer();
    return bRet;
}


void CImgApp::OnFileOpen()
{
    // TODO: Add your command handler code here

    CString         newName;

    e_nFileFormat = MyDoPromptFileName(newName, IDS_OPENFILE, AllFilterBuff,
          OFN_HIDEREADONLY | OFN_FILEMUSTEXIST, TRUE);
    if(!e_nFileFormat)
        return; // open cancelled
    OpenDocumentFile(newName);

}

void CImgApp::OnToolsFont()
{
    // TODO: Add your command handler code here
    CFontDialog dlgFont;
    //
    // Get font name and size to be used.
    //
    if(dlgFont.DoModal()== IDOK) {
        csFaceName =  dlgFont.GetFaceName();
        nFontSize = dlgFont.GetSize();
    }

}

void CImgApp::OnUpdateToolsFont(CCmdUI* /*pCmdUI*/)
{
    // TODO: Add your command update UI handler code here
}

BOOL CAboutDlg::OnInitDialog()
{
    CDialog::OnInitDialog();

    // TODO: Add extra initialization here
    char    szVersion[20];
    szVersion[0] = '\0';

    CString str;
    str.LoadString(IDR_MAINFRAME);
    SetDlgItemText(IDR_MAINFRAME, str.GetBuffer( str.GetLength()+1) );

    GetImageVersion(szVersion, sizeof(szVersion));
    SetDlgItemText(IDC_BIDIBVERSION, szVersion);

    GetTiffVersion(szVersion, sizeof(szVersion));
    SetDlgItemText(IDC_TIFFVERSIO, szVersion);

	GetBiJPEGVersion(szVersion, sizeof(szVersion));
    SetDlgItemText(IDC_BIJPEGVERSION, szVersion);

	GetBiPrintVersion(szVersion, sizeof(szVersion));
    SetDlgItemText(IDC_BIPRINTVERSION, szVersion);

	GetBiDispVersion(szVersion, sizeof(szVersion));
    SetDlgItemText(IDC_BIDISPVERSION, szVersion);

    GetFaxCppVersion(szVersion, sizeof(szVersion));
    SetDlgItemText(IDC_FAXVERSION, szVersion);

	if (GetNumberOfLicensedPorts() == 0)
		strcpy(szVersion, "Unlimited ports");
	else
		sprintf(szVersion, "%d ports", GetNumberOfLicensedPorts());

	SetDlgItemText(IDC_PORTS, szVersion);

    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CImgApp::OnExitApplication()
{	
	CDlgFaxClose dlgCloseFaxPort;

    dlgCloseFaxPort.DoModal(); 
    
    if ( ((CLogs *)LogDocument[LGT_OUTBOX])->GetBlockCount() ) 
	{
        if ( AfxMessageBox( IDS_WARNING, MB_YESNO ) == IDYES ) 
		{
            CWinApp::OnAppExit();
        }
    }
    else PostMessage(AfxGetMainWnd()->m_hWnd,WM_CLOSE,0,0);
}

void CImgApp::FaxEventText(int iPort, LPSTR buf)
{
    if(dlgEvent)
        dlgEvent->SetEventText(iPort, buf);
}

void CImgApp::ShowAllMagnifyWnd(int nShow)
{
    CDocument *pdoc;
    CFrameWnd *frm = NULL;
    CMDIChildWnd *pnext = NULL;
    CView *pw = NULL;
    CImgView *pwi = NULL;
    CMDIFrameWnd *pmain = (CMDIFrameWnd *)m_pMainWnd;
    if(pmain==NULL)
        return;
    CMDIChildWnd *pfirst = pmain->MDIGetActive();
    pnext = pfirst;
    do
    {
        if(pnext==NULL)
            break;
        frm = pnext->GetActiveFrame();
        if(frm==NULL)
            break;
        pw = NULL;
        pdoc = frm->GetActiveDocument();
        if(pdoc)
        {
            if(pdoc->IsKindOf(RUNTIME_CLASS(CImgDoc)))
            {
                CImgDoc *pdoc2 = (CImgDoc *)pdoc;
                pw = pdoc2->qryImgView();
                if(pw)
                {
                    if(pw->IsKindOf(RUNTIME_CLASS(CImgView)))
                    {
                        pwi = (CImgView *)pw;
                        pwi->ShowMagnifyWnd(nShow);
                    }
                }
            }
        }

        pmain->MDINext();
        pnext = pmain->MDIGetActive();
    }
    while(pnext!=pfirst);

}


void CImgApp::LoadZoomINIFile() {
    int base, jj, tmp;
    ZOOMSTEP ee, rr;
    char name[40];
    LPSTR sec = "BZOOM";

    _fmemset(&ee, 0, sizeof(ee));
    _fmemset(&rr, 0, sizeof(rr));

    base = (int)GetProfileInt(sec, "BASE", -1);
    if(base<=0 || base>MAX_SCALE_BASE)
        return;

    ee.num = (int)GetProfileInt(sec, "E_NUM", -1);
    if(ee.num<=0 || ee.num>MAX_SCALE_STEP)
        return;

    rr.num = (int)GetProfileInt(sec, "R_NUM", -1);
    if(rr.num<=0 || rr.num>MAX_SCALE_STEP)
        return;

    ee.step[0] = (int)GetProfileInt(sec, "E_1", -1);
    if(ee.step[0] != base)
        return;
    tmp = ee.step[0];
    for(jj=1; jj<ee.num; jj++) {
        wsprintf(name, "E_%d", jj+1);
        ee.step[jj] = (int)GetProfileInt(sec, name, -1);
        if(ee.step[jj] <= tmp)
            return;
        tmp = ee.step[jj]; }

    rr.step[0] = (int)GetProfileInt(sec, "R_1", -1);
    if(rr.step[0] != base)
        return;
    tmp = rr.step[0];
    for(jj=1; jj<rr.num; jj++) {
        wsprintf(name, "R_%d", jj+1);
        rr.step[jj] = (int)GetProfileInt(sec, name, -1);
        if(rr.step[jj] <= tmp)
            return;
        tmp = rr.step[jj]; }

    BZoomSetScaleSteps(base, &ee, &rr);
    return; }

void CImgApp::SaveZoomINIFile() {
    int base, jj;
    ZOOMSTEP ee, rr;
    char name[40];
    LPSTR sec = "BZOOM";

    _fmemset(&ee, 0, sizeof(ee));
    _fmemset(&rr, 0, sizeof(rr));

    base = BZoomGetScaleSteps(&ee, &rr);
    WriteProfileInt(sec, "BASE", base);

    WriteProfileInt(sec, "E_NUM", ee.num);
    for(jj=0; jj<ee.num; jj++) {
        wsprintf(name, "E_%d", jj+1);
        WriteProfileInt(sec, name, ee.step[jj]); }

    WriteProfileInt(sec, "R_NUM", rr.num);
    for(jj=0; jj<rr.num; jj++) {
        wsprintf(name, "R_%d", jj+1);
        WriteProfileInt(sec, name, rr.step[jj]);
    }   /* for */

    return; }

HDC  CImgApp::GetPrinterDC()
{
    HDC hRetDC ;
    LPDEVNAMES  lpDevNames ;
    LPSTR       lpDriver ;
    LPSTR       lpDevice ;
    LPSTR       lpOutput ;


    UpdatePrinterSelection(FALSE);

    if (!m_hDevNames) return NULL ;
    lpDevNames  = (LPDEVNAMES) GlobalLock(m_hDevNames) ;
    if (!lpDevNames) return NULL ;

    lpDriver = (LPSTR)((LPSTR)lpDevNames) + lpDevNames->wDriverOffset ;
    lpDevice = (LPSTR)((LPSTR)lpDevNames) + lpDevNames->wDeviceOffset;
    lpOutput = (LPSTR)((LPSTR)lpDevNames) + lpDevNames->wOutputOffset;

    hRetDC = CreateDC(lpDriver,lpDevice,lpOutput,NULL);
    GlobalUnlock(m_hDevNames);
    return hRetDC ;
}

CDC *CImgApp::GetPrinterCDC()
{
    LPDEVNAMES  lpDevNames ;
    LPDEVMODE   lpDevMode  ;
    LPSTR       lpDriver, lpDevice, lpOutput ;
    CDC         *pRetDC;

//  UpdatePrinterSelection(FALSE);
    OnFilePrintSetup();

    if (!m_hDevNames) return NULL ;
    lpDevNames  = (LPDEVNAMES) GlobalLock(m_hDevNames) ;
    if (!lpDevNames) return NULL ;
    lpDevMode = (LPDEVMODE) GlobalLock(m_hDevMode);

    lpDriver = (LPSTR)((LPSTR)lpDevNames) + lpDevNames->wDriverOffset ;
    lpDevice = (LPSTR)((LPSTR)lpDevNames) + lpDevNames->wDeviceOffset;
    lpOutput = (LPSTR)((LPSTR)lpDevNames) + lpDevNames->wOutputOffset;

    pRetDC = new CDC;
    if ( pRetDC )
        pRetDC->CreateDC( lpDriver, lpDevice, lpOutput, lpDevMode );

    GlobalUnlock(m_hDevNames);
    GlobalUnlock(m_hDevMode);
    return pRetDC ;
}

CImgDoc* CImgApp::OnNewFaxGroupDocument()
{
    POSITION pos ;
    CDocTemplate* pTemplate = NULL;
    CString str;
#if     (_MFC_VER < 0x400)
    pos = m_templateList.GetHeadPosition();
#else
        pos = GetFirstDocTemplatePosition();
#endif

    for( ; ; ) {
#if     (_MFC_VER < 0x400)
        pTemplate = (CDocTemplate*)m_templateList.GetNext(pos);
#else
                pTemplate = GetNextDocTemplate(pos) ;
#endif

        if ( pTemplate==NULL )
            break;
        if (  pTemplate->GetDocString(str, CDocTemplate::docName) ) {
            if ( str == CString("FAX") ) {
                return (CImgDoc*)pTemplate->OpenDocumentFile(NULL);
                break;
            }
        }
    }
    return (CImgDoc*)0;
}

BOOL CImgApp::CreateDirs()
{
    char    szModuleName[260];
    LPSTR   lpFileName;

    GetModuleFileName( AfxGetInstanceHandle(), szModuleName, sizeof(szModuleName) );
    lpFileName = _fstrrchr( szModuleName, '\\' );
    if ( !lpFileName )
        lpFileName = _fstrrchr( szModuleName, ':' );
    *(++lpFileName) = 0;
    m_szDemoPath = szModuleName;
    _fstrcat( szModuleName, "SEND" );
    mkdir( szModuleName );

    *lpFileName = 0;
    _fstrcat( szModuleName, "RECEIVE" );
    mkdir( szModuleName );

    *lpFileName = 0;
    _fstrcat( szModuleName, "OUT" );
    mkdir( szModuleName );

    *lpFileName = 0;
    _fstrcat( szModuleName, "POLL" );
    mkdir( szModuleName );
    FaxEventHandler (NULL, (TEFaxEvent)POLLING_OUTPUT, (LPARAM)szModuleName);
    return 0;
}

HFILE CImgApp::GetFileName( CString &szDir, CString &szExt, CString &szName )
{
    CString  szFile, szTime;
    DWORD    ctime;
    OFSTRUCT of;
    HFILE    hFile;

    time( (time_t*)&ctime );
    while ( 1 ) {
        ltoa( ctime, szTime.GetBuffer(64), 10 );
        szTime.ReleaseBuffer( -1 );
        szName = szDir ;
                szName += szTime.Right(8) ;
                szName += '.' ;
                szName +=  szExt;

        hFile = OpenFile( szName, &of, OF_EXIST );
        if ( hFile != HFILE_ERROR ) {
            ctime++;
        }
        else {
            hFile = OpenFile( szName, &of, OF_CREATE|OF_READWRITE );
            break;
        }
    }
    return hFile;
}

void CImgApp::ReadSendIniFile()
{
    m_retries  = GetProfileInt("Fax", "RETRIES",  1);
    m_retrytim = GetProfileInt("Fax", "RETRYTIM", 1);
    m_bPulse   = GetProfileInt("Fax", "PULSE", 0);
}

void CImgApp::SaveSendIniFile()
{
    WriteProfileInt("Fax", "RETRIES", m_retries);
    WriteProfileInt("Fax", "RETRYTIM", m_retrytim);
    WriteProfileInt("Fax", "PULSE", m_bPulse);
}

void CImgApp::ShowFaxBlock( int LogType, int BlockID, BOOL /*bPrintDoc*/, HFILE hb )
{
    BOOL bOk;
    POSITION pos ;
    CDocTemplate* pTemplate = NULL;
    CString str;

#if     (_MFC_VER < 0x400)
    pos = m_templateList.GetHeadPosition();
#else
        pos = GetFirstDocTemplatePosition();
#endif

    while ( pos ) {
#if     (_MFC_VER < 0x400)
        pTemplate = (CDocTemplate*)m_templateList.GetNext(pos);
#else
                pTemplate = GetNextDocTemplate(pos) ;
#endif
        if ( pTemplate==NULL )
            break;
        bOk = pTemplate->GetDocString(str, CDocTemplate::docName);
        if ( bOk==FALSE ) break ;
        if ( str==CString("FAXBLOCK") ) {
            POSITION ps ;
            CDocument   *pDoc ;
            CBlockDoc   *pNewDoc ;
            ps = pTemplate->GetFirstDocPosition() ;
            pNewDoc = NULL ;
            while ( ps ) {
                pDoc = pTemplate->GetNextDoc(ps) ;
                if ( pDoc->IsKindOf(RUNTIME_CLASS(CBlockDoc)) ) {
                    pNewDoc = (CBlockDoc*)pDoc ;
                    if ((pNewDoc->m_LogType == LogType ) && (pNewDoc->m_BlockID==BlockID)) {
                        break ;
                    }
                    pNewDoc = NULL ;
                }
            }
            if (!pNewDoc){
                pNewDoc= (CBlockDoc*)pTemplate->OpenDocumentFile(NULL);
                if (!pNewDoc) break ;
                pNewDoc->LoadFaxBlock( LogType, BlockID, hb );
            } else {
                pNewDoc->SetActiveDoc();
            }
            break;
        }
    }
}

void CImgApp::SetFaxTime( TSFaxTime *mytime, struct tm *wtime )
{
    mytime->tm_sec      = (WORD)wtime->tm_sec;
    mytime->tm_min      = (WORD)wtime->tm_min;
    mytime->tm_hour     = (WORD)wtime->tm_hour;
    mytime->tm_mday     = (WORD)wtime->tm_mday;
    mytime->tm_mon      = (WORD)wtime->tm_mon;
    mytime->tm_year     = (WORD)wtime->tm_year;
    mytime->tm_wday     = (WORD)wtime->tm_wday;
    mytime->tm_yday     = (WORD)wtime->tm_yday;
    mytime->tm_isdst    = (WORD)wtime->tm_isdst;
}

void CImgApp::SetWinTime( TSFaxTime *mytime, struct tm *wtime )
{
    wtime->tm_sec      = (int)mytime->tm_sec;
    wtime->tm_min      = (int)mytime->tm_min;
    wtime->tm_hour     = (int)mytime->tm_hour;
    wtime->tm_mday     = (int)mytime->tm_mday;
    wtime->tm_mon      = (int)mytime->tm_mon;
    wtime->tm_year     = (int)mytime->tm_year;
    wtime->tm_wday     = (int)mytime->tm_wday;
    wtime->tm_yday     = (int)mytime->tm_yday;
    wtime->tm_isdst    = (int)mytime->tm_isdst;
}

void CImgApp::OnPortsetup()
{
    CPortSelect dlgPortSel;

    if ( dlgPortSel.DoModal() == IDOK ) {
        CPortSet dlgPortSetup;

        dlgPortSetup.m_wPortNr = dlgPortSel.m_wPort;
        if ( dlgPortSetup.DoModal() == IDOK ) {
        }
    }
}

void CImgApp::OnUpdatePortSetup(CCmdUI *pCmdUI)
{
/*    for ( int i = 0; i < MAX_FAXPORTS; i++) {
        if ( FaxPorts[i] ) {
            if ( FaxPorts[i]->IsOpen() ) {
                pCmdUI->Enable(TRUE);
                return;
            }
        }
    }*/
    pCmdUI->Enable(FALSE);
}

void CImgApp::OnFaxPoll()
{
    CPolling    dlgPoll;

    dlgPoll.DoModal();
}

void CImgApp::OnUpdateFaxPoll(CCmdUI* pCmdUI)
{
    BOOL bEnable = FALSE ;
    for(int i=0;i<MAX_FAXPORTS;i++){
        if (FaxPorts[i]){
            if (FaxPorts[i]->IsOpen()){
                bEnable = TRUE ;
                break ;
            }
        }
    }
    pCmdUI->Enable( bEnable ) ;
}

extern BOOL OK;



void CImgApp::OnUpdateSendascii(CCmdUI* pCmdUI) 
{
	// TODO: Add your command update UI handler code here
	BOOL bEnable = FALSE ;
    for(int i=0;i<MAX_FAXPORTS;i++){
        if (FaxPorts[i]){
            if (FaxPorts[i]->IsOpen()){
                bEnable = TRUE ;
                break ;
            }
        }
    }
//    pCmdUI->Enable( IsAnyPortOpen() ) ;
    pCmdUI->Enable( bEnable ) ;		
}

void CImgApp::OnSendascii() 
{
	// TODO: Add your command handler code here
	CFileDialog *dlg=new CFileDialog(TRUE,"txt",NULL,NULL,"Text files (*.txt)|*.txt|\0");
	if((dlg->DoModal())==IDOK)
	{
		CDlgSendFax dlgFaxSend;
		CImgDoc *doc=(CImgDoc*)new CImgDoc(dlg->GetPathName());
		dlgFaxSend.pDoc =doc;
		dlgFaxSend.DoModal();
		delete doc;
	}
	
}


HBRUSH CAboutDlg::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor) 
{
	HBRUSH hbr = CDialog::OnCtlColor(pDC, pWnd, nCtlColor);
	
	if (nCtlColor == CTLCOLOR_STATIC)
    {    
         if (pWnd == GetDlgItem(IDC_WEB) || pWnd==GetDlgItem(IDC_EMAIL))
              pDC->SetTextColor(RGB(0, 0, 255));
    }
	
	// TODO: Return a different brush if the default is not desired
	return hbr;
}

void CAboutDlg::OnMouseMove(UINT nFlags, CPoint point) 
{
	CRect rectWeb,rectMail;
	m_cWebPage.GetWindowRect(&rectWeb);
	m_cMail.GetWindowRect(&rectMail);
	ScreenToClient(rectWeb);
	ScreenToClient(rectMail);
	if (rectWeb.PtInRect(point) || rectMail.PtInRect(point))
		SetCursor(LoadCursor(NULL, MAKEINTRESOURCE(32649)));

	CDialog::OnMouseMove(nFlags, point);
}

void CAboutDlg::OnLButtonDown(UINT nFlags, CPoint point) 
{
	CRect rectWeb,rectMail;
	CString web, mail="mailto:";
	m_cWebPage.GetWindowRect(&rectWeb);
	m_cMail.GetWindowRect(&rectMail);
	ScreenToClient(rectWeb);
	ScreenToClient(rectMail);
	if (rectWeb.PtInRect(point))
	{
		m_cWebPage.GetWindowText(web);
		VisitTo(&web);		
	}
	else if (rectMail.PtInRect(point))
	{
		m_cMail.GetWindowText(web);
		mail+=web;
		VisitTo(&mail);
	}
	
	CDialog::OnLButtonDown(nFlags, point);
}

void CAboutDlg::VisitTo(CString *page)
{
	HINSTANCE hRet = ShellExecute( NULL, "open", page->GetBuffer(1024),
		NULL, NULL, SW_SHOWNORMAL );
	switch ((long)hRet)
	{
		case 0 : 
			AfxMessageBox("The operating system is out of memory or resources.");
			break;
		case ERROR_FILE_NOT_FOUND :
			AfxMessageBox("The specified file was not found.");
			break;
		case ERROR_PATH_NOT_FOUND :
			AfxMessageBox("The specified path was not found.");
			break;
		case ERROR_BAD_FORMAT :
			AfxMessageBox("The .exe file is invalid (non-Win32® .exe or error in .exe image).");
			break;
		case SE_ERR_ACCESSDENIED :
			AfxMessageBox("The operating system denied access to the specified file.");
			break;
		case SE_ERR_ASSOCINCOMPLETE :
			AfxMessageBox("The file name association is incomplete or invalid.");
			break;
		case SE_ERR_DDEBUSY :
			AfxMessageBox("The DDE transaction could not be completed because other DDE transactions were being processed.");
			break;
		case SE_ERR_DDEFAIL :
			AfxMessageBox("The DDE transaction failed.");
			break;
		case SE_ERR_DDETIMEOUT :
			AfxMessageBox("The DDE transaction could not be completed because the request timed out.");
			break;
		case SE_ERR_DLLNOTFOUND :
			AfxMessageBox("The specified dynamic-link library was not found.");
			break;
		case SE_ERR_NOASSOC :
			AfxMessageBox("There is no application associated with the given file name extension. This error will also be returned if you attempt to print a file that is not printable.");
			break;
		case SE_ERR_OOM :
			AfxMessageBox("There was not enough memory to complete the operation.");
			break;
		case SE_ERR_SHARE :
			AfxMessageBox("A sharing violation occurred.");
			break;
		case -1 : 
			AfxMessageBox("Invalid window state parameter.");
			break;
	}	
}


void CImgApp::OnHelpFaxcsdkhelp() 
{
	HINSTANCE hRet = ShellExecute( NULL, "open", "..\\Help\\Black_Ice_Fax_C++_SDK_Help.chm",
		NULL, NULL, SW_SHOWNORMAL );	
	switch ((long)hRet)
	{
		case 0 : 
			AfxMessageBox("The operating system is out of memory or resources.");
			break;
		case ERROR_FILE_NOT_FOUND :
			AfxMessageBox("The specified file was not found.");
			break;
		case ERROR_PATH_NOT_FOUND :
			AfxMessageBox("The specified path was not found.");
			break;
		case ERROR_BAD_FORMAT :
			AfxMessageBox("The .exe file is invalid (non-Win32® .exe or error in .exe image).");
			break;
		case SE_ERR_ACCESSDENIED :
			AfxMessageBox("The operating system denied access to the specified file.");
			break;
		case SE_ERR_ASSOCINCOMPLETE :
			AfxMessageBox("The file name association is incomplete or invalid.");
			break;
		case SE_ERR_DDEBUSY :
			AfxMessageBox("The DDE transaction could not be completed because other DDE transactions were being processed.");
			break;
		case SE_ERR_DDEFAIL :
			AfxMessageBox("The DDE transaction failed.");
			break;
		case SE_ERR_DDETIMEOUT :
			AfxMessageBox("The DDE transaction could not be completed because the request timed out.");
			break;
		case SE_ERR_DLLNOTFOUND :
			AfxMessageBox("The specified dynamic-link library was not found.");
			break;
		case SE_ERR_NOASSOC :
			AfxMessageBox("There is no application associated with the given file name extension. This error will also be returned if you attempt to print a file that is not printable.");
			break;
		case SE_ERR_OOM :
			AfxMessageBox("There was not enough memory to complete the operation.");
			break;
		case SE_ERR_SHARE :
			AfxMessageBox("A sharing violation occurred.");
			break;
		case -1 : 
			AfxMessageBox("Invalid window state parameter.");
			break;
	}		
}
