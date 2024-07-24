// ReceiveFaxDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ReceiveFax.h"
#include "ReceiveFaxDlg.h"
#include "dlgFaxPortSetup.h"
#include "dlgFaxClose.h"
#include "commcl.h"
#include "faxclass.h"

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
// CReceiveFaxDlg dialog

CReceiveFaxDlg::CReceiveFaxDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CReceiveFaxDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CReceiveFaxDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CReceiveFaxDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CReceiveFaxDlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CReceiveFaxDlg, CDialog)
	//{{AFX_MSG_MAP(CReceiveFaxDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_WM_CREATE()
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_OPENPORT, OnOpenport)
	ON_BN_CLICKED(IDC_CLOSEPORT, OnCloseport)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CReceiveFaxDlg message handlers

BOOL CReceiveFaxDlg::OnInitDialog()
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
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CReceiveFaxDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CReceiveFaxDlg::OnPaint() 
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
HCURSOR CReceiveFaxDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

int CReceiveFaxDlg::OnCreate(LPCREATESTRUCT lpCreateStruct) 
{
	if (CDialog::OnCreate(lpCreateStruct) == -1)
		return -1;
//Initialize the fax driver.
//Register the window for receiving events related to the fax transmission.
	if(SetupFaxDriver(NULL) || SetFaxMessage(this->m_hWnd))
        AfxMessageBox("Setting fax driver has failed!");
	
	return 0;
}

void CReceiveFaxDlg::OnDestroy() 
{
	CDialog::OnDestroy();
	
	CReceiveFaxApp *pApp = (CReceiveFaxApp *)AfxGetApp();

    for(int i=0;i<MAX_COMPORTS;i++){
        if ( pApp->FaxPorts[i] ) {
            if ( pApp->FaxPorts[i]->IsOpen() ) {
                pApp->FaxPorts[i]->AbortFax();
            }
        }
    }
//Unregister the window registered with SetFaxMessage.
    KillFaxMessage(this->m_hWnd);
    EndOfFaxDriver(TRUE);		
}

void CReceiveFaxDlg::OnOpenport() 
{
	bool isAvailablePort=false;
    char chFullName[15];

	for (int nCom = 0 ; nCom < MAX_COMPORTS ; nCom++) {
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
			isAvailablePort=true;
			break;
        }
    }	
	if (isAvailablePort)
	{
		CdlgFaxPortSetup dlgFaxPortSetup;
	    dlgFaxPortSetup.DoModal();	
	}
	else AfxMessageBox("There is no available port!");	
}

void CReceiveFaxDlg::OnCloseport() 
{
	CDlgFaxClose dlgCloseFaxPort;

    dlgCloseFaxPort.DoModal();	
}

LRESULT CReceiveFaxDlg::WindowProc(UINT message, WPARAM wParam, LPARAM lParam) 
{
	int iError;	

	CReceiveFaxApp *pApp = (CReceiveFaxApp *)AfxGetApp();
    if(message == pApp->nMessage)
    {
				switch(wParam)
				{
					case MFX_RECEIVED:
						//the fax was received
					
						FAXOBJ fax=(FAXOBJ)lParam;              //get a pointer for the first fax object

                        if ( fax ) { 

                                TUFaxImage  FaxPage;
								CFileDialog dlgSave(FALSE, _T("TIF"), NULL, NULL,_T("TIFF File Format|*.tif|"));
								dlgSave.DoModal();
								CString fileName = dlgSave.GetPathName();
								delete dlgSave;
								if (fileName=="") break;
                                memset( &FaxPage, 0, sizeof(FaxPage) );

                                FaxPage.File = fileName ;
								TSFaxParam sParam;
			/***********Retrieve the parameters of the fax to find out the number of received pages*****/
			/*parameter:	Reference to a fax parameter structure.*/
								fax->GetParam(sParam);  //we need to know how many pages contains the fax object

								for(int i=0;i<sParam.PageNum;++i)  //save every page
											
			/*******************Get the image of the fax***********************************/ 
			/*1. parameter:	Fax object.
			  2. parameter:	Number of pages (zero based).
			  3. parameter:	Image type. The types of the destination image can be:

				IMT_MEM_DIRECT          Copy Raw data  to  memory. 
                                        The  Data type depends on FaxObject type
                                        CCITT encoded  - on Normal Fax.
                                        BFT encoded  - on   Bft Fax 
                                        In ECM mode enable to receive  Custom Data from another Fax C++  station  
				IMT_MEM_BITMAP          Memory handle to a device dependent bitmap.
				IMT_MEM_DIB             Memory handle to a device independent bitmap.
				IMT_FILE_DIRECT         Copy Raw data  to  file. 
                                        The  Data type depends on FaxObject type
                                        CCITT encoded  - on Normal Fax.
                                        BFT encoded  - on   Bft Fax 
                                        In ECM mode enable to receive  Custom Data from another FaxC++  station  
				IMT_FILE_BMP		    The image is given as a Windows bitmap file.
				IMT_FILE_PCX            The image is given as a PCX file
				IMT_FILE_DCX            The image is given as a DCX file.
				IMT_FILE_TIFF_NOCOMP    The image is given as an uncompressed TIFF file.
				IMT_FILE_TIFF_PACKBITS  The image is given as a TIFF file with pack bits compression.
				IMT_FILE_TIFF_LZW       The image is given as a TIFF file with LZW compression.
				IMT_FILE_TIFF_LZDIFF    The image is given as a TIFF file with differential LZW compression.
				IMT_FILE_TIFF_G31DNOEOL The image is given as a TIFF file with Group 3 one dimensional NoEol compression..
				IMT_FILE_TIFF_G31D      The image is given as a TIFF file with Group 2 one dimensional.
				IMT_FILE_TIFF_G32D      The image is given as a TIFF file with Group 3 two dimensional compression..
				IMT_FILE_TIFF_G4        The image is given as a TIFF file with G4 compression.
				IMT_FILE_GIF            The image is given as a GIF file.
				IMT_FILE_TGA            The image is given as a TGA file.
				IMT_FILE_JPEG           The image is given as  a JPEG file.
				IMT_BFTOBJ              The page is a BFT page. The PageImage -> BftObj member must point to a valid TCBinaryParam object.

			  4. parameter:	Pointer to an image structure.
							The name of the file must be specified in the TUFaxImage union.
			  5. parameter:	If TRUE, the image will be appended to the file, otherwise the file will be created or truncated.		
			  Returns zero on success, otherwise returns an error code. 
			  In the case of the TUFaxImage type is IMT_MEM_DIRECT or IMT_FILE_DIRECT, 
			  the function returns the number of scan lines in the image if fax object type is REGTYPE_NORMALFAX.
			*/
								iError=GetFaxImagePage( fax, i, IMT_FILE_TIFF_G31D, &FaxPage, TRUE );
								if (iError!=0){
									char buf[10];
									sprintf(buf,"%d",iError);
									AfxMessageBox(buf);
								}

                        }
						/*****************Delete fax object.******************/
						//parameter: fax object
						
						if (fax) ClearFaxObj(fax);

                        break;
				}
    }		
	return CDialog::WindowProc(message, wParam, lParam);
}
