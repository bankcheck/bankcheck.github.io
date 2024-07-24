// NMSOpen.cpp : implementation file
//

#include "stdafx.h"
#include "ocxdemo.h"
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
	DDX_Control(pDX, IDC_SPINDID, m_SpinDID);
	DDX_Control(pDX, IDC_PROTOCOL, m_cbProtocol);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CNMSOpen, CDialog)
	//{{AFX_MSG_MAP(CNMSOpen)
	ON_BN_DOUBLECLICKED(IDOK, OnDoubleclickedOk)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CNMSOpen message handlers

BOOL CNMSOpen::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	CString	szPart;
    int     i, go=1;

    while ( go ) {
        i = m_szChannels.Find( ' ' );
        if ( i == -1 ) { go = 0; szPart = m_szChannels; }
        else szPart = m_szChannels.Left( i );
        LPSTR lpLine=szPart.GetBuffer(255);
        SendDlgItemMessage( IDC_NMSChannels, LB_ADDSTRING, 0, (LPARAM)lpLine );
        m_szChannels = m_szChannels.Right( m_szChannels.GetLength()-i-1 );
    }
    SendDlgItemMessage( IDC_NMSChannels, LB_SETCURSEL, 0, 0 );
	SendDlgItemMessage( IDC_DID, EM_LIMITTEXT, (WPARAM)5, 0L );

	m_cbProtocol.SetCurSel(0);
	m_SpinDID.SetRange(0, UD_MAXVAL);
	m_SpinDID.SetPos( 3 );


    return TRUE;
}

void CNMSOpen::OnOK() 
{
	//protocol to szProtocol (CString), from cbProtocol (CComboBox)
	char strProtocol[12];
	int nProtocolIndex = m_cbProtocol.GetCurSel();
	GetSelectedProtocoll( nProtocolIndex, strProtocol, 12 );
	szProtocol = strProtocol;

	//DID digits number to didDigits (long) from m_DID(CEdit)
	CString szDID;
	GetDlgItem(IDC_DID)->GetWindowText( szDID );
	didDigits = atoi( szDID );
	if( didDigits < 1 || didDigits > UD_MAXVAL )
		didDigits = 3;

	//selected channel to m_selectedChannel (CString) from IDC_NMSChannels (CListBox)
	CListBox * pList = (CListBox*)GetDlgItem(IDC_NMSChannels);
	if( pList )
	{
		int curSel = pList->GetCurSel();
		pList->GetText(curSel, m_selectedChannel );
	}

	CDialog::OnOK();
}

void CNMSOpen::OnDoubleclickedOk() 
{
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
        default:
            strcpy(szProtocol,"LPS0");
    }
}
