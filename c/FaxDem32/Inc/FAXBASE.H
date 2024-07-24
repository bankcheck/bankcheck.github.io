#ifndef _FAXBASE_H
#define _FAXBASE_H
#ifndef STRICT
#define STRICT
#endif 
#include <port32.h>
#include <assert.h>
#include <windows.h>


#ifndef HCOMDEV
 #ifdef _THREAD
   #define HCOMDEV HANDLE
 #else 
   #define HCOMDEV int 
 #endif
#endif

//#ifndef LPCBYTE
typedef unsigned char far const *LPCBYTE ;	
//#endif


//----------------------------
// CLASS IDS     
//----------------------------

#define CID_FAXOBJECT 1
#define CID_CONTROL   2
#define CID_COMPORT   3
#define CID_MODEMPORT 4


#define DECLARECLASS(BaseClass,Name,ID) \
	inline LPCSTR TCClassName() const {return Name ;};\
	inline WORD   TCClassID() const {return ID;};\
	inline BOOL   IsBasedON(WORD wID) const \
	{\
	 	if (wID == ID) return TRUE ;\
	 	return BaseClass::IsBasedON(wID);\
	}

class CFAXAPI TCFaxObject
 {
  protected:
#ifdef _THREAD
           HMUTEX  hMutex ;
#endif

  public:
           EXPDEF  TCFaxObject();	
           EXPDEF  ~TCFaxObject();
   virtual LPCSTR  TCClassName() const ;
   virtual WORD    TCClassID() const ;
   virtual BOOL    IsBasedON(WORD wId) const ;

#ifdef _THREAD
           DWORD   WaitForObject(DWORD dwMiliSec=10000);
           BOOL    ReleaseObject();
#endif

} ;
	

class TCLogFile;
    
class CFAXAPI  TCBuffer {
public:     
    EXPDEF	TCBuffer();
	EXPDEF  ~TCBuffer();
	EXPDEF	TCBuffer(short nSize);	
	short   EXPDEF  Realloc(short NewSize);
	short   EXPDEF GetSize() const {return nSize;};
	inline  EXPDEF operator LPBYTE (){return lpBytes;} ;
	inline  EXPDEF operator LPSTR  (){return LPSTR(lpBytes);} ;
	inline  LPBYTE EXPDEF  GetDataPtr() {return lpBytes;}; 
	virtual void  EXPDEF  Clear();
	short   EXPDEF  Set(LPCBYTE lpData,short nDataSize);
	short   EXPDEF  Append(LPCBYTE lpData,short nDataSize);
	BOOL    EXPDEF  Write(TCLogFile& File);
	BOOL    EXPDEF  Read(TCLogFile& hFile);
protected:

	LPBYTE 			lpBytes ;
	short				nSize ;	


} ; 

class CFAXAPI  TCStr: public TCBuffer
{
public:
	// the Constructors 
	EXPDEF	TCStr();
	EXPDEF	TCStr(LPCSTR lpStr);
	EXPDEF	TCStr(short iVal);
	EXPDEF	TCStr(unsigned short iVal);
	EXPDEF	TCStr(long lVal);
	EXPDEF	TCStr(unsigned long lVal);

	short EXPDEF  Append(LPCSTR lpStr);
	short EXPDEF  Append(const TCStr& rStr)	;

	short  EXPDEF Length() const ;
	short  EXPDEF Compress();
    LPSTR  EXPDEF lpStr();
	// Operators 
	TCStr&  EXPDEF operator  = (LPCSTR lpStr);
	inline  EXPDEF operator LPCSTR() const {return (LPCSTR(lpBytes));};
} ;

class CFAXAPI  TCLogFile {
	friend class TCLog ;
protected:
#ifdef _THREAD
	HANDLE hFile ;
#else 
	HFILE  hFile ;
#endif	
	TCStr  FileName ;        
	BOOL   bReadOnly ; 
public:
	  TCLogFile()	;
	  ~TCLogFile();

	virtual void   CloseFile();
	virtual BOOL   OpenFile(LPCSTR lpFileName,BOOL bReadOnly=FALSE, BOOL bDelete = TRUE);
	virtual BOOL   IsOpen();

	virtual BOOL   Read(LPVOID lpData,DWORD dwSize);
	virtual BOOL   Write(LPVOID lpData,DWORD dwSize);
	virtual BOOL   Write(short Sh);
	virtual BOOL   Read(short & Sh);
	virtual BOOL   Write(DWORD dwVal);
	virtual BOOL   Read(DWORD & dwVal);
	virtual BOOL   Write(WORD wVal);
	virtual BOOL   Read(WORD &wVal);
	virtual BOOL   SeekToEnd();
	virtual DWORD   GetFilePointer();
	virtual BOOL    SeekTo(DWORD dwSeek);
	virtual BOOL    CopyFile(TCLogFile & ErrFile);
	LPCSTR   	    GetName();
};


class CFAXAPI  TCLogRecord {
	friend class TCLog ;
public:
	EXPDEF TCLogRecord();
	EXPDEF ~TCLogRecord();

	virtual BOOL EXPDEF  FormatStr(TCStr& Str,BOOL bCRLF=TRUE);
	WORD      EXPDEF GetClass(){return wClass;};
static void   EXPDEF Delete(TCLogRecord* lpRec);
 	DWORD    EXPDEF Time()  {return dwTime;}; 

protected:

	virtual void   SetData(LPCBYTE lpData,short nSize);
	virtual void   AppendData(LPCBYTE lpData,short nSize);

	virtual void   Dump();
	virtual LPCSTR   RecordName();

	virtual BOOL   Write(TCLogFile& File);
	virtual BOOL   Read(TCLogFile&  File);

	BOOL      Get(WORD   & wData);
	BOOL      Get(DWORD  & dwData);
	BOOL      Get(LPSTR lpBuffer,int Max );

protected:
	short       ReadPtr ;
	WORD		wClass  ;
	DWORD		dwTime ;
	TCBuffer 	theData ;
} ;


class CFAXAPI  TCLog {
	
protected:
	static	DWORD dwSerial   ;
			DWORD dwObjectID ;
	TCLogRecord    *Current  ;
public:	
	TCLogFile      LogFile  ;
public:
	EXPDEF  TCLog();
	EXPDEF  ~TCLog();
	void	 EXPDEF	  	WriteLog(TCLogRecord &LRec);
	BOOL	 EXPDEF	  	OpenLog(LPCSTR lpLogNameName,BOOL bReadOnly,BOOL bDelete = TRUE);
	void     EXPDEF       CloseLog() ;
	BOOL	 EXPDEF	  	SeekToEnd();

	TCLogRecord*  EXPDEF	GetCurrent();
	BOOL		  EXPDEF 	PutLog(WORD Class,LPCBYTE lpByte,short nSize);
	BOOL  		  EXPDEF	PutLog(WORD wClass,WORD  wData);
	BOOL		  EXPDEF 	PutLog(WORD wClass,DWORD dwData);			

	void		  EXPDEF	Commit();
	TCLogRecord*  EXPDEF	Create(WORD Class); 

	TCLogRecord*  EXPDEF  ReadLog();

};

//======================
// Access System log 
//=======================

void  FAXAPI16 PutLog(WORD wClass,LPCBYTE lpByte,short nSize);
void  FAXAPI16 PutLog(WORD wClass,WORD  wData);
void  FAXAPI16 PutLog(WORD wClass,DWORD wData);			
void  FAXAPI16 PutLog(WORD wClass,LPCSTR lpStr);			
void  FAXAPI16 CommitLog();
void  FAXAPI16 CommentLog(LPCSTR lpComment);
BOOL  FAXAPI16 OpenSystemLog(LPCSTR lpFileName);
void  FAXAPI16 CloseSystemLog();


#endif
