/*
*  $Log:   K:\archive\faxsrc40\inc\colorfax.h  $
 * 
 *    Rev 4.35   24 Mar 1998 12:23:26   Zoltan
 * No change.
 * 
 *    Rev 4.34   01 Dec 1997 14:12:20   Zoltan
 * 
 *    Rev 4.32   26 Aug 1997 19:14:28   Gyuri
 * No change.
 * 
 *    Rev 4.31   03 Feb 1997 10:19:32   joe
 * 
 * MH
 * 
 *    Rev 4.30   28 Oct 1996 17:56:02   joe
 * 
 *    Rev 4.29   03 Oct 1996 13:38:44   joe
 *
 *    Rev 4.27   08 May 1996 15:09:18   joe
 *
 *    Rev 4.1   27 Apr 1996 15:28:12   Gyuri
 * Initial revision.
 *
 *    Rev 4.21   22 Mar 1996 15:47:38   Albert
 * No change.
 *
 *    Rev 4.20   21 Mar 1996 16:33:44   Albert
 * No change.
 *
 *    Rev 4.7   15 Mar 1996 10:14:14   Albert
 *
 *    Rev 4.6   14 Mar 1996 15:06:20   Albert
 * No change.
 *
 *    Rev 4.5   09 Mar 1996 19:05:10   Albert
 * No change.
 *
 *    Rev 4.4   09 Mar 1996 12:44:30   Albert
 * No change.
 *
 *    Rev 4.3   08 Mar 1996 14:54:20   Albert
 * No change.
 *
 *    Rev 4.2   08 Mar 1996 11:38:00   Albert
 * No change.
 *
 *    Rev 4.1   05 Mar 1996 17:54:38   Albert
 * No change.
 *
 *    Rev 4.0   05 Mar 1996 10:08:48   Albert
 * Initial revision.
 *
 *    Rev 0.911   03 Mar 1996 13:35:30   Albert
 * No change.
 *
 *    Rev 0.910   02 Mar 1996 15:32:24   Albert
 * No change.
 *
 *    Rev 0.901   01 Mar 1996 13:17:00   Albert
 *
 * Work Win16
 *
 *    Rev 0.900   27 Feb 1996 10:03:38   Albert
 * No change.
 *
 *    Rev 0.803   21 Feb 1996 09:45:52   Albert
 * No change.
 *
 *    Rev 0.802   15 Feb 1996 11:27:12   Albert
 * No change.
 *
 *    Rev 0.801   13 Feb 1996 12:40:50   Albert
 * No change.
 *
 *    Rev 0.800   08 Feb 1996 16:56:28   Albert
 * Initial revision.
 *
 *    Rev 3.280   15 Dec 1995 09:57:26   Albert
 * No change.
 *
 *    Rev 3.251   12 Dec 1995 13:33:18   Albert
 *
 *    Rev 3.250   22 Nov 1995 15:19:42   Albert
 * Initial revision.
 *
 *    Rev 6.190   01 Nov 1995 14:42:46   Albert
 * Initial revision.
*/
//****************************************************************************
// Include

#ifndef _COLORFAX_H
#define _COLORFAX_H

#include "faxclass.h"
#include "globerr.h"

#pragma pack(4)
//****************************************************************************
// TCColorFax

class FAXAPI far TCColorFax : public TCFaxNormal
{
protected:
    TEColorType  ColorType ;
    virtual LPSTR PageFileName(int nPage);
public:
    //-------------------------------------------------------------
    static FAXOBJ CALLBACK CreateTCColorFax(BOOL Send);
    //-------------------------------------------------------------
    EXPDEF TCColorFax(BOOL Send);
    EXPDEF ~TCColorFax();

    int  EXPDEF SetParam (TSFaxParam far &Param);
    void EXPDEF GetParam (TSFaxParam far &Param);

    int  EXPDEF SetImagePage (int PageNum, TEImageType Type, TUFaxImage far &Image, int ImageNum);
    int  EXPDEF GetImagePage (int PageNum, TEImageType Type, TUFaxImage far &Image, int Append);

    char EXPDEF GetFaxType ();
    int  EXPDEF ReadFaxData(LPSTR Data,int Size);
    int  EXPDEF WriteFaxData (LPSTR Data, int Size);
//    virtual int EXPDEF  ReadImgData(HFILE hFile);
//    virtual int EXPDEF  WriteImgData(HFILE hFile);
};
#pragma pack()
#endif
