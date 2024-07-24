

//
// Image File Formats
//
#define FORMAT_FIRST            1       /* NGY */
#define FORMAT_TIFF             1
#define FORMAT_CCITT_G31D_EOL   2
#define FORMAT_CCITT_G31D_NOEOL 3
#define FORMAT_CCITT_G32D       4
#define FORMAT_CCITT_G4         5
#define FORMAT_RAW              6
#define FORMAT_IBM_MMR_IOCA     7
#define FORMAT_IBM_MMR_RAW      8
#define FORMAT_BITMAP           9
#define FORMAT_ASCII            10
#define FORMAT_CALS             11

#if JPEG_EXIST > 0
#define FORMAT_JPEG             12
#define FORMAT_LAST             12      /* NGY */
#else
#define FORMAT_LAST             11      /* NGY */
#endif
//
// C Functions included in CFunc.c
//

#ifndef DEF_RATIO
#define DEF_RATIO
typedef struct tag_RATIO {
  DWORD    dwNumer;
  DWORD    dwDenom;
  }  RATIO;      
#endif  

HANDLE LoadCcittToDIB(LPSTR lpszFileName, UINT wCompression, LONG lOffset, 
        UINT wWidth, UINT wHeight, int bFillOrder, UINT bByteOrder, HINSTANCE hInst);
BOOL SaveDIBCcitt(LPSTR lpszFileName,  HANDLE  hDIB, HINSTANCE hInst, UINT wCompression);
HANDLE LoadMMRToDIB(LPSTR lpszFileName, UINT wCompression, LONG lOffset, 
    UINT wWidth, UINT wHeight, int bFillOrder, UINT bByteOrder, HINSTANCE hInst);
BOOL SaveDIBMMR(LPSTR lpszFileName,  HANDLE  hDIB, HINSTANCE hInst, UINT wCompression);
HANDLE  LoadBMPToDIB(const char *pszPathName);
BOOL SaveDIBToBMP(LPSTR szFile, HANDLE hdib);
BOOL CALLBACK SaveDIBInTiff(LPSTR lpszFileName,  HANDLE  hDIB, UINT wCompMode, 
        int nPhotomInterp, int fillorder, LPNOTESTRUCT sNote, HINSTANCE hInst);
HANDLE LoadASCIIFileIntoDIB(LPSTR szFileName);

typedef struct tagInqName {
    UINT nTag;                  /* input  Tag ID */
    long nValue;                /* input  Tag Val */
    LPSTR lpTagName;            /* output Tag ID Name */
    UINT nTagLen;               /* input  Len of 'lpTagName' */
    LPSTR lpValName;            /* output Tag Val Name */
    UINT nValLen;               /* input  Len of 'lpValName' */
} TINQTAGNAME;    

int  LoadTiffTagName(TINQTAGNAME FAR *cinq);
void LoadTiffTagTypeName(UINT nType, LPSTR buf, UINT nLen);

