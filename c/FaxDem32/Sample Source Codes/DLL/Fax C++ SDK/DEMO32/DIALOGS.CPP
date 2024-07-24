// dialogs.cpp : implementation file
//

#include "stdafx.h"

#pragma warning(disable:4103)

extern "C" {
	#include "bitiff.h"
	#include "bidisp.h"
};

#include "resource.h"
#include "faxcpp.h"
#include "imgdoc.h"
#include "magnifyw.h"
#include "disp.h"
#include "imgvw.h"
#include "dialogs.h"
#include "faxdlg.h"
#include "mainfrm.h"
#include "demo.h"



#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif


BOOL CDlg::OnInitDialog(void)
{
    RECT    rDialog, rDesctop;

    CDialog::OnInitDialog();

    GetWindowRect(&rDialog);
    GetDesktopWindow()->GetWindowRect(&rDesctop);

    int iDialog  = rDialog.right - rDialog.left;

    rDialog.left = rDesctop.left + ((rDesctop.right - rDesctop.left) - iDialog)/2;
    rDialog.right = rDialog.left + iDialog;

    iDialog  = rDialog.bottom - rDialog.top;

    rDialog.top = rDesctop.top + ((rDesctop.bottom - rDesctop.top) - iDialog)/2;
    rDialog.bottom = rDialog.top + iDialog;


    MoveWindow(&rDialog, TRUE);
    return  TRUE;
}

/////////////////////////////////////////////////////////////////////////////
// CDimension dialog

CDimension::CDimension(CWnd* pParent /*=NULL*/)
    : CDlg(CDimension::IDD, pParent)
{
    //{{AFX_DATA_INIT(CDimension)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}

void CDimension::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CDimension)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CDimension, CDialog)
    //{{AFX_MSG_MAP(CDimension)
        // NOTE: the ClassWizard will add message map macros here
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDimension message handlers

BOOL CDimension::OnInitDialog(void)
{
    CDlg::OnInitDialog();
    if (!pDoc) return FALSE ;
    

	SetDlgItemText(IDC_TIFFFILE, pDoc->szTiffFileName);
	SetDlgItemInt(IDC_WIDTH, (int)pDoc->dwWidth);
	SetDlgItemInt(IDC_HEIGHT, (int)(pDoc->dwHeight));
	SetDlgItemInt(IDC_PLANES, (int)(pDoc->wPlanes));
	SetDlgItemInt(IDC_BITS, (int)(pDoc->wBits));
	SetDlgItemInt(IDC_HORZDPI, (int)(pDoc->wHorizontalDPI));
	SetDlgItemInt(IDC_VERTDPI, (int)(pDoc->wVerticalDPI));

    return   TRUE;
}

/////////////////////////////////////////////////////////////////////////////
// CDlgRotate dialog

CDlgRotate::CDlgRotate(CWnd* pParent /*=NULL*/)
    : CDlg(CDlgRotate::IDD, pParent)
{
    //{{AFX_DATA_INIT(CDlgRotate)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}

void CDlgRotate::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CDlgRotate)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CDlgRotate, CDialog)
    //{{AFX_MSG_MAP(CDlgRotate)
	ON_EN_CHANGE(IDC_DEGREE, OnChangeDegree)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgRotate message handlers

BOOL CDlgRotate::OnInitDialog()
{
    CDlg::OnInitDialog();
    
    // TODO: Add extra initialization here
    CheckRadioButton(IDC_SLOW, IDC_FAST, IDC_SLOW);
    SetDlgItemInt(IDC_DEGREE, 0, TRUE);
	((CEdit*)GetDlgItem(IDC_DEGREE))->LimitText(4);
    GetDlgItem(IDC_DEGREE)->SetFocus();
    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CDlgRotate::OnOK()
{
    // TODO: Add extra validation here
    
    nDegree = GetDlgItemInt(IDC_DEGREE, NULL, TRUE);
    nMethod = GetCheckedRadioButton(IDC_SLOW, IDC_FAST) == IDC_FAST;
    CDialog::OnOK();
}

/////////////////////////////////////////////////////////////////////////////
// CDlgScale dialog

CDlgScale::CDlgScale(CWnd* pParent /*=NULL*/)
    : CDlg(CDlgScale::IDD, pParent)
{
    //{{AFX_DATA_INIT(CDlgScale)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}

void CDlgScale::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CDlgScale)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CDlgScale, CDialog)
    //{{AFX_MSG_MAP(CDlgScale)
	ON_EN_CHANGE(IDC_X_AXIS, OnChangeXAxis)
	ON_EN_CHANGE(IDC_Y_AXIS, OnChangeYAxis)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgScale message handlers

BOOL CDlgScale::OnInitDialog()
{
    CDlg::OnInitDialog();
    
    // TODO: Add extra initialization here
    if (!pDoc) return FALSE ;
    
    CheckRadioButton(IDC_BILINEAR, IDC_CUBIC_SPLINE, IDC_BILINEAR);
    SetDlgItemInt(IDC_X_AXIS, (int)(pDoc->dwWidth), FALSE);
    SetDlgItemInt(IDC_Y_AXIS, (int)(pDoc->dwHeight), FALSE);
	((CEdit*)GetDlgItem(IDC_X_AXIS))->LimitText(5);
	((CEdit*)GetDlgItem(IDC_Y_AXIS))->LimitText(5);
    GetDlgItem(IDC_X_AXIS)->SetFocus();
        
    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CDlgScale::OnOK()
{
    // TODO: Add extra validation here
    
    wWidth = (WORD)GetDlgItemInt(IDC_X_AXIS, NULL, FALSE);
    wHeight = (WORD)GetDlgItemInt(IDC_Y_AXIS, NULL, FALSE);
    nMethod = GetCheckedRadioButton(IDC_BILINEAR, IDC_CUBIC_SPLINE) == IDC_CUBIC_SPLINE;
    
    CDialog::OnOK();
}

/////////////////////////////////////////////////////////////////////////////
// CDlgSkew dialog

CDlgSkew::CDlgSkew(CWnd* pParent /*=NULL*/)
    : CDlg(CDlgSkew::IDD, pParent)
{
    //{{AFX_DATA_INIT(CDlgSkew)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}

void CDlgSkew::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CDlgSkew)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CDlgSkew, CDialog)
    //{{AFX_MSG_MAP(CDlgSkew)
	ON_EN_CHANGE(IDC_DISTANCE, OnChangeDistance)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgSkew message handlers

BOOL CDlgSkew::OnInitDialog()
{
    CDlg::OnInitDialog();
    
    // TODO: Add extra initialization here
    
    CheckRadioButton(IDC_X_AXIS, IDC_Y_AXIS, IDC_X_AXIS);
    SetDlgItemInt(IDC_DISTANCE, 0, TRUE);
    GetDlgItem(IDC_DISTANCE)->SetFocus();
	((CEdit*)GetDlgItem(IDC_DISTANCE))->LimitText(4);
    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CDlgSkew::OnOK()
{
    // TODO: Add extra validation here
    
    nIncrement = GetDlgItemInt(IDC_DISTANCE, NULL, TRUE);
    bDirection = GetCheckedRadioButton(IDC_X_AXIS, IDC_Y_AXIS) == IDC_X_AXIS;
    CDialog::OnOK();
}

/////////////////////////////////////////////////////////////////////////////
// CDlgColorToGray dialog

CDlgColorToGray::CDlgColorToGray(CWnd* pParent /*=NULL*/)
    : CDlg(CDlgColorToGray::IDD, pParent)
{
    //{{AFX_DATA_INIT(CDlgColorToGray)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}

void CDlgColorToGray::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CDlgColorToGray)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CDlgColorToGray, CDialog)
    //{{AFX_MSG_MAP(CDlgColorToGray)
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgColorToGray message handlers

BOOL CDlgColorToGray::OnInitDialog()
{
    CDlg::OnInitDialog();
    
    // TODO: Add extra initialization here
	if (!pDoc)  return FALSE ;
	    
    CheckRadioButton(IDC_NOANTIALISING, IDC_ANTIALISING5, IDC_NOANTIALISING);
    if(pDoc->wBits*pDoc->wPlanes == 1)
        GetDlgItem(IDC_PSYCHOVISUAL)->EnableWindow(FALSE);
    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CDlgColorToGray::OnOK()
{
    // TODO: Add extra validation here
    
    nMethod = GetCheckedRadioButton(IDC_NOANTIALISING, IDC_ANTIALISING5);
    switch(nMethod) {
        case IDC_NOANTIALISING:
            nMethod = 0;
            break;
        case IDC_ANTIALISING3:
            nMethod = 1;
            break;
        case IDC_ANTIALISING5:
            nMethod = 2;
            break;
    }
    bPsychovisual = (((CButton*)GetDlgItem(IDC_PSYCHOVISUAL))->GetCheck() == 1);    
    CDialog::OnOK();
}

/////////////////////////////////////////////////////////////////////////////
// CCustomZoom dialog


CCustomZoom::CCustomZoom(CWnd* pParent /*=NULL*/)
    : CDlg(CCustomZoom::IDD, pParent)
{
    //{{AFX_DATA_INIT(CCustomZoom)
    m_edit1 = 0;
    m_edit2 = 0;
    //}}AFX_DATA_INIT
}

void CCustomZoom::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CCustomZoom)
    DDX_Text(pDX, IDC_EDIT1, m_edit1);
    DDX_Text(pDX, IDC_EDIT2, m_edit2);
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CCustomZoom, CDialog)
    //{{AFX_MSG_MAP(CCustomZoom)
	ON_EN_CHANGE(IDC_EDIT1, OnChangeEdit1)
	ON_EN_CHANGE(IDC_EDIT2, OnChangeEdit2)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CCustomZoom message handlers

BOOL CCustomZoom::OnInitDialog()
{
    CDlg::OnInitDialog();
    
    // TODO: Add extra initialization here
    
    return TRUE;  // return TRUE  unless you set the focus to a control
}
/////////////////////////////////////////////////////////////////////////////
// CZoomStep dialog


CZoomStep::CZoomStep(CWnd* pParent /*=NULL*/)
    : CDlg(CZoomStep::IDD, pParent)
{
    //{{AFX_DATA_INIT(CZoomStep)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}

void CZoomStep::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CZoomStep)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CZoomStep, CDialog)
    //{{AFX_MSG_MAP(CZoomStep)
    ON_EN_CHANGE(IDC_BASE, OnChangeBase)
	ON_EN_CHANGE(IDC_E_STEPNUM, OnChangeEStepnum)
	ON_EN_CHANGE(IDC_R_STEPNUM, OnChangeRStepnum)
	ON_EN_CHANGE(IDC_E10, OnChangeE10)
	ON_EN_CHANGE(IDC_E9, OnChangeE9)
	ON_EN_CHANGE(IDC_E8, OnChangeE8)
	ON_EN_CHANGE(IDC_E7, OnChangeE7)
	ON_EN_CHANGE(IDC_E6, OnChangeE6)
	ON_EN_CHANGE(IDC_E5, OnChangeE5)
	ON_EN_CHANGE(IDC_E4, OnChangeE4)
	ON_EN_CHANGE(IDC_E3, OnChangeE3)
	ON_EN_CHANGE(IDC_E2, OnChangeE2)
	ON_EN_CHANGE(IDC_R2, OnChangeR2)
	ON_EN_CHANGE(IDC_R3, OnChangeR3)
	ON_EN_CHANGE(IDC_R4, OnChangeR4)
	ON_EN_CHANGE(IDC_R5, OnChangeR5)
	ON_EN_CHANGE(IDC_R6, OnChangeR6)
	ON_EN_CHANGE(IDC_R7, OnChangeR7)
	ON_EN_CHANGE(IDC_R8, OnChangeR8)
	ON_EN_CHANGE(IDC_R9, OnChangeR9)
	ON_EN_CHANGE(IDC_R10, OnChangeR10)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CZoomStep message handlers

BOOL CZoomStep::OnInitDialog()
{
    CDlg::OnInitDialog();
    
    // TODO: Add extra initialization here
    
    int jj, zbase;
    ZOOMSTEP ee, rr;
    zbase = BZoomGetScaleSteps(&ee, &rr);
    SetDlgItemInt(IDC_BASE, zbase);
    SetDlgItemInt(IDC_E_STEPNUM, ee.num);
    SetDlgItemInt(IDC_R_STEPNUM, rr.num);
    for(jj=0; jj<ee.num; jj++) 
        SetDlgItemInt(IDC_E1+jj, ee.step[jj]);
    for(jj=0; jj<rr.num; jj++) 
        SetDlgItemInt(IDC_R1+jj, rr.step[jj]);
    SetDlgItemText(IDC_Z_ERROR, " ");

    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CZoomStep::OnOK()
{
    // TODO: Add extra validation here
    int jj, zbase, tmp;
    ZOOMSTEP ee, rr;

    _fmemset(&ee, 0, sizeof(ee));
    _fmemset(&rr, 0, sizeof(rr));

    zbase = GetDlgItemInt(IDC_BASE);
    if(zbase<=0 || zbase>MAX_SCALE_BASE) {
        SetDlgItemText(IDC_Z_ERROR, "Bad base value (1..1000)");
        GetDlgItem(IDC_BASE)->SetFocus();
        return; }

    ee.num = GetDlgItemInt(IDC_E_STEPNUM);
    if(ee.num<=0 || ee.num>MAX_SCALE_STEP) {
        SetDlgItemText(IDC_Z_ERROR, "Bad enlarge number (1..10)");
        GetDlgItem(IDC_E_STEPNUM)->SetFocus();
        return; }

    rr.num = GetDlgItemInt(IDC_R_STEPNUM);
    if(rr.num<=0 || rr.num>MAX_SCALE_STEP) {
        SetDlgItemText(IDC_Z_ERROR, "Bad reduce number (1..10)");
        GetDlgItem(IDC_R_STEPNUM)->SetFocus();
        return; }

    ee.step[0] = GetDlgItemInt(IDC_E1);
    if(ee.step[0] != zbase) {
        SetDlgItemText(IDC_Z_ERROR, "Bad base value (1..1000)");
        GetDlgItem(IDC_BASE)->SetFocus();
        return; }

    tmp = ee.step[0];
    for(jj=1; jj<ee.num; jj++) {
        ee.step[jj] = GetDlgItemInt(IDC_E1+jj);
        if(ee.step[jj] <= tmp) {
            SetDlgItemText(IDC_Z_ERROR, "Bad enlarge progression");
            GetDlgItem(IDC_E1+jj)->SetFocus();
            return; }
        tmp = ee.step[jj];
    }            

    rr.step[0] = GetDlgItemInt(IDC_R1);
    if(rr.step[0] != zbase) {
        SetDlgItemText(IDC_Z_ERROR, "Bad base value (1..1000)");
        GetDlgItem(IDC_BASE)->SetFocus();
        return; }

    tmp = rr.step[0];
    for(jj=1; jj<rr.num; jj++) {
        rr.step[jj] = GetDlgItemInt(IDC_R1+jj);
        if(rr.step[jj] <= tmp) {
            SetDlgItemText(IDC_Z_ERROR, "Bad reduce progression");
            GetDlgItem(IDC_R1+jj)->SetFocus();
            return; }
        tmp = rr.step[jj];
    }            

    BZoomSetScaleSteps(zbase, &ee, &rr);
    
    CDialog::OnOK();
    
}

void CZoomStep::OnChangeBase()
{
    // TODO: Add your control notification handler code here
    int zbase,zbaseold;
	CString zbasestr;
    char buf[30];
	ZOOMSTEP ee,rr;
    zbaseold=BZoomGetScaleSteps(&ee, &rr);

    GetDlgItem(IDC_BASE)->GetWindowText(zbasestr);
	bool notNumber=false;
	for (int i=0;i<zbasestr.GetLength() && notNumber==false;i++)
		if ((char)(zbasestr[i])<48 || (char)zbasestr[i]>57) notNumber=true;
	zbase=atoi(zbasestr);
	if (notNumber || zbase<=0 || zbase>MAX_SCALE_BASE) {
       /* SetDlgItemText(IDC_E_BASE, ": ???");
        SetDlgItemText(IDC_R_BASE, "??? :");
        SetDlgItemText(IDC_E1, "???");
        SetDlgItemText(IDC_R1, "???");
        return;*/
		SetDlgItemInt(IDC_BASE,zbaseold);}
	else
	{
    wsprintf(buf, ": %d", zbase);
    SetDlgItemText(IDC_E_BASE, buf);
    wsprintf(buf, "%d :", zbase);
    SetDlgItemText(IDC_R_BASE, buf);

    SetDlgItemInt(IDC_E1, zbase);
    SetDlgItemInt(IDC_R1, zbase);
	}

    
}
/////////////////////////////////////////////////////////////////////////////
// CMySave dialog


CMySave::CMySave(BOOL flg)
    : CFileDialog(flg)
{
    //{{AFX_DATA_INIT(CMySave)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT
}

void CMySave::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CMySave)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CMySave, CDialog)
    //{{AFX_MSG_MAP(CMySave)
    ON_BN_CLICKED(1, On1)
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CMySave message handlers

BOOL CMySave::OnInitDialog()
{
    CFileDialog::OnInitDialog();
    
    // TODO: Add extra initialization here
#if JPEG_EXIST == 1
    m_dlg_jpeg_qu = 75;
    SetDlgItemInt(IDC_EDIT1, m_dlg_jpeg_qu);
#else
    CWnd *hwnd = GetDlgItem(IDC_EDIT1);    
    if(hwnd)
        hwnd->ShowWindow(SW_HIDE);
    hwnd = GetDlgItem(IDC_JPEG_STAT);    
    if(hwnd)
        hwnd->ShowWindow(SW_HIDE);
#endif
    
    return TRUE;  // return TRUE  unless you set the focus to a control
}

void CMySave::On1()
{
    // TODO: Add your control notification handler code here
    m_dlg_jpeg_qu = GetDlgItemInt(IDC_EDIT1);
    CFileDialog::OnOK();
}

void CMySave::OnLBSelChangedNotify(UINT nIDBox, UINT iCurSel, UINT nCode) {
    BOOL f1 = FALSE;
    if(nCode!=CD_LBSELCHANGE) 
        return;       
    if(nIDBox!=1136)
        return;
        
#if JPEG_EXIST == 1        
    if(iCurSel+FORMAT_FIRST+1==FORMAT_JPEG)
        f1 = TRUE;    
#endif        
            
    CWnd *hwnd = GetDlgItem(IDC_EDIT1);    
    if(hwnd)
        hwnd->EnableWindow(f1);
	iCurSel = iCurSel;
    return; }
/////////////////////////////////////////////////////////////////////////////
// CHalftoneDlg dialog


CHalftoneDlg::CHalftoneDlg(CWnd* pParent /*=NULL*/)
	: CDlg(CHalftoneDlg::IDD, pParent)
{             
	m_Methode = 0;
	m_Intensity = 0;
	//{{AFX_DATA_INIT(CHalftoneDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}

void CHalftoneDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CHalftoneDlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CHalftoneDlg, CDlg)
	//{{AFX_MSG_MAP(CHalftoneDlg)
	ON_EN_KILLFOCUS(IDC_EDIT1, OnKillfocusEdit1)
	ON_WM_VSCROLL()
	ON_WM_HSCROLL()
	ON_EN_CHANGE(IDC_EDIT1, OnChangeEdit1)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CHalftoneDlg message handlers

BOOL CHalftoneDlg::OnInitDialog()
{
	CDlg::OnInitDialog();
	
	// TODO: Add extra initialization here
	((CEdit *)GetDlgItem(IDC_EDIT1))->LimitText(4);
	int tmp = 0;
	if(m_Methode>=0 && m_Methode<3)
		tmp = m_Methode;
	CheckRadioButton(IDC_RADIO1, IDC_RADIO3, IDC_RADIO1+tmp);
	
	SetDlgItemInt(IDC_EDIT1, m_Intensity);
	
	CScrollBar *sb;
	sb = (CScrollBar *)GetDlgItem(IDC_SCROLL1);
	if(sb) 
	{
		sb->SetScrollRange(-128, 128, FALSE);
		sb->SetScrollPos(m_Intensity);
	}	
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CHalftoneDlg::OnKillfocusEdit1()
{
	// TODO: Add your control notification handler code here
	int met, tmp;
	met = GetDlgItemInt(IDC_EDIT1);
	tmp = met;
	int smin = -128;
	int smax = 128;
	CScrollBar *sb;
	sb = (CScrollBar *)GetDlgItem(IDC_SCROLL1);
	if(sb) 
		sb->GetScrollRange(&smin, &smax);
	
	if(met < smin)
		tmp = smin;
	if(met > smax)
		tmp = smax;
	if(met != tmp)
	{	
		met = tmp;
		SetDlgItemInt(IDC_EDIT1, met);
	}
	
	if(sb) 
		sb->SetScrollPos(met);
}

void CHalftoneDlg::OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar)
{
	// TODO: Add your message handler code here and/or call default
	
	CDialog::OnVScroll(nSBCode, nPos, pScrollBar);
}

void CHalftoneDlg::OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar)
{
	// TODO: Add your message handler code here and/or call default
	
	int smin = -128;
	int smax = 128;
	if(pScrollBar)
	{
		pScrollBar->GetScrollRange(&smin, &smax);
		int pos = pScrollBar->GetScrollPos();
		int tmp = pos;
		
		switch(nSBCode)
		{
			case SB_LINELEFT:
				pos--;
				break;
			case SB_LINERIGHT:
				pos++;
				break;
			case SB_PAGELEFT:
				pos -= 10;
				break;
			case SB_PAGERIGHT:
				pos += 10;
				break;
			case SB_THUMBPOSITION:
			case SB_THUMBTRACK:
				pos = (int)nPos;
				break;	
		}	
		if(pos < smin)
			pos = smin;
		if(pos > smax)
			pos = smax;
		if(pos==tmp)
			return;				
			
		pScrollBar->SetScrollPos(pos);
		SetDlgItemInt(IDC_EDIT1, pos);
	}		
	
	CDialog::OnHScroll(nSBCode, nPos, pScrollBar);
}

void CHalftoneDlg::OnCancel()
{
	// TODO: Add extra cleanup here
	
	CDialog::OnCancel();
}

void CHalftoneDlg::OnOK()
{
	// TODO: Add extra validation here
	
	int tmp = GetCheckedRadioButton(IDC_RADIO1, IDC_RADIO3);
	if(tmp)
		m_Methode = tmp - IDC_RADIO1;
	m_Intensity = GetDlgItemInt(IDC_EDIT1);		
		
	CDlg::OnOK();
}


void CZoomStep::OnChangeEStepnum() 
{
	ZOOMSTEP ee, rr;
	CString neweenum;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_E_STEPNUM)->GetWindowText(neweenum);
	bool notNumber=false;
	for (int i=0;i<neweenum.GetLength() && notNumber==false;i++)
		if ((char)(neweenum[i])<48 || (char)neweenum[i]>57) notNumber=true;
	if (notNumber) SetDlgItemInt(IDC_E_STEPNUM,ee.num);


	// TODO: Add your control notification handler code here
	
}


void CZoomStep::OnChangeRStepnum() 
{
	ZOOMSTEP ee, rr;
	CString newrrnum;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_R_STEPNUM)->GetWindowText(newrrnum);
	bool notNumber=false;
	for (int i=0;i<newrrnum.GetLength() && notNumber==false;i++)
		if ((char)(newrrnum[i])<48 || (char)newrrnum[i]>57) notNumber=true;
	if (notNumber) SetDlgItemInt(IDC_R_STEPNUM,rr.num);
	

}

void CZoomStep::OnChangeE10() 
{
	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_E10)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (ee.step[9]!=0) SetDlgItemInt(IDC_E10,ee.step[9]);
			else SetDlgItemText(IDC_E10,"");
}

void CZoomStep::OnChangeE9() 
{
	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_E9)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (ee.step[8]!=0) SetDlgItemInt(IDC_E9,ee.step[8]);
			else SetDlgItemText(IDC_E9,"");
	
}

void CZoomStep::OnChangeE8() 
{

	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_E8)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (ee.step[7]!=0) SetDlgItemInt(IDC_E8,ee.step[7]);
			else SetDlgItemText(IDC_E8,"");
	
	
}

void CZoomStep::OnChangeE7() 
{
	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_E7)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (ee.step[6]!=0) SetDlgItemInt(IDC_E7,ee.step[6]);
			else SetDlgItemText(IDC_E7,"");
	
}

void CZoomStep::OnChangeE6() 
{
	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_E6)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (ee.step[5]!=0) SetDlgItemInt(IDC_E6,ee.step[5]);
			else SetDlgItemText(IDC_E6,"");
	
	
}

void CZoomStep::OnChangeE5() 
{
	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_E5)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (ee.step[4]!=0) SetDlgItemInt(IDC_E5,ee.step[4]);
			else SetDlgItemText(IDC_E5,"");
	
}

void CZoomStep::OnChangeE4() 
{
	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_E4)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (ee.step[3]!=0) SetDlgItemInt(IDC_E4,ee.step[3]);
			else SetDlgItemText(IDC_E4,"");
}

void CZoomStep::OnChangeE3() 
{
	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_E3)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (ee.step[2]!=0) SetDlgItemInt(IDC_E3,ee.step[2]);
			else SetDlgItemText(IDC_E3,"");
	
	
}

void CZoomStep::OnChangeE2() 
{
	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_E2)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (ee.step[1]!=0) SetDlgItemInt(IDC_E2,ee.step[1]);
			else SetDlgItemText(IDC_E2,"");
	
}

void CZoomStep::OnChangeR2() 
{
	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_R2)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (rr.step[1]!=0) SetDlgItemInt(IDC_R2,rr.step[1]);
			else SetDlgItemText(IDC_R2,"");
}

void CZoomStep::OnChangeR3() 
{
	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_R3)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (rr.step[2]!=0) SetDlgItemInt(IDC_R3,rr.step[2]);
			else SetDlgItemText(IDC_R3,"");
}

void CZoomStep::OnChangeR4() 
{
	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_R4)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (rr.step[3]!=0) SetDlgItemInt(IDC_R4,rr.step[3]);
			else SetDlgItemText(IDC_R4,"");
}

void CZoomStep::OnChangeR5() 
{
	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_R5)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (rr.step[4]!=0) SetDlgItemInt(IDC_R5,rr.step[4]);
			else SetDlgItemText(IDC_R5,"");
}

void CZoomStep::OnChangeR6() 
{
	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_R6)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (rr.step[5]!=0) SetDlgItemInt(IDC_R6,rr.step[5]);
			else SetDlgItemText(IDC_R6,"");
}

void CZoomStep::OnChangeR7() 
{
	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_R7)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (rr.step[6]!=0) SetDlgItemInt(IDC_R7,rr.step[6]);
			else SetDlgItemText(IDC_R7,"");
}

void CZoomStep::OnChangeR8() 
{
	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_R8)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (rr.step[7]!=0) SetDlgItemInt(IDC_R8,rr.step[7]);
			else SetDlgItemText(IDC_R8,"");
}

void CZoomStep::OnChangeR9() 
{
	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_R9)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (rr.step[8]!=0) SetDlgItemInt(IDC_R9,rr.step[8]);
			else SetDlgItemText(IDC_R9,"");
}

void CZoomStep::OnChangeR10() 
{
	ZOOMSTEP ee, rr;
	CString newsv;
    BZoomGetScaleSteps(&ee, &rr);
    GetDlgItem(IDC_R10)->GetWindowText(newsv);
	if (newsv=="") return;
	bool notNumber=false;
	for (int i=0;i<newsv.GetLength() && notNumber==false;i++)
		if ((char)(newsv[i])<48 || (char)newsv[i]>57) notNumber=true;
	if (notNumber)
		if (rr.step[9]!=0) SetDlgItemInt(IDC_R10,rr.step[9]);
			else SetDlgItemText(IDC_R10,"");
}

void CCustomZoom::OnChangeEdit1() 
{
	CString newmedit;
    GetDlgItem(IDC_EDIT1)->GetWindowText(newmedit);
	bool notNumber=false;
	for (int i=0;i<newmedit.GetLength() && notNumber==false;i++)
		if ((char)(newmedit[i])<48 || (char)newmedit[i]>57) notNumber=true;
	if (notNumber) SetDlgItemInt(IDC_EDIT1,m_edit1);

	
}

void CCustomZoom::OnChangeEdit2() 
{
	CString newmedit;
    GetDlgItem(IDC_EDIT2)->GetWindowText(newmedit);
	bool notNumber=false;
	for (int i=0;i<newmedit.GetLength() && notNumber==false;i++)
		if ((char)(newmedit[i])<48 || (char)newmedit[i]>57) notNumber=true;
	if (notNumber) SetDlgItemInt(IDC_EDIT2,m_edit1);
}

void CDlgScale::OnChangeXAxis() 
{
	CString newmedit;
    GetDlgItem(IDC_X_AXIS)->GetWindowText(newmedit);
	bool notNumber=false;
	for (int i=0;i<newmedit.GetLength() && notNumber==false;i++)
		if ((char)(newmedit[i])<48 || (char)newmedit[i]>57) notNumber=true;
	if (notNumber) SetDlgItemInt(IDC_X_AXIS,(int)(pDoc->dwWidth), FALSE);
}

void CDlgScale::OnChangeYAxis() 
{
	CString newmedit;
    GetDlgItem(IDC_Y_AXIS)->GetWindowText(newmedit);
	bool notNumber=false;
	for (int i=0;i<newmedit.GetLength() && notNumber==false;i++)
		if ((char)(newmedit[i])<48 || (char)newmedit[i]>57) notNumber=true;
	if (notNumber) SetDlgItemInt(IDC_Y_AXIS,(int)(pDoc->dwHeight), FALSE);
}

void CDlgSkew::OnChangeDistance() 
{
	CString newmedit;
    GetDlgItem(IDC_DISTANCE)->GetWindowText(newmedit);
	bool notNumber=false;
	for (int i=0;i<newmedit.GetLength() && notNumber==false;i++)
		if ((char)(newmedit[i])<48 || (char)newmedit[i]>57) notNumber=true;
	if (notNumber) SetDlgItemInt(IDC_DISTANCE, 0, TRUE);
}

void CDlgRotate::OnChangeDegree() 
{
	CString newmedit;
    GetDlgItem(IDC_DEGREE)->GetWindowText(newmedit);
	bool notNumber=false;
	for (int i=0;i<newmedit.GetLength() && notNumber==false;i++)
		if ((char)(newmedit[i])<48 || (char)newmedit[i]>57) notNumber=true;
	if (notNumber) SetDlgItemInt(IDC_DEGREE,  0, TRUE);
}

void CHalftoneDlg::OnChangeEdit1() 
{
	CString newmedit;
    GetDlgItem(IDC_EDIT1)->GetWindowText(newmedit);
	bool notNumber=false;
	if (((char)newmedit[0]<48 || (char)newmedit[0]>57) && newmedit[0]!='-') notNumber=true;
	for (int i=1;i<newmedit.GetLength() && notNumber==false;i++)
		if ((char)(newmedit[i])<48 || (char)newmedit[i]>57) notNumber=true;
	if (notNumber) SetDlgItemInt(IDC_EDIT1, m_Intensity);

}
