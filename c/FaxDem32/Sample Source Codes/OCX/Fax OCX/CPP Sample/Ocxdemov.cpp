// OCXDEMOView.cpp : implementation of the COCXDEMOView class
//

#include "stdafx.h"
#include "OCXDEMO.h"
#include "options.h"
#include "OCXDEMOD.h"
#include "OCXDEMOV.h"
#include "resource.h"
#include "NMSOpen.h"
#include "Dialogic.h"
#include "io.h"
#include "FaxConfig.h"
#include "faxcpp.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#include "defines.h"

/////////////////////////////////////////////////////////////////////////////
// COCXDEMOView

IMPLEMENT_DYNCREATE(COCXDEMOView, CView)

BEGIN_MESSAGE_MAP(COCXDEMOView, CView)
        //{{AFX_MSG_MAP(COCXDEMOView)
        ON_WM_CREATE()
        ON_COMMAND(ID_SEND, OnSend)
        ON_COMMAND(ID_CLOSE, OnClose)
        ON_COMMAND(ID_INIT_BROOK, OnInitBrook)
        ON_UPDATE_COMMAND_UI(ID_INIT_BROOK, OnUpdateInitBrook)
        ON_COMMAND(ID_INIT_COMM, OnInitComm)
        ON_UPDATE_COMMAND_UI(ID_INIT_COMM, OnUpdateInitComm)
        ON_COMMAND(ID_INIT_GAMMA, OnInitGamma)
        ON_UPDATE_COMMAND_UI(ID_INIT_GAMMA, OnUpdateInitGamma)
        ON_WM_DESTROY()
	ON_COMMAND(ID_INIT_NMSCHANNEL, OnInitNmschannel)
	ON_UPDATE_COMMAND_UI(ID_INIT_NMSCHANNEL, OnUpdateInitNmschannel)
	ON_COMMAND(ID_INIT_DIALOGICCHANNEL, OnInitDialogicchannel)
	ON_UPDATE_COMMAND_UI(ID_INIT_DIALOGICCHANNEL, OnUpdateInitDialogicchannel)
	ON_UPDATE_COMMAND_UI(ID_SEND, OnUpdateSend)
	ON_UPDATE_COMMAND_UI(ID_CLOSE, OnUpdateClose)
	ON_COMMAND(ID_FAX_CONFIG, OnFaxConfig)
	ON_COMMAND(ID_FAX_SHOWFAXMANAGER, OnFaxShowfaxmanager)
	ON_UPDATE_COMMAND_UI(ID_FAX_SHOWFAXMANAGER, OnUpdateFaxShowfaxmanager)
	ON_UPDATE_COMMAND_UI(IDM_BROOK_DEBUG, OnUpdateBrookDebug)
	ON_COMMAND(IDM_BROOK_DEBUG, OnBrookDebug)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// COCXDEMOView construction/destruction

COCXDEMOView::COCXDEMOView()
{
    m_szComPorts    = _T("");
    m_szBChannels   = _T("");
    m_szGChannels   = _T("");
    m_ObjNum = 0;
	SpeakerMode=SMO_DIAL;
	SpeakerVolume=SVO_MEDIUM;
	BaudRate=BR_33600;
	Ecm=TRUE;
	Bft=FALSE;
	Debug=FALSE;
	ActualFaxPort="";
	displayFaxManager=FALSE;
}

COCXDEMOView::~COCXDEMOView()
{
}

BOOL COCXDEMOView::PreCreateWindow(CREATESTRUCT& cs)
{
    // TODO: Modify the Window class or styles here by modifying
    //  the CREATESTRUCT cs

    return CView::PreCreateWindow(cs);
}

/////////////////////////////////////////////////////////////////////////////
// COCXDEMOView drawing

void COCXDEMOView::OnDraw(CDC* pDC)
{
    COCXDEMODoc* pDoc = GetDocument();
    ASSERT_VALID(pDoc);

    // TODO: add draw code for native data here
}

/////////////////////////////////////////////////////////////////////////////
// COCXDEMOView diagnostics

#ifdef _DEBUG
void COCXDEMOView::AssertValid() const
{
    CView::AssertValid();
}

void COCXDEMOView::Dump(CDumpContext& dc) const
{
    CView::Dump(dc);
}

COCXDEMODoc* COCXDEMOView::GetDocument() // non-debug version is inline
{
    ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(COCXDEMODoc)));
    return (COCXDEMODoc*)m_pDocument;
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// COCXDEMOView message handlers
static const WCHAR BASED_CODE _szLicString[] =
        L"Copyright (c) 2001, Black Ice Software, Inc.";

int COCXDEMOView::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
    COCXDEMOApp *lpApp = (COCXDEMOApp*)AfxGetApp();

    if (CView::OnCreate(lpCreateStruct) == -1)
        return -1;

    BSTR pbstrKey = SysAllocString(_szLicString);
    
    m_fax.Create( NULL, WS_VISIBLE,
                  CRect(50,50,100,100), this, IDC_FAXCTRL1, NULL, FALSE , pbstrKey);
    SysFreeString(pbstrKey);
	lpApp->m_pFax=&m_fax;
    return 0;
}

void COCXDEMOView::OnSend()
{
    Options dlg;
    long    error=0, faxID;
	long PageNum;
	bool invalid=false;
	int pushed;
   	
	while (!invalid){
		pushed=dlg.DoModal();
		
	    if ( pushed == IDOK ) {
			
		int ii = strspn(dlg.m_phonenumber, "0123456789,");
		int ln = lstrlen(dlg.m_phonenumber);
		BOOL bOK = (ii>=ln && ln) ? TRUE : FALSE;
		if (dlg.m_phonenumber.GetLength()==0){
			AfxMessageBox("You must specify the phone number.",MB_OK);
			dlg.fileFocus=FALSE;
			continue;}
		else if (!bOK){
			AfxMessageBox("The given phone number is incorrect.",MB_OK);
			dlg.fileFocus=FALSE;
			continue;}
		if (_access(dlg.m_szFileName,0)==-1){
			AfxMessageBox("You must specify an existing file to send.",MB_OK);
			dlg.fileFocus=TRUE;
			continue;
		}
		dlg.fileFocus=FALSE;
		invalid=true;
		
			
        m_fax.SetPageFileName( dlg.m_szFileName );
		CString name(dlg.m_szFileName);
		name.MakeLower();
		if (name.Find(".tif")!=-1)
			PageNum=m_fax.GetNumberOfImages(dlg.m_szFileName,PAGE_FILE_TIFF_G31D);
		else
			PageNum=1;
		
		short compression;
			if (dlg.m_nocomp==IDC_NOCOMP) 
				compression = 4;
			else if (dlg.m_nocomp==IDC_G31D || dlg.m_nocomp==IDC_COLOR)
				compression = 2;
			else if (dlg.m_nocomp==IDC_G32D)
				compression = 3;
			else if (dlg.m_nocomp==IDC_G4)
				compression = 5;
			else compression = 2;

		 byte type, colorfax;

			if (dlg.m_nocomp==IDC_COLOR)
			{
				type = 2;
				colorfax = 3;
				if (Bft)
					Bft = false;
			}
			else
			{
				colorfax = 2;
				if (Bft)
					type = 2;
				else type = 1;
			}

		short ecmtemp=EC_ENABLE,bfttemp=BF_DISABLE;
		if (Ecm) ecmtemp=EC_ENABLE;
		else ecmtemp=EC_DISABLE;
		
		if (Bft) bfttemp=BF_ENABLE;
		else bfttemp=BF_DISABLE;


		faxID = m_fax.CreateFaxObject( type, (short)PageNum, 3, 2, 1, compression, bfttemp, ecmtemp, 2, 1 );
		if (faxID==0) AfxMessageBox( "Can't create fax object !", MB_OK );
		else
        {
			bool bOK=true;
            m_fax.SetFaxParam( faxID, FP_SEND, (short)PageNum );
            m_fax.SetPhoneNumber( faxID, dlg.m_phonenumber );
			for (short i = 1; i <= PageNum; ++i)
				{
					if (m_fax.SetFaxPage(faxID, i, 17, i) != 0)
					{	
						char strerr[50];
						sprintf(strerr,"Can't set fax page! Error code: %d",m_fax.GetFaxError());
						AfxMessageBox(strerr);
						bOK = false;
						break;
					}
				}
			if (bOK)
			{
				if (dlg.m_queue==IDC_IMMEDIATE)
				{
					CString port=dlg.m_sendPort;
					int index=port.Find(':');
					if (index!=-1)
							port=port.Left(index);
					error=m_fax.SendNow(port,faxID);
				}
				else if (dlg.m_queue==IDC_QUEUE)
					error = m_fax.SendFaxObj(faxID);
				if (error != 0)
					{
						m_fax.ClearFaxObject(faxID);
						char strerr[50];
						sprintf(strerr,"Can't set fax page! Error code: %d",m_fax.GetFaxError());
						AfxMessageBox(strerr);
					}
            }

        }

    }
		else if (pushed==IDCANCEL) break;
	}
}

void COCXDEMOView::OnClose()
{
    long    error;
    CString szPortList;
    CPortClose port;
    port.m_szPorts      = m_fax.GetPortsOpen();
    port.m_szBChannels  = m_fax.GetBrooktroutChannelsOpen();
    port.m_szGChannels  = m_fax.GetGammaChannelsOpen();
    if ( port.DoModal() == IDOK ) {
		BeginWaitCursor();
        m_fax.ClosePort(port.m_szPort);
        if ( error=m_fax.GetFaxError() ) {
            char err[256];
            sprintf(err,"Error: %ld",error);
            AfxMessageBox(err);
        }
		if (m_fax.GetPortsOpen().GetLength()==0 && m_fax.GetBrooktroutChannelsOpen().GetLength()==0 &&
			m_fax.GetGammaChannelsOpen().GetLength()==0)
			displayFaxManager=FALSE;
		EndWaitCursor();
    }

}

void COCXDEMOView::OnInitBrook()
{
    CBrooktrout dlg;
    long        error;
    CString     channels;

    dlg.m_config = m_fax.GetBrooktroutCFile();
    dlg.m_channels = m_fax.GetAvailableBrooktroutChannels();
	dlg.m_brHeader=m_fax.GetHeader();
	dlg.m_brLocalID = m_fax.GetLocalID();
    if (dlg.DoModal()==IDOK ) {
		BeginWaitCursor();
		m_fax.SetLocalID(dlg.m_brLocalID);
		m_fax.SetHeader( dlg.m_brHeader );
        m_fax.SetHeaderHeight(25);
        m_fax.SetHeaderFaceName("Arial");
        m_fax.SetHeaderFontSize(10);
        m_fax.SetBrooktroutCFile( dlg.m_config );
        if ( error = m_fax.GetFaxError() ) {
            AfxMessageBox(GetError(error));
        }
        else {
            m_fax.OpenPort(dlg.m_szChannel);
            if ( error=m_fax.GetFaxError() ) {
                AfxMessageBox(GetError(error));
            }
            else {
					displayFaxManager=TRUE;
                    if( dlg.m_bDTMF)
                         {
                          m_fax.RecvDTMF( dlg.m_szChannel, 5, 20);
                         }
            }
        }
		EndWaitCursor();
    }
}

void COCXDEMOView::OnUpdateInitBrook(CCmdUI* pCmdUI)
{
        m_szBChannels = m_fax.GetAvailableBrooktroutChannels();
        pCmdUI->Enable( m_szBChannels.GetLength());
}

void COCXDEMOView::OnInitComm()
{
    CCommPort dlg;
	char szFax[256], szFaxName[256];
	bool invalid=false;
	int pushed;
   	
    
	
	while (!invalid){
		
		dlg.m_rings     = m_fax.GetRings();
		dlg.m_commports = m_fax.GetAvailablePorts();
		dlg.m_bHeader   = m_fax.GetHeader();
		dlg.m_szLocalID = m_fax.GetLocalID();
		dlg.m_bDebugEnbl = Debug;
		pushed=dlg.DoModal();
	
    if ( pushed == IDOK ) {
		BeginWaitCursor();
		short EcmOrBft=EC_ENABLE;
		Debug=dlg.m_bDebugEnbl;
        m_fax.SetLocalID( dlg.m_szLocalID );
        m_fax.SetRings( dlg.m_rings );
        m_fax.SetHeader( dlg.m_bHeader );
        m_fax.SetHeaderHeight(25);
        m_fax.SetHeaderFaceName("Arial");
        m_fax.SetHeaderFontSize(10);
		sprintf(szFax, "Fax%d", dlg.m_FaxListIndex);     
        GetPrivateProfileString("Faxes", szFax, "", szFaxName, sizeof(szFaxName), "faxcpp1.ini");
		CString ActPortTemp=ActualFaxPort;
		ActualFaxPort=dlg.m_ActPort;
		m_fax.SetFaxType(szFaxName);
		m_fax.TestModem(ActualFaxPort);
		
		if  (m_fax.GetClassType().GetLength()!=0)
		{
			if (m_fax.GetFaxType() == "GCLASS1(SFC)" && (m_fax.GetClassType().Find("1") == -1 || m_fax.GetClassType().Find("1.0") == m_fax.GetClassType().Find("1")))
				{
					AfxMessageBox("The selected modem does not support Class 1",MB_OK);
					EndWaitCursor();
					continue;
				}
				else if (m_fax.GetFaxType() == "GCLASS1(HFC)" && (m_fax.GetClassType().Find("1") == -1 || m_fax.GetClassType().Find("1.0") == m_fax.GetClassType().Find("1")))
				{
					AfxMessageBox("The selected modem does not support Class 1");
					EndWaitCursor();
					continue;
				}
				else if (m_fax.GetFaxType() == "GCLASS1.0(SFC)" && m_fax.GetClassType().Find("1.0") == -1)
				{
					AfxMessageBox("The selected modem does not support Class 1.0");
					EndWaitCursor();
					continue;
				}
				else if (m_fax.GetFaxType() == "GCLASS1.0(HFC)" && m_fax.GetClassType().Find("1.0")==-1)
				{
					AfxMessageBox("The selected modem does not support Class 1.0");
					EndWaitCursor();
					continue;
				}
				else if ((m_fax.GetFaxType() == "GCLASS2S/RF/" || m_fax.GetFaxType() == "GCLASS2R") && (m_fax.GetClassType().Find("2")==-1 || m_fax.GetClassType().Find("2.0") == m_fax.GetClassType().Find("2")))
				{
					AfxMessageBox("The selected modem does not support Class 2");
					EndWaitCursor();
					continue;
				}
				else if ((m_fax.GetFaxType() == "GCLASS2.0" || m_fax.GetFaxType() == "GCLASS2.0 MULTITECH") && m_fax.GetClassType().Find( "2.0") == -1)
				{
					AfxMessageBox("The selected modem does not support Class 2.0");
					EndWaitCursor();
					continue;
				}
				else if ((m_fax.GetFaxType() == "GH14.4F(HFC)" || m_fax.GetFaxType() == "GU.S.R14.4F(HFC)") && (m_fax.GetClassType().Find("1") == -1) || m_fax.GetClassType().Find("1.0") == m_fax.GetClassType().Find("1")) 
				{
					AfxMessageBox("The selected modem does not support Class 1");
					EndWaitCursor();
					continue;
				}
				ActualFaxPort=dlg.m_ActPort;
				m_fax.SetSpeakerVolume(SpeakerVolume);
				Sleep(2000);
				
				int errcode=m_fax.OpenPort(ActualFaxPort);
				if (errcode!=0)
					AfxMessageBox(GetError(errcode),MB_OK);	
				else 
				{
					displayFaxManager=TRUE;
					COCXDEMOApp *lpApp = (COCXDEMOApp*)AfxGetApp();
					char temp[4];
					itoa(dlg.m_FaxListIndex,temp,10);
					lpApp->PortsAndClasses=lpApp->PortsAndClasses+ActualFaxPort+':'+temp+' ';
				}
				m_fax.SetSpeakerMode(ActualFaxPort,SpeakerMode,SpeakerVolume);
				if (Ecm) EcmOrBft=EC_ENABLE;
					else EcmOrBft=EC_DISABLE;
				m_fax.SetPortCapability(ActualFaxPort, PC_ECM, EcmOrBft);
				if (Bft) EcmOrBft=BF_ENABLE;
					else EcmOrBft=BF_DISABLE;
				m_fax.SetPortCapability(ActualFaxPort, PC_BINARY,EcmOrBft);
				m_fax.SetPortCapability(ActualFaxPort, PC_MAX_BAUD_SEND, BaudRate);
				m_fax.EnableLog(ActualFaxPort,Debug);
				m_fax.SetHeaderHeight(25);
				invalid=true;
		}
		else
		{
			CString szText = "No modem on " + ActualFaxPort + " port.";
			MessageBox(szText, "Error",MB_OK);
			ActualFaxPort=ActPortTemp;
			EndWaitCursor();
			continue;
		}
	EndWaitCursor();
    }
	else if (pushed==IDCANCEL) break;
	}
		EndWaitCursor();
}

void COCXDEMOView::OnUpdateInitComm(CCmdUI* pCmdUI)
{
        m_szComPorts = m_fax.GetAvailablePorts();
        pCmdUI->Enable( m_szComPorts.GetLength() );
}

void COCXDEMOView::OnInitGamma()
{
    CGamma   dlg;
    long     error;
    CString  channels;

    dlg.m_rings  = m_fax.GetRings();
    dlg.m_config = m_fax.GetGammaCFile();
    dlg.m_channels = m_fax.GetAvailableGammaChannels();
    if ( dlg.DoModal() == IDOK ) {
        m_fax.SetRings( (short)dlg.m_rings );
        if ( dlg.m_rings )
            m_fax.SetGammaCFile( dlg.m_config );
        if ( error = m_fax.GetFaxError() ) {
            AfxMessageBox(GetError(error),MB_OK);
        }
        else {
            m_fax.OpenPort(dlg.m_szChannel);
            if ( error=m_fax.GetFaxError() ) {
                AfxMessageBox(GetError(error),MB_OK);
            }
			else displayFaxManager=TRUE;
        }
    }
}

void COCXDEMOView::OnUpdateInitGamma(CCmdUI* pCmdUI)
{
    m_szGChannels = m_fax.GetAvailableGammaChannels();
    pCmdUI->Enable( m_szGChannels.GetLength());
}

void COCXDEMOView::OnInitNmschannel() 
{
	long     error;
	CNMSOpen dlg;

	dlg.m_szChannels = m_fax.GetAvailableNMSChannels();
    if ( dlg.DoModal() == IDOK ) 
	{
		m_fax.SetNMSProtocoll(dlg.szProtocol);
		m_fax.SetNMSDNISDigitNum(dlg.didDigits);
        m_fax.OpenPort(dlg.m_selectedChannel);
        if ( error=m_fax.GetFaxError() ) {
            AfxMessageBox(GetError(error),MB_OK);
        }
		else displayFaxManager=TRUE;
    }
}

void COCXDEMOView::OnUpdateInitNmschannel(CCmdUI* pCmdUI) 
{
	m_szNMSChannels = m_fax.GetAvailableNMSChannels();
	pCmdUI->Enable(m_szNMSChannels.GetLength());
}

void COCXDEMOView::OnInitDialogicchannel() 
{
	long     error;
	CDialogic dlg;

	dlg.m_szChannels = m_fax.GetAvailableDialogicChannels();
    if ( dlg.DoModal() == IDOK ) 
	{
        m_fax.OpenPort(dlg.m_selectedChannel);
        if ( error=m_fax.GetFaxError() ) {
            AfxMessageBox(GetError(error),MB_OK);
        }
		else 
		{
			if( dlg.m_bDTMF)
                        m_fax.RecvDTMF( dlg.m_selectedChannel, 5, 20);
                         
			displayFaxManager=TRUE;
		}
    }
}

void COCXDEMOView::OnUpdateInitDialogicchannel(CCmdUI* pCmdUI) 
{
	m_szDialogicChannels = m_fax.GetAvailableDialogicChannels();
	pCmdUI->Enable( m_szDialogicChannels.GetLength() );
}


BEGIN_EVENTSINK_MAP(COCXDEMOView, CView)
    //{{AFX_EVENTSINK_MAP(COCXDEMOView)
        ON_EVENT(COCXDEMOView, IDC_FAXCTRL1, 1 /* Answer */, OnAnswer, VTS_BSTR)
        ON_EVENT(COCXDEMOView, IDC_FAXCTRL1, 5 /* StartSend */, OnStartSend, VTS_BSTR)
        ON_EVENT(COCXDEMOView, IDC_FAXCTRL1, 6 /* EndSend */, OnEndSend, VTS_BSTR VTS_I4 VTS_BSTR)
        ON_EVENT(COCXDEMOView, IDC_FAXCTRL1, 7 /* EndReceive */, OnEndReceive, VTS_BSTR VTS_I4 VTS_BSTR)
        ON_EVENT(COCXDEMOView, IDC_FAXCTRL1, 8 /* Terminate */, OnTerminate, VTS_BSTR VTS_I4 VTS_I2 VTS_I4 VTS_BSTR VTS_BSTR)
        ON_EVENT(COCXDEMOView, IDC_FAXCTRL1, 9 /* StartPage */, OnStartPage, VTS_BSTR VTS_I4)
        ON_EVENT(COCXDEMOView, IDC_FAXCTRL1, 10 /* EndPage */, OnEndPage, VTS_BSTR VTS_I4)
        //}}AFX_EVENTSINK_MAP
END_EVENTSINK_MAP()

LPSTR COCXDEMOView::MakeTerminationText( long TCode )
{
    switch ( TCode ) {
        case TER_NONE :
            return "Session not terminated" ;
        case TER_ABORT :
            return "User Abort" ;
        case TER_UNSPECIFIED :
            return "Unspecified error" ;
        case TER_RINGBACK :
            return "Ringback detect" ;
        case TER_NO_CARRIER :
            return "No carrier detected" ;
        case TER_BUSY :
            return "The remote station is BUSY" ;
        case TER_PHASE_A :
            return "Uspecified phase A error" ;
        case TER_PHASE_B :
            return "Unspecified phase B error" ;
        case TER_NO_ANSWER :
            return "No Answer" ;
        case TER_NO_DIALTONE :
            return "No dialtone" ;
        case TER_INVALID_REMOTE :
            return  "Remote modem cannot receive or send " ;
        case TER_COMREC_ERROR :
            return "Command not received" ;
        case TER_INVALID_COMMAND :
            return "Incvalid command received" ;
        case TER_INVALID_RESPONSE :
            return "Invalid response received" ;
        case TER_DCS_SEND :
            return "DCS send 3 times without answer" ;
        case TER_DIS_RECEIVED :
            return "DIS received 3 times" ;
        case TER_DIS_NOTRECEIVED :
            return "DIS not received" ;
        case TER_TRAINING :
            return "Failure training in 2400 bit/s" ;
        case TER_TRAINING_MINSPEED :
            return "Training failure : minimum speed reached." ;
        case TER_PHASE_C  :
            return "Error in page transmission" ;
        case TER_IMAGE_FORMAT :
            return "Unspecified image format" ;
        case TER_IMAGE_CONVERSION :
            return "Image conversion error" ;
        case TER_DTE_DCE_DATA_UNDERFLOW :
            return "DTE to DCE data underflow" ;
        case TER_UNRECOGNIZED_CMD :
            return "Unrecognized transparent data command" ;
        case TER_IMAGE_LINE_LENGTH:
            return "Image error line length wrong" ;
        case TER_IMAGE_PAGE_LENGTH  :
            return "Page length wrong" ;
        case TER_IMAGE_COMPRESSION :
            return "wrong compression mode" ;
        case TER_PHASE_D :
            return "Unspecified phase D error" ;
        case TER_MPS :
            return "No response to MPS" ;
        case TER_MPS_RESPONSE :
            return "Invalid response to MPS" ;
        case TER_EOP :
            return "No response to EOP" ;
        case TER_EOP_RESPONSE :
            return "Invalid response to EOP" ;
        case TER_EOM :
            return "No response to EOM" ;
        case TER_EOM_RESPONSE :
            return "Invalid response to EOM" ;
        case TER_UNABLE_TO_CONTINUE :
            return "Unable to continue after PIN or PPP" ;
        case TER_T2_TIMEOUT :
            return "T.30 T2 timeout expected" ;
        case TER_T1_TIMEOUT :
            return "T.30 T1 timeout expected" ;
        case TER_MISSING_EOL :
            return "Missing EOL after 5 sec" ;
        case TER_BAD_CRC :
            return "Bad CRC or Frame" ;
        case TER_DCE_DTE_DATA_UNDERFLOW :
            return "DCE to DTE data underflow" ;
        case TER_DCE_DTE_DATA_OVERFLOW :
            return "DCE to DTE data overflow" ;
        case TER_INVALID_REMOTE_RECEIVE :
            return "Remote cannot receive" ;
        case TER_INVALID_REMOTE_ECM :
            return "Invalid remote ECM mode " ;
        case TER_INVALID_REMOTE_BFT:
            return "Invalid remote BFT mode" ;
        case TER_INVALID_REMOTE_WIDTH:
            return "Invalid remote width" ;
        case TER_INVALID_REMOTE_LENGTH :
            return "Invalid remote length" ;
        case TER_INVALID_REMOTE_COMPRESS:
            return "Invalid remote compression " ;
        case TER_INVALID_REMOTE_RESOLUTION :
            return "Invalid remote resolution" ;
        case TER_NO_SEND_DOCUMET :
            return "No transmitting document" ;
        case TER_PPS_RESPONSE :
            return "No response to PPS" ;
        case TER_NOMODEM :
            return "No modem on comm port" ;
        case TER_INVALIDCLASS:
            return "Incompatible modem" ;
        case TER_B_FILEIO:
            return "Brooktrout: File I/O error occured." ;
        case TER_B_FILEFORMAT:
            return "Brooktrout: Bad file format." ;
        case TER_B_BOARDCAPABILITY:
            return "Brooktrout: Line card firmware does not support capability." ;
        case TER_B_NOTCONNECTED:
            return "Brooktrout: Channel is not in proper state." ;
        case TER_B_BADPARAMETER:
            return "Brooktrout: Bad parameter value used." ;
        case TER_B_MEMORY:
            return "Brooktrout: Memory allocation error." ;
        case TER_B_BADSTATE:
            return "Brooktrout: The channel is not in a required state." ;
        case TER_B_NO_LOOP_CURRENT:
            return "Brooktrout: No loop current detected." ;
        case TER_B_LOCAL_IN_USE:
            return "Brooktrout: Local phone in use." ;
        case TER_B_CALL_COLLISION:
            return "Brooktrout: Ringing detected during dialing." ;
        case TER_B_CONFIRM:
            return "Confirmation tone detected." ;
        case TER_B_DIALTON:
            return "Dial tone detected; the dialing sequence did not brake dial tone." ;
        case TER_B_G2_DETECTED:
            return "Group 2 fax machine detected. Remote fax machine is capable of sending and receiving G2 facsimiles only." ;
        case TER_B_HUMAN:
            return "Answer (probable human) detected; does not match any other expected call progress signal patterns." ;
        case TER_B_QUIET:
            return "After dialing the number, no energy detected on the line, possible dead line." ;
        case TER_B_RECALL:
            return "Recall dial tone detected." ;
        case TER_B_RNGNOANS:
            return "The remote end was ringing but did not answer." ;
        case TER_B_SITINTC:
            return "Intercept tone detected; invalid telephone number or class of service restriction." ;
        case TER_B_SITNOCIR:
            return "No circuit detected; end office or carrier originating failure; possible dead line." ;
        case TER_B_SITREORD:
            return "Reorder tone detected; end office or carrier originating failure." ;
        case TER_B_SITVACOE:
            return "Vacant tone detected; remote originating failure; invalid telephone number." ;
        case TER_B_UNSPECIFIED:
            return "Brooktrout error." ;
        case TER_B_NO_WINK:
            return "Brooktrout error : no wink." ;
        case TER_B_RSPREC_VCNR:
            return "Brooktrout error : RSPREC invalid response received." ;
        case TER_B_COMREC_DCN:
            return "Brooktrout error : DCN received in COMREC." ;
        case TER_B_RSPREC_DCN:
            return "Brooktrout error : DCN received in RSPREC." ;
        case TER_B_INCOMPAT_FMT:
            return "Brooktrout error : Incompatible fax formats." ;
        case TER_B_INVAL_DMACNT:
            return "Brooktrout error : Invalid DMA count specified for transmitter." ;
        case TER_B_FTM_NOECM:
            return "Brooktrout error : Binary File Transfer specified, but ECM not enabled on transmitter.";
        case TER_B_INCMP_FTM:
            return "Brooktrout error : Binary File Transfer specified, but not supported by receiver.";
        // phase D hangup codes
        case TER_B_RR_NORES:
            return "Brooktrout error : No response to RR after three tries." ;
        case TER_B_CTC_NORES:
            return "Brooktrout error : No response to CTC, or response was not CTR." ;
        case TER_B_T5TO_RR:
            return "Brooktrout error : T5 time out since receiving first RNR." ;
        case TER_B_NOCONT_NSTMSG:
            return "Brooktrout error : Do not continue with next message after receiving ERR." ;
        case TER_B_ERRRES_EOREOP:
            return "Brooktrout error : ERR response to EOR-EOP or EOR-PRI-EOP." ;
        case TER_B_SE:
            return "Brooktrout error : RSPREC error." ;
        case TER_B_EORNULL_NORES:
            return "Brooktrout error : No response received after third try for EOR-NULL." ;
        case TER_B_EORMPS_NORES:
            return "Brooktrout error : No response received after third try for EOR-MPS." ;
        case TER_B_EOREOP_NORES:
            return "Brooktrout error : No response received after third try for EOR-EOP." ;
        case TER_B_EOREOM_NORES:
            return "Brooktrout error : No response received after third try for EOR-EOM." ;
        // receive phase B hangup codes
        case TER_B_RCVB_SE:
            return "Brooktrout error : RSPREC error." ;
        case TER_B_NORMAL_RCV:
            return "Brooktrout error : DCN received in COMREC." ;
        case TER_B_RCVB_RSPREC_DCN:
            return "Brooktrout error : DCN received in RSPREC." ;
        case TER_B_RCVB_INVAL_DMACNT:
            return "Brooktrout error : Invalid DMA count specified for receiver." ;
        case TER_B_RCVB_FTM_NOECM:
            return "Brooktrout error : Binary File Transfer specified, but ECM supported by receiver." ;
        // receive phase D hangup codes
        case TER_B_RCVD_SE_VCNR:
            return "Brooktrout error : RSPREC invalid response received." ;
        case TER_B_RCVD_COMREC_VCNR:
            return "Brooktrout error : COMREC invalid response received." ;
        case TER_B_RCVD_T3TO_NORESP:
            return "Brooktrout error : T3 time-out; no local response for remote voice interrupt." ;
        case TER_B_RCVD_T2TO:
            return "Brooktrout error : T2 time-out; no command received after responding RNR." ;
        case TER_B_RCVD_DCN_COMREC:
            return "Brooktrout error : DCN received for command received." ;
        case TER_B_RCVD_COMREC_ERR:
            return "Brooktrout error : Command receive error." ;
        case TER_B_RCVD_BLKCT_ERR:
            return "Brooktrout error : Receive block count error in ECM mode." ;
        case TER_B_RCVD_PGCT_ERR:
            return "Brooktrout error : Receive page count error in ECM mode." ;
        case TER_HUMANVOICE:
            return "Human voice detected." ;

    }
    return "";
}

void COCXDEMOView::OnDestroy()
{
        
        m_fax.CloseAllPorts();
        CView::OnDestroy();
        
 
}
 

void COCXDEMOView::OnAnswer(LPCTSTR Port)
{
    TRACE1( "Answering a call on %s !\n", Port );
}

void COCXDEMOView::OnStartSend(LPCTSTR PortName)
{
    TRACE1( "Starting to send on %s !\n", PortName );
}


void COCXDEMOView::OnEndSend(LPCTSTR PortName, long FaxID, LPCTSTR RemoteID)
{
#ifdef _DEBUG
    TRACE1( "EndSend received from %s !\n", PortName );
#endif
        if ( m_fax.ClearFaxObject( FaxID ) ) {
        TRACE0( "Error deleting faxobject in OnEndSend !\n" );
    }
}

void COCXDEMOView::OnEndReceive(LPCTSTR PortName, long FaxID, LPCTSTR RemoteID)
{
    TRACE1( "End of receive on %s !\n", PortName );
    if ( FaxID ) {
        m_fax.SetFaxFileName( "c:\\receive.tif" );
        if ( m_fax.GetFaxPage( FaxID, 1, PAGE_FILE_TIFF_G31D, FALSE ) ) {
            TRACE0( "GetFaxPage failed !\n" );
        }
		else AfxMessageBox("Fax received in c:\\receive.tif");
        m_fax.ClearFaxObject( FaxID );
    }
}

void COCXDEMOView::OnTerminate(LPCTSTR lpPort, long lStatus, short sPageNo, long ConnectTime, LPCTSTR szDID, LPCTSTR szDTMF)
{
    char GammaName[] = "GChannel";

    TRACE3( "Termination status from %s: %ld, connect time : %d", lpPort, lStatus, ConnectTime );
	char buf[100];
	wsprintf(buf,"DTMF received on %s: %s",lpPort,szDTMF);
	if (szDTMF) AfxMessageBox(buf);
        TRACE2( " DID: %s, DTMF: %s\n", szDID, szDTMF);
        if ( !strncmp( lpPort, "GChannel", sizeof(GammaName)-1 ) ) {
			if ( lStatus != TER_NORMAL ){
            AfxMessageBox( MakeTerminationText( lStatus ), MB_OK );
			}
    }
}

void COCXDEMOView::OnStartPage(LPCTSTR szPort, long lPageNumber)
{
   TRACE2( "Start of page %d on port %s\n", lPageNumber, szPort);
}

void COCXDEMOView::OnEndPage(LPCTSTR szPort, long lPageNumber)
{
   TRACE2( "End of page %d on port %s\n", lPageNumber, szPort);
}

void COCXDEMOView::OnUpdateSend(CCmdUI* pCmdUI) 
{
	CString ports;
		ports=m_fax.GetPortsOpen();
		if (ports=="")
		{
			ports=m_fax.GetBrooktroutChannelsOpen();
			if (ports=="")
			{
				ports=m_fax.GetGammaChannelsOpen();
				if (ports=="") 
				{
				pCmdUI->Enable(FALSE);
				return;
				}
			}
		}       
	pCmdUI->Enable(TRUE); 
}

void COCXDEMOView::OnUpdateClose(CCmdUI* pCmdUI) 
{
	CString ports;
	ports=m_fax.GetPortsOpen();
		if (ports=="")
		{
			ports=m_fax.GetBrooktroutChannelsOpen();
			if (ports=="")
			{
				ports=m_fax.GetGammaChannelsOpen();
				if (ports=="") 
				{
					pCmdUI->Enable(FALSE);
					return;
				}
			}
		}       
	pCmdUI->Enable(TRUE); 
}

void COCXDEMOView::OnFaxConfig() 
{
	CFaxConfig dlg;
	switch(SpeakerMode)
	{
		case SMO_NEVER:
                dlg.m_speakerMode = IDC_RADIO1;
                break;
        case SMO_ALWAYS:
                dlg.m_speakerMode = IDC_RADIO2;
                break;
        default:
                dlg.m_speakerMode = IDC_RADIO3;
                break;
	}
	switch(SpeakerVolume)
	{
        case SVO_HIGH:
                dlg.m_speakerVolume = IDC_RADIO6;
                break;
        case SVO_MEDIUM:
                dlg.m_speakerVolume = IDC_RADIO5;
                break;
        default:
                dlg.m_speakerVolume = IDC_RADIO4;
                break;
	}
	
	dlg.m_BaudRate = BaudRate;
	dlg.m_Ecm=Ecm;
	dlg.m_BFT=Bft;
	
	
	if (dlg.DoModal()==IDOK)
	{	short EcmOrBft=EC_ENABLE;
		SpeakerMode = dlg.m_speakerMode;
		SpeakerVolume = dlg.m_speakerVolume;
		BaudRate=dlg.m_BaudRate+2;
		Ecm=dlg.m_Ecm;
		Bft=dlg.m_BFT;
		m_fax.SetSpeakerMode(ActualFaxPort,SpeakerMode,SpeakerVolume);
		if (Ecm) EcmOrBft=EC_ENABLE;
		else EcmOrBft=EC_DISABLE;
		m_fax.SetPortCapability(ActualFaxPort, PC_ECM, EcmOrBft);
		if (Bft) EcmOrBft=BF_ENABLE;
		else EcmOrBft=BF_DISABLE;
		m_fax.SetPortCapability(ActualFaxPort, PC_BINARY,EcmOrBft);
		m_fax.SetPortCapability(ActualFaxPort, PC_MAX_BAUD_SEND, BaudRate);
	}
}

CString COCXDEMOView::GetError(int errorCode)
{
	CString retval;
	char buffer[20];
	switch (errorCode)
		{
				case -150 : retval = "The specified file doesn’t exist.";
								break;
				case -151 : retval = "The specified communication port is invalid.";
								break;
				case -152 : retval = "The specified communication port doesn’t exist.";
								break;
				case -153 : retval = "Cannot connect to the port.";
					break;
				case -154 : retval = "No file was specified for sending.";
					break;
				case -155 : retval = "The creation of the fax object failed.";
					break;
				case -156 : retval = "The specified communication port was already initialized.";
					break;
				case -157 : retval = "An invalid fax modem type was specified.";
					break;
				case -158 : retval = "No phone number was specified for SetPhoneNumber function.";
					break;
				case -159 : retval = "Invalid fax ID was specified.";
					break;
				case -160 : retval = "Invalid image type was specified for SetFaxPage method.";
					break;
				case -161 : retval = "Invalid image filename was specified for SetFaxPage method.";
					break;
				case -162 : retval = "The attempt to open or convert the ASCII data to image was unsuccessful.";
					break;
				case -163 : retval = "There was no DIB handle specified before SetFaxPage method.";
					break;
				case -164 : retval = "Invalid DIB handle was specified before SetFaxPage method.";
					break;
				case -165 : retval = "There weren’t any ports open before an operation (SendFaxObj) which needed one.";
					break;
				case -166 : retval =  "The OCX wasn’t able to recognize the format of the specified image file.";
					break;
				case -167 : retval = "The modem test on the specified COM port was unsuccessful.";
					break;
				case -168 : retval = "Invalid filename specified.";
					break;
				case -169 : retval =  "The specified Brooktrout fax channel has no faxing capability.";
					break;
				case -170 : retval =  "No configuration file was specified before opening a Brooktrout or GammaLink fax channel.";
					break;
				case  -171 :  retval =  "The DEMO version of the Fax OCX supports only 1 fax port.";
					break;
				case  -172 : retval =  "The DEMO version of the Fax OCX supports only 1 page faxes.";
					break;
				default : itoa(errorCode,buffer,10);
							retval=buffer;
					break;
			}
			return retval;
}

void COCXDEMOView::OnFaxShowfaxmanager() 
{
	CWnd* pMain = AfxGetMainWnd();
	CMenu* mmenu = pMain->GetMenu();
	CMenu* submenu = mmenu->GetSubMenu(1);

	MENUITEMINFO info;
	info.cbSize = sizeof (MENUITEMINFO); // must fill up this field
	info.fMask = MIIM_STATE;             // get the state of the menu item
	VERIFY(submenu->GetMenuItemInfo(ID_FAX_SHOWFAXMANAGER, &info));

	if (info.fState & MF_CHECKED){
      submenu->CheckMenuItem(ID_FAX_SHOWFAXMANAGER, MF_UNCHECKED | MF_BYCOMMAND);
	  m_fax.SetDisplayFaxManager(FALSE);}
   else
   {
      submenu->CheckMenuItem(ID_FAX_SHOWFAXMANAGER, MF_CHECKED | MF_BYCOMMAND);
	  m_fax.SetDisplayFaxManager(TRUE);
   }
}

void COCXDEMOView::OnUpdateFaxShowfaxmanager(CCmdUI* pCmdUI) 
{
	CWnd* pMain = AfxGetMainWnd();
	CMenu* mmenu = pMain->GetMenu();
	CMenu* submenu = mmenu->GetSubMenu(1);
	if (displayFaxManager)
		pCmdUI->Enable( TRUE );
	else 
		pCmdUI->Enable( FALSE);
	if (m_fax.GetDisplayFaxManager())
	{
		submenu->CheckMenuItem(ID_FAX_SHOWFAXMANAGER, MF_CHECKED | MF_BYCOMMAND);
		m_fax.SetDisplayFaxManager(TRUE);
	}
	else 
	{
		submenu->CheckMenuItem(ID_FAX_SHOWFAXMANAGER, MF_UNCHECKED | MF_BYCOMMAND);
		m_fax.SetDisplayFaxManager(FALSE);
	}

}

void COCXDEMOView::OnUpdateBrookDebug(CCmdUI* pCmdUI) 
{
    COCXDEMOView	*pApp = (COCXDEMOView *)AfxGetApp();
    BOOL bEnable = FALSE;

    if ( pApp->BrooktroutChannels && pApp->BrooktroutChannels[0] ) 
	{
		bEnable = TRUE ;
		int nChk = (int)(pApp->m_DebugBrook ? 1 : 0);
        pCmdUI->SetCheck(nChk);
	}
    pCmdUI->Enable(bEnable) ;
}

void COCXDEMOView::OnBrookDebug() 
{
	COCXDEMOView *pApp = (COCXDEMOView *)AfxGetApp();

    if ( pApp->BrooktroutChannels && pApp->BrooktroutChannels[0] ) {
        pApp->m_DebugBrook = (pApp->m_DebugBrook?0:1);
        if ( pApp->m_DebugBrook )
            EnableDebug( DBG_ALL );
        else
            EnableDebug( DBG_NONE );
    }
}
