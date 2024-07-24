// BOpen.cpp : implementation file
//

#include "stdafx.h"
#include "FaxWithBrooktrout.h"
#include "BOpen.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CBOpen dialog


CBOpen::CBOpen(CWnd* pParent /*=NULL*/)
	: CDialog(CBOpen::IDD, pParent)
{
	//{{AFX_DATA_INIT(CBOpen)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CBOpen::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CBOpen)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CBOpen, CDialog)
	//{{AFX_MSG_MAP(CBOpen)
	ON_BN_CLICKED(IDC_BROWSE, OnBrowse)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CBOpen message handlers

BOOL CBOpen::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	CFaxWithBrooktroutApp     *pApp = (CFaxWithBrooktroutApp *)AfxGetApp();
	if (( pApp->BrooktroutChannels && pApp->BrooktroutChannels[0]))
	{
		for(int nCh=0 ; nCh < MAX_FAXCHANNELS && pApp->BrooktroutChannels[nCh] ; nCh++ )
		{
			if ( pApp->BrooktroutChannels[nCh] == 1 || // fax or tr114 channel
			    pApp->BrooktroutChannels[nCh] >= 3 ) 
			{
				char szCom[20];
	            if ( B_IsChannelFree( nCh ) )
				{
					strcpy( szCom, "Channel" );
					_itoa( nCh, &szCom[ strlen("Channel") ], 10 );
					((CListBox *)GetDlgItem(IDC_BCHANNELS))->AddString(szCom);
				}
			}
		}

		char szTmp2[200];
		GetPrivateProfileString("Brooktrout","Config file","btcall.cfg",szTmp2,200,"Demo32.INI");
		SetDlgItemText( IDC_CFILE, szTmp2 );
		
		((CListBox *) GetDlgItem(IDC_BCHANNELS))->SetCurSel(0);
	}	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}
	
void CBOpen::OnBrowse() 
{
	LPSTR GroupFilterBuff =
    "Config Files (*.cfg)\0*.CFG\0"
    "All Files\0*.*\0";
	CFileDialog *dlgFile=new CFileDialog(TRUE);
	dlgFile->m_ofn.lpstrTitle = "Open";
	dlgFile->m_ofn.lpstrFilter = GroupFilterBuff;
	if (dlgFile->DoModal()==IDOK)
		SetDlgItemText( IDC_CFILE,dlgFile->m_ofn.lpstrFileTitle);;

	delete dlgFile;			
}

void CBOpen::OnOK() 
{
	CListBox  *cPortList;
	CFaxWithBrooktroutApp  *pApp = (CFaxWithBrooktroutApp *)AfxGetApp();
	CEdit     *cEdit;
	char szPortName[10],szCFile[256];
	char buf[30];
	int select;
    
	cPortList =(CListBox *)GetDlgItem( IDC_BCHANNELS );
	for (int n=0; n < cPortList->GetCount(); ++n)
	{
		if (cPortList->GetSel(n)) 
		{	
			BeginWaitCursor();
			select = n;
			if ( select != LB_ERR ) 
			{
				cPortList->GetText( select, szPortName );
				cEdit =(CEdit *)GetDlgItem( IDC_CFILE );
				memset( szCFile, 0, sizeof(szCFile) );
				cEdit->GetLine( 0, szCFile, sizeof(szCFile) );
				WritePrivateProfileString("Brooktrout","Config file",szCFile,"Demo32.ini");
				for ( int i = 0 ; i < MAX_FAXCHANNELS ; i++ ) 
				{
					if ( !pApp->FaxPorts[i] ) 
					{

	/*********************Connect the channel to the fax hardware.**************************/
	/*1. parameter: Name of the Brooktrout channel.(Channel1, Channel2... etc.).
	  2. parameter: This parameter should point to the string "Brooktrout Channel" or can be NULL.
	  3. parameter: Name of the configuration file that contains the settings for the fax hardware ("BTCALL.CFG")
	  Returns fax port object on success, otherwise returns zero.
	*/
						pApp->FaxPorts[i] = ConnectPortExt(szPortName, NULL, szCFile );
						SetAutoAnswer(pApp->FaxPorts[i],1);
	/*
	You can also use ConnectChannel instead of ConnectPortExt to create a Brooktrout Fax Port object.
	1. parameter: Name of the Brooktrout channel. (Channel1, Channel2... etc.).
	2. parameter: Name of the configuration file that contains the settings for the fax hardware ("BTCALL.CFG")
	3. parameter: The type of the fax board.(BRD_BROOKTROUT)
	Returns: - fax port object on success
			 - NULL,  if szChannel or szCFile is NULL.
			 - FER_NO_FIRMWARE, if the library can’t locate or download the Firmware.
				pApp->FaxPorts[i]=ConnectChannel(szChannel,szCFile,BRD_BROOKTROUT);
	*/

						if ( !pApp->FaxPorts[i] ) 
						{
							AfxMessageBox("Unable to connect channel!");
							EndWaitCursor();
							return;
						} 
						else 
						{
							wsprintf(buf,"%s was opened.",szPortName);
							pApp->FaxEventText(buf);
						}
						break;
					}						
				}
			}
			EndWaitCursor();
			Sleep(200);
		}
	}
	CDialog::OnOK();
}
