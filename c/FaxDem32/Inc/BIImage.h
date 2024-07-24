#include <windows.h>

#ifndef _BIIMAGE_H_
#define _BIIMAGE_H_

typedef HANDLE HDIB;

#define DISPLAY_NONE				0
#define DISPLAY_PROGRESS			1
#define DISPLAY_DIALOG				2
#define DISPLAY_BOTH				3

#define CLUSTERED_CLASSICAL	0
#define CLUSTERED_LINE		1
#define CLUSTERED_SPIRAL	2
#define DISPERSED_5X5		3
#define DISPERSED_8X8A		4
#define DISPERSED_8X8B		5
#define DISPERSED_16X16		6


#define FLAG_YUV		10L
#define FLAG_CMY		11L
#define FLAG_CMYK		12L
#define FLAG_YIQ		13L
#define FLAG_HSV		14L
#define FLAG_HSI		15L
#define FLAG_XYZ		16L
#define FLAG_LAB		17L

#define FORMAT_RGB		1
#define FORMAT_YUV		2
#define FORMAT_CMY		3
#define FORMAT_CMYK		4
#define FORMAT_YIQ		5
#define FORMAT_HSV		6
#define FORMAT_HSI		7
#define FORMAT_XYZ		8
#define FORMAT_LAB		9

// names of convolution kernels
#define USER                  1
#define FROMFILE              2
#define SMOOTH                3
#define WEIGHTEDSMOOTH        4
#define LAPLACE               5
#define WEIGHTEDLAPLACE       6

typedef enum tag_ColorConvertErrors {
	CCNOERROR,				// No error occurs
	CCDUPLICATEERROR,		// Error Duplicat DIB
	CCIINVALIDFORMAT,		// Invalid conversion format
	CCCONVERT32BIT,			// Error convert DIB to 32 bit
	CCINVALIDPARAMETER,		// Invalid paramter
	CCINVALIDBUFFERSIZE,	// Invalid buffer size
	CCCREATEDLG,			// Error creating progress dialog
	CCNOBIDLGS,				// BIDlgs.dll is missing.
	CCCONVERSIONERROR		// Color Conversion Error
}ColorConvertErrors;

// struch HSV
typedef struct _S_HSV
{
	unsigned char H;	
	unsigned char S;
	unsigned char V;
}S_HSV;
typedef S_HSV far *  LPS_HSV; 

// struch HSI
typedef struct _S_HSI
{
	unsigned char H;	
	unsigned char S;
	unsigned char I;
}S_HSI;
typedef S_HSI far *  LPS_HSI; 

// struch RGB
typedef struct _S_RGB
{
	unsigned char red;
	unsigned char green;
	unsigned char blue;
}S_RGB;

typedef struct _S_RGBQUAD
{
	unsigned char red;
	unsigned char green;
	unsigned char blue;
	unsigned char quad;
}S_RGBQUAD;

typedef S_RGB far *  LPS_RGB; 

typedef S_RGBQUAD far *  LPS_RGBQUAD;

// struch CMY
typedef struct _S_CMY
{
	unsigned char cyan;
	unsigned char magneta;
	unsigned char yellow;
}S_CMY;
typedef S_CMY far *  LPS_CMY; 

// struch YIQ
typedef struct _S_YIQ
{
	unsigned char Y;
	unsigned char I;
	unsigned char Q;
}S_YIQ;
typedef S_YIQ far *  LPS_YIQ; 

// struct YUV
typedef struct _S_YUV
{
	unsigned char Y;
	unsigned char U;
	unsigned char V;
}S_YUV;
typedef S_YUV far *  LPS_YUV; 

// struct CMYK
typedef struct _S_CMYK
{
	unsigned char C;
	unsigned char M;
	unsigned char Y;
	unsigned char K;
}S_CMYK;
typedef S_CMYK far *  LPS_CMYK; 

// struch XYZ
typedef struct _S_XYZ
{
	unsigned char X;	
	unsigned char Y;
	unsigned char Z;
}S_XYZ;
typedef S_XYZ far *  LPS_XYZ; 

// struch LAB
typedef struct _S_LAB
{
	unsigned char L;	
	unsigned char A;
	unsigned char B;
}S_LAB;
typedef S_LAB far *  LPS_LAB;

// struct for ReplaceColor
typedef struct _S_REP
{
	BYTE intRed;	
	BYTE intGreen;
	BYTE intBlue;
}S_REP;
typedef S_REP far *  LPS_REP; 

S_HSV CALLBACK RGBtoHSV(const LPS_RGB sRGB);
S_CMYK CALLBACK RGBtoCMYK(const LPS_RGB sRGB);
S_RGB CALLBACK HSVtoRGB(const LPS_HSV sHSV);
S_HSI CALLBACK RGBtoHSI(const LPS_RGB sRGB);
S_RGB CALLBACK HSItoRGB(const LPS_HSI sHSI);
S_CMY CALLBACK RGBtoCMY(const LPS_RGB sRGB);
S_RGB CALLBACK CMYtoRGB(const LPS_CMY sCMY);
S_YIQ CALLBACK RGBtoYIQ(const LPS_RGB sRGB);
S_RGB CALLBACK YIQtoRGB(const LPS_YIQ sYIQ);
S_YUV CALLBACK RGBtoYUV(const LPS_RGB sRGB);
S_RGB CALLBACK YUVtoRGB(const LPS_YUV sYUV);
S_YUV CALLBACK YIQtoYUV(const LPS_YIQ sYIQ);
S_YIQ CALLBACK YUVtoYIQ(const LPS_YUV sYUV);
S_YUV CALLBACK CMYtoYUV(const LPS_CMY sCMY);
S_YIQ CALLBACK CMYtoYIQ(const LPS_CMY sCMY);
S_CMY CALLBACK YUVtoCMY(const LPS_YUV sYUV);
S_CMY CALLBACK YIQtoCMY(const LPS_YIQ sYIQ);
S_CMYK CALLBACK CMYtoCMYK(const LPS_CMY sCMY);
S_CMY CALLBACK CMYKtoCMY(const LPS_CMYK sCMYK);
S_RGB CALLBACK CMYKtoRGB(const LPS_CMYK sCMYK);
S_YUV CALLBACK CMYKtoYUV(const LPS_CMYK sCMYK);
S_CMYK CALLBACK YUVtoCMYK(const LPS_YUV sYUV);
S_YIQ CALLBACK CMYKtoYIQ(const LPS_CMYK sCMYK);
S_CMYK CALLBACK YIQtoCMYK(const LPS_YIQ sYIQ);
S_HSV CALLBACK YUVtoHSV(const LPS_YUV sYUV);
S_YUV CALLBACK HSVtoYUV(const LPS_HSV sHSV);
S_HSV CALLBACK YIQtoHSV(const LPS_YIQ sYIQ);
S_YIQ CALLBACK HSVtoYIQ(const LPS_HSV sHSV);
S_HSV CALLBACK CMYtoHSV(const LPS_CMY sCMY);
S_CMY CALLBACK HSVtoCMY(const LPS_HSV sHSV);
S_HSV CALLBACK CMYKtoHSV(const LPS_CMYK sCMYK);
S_CMYK CALLBACK HSVtoCMYK(const LPS_HSV sHSV);
S_RGB CALLBACK XYZtoRGB(const LPS_XYZ sXYZ);
S_XYZ CALLBACK RGBtoXYZ(const LPS_RGB sRGB);
S_YUV CALLBACK XYZtoYUV(const LPS_XYZ sXYZ);
S_XYZ CALLBACK YUVtoXYZ(const LPS_YUV sYUV);
S_YIQ CALLBACK XYZtoYIQ(const LPS_XYZ sXYZ);
S_XYZ CALLBACK YIQtoXYZ(const LPS_YIQ sYIQ);
S_CMY CALLBACK XYZtoCMY(const LPS_XYZ sXYZ);
S_XYZ CALLBACK CMYtoXYZ(const LPS_CMY sCMY);
S_CMYK CALLBACK XYZtoCMYK(const LPS_XYZ sXYZ);
S_XYZ CALLBACK CMYKtoXYZ(const LPS_CMYK sCMYK);
S_HSV CALLBACK XYZtoHSV(const LPS_XYZ sXYZ);
S_XYZ CALLBACK HSVtoXYZ(const LPS_HSV sHSV);
S_LAB CALLBACK RGBtoLAB(const LPS_RGB sRGB);
S_RGB CALLBACK LABtoRGB(const LPS_LAB sLAB);
S_LAB CALLBACK YUVtoLAB(const LPS_YUV sYUV);
S_YUV CALLBACK LABtoYUV(const LPS_LAB sLAB);
S_LAB CALLBACK YIQtoLAB(const LPS_YIQ sYIQ);
S_YIQ CALLBACK LABtoYIQ(const LPS_LAB sLAB);
S_LAB CALLBACK HSVtoLAB(const LPS_HSV sHSV);
S_HSV CALLBACK LABtoHSV(const LPS_LAB sLAB);
S_LAB CALLBACK CMYtoLAB(const LPS_CMY sCMY);
S_CMY CALLBACK LABtoCMY(const LPS_LAB sLAB);
S_LAB CALLBACK CMYKtoLAB(const LPS_CMYK sCMYK);
S_CMYK CALLBACK LABtoCMYK(const LPS_LAB sLAB);
S_LAB CALLBACK XYZtoLAB(const LPS_XYZ sXYZ);
S_XYZ CALLBACK LABtoXYZ(const LPS_LAB sLAB);
S_YIQ CALLBACK HSItoYIQ(const LPS_HSI sHSI);
S_HSI CALLBACK YIQtoHSI(const LPS_YIQ sYIQ);
S_YUV CALLBACK HSItoYUV(const LPS_HSI sHSI);
S_HSI CALLBACK YUVtoHSI(const LPS_YUV sYUV);
S_HSV CALLBACK HSItoHSV(const LPS_HSI sHSI);
S_HSI CALLBACK HSVtoHSI(const LPS_HSV sHSV);
S_CMY CALLBACK HSItoCMY(const LPS_HSI sHSI);
S_HSI CALLBACK CMYtoHSI(const LPS_CMY sCMY);
S_CMYK CALLBACK HSItoCMYK(const LPS_HSI sHSI);
S_HSI CALLBACK CMYKtoHSI(const LPS_CMYK sCMYK);
S_XYZ CALLBACK HSItoXYZ(const LPS_HSI sHSI);
S_HSI CALLBACK XYZtoHSI(const LPS_XYZ sXYZ);
S_LAB CALLBACK HSItoLAB(const LPS_HSI sHSI);
S_HSI CALLBACK LABtoHSI(const LPS_LAB sLAB);


HDIB CALLBACK ConvertDIBColorSpace(HDIB hDib, int nFormatSrc, int nFormatDest, BOOL bShowProgress, HWND hParent);
int CALLBACK ConvertColorSpace(BYTE* bufferSrc, BYTE* bufferDest, int iSize, int nFormatSrc, int nFormatDest, BOOL bShowProgress, HWND hParent);
int CALLBACK GetLastColorConvertError();

HANDLE   CALLBACK ColorConvolution(HANDLE hDIB1, BOOL bUndoMode,
                         BOOL bPsychovisual, short nFilterType,
                         short nSize, LPSTR lpFileName,
                         short FAR *lpFilter, LPINT lpnErrorFlag,
						 int iShowProgress, HWND hParent);
HANDLE CALLBACK ColorBrightnessContrast(HANDLE hDIB1, short nBrightness, short nContrast, BOOL bShowDialog);
HDIB CALLBACK ColorHueSaturation(HDIB hDib, int hue, int saturation, int intensity, UINT min, UINT max, int iShowProgress, HWND hParent);
HDIB CALLBACK ColorCMYKLevels(HDIB hDib, int cyan, int magneta, int yellow, int black, int iShowProgress, HWND hParent);
HDIB CALLBACK Desaturate(HDIB hDib, int iShowProgress, HWND hParent);
HDIB CALLBACK ReplaceColor(HDIB hDib, RGBTRIPLE rgb, S_REP pLimit, int hue, int saturation, int intensity, int iShowProgress, HWND hParent);

HDIB CALLBACK GammaCorrection(HDIB hDib, int Red, int Green, int Blue, int iShowProgress, HWND hParent);

int CALLBACK SplitColorChannels(HDIB hDib, HDIB *hDibChannels, BYTE colorFormat);

// Dithering functions
HANDLE   CALLBACK DitherFS4(HANDLE hDIB, int nBitCount);
HANDLE   CALLBACK DitherJJN(HANDLE hDIB, int nBitCount);
HANDLE   CALLBACK DitherSmooth(HANDLE hDIB, int nBitCount);
HANDLE   CALLBACK DitherSharp(HANDLE hDIB, int nBitCount);
HANDLE   CALLBACK DitherStucki(HANDLE hDIB, int nBitCount);
HANDLE   CALLBACK DitherBurkes(HANDLE hDIB, int nBitCount);
HANDLE   CALLBACK DitherSierra(HANDLE hDIB, int nBitCount);
HANDLE   CALLBACK DitherSA(HANDLE hDIB, int nBitCount); 
HDIB	 CALLBACK DitherOrdered(HDIB hDib, int nMatrix);

void CALLBACK GetBiImageVersion(LPSTR lpBuffer, int nMaxByte);

#endif