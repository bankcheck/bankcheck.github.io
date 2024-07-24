/****************************************************************************/
/* tools.h   (c) Copyright Black Ice Software Inc.  1989 - 1991             */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/****************************************************************************/
#define NORM_BIT_ORDER   1			/* High to Low */
#define REV_BIT_ORDER    2			/* Low to High */

#define LH_BYTE_ORDER    0x4949 	/* High to Low */
#define HL_BYTE_ORDER	   0x4D4D	/* Low to High */


#define WIDTHLONG(i)      (( (i)+ 31)/ 8)
#define WIDTHBYTES(i)     ((( (i)+ 31)/ 32)* 4)
#define WIDTH2BYTES(i)    ((( (i)+ 15)/ 16)* 2)
#define FULLBYTE( i)      (( (i)+ 7)/ 8)

// Type independent min and max macros.
#define MIN(A,B) ( (A < B) ? A : B )
#define MAX(A,B) ( (A > B) ? A : B )

// Data types.
#define BYTETYPE     1
#define ASCIITYPE    2
#define SHORTTYPE    3
#define LONGTYPE     4
#define RATIONALTYPE 5
#define OFFSETTYPE   9

// Data type sizes in bytes 
#define BYTESIZE     1
#define ASCIISIZE    1
#define SHORTSIZE    2
#define LONGSIZE     4 
#define RATIONALSIZE 8
#define OFFSETSIZE   4

typedef unsigned char huge * HPSTR;


int  ItemSize(int iType);
int  SwapBytes(HPSTR lpBytes, int iType, LONG lCount);
VOID ReverseFillOrder(HPSTR lpBuff, DWORD dwNumberOfBytes);
BOOL LongRead(int nFile, int iType, LONG lCount, HPSTR lpBuffer,
										int nByteOrder, int nBitOrder);
BOOL LongWrite(int nFile, int iType, LONG lCount, HPSTR lpBuffer,
										int nByteOrder, int nBitOrder);
VOID ShellSort(LPWORD lpwDat, int nItems);

VOID FAR DebugMsg(LPSTR lpszFormat,...); 
VOID FAR ErrorMsg(LPSTR lpszFormat,...); 

