

#include "resource.h"  
    
#include "stdafx.h"
#include "inputvw.h"
#include "splitter.h"

//#include "magnifyw.h"
//#include "disp.h"
//#include "imgvw.h"
//#include "imgdoc.h"


#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CSplitterFrame

// Create a splitter window which splits an output text view and an input view
//                           |
//    TEXT VIEW (CTextView)  | INPUT VIEW (CInputView)
//                           |

IMPLEMENT_DYNCREATE(CSplitterFrame, CMDIChildWnd)

CSplitterFrame::CSplitterFrame()
{
}

CSplitterFrame::~CSplitterFrame()
{
}


BOOL CSplitterFrame::OnCreateClient(LPCREATESTRUCT /*lpCreate*/, CCreateContext* pContext)
{   
    CImgDoc *pDoc = (CImgDoc *)pContext->m_pCurrentDoc;
    
//  if(!pDoc->m_bGroup)
//  {   
//      return CMDIChildWnd::OnCreateClient(lpCreate, pContext);
//  }   

    // create a splitter with 1 row, 2 columns
    if (!m_wndSplitter.CreateStatic(this, 1, 2))
    {
        TRACE("Failed to CreateStaticSplitter\n");
        return FALSE;
    }

    // add the first splitter pane - the default view in column 0
    if (!m_wndSplitter.CreateView(0, 1,
        pContext->m_pNewViewClass, CSize(300, 400), pContext))
    {
        TRACE("Failed to create first pane\n");
        return FALSE;
    }

    // add the second splitter pane - an input view in column 1
    if (!m_wndSplitter.CreateView(0, 0,
        RUNTIME_CLASS(CInputView), CSize(200, 100), pContext))
    {
        TRACE("Failed to create second pane\n");
        return FALSE;
    }

    // activate the input view
    SetActiveView((CView*)m_wndSplitter.GetPane(0,1));

    return TRUE;
}

BEGIN_MESSAGE_MAP(CSplitterFrame, CMDIChildWnd)
    //{{AFX_MSG_MAP(CSplitterFrame)
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()

