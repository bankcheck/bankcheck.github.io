/****************************************************************************/
/*            (c) Copyright Black Ice Software Inc.  1994.                  */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/*                                                                          */
/*                                                                          */
/****************************************************************************/

/* $Log:   K:\archive\faxsrc40\inc\log.h  $
 * 
 *    Rev 1.0   24 Mar 1998 12:25:16   Zoltan
 * Initial revision.
 * 
 *    Rev 4.28   29 Jan 1997 18:03:00   joe
 * pragma pack(4)
 * 
 *    Rev 4.27   08 May 1996 14:56:18   joe
 * 
 *    Rev 4.21   22 Mar 1996 15:47:34   Albert
 * 
*/

#ifndef _LOG_H
#define _LOG_H

#pragma pack(4)

#define LOG_PORTREAD        1
#define LOG_PORTWRITE       2
#define LOG_WRITEBINARY     3
#define LOG_SENDCOMMAND     4
#define LOG_REPLAYLINE      5
#define LOG_CONTROLMESSAGE  6
#define LOG_COMMENT         7
#define LOG_RECEIVELINE     8
#define LOG_TRACE           9
#define LOG_SENDHDLC       10
#define LOG_RECEIVEHDLC    11
#define LOG_PHASE          12
#define LOG_DOCUMENT       13
#define LOG_MODEMSTATUS    14
#define LOG_TIMEOUT        15
#define LOG_TERMINATE      16
#define LOG_WRITEPAGE      17
#define LOG_READPAGE       18  
#define LOG_PROCESS        19
#define LOG_LINEERROR      20
#define LOG_CONTROL        21

#define LOG_FUNCCALL       22
#define LOG_FAXMNG         23
#define LOG_ERRORMSG       24

#define LOG_SETMODE        25
#define LOG_SETREMOTE      26
#define LOG_SETMODEM       27

//
//
//
class TCVLogFile;
    
class CVOICEAPI  TCVBuffer {
public:     
    EXPDEF	TCVBuffer();
	EXPDEF  ~TCVBuffer();
	EXPDEF	TCVBuffer(short nSize);	
	short   EXPDEF  Realloc(short NewSize);
	short   EXPDEF GetSize() const {return nSize;};
	inline  EXPDEF operator LPBYTE (){return lpBytes;} ;
	inline  EXPDEF operator LPSTR  (){return LPSTR(lpBytes);} ;
	inline  LPBYTE EXPDEF  GetDataPtr() {return lpBytes;}; 
	virtual void  EXPDEF  Clear();
	short   EXPDEF  Set(LPCBYTE lpData,short nDataSize);
	short   EXPDEF  Append(LPCBYTE lpData,short nDataSize);
	BOOL    EXPDEF  Write(TCVLogFile& File);
	BOOL    EXPDEF  Read(TCVLogFile& hFile);
protected:

	LPBYTE 			lpBytes ;
	short				nSize ;	


} ; 

class CVOICEAPI  TCVStr: public TCVBuffer
{
public:
	// the Constructors 
	EXPDEF	TCVStr();
	EXPDEF	TCVStr(LPCSTR lpStr);
	EXPDEF	TCVStr(short iVal);
	EXPDEF	TCVStr(unsigned short iVal);
	EXPDEF	TCVStr(long lVal);
	EXPDEF	TCVStr(unsigned long lVal);

	short EXPDEF  Append(LPCSTR lpStr);
	short EXPDEF  Append(const TCVStr& rStr)	;

	short  EXPDEF Length() const ;
	short  EXPDEF Compress();
    LPSTR  EXPDEF lpStr();
	// Operators 
	TCVStr&  EXPDEF operator  = (LPCSTR lpStr);
	inline  EXPDEF operator LPCSTR() const {return (LPCSTR(lpBytes));};
} ;

class CVOICEAPI  TCVLogFile {
	friend class TCVLog ;
protected:
#ifdef _THREAD
	HANDLE hFile ;
#else 
	HFILE  hFile ;
#endif	
	TCVStr  FileName ;        
	BOOL   bReadOnly ; 
public:
	  TCVLogFile()	;
	  ~TCVLogFile();

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
	virtual BOOL    CopyFile(TCVLogFile & ErrFile);
	LPCSTR   	    GetName();
};


class CVOICEAPI  TCVLogRecord {
	friend class TCVLog ;
public:
	EXPDEF TCVLogRecord();
	EXPDEF ~TCVLogRecord();

	virtual BOOL EXPDEF  FormatStr(TCVStr& Str,BOOL bCRLF=TRUE);
	WORD      EXPDEF GetClass(){return wClass;};
static void   EXPDEF Delete(TCVLogRecord* lpRec);
 	DWORD    EXPDEF Time()  {return dwTime;}; 

protected:

	virtual void   SetData(LPCBYTE lpData,short nSize);
	virtual void   AppendData(LPCBYTE lpData,short nSize);

	virtual void   Dump();
	virtual LPCSTR   RecordName();

	virtual BOOL   Write(TCVLogFile& File);
	virtual BOOL   Read(TCVLogFile&  File);

	BOOL      Get(WORD   & wData);
	BOOL      Get(DWORD  & dwData);
	BOOL      Get(LPSTR lpBuffer,int Max );

protected:
	short       ReadPtr ;
	WORD		wClass  ;
	DWORD		dwTime ;
	TCVBuffer 	theData ;
} ;


class CVOICEAPI  TCVLog {
	
protected:
	static	DWORD dwSerial   ;
			DWORD dwObjectID ;
	TCVLogRecord    *Current  ;
public:	
	TCVLogFile      LogFile  ;
public:
	EXPDEF  TCVLog();
	EXPDEF  ~TCVLog();
	void	 EXPDEF	  	WriteLog(TCVLogRecord &LRec);
	BOOL	 EXPDEF	  	OpenLog(LPCSTR lpLogNameName,BOOL bReadOnly,BOOL bDelete = TRUE);
	void     EXPDEF       CloseLog() ;
	BOOL	 EXPDEF	  	SeekToEnd();

	TCVLogRecord*  EXPDEF	GetCurrent();
	BOOL		  EXPDEF 	PutLog(WORD Class,LPCBYTE lpByte,short nSize);
	BOOL  		  EXPDEF	PutLog(WORD wClass,WORD  wData);
	BOOL		  EXPDEF 	PutLog(WORD wClass,DWORD dwData);			

	void		  EXPDEF	Commit();
	TCVLogRecord*  EXPDEF	Create(WORD Class); 

	TCVLogRecord*  EXPDEF  ReadLog();

};

//======================
// Access System log 
//=======================

void  VOICEAPI16 PutLog(WORD wClass,LPCBYTE lpByte,short nSize);
void  VOICEAPI16 PutLog(WORD wClass,WORD  wData);
void  VOICEAPI16 PutLog(WORD wClass,DWORD wData);			
void  VOICEAPI16 PutLog(WORD wClass,LPCSTR lpStr);			
void  VOICEAPI16 CommitLog();
void  VOICEAPI16 CommentLog(LPCSTR lpComment);
BOOL  VOICEAPI16 OpenSystemLog(LPCSTR lpFileName);
void  VOICEAPI16 CloseSystemLog();



//
//
//
class  StringLog : public TCVLogRecord 
{
public:
     StringLog();
    void  Out(TCVStr & Str);
    inline static TCVLogRecord *  Create(){return new StringLog;};
    void  AppendData(LPCBYTE lpData,short nSize);
    BOOL  EXPDEF FormatStr(TCVStr& Str,BOOL bCRLF=TRUE);
} ;

class  SendCommandLog : public StringLog
{
public:
    SendCommandLog() { wClass=LOG_SENDCOMMAND; };
    inline static TCVLogRecord * Create(){return new SendCommandLog;};
    inline LPCSTR RecordName() {return "Modem Command";};
} ;

class ReplayLineLog : public StringLog
{
public:
    ReplayLineLog() { wClass=LOG_REPLAYLINE; };
    inline static TCVLogRecord * Create(){return new ReplayLineLog;};
    inline LPCSTR RecordName() {return "Modem Replay";};
} ;
//=============================================
//
//=============================================
#define LD_SEND_START       1
#define LD_SEND_START_DOC   2
#define LD_SEND_END_DOC     3
#define LD_SEND_START_PAGE  4
#define LD_SEND_END_PAGE    5
#define LD_SEND_END         6

#define LD_REC_START        11
#define LD_REC_START_DOC    12
#define LD_REC_END_DOC      13
#define LD_REC_START_PAGE   14
#define LD_REC_END_PAGE     15
#define LD_REC_END          16

class Log_Document : public TCVLogRecord
{
public: 
    Log_Document() {wClass = LOG_DOCUMENT;};
    inline static TCVLogRecord * Create(){return new Log_Document;};
    inline LPCSTR RecordName() {return "Document";};

    BOOL EXPDEF FormatStr(TCVStr& Str,BOOL bCRLF=TRUE);

} ;

class Log_ModemStatus : public TCVLogRecord
{
public:
    Log_ModemStatus() {wClass = LOG_MODEMSTATUS ;};
    inline static TCVLogRecord * Create(){return new Log_ModemStatus ;};
    inline LPCSTR RecordName() {return "Modem Status";};

    BOOL EXPDEF FormatStr(TCVStr& Str,BOOL bCRLF=TRUE);
} ;

class Log_Timeout : public TCVLogRecord
{
public:
    Log_Timeout() {wClass = LOG_TIMEOUT  ;};
    inline static TCVLogRecord * Create(){return new Log_Timeout;};
    inline LPCSTR RecordName() {return "Timeout";};

    BOOL EXPDEF FormatStr(TCVStr& Str,BOOL bCRLF=TRUE);

} ;

class Log_ReadPage: public TCVLogRecord
{
public:
    Log_ReadPage() {wClass = LOG_READPAGE ;};
    inline static TCVLogRecord * Create(){return new Log_ReadPage;};
    inline LPCSTR RecordName() {return "Read Page Data";};

    BOOL EXPDEF FormatStr(TCVStr& Str,BOOL bCRLF=TRUE);
} ;

class Log_WritePage: public TCVLogRecord
{
public:
    Log_WritePage() {wClass = LOG_WRITEPAGE ;};
    inline static TCVLogRecord * Create(){return new Log_WritePage;};
    inline LPCSTR RecordName() {return "Write Page Data";};

    BOOL EXPDEF FormatStr(TCVStr& Str,BOOL bCRLF=TRUE);
} ;

#define PROC_START 1
#define PROC_END   2

class Log_Process: public TCVLogRecord
{
public:
    Log_Process() {wClass = LOG_PROCESS;};
    inline static TCVLogRecord * Create(){return new Log_Process;};
    inline LPCSTR RecordName() {return "Process";};

    BOOL EXPDEF FormatStr(TCVStr& Str,BOOL bCRLF=TRUE);
} ;

class Log_LineError: public TCVLogRecord
{
public:
    Log_LineError() {wClass = LOG_LINEERROR ;};
    inline static TCVLogRecord * Create(){return new Log_LineError;};
    inline LPCSTR RecordName() {return "Line Error";};

    BOOL EXPDEF FormatStr(TCVStr& Str,BOOL bCRLF=TRUE);
} ;

class Log_Control: public TCVLogRecord
{
public:
    Log_Control() {wClass = LOG_CONTROL ;};
    inline static TCVLogRecord * Create(){return new Log_Control;};
    inline LPCSTR RecordName() {return "Control";};

    BOOL EXPDEF FormatStr(TCVStr& Str,BOOL bCRLF=TRUE);
} ;

class Log_FuncCall : public StringLog
{
public:
    Log_FuncCall() {wClass = LOG_FUNCCALL ;};
    inline static TCVLogRecord * Create(){return new Log_FuncCall;};
};

class Log_Trace : public StringLog
{
public:
    Log_Trace() {wClass = LOG_TRACE ;};
    inline static TCVLogRecord * Create(){return new Log_Trace;};
};

class  Log_Faxmng : public TCVLogRecord
{
public:
    Log_Faxmng() {wClass = LOG_FAXMNG ;};
    inline static TCVLogRecord * Create(){return new Log_Faxmng;};

    BOOL EXPDEF FormatStr(TCVStr& Str,BOOL bCRLF=TRUE);
};

class Log_ErrorMsg : public StringLog
{
public:
    Log_ErrorMsg() {wClass = LOG_ERRORMSG ;};
    inline static TCVLogRecord * Create(){return new Log_ErrorMsg;};
};

class FunctionCall 
{
    TCVStr Name ;
    TCVLog * lpLog ;
public:
    FunctionCall(LPCSTR lpFuncName,TCVLog* lpLog=NULL);
    ~FunctionCall();
};
#define	FC(a,b) FunctionCall fc((a),(b))

class Log_SetMode : public TCVLogRecord 
{
public:
    Log_SetMode() {wClass = LOG_SETMODE ;};
    inline static TCVLogRecord * Create(){return new Log_SetMode;};  
    inline BOOL EXPDEF  FormatStr(TCVStr& Str,BOOL ){
        Str = "SET SESSION" ;
        return FALSE ;
    } ;
};

class Log_SetRemoteMode : public TCVLogRecord 
{
public:
    Log_SetRemoteMode() {wClass = LOG_SETREMOTE ;};
    inline static TCVLogRecord * Create(){return new Log_SetRemoteMode;};    
    inline BOOL EXPDEF FormatStr(TCVStr& Str,BOOL ){
        Str = "REMOTE MODEM" ;
        return TRUE ;
    } ;
};

class Log_SetLocalModem : public TCVLogRecord 
{
public:
    Log_SetLocalModem() {wClass = LOG_SETMODEM ;};
    inline static TCVLogRecord * Create(){return new Log_SetLocalModem;};    
    inline BOOL EXPDEF FormatStr(TCVStr& Str,BOOL ){
        Str = "SET COMPATIBILITY" ;
        return TRUE ;
    } ;
};

void TraceMSG(LPCSTR Format,LPCSTR Str=NULL,LPCSTR Str2=NULL,LPCSTR Str3=NULL,LPCSTR Str4=NULL);
void TraceMSG(TCVLog &Log,LPCSTR Format,LPCSTR Str=NULL,LPCSTR Str2=NULL,LPCSTR Str3=NULL,LPCSTR Str4=NULL);

#pragma pack()

#endif
