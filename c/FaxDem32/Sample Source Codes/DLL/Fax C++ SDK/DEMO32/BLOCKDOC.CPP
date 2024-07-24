// blockdoc.cpp : implementation file
//
#include "stdafx.h"
#include <io.h>

#include "v_config.h"
#include "string.h"

extern "C" {
	#include "bidib.h"
	#include "bitiff.h"
	#include "biprint.h"
	#include "bidisp.h"
    #include "cals.h"
#if JPEG_EXIST == 1
    #include "bijpeg.h"
#endif
};

//#include <fstream.h>

#include <stdio.h>

#include "faxcpp.h"
#include "commcl.h"
#include "resource.h"
#include "magnifyw.h"
#include "disp.h"
#include "imgvw.h"
#include "inputvw.h"
#include "imgdoc.h"
#include "dialogs.h"
#include "faxdlg.h"
//#include "faxdoc.h"
#include "demo.h"
#include "mainfrm.h"
#include "dibpal.h"
#include "faxclass.h"
#include "faxbft.h"
#include "colorfax.h"

// TCFax
#include "logs.h"

#include "blockdoc.h"

#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CBlockDoc

IMPLEMENT_SERIAL(CBlockDoc, CDocument, 0 /* schema number*/ )

CBlockDoc::CBlockDoc()
{
    bPrintAndExit = FALSE ;
    m_nFileFormat = 0 ;
    m_faxobj = NULL;
}

BOOL CBlockDoc::OnNewDocument()
{
    if (!CDocument::OnNewDocument())
        return FALSE;
    return TRUE;
}

CBlockDoc::~CBlockDoc()
{
    if ( m_faxobj )
        ClearFaxObj( m_faxobj );

    if ( m_tmpName.GetLength() ) {
        OFSTRUCT of;
        OpenFile( m_tmpName, &of, OF_DELETE );
    }
}


BEGIN_MESSAGE_MAP(CBlockDoc, CImgDoc)
    //{{AFX_MSG_MAP(CBlockDoc)
    ON_COMMAND(ID_FILE_SAVE, OnFileSave)
    ON_UPDATE_COMMAND_UI(ID_FILE_SAVE, OnUpdateFileSave)
    ON_COMMAND(IDM_PAGEBACKWAD, OnPageBackwad)
    ON_UPDATE_COMMAND_UI(IDM_PAGEBACKWAD, OnUpdatePagebackwad)
    ON_COMMAND(IDM_PAGEFORWARD, OnPageForward)
    ON_UPDATE_COMMAND_UI(IDM_PAGEFORWARD, OnUpdatePageforward)
    ON_COMMAND(ID_FILE_SAVE_AS, OnFileSaveAs)
    ON_UPDATE_COMMAND_UI(ID_FILE_SAVE_AS, OnUpdateFileSaveAs)
    ON_COMMAND(ID_FILE_PRINT, OnFilePrint)
        ON_UPDATE_COMMAND_UI(ID_FAX_SEND, OnUpdateFaxSend)
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CBlockDoc serialization

void CBlockDoc::Serialize(CArchive& ar)
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
// CBlockDoc commands

void CBlockDoc::OnFileSave()
{
    OnFileSaveAs();
}

void CBlockDoc::OnUpdateFileSave(CCmdUI* pCmdUI)
{
    pCmdUI->Enable(FALSE);
}

void CBlockDoc::OnPageBackwad()
{
    if (m_nBlockCurrent > 0 )  {
        int iError;
        TUFaxImage      img;

        m_nBlockCurrent -- ;
                  nCurrent--;                   //rz
        iError = GetFaxImagePage( m_faxobj, m_nBlockCurrent, IMT_MEM_DIB, &img, FALSE );
        if ( !iError )
            SetNewDib( img.Dib );
    }
}

void CBlockDoc::OnUpdatePagebackwad(CCmdUI* pCmdUI)
{
    BOOL bEnable = FALSE ;
    if (m_faxobj) {
        if ( (m_faxobj->GetFaxType()!=REGTYPE_BINARYFILE) && (nImages > 1) && (m_nBlockCurrent != 0) ) {
            bEnable = TRUE ;
        }
    }
    pCmdUI->Enable(bEnable);
}

void CBlockDoc::OnPageForward()
{
    if ( nImages > m_nBlockCurrent ) {
        int iError;
        TUFaxImage      img;

        m_nBlockCurrent++ ;
                  nCurrent++;           //rz
        iError = GetFaxImagePage( m_faxobj, m_nBlockCurrent, IMT_MEM_DIB, &img, FALSE );
        if ( !iError ) {
            SetNewDib( img.Dib );
        }
    }
}

void CBlockDoc::OnUpdatePageforward(CCmdUI* pCmdUI)
{
    BOOL bEnable = FALSE ;
    if (m_faxobj){
        if ( (m_nBlockCurrent < (nImages-1)) && (m_faxobj->GetFaxType()!=REGTYPE_BINARYFILE) ) {
            bEnable = TRUE ;
        }
    }
    pCmdUI->Enable(bEnable);
}

void CBlockDoc::GoPage(int PageNr) //rz
{
    if ( (nImages > PageNr) && (PageNr>=0) ) {
        int iError;
        TUFaxImage      img;
                  m_nBlockCurrent=PageNr;
                  nCurrent=PageNr;
        iError = GetFaxImagePage( m_faxobj, m_nBlockCurrent, IMT_MEM_DIB, &img, FALSE );
        if ( !iError ) {
            SetNewDib( img.Dib );
        }
    }

}



void CBlockDoc::OnFileSaveAs()
{
    CImgDoc::OnFileSaveAs();
}

void CBlockDoc::OnUpdateFileSaveAs(CCmdUI* pCmdUI)
{
    pCmdUI->Enable(TRUE);
}

BOOL CBlockDoc::PrintAndExit()
{
    bPrintAndExit = TRUE ;
    OnFilePrint();
    OnCloseDocument();
    return TRUE ;
}

BOOL CBlockDoc::OnOpenDocument(const char *pszPathName)
{
    bPrintAndExit = TRUE ; // Filename Flag only
    return TRUE ;
}

void CBlockDoc::OnFilePrint()
{
        int                             iError;
    int                         nPageCnt;
    GPRINT                      sPrint;
    RECT                        rScale;
        TUFaxImage      img;

    SetRect(&rScale, 1, 1, 1, 1);

    sPrint.bDisplay = TRUE;
    sPrint.bCenterVertImg = FALSE;
    sPrint.bCenterHorizImg = FALSE;
    sPrint.bScalePage = FALSE;
    sPrint.nNumCopies = 1;
    sPrint.bConvertCtoB = FALSE;
    sPrint.bStretchPage = TRUE;
    sPrint.bAllPage = TRUE ;
    sPrint.bUseDPI  = FALSE;

        HDC hDC = NULL;
//  CImgApp *pApp = (CImgApp *)AfxGetApp();
//  HDC hdc = pApp->GetPrinterDC();

    if(! PrepareToPrint(AfxGetMainWnd()->m_hWnd, hDC, &sPrint,"Fax Document",nImages)  ) {
        if(sPrint.bAllPage)
        {
            for(nPageCnt=0;nPageCnt< nImages; nPageCnt++)
            {
                iError = GetFaxImagePage( m_faxobj, nPageCnt, IMT_MEM_DIB, &img, FALSE );
                if (!img.Dib || iError)
                {
                    break ;
                }
                if( PrintDIBPage(img.Dib, NULL, &rScale,nPageCnt,0,0) )
                {
                    GlobalFree(img.Dib);
                    img.Dib=NULL;
                    break ;
                }
                GlobalFree(img.Dib);
                img.Dib=NULL;

            }
        }
        else
        {
                        iError = GetFaxImagePage( m_faxobj, nCurrent, IMT_MEM_DIB, &img, FALSE );
                        if (img.Dib && !iError)
                        {
                                PrintDIBPage(img.Dib, NULL, &rScale,nCurrent,0,0);
                                GlobalFree(img.Dib);
                                img.Dib=NULL;

                        }
        }
    }

    EndPrint( hDC );

    if (sPrint.bAllPage)
    {
        GoPage(nCurrent);
    }
}


void CBlockDoc::LoadFaxBlock(int Type,int ID, HFILE hBlockFile)
{
    int             iError ;
    CImgApp*        pApp ;
    CLogs*          pLogs ;
    TSFaxHeader     hdr;
    TSFaxParam      par;
    union TUFaxImage img;
    HDIB            hDib=NULL;
    DWORD dwSize;

    m_LogType  = Type  ;
    m_BlockID  = ID    ;

    pApp = (CImgApp *)AfxGetApp() ;
    pLogs = (CLogs*)pApp->LogDocument[Type]  ;

    ASSERT(pApp  != NULL);
    ASSERT(pLogs != NULL);

    dwSize = sizeof(TSFaxHeader);
    _lread( hBlockFile, &hdr, sizeof(TSFaxHeader) );
    if ( hdr.bType == FXT_NORMAL )
        m_faxobj = TCFaxNormal::CreateFaxObj( REGTYPE_NORMALFAX, FALSE );
    if ( hdr.bType == FXT_BFT ) {
        m_faxobj = TCFaxNormal::CreateFaxObj( REGTYPE_BINARYFILE, FALSE );\
    }
    if ( hdr.bType == FXT_COLOR )
        m_faxobj = TCFaxNormal::CreateFaxObj( REGTYPE_COLORFAX, FALSE);
    if ( !m_faxobj )
        return;
    m_faxobj->ReadHeader( hBlockFile );
    m_faxobj->ReadImgData( hBlockFile );

    m_faxobj->GetParam( par );

    if ( hdr.bType == FXT_BFT ) {
        FILEFORMAT f;
        int        err;
        TCBinaryParam BftObj;
        //char       chTempPath[256];

        img.BftObj = &BftObj;
        iError = GetFaxImagePage( m_faxobj, 0, IMT_BFTOBJ, &img, FALSE );
        if ( !iError ) {
                        TCFaxNormal::GetTempFileName((LPSTR)m_tmpName.GetBuffer(256));
            m_tmpName.ReleaseBuffer(-1);
            long lSize = BftObj.ReadValue(BFD_data_file_content_FILE,
                                    (LPBYTE)m_tmpName.GetBuffer(256),
                                    m_tmpName.GetLength() );
            if (lSize <=0 ) {
                AfxMessageBox("Error while decode file!",MB_OK|MB_ICONSTOP);
            }
            else {
                f = GetImageFormat( m_tmpName.GetBuffer(256) );
                if ( f != UNKNOWN_FILE ) {
                    nImages = 1;
                    hDib = LoadImageIntoDIB( m_tmpName.GetBuffer(256), 0, &err );
                    if ( hDib )
                        SetNewDib( hDib );
                    else
                        AfxMessageBox( "Read error while loading image." );
                }
                else
                    AfxMessageBox( "Can't recognize file type. " );
            }
        }
        return;
    }
    iError = GetFaxImagePage( m_faxobj, 0, IMT_MEM_DIB, &img, FALSE );
    if ( !iError ) {
        nImages = par.PageNum;
        m_nBlockCurrent = 0;
        SetNewDib( img.Dib );
    }

}

void CBlockDoc::OnUpdateFaxSend(CCmdUI* pCmdUI)
{
    pCmdUI->Enable(IsAnyPortOpen()) ;
}

/////////////////////////////////////////////////////////////////////////////
// CBlockFrame

IMPLEMENT_DYNCREATE(CBlockFrame, CMDIChildWnd)

CBlockFrame::CBlockFrame()
{
}

CBlockFrame::~CBlockFrame()
{
}


BEGIN_MESSAGE_MAP(CBlockFrame, CMDIChildWnd)
    //{{AFX_MSG_MAP(CBlockFrame)
        // NOTE - the ClassWizard will add and remove mapping macros here.
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CBlockFrame message handlers

