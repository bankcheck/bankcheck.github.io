// OpenDialogic.cpp : implementation file
//

#include "stdafx.h"
#include "OpenFaxBoards.h"
#include "OpenDialogic.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// COpenDialogic dialog


COpenDialogic::COpenDialogic(CWnd* pParent /*=NULL*/)
	: CDialog(COpenDialogic::IDD, pParent)
{
	//{{AFX_DATA_INIT(COpenDialogic)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void COpenDialogic::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(COpenDialogic)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(COpenDialogic, CDialog)
	//{{AFX_MSG_MAP(COpenDialogic)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// COpenDialogic message handlers

BOOL COpenDialogic::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	COpenFaxBoardsApp     *pApp = (COpenFaxBoardsApp *)AfxGetApp();
	CListBox *pPortBox = (CListBox *)GetDlgItem(IDC_CHANNELS);
	char    szChName[15];
	for (int i=1 ; i <= pApp->m_nDialogicBoard ; i++ ) 
        for (int j=1 ; j<= D_GetChannelNum(i) ; j++ ) 
            if ( D_IsChannelFree( i, j ) ) {
                wsprintf( szChName, "dxxxB%dC%d", i, j );
				pPortBox->AddString(szChName);
			}
            
	pPortBox->SetCurSel(0);	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void COpenDialogic::OnOK() 
{
	COpenFaxBoardsApp     *pApp = (COpenFaxBoardsApp *)AfxGetApp();
	char szChannel[15];
	char buf[30];
	CListBox  *cPortList;
	BeginWaitCursor();
	cPortList=(CListBox *)GetDlgItem(IDC_CHANNELS);
	cPortList->GetText(cPortList->GetCurSel(), szChannel);
	for(int i=0;i<MAX_FAXPORTS;i++)
		if (!pApp->FaxPorts[i])
		{
		/*********************Connect the channel to the fax hardware.**************************/
		/*
		1. parameter: Name of the Dialogic channel.The name should be in the form ‘dxxxB1C1’ where the number 
		after B specifies the number of the board,the number after C specifies the number of the channel.
		2. parameter: Name of the configuration file that contains the settings for the fax hardware.
					  It is NULL for Dialogic Board.
		3. parameter: The type of the fax board.(BRD_DIALOGIC)
		Returns: - fax port object on success
				 - NULL,  if szChannel is NULL.
		*/
			pApp->FaxPorts[i]=ConnectChannel(szChannel,NULL,BRD_DIALOGIC);
		/* You can also use ConnectPortExt to connect the Dialogic channel to the fax hardware.
		1. parameter: Name of the Dialogic channel. The name should be in the 
					  form ‘dxxxB1C1’ where the number after B specifies the number of the board, 
					  the number after C specifies the number of the channel.
		2. parameter: This parameter should point to the string "Dialogic Channel".
		3. parameter: Must be NULL.
			pApp->FaxPorts[i]=ConnectPortExt(szChannel,"Dialogic Channel",NULL);
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
