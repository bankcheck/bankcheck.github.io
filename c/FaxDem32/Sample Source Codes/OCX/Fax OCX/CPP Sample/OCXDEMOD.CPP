// OCXDEMODoc.cpp : implementation of the COCXDEMODoc class
//

#include "stdafx.h"
#include "OCXDEMO.h"

#include "OCXDEMOD.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// COCXDEMODoc

IMPLEMENT_DYNCREATE(COCXDEMODoc, CDocument)

BEGIN_MESSAGE_MAP(COCXDEMODoc, CDocument)
        //{{AFX_MSG_MAP(COCXDEMODoc)
                // NOTE - the ClassWizard will add and remove mapping macros here.
                //    DO NOT EDIT what you see in these blocks of generated code!
        //}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// COCXDEMODoc construction/destruction

COCXDEMODoc::COCXDEMODoc()
{
        // TODO: add one-time construction code here

}

COCXDEMODoc::~COCXDEMODoc()
{
}

BOOL COCXDEMODoc::OnNewDocument()
{
        if (!CDocument::OnNewDocument())
               return FALSE;

        // TODO: add reinitialization code here
        // (SDI documents will reuse this document)

        return TRUE;
}

/////////////////////////////////////////////////////////////////////////////
// COCXDEMODoc serialization

void COCXDEMODoc::Serialize(CArchive& ar)
{
        if (ar.IsStoring())
        {
                // TODO: add storing code here
        }
        else
        {
                // TODO: add loading code here
        }
}

/////////////////////////////////////////////////////////////////////////////
// COCXDEMODoc diagnostics

#ifdef _DEBUG
void COCXDEMODoc::AssertValid() const
{
        CDocument::AssertValid();
}

void COCXDEMODoc::Dump(CDumpContext& dc) const
{
        CDocument::Dump(dc);
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// COCXDEMODoc commands
