/****************************************************************************/
/* mmr.h    (c) Copyright Black Ice Software Inc.  1989 - 1991             */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/****************************************************************************/
/***************************************************************************
 Module
      mmr.h

 Revision

 Description
      Declaration of functions and macros used in MMR file manipulation.

 Notes
      The function definitions are in TIFF.C .

 
   Initial revision.
***************************************************************************/

typedef struct  tagIOCA
  {
  DWORD     dwSegLength;     // Segment length
  WORD      wImgType;        // begin Image Content "FF" IOCA	     
  WORD      wImgHResolution; // Image vertical resolution     
  WORD      wImgVResolution; // image horizontal resolution
  WORD      wHSize;          // Image Width
  WORD      wVSize;          // Image Height
  WORD      wCompression;    // Image Compression
  WORD      wFirstImgSize;   // First image block size in bytes
  LONG      lFirstImgOffset; // First image block offset in the file
  } IOCA;

typedef IOCA FAR * LPIOCA;

#ifndef DEF_FILLPROC	/* (NGY) */
#define DEF_FILLPROC
#ifdef STRICT
typedef int (CALLBACK *FILLPROC)(LPSTR lpLineBuff, int nLine, LONG lParam);
#else
typedef int (CALLBACK *FILLPROC)();
#endif
#endif

BOOL CALLBACK ReadIOCAHeader(int nFile, LPIOCA lpIoca);
BOOL CALLBACK ReadMODCAHeader(int nFile, LPIOCA lpIoca);

BOOL CALLBACK DecodeMMRImage(int nFile, long lOffset,
			     UINT wWidth, UINT wHeight,
			     UINT dwCompression, int  nFillOrder,
			     UINT wByteOrder, LONG lUserData,
			     FILLPROC lpLineFn);

BOOL CALLBACK EncodeMMRImage(int nFile, UINT wWidth, UINT wHeight,
			     UINT dwCompression, LONG lUserData,
			     FILLPROC lpLineFn);

BOOL CALLBACK WriteIOCAHeader(int nFile, LPIOCA lpIoca);
BOOL CALLBACK WriteIOCATail(int nFile);

/* Not Documented Functions */
BOOL CALLBACK WriteMODCAHeader(int nFile, LPIOCA lpIoca);
BOOL CALLBACK WriteMODCATail(int nFile);

