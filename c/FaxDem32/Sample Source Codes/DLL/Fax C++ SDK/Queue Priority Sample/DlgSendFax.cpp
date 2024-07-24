// DlgSendFax.cpp : implementation file
//

#include "stdafx.h"
#include "QueueFaxSample.h"
#include "DlgSendFax.h"
#include "faxtype.h"
#include "faxclass.h"
#include "faxcpp.h"
#include "commcl.h"
#include "time.h"
#include "io.h"
extern "C"{
#include "bidib.h"
#include "bitiff.h"
}

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#define SEND_TYPE_END      -1
#define SEND_TYPE_NORMAL    0

struct TFERTable
{
        int code;
        LPSTR txt;
};

static TFERTable errortab[] =
{
    { FER_MEMORIA               ,   "FER_MEMORIA"           } ,
    { FER_TOOLONG               ,   "FER_TOOLONG"           } ,
    { FER_FAXNOW                ,   "FER_FAXNOW"            } ,
    { FER_FILE                  ,   "FER_FILE"              } ,
    { FER_BADPARAM              ,   "FER_BADPARAM"          } ,
    { FER_BADFAX                ,   "FER_BADFAX"            } ,
    { FER_SYSTEM                ,   "FER_SYSTEM"            } ,
    { FER_RONGFORMAT            ,   "FER_RONGFORMAT"        } ,
    { FER_NOQUEUE               ,   "FER_NOQUEUE"           } ,
    { FER_ENCODE                ,   "FER_ENCODE"            } ,
    { FER_NOTIMPLEMENTED        ,   "FER_NOTIMPLEMENTED"    } ,
    { FER_BFTDECODE             ,   "FER_BFTDECODE"         } ,
    { FER_PORTDISABLE           ,   "FER_PORTDISABLE"       } ,
    { FER_PORTSYNC              ,   "FER_PORTSYNC"          } ,

    { FER_SYS_REGCLASS          ,   "FER_SYS_REGCLASS"      } ,
    { FER_SYS_CREATEWND         ,   "FER_SYS_CREATEWND"     } ,
    { FER_LOADIMG               ,   "FER_LOADIMG"           } ,
    { FER_SCALEIMG              ,   "FER_SCALEIMG"          } ,
    { FER_ENCOD_CCITT           ,   "FER_ENCOD_CCITT"       } ,
    { FER_DECOD_CCITT           ,   "FER_DECOD_CCITT"       } ,
    { FER_LOADMODULE            ,   "FER_LOADMODULE"        } ,
    { FER_CONNECT               ,   "FER_CONNECT"           } ,
    { FER_CREATEFAXOBJ          ,   "FER_CREATEFAXOBJ"      } ,

    { FER_BAD_PAGENUM           ,   "FER_BAD_PAGENUM"       } ,
    { FER_BAD_PAGEFNAME         ,   "FER_BAD_PAGEFNAME"     } ,
    { FER_BAD_BFTDATA           ,   "FER_BAD_BFTDATA"       } ,
    { FER_BAD_BFTDATAID         ,   "FER_BAD_BFTDATAID"     } ,
    { FER_BAD_BFTSIZE           ,   "FER_BAD_BFTSIZE"       } ,
    { FER_BAD_IMGTYPE           ,   "FER_BAD_IMGTYPE"       } ,
    { FER_BAD_IMGFILE           ,   "FER_BAD_IMGFILE"       } ,
    { FER_BAD_IMGMEM            ,   "FER_BAD_IMGMEM"        } ,
    { FER_BAD_FAXPORT           ,   "FER_BAD_FAXPORT"       } ,
    { FER_BAD_MODEMTEST         ,   "FER_BAD_MODEMTEST"     } ,

    { FER_FILE_OPEN             ,   "FER_FILE_OPEN"         } ,
    { FER_FILE_COPY             ,   "FER_FILE_COPY"         } ,
    { FER_FILE_WRITE            ,   "FER_FILE_WRITE"        } ,
    { FER_FILE_READ             ,   "FER_FILE_READ"         } ,
    { FER_FILE_NOEXIST          ,   "FER_FILE_NOEXIST"      } ,

    { 0                         ,   NULL      }
};
/////////////////////////////////////////////////////////////////////////////
// CDlgSendFax dialog


CDlgSendFax::CDlgSendFax(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgSendFax::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDlgSendFax)
	m_phonenum = _T("");
	//}}AFX_DATA_INIT
}


void CDlgSendFax::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDlgSendFax)
	DDX_Text(pDX, IDC_FAXNUMBER, m_phonenum);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDlgSendFax, CDialog)
	//{{AFX_MSG_MAP(CDlgSendFax)
	ON_BN_CLICKED(IDC_BROWSE, OnBrowse)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgSendFax message handlers

static  void LoadFaxNames(CDialog  *cDlg, BOOL bClose)
{
    CQueueFaxSampleApp     *pApp = (CQueueFaxSampleApp *)AfxGetApp();
    CListBox    *pPortBox = (CListBox *)cDlg->GetDlgItem(IDC_LIST1);
    int         nWidth = 0;

    for ( int i = 0; i < MAX_FAXPORTS; i++) {
        if(pApp->FaxPorts[i])
        {
            if (pApp->FaxPorts[i]->IsOpen() || bClose)
            {
                TSSessionParameters CSession ;
                GetSessionParameters(pApp->FaxPorts[i],&CSession) ;
                CString cFax = CSession.PortName;
                cFax += ':' ;
                                cFax += CSession.ModemName;
                cFax +=  '.';
                cFax += CSession.FaxType;

                pPortBox->SetItemData(pPortBox->AddString(cFax), (DWORD)(i));
                if(cFax.GetLength() > nWidth)
                {
                    nWidth = cFax.GetLength();
                }
            }
        }
    }
    pPortBox->SetHorizontalExtent(8*nWidth);
    pPortBox->SetCurSel(0);
}

static  int GetPortNumber(CDialog *cDlg)
{
    int         iPort   = -1;
    CListBox    *pPortList = (CListBox *)cDlg->GetDlgItem(IDC_LIST1);

    iPort = pPortList->GetCurSel();
    if(iPort >= 0)
        iPort = (int)pPortList->GetItemData(iPort);
    else
        iPort = -1;
    return iPort;
}


LPSTR MakeFERText(int code)
{
    if(code == 0)
        return "No Error";

    TFERTable *cb;
    for ( int jj=0; jj<500; jj++ ) {
        cb = &errortab[jj];
        if ( cb->code==0 || cb->txt==NULL ) {
            break;
        }
        if ( cb->code==code ) {
            return cb->txt;
        }
    }
    return " ";
}

BOOL CDlgSendFax::OnInitDialog() 
{
	
	pagesToSend=0;
    CQueueFaxSampleApp *pApp = (CQueueFaxSampleApp *)AfxGetApp();

    CDialog::OnInitDialog();


#ifndef WIN32
    if(!pApp->FaxPorts[0] && !pApp->FaxPorts[1] && !pApp->FaxPorts[2] && !pApp->FaxPorts[3]) {
        AfxMessageBox("No port exist for sending");
        EndDialog(FALSE);
        return  FALSE;
    }
#endif
    ::LoadFaxNames(this, FALSE);


    CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
    if ( lst1 ) {
        int nn = lst1->GetCount();
        if ( nn > 0 ) {
            lst1->SetCurSel(0);
        }
    }
    
    ((CEdit *)GetDlgItem(IDC_FAXNUMBER))->LimitText(32);
    ((CEdit *)GetDlgItem(IDC_FILENAME))->LimitText(255);
	SetDlgItemText(IDC_FILENAME,pApp->fileName);

	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}


void CDlgSendFax::OnOK() 
{
	CString fileToSend;
	CString phoneNum;
	GetDlgItemText(IDC_FAXNUMBER,phoneNum);

	int ii = strspn(phoneNum, "0123456789,");
		int ln = lstrlen(phoneNum);
		BOOL bOK = (ii>=ln && ln) ? TRUE : FALSE;
		if (phoneNum.GetLength()==0){
			AfxMessageBox("You must specify the phone number.",MB_OK);
			((CEdit *)GetDlgItem(IDC_FAXNUMBER))->SetFocus();
			return;}
		else if (!bOK){
			AfxMessageBox("The given phone number is incorrect.",MB_OK);
			((CEdit *)GetDlgItem(IDC_FAXNUMBER))->SetSel(0,-1);
			((CEdit *)GetDlgItem(IDC_FAXNUMBER))->SetFocus();
			return;}

	GetDlgItemText(IDC_FILENAME,fileToSend);
	if (_access(fileToSend,0)==-1){
			AfxMessageBox("You must specify an existing file to send.",MB_OK);
			return;
		}

	CQueueFaxSampleApp     *pApp = (CQueueFaxSampleApp *)AfxGetApp();
	pApp->fileName=fileToSend;
    int         nBaud = pApp->GetProfileInt("Fax", "MAXBAUD", 4),
                nEcm = pApp->GetProfileInt("Fax", "Enable ECM Send", ECM_ENABLE ),
                nBft = pApp->GetProfileInt("Fax", "Enable BFT", BFT_DISABLE );
    int         pagefrom = 0, pageto = 0, pagenum = 10, bNext = 0,
                LastType = 0, nType = 0;

    iPort = ::GetPortNumber(this);
    if ( iPort < 0  ||  iPort >=MAX_FAXPORTS )
        return;
    
    m_faxport = pApp->FaxPorts[iPort];
    if ( !m_faxport)
        return;

        nBaud = BDR_14400;
    SetPortCapabilities( m_faxport, FDC_BAUD_SEND, nBaud );
    SetPortCapabilities( m_faxport, FDC_ECM, nEcm );
    SetPortCapabilities( m_faxport, FDC_BINARY,  nBft );

	int actPage;
	char* file=fileToSend.GetBuffer(0);
	int NumberOfPages;
	fileToSend.MakeLower();
	if (fileToSend.Find(".tif")!=-1)
		NumberOfPages=GetNumberOfImagesInTiffFile(file);
	else 
	{
		AfxMessageBox("You must specify a TIFF file!",MB_OK);
		((CEdit *)GetDlgItem(IDC_FILENAME))->SetSel(0,-1);
		((CEdit *)GetDlgItem(IDC_FILENAME))->SetFocus();
		return;
	}
	for(int i=0;i<10;i++)
	{
		srand( (unsigned)time( NULL ) );
		if (i==0)
			actPage=NumberOfPages;
		else
			while((actPage=rand())<=0 || actPage>NumberOfPages);
		actPage--;
	TSFaxParam  sFaxParam;
    FAXOBJ      faxobj ;
    
    sFaxParam.PageNum     = 1;


    sFaxParam.Width       = PWD_1728;
    sFaxParam.Length      = PLN_A4;
    sFaxParam.Compress    = DCF_1DMH;
    sFaxParam.Binary      = BFT_NOCHANGE;
    sFaxParam.BitOrder    = BTO_FIRST_LSB;
    sFaxParam.Resolut     = RES_NOCHANGE;
	sFaxParam.BitOrder = BTO_FIRST_LSB;
    sFaxParam.Send = TRUE;
    sFaxParam.DeleteFiles = TRUE ;
	sFaxParam.Ecm = ECM_NOCHANGE;
	


    GetDlgItemText( IDC_FAXNUMBER, &sFaxParam.RemoteNumber[0], sizeof(sFaxParam.RemoteNumber));
	sFaxParam.Priority = actPage;
     
    faxobj = CreateSendFax('N', &sFaxParam);
    
    if ( !faxobj ) {
        AfxMessageBox("CreateSendFax failed");
        pApp->FaxEventText(iPort, "CreateSendFax failed");
        return;
    }


    char buf[300];
    LPSTR lpFileName = NULL;
    CString strFileName;

    union TUFaxImage   sFaxPage;
    int iError = 0;
    BOOL bOk = TRUE;

    pApp->FaxEventText(iPort, "---");



	strFileName = fileToSend;

    lpFileName = strFileName.GetBuffer( strFileName.GetLength() );
	sFaxPage.File=lpFileName;

       
   if ( lpFileName==NULL)
        lpFileName = "???";
 
    wsprintf(buf, "Setup page-%i for sending  (%s)", actPage+1, lpFileName);
    pApp->FaxEventText(iPort, buf);

    iError = SetFaxImagePage(faxobj, 0, IMT_FILE_TIFF_G31D, &sFaxPage,  actPage);

	if ( iError < 0 ) {
            wsprintf(buf, "SetFaxImagePage has failt, page:%i, error:%i %s",
                                                        actPage+1, iError, MakeFERText(iError) );
            pApp->FaxEventText(iPort, buf);
            bOk = FALSE;
            return;
    }

    if ( iError > 0 ) {
            wsprintf(buf, "SetFaxImagePage return code, page:%i, error:%i %s",
                                                         actPage+1, iError, MakeFERText(iError) );
            pApp->FaxEventText(iPort, buf);
   }
	iError=PutFaxOnQueue(faxobj);
	if (iError==0) pApp->FaxEventText(iPort, "Fax has been sent to queue");
	else
	{
	sprintf(buf, "Send Fax error:%i %s", iError, MakeFERText(iError));
        AfxMessageBox(buf);
        pApp->FaxEventText(iPort, buf);
		return;
    }
        CDialog::OnOK();  
	}
}




void CDlgSendFax::OnBrowse() 
{
	CFileDialog dlg(TRUE, _T("BMP"), NULL, OFN_FILEMUSTEXIST | OFN_HIDEREADONLY,
              _T("TIFF File Format|*.tif"));

    if ( dlg.DoModal() == IDOK ) {
        SetDlgItemText( IDC_FILENAME, dlg.GetPathName() );
    }	
}
