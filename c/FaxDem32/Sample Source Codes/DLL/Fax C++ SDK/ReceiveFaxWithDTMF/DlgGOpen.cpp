// DlgGOpen.cpp : implementation file
//

#include "stdafx.h"
#include "ReceiveFaxWithDTMF.h"
#include "DlgGOpen.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDlgGOpen dialog


CDlgGOpen::CDlgGOpen(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgGOpen::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDlgGOpen)
	//}}AFX_DATA_INIT
}


void CDlgGOpen::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDlgGOpen)
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDlgGOpen, CDialog)
	//{{AFX_MSG_MAP(CDlgGOpen)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgGOpen message handlers

BOOL CDlgGOpen::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	int     nCh;
    CReceiveFaxWithDTMFApp *pApp = (CReceiveFaxWithDTMFApp *)AfxGetApp();
    CListBox *pLB;
    CDialog::OnInitDialog();


    pLB = (CListBox *)GetDlgItem(IDC_CHANNELS);
    for ( nCh=0 ; (nCh < MAX_GAMMACHANNELS) ; nCh++ ) {
        char szCom[20];

        if ( G_IsChannelFree( nCh ) ) {
            strcpy( szCom, "Channel" );
            _itoa( nCh, &szCom[ strlen("Channel") ], 10 );
            pLB->AddString(szCom);
        }
    }

    if ( G_NeedConfig() ) {
        CString szTmp = pApp->GetProfileString( "GammaLink", "Config file", "" );
        SetDlgItemText( IDC_CONFIG, szTmp );
    }
    else
        GetDlgItem(IDC_CONFIG)->EnableWindow( FALSE );
   	((CEdit *)GetDlgItem(IDC_GDTMF))->LimitText(1);
	SetDlgItemText(IDC_GDTMF,"4");
    pLB->SetCurSel(0);		
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CDlgGOpen::OnOK() 
{
	BeginWaitCursor();
	CListBox  *cPortList ;
	CEdit     *cEdit;
	CReceiveFaxWithDTMFApp *pApp = (CReceiveFaxWithDTMFApp *)AfxGetApp();
	char      szChannel[10], szCFile[256];
	cPortList =(CListBox *)GetDlgItem( IDC_CHANNELS );
	cPortList->GetText( cPortList->GetCurSel(), szChannel );
	cEdit =(CEdit *)GetDlgItem( IDC_CONFIG );
    memset( szCFile, 0, sizeof(szCFile) );
    cEdit->GetLine( 0, szCFile, sizeof(szCFile) );
    pApp->WriteProfileString( "GammaLink", "Config file", szCFile );
	int m_gDTMF=GetDlgItemInt(IDC_GDTMF,NULL,FALSE);
	for ( int i = 0 ; i < MAX_FAXPORTS ; i++ ) {
            if ( !pApp->FaxPorts[i] ) {
	/*********************Connect the channel to the fax hardware.**************************/
	/*
	1. parameter: Name of the GammaLink channel. 
	2. parameter: This parameter should point to the name of the GammaLink configuration file.
				  The string can contain a full path ( "d:\\gamma\\fax\\gfax.$dc") or only the filename.
				  In the latter case the function tries to open the config file in the directory
				  specified by the environment variable GFAX.
	3. parameter: The type of the fax board.(BRD_GAMMALINK)
	Returns: - fax port object on success
			 - NULL,  if szChannel or szCFile is NULL.
			 - FER_GAMMA_BAD_LINE_CONFIG, if the GammaLink fax channel is configured to 
			   answer-only or dial-only operation which is incompatible with Fax C++. 
			   The GFXSHUTDOWN value must be set to 3 in the GammaLink configuration file.
			 - FER_GAMMA_INCOMPATIBLE_TIFF_FORMAT, if in the GammaLink configuration file it 
			   isn’t specified in which image format the received fax will be written to disk. 
               The GFXFORM value must be other then 0.
			 - FER_GAMMA_NOENVVAR, if the GFAX environment variable can’t be found.*/
                pApp->FaxPorts[i] = ConnectChannel(szChannel, szCFile, BRD_GAMMALINK );
	/* You can also use ConnectPortExt to connect the GammaLink channel to the fax hardware.
		1. parameter: Name of the GammaLink channel. 
		2. parameter: This parameter should point to the string "Gamma Channel".
		3. parameter: This parameter should point to the name of the GammaLink configuration file.
					  The string can contain a full path ( "d:\\gamma\\fax\\gfax.$dc") or only the filename.
					  In the latter case the function tries to open the config file in the directory
					  specified by the environment variable GFAX.
			pApp->FaxPorts[i]=ConnectPortExt(szChannel,"Gamma Channel",szCFile);
		*/
				

                if ( !pApp->FaxPorts[i] ) {
                    AfxMessageBox("Unable to connect channel!");
                    EndWaitCursor();
					return;
                } else 
				{
	/*****************************Set Port Capabilities**************************************/
	/*1. parameter: Fax port object.
	  2. parameter: Type of capability to be set
		 Set the device-specific information about the fax equipment. The Cap parameter specifies the type of the information to be set. 
		 It can be one of the following indexes:

		FDC_SETCOMPRESS         Compression type the driver can handle and pass it on in the HDLC frame.
								The nData parameter is a TECompression data type.
		FDC_ONLINECOMPRESS		Compression type the device can handle on line.
								The nData parameter is a TECompression data type.
								Not utilized in this release.
		FDC_ECM                 If the nData parameter is ECM_ENABLE the modem can handle Error Correction Mode.
								The nData parameter data type is enum. See faxtype.h. 
		FDC_BINARY              If the nData parameter is BFT_ENABLE the modem can handle binary transmission or not.
								The nData parameter data type is enum.
		FDC_WIDTH               Width of the paper supported. The nData parameter data type is TEPageWidth.
		FDC_LENGTH              Length of the paper supported. The nData parameter data type is TEPageLength.
		FDC_BAUD_SEND			Communication baud rate supported for sending data. The returned value data type is TEBaudRate.
		FDC_BAUD_REC			Communication baud rate supported for receiving data. The nData parameter data type is TEBaudRate.
		FDC_NONSTDFRAM			Supported non standard framing. The nData parameter data type is BOOL.
		FDC_BITORDER			The bit order the fax supports. The nData parameter data type is TEBitOrder.
		FDC_FAXPOLLING			The caller can receive or the caller can send faxes. The nData parameter data type is BOOL.
		FDC_RESOLUTION			Supported resolution. The nData parameter data type is TEResolution.
		//***********************************************
		FDC_GET_DTMF			The fax port can detect DTMF tones in receiving mode. The nData parameter data type is BOOL.
		//***********************************************
		3. parameter: The value to be set
		Returns -1 on error, otherwise returns a non negative number.
	*/
                    SetPortCapabilities( pApp->FaxPorts[i], FDC_GET_DTMF, TRUE );
	/*************************Set the number of DTMF digist*******************************/
	/*1. parameter: Fax port object
	  2. parameter: Number of digits to wait for.
	  Returns zero on success, not zero if error occured.
	*/
					SetDigitNumber(pApp->FaxPorts[i], m_gDTMF);
	/*************************Set the number of seconds to wait for a digit**************/
	/*1. parameter: Fax port object
	  2. parameter: Number of seconds to wait.
	  Returns zero on success, otherwise returns TRUE
	*/
					SetVoiceTimeout(pApp->FaxPorts[i],20);
					char buf[30];
                    wsprintf(buf,"%s was opened.",szChannel);
					AfxMessageBox(buf);
					break;
                }
            }
        }	
	CDialog::OnOK();
}
