// dlgSendFax.cpp : implementation file
//

#include "stdafx.h"
#include "FaxWithBrooktrout.h"
#include "dlgSendFax.h"
#include "io.h"
extern "C"
{
#include "bitiff.h"
}

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// dlgSendFax dialog


dlgSendFax::dlgSendFax(CWnd* pParent /*=NULL*/)
	: CDialog(dlgSendFax::IDD, pParent)
{
	//{{AFX_DATA_INIT(dlgSendFax)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void dlgSendFax::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(dlgSendFax)
	DDX_Control(pDX, IDC_CHANNELLIST, m_channellist);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(dlgSendFax, CDialog)
	//{{AFX_MSG_MAP(dlgSendFax)
	ON_BN_CLICKED(IDC_BROWSE, OnBrowse)
	ON_BN_CLICKED(IDC_CONFIRMNUMBER, OnConfirmnumber)
	ON_BN_CLICKED(IDC_CONFIRMFILE, OnConfirmfile)
	ON_BN_CLICKED(IDC_RECEIVE, OnReceive)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// dlgSendFax message handlers

BOOL dlgSendFax::OnInitDialog() 
{
	CDialog::OnInitDialog();
	CFaxWithBrooktroutApp *pApp = (CFaxWithBrooktroutApp *)AfxGetApp();
	int i,iItem;
    BOOL bOpen = FALSE ;
    for(i=0;i<MAX_FAXCHANNELS;i++)
    {
        if (pApp->FaxPorts[i])
        {
                bOpen = TRUE ;
                break ;
        }
    }

    if(!bOpen) {
        AfxMessageBox("There is no channel open!");
        EndDialog(FALSE);
        return  FALSE;
    }

	LV_COLUMN lvColumn;
	
	lvColumn.mask   = LVCF_FMT | LVCF_WIDTH | LVCF_TEXT | LVCF_SUBITEM;
    lvColumn.fmt    = LVCFMT_LEFT;
    lvColumn.pszText = "Brooktrout Channels";

    lvColumn.iSubItem = 0;
    lvColumn.cx     = 120;
    m_channellist.InsertColumn( 0, &lvColumn );		

	lvColumn.pszText = "Fax Number";
    lvColumn.iSubItem = 1;
    lvColumn.cx     = 70;
    m_channellist.InsertColumn( 1, &lvColumn );		

	lvColumn.pszText = "File To Send";
    lvColumn.iSubItem = 2;
    lvColumn.cx     = 213;
    m_channellist.InsertColumn( 2, &lvColumn );	

	ListView_SetExtendedListViewStyle(m_channellist.m_hWnd, LVS_EX_FULLROWSELECT);

	for (i = 0; i < MAX_FAXCHANNELS; i++) {
        if(pApp->FaxPorts[i])
        {
                TSSessionParameters CSession ;
                GetSessionParameters(pApp->FaxPorts[i],&CSession) ;
                CString cFax = CSession.PortName;
				iItem = m_channellist.GetItemCount();
				m_channellist.SetItemData(m_channellist.InsertItem(iItem,cFax),i);
        }
    }
	m_channellist.SetFocus();
	int topitem=m_channellist.GetTopIndex();
    m_channellist.SetItemState(topitem,LVIS_SELECTED,LVIS_SELECTED);
	((CEdit *)GetDlgItem(IDC_FAXNUMBER))->LimitText(1);
    ((CEdit *)GetDlgItem(IDC_FILENAME))->LimitText(255);
	HMODULE hModule;
	hModule=GetModuleHandle("Faxcpp32.dll");
	char		szFilename [MAX_PATH];
	GetModuleFileName( hModule,   szFilename, MAX_PATH );
	char* pStr = strrchr(szFilename, '\\');
	if (pStr)
			strcpy(pStr, "\\BrookInfo.ini");
	int ChannelNum=GetPrivateProfileInt("ChannelNum","ChannelNr",0,szFilename);
	char fileToSend[256];
	GetPrivateProfileString("Send File", "FileToSend", "", fileToSend, sizeof(fileToSend),szFilename);
	char phoneNum[20];
	char szTemp[20];

	
	for(i=0;i<ChannelNum;i++)
	{
		sprintf(szTemp, "Fax%d", i+1);
		GetPrivateProfileString("FaxNumbers", szTemp, "", phoneNum, 20, szFilename);

		m_channellist.SetItemText(i,1,phoneNum);
		m_channellist.SetItemText(i,2,fileToSend);
	}

	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void dlgSendFax::OnBrowse() 
{
	CFileDialog dlg(TRUE, _T("TIFF"), NULL, OFN_FILEMUSTEXIST | OFN_HIDEREADONLY,
              _T("TIFF File Format|*.tif"));

    if ( dlg.DoModal() == IDOK ) {
        SetDlgItemText( IDC_FILENAME, dlg.GetPathName() );
    }			
}

void dlgSendFax::OnConfirmnumber() 
{
	CString phoneNum;
	int selected=m_channellist.GetNextItem(-1,LVIS_SELECTED);
	GetDlgItemText(IDC_FAXNUMBER,phoneNum);
	m_channellist.SetItemText(selected,1,phoneNum);
}

void dlgSendFax::OnConfirmfile() 
{
	CString file;
	int selected=m_channellist.GetNextItem(-1,LVIS_SELECTED);
	GetDlgItemText(IDC_FILENAME,file);
	m_channellist.SetItemText(selected,2,file);
}

void dlgSendFax::OnOK() 
{
	CString channel,faxNumber,file;
	int numberOfPages,iPort,iError;
	TSFaxParam  sFaxParam;
	char buf[70];
    FAXOBJ      faxobj ;
	union TUFaxImage   sFaxPage;

	EnableDebug( DBG_ALL );
	CFaxWithBrooktroutApp* pApp = (CFaxWithBrooktroutApp*) AfxGetApp();
	if (pApp->list) pApp->DeleteList();
	int i;
	for (i=0;i<m_channellist.GetItemCount();i++)
	{
		channel=m_channellist.GetItemText(i,0);
		faxNumber=m_channellist.GetItemText(i,1);
		file=m_channellist.GetItemText(i,2);
		if (faxNumber=="")
		{
			sprintf(buf,"You must specify the fax number for %s",channel);
			AfxMessageBox(buf);
			return;
		}
		if (_access(file,0)==-1)
		{
			sprintf(buf,"You must specify and existing file to send for %s",channel);
			AfxMessageBox(buf);
			return;
		}
		file.MakeLower();
		if (file.Find(".tif")==-1)
		{
			sprintf(buf,"You must specify a TIFF file for %s",channel);
			AfxMessageBox(buf);
			return;
		}
	}

	for (i=0;i<m_channellist.GetItemCount();i++)
	{
		channel=m_channellist.GetItemText(i,0);
		faxNumber=m_channellist.GetItemText(i,1);
		file=m_channellist.GetItemText(i,2);
		file.MakeLower();
		memset(&sFaxParam, 0, sizeof(TSFaxParam));

		numberOfPages=GetNumberOfImagesInTiffFile(file.GetBuffer(0));
		sFaxParam.PageNum     = numberOfPages; 
		sFaxParam.Width       = PWD_1728; //Convert pages to 1728 pixel wide images.
		sFaxParam.Length      = PLN_A4;
		sFaxParam.Compress    = DCF_1DMH;
		sFaxParam.Binary      = BFT_NOCHANGE;
		sFaxParam.BitOrder    = BTO_FIRST_LSB;
		sFaxParam.Resolut     = RES_NOCHANGE;
		sFaxParam.Send = TRUE;//Direction of the data transmission (TRUE = send, FALSE = receive).
		sFaxParam.DeleteFiles = TRUE ;
		sFaxParam.Ecm = ECM_NOCHANGE;
		strcpy(sFaxParam.RemoteNumber,faxNumber.GetBuffer(0));
		faxobj = CreateSendFax('N', &sFaxParam);
		if ( !faxobj ) {
			sprintf(buf,"CreateSendFax failed for %s",channel);
			pApp->FaxEventText(buf);
			return;
		}
		sFaxPage.File=file;
		for (int j=0;j<numberOfPages;j++)
		{
			iError=SetFaxImagePage(faxobj, j, IMT_FILE_TIFF_G31D, &sFaxPage,  j);
			if (iError!=0)
			{
				sprintf(buf, "SetFaxImagePage has failt, page:%i, error:%i, channel: %s",j, iError,channel);
				pApp->FaxEventText(buf);
				return;
			}
		}
		iPort=(int) m_channellist.GetItemData(i);
		iError=SendFaxNow(pApp->FaxPorts[iPort],faxobj,FALSE);
		if (iError!=0)
		{
			ClearFaxObj(faxobj);
			sprintf(buf,"Can't send fax for channel %s! Error code: %d",channel,iError);
			pApp->FaxEventText(buf);
			return;
		}
		pApp->AddToList(pApp->FaxPorts[iPort],channel,faxobj,1, true);
	}
	CDialog::OnOK();
}

void dlgSendFax::OnReceive() 
{
	CString channel,faxNumber,file;
	int numberOfPages,iPort,iError;
	TSFaxParam  sFaxParam;
    FAXOBJ      faxobj ;
	char buf[70];
	union TUFaxImage   sFaxPage;

	EnableDebug( DBG_ALL );
	CFaxWithBrooktroutApp* pApp = (CFaxWithBrooktroutApp*) AfxGetApp();
	if (pApp->list) pApp->DeleteList();
	int i;
	for (i=0;i<m_channellist.GetItemCount();i++)
	{
		channel=m_channellist.GetItemText(i,0);
		faxNumber=m_channellist.GetItemText(i,1);
		file=m_channellist.GetItemText(i,2);
		if (faxNumber=="")
		{
			sprintf(buf,"You must specify the fax number for %s",channel);
			AfxMessageBox(buf);
			return;
		}
		if (_access(file,0)==-1)
		{
			sprintf(buf,"You must specify and existing file to send for %s",channel);
			AfxMessageBox(buf);
			return;
		}
		file.MakeLower();
		if (file.Find(".tif")==-1)
		{
			sprintf(buf,"You must specify a TIFF file for %s",channel);
			AfxMessageBox(buf);
			return;
		}
	}
	for (i=0;i<m_channellist.GetItemCount();i++)
	{
		channel=m_channellist.GetItemText(i,0);
		faxNumber=m_channellist.GetItemText(i,1);
		file=m_channellist.GetItemText(i,2);
		file.MakeLower();
		numberOfPages=GetNumberOfImagesInTiffFile(file.GetBuffer(0));
		memset(&sFaxParam, 0, sizeof(TSFaxParam));
		sFaxParam.PageNum     = numberOfPages; 
		sFaxParam.Width       = PWD_1728; //Convert pages to 1728 pixel wide images.
		sFaxParam.Length      = PLN_A4;
		sFaxParam.Compress    = DCF_1DMH;
		sFaxParam.Binary      = BFT_NOCHANGE;
		sFaxParam.BitOrder    = BTO_FIRST_LSB;
		sFaxParam.Resolut     = RES_NOCHANGE;
		sFaxParam.Send = TRUE;//Direction of the data transmission (TRUE = send, FALSE = receive).
		sFaxParam.DeleteFiles = TRUE ;
		sFaxParam.Ecm = ECM_NOCHANGE;
		strcpy(sFaxParam.RemoteNumber,faxNumber.GetBuffer(0));
		faxobj = CreateSendFax('N', &sFaxParam);
		if ( !faxobj ) {
			sprintf(buf,"CreateSendFax failed for %s",channel);
			pApp->FaxEventText(buf);
			return;
		}
		sFaxPage.File=file;
		for (int j=0;j<numberOfPages;j++)
		{
			if (iError=SetFaxImagePage(faxobj, j, IMT_FILE_TIFF_G31D, &sFaxPage,  j)!=0)
			{
				sprintf(buf, "SetFaxImagePage has failt, page:%i, error:%i, channel: %s",i, iError,channel);
				pApp->FaxEventText(buf);
				return;
			}
		}
		iPort=(int) m_channellist.GetItemData(i);
		pApp->AddToList(pApp->FaxPorts[iPort],channel,faxobj,0, false);
		sprintf(buf,"%s: Waiting for a call...",channel);
		pApp->FaxEventText(buf);
	}
	CDialog::EndDialog(RECEIVEPUSHED);
}
