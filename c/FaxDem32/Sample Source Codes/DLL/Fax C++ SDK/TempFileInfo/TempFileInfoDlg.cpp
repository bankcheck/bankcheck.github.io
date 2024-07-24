// TempFileInfoDlg.cpp : implementation file
//

#include "stdafx.h"
#include "faxclass.h"
#include "faxcpp.h"
extern "C" {
#include "bitiff.h"
};
//#include "logs.h"
#include "TempFileInfo.h"
#include "TempFileInfoDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

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
// CTempFileInfoDlg dialog

CTempFileInfoDlg::CTempFileInfoDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CTempFileInfoDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CTempFileInfoDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);		
}

void CTempFileInfoDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CTempFileInfoDlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CTempFileInfoDlg, CDialog)
	//{{AFX_MSG_MAP(CTempFileInfoDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDD_TEMPFILEINFO_DIALOG, OnTempfileinfoDialog)
	ON_BN_CLICKED(IDC_BROWSE, OnBrowse)			
	ON_BN_CLICKED(IDC_SAVE, OnSave)
	ON_BN_CLICKED(IDC_CANCEL, OnCancel)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CTempFileInfoDlg message handlers

BOOL CTempFileInfoDlg::OnInitDialog()
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
	
	if(SetupFaxDriver(NULL) || SetFaxMessage(m_hWnd))
	{
        AfxMessageBox("Setting fax driver has failed!");
		exit(1);
	}
		
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CTempFileInfoDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CTempFileInfoDlg::OnPaint() 
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
HCURSOR CTempFileInfoDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CTempFileInfoDlg::OnTempfileinfoDialog() 
{
	// TODO: Add your control notification handler code here	
}

void CTempFileInfoDlg::OnBrowse() 
{	
	HFILE tmpFile;
	OFSTRUCT ofs;
	char tmpInf[MAX_PATH];
	
	LPSTR GroupFilterBuff =
    "Temporary Files (*.tmp)\0*.TMP\0"
    "All Files\0*.*\0";

	CFileDialog *dlgFile = new CFileDialog(TRUE);	
	dlgFile->m_ofn.lpstrTitle = "Open";
	dlgFile->m_ofn.lpstrFilter = GroupFilterBuff;
	if (dlgFile->DoModal()==IDOK) {
		SetDlgItemText( IDC_EDIT_TEMP_FILE,dlgFile->GetPathName());	
		sprintf(tmpInf,dlgFile->GetFileTitle());
		strcat(tmpInf,".tif");		
		SetDlgItemText( IDC_SAVE_TIFF,tmpInf);	
		strcpy(m_tmpFile,dlgFile->GetPathName());
		tmpFile = OpenFile( dlgFile->GetPathName(), (LPOFSTRUCT)&ofs, OF_READ );
							
		TSFaxHeader header;
		WORD    wSize;
		DWORD   dwRead;		

		_llseek( tmpFile, 0, 0 );
		wSize = sizeof(TSFaxHeader);
		dwRead = _lread( tmpFile, &header, wSize );

		_lclose(tmpFile);

		sprintf(tmpInf,"%s",dlgFile->GetFileName());		//File name
		SetDlgItemText(IDC_FILE_NAME_OUT,tmpInf);

		SetDlgItemText(IDC_SEND_RECEIVE_OUT,header.bSend?"Send":"Receive");		//Send or receive

		sprintf(tmpInf,"%s",header.bColorFax <= 1?"No":"Yes");		//Color fax
		SetDlgItemText(IDC_COLOR_OUT,tmpInf);

		sprintf(tmpInf,"%s",header.bColorType?"8 bits per pixel":"24 bits per pixel");		//Fax type
		SetDlgItemText(IDC_COLOR_TYPE_OUT,tmpInf);

		sprintf(tmpInf,"%d",header.bWidth);		//Width
		SetDlgItemText(IDC_WIDTH_OUT,tmpInf);

		sprintf(tmpInf,"%d",header.bLength);		//Length
		SetDlgItemText(IDC_LENGTH_OUT,tmpInf);

		sprintf(tmpInf,"%d",header.wPageNum);		//Page number
		SetDlgItemText(IDC_PAGENUM_OUT,tmpInf);
		
		sprintf(tmpInf,"%d",header.bResolut);		//Resolution
		SetDlgItemText(IDC_RESOLUT_OUT,tmpInf);
		
		SetDlgItemText(IDC_REMOTE_NUMBER_OUT,header.RemoteNumber);		//Remote number
		
		sprintf(tmpInf,"%d/%d/%d   %d:%d:%d",header.CreateTime.tm_mday,header.CreateTime.tm_mon+1,header.CreateTime.tm_year+1900,header.CreateTime.tm_hour,header.CreateTime.tm_min,header.CreateTime.tm_sec);		//Create time
		SetDlgItemText(IDC_CREATE_TIME_OUT,tmpInf);

		sprintf(tmpInf,"%d/%d/%d   %d:%d:%d",header.SendTime.tm_mday,header.SendTime.tm_mon+1,header.SendTime.tm_year+1900,header.SendTime.tm_hour,header.SendTime.tm_min,header.SendTime.tm_sec);		//Send time
		SetDlgItemText(IDC_SEND_TIME_OUT,tmpInf);
		
		sprintf(tmpInf,"%d",header.wRetry);		//Retry
		SetDlgItemText(IDC_RETRY_OUT,tmpInf);	
		
		sprintf(tmpInf,"%s",header.szName);		//Name
		SetDlgItemText(IDC_NAME_OUT,tmpInf);		

		sprintf(tmpInf,"%s",header.szCompany);		//Company
		SetDlgItemText(IDC_COMPANY_OUT,tmpInf);		
	
		delete dlgFile;	
		}
	else 
		{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with Cancel
		}
}

void CTempFileInfoDlg::OnOK() 
{
	// TODO: Add extra validation here	
	CDialog::OnOK();
}

void CTempFileInfoDlg::OnCancel() 
{
	// TODO: Add extra cleanup here
	CDialog::OnOK();
}

void CTempFileInfoDlg::OnSave() 
{	
	char tiff[MAX_PATH];
	int iError;
	CFile BlockFile;
	CFileException e;
	FAXOBJ Fax;
	TSFaxHeader hdr;
	TSFaxParam par;
	union TUFaxImage img;
	
	LPSTR GroupFilterBuff =
    "Tiff Files (*.tif)\0*.TIF\0"
    "All Files\0*.*\0";

	Fax = NULL;	
	GetDlgItemText(IDC_SAVE_TIFF, tiff, sizeof(tiff));
	CFileDialog *dlgSave = new CFileDialog(FALSE);	
	dlgSave->m_ofn.lpstrFilter = GroupFilterBuff;
	dlgSave->m_ofn.lpstrFile = tiff;
	if (dlgSave->DoModal()==IDOK) 
	{
		BeginWaitCursor();
		if (BlockFile.Open(m_tmpFile,CFile::modeRead,&e ) != 0 ) 
		{
			_lread((HFILE)BlockFile.m_hFile,&hdr,sizeof(TSFaxHeader));
			if ( hdr.bType == FXT_NORMAL )
				Fax = TCFaxNormal::CreateFaxObj( REGTYPE_NORMALFAX, FALSE );
			if ( hdr.bType == FXT_BFT ) 
				Fax = TCFaxNormal::CreateFaxObj( REGTYPE_BINARYFILE, FALSE );
			if ( hdr.bType == FXT_COLOR )
				Fax = TCFaxNormal::CreateFaxObj( REGTYPE_COLORFAX, FALSE);

			if (Fax)
			{
				Fax->ReadHeader((HFILE)BlockFile.m_hFile);
				Fax->ReadImgData((HFILE)BlockFile.m_hFile);
				Fax->GetParam( par );

				for (int s =0; s <= par.PageNum; ++s) 
				{
					iError = GetFaxImagePage( Fax, s, IMT_MEM_DIB, &img, FALSE );
					if ( !iError ) 
					{
						if (!SaveDIBInTiffFile((LPSTR)(LPCSTR)dlgSave->GetPathName(), img.Dib, TCOMP_PACKBITS, FALSE))
						{
							AfxMessageBox("Error saving tiff file.",MB_ICONERROR); 
							GlobalFree(img.Dib);
							BlockFile.Close();
							return;
						}

						GlobalFree(img.Dib);
					}
				}
			} 
			else 
			{
			AfxMessageBox("Error creating fax object.",MB_ICONERROR); 			
			BlockFile.Close();
			return;	
			}
			BlockFile.Close();
		}
		else
		{
			AfxMessageBox("Error opening tmp file.",MB_ICONERROR); 
			return;
		}
		EndWaitCursor();
	}
	else
		{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with Cancel
		}
}

