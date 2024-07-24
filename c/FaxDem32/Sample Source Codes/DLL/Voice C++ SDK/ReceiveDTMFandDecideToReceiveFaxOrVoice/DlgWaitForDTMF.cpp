// cDTMFDlg.cpp : implementation file
//
#include "stdafx.h"
#include "ReceiveDTMFandDecideToReceiveFaxOrVoice.h"
#include "DlgWaitForDTMF.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// cWaitForDTMFDlg dialog


cWaitForDTMFDlg::cWaitForDTMFDlg(CWnd* pParent /*=NULL*/)
	: CDialog(cWaitForDTMFDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(cWaitForDTMFDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void cWaitForDTMFDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(cWaitForDTMFDlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	DDX_Control(pDX, IDC_NUMBER_OF_DTMF, m_numOfDTMF);
	DDX_Control(pDX, IDC_DELIM_OF_DTMF, m_delimOfDTMF);
	//}}AFX_DATA_MAP
}

BOOL cWaitForDTMFDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	m_numOfDTMF.LimitText(3);
	m_delimOfDTMF.LimitText(1);
	return TRUE;
}


BEGIN_MESSAGE_MAP(cWaitForDTMFDlg, CDialog)
	//{{AFX_MSG_MAP(cWaitForDTMFDlg)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// cWaitForDTMFDlg message handlers

void cWaitForDTMFDlg::OnOK() 
{
BOOL	bTrans;

	// TODO: Add extra validation here
	memset(&DTMFInfo,0,sizeof(DTMFInfo));
	DTMF_NUM((&DTMFInfo)) = GetDlgItemInt(IDC_NUMBER_OF_DTMF,&bTrans,FALSE);
	if( bTrans )
	{
		if( DTMF_NUM((&DTMFInfo)) >= 0 && DTMF_NUM((&DTMFInfo)) <= MMOD_DTMF_LEN )
		{	
		char	szTemp[2];
		int		nTemp = SendDlgItemMessage(IDC_DELIM_OF_DTMF,WM_GETTEXT,2,(LPARAM)szTemp );
		bool	bOK = true;

			if(  nTemp < 2 )
			{	
				if( nTemp == 1 )
				{
					if( isdigit( *szTemp ) || *szTemp == '#' || *szTemp == '*' )
					{
						DTMF_DELIM((&DTMFInfo)) = *szTemp;
					}
					else
					{
						AfxMessageBox("Invalid DTMF delimiter!");
						bOK = false;
					}
				}

				if( bOK )
				{
					CDialog::OnOK();
				}
			}
			else
			{
				AfxMessageBox("Only one delimiter digit is acceptable!");
			}
		}
		else
		{
			AfxMessageBox("Number of DTMF digits must be between 1-128!");
		}
	}
	else
	{
		AfxMessageBox("Number of DTMF digits is incorrect!");
	}
}
