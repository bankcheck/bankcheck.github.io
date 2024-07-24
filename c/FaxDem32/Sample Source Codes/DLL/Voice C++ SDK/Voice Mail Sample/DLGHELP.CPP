// DlgHelp.cpp : implementation file
//

#include "stdafx.h"
#include "Voice Mail Sample.h"
#include "DlgHelp.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDlgHelp dialog


CDlgHelp::CDlgHelp(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgHelp::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDlgHelp)
	//}}AFX_DATA_INIT
    AfxInitRichEdit();
}


void CDlgHelp::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDlgHelp)
	DDX_Control(pDX, IDC_TEXT, m_cTextCtrl);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDlgHelp, CDialog)
	//{{AFX_MSG_MAP(CDlgHelp)
	ON_WM_CLOSE()
	ON_WM_SHOWWINDOW()
	ON_WM_SIZE()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDlgHelp message handlers

ULONG PASCAL MyStreamInCallback(DWORD dwCookie, LPBYTE pbBuff, LONG cb, LONG *pcb)
{
   CFile* pFile = (CFile*) dwCookie;

   *pcb = pFile->Read(pbBuff, cb);

   return 0;
}

BOOL CDlgHelp::OnInitDialog() 
{
   CDialog::OnInitDialog();
	
   extern CRichEditCtrl* pmyRichEditCtrl;
   // The file from which to load the contents of the rich edit control.
   CFile cFile(TEXT("vmhelp.rtf"), CFile::modeRead);
   EDITSTREAM es;

   es.dwCookie = (DWORD) &cFile;
   es.pfnCallback = MyStreamInCallback; 
   m_cTextCtrl.StreamIn(SF_RTF, es);    

	
   return TRUE;  
}

void CDlgHelp::OnClose() 
{
	CDialog::OnClose();
}

void CDlgHelp::OnShowWindow(BOOL bShow, UINT nStatus) 
{
    m_cTextCtrl.SetSel(0,0);
    CDialog::OnShowWindow(bShow, nStatus);
   	
	
}

void CDlgHelp::OnSize(UINT nType, int cx, int cy) 
{
	CDialog::OnSize(nType, cx, cy);
	if(m_cTextCtrl.m_hWnd)
        m_cTextCtrl.SetWindowPos(&wndTop, 0, 0, cx, cy, 0);
	
}
