// dlgFaxPortSetup.cpp : implementation file
//

#include "stdafx.h"
#include <stdio.h>
#include <stddef.h>
#include "QueueFaxSample.h"
#include "QueueFaxSampleDlg.h"
#include "dlgFaxPortSetup.h"
/*#include "faxtype.h"*/
#include "faxcpp.h"
#include "commcl.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif
#if defined(WIN32)
#define _fstrspn strspn
#define B_PORTNAME "Channel"
#define G_PORTNAME "Channel"
#endif

/////////////////////////////////////////////////////////////////////////////
// CdlgFaxPortSetup dialog


CdlgFaxPortSetup::CdlgFaxPortSetup(CWnd* pParent /*=NULL*/)
	: CDialog(CdlgFaxPortSetup::IDD, pParent)
{
	//{{AFX_DATA_INIT(CdlgFaxPortSetup)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CdlgFaxPortSetup::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CdlgFaxPortSetup)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CdlgFaxPortSetup, CDialog)
	//{{AFX_MSG_MAP(CdlgFaxPortSetup)
	ON_CBN_SELCHANGE(IDC_FAXLIST, OnSelchangeFaxlist)
	ON_EN_CHANGE(IDC_SETUP, OnChangeSetup)
	ON_EN_CHANGE(IDC_RESET, OnChangeReset)
	ON_BN_CLICKED(IDC_TESTMODEM, OnTestmodem)
	ON_BN_CLICKED(IDC_TESTDIALTONE, OnTestdialtone)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CdlgFaxPortSetup message handlers

BOOL CdlgFaxPortSetup::OnInitDialog() 
{
	int CntPorts, nCom;
    char chFullName[15];
	CDialog::OnInitDialog();
	
    CQueueFaxSampleApp *pApp = (CQueueFaxSampleApp *)AfxGetApp();
#ifndef WIN32
    if ( pApp->FaxPorts[0] && pApp->FaxPorts[1] && pApp->FaxPorts[2] && pApp->FaxPorts[3]) {
        AfxMessageBox( "No free port to open!, Please close a port already open!" );
        EndDialog(FALSE);
        return  FALSE;
    }
#endif
    // Fill comm. port list box.
    CntPorts = 0 ;
    for ( nCom = 0 ; nCom < MAX_FAXPORTS ; nCom++) {
        char szCom[10];
        sprintf(szCom, "COM%1d", nCom+1);
#ifndef _THREAD
        int nCommPort = OpenComm( szCom, 32, 32 );
#else
        sprintf( chFullName, "\\\\.\\COM%d", nCom+1 );
        HANDLE nCommPort =  CreateFile( chFullName, GENERIC_READ | GENERIC_WRITE,
                      0,                    // exclusive access
                      NULL,                 // no security attrs
                      OPEN_EXISTING,
                      FILE_ATTRIBUTE_NORMAL |
                      FILE_FLAG_OVERLAPPED, // overlapped I/O
                      NULL )  ;

#endif

#ifndef _THREAD
        if (nCommPort >= 0  ) {
            CloseComm(nCommPort);
#else
        if (nCommPort != INVALID_HANDLE_VALUE  ) {
            CloseHandle(nCommPort);
#endif
            CntPorts++ ;
            //pApp->FaxPorts[nCom] = GetPortID(szCom);
            ((CListBox *)GetDlgItem(IDC_PORTLIST))->AddString(szCom);
        }
    }
    // Fill fax list box.
    UINT    nLength = 0;
    BOOL    First= TRUE;
    LPSTR   IniFileName;
    int     localFax= 0;
    IniFileName= "faxcpp1.ini";
    CComboBox    *pFaxList = (CComboBox *)GetDlgItem(IDC_FAXLIST);
    for(int nFaxes = 1; ;nFaxes++) {
        char szFax[128], szFaxName[128];

        sprintf(szFax, "Fax%d", ++localFax);

        if(!GetPrivateProfileString("Faxes", szFax, "", szFaxName, sizeof(szFaxName), IniFileName)) {
            if (!First) break;
            First= FALSE;
            IniFileName= "faxcpp2.ini";
            continue;
        }
        if(!GetPrivateProfileString(szFaxName, "Long Name", "", szFaxName, sizeof(szFaxName), IniFileName)) {
            if (!First) break;
            First= FALSE;
            continue;
        }
        int nItem = pFaxList->AddString(szFaxName);
        pFaxList->SetItemData(nItem, nFaxes);
        if(strlen(szFaxName) > nLength)
            nLength = strlen(szFaxName);
    }
    ((CListBox *)GetDlgItem(IDC_PORTLIST))->SetCurSel(0);

    // Identification number. (own fax number)
    CString cId = pApp->GetProfileString("Fax", "Identification String", NULL);
    SetDlgItemText(IDC_IDSTRING, cId);

    // Set defualt debug files and debug flags.
    ((CButton *)GetDlgItem(IDC_DEBUG))->SetCheck(FALSE);

    pFaxList->SetCurSel(pApp->GetProfileInt("Fax","Selected",0));
    OnSelchangeFaxlist();
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CdlgFaxPortSetup::OnSelchangeFaxlist() 
{
// Load setup string of the selected fax.
    CComboBox *cFaxList =(CComboBox*)GetDlgItem(IDC_FAXLIST);
    char szFaxName[256];
    char szReset[64] ;

    int nFax= (int)cFaxList->GetItemData(cFaxList->GetCurSel());
    LPSTR IniFile= "faxcpp1.ini";
    wsprintf(szFaxName, "Fax%d",  nFax);

    GetPrivateProfileString("Faxes", szFaxName, "", szFaxName, sizeof(szFaxName), IniFile);

    GetPrivateProfileString(szFaxName,"Reset String","ATZ",szReset,sizeof(szReset),IniFile);
    SetDlgItemText(IDC_RESET,szReset);

    if(!GetPrivateProfileString(szFaxName, "Setup String", "", szFaxName, sizeof(szFaxName), IniFile))
        szFaxName[0] = '\0';
    SetDlgItemText(IDC_SETUP, szFaxName);	
}

void CdlgFaxPortSetup::OnChangeSetup() 
{
	char szFaxName[256];
    char szSetup[256];

    CComboBox *cFaxList =(CComboBox *)GetDlgItem(IDC_FAXLIST);
    GetDlgItemText(IDC_SETUP, szSetup, sizeof(szSetup));

    int nFax= (int)cFaxList->GetItemData(cFaxList->GetCurSel());
    LPSTR IniFile= "faxcpp1.ini";
    
    wsprintf(szFaxName, "Fax%d",  nFax);
    GetPrivateProfileString("Faxes", szFaxName, "", szFaxName, sizeof(szFaxName), IniFile);

    WritePrivateProfileString(szFaxName, "Setup String", szSetup, IniFile);
	
}

void CdlgFaxPortSetup::OnChangeReset() 
{
	char szFaxName[256];
    char szReset[64],szNewReset[64] ;

    CComboBox *cFaxList =(CComboBox *)GetDlgItem(IDC_FAXLIST);

    int nFax= (int)cFaxList->GetItemData(cFaxList->GetCurSel());
    LPSTR IniFile= "faxcpp1.ini";
    
    wsprintf(szFaxName, "Fax%d",  nFax);
    GetPrivateProfileString("Faxes", szFaxName, "", szFaxName, sizeof(szFaxName), IniFile);

    GetDlgItemText(IDC_RESET,szNewReset,sizeof(szNewReset));
    GetPrivateProfileString(szFaxName,"Reset String","ATZ",szReset,sizeof(szReset),IniFile);
    if (strncmp(szReset,szNewReset,sizeof(szReset))!=0) {
        WritePrivateProfileString(szFaxName, "Reset String", szNewReset, IniFile);
    }
}

void CdlgFaxPortSetup::OnOK() 
{
	int       nFax, nBaud, SelectedFax, nEcm, nBft ;
    LPSTR     IniFile ;
    CListBox  *cPortList ;
    CComboBox *cFaxList ;
    char      szPortName[10];
    char      szFaxName[50];
    char      szReset[64] ;
    char      szStationID[21] ;

    CQueueFaxSampleApp *   pApp  ;
	CQueueFaxSampleDlg dlgevent;

    pApp = (CQueueFaxSampleApp *)AfxGetApp();

    OnChangeSetup();
    OnChangeReset();

    cPortList =(CListBox *)GetDlgItem(IDC_PORTLIST);
    cPortList->GetText(cPortList->GetCurSel(), szPortName);

    // Get fax name,.
    cFaxList =(CComboBox*)GetDlgItem(IDC_FAXLIST);

    nFax= (int)cFaxList->GetItemData(cFaxList->GetCurSel());
    IniFile= "faxcpp1.ini";
    
    wsprintf(szFaxName, "Fax%d",  nFax);
    GetPrivateProfileString("Faxes", szFaxName, "", szFaxName, sizeof(szFaxName), IniFile);

    SelectedFax = cFaxList->GetCurSel();
    pApp->WriteProfileInt("Fax","Selected",SelectedFax);

    // Get ID string and no. of ring to answer.
    GetDlgItemText(IDC_IDSTRING, szStationID, sizeof(szStationID));
    pApp->WriteProfileString("Fax", "Identification String", szStationID);
    SetMyID(szStationID);

    // Find and empty faxport.
    for ( int i = 0 ; i < MAX_FAXPORTS ; i++ ) {
        if (!pApp->FaxPorts[i] ) {
            pApp->FaxPorts[i] = ConnectPortExt(szPortName, szFaxName, IniFile);
            if(!pApp->FaxPorts[i]) {
                AfxMessageBox("Unable to connect port!");
                return;
            } else {
                pApp->nComm[i] = atoi(&szPortName[3]);
                pApp->FaxEventText(i, "Port Open");
                if ( ((CButton *)GetDlgItem(IDC_DEBUG))->GetCheck() ) {
                    EnableLog(pApp->FaxPorts[i],TRUE);
                } ;
                GetDlgItemText(IDC_RESET,szReset,sizeof(szReset)) ;
                SetModemCommands(pApp->FaxPorts[i],szReset,NULL,NULL,NULL);

                SetRuningMode(pApp->RunMode);

                SetSpeaker(pApp->FaxPorts[i], pApp->SpeakerMode, pApp->SpeakerVolume);
                SetDialMode( pApp->FaxPorts[i], TONE_DIAL );

                nBaud = pApp->GetProfileInt("Fax", "MAXBAUD", 4);
                nEcm = pApp->GetProfileInt("Fax", "Enable ECM Receive", ECM_ENABLE );
                nBft = pApp->GetProfileInt("Fax", "Enable BFT", BFT_DISABLE );
                if(nBaud<=0 || nBaud>=BDR_END)
                    nBaud = BDR_14400;
                SetPortCapabilities(pApp->FaxPorts[i], FDC_BAUD_SEND, nBaud);
                SetPortCapabilities(pApp->FaxPorts[i], FDC_ECM, nEcm);

                SetPortCapabilities(pApp->FaxPorts[i], FDC_BINARY, nBft);
                SetStationID( pApp->FaxPorts[i], szStationID );

            }
            break;
        }
    }
	CDialog::OnOK();
}

void CdlgFaxPortSetup::OnTestmodem() 
{
	// TODO: Add your control notification handler code here
	TSTestResult ts;
    memset(&ts, 0, sizeof(ts));
    char buf[200];
    CString OutString ;

    SetCapture() ;

    CListBox *cPortList =(CListBox *)GetDlgItem(IDC_PORTLIST);
    char szPortName[10];
    memset(szPortName, 0, sizeof(szPortName));
    cPortList->GetText(cPortList->GetCurSel(), szPortName);
    BeginWaitCursor();
    int iError = FaxModemTest((LPSTR)szPortName, &ts);
    EndWaitCursor();
	
    if(iError==0)
    {
        LPSTR lpToken ;
        memset(buf,0,sizeof(buf));
        lstrcpy(buf,ts.ClassType);
        OutString =  "" ;
        for(lpToken = strtok(buf,",") ; lpToken ; lpToken = strtok(NULL,",")  ) {
            if (strcmp(lpToken,"0") == 0){
                if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
                OutString = OutString + "Data" ;
                continue ;
            }
		
            if (strcmp(lpToken,"1.0") == 0){
                if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
                OutString = OutString + "FAX Class 1.0" ;
                continue ;
            }
            if (strcmp(lpToken,"1") == 0){
                if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
                OutString = OutString + "FAX Class 1" ;
                continue ;
            }

            if (strcmp(lpToken,"2.0") == 0){
                if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
                OutString = OutString + "FAX Class 2.0" ;
                continue ;
            }
			if (strcmp(lpToken,"2.1") == 0){
                if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
                OutString = OutString + "FAX Class 2.1" ;
                continue ;
            }

            if (strcmp(lpToken,"2") == 0){
                if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
                OutString = OutString + "FAX Class 2" ;
                continue ;
            }

            if (strcmp(lpToken,"80") == 0){
                if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
                OutString = OutString + "Class 80" ;
                continue ;
            }

            if (strcmp(lpToken,"8") == 0){
                if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
                OutString = OutString + "Class 8" ;
                continue ;
            }

			if (strlen(lpToken)>0)
				if (OutString.GetLength() > 0 ) OutString = OutString + ", " ;
					OutString = OutString + "Class " + lpToken;
 
        }

        if (OutString.GetLength() > 0) {
            SetDlgItemText(IDC_TEST1,  OutString);
        } else {
            SetDlgItemText(IDC_TEST1,  ts.ClassType);
        }

        SetDlgItemText(IDC_TEST2, ts.Manufact);
        SetDlgItemText(IDC_TEST3,  ts.Model);
    }
    else
    {
        wsprintf(buf, "No modem on %s", (LPSTR)szPortName);
        SetDlgItemText(IDC_TEST1, buf);
        SetDlgItemText(IDC_TEST2, "");
        SetDlgItemText(IDC_TEST3, "");
    }
    ReleaseCapture();
}

void CdlgFaxPortSetup::OnTestdialtone() 
{
	// TODO: Add your control notification handler code here
	SetCapture();
    CListBox *cPortList =(CListBox *)GetDlgItem(IDC_PORTLIST);
    char szPortName[10];
    memset(szPortName, 0, sizeof(szPortName));
    cPortList->GetText(cPortList->GetCurSel(), szPortName);

    BeginWaitCursor();
    int iError =DetectDialTone((LPSTR)szPortName);
	EndWaitCursor();	
	if (1==iError)
		MessageBox("Dialtone Detected. ", "Test Dialtone", MB_ICONINFORMATION);
	else if (0==iError)
		MessageBox("No Dialtone! ", "Test Dialtone", MB_ICONSTOP);
	else if (-1==iError)
		MessageBox("No Modem on COM Port! ", "Test Dialtone", MB_ICONSTOP);
		
    ReleaseCapture();
}
