// DetectTone.cpp : implementation file
//

#include "stdafx.h"
#include "interactive voice sample.h"
#include "DetectTone.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDetectTone dialog


CDetectTone::CDetectTone(CWnd* pParent /*=NULL*/)
	: CDialog(CDetectTone::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDetectTone)
	m_DetectionMode = _T("Leading Edge Detection");
	m_dFreq1 = 300;
	m_dFreq1Dev = 30;
	m_dFreq2 = 1000;
	m_dFreq2Dev = 100;
	m_iToneType = 0;
	m_szToneID = _T("1");
	//}}AFX_DATA_INIT
}


void CDetectTone::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDetectTone)
	DDX_CBString(pDX, IDC_DETECTIONMODE, m_DetectionMode);
	DDX_Text(pDX, IDC_FREQ1, m_dFreq1);
	DDV_MinMaxInt(pDX, m_dFreq1, 10, 10000);
	DDX_Text(pDX, IDC_FREQ1DEV, m_dFreq1Dev);
	DDV_MinMaxInt(pDX, m_dFreq1Dev, 0, 5000);
	DDX_Text(pDX, IDC_FREQ2, m_dFreq2);
	DDV_MinMaxInt(pDX, m_dFreq2, 10, 10000);
	DDX_Text(pDX, IDC_FREQ2DEV, m_dFreq2Dev);
	DDV_MinMaxInt(pDX, m_dFreq2Dev, 0, 5000);
	DDX_Radio(pDX, IDC_SINGLE_TONE, m_iToneType);
	DDX_Text(pDX, IDC_TONEID, m_szToneID);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDetectTone, CDialog)
	//{{AFX_MSG_MAP(CDetectTone)
	ON_BN_CLICKED(IDC_SINGLE_TONE, OnSingleTone)
	ON_BN_CLICKED(IDC_DUAL_TONE, OnDualTone)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDetectTone message handlers

void CDetectTone::OnOK() 
{
    UpdateData(TRUE);
	CDialog::OnOK();
}

void CDetectTone::OnSingleTone() 
{
    UpdateData(TRUE);
    if(!m_iToneType)
    {
        (CWnd*)GetDlgItem(IDC_FREQ2)->EnableWindow(FALSE);
        (CWnd*)GetDlgItem(IDC_FREQ2DEV)->EnableWindow(FALSE);
    }
    else
    {
        (CWnd*)GetDlgItem(IDC_FREQ2)->EnableWindow(TRUE);
        (CWnd*)GetDlgItem(IDC_FREQ2DEV)->EnableWindow(TRUE);
    }
	
}

void CDetectTone::OnDualTone() 
{
    UpdateData(TRUE);
    if(!m_iToneType)
    {
        (CWnd*)GetDlgItem(IDC_FREQ2)->EnableWindow(FALSE);
        (CWnd*)GetDlgItem(IDC_FREQ2DEV)->EnableWindow(FALSE);
    }
    else
    {
        (CWnd*)GetDlgItem(IDC_FREQ2)->EnableWindow(TRUE);
        (CWnd*)GetDlgItem(IDC_FREQ2DEV)->EnableWindow(TRUE);
    }
}

BOOL CDetectTone::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
    if(!m_iToneType)
    {
        (CWnd*)GetDlgItem(IDC_FREQ2)->EnableWindow(FALSE);
        (CWnd*)GetDlgItem(IDC_FREQ2DEV)->EnableWindow(FALSE);
    }
    else
    {
        (CWnd*)GetDlgItem(IDC_FREQ2)->EnableWindow(TRUE);
        (CWnd*)GetDlgItem(IDC_FREQ2DEV)->EnableWindow(TRUE);
    }


	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}


int CDetectTone::GetDetectionMode()
{
    if(m_DetectionMode == _T("Leading Edge Detection") )
        return TONE_DETECTION_MODE_LEADING;
    else
        return TONE_DETECTION_MODE_TRAILING;
}


void CDetectTone::SetToneID(int ToneID)
{
    if(ToneID>0)
    {
        wsprintf(m_szToneID.GetBuffer(256), "%d", ToneID);
		m_szToneID.ReleaseBuffer();
    }
}

