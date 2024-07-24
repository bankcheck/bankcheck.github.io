/****************************************************************************/
/*            (c) Copyright Black Ice Software Inc.  1996.                  */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/*                                                                          */
/****************************************************************************/


#ifndef __PORT32_H

#if _MSC_VER >= 800
#pragma warning(disable: 4001 4201 4514 4699 4705 4005)
#endif

#if defined(__FLAT__) || defined(_WIN32)

//  Win32 definitions
#ifndef WIN32
#define WIN32
#endif

#define WIN32_LEAN_AND_MEAN
#define NONLS
#define NOSOUND


#define huge
#define _huge
#define __huge
#define _export
#define _loadds

#define HMUTEX HANDLE
#define HEVENT HANDLE


#ifndef _fmemcpy    /* there is in windowsx.h */
#define _fmemcpy(a,b,c)  memcpy(a,b,c)
#define _fmemset(a,b,c)  memset(a,b,c)
#define _fstrcpy(a,b)    strcpy(a,b)
#define _fstrlen(a)      strlen(a)
#define _fstrrchr(a,b)   strrchr(a,b)
#define _fstrcat(a,b)    strcat(a,b)

#define _fstrchr(a,b)    strchr(a,b)
#define _fstrtok(a,b)    strtok(a,b)

#define FAXAPI  __declspec(dllexport)
#define CFAXAPI  FAXAPI
#define FAXAPI16 CALLBACK
#define EXPDEF
#define HCOMDEV HANDLE



#endif      /* windowsx.h  */

#define  hmemcpy(a,b,c)  memcpy(a,b,(int)(c))
#define INVALID_HANDLE (NULL)
#else       /*  WIN32 */

// Win 16 Definitions

#define INVALID_HANDLE  ((HANDLE)32 )

#define FAXAPI
#define CFAXAPI  _far
#define FAXAPI16 _export CALLBACK
//#define EXPDEF _export _loadds
#define EXPDEF _export CALLBACK

#define HMUTEX  //
#define HEVENT  //

#define HCOMDEV int

#endif      /*  WIN32 */

#endif      /*  __PORT32_H  */
