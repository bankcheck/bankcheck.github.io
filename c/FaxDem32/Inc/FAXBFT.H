/****************************************************************************/
/*            (c) Copyright Black Ice Software Inc.  1994.                  */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/*                                                                          */
/*                                                                          */
/****************************************************************************/

#ifndef __FAXBFT_H
#define __FAXBFT_H

//****************************************************************************
// Include
#include "faxclass.h"
#include "globerr.h"

#pragma pack(4)

//****************************************************************************
// ENUMs
enum TEBftAction {BFA_read, BFA_insert, BFA_replace, BFA_extend, BFA_erase};

enum TEBftDataID {BFD_filename,                         // string,0,string,0...string00
                  BFD_permitted_actions,                // integer (use TEBftAction 2 byte)
                  BFD_date_and_time_of_creation,        // Generalized time - 0 termited string
                  BFD_date_and_time_last_modification,  // Generalized time - 0 termited string
                  BFD_identity_of_last_modifier,        // Generalized time - 0 termited string
                  BFD_filesize,                         // DWORD
                  BFD_private_use,                      // Binary Data
                  BFD_application_reference,            // string,0,string,0...string00
                  BFD_machine,                          // string,0,string,0...string00
                  BFD_enviroment,                       // string,0,string,0...string00
                  BFD_pathname,                         // string,0,string,0...string00
                  BFD_user_visible_string,              // string,0,string,0...string00
                  BFD_compression,                      // string,0,string,0...string00
                  BFD_data_file_content_FILE,           // Give the file name of binary data
                  BFD_data_file_content_BINARY,         // Binary Data
                  BFD_END
                  };

//****************************************************************************
// TSParamData
struct TSParamData
{
    long    Size;
    LPBYTE  Data;
};
//****************************************************************************
// TCBinaryParam class
class far TCFaxBinaryFile;

class CFAXAPI TCBinaryParam
{
friend
    TCFaxBinaryFile;
    
public:
    TCBinaryParam();
    virtual ~TCBinaryParam();
    
    //---------------------------------------------------
    virtual long WriteValue (TEBftDataID DataID, LPBYTE Data, long Size); // write in this object
    virtual long ReadValue (TEBftDataID DataID, LPBYTE Data, long Size);
    //---------------------------------------------------
    virtual PTCBinaryParam GetNextBinaryParam ();
    virtual PTCBinaryParam GetLastBinaryParam ();
    virtual int AddNewBinaryParam (PTCBinaryParam Param);
    //---------------------------------------------------
    virtual int ClearAllData ();

protected:

   	TCGlobError xerr;				/* for normal member functions */
#ifdef _VISUALC7
	long Encoding(ofstream &os, BOOL First=TRUE); // return < 0 error; > 0 writted byte
	long Decoding(ifstream &os, BOOL First=TRUE); // return < 0 error; > 0 left byte
#else
	virtual long Encoding(ofstream &os, BOOL First=TRUE); // return < 0 error; > 0 writted byte
	virtual long Decoding(ifstream &os, BOOL First=TRUE); // return < 0 error; > 0 left byte
#endif

    PTCBinaryParam  Next;
    PTCBinaryParam  Last;
    
    TSParamData ParamData[BFD_END];

private:
};
//****************************************************************************
// TCFaxBinaryFile class
class CFAXAPI TCFaxBinaryFile : public TCFaxNormal
{
public:
    //-------------------------------------------------------------
    static FAXOBJ CALLBACK CreateTCFaxBinaryFile (BOOL Send);
    //-------------------------------------------------------------
    EXPDEF TCFaxBinaryFile (BOOL Send);
	EXPDEF ~TCFaxBinaryFile ();    
	
    virtual int EXPDEF SetParam (TSFaxParam far &Param);
	virtual int EXPDEF SetImagePage (int PageNum, TEImageType Type, TUFaxImage far &Image, int ImageNum);
    virtual int EXPDEF GetImagePage (int PageNum, TEImageType Type, TUFaxImage far &Image, int ImageNum);
    
    virtual char EXPDEF GetCompatibleFaxType (LPSTR RemoteTypes);
    
    virtual char EXPDEF GetFaxType ();
	int  EXPDEF ReadFaxData(LPSTR Data,int Size);    
	int  EXPDEF WriteFaxData (LPSTR Data, int Size);

protected:
    
private:
};
//*****************************************************************************
#pragma pack()
#endif  // __FAXBFT_H 
 
