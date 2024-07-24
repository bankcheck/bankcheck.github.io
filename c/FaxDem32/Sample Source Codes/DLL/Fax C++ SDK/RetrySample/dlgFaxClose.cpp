// dlgFaxClose.cpp : implementation file
//

#include "stdafx.h"
#include "RetrySample.h"
#include "dlgFaxClose.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CdlgFaxClose dialog


CdlgFaxClose::CdlgFaxClose(CWnd* pParent /*=NULL*/)
	: CDialog(CdlgFaxClose::IDD, pParent)
{
	//{{AFX_DATA_INIT(CdlgFaxClose)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CdlgFaxClose::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CdlgFaxClose)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CdlgFaxClose, CDialog)
	//{{AFX_MSG_MAP(CdlgFaxClose)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CdlgFaxClose message handlers

BOOL CdlgFaxClose::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	CRetrySampleApp *pApp = (CRetrySampleApp *)AfxGetApp();
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
        AfxMessageBox("There is no port open!");
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

void CdlgFaxClose::OnOK() 
{
	BeginWaitCursor();
    CRetrySampleApp     *pApp = (CRetrySampleApp *)AfxGetApp();
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
	TSPortStatus ps;
	GetPortStatus(pApp->FaxPorts[iPort],&ps);
	if (ps.Status==0)
	{
        if(!DisconnectPort(pApp->FaxPorts[iPort])) {
            pApp->FaxPorts[iPort] = NULL;
            AfxMessageBox("Port was closed.");
        }
        else
            AfxMessageBox("Port close error!");
    }
	else AfxMessageBox("Cannot close the port. Port is in use!");
	}
	EndWaitCursor();		
	CDialog::OnOK();
}
