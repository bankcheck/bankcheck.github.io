// logsview.cpp : implementation file
//

#include "stdafx.h"
#include "faxcpp.h"        
#include "resource.h"
extern "C" {
	#include "bitiff.h"
}
#include "imgdoc.h"
#include "dialogs.h"
#include "faxdlg.h"
//#include "faxdoc.h"
#include "demo.h"
#include "logs.h"
#include "logsview.h"
#include "logsfram.h"

#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif

//#define IDL_LISTBOX 381
#define IDB_EMPTY   382
#define IDB_DATE    383
#define IDB_TIME    384
#define IDB_NAME    385
#define IDB_PAGE    386
#define IDB_NUMBER  387

#define NARROW      60
#define BROAD       180
#define POS_ICON    0
#define POS_DATE    NARROW
#define POS_TIME    (NARROW+NARROW)
#define POS_NAME    (NARROW+NARROW+NARROW)
#define POS_PAGE    (NARROW+NARROW+NARROW+BROAD)
#define POS_NUMBER  (NARROW+NARROW+NARROW+BROAD+NARROW)
#define POS_END     (NARROW+NARROW+NARROW+BROAD+NARROW+BROAD)

#define POS_BORDERHIGH  20

#ifdef  WIN32
#define GET_WM_COMMAND_ID(wParam, lParam)   (LOWORD (wParam))
#define GET_WM_COMMAND_CMD(wParam, lParam)  (HIWORD (wParam))
#else
#define GET_WM_COMMAND_ID(wParam, lParam)   (wParam)
#define GET_WM_COMMAND_CMD(wParam, lParam)  (HIWORD (lParam))
#endif

/////////////////////////////////////////////////////////////////////////////
// CLogsView

IMPLEMENT_DYNCREATE(CLogsView, CView)

CLogsView::CLogsView()
{
    ListBox= new CListBox;
    btEmpty= new CBitmapButton;
    btDate= new CBitmapButton;
    btTime= new CBitmapButton;
    btName= new CBitmapButton;
    btNumber= new CBitmapButton;
    btPage= new CBitmapButton;
    iSortType= 0;
}

CLogsView::~CLogsView()
{
    delete ListBox;
    delete btEmpty;
    delete btDate;
    delete btTime;
    delete btName;
    delete btNumber;
    delete btPage;
}

BEGIN_MESSAGE_MAP(CLogsView, CView)
    //{{AFX_MSG_MAP(CLogsView)
    ON_WM_CREATE()
    ON_WM_DESTROY()
    ON_WM_SIZE()
    ON_WM_DRAWITEM()
    ON_WM_MEASUREITEM()
    ON_WM_COMPAREITEM()
    ON_WM_DELETEITEM()
    ON_COMMAND(IDB_DATE, OnSortDate)
    ON_COMMAND(IDB_TIME, OnSortTime)
    ON_COMMAND(IDB_NAME, OnSortName)
    ON_COMMAND(IDB_PAGE, OnSortPage)
    ON_COMMAND(IDB_NUMBER, OnSortNumber)
    ON_COMMAND(ID_FILE_PRINT, OnFilePrint)
    ON_UPDATE_COMMAND_UI(ID_FILE_PRINT, OnUpdateFilePrint)
    ON_WM_RBUTTONDBLCLK()
    ON_WM_KEYDOWN() 
    ON_WM_VKEYTOITEM()
    ON_WM_SETFOCUS()
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CLogsView drawing

void CLogsView::OnDraw(CDC* pDC)
{
    ListBox->UpdateWindow();
}

/////////////////////////////////////////////////////////////////////////////
// CLogsView message handlers
int CLogsView::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
    if (CView::OnCreate(lpCreateStruct) == -1)
        return -1;

    btEmpty->Create("", WS_CHILD|WS_VISIBLE|BS_OWNERDRAW, CRect(POS_ICON, 0, POS_DATE, POS_BORDERHIGH), this, IDB_EMPTY);
    btDate->Create("", WS_CHILD|WS_VISIBLE|BS_OWNERDRAW, CRect(POS_DATE, 0, POS_TIME, POS_BORDERHIGH), this, IDB_DATE);
    btTime->Create("", WS_CHILD|WS_VISIBLE|BS_OWNERDRAW, CRect(POS_TIME, 0, POS_NAME, POS_BORDERHIGH), this, IDB_TIME);
    btName->Create("", WS_CHILD|WS_VISIBLE|BS_OWNERDRAW, CRect(POS_NAME, 0, POS_PAGE, POS_BORDERHIGH), this, IDB_NAME);
    btPage->Create("", WS_CHILD|WS_VISIBLE|BS_OWNERDRAW, CRect(POS_PAGE, 0, POS_NUMBER, POS_BORDERHIGH), this, IDB_PAGE);
    btNumber->Create("", WS_CHILD|WS_VISIBLE|BS_OWNERDRAW, CRect(POS_NUMBER, 0, POS_END, POS_BORDERHIGH), this, IDB_NUMBER);

    ListBox->Create(WS_CHILD | WS_VSCROLL | WS_TABSTOP | WS_VISIBLE | LBS_OWNERDRAWFIXED | LBS_STANDARD | LBS_SORT | LBS_NOTIFY | LBS_NOINTEGRALHEIGHT |
        LBS_WANTKEYBOARDINPUT, CRect(0,0,1,1), this, IDL_LISTBOX);
    return 0;
}

void CLogsView::OnDestroy()
{
    int i, ItemNum= ListBox->GetCount();
    
    for ( i = 0 ; i < ItemNum ; i++ )
        delete (TSViewFaxBlock *)ListBox->GetItemDataPtr(i);
}

void CLogsView::OnSize(UINT nType, int cx, int cy)
{
    CView::OnSize(nType, cx, cy);
    
    ListBox->MoveWindow(0, POS_BORDERHIGH, cx, cy-POS_BORDERHIGH, TRUE);
//    if (cx < POS_END) MoveWindow(0, 0, POS_END, cy, TRUE);
}

void CLogsView::DrawButton( LPSTR chTitle, LPDRAWITEMSTRUCT lpDrawItemStruct, CDC &DC )
{
    COLORREF    crBtnF = GetSysColor(COLOR_BTNFACE);
    int         lastMode;
    CSize       TextLength;
    CBrush      lt2( crBtnF );
    CRect       rc = lpDrawItemStruct->rcItem, rcText  ;
    CPen        LightPen( PS_SOLID, 1, RGB(255,255,255));
    CPen        DarkPen( PS_SOLID, 1, RGB(0,0,0));
    CPen        *OldPen;

    TextLength = DC.GetTextExtent( chTitle, _fstrlen(chTitle) );
    rcText.left  = (rc.Width()-TextLength.cx)>>1;
    rcText.top   = 0;
    rcText.right = rc.Width() - rcText.left;
    rcText.bottom = rc.Height() ;
    DC.FillRect( &lpDrawItemStruct->rcItem, &lt2 );
    if ( lpDrawItemStruct->itemState & ODS_SELECTED ) {
        OldPen = DC.SelectObject( &DarkPen );
        DC.MoveTo( rc.left+1, rc.bottom-1 );
        DC.LineTo( rc.left+1, rc.top );
        DC.LineTo( rc.right-1, rc.top );
        DC.SelectObject( &LightPen );
        DC.LineTo( rc.right-1, rc.bottom-1 );
        DC.LineTo( rc.left+1, rc.bottom-1 );
        lastMode= DC.SetBkMode(TRANSPARENT);
        rcText.left++; rcText.top++; rcText.right++; rcText.bottom++;
        DC.SetTextColor(RGB(255,255,255));
        DC.DrawText( chTitle, -1, &rcText, DT_SINGLELINE|DT_VCENTER );
        rcText.left++; rcText.top++; rcText.right++; rcText.bottom++;
        DC.SetTextColor(RGB(0,0,0));
        DC.DrawText( chTitle, -1, &rcText, DT_SINGLELINE|DT_VCENTER );
    }
    else {
        OldPen = DC.SelectObject( &LightPen );
        DC.MoveTo( rc.left+1, rc.bottom-1 );
        DC.LineTo( rc.left+1, rc.top );
        DC.LineTo( rc.right-1, rc.top );
        DC.SelectObject( &DarkPen );
        DC.LineTo( rc.right-1, rc.bottom-1 );
        DC.LineTo( rc.left+1, rc.bottom-1 );
        lastMode= DC.SetBkMode(TRANSPARENT);
        DC.SetTextColor(RGB(255,255,255));
        DC.DrawText( chTitle, -1, &rcText, DT_SINGLELINE|DT_VCENTER );
        rcText.left++; rcText.top++; rcText.right++; rcText.bottom++;
        DC.SetTextColor(RGB(0,0,0));
        DC.DrawText( chTitle, -1, &rcText, DT_SINGLELINE|DT_VCENTER );
    }
    DC.SelectObject( OldPen );
    DC.SetBkMode (lastMode);
}

void CLogsView::OnDrawItem(int nIDCtl, LPDRAWITEMSTRUCT lpDrawItemStruct)
{
    CDC     DC;
    DC.Attach(lpDrawItemStruct->hDC);
    int     y= lpDrawItemStruct->rcItem.top;
    CFont   Font,*cOldFont;

    if ( Font.CreateFont(12, 0, 0, 0, FW_LIGHT, 0, 0, 0, 
                            ANSI_CHARSET, 
                            OUT_DEFAULT_PRECIS,
                            CLIP_DEFAULT_PRECIS,
                            DEFAULT_QUALITY, 
                            DEFAULT_PITCH, 
                            "MS Sans Serif")){
        cOldFont = (CFont*)DC.SelectObject(&Font);
    }    

    switch ( nIDCtl ) {
        case IDB_EMPTY:
            DrawButton( "", lpDrawItemStruct, DC );
            break;
        case IDB_DATE :
            DrawButton( "Date", lpDrawItemStruct, DC );
            break;
        case IDB_TIME :
            DrawButton( "Time", lpDrawItemStruct, DC );
            break;
        case IDB_NAME:
            DrawButton( "Name (ID)", lpDrawItemStruct, DC );
            break;
        case IDB_PAGE:
            DrawButton( "Page", lpDrawItemStruct, DC );
            break;
        case IDB_NUMBER:
            DrawButton( "Phone Number", lpDrawItemStruct, DC );
            break;
        case IDL_LISTBOX : {
            CBrush br(DC.GetBkColor());
            DC.FillRect(&lpDrawItemStruct->rcItem, &br);
        
            int lastMode= DC.SetBkMode (TRANSPARENT);
        
            if (lpDrawItemStruct->itemState & ODS_SELECTED) {
                CBrush br(RGB(0, 0xFF, 0));
                DC.FillRect(&lpDrawItemStruct->rcItem, &br);
                DC.DrawFocusRect(&lpDrawItemStruct->rcItem);
            }    
            if (lpDrawItemStruct->itemData != NULL && lpDrawItemStruct->itemData != DWORD(-1)) {
                TSViewFaxBlock *vfb= (TSViewFaxBlock *)lpDrawItemStruct->itemData;
                
                if (vfb->DocIcon) {
                    DC.DrawIcon(lpDrawItemStruct->rcItem.left+10
                            ,lpDrawItemStruct->rcItem.top
                            ,vfb->DocIcon);
                }
                if (vfb->DocError) {
                    DC.DrawIcon(lpDrawItemStruct->rcItem.left+10
                                ,lpDrawItemStruct->rcItem.top
                                ,vfb->DocError);
                }
                CRect rc ;
                rc = lpDrawItemStruct->rcItem  ;
                rc.left  = POS_DATE ;
                rc.right = POS_TIME ;
                DC.DrawText(vfb->Date,-1,&rc,DT_SINGLELINE|DT_VCENTER|DT_CENTER);
                rc.left  = POS_TIME ;
                rc.right = POS_NAME;
                DC.DrawText(vfb->Time,-1,&rc,DT_SINGLELINE|DT_VCENTER|DT_CENTER);
                rc.left  = POS_NAME ;
                rc.right = POS_PAGE ;
                DC.DrawText(vfb->Name,-1,&rc,DT_SINGLELINE|DT_VCENTER);
                rc.left  = POS_PAGE ;
                rc.right = POS_NUMBER ;
                DC.DrawText(vfb->PageNumber,-1,&rc,DT_SINGLELINE|DT_VCENTER|DT_CENTER);
                rc.left  = POS_NUMBER ;
                rc.right = lpDrawItemStruct->rcItem.right   ;
                DC.DrawText(vfb->PhoneNumber,-1,&rc,DT_SINGLELINE|DT_VCENTER);
            }
            DC.SetBkMode (lastMode);
        }
    }
    DC.SelectObject(cOldFont);
    DC.Detach();
}

void CLogsView::OnMeasureItem(int /*nIDCtl*/, LPMEASUREITEMSTRUCT lpMeasureItemStruct)
{
    lpMeasureItemStruct->itemHeight= 18;    
}

int CLogsView::OnCompareItem(int /*nIDCtl*/, LPCOMPAREITEMSTRUCT lpCompareItemStruct)
{
    TSViewFaxBlock *vfb1= (TSViewFaxBlock *)lpCompareItemStruct->itemData1;
    TSViewFaxBlock *vfb2= (TSViewFaxBlock *)lpCompareItemStruct->itemData2;

    LPSTR Comp1= NULL;
    LPSTR Comp2= NULL;
    int tmp;

    switch ( iSortType ) {
        case 0: 
            Comp1= vfb2->Date; 
            Comp2= vfb1->Date; 
            tmp = lstrcmpi(Comp1, Comp2);
            if(tmp==0)
            {                               /* if the date is the same */
                Comp1= vfb2->Time; 
                Comp2= vfb1->Time; 
            }
            break;
        case 1: 
            Comp1= vfb2->Time; 
            Comp2= vfb1->Time; 
            break;
        case 2: 
            Comp1= vfb1->Name; 
            Comp2= vfb2->Name; 
            break;
        case 3: 
            Comp1= vfb1->PageNumber;
            Comp2= vfb2->PageNumber;
            break;
        case 4: 
            Comp1= vfb1->PhoneNumber; 
            Comp2= vfb2->PhoneNumber; 
            break;
    }
    if (Comp1 && Comp2)
    {
        return lstrcmpi(Comp1, Comp2);
    }
    return 0;
}

void CLogsView::OnDeleteItem( int nIDCtl, LPDELETEITEMSTRUCT lpDeleteItemStruct )
{
}

BOOL CLogsView::AddNewLine(TSViewFaxBlock *FaxBlock)
{
    TSViewFaxBlock *vfb= new TSViewFaxBlock;
    vfb[0]= FaxBlock[0];

    int in= ListBox->AddString(LPSTR(vfb));
    if ( in == LB_ERR || in == LB_ERRSPACE ) {
        delete vfb;
        return FALSE;
    }
    ListBox->SetCurSel(in);
    WriteState();
    return TRUE;
}

BOOL CLogsView::DeleteLine(int ID)
{
    int ItemNum= ListBox->GetCount();
    int act= ListBox->GetCurSel();
    int actID= -1;
    TSViewFaxBlock *vfb= NULL;

    if (act != LB_ERR) {    
        vfb= (TSViewFaxBlock *)ListBox->GetItemDataPtr(act);
        if (vfb->ID == ID) {
            ListBox->DeleteString(act);
            _unlink( vfb->szFileName );
            ClearState();
            delete vfb;
            act--;
            if (act < 0) act= 0;
            if (ItemNum > 1) ListBox->SetCurSel(act);
            WriteState();
            return TRUE;
        }
        actID= vfb->ID;
    }
    for (int i= 0; i < ItemNum; i++) {
        vfb= (TSViewFaxBlock *)ListBox->GetItemDataPtr(i);
        if (vfb->ID == ID) {
            ListBox->DeleteString(i);
            delete vfb;
            if (actID >= 0) {
                for (int i= 0; i < ItemNum - 1; i++) {
                    vfb= (TSViewFaxBlock *)ListBox->GetItemDataPtr(i);
                    if (vfb->ID == actID) {
                        ListBox->SetCurSel(i);
                        WriteState();
                        return TRUE;
                    }
                }
            }
            return TRUE;
        }
    }
    return FALSE;
}

int CLogsView::GetFName(int ID, LPSTR szName)
{
    TSViewFaxBlock *vfb= NULL;
    int i, ItemNum = ListBox->GetCount();

    for ( i=0 ; i<ItemNum ; i++ ) {
        vfb= (TSViewFaxBlock *)ListBox->GetItemDataPtr(i);
        if (vfb->ID == ID) {
            _fstrcpy( szName, vfb->szFileName );
            return TRUE;
        }
    }
    return FALSE;
}

int CLogsView::GetNotUsedID()
{
    int ItemNum= ListBox->GetCount();

    BOOL *used= new BOOL[ItemNum+1];
	int i;
    for (i= 0; i <= ItemNum; used[i++]= FALSE);

    for (i= 0; i < ItemNum; i++) {
        TSViewFaxBlock *vfb= (TSViewFaxBlock *)ListBox->GetItemDataPtr(i);
        if (vfb->ID <= ItemNum) used[vfb->ID]= TRUE;
    }
    for (i= 0; i <= ItemNum && used[i]; i++);
    delete used;

    return i;
}

BOOL CLogsView::DeleteAllLine()
{
    int ItemNum= ListBox->GetCount();

    for (int i= 0; i < ItemNum; i++)
        delete (TSViewFaxBlock *)ListBox->GetItemDataPtr(i);
    ListBox->ResetContent();

    return TRUE;
}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void CLogsView::OnSortDate()
{
    ChangeSort(0);
}

void CLogsView::OnSortTime()
{
    ChangeSort(1);
}

void CLogsView::OnSortName()
{
    ChangeSort(2);
}

void CLogsView::OnSortPage()
{
    ChangeSort(3);
}

void CLogsView::OnSortNumber()
{
    ChangeSort(4);
}

void CLogsView::ChangeSort(int Type)
{
    iSortType= Type;

    int ItemNum= ListBox->GetCount();

    if (ItemNum <= 0) return;
    
    TSViewFaxBlock **pvfb= (TSViewFaxBlock **) new char[ItemNum * sizeof(TSViewFaxBlock *)];
    
    int act= ListBox->GetCurSel();
    
    int actID= -1;
    if (act != LB_ERR) {
        actID= ((TSViewFaxBlock *)ListBox->GetItemDataPtr(act))->ID;
    }
	int i;
    for (i= 0; i < ItemNum; i++) {
        pvfb[i]= (TSViewFaxBlock *)ListBox->GetItemDataPtr(i);
    }
    ListBox->ResetContent();
    
    for (i= 0; i < ItemNum; i++) {
        ListBox->AddString((LPSTR)(pvfb[i]));
    }
    if (actID >= 0) {
        for (i= 0; i < ItemNum; i++) {
            if (((TSViewFaxBlock *)ListBox->GetItemDataPtr(i))->ID == actID) {
                ListBox->SetCurSel(i);
                WriteState();
                break;
            }
        }
    }
    delete (char *)pvfb;

    ListBox->Invalidate(FALSE);
    ListBox->UpdateWindow();
    ListBox->SetFocus();
}

void CLogsView::ClearState()
{
    ((CLogs*)GetDocument())->ClearStatus();
}

void CLogsView::WriteState()
{
    int act ;
    TSViewFaxBlock *vfb ;

    act= ListBox->GetCurSel();
    if ( act >= 0 ) {
        vfb = (TSViewFaxBlock *)ListBox->GetItemData(act);
        if ( vfb ) 
            ((CLogs*)GetDocument())->WriteStatus( vfb );
    }
}

LRESULT CLogsView::WindowProc(UINT message, WPARAM wParam, LPARAM lParam)
{
    int act ;
    TSViewFaxBlock *vfb ;
	 
    if ( message == WM_COMMAND ) {
        if ((GET_WM_COMMAND_ID(wParam,lParam) ==IDL_LISTBOX ) &&
                        (GET_WM_COMMAND_CMD(wParam,lParam)==LBN_DBLCLK) ) {
            CImgApp* pApp = (CImgApp*)   AfxGetApp();

            act= ListBox->GetCurSel();
            if ( act >=0 ) {
                vfb= (TSViewFaxBlock *)ListBox->GetItemData(act);
                if ( vfb ) {
                    if ( strcmp(vfb->PageNumber,"0") != 0 ) {
                        CFile   BlockFile;
                        CFileException e;

                        if ( BlockFile.Open( vfb->szFileName, CFile::modeRead, &e ) == 0 )
                            return 0;
                        pApp->ShowFaxBlock(vfb->Type, vfb->ID, FALSE, (HFILE)BlockFile.m_hFile );
                        BlockFile.Close();
						    } else {
                        MessageBeep(0);
                    }
                }   
            }   
            return 0 ;
        }
        if ( (GET_WM_COMMAND_ID(wParam,lParam) ==IDL_LISTBOX ) && 
                                ( GET_WM_COMMAND_CMD(wParam,lParam)==LBN_SELCHANGE ) )
            WriteState();
    }
    return CView::WindowProc(message,wParam,lParam) ;
}

int CLogsView::OnVKeyToItem(UINT nKey, CListBox *pListBox, UINT nIndex)
{
    if(nKey==VK_DELETE)
    {
        DoingDelKey();
        return -2;
    }                       
    nIndex = nIndex;
    pListBox = pListBox;
    return -1;
}

void CLogsView::OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags)
{
    if(nChar==VK_DELETE)
    {
        DoingDelKey();
    }
    else    
    {
        CView::OnKeyDown(nChar, nRepCnt, nFlags);
    }   

}

void CLogsView::DoingDelKey()
{
    if(ListBox==NULL)
        return;
        
    int index = ListBox->GetCurSel();
    if(index<0)
        return;
     
    int nret = AfxMessageBox("Are you sure want to delete an item?", MB_YESNO);     
    if(nret!=IDYES)
        return;
    
    TSViewFaxBlock *vfb= (TSViewFaxBlock *)ListBox->GetItemDataPtr(index);
    int id = vfb->ID;
    
    CLogs *logs = (CLogs *)GetDocument();
    if(logs==NULL)
        return;  
    logs->DeleteFaxBlockk(id);
}

void CLogsView::OnSetFocus(CWnd *)
{
    if ( ListBox )
        ListBox->SetFocus();    
}

int CLogsView::GetItemCount()
{
    if ( ListBox )
        return ListBox->GetCount();
    else
        return -1;
}

/////////////////////////////////////////////////////////////////////////////
// CLogsView Printing support
void CLogsView::NewPage( CDC *pPrintDC, CRect *rcPage, int PageNum, int cyChar )
{
    char    szPage[16], szNum[8];

    pPrintDC->TextOut( rcPage->left, rcPage->top, strHeader );
    rcPage->top += cyChar + cyChar / 4;
    pPrintDC->MoveTo( rcPage->left, rcPage->top );
    pPrintDC->LineTo( rcPage->right, rcPage->top );
    rcPage->top += cyChar / 4;

    itoa( PageNum, szNum, 10 );
    _fstrcpy( szPage, "Page " );
    _fstrcat( szPage, szNum );
    rcPage->bottom -= cyChar;
    pPrintDC->TextOut( rcPage->left, rcPage->bottom, szPage );
    rcPage->bottom -= cyChar / 4;
    pPrintDC->MoveTo( rcPage->left, rcPage->bottom );
    pPrintDC->LineTo( rcPage->right, rcPage->bottom );
    rcPage->bottom -= cyChar / 4;    
}                                    

void CLogsView::OnFilePrint()
{   
    CDC    *pPrintDC = ((CImgApp *)AfxGetApp())->GetPrinterCDC();
    int     cxPage, cyPage, cyChar, i, PageNum;
    TEXTMETRIC tm;
    char    szActLine[256];
    TSViewFaxBlock far *vfb;
    CRect   rcPage;
    CSize   vpext;
    DOCINFO doc;

    if ( pPrintDC ) {
        PageNum = 1;
        pPrintDC->SetMapMode( MM_LOENGLISH );
        pPrintDC->SetMapMode( MM_ANISOTROPIC );
        vpext = pPrintDC->GetViewportExt();
        if ( vpext.cy < 0 )
            vpext.cy = -vpext.cy;
        pPrintDC->SetViewportExt( vpext );
        switch( ((CLogs*)GetDocument())->LogType ) {
            case LGT_SEND:
                strHeader = "Send Log";
                break;

            case LGT_RECEIVE:
                strHeader = "Receive Log";
                break;

            case LGT_OUTBOX:
                strHeader = "Out Box";
                break;
        }
        pPrintDC->GetTextMetrics(&tm);
        cyChar = tm.tmHeight;
    
        m_fontPrint = new CFont;
        if ( m_fontPrint ) {
            if ( m_fontPrint->CreateFont(12, 0, 0, 0, FW_LIGHT, 0, 0, 0, ANSI_CHARSET, 
                        OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, 
                        DEFAULT_PITCH, "Courier") ) {
                m_fontOld = (CFont*)pPrintDC->SelectObject(m_fontPrint);
                cxPage = pPrintDC->GetDeviceCaps(HORZRES);
                cyPage = pPrintDC->GetDeviceCaps(VERTRES);
                rcPage.SetRect( 0, 0, cxPage, cyPage );
                pPrintDC->DPtoLP( &rcPage );
                doc.cbSize = sizeof( doc );
                doc.lpszDocName = "DocName";
                doc.lpszOutput = NULL;
                i = pPrintDC->StartDoc( &doc );
                i = pPrintDC->StartPage();
                NewPage( pPrintDC, &rcPage, PageNum, cyChar );

                PrintActLine = 0;
                while ( 1 ) {
                    vfb = (TSViewFaxBlock far *)ListBox->GetItemDataPtr( PrintActLine++ );
                    if ( vfb == (TSViewFaxBlock far *)-1 ) {
                        break;
                    }
                    else {
                        _fmemset( szActLine, 0, sizeof(szActLine) );
                        _fstrcpy( &szActLine[0], vfb->Date );
                        _fstrcpy( &szActLine[DATEBUFF_SIZE], vfb->Time );
                        _fstrcpy( &szActLine[DATEBUFF_SIZE+TIMEBUFF_SIZE], vfb->Name );
                        _fstrcpy( &szActLine[DATEBUFF_SIZE+TIMEBUFF_SIZE+NAMEBUFF_SIZE],
                                            vfb->PageNumber );
                        _fstrcpy( &szActLine[DATEBUFF_SIZE+TIMEBUFF_SIZE+NAMEBUFF_SIZE+6],
                                            vfb->PhoneNumber );
                        for ( i=0 ; i < DATEBUFF_SIZE+TIMEBUFF_SIZE+NAMEBUFF_SIZE+6 ; i++ ) {
                            if ( !szActLine[i] )
                                szActLine[i] = 32;
                        }
                        pPrintDC->TextOut(rcPage.left, rcPage.top, szActLine );
                        rcPage.top += cyChar + cyChar / 4;
                        if ( (rcPage.bottom - rcPage.top) < (cyChar + cyChar / 4) ) {
                            pPrintDC->EndPage();
                            pPrintDC->SelectObject( m_fontOld );
                            pPrintDC->SetMapMode( MM_LOENGLISH );
                            pPrintDC->SetMapMode( MM_ANISOTROPIC );
                            pPrintDC->SetViewportExt( vpext );
                            m_fontOld = (CFont*)pPrintDC->SelectObject(m_fontPrint);
                            PageNum++;
                            rcPage.SetRect( 0, 0, cxPage, cyPage );
                            pPrintDC->DPtoLP( &rcPage );
                            pPrintDC->StartPage();
                            NewPage( pPrintDC, &rcPage, PageNum, cyChar );
                        }
                    }
                }
                pPrintDC->EndPage();
                pPrintDC->EndDoc();
            }
            pPrintDC->SelectObject(m_fontOld);
            delete m_fontPrint;
        }
        delete pPrintDC;
    }
}

void CLogsView::OnUpdateFilePrint(CCmdUI* pCmdUI)
{
    pCmdUI->Enable( ListBox->GetCount() );
}
