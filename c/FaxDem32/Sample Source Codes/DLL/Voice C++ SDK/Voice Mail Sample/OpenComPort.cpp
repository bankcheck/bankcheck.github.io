// OpenComPort.cpp : implementation file
//

#include "stdafx.h"
#include "Voice Mail Sample.h"
#include "OpenComPort.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// COpenComPort dialog


COpenComPort::COpenComPort(CWnd* pParent /*=NULL*/)
	: CDialog(COpenComPort::IDD, pParent)
{
	//{{AFX_DATA_INIT(COpenComPort)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT

    m_nProgressStatus = 0;
    m_bWaitCursor = FALSE;
    m_bTesting = TRUE;
    m_bAutoDetect = false;
    m_nActType = -1;
}


void COpenComPort::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(COpenComPort)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(COpenComPort, CDialog)
	//{{AFX_MSG_MAP(COpenComPort)
	ON_WM_SETCURSOR()
	ON_BN_CLICKED(IDC_TEST_MODEM, OnTestModem)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// COpenComPort message handlers

BOOL COpenComPort::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	// TODO: Add extra initialization here
char	szTemp[MAX_PATH];
HANDLE	hTemp;
int		nIndex;

	// Comm port
	for( int i = 1; i < MAX_PORTS; i++ )
	{
		sprintf( szTemp, "\\\\.\\COM%d", i);
		hTemp = CreateFile(szTemp, GENERIC_READ | GENERIC_WRITE,
							0,
							NULL,
							OPEN_EXISTING,
							FILE_FLAG_OVERLAPPED,
							NULL);
		if( hTemp != INVALID_HANDLE_VALUE )
		{
			CloseHandle( hTemp );

			nIndex = SendDlgItemMessage(IDC_COMM_PORT,CB_ADDSTRING,0,(LPARAM)&szTemp[4]);
			SendDlgItemMessage(IDC_COMM_PORT,CB_SETITEMDATA,nIndex,i);
		}
	}
	SendDlgItemMessage(IDC_COMM_PORT,CB_SETCURSEL,0,0L);
	SendDlgItemMessage(IDC_MODEM_TYPES,CB_SETCURSEL,0,0L);
	SendDlgItemMessage(IDC_FAXCLASS_TYPE,CB_SETCURSEL,0,0L);

	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void COpenComPort::OnOK() 
{
	m_bTesting=false;
	OnTestModem();
}

void COpenComPort::DestroyModemObject()
{
	if( theApp.GetOpenModem() )
	{
		theApp.GetOpenModem()->DestroyModemObject();
		theApp.SetOpenModem(NULL);
		m_nProgressStatus = 0;
	}
}

const char	*szVoiceCaps[] = {"Data","Class1","Class2","Voice","Voiceview"};
void COpenComPort::OnVoiceMsg(MODEMOBJ Modem,int event)
{
    try
    {
        if( event == MFX_MODEM_OK )
        {
		    if( m_nProgressStatus == 0 )
		    {
				m_nProgressStatus = 2;
                if( !Modem->TestVoiceCapabilities() )
			    {
				    throw 1;
			    }
		    }
		    else
		    {
		    TSVoiceTestResult	stTestResult;
		    char				szTemp[200];
		    bool				bStarted	= false;

			    Modem->GetTestResult(&stTestResult);

			    *szTemp	= 0;
			    SendDlgItemMessage(IDC_MANUFACTURE,WM_SETTEXT,0,(LPARAM)TEST_MANUFACT((&stTestResult)));
			    SendDlgItemMessage(IDC_MODEL,WM_SETTEXT,0,(LPARAM)TEST_MODEL((&stTestResult)) );

                if(m_nActType==7)
                    SendDlgItemMessage(IDC_MODEM_TYPES,CB_SETCURSEL,4,0);
                else if(m_nActType==6)
                    SendDlgItemMessage(IDC_MODEM_TYPES,CB_SETCURSEL,3);
                else if(m_nActType==8)
                    SendDlgItemMessage(IDC_MODEM_TYPES,CB_SETCURSEL,5);
                else
                    SendDlgItemMessage(IDC_MODEM_TYPES,CB_SETCURSEL,m_nActType+1,0);


			    for(int i = 0; i < 4; i++ )
			    {
				    if( TEST_MODES((&stTestResult))[i] )
				    {
					    if( bStarted )
					    {
						    strcat(szTemp,"/");
					    }
					    strcat(szTemp,szVoiceCaps[i]);
					    bStarted = TRUE;
				    }
			    }

			    EndWaitCursor();
			    m_bWaitCursor=FALSE;

			    MessageBeep( MB_OK );
			    EnableControls(true);
			    
			    SendDlgItemMessage(IDC_CAPABILITIES,WM_SETTEXT,0,(LPARAM)szTemp);
			    if(!m_bTesting)
                {
				int nRings	= theApp.GetProfileInt(g_szSection,g_szRings,1);

					Modem->WaitForRings(nRings);
				
					Modem->SetLogDir(g_szExePath);
					Modem->EnableLog(IsDlgButtonChecked(IDC_LOG));

				    m_bTesting=TRUE;
				    CDialog::OnOK();
			    }
                else
                {
                    throw 2;
                }
		    }
        }
	    else if( event == MFX_ERROR )
	    {
            throw 1;
        }
    }
    catch(int e)
    {
	    int		nError = Modem->GetLastError();

        //m_bTesting = TRUE;
		EndWaitCursor();
		m_bWaitCursor=false;

        if( e == 1 )
        {
      		DestroyModemObject();
    		EnableControls(true);
	    	m_bOpenPort=FALSE;

            if(m_bAutoDetect && m_nActType!=7) {
                switch(m_nActType){
                case 0:						
				case 6:						//0-Rockwell
                    ++m_nActType;			//1-USR
                    break;					//2-Dialogic
                case 1:						//3-Bicom
                    m_nActType=6;			//4-Brooktrout
					break;					//5-NMS
				case 8:						//6-Lucent
                    m_nActType=0;			//7-Cirrus Logic
					break;					//8-Conexant HCF
                }

                m_bWaitCursor = TRUE;

                EnableControls(FALSE);
	            BeginWaitCursor();
		        if( (Modem = mdm_CreateModemObject(m_nActType)) != NULL )
		        {
		            char	szTemp[MAX_PATH];
                    int		nIndex	= SendDlgItemMessage(IDC_COMM_PORT,CB_GETCURSEL,0,0L);
                    Modem->SetSilenceDetectionParams(MSD_LOW,8000);


                    theApp.SetOpenModem(Modem);

			        m_nProgressStatus = 0;
                    Modem->SetModemLong((LONG)this);
                    SendDlgItemMessage(IDC_COMM_PORT,CB_GETLBTEXT,nIndex,(LPARAM)szTemp);
                    Modem->OpenPort(szTemp);
		        }
		        
            }
            else 
		    {
			    AfxMessageBox("No modem found on selected port!");
		    }
        }
	}
}

BOOL COpenComPort::OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message) 
{
	// TODO: Add your message handler code here and/or call default
	if(m_bWaitCursor)
		return TRUE;
	else
		return CDialog::OnSetCursor(pWnd, nHitTest, message);
}

void COpenComPort::OnTestModem() 
{
int		nIndex	= SendDlgItemMessage(IDC_COMM_PORT,CB_GETCURSEL,0,0L);

	m_bWaitCursor = TRUE;

    EnableControls(FALSE);
	BeginWaitCursor();
	DestroyModemObject();
	
    if( nIndex != CB_ERR )
	{
    MODEMOBJ    Modem;
	int	        nModemType = SendDlgItemMessage(IDC_MODEM_TYPES,CB_GETCURSEL,0,0L);

        if(nModemType==0 ){
            m_bAutoDetect = true;
            m_nActType = 8;
            nModemType = 8;
        }
        else {
            --nModemType;
		    if(nModemType==2)
			    nModemType=6;
		    if(nModemType==3)
			    nModemType=7;
			if(nModemType==4)
			    nModemType=8;
			
        }
		if( (Modem = mdm_CreateModemObject(nModemType)) != NULL )
		{
		char	szTemp[MAX_PATH];

            theApp.SetOpenModem(Modem);

			m_nProgressStatus = 0;
            Modem->SetModemLong((LONG)this);


			SendDlgItemMessage(IDC_COMM_PORT,CB_GETLBTEXT,nIndex,(LPARAM)szTemp);
            Modem->OpenPort(szTemp);
		}
		else
		{
			AfxMessageBox("Cannot create modem object!");
		}
	}
}

void COpenComPort::EnableControls(BOOL bEnable)
{
    GetDlgItem(IDOK)->EnableWindow(bEnable);
    GetDlgItem(IDCANCEL)->EnableWindow(bEnable);
    GetDlgItem(IDC_COMM_PORT)->EnableWindow(bEnable);
    GetDlgItem(IDC_MODEM_TYPES)->EnableWindow(bEnable);
    GetDlgItem(IDC_FAXCLASS_TYPE)->EnableWindow(bEnable);
    GetDlgItem(IDC_TEST_MODEM)->EnableWindow(bEnable);
}
