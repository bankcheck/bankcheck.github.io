// mainfrm.cpp : implementation of the CMainFrame class
//

#include "stdafx.h"
#include <dde.h>
#ifdef WIN32
        #include "dlgbc.h"
#endif

extern "C" {
    #include    "pbook.h"
	#include "bitiff.h"
	#include "bidisp.h"
};

//#include <fstream.h>
//#include <stdio.h>

#pragma warning(disable:4103)

#include "faxbft.h"
#include "faxcpp.h"
#include "commcl.h"

#include "resource.h"
#include "imgdoc.h"

#include "magnifyw.h"
#include "disp.h"
#include "imgvw.h"
#include "dialogs.h"
#include "faxdlg.h"
#include "mainfrm.h"
#include "demo.h"
#include "inputvw.h"
#include "phbdlg.h"
#include "logs.h"
#ifdef WIN32
#include "dlgc.h"
#include "opencmtx.h"
#include "dlgnms.h"

#endif

#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif
#define  TIMER_ID_CHKOUTBOX 1

/////////////////////////////////////////////////////////////////////////////
// CMainFrame

IMPLEMENT_DYNAMIC(CMainFrame, CMDIFrameWnd)

BEGIN_MESSAGE_MAP(CMainFrame, CMDIFrameWnd)
    //{{AFX_MSG_MAP(CMainFrame)
    ON_WM_CREATE()
    ON_WM_DESTROY()
    ON_WM_SIZE()
    ON_COMMAND(ID_EDIT_PASTE, OnEditPaste)
    ON_UPDATE_COMMAND_UI(ID_EDIT_PASTE, OnUpdateEditPaste)
    ON_UPDATE_COMMAND_UI(ID_INDICATOR_IMAGENO, OnUpdateIndicatorImageno)
    ON_UPDATE_COMMAND_UI(ID_INDICATOR_IMAGETOTAL, OnUpdateIndicatorImageTotal)
    ON_WM_PALETTECHANGED()
    ON_WM_QUERYNEWPALETTE()
    ON_WM_TIMER()
    ON_COMMAND(ID_FAX_PORTSETUP, OnFaxPortSetup)
    ON_UPDATE_COMMAND_UI(ID_FAX_PORTSETUP, OnUpdateFaxPortSetup)
    ON_UPDATE_COMMAND_UI(ID_FAX_PORT_CLOSE, OnUpdateFaxPortClose)
    ON_COMMAND(ID_FAX_PORT_CLOSE, OnFaxPortClose)
    ON_COMMAND(ID_FAX_ABORT, OnFaxAbort)
    ON_UPDATE_COMMAND_UI(ID_FAX_ABORT, OnUpdateFaxAbort)
    ON_COMMAND(ID_FAX_EVENT, OnFaxEvent)
    ON_UPDATE_COMMAND_UI(ID_FAX_EVENT, OnUpdateFaxEvent)
    ON_COMMAND(ID_FAX_REC, OnFaxRec)
    ON_UPDATE_COMMAND_UI(ID_FAX_REC, OnUpdateFaxRec)
    ON_COMMAND(ID_FAX_CONFIG, OnFaxConfig)
    ON_UPDATE_COMMAND_UI(ID_FAX_CONFIG, OnUpdateFaxConfig)
    ON_COMMAND(ID_PHONEBOOK_EDIT, OnPhonebookEdit)
    ON_COMMAND(ID_PHONEBOOK_EXPORT, OnPhonebookExport)
    ON_COMMAND(ID_PHONEBOOK_IMPORT, OnPhonebookImport)
    ON_UPDATE_COMMAND_UI(ID_FAX_BROOK, OnUpdateFaxPortBrook)
    ON_UPDATE_COMMAND_UI(ID_FAX_GAMMA, OnUpdateFaxPortGamma)
    ON_UPDATE_COMMAND_UI(IDM_DIALOGIC, OnUpdateDialogic)
    ON_UPDATE_COMMAND_UI(IDD_BICOM, OnUpdateBicom)
    ON_UPDATE_COMMAND_UI(IDD_CMTX, OnUpdateCMTX)
    ON_UPDATE_COMMAND_UI(IDD_NMS, OnUpdateNms)
#if defined(WIN32)
    ON_COMMAND(ID_FAX_BROOK, OnFaxPortBrook)
    ON_COMMAND(ID_FAX_GAMMA, OnFaxPortGamma)
    ON_COMMAND(IDM_DIALOGIC, OnOpenDialogic)
    ON_COMMAND(IDD_BICOM, OnOpenBicom)
    ON_COMMAND(IDD_CMTX, OnOpenCMTX)
    ON_COMMAND(IDD_NMS, OnOpenNms)
    ON_COMMAND(IDM_BROOK_DEBUG, OnDebugBrook)
    ON_UPDATE_COMMAND_UI(IDM_BROOK_DEBUG, OnUpdateDebugBrook)
	ON_COMMAND(IDM_FAXMANAGER, OnHideFaxmanager)
	ON_UPDATE_COMMAND_UI(IDM_FAXMANAGER, OnUpdateHideFaxmanager)
#endif
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// arrays of IDs used to initialize control bars

// toolbar buttons - IDs are command buttons
static UINT BASED_CODE buttons[] =
{
    // same order as in the bitmap 'toolbar.bmp'
    ID_FILE_OPEN,
    ID_FILE_SAVE,
    ID_SEPARATOR,

    ID_EDIT_COPY,
    ID_EDIT_PASTE,
    ID_SEPARATOR,

    ID_FAX_PORTSETUP,
    ID_FAX_PORT_CLOSE,
    ID_FAX_SEND,
    ID_FAX_REC,
    ID_SEPARATOR,

    IDM_SHOW_DPI,
	IDM_FITTOWIDTH,
    IDM_FITOWINDOW,
    IDM_CENTERIMAGE,
    ID_SEPARATOR,

    IDM_ZOOMIN,
    IDM_ZOOMOUT,
    IDM_MAGNIFY,
    IDM_ZOOM_MODE,
    ID_SEPARATOR,

    ID_VIEW_ANNOTATIONTOOLBAR,
    ID_SEPARATOR,

    IDM_PAGEFORWARD,
    IDM_PAGEBACKWAD,
    ID_SEPARATOR,

    IDM_ROTATE270,
    IDM_FLIPHORIZONTAL,
    IDM_FLIPVERTICAL,
    IDM_VIEW_INVERT,
    ID_SEPARATOR,

    ID_FILE_PRINT,
    IDM_DIMENSIONS,
    ID_SEPARATOR,

    ID_APP_EXIT,
    ID_SEPARATOR,

    ID_APP_ABOUT
};

static UINT BASED_CODE indicators[] =
{
    ID_SEPARATOR,           // status line indicator
    ID_INDICATOR_IMAGENO,
    ID_INDICATOR_IMAGETOTAL,
};



/////////////////////////////////////////////////////////////////////////////
// CMainFrame construction/destruction

CMainFrame::CMainFrame()
{
    m_hScanDIB = NULL;
}

CMainFrame::~CMainFrame()
{
    
}

int CMainFrame::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    if (CMDIFrameWnd::OnCreate(lpCreateStruct) == -1)
        return -1;

    //
    // Setting up toolbar.
    //
    if (!m_wndToolBar.Create(this) ||
        !m_wndToolBar.LoadBitmap(IDR_MAINFRAME) ||
        !m_wndToolBar.SetButtons(buttons,
          sizeof(buttons)/sizeof(UINT)))
    {
        TRACE("Failed to create toolbar\n");
        return -1;      // fail to create
    }
#ifdef WIN32
    m_wndToolBar.SetBarStyle(m_wndToolBar.GetBarStyle() | CBRS_TOOLTIPS );
#endif
    if (!m_wndStatusBar.Create(this) ||
        !m_wndStatusBar.SetIndicators(indicators,
          sizeof(indicators)/sizeof(UINT)))
    {
        TRACE("Failed to create status bar\n");
        return -1;      // fail to create
    }

    static  UINT    uPanelID, uPanelStyle, uPanelWidth;
    int     nIndex = m_wndStatusBar.CommandToIndex(ID_SEPARATOR);
    RECT    r;

    //
    // Setting status bar pane dimensions.
    //
    GetClientRect(&r);
    uPanelWidth = 30;
    m_wndStatusBar.SetPaneInfo(nIndex, ID_SEPARATOR, SBPS_POPOUT, 2*r.right/3);
    m_wndStatusBar.SetPaneInfo(nIndex, ID_SEPARATOR, SBPS_STRETCH, 2*r.right/3);

    nIndex = m_wndStatusBar.CommandToIndex(ID_INDICATOR_IMAGENO);

    m_wndStatusBar.SetPaneInfo(nIndex, ID_INDICATOR_IMAGENO, SBPS_NORMAL, uPanelWidth);
    m_wndStatusBar.SetPaneText(nIndex, "", TRUE);
#ifdef WIN32
        EnableDocking(CBRS_ALIGN_ANY);
#endif

    nIndex = m_wndStatusBar.CommandToIndex(ID_INDICATOR_IMAGETOTAL);

    m_wndStatusBar.SetPaneInfo(nIndex, ID_INDICATOR_IMAGETOTAL, SBPS_NORMAL, uPanelWidth);
    m_wndStatusBar.SetPaneText(nIndex, "", TRUE);
    ShowWindow(SW_MAXIMIZE);

    pApp->dlgEvent = new CFaxEvent(this);
    pApp->dlgEvent->ShowWindow(SW_HIDE);
    ShowWindow(SW_MAXIMIZE);
    if (GetFaxSystemDialogBox()) {
        ::SetParent(GetFaxSystemDialogBox(),m_hWnd);
    }
    m_TimerID = SetTimer(TIMER_ID_CHKOUTBOX,30000,NULL);

#ifdef _WIN32
    OSVERSIONINFO VersionInfo;
    VersionInfo.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
    GetVersionEx( &VersionInfo );

    m_dwPlatformId = VersionInfo.dwPlatformId;
    
#endif
    if(SetupFaxDriver(NULL) || SetFaxMessage(m_hWnd))
        AfxMessageBox("Setting fax driver has failed!");
#if defined(WIN32)
    pApp->BrooktroutChannels = GetChannelInfo();
    pApp->m_nGammaChannel = G_GetChannelNum();
    pApp->m_nDialogicBoard = D_GetBoardNum();
	pApp->m_nBicomBoard = BCM_GetBoardNum();
    pApp->m_nCmtxChannels = C_GetChannelNum();
    pApp->m_nNmsBoard = NMS_GetBoardNum();

#else
    pApp->BrooktroutChannels = NULL;
    pApp->m_nGammaChannel = 0;
    pApp->m_nDialogicBoard = 0;
	pApp->m_nBicomBoard = 0;
	pApp->m_nCmtxChannels = 0;
    pApp->m_nNmsBoard = 0;
	
#endif
    if ( GetProfileInt("StartUp", "PulseDial", 0) )
    SetRuningMode(RNM_HALTINFRAME);


    return 0;
}


/////////////////////////////////////////////////////////////////////////////
// CMainFrame diagnostics

#ifdef _DEBUG
void CMainFrame::AssertValid() const
{
    CMDIFrameWnd::AssertValid();
}

void CMainFrame::Dump(CDumpContext& dc) const
{
    CMDIFrameWnd::Dump(dc);
}

#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CMainFrame message handlers

//
// Update size of the status bar when the windows is resized.
//
void CMainFrame::OnSize(UINT nType, int cx, int cy)
{
    CMDIFrameWnd::OnSize(nType, cx, cy);

    // TODO: Add your message handler code here
    m_wndStatusBar.SetPaneInfo(m_wndStatusBar.CommandToIndex(ID_SEPARATOR),
        ID_SEPARATOR, SBPS_STRETCH, 2*cx/3);

}

///////////////////////////////////////////////////////////////////////////////
// Paste functions. (Edit Paste command)
///////////////////////////////////////////////////////////////////////////////
//
// Paste image to a new child window.
//
void CMainFrame::OnEditPaste()
{
    AfxGetApp()->OpenDocumentFile("Untitled");
}

void CMainFrame::OnUpdateEditPaste(CCmdUI* pCmdUI)
{
    pCmdUI->Enable(IsClipboardFormatAvailable(CF_DIB));

}

void CMainFrame::OnUpdateIndicatorImageno(CCmdUI* pCmdUI)
{
    pCmdUI->Enable(TRUE);
}

void CMainFrame::OnUpdateIndicatorImageTotal(CCmdUI* pCmdUI)
{
    pCmdUI->Enable(TRUE);
}

void CMainFrame::OnPaletteChanged(CWnd* pFocusWnd)
{
    CMDIFrameWnd::OnPaletteChanged(pFocusWnd);

    // always realize the palette for the active view
    CMDIChildWnd* pMDIChildWnd = MDIGetActive();
    if (pMDIChildWnd == NULL)
        return; // no active MDI child frame
    CView* pView = pMDIChildWnd->GetActiveView();

    // notify all child windows that the palette has changed
    SendMessageToDescendants(WM_DOREALIZE, (WPARAM)pView->m_hWnd);
}

BOOL CMainFrame::OnQueryNewPalette()
{
    CMDIChildWnd* pMDIChildWnd = MDIGetActive();
    if (pMDIChildWnd == NULL)
        return FALSE; // no active MDI child frame
    CView* pView = pMDIChildWnd->GetActiveView();

    // just notify the target view
    pView->SendMessage(WM_DOREALIZE, (WPARAM)pView->m_hWnd);
    return TRUE;
}

CImgDoc *CMainFrame::GetDocument()
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    CFrameWnd *frm = (CFrameWnd *)pApp->m_pMainWnd;
    CImgDoc *pDoc = NULL;
    if( frm ) {
        CFrameWnd *fa = frm->GetActiveFrame();
        if ( fa ) {
            CView *pw = fa->GetActiveView();
            if ( pw ) {
                pDoc = (CImgDoc *)pw->GetDocument();
            }
        }
    }
    return pDoc;
}

int CMainFrame::RecSaveInTiffFile(FAXOBJ FaxObj)
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    union TUFaxImage sFaxPage;
    TSFaxParam  sFaxParam;
    char        szTempFile[_MAX_PATH];
    BOOL        bAppend = FALSE;
    int         iError = 0;
    char        buf[150];

    GetFaxParam(FaxObj, &sFaxParam);
    if (sFaxParam.PageNum <=0 ) return 0;

    wsprintf(buf, "FAX received. Pages: %i", sFaxParam.PageNum);
    pApp->FaxEventText(-1, buf);
#ifndef WIN32
    GetTempFileName(pApp->szAppPath[0], &pApp->szAppPath[3], 0, szTempFile);
#else
    GetTempFileName(pApp->szAppPath, "" , 0, szTempFile);
#endif
    szTempFile[lstrlen(szTempFile)-3]= 0;
    lstrcat (szTempFile, "TIF");
    sFaxPage.File = szTempFile;

    for(int i = 0; i < sFaxParam.PageNum; i++)
    {
        iError = GetFaxImagePage(FaxObj, i, IMT_FILE_TIFF_G31D, &sFaxPage, bAppend);
        if(iError)
        {
            wsprintf(buf, "'GetFaxImagePage' error:%i %s", iError, MakeFERText(iError) );
            pApp->FaxEventText(-1, buf);
            break;
        }
        bAppend = TRUE;

        wsprintf(buf, "Get page: %i", i+1);
        pApp->FaxEventText(-1, buf);

    }
    pApp->OpenDocumentFile(sFaxPage.File);
    return iError;
}

int CMainFrame::RecSaveInFaxGroup(FAXOBJ FaxObj)
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    union TUFaxImage sFaxPage;
    TSFaxParam  sFaxParam;
    char        szTempFile[_MAX_PATH];
    BOOL        bAppend = FALSE;
    int         iError = 0;
    char        buf[150];

    GetFaxParam(FaxObj, &sFaxParam);
    if (sFaxParam.PageNum <=0 ) return 0;

    wsprintf(buf, "FAX received. Pages: %i", sFaxParam.PageNum);
    pApp->FaxEventText(-1, buf);

    pApp->OnFileNew();

    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
        pApp->FaxEventText(-1, "No active document");

    for(int i = 0; i < sFaxParam.PageNum; i++)
    {
    #ifndef WIN32
        GetTempFileName(pApp->szAppPath[0], &pApp->szAppPath[3], 0, szTempFile);
    #else
        GetTempFileName(pApp->szAppPath, "", 0, szTempFile);
    #endif
        szTempFile[lstrlen(szTempFile)-3]= 0;
        lstrcat (szTempFile, "TIF");
        sFaxPage.File= szTempFile;
        iError = GetFaxImagePage(FaxObj, i, IMT_FILE_TIFF_G31D, &sFaxPage, bAppend);
        if(iError)
        {
            wsprintf(buf, "'GetFaxImagePage' error: %i %s", iError, MakeFERText(iError) );
            pApp->FaxEventText(-1, buf);
            break;
        }

        wsprintf(buf, "Get page: %i", i+1);
        pApp->FaxEventText(-1, buf);

        if(pDoc)
        {
            pDoc->arName.Add(szTempFile);
            pDoc->arStat.Add(STAT_MONO);
            pDoc->arType.Add(FORMAT_TIFF);
        }
    }

    if(pDoc)
    {
        CString str ;
        int     ln  ;
        pDoc->UpdateAllViews(NULL, HINT_NEWGROUP);
        if ( pDoc->arName.GetSize() ) {
            str = pDoc->arName.GetAt(0);
        }
        ln = str.GetLength();
        if(ln>0)
        {
            const char *pFirst = str.GetBuffer(ln+1);
            pDoc->LoadImage(pFirst, 0);
        }
    }

    return iError;
}

int CMainFrame::RecBFT(FAXOBJ FaxObj)
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    union TUFaxImage sFaxPage;
    TSFaxParam      sFaxParam;
    TCBinaryParam   BftObj;
    CString     newName;
    int         iError = 0;
    BOOL        bAppend = FALSE;
    char        buf[250];
    char        BfdFileName[_MAX_PATH];
    char        appref[50];
    BOOL        bGroup1 = FALSE;
    BOOL        bGroup2 = FALSE;
    long        lError = 0;

    GetFaxParam(FaxObj, &sFaxParam);
    if (sFaxParam.PageNum <=0 ) return 0;

    pApp->OnFileNew();

    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
        pApp->FaxEventText(-1, "No active document");


    wsprintf(buf, "BFT file received. Pages: %i", sFaxParam.PageNum);
    pApp->FaxEventText(-1, buf);

    sFaxPage.BftObj = &BftObj;

    for(int i = 0; i < sFaxParam.PageNum; i++)
    {
        iError = GetFaxImagePage(FaxObj, i, IMT_BFTOBJ, &sFaxPage, bAppend);
        if(iError)
        {
            wsprintf(buf, "'GetFaxImagePage' error: %i %s", iError, MakeFERText(iError) );
            pApp->FaxEventText(-1, buf);
            break;
        }

        wsprintf(buf, "Get BFT page: %i", i+1);
        pApp->FaxEventText(-1, buf);

        BfdFileName[0] = 0;
        BftObj.ReadValue(BFD_filename, (LPBYTE)BfdFileName, sizeof(BfdFileName));

        if(BfdFileName[0] == 0)
        {
            #ifndef WIN32
                GetTempFileName(pApp->szAppPath[0], &pApp->szAppPath[3], 0, BfdFileName);
            #else
                GetTempFileName(pApp->szAppPath, "", 0, BfdFileName);
            #endif
            wsprintf(buf, "Tmp file has generated for BFT page: %i, filename: %s", i+1, (LPSTR)BfdFileName);
            pApp->FaxEventText(-1, buf);
        }
        else
        {
            char szTemp[_MAX_PATH+5];
            char tmpDrive[_MAX_DRIVE+5];
            char tmpDir[_MAX_DIR+5];
            char fName[_MAX_FNAME+5];
            char fExt[_MAX_EXT+5];
            #ifndef WIN32
                GetTempFileName(pApp->szAppPath[0], &pApp->szAppPath[3], 0, szTemp);
            #else
                GetTempFileName(pApp->szAppPath, "", 0, szTemp);
            #endif
            _splitpath(szTemp, tmpDrive, tmpDir, NULL, NULL);
            _splitpath(BfdFileName, NULL, NULL, fName, fExt);
            _makepath(BfdFileName, tmpDrive, tmpDir, fName, fExt);
        }

        lError = BftObj.ReadValue(BFD_data_file_content_FILE, (LPBYTE)BfdFileName, lstrlen(BfdFileName)+1);
        if(lError)
        {
            wsprintf(buf, "Read binary data length: %li", lError);
            pApp->FaxEventText(-1, buf);
        }

        wsprintf(buf, "Get BFT page: %i, filename: %s", i+1, (LPSTR)BfdFileName);
        pApp->FaxEventText(-1, buf);

        appref[0] = 0;
        BftObj.ReadValue(BFD_application_reference, (LPBYTE)appref, sizeof(appref));

        bGroup1 = FALSE;
        if( stricmp(appref, "IMAGE")==0 )
            bGroup1 = TRUE;

        if(bGroup1 && pDoc)
        {
            bGroup2 = TRUE;
            pDoc->arName.Add(BfdFileName);
            pDoc->arStat.Add(STAT_BFT);
            pDoc->arType.Add(0);
        }

    }

    if(bGroup2 && pDoc)
    {
        pDoc->UpdateAllViews(NULL, HINT_NEWGROUP);
        CString str = pDoc->arName.GetAt(0);
        int ln = str.GetLength();
        if(ln)
        {
            const char *pFirst = str.GetBuffer(ln+1);
            pDoc->LoadImage(pFirst, 0);
        }
    }

    return iError;
}

void CMainFrame::ReadFaxQueueu()
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    FAXOBJ  FaxObj;
    CLogs*  RecLog ;
    CString szName;
    HFILE   hf;
    TSFaxHeader header;
    TSFaxParam sFaxParam;
    time_t  CurTime = time( NULL );
    struct tm ctm;
    TSSessionParameters Param;

    RecLog = (CLogs*) pApp->LogDocument[LGT_RECEIVE] ;
    FaxObj= GetObjFromReceiveQueue();

    while ( FaxObj ) {
        hf = pApp->GetFileName( RecLog->m_szActDir, CString("tmp"), szName );
        FaxObj->GetParam( sFaxParam );
        memset( &header, 0, sizeof(TSFaxHeader) );
        header.bType        = FaxObj->GetFaxType();
        header.wPageNum     = sFaxParam.PageNum;
        header.bResolut     = (BYTE)sFaxParam.Resolut;
        header.bWidth       = (BYTE)sFaxParam.Width;
        header.bLength      = (BYTE)sFaxParam.Length;
        header.bCompress    = (BYTE)sFaxParam.Compress;
        header.bBinary      = (BYTE)sFaxParam.Binary;
        header.bBitOrder    = (BYTE)sFaxParam.BitOrder;
        header.bSend        = FALSE;
        header.wRetry       = 0;
        header.wInterval    = 0;
        header.dwTransmitTime = 0;
        header.wSpeed       = 0;
        header.wRefCnt      = 0;
        _fstrcpy( &header.RemoteNumber[0], "" );
        _fstrcpy( &header.szKey[0], "" );
        _fstrcpy( &header.szSubAddr[0], "" );
        _fstrcpy( &header.szName[0], sFaxParam.RemoteNumber);
        _fstrcpy( &header.szCompany[0], "" );
        FaxObj->GetSessionParam( Param );
        if ( (Param.TStatus==TRM_NONE) || (Param.TStatus==TRM_NORMAL) )
            header.wStatus = FXS_RECEIVED ;
        else
            header.wStatus = FXS_RECEIVEERROR ;

        ctm = *localtime( &CurTime );
        pApp->SetFaxTime( &header.CreateTime, &ctm);
        pApp->SetFaxTime( &header.SendTime, &ctm);

        FaxObj->WriteHeader( hf, &header );
        FaxObj->WriteImgData( hf );
//        pApp->ShowFaxBlock(LGT_RECEIVE, ID, TRUE, hf );
        _lclose( hf );

        FaxObj = GetNextFaxQueueObj( FaxObj );
    }
    RecLog->FillViewLog(TRUE);

    for( FaxObj= GetObjFromReceiveQueue(); FaxObj; FaxObj = GetObjFromReceiveQueue())
        ClearFaxObj(FaxObj);
}

LRESULT CMainFrame::FaxMsg(WPARAM wParam, LPARAM lParam)
{
    CImgApp     *pApp = (CImgApp *)AfxGetApp();
    CFaxEvent   *ev = pApp->dlgEvent;
//    CString     szFName;
    CLogs       *SendLog, *OutBox;
    FAXOBJ      Fax;
    TSSessionParameters Param;

    if(ev)
        ev->RecFaxMessage(wParam, lParam);
    switch ( wParam ) {
        case MFX_RECEIVED:
            OutputDebugString( "MFX_RECEIVED received.\n" );
            ReadFaxQueueu();
            break;
        case MFX_HIDEFAXMANAGER:
            pApp->m_bFaxManagerVisible=BOOL(lParam);
            break;

        case MFX_ENDSEND:
            OutputDebugString( "MFX_ENDSEND received.\n" );
            Fax = (FAXOBJ)lParam ;
            SendLog = (CLogs*) pApp->LogDocument[LGT_SEND] ;
            OutBox  = (CLogs*) pApp->LogDocument[LGT_OUTBOX ] ;
            if ( OutBox && SendLog && Fax ) {
                CFile   fOut;
                CString szName;
                HFILE   hf;
                CFileException e;
                TSFaxHeader header;
                time_t    lSendTime;
                LPSTR   lpName;

                TSSessionParameters Param;
                
                time( &lSendTime );
                if ( Fax->UserData ) { // anything in the Out Box ?
                    lpName = (LPSTR)GlobalLock( (HGLOBAL)Fax->UserData );
                    if ( fOut.Open( lpName, CFile::modeRead, &e ) == 0 )
                        break;

                    if ( fOut.Read( &header, sizeof(TSFaxHeader) ) != sizeof(TSFaxHeader) )
                        break;
                    fOut.Close();
                    _unlink( lpName );
                    GlobalUnlock( (HGLOBAL)Fax->UserData );
                    GlobalFree( (HGLOBAL)Fax->UserData );
                    OutBox->FillViewLog( TRUE );
                }
                else {
                    TSFaxParam sFaxParam;

                    Fax->GetParam( sFaxParam );
                    memset( &header, 0, sizeof(TSFaxHeader) );
                    header.bType        = Fax->GetFaxType();
                    header.wPageNum     = sFaxParam.PageNum;
                    header.bResolut     = (BYTE)sFaxParam.Resolut;
                    header.bWidth       = (BYTE)sFaxParam.Width;
                    header.bLength      = (BYTE)sFaxParam.Length;
                    header.bCompress    = (BYTE)sFaxParam.Compress;
                    header.bBinary      = (BYTE)sFaxParam.Binary;
                    header.bBitOrder    = (BYTE)sFaxParam.BitOrder;
                    header.bSend        = sFaxParam.Send;
                    header.wRetry       = 0;
                    header.wInterval    = 0;
                    header.dwTransmitTime = 0;
                    header.wSpeed       = 0;
                    header.wRefCnt      = 0;
                    _fstrcpy( &header.RemoteNumber[0], &sFaxParam.RemoteNumber[0] );
                    _fstrcpy( &header.szKey[0], "" );
                    _fstrcpy( &header.szName[0], "" );
                    _fstrcpy( &header.szSubAddr[0], "" );
                    _fstrcpy( &header.szCompany[0], "" );
                }
                pApp->SetFaxTime( &header.SendTime, localtime( &lSendTime ) );
                header.CreateTime = header.SendTime;
                Fax->GetSessionParam( Param );
                if ( (Param.TStatus==TRM_NONE) || (Param.TStatus==TRM_NORMAL) )
                    header.wStatus = FXS_SENDED ;
                else
                    header.wStatus = FXS_SENDERROR ;

                Fax->GetSessionParam(Param);
                _fstrcpy( &header.szName[0], Param.RemoteID );

                hf = pApp->GetFileName( SendLog->m_szActDir, CString("tmp"), szName );
                Fax->WriteHeader( hf, &header );
                Fax->WriteImgData( hf );
                _lclose( hf );

                SendLog->FillViewLog(FALSE);
                ClearFaxObj(Fax);
            }
            break;
        case MFX_DIAL:
            OutputDebugString( "MFX_DIAL received.\n" );
            break;
        case MFX_HANGUP:
            OutputDebugString( "MFX_HANGUP received.\n" );
            break;
        case MFX_ANSWER:
            OutputDebugString( "MFX_ANSWER received.\n" );
            break;
        case MFX_DONOTSEND:
            OutputDebugString( "MFX_DONOTSEND received.\n" );
            break;
        case MFX_MODEMTYPE:
            OutputDebugString( "MFX_MODEMTYPE received.\n" );
            break;
        case MFX_TERMINATE:
            OutputDebugString( "MFX_TERMINATE received.\n" );
            break;
        case MFX_RING:
            OutputDebugString( "MFX_RING received.\n" );
            break;
    }
    return 0l;
}



LRESULT CMainFrame::WindowProc(UINT message, WPARAM wParam, LPARAM lParam)
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    if(message == pApp->nMessage)
    {
        return FaxMsg(wParam, lParam);
    }

    if(message == WM_DDE_INITIATE)
    {
        return OnWmDDEInitiate(wParam, lParam);
    }

    return CMDIFrameWnd::WindowProc(message, wParam, lParam);
}

void CMainFrame::OnDestroy()
{
    CMDIFrameWnd::OnDestroy();

    KillTimer(m_TimerID);
    CImgApp *pApp = (CImgApp *)AfxGetApp();

    for(int i=0;i<MAX_FAXPORTS;i++){
        if ( pApp->FaxPorts[i] ) {
            if ( pApp->FaxPorts[i]->IsOpen() ) {
                pApp->FaxPorts[i]->AbortFax();
            }
        }
    }

    if(pApp->dlgEvent) {
        delete pApp->dlgEvent;
        pApp->dlgEvent = NULL; }
    KillFaxMessage(this->m_hWnd);
    EndOfFaxDriver(TRUE);
#ifdef _WIN32

#endif
}

void CMainFrame::OnFaxPortSetup()
{
    CDlgFaxPortSetup dlgFaxPortSetup;

    dlgFaxPortSetup.DoModal();
}

void CMainFrame::OnUpdateFaxPortSetup(CCmdUI* pCmdUI)
{
    CImgApp         *pApp = (CImgApp *)AfxGetApp();
    BOOL bEnable = FALSE;

    for(int i=0;i<MAX_FAXPORTS;i++) {
        if (!pApp->FaxPorts[i]) {
            bEnable = TRUE ;
        } else {
            if (!pApp->FaxPorts[i]->IsOpen()){
                bEnable = TRUE ;
                break ;
            }
        }
    }
    pCmdUI->Enable(bEnable) ;
}

void CMainFrame::OnUpdateFaxPortClose(CCmdUI* pCmdUI)
{
    pCmdUI->Enable( IsAnyPortOpen(TRUE, FALSE) );
}

void CMainFrame::OnFaxPortClose()
{
    CDlgFaxClose dlgCloseFaxPort;

    dlgCloseFaxPort.DoModal();
}

void CMainFrame::OnFaxAbort()
{
    CDlgAbortFax dlgAbortFax;

    dlgAbortFax.DoModal();
}

void CMainFrame::OnUpdateFaxAbort(CCmdUI* pCmdUI)
{
    pCmdUI->Enable( IsAnyPortOpen(FALSE, TRUE) );
}


void CMainFrame::OnFaxEvent()
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    pApp->bShowEvent = pApp->bShowEvent ? FALSE : TRUE;
    int nShow = (int)(pApp->bShowEvent ? SW_NORMAL : SW_HIDE);
    CFaxEvent *wnd = pApp->dlgEvent;
    if(wnd)
        wnd->ShowWindow(nShow);
}

void CMainFrame::OnUpdateFaxEvent(CCmdUI* pCmdUI)
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();

    pCmdUI->Enable( TRUE );
    int nChk = (int)(pApp->bShowEvent ? 1 : 0);
    pCmdUI->SetCheck(nChk);
}

void CMainFrame::OnFaxRec()
{
    CFaxRec dlgFaxRec;

    dlgFaxRec.DoModal();

}

void CMainFrame::OnUpdateFaxRec(CCmdUI* pCmdUI)
{
    pCmdUI->Enable( IsAnyPortOpen(FALSE, FALSE) );

}

void CMainFrame::OnFaxConfig()
{
    // TODO: Add your command handler code here
    CFaxConfig dlgFaxConfig;

    dlgFaxConfig.DoModal();

}

void CMainFrame::OnUpdateFaxConfig(CCmdUI* pCmdUI)
{
    pCmdUI->Enable( TRUE );

}

LRESULT CMainFrame::OnWmDDEInitiate(WPARAM wParam, LPARAM lParam)
{
    ATOM aKey = LOWORD(lParam);
    ATOM aGrp = HIWORD(lParam);
    char grpfile[200];
    char fext[_MAX_EXT];
    UINT  hh;
    char buf[150];

    MessageBeep(0);

    CImgApp *pApp = (CImgApp *)AfxGetApp();

    grpfile[0] = 0;

    hh = GlobalGetAtomName(aGrp, grpfile, sizeof(grpfile));
    if(hh==0 || grpfile[0]==0)
    {
        pApp->FaxEventText(-1, "'GlobalGetAtomName' error");
        return 0l;
    }

    _splitpath(grpfile, NULL, NULL, NULL, fext);
    if( stricmp(fext, ".FAX") )
    {
        wsprintf(buf, "Fax name extension must be .FAX  (%s)", (LPSTR)grpfile);
        pApp->FaxEventText(-1, buf);
        return 0l;
    }

    wsprintf(buf, "Get a group file from printer driver: %s", (LPSTR)grpfile);
    pApp->FaxEventText(-1, buf);
    pApp->OpenDocumentFile(grpfile);
    wParam = wParam;
    return 0l;
}


BOOL CMainFrame::IsAnyPortOpen(BOOL bClose, BOOL bAbort)
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();

    TSPortStatus st;
    BOOL bOpen;

    for(int i=0;i<MAX_FAXPORTS;i++)
    {
        if (pApp->FaxPorts[i]==NULL)
        {
            continue;
        }

        bOpen = pApp->FaxPorts[i]->IsOpen();
        GetPortStatus(pApp->FaxPorts[i], &st);

        if(bAbort && bOpen)
        {
            return TRUE;
        }

        if(bClose && st.Status==CST_NOTHING)
        {
            return TRUE;
        }

        if(bOpen && st.Status==CST_NOTHING)
        {
            return TRUE;
        }

    }
    return FALSE ;
}


void CMainFrame::OnPhonebookEdit()
{
    CPhbookEdit pedlg;

    BOOL bOK = pedlg.PETestExist1();

    if ( bOK )
        pedlg.DoModal();
}

void CMainFrame::OnPhonebookExport()
{
    CPhbookEdit pedlg;
    pedlg.PEExport();
}

void CMainFrame::OnPhonebookImport()
{
    CPhbookEdit pedlg;
    pedlg.PEImport();
}

void CMainFrame::OnTimer(UINT nIDEvent)
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
//    if ( pApp->nInsideDlg )
//        return;

    CMDIFrameWnd::OnTimer(nIDEvent);
    CLogs*   OutBox ;

    OutBox = (CLogs*) pApp->LogDocument[LGT_OUTBOX];
    if ( nIDEvent == TIMER_ID_CHKOUTBOX ) {
        if ( OutBox ) {
            OutBox->CheckOutBox();
        }
    }
}

#if defined(WIN32)
void CMainFrame::OnOpenDialogic()
{
    COpenDialogic dlgOpenDialogic;

    dlgOpenDialogic.DoModal();
}

void CMainFrame::OnOpenBicom()
{
    COpenBicom dlgOpenBicom;

    dlgOpenBicom.DoModal();
}


void CMainFrame::OnOpenCMTX()
{
    COpencmtx dlgOpenCmtx;

    dlgOpenCmtx.DoModal();
}


void CMainFrame::OnOpenNms()
{
    CDlgNms dlgOpenNms;

    dlgOpenNms.DoModal();
}

void CMainFrame::OnFaxPortBrook()
{
    CBOpen dlgOpenBrooktrout;

    dlgOpenBrooktrout.DoModal();
}

void CMainFrame::OnFaxPortGamma()
{
    CDlgGOpen dlgOpenGamma;

    dlgOpenGamma.DoModal();
}

void CMainFrame::OnDebugBrook()
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    if ( pApp->BrooktroutChannels && pApp->BrooktroutChannels[0] ) {
        pApp->m_DebugBrook = (pApp->m_DebugBrook?0:1);
        if ( pApp->m_DebugBrook )
            EnableDebug( DBG_ALL );
        else
            EnableDebug( DBG_NONE );
    }
}

void CMainFrame::OnUpdateDebugBrook(CCmdUI* pCmdUI)
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    BOOL bEnable = FALSE;

    if ( pApp->BrooktroutChannels && pApp->BrooktroutChannels[0] ) {
        bEnable = TRUE;
        int nChk = (int)(pApp->m_DebugBrook ? 1 : 0);
        pCmdUI->SetCheck(nChk);
    }
    pCmdUI->Enable(bEnable) ;
}

#endif

void CMainFrame::OnUpdateFaxPortBrook(CCmdUI* pCmdUI)
{
    CImgApp         *pApp = (CImgApp *)AfxGetApp();
    BOOL bEnable = FALSE;

    if ( pApp->BrooktroutChannels && pApp->BrooktroutChannels[0] )
                bEnable = TRUE ;
    pCmdUI->Enable(bEnable) ;
}

void CMainFrame::OnUpdateDialogic(CCmdUI* pCmdUI)
{
    CImgApp* pApp = (CImgApp *)AfxGetApp();
    BOOL bEnable = FALSE;

    if ( pApp->m_nDialogicBoard )
        bEnable = TRUE;

    pCmdUI->Enable(bEnable) ;
}

void CMainFrame::OnUpdateBicom(CCmdUI* pCmdUI)
{
    CImgApp* pApp = (CImgApp *)AfxGetApp();
    BOOL bEnable = FALSE;

    if ( pApp->m_nBicomBoard )
        bEnable = TRUE;

    pCmdUI->Enable(bEnable) ;
}

void CMainFrame::OnUpdateCMTX(CCmdUI* pCmdUI)
{
    CImgApp* pApp = (CImgApp *)AfxGetApp();
    BOOL bEnable = FALSE;

    if ( pApp->m_nCmtxChannels )
        bEnable = TRUE;

    pCmdUI->Enable(bEnable) ;
}


void CMainFrame::OnUpdateNms(CCmdUI* pCmdUI)
{
    CImgApp* pApp = (CImgApp *)AfxGetApp();
    BOOL bEnable = FALSE;

    if ( pApp->m_nNmsBoard )
        bEnable = TRUE;
    pCmdUI->Enable(bEnable) ;
}

void CMainFrame::OnUpdateFaxPortGamma(CCmdUI* pCmdUI)
{
    CImgApp         *pApp = (CImgApp *)AfxGetApp();
    BOOL bEnable = FALSE;

    if ( pApp->m_nGammaChannel != 0 ) 
                bEnable = TRUE ;
    
    pCmdUI->Enable(bEnable) ;
}

CStatusBar *GetGlobalStatusBar ()
{
    return ((CMainFrame *)(AfxGetApp()->m_pMainWnd))->GetStatusBarPtr();
}

void CMainFrame::OnHideFaxmanager() 
{
    CImgApp* pApp = (CImgApp *)AfxGetApp();  
    FARPROC fp;
    HANDLE lib=LoadLibrary("faxmng32.dll");
    if(lib<=INVALID_HANDLE)return;
    fp=GetProcAddress((HMODULE)lib, "SetDialogMode");
    if(!fp) {
        FreeLibrary((HMODULE)lib);
        return;
    }
    pApp->m_bFaxManagerVisible=!pApp->m_bFaxManagerVisible;
    ((void(CALLBACK*)(BOOL))fp)(pApp->m_bFaxManagerVisible);
    FreeLibrary((HMODULE)lib);
    return;
}

void CMainFrame::OnUpdateHideFaxmanager(CCmdUI* pCmdUI) 
{
    CImgApp* pApp = (CImgApp *)AfxGetApp();  
    CMenu *menu;
    menu = GetMenu();
    if(menu) {
        if(!pApp->m_bFaxManagerVisible) {
            menu->ModifyMenu(IDM_FAXMANAGER, MF_STRING, IDM_FAXMANAGER,  "&Show Fax Manager");
        }
        else {
            menu->ModifyMenu(IDM_FAXMANAGER, MF_STRING, IDM_FAXMANAGER,  "&Hide Fax Manager");
        }
    }

    pCmdUI->Enable( TRUE ) ;    	
}
