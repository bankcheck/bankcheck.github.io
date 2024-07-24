// DlgNms.cpp : implementation file
//

#include "stdafx.h"
#include "demo.h"
#include "DlgNms.h"
#include "faxcpp.h"
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
                // NOTE: the ClassWizard will add member initialization here
        //}}AFX_DATA_INIT
}


void CDlgNms::DoDataExchange(CDataExchange* pDX)
{ 
        CDialog::DoDataExchange(pDX);
        //{{AFX_DATA_MAP(CDlgNms)
	DDX_Control(pDX, IDC_PROTOCOLL, m_cbProtocol);
	DDX_Control(pDX, IDC_SPINDID, m_DIDSpin);
	DDX_Control(pDX, IDC_DID, m_DID);
        DDX_Control(pDX, IDC_CHANNELSNMS, m_ChannelList);
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
      for ( i=0 ; i <= pApp->m_nNmsBoard ; i++ ) {
         for ( j=0 ; j<= NMS_GetChannelNum(i) ; j++ ) {
            if ( NMS_IsChannelFree( i, j ) ) {
                wsprintf( szChName, "NMS_B%dCH%d", i, j );
                x = m_ChannelList.InsertItem( pos++, szChName );
                if ( x != -1 ) {
                    m_ChannelList.SetItemData( x, nGlobalChannel );
                    if ( !TestNms( szChName, &result ) ) {
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

	//TAMAS->
	m_cbProtocol.SetCurSel(0);
	m_DIDSpin.SetRange(0, UD_MAXVAL);
	m_DIDSpin.SetPos( 3 );
	//TAMAS<-
    
    // Identification number. (own fax number)
    CString cId = pApp->GetProfileString("Fax", "Identification String", NULL);
    SetDlgItemText(IDC_IDSTRING, cId);
	((CEdit*)GetDlgItem(IDC_IDSTRING))->LimitText(60);
	((CEdit*)GetDlgItem(IDC_DID))->LimitText(5);

    m_ChannelList.SetFocus();

        return TRUE;  // return TRUE unless you set the focus to a control
                      // EXCEPTION: OCX Property Pages should return FALSE
}

void CDlgNms::OnOK()
{
    // TODO: Add extra validation here
	int     nBaud, nEcm, nBft, nItems, i, sel;
    CString szChannel;
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    TSSessionParameters CSession;
    char      szStationID[21] ;

    // Get ID string and no. of ring to answer.
    GetDlgItemText(IDC_IDSTRING, szStationID, sizeof(szStationID));
    pApp->WriteProfileString("Fax", "Identification String", szStationID);
    SetMyID(szStationID);
    
    nItems = m_ChannelList.GetItemCount();

	BeginWaitCursor();

	for( sel=0; sel<nItems; sel++ )
	{
		if( m_ChannelList.GetItemState( sel, LVIS_SELECTED ) == LVIS_SELECTED )
		{
			if ( sel != nItems ) {
				szChannel = m_ChannelList.GetItemText( sel, 0 );

				for ( i = 0 ; i < MAX_FAXPORTS ; i++ ) {
					if ( !pApp->FaxPorts[i] ) {

						//set protocol
						char szProtocol[12];
						int nProtocolIndex = m_cbProtocol.GetCurSel();
						GetSelectedProtocoll( nProtocolIndex, szProtocol, 12 );
						NMS_SetProtocol( szProtocol );
						//

						//set digit number
						long nDID=0;
						char szDID[12];
						m_DID.GetWindowText(CString(szDID));
						nDID=atol(szDID);
						if(nDID<1 || nDID>25)
							nDID = 3;
						NMS_SetDIDDigitNumber(nDID);
						pApp->FaxPorts[i] = ConnectChannel( szChannel.GetBuffer(256), NULL, BRD_NMS );
						if ( pApp->FaxPorts[i] ) {
							int nGlobalChannelNumber;

							nGlobalChannelNumber = m_ChannelList.GetItemData( sel );
							pApp->nComm[i] = nGlobalChannelNumber + MAX_COMPORTS+MAX_FAXCHANNELS+MAX_GAMMACHANNELS+MAX_BICOMCHANNELS+MAX_CMTXCHANNELS+MAX_NMSCHANNELS;

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

							pApp->WriteProfileString(szChannel.GetBuffer(256), "Protocol", szProtocol);
							pApp->WriteProfileString(szChannel.GetBuffer(256), "DID", szDID);



							CString cId = pApp->GetProfileString("Fax", "Identification String", NULL);
							SetStationID( pApp->FaxPorts[i], cId.GetBuffer( cId.GetLength()+1 ) );
						}
						else
							AfxMessageBox( "Unable to connect channel!" );
						break;
					}
				}
			}
        }
    }
	EndWaitCursor();

    CDialog::OnOK();
}

//TAMAS->	
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
//TAMAS<-
