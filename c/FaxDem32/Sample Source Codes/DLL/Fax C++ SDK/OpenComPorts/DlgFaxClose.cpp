// DlgFaxClose.cpp : implementation file
//

#include "stdafx.h"
#include "OpenComPorts.h"
#include "DlgFaxClose.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDlgFaxClose dialog


CDlgFaxClose::CDlgFaxClose(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgFaxClose::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDlgFaxClose)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CDlgFaxClose::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDlgFaxClose)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDlgFaxClose, CDialog)
	//{{AFX_MSG_MAP(CDlgFaxClose)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgFaxClose message handlers

BOOL CDlgFaxClose::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	COpenComPortsApp *pApp = (COpenComPortsApp *)AfxGetApp();
	int i;
    BOOL bOpen = FALSE ;
    for(i=0;i<MAX_COMPORTS;i++)
    {
        if (pApp->FaxPorts[i])
        {
                bOpen = TRUE ;
                break ;
        }
    }

    if(!bOpen) {
        AfxMessageBox("No port exist for close");
        EndDialog(FALSE);
        return  FALSE;
    }
    CListBox    *pPortBox = (CListBox *)GetDlgItem(IDC_FAXPORTS);
	for (i = 0; i < MAX_COMPORTS; i++) {
        if(pApp->FaxPorts[i])
        {
                TSSessionParameters CSession ;
                GetSessionParameters(pApp->FaxPorts[i],&CSession) ;
                CString cFax = CSession.PortName;
                cFax += ':' ;
                                cFax += CSession.ModemName;
                cFax +=  '.';
                cFax += CSession.FaxType;
                pPortBox->SetItemData(pPortBox->AddString(cFax), (DWORD)(i));
            
        }
    }
    pPortBox->SetCurSel(0);	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CDlgFaxClose::OnOK() 
{
	BeginWaitCursor();
    COpenComPortsApp     *pApp = (COpenComPortsApp *)AfxGetApp();
    CListBox    *pPortList = (CListBox *)GetDlgItem(IDC_FAXPORTS);
    int         iPort = -1;
	iPort = pPortList->GetCurSel();
    if(iPort >= 0)
        iPort = (int)pPortList->GetItemData(iPort);
    else
        iPort = -1;
    if(iPort >= 0) {
        // Close the port.
	/*****************Deletes the fax port and closes the COM port.******************/
	/*parameter: Fax port object. (PORTFAX type)
	  Returns zero on success, otherwise returns an error code.
	*/
        if(!DisconnectPort(pApp->FaxPorts[iPort])) {
            pApp->FaxPorts[iPort] = NULL;
            AfxMessageBox("Port was closed.");
        }
        else
            AfxMessageBox("Port close error!");
    }
	EndWaitCursor();		
	CDialog::OnOK();
}
