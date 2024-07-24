// DlgNms.cpp : implementation file
//

#include "stdafx.h"
#include "OpenFaxBoards.h"
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
		// NOTE: the ClassWizard will add member initialization here
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
	COpenFaxBoardsApp     *pApp = (COpenFaxBoardsApp *)AfxGetApp();
	CListBox *pPortBox = (CListBox *)GetDlgItem(IDC_NMS);
	char    szChName[15];
	for (int i=0 ; i <= pApp->m_nNmsBoard ; i++ ) 
        for (int j=0 ; j<= NMS_GetChannelNum(i) ; j++ ) 
            if ( NMS_IsChannelFree( i, j ) ) {
                wsprintf( szChName, "NMS_B%dCH%d", i, j );
				pPortBox->AddString(szChName);
			}
    m_cbProtocol.SetCurSel(0);
	pPortBox->SetCurSel(0);	

	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CDlgNms::OnOK() 
{
	COpenFaxBoardsApp     *pApp = (COpenFaxBoardsApp *)AfxGetApp();
	char szChannel[15];
	char buf[30];
	CListBox  *cPortList;
	BeginWaitCursor();
	cPortList=(CListBox *)GetDlgItem(IDC_NMS);
	cPortList->GetText(cPortList->GetCurSel(), szChannel);
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
