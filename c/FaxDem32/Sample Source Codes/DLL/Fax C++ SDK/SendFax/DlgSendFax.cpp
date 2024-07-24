// DlgSendFax.cpp : implementation file
//

#include "stdafx.h"
#include "SendFax.h"
#include "DlgSendFax.h"
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
// CDlgSendFax dialog


CDlgSendFax::CDlgSendFax(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgSendFax::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDlgSendFax)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void CDlgSendFax::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDlgSendFax)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDlgSendFax, CDialog)
	//{{AFX_MSG_MAP(CDlgSendFax)
	ON_BN_CLICKED(IDC_BROWSE, OnBrowse)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgSendFax message handlers

BOOL CDlgSendFax::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	CSendFaxApp *pApp = (CSendFaxApp *)AfxGetApp();
	int i;
    BOOL bOpen = FALSE ;
    for(i=0;i<MAX_COMPORTS;i++)
    {
        if (pApp->FaxPorts[i])
        {
                bOpen = TRUE ;
                break ;
        }
    }

    if(!bOpen) {
        AfxMessageBox("There is no port open!");
        EndDialog(FALSE);
        return  FALSE;
    }
    CListBox    *pPortBox = (CListBox *)GetDlgItem(IDC_PORTS);
	for (i = 0; i < MAX_COMPORTS; i++) {
        if(pApp->FaxPorts[i])
        {
                TSSessionParameters CSession ;
                GetSessionParameters(pApp->FaxPorts[i],&CSession) ;
                CString cFax = CSession.PortName;
                cFax += ':' ;
                                cFax += CSession.ModemName;
                cFax +=  '.';
                cFax += CSession.FaxType;
                pPortBox->SetItemData(pPortBox->AddString(cFax), (DWORD)(i));
            
        }
    }
    pPortBox->SetCurSel(0);
	((CEdit *)GetDlgItem(IDC_FAXNUMBER))->LimitText(32);
    ((CEdit *)GetDlgItem(IDC_FILENAME))->LimitText(255);
	SetDlgItemText(IDC_FILENAME,pApp->fileName);
    CheckRadioButton(IDC_SENDQUEUE, IDC_SENDIMMEDIATE, IDC_SENDQUEUE);
	((CEdit *)GetDlgItem(IDC_FAXNUMBER))->SetFocus();
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CDlgSendFax::OnBrowse() 
{
	CFileDialog dlg(TRUE, _T("TIFF"), NULL, OFN_FILEMUSTEXIST | OFN_HIDEREADONLY,
              _T("TIFF File Format|*.tif"));

    if ( dlg.DoModal() == IDOK ) {
        SetDlgItemText( IDC_FILENAME, dlg.GetPathName() );
    }		
}

void CDlgSendFax::OnOK() 
{
	CString fileToSend;
	CString phoneNum;
	int NumberOfPages;
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
			((CEdit *)GetDlgItem(IDC_FILENAME))->SetSel(0,-1);
			((CEdit *)GetDlgItem(IDC_FILENAME))->SetFocus();
			return;
		}	
	char* file=fileToSend.GetBuffer(0);
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
	/**************************Start fax sending procedure************************************/

	/*
	If the fax port is created, the port is ready for sending faxes through the assigned communication port.
	In order to send a fax, we have to create a fax object performing the CreateSendFax function. 
	The first parameter of this function gives the type of the fax transmission protocol.
	The second parameter specifies the description of fax properties in a structure.
	The properties determine the dimensions of fax pages, the bit order of the transmission and the type of compression of fax pages. 
	If the fax object is created successfully, the fax pages can be filled with the SetFaxImagePage function.
	The image page can be specified either with a memory handle or name of a file.
	The image in the memory can be a device dependent or independent bitmap or a handle to raw data.
	In the end; we can send the fax immediately or we can put the fax in a sending queue waiting to get the communication line free for sending it.
	Sending the fax immediately will cause the transmission currently in progress to be interrupted.
	*/

	/*************************** Filling TSFaxParam Structure*******************************/

	/*TSFaxParam structures store information about a fax.*/
	TSFaxParam  sFaxParam;
    FAXOBJ      faxobj ;
    
    sFaxParam.PageNum     = NumberOfPages; //Specifies the number of pages in a fax.


    sFaxParam.Width       = PWD_1728; //Convert pages to 1728 pixel wide images.
	/*sFaxParam.Width can have the following values:
		PWD_NOCHANGE  Use default value
		PWD_864       Convert pages to 864 pixel wide images.
		PWD_1216      Convert pages to 1216 pixel wide images.
		PWD_1728      Convert pages to 1728 pixel wide images.
		PWD_2048      Convert pages to 2048 pixel wide images.
		PWD_2432      Convert pages to 2423 pixel wide images.
	*/
    sFaxParam.Length      = PLN_A4;
	/*sFaxParam.Length can have the following values:
		PLN_NOCHANGE   Use default value (PLN_UNLIMITED).
		PLN_A4         Convert pages to a A4 length images.
        PLN_B4         Convert pages to a B4 length images.
        PLN_UNLIMITED  The length of the page is unlimited.
	*/
    sFaxParam.Compress    = DCF_1DMH;
	/*sFaxParam.Compress can have the following values:
		DCF_NOCHANGE		Use default value
        DCF_1DMH			Use 1 dimensional CCITT Group 3 compression.
        DCF_2DMR			Use 2 dimensional CCITT Group 3 compression.
        DCF_UNCOMPRESSED	Use no compression.
        DCF_2DMMR			Use 2 dimensional MMR compression.
	*/
    sFaxParam.Binary      = BFT_NOCHANGE;
	/*sFaxParam.Binary can have the following values:
		BFT_NOCHANGE    Use default value
        BFT_DISABLE     Disable Class 1 binary file transmission.
        BFT_ENABLE      Enable Class 1 binary file transmission.
	*/
    sFaxParam.BitOrder    = BTO_FIRST_LSB;
	/*sFaxParam.BitOrder can have the following values:
		BTO_FIRST_LSB     The least significant bit will be sent first.
        BTO_LAST_LSB      The least significant bit will be sent last.
        BTO_BOTH          The device supports both types of transmission.
	*/
    sFaxParam.Resolut     = RES_NOCHANGE;
	/*sFaxParam.Resolut can have the following values:
		RES_NOCHANGE   Use default value
        RES_98LPI      Convert pages to low resolution images (98 line/inch).
        RES_196LPI     Convert pages to a fine resolution images (196 line/inch).
	*/
    sFaxParam.Send = TRUE;//Direction of the data transmission (TRUE = send, FALSE = receive).
    sFaxParam.DeleteFiles = TRUE ;
	//Set the DeleteFile flag to TRUE to delete the temporary file if it is not used. 
	//Set the flag to FALSE to keep it.
	sFaxParam.Ecm = ECM_NOCHANGE;
	/*sFaxParam.Ecm can have the following values:
		ECM_NOCHANGE  Use default value
		ECM_DISABLE   Disable Error correction mode (ECM).
		ECM_ENABLE    Enable Error correction mode (ECM).
	*/

    GetDlgItemText( IDC_FAXNUMBER, &sFaxParam.RemoteNumber[0], sizeof(sFaxParam.RemoteNumber));
	//sFaxParam.RemoteNumber holds the destination phone number.

	//If you would like to put the fax on queue you can set the priority of your fax.
	//Higher priority faxes will be sent earlier than lower priority faxes.
	//sFaxParam.Priority = 10;

	/*******************************Creating a fax object**********************************/

	/*This function creates and returns a FAX object new TCNormalFax(TRUE) with the parameters 
	set in the TSFaxParam. The FaxType variable contains the type of the fax. 
	The driver will handle the normal faxes in this release.
	1. parameter: Type of  fax. 
		The type of the normal fax is ‘N’ (it is defined as REGTYPE_NORMALFAX ). 
		The type of Binary File Transfer is ‘B’ (it is defined as REGTYPE_BINARYFILE).
		The ‘C’ is reserved for the Color FAX type. 
		The ‘B’ is reserved for Binary File transfer.
		The ‘M’ is reserved for multi-media applications. 
	2. parameter: Pointer to a fax parameter structure.
 
	Please Note: it is very important to set the page number parameter in sFaxParam.

	The function returns a FAX object on success or NULL if creating fax object failed.
	*/

    faxobj = CreateSendFax('N', &sFaxParam);
	if ( !faxobj ) {
        AfxMessageBox("CreateSendFax failed");
        return;
    }
	/*
	TUFaxImage union stores information about a page of a fax. The members of the structure are:
	HBITMAP				Bitmap    A handle to device-dependent bitmap where the fax page is stored.
	HGLOBAL				Memory    The image of the page is stored in a memory block as a raw image.
	HGLOBAL				Dib       A handle to device-independent bitmap where the fax page is stored.
	LPSTR				File      The image of the page is stored in a file.
	PTCBinaryParam      BftObj    The page is a BFT object.
	*/
    union TUFaxImage   sFaxPage;
    int iError = 0;
    char buf[50];

	sFaxPage.File=fileToSend;
	//for example: "Test.tif". You have to specify the full path if the file is not in the 
	//directory of the application
	
	for (int i=0;i<NumberOfPages;i++)
	{
	/********************************Set pages for the fax*********************************/

	/*This function sets the new page of the given fax by calling the TCNormalFax::SetImagePage function. 
	1. parameter: Fax port object.
	2. parameter: The 0 based n-th page number in the fax object.
	3. Parameter: Specifies the type of  image.

	The types of the image pages can be:
	IMT_MEM_DIRECT          Memory handle to a raw data  
                            The  Data type depends on FaxObject type   
                            CCITT encoded  - on Normal Fax. 
                            BFT encoded  - on   Bft Fax 
                            The driver does not  validate  data
                            In ECM mode enable to send Custom Data to remote fax station 

	IMT_MEM_BITMAP          Memory handle to a device dependent bitmap.
	IMT_MEM_DIB             Memory handle to a device independent bitmap.
	IMT_FILE_DIRECT         Raw data  in  file. 
                            The  Data type depends on FaxObject type
                            CCITT encoded  - on Normal Fax.
                            BFT encoded  - on   Bft Fax 
                            The driver not  validate  data
                            In ECM mode, enable to send Custom Data to remote fax station  
	IMT_FILE_BMP            The image is given as a Windows bitmap file.
	IMT_FILE_PCX            The image is given as a PCX file (requires BIPCX.DLL, licensed separately)
	IMT_FILE_DCX            The image is given as a DCX file.
	IMT_FILE_TIFF_NOCOMP    The image is given as an uncompressed TIFF file.
	IMT_FILE_TIFF_PACKBITS  The image is given as a TIFF file with pack bits compression.
	IMT_FILE_TIFF_LZW       The image is given as a TIFF file with LZW compression.
	IMT_FILE_TIFF_LZDIFF    The image is given as a TIFF file with differential LZW compression.
	IMT_FILE_TIFF_G31DNOEOL The image is given as a TIFF file with Group 3 one dimensional NoEol compression..
	IMT_FILE_TIFF_G31D      The image is given as a TIFF file with Group 2 one dimensional.
	IMT_FILE_TIFF_G32D      The image is given as a TIFF file with Group 3 two dimensional compression..
	IMT_FILE_TIFF_G4        The image is given as a TIFF file with G4 compression.
	IMT_FILE_TGA            The image is given as a TGA file (requires BIPCX.DLL, licensed separately)
	IMT_FILE_JPEG           The image is given as a JPEG file    
	IMT_BFTOBJ              The page is a BFT page. The PageImage -> BftObj member must point to a valid TCBinaryParam object.

	4. parameter: Pointer to an image structure.
	5. parameter: Specifies which image should be used in a multi-image file(also 0 based).
 	*/

		iError = SetFaxImagePage(faxobj, i, IMT_FILE_TIFF_G31D, &sFaxPage,  i);
		if ( iError!=0 )
		{
            wsprintf(buf, "SetFaxImagePage has failt, page:%i, error:%i %s",i, iError);
			AfxMessageBox(buf);
            return;
		}
    }
		
	int SendMode=GetCheckedRadioButton(IDC_SENDQUEUE,IDC_SENDIMMEDIATE);
	if (SendMode==IDC_SENDQUEUE){
	/*****************************Adding the fax to the send queue**************************/
	
	/*
	This function puts the specified fax in the send queue. 
	The specified fax will be automatically sent by the FAX C++ Manager on the first available port 
	once all of the higher priority faxes in front of the specified fax have been sent.
	parameter: fax object.
	Returns zero on success, otherwise returns an error code.
	*/
		iError=PutFaxOnQueue(faxobj);
		if (iError!=0){
	/*This function deletes the specified fax from the fax queue.
	parameter: fax object
	*/
			ClearFaxObj(faxobj);
			sprintf(buf,"Can't send fax! Error code: %d",iError);
			AfxMessageBox(buf);
		}
	}
	else
	{
		CSendFaxApp* pApp = (CSendFaxApp*) AfxGetApp();
		CListBox    *pPortList = (CListBox *) GetDlgItem(IDC_PORTS);
		int iPort;
		if (pPortList->GetCurSel()>=0)
		{
			iPort = (int)pPortList->GetItemData(pPortList->GetCurSel());
	/****************************Sending the fax immediately*********************************/

	/*
	This function immediately sends the fax through the specified port.
	An error code will be returned if the port is active (currently sending or receiving any faxes) or if the port doesn’t exist.
	1. parameter: Fax Port (PORTFAX type). The fax will be sent to the specified port.
	2. parameter: Fax object to be sent.
	3. parameter: Not currently used. Reserved for future use.
	Returns zero on success, otherwise returns an error code.
	*/
            iError=SendFaxNow( pApp->FaxPorts[iPort], faxobj, FALSE);
			if (iError!=0){
				ClearFaxObj(faxobj);
				sprintf(buf,"Can't send fax! Error code: %d",iError);
				AfxMessageBox(buf);
			}

		}
	}

    	

	CDialog::OnOK();
}

