// cGenTone.cpp : implementation file
//
#include "stdafx.h"
#include "Interactive Voice Sample.h"
#include "DlgGenerateTone.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// cGenerateTone dialog


cGenerateTone::cGenerateTone(CWnd* pParent /*=NULL*/)
	: CDialog(cGenerateTone::IDD, pParent)
{
	nFreq1		= 440;
	nFreq2		= 440;
	nDuration	= 40;

	//{{AFX_DATA_INIT(cGenerateTone)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void cGenerateTone::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(cGenerateTone)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(cGenerateTone, CDialog)
	//{{AFX_MSG_MAP(cGenerateTone)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// cGenerateTone message handlers

BOOL cGenerateTone::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void cGenerateTone::OnOK() 
{
BOOL	bTrans;

	try
	{
		// TODO: Add extra validation here
		nFreq1 = GetDlgItemInt(IDC_FREQ_FIRST,&bTrans,false);
		if( bTrans )
		{
			nFreq2 = GetDlgItemInt(IDC_FREQ_SEC,&bTrans,false);
			if( bTrans )
			{
				nDuration = GetDlgItemInt(IDC_DURATION,&bTrans,false);
				if( bTrans )
				{
					CDialog::OnOK();
				}
				else
				{
					throw IDC_DURATION;
				}
			}
			else
			{
				throw IDC_FREQ_SEC;
			}
		}
		else
		{
			throw IDC_FREQ_FIRST;
		}
	}
	catch(int e)
	{
		if( e == IDC_DURATION )
		{
			AfxMessageBox("Duration  must be between 0 and 40!");
		}
		else
		{
			AfxMessageBox("Frequency must be 0 or between 200 and 3000!");
		}
		GetDlgItem(e)->SetFocus();
	}
}
