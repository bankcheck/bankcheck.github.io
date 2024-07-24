// FaxConfig.cpp : implementation file
//

#include "stdafx.h"
#include "ocxdemo.h"
#include "FaxConfig.h"
#include "defines.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CFaxConfig dialog


CFaxConfig::CFaxConfig(CWnd* pParent /*=NULL*/)
	: CDialog(CFaxConfig::IDD, pParent)
{
	//{{AFX_DATA_INIT(CFaxConfig)
	m_speakerVolume = -1;
	m_speakerMode = -1;
	m_Ecm = FALSE;
	m_BFT = FALSE;
	m_BaudRate = -1;
	//}}AFX_DATA_INIT
	m_Ecm=TRUE;
}


void CFaxConfig::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CFaxConfig)
	DDX_Radio(pDX, IDC_RADIO4, m_speakerVolume);
	DDX_Radio(pDX, IDC_RADIO1, m_speakerMode);
	DDX_Check(pDX, IDC_ENABLE_ECM, m_Ecm);
	DDX_Check(pDX, IDC_ENABLE_BFT, m_BFT);
	DDX_Radio(pDX, IDC_RADIO7, m_BaudRate);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CFaxConfig, CDialog)
	//{{AFX_MSG_MAP(CFaxConfig)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFaxConfig message handlers

BOOL CFaxConfig::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	CheckRadioButton(IDC_RADIO1, IDC_RADIO3, m_speakerMode);
	CheckRadioButton(IDC_RADIO4,IDC_RADIO6, m_speakerVolume);
	CheckRadioButton(IDC_RADIO7, IDC_RADIO20, IDC_RADIO7+m_BaudRate-2);
	CheckDlgButton(IDC_ENABLE_ECM, m_Ecm);
	CheckDlgButton(IDC_ENABLE_BFT, m_BFT);
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CFaxConfig::OnOK() 
{
	m_speakerMode=GetCheckedRadioButton(IDC_RADIO1, IDC_RADIO3);	
	m_speakerVolume=GetCheckedRadioButton(IDC_RADIO4,IDC_RADIO6);
	m_BaudRate=GetCheckedRadioButton(IDC_RADIO7,IDC_RADIO20)-IDC_RADIO7;
	m_Ecm=IsDlgButtonChecked(IDC_ENABLE_ECM);
	m_BFT=IsDlgButtonChecked(IDC_ENABLE_BFT);
	CDialog::OnOK();
}
