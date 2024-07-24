/****************************************************************************/
/*            (c) Copyright Black Ice Software Inc.  1994.                  */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/*                                                                          */
/*                                                                          */
/****************************************************************************/
/*
  $Log:   K:\archive\faxsrc40\inc\cltestcl.h  $
 * 
 *    Rev 4.31   24 Mar 1998 12:23:28   Zoltan
 * No change.
 * 
 *    Rev 4.30   01 Dec 1997 14:12:30   Zoltan
 * 
 *    Rev 4.28   26 Aug 1997 19:14:30   Gyuri
 * No change.
 * 
 *    Rev 4.27   08 May 1996 15:09:32   joe
 * 
 *    Rev 4.21   22 Mar 1996 15:48:28   Albert
 * No change.
 * 
 *    Rev 4.20   21 Mar 1996 16:34:42   Albert
 * No change.
 * 
 *    Rev 4.8   20 Mar 1996 14:47:14   Albert
 * 
 * 
 *    Rev 4.7   16 Mar 1996 12:14:12   joe
 * No change.
 * 
 *    Rev 4.6   14 Mar 1996 15:07:12   Albert
 * No change.
 * 
 *    Rev 4.5   09 Mar 1996 19:06:38   Albert
 * No change.
 * 
 *    Rev 4.4   09 Mar 1996 12:45:08   Albert
 * No change.
 * 
 *    Rev 4.3   08 Mar 1996 14:55:04   Albert
 * No change.
 * 
 *    Rev 4.2   08 Mar 1996 11:37:08   Albert
 * No change.
 * 
 *    Rev 4.1   05 Mar 1996 17:55:16   Albert
 * 
 * Scanline Time fizxed
 * 
 *    Rev 4.0   05 Mar 1996 10:11:30   Albert
 * Initial revision.
 * 
 *    Rev 0.911   03 Mar 1996 13:37:36   Albert
 * No change.
 * 
 *    Rev 0.910   02 Mar 1996 15:34:04   Albert
 * No change.
 * 
 *    Rev 0.804   01 Mar 1996 13:19:08   Albert
 * No change.
 * 
 *    Rev 0.803   21 Feb 1996 09:46:58   Albert
 * 
 * 
 *    Rev 0.802   15 Feb 1996 11:41:08   Albert
 * No change.
 * 
 *    Rev 0.801   13 Feb 1996 12:41:24   Albert
 * No change.
 * 
 *    Rev 0.800   08 Feb 1996 16:58:56   Albert
 * Initial revision.
 * 
 *    Rev 3.280   15 Dec 1995 09:58:14   Albert
 * No change.
 * 
 *    Rev 3.250   20 Nov 1995 15:14:26   Albert
 * No change.
 * 
 *    Rev 3.170   17 Oct 1995 19:20:08   joe
 * No change.
 * 
 *    Rev 3.110   14 Sep 1995 12:48:38   Albert
 * No change.
 * 
 *    Rev 3.100   30 Aug 1995 16:25:42   Albert
 * Beta test version
*/

#ifndef  __cplusplus
    #error  "This inlude file must use with C++ compiler!"
#endif  // __cplusplus

#ifndef __CLTESTCL_H
#define __CLTESTCL_H

//****************************************************************************
// Include
#include "commcl.h"
#include "control1.h"
//****************************************************************************

//****************************************************************************

//****************************************************************************
class TCModemTest: public TCCommPure
{
public:
	TSTestResult TestResult ;
	BOOL         bModem ;
public:
    static PORTFAX CALLBACK CreateTCModemTest (LPSTR FaxShortName, LPSTR FileName);
    
    EXPDEF TCModemTest (LPSTR FaxName, LPSTR FileName);
	EXPDEF TCModemTest ();

    virtual EXPDEF  ~TCModemTest();
	long 	SendFaxEvent (TEFaxEvent Event, LPARAM lParam);

protected:
	TMControl* mcInitialSetup();
	TMControl* mcWait();
private:

};
//****************************************************************************
#endif // __CLTESTCL_H
