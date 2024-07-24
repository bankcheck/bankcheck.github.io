#ifndef JFIF_H
#define JFIF_H
/****************************************************************************/
/* jfif.h    (c) Copyright Black Ice Software Inc.  1989 - 1991             */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/****************************************************************************/
   
//----------- Error codes -----------------------
#define JERR_OK					0
#define JERR_FILE				1
#define JERR_COLORS				2
#define JERR_MEMORY				3
#define JERR_COMPRESSION		4
#define JERR_PARAMETER			5
#define JERR_NOLINEPROC			6
#define JERR_DENSITY			7
#define JERR_BAD_SUBSAMPLING	8
#define JERR_HAS_HEIGHT			9
#define JERR_NO_DNL				10
#define JERR_BAD_DNL			11
#define JERR_BITMANI			12

//------------ Header types 
#define JHDR_JFIF  0
#define JHDR_G3FAX 1


typedef struct tagJCompressInfo 
{                    
	WORD     wWidth ;
	WORD     wHeight;
 	DWORD 	 dwXRes ;
 	DWORD 	 dwYRes ;
 	WORD  	 wQuality ;
	WORD  	 wColors ;
	BOOL   	 bGrayOutput ;
    WORD  	 wXSubSampling ;
    WORD  	 wYSubSampling ;
    WORD  	 wRestartInterval ;
    WORD  	 wHeaderType ;
    LONG  	 lUserData ;
	FILLPROC lpLineFn ;     
    BOOL     bHPLabColor;
    BOOL     bDNL;
}   JCompressInfo  ;

int   CALLBACK _loadds EncodeJPEGImage(int nFile, JCompressInfo FAR * lpInfo);
                   
int  CALLBACK _loadds EncodeJPEGImageTo(int nFile, WORD wWidth, WORD wHeight,
                                       int nColors,int nQuality,
                                       LONG lUserData,
                                       FILLPROC lpLineFn, DWORD dwXRes,DWORD dwYRes);
                                       
int CALLBACK _loadds SaveDIBInJPEGFile(LPSTR lpFileName, HANDLE hDIB, int nQuality);
int CALLBACK _loadds SaveDIBInHPLabJPEG(LPSTR lpFileName,HANDLE hDIB,int nQuality);
int CALLBACK _loadds SaveDIBInColorFaxJPEG(LPSTR lpFileName,HANDLE hDIB,int nQuality);
int CALLBACK _loadds SaveDIBInJPEGFileEx(LPSTR lpFileName, HANDLE hDIB, JCompressInfo FAR * lpInfo);

int CALLBACK _loadds GetJPEGDimensions(int nFile, LPBITMAPINFOHEADER lpBi);
int CALLBACK _loadds GetJPEGFileDimensions(LPSTR lpFileName, LPBITMAPINFOHEADER lpBi);

int FAR PASCAL _loadds GetJPEGFileInfo(LPSTR lpFileName,JCompressInfo FAR * lpInfo);
int CALLBACK _loadds GetJPEGInfo(int nFile,JCompressInfo FAR * lpInfo);

int CALLBACK _loadds DecodeJPEGImage(int nFile, 
                              UINT wFirstStrip, UINT wNumLines,
                              LONG lUserData,
                              FILLPROC lpLineFn);

HANDLE CALLBACK _loadds LoadJPEGFileIntoDIB(int nFile);
HANDLE CALLBACK _loadds LoadJPEGIntoDIB(LPSTR lpFileName);

int CALLBACK _loadds ConvertDNLToHeight(LPSTR lpFileName);

#endif
