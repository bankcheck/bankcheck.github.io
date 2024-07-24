// dlgFaxPortSetup.cpp : implementation file
//

#include "stdafx.h"
#include "RetrySample.h"
#include "dlgFaxPortSetup.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
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
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CdlgFaxPortSetup message handlers

BOOL CdlgFaxPortSetup::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	int CntPorts, nCom;
    char chFullName[15];
	CDialog::OnInitDialog();
	
    CRetrySampleApp *pApp = (CRetrySampleApp *)AfxGetApp();

    // Fill comm. port list box.
    CntPorts = 0 ;
    for ( nCom = 0 ; nCom < MAX_COMPORTS ; nCom++) {
        char szCom[10];
        sprintf(szCom, "COM%1d", nCom+1);

        sprintf( chFullName, "\\\\.\\COM%d", nCom+1 );
        HANDLE nCommPort =  CreateFile( chFullName, GENERIC_READ | GENERIC_WRITE,
                      0,                    // exclusive access
                      NULL,                 // no security attrs
                      OPEN_EXISTING,
                      FILE_ATTRIBUTE_NORMAL |
                      FILE_FLAG_OVERLAPPED, // overlapped I/O
                      NULL )  ;




        if (nCommPort != INVALID_HANDLE_VALUE  ) {
            CloseHandle(nCommPort);

            CntPorts++ ;
            ((CListBox *)GetDlgItem(IDC_PORTLIST))->AddString(szCom);
        }
    }	
	((CListBox *)GetDlgItem(IDC_PORTLIST))->SetCurSel(0);			
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CdlgFaxPortSetup::OnOK() 
{
	CListBox  *cPortList ;
    char      szPortName[10];
	char buf[20];
	BeginWaitCursor();
	LPSTR classfax="GCLASS1(SFC)";
	LPSTR inifile="faxcpp1.ini";
    CRetrySampleApp *   pApp  ;

    pApp = (CRetrySampleApp *)AfxGetApp();

    cPortList =(CListBox *)GetDlgItem(IDC_PORTLIST);
    cPortList->GetText(cPortList->GetCurSel(), szPortName);
    TSTestResult tr;
	memset(&tr, 0, sizeof(tr));
	/******************Test if there is a modem on the specified com port.****************/
	/* 1. parameter: Name of the fax port
	   2. parameter: Pointer to the result data structure.
	   If iError is zero there is modem on the specified com port.
	   If iError is -1, there is no modem on the specified com port.
	*/
	int iError=FaxModemTest((LPSTR)szPortName,&tr);
	if (iError==-1) 
	{ 
		AfxMessageBox("No modem on com port!");
		EndWaitCursor();return;
	}
	else if (iError!=0)
	{
		wsprintf(buf,"Error %i",iError);
		AfxMessageBox(buf);
		EndWaitCursor();
		return;
	}
    
    // Find and empty faxport.
    for ( int i = 0 ; i < MAX_COMPORTS ; i++ ) {
        if (!pApp->FaxPorts[i] ) 
		{
	/*********************Connect the port to the fax hardware.**************************/
	/*1. parameter: Name of a port.(COM1, COM2... etc.).
	  2. parameter: 2. parameter: Name of a fax CLASS. 
	  Name of a fax CLASS refers to a section in the Faxcpp1.ini file. 
	  The available values can be loaded from the Faxcpp1.ini file.
		 For opening a port in Class 1 (Software Flow Control) specify: "GCLASS1(SFC)".
		 For opening a port in Class 1 (Hardware Flow Control) specify: "GCLASS1(HFC)".
		 For opening a port in Class 1.0 (Software Flow Control) specify: "GCLASS1.0(SFC)".
		 For opening a port in Class 2 specify: "GCLASS2S/RF/".
		 For opening a port (with Multitech modem on it) in Class 2.0 specify: "GCLASS2.0 MULTITECH".
		 For opening a port in Class 2.0 specify: "GCLASS2.0".
		 For opening a port (with Generic Hayes 14.4 modem on it) in Class 1 (Hardware Flow Control) specify: "GH14.4F(HFC)".
		 For opening a port (with Generic Rockwell modem on it) in Class 2 specify: "GCLASS2R".
 		 For opening a port (with Generic U.S. Robotics 14.4 modem on it) in Class 1 specify: "GU.S.R14.4F(HFC)".
	  3. parameter: Name of the ini file that contains the setting for the fax hardware.
	  Returns fax port on success, otherwise returns zero.
	*/
			pApp->FaxPorts[i] = ConnectPortExt(szPortName, classfax, inifile);
			if(!pApp->FaxPorts[i]) {
                AfxMessageBox("Unable to connect port!");
				EndWaitCursor();
                return;
			} 
			wsprintf(buf,"%s was opened.",szPortName);
            AfxMessageBox(buf);
			break;
		}
    }
	EndWaitCursor();			
	CDialog::OnOK();
}
