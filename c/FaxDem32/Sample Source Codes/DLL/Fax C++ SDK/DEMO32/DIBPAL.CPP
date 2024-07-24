#include "stdafx.h"
#include "dibpal.h"
/* DIB constants */
#define PALVERSION   0x300
#define IS_WIN30_DIB(lpbi)  ((*(LPDWORD)(lpbi)) == sizeof(BITMAPINFOHEADER))

/*************************************************************************
 *
 * DIBNumColors()
 *
 * Parameter:
 *
 * LPSTR lpbi       - pointer to packed-DIB memory block
 *
 * Return Value:
 *
 * UINT             - number of colors in the color table
 *
 * Description:
 *
 * This function calculates the number of colors in the DIB's color table
 * by finding the bits per pixel for the DIB (whether Win3.0 or other-style
 * DIB). If bits per pixel is 1: colors=2, if 4: colors=16, if 8: colors=256,
 * if 24, no colors in color table.
 *
 ************************************************************************/


UINT WINAPI DIBNumColors(LPSTR lpbi)
{
    UINT wBitCount;  // DIB bit count

    /*  If this is a Windows-style DIB, the number of colors in the
     *  color table can be less than the number of bits per pixel
     *  allows for (i.e. lpbi->biClrUsed can be set to some value).
     *  If this is the case, return the appropriate value.
     */

    if (IS_WIN30_DIB(lpbi))
    {
        DWORD dwClrUsed;

        dwClrUsed = ((LPBITMAPINFOHEADER)lpbi)->biClrUsed;
        if (dwClrUsed != 0)
            return (UINT)dwClrUsed;
    }

    /*  Calculate the number of colors in the color table based on
     *  the number of bits per pixel for the DIB.
     */
    if (IS_WIN30_DIB(lpbi))
        wBitCount = ((LPBITMAPINFOHEADER)lpbi)->biBitCount;
    else
        wBitCount = ((LPBITMAPCOREHEADER)lpbi)->bcBitCount;

    /* return number of colors based on bits per pixel */
    switch (wBitCount)
    {
        case 1:
            return 2;

        case 4:
            return 16;

        case 8:
            return 256;

        default:
            return 0;
    }
}
  
/*************************************************************************
 *
 * CreateDIBPalette()
 *
 * Parameter:
 *
 * HDIB hDIB        - specifies the DIB
 *
 * Return Value:
 *
 * HPALETTE         - specifies the palette
 *
 * Description:
 *
 * This function creates a palette from a DIB by allocating memory for the
 * logical palette, reading and storing the colors from the DIB's color table
 * into the logical palette, creating a palette from this logical palette,
 * and then returning the palette's handle. This allows the DIB to be
 * displayed using the best possible colors (important for DIBs with 256 or
 * more colors).
 *
 ************************************************************************/


BOOL WINAPI CreateDIBPalette(HDIB hDIB, CPalette* pPal)
{
    LPLOGPALETTE lpPal;      // pointer to a logical palette
    HANDLE hLogPal;          // handle to a logical palette
    HPALETTE hPal = NULL;    // handle to a palette
    int i;                   // loop index
    UINT wNumColors;         // number of colors in color table
    LPSTR lpbi;              // pointer to packed-DIB
    LPBITMAPINFO lpbmi;      // pointer to BITMAPINFO structure (Win3.0)
    LPBITMAPCOREINFO lpbmc;  // pointer to BITMAPCOREINFO structure (old)
    BOOL bWinStyleDIB;       // flag which signifies whether this is a Win3.0 DIB
    BOOL bResult = FALSE;

    /* if handle to DIB is invalid, return FALSE */

    if (hDIB == NULL)
      return FALSE;

   lpbi = (LPSTR) ::GlobalLock((HGLOBAL) hDIB);

   /* get pointer to BITMAPINFO (Win 3.0) */
   lpbmi = (LPBITMAPINFO)lpbi;

   /* get pointer to BITMAPCOREINFO (old 1.x) */
   lpbmc = (LPBITMAPCOREINFO)lpbi;

   /* get the number of colors in the DIB */
   wNumColors = ::DIBNumColors(lpbi);

   if (wNumColors != 0)
   {
        /* allocate memory block for logical palette */
        hLogPal = ::GlobalAlloc(GHND, sizeof(LOGPALETTE)+ 
                    sizeof(PALETTEENTRY)* wNumColors);

        /* if not enough memory, clean up and return NULL */
        if (hLogPal == 0)
        {
            ::GlobalUnlock((HGLOBAL) hDIB);
            return FALSE;
        }

        lpPal = (LPLOGPALETTE) ::GlobalLock((HGLOBAL) hLogPal);

        /* set version and number of palette entries */
        lpPal->palVersion = PALVERSION;
        lpPal->palNumEntries = (WORD)wNumColors;

        /* is this a Win 3.0 DIB? */
        bWinStyleDIB = IS_WIN30_DIB(lpbi);
        for (i = 0; i < (int)wNumColors; i++)
        {
            if (bWinStyleDIB)
            {
                lpPal->palPalEntry[i].peRed = lpbmi->bmiColors[i].rgbRed;
                lpPal->palPalEntry[i].peGreen = lpbmi->bmiColors[i].rgbGreen;
                lpPal->palPalEntry[i].peBlue = lpbmi->bmiColors[i].rgbBlue;
                lpPal->palPalEntry[i].peFlags = 0;
            }
            else
            {
                lpPal->palPalEntry[i].peRed = lpbmc->bmciColors[i].rgbtRed;
                lpPal->palPalEntry[i].peGreen = lpbmc->bmciColors[i].rgbtGreen;
                lpPal->palPalEntry[i].peBlue = lpbmc->bmciColors[i].rgbtBlue;
                lpPal->palPalEntry[i].peFlags = 0;
            }
        }

        /* create the palette and get handle to it */
        bResult = pPal->CreatePalette(lpPal);
        ::GlobalUnlock((HGLOBAL) hLogPal);
        ::GlobalFree((HGLOBAL) hLogPal);
    }

    ::GlobalUnlock((HGLOBAL) hDIB);

    return bResult;
}

