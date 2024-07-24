// OpenDialogic.cpp : implementation file
//

#include "stdafx.h"
#include "ReceiveFaxWithDTMF.h"
#include "OpenDialogic.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// COpenDialogic dialog


COpenDialogic::COpenDialogic(CWnd* pParent /*=NULL*/)
	: CDialog(COpenDialogic::IDD, pParent)
{
	//{{AFX_DATA_INIT(COpenDialogic)
	//}}AFX_DATA_INIT
}


void COpenDialogic::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(COpenDialogic)
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(COpenDialogic, CDialog)
	//{{AFX_MSG_MAP(COpenDialogic)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// COpenDialogic message handlers

BOOL COpenDialogic::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	CReceiveFaxWithDTMFApp     *pApp = (CReceiveFaxWithDTMFApp *)AfxGetApp();
	CListBox *pPortBox = (CListBox *)GetDlgItem(IDC_CHANNELS);
	char    szChName[15];
	for (int i=1 ; i <= pApp->m_nDialogicBoard ; i++ ) 
        for (int j=1 ; j<= D_GetChannelNum(i) ; j++ ) 
            if ( D_IsChannelFree( i, j ) ) {
                wsprintf( szChName, "dxxxB%dC%d", i, j );
				pPortBox->AddString(szChName);
			}
    ((CEdit *)GetDlgItem(IDC_DDTMF))->LimitText(1);
	SetDlgItemText(IDC_DDTMF,"4");
	pPortBox->SetCurSel(0);		
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void COpenDialogic::OnOK() 
{
	CReceiveFaxWithDTMFApp     *pApp = (CReceiveFaxWithDTMFApp *)AfxGetApp();
	char szChannel[15];
	char buf[30];
	CListBox  *cPortList;
	BeginWaitCursor();
	cPortList=(CListBox *)GetDlgItem(IDC_CHANNELS);
	cPortList->GetText(cPortList->GetCurSel(), szChannel);
	int m_dDTMF=GetDlgItemInt(IDC_DDTMF,NULL,FALSE);
	for(int i=0;i<MAX_FAXPORTS;i++)
		if (!pApp->FaxPorts[i])
		{
		/*********************Connect the channel to the fax hardware.**************************/
		/*
		1. parameter: Name of the Dialogic channel.The name should be in the form ‘dxxxB1C1’ where the number 
		after B specifies the number of the board,the number after C specifies the number of the channel.
		2. parameter: Name of the configuration file that contains the settings for the fax hardware.
					  It is NULL for Dialogic Board.
		3. parameter: The type of the fax board.(BRD_DIALOGIC)
		Returns: - fax port object on success
				 - NULL,  if szChannel is NULL.
		*/
			pApp->FaxPorts[i]=ConnectChannel(szChannel,NULL,BRD_DIALOGIC);
		/* You can also use ConnectPortExt to connect the Dialogic channel to the fax hardware.
		1. parameter: Name of the Dialogic channel. The name should be in the 
					  form ‘dxxxB1C1’ where the number after B specifies the number of the board, 
					  the number after C specifies the number of the channel.
		2. parameter: This parameter should point to the string "Dialogic Channel".
		3. parameter: Must be NULL.
			pApp->FaxPorts[i]=ConnectPortExt(szChannel,"Dialogic Channel",NULL);
		*/
			if (pApp->FaxPorts[i]){
	/*****************************Set Port Capabilities**************************************/
	/*1. parameter: Fax port object.
	  2. parameter: Type of capability to be set. It can be one of the following indexes:

		FDC_SETCOMPRESS         Compression type the driver can handle and pass it on in the HDLC frame.
								The 3. parameter is a TECompression data type.
		FDC_ONLINECOMPRESS		Compression type the device can handle on line.
								The 3. parameter is a TECompression data type.
								Not utilized in this release.
		FDC_ECM                 If the 3. parameter is ECM_ENABLE the modem can handle Error Correction Mode.
								The 3. parameter data type is enum. See faxtype.h. 
		FDC_BINARY              If the 3. parameter is BFT_ENABLE the modem can handle binary transmission.
								The 3. parameter data type is enum.
		FDC_WIDTH               Width of the paper supported. The 3. parameter data type is TEPageWidth.
		FDC_LENGTH              Length of the paper supported. The 3. parameter data type is TEPageLength.
		FDC_BAUD_SEND			Communication baud rate supported for sending data. The returned value data type is TEBaudRate.
		FDC_BAUD_REC			Communication baud rate supported for receiving data. The 3. parameter data type is TEBaudRate.
		FDC_NONSTDFRAM			Supported non standard framing. The 3. parameter data type is BOOL.
		FDC_BITORDER			The bit order the fax supports. The 3. parameter data type is TEBitOrder.
		FDC_FAXPOLLING			The caller can receive or the caller can send faxes. The 3. parameter data type is BOOL.
		FDC_RESOLUTION			Supported resolution. The 3. parameter data type is TEResolution.
		//***********************************************
		FDC_GET_DTMF			The fax port can detect DTMF tones in receiving mode. The 3. parameter data type is BOOL.
		//***********************************************
		3. parameter: The value to be set
		Returns -1 on error, otherwise returns a non negative number.
	*/
                    SetPortCapabilities( pApp->FaxPorts[i], FDC_GET_DTMF, TRUE );
	/*************************Set the number of DTMF digits*******************************/
	/*1. parameter: Fax port object
	  2. parameter: Number of digits to wait for.
	  Returns zero on success, not zero if error occured.
	*/
					SetDigitNumber(pApp->FaxPorts[i], m_dDTMF);
	/*************************Set the number of seconds to wait for a digit**************/
	/*1. parameter: Fax port object
	  2. parameter: Number of seconds to wait.
	  Returns zero on success, otherwise returns TRUE
	*/
					SetVoiceTimeout(pApp->FaxPorts[i],20);
				wsprintf(buf,"%s was opened.",szChannel);
				AfxMessageBox(buf);
				break;
			}
			else 
			{
				AfxMessageBox("Unable to connect channel!");
				EndWaitCursor();
				return;
			}
		}
	EndWaitCursor();		
	CDialog::OnOK();
}
