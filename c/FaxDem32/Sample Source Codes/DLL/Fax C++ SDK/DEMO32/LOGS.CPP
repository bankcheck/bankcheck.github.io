// logs.cpp : implementation file
//

#include "stdafx.h"

#include <dos.h>

#include "faxcpp.h"
#include "faxclass.h"
#include "resource.h"      
extern "C" {
	#include "bitiff.h"
}
#include "imgdoc.h"
#include "dialogs.h"
#include "faxdlg.h"
#include "commcl.h"
//#include "faxdoc.h"
#include "demo.h"
#include "logs.h"
#include "logsview.h"
#include "logsfram.h"
#include "mainfrm.h"

#ifdef _DEBUG
#undef THIS_FILE
static char BASED_CODE THIS_FILE[] = __FILE__;
#endif                      

int CompressStr(LPSTR lpStr);

//#define REGTYPE_COLORFAX 'C' 

extern "C" {
    int  hWnd;
}
/////////////////////////////////////////////////////////////////////////////
// CLogs

IMPLEMENT_SERIAL(CLogs, CDocument, 0 /* schema number*/ )

CLogs::CLogs()
{   
}

//-------------------------------------------------------------------
BOOL CLogs::OnNewDocument()
{
    if (!CDocument::OnNewDocument())
        return FALSE;

    CDocTemplate *pdt= GetDocTemplate();
    CString str;
    BOOL bOk = pdt->GetDocString(str, CDocTemplate::docName);
    if(bOk==FALSE) return FALSE;

    if (str==CString("SENDLOG")) {
        LogType= LGT_SEND;
        m_szActDir = ((CImgApp*)AfxGetApp())->m_szDemoPath + "SEND\\";
    }
    else if (str==CString("RECLOG")) {
        LogType= LGT_RECEIVE;
        m_szActDir = ((CImgApp*)AfxGetApp())->m_szDemoPath + "RECEIVE\\";
    }
    else if (str==CString("OUTLOG")) {
        LogType= LGT_OUTBOX;
        m_szActDir = ((CImgApp*)AfxGetApp())->m_szDemoPath + "OUT\\";
    }
    else if (str==CString("POLLLOG")) {
        LogType= LGT_POLLING;
        m_szActDir = ((CImgApp*)AfxGetApp())->m_szDemoPath + "POLL\\";
    }
    else return FALSE;

    WriteDir();
    hNormal = AfxGetApp()->LoadIcon( IDI_NORMAL );
    hColor  = AfxGetApp()->LoadIcon( IDI_COLOR );
    hBft    = AfxGetApp()->LoadIcon( IDI_BFT );
    hError  = AfxGetApp()->LoadIcon( IDI_ERROR );

    FillViewLog( TRUE );    
    return TRUE;
}
//-------------------------------------------------------------------
BOOL CLogs::OnOpenDocument(const char * pszFileName)
{
    if (!CDocument::OnOpenDocument(pszFileName))
        return FALSE;

    return TRUE;
}

CLogs::~CLogs()
{
    DeleteObject(hNormal) ;
    DeleteObject(hColor ) ;
    DeleteObject(hBft   ) ;
    DeleteObject(hError ) ;
}

BEGIN_MESSAGE_MAP(CLogs, CDocument)
    //{{AFX_MSG_MAP(CLogs)
    ON_UPDATE_COMMAND_UI(ID_FILE_SAVE, OnUpdateLogFileSave)
    ON_UPDATE_COMMAND_UI(ID_FILE_SAVE_AS, OnUpdateLogFileSaveAs)
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CLogs serialization

void CLogs::Serialize(CArchive& ar)
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
             
//---------------------------------------------------------------
/*int CLogs::GetSelectedBlockk() //return - ID
{
    POSITION pos= GetFirstViewPosition();
    CLogsView *View= (CLogsView *)GetNextView(pos);
    return View->GetCurrentLine();
}*/
//---------------------------------------------------------------
int CLogs::GetBlockCount()
{
    POSITION pos= GetFirstViewPosition();
    CLogsView *View= (CLogsView *)GetNextView(pos);
    return View->GetItemCount();
}
//---------------------------------------------------------------
BOOL CLogs::DeleteFaxBlockk(int ID)
{   
    POSITION pos= GetFirstViewPosition();
    CLogsView *View= (CLogsView *)GetNextView(pos);

    if ( !View ) return FALSE;
    return View->DeleteLine( ID );
}
//---------------------------------------------------------------
BOOL CLogs::GetFName(int ID, LPSTR szName)
{
    POSITION pos= GetFirstViewPosition();
    CLogsView *View= (CLogsView *)GetNextView(pos);
    if ( !View ) return FALSE;
    return View->GetFName( ID, szName );
}
//-------------------------------------------------------------
int CLogs::FillViewLog( BOOL bSelectFirst )      
{
    int         recnum=0;
    POSITION    pos= GetFirstViewPosition();
    CLogsView   *View= (CLogsView *)GetNextView(pos);
    CImgApp     *pApp = (CImgApp *)AfxGetApp();
    CString     szPath, szFileFound;
    CFile       fLine;
    CFileException e;
    TSFaxHeader header;

    if ( !View ) return -1;
    ClearStatus();
    View->DeleteAllLine();
    szPath = m_szActDir + "*.tmp";
#ifdef WIN32
    WIN32_FIND_DATA fdata;
    HANDLE  hFind;

    hFind = FindFirstFile( szPath, &fdata );
    if ( hFind != INVALID_HANDLE_VALUE ) {
        szFileFound = m_szActDir + fdata.cFileName;
        if ( fLine.Open( szFileFound, CFile::modeRead, &e ) == 0 )
            return 0;
        fLine.Read( &header, sizeof(header) );
        UpdateViewLine( &header, szFileFound.GetBuffer(szFileFound.GetLength()) );
        fLine.Close();
        recnum++;
        while ( FindNextFile( hFind, &fdata ) ) {
            szFileFound = m_szActDir + fdata.cFileName;
            if ( fLine.Open( szFileFound, CFile::modeRead, &e ) == 0 )
                return recnum;
            fLine.Read( &header, sizeof(header) );
            UpdateViewLine( &header, szFileFound.GetBuffer(szFileFound.GetLength()) );
            fLine.Close();
            recnum++;
        }
        FindClose(hFind);
    }
#else
    struct _find_t c_file;

    szPath = m_szActDir + "*.tmp";
    if ( _dos_findfirst( szPath, _A_NORMAL, &c_file ) == 0 ) {
        szFileFound = m_szActDir + c_file.name;
        if ( fLine.Open( szFileFound, CFile::modeRead, &e ) == 0 )
            return 0;
        fLine.Read( &header, sizeof(header) );
        UpdateViewLine( &header, szFileFound.GetBuffer(szFileFound.GetLength()) );
        fLine.Close();
        recnum++;
        while ( !_dos_findnext( &c_file ) ) {
            szFileFound = m_szActDir + c_file.name;
            if ( fLine.Open( szFileFound, CFile::modeRead, &e ) == 0 )
                return recnum;
            fLine.Read( &header, sizeof(header) );
            UpdateViewLine( &header, szFileFound.GetBuffer(szFileFound.GetLength()) );
            fLine.Close();
            recnum++;
        }
    }
#endif
    if ( bSelectFirst )
        View->WriteState();
    return recnum;
}
//-------------------------------------------------------------
int CLogs::UpdateViewLine( TSFaxHeader far *header, LPSTR chFName )
{
    TSViewFaxBlock ViewBlock;

    POSITION pos= GetFirstViewPosition();
    CLogsView *View= (CLogsView *)GetNextView(pos);
    if ( !View ) return -1;

    wsprintf (ViewBlock.CDate, "%2d/%02d/%02d", header->CreateTime.tm_mon+1, header->CreateTime.tm_mday, header->CreateTime.tm_year+1900);
    wsprintf (ViewBlock.CTime, "%2d:%02d", header->CreateTime.tm_hour, header->CreateTime.tm_min);
    wsprintf (ViewBlock.Date, "%2d/%02d/%02d", header->SendTime.tm_mon+1, header->SendTime.tm_mday, header->SendTime.tm_year+1900);
    wsprintf (ViewBlock.Time, "%2d:%02d", header->SendTime.tm_hour, header->SendTime.tm_min);

    CompressStr( header->RemoteNumber );
    CompressStr( header->szName );
    lstrcpy( ViewBlock.Name, header->szName );
    lstrcpy( ViewBlock.PhoneNumber, header->RemoteNumber );
    wsprintf( ViewBlock.PageNumber, "%d", header->wPageNum);
    ViewBlock.DocIcon= hNormal;
    ViewBlock.Type = LogType ;
    ViewBlock.ID = View->GetNotUsedID();

    _fstrcpy( ViewBlock.szFileName, chFName );
    if ( header->wStatus == FXS_SENDERROR || header->wStatus == FXS_RECEIVEERROR )
        ViewBlock.DocError = hError ;

    if ( header->bType == FXT_BFT )
        ViewBlock.DocIcon = hBft ;

    if ( header->bType == FXT_COLOR )
        ViewBlock.DocIcon = hColor;

    View->AddNewLine(&ViewBlock);
    return 0;
}

int CLogs::CheckOutBox()
{
    long        cur_time, lSendTime ;
    int         i, bPort ;
    CFile       fLine ;
    CFileException e;
    CImgApp     *pApp = (CImgApp *)AfxGetApp();
    FAXOBJ      FaxObj = NULL;
    TSFaxHeader header;
    CString     szPath, szFileFound;
    struct tm   stm;

    bPort = FALSE ; 
    for ( i=0 ; i<MAX_FAXPORTS ; i++ ) {
        TSPortStatus sPortStatus;
        if (pApp->FaxPorts[i]) {
            if( pApp->FaxPorts[i]->IsOpen() ) {
                bPort = TRUE ;
                GetPortStatus(pApp->FaxPorts[i], &sPortStatus);
                if (sPortStatus.Status) {
                    return -1;
                }
            }
        }
    }   

    if (!bPort)
        return -1 ;

    szPath = m_szActDir + "*.tmp";
    cur_time = time(NULL);    
#ifdef WIN32
    WIN32_FIND_DATA fdata;
    HANDLE  hFind;

    hFind = FindFirstFile( szPath, &fdata );
    if ( hFind != INVALID_HANDLE_VALUE ) {
        szFileFound = m_szActDir + fdata.cFileName;
        fLine.Open( szFileFound, CFile::modeReadWrite, &e );

        fLine.Read( &header, sizeof(header) );
        pApp->SetWinTime( &header.SendTime, &stm );
        lSendTime = mktime( &stm );

        if ( (lSendTime < cur_time) && (header.wStatus == (BYTE)FXS_WAITSEND) ) {
            FaxObj = LoadFileToFAXOBJ( fLine, &header );
            FaxObj->UserData = (long)MakeName( szFileFound.GetBuffer(szFileFound.GetLength()) );
            if ( PutFaxOnQueue( FaxObj ) >= 0 ) {
                header.wStatus = (BYTE)FXS_SENDING;
                fLine.Seek( 0, CFile::begin );
                fLine.Write( &header, sizeof(header) );
            }
            else
                ClearFaxObj( FaxObj );
        }
        else {
            fLine.Close();
            while ( FindNextFile( hFind, &fdata ) ) {
                szFileFound = m_szActDir + fdata.cFileName;
                fLine.Open( szFileFound, CFile::modeRead, &e );
                fLine.Read( &header, sizeof(header) );
                pApp->SetWinTime( &header.SendTime, &stm );
                lSendTime = mktime( &stm );

                if ( (lSendTime < cur_time) && (header.wStatus == (BYTE)FXS_WAITSEND) ) {
                    FaxObj = LoadFileToFAXOBJ( fLine, &header );
                    FaxObj->UserData = (long)MakeName( szFileFound.GetBuffer(szFileFound.GetLength()) );
                    if ( PutFaxOnQueue( FaxObj ) >= 0 ) {
                        header.wStatus = (BYTE)FXS_SENDING;
                        fLine.Seek( 0, CFile::begin );
                        fLine.Write( &header, sizeof(header) );
                    }
                    else
                        ClearFaxObj( FaxObj );
                }
                fLine.Close();
            }
        }
        FindClose( hFind );
    }

#else
    struct _find_t c_file;
    
    if ( _dos_findfirst( szPath, _A_NORMAL, &c_file ) == 0 ) {
        szFileFound = m_szActDir + c_file.name;
        fLine.Open( szFileFound, CFile::modeReadWrite, &e );

        fLine.Read( &header, sizeof(header) );
        pApp->SetWinTime( &header.SendTime, &stm );
        lSendTime = mktime( &stm );

        if ( (lSendTime < cur_time) && (header.wStatus == (BYTE)FXS_WAITSEND) ) {
            FaxObj = LoadFileToFAXOBJ( fLine, &header );
            FaxObj->UserData = (long)MakeName( szFileFound.GetBuffer(szFileFound.GetLength()) );
            if ( PutFaxOnQueue( FaxObj ) >= 0 ) {
                header.wStatus = (BYTE)FXS_SENDING;
                fLine.Seek( 0, CFile::begin );
                fLine.Write( &header, sizeof(header) );
            }
            else
                ClearFaxObj( FaxObj );
        }
        else {
            fLine.Close();
            while ( _dos_findnext( &c_file ) == 0 ) {
                szFileFound = m_szActDir + c_file.name;
                fLine.Open( szFileFound, CFile::modeRead, &e );
                fLine.Read( &header, sizeof(header) );
                pApp->SetWinTime( &header.SendTime, &stm );
                lSendTime = mktime( &stm );

                if ( (lSendTime < cur_time) && (header.wStatus == (BYTE)FXS_WAITSEND) ) {
                    FaxObj = LoadFileToFAXOBJ( fLine, &header );
                    FaxObj->UserData = (long)MakeName( szFileFound.GetBuffer(szFileFound.GetLength()) );
                    if ( PutFaxOnQueue( FaxObj ) >= 0 ) {
                        header.wStatus = (BYTE)FXS_SENDING;
                        fLine.Seek( 0, CFile::begin );
                        fLine.Write( &header, sizeof(header) );
                    }
                    else
                        ClearFaxObj( FaxObj );
                }
                fLine.Close();
            }
        }
    }
#endif
    return 0 ;
}

//***************************************
FAXOBJ CLogs::LoadFileToFAXOBJ( CFile &file, TSFaxHeader *lpHeader )
{
    CImgApp         *pApp = (CImgApp *)AfxGetApp(); 
    TSFaxParam      FaxPar;
    BOOL            Send= FALSE;
    FAXOBJ          fo= NULL;
    FAXOBJ          First = NULL ;
    FAXOBJ          Last=NULL ;

    if ( lpHeader->wStatus <= FXS_SENDERROR )
        Send= TRUE;
    if ( lpHeader->bType == FXT_NORMAL )
        fo = TCFaxNormal::CreateFaxObj(REGTYPE_NORMALFAX, Send);
    if ( lpHeader->bType == FXT_BFT )
        fo = TCFaxNormal::CreateFaxObj(REGTYPE_BINARYFILE, Send);
    if ( lpHeader->bType == FXT_COLOR )
        fo = TCFaxNormal::CreateFaxObj(REGTYPE_COLORFAX, Send);
    if (fo == NULL) return First;
        
    // Chain fax object
    if (!First) {
        First = fo ;
    }               
    if (Last) Last->SetNextFax(fo);
        
    Last = fo ;

    FaxPar.PageNum  = lpHeader->wPageNum;
    FaxPar.Resolut  = (TEResolution)lpHeader->bResolut;
    FaxPar.Width    = (TEPageWidth)lpHeader->bWidth;
    FaxPar.Length   = (TEPageLength)lpHeader->bLength;
    FaxPar.Compress = (TECompression)lpHeader->bCompress;
    FaxPar.Binary   = (TEBinaryFile)lpHeader->bBinary;
    FaxPar.BitOrder = (TEBitOrder)lpHeader->bBitOrder;
    FaxPar.Send     = (BOOL)lpHeader->bSend;

    if (Send) {
        strncpy( FaxPar.RemoteNumber, lpHeader->RemoteNumber, sizeof(FaxPar.RemoteNumber)-1 );
    }
    FaxPar.RemoteNumber[ sizeof(FaxPar.RemoteNumber)-1 ] = 0;
    if (fo->GetFaxType()== REGTYPE_BINARYFILE){
        FaxPar.Binary = BFT_ENABLE ;
    }
    fo->SetParam( FaxPar );
    fo->ReadImgData( (HFILE)file.m_hFile );
    return First;
}

//---------------------------------------------

/////////////////////////////////////////////////////////////////////////////
// CLogs commands

void CLogs::SetActiveDoc()
{
    POSITION pos= GetFirstViewPosition();
    CLogsView *View= (CLogsView *)GetNextView(pos);
    ((CMDIChildWnd*)(View->GetParent()))->MDIActivate();
    OpenIcon(((CMDIChildWnd*)(View->GetParent()))->m_hWnd) ;
}

static void fillrandomstring(LPSTR pStr, int Size)
{
    int len= rand()%Size;
    for (int i= 0; i < len; i++)
    {
        pStr[i]= char((rand()%95)+32);
    }
    pStr[len]= 0;
}   

int CompressStr(LPSTR lpStr)
{
    int iLen ;
    iLen = strlen(lpStr);
    while(iLen > 0 ) {
        if ((lpStr[iLen] == 0 ) || (lpStr[iLen] == ' ')) {
            lpStr[iLen] = 0 ;
        } else {
            break ;
        }          
        iLen -- ;
    }
    return iLen ;
}

void CLogs::MakeTempFile(LPSTR TmpFileName)
{
    char BaseDir[255];
    OFSTRUCT ofs;

    BaseDir[0] = 0;
    lstrcpy( BaseDir, AfxGetApp()->GetProfileString(LOG_SECTION, LOGKEY_IMGPATH, "") );

    if ( BaseDir[0] == 0 ) {
#ifdef WIN32
        GetTempFileName( BaseDir, "", 0, TmpFileName);
#else
        GetTempFileName( BaseDir[0], "", 0, TmpFileName);
#endif
        return;
    }   

    char ltmp[MAX_FILENAME];
    char fdrive[_MAX_DRIVE], fdir[_MAX_DIR];
    char fname[_MAX_FNAME],  fext[_MAX_EXT];

    int ln = lstrlen(BaseDir);
    if ( ln > 0 && BaseDir[ln-1]!='\\' ) {
        BaseDir[ln] = '\\';
        BaseDir[ln+1] = 0;
    }
#ifdef WIN32
    GetTempFileName (BaseDir, "", 0, ltmp);
#else
    GetTempFileName (BaseDir[0], "", 0, ltmp);
#endif
    _splitpath(ltmp, NULL, NULL, fname, fext);
    _splitpath(BaseDir, fdrive, fdir, NULL, NULL);
    _makepath(TmpFileName, fdrive, fdir, fname, fext);

    OpenFile (TmpFileName, &ofs, OF_EXIST);
    if ( ofs.nErrCode != 2 ) {// 2 = File not found.
        // something wrong with path. 
#ifdef WIN32
        GetTempFileName (BaseDir, "", 0, TmpFileName);
#else
        GetTempFileName (BaseDir[0], "", 0, TmpFileName);
#endif
    }
    OpenFile(ltmp,&ofs,OF_DELETE);
}

void CLogs::OnUpdateLogFileSave(CCmdUI* pCmdUI)
{
    pCmdUI->Enable(FALSE);  
}

void CLogs::OnUpdateLogFileSaveAs(CCmdUI* pCmdUI)
{
    pCmdUI->Enable(FALSE);  
};

void CLogs::WriteDir()
{
    POSITION    pos=GetFirstViewPosition();
    CView   *View = (CView *)GetNextView(pos);
    
    if ( !View->IsKindOf(RUNTIME_CLASS(CLogStatus) ) )
        View = (CView *)GetNextView(pos);

    if ( View->IsKindOf(RUNTIME_CLASS(CLogStatus) ) )
        ((CLogStatus*)View)->WriteDir( m_szActDir );
}

void CLogs::WriteStatus( TSViewFaxBlock *vfb )
{
    POSITION    pos=GetFirstViewPosition();
    CView   *View = (CView *)GetNextView(pos);
    
    if ( !View->IsKindOf(RUNTIME_CLASS(CLogStatus) ) )
        View = (CView *)GetNextView(pos);

    if ( View->IsKindOf(RUNTIME_CLASS(CLogStatus) ) )
        ((CLogStatus*)View)->WriteStatus( vfb );
}

void CLogs::ClearStatus()
{
    POSITION    pos=GetFirstViewPosition();
    CView   *View = (CView *)GetNextView(pos);
    
    if ( !View->IsKindOf(RUNTIME_CLASS(CLogStatus) ) )
        View = (CView *)GetNextView(pos);

    if ( View->IsKindOf(RUNTIME_CLASS(CLogStatus) ) )
        ((CLogStatus*)View)->ClearStatus();
}

HGLOBAL CLogs::MakeName( LPSTR szName )
{
    HGLOBAL hRet;
    LPSTR   lpName;

    hRet = GlobalAlloc( GHND, 260 );
    lpName = (LPSTR)GlobalLock( hRet );
    if ( lpName ) {
        lstrcpy( lpName, szName );
        GlobalUnlock( hRet );
    }
    return hRet;
}

void  _loadds CLogs::OnDone(HANDLE hDIB,LPCSTR lpFileName)
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();

    TRACE0( "Acquire is done (in CLogs) ==> Opening image window.\n" );
    ((CMainFrame*)(pApp->m_pMainWnd))->m_hScanDIB = hDIB;
    pApp->NewImage();
}

void _loadds CLogs::OnCloseTWdoc()
{
    CImgApp *pApp = (CImgApp *)AfxGetApp();
//     AfxGetMainWnd()->EnableWindow(TRUE);
    AfxGetMainWnd()->SetFocus();
}

