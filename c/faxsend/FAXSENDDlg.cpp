// FAXSENDDlg.cpp : implementation file
//
#include "stdafx.h"
#include "FAXSEND.h"
#include "FAXSENDDlg.h"

#include "tapifax.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

CFAXSENDDlg *g_FaxDialog = NULL;

//20151217
SQLHDBC dbc;
SQLHENV env;
SQLCHAR OutConnStr[255];
SQLSMALLINT OutConnStrLen;
//20151217

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFAXSENDDlg dialog



CFAXSENDDlg::CFAXSENDDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CFAXSENDDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CFAXSENDDlg)

	g_hFax = NULL ;

	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CFAXSENDDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CFAXSENDDlg)
	DDX_Text(pDX, IDC_STATIC_CIS, m_CIS);
	DDX_Text(pDX, IDC_STATIC_SPEED, m_Speed);
	DDX_Text(pDX, IDC_TIME, m_sTakeTime);
	DDX_Text(pDX, IDC_PAGE, m_sPage);
	DDX_Text(pDX, IDC_STATIC_REMOTE, m_Remote);
	DDX_Text(pDX, IDC_STATIC_OP, m_Stat);
	DDX_Text(pDX, IDC_STATIC_FAX_DATA, m_Fax_data);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CFAXSENDDlg, CDialog)
	//{{AFX_MSG_MAP(CFAXSENDDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_WM_TIMER()
	//}}AFX_MSG_MAP

		ON_MESSAGE(WM_SMARTFAX, OnSmartFax)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFAXSENDDlg message handlers

BOOL CFAXSENDDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here


	m_iVolume = 1;
	this->UpdateData(false);

//read ini
    char drive[_MAX_DRIVE];
    char dir[_MAX_DIR];
    char fname[_MAX_FNAME];
    char ext[_MAX_EXT];
    char szFile[260];
	char sCallerID[260];
	char sCallerNo[260];

    _splitpath(__argv[0], drive, dir, fname, ext);
    if (drive[0] == '\0' && dir[0] == '\0') {
        char buf[1024];

        GetCurrentDirectory(260, buf);
        sprintf(szFile, "%s\\fax.ini", buf);
    }
    else
        _makepath(szFile, drive, dir, "fax", ".ini" );
    GetPrivateProfileString("FAX", "LogPath",
                            "C:\\Fax\\Log\\",
                            g_log, 260, szFile);
    AddBslash(g_log);
    GetPrivateProfileString("FAX", "CallerID",
                            "HKAH",
                            sCallerID, 260, szFile);
	m_From = _T(sCallerID);
    GetPrivateProfileString("FAX", "CallerNo",
                            "36518800",
                            sCallerNo, 260, szFile);

    GetPrivateProfileString("FAX", "Server",
                            "Driver={Oracle in OraDb10g_home1};Dbq=seed;UID=lis;PWD=laboratory",
							g_szServer, 260, szFile);

    GetPrivateProfileString("FAX", "BackupPath",
                            "c:\\fax\\faxlog\\backup\\",
							g_szBackup, 260, szFile);
	
	g_backup = GetPrivateProfileInt("FAX", "Backup", 1, szFile);
	
	g_sleep = GetPrivateProfileInt("FAX", "Wait", 1, szFile);

	g_retry = GetPrivateProfileInt("FAX", "MaxRetry", 6, szFile);

	m_sIdentifi = _T(sCallerNo);
	m_iPort = GetPrivateProfileInt("FAX", "port", 0, szFile);
	m_bIs2D = GetPrivateProfileInt("FAX", "2D", 1, szFile);
	m_CreateHead = GetPrivateProfileInt("FAX", "CreateHead", 1, szFile);
	m_iClass = GetPrivateProfileInt("FAX", "Class", 0, szFile);
	m_bEcm = GetPrivateProfileInt("FAX", "ECM", 1, szFile);
	m_iVolume = GetPrivateProfileInt("FAX", "vol", 1, szFile);
	m_nResolution = GetPrivateProfileInt("FAX", "res", 0, szFile);
	m_iSpeed = GetPrivateProfileInt("FAX", "speed", 0, szFile);
	
	g_FaxDialog = this;
	curPage = 1;
	WriteLog("Program starts");

//SQL Connect 20151217
	dbconnect();
//20151217

	SetTimer(100,1000, 0); 
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CFAXSENDDlg::OnCancel()
{
   // TODO: Add extra cleanup here

   // Ensure that you reset all the values back to the
   // ones before modification. This handler is called
   // when the user doesn't want to save the changes.

   if (AfxMessageBox(_T("Are you sure to abort fax?"), 
      MB_YESNO) == IDNO)
   {
      // Give the user a chance if he has unknowingly hit the
      // Cancel button. If he says No, return. Don't reset. If
      // Yes, go ahead and reset the values and close the dialog.
      return; 
   }

//SQL Connect 20151217
	dbdisconnect();
	WriteLog("Program stopped");

//20151217
   CDialog::OnCancel();
}

void CFAXSENDDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CFAXSENDDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CFAXSENDDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}




EFaxSpeed GetSelSpeed(int Index)
{
	switch(Index)
	{
	case 0:
		return FS_1440;
	case 1:
		return FS_1200;
	case 2:
		return FS_9600;
	case 3:
		return FS_7200;
	case 4:
		return FS_4800;
	default:
		return FS_2400;
	}
}



EVolume GetFaxVolume(int Index)
{
	switch(Index)
	{
	case 0:
		return VO_OFF;
	case 1:
		return VO_LOW;
	case 2:
		return VO_MIDDLE;
	default :
		return VO_HIGH;	
	}
}


void CFAXSENDDlg::OnSendFax() 
{
	// TODO: Add your control notification handler code here

	this->UpdateData(TRUE);
/*
	if(m_iPort==0)  // From Tapi 
	{
		int nSel =  m_ModemList.GetCurSel();
		DWORD dwDevice = m_ModemList.GetItemData(nSel);
		
		if(dwDevice >=0 )
		{
			InitializeTAPI(dwDevice);
			InitFaxTapiCall(g_hLine,g_hCall);
		}
		
		
	}else   // From ComPort
	{				
		ComPortSendFax();		
	}*/
	InitializeTAPI(0);
	InitFaxTapiCall(g_hLine,g_hCall);
}

void CFAXSENDDlg::OnSmartFax(WPARAM wParam, LPARAM lParam)
{

	SQLINTEGER Length = SQL_NTS;
//	SQLHENV env;
//	SQLHDBC dbc;
	SQLHSTMT stmt;
//ODBC API return status
	SQLRETURN ret; 

	SQLINTEGER SQLerr;
	SQLSMALLINT SQLmsglen;

//	SQLCHAR OutConnStr[255];
//	SQLSMALLINT OutConnStrLen;

	unsigned char * pStatus = new unsigned char;
	unsigned char * pMsg = new unsigned char;

	//unsigned char * error = new unsigned char;

	static unsigned long faxdata = 0 ;

	char bakname[260];
//	char orgname[260];
	char *p;
	char fname[260];
	bool unknown;

	SQLCHAR SQLSUC[200] = "update labo_mastfax set status = 'S' where rowid = ?";
	SQLCHAR SQLHOLD[200] = "update labo_mastfax set status = '6' where rowid = ?";
	//SQLCHAR SQLDEL[200] = "delete labo_mastfax where rowid = ?";				

	this->UpdateData();

	switch(wParam)
	{

	case WM_FAXUSERCANCE:
		m_Stat =  "User Cancel Send fax...";
		//ShutdownTAPI();		
		break;

	case WM_FAXMISSIONOUTOVER:
		{
			ShutdownTAPI();

			unknown = false;
		
			if (lParam==0)
			{
				m_Stat = "Send fax successful";
				WriteLog("Send fax successful. File: %s Labno: %s to: %s", FaxFile, fLABNUM, fFAXNUM);
				Sleep(g_sleep);

//				if (curPage >= fTOTPAGE) {
					curPage = 0;
/*
//sql connection
					ret = SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &env);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_ENV, env, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
					}

					ret = SQLSetEnvAttr(env, SQL_ATTR_ODBC_VERSION, (SQLPOINTER*) SQL_OV_ODBC3, 0);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_ENV, env, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
					}

					ret = SQLAllocHandle(SQL_HANDLE_DBC, env, &dbc);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
					}

					ret = SQLDriverConnect(
						dbc, 
						NULL, 
						(SQLCHAR*) g_szServer, 
						SQL_NTS,
						OutConnStr,
						255, 
						&OutConnStrLen,
						SQL_DRIVER_NOPROMPT );
	
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
					}
*/
					ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt); 
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}

//status: 1 = New, 4 = Ready, 6 = Hold, S = Sent
				//SQLCHAR SQL[200] = "update labo_mastfax set status = 'S', fax_image=null where lab_num=? and dest_code=? and mod_type=?";
				//SQLCHAR SQL[200] = "update labo_mastfax set status = 'S', fax_image=null where rowid=?";

// Bind Parameters
					ret = SQLBindParameter(stmt, 1, SQL_PARAM_INPUT,
						SQL_C_CHAR, SQL_CHAR, 0, 0,
						tROWID, sizeof(tROWID), &Length);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}
				/*ret = SQLBindParameter(stmt, 1, SQL_PARAM_INPUT,
					SQL_C_CHAR, SQL_CHAR, 0, 0,
					fLABNUM, sizeof(fLABNUM), &Length);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
				}

				ret = SQLBindParameter(stmt, 2, SQL_PARAM_INPUT,
					SQL_C_CHAR, SQL_CHAR, 0, 0,
					fDEST, sizeof(fDEST), &Length);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
				}

				ret = SQLBindParameter(stmt, 3, SQL_PARAM_INPUT,
					SQL_C_CHAR, SQL_CHAR, 0, 0,
					fMODTYPE, sizeof(fMODTYPE), &Length);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
				}*/
//Prepare SQL
					ret = SQLPrepare(stmt, SQLSUC, SQL_NTS);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}

// Execute statement with parameters
					ret = SQLExecute(stmt);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}
//insert log
					SQLCHAR SQL1[200] = "insert into labo_faxlog (LAB_NUM, NAME1, CALL_TYPE, FAX_NUM, DATE_SENT, TIME_SENT, FAX_MESSAG, ANS_BY, FAX_BY, MOD_TYPE) values (?,?, 'F', ?, sysdate, TO_CHAR(sysdate, 'HH24:MI'), 'OK',?,?,?)";
						
// Bind Parameters
					ret = SQLBindParameter(stmt, 1, SQL_PARAM_INPUT,
						SQL_C_CHAR, SQL_CHAR, 0, 0,
						fLABNUM, sizeof(fLABNUM), &Length);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}

					ret = SQLBindParameter(stmt, 2, SQL_PARAM_INPUT,
						SQL_C_CHAR, SQL_CHAR, 0, 0,
						fNAME, sizeof(fNAME), &Length);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}

					ret = SQLBindParameter(stmt, 3, SQL_PARAM_INPUT,
						SQL_C_CHAR, SQL_CHAR, 0, 0,
						fFAXNUM, sizeof(fFAXNUM), &Length);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}

					ret = SQLBindParameter(stmt, 4, SQL_PARAM_INPUT,
						SQL_C_CHAR, SQL_CHAR, 0, 0,
						fFAXNUM, sizeof(fFAXNUM), &Length);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}

					ret = SQLBindParameter(stmt, 5, SQL_PARAM_INPUT,
						SQL_C_CHAR, SQL_CHAR, 0, 0,
						fFAXBY, sizeof(fFAXBY), &Length);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}

					ret = SQLBindParameter(stmt, 6, SQL_PARAM_INPUT,
						SQL_C_CHAR, SQL_CHAR, 0, 0,
						fMODTYPE, sizeof(fMODTYPE), &Length);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}
//Prepare SQL
					ret = SQLPrepare(stmt, SQL1, SQL_NTS);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}

// Execute statement with parameters
					ret = SQLExecute(stmt);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}	
//End connection
					ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}
/*disconnect    
					ret=SQLDisconnect(dbc);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						ret = SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
					}
    
					ret=SQLFreeHandle(SQL_HANDLE_DBC, dbc);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						ret = SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
					}
*/
/*
					for (int i=1;i<=fTOTPAGE;i++){
						sprintf(orgname, "%s%d.tif", fFILE, i);
						if (g_backup) {
							p = strrchr(orgname, '\\');
							p++;
							strcpy (fname, p);
							sprintf(bakname, "%s%s", g_szBackup, fname);
							WriteLog("Move file from %s to %s", orgname, bakname);
							CopyFile(orgname, bakname, FALSE);
						}
						DeleteFile(orgname);
					}
*/
//				}

				if (g_backup) {

					p = strrchr(m_FaxFileName, '\\');
					p++;
					strcpy (fname, p);
					sprintf(bakname, "%s%s", g_szBackup, fname);

					WriteLog("Move file from %s to %s", m_FaxFileName, bakname);
					CopyFile(m_FaxFileName, bakname, FALSE);
				}
				unlink(m_FaxFileName);
				//curPage++;

			}
			else {

/*
FAX FAIL error code
	101:    Failed to Open FAX file ~
	102:    Couldn't conneced  within 35 secs of ATA command
	103:	Resevr
	104:    Failed to send CSI frames 
	105:    Failed to send DIS frames 
	106:    Failed to send NFS frames 
	107:    Failed to send other negotiating frames
	108:    Failed to send CFR frames
	109:    Failed to training
	110:    Failed to send FTT frames
	111:    Failed to set training speed  3 times
	112:    Failed to send CRP frames
	113:    Failed to dropped carrier within 5 s 
	114:    Failed to respond to +FRM properly
	115:    Failed to get modem data
	116:    Failed to accept page data
  	201:	Couldn't be found transmit file 
	202:	Transmit file isn't TIFF CLASS
	203:	Call isn't answered within 30 s
	204:	Machine can't receive fax data
	205:	Couldn't set +FTM
	206:	Couldn't set +FTM
	210:	NO DIALTONE
	211:	BUSY
	212:	NO ANSWER
	213:	NO CARRIER
*/
				switch(lParam) {
					case 101:
						m_Stat = "Failed to Open FAX file\0";
						break;
					case 102:
						m_Stat = "ATA command error\0";
						break;
					case 103:
						m_Stat = "Resevr\0";
						break;
					case 104:
						m_Stat = "Failed to send CSI frames\0";
						break;
					case 105:
						m_Stat = "Failed to send DIS frames\0";
						break;
					case 106:
						m_Stat = "Failed to send NFS frames\0";
						break;
					case 107:
						m_Stat = "Negotiating frames error\0";
						break;
					case 108:
						m_Stat = "Failed to send CFR frames\0";
						break;
					case 109:
						m_Stat = "Failed to training\0";
						break;
					case 110:
						m_Stat = "Failed to send FTT frames\0";
						break;
					case 111:
						m_Stat = "Set training speed error\0";
						break;
					case 112:
						m_Stat = "Failed to send CRP frames\0";
						break;
					case 113:
						m_Stat = "Failed to dropped carrier\0";
						break;
					case 114:
						m_Stat = "Failed to respond to +FRM\0";
						break;
					case 115:
						m_Stat = "Failed to get modem data\0";
						break;
					case 116:
						m_Stat = "Failed to accept page\0";
						break;
					case 201:
						m_Stat = "Transmit file not found\0";
						break;
					case 202:
						m_Stat = "Transmit file isn't TIFF\0";
						break;
					case 203:
						m_Stat = "No answered within 30s\0";
						break;
					case 204:
						m_Stat = "Receive fax data error\0";
						break;
					case 205:
						m_Stat = "Couldn't set +FTM\0";
						break;
					case 206:
						m_Stat = "Couldn't set +FTM\0";
						break;
					case 210:
						m_Stat = "NO DIALTONE\0";
						break;
					case 211:
						m_Stat = "BUSY\0";
						break;
					case 212:
						m_Stat = "NO ANSWER\0";
						break;
					case 213:
						m_Stat = "NO CARRIER\0";
						break;
					default:
						sprintf(fSTATUS, "Unknown return code: %d\0", lParam);
						m_Stat = _T(fSTATUS);
						unknown = true;
				}

				sprintf(fSTATUS, "%s", m_Stat);
				WriteLog("%s File: %s Labno: %s to: %s", m_Stat, FaxFile, fLABNUM, fFAXNUM);

//sql connection
/*
				ret = SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &env);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_ENV, env, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
				}

				ret = SQLSetEnvAttr(env, SQL_ATTR_ODBC_VERSION, (SQLPOINTER*) SQL_OV_ODBC3, 0);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_ENV, env, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
				}

				ret = SQLAllocHandle(SQL_HANDLE_DBC, env, &dbc);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
				}

				ret = SQLDriverConnect(
					dbc, 
					NULL, 
					(SQLCHAR*) g_szServer, 
					SQL_NTS,
					OutConnStr,
					255, 
					&OutConnStrLen,
					SQL_DRIVER_NOPROMPT );
	
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
				}
*/
				ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt); 
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
					dbdisconnect();
					dbconnect();
				}

//update mastfax
//status: 1 = New, 4 = Ready, 6 = Hold, S = Sent
				//SQLCHAR SQL2[200] = "update labo_mastfax set status = '6' where lab_num= ? and dest_code= ? and mod_type= ?";

// Bind Parameters
				ret = SQLBindParameter(stmt, 1, SQL_PARAM_INPUT,
					SQL_C_CHAR, SQL_CHAR, 0, 0,
					tROWID, sizeof(tROWID), &Length);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
					dbdisconnect();
					dbconnect();
				}
				/*ret = SQLBindParameter(stmt, 1, SQL_PARAM_INPUT,
					SQL_C_CHAR, SQL_CHAR, 0, 0,
					fLABNUM, sizeof(fLABNUM), &Length);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
				}

				ret = SQLBindParameter(stmt, 2, SQL_PARAM_INPUT,
					SQL_C_CHAR, SQL_CHAR, 0, 0,
					fDEST, sizeof(fDEST), &Length);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
				}

				ret = SQLBindParameter(stmt, 3, SQL_PARAM_INPUT,
					SQL_C_CHAR, SQL_CHAR, 0, 0,
					fMODTYPE, sizeof(fMODTYPE), &Length);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
				}*/
//Prepare SQL
				/*
				if (lParam == 101) {
					ret = SQLPrepare(stmt, SQLDEL, SQL_NTS);
				} else {
					ret = SQLPrepare(stmt, SQLHOLD, SQL_NTS);
				}
				*/
				ret = SQLPrepare(stmt, SQLHOLD, SQL_NTS);


				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
					dbdisconnect();
					dbconnect();
				}

// Execute statement with parameters
				ret = SQLExecute(stmt);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
					dbdisconnect();
					dbconnect();
				}

				//if (lParam != 101) {
//insert log	
					SQLCHAR SQL3[200] = "insert into labo_faxlog (LAB_NUM, NAME1, CALL_TYPE, FAX_NUM, DATE_SENT, TIME_SENT, FAX_MESSAG, ANS_BY, FAX_BY, MOD_TYPE) values (?,?, 'F', ?, sysdate, TO_CHAR(sysdate, 'HH24:MI'), ?,?,?,?)";
// Bind Parameters
					ret = SQLBindParameter(stmt, 1, SQL_PARAM_INPUT,
						SQL_C_CHAR, SQL_CHAR, 0, 0,
						fLABNUM, sizeof(fLABNUM), &Length);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}

					ret = SQLBindParameter(stmt, 2, SQL_PARAM_INPUT,
						SQL_C_CHAR, SQL_CHAR, 0, 0,
						fNAME, sizeof(fNAME), &Length);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}
	
					ret = SQLBindParameter(stmt, 3, SQL_PARAM_INPUT,
						SQL_C_CHAR, SQL_CHAR, 0, 0,
						fFAXNUM, sizeof(fFAXNUM), &Length);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}

					ret = SQLBindParameter(stmt, 4, SQL_PARAM_INPUT,
						SQL_C_CHAR, SQL_CHAR, 0, 0,
						fSTATUS, sizeof(fSTATUS), &Length);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}

					ret	= SQLBindParameter(stmt, 5, SQL_PARAM_INPUT,
						SQL_C_CHAR, SQL_CHAR, 0, 0,
						fFAXNUM, sizeof(fFAXNUM), &Length);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}

					ret = SQLBindParameter(stmt, 6, SQL_PARAM_INPUT,
						SQL_C_CHAR, SQL_CHAR, 0, 0,
						fFAXBY, sizeof(fFAXBY), &Length);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}

					ret = SQLBindParameter(stmt, 7, SQL_PARAM_INPUT,
						SQL_C_CHAR, SQL_CHAR, 0, 0,
						fMODTYPE, sizeof(fMODTYPE), &Length);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}
//Prepare SQL
					ret = SQLPrepare(stmt, SQL3, SQL_NTS);
					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}

// Execute statement with parameters
				
					ret = SQLExecute(stmt);

					if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
						SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
						pStatus,&SQLerr,pMsg,100,&SQLmsglen);
						WriteLog("%s:%s", pStatus, pMsg);
						dbdisconnect();
						dbconnect();
					}
				//}
//End connection
				ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
					dbdisconnect();
					dbconnect();
				}
/*    
				ret=SQLDisconnect(dbc);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					ret = SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
				}
    
				ret=SQLFreeHandle(SQL_HANDLE_DBC, dbc);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					ret = SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
				}
*/
				curPage = 1;
			//KillTimer(100);
			}
		}

		break;		


		
	case WM_FAXCHANGESTATE:					
		{

				switch(lParam)
				{

				case FAXINIT:

					m_bEcmFlag = false ;
					m_nTimes = 0 ;
					SetTimer(100,1000, 0); 
					m_Remote="";
					faxdata = 0;
					m_Fax_data.Format("%dK",0);	



					m_Stat =  "Init Device";
					this->UpdateData(false);
					break;
				case DIALFAX:
					m_Stat =  "Dialing...";
					break;
				case ANSWER:
					m_Stat =  "Answering...";
					break; 
				case NEGOTIATION:
					m_Stat =  "Negotiating...";
					break; 
				case TRAINING:
					m_Stat =  "Training....";
					break; 
			
			
				}
		}

		break; 
	case WM_FAXSETCIS:

		m_Remote.Format("%s",(char*)lParam );	
		m_Remote.TrimLeft(" ");
		m_Remote.TrimRight(" ");

		break; 

	case WM_FAXSENDPAGEDATA:
		faxdata+=(long)lParam;
		m_Fax_data.Format("%dK",faxdata/1024);							
		break;

	case WM_ACCEPTPAGE:
		m_Stat =  "Page accepted ...";
		
		break;
	case WM_REJECTPAGE:
		m_Stat =  "Page rejected ...";
		
		break;

	case WM_FAXSPEED:
		m_Speed.Format("%d%s",lParam,"00 bps");
		break;

	case WM_FAXPAGE:
		m_nPage = (int)lParam;
		m_sPage.Format("Page %d",m_nPage);
		break;

	case WM_FAXECM:
		m_bEcmFlag  =  lParam == 0 ? false : true ;
		break;

	case WM_FAXPROCESSPAGEDATA:				
	
    	m_Stat =  "Sending page ";
		
		switch(lParam)
		{
			case D1DMR:

				if(m_bEcmFlag)
					m_Stat +=  "(ECM MH)...";
				else
					m_Stat += "(1DMH)...";
			
				break;
			case D2DMR:
							
				if(m_bEcmFlag)
					m_Stat +=  "(ECM 2DMR)...";
				else
					m_Stat += "(2DMR)...";			

				break;			
			case D2DMMR:

				if(m_bEcmFlag)
					m_Stat +=  "(ECM MMR)...";
				else
					m_Stat += "(2DMMR)...";
				break;
		}
	    break;

	default:
		;
	}

	TRACE("OnSmartFax  wParam == %d ----- lParam == %d \n",wParam,lParam);
	this->UpdateData(false);
}


void CFAXSENDDlg::OnCancelFax() 
{

	AbortPort(&g_hFax);
	
}

void CFAXSENDDlg::OnTimer(UINT nIDEvent) 
{
	// TODO: Add your message handler code here and/or call default
	if(nIDEvent == 100 )
	{
		CTimeSpan ts(0,0,0,m_nTimes++);		
		m_sTakeTime.Format("%01d:%01d:%02d",ts.GetHours(),ts.GetMinutes(),ts.GetSeconds());
	}

//	SQLINTEGER Length;
//	SQLHENV env;
//	SQLHDBC dbc;
	SQLHSTMT stmt;
	SQLRETURN ret; /* ODBC API return status*/ 
		
	SQLINTEGER SQLerr;
	SQLSMALLINT SQLmsglen;

//	SQLCHAR OutConnStr[255];
//	SQLSMALLINT OutConnStrLen;
	SQLINTEGER Length = SQL_NTS;
	unsigned char * pStatus = new unsigned char;
	unsigned char * pMsg = new unsigned char;

//sql connection
/*
		ret = SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &env);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_ENV, env, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
		}

		ret = SQLSetEnvAttr(env, SQL_ATTR_ODBC_VERSION, (SQLPOINTER*) SQL_OV_ODBC3, 0);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_ENV, env, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
		}

		ret = SQLAllocHandle(SQL_HANDLE_DBC, env, &dbc);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
		}

		ret = SQLDriverConnect(
			dbc, 
	        NULL, 
		    (SQLCHAR*) g_szServer, 
			SQL_NTS,
	        OutConnStr,
		    255, 
	        &OutConnStrLen,
		    SQL_DRIVER_NOPROMPT );
	
	    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
		}
*/
		ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt); 
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
		}

//status: 1 = Sending, 4 = Ready, 6 = Hold, S = Sent
		SQLCHAR SQL[250] = "select name, fax_num, fax_image, faxed_by, mod_type, dest_code, lab_num, rowid, tot_page from labo_mastfax where status in ('1', '4') and call_type = 'F' and fax_image is not null and tot_page is not null order by status, priority desc, date_ready";

		ret = SQLPrepare(stmt, SQL, SQL_NTS);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
		}
	
		ret = SQLExecute(stmt);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
		}
//bind parameter
    
	// field length parameters...
		SDWORD lNAME, lFAXNUM, lFILE, lFAXBY, lMODTYPE, lDEST, lLABNUM, lROWID, lTOTPAGE;
	    lNAME=lFAXNUM=lFILE=lFAXBY=lMODTYPE=lDEST=lLABNUM=lROWID=lTOTPAGE=SQL_NTS;

		ret=SQLBindCol(stmt,1,SQL_C_CHAR, &fNAME,31,&lNAME);
	    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
		}

	    ret=SQLBindCol(stmt,2,SQL_C_CHAR, fFAXNUM,31,&lFAXNUM);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
		}

		ret=SQLBindCol(stmt,3,SQL_C_CHAR, fFILE,1001,&lFILE);
	    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
		}

	    ret=SQLBindCol(stmt,4,SQL_C_CHAR, fFAXBY,11,&lFAXBY);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
		}

		ret=SQLBindCol(stmt,5,SQL_C_CHAR, fMODTYPE,2,&lMODTYPE);
	    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
		}

	    ret=SQLBindCol(stmt,6,SQL_C_CHAR, fDEST,11,&lDEST);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
		}

		ret=SQLBindCol(stmt,7,SQL_C_CHAR, fLABNUM,9,&lLABNUM);
	    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
		}

	    ret=SQLBindCol(stmt,8,SQL_C_CHAR, fROWID,20,&lROWID);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
		}

		ret=SQLBindCol(stmt,9,SQL_C_LONG, &fTOTPAGE,0,&lTOTPAGE);
	    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
		}
		

		ret=SQLFetch(stmt);
	    if(ret == SQL_SUCCESS || ret == SQL_SUCCESS_WITH_INFO) {

			this->UpdateData(true);

//			if (curPage == 1) {
				m_To = _T(fNAME);

				m_From = _T(fFAXBY);

				m_FaxNumber = _T(fFAXNUM);

				strcpy(tFILE, fFILE);

				strcpy(tROWID, fROWID);

				ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
					dbdisconnect();
					dbconnect();
				}

				ret = SQLAllocHandle(SQL_HANDLE_STMT, dbc, &stmt); 
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
					dbdisconnect();
					dbconnect();
				}

				SQLCHAR SQL2[200] = "update labo_mastfax set status = '1' where rowid = ?";

// Bind Parameters
				ret = SQLBindParameter(stmt, 1, SQL_PARAM_INPUT,
					SQL_C_CHAR, SQL_CHAR, 0, 0,
					tROWID, sizeof(tROWID), &Length);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
					dbdisconnect();
					dbconnect();
				}
//Prepare SQL
				ret = SQLPrepare(stmt, SQL2, SQL_NTS);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
					dbdisconnect();
					dbconnect();
				}

// Execute statement with parameters
				ret = SQLExecute(stmt);
				if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
					SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
					pStatus,&SQLerr,pMsg,100,&SQLmsglen);
					WriteLog("%s:%s", pStatus, pMsg);
					dbdisconnect();
					dbconnect();
				}

//			}
			
			//sprintf(FaxFile, "%s%d.tif", tFILE, curPage);
			sprintf(FaxFile, "%s.tif", tFILE);
			
			m_FaxFileName = _T(FaxFile);

			OnSendFax();
		}
		
		ret=SQLFreeHandle(SQL_HANDLE_STMT, stmt);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			SQLGetDiagRec(SQL_HANDLE_STMT, stmt, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
			dbdisconnect();
			dbconnect();
		}
/*    
		ret=SQLDisconnect(dbc);
	    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			ret = SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
		}
    
		ret=SQLFreeHandle(SQL_HANDLE_DBC, dbc);
		if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
			ret = SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
			WriteLog("%s:%s", pStatus, pMsg);
		}
*/
	CDialog::OnTimer(nIDEvent);
}

void CFAXSENDDlg::FillComboBox(DWORD dwDevice, const char *sLineName, const char *ComPort, unsigned long lParam)
{

	CComboBox *ModemList = (CComboBox *)lParam;
	int index = ModemList->AddString(sLineName);
	ModemList->SetItemData(index,dwDevice);	

}

int CFAXSENDDlg::TapiSendFax()
{
	this->UpdateData();

	DWORD CurrentProcess = GetPriorityClass(GetCurrentProcess());

	SFaxParam *Sender =(SFaxParam *) new SFaxParam; 
	Sender->hFax = &g_hFax;

	Sender->hCall = g_hCall;
	Sender->hLine = g_hLine;
	
	strcpy(Sender->FileName,m_FaxFileName);
	
	strcpy(Sender->FaxNumber,m_FaxNumber) ;

	Sender->Hwnd = this->GetSafeHwnd();
	Sender->Msg = WM_SMARTFAX;
	Sender->nComPort = m_iPort;

	Sender->Speed = GetSelSpeed(m_iSpeed);
	Sender->Is2D = m_bIs2D == TRUE ? U2D_ENABLE : U2D_DISABLE ;
	Sender->CreateHead = m_CreateHead == TRUE ? CH_ENABLE : CH_DISABLE;
	Sender->Class = m_iClass == 0 ? CLASS_1 : CLASS_2  ;
	strcpy(Sender->Identifi,m_sIdentif);
	Sender->Ecm = m_bEcm == TRUE ? ECM_ENABLE : ECM_DISABLE ;
	Sender->Volume =GetFaxVolume(m_iVolume) ;

	strcpy(Sender->From,m_From);
	strcpy(Sender->To,m_To);

	Sender->Resolution = m_nResolution == 0 ?  RE_FINE : RE_STANDARD ;
	Sender->nStartPage = 1 ;
	

	WriteLog("Attemp to send file:%s Num:%s", Sender->FileName, Sender->FaxNumber);

	TapiSmartSendFax(BIRTH,NULL,Sender);

//	TapiSmartSendFax(Sender);
	delete Sender;
	
	return 0;
}

int CFAXSENDDlg::ComPortSendFax()
{

	this->UpdateData();

	SFaxParam *Sender =(SFaxParam *) new SFaxParam; 
	Sender->hFax = &g_hFax;

	strcpy(Sender->FileName,m_FaxFileName);
	strcpy(Sender->FaxNumber,m_FaxNumber) ;

	Sender->Hwnd = this->GetSafeHwnd();
	Sender->Msg = WM_SMARTFAX;
	Sender->nComPort = m_iPort;
    
	Sender->Speed = GetSelSpeed(m_iSpeed);
	Sender->Is2D = m_bIs2D == TRUE ? U2D_ENABLE : U2D_DISABLE ;
	Sender->CreateHead = m_bEcm == TRUE ? CH_ENABLE : CH_DISABLE;
	Sender->Class = m_iClass == 0  ? CLASS_1 : CLASS_2  ;
	strcpy(Sender->Identifi,m_sIdentif);
	Sender->Ecm = m_bEcm == TRUE ? ECM_ENABLE : ECM_DISABLE ;
	Sender->Volume = GetFaxVolume(m_iVolume) ;
	
	strcpy(Sender->From,m_From);
	strcpy(Sender->To,m_To);
	Sender->nStartPage = 1 ;
	Sender->Resolution = m_nResolution == 0 ?  RE_FINE : RE_STANDARD ;


	//int rc = SmartSendFax(Sender);
	int rc = SmartSendFax(BIRTH,NULL,Sender);

	delete Sender;	

	return rc;

}



void CFAXSENDDlg::OnCreateHead() 
{
	// TODO: Add your control notification handler code here

	BOOL fEnable ;
	this->UpdateData();
	fEnable = m_CreateHead ;
}

CString CFAXSENDDlg::GetWorkPath()
{
	char szPath[512];
	CString strTemp;
	int nPos;
	CString strWorkPath = _T( "" );
	
	GetModuleFileName( NULL , szPath , 512 );
	strTemp = szPath;
	nPos = strTemp.Find( '\\' );
	while( nPos != -1 )
	{
		strWorkPath += strTemp.Left( nPos + 1 );
		strTemp = strTemp.Right( strlen( strTemp ) - nPos -1 );
		nPos = strTemp.Find( '\\' );
	}

	return strWorkPath;

}

CString CFAXSENDDlg::GetFullPath(CString FileName)
{	
	int nPos = FileName.Find(':');

	if(nPos ==-1)
	{
		return GetWorkPath()+FileName;
	}
	return FileName;
}

void CFAXSENDDlg::OnStaticWww() 
{
	// TODO: Add your control notification handler code here
	ShellExecute(NULL,"open","http://www.i-enet.com",NULL,NULL,SW_SHOWNORMAL);
}

int CFAXSENDDlg::AddBslash(char *s)
{
    int len;

    len = strlen(s);
    if (len == 0) return 0;
    if (s[len-1] == '\\' || s[len-1] == '/') return 0;
    s[len++] = '\\';
    s[len] = '\0';

    return 1;
}

void CFAXSENDDlg::WriteLog(char *fmt, ...)
{
    char buf[4096];
    va_list marker;
    char fname[260];
    FILE *fp;
    time_t t;
    struct tm *tp;
    static char szOldMsg[4096];
    char *p;

    va_start(marker, fmt);
    vsprintf(buf, fmt, marker);
    va_end(marker);

    if (strcmp(szOldMsg, buf) == 0) return;
    strcpy(szOldMsg, buf);

    p = strtok(buf, "\r\n");
    if (p == NULL)
        *p = '\0';

    time(&t);
    tp = localtime(&t);
    if (tp != NULL) {
        sprintf(fname, "%s%02d%02d.log", g_log,
                        tp->tm_mon+1, tp->tm_mday);
        fp = fopen(fname, "at");
        if (fp != NULL) {
            fprintf(fp, "%02d:%02d:%02d %s\n", tp->tm_hour, tp->tm_min, tp->tm_sec, buf);
            fclose(fp);
        }
    }
    return;
}

void CFAXSENDDlg::dbconnect(void) {
////db connection
//
	SQLRETURN ret; /* Odbc API return status*/ 
	SQLINTEGER SQLerr;
	SQLSMALLINT SQLmsglen;
	unsigned char * pStatus = new unsigned char;
	unsigned char * pMsg = new unsigned char;
	
//20180510 Arran add sleep before connect
	Sleep(g_sleep);

	WriteLog("Connecting database");

	ret = SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &env);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_ENV, env, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
	}

	ret = SQLSetEnvAttr(env, SQL_ATTR_ODBC_VERSION, (SQLPOINTER*) SQL_OV_ODBC3, 0);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_ENV, env, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
	}

	ret = SQLAllocHandle(SQL_HANDLE_DBC, env, &dbc);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
	}
	
	ret = SQLDriverConnect(
		dbc, 
        NULL, 
        (SQLCHAR*) g_szServer, 
		SQL_NTS,
        OutConnStr,
        255, 
        &OutConnStrLen,
        SQL_DRIVER_NOPROMPT );             

    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
	}

////
}

void CFAXSENDDlg::dbdisconnect(void) {
	//Disconnect
	SQLRETURN ret; /* Odbc API return status*/ 
	SQLINTEGER SQLerr;
	SQLSMALLINT SQLmsglen;
	unsigned char * pStatus = new unsigned char;
	unsigned char * pMsg = new unsigned char;

    ret=SQLDisconnect(dbc);
    if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		ret = SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
	}

    ret=SQLFreeHandle(SQL_HANDLE_DBC, dbc);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		ret = SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
	}
	dbc = NULL;
	
	ret=SQLFreeHandle(SQL_HANDLE_ENV, env);
	if(ret != SQL_SUCCESS && ret != SQL_SUCCESS_WITH_INFO) {
		ret = SQLGetDiagRec(SQL_HANDLE_DBC, dbc, 1,
			pStatus,&SQLerr,pMsg,100,&SQLmsglen);
		WriteLog("%s:%s", pStatus, pMsg);
	}
    env = NULL;

	WriteLog("Database disconnected");
}