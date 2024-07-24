// BOpen.cpp : implementation file
//

#include "stdafx.h"
#include "QueueFaxSample.h"
#include "BOpen.h"
#include "faxcpp.h"
#include "commcl.h"
#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#define B_PORTNAME "Channel"

/////////////////////////////////////////////////////////////////////////////
// CBOpen dialog


CBOpen::CBOpen(CWnd* pParent /*=NULL*/)
	: CDialog(CBOpen::IDD, pParent)
{
	//{{AFX_DATA_INIT(CBOpen)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CBOpen::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CBOpen)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CBOpen, CDialog)
	//{{AFX_MSG_MAP(CBOpen)
	ON_BN_CLICKED(IDC_TEST, OnTest)
	ON_LBN_SELCHANGE(IDC_CHANNELS, OnSelchangeChannels)
	ON_BN_CLICKED(IDC_BROWSE, OnBrowse)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CBOpen message handlers

BOOL CBOpen::OnInitDialog() 
{
	int     nCh;
    CQueueFaxSampleApp *pApp = (CQueueFaxSampleApp *)AfxGetApp();
	// checking for brooktrout channels
    for( nCh=0 ; nCh < MAX_FAXCHANNELS && pApp->BrooktroutChannels[nCh] ; nCh++ ) {
        if ( pApp->BrooktroutChannels[nCh] == 1 || // fax or tr114 channel
                        pApp->BrooktroutChannels[nCh] >= 3 ) {
            char szCom[20];

            if ( B_IsChannelFree( nCh ) ) {
                strcpy( szCom, B_PORTNAME );
                strcat( szCom, " " );
                _itoa( nCh, &szCom[ strlen(B_PORTNAME) ], 10 );
                //szCom[ strlen(B_PORTNAME) ] = (char)nCh+'0';
                ((CListBox *)GetDlgItem(IDC_CHANNELS))->AddString(szCom);
            }
        }
    }

    CString szTmp;
	char szTmp2[200];
	GetPrivateProfileString("Brooktrout","Config file","btcall.cfg",szTmp2,200,"Demo32.INI");
    SetDlgItemText( IDC_CFILE, szTmp2 ); 

    // Identification number. (own fax number)
    CString cId = pApp->GetProfileString("Fax", "Identification String", NULL);
    SetDlgItemText(IDC_IDSTRING, cId);

	SendDlgItemMessage( IDC_CFILE, EM_LIMITTEXT, (WPARAM)255, 0L );
    SendDlgItemMessage( IDC_HDRSTRING, EM_LIMITTEXT, (WPARAM)60, 0L );
	SendDlgItemMessage( IDC_IDSTRING, EM_LIMITTEXT, (WPARAM)60, 0L );
	CDialog::OnInitDialog();
	
	// TODO: Add extra initialization here
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CBOpen::OnTest() 
{
	TSTestResult ts;
    int i;

    memset(&ts, 0, sizeof(ts));

    CListBox *cPortList =(CListBox *)GetDlgItem(IDC_CHANNELS);
    char szPortName[10];
    memset( szPortName, 0, sizeof(szPortName) );
    i = cPortList->GetCurSel();
    if ( i != LB_ERR ) {
        cPortList->GetText( i, szPortName );
        BeginWaitCursor();
        int iError = TestBrooktrout( (LPSTR)szPortName, &ts );
        EndWaitCursor();
        SetDlgItemText( IDC_TYPE, ts.Model );
    }	
}

void CBOpen::OnSelchangeChannels() 
{
	SetDlgItemText( IDC_TYPE, "" );	
}

void CBOpen::OnOK() 
{
	CListBox  *cPortList ;
    CEdit     *cEdit;
    char      szPortName[10], szCFile[256];
    CQueueFaxSampleApp   *pApp = (CQueueFaxSampleApp *)AfxGetApp();
    int       nBaud, nEcm, nBft, sel, nRings ;
    TSSessionParameters CSession;
    char      szStationID[21] ;

    cPortList =(CListBox *)GetDlgItem( IDC_CHANNELS );
    sel = cPortList->GetCurSel();
    if ( sel != LB_ERR ) {
        cPortList->GetText( sel, szPortName );

        /*cEdit =(CEdit *)GetDlgItem( IDC_HDRSTRING );		This CEdit does not exist on the form!
        memset( szCFile, 0, sizeof(szCFile) );
        cEdit->GetLine( 0, szCFile, sizeof(szCFile) );
        pApp->WriteProfileString( "Brooktrout", "Header", szCFile );*/

        cEdit =(CEdit *)GetDlgItem( IDC_CFILE );
        memset( szCFile, 0, sizeof(szCFile) );
        cEdit->GetLine( 0, szCFile, sizeof(szCFile) );
		WritePrivateProfileString("Brooktrout","Config file",szCFile,"Demo32.ini");


        // Get ID string and no. of ring to answer.
        GetDlgItemText(IDC_IDSTRING, szStationID, sizeof(szStationID));
        pApp->WriteProfileString("Fax", "Identification String", szStationID);
        SetMyID(szStationID);

        // Find and empty faxport.
        for ( int i = 0 ; i < MAX_FAXPORTS ; i++ ) {
            if ( !pApp->FaxPorts[i] ) {
                pApp->FaxPorts[i] = ConnectPortExt(szPortName, NULL, szCFile );

                if ( !pApp->FaxPorts[i] ) {
                    AfxMessageBox("Unable to connect port!");
                    return;
                } else {
                    pApp->nComm[i] = atoi( &szPortName[strlen(B_PORTNAME)] ) + MAX_COMPORTS;
                    pApp->FaxEventText(i, "Port Open");
                    SetRuningMode(pApp->RunMode);
                    GetSessionParameters( pApp->FaxPorts[i], &CSession );
                    pApp->nRings[i] = CSession.RingToAnswer;

                    nRings = GetCheckedRadioButton( IDC_HEADER, IDC_FOOTER );
                    pApp->FaxPorts[i]->SetHeaderType( nRings==IDC_HEADER );
                    CString cHdr = pApp->GetProfileString( "Brooktrout", "Header", NULL );
                    SetHeader( pApp->FaxPorts[i], cHdr.GetBuffer(250) );

                    nBaud = pApp->GetProfileInt("Fax", "MAXBAUD", 4);
                    nEcm = pApp->GetProfileInt("Fax", "Enable ECM Receive", ECM_ENABLE );
                    nBft = pApp->GetProfileInt("Fax", "Enable BFT", BFT_DISABLE );
                        nBaud = BDR_14400;
                    SetPortCapabilities(pApp->FaxPorts[i], FDC_BAUD_SEND, nBaud);
                    SetPortCapabilities(pApp->FaxPorts[i], FDC_ECM, nEcm);
                    SetPortCapabilities(pApp->FaxPorts[i], FDC_BINARY, nBft);
                    SetPortCapabilities(pApp->FaxPorts[i], FDC_GET_DTMF, TRUE );

                    CString cId = pApp->GetProfileString("Fax", "Identification String", NULL);
                    SetStationID( pApp->FaxPorts[i], cId.GetBuffer( cId.GetLength()+1 ) );
                }
                break;
            }
        }
	CDialog::OnOK();
	}
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
