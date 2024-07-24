// MainFrm.cpp : implementation of the CMainFrame class
//

#include "stdafx.h"
#include "Voice Mail Sample.h"
#include "Voice Mail SampleDoc.h"
#include "OpenComPort.h"
#include "BrookOpen.h"
#include "DialogicOpen.h"
#include "NMSOpen.h"
#include "codec.h"
#include "Splash.h"
#include "DlgAutoAnswerCfg.h"

#include "MainFrm.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMainFrame

IMPLEMENT_DYNAMIC(CMainFrame, CMDIFrameWnd)

BEGIN_MESSAGE_MAP(CMainFrame, CMDIFrameWnd)
	//{{AFX_MSG_MAP(CMainFrame)
	ON_WM_CREATE()
	ON_WM_DESTROY()
	ON_UPDATE_COMMAND_UI(ID_VOICEFAX_OPENPORT_COMPORT, OnUpdatePortOpen)
	ON_COMMAND(ID_VOICEFAX_OPENPORT_COMPORT, OnVoicefaxOpenportComport)
	ON_COMMAND(ID_VOICEFAX_OPENPORT_BROOKTROUTCHANNEL, OnVoicefaxOpenportBrooktroutchannel)
	ON_COMMAND(ID_VIEW_RECEIVEDFAXES, OnViewReceivedfaxes)
	ON_COMMAND(ID_VOICEFAX_OPENPORT_DIALOGICCHANNEL, OnVoicefaxOpenportDialogicchannel)
	ON_COMMAND(ID_VOICEFAX_OPENPORT_NMS, OnVoicefaxOpenportNms)
	ON_WM_SIZE()
	ON_WM_MOVE()
	ON_COMMAND(ID_ANSWERPHONE_CONFIG, OnAnswerphoneConfig)
    ON_REGISTERED_MESSAGE(VoiceMsg,OnVoiceMsg)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

static UINT indicators[] =
{
	ID_SEPARATOR,           // status line indicator
	ID_INDICATOR_CAPS,
	ID_INDICATOR_NUM,
	ID_INDICATOR_SCRL,
};

/////////////////////////////////////////////////////////////////////////////
// CMainFrame construction/destruction

CMainFrame::CMainFrame()
{
	// TODO: add member initialization code here
	
}

CMainFrame::~CMainFrame()
{
}

int CMainFrame::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if (CMDIFrameWnd::OnCreate(lpCreateStruct) == -1)
		return -1;
	
	if (!m_wndToolBar.Create(this) ||
		!m_wndToolBar.LoadToolBar(IDR_MAINFRAME))
	{
		TRACE0("Failed to create toolbar\n");
		return -1;      // fail to create
	}

	if (!m_wndStatusBar.Create(this) ||
		!m_wndStatusBar.SetIndicators(indicators,
		  sizeof(indicators)/sizeof(UINT)))
	{
		TRACE0("Failed to create status bar\n");
		return -1;      // fail to create
	}

	// TODO: Remove this if you don't want tool tips or a resizeable toolbar
	m_wndToolBar.SetBarStyle(m_wndToolBar.GetBarStyle() |
		CBRS_TOOLTIPS | CBRS_FLYBY | CBRS_SIZE_DYNAMIC);

	// TODO: Delete these three lines if you don't want the toolbar to
	//  be dockable
	m_wndToolBar.EnableDocking(CBRS_ALIGN_ANY);
	EnableDocking(CBRS_ALIGN_ANY);
	DockControlBar(&m_wndToolBar);

    StartCODEC(NULL,THREAD_PRIORITY_BELOW_NORMAL);
    SetupFaxDriver(NULL);
	SetupVoiceDriver(NULL);
    SetRuningMode(RNM_ALWAYSFREE);
    SetFaxMessage(m_hWnd);

	// CG: The following line was added by the Splash Screen component.
	CSplashWnd::ShowSplashScreen(this);
	return 0;
}

BOOL CMainFrame::PreCreateWindow(CREATESTRUCT& cs)
{
CRect rect = theApp.m_rectInitialFrame;

	if (rect.Width() > 0 && rect.Height() > 0)
	{
		// make sure window will be visible
		CDisplayIC dc;
		CRect rectDisplay(0, 0, dc.GetDeviceCaps(HORZRES), 
			dc.GetDeviceCaps(VERTRES));
		if (rectDisplay.PtInRect(rect.TopLeft()) && 
			rectDisplay.PtInRect(rect.BottomRight()))
		{
			cs.x = rect.left;
			cs.y = rect.top;
			cs.cx = rect.Width();
			cs.cy = rect.Height();
		}
	}

    return CMDIFrameWnd::PreCreateWindow(cs);
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

long CMainFrame::OnVoiceMsg(WPARAM event,LPARAM lParam)
{
	if( event >= MFX_VOICE_CONNECT && event <= MFX_DTMF_STAR )
	// VOICE C++ events
	{
    MODEMOBJ Modem = (MODEMOBJ)lParam;

        if( Modem == theApp.GetOpenModem() )
        {
            switch( Modem->GetModemType() )
            {
            case    MOD_CONEXANT_HCF:
            case    MOD_STANDARD_ROCKWELL:
            case    MOD_USR_SPORSTER:
			case    MOD_LUCENT:
			case    MOD_CIRRUSLOGIC:
            {
                COpenComPort *pOpen = (COpenComPort*)Modem->GetModemLong();
                pOpen->OnVoiceMsg(Modem,event);
            }
                break;

            case    MOD_DIALOGIC:
            {
                CDialogicOpen *pOpen = (CDialogicOpen*)Modem->GetModemLong();
                pOpen->OnVoiceMsg(event);
            }
                break;

            case    MOD_BROOKTROUT:
            {
                CBrookOpen *pOpen = (CBrookOpen*)Modem->GetModemLong();
                pOpen->OnVoiceMsg(event);
            }
                break;

            case    MOD_NMS:
            {
                CNMSOpen *pOpen = (CNMSOpen*)Modem->GetModemLong();
                pOpen->OnVoiceMsg(event);
            }
            break;

            }
        }
        else
        {
        CVoiceMailSampleDoc *pDoc = (CVoiceMailSampleDoc*)Modem->GetModemLong();

            pDoc->OnVoiceMsg(event);
        }
    }
	else if( event >= MFX_RECEIVED && event <= MFX_IDLE )
	// FAX C++ events
	{
        bool	bProcessed = false;

        DEBUGMSG("Fax C++ msg: [%d]", event);
        switch( event )
        {
        case	MFX_STARTRECEIVE:
        case	MFX_STARTSEND:
        case	MFX_IDLE:
        case	MFX_TERMINATE:
            {
            MODEMOBJ	Modem = (MODEMOBJ)GetUserLongPort( (PORTFAX)lParam );
                ASSERT(Modem);
            CVoiceMailSampleDoc *pDoc = (CVoiceMailSampleDoc*)Modem->GetModemLong();
                ASSERT(pDoc);

                DEBUGMSG("Event: [0x%x]", event);
                pDoc->OnVoiceMsg(event);
            }
            break;

        case    MFX_RECEIVED:
        case    MFX_ENDSEND:
            {
		    TSSessionParameters	session;
            PORTFAX             FaxPort;
            MODEMOBJ	        Modem;
            CVoiceMailSampleDoc *pDoc;

                // the following steps are required to
                // gain the pointer to the CVoiceMailSampleDoc* object
                // that is receiving the this fax.
			    DEBUGMSG("MFX_RECEIVED");
			    bProcessed = true;

			    ((FAXOBJ)lParam)->GetSessionParam(session);

                FaxPort = session.FaxPort;
                ASSERT(FaxPort);

                Modem = (MODEMOBJ)GetUserLongPort( FaxPort );
                ASSERT(Modem);

                pDoc = (CVoiceMailSampleDoc*)Modem->GetModemLong();
                ASSERT(pDoc);

                if( event == MFX_RECEIVED )
                {
                    pDoc->OnFaxReceived((FAXOBJ)lParam);
                }
                else
                {
                    pDoc->OnVoiceMsg(event);
                }
            }
            break;
        }
    }

    return 0;
}

void CMainFrame::OnDestroy() 
{
	CMDIFrameWnd::OnDestroy();
	
    KillFaxMessage(m_hWnd);
	EndOfVoiceDriver( TRUE );
    EndOfFaxDriver( TRUE );
    TerminateCODEC();
}

void CMainFrame::OnUpdatePortOpen(CCmdUI* pCmdUI) 
{
	// TODO: Add your command update UI handler code here
	
}

void CMainFrame::OnVoicefaxOpenportComport() 
{
COpenComPort dlg(this);

    if( dlg.DoModal() == IDOK )
    {
        CreateNewDoc();
    }
}

void CMainFrame::OnVoicefaxOpenportBrooktroutchannel() 
{
CBrookOpen dlg(this);

    if( dlg.DoModal() == IDOK )
    {
        CreateNewDoc();
    }
}
    
void CMainFrame::CreateNewDoc()
{
POSITION pos = theApp.GetFirstDocTemplatePosition();
    ASSERT(pos);
CDocTemplate *pDocTemp = theApp.GetNextDocTemplate(pos);
    ASSERT(pDocTemp);
CVoiceMailSampleDoc *pDoc = (CVoiceMailSampleDoc*)pDocTemp->OpenDocumentFile(NULL);
    ASSERT(pDoc);
MODEMOBJ    Modem = theApp.GetOpenModem();
    ASSERT(Modem);

    theApp.SetOpenModem(NULL);

    pDoc->SetModem(Modem);
}

void CMainFrame::OnViewReceivedfaxes() 
{
CFileDialog dlgOpen(TRUE);
char        szFile[MAX_PATH];
char        szInitDir[MAX_PATH];

    *szFile = 0;
    sprintf(szInitDir,"%s\\Fax.in",g_szExePath);

    dlgOpen.m_ofn.hwndOwner = m_hWnd;
    dlgOpen.m_ofn.lpstrFilter = "TIFF Image (*.tif)\0*.tif\0";
    dlgOpen.m_ofn.lpstrFile = szFile;
    dlgOpen.m_ofn.lpstrInitialDir = szInitDir;
    dlgOpen.m_ofn.lpstrDefExt = "tif";
    dlgOpen.m_ofn.lpstrTitle = "Load Received Fax Document";

    if( dlgOpen.DoModal() == IDOK )
    {
    POSITION pos = theApp.GetFirstDocTemplatePosition();
        ASSERT(pos);
    CDocTemplate *pDocTemp = theApp.GetNextDocTemplate(pos);
        ASSERT(pDocTemp);
        pDocTemp = theApp.GetNextDocTemplate(pos);
        pDocTemp->OpenDocumentFile(szFile);
    }
}

void CMainFrame::OnVoicefaxOpenportDialogicchannel() 
{
CDialogicOpen   dlg(this);

    if( dlg.DoModal() == IDOK )
    {
        CreateNewDoc();
    }
}

void CMainFrame::OnVoicefaxOpenportNms() 
{
CNMSOpen   dlg(this);

    if( dlg.DoModal() == IDOK )
    {
        CreateNewDoc();
    }
}

void CMainFrame::OnSize(UINT nType, int cx, int cy) 
{
	CMDIFrameWnd::OnSize(nType, cx, cy);
	
	theApp.m_bMaximized = (nType == SIZE_MAXIMIZED);
	if (nType == SIZE_RESTORED)
		GetWindowRect(theApp.m_rectInitialFrame);
}

void CMainFrame::OnMove(int x, int y) 
{
	CMDIFrameWnd::OnMove(x, y);
	
	WINDOWPLACEMENT wp;
	wp.length = sizeof(wp);
	GetWindowPlacement(&wp);
	theApp.m_rectInitialFrame = wp.rcNormalPosition;
}

void CMainFrame::OnAnswerphoneConfig() 
{
cAnswerConfig   dlg(this);

    dlg.DoModal();
}

