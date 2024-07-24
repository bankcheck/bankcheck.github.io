// NMSOpen.cpp : implementation file
//

#include "stdafx.h"
#include "ReceiveDTMFandDecideToReceiveFaxOrVoice.h"
#include "NMSOpen.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CNMSOpen dialog


CNMSOpen::CNMSOpen(CWnd* pParent /*=NULL*/)
        : CDialog(CNMSOpen::IDD, pParent)
{
    //{{AFX_DATA_INIT(CNMSOpen)
	//}}AFX_DATA_INIT
}


void CNMSOpen::DoDataExchange(CDataExchange* pDX)
{
        CDialog::DoDataExchange(pDX);
        //{{AFX_DATA_MAP(CNMSOpen)
	DDX_Control(pDX, IDC_PROTOCOLL, m_cbProtocol);
	DDX_Control(pDX, IDC_DID, m_DID);
	DDX_Control(pDX, IDC_SPINDID, m_DIDSpin);
        DDX_Control(pDX, IDC_LIST1, m_ChList);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CNMSOpen, CDialog)
        //{{AFX_MSG_MAP(CNMSOpen)
    ON_NOTIFY(NM_DBLCLK, IDC_LIST1, OnOK1)
	ON_WM_SETCURSOR()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CNMSOpen message handlers



void CNMSOpen::OnOK()
{
	CString	szChannel;
	int		nItems = m_ChList.GetItemCount();
   
    DestroyModemObject();

    int nSel;
    for ( nSel=0 ; (nSel<nItems) && (m_ChList.GetItemState( nSel, LVIS_SELECTED ) != LVIS_SELECTED );nSel++ ) ;

    if( nSel < nItems )
    {
        MODEMOBJ Modem = mdm_CreateModemObject(MOD_NMS);
	    int nRings = theApp.GetProfileInt(g_szSection,"Rings",3);
 

        szChannel = m_ChList.GetItemText( nSel, 0 );

		//set protocol
		char szProtocol[12];
		int nProtocolIndex = m_cbProtocol.GetCurSel();
		GetSelectedProtocoll( nProtocolIndex, szProtocol, 12 );
        mdm_NMS_SetProtocol( szProtocol );

        if( Modem )
        {
			//set digit number
			int nDID=0;
			char szDID[12];
			m_DID.GetWindowText(CString(szDID));
			nDID=atoi(szDID);
			if(nDID<1 || nDID>25)
				nDID = 3;
    
            mdm_DID_SetDigitNumber(Modem, nDID);

			theApp.SetOpenModem(Modem);
            Modem->SetModemLong((LONG)this);

	        m_bWaitCursor = TRUE;
	        BeginWaitCursor();

		    Modem->WaitForRings(nRings);
            if(!Modem->OpenPort(szChannel)) {
                AfxMessageBox("Cannot open channel!");
            }
			else
				AfxMessageBox("Channel opened");
        }
    }
}

BOOL CNMSOpen::OnInitDialog()
{
char        szCh[20];
LV_COLUMN   lvColumn;
int         nItem   = 0;
int         nBoards = mdm_NMS_GetBoardNum();


    CDialog::OnInitDialog();
	
	// For receiving fax messages
    SetFaxMessage(m_hWnd);
	nMessage = RegisterWindowMessage(REG_FAXMESSAGE);

    lvColumn.mask   = LVCF_FMT | LVCF_WIDTH | LVCF_TEXT | LVCF_SUBITEM;
    lvColumn.fmt    = LVCFMT_LEFT;
    lvColumn.pszText = "Name";
    lvColumn.cx     = 100;
    lvColumn.iSubItem = 0;
    m_ChList.InsertColumn( 0, &lvColumn );

    lvColumn.pszText = "Type";
    lvColumn.iSubItem = 1;
    lvColumn.cx     = 180;
    m_ChList.InsertColumn( 1, &lvColumn );

    for( int board = 1; board <= nBoards; board++ )
    {
        for( int channel = 1; channel <= mdm_NMS_GetChannelNum(board-1); channel++ )
        {
            if( mdm_NMS_IsChannelFree(board-1,channel-1) )
            {
                sprintf( szCh,"NMS_B%dCH%d",board-1,channel-1);
                nItem = m_ChList.InsertItem(nItem,szCh);
                m_ChList.SetItemText(nItem,1,"NMS board");
                nItem++;
            }
        }
    }

	m_cbProtocol.SetCurSel(0);
	m_DIDSpin.SetRange(0, UD_MAXVAL);
	m_DIDSpin.SetPos( 3 );

    return TRUE;  // return TRUE unless you set the focus to a control
                  // EXCEPTION: OCX Property Pages should return FALSE
}

LRESULT CNMSOpen::WindowProc(UINT message, WPARAM wParam, LPARAM lParam)
{
    m_bWaitCursor=FALSE;

	if ( nMessage == message )
	{
		EndWaitCursor();
		m_bWaitCursor = FALSE;
		if ( wParam == MFX_NO_CARRIER ||
			 wParam == MFX_NO_DIALTONE ||
			 wParam == MFX_BUSY ||
			 wParam == MFX_ERROR)
		{
			DestroyModemObject();
			AfxMessageBox("Cannot open channel!");
		}
		else if ( wParam == MFX_MODEM_OK )
			CDialog::OnOK();
	}
	return CDialog::WindowProc(message, wParam, lParam);
}

BOOL CNMSOpen::OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message) 
{
	// TODO: Add your message handler code here and/or call default
	if(m_bWaitCursor)
		return TRUE;
	else
		return CDialog::OnSetCursor(pWnd, nHitTest, message);
}

void CNMSOpen::DestroyModemObject()
{
	if( theApp.GetOpenModem() )
	{
		theApp.GetOpenModem()->DestroyModemObject();
		theApp.SetOpenModem(NULL);
	}
}

void CNMSOpen::EnableControls(BOOL bEnable)
{
    GetDlgItem(IDOK)->EnableWindow(bEnable);
    GetDlgItem(IDCANCEL)->EnableWindow(bEnable);
}

void CNMSOpen::GetSelectedProtocoll(int nProtocolIndex, char * szProtocol, int maxSize)
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

//because VC 7.0
void CNMSOpen::OnOK1(NMHDR* param1, LRESULT* param2)
{
	OnOK();
}
