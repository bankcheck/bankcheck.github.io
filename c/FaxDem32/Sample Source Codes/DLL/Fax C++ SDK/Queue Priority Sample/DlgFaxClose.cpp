// DlgFaxClose.cpp : implementation file
//

#include "stdafx.h"
#include "QueueFaxSample.h"
#include "DlgFaxClose.h"
#include "faxcpp.h"
#include "commcl.h"

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

static  void LoadFaxNames(CDialog  *cDlg, BOOL bClose)
{
    CQueueFaxSampleApp     *pApp = (CQueueFaxSampleApp *)AfxGetApp();
    CListBox    *pPortBox = (CListBox *)cDlg->GetDlgItem(IDC_FAXPORTS);
    int         nWidth = 0;

    for ( int i = 0; i < MAX_FAXPORTS; i++) {
        if(pApp->FaxPorts[i])
        {
            if (pApp->FaxPorts[i]->IsOpen() || bClose)
            {
                TSSessionParameters CSession ;
                GetSessionParameters(pApp->FaxPorts[i],&CSession) ;
                CString cFax = CSession.PortName;
                cFax += ':' ;
                                cFax += CSession.ModemName;
                cFax +=  '.';
                cFax += CSession.FaxType;

                pPortBox->SetItemData(pPortBox->AddString(cFax), (DWORD)(i));
                if(cFax.GetLength() > nWidth)
                {
                    nWidth = cFax.GetLength();
                }
            }
        }
    }
    pPortBox->SetHorizontalExtent(8*nWidth);
    pPortBox->SetCurSel(0);
}

static  int GetPortNumber(CDialog *cDlg)
{
    int         iPort   = -1;
    CListBox    *pPortList = (CListBox *)cDlg->GetDlgItem(IDC_FAXPORTS);

    iPort = pPortList->GetCurSel();
    if(iPort >= 0)
        iPort = (int)pPortList->GetItemData(iPort);
    else
        iPort = -1;
    return iPort;
}

BOOL CDlgFaxClose::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	CQueueFaxSampleApp *pApp = (CQueueFaxSampleApp *)AfxGetApp();

    int i ;
    BOOL bOpen = FALSE ;
    for(i=0;i<MAX_FAXPORTS;i++)
    {
        if (pApp->FaxPorts[i])
        {
//            if (pApp->FaxPorts[i]->IsOpen())
//            {
                bOpen = TRUE ;
                break ;
//            }
        }
    }

    if(!bOpen) {
        AfxMessageBox("No port exist for close");
        EndDialog(FALSE);
        return  FALSE;
    }
    LoadFaxNames(this, TRUE);
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}



void CDlgFaxClose::OnOK() 
{
	BeginWaitCursor();
    CQueueFaxSampleApp     *pApp = (CQueueFaxSampleApp *)AfxGetApp();
    CListBox    *pPortList = (CListBox *)GetDlgItem(IDC_FAXPORTS);
    int         iPort = ::GetPortNumber(this);
    if(iPort >= 0) {
        // Close the port.
        if(!DisconnectPort(pApp->FaxPorts[iPort])) {
            pApp->FaxPorts[iPort] = NULL;
            pApp->FaxEventText(iPort, "Port Close");
        }
        else
            AfxMessageBox("Port close error!");
    }
	EndWaitCursor();	
	CDialog::OnOK();
}
