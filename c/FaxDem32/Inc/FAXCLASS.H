/****************************************************************************/
/*            (c) Copyright Black Ice Software Inc.  1994.                  */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/*                                                                          */
/*                                                                          */
/****************************************************************************/
#ifndef __FAXCL_H
#define __FAXCL_H

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Include
#include "queue.h"

#include "control1.h"
#include "faxtype.h"
#include "globerr.h"

class TRegistFaxClass;

#pragma pack(4)

//****************************************************************************
typedef FAXOBJ (CALLBACK * ProcCreateFax)(BOOL Send);
typedef HANDLE HDIB;

// TRegistFaxClass
class TRegistFaxClass
{
public:
    //------------------------------------------------------------
    TRegistFaxClass (char Type, ProcCreateFax Proc);
    //------------------------------------------------------------
    static ProcCreateFax SearchFaxType (char Type)
    {
        TRegistFaxClass *p= Search(Type);
        if (p) return p->FaxProc;
        return NULL;
    }
    //------------------------------------------------------------
    static int GetAllClass (LPSTR AllClass);
    static void RemoveAll(void);

private:
    //------------------------------------------------------------
    static TRegistFaxClass *Search (char Type);

    //------------------------------------------------------------
    char               FaxType;
    ProcCreateFax      FaxProc;
    TRegistFaxClass   *Next;

    //------------------------------------------------------------
    static TRegistFaxClass *First;
};

//-------------------------------------------------------------------------
//
//-------------------------------------------------------------------------

class DirectImage
{
protected:
        LPSTR                   lpFileName ;
public:
        int                     Format     ;
        int                     LineNum    ;
        TEPageStatus    Status     ;
public:
        DirectImage() ;
        ~DirectImage() ;
        LPSTR  GetFileName() const {
            return lpFileName ;
        };
        void   SetFileName(LPCSTR lpNewName);
        DirectImage& operator = (const DirectImage& Img);
} ;

class FAXAPI DirectImageArray {
protected:
        DirectImage *Images;
        int Items ;
public:
        DirectImageArray();
        ~DirectImageArray();
        inline int Size() const {
            return Items ;
        };
        int SetNewSize(int NewSize);
        inline DirectImage& operator [] (int i) {
            return Images[i];
        };
} ;

class FAXAPI G3LineCounter
{
public:
        int     BitNum        ;
        int     NullBitNumber ;
        int     LineNum           ;
        int     RTC1LineNum ;
        int     RTCNum        ;
        WORD    DetectEOP:1   ;
        int     Errors ;
public:
        G3LineCounter();
        void Reset();
        void Test(BYTE DataByte);
        int GetLineNum();
} ;


//****************************************************************************
// TCFaxNormal class
class FAXAPI far TCFaxNormal : public TCQueueItem
{
    friend class TCCommPure ;
    friend class TCCommPort ;
#if defined(WIN32)
    friend class TCCommClassBrookTR114 ;
	friend class TCCommClassBrookTR1034;
    friend class TCCommClassGamma ;
    friend class TCCommClassDialogic;
    friend class TCCommClassBicom;
    friend class TCCommClassCommetrex;
    friend class TCCommClassNms;
#endif
public:
    //-------------------------------------------------------------
    static FAXOBJ EXPDEF   CreateFaxObj (char FaxType, BOOL Send);
    static int    EXPDEF   RegisterFaxClass (char CppClassName, ProcCreateFax lpProc, TRegistFaxClass** pRClass);
    static int    EXPDEF   GetAllFaxClass (LPSTR FaxClass);
    static FAXOBJ CALLBACK CreateTCFaxNormal (BOOL Send);
    static void   EXPDEF   ReverseByte (char &Data);
    static void   EXPDEF   SetImageDirectory (LPSTR Dir);
    static void   EXPDEF   EndOfDll ();

    //-------------------------------------------------------------
    EXPDEF TCFaxNormal (BOOL aSend);
    virtual EXPDEF  ~TCFaxNormal ();

    // -- These functions call the user
    virtual int  EXPDEF SetParam (TSFaxParam far &Param);
    virtual int  EXPDEF SetImagePage (int PageNum, TEImageType Type, TUFaxImage far &Image, int ImageNum );
    virtual void EXPDEF GetParam (TSFaxParam far &Param);
    virtual int  EXPDEF GetImagePage (int PageNum, TEImageType Type, TUFaxImage far &Image, int ImageNum);
    virtual long EXPDEF GetEncodedDataSize (int PageNumber);

    virtual char EXPDEF GetFaxType ();
//    virtual int  EXPDEF CreateFaxHeader( HDIB hDst );
    virtual int  EXPDEF SetFaxHeader( TSHeaderContext *lpBContext );
    TEHeaderType  EXPDEF IsHeader();
    //-------------------------------------------------------------

    virtual int  EXPDEF GetRepeatCount();
    virtual int  EXPDEF SetRepeatCount(int nRep=-1);

    virtual long EXPDEF GetNextCallTime();
    virtual void EXPDEF SetNextCallTime(long tNext=0);

    TCFaxNormal* EXPDEF GetNextFax();
    void        EXPDEF  SetNextFax(TCFaxNormal* pNext);
    DWORD       EXPDEF  GetCurImagePos();

    static BOOL EXPDEF  GetTempFileName(LPSTR lpStr);
    void        EXPDEF  EnableBitOrderDetect() ;
        void        EXPDEF  DisableBitOrderDetect();
//    int         EXPDEF  SetHeaderDIB( HDIB hDib );
    virtual int EXPDEF  Read(HFILE hFile);
    virtual int EXPDEF  Write(HFILE hFile);
    virtual int EXPDEF  ReadHeader(HFILE hFile);
    virtual int EXPDEF  WriteHeader(HFILE hFile);
    virtual int EXPDEF  ReadHeader(HFILE hFile, TSFaxHeader far *Header);
    virtual int EXPDEF  WriteHeader(HFILE hFile, TSFaxHeader far *Header);
    virtual int EXPDEF  ReadImgData(HFILE hFile);
    virtual int EXPDEF  WriteImgData(HFILE hFile);
    virtual int EXPDEF  CreateCCITTHeader( LPSTR szCCITTFile, BOOL bSave, int , int);

    TEPageStatus EXPDEF TCFaxNormal::GetPageStatus(int nPage);

    virtual void EXPDEF GetSessionParam(TSSessionParameters& Param);

    virtual void        SetMonoFlag();
            int         GetDTMFDigits( LPSTR pBuff, int nr );
            int         GetDNISDigits( LPSTR pBuff, int nr );

			LPCSTR		GetUserString();
			void 		SetUserString(LPCSTR szUserString);

    //-------------------------------------------------------------
    // Public Attributes
    //-------------------------------------------------------------
    BOOL        Send;
    long        UserData;
    void       *UserPtr;
    TEFaxError  ErrorCode ;
protected:
    // -- These functions call the TCCommPure class
    virtual int  EXPDEF StartFax (TSSessionParameters& Param);
    virtual int  EXPDEF StartPage (int PageNumber);
    virtual int  EXPDEF WriteData (LPSTR Data, int Size);
    virtual int  EXPDEF ReadData (LPSTR Data, int Size);
    virtual int  EXPDEF ReadFaxData(LPSTR Data,int Size);
    virtual int  EXPDEF WriteFaxData (LPSTR Data, int Size);
    virtual int  EXPDEF EndPage (int LineNum);
    virtual int  EXPDEF EndFax (TSSessionParameters& Param);
    virtual int  EXPDEF CalcMinScanBytes(TEResolution Resolut,TEScanLine Scan,TEBaudRate   Baud);
    virtual int  EXPDEF GetLineCounter();

public:
    static int  DetectBitOrder;

    void        UpdateConnectTime(TSSessionParameters& Param);
protected:
    TSSessionParameters EndParam ;
    TSHeaderContext   m_header;

    WORD        IsEndFax:1  ;
    WORD        IsStartPage:1 ;
    WORD        IsRTCSent:1 ;
    static      TCGlobError serr;                /* for static member functions */
    TCGlobError xerr;                               /* for normal member functions */
    int EXPDEF  SetPageStatus( int nPage, TEPageStatus Code );
    virtual LPSTR PageFileName( int nPage );
    virtual LPSTR MHPageFileName( int nPage );
    BOOL        CheckGroup31D( TEImageType Type, TUFaxImage far &Image,
                                int ImageNum, LPSTR lpHeaderFile, int );
    LPLOGFONT   CreateLogFont( LPSTR lpszFaceName, int pt, int Weight,
                                BYTE Italic, BYTE Underline, BYTE StrikeOut, BOOL bHighRes );
    BYTE        GetSystemCharSet( void );
    int         WriteRaw( LPSTR TmpFileName, int GotHdr, HGLOBAL Memory );
    HDIB        AppendDIB( HGLOBAL hDst, HGLOBAL hSrc );
    int         SetDTMFDigits( LPSTR pDTMFDigits );
    int         SetDNISDigits( LPSTR pDNISDigits );
    //-------------------------------------------------------------
    int                 MaxPageNum;
    enum TEResolution   Resolut;
    enum TEPageWidth    Width;
    enum TEPageLength   Length;
    int             LineNum;
    enum TECompression  Compress;
    enum TEErrorCorrect Ecm ;
    enum TEBinaryFile   Binary;
    enum TEBitOrder     BitOrder;
    enum TEHeaderType   m_HeaderType;
    enum TESendMode     SendMode;


    PORTFAX         Port;

    char            RemoteNumber[MAX_CALLNUMBER];
    // Header members
    HDIB            m_hHeaderDib;
    DWORD           m_dwHeaderHeight, m_dwHeaderWidth;
    char            m_Header[250];

    DirectImageArray DirectImages;
    DirectImageArray MHImages;

    //-------------------------------------------------------------
    int             Page;
    DWORD           ImagePos;
    DWORD           SizeGlobalMem;
    HGLOBAL         hndMem;
    char huge *     hpMem;
    BOOL            BitReverse;
    BOOL            SendMH;
    char            m_chDTMFDigits[64];

    BOOL            InvertHeader; //rz the appended header must be inverted

    static char     BaseDir[MAX_FILENAME];

    //-------------------------------------------------------------

    int             Repeat   ;
    long            NextTime ;
    TCFaxNormal*    NextFax  ;
protected:
#ifdef _THREAD
        HANDLE                  hMutex ;
#endif

    // Line numbering
    int                 MinScanByte   ;
    int                 LastByteNum   ;

    G3LineCounter   CNormal   ;
    G3LineCounter   CReverse  ;
    int                             NullBitNumber ;

    //-------------------------------------------------------------
    void DDumpContext();
    char            Password[MAX_PASSWORD]; //rz password
    char            m_chDNISDigits[64];
	char            UserString[MAX_PATH+1]; //EA user data such as sender's name, filename, etc.

};
//*****************************************************************************

#pragma pack()
#endif  // __FAXCL_H

