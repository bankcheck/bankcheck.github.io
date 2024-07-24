// DlgFaxClose.cpp : implementation file
//

#include "stdafx.h"
#include "FaxWithBrooktrout.h"
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
	
	CFaxWithBrooktroutApp *pApp = (CFaxWithBrooktroutApp *)AfxGetApp();
	int i;
    BOOL bOpen = FALSE ;
    for(i=0;i<MAX_FAXCHANNELS;i++)
    {
        if (pApp->FaxPorts[i])
        {
                bOpen = TRUE ;
                break ;
        }
    }

    if(!bOpen) {
        AfxMessageBox("No channel exists for close");
        EndDialog(FALSE);
        return  FALSE;
    }
    CListBox    *pPortBox = (CListBox *)GetDlgItem(IDC_FAXPORTS);
	for (i = 0; i < MAX_FAXCHANNELS; i++) {
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
    CFaxWithBrooktroutApp     *pApp = (CFaxWithBrooktroutApp *)AfxGetApp();
    CListBox    *pPortList = (CListBox *)GetDlgItem(IDC_FAXPORTS);
    int         iPort = -1;
	char buf[50];

	for (int n=0; n < pPortList->GetCount(); ++n)
	{
		iPort = pPortList->GetCurSel();
		{
			BeginWaitCursor();
			int  iPort = n;
			if(iPort >= 0) 			
				iPort = (int)pPortList->GetItemData(iPort);
			else iPort = -1;
			if(iPort >= 0) 
			{
    // Close the channel.
	/*****************Deletes the fax port and closes the channel.******************/
	/*parameter: Fax port object. (PORTFAX type)
	  Returns zero on success, otherwise returns an error code.
	*/
				CString channel=pApp->GetChannelName(pApp->FaxPorts[iPort]);
				if(!DisconnectPort(pApp->FaxPorts[iPort])) 
				{
					pApp->FaxPorts[iPort] = NULL;
					sprintf(buf,"%s: Channel was closed.",channel);
					pApp->FaxEventText(buf);
				}
				else
				{
					sprintf(buf,"%s: Channel close error!",channel);
					AfxMessageBox(buf);
				}
				EndWaitCursor();
				Sleep(200);
			}
		}
	}
	CDialog::OnOK();
}