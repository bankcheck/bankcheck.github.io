// DlgNms.cpp : implementation file
//

#include "stdafx.h"
#include "ReceiveFaxWithDTMF.h"
#include "DlgNms.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDlgNms dialog


CDlgNms::CDlgNms(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgNms::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDlgNms)
	//}}AFX_DATA_INIT
}


void CDlgNms::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDlgNms)
	DDX_Control(pDX, IDC_PROTOCOLL, m_cbProtocol);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDlgNms, CDialog)
	//{{AFX_MSG_MAP(CDlgNms)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgNms message handlers

BOOL CDlgNms::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	CReceiveFaxWithDTMFApp     *pApp = (CReceiveFaxWithDTMFApp *)AfxGetApp();
	CListBox *pPortBox = (CListBox *)GetDlgItem(IDC_NMS);
	char    szChName[15];
	for (int i=0 ; i <= pApp->m_nNmsBoard ; i++ ) 
        for (int j=0 ; j<= NMS_GetChannelNum(i) ; j++ ) 
            if ( NMS_IsChannelFree( i, j ) ) {
                wsprintf( szChName, "NMS_B%dCH%d", i, j );
				pPortBox->AddString(szChName);
			}
	((CEdit *)GetDlgItem(IDC_NDTMF))->LimitText(1);
    m_cbProtocol.SetCurSel(0);
	SetDlgItemText(IDC_NDTMF,"4");
	pPortBox->SetCurSel(0);		
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CDlgNms::OnOK() 
{
	CReceiveFaxWithDTMFApp     *pApp = (CReceiveFaxWithDTMFApp *)AfxGetApp();
	char szChannel[15];
	char buf[30];
	CListBox  *cPortList;
	BeginWaitCursor();
	cPortList=(CListBox *)GetDlgItem(IDC_NMS);
	cPortList->GetText(cPortList->GetCurSel(), szChannel);
	int m_nDTMF=GetDlgItemInt(IDC_NDTMF,NULL,FALSE);
	for(int i=0;i<MAX_FAXPORTS;i++)
		if (!pApp->FaxPorts[i])
		{
			char szProtocol[12];
			int nProtocolIndex = m_cbProtocol.GetCurSel();
			GetSelectedProtocoll( nProtocolIndex, szProtocol, 12 );
	/*********************Set the telephony protocol**************************/
	/*This function sets the telephony protocol used with the NMS board. 
	By default FaxC++ will use the Analog Loop-start telephony protocol.
	If other protocols are needed, call this function before opening any fax channel, 
	but after the SetupFaxDriver() function was called.
	The szProtocol parameter should have one of the following values:
Protocol Name		NMS Boards								Description
 (szProtocol)
	"LPS0"				AG-8								Analog Loop-start
	"LPS8"		AG-T1 or AG Dual T							Digital Loop-start (OPS-FX)
	"LPS9"		AG-T1 or AG Dual T							Digital Loop-start (OPS-SA)
	"DID0"		AG-T1, AG Dual T, AG Quad  T or AG-8/DID	Digital/Analog Wink-start (inbound only)
	"FDI0"		AG-8/DID									Feature Group D (inbound only)
	"GST8"		AG-T1 or AG Dual T							Digital Ground-start (OPS-FX)
	"GST9"		AG-T1 or AG Dual T							Digital Ground-start (OPS-SA)
	"OGT0"		AG-T1, AG Dual T, AG Quad  T or AG-8/DID	Digital/Analog Wink-start (outbound only)
	"WNK0"		AG-T1, AG Dual T, AG Quad  T or AG-8/DID	Digital/Analog Wink-start
	"WNK1"		AG-8/E&M									Analog Wink-start*/

			NMS_SetProtocol( szProtocol );
	/*********************Connect the channel to the fax hardware.**************************/
	/*
	1. parameter: Name of the NMS channel. 
	2. parameter: Name of the configuration file that contains the settings for the fax hardware.
				  It is NULL for NMS boards.
	3. parameter: The type of the fax board.(BRD_NMS)
	Returns: - fax port object on success
			 - NULL,  if szChannel is NULL.*/
			pApp->FaxPorts[i]=ConnectChannel(szChannel,NULL,BRD_NMS);
	/* You can also use ConnectPortExt to connect the NMS channel to the fax hardware.
		1. parameter: Name of the NMS channel. 
		2. parameter: This parameter should point to the string "NMS Channel".
		3. parameter: Must be NULL.
			pApp->FaxPorts[i]=ConnectPortExt(szChannel,"NMS Channel",NULL);	
		*/
			if (pApp->FaxPorts[i]){
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
					SetDigitNumber(pApp->FaxPorts[i], m_nDTMF);
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

void CDlgNms::GetSelectedProtocoll(int nProtocolIndex, char * szProtocol, int maxSize)
{
    switch(nProtocolIndex) {
        case 0:
            strcpy(szProtocol,"LPS0");
        break;
        case 1:
            strcpy(szProtocol,"DID0");
        break;
        case 2:
            strcpy(szProtocol,"OGT0");
        break;
        case 3:
            strcpy(szProtocol,"WNK0");
        break;
        case 4:
            strcpy(szProtocol,"WNK1");
        break;
        case 5:
            strcpy(szProtocol,"LPS8");
        break;
        case 6:
            strcpy(szProtocol,"FDI0");
        break;
        case 7:
            strcpy(szProtocol,"LPS9");
        break;
        case 8:
            strcpy(szProtocol,"GST8");
        break;
        case 9:
            strcpy(szProtocol,"GST9");
        break;
        case 10:
            strcpy(szProtocol,"ISD0");
        break;
        case 11:
            strcpy(szProtocol,"MFC0");
        break;
        default:
            strcpy(szProtocol,"LPS0");
    }
}
