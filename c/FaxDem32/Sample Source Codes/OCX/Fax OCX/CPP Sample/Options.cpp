// Options.cpp : implementation file
//

#include "stdafx.h"
#include "OCXDEMO.h"
#include "Options.h"
#include "fax.h"
#include "faxcpp.h"
#include "faxtype.h"
#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// Options dialog


Options::Options(CWnd* pParent /*=NULL*/)
	: CDialog(Options::IDD, pParent)
{
	//{{AFX_DATA_INIT(Options)
	m_phonenumber = _T("");
	m_szFileName = _T("");
	//}}AFX_DATA_INIT
	m_queue=IDC_QUEUE;
	m_nocomp=IDC_G31D;
	fileFocus=FALSE;
	m_szFileName="Test.tif";
}


void Options::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(Options)
	DDX_Text(pDX, IDC_PHONENUMBER, m_phonenumber);
	DDV_MaxChars(pDX, m_phonenumber, 64);
	DDX_Text(pDX, IDC_FILENAME, m_szFileName);
	DDV_MaxChars(pDX, m_szFileName, 256);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(Options, CDialog)
	//{{AFX_MSG_MAP(Options)
	ON_BN_CLICKED(IDC_BROWSE, OnBrowse)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// Options message handlers
/////////////////////////////////////////////////////////////////////////////

void Options::OnBrowse() 
{
    CFileDialog dlg(TRUE, _T("BMP"), NULL, OFN_FILEMUSTEXIST | OFN_HIDEREADONLY,
              _T("Bitmap Format|*.bmp|TIFF File Format|*.tif|JPEG Format|*.jpg|ASCII Text File (*.txt)|*.txt|All Files (*.*)|*.*||"));

    if ( dlg.DoModal() == IDOK ) {
        m_szFileName = dlg.GetPathName();
        SetDlgItemText( IDC_FILENAME, dlg.GetPathName() );
    }
}

// CBrooktrout dialog
CBrooktrout::CBrooktrout(CWnd* pParent /*=NULL*/)
	: CDialog(CBrooktrout::IDD, pParent)
{
	//{{AFX_DATA_INIT(CBrooktrout)
	m_config = _T("");
	m_bDTMF = FALSE;
	m_brHeader = FALSE;
	m_brLocalID = _T("");
	//}}AFX_DATA_INIT
}

void CBrooktrout::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CBrooktrout)
	DDX_Text(pDX, IDC_BCONFIG, m_config);
	DDV_MaxChars(pDX, m_config, 256);
	DDX_Check(pDX, IDC_DTMF, m_bDTMF);
	DDX_Check(pDX, IDC_BRHEADER, m_brHeader);
	DDX_Text(pDX, IDC_BRLOCALID, m_brLocalID);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CBrooktrout, CDialog)
	//{{AFX_MSG_MAP(CBrooktrout)
	ON_BN_CLICKED(IDC_BROWSE, OnBrowse)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CBrooktrout message handlers
/////////////////////////////////////////////////////////////////////////////

BOOL CBrooktrout::OnInitDialog() 
{
	CString	szPart;
    int i, go=1;

	CDialog::OnInitDialog();

    while ( go ) {
        i = m_channels.Find( ' ' );
        if ( i == -1 ) { go = 0; szPart = m_channels; }
        else szPart = m_channels.Left( i );
        LPSTR lpLine=szPart.GetBuffer(255);
        SendDlgItemMessage( IDC_COMport, LB_ADDSTRING, 0, (LPARAM)lpLine );
        m_channels = m_channels.Right( m_channels.GetLength()-i-1 );
    }
    SendDlgItemMessage( IDC_COMport, LB_SETCURSEL, 0, 0 );
	SendDlgItemMessage( IDC_BCONFIG, EM_LIMITTEXT, (WPARAM)255, 0L );
	SendDlgItemMessage( IDC_BRLOCALID, EM_LIMITTEXT, (WPARAM)60, 0L );
	
    return TRUE;
}


void CBrooktrout::OnOK() 
{
    CListBox *cPortList =(CListBox *)GetDlgItem(IDC_COMport);
	LPSTR     pPortName = m_szChannel.GetBuffer(256);
    cPortList->GetText( cPortList->GetCurSel(), pPortName );
    m_szChannel.ReleaseBuffer(-1);
	CDialog::OnOK();
}

// CGamma dialog

CGamma::CGamma(CWnd* pParent /*=NULL*/)
	: CDialog(CGamma::IDD, pParent)
{
	//{{AFX_DATA_INIT(CGamma)
	m_config = _T("");
	m_rings = 0;
	//}}AFX_DATA_INIT
}

void CGamma::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CGamma)
	DDX_Text(pDX, IDC_GCONFIG, m_config);
	DDV_MaxChars(pDX, m_config, 256);
	DDX_Text(pDX, IDC_RINGS, m_rings);
	DDV_MinMaxLong(pDX, m_rings, 0, 32);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CGamma, CDialog)
	//{{AFX_MSG_MAP(CGamma)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CGamma message handlers

BOOL CGamma::OnInitDialog() 
{
	CString	szPart;
    int     i, go=1;

    CDialog::OnInitDialog();

    while ( go ) {
        i = m_channels.Find( ' ' );
        if ( i == -1 ) { go = 0; szPart = m_channels; }
        else szPart = m_channels.Left( i );
        LPSTR lpLine=szPart.GetBuffer(255);
        SendDlgItemMessage( IDC_COMport, LB_ADDSTRING, 0, (LPARAM)lpLine );
        m_channels = m_channels.Right( m_channels.GetLength()-i-1 );
    }
    SendDlgItemMessage( IDC_COMport, LB_SETCURSEL, 0, 0 );
	SendDlgItemMessage( IDC_GCONFIG, EM_LIMITTEXT, (WPARAM)255, 0L );
	SendDlgItemMessage( IDC_RINGS, EM_LIMITTEXT, (WPARAM)1, 0L );
    return TRUE;
}


void CGamma::OnOK() 
{
    CListBox *cPortList =(CListBox *)GetDlgItem(IDC_COMport);
	LPSTR     pPortName = m_szChannel.GetBuffer(256);
    cPortList->GetText( cPortList->GetCurSel(), pPortName );
    m_szChannel.ReleaseBuffer(-1);

	CDialog::OnOK();
}

/////////////////////////////////////////////////////////////////////////////
// CCommPort dialog


CCommPort::CCommPort(CWnd* pParent /*=NULL*/)
	: CDialog(CCommPort::IDD, pParent)
{
	//{{AFX_DATA_INIT(CCommPort)
	m_rings = 0;
	m_bHeader = FALSE;
	m_commports = _T("");
	m_szLocalID = _T("");
	m_bDebugEnbl = FALSE;
	//}}AFX_DATA_INIT
	m_FaxListIndex=GetProfileInt("Fax","Selected",0);
	m_ActPort="";
}


void CCommPort::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CCommPort)
	DDX_Text(pDX, IDC_RINGS, m_rings);
	DDV_MinMaxInt(pDX, m_rings, 0, 15);
	DDX_Check(pDX, IDC_HEADER, m_bHeader);
	DDX_LBString(pDX, IDC_COMport, m_commports);
	DDX_Text(pDX, IDC_LOCALID, m_szLocalID);
	DDV_MaxChars(pDX, m_szLocalID, 21);
	DDX_Check(pDX, IDC_DEBUG, m_bDebugEnbl);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CCommPort, CDialog)
	//{{AFX_MSG_MAP(CCommPort)
	ON_BN_CLICKED(IDC_TEST, OnTest)
	ON_BN_CLICKED(IDC_DIALTONE, OnDialtone)
	ON_CBN_SELCHANGE(IDC_FAXLIST, OnSelchangeFaxlist)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CCommPort message handlers

BOOL CCommPort::OnInitDialog() 
{
	CString	szPart;
    int i, go=1;
	
    CDialog::OnInitDialog();

	((CEdit *)GetDlgItem(IDC_RESET))->LimitText(25);
	((CEdit *)GetDlgItem(IDC_SETUP))->LimitText(25);
	((CEdit *)GetDlgItem(IDC_LOCALID))->LimitText(100);
	((CEdit *)GetDlgItem(IDC_RINGS))->LimitText(1);

	CString	IniFileName="faxcpp1.ini";
    int localFax;
	BOOL First=TRUE;
	CComboBox    *pFaxList = (CComboBox *)GetDlgItem(IDC_FAXLIST);
	COCXDEMOApp *lpApp = (COCXDEMOApp*)AfxGetApp();
    localFax = 0;
    for(int nFaxes = 1; ;nFaxes++) {
        char szFax[128], szFaxName[128];

        sprintf(szFax, "Fax%d", ++localFax);

        if(!GetPrivateProfileString("Faxes", szFax, "", szFaxName, sizeof(szFaxName), IniFileName)) {
            if (!First) break;
            First= FALSE;
            continue;
        }
        if(!GetPrivateProfileString(szFaxName, "Long Name", "", szFaxName, sizeof(szFaxName), IniFileName)) {
            if (!First) break;
            First= FALSE;
            continue;
        }
        int nItem=pFaxList->AddString(szFaxName);
        pFaxList->SetItemData(nItem, nFaxes);
    }
	pFaxList->SetCurSel(GetProfileInt("Fax","Selected",1)-1);
	OnSelchangeFaxlist();
	while ( go ) {
        i = m_commports.Find( ' ' );
        if ( i == -1 ) { go = 0; szPart = m_commports; }
        else szPart = m_commports.Left( i );
        LPSTR lpLine=szPart.GetBuffer(255);
        SendDlgItemMessage( IDC_COMport, LB_ADDSTRING, 0, (LPARAM)lpLine );
        m_commports = m_commports.Right( m_commports.GetLength()-i-1 );
    }
    SendDlgItemMessage( IDC_COMport, LB_SETCURSEL, 0, 0 );
    
	return TRUE;
}

void CCommPort::OnTest() 
{
    int     iError;
    char    buf[150], ClassType[25], Manufact[256], Model[256];
    char    szPortName[10];
    CString OutString, szResult;
    COCXDEMOApp *lpApp = (COCXDEMOApp*)AfxGetApp();

    CListBox *cPortList =(CListBox *)GetDlgItem(IDC_COMport);
    memset( szPortName, 0, sizeof(szPortName) );
    if ( cPortList->GetCurSel() != LB_ERR ) {
        cPortList->GetText( cPortList->GetCurSel(), szPortName );
        BeginWaitCursor();
        iError = lpApp->m_pFax->TestModem( szPortName );
        EndWaitCursor();

        if ( iError == 0 ) {
             LPSTR lpToken ;

             szResult = lpApp->m_pFax->GetClassType();
             strcpy( ClassType, (LPCTSTR)szResult );
             szResult = lpApp->m_pFax->GetManufacturer();
             strcpy( Manufact, (LPCTSTR)szResult );
             szResult = lpApp->m_pFax->GetModel();
             strcpy( Model, (LPCTSTR)szResult );

             memset( buf, 0, sizeof(buf) );
             lstrcpy( buf, ClassType );
             OutString =  "" ;
             for ( lpToken = strtok(buf,",") ; lpToken ; lpToken = strtok(NULL,"," ) ) {
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
             if ( OutString.GetLength() > 0 )
                 SetDlgItemText( IDC_CTYPE, OutString );
             else
                 SetDlgItemText( IDC_CTYPE, ClassType );
             SetDlgItemText( IDC_MAKER, Manufact);
             SetDlgItemText( IDC_MODEL, Model);
        }
        else {
             wsprintf( buf, "No modem on %s", szPortName );
             SetDlgItemText( IDC_CTYPE, buf );
             SetDlgItemText( IDC_MAKER, "" );
             SetDlgItemText( IDC_MODEL, "" );
        }
    }
}

void CCommPort::OnOK() 
{

	COCXDEMOApp *lpApp = (COCXDEMOApp*)AfxGetApp();
	char szReset[64];
	char szSetup[256];
	GetDlgItemText(IDC_RESET, szReset, sizeof(szReset));
	lpApp->m_pFax->SetResetString(szReset,m_FaxListIndex);
	GetDlgItemText(IDC_SETUP, szSetup, sizeof(szSetup));
	lpApp->m_pFax->SetSetupString(szSetup,m_FaxListIndex);
	m_bDebugEnbl=IsDlgButtonChecked(IDC_DEBUG);
	lpApp->WriteProfileInt("Fax","Selected",m_FaxListIndex);
	CListBox *cPortList =(CListBox *)GetDlgItem(IDC_COMport);
	cPortList->GetText(cPortList->GetCurSel(),m_ActPort);	

	
    
//	LPSTR     pPortName = m_commports.GetBuffer(256);
    
  //  m_commports.ReleaseBuffer(-1);
//	CString port=pPortName;
	CDialog::OnOK();
}

/////////////////////////////////////////////////////////////////////////////
// CPortClose dialog


CPortClose::CPortClose(CWnd* pParent /*=NULL*/)
	: CDialog(CPortClose::IDD, pParent)
{
	//{{AFX_DATA_INIT(CPortClose)
	m_szPort = _T("");
	//}}AFX_DATA_INIT
}


void CPortClose::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPortClose)
	DDX_LBString(pDX, IDC_PORTLIST, m_szPort);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CPortClose, CDialog)
	//{{AFX_MSG_MAP(CPortClose)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

void CPortClose::AddComLines( CString szPorts, CString szPre )
{
	CString	szPart;
    int i, go=1,portindex,spaceindex;
	COCXDEMOApp *lpApp = (COCXDEMOApp*)AfxGetApp();

    if ( szPorts.GetLength() ) {
        while ( go ) {
            i = szPorts.Find( ' ' );
            if ( i == -1 ) { go = 0; szPart = szPorts; }
            else szPart = szPorts.Left( i );
			CString lpLine=szPart.GetBuffer(255);
			portindex=lpApp->PortsAndClasses.Find(lpLine)+lpLine.GetLength()+1;
			spaceindex=lpApp->PortsAndClasses.Find(' ',portindex);
			CString a="";
			for (int k=portindex;k<spaceindex;k++)
				a=a+lpApp->PortsAndClasses[k];
			short index=atoi(a);
			lpLine=lpLine+':'+lpApp->m_pFax->GetLongName(index);
            ((CListBox *)GetDlgItem(IDC_PORTLIST))->AddString(lpLine);
            szPorts = szPorts.Right( szPorts.GetLength()-i-1 );
        }
    }
}

void CPortClose::AddLines( CString szPorts, CString szPre )
{
	CString	szPart;
    int i, go=1;

    if ( szPorts.GetLength() ) {
        while ( go ) {
            i = szPorts.Find( ' ' );
            if ( i == -1 ) { go = 0; szPart = szPorts; }
            else szPart = szPorts.Left( i );
            LPSTR lpLine=szPart.GetBuffer(255);
            SendDlgItemMessage( IDC_PORTLIST, LB_ADDSTRING, 0, (LPARAM)lpLine );
            szPorts = szPorts.Right( szPorts.GetLength()-i-1 );
        }
    }
}

/////////////////////////////////////////////////////////////////////////////
// CPortClose message handlers

BOOL CPortClose::OnInitDialog() 
{
    CDialog::OnInitDialog();

    AddComLines( m_szPorts, "" );
    AddLines( m_szBChannels, "" );
    AddLines( m_szGChannels, "" );
    SendDlgItemMessage( IDC_PORTLIST, LB_SETCURSEL, 0, 0 );

	return TRUE;
}

void CCommPort::OnDialtone() 
{
	SetCapture();
	COCXDEMOApp *lpApp = (COCXDEMOApp*)AfxGetApp();
    CListBox *cPortList =(CListBox *)GetDlgItem(IDC_COMport);
    char szPortName[10];
    memset(szPortName, 0, sizeof(szPortName));
    cPortList->GetText(cPortList->GetCurSel(), szPortName);

    BeginWaitCursor();
    int iError =lpApp->m_pFax->DetectDialTone((LPCSTR)szPortName);
	EndWaitCursor();	
	if (1==iError)
		MessageBox("Dialtone Detected. ", "Test Dialtone", MB_ICONINFORMATION);
	else if (0==iError)
		MessageBox("No Dialtone! ", "Test Dialtone", MB_ICONSTOP);
	else if (-1==iError)
		MessageBox("No Modem on COM Port! ", "Test Dialtone", MB_ICONSTOP);
		
    ReleaseCapture(); 	
}

void CCommPort::OnSelchangeFaxlist() 
{
	CComboBox *cFaxList =(CComboBox*)GetDlgItem(IDC_FAXLIST);
    COCXDEMOApp *lpApp = (COCXDEMOApp*)AfxGetApp();
	m_FaxListIndex= (int)cFaxList->GetItemData(cFaxList->GetCurSel());
    SetDlgItemText(IDC_RESET,lpApp->m_pFax->GetResetString(m_FaxListIndex));   
    SetDlgItemText(IDC_SETUP,lpApp->m_pFax->GetSetupString(m_FaxListIndex));	
}

BOOL Options::OnInitDialog() 
{

	CDialog::OnInitDialog();
	
	CheckRadioButton(IDC_QUEUE,IDC_IMMEDIATE,IDC_QUEUE);
	CheckRadioButton(IDC_NOCOMP,IDC_G4,IDC_G31D);
	((CEdit *)GetDlgItem(IDC_PHONENUMBER))->LimitText(32);
	((CEdit *)GetDlgItem(IDC_FILENAME))->LimitText(255);
	
	CListBox *cPortList =(CListBox *)GetDlgItem(IDC_PORTS);

	CString t1;
	COCXDEMOApp *lpApp = (COCXDEMOApp*)AfxGetApp();
	t1=lpApp->m_pFax->GetPortsOpen();
	AddComPortsToListBox(t1,"");
	t1=lpApp->m_pFax->GetBrooktroutChannelsOpen();
	AddLinesToListBox(t1,"");
	t1=lpApp->m_pFax->GetGammaChannelsOpen();
	AddLinesToListBox(t1,"");
	t1=lpApp->m_pFax->GetDialogicChannelsOpen();
	AddLinesToListBox(t1,"");
	t1=lpApp->m_pFax->GetNMSChannelsOpen();
	AddLinesToListBox(t1,"");
	cPortList->SetCurSel(0);
	SetDlgItemText(IDC_FILENAME,m_szFileName);
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void Options::AddComPortsToListBox( CString szPorts, CString szPre )
{
	CString	szPart;
    int i, go=1,portindex,spaceindex;
	COCXDEMOApp *lpApp = (COCXDEMOApp*)AfxGetApp();
    if ( szPorts.GetLength() ) {
        while ( go ) {
            i = szPorts.Find( ' ' );
            if ( i == -1 ) { go = 0; szPart = szPorts; }
            else szPart = szPorts.Left( i );
            CString lpLine=szPart.GetBuffer(255);
			portindex=lpApp->PortsAndClasses.Find(lpLine)+lpLine.GetLength()+1;
			spaceindex=lpApp->PortsAndClasses.Find(' ',portindex);
			CString a="";
			for (int k=portindex;k<spaceindex;k++)
				a=a+lpApp->PortsAndClasses[k];
			short index=atoi(a);
			lpLine=lpLine+':'+lpApp->m_pFax->GetLongName(index);
            ((CListBox *)GetDlgItem(IDC_PORTS))->AddString(lpLine);
            szPorts = szPorts.Right( szPorts.GetLength()-i-1 );
        }
    }
}

void Options::AddLinesToListBox( CString szPorts, CString szPre )
{
	CString	szPart;
    int i, go=1;

    if ( szPorts.GetLength() ) {
        while ( go ) {
            i = szPorts.Find( ' ' );
            if ( i == -1 ) { go = 0; szPart = szPorts; }
            else szPart = szPorts.Left( i );
            LPSTR lpLine=szPart.GetBuffer(255);
            SendDlgItemMessage( IDC_PORTS, LB_ADDSTRING, 0, (LPARAM)lpLine );
            szPorts = szPorts.Right( szPorts.GetLength()-i-1 );
        }
    }
}

void Options::OnOK() 
{
	CListBox *cPortList =(CListBox *)GetDlgItem(IDC_PORTS);
	cPortList->GetText(cPortList->GetCurSel(),m_sendPort);
	m_queue=GetCheckedRadioButton(IDC_QUEUE,IDC_IMMEDIATE);
	m_nocomp=GetCheckedRadioButton(IDC_NOCOMP,IDC_G4);
	
	CDialog::OnOK();
}


void CBrooktrout::OnBrowse() 
{
	LPSTR GroupFilterBuff =
    "Config Files (*.cfg)\0*.CFG\0"
    "All Files\0*.*\0";
	CFileDialog *dlgFile=new CFileDialog(TRUE);
	dlgFile->m_ofn.lpstrTitle = "Open";
	dlgFile->m_ofn.lpstrFilter = GroupFilterBuff;
	if (dlgFile->DoModal()==IDOK)
		SetDlgItemText( IDC_BCONFIG,dlgFile->m_ofn.lpstrFileTitle);;

	delete dlgFile;	
}

void CPortClose::OnOK() 
{
	CString PortToClose;
	CListBox *cPortList =(CListBox *)GetDlgItem(IDC_PORTLIST);
	COCXDEMOApp *lpApp = (COCXDEMOApp*)AfxGetApp();
	cPortList->GetText(cPortList->GetCurSel(),PortToClose);
	int index=PortToClose.Find(':');
	if (index!=-1)
			PortToClose=PortToClose.Left(index);
	int portindex=lpApp->PortsAndClasses.Find(PortToClose);
	int spaceindex=lpApp->PortsAndClasses.Find(' ',portindex);
	lpApp->PortsAndClasses=lpApp->PortsAndClasses.Left(portindex)+lpApp->PortsAndClasses.Right(lpApp->PortsAndClasses.GetLength()-(spaceindex+1));
	CDialog::OnOK();
}
