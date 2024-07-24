// ascii.cpp : implementation file
//

#include "stdafx.h"

#include "port32.h"
#include "memory.h"
#include "bitiff.h"
#include "resource.h"
#include "ascii.h"

#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAscii dialog
CAscii::CAscii(CWnd* pParent /*=NULL*/)
        : CDialog(CAscii::IDD, pParent)
{
	//{{AFX_DATA_INIT(CAscii)
	m_Height	= 1100;
	m_LineSpace	= 0;
	m_szTabs	= "";
	m_Width		= 864;
	m_xDPI		= 200;
	m_xMargin	= 25;
	m_yDPI		= 200;
	m_yMargin	= 25;
	//}}AFX_DATA_INIT
	m_Measure	= MEASURE_INCH;

	_fmemset( &m_lf, 0, sizeof(m_lf) );
	lstrcpy( m_lf.lfFaceName, "System" );
	m_lf.lfHeight = 10;
	m_cf.iPointSize = 100;
}

void CAscii::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAscii)
	DDX_Text(pDX, IDC_HEIGHT, m_Height);
	DDV_MinMaxUInt(pDX, m_Height, 1, 65535);
	DDX_Text(pDX, IDC_LINESPACE, m_LineSpace);
	DDV_MinMaxUInt(pDX, m_LineSpace, 0, 32768);
	DDX_Text(pDX, IDC_TABS, m_szTabs);
	DDV_MaxChars(pDX, m_szTabs, 255);
	DDX_Text(pDX, IDC_WIDTH, m_Width);
	DDV_MinMaxUInt(pDX, m_Width, 1, 65535);
	DDX_Text(pDX, IDC_XDPI, m_xDPI);
	DDV_MinMaxUInt(pDX, m_xDPI, 1, 1000);
	DDX_Text(pDX, IDC_XMARGIN, m_xMargin);
	DDV_MinMaxUInt(pDX, m_xMargin, 0, 65535);
	DDX_Text(pDX, IDC_YDPI, m_yDPI);
	DDV_MinMaxUInt(pDX, m_yDPI, 1, 1000);
	DDX_Text(pDX, IDC_YMARGIN, m_yMargin);
	DDV_MinMaxUInt(pDX, m_yMargin, 0, 65535);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAscii, CDialog)
	//{{AFX_MSG_MAP(CAscii)
	ON_BN_CLICKED(IDC_FONTSEL, OnFontsel)
	ON_BN_CLICKED(IDC_METER, OnMeter)
	ON_BN_CLICKED(IDC_INCH, OnInch)
	ON_BN_CLICKED(IDC_FINEFAXPAGE, OnFinefaxpage)
	ON_BN_CLICKED(IDC_STANDARDFAXPAGE, OnStandardfaxpage)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CAscii message handlers

void CAscii::OnFontsel()
{
	CFontDialog     dlgFont;
	
	*dlgFont.m_cf.lpLogFont = m_lf;
	dlgFont.m_cf.Flags     |= CF_SCREENFONTS | CF_EFFECTS | CF_INITTOLOGFONTSTRUCT;
	dlgFont.m_cf.rgbColors  = RGB(0, 0, 0);
	dlgFont.m_cf.nFontType  = SCREEN_FONTTYPE;
	if ( dlgFont.DoModal() == IDOK ) {
		m_cf = dlgFont.m_cf;
		m_lf = *dlgFont.m_cf.lpLogFont;
    }
}

void CAscii::OnMeter()
{
	m_Measure = MEASURE_METER;
	CheckRadioButton( IDC_INCH, IDC_METER, IDC_METER );
}

void CAscii::OnInch()
{
	m_Measure = MEASURE_INCH;
	CheckRadioButton( IDC_INCH, IDC_METER, IDC_INCH );
}

BOOL CAscii::OnInitDialog()
{
	CDialog::OnInitDialog();

	if ( m_Measure == MEASURE_INCH )
		CheckRadioButton( IDC_INCH, IDC_METER, IDC_INCH );
	else
		CheckRadioButton( IDC_INCH, IDC_METER, IDC_METER );

	CenterWindow();
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CAscii::OnOK()
{
	DWORD	dwPixelWidth, dwPixelHeight, dwInchWidth, dwInchHeight;
	BOOL	bTrans;

	dwInchWidth		= (DWORD)GetDlgItemInt( IDC_WIDTH, &bTrans, FALSE );
	dwInchHeight	= (DWORD)GetDlgItemInt( IDC_HEIGHT, &bTrans, FALSE );
	if ( m_Measure == MEASURE_METER ) {
		dwInchWidth	= dwInchWidth * 1000 / 254;
		dwInchHeight= dwInchHeight * 1000 / 254;
	}
	dwPixelWidth  = dwInchWidth * GetDlgItemInt( IDC_XDPI, &bTrans, FALSE ) / 100;
	dwPixelHeight = dwInchHeight * GetDlgItemInt( IDC_YDPI, &bTrans, FALSE ) / 100;
	if ( dwPixelWidth > 1728 || dwPixelHeight > 2200 )
		AfxMessageBox( "Image width or height is bigger then fax standard." );
	else
		CDialog::OnOK();
}

//rz
void CAscii::OnFinefaxpage() 
{
	// TODO: Add your control notification handler code here
		CButton* cbox=(CButton*)GetDlgItem(IDC_STANDARDFAXPAGE);	
	if(cbox->GetCheck())cbox->SetCheck(0);
	cbox=(CButton*)GetDlgItem(IDC_FINEFAXPAGE);	
	if(cbox->GetCheck())
	{
		char s[3];
		m_Width=864;
		CEdit* edit=(CEdit*)GetDlgItem(IDC_WIDTH);
		wsprintf(s,"%d",m_Width);
		edit->SetWindowText(s);
		edit=(CEdit*)GetDlgItem(IDC_HEIGHT);
		m_Height=1100;
		wsprintf(s,"%d",m_Height);
		edit->SetWindowText(s);
		edit=(CEdit*)GetDlgItem(IDC_XDPI);
		m_xDPI=200;
		wsprintf(s,"%d",m_xDPI);
		edit->SetWindowText(s);
		edit=(CEdit*)GetDlgItem(IDC_YDPI);
		m_yDPI=200;
		wsprintf(s,"%d",m_yDPI);
		edit->SetWindowText(s);
	}

}

void CAscii::OnStandardfaxpage() 
{
	// TODO: Add your control notification handler code here
	CButton* cbox=(CButton*)GetDlgItem(IDC_FINEFAXPAGE);	
	if(cbox->GetCheck())cbox->SetCheck(0);
	cbox=(CButton*)GetDlgItem(IDC_STANDARDFAXPAGE);	
	if(cbox->GetCheck())
	{
		char s[3];
		m_Width=864;
		CEdit* edit=(CEdit*)GetDlgItem(IDC_WIDTH);
		wsprintf(s,"%d",m_Width);
		edit->SetWindowText(s);
		edit=(CEdit*)GetDlgItem(IDC_HEIGHT);
		m_Height=1100;
		wsprintf(s,"%d",m_Height);
		edit->SetWindowText(s);
		edit=(CEdit*)GetDlgItem(IDC_XDPI);
		m_xDPI=200;
		wsprintf(s,"%d",m_xDPI);
		edit->SetWindowText(s);
		edit=(CEdit*)GetDlgItem(IDC_YDPI);
		m_yDPI=100;
		wsprintf(s,"%d",m_yDPI);
		edit->SetWindowText(s);
	}
		
}
