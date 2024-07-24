// BOpen.cpp : implementation file
//

#include "stdafx.h"
#include "ReceiveFaxWithDTMF.h"
#include "BOpen.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CBOpen dialog


CBOpen::CBOpen(CWnd* pParent /*=NULL*/)
	: CDialog(CBOpen::IDD, pParent)
{
	//{{AFX_DATA_INIT(CBOpen)
	//}}AFX_DATA_INIT
}


void CBOpen::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CBOpen)
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CBOpen, CDialog)
	//{{AFX_MSG_MAP(CBOpen)
	ON_BN_CLICKED(IDC_BROWSE, OnBrowse)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CBOpen message handlers

BOOL CBOpen::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	CReceiveFaxWithDTMFApp     *pApp = (CReceiveFaxWithDTMFApp *)AfxGetApp();
	if (( pApp->BrooktroutChannels && pApp->BrooktroutChannels[0]))
	{
		for(int nCh=0 ; nCh < MAX_FAXCHANNELS && pApp->BrooktroutChannels[nCh] ; nCh++ )
		{
			if ( pApp->BrooktroutChannels[nCh] == 1 || // fax or tr114 channel
			    pApp->BrooktroutChannels[nCh] >= 3 ) 
			{
				char szCom[20];
	            if ( B_IsChannelFree( nCh ) )
				{
					strcpy( szCom, "Channel" );
					_itoa( nCh, &szCom[ strlen("Channel") ], 10 );
					((CListBox *)GetDlgItem(IDC_BCHANNELS))->AddString(szCom);
				}
			}
		}

		CString szTmp;
		char szTmp2[200];
		GetPrivateProfileString("Brooktrout","Config file","btcall.cfg",szTmp2,200,"Demo32.INI");
		SetDlgItemText( IDC_CFILE, szTmp2 );

		((CListBox *) GetDlgItem(IDC_BCHANNELS))->SetCurSel(0);
	}	
	((CEdit *)GetDlgItem(IDC_BDTMF))->LimitText(1);
	SetDlgItemText(IDC_BDTMF,"4");
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CBOpen::OnBrowse() 
{
	LPSTR GroupFilterBuff =
    "Config Files (*.cfg)\0*.CFG\0"
    "All Files\0*.*\0";
	CFileDialog *dlgFile=new CFileDialog(TRUE);
	dlgFile->m_ofn.lpstrTitle = "Open";
	dlgFile->m_ofn.lpstrFilter = GroupFilterBuff;
	if (dlgFile->DoModal()==IDOK)
		SetDlgItemText( IDC_CFILE,dlgFile->m_ofn.lpstrFileTitle);;

	delete dlgFile;		
}

void CBOpen::OnOK() 
{
	CListBox  *cPortList;
	CReceiveFaxWithDTMFApp     *pApp = (CReceiveFaxWithDTMFApp *)AfxGetApp();
	CEdit     *cEdit;
	char szChannel[10],szCFile[256];
	char buf[30];
	BeginWaitCursor();
	cPortList =(CListBox *)GetDlgItem( IDC_BCHANNELS );
	cPortList->GetText( cPortList->GetCurSel(), szChannel );
	cEdit =(CEdit *)GetDlgItem( IDC_CFILE );
    memset( szCFile, 0, sizeof(szCFile) );
    cEdit->GetLine( 0, szCFile, sizeof(szCFile) );
	WritePrivateProfileString("Brooktrout","Config file",szCFile,"Demo32.ini");

	int m_bDTMF=GetDlgItemInt(IDC_BDTMF,NULL,FALSE);
	 for ( int i = 0 ; i < MAX_FAXPORTS ; i++ ) {
            if ( !pApp->FaxPorts[i] ) {
	
	/*********************Connect the channel to the fax hardware.**************************/
	/*1. parameter: Name of the Brooktrout channel.(Channel1, Channel2... etc.).
	  2. parameter: This parameter should point to the string "Brooktrout Channel" or can be NULL.
	  3. parameter: Name of the configuration file that contains the settings for the fax hardware ("BTCALL.CFG")
	  Returns fax port object on success, otherwise returns zero.
	*/
 //               pApp->FaxPorts[i] = ConnectPortExt(szChannel, NULL, szCFile );
	/*
	You can also use ConnectChannel instead of ConnectPortExt to create a Brooktrout Fax Port object.
	1. parameter: Name of the Brooktrout channel. (Channel1, Channel2... etc.).
	2. parameter: Name of the configuration file that contains the settings for the fax hardware ("BTCALL.CFG")
	3. parameter: The type of the fax board.(BRD_BROOKTROUT)
	Returns: - fax port object on success
			 - NULL,  if szChannel or szCFile is NULL.
			 - FER_NO_FIRMWARE, if the library can’t locate or download the Firmware.
			 */
				pApp->FaxPorts[i]=ConnectChannel(szChannel,szCFile,BRD_BROOKTROUT);
	
				
                if ( !pApp->FaxPorts[i] ) {
                    AfxMessageBox("Unable to connect channel!");
					EndWaitCursor();
                    return;
                } else {
                    wsprintf(buf,"%s was opened.",szChannel);
					AfxMessageBox(buf);
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
					SetDigitNumber(pApp->FaxPorts[i], m_bDTMF);
	/*************************Set the number of seconds to wait for a digit**************/
	/*1. parameter: Fax port object
	  2. parameter: Number of seconds to wait.
	  Returns zero on success, otherwise returns TRUE
	*/
					SetVoiceTimeout(pApp->FaxPorts[i],20);
                }
                break;
            }
        }
	EndWaitCursor();		
	CDialog::OnOK();
}
