// DlgBc.cpp : implementation file
//

#include "stdafx.h"
#include "demo.h"
#include "DlgBc.h"
#include "faxcpp.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// COpenBicom dialog


COpenBicom::COpenBicom(CWnd* pParent /*=NULL*/)
        : CDialog(COpenBicom::IDD, pParent)
{
        //{{AFX_DATA_INIT(COpenBicom)
                // NOTE: the ClassWizard will add member initialization here
        //}}AFX_DATA_INIT
}


void COpenBicom::DoDataExchange(CDataExchange* pDX)
{
        CDialog::DoDataExchange(pDX);
        //{{AFX_DATA_MAP(COpenBicom)
        DDX_Control(pDX, IDC_CHANNELSBC, m_ChannelList);
        //}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(COpenBicom, CDialog)
        //{{AFX_MSG_MAP(COpenBicom)
        //}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// COpenBicom message handlers

BOOL COpenBicom::OnInitDialog()
{

   //     CDialog::OnInitDialog();

        // TODO: Add extra initialization here
    char    szChName[25];
    LV_COLUMN lvColumn;
    CDialog::OnInitDialog();
    CImgApp* pApp = (CImgApp *)AfxGetApp();
    lvColumn.mask   = LVCF_FMT | LVCF_WIDTH | LVCF_TEXT | LVCF_SUBITEM;
    lvColumn.fmt    = LVCFMT_LEFT;
    lvColumn.pszText = szChName;
    sprintf( szChName, "Name" );
    lvColumn.cx     = 100;
    lvColumn.iSubItem = 0;
        m_ChannelList.InsertColumn( 0, &lvColumn );

    sprintf( szChName, "Type" );
    lvColumn.iSubItem = 1;
    lvColumn.cx     = 180;
    m_ChannelList.InsertColumn( 1, &lvColumn );

    int     i, j, x, pos=0, nGlobalChannel=0;
    TSTestResult result;
      for ( i=1 ; i <= pApp->m_nBicomBoard ; i++ ) {
         for ( j=1 ; j<= BCM_GetChannelNum(i) ; j++ ) {
            if ( BCM_IsChannelFree( i, j ) ) {
                wsprintf( szChName, "BCM_MB%dCH%d", i, j );
                x = m_ChannelList.InsertItem( pos++, szChName );
                if ( x != -1 ) {
                    m_ChannelList.SetItemData( x, nGlobalChannel );
                    if ( !TestBicom( szChName, &result ) ) {
                        m_ChannelList.SetItemText( x, 1, result.Model );
                    }
                }
                else
                    return FALSE;
            }
            nGlobalChannel++; // increment global channel counter
        }
    }
    m_ChannelList.SetItemState( m_ChannelList.GetTopIndex(),
                                LVIS_SELECTED | LVIS_FOCUSED,
                                LVIS_SELECTED | LVIS_FOCUSED );
    // Header settings
    ((CButton *)GetDlgItem(IDC_HEADERBC))->SetCheck( pApp->GetProfileInt( "Fax", "Header", 1 ) );

    m_ChannelList.SetFocus();

        return TRUE;  // return TRUE unless you set the focus to a control
                      // EXCEPTION: OCX Property Pages should return FALSE
}

void COpenBicom::OnOK()
{
        // TODO: Add extra validation here
int     nBaud, nEcm, nBft, nItems, i, sel;
    CString szChannel;
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    TSSessionParameters CSession;

    nItems = m_ChannelList.GetItemCount();
    for ( sel=0 ; (sel<nItems) && (m_ChannelList.GetItemState( sel, LVIS_SELECTED ) != LVIS_SELECTED ) ;
                                        sel++ ) ;
    if ( sel != nItems ) {
        szChannel = m_ChannelList.GetItemText( sel, 0 );

        for ( i = 0 ; i < MAX_FAXPORTS ; i++ ) {
            if ( !pApp->FaxPorts[i] ) {
                pApp->FaxPorts[i] = ConnectChannel( szChannel.GetBuffer(256), NULL, BRD_BICOM );
                if ( pApp->FaxPorts[i] ) {
                    int nGlobalChannelNumber;

                    nGlobalChannelNumber = m_ChannelList.GetItemData( sel );
                    pApp->nComm[i] = nGlobalChannelNumber + MAX_COMPORTS+MAX_FAXCHANNELS+MAX_GAMMACHANNELS+MAX_BICOMCHANNELS;

                    pApp->FaxEventText( i, "Port Open" );
                    SetRuningMode(pApp->RunMode);
                    GetSessionParameters( pApp->FaxPorts[i], &CSession );
                    pApp->nRings[i] = CSession.RingToAnswer;

                    nBaud = pApp->GetProfileInt("Fax", "MAXBAUD", 4);
                    nEcm = pApp->GetProfileInt("Fax", "Enable ECM Receive", ECM_ENABLE );
                    nBft = pApp->GetProfileInt("Fax", "Enable BFT", BFT_DISABLE );
                    if ( nBaud<=0 || nBaud>=BDR_END )
                        nBaud = BDR_14400;
                    SetPortCapabilities( pApp->FaxPorts[i], FDC_BAUD_SEND, nBaud);
                    SetPortCapabilities( pApp->FaxPorts[i], FDC_BAUD_REC,  nBaud);
                    SetPortCapabilities( pApp->FaxPorts[i], FDC_ECM, nEcm);
                    SetPortCapabilities( pApp->FaxPorts[i], FDC_BINARY, nBft);
                    SetPortCapabilities( pApp->FaxPorts[i], FDC_GET_DTMF, TRUE );

                    int cHdr=pApp->WriteProfileInt( "Fax", "Header", ((CButton *)GetDlgItem(IDC_HEADERBC))->GetCheck() );


                    //if ( ((CButton *)GetDlgItem(IDC_HEADER))->GetCheck() )
                    //    D_HeaderMode( pApp->FaxPorts[i], DHDR_INSERT | DHDR_FMT1 );

                    CString cId = pApp->GetProfileString("Fax", "Identification String", NULL);
                    SetStationID( pApp->FaxPorts[i], cId.GetBuffer( cId.GetLength()+1 ) );
                }
                else
                    AfxMessageBox( "Unable to connect channel!" );
                break;
            }
        }
    }
        CDialog::OnOK();
}
