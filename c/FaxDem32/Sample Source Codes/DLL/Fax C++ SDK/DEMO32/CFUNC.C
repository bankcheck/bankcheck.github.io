/****************************************************************************/
/* loadtiff.c  (c) Copyright Black Ice Software Inc.  1989 - 1991           */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/****************************************************************************/
/**********************************************************************************
  Module

  Revision

  Description
                Image decoding demo sources for TIFF.DLL .

  Notes

  History
 *
 * IBS image reader improved
 *
 * Functions are returning with boolean value.
 * They set gPage.hCurrentBitmap internaly.
 *
 * This is a reference version.
 *
 *
 * CCITT image handling routines.
 *
 * Initial revision.
**********************************************************************************/


#if _MSC_VER >= 800
#pragma warning(disable:4699)
/* 4699: precompiled header */
#endif

#define CCITT_SUPPORT

#define TIFF_TAG_V6

/* #define WINVER     0x0300   */
#define STRICT
#include <windows.h>
#include <memory.h>
#include <io.h>
#include <stdio.h>
#include <string.h>

#include "port32.h"
#include "bitiff.h"
#include "bitmani.h"
#include "mmr.h"
#include "v_config.h"
#include "tools.h"
#include "CFunc.h"
#include "resource.h"

//----------------------------- External Functions ----------------------------

//----------------------------- External Variables ----------------------------

#define    WIDTHBYTES(i)  ((i+31)/32*4)


typedef struct tagBWBITMAPINFO {
      BITMAPINFOHEADER   bmiHeader;
      RGBQUAD            bmiColors[2];
} BWBITMAPINFO;


//------------------------------- Module Defines ------------------------------

#define PALETTESIZE     256
#define PALVERSION      0x300

/* macro to determine if resource is a DIB */
#define BFT_BITMAP 0x4d42   /* 'BM' */

#define ISDIB(bft)      ((bft) == BFT_BITMAP)

// typedef HANDLE HDIB;

// Macro for testing to fill a bitmap with black.
#define ERASEBITMAP(B,D,X,Y)                                         \
        {                                                            \
           HDC hTempDC;                                              \
           hTempDC = CreateCompatibleDC(D);                          \
           if (hTempDC)                                              \
           {                                                         \
              SelectObject(hTempDC,B);                               \
              BitBlt(hTempDC,0,0,(int)X,(int)Y,NULL,0,0,BLACKNESS);  \
              DeleteDC(hTempDC);                                     \
           }                                                         \
        }

#define SWAPRGB(BmInfo)                       \
        {                                     \
        BYTE X = BmInfo->bmiColors[0].rgbBlue; \
        BYTE Y = BmInfo->bmiColors[1].rgbBlue; \
        BmInfo->bmiColors[0].rgbBlue = Y;      \
        BmInfo->bmiColors[0].rgbGreen= Y;      \
        BmInfo->bmiColors[0].rgbRed  = Y;      \
        BmInfo->bmiColors[1].rgbBlue = X;      \
        BmInfo->bmiColors[1].rgbGreen= X;      \
        BmInfo->bmiColors[1].rgbRed  = X;      \
        }

//-------------------------------- Module Types -------------------------------

//------------------------------ Global Functions -----------------------------

// HBITMAP CALLBACK LoadCcittImage(LPSTR lpszFileName, UINT wCompression);

//------------------------------ Global Variables -----------------------------

BWBITMAPINFO BmInfo = {
    (DWORD)sizeof(BITMAPINFOHEADER),    // Type descriptor.
    0L,                                 // Width.
    0L,                                 // Height.
    1,                                  // Planes.
    1,                                  // Bits per pixel.
    0L,0L,0L,0L,
    2L,                                 // Colors used.
    2L,                                 // Colors important.
    0,0,0,0,                            // Black RGB.
    0xFF,0xFF,0xFF,0,                   // White RGB.
};

typedef struct  TagTIFFLINEDATA {
        HANDLE  hBitmapInfo;
        BYTE huge * lpBits;
        UINT    wHeight;
        UINT    wWidthBytes;
        UINT    wUsage;
} TIFFLINEDATA;

static  TIFFLINEDATA TiffLineData;

#ifdef WIN32

#define MakeFillProc(x, y)  x
#define FreeFillProc(x)

#else   /* WIN32 */

static FILLPROC MakeFillProc(FILLPROC fn, HINSTANCE hIn) {
    return (FILLPROC)MakeProcInstance((FARPROC)fn, hIn); }

static void FreeFillProc(FILLPROC fn) {
    FreeProcInstance((FARPROC)fn);
    return; }

#endif  /* WIN32 */



static  int CALLBACK FlushDIBLine(LPSTR lpLineBuff, int nLine, LONG lParam)
{
    TIFFLINEDATA far * lpTiffLineData = (TIFFLINEDATA far *)lParam;

    // copy into DIB
    hmemcpy(lpTiffLineData->lpBits+(DWORD)((DWORD)((int)lpTiffLineData->wHeight - ++nLine)*
             (DWORD)lpTiffLineData->wUsage), lpLineBuff, lpTiffLineData->wWidthBytes);

    return(TOK);
}


HANDLE LoadCcittToDIB(LPSTR lpszFileName, UINT wCompression, LONG lOffset,
    UINT wWidth, UINT wHeight, int bFillOrder, UINT bByteOrder, HINSTANCE hInst)
{
    FILLPROC    lpfnLineProc;
    TIFFLINEDATA    TiffLineData;
    LPBITMAPINFO    lpBmI = NULL;
    HANDLE          h;
    DWORD           dwLen;
    UINT            wWidthBytesOfOneLine;
    DWORD           dwMethod;
    HFILE           nFile;
    HCURSOR         hOldCursor;
        BOOL            bSuccess;

    hInst = hInst;

    switch(wCompression){
        case FORMAT_CCITT_G31D_NOEOL:
            dwMethod = TIFF_CCITT;
            break;
       case FORMAT_CCITT_G31D_EOL:
           dwMethod = CCITT_GROUP3;
           break;
       case FORMAT_CCITT_G32D:
//  NGY        dwMethod = MAKELONG(CCITT_GROUP3, CCITT_2D);
                   dwMethod = CCITT_GROUP3 | CCITT_2D;
           break;
       case FORMAT_CCITT_G4:
           dwMethod = CCITT_GROUP4;
           break;
       case FORMAT_RAW:
           dwMethod = NOCOMPRESSION;
           break;
       default:
            SetTiffError(TUNKNOWNCOMPRESSION);
            return 0;
    }

    nFile = _lopen(lpszFileName, OF_READ);
    if (nFile < 0) {      // Opening OK.
        SetTiffError(TFILEIOERROR);
        return  0;
    }
    _fmemset(&TiffLineData, 0, sizeof (TiffLineData));

    TiffLineData.hBitmapInfo = GlobalAlloc(GHND, sizeof(BWBITMAPINFO));
    if (TiffLineData.hBitmapInfo == NULL)
       return 0;

    // Creates an empty BITMAP.
    lpBmI = (LPBITMAPINFO)GlobalLock(TiffLineData.hBitmapInfo);
    if (lpBmI == NULL) {
        GlobalFree(TiffLineData.hBitmapInfo);
        SetTiffError(TNOTENOUGHMEMORY);         // Error flag default value.
        return 0;
    }
    _fmemcpy(lpBmI, &BmInfo, sizeof(BmInfo));
    lpBmI->bmiHeader.biWidth = wWidth;
    lpBmI->bmiHeader.biHeight = wHeight;

    wWidthBytesOfOneLine = (UINT)WIDTHBYTES((DWORD)lpBmI->bmiHeader.biWidth * (DWORD)lpBmI->bmiHeader.biBitCount);
    lpBmI->bmiHeader.biSizeImage = (DWORD)wWidthBytesOfOneLine * (DWORD)lpBmI->bmiHeader.biHeight;
    dwLen = lpBmI->bmiHeader.biSizeImage + sizeof(BWBITMAPINFO);
    GlobalUnlock(TiffLineData.hBitmapInfo);
    if((h=GlobalReAlloc(TiffLineData.hBitmapInfo, dwLen+100, GHND))== NULL) {
        GlobalFree(TiffLineData.hBitmapInfo);
        SetTiffError(TNOTENOUGHMEMORY);         // Error flag default value.
        return 0;
    }
  /*  GlobalFree(TiffLineData.hBitmapInfo);    NGY */
    TiffLineData.hBitmapInfo = h;
    lpBmI = (LPBITMAPINFO) GlobalLock(TiffLineData.hBitmapInfo);

    if (lpBmI == NULL) {
        GlobalFree(TiffLineData.hBitmapInfo);
        SetTiffError(TNOTENOUGHMEMORY);         // Error flag default value.
        return 0;
    }

    TiffLineData.lpBits  = (BYTE huge *)lpBmI + sizeof(BWBITMAPINFO);
    TiffLineData.wHeight = (UINT)lpBmI->bmiHeader.biHeight;
    TiffLineData.wUsage  = wWidthBytesOfOneLine;
    TiffLineData.wWidthBytes = ((UINT)lpBmI->bmiHeader.biWidth*
                                          lpBmI->bmiHeader.biBitCount + 7)/8;
    lpfnLineProc = MakeFillProc(FlushDIBLine, hInst);

    // Displays an hourglass-cursor and saves the original one.
    hOldCursor = SetCursor(LoadCursor(NULL,IDC_WAIT));

    // Fills the image in the bitmap.
    bSuccess = DecodeCcittImageFrom(nFile, lOffset,
            (UINT)lpBmI->bmiHeader.biWidth,
            (UINT)lpBmI->bmiHeader.biHeight,
                dwMethod, bFillOrder, bByteOrder,
            (LONG)(TIFFLINEDATA far *)&TiffLineData,
             lpfnLineProc);
    SetCursor(hOldCursor);
    if(!bSuccess) {
        int ee = TiffError();
        char buf[100];
        switch(ee) {
            case TENDOFDATA:
            case TNOEOFB:
            case TBADEOFB:
                TiffErrorString(buf, ee);
                MessageBox(NULL, buf, "TIFF warning",
                              MB_OK|MB_ICONEXCLAMATION);
                break;
            default:                         // real error.
                GlobalFree(TiffLineData.hBitmapInfo);
                return 0;
        }
    }

    // Frees the process instance.
    FreeFillProc(lpfnLineProc);

    GlobalUnlock(TiffLineData.hBitmapInfo);

    // Restores original cursor from hourglass-cursor.
    _lclose(nFile);

    return  TiffLineData.hBitmapInfo;
}

//////////////////////////////////////////////////////////////////////////////
// Save CCITT image file
//////////////////////////////////////////////////////////////////////////////

/**********************************************************************************
  Function
                FillDIBLine

  Parameters
                lpLineBuff        Bits of uncompressed line inDIB format.
                nLine             Line index counted from zero.
                lParam            User parameter passed unchanged.

  Returns
                Error status. TOK if OK.

  Description
                Fill the data buffer with a DIB line from the image.

  Notes
                None.

  Author
                H_G,    12/26/90                Initial version.
**********************************************************************************/

int CALLBACK FillDIBLine(LPSTR lpLineBuff, int nLine, LONG lParam)
{
    TIFFLINEDATA far * lpTiffLineData = (TIFFLINEDATA far *)lParam;

    // copy into DIB
    _fmemcpy(lpLineBuff, lpTiffLineData->lpBits+(DWORD)((DWORD)((int)lpTiffLineData->wHeight - nLine - 1)*
             (DWORD)lpTiffLineData->wUsage), lpTiffLineData->wWidthBytes);

    return(TOK);
}

BOOL SaveDIBCcitt(LPSTR lpszFileName,  HANDLE  hDIB, HINSTANCE hInst, UINT wCompression)
{
    UINT            wWidthBytesOfOneLine;
    TIFFLINEDATA    TiffLineData;
    LPBITMAPINFO    lpBmI;
    BOOL            bSuccess = FALSE;
    HCURSOR         hOldCur;
    FILLPROC        lpFillFarProc;
    DWORD           dwMethod;
    HFILE           nFile;
    OFSTRUCT        Dummy;

    hInst = hInst;
    lpBmI = (LPBITMAPINFO) GlobalLock(hDIB);

    if (lpBmI == NULL)
        return FALSE;

    switch(wCompression){
        case FORMAT_CCITT_G31D_NOEOL:
            dwMethod = TIFF_CCITT;
            break;
       case FORMAT_CCITT_G31D_EOL:
           dwMethod = CCITT_GROUP3;
           break;
       case FORMAT_CCITT_G32D:
//   NGY       dwMethod = MAKELONG(CCITT_GROUP3, CCITT_2D);
                   dwMethod = CCITT_GROUP3 | CCITT_2D;
           break;
       case FORMAT_CCITT_G4:
           dwMethod = CCITT_GROUP4;
           break;
       case FORMAT_RAW:
           dwMethod = NOCOMPRESSION;
           break;
       default:
            GlobalUnlock(hDIB);
            SetTiffError(TUNKNOWNCOMPRESSION);
            return FALSE;
    }

    nFile = OpenFile((LPSTR)lpszFileName,(LPOFSTRUCT)&Dummy,OF_CREATE|OF_WRITE);
    if(nFile > 0) {

        // Displays an hourglass-cursor and saves the original one.
        hOldCur = SetCursor(LoadCursor((HANDLE)0,IDC_WAIT));

        wWidthBytesOfOneLine= (UINT)WIDTHBYTES(lpBmI->bmiHeader.biWidth *
           lpBmI->bmiHeader.biBitCount);
        // Prepares callback function's pocedure instance.
        TiffLineData.wWidthBytes = (UINT)((lpBmI->bmiHeader.biWidth*
            lpBmI->bmiHeader.biBitCount+7)/8);
        lpFillFarProc = MakeFillProc(FillDIBLine, hInst);
        TiffLineData.lpBits  = (HPSTR)lpBmI + sizeof(BWBITMAPINFO);
        TiffLineData.wHeight = (UINT)lpBmI->bmiHeader.biHeight;
        TiffLineData.wUsage  = wWidthBytesOfOneLine;

        // Codes bitmap and writes data into TIFF file.
        bSuccess = EncodeCcittImage(nFile,
                (UINT)lpBmI->bmiHeader.biWidth,
            (UINT)lpBmI->bmiHeader.biHeight,
            dwMethod,
            (LONG)(TIFFLINEDATA far *)&TiffLineData,
                lpFillFarProc);

        // Restores original cursor from hourglass-cursor.
        _lclose(nFile);
        SetCursor(hOldCur);
    } else {
        MessageBox((HANDLE)0, "File creation error.", "TIFF error",
                   MB_OK | MB_ICONEXCLAMATION);
    }
    return(bSuccess);
}

//////////////////////////////////////////////////////////////////////////////
// Load IBM-MMR image file
//////////////////////////////////////////////////////////////////////////////

HANDLE LoadMMRToDIB(LPSTR lpszFileName, UINT wCompression, LONG lOffset,
    UINT wWidth, UINT wHeight, int bFillOrder, UINT bByteOrder, HINSTANCE hInst)
{
    FILLPROC            lpfnLineProc;
    TIFFLINEDATA    TiffLineData;
    LPBITMAPINFO    lpBmI = NULL;
    HANDLE          h;
    DWORD           dwLen;
    UINT            wWidthBytesOfOneLine;
    HFILE           nFile;
    HCURSOR         hOldCursor;
    BOOL            bSuccess;
    IOCA            Ioca;

    // Displays an hourglass-cursor and saves the original one.
    hOldCursor = SetCursor(LoadCursor(NULL,IDC_WAIT));

    hInst = hInst;
    nFile = _lopen(lpszFileName, T_READ);
    if (nFile < 0) {      // Opening OK.
        SetTiffError(TFILEIOERROR);
        SetCursor(hOldCursor);
        return  0;
    }
    _fmemset(&TiffLineData, 0, sizeof (TiffLineData));

    TiffLineData.hBitmapInfo = GlobalAlloc(GHND, sizeof(BWBITMAPINFO));

    // Creates an empty BITMAP.
    lpBmI = (LPBITMAPINFO) GlobalLock(TiffLineData.hBitmapInfo);
    if (lpBmI == NULL) {
        GlobalFree(TiffLineData.hBitmapInfo);
        SetTiffError(TNOTENOUGHMEMORY);         // Error flag default value.
        _lclose(nFile);
        SetCursor(hOldCursor);
        return 0;
    }
    _fmemcpy(lpBmI, &BmInfo, sizeof(BmInfo));       /* NGY */
    if(wCompression == FORMAT_IBM_MMR_IOCA) {
        bFillOrder = NORM_BIT_ORDER;
        bByteOrder = LH_BYTE_ORDER;
        if(ReadIOCAHeader(nFile,&Ioca) == FALSE) {
              GlobalUnlock(TiffLineData.hBitmapInfo);
              GlobalFree(TiffLineData.hBitmapInfo);
              _lclose(nFile);
              SetTiffError(TFILEIOERROR);
              SetCursor(hOldCursor);
              return    0;
        }
        wWidth  = Ioca.wHSize;
        wHeight = Ioca.wVSize;
        if(wWidth==0 || wHeight==0) {
              GlobalUnlock(TiffLineData.hBitmapInfo);
              GlobalFree(TiffLineData.hBitmapInfo);
              _lclose(nFile);
              SetTiffError(TFILEIOERROR);
              SetCursor(hOldCursor);
              return 0; }
        lpBmI->bmiHeader.biXPelsPerMeter = Ioca.wImgHResolution;
        lpBmI->bmiHeader.biYPelsPerMeter = Ioca.wImgVResolution;
        // the file pointer already at the beginning of image
        lOffset = Ioca.lFirstImgOffset;
    }

/*    _fmemcpy(lpBmI, &BmInfo, sizeof(BmInfo));   NGY   (wrong the biXPelsPerMeter member)*/
    lpBmI->bmiHeader.biWidth = wWidth;
    lpBmI->bmiHeader.biHeight = wHeight;

    wWidthBytesOfOneLine = (UINT)WIDTHBYTES((DWORD)lpBmI->bmiHeader.biWidth * (DWORD)lpBmI->bmiHeader.biBitCount);
    lpBmI->bmiHeader.biSizeImage = (DWORD)wWidthBytesOfOneLine * (DWORD)lpBmI->bmiHeader.biHeight;
    dwLen = lpBmI->bmiHeader.biSizeImage + sizeof(BWBITMAPINFO);
    GlobalUnlock(TiffLineData.hBitmapInfo);
    if((h=GlobalReAlloc(TiffLineData.hBitmapInfo, dwLen+1000, 0))== NULL) {
        GlobalFree(TiffLineData.hBitmapInfo);
        SetTiffError(TNOTENOUGHMEMORY);         // Error flag default value.
        _lclose(nFile);
        SetCursor(hOldCursor);
        return 0;
    }
    /* GlobalFree(TiffLineData.hBitmapInfo);    NGY */
    TiffLineData.hBitmapInfo = h;
    lpBmI = (LPBITMAPINFO) GlobalLock(TiffLineData.hBitmapInfo);

    if (lpBmI == NULL) {
        GlobalFree(TiffLineData.hBitmapInfo);
        SetTiffError(TNOTENOUGHMEMORY);         // Error flag default value.
        _lclose(nFile);
        SetCursor(hOldCursor);
        return 0;
    }

    TiffLineData.lpBits  = (BYTE huge *)lpBmI + sizeof(BWBITMAPINFO);
    TiffLineData.wHeight = (UINT)lpBmI->bmiHeader.biHeight;
    TiffLineData.wUsage  = wWidthBytesOfOneLine;
    TiffLineData.wWidthBytes = ((UINT)lpBmI->bmiHeader.biWidth*
                                          lpBmI->bmiHeader.biBitCount + 7)/8;
    lpfnLineProc = MakeFillProc(FlushDIBLine, hInst);


    SWAPRGB(lpBmI);

    // Fills the image in the bitmap.
    bSuccess = DecodeMMRImage(nFile, lOffset,
        (UINT)lpBmI->bmiHeader.biWidth, (UINT)lpBmI->bmiHeader.biHeight,
        wCompression, bFillOrder, bByteOrder,
        (LONG)(TIFFLINEDATA far *)&TiffLineData, lpfnLineProc);

    SWAPRGB(lpBmI);

    SetCursor(hOldCursor);

    if(!bSuccess) {
        int ee = TiffError();
        char buf[100];
        switch(ee) {
            case TENDOFDATA:
            case TNOEOFB:
            case TBADEOFB:
                TiffErrorString(buf, ee);
                MessageBox(NULL, buf, "TIFF warning",
                              MB_OK|MB_ICONEXCLAMATION);
                break;
            default:                         // real error.
                _lclose(nFile);
                GlobalUnlock(TiffLineData.hBitmapInfo);
                GlobalFree(TiffLineData.hBitmapInfo);
                return 0;
        }
    }

    // Frees the process instance.
    FreeFillProc(lpfnLineProc);

    GlobalUnlock(TiffLineData.hBitmapInfo);

    // Restores original cursor from hourglass-cursor.
    _lclose(nFile);

    return  TiffLineData.hBitmapInfo;
}

//////////////////////////////////////////////////////////////////////////////
// Save MMR image file
//////////////////////////////////////////////////////////////////////////////
BOOL SaveDIBMMR(LPSTR lpszFileName,  HANDLE  hDIB, HINSTANCE hInst, UINT wCompression)
{
    UINT            wWidthBytesOfOneLine;
    TIFFLINEDATA    TiffLineData;
    LPBITMAPINFO    lpBmI;
    BOOL            bSuccess = FALSE;
    HCURSOR         hOldCur;
    FILLPROC        lpFillFarProc;
    HFILE           nFile;
    OFSTRUCT        Dummy;
    IOCA            Ioca;

    hInst = hInst;
    lpBmI = (LPBITMAPINFO) GlobalLock(hDIB);

    if (lpBmI == NULL)
        return FALSE;

    nFile = OpenFile((LPSTR)lpszFileName,(LPOFSTRUCT)&Dummy,OF_CREATE|OF_WRITE);
    if(nFile > 0) {
        if(wCompression == FORMAT_IBM_MMR_IOCA) {
            Ioca.wHSize = (WORD)lpBmI->bmiHeader.biWidth;
            Ioca.wVSize = (WORD)lpBmI->bmiHeader.biHeight;
            Ioca.wImgHResolution = (WORD)lpBmI->bmiHeader.biXPelsPerMeter;  /* NGY */
            Ioca.wImgVResolution = (WORD)lpBmI->bmiHeader.biYPelsPerMeter;      /* NGY */
            if (WriteIOCAHeader(nFile, &Ioca) == FALSE) {
                GlobalUnlock(hDIB);
                _lclose(nFile);
                SetTiffError(TFILEIOERROR);
                return  FALSE;
             }
        }
        // Displays an hourglass-cursor and saves the original one.
        hOldCur = SetCursor(LoadCursor((HANDLE)0,IDC_WAIT));

        wWidthBytesOfOneLine= (UINT)WIDTHBYTES(lpBmI->bmiHeader.biWidth *
           lpBmI->bmiHeader.biBitCount);
        // Prepares callback function's pocedure instance.
        TiffLineData.wWidthBytes = (UINT)((lpBmI->bmiHeader.biWidth*
            lpBmI->bmiHeader.biBitCount+7)/8);
        lpFillFarProc = MakeFillProc(FillDIBLine, hInst);
        TiffLineData.lpBits  = (HPSTR)lpBmI + sizeof(BWBITMAPINFO);
        TiffLineData.wHeight = (UINT)lpBmI->bmiHeader.biHeight;
        TiffLineData.wUsage  = wWidthBytesOfOneLine;

        // Codes bitmap and writes data into TIFF file.
        bSuccess = EncodeMMRImage(nFile, (UINT)lpBmI->bmiHeader.biWidth,
            (UINT)lpBmI->bmiHeader.biHeight, 0, (LONG)(TIFFLINEDATA far *)&TiffLineData,
            lpFillFarProc);

        if(bSuccess && wCompression == FORMAT_IBM_MMR_IOCA)
            bSuccess = WriteIOCATail(nFile);

        if(bSuccess==FALSE)
            SetTiffError(TFILEIOERROR);

        _lclose(nFile);
        // Restores original cursor from hourglass-cursor.
        SetCursor(hOldCur);
    } else {
        MessageBox((HANDLE)0, "File creation error.", "TIFF error",
                   MB_OK | MB_ICONEXCLAMATION);
    }
    return(bSuccess);
}

//////////////////////////////////////////////////////////////////////////////
// Load Windows Bitmap file
//////////////////////////////////////////////////////////////////////////////

/*****************************************************************************
 Function
                  DibNumColors

 Parameters
                  long pointer to bitmapinfoheader

 Returns
                  The number of colors in the DIB

 Description
                  Determines the number of colors in the DIB by looking at
                  the BitCount filed in the info block


 Notes
                  None.

 Author
                  L_G, 07/27/90 10:50
*****************************************************************************/
static  UINT DibNumColors (VOID FAR * pv)
{
    int                 bits;
    LPBITMAPINFOHEADER  lpbi;
    LPBITMAPCOREHEADER  lpbc;

    lpbi = ((LPBITMAPINFOHEADER)pv);
    lpbc = ((LPBITMAPCOREHEADER)pv);

    /*  With the BITMAPINFO format headers, the size of the palette
     *  is in biClrUsed, whereas in the BITMAPCORE - style headers, it
     *  is dependent on the bits per pixel ( = 2 raised to the power of
     *  bits/pixel).
     */
    if (lpbi->biSize != sizeof(BITMAPCOREHEADER)){
        if (lpbi->biClrUsed != 0)
            return (UINT)lpbi->biClrUsed;
        bits = lpbi->biBitCount;
    }
    else
        bits = lpbc->bcBitCount;

    switch (bits){
        case 1:
                return 2;
        case 4:
                return 16;
        case 8:
                return 256;
        default:
                /* A 24 bitcount DIB has no color table */
                return 0;
    }
}


/*****************************************************************************
 Function
              ReadDibBitmapInfo

 Parameters
              fh => DOS filehandler

 Returns
              A handle to the BITMAPINFO of the DIB in the file

 Description
              Will read a file in DIB format and return a global HANDLE
              to it's BITMAPINFO.  This function will work with both
              "old" (BITMAPCOREHEADER) and "new" (BITMAPINFOHEADER)
              bitmap formats, but will always return a "new" BITMAPINFO


 Notes
              None.

 Author
              L_G, 07/27/90 09:39
*****************************************************************************/
static  HANDLE ReadDibBitmapInfo (int fh)
{
DWORD     off;
HANDLE    hbi = (HANDLE)0;
int       size;
int       i;
UINT      nNumColors;

RGBQUAD FAR       *pRgb;
BITMAPINFOHEADER   bi;
BITMAPCOREHEADER   bc;
LPBITMAPINFOHEADER lpbi;
BITMAPFILEHEADER   bf;
DWORD              dwWidth = 0;
DWORD              dwHeight = 0;
UINT               wPlanes, wBitCount;

    if (fh == -1)
        return (HANDLE)0;

    /* Reset file pointer and read file header */
    off = _llseek(fh, 0L, SEEK_CUR);
    if (sizeof (bf) != _lread (fh, (LPSTR)&bf, sizeof (bf)))
        return (HANDLE)0;

    /* Do we have a RC HEADER? */
    if (!ISDIB (bf.bfType)) {
        bf.bfOffBits = 0L;
        _llseek (fh, off, SEEK_SET);
    }
    if (sizeof (bi) != _lread (fh, (LPSTR)&bi, sizeof(bi)))
        return FALSE;

    nNumColors = DibNumColors (&bi);

    /* Check the nature (BITMAPINFO or BITMAPCORE) of the info. block
     * and extract the field information accordingly. If a BITMAPCOREHEADER,
     * transfer it's field information to a BITMAPINFOHEADER-style block
     */
    switch (size = (int)bi.biSize){
        case sizeof (BITMAPINFOHEADER):
            break;

        case sizeof (BITMAPCOREHEADER):

            bc = *(BITMAPCOREHEADER*)&bi;

            dwWidth   = (DWORD)bc.bcWidth;
            dwHeight  = (DWORD)bc.bcHeight;
            wPlanes   = bc.bcPlanes;
            wBitCount = bc.bcBitCount;

            bi.biSize               = sizeof(BITMAPINFOHEADER);
            bi.biWidth              = dwWidth;
            bi.biHeight             = dwHeight;
            bi.biPlanes             = (WORD)wPlanes;
            bi.biBitCount           = (WORD)wBitCount;

            bi.biCompression        = BI_RGB;
            bi.biSizeImage          = 0;
            bi.biXPelsPerMeter      = 0;
            bi.biYPelsPerMeter      = 0;
            bi.biClrUsed            = nNumColors;
            bi.biClrImportant       = nNumColors;

            _llseek (fh, (LONG)sizeof (BITMAPCOREHEADER) - sizeof (BITMAPINFOHEADER), SEEK_CUR);
            break;

        default:
            /* Not a DIB! */
            return (HANDLE)0;
    }

    /*  Fill in some default values if they are zero */
    if (bi.biSizeImage == 0){
        bi.biSizeImage = WIDTHBYTES ((DWORD)bi.biWidth * bi.biBitCount)
                         * bi.biHeight;
    }
    if (bi.biClrUsed == 0)
        bi.biClrUsed = DibNumColors(&bi);

    /* Allocate for the BITMAPINFO structure and the color table. */
    hbi = GlobalAlloc (GHND, (LONG)bi.biSize + nNumColors * sizeof(RGBQUAD));
    if (!hbi)
        return (HANDLE)0;
    lpbi = (LPBITMAPINFOHEADER)GlobalLock (hbi);
    *lpbi = bi;

    /* Get a pointer to the color table */
    pRgb = (RGBQUAD FAR *)((LPSTR)lpbi + bi.biSize);
    if (nNumColors){
       if (size == sizeof(BITMAPCOREHEADER)){
          /* Convert a old color table (3 byte RGBTRIPLEs) to a new
           * color table (4 byte RGBQUADs)
           */
          _lread (fh, (LPSTR)pRgb, nNumColors * sizeof(RGBTRIPLE));

          for (i = nNumColors - 1; i >= 0; i--){
              RGBQUAD rgb;

              rgb.rgbRed      = ((RGBTRIPLE FAR *)pRgb)[i].rgbtRed;
              rgb.rgbBlue     = ((RGBTRIPLE FAR *)pRgb)[i].rgbtBlue;
              rgb.rgbGreen    = ((RGBTRIPLE FAR *)pRgb)[i].rgbtGreen;
              rgb.rgbReserved = (BYTE)0;

              pRgb[i] = rgb;
          }
       }
       else
           _lread(fh,(LPSTR)pRgb,nNumColors * sizeof(RGBQUAD));
    }

    if (bf.bfOffBits != 0L)
        _llseek(fh,off + bf.bfOffBits,SEEK_SET);

    GlobalUnlock(hbi);
    return hbi;
}

/*****************************************************************************
 Function
              DibInfo

 Parameters


 Returns
              BOOL

 Description

              Retrieves the DIB info associated with a CF_DIB
              format memory block

 Notes
              None.

 Author
              L_G, 07/27/90 09:58
*****************************************************************************/
static  BOOL DibInfo (HANDLE hbi, LPBITMAPINFOHEADER lpbi)
{
    if (hbi) {
        *lpbi = *(LPBITMAPINFOHEADER)GlobalLock (hbi);

        /* fill in the default fields */
        if (lpbi->biSize != sizeof (BITMAPCOREHEADER)) {
            if (lpbi->biSizeImage == 0L) {
                lpbi->biSizeImage =
                         (UINT)WIDTHBYTES(lpbi->biWidth*lpbi->biBitCount) *
                         lpbi->biHeight;
            }
            if (lpbi->biClrUsed == 0L)
                lpbi->biClrUsed = DibNumColors (lpbi);
        }
        GlobalUnlock (hbi);
        return TRUE;
    }
    return FALSE;
}

HANDLE  LoadBMPToDIB(const char *pszPathName)
{
    OFSTRUCT            of;
    HDIB                h;
    BITMAPINFOHEADER    bi;
    LPBITMAPINFOHEADER  lpbi;
    DWORD               dwBits, dwLen = 0;
    HANDLE              hDib = NULL;

    HFILE hFile = OpenFile(pszPathName, &of, OF_READ|OF_SHARE_DENY_WRITE);
    if (hFile > -1) {
        hDib = ReadDibBitmapInfo(hFile);
        if (hDib) {
            DibInfo(hDib,&bi);

            // Calculate the memory needed to hold the DIB
            dwBits = bi.biSizeImage;
            dwLen  = bi.biSize + (DWORD)PaletteSize((LPSTR)&bi) + dwBits;

            // Try to increase the size of the bitmap info. buffer to hold the DIB
            h = GlobalReAlloc(hDib, dwLen, 0);
            if (!h) {
                GlobalFree(hDib);
                hDib = (HANDLE)0;
            } else {
                hDib = h;

                /* Read in the bits */
                lpbi = (LPBITMAPINFOHEADER)GlobalLock(hDib);
                if(lpbi)
/* NGY */               _hread(hFile, (LPSTR)lpbi + (UINT)lpbi->biSize + PaletteSize((LPSTR)lpbi), dwBits);
                GlobalUnlock(hDib);
            }
        }
        _lclose(hFile);
    }
    return  hDib;
}

//////////////////////////////////////////////////////////////////////////////
// Save BMP image file
//////////////////////////////////////////////////////////////////////////////
/*****************************************************************************
 Function
                        SaveDIBToBMP

 Parameters
                        filename
                        handle of DIB

 Returns
                        BOOL

 Description
                        Write a global handle in CF_DIB format to a file

 Notes
                        None.

 Author
                        L_G, 07/28/90 09:28
*****************************************************************************/
BOOL SaveDIBToBMP(LPSTR szFile, HANDLE hdib)
{
    BITMAPFILEHEADER    hdr;
    LPBITMAPINFOHEADER  lpbi;
    int                 fh;
    OFSTRUCT            of;
    BOOL bRval          = FALSE;
    if (!hdib)
        return FALSE;

    fh = OpenFile (szFile, &of, OF_CREATE|OF_READWRITE);
    if (fh > -1) {

        lpbi = (VOID FAR *)GlobalLock (hdib);

        /* Fill in the fields of the file header */
        hdr.bfType          = BFT_BITMAP;
        hdr.bfSize          = GlobalSize (hdib) + sizeof (BITMAPFILEHEADER);
        hdr.bfReserved1     = 0;
        hdr.bfReserved2     = 0;
        hdr.bfOffBits       = (DWORD)sizeof(BITMAPFILEHEADER) + lpbi->biSize +
                          PaletteSize((LPSTR)lpbi);

        /* Write the file header */
        if(_lwrite (fh, (LPSTR)&hdr, sizeof (BITMAPFILEHEADER)) == sizeof(BITMAPFILEHEADER)) {

        /* Write the DIB header and the bits */
            if(_hwrite (fh, (LPVOID)lpbi, (LONG)GlobalSize (hdib)) == (LONG)GlobalSize(hdib))
                bRval = TRUE;
        }
    }

    GlobalUnlock (hdib);
    _lclose (fh);
    return bRval;
}


/**********************************************************************************
  Function
                FillTiffLineDIB

  Parameters
                lpLineBuff        Bits of uncompressed line inDIB format.
                nLine             Line index counted from zero.
                lParam            User parameter passed unchanged.

  Returns
                Error status. TOK if OK.

  Description
                Fill the data buffer with a DIB line from the image.

  Notes
                None.

  Author
                H_G,    12/26/90                Initial version.
**********************************************************************************/

int CALLBACK FillTiffLineDIB(LPSTR lpLineBuff, int nLine, LONG lParam)
{
TIFFLINEDATA far * lpTiffLineData = (TIFFLINEDATA far *)lParam;

    // copy into DIB
    _fmemcpy(lpLineBuff, lpTiffLineData->lpBits+(DWORD)((DWORD)((int)lpTiffLineData->wHeight - nLine - 1)*
             (DWORD)lpTiffLineData->wUsage), lpTiffLineData->wWidthBytes);

    return(TOK);
}
/**********************************************************************************
  Function
                FillTiffLineDIB24

  Parameters
                lpLineBuff        Bits of uncompressed line inDIB format.
                nLine             Line index counted from zero.
                lParam            User parameter passed unchanged.

  Returns
                Error status. TOK if OK.

  Description
                Fill the data buffer with a DIB line from the image.

  Notes
  Notes
                The TIFF DLL returns RGB siquence but MS Windows stores it
                in BGR format. Why, ask Silly Bill G.!

  Author
                J_N,    5/13/93                Initial version.
**********************************************************************************/
int CALLBACK FillTiffLineDIB24(LPSTR lpLineBuff, int nLine, LONG lParam)
{
TIFFLINEDATA far * lpTiffLineData = (TIFFLINEDATA far *)lParam;
UINT  wByteCnt  = lpTiffLineData->wWidthBytes;
HPSTR hpSrcLine;
HPSTR hpDstLine;
BYTE  bBlue;

    // copy into DIB
    _fmemcpy(lpLineBuff, lpTiffLineData->lpBits+(DWORD)((DWORD)((int)lpTiffLineData->wHeight - nLine - 1)*
             (DWORD)lpTiffLineData->wUsage), lpTiffLineData->wWidthBytes);

    hpSrcLine = (HPSTR)lpLineBuff;
    hpDstLine = (HPSTR)lpLineBuff;

    for(;wByteCnt>2;wByteCnt-=3) {
          bBlue          = *(hpSrcLine+2);
          *(hpDstLine+2) = *hpSrcLine;
          *hpDstLine     = bBlue;
          hpSrcLine+=3;
          hpDstLine+=3;
    }

    return(TOK);
}

/**********************************************************************************
  Function
                DefineCompressionInfo

  Parameters
                hChain                          Image chain handle.
                nImage                          Image index.
                p_wCompMode                       Compression mode as defined

  Returns
                TRUE on success, FALSE if failed.

  Description
                Defines several tags.

  Notes
                None.

  Author
                H_G,    01/02/91                Initial version.
**********************************************************************************/

static BOOL DefineCompressionInfo(TIFFFILE hChain, int nImage, UINT p_wCompMode, LPBITMAPINFO lpBmI, int FillOrder)
{
    UINT wCompression, wAuxInfo = 0;
    UINT wAuxTag = 0;
    RATIO XRes, YRes;
    HDC hDC;
    char szTemp[80];
    char szVersion[15];
    WORD wFillOrder = REV_BIT_ORDER;

    // Calculates the resolution tags.
    hDC = GetDC((HWND)0);
    if (!hDC)
       return(FALSE);

    // change this to set different DPI.
    if (lpBmI != NULL) {
       if (lpBmI->bmiHeader.biXPelsPerMeter == 0L)
          XRes.dwNumer = GetDeviceCaps(hDC,LOGPIXELSX);
       else
          XRes.dwNumer = (DWORD)((float)lpBmI->bmiHeader.biXPelsPerMeter / 39.37);
       if (lpBmI->bmiHeader.biYPelsPerMeter == 0L)
          YRes.dwNumer = GetDeviceCaps(hDC,LOGPIXELSY);
       else
          YRes.dwNumer = (DWORD)((float)lpBmI->bmiHeader.biYPelsPerMeter / 39.37);
    } else {
       XRes.dwNumer = GetDeviceCaps(hDC,LOGPIXELSX);
       YRes.dwNumer = GetDeviceCaps(hDC,LOGPIXELSY);
    }
    XRes.dwDenom = YRes.dwDenom = 1;
    ReleaseDC((HWND)0,hDC);

    switch(p_wCompMode){
       case TCOMP_NOCOMP:
            wCompression = NOCOMPRESSION;
            break;
       case TCOMP_PACKBITS:
            wCompression = PACK_BITS;
            break;
       case TCOMP_LZW_DIFF:
            wAuxInfo = 2;          // Horizontal differencing.
            wAuxTag = PREDICTOR;
       case TCOMP_LZW:
            wCompression = LZW_COMPRESSION;
            break;
       case TCOMP_CCITTG2:
            wCompression = TIFF_CCITT;
            break;
       case TCOMP_CCITTG31D:
            wCompression = CCITT_GROUP3;
            break;
       case TCOMP_CCITTG32D:
            wAuxInfo = 1;          // Two dimensional coding.
            wAuxTag = GROUP3OPTIONS;
            wCompression = CCITT_GROUP3;
            break;
       case TCOMP_CCITTG4:
            wCompression = CCITT_GROUP4;
            break;
#if JPEG_EXIST > 0
       case TCOMP_JPEG:
            wCompression = JPEG_COMPRESSION;
            break;
#endif
       default:
            return(FALSE);
    }

    GetTiffVersion(szVersion, sizeof(szVersion));
    lstrcpy(szTemp,"TIFF.DLL from Black Ice Software, Inc.");
    lstrcat(szTemp,szVersion);
    // Defines the tags. Resolution is measured in Inch (RESOLUTIONUNIT = 2).
    if(!DefineTiffImageInfo(hChain,nImage,COMPRESSION,SHORTTYPE,wCompression)) return(FALSE);
    if(!DefineTiffImageInfoBuffer(hChain,nImage,SOFTWARE,szTemp,ASCIITYPE,lstrlen(szTemp)+1))  return(FALSE);

    if(!DefineTiffImageInfo(hChain,nImage,RESOLUTIONUNIT,SHORTTYPE,2))      return(FALSE);
    if(!DefineTiffImageInfoBuffer(hChain,nImage,XRESOLUTION,(VOID FAR*)&XRes,RATIONALTYPE,1)) return(FALSE);
    if(!DefineTiffImageInfoBuffer(hChain,nImage,YRESOLUTION,(VOID FAR*)&YRes,RATIONALTYPE,1)) return(FALSE);

    /* By HZs for FaxCPP compatibility */
    if ( FillOrder == 2 ) {
        if ( !DefineTiffImageInfoBuffer( hChain, nImage, FILLORDER,(VOID FAR*)&wFillOrder, SHORTTYPE, 1 ) )
            return(FALSE);
    }

    // Defines auxillary compression info if neccessary.
    if((wAuxTag != 0) && (!DefineTiffImageInfo(hChain,nImage,wAuxTag,SHORTTYPE,wAuxInfo))) return(FALSE);

    return(TRUE);
}

/**********************************************************************************
  Function
                DefineColorInfoFromDIB

  Parameters
                None.

  Returns
                None.

  Description


  Notes
                None.

  Author
               Jozsef Nemeth,    11/20/92                Initial version.
**********************************************************************************/

static BOOL DefineColorInfoFromDIB(TIFFFILE hChain, int nImage,int nPhotomInterp,
                                    LPBITMAPINFO lpBmI)
{
    HANDLE hColorMap;
    WORD FAR *lpColor;
    UINT wIndex;
    BOOL bRetVal = TOK;
    UINT nNumCol;

    bRetVal = DefineTiffImageInfo(hChain,
                                  nImage,
                                  PHOTOMETRICINTERPRETATION,
                                  SHORTTYPE,
                                  (UINT)nPhotomInterp);

    nNumCol = DibNumColors(lpBmI);
    if(bRetVal && nNumCol && (nPhotomInterp == 3)) {
       // due to bug in DefineTiffImageInfoBuffer has to be twise the size
       // TO DO - fix bug in DefineTiffImageInfoBuffer
       hColorMap = GlobalAlloc(GHND,
                               (nNumCol * 3) * 2);
       if(hColorMap) {
          if ((lpColor = (WORD FAR*)GlobalLock(hColorMap))!=NULL) {
             for ( wIndex=0; wIndex < nNumCol; wIndex++) {
                lpColor[wIndex] = (WORD)( (WORD)lpBmI->bmiColors[wIndex].rgbRed << 8 );

                lpColor[wIndex+nNumCol] =
                           (WORD)( (WORD)lpBmI->bmiColors[wIndex].rgbGreen << 8 );

                lpColor[wIndex+2*nNumCol] =
                    (WORD)( (WORD)lpBmI->bmiColors[wIndex].rgbBlue << 8 );
             }

             bRetVal = DefineTiffImageInfoBuffer(hChain,   nImage,
                                                 COLORMAP,
                                                 lpColor,
                                                 SHORTTYPE,
                                                 nNumCol*3);
             GlobalUnlock(hColorMap);
          }
          GlobalFree(hColorMap);
       }
    }
    return(bRetVal);
}

/*****************************************************************************
 Function
             SaveDIBIntoTiffFormat

 Parameters
             lpszFileName               Tiff file name.
             hBitmap                    Bitmap to convert into TIFF.

 Returns
             TRUE on success, otherwise FALSE.

 Description
             Convert bitmap 'hBitmap' into a TIFF file named 'lpszFileName'
             using compression algorithm defined in 'wCompression'.

 Compression type -  TCOMP_NOCOMP     - Nocompression
                     TCOMP_PACKBITS   - Packbit
                     TCOMP_LZW        - LZW
                     TCOMP_LZW_DIFF   - LZW with differentiation
                     TCOMP_CCITTG2    - CCITT Group 3 1D NO EOL
                     TCOMP_CCITTG31D  - CCITT Group 3 1D
                     TCOMP_CCITTG32D  - CCITT Group 3 2D
                     TCOMP_CCITTG4    - CCITT Group 4

 Notes
             It is a sample source. It is not part of the DLL.

 Author
             Siklos Gabor
*****************************************************************************/

BOOL CALLBACK SaveDIBInTiff(LPSTR lpszFileName,  HANDLE  hDIB, UINT p_wCompMode,
                            int nPhotomInterp, int FillOrder,
                            LPNOTESTRUCT sNote,  HINSTANCE hInst)
{
    TIFFFILE hChain;
    int      nImage;
    BITMAP   Bm;
    UINT     wWidthBytesOfOneLine;
    TIFFLINEDATA TiffLineData;
    LPBITMAPINFO lpBmI     = NULL;
    BOOL     bSuccess      = FALSE;
    HCURSOR  hOldCur       = (HCURSOR)0;
    FILLPROC  lpFillFarProc = NULL;
    int      nClrsImprt;

    hInst = hInst;
    lpBmI = (LPBITMAPINFO) GlobalLock(hDIB);

    if (lpBmI == NULL)
        return FALSE;

    if(lpBmI->bmiHeader.biClrUsed==0)          /* NGY */
        lpBmI->bmiHeader.biClrUsed = DibNumColors(lpBmI);

    Bm.bmBitsPixel = (BYTE)lpBmI->bmiHeader.biBitCount;
    Bm.bmPlanes    = (BYTE)lpBmI->bmiHeader.biPlanes;
    Bm.bmWidth     = (int)lpBmI->bmiHeader.biWidth;
    Bm.bmHeight    = (int)lpBmI->bmiHeader.biHeight;
    Bm.bmWidthBytes= (int)((lpBmI->bmiHeader.biWidth *
                            lpBmI->bmiHeader.biBitCount+7)/8);
    Bm.bmType      = 0;

    // Sets global variables.
//    nClrsImprt = (int)lpBmI->bmiHeader.biClrUsed;
    nClrsImprt = (int)DibNumColors(lpBmI);      /* NGY */

    // display dialogbox
    // TO-DO dilog box will not set "nPhotomInterp" correctly for RGB 24 bit
    // image because there is option for it.
    if (nPhotomInterp == PI_PALETTECOLOR && lpBmI->bmiHeader.biBitCount > 8)
        nPhotomInterp = PI_RGBCOLOR;

    switch(p_wCompMode) {
       case TCOMP_NOCOMP:
       case TCOMP_PACKBITS:
       case TCOMP_LZW:
       case TCOMP_LZW_DIFF:
       case TCOMP_JPEG:
           break;
       case TCOMP_CCITTG2:
       case TCOMP_CCITTG31D:
       case TCOMP_CCITTG32D:
       case TCOMP_CCITTG4:
           nClrsImprt = 2;
           nPhotomInterp = PI_GREYSCALE;
           break;

       default:
           GlobalUnlock(hDIB);
           return(FALSE);
    }

    // set correct black and white interpitation
    // WhiteIsZero or BlackIsZero
    // See tag 262 default is White Is Zero
    if ( nPhotomInterp == PI_GREYSCALE ) {
       if ( lpBmI->bmiColors[0].rgbGreen == 0 &&
                        lpBmI->bmiColors[0].rgbRed   == 0 &&
                        lpBmI->bmiColors[0].rgbBlue  == 0 ) {
          // Black is Zero
          nPhotomInterp = PI_INV_GREYSCALE;
       }
    }
    // Displays an hourglass-cursor and saves the original one.
    hOldCur = SetCursor(LoadCursor((HANDLE)0,IDC_WAIT));

    // Creates a TIFF image chain in the memory.
    hChain = OpenTiffFile((LPSTR)lpszFileName, T_APPEND);
    if(!hChain)
        return FALSE;

    // Defines byte order.
    if(!ModiTiffFileInfo(hChain,NULL,LH_BYTE_ORDER)) {
        CloseTiffFile(hChain);
        return FALSE;
    }
    // Registers a new image in the chain (it is the only one now).
    nImage = DefineTiffImage(hChain);
    if ( nImage < 0 ) {
        CloseTiffFile(hChain);
        return FALSE;
    }
    // Defines compression tags.

    if ( DefineCompressionInfo( hChain, nImage, p_wCompMode, lpBmI, FillOrder )) {
        // Must change two fields if color image is saved as mono.
        if(nClrsImprt == 2) {
            Bm.bmBitsPixel = 1;
            Bm.bmPlanes    = 1;
        }
        if(DefineGeneralTags(hChain, nImage, Bm) == TOK) {
            // Defines COLORMAP tag if neccessary.
            if(DefineColorInfoFromDIB(hChain,nImage,nPhotomInterp,lpBmI)) {
                // the DIB width LONG alined
                wWidthBytesOfOneLine= (UINT)WIDTHBYTES(lpBmI->bmiHeader.biWidth *
                                                       lpBmI->bmiHeader.biBitCount);
                // Prepares callback function's pocedure instance.
                if (lpBmI->bmiHeader.biBitCount <= 8) {
                    TiffLineData.wWidthBytes = (UINT)((lpBmI->bmiHeader.biWidth*
                                                   lpBmI->bmiHeader.biBitCount+7)/8);
                    lpFillFarProc = MakeFillProc(FillTiffLineDIB,hInst);
                } else {
                     TiffLineData.wWidthBytes = (UINT)WIDTHBYTES(lpBmI->bmiHeader.biWidth*
                                                     lpBmI->bmiHeader.biBitCount);
                     lpFillFarProc = MakeFillProc(FillTiffLineDIB24,hInst);
                }
//                if (sNote->bOnHead && sNote->hStr)
//                    AddNoteTagToTiff(hChain,nImage, sNote);
                TiffLineData.lpBits  = (HPSTR)lpBmI +
                                       lpBmI->bmiHeader.biSize +
                                       PaletteSize((LPSTR)lpBmI);
                TiffLineData.wHeight = (UINT)lpBmI->bmiHeader.biHeight;
                TiffLineData.wUsage  = wWidthBytesOfOneLine;

                // Codes bitmap and writes data into TIFF file.
                bSuccess = EncodeTiffImage(hChain, nImage,
                                   (LONG)(TIFFLINEDATA far *)&TiffLineData,
                                   lpFillFarProc);

            }       // Endif general tags definition OK.

        }       // Endif color info definition OK.

    }       // Endif compression type definition OK.

    // Drops image. CloseTiffFile() will drop anyway.
    DropTiffImage(hChain,nImage);

    CloseTiffFile(hChain);

    // Restores original cursor from hourglass-cursor.
    SetCursor(hOldCur);

    if (!bSuccess)
        MessageBox((HANDLE)0,
                   "Saving has failed.",
                   "TIFF error",
                   MB_OK | MB_ICONEXCLAMATION);

    return(bSuccess);
}


//////////////////////////////////////////////////////////////////////////
// Load ASCII
//////////////////////////////////////////////////////////////////////////

/**********************************************************************************
  Function
                LoadASCIIIntoBitmap

  Parameters
                hWnd: Handle of active window.
                hMem: Memory handle of the previously loaded text file.

  Returns
                A valid bitmap handle or NULL in case of any error.

  Description
                It loads the ASCII text located in the memory into a bitmap.

  Notes
                None.

  Author
                "Vamosi_Janos", 01/22/91                Initial version.
**********************************************************************************/

HBITMAP LoadASCIIIntoBitmap(HWND hWnd, HANDLE hMem)
{
HPSTR hpRunner, hpszText;
DWORD dwBlockSize;
unsigned  nRows, nCols, nWidest;
unsigned int i;
unsigned nWidth,nHeight;
int nXExtent,nYExtent;
TEXTMETRIC tm;
int nCharHeight;
HDC hDC,hdcBit;
HBITMAP hbmTemp;
RECT rRect;

    // Lock memory
    hpRunner = hpszText = (HPSTR)GlobalLock(hMem);
    if (hpszText==NULL) {
        MessageBox(hWnd,
                   "Could not lock the data area",
                   "ERROR",
                   MB_ICONEXCLAMATION|MB_OK);
        return (HANDLE)0;
    }

    dwBlockSize = GlobalSize(hMem);       // Determines the size of memory block.
    hpszText[dwBlockSize-1] = 0;          // Zeroes the last byte of block.

    // compute number of rows, widest row
    nRows=1;
    nWidest=nCols=1;
    for (i=0; *hpRunner; i++) {
        switch(*(hpRunner++)) {
            case '\r': //CR
                nRows++;
                if (nCols>nWidest)
                    nWidest=nCols;
                nCols=0;
                break;

            case '\t': //TAB
                nCols+=8;
                break;

            default:
                nCols++;
                break;
        }
    }
    // if last rows doesn t contain CR
    if (nCols>nWidest)
        nWidest=nCols;


    // compute appropriate bitmap dimensions
    hDC=GetDC(hWnd);
    hdcBit=CreateCompatibleDC(hDC);
    if (hdcBit == (HANDLE)0) {
        ReleaseDC(hWnd,hDC);
        GlobalUnlock(hMem);
        MessageBox(hWnd,
                   "Unable to create DC",
                   "ERROR",
                   MB_ICONEXCLAMATION|MB_OK);
        return (HANDLE)0;
    }

    ReleaseDC(hWnd,hDC);
    GetTextMetrics(hdcBit,(LPTEXTMETRIC)&tm);
    nXExtent = nWidth = (nWidest+5)*tm.tmAveCharWidth;
    if (nXExtent > 32767) {
        DeleteDC(hdcBit);
        GlobalUnlock(hMem);
        MessageBox(hWnd,
                  "Unable load file into bitmap.\nText file is to large.",
                  "ERROR",
                  MB_ICONEXCLAMATION|MB_OK);
        return (HANDLE)0;
    }

    nCharHeight = (int)(tm.tmAscent+tm.tmDescent+tm.tmExternalLeading);
    nYExtent = nHeight = (nRows+1) * nCharHeight;
    if (nYExtent > 32767) {
        DeleteDC(hdcBit);
        GlobalUnlock(hMem);
        MessageBox(hWnd,
                  "Unable load file into bitmap.\nText file is to large.",
                  "ERROR",
                  MB_ICONEXCLAMATION|MB_OK);
        return (HANDLE)0;
    }

    // ask API to compute surroinding rectangle
    SetRectEmpty((LPRECT)&rRect);
    rRect.left  = 2 * tm.tmAveCharWidth;
    rRect.right = nXExtent;
    rRect.bottom= nYExtent;

    // It does not draw the text, only adjusts the size of the rectangle
    DrawText(hdcBit,
             hpszText,-1,
             (LPRECT)&rRect,
             DT_CALCRECT | DT_EXPANDTABS | DT_EXTERNALLEADING | DT_LEFT);
    nWidth= nXExtent = (int)rRect.right;
    nHeight=nYExtent = (int)rRect.bottom;

    // try to create bitmap
    hbmTemp=(HANDLE)0;
    do {
        // monochrome bitmap will do
        hbmTemp =CreateBitmap(nXExtent,     //width
                              nYExtent,     //height
                              1,            //planes
                              1,            //bitcount
                              NULL);        // initialization
        if (hbmTemp == (HANDLE)0)
            // decrement physical dimensions if bitmap would be too large
            nYExtent /=2;
    } while ((hbmTemp==(HANDLE)0) && (nYExtent > nCharHeight));

    if (hbmTemp == (HANDLE)0) {
        DeleteDC(hdcBit);
        GlobalUnlock(hMem);
        MessageBox(hWnd,
                   "Not enough memory !",
                   "ERROR",
                   MB_ICONEXCLAMATION|MB_OK);
        return (HANDLE)0;
    }

    // clear bitmap white
    SelectObject(hdcBit,hbmTemp);
    SelectObject(hdcBit,GetStockObject(WHITE_BRUSH));
    PatBlt(hdcBit,0,0,nXExtent,nYExtent,PATCOPY);

    // draw text into bitmap
    SetMapMode(hdcBit,MM_ANISOTROPIC);
    SetWindowExtEx(hdcBit,nWidth,nHeight,NULL);
    SetViewportExtEx(hdcBit,nXExtent,nYExtent,NULL);

    // If the height exceeds certain limlit (cc. 480)
    // than it won't draw properly unless you use DT_NOCLIP !!??

    DrawText(hdcBit,
             hpszText,
             -1,
             (LPRECT)&rRect,
             DT_NOCLIP|DT_EXPANDTABS|DT_EXTERNALLEADING|DT_LEFT);

    // finish job
    DeleteDC(hdcBit);
    GlobalUnlock(hMem);

    return( hbmTemp );

}

/*  The _filelength() functions not work properly in WIN32 environment  (NGY) */

#define XSEEK_BEGIN 0
#define XSEEK_ACTUAL    1
#define XSEEK_END   2

static long Xfilelength(int nFile) {
    long lact, lret;
    lact = _llseek(nFile, 0, XSEEK_ACTUAL);
    lret = _llseek(nFile, 0, XSEEK_END);
    _llseek(nFile, lact, XSEEK_BEGIN);
    return lret; }


/**********************************************************************************
  Function
                LoadASCIIFileToBitmap

  Parameters
                None.

  Returns
                None.

  Description


  Notes
                None.

  Author
                Vamosi_Janos,   01/29/91                Initial version.
**********************************************************************************/
HANDLE LoadASCIIFileIntoDIB(LPSTR szFileName)
{
int nFileHandler;
OFSTRUCT ofs;
DWORD dwSize;
HCURSOR hOldCur;
HANDLE hRet;
HWND hWnd;
HDC hDC;
VOID FAR *lpByte;
HBITMAP hBitmap;
HANDLE  hDib;

    nFileHandler=OpenFile(szFileName,(LPOFSTRUCT)&ofs,OF_READ|OF_SHARE_DENY_WRITE);
    if (nFileHandler==-1)
        return FALSE;

    // compute memory needed
    dwSize = Xfilelength(nFileHandler);

    // allocate memory
    hRet = GlobalAlloc(GHND , dwSize);
    if (hRet == (HANDLE)0) {
        _lclose(nFileHandler);
        MessageBox(GetActiveWindow(),
                   "Not enough memory !",
                   "ERROR",
                   MB_ICONEXCLAMATION|MB_OK);
        return 0;
    }

    // Displays an hourglass-cursor and saves the original one.
    hOldCur = SetCursor(LoadCursor((HANDLE)0,IDC_WAIT));

    // read text into memory
    lpByte= (VOID FAR *)GlobalLock(hRet);
    _hread(nFileHandler, lpByte, dwSize); // capable to read more than 64K!!!!
    GlobalUnlock(hRet);
    close(nFileHandler);

    hDC = GetDC(hWnd=GetActiveWindow());
    hBitmap = LoadASCIIIntoBitmap(hWnd,hRet);
    ReleaseDC(hWnd, hDC);
    hDib = ConvertBitmapToDIB(hBitmap, 0);
    GlobalFree(hRet);
    DeleteObject(hBitmap);
    // Restores original cursor from hourglass-cursor.
    SetCursor(hOldCur);

    return(hDib);
}


typedef enum enVTYPE {
    VTYPE_ENUM,             /* enumeracio */
    VTYPE_BITS,             /* bit fileds */
    VTYPE_DEFAULT,
    VTYPE_ENDLIST,
} TVALTYPE;

typedef struct {
    TVALTYPE vType;
    long value;
    LPSTR vName;
} TTAGVALUE;

typedef struct tag_TAGNAME {
    UINT tagValue;
    LPSTR tagName;
    TTAGVALUE FAR *tagValName;
} TTAGNAME;

static TTAGVALUE valNewSubfile[] = {
    { VTYPE_DEFAULT , 0L                ,   "NORMALVERSION"      } ,
    { VTYPE_BITS    , REDUCEDVERSION    ,   "REDUCEDVERSION"     } ,
    { VTYPE_BITS    , APAGEOFAMULTIPAGE ,   "PAGE"               } ,
    { VTYPE_BITS    , TRANSPARENCYMASK  ,   "TRANSPMASK"         } ,
    { VTYPE_ENDLIST , 0L                ,   ""  }  };

static TTAGVALUE valOldSubfile[] = {
    { VTYPE_ENUM    , OLDFULLVER    ,       "OLDFULLVER"      } ,
    { VTYPE_ENUM    , OLDREDUCEDVER ,       "OLDREDUCEDVER"   } ,
    { VTYPE_ENUM    , OLDAPAGE      ,       "OLDAPAGE"        } ,
    { VTYPE_ENDLIST , 0L            ,       ""                } };

static TTAGVALUE valComp[] = {
    { VTYPE_ENUM    , NOCOMPRESSION   ,     "NOCOMPRESSION" } ,
    { VTYPE_ENUM    , TIFF_CCITT      ,     "CCITT"         } ,
    { VTYPE_ENUM    , CCITT_GROUP3    ,     "GROUP-3"       } ,
    { VTYPE_ENUM    , CCITT_GROUP4    ,     "GROUP-4"       } ,
    { VTYPE_ENUM    , LZW_COMPRESSION ,     "LZW"           } ,
    { VTYPE_ENUM    , PACK_BITS       ,     "PACKBITS"      } ,
#ifdef TIFF_TAG_V6
    { VTYPE_ENUM    , JPEG_COMPRESSION,     "JPEG_COMP"     } ,
#endif
    { VTYPE_ENDLIST , 0L              ,     ""               } ,  };

static TTAGVALUE valPhoto[] = {
    { VTYPE_ENUM    , PI_GREYSCALE     ,    "GREYSCALE"        } ,
    { VTYPE_ENUM    , PI_INV_GREYSCALE ,    "INV-GREY"         } ,
    { VTYPE_ENUM    , PI_RGBCOLOR      ,    "RGBCOLOR"         } ,
    { VTYPE_ENUM    , PI_PALETTECOLOR  ,    "PALETTECOLOR"     } ,
    { VTYPE_ENUM    , PI_TRANSPMASK    ,    "TRANSPMASK"       } ,
#ifdef TIFF_TAG_V6
    { VTYPE_ENUM    , PI_CMYK          ,    "CMYK"             } ,
    { VTYPE_ENUM    , PI_YCC           ,    "YCC"              } ,
#endif
    { VTYPE_ENDLIST , 0L               ,    ""                 } ,  };

static TTAGVALUE valThres[] = {
    { VTYPE_ENUM    , 1                ,    "LINE-ART"          } ,
    { VTYPE_ENUM    , 2                ,    "DITHERED"          } ,
    { VTYPE_ENUM    , 3                ,    "ERROR-DIFFUSED"    } ,
    { VTYPE_ENDLIST , 0L               ,    ""                  } ,  };

static TTAGVALUE valFill[] = {
    { VTYPE_ENUM    , NORM_BIT_ORDER   ,    "NORM-BIT-ORDER"    } ,
    { VTYPE_ENUM    , REV_BIT_ORDER    ,    "REV-BIT-ORDER"     } ,
    { VTYPE_ENDLIST , 0L               ,    ""                  } ,  };

static TTAGVALUE valOrient[] = {
    { VTYPE_ENUM    , 1                ,    "TOP-LEFT"          } ,
    { VTYPE_ENUM    , 2                ,    "TOP-RIGHT"         } ,
    { VTYPE_ENUM    , 3                ,    "BOTTOM-RIGHT"      } ,
    { VTYPE_ENUM    , 4                ,    "BOTTOM-LEFT"       } ,
    { VTYPE_ENUM    , 5                ,    "LEFT-TOP"          } ,
    { VTYPE_ENUM    , 6                ,    "RIGHT-TOP"         } ,
    { VTYPE_ENUM    , 7                ,    "RIGHT-BOTTOM"      } ,
    { VTYPE_ENUM    , 8                ,    "LEFT-BOTTOM"       } ,
    { VTYPE_ENDLIST , 0L               ,    ""                  } ,  };

static TTAGVALUE valPlanar[] = {
    { VTYPE_ENUM    , 1                ,    "ONE-PLANE"         } ,
    { VTYPE_ENUM    , 2                ,    "MANY-PLANES"       } ,
    { VTYPE_ENDLIST , 0L               ,    ""                  } ,  };

static TTAGVALUE valG3[] = {
    { VTYPE_DEFAULT , 0                ,    "G3-DEFAULT-1D"     } ,
    { VTYPE_BITS    , 1                ,    "G3-2D"             } ,
    { VTYPE_BITS    , 2                ,    "G3-UNCOMP"         } ,
    { VTYPE_BITS    , 4                ,    "G3-FILLBITS"       } ,
    { VTYPE_ENDLIST , 0L               ,    ""                  } ,  };

static TTAGVALUE valG4[] = {
    { VTYPE_DEFAULT , 0                ,    "G4-DEFAULT-2D"     } ,
    { VTYPE_BITS    , 2                ,    "G4-UNCOMP"         } ,
    { VTYPE_ENDLIST , 0L               ,    ""                  } ,  };

static TTAGVALUE valPredic[] = {
    { VTYPE_ENUM    , 1                ,    "NO-PREDIC"         } ,
    { VTYPE_ENUM    , 2                ,    "HORIZDIFF"         } ,
    { VTYPE_ENDLIST , 0L               ,    ""                  } ,  };

static TTAGVALUE valGrayUnit[] = {
    { VTYPE_ENUM    , 1                ,    "TENTHS"            } ,
    { VTYPE_ENUM    , 2                ,    "HUNDREDTHS"        } ,
    { VTYPE_ENUM    , 3                ,    "THOUSANDTHS"       } ,
    { VTYPE_ENUM    , 4                ,    "TEN-THOUSANDTH"    } ,
    { VTYPE_ENUM    , 5                ,    "HUNDRED-THOUS."    } ,
    { VTYPE_ENDLIST , 0L               ,    ""                  } ,  };

static TTAGVALUE valResUnit[] = {
    { VTYPE_ENUM    , 1                ,    "NO-UNIT"             } ,
    { VTYPE_ENUM    , 2                ,    "INCH"                } ,
    { VTYPE_ENUM    , 3                ,    "CENTIMETER"          } ,
    { VTYPE_ENDLIST , 0L               ,    ""                    } ,  };

static TTAGVALUE valBitsPer[] = {
    { VTYPE_ENUM    , 1                ,    "BILEVEL"             } ,
    { VTYPE_ENUM    , 4                ,    "16-LEVEL"            } ,
    { VTYPE_ENUM    , 8                ,    "256-LEVEL"           } ,
    { VTYPE_ENUM    , 24               ,    "FULLCOLOR"           } ,
    { VTYPE_ENDLIST , 0L               ,    ""                    } ,  };

// Tag names.
static TTAGNAME TagNames[] = {
 { NEWSUBFILETYPE            , "NEWSUBFILETYPE"            , valNewSubfile } ,
 { SUBFILETYPE               , "SUBFILETYPE"               , valOldSubfile } ,
 { IMAGEWIDTH                , "IMAGEWIDTH"                , NULL } ,
 { IMAGELENGTH               , "IMAGELENGTH"               , NULL } ,
 { BITSPERSAMPLE             , "BITSPERSAMPLE"             , valBitsPer  } ,
 { COMPRESSION               , "COMPRESSION"               , valComp } ,
 { PHOTOMETRICINTERPRETATION , "PHOTOMETRICINTERPRETATION" , valPhoto } ,
 { THRESHHOLDING             , "THRESHHOLDING"             , valThres } ,
 { CELLWIDTH                 , "CELLWIDTH"                 , NULL } ,
 { CELLLENGTH                , "CELLLENGTH"                , NULL } ,
 { FILLORDER                 , "FILLORDER"                 , valFill } ,
 { DOCUMENTNAME              , "DOCUMENTNAME"              , NULL } ,
 { IMAGEDESCRIPTION          , "IMAGEDESCRIPTION"          , NULL } ,
 { MAKE                      , "MAKE"                      , NULL } ,
 { MODEL                     , "MODEL"                     , NULL } ,
 { STRIPOFFSETS              , "STRIPOFFSETS"              , NULL } ,
 { ORIENTATION               , "ORIENTATION"               , valOrient } ,
 { SAMPLESPERPIXEL           , "SAMPLESPERPIXEL"           , NULL } ,
 { ROWSPERSTRIP              , "ROWSPERSTRIP"              , NULL } ,
 { STRIPBYTECOUNTS           , "STRIPBYTECOUNTS"           , NULL } ,
 { MINIMUMVALUE              , "MINIMUMVALUE"              , NULL } ,
 { MAXIMUMVALUE              , "MAXIMUMVALUE"              , NULL } ,
 { XRESOLUTION               , "XRESOLUTION"               , NULL } ,
 { YRESOLUTION               , "YRESOLUTION"               , NULL } ,
 { PLANARCONFIG              , "PLANARCONFIG"              , valPlanar } ,
 { PAGENAME                  , "PAGENAME"                  , NULL } ,
 { XPOSITION                 , "XPOSITION"                 , NULL } ,
 { YPOSITION                 , "YPOSITION"                 , NULL } ,
 { FREEOFFSETS               , "FREEOFFSETS"               , NULL } ,
 { FREEBYTECOUNTS            , "FREEBYTECOUNTS"            , NULL } ,
 { GRAYRESPONSEUNITS         , "GRAYRESPONSEUNITS"         , valGrayUnit } ,
 { GRAYRESPONSECURVE         , "GRAYRESPONSECURVE"         , NULL } ,
 { GROUP3OPTIONS             , "GROUP3OPTIONS"             , valG3 } ,
 { GROUP4OPTIONS             , "GROUP4OPTIONS"             , valG4 } ,
 { RESOLUTIONUNIT            , "RESOLUTIONUNIT"            , valResUnit } ,
 { PAGENUMBER                , "PAGENUMBER"                , NULL } ,
 { COLORRESPONSEUNIT         , "COLORRESPONSEUNIT"         , NULL } ,
 { COLORRESPONSECURVES       , "COLORRESPONSECURVES"       , NULL } ,
 { SOFTWARE                  , "SOFTWARE"                  , NULL } ,
 { DATETIME                  , "DATETIME"                  , NULL } ,
 { ARTIST                    , "ARTIST"                    , NULL } ,
 { HOSTCOMPUTER              , "HOSTCOMPUTER"              , NULL } ,
 { PREDICTOR                 , "PREDICTOR"                 , valPredic } ,
 { WHITEPOINT                , "WHITEPOINT"                , NULL } ,
 { PRIMARYDHROMATICITIES     , "PRIMARYDHROMATICITIES"     , NULL } ,
 { COLORMAP                  , "COLORMAP"                  , NULL } ,

#ifdef TIFF_TAG_V6
 { HALFTONEHINTS             , "HALFTONEHINTS"             , NULL } ,
 { TILEWIDTH                 , "TILEWIDTH"                 , NULL } ,
 { TILELENGTH                , "TILELENGTH"                , NULL } ,
 { TILEOFFSETS               , "TILEOFFSETS"               , NULL } ,
 { TILEBYTECOUNTS            , "TILEBYTECOUNTS"            , NULL } ,

 { JPEGPROC                  , "JPEGPROC"                  , NULL } ,
 { JPEGINTERCHANGEFORMAT     , "JPEGINTERCHANGEFORMAT"     , NULL } ,
 { JPEGINTERCHANGEFORMATLENGTH,"JPEGINTERCHANGEFORMATLNG"  , NULL } ,
 { JPEGRESTARTINTERVAL       , "JPEGRESTARTINTERVAL"       , NULL } ,
 { JPEGLOSLESSPREDICTORS     , "JPEGLOSLESSPREDICTORS"     , NULL } ,
 { JPEGPOINTTRANSFORMS       , "JPEGPOINTTRANSFORMS"       , NULL } ,
 { JPEGQTABLES               , "JPEGQTABLES"               , NULL } ,
 { JPEGDCTABLES              , "JPEGDCTABLES"              , NULL } ,
 { JPEGACTABLES              , "JPEGACTABLES"              , NULL } ,
 { YCBCRCOEFFICIENTS         , "YCBCRCOEFFICIENTS"         , NULL } ,
 { YCBCRSUBSAMPLING          , "YCBCRSUBSAMPLING"          , NULL } ,
 { YCBCRPOSITIONING          , "YCBCRPOSITIONING"          , NULL } ,
 { REFERENCEBLACKWHITE       , "REFERENCEBLACKWHITE"       , NULL } ,
#endif   /* TIFF_TAG_V6 */

};
#define MAX_TIFFTAG (sizeof(TagNames) / sizeof(TagNames[0]) )

// Data type strings.
static char *TagTypes[] = {
    "??TYPE??",   "BYTE", "ASCII", "SHORT", "LONG", "RATIONAL"  };

#define MAX_TAGTYPE (sizeof(TagTypes) / sizeof(TagTypes[0]) )

int LoadTiffTagName(TINQTAGNAME FAR *cinq) {
    TTAGNAME FAR *ctab;
    TTAGVALUE FAR *cval;
    int jj, flg, ln, fVal;
    flg = FALSE;
    for(jj=0; jj<MAX_TIFFTAG; jj++) {
        if(TagNames[jj].tagValue == cinq->nTag) {
            flg = TRUE;
            break; }
    }   /* for */
    if(flg==FALSE) {
        if(cinq->lpTagName && cinq->nTagLen > 5)
            strncpy(cinq->lpTagName, "??TAG??", cinq->nTagLen);
        if(cinq->lpValName && cinq->nValLen > 5)
            cinq->lpValName[0] = 0;
        return FALSE; }

    ctab = &TagNames[jj];
    if(cinq->lpTagName && cinq->nTagLen)
         strncpy(cinq->lpTagName, ctab->tagName, cinq->nTagLen);
    if(cinq->lpValName==NULL || cinq->nValLen <=5)
        return TRUE;
    if(ctab->tagValName==NULL) {
        cinq->lpValName[0] = 0;
        return TRUE; }
    cval = &ctab->tagValName[0];
    cinq->lpValName[0] = 0;
    fVal = FALSE;
    for(;;) {
        if(cval->vType==VTYPE_ENDLIST)
            break;
        if(cval->vType==VTYPE_DEFAULT)
            strncpy(cinq->lpValName, cval->vName, cinq->nValLen);
        else {
            if(cval->vType==VTYPE_ENUM) {
                if(cinq->nValue==cval->value)
                    strncpy(cinq->lpValName, cval->vName, cinq->nValLen);
            } else if(cval->vType==VTYPE_BITS) {
                if(cinq->nValue & cval->value) {
                    if(fVal==FALSE) {
                        fVal = TRUE;
                        strncpy(cinq->lpValName, cval->vName, cinq->nValLen); }
                    else {
                         ln = strlen(cinq->lpValName);
                         if((UINT)(ln+25) < cinq->nValLen)
                             wsprintf(&cinq->lpValName[ln], " | %s",  cval->vName);
                    } }  }
        }
        cval++;
    }   /* for */
    if(cinq->lpValName[0]==0)
        strncpy(cinq->lpValName, "??VALUE??", cinq->nValLen);
    return TRUE; }

void LoadTiffTagTypeName(UINT nType, LPSTR buf, UINT nLen) {
    if(buf==NULL || nLen<5)
        return;
    if(nType>=MAX_TAGTYPE)
        nType = 0;
    strncpy(buf, TagTypes[nType], nLen);
    return; }


