// DialogicOpen.cpp : implementation file
//

#include "stdafx.h"
#include "Interactive Voice Sample.h"
#include "DialogicOpen.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDialogicOpen dialog

CDialogicOpen::CDialogicOpen(CWnd* pParent /*=NULL*/)
	: CDialog(CDialogicOpen::IDD, pParent)
{
    m_bWaitCursor = FALSE;
	//{{AFX_DATA_INIT(CDialogicOpen)
	m_szProtocol = _T("us_mf_io");
	m_bPAMD = FALSE;
	//}}AFX_DATA_INIT
}


void CDialogicOpen::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDialogicOpen)
	DDX_Control(pDX, IDC_LINETYPE, m_cbLineType);
	DDX_Control(pDX, IDC_LIST1, m_ChannelList);
	DDX_Text(pDX, IDC_PROTOCOL, m_szProtocol);
	DDV_MaxChars(pDX, m_szProtocol, 64);
	DDX_Check(pDX, IDC_PAMD, m_bPAMD);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDialogicOpen, CDialog)
	//{{AFX_MSG_MAP(CDialogicOpen)
	ON_CBN_SELCHANGE(IDC_LINETYPE, OnSelchangeLinetype)
	ON_NOTIFY(NM_DBLCLK, IDC_LIST1, OnDblclkList1)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDialogicOpen message handlers
void CDialogicOpen::OnVoiceMsg(int event)
{
    EndWaitCursor();
    m_bWaitCursor=FALSE;

	if( event == MFX_MODEM_OK )
    {
		if( theApp.GetOpenModem() )
		{
			UpdateData(TRUE);
			if(m_bPAMD)
				mdm_SetParameters(theApp.GetOpenModem(), MDM_ENABLE_ANSVERING_MACHINE_DETECTION, TRUE);
			else
				mdm_SetParameters(theApp.GetOpenModem(), MDM_ENABLE_ANSVERING_MACHINE_DETECTION, FALSE);
		}		
		
        CDialog::OnOK();
    }
    else
    {
		DestroyModemObject();
        AfxMessageBox("Cannot open channel!");
        EnableControls(TRUE);
    }
}

void CDialogicOpen::OnOK() 
{
    CString		szChannel;
    int			nItems = m_ChannelList.GetItemCount();
    CString protocol;

    GetDlgItem(IDC_PROTOCOL)->GetWindowText(protocol);

    int nIndex = m_cbLineType.GetCurSel();

    if( (strlen(protocol.GetBuffer(64))==0) && ( nIndex == 2 || nIndex == 3) )  {
        AfxMessageBox("Please specify a valid protocol name!");
        return;
    }

	DestroyModemObject();

	int nSel;
	for ( nSel=0 ; (nSel<nItems) && (m_ChannelList.GetItemState( nSel, LVIS_SELECTED ) != LVIS_SELECTED ) ;
			nSel++ ) ;

	if( nSel < nItems )
	{
    	MODEMOBJ Modem = mdm_CreateModemObject(MOD_DIALOGIC);

        szChannel = m_ChannelList.GetItemText( nSel, 0 );

        if( Modem )
        {
            
            switch (nIndex){
                default:
                case 0:
                    mdm_D_SetLineType(Modem, LINETYPE_ANALOG);
                    break;
                case 1:
                    mdm_D_SetLineType(Modem, LINETYPE_ISDN);
                    break;
                case 2:
                    mdm_D_SetLineType(Modem, LINETYPE_T1);
                    mdm_D_SetProtocol(Modem, protocol.GetBuffer(64));
                    break;
                case 3:
                    mdm_D_SetLineType(Modem, LINETYPE_E1);
                    mdm_D_SetProtocol(Modem, protocol.GetBuffer(64));
                    break;
            }

            theApp.SetOpenModem(Modem);
            Modem->SetModemLong((LONG)this);
            EnableControls(FALSE);
            if( Modem->OpenPort(szChannel) )
            {
                m_bWaitCursor = TRUE;
                BeginWaitCursor();
            }
            else
            {
                AfxMessageBox("Cannot open channel!");
                DestroyModemObject();
                EnableControls(TRUE);
            }
        }
    }

}

BOOL CDialogicOpen::OnInitDialog() 
{
int				i, j, x;
char			szChName[25];
LV_COLUMN		lvColumn;
TSTestResult	result;
int				pos=0;
int				nGlobalChannel=0;

	CDialog::OnInitDialog();

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

    for ( i=1 ; i <= mdm_D_GetBoardNum() ; i++ ) 
	{
        for ( j=1 ; j<= mdm_D_GetChannelNum(i) ; j++ ) 
		{
            if ( mdm_D_IsChannelFree( i, j ) ) 
			{
                wsprintf( szChName, "dxxxB%dC%d", i, j );
                x = m_ChannelList.InsertItem( pos++, szChName );
                if ( x != -1 ) 
				{
                    m_ChannelList.SetItemData( x, nGlobalChannel );
                    if ( !mdm_TestDialogic( szChName, &result ) ) 
					{
                        m_ChannelList.SetItemText( x, 1, result.Model );
                    }
                }
                else
                {
                    return FALSE;
                }
            }
            nGlobalChannel++; // increment global channel counter
        }
    }

	if( m_ChannelList.GetItemCount() != 0 )
	{
		m_ChannelList.SetItemState( m_ChannelList.GetTopIndex(), 
									LVIS_SELECTED | LVIS_FOCUSED,
									LVIS_SELECTED | LVIS_FOCUSED );
	}
	else
	{
		::EnableWindow(GetDlgItem(IDOK)->m_hWnd,FALSE);
	}

    m_ChannelList.SetFocus();

    m_cbLineType.SetCurSel(0);
    GetDlgItem(IDC_PROTOCOL)->EnableWindow(FALSE);
    return FALSE;
}

void CDialogicOpen::DestroyModemObject()
{
	if( theApp.GetOpenModem() )
	{
		theApp.GetOpenModem()->DestroyModemObject();
		theApp.SetOpenModem(NULL);
	}
}

void CDialogicOpen::EnableControls(BOOL bEnable)
{
    GetDlgItem(IDOK)->EnableWindow(bEnable);
    GetDlgItem(IDCANCEL)->EnableWindow(bEnable);
}

void CDialogicOpen::OnSelchangeLinetype() 
{
	int nIndex = m_cbLineType.GetCurSel();

    if(nIndex == 0 || nIndex == 1){
        GetDlgItem(IDC_PROTOCOL)->EnableWindow(FALSE);
        GetDlgItem(IDC_PROTOCOL)->SetWindowText("");
    }
    else {
        GetDlgItem(IDC_PROTOCOL)->EnableWindow(TRUE);
    }
}

void CDialogicOpen::OnDblclkList1(NMHDR* pNMHDR, LRESULT* pResult) 
{
	// TODO: Add your control notification handler code here
	OnOK();
	*pResult = 0;
}
