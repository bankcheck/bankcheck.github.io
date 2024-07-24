// DlgGOpen.cpp : implementation file
//

#include "stdafx.h"
#include "OpenFaxBoards.h"
#include "DlgGOpen.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDlgGOpen dialog


CDlgGOpen::CDlgGOpen(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgGOpen::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDlgGOpen)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CDlgGOpen::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDlgGOpen)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDlgGOpen, CDialog)
	//{{AFX_MSG_MAP(CDlgGOpen)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgGOpen message handlers

BOOL CDlgGOpen::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
int     nCh;
    COpenFaxBoardsApp *pApp = (COpenFaxBoardsApp *)AfxGetApp();
    CListBox *pLB;
    CDialog::OnInitDialog();


    pLB = (CListBox *)GetDlgItem(IDC_CHANNELS);
    for ( nCh=0 ; (nCh < MAX_GAMMACHANNELS) ; nCh++ ) {
        char szCom[20];

        if ( G_IsChannelFree( nCh ) ) {
            strcpy( szCom, "Channel" );
            _itoa( nCh, &szCom[ strlen("Channel") ], 10 );
            pLB->AddString(szCom);
        }
    }

    if ( G_NeedConfig() ) {
        CString szTmp = pApp->GetProfileString( "GammaLink", "Config file", "" );
        SetDlgItemText( IDC_CONFIG, szTmp );
    }
    else
        GetDlgItem(IDC_CONFIG)->EnableWindow( FALSE );
   
    pLB->SetCurSel(0);	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CDlgGOpen::OnOK() 
{
	BeginWaitCursor();
	CListBox  *cPortList ;
	CEdit     *cEdit;
	COpenFaxBoardsApp *pApp = (COpenFaxBoardsApp *)AfxGetApp();
	char      szChannel[10], szCFile[256];
	cPortList =(CListBox *)GetDlgItem( IDC_CHANNELS );
	cPortList->GetText( cPortList->GetCurSel(), szChannel );
	cEdit =(CEdit *)GetDlgItem( IDC_CONFIG );
    memset( szCFile, 0, sizeof(szCFile) );
    cEdit->GetLine( 0, szCFile, sizeof(szCFile) );
    pApp->WriteProfileString( "GammaLink", "Config file", szCFile );
	for ( int i = 0 ; i < MAX_FAXPORTS ; i++ ) {
            if ( !pApp->FaxPorts[i] ) {
	/*********************Connect the channel to the fax hardware.**************************/
	/*
	1. parameter: Name of the GammaLink channel. 
	2. parameter: This parameter should point to the name of the GammaLink configuration file.
				  The string can contain a full path ( "d:\\gamma\\fax\\gfax.$dc") or only the filename.
				  In the latter case the function tries to open the config file in the directory
				  specified by the environment variable GFAX.
	3. parameter: The type of the fax board.(BRD_GAMMALINK)
	Returns: - fax port object on success
			 - NULL,  if szChannel or szCFile is NULL.
			 - FER_GAMMA_BAD_LINE_CONFIG, if the GammaLink fax channel is configured to 
			   answer-only or dial-only operation which is incompatible with Fax C++. 
			   The GFXSHUTDOWN value must be set to 3 in the GammaLink configuration file.
			 - FER_GAMMA_INCOMPATIBLE_TIFF_FORMAT, if in the GammaLink configuration file it 
			   isn’t specified in which image format the received fax will be written to disk. 
               The GFXFORM value must be other then 0.
			 - FER_GAMMA_NOENVVAR, if the GFAX environment variable can’t be found.*/
                pApp->FaxPorts[i] = ConnectChannel(szChannel, szCFile, BRD_GAMMALINK );
	/* You can also use ConnectPortExt to connect the GammaLink channel to the fax hardware.
		1. parameter: Name of the GammaLink channel. 
		2. parameter: This parameter should point to the string "Gamma Channel".
		3. parameter: This parameter should point to the name of the GammaLink configuration file.
					  The string can contain a full path ( "d:\\gamma\\fax\\gfax.$dc") or only the filename.
					  In the latter case the function tries to open the config file in the directory
					  specified by the environment variable GFAX.
			pApp->FaxPorts[i]=ConnectPortExt(szChannel,"Gamma Channel",szCFile);
		*/
				

                if ( !pApp->FaxPorts[i] ) {
                    AfxMessageBox("Unable to connect channel!");
                    EndWaitCursor();
					return;
                } else 
				{
					char buf[30];
                    wsprintf(buf,"%s was opened.",szChannel);
					AfxMessageBox(buf);
					break;
                }
            }
        }
		
	CDialog::OnOK();
}
