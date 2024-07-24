
#include "stdafx.h"

//#include "resource.h"       // main symbols 
//#include "imgdoc.h"
//#include "inputvw.h"

#include "v_config.h"

extern "C" {
	#include "bitiff.h"
	#include "bidisp.h"
    #include "cals.h"
#if JPEG_EXIST == 1
    #include "bijpeg.h"
#endif
};  

#pragma warning(disable:4103)
        
#include "faxcpp.h"        
  
#include "resource.h"  

#include "magnifyw.h"
#include "disp.h"
#include "imgvw.h"
#include "imgdoc.h"
#include "dialogs.h"
#include "faxdlg.h"
#include "demo.h"
#include "mainfrm.h"
#include "inputvw.h"

#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CInputView

IMPLEMENT_DYNCREATE(CInputView, CFormView)

CInputView::CInputView()
    : CFormView(IDD_INPUTFORM)
{
    //{{AFX_DATA_INIT(CInputView)
    //}}AFX_DATA_INIT
    
            
    nRightMargin  = 0;
    nMinWidth     = 0;
    
}

CInputView::~CInputView()
{
}

CImgDoc *CInputView::GetDocument()
{
    ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CImgDoc)));
    return (CImgDoc*) m_pDocument;
}

        
static LPSTR MakeStatText(WORD wStat)
{
    switch(wStat)
    {
        case STAT_MONO:
                return "MONO";
        case STAT_DITH:
                return "DITH";
        case STAT_BFT:
                return "BFT ";
    }                                   
    return "?   ";
}        

BOOL CInputView::MakeListBoxRow(int nSel, LPSTR buf)
{       
    CString str;
    int ln;     
    LPSTR ptr_name, ptr_stat;
    WORD wStat;
    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
        return FALSE;
    str = pDoc->arName.GetAt(nSel); 
    if(str.IsEmpty()) 
        return FALSE;
    ln = str.GetLength();   
    if(ln==0)
        return FALSE;
    ptr_name = str.GetBuffer(ln+1);
    wStat = pDoc->arStat.GetAt(nSel);
    ptr_stat = MakeStatText(wStat); 
    wsprintf(buf, "%s - %s", ptr_stat, ptr_name);
    return TRUE;
}       

void CInputView::OnInitialUpdate()
{
    CFormView::OnInitialUpdate();
    
    BOOL bOk;
    CFont cfont;
    bOk = cfont.CreateStockObject(ANSI_FIXED_FONT);
    if(bOk)
    {
        CListBox *lBox = (CListBox *)GetDlgItem(IDC_LIST1);
        if(lBox)
        {
            lBox->SetFont(&cfont);
            cfont.Detach();       
        }   
    }
}
        
void CInputView::OnUpdate(CView*, LPARAM hint, CObject*)
{        
    if(hint==0)
        return;

    int ln;     
    BOOL bOk;       
    CImgDoc *pDoc = GetDocument();
    if(pDoc==NULL)
        return;
        
    CListBox *lBox = (CListBox *)GetDlgItem(IDC_LIST1);
    if(lBox==NULL)
        return;
        
    ln = pDoc->GroupFileName.GetLength();       
    if(ln)      
        SetDlgItemText(IDC_GROUP, pDoc->GroupFileName.GetBuffer(ln+1) );        
        
    int nSiz = pDoc->arName.GetSize();
    lBox->ResetContent();   
    SetDlgItemInt(IDC_GNUM, nSiz);
    
    int nSel;

    if(nSiz)
    {   
        nSel = 0;
        char buf[250];
        for(int jj=0; jj<nSiz; jj++)
        {   
            bOk = MakeListBoxRow(jj, buf);
            if(bOk)
                lBox->AddString(buf);
        }   
        SetHorzExtent(lBox);
        lBox->SetCurSel(nSel);                                                              
    }
    else
    {
        nSel = -1;
        GetDlgItem(IDC_REMOVE)->EnableWindow(FALSE);
    }   
    
    SetDlgItemInt(IDC_NACT, nSel+1);
    UpdateButtons(nSel, nSiz);
}
    

void CInputView::DoDataExchange(CDataExchange* pDX)
{
    CFormView::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CInputView)
    //}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CInputView, CFormView)
    //{{AFX_MSG_MAP(CInputView)
    ON_LBN_SELCHANGE(IDC_LIST1, OnSelchangeList1)
    ON_LBN_DBLCLK(IDC_LIST1, OnDblclkList1)
    ON_BN_CLICKED(IDC_REMOVE, OnRemove)
    ON_BN_CLICKED(IDC_ADD, OnAdd)
    ON_BN_CLICKED(IDC_BFT, OnBft)
    ON_BN_CLICKED(IDC_GRPSAVE, OnGrpsave)
    ON_WM_SIZE()
    ON_WM_SHOWWINDOW()
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()


BOOL CInputView::qryListbox(int &nSel, int &nSiz)
{
    CImgDoc *pDoc = GetDocument();        
    if(pDoc==NULL)
        return FALSE;
    CListBox *lBox = (CListBox *)GetDlgItem(IDC_LIST1);
    if(lBox==NULL)
        return FALSE;
    nSel = lBox->GetCurSel();
    if(nSel < 0)
        return FALSE;
    nSiz = pDoc->arName.GetSize();
    if(nSiz < 1)
        return FALSE;
    return TRUE;    
}

void CInputView::UpdateButtons(int nSel, int nSiz)
{
    CImgDoc *pDoc = GetDocument();        
    if(pDoc==NULL)
        return;
        
    WORD nStat;
    BOOL bEnb = FALSE;

    if(nSel>=0)
    {       
        nStat = pDoc->arStat.GetAt(nSel);
        bEnb = (nStat==STAT_MONO) ? FALSE : TRUE;
    }   
    GetDlgItem(IDC_BFT)->EnableWindow(bEnb);

//    bEnb = nSiz>1 ? TRUE : FALSE;
//    GetDlgItem(IDC_GRPSAVE)->EnableWindow(bEnb);
    nSiz = nSiz;
}


void CInputView::OnSelchangeList1()
{
    CImgDoc *pDoc = GetDocument();        
    int nSel, nSiz;
    BOOL bOk = qryListbox(nSel, nSiz);
    if(!bOk)
        return;
    
    CString str = pDoc->arName.GetAt(nSel);
    if( str.IsEmpty() )
        return;
    int ln = str.GetLength();
    if(ln==0)
        return;    
    pDoc->m_nFileFormat = pDoc->arType.GetAt(nSel);     
    char *ptr = str.GetBuffer(ln+1);
    pDoc->LoadImage(ptr, 0);                            
    SetDlgItemInt(IDC_NACT, nSel+1);

    UpdateButtons(nSel, nSiz);  
    
    pDoc->nGroupCurrent = nSel;
}

void CInputView::OnDblclkList1()
{
    // TODO: Add your control notification handler code here
    
}   

void CInputView::RemoveOne(int nSel)
{
    CImgDoc *pDoc = GetDocument();        
    pDoc->arName.RemoveAt(nSel);
    pDoc->arStat.RemoveAt(nSel);
    pDoc->arType.RemoveAt(nSel);
}


void CInputView::OnRemove()
{
    // TODO: Add your control notification handler code here
    CListBox *lBox = (CListBox *)GetDlgItem(IDC_LIST1);
    if(lBox==NULL)
        return;
    CImgDoc *pDoc = GetDocument();        
    int nSel, nSiz;
    BOOL bOk = qryListbox(nSel, nSiz);
    if(!bOk)
        return;
    
    if(nSiz < 1)
    {
        return;
    }    
        
    RemoveOne(nSel);
    lBox->DeleteString(nSel);       
    nSel--;
    if(nSel<0)
    {
        nSel = 0;    
    }
    lBox->SetCurSel(nSel);              
    
    if(nSiz > 1)
    {
        OnSelchangeList1();
    
        bOk = qryListbox(nSel, nSiz);
        if(bOk)
        {
            SetDlgItemInt(IDC_GNUM, nSiz);
        }
    }
    else
    {
        lBox->SetCurSel(-1);              
/**     
        if(pDoc->m_hDib)
        {
            GlobalFree( pDoc->m_hDib );
            pDoc->m_hDib = NULL;
        }
        pDoc->SetNewDib(NULL);        
**/

        pDoc->ClearDib();       
        
        SetDlgItemInt(IDC_GNUM, 0);
        SetDlgItemInt(IDC_NACT, 0);
    }       
}

void CInputView::OnAdd()
{
    // TODO: Add your control notification handler code here

    CString         newName;
    WORD            l_nFileFormat;
    
    CImgApp *pApp = (CImgApp *)AfxGetApp();
    
    l_nFileFormat = (WORD)pApp->PromptFaxFileName(newName);
    if(l_nFileFormat==0)
        return;
	//Pcx if state removed by Levente Nemethy
    if( l_nFileFormat==6  && GetNumberOfImagesInTiffFile(newName.GetBuffer(MAX_PATH))!=1 )            
        AfxMessageBox("Please don't add multipage image files!");
    else
        AddFile(newName,l_nFileFormat) ;
}   

void CInputView::SetHorzExtent(CListBox *lBox)
{         
    int extent = 0;       
    int ln;
    LPSTR ptr = NULL;
    CString str;
    CClientDC dc(lBox);;
    CSize siz;
    
    dc.SelectStockObject(ANSI_FIXED_FONT);
    
//    CFont cfont;
//    bOk = cfont.CreateStockObject(ANSI_FIXED_FONT);
          
    int num = lBox->GetCount();
    for(int jj=0; jj<num; jj++)
    {
        lBox->GetText(jj, str);
        ln = str.GetLength();
        if(ln==0)
        {
            continue;
        }   
        ptr = str.GetBuffer(ln+1);
        siz = dc.GetTextExtent(ptr, ln);
//      siz = dc.GetOutputTextExtent(ptr, ln);
        if(siz.cx > extent)
        {
            extent = siz.cx;        
        }
    }               
    
//  extent *= 5;
//  extent /= 4;

    extent += 20;
    
    lBox->SetHorizontalExtent(extent);
}                   

BOOL CInputView::AddFile(CString & newName,WORD nFileFormat)
{
    CImgDoc *pDoc = GetDocument();        
    if(pDoc==NULL)
        return FALSE ;
    CListBox *lBox = (CListBox *)GetDlgItem(IDC_LIST1);
    if(lBox==NULL)
        return FALSE ;

    int ln = newName.GetLength();
    if(ln < 1)
        return FALSE ;
                  
    LPSTR lpName = newName.GetBuffer(ln+1);          
    
    int nBits = pDoc->GetBitsPerPixel(lpName);          
    int nStat = (nBits==1) ? STAT_MONO : STAT_BFT;
             
    pDoc->arName.Add(newName);
    pDoc->arStat.Add((WORD)nStat);
    pDoc->arType.Add(nFileFormat);
    int nSiz = pDoc->arName.GetSize();
    int nSel = nSiz-1;
    
    char buf[200];  
    MakeListBoxRow(nSel, buf);
    lBox->AddString(buf);       
    SetHorzExtent(lBox);
    
    lBox->SetCurSel(nSel);              
    OnSelchangeList1();
    
    SetDlgItemInt(IDC_GNUM, nSiz);

    return TRUE ;
}

void CInputView::OnBft()
{
    // TODO: Add your control notification handler code here
    
    CListBox *lBox = (CListBox *)GetDlgItem(IDC_LIST1);
    if(lBox==NULL)
        return;
    CImgDoc *pDoc = GetDocument();        
    int nSel, nSiz;
    BOOL bOk = qryListbox(nSel, nSiz);
    if(!bOk)
        return;
        
    int nStat = pDoc->arStat.GetAt(nSel);
    if(nStat==STAT_MONO)
        return;
        
    nStat = (nStat==STAT_DITH) ? STAT_BFT : STAT_DITH;      
    
    pDoc->arStat.SetAt(nSel, (WORD)nStat);
    
    char buf[200];
    bOk = MakeListBoxRow(nSel, buf);
    if(bOk)
    {
        lBox->DeleteString(nSel);
        lBox->InsertString(nSel, buf);
        lBox->SetCurSel(nSel);
    }   
}


void CInputView::OnGrpsave()
{
    // TODO: Add your control notification handler code here
    CImgDoc *pDoc = GetDocument();        
    if(pDoc==NULL)
        return;

    CImgApp *pApp = (CImgApp *)AfxGetApp();
    BOOL bOk = pApp->PromptFaxSaveFileName(pDoc->GroupFileName);
    if(bOk==FALSE)
        return;
        
    char *ptr;      
    int ln = pDoc->GroupFileName.GetLength();
    if(ln)
    {
		pDoc->GroupFileName+=".FAX";
        ptr = pDoc->GroupFileName.GetBuffer(ln+1);          
        pDoc->SaveFaxGroup(ptr);        
        SetDlgItemText(IDC_GROUP, ptr);
    }   
}

void CInputView::OnSize(UINT nType, int cx, int cy)
{
    CFormView::OnSize(nType, cx, cy);
    CListBox *pListBox = (CListBox *)GetDlgItem(IDC_LIST1);
    if (pListBox) {
        CRect rcListBox ;
        CRect rcWindow   ;
        pListBox->GetWindowRect(&rcListBox);
        ScreenToClient(&rcListBox);
        GetClientRect(&rcWindow);
                
        rcListBox.right = rcWindow.right - rcListBox.left  ;
        if (rcListBox.Width()  < nMinWidth) {
            rcListBox.right = rcListBox.left + nMinWidth ;
        }   
        pListBox->MoveWindow(&rcListBox);    
    }
    
}

void CInputView::OnShowWindow(BOOL bShow, UINT nStatus)
{
    CFormView::OnShowWindow(bShow, nStatus);
    
    CFormView::OnInitialUpdate();
    if(nMinWidth == 0 ) {   
        CListBox *lBox = (CListBox *)GetDlgItem(IDC_LIST1);
        if(lBox)
        {
            CRect rcListBox ;
            CRect rcWindow   ;
            lBox->GetWindowRect(&rcListBox);
            ScreenToClient(&rcListBox);
            GetClientRect(&rcWindow);
            
            nRightMargin  = rcWindow.right - rcListBox.right;
            nMinWidth     = rcListBox.Width() ;
        }   
    }   
}

