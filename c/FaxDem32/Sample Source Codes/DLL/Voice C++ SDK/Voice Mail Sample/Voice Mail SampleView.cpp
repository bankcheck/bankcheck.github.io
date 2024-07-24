// Voice Mail SampleView.cpp : implementation of the CVoiceMailSampleView class
//

#include "stdafx.h"
#include "Voice Mail Sample.h"

#include "Voice Mail SampleDoc.h"
#include "Voice Mail SampleView.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CVoiceMailSampleView

IMPLEMENT_DYNCREATE(CVoiceMailSampleView, CView)

BEGIN_MESSAGE_MAP(CVoiceMailSampleView, CView)
	//{{AFX_MSG_MAP(CVoiceMailSampleView)
	ON_WM_CREATE()
	ON_WM_SIZE()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CVoiceMailSampleView construction/destruction

CVoiceMailSampleView::CVoiceMailSampleView()
{
}

CVoiceMailSampleView::~CVoiceMailSampleView()
{
}

BOOL CVoiceMailSampleView::PreCreateWindow(CREATESTRUCT& cs)
{
	// TODO: Modify the Window class or styles here by modifying
	//  the CREATESTRUCT cs

	return CView::PreCreateWindow(cs);
}

/////////////////////////////////////////////////////////////////////////////
// CVoiceMailSampleView drawing

void CVoiceMailSampleView::OnDraw(CDC* pDC)
{
	CVoiceMailSampleDoc* pDoc = GetDocument();
	ASSERT_VALID(pDoc);

	// TODO: add draw code for native data here
}

/////////////////////////////////////////////////////////////////////////////
// CVoiceMailSampleView diagnostics

#ifdef _DEBUG
void CVoiceMailSampleView::AssertValid() const
{
	CView::AssertValid();
}

void CVoiceMailSampleView::Dump(CDumpContext& dc) const
{
	CView::Dump(dc);
}

CVoiceMailSampleDoc* CVoiceMailSampleView::GetDocument() // non-debug version is inline
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CVoiceMailSampleDoc)));
	return (CVoiceMailSampleDoc*)m_pDocument;
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CVoiceMailSampleView message handlers

void CVoiceMailSampleView::OnUpdate(CView* pSender, LPARAM lHint, CObject* pHint) 
{
int			nIndex;
time_t		lTime;
struct	tm	*localTime;
char    szBuff[64];

	time( &lTime );
	localTime = localtime( &lTime );
	sprintf( szBuff, "%02d:%02d:%02d", localTime->tm_hour,localTime->tm_min,localTime->tm_sec);
	nIndex = m_ModemEvent.InsertItem( m_ModemEvent.GetItemCount(), szBuff);
	if( nIndex != -1 )
	{
		m_ModemEvent.SetItemText( nIndex, 1, (LPCSTR)pHint);
	}
}



int CVoiceMailSampleView::OnCreate(LPCREATESTRUCT lpCreateStruct) 
{
	if (CView::OnCreate(lpCreateStruct) == -1)
		return -1;
	
RECT	rect;
DWORD	dwStyle	= WS_CHILD|WS_VISIBLE|WS_VSCROLL|WS_HSCROLL|LBS_USETABSTOPS|WS_BORDER;

	dwStyle	|= LVS_ALIGNTOP | LVS_REPORT | LVS_SINGLESEL | LVS_NOSORTHEADER;

	memset(&rect,0,sizeof(rect));
	if( m_ModemEvent.Create( dwStyle,rect,this,1) )
    {
    char			szChName[50];
    LV_COLUMN		lvColumn;
    int				nCtrl;

	    // TODO: Add your specialized creation code here
        lvColumn.mask   = LVCF_FMT | LVCF_WIDTH | LVCF_TEXT | LVCF_SUBITEM;
        lvColumn.fmt    = LVCFMT_LEFT;
        lvColumn.pszText = szChName;
        sprintf( szChName, "Time" );
        lvColumn.cx     = 100;
        lvColumn.iSubItem = 0;
	    nCtrl = m_ModemEvent.InsertColumn( 0, &lvColumn );

        sprintf( szChName, "Action" );
        lvColumn.iSubItem = 1;
        lvColumn.cx     = 500;
        nCtrl = m_ModemEvent.InsertColumn( 1, &lvColumn );
    }

	return 0;
}

void CVoiceMailSampleView::OnSize(UINT nType, int cx, int cy) 
{
	CView::OnSize(nType, cx, cy);
	
	// TODO: Add your message handler code here
	m_ModemEvent.MoveWindow(0,0,cx,cy);
}
