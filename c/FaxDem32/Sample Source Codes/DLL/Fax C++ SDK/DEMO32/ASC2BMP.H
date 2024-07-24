
#ifndef __ASC2BMP_H
#define __ASC2BMP_H

#define MEASURE_INCH  1
#define TEXT_ITALIC   2
#define TEXT_BOLD     4

#define ERROR_INVALID_PARAM     1
#define ERROR_NOT_ENOUGH_SPACE  2
#define ERROR_FILE_NOT_OPEN     3
#define ERROR_NOT_ENOUGH_MEMORY 4

#define OUT_BMP       10
#define OUT_DIB       11

typedef struct tagFAXPAGE {
   char    szFileName[256];
   int     nPageWidth;
   int     nPageLength;
   int     nXmargin;
   int     nYmargin;
   char    szTypeFace[128];
   int     nFontPointSize;
   int     nXDPI;
   int     nYDPI;
   int     nLineSpace;
   int     szTabArray[16];
   WORD    nFlags;
} FAXTOASCII, FAR *LPFAXTOASCII;

UINT CALLBACK CreateBMPFaxPageFromASCII( LPFAXTOASCII, UINT, HANDLE far *, int far * );
UINT CALLBACK CreateDIBFaxPageFromASCII( LPFAXTOASCII, UINT, HANDLE far *, int far * );
UINT CALLBACK CreateFaxPageFromASCII( LPFAXTOASCII, UINT, HANDLE far *, UINT, HBITMAP, int far * );

#endif /*__ASC2BMP_H*/
