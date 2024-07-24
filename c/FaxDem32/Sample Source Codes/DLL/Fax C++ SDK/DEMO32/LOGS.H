// logs.h : header file
//

//#include <stdlib.h>

#define DATEBUFF_SIZE   11
#define TIMEBUFF_SIZE   6
#define NAMEBUFF_SIZE   41
#define PHONEBUFF_SIZE  MAX_CALLNUMBER
#define IMAGENAMEBUFF_SIZE MAX_FILENAME

enum TEFaxStatus {FXS_WAITSEND, FXS_SENDING, FXS_SENDED, FXS_SENDERROR, FXS_RECEIVING, FXS_RECEIVED, FXS_RECEIVEERROR, FXS_END};

#define FXT_NORMAL  'N'
#define FXT_BFT     'B'
#define FXT_COLOR   'C'

struct TSViewFaxBlock
{
    inline TSViewFaxBlock() 
    {
        DocIcon= NULL;
        DocError=NULL;
    }         
    int     Type ;
    int     ID;
//    CBitmap *Bitmap;
    HICON   DocIcon ;
    HICON   DocError ; 
    char    Date[DATEBUFF_SIZE];
    char    Time[TIMEBUFF_SIZE];
    char    Name[NAMEBUFF_SIZE];
    char    CDate[DATEBUFF_SIZE];
    char    CTime[TIMEBUFF_SIZE];
    char    PhoneNumber[PHONEBUFF_SIZE];
    char    PageNumber[6];
    char    szFileName[256];
};

/////////////////////////////////////////////////////////////////////////////
// CLogs document
enum TELogType {LGT_SEND, LGT_RECEIVE, LGT_OUTBOX, LGT_POLLING};

class CLogs : public CDocument 
{
    DECLARE_SERIAL(CLogs)
protected:
    CLogs();            // protected constructor used by dynamic creation

// Attributes
public:

// Operations
public:
    TELogType   LogType;
    CString     m_szActDir;

    void    SetActiveDoc();
    BOOL    GetFName(int ID, LPSTR szName);
    int     FillViewLog( BOOL bSelectFirst );
    //---------------------------
    // Logs Managment
    // Functions

    // int GetSelectedBlockk(); //return - ID
    int     GetBlockCount();
    void    WriteDir();
    void    WriteStatus(TSViewFaxBlock *vfb);
    void    ClearStatus();
    HGLOBAL MakeName( LPSTR szName );

    BOOL    DeleteFaxBlockk(int ID);
    //---------------------------
    int     FillViewLog ();
    int     UpdateViewLine( TSFaxHeader far *header, LPSTR chName );
    //---------------------------
    FAXOBJ  LoadFileToFAXOBJ( CFile &file, TSFaxHeader *lpHeader );

    //----- OutBox Only -------------                  
    int     CheckOutBox();
    //int ResetOutBox(); // Called on startup
    int     OnSendError(int BlockID);                      
    void    MakeTempFile(LPSTR TmpFileName);
    
// Implementation
protected:
    virtual ~CLogs();
    virtual void Serialize(CArchive& ar);   // overridden for document i/o
    virtual BOOL OnNewDocument();
    virtual BOOL OnOpenDocument(const char * pszFileName);

    void _loadds OnDone(HANDLE hDib,LPCSTR lpFileName);
    void _loadds OnCloseTWdoc();

    // Generated message map functions
protected:
    //{{AFX_MSG(CLogs)
    afx_msg void OnTesztAddfaxblock();
    afx_msg void OnTesztAddfaxobj();
    afx_msg void OnTesztAddfaxpage();
    afx_msg void OnTesztDeleteact();
    afx_msg void OnTesztUpdatelogs();
    afx_msg void OnUpdateLogFileSave(CCmdUI* pCmdUI);
    afx_msg void OnUpdateLogFileSaveAs(CCmdUI* pCmdUI);
    afx_msg void OnUpdateAcquire(CCmdUI* pCmdUI);
    afx_msg void OnUpdateSelectsource(CCmdUI* pCmdUI);
    afx_msg void OnSelectsource();
    afx_msg void OnAcquire();
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()

private:
    HICON   hNormal ;
    HICON   hColor  ;
    HICON   hBft    ;
    HICON   hError  ;
};

//******************************************
#define LOG_SECTION "Logs"
#define LOGKEY_PATH "Database Path"
#define LOGKEY_IMGPATH "Image Path"

