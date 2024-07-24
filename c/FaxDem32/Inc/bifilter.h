#include <windows.h>

#ifndef _BIFILTER_H
#define _BIFILTER_H

typedef HANDLE HDIB;

#define DISPLAY_NONE				0
#define DISPLAY_PROGRESS			1
#define DISPLAY_DIALOG				2
#define DISPLAY_BOTH				3

#define GRADIENT_NORTH_ISOTROPIC		0
#define GRADIENT_NORTHEAST_ISOTROPIC	1
#define GRADIENT_EAST_ISOTROPIC			2
#define GRADIENT_SOUTHEAST_ISOTROPIC	3
#define GRADIENT_SOUTH_ISOTROPIC		4
#define GRADIENT_SOUTHWEST_ISOTROPIC	5
#define GRADIENT_WEST_ISOTROPIC			6
#define GRADIENT_NORTHWEST_ISOTROPIC	7

#define GRADIENT_NORTH_KIRSCH		10
#define GRADIENT_NORTHEAST_KIRSCH	11
#define GRADIENT_EAST_KIRSCH		12
#define GRADIENT_SOUTHEAST_KIRSCH	13
#define GRADIENT_SOUTH_KIRSCH		14
#define GRADIENT_SOUTHWEST_KIRSCH	15
#define GRADIENT_WEST_KIRSCH		16
#define GRADIENT_NORTHWEST_KIRSCH	17

#define GRADIENT_NORTH_PIXELDIFF		20
#define GRADIENT_NORTHEAST_PIXELDIFF	21
#define GRADIENT_EAST_PIXELDIFF			22
#define GRADIENT_SOUTHEAST_PIXELDIFF	23
#define GRADIENT_SOUTH_PIXELDIFF		24
#define GRADIENT_SOUTHWEST_PIXELDIFF	25
#define GRADIENT_WEST_PIXELDIFF			26
#define GRADIENT_NORTHWEST_PIXELDIFF	27

#define GRADIENT_NORTH_PREWIT		30
#define GRADIENT_NORTHEAST_PREWIT	31
#define GRADIENT_EAST_PREWIT		32
#define GRADIENT_SOUTHEAST_PREWIT	33
#define GRADIENT_SOUTH_PREWIT		34
#define GRADIENT_SOUTHWEST_PREWIT	35
#define GRADIENT_WEST_PREWIT		36
#define GRADIENT_NORTHWEST_PREWIT	37

#define GRADIENT_NORTH_SEPPIXDIFF		40
#define GRADIENT_NORTHEAST_SEPPIXDIFF	41
#define GRADIENT_EAST_SEPPIXDIFF		42
#define GRADIENT_SOUTHEAST_SEPPIXDIFF	43
#define GRADIENT_SOUTH_SEPPIXDIFF		44
#define GRADIENT_SOUTHWEST_SEPPIXDIFF	45
#define GRADIENT_WEST_SEPPIXDIFF		46
#define GRADIENT_NORTHWEST_SEPPIXDIFF	47

#define GRADIENT_NORTH_SOBEL		50
#define GRADIENT_NORTHEAST_SOBEL	51
#define GRADIENT_EAST_SOBEL			52
#define GRADIENT_SOUTHEAST_SOBEL	53
#define GRADIENT_SOUTH_SOBEL		54
#define GRADIENT_SOUTHWEST_SOBEL	55
#define GRADIENT_WEST_SOBEL			56
#define GRADIENT_NORTHWEST_SOBEL	57

#define GRADIENT_NORTH_ROBERTS		60
#define GRADIENT_NORTHEAST_ROBERTS	61
#define GRADIENT_EAST_ROBERTS		62
#define GRADIENT_SOUTHEAST_ROBERTS	63
#define GRADIENT_SOUTH_ROBERTS		64
#define GRADIENT_SOUTHWEST_ROBERTS	65
#define GRADIENT_WEST_ROBERTS		66
#define GRADIENT_NORTHWEST_ROBERTS	67

#define LAPLACE_4_NEIGHBOURALL			0
#define LAPLACE_4_NEIGHBOURNORTH		1
#define LAPLACE_4_NEIGHBOURWEST			2

#define LAPLACE_8_NEIGHBOURALL			10
#define LAPLACE_8_NEIGHBOURNORTH		11
#define LAPLACE_8_NEIGHBOURWEST			12
#define LAPLACE_8_NEIGHBOURNORTHWEST	13
#define LAPLACE_8_NEIGHBOURNORTHEAST	14

#define DIFF_HORIZONTAL				0
#define DIFF_VERTICAL				1
#define DIFF_NORTHWEST_SOUTHEAST	2
#define DIFF_NORTHEAST_SOUTHWEST	3

#define NO_FILTER_ERROR			1
#define ERROR_NO_BIDLGS			-1	// BIDlgs.dll does not exist
#define ERROR_NO_BIIMAGE		-2	// BIImage.dll does not exist
#define ERROR_INVALIDPARAMETER -3  // Invalid parameter
#define ERROR_DUPLICATE			-4  // Error duplicate DIB
#define ERROR_DEMO				-5  // Error Demo version

// ComputeLUT
#define OPEN                 30
#define COMPUTE              31
#define CLOSE                32

typedef struct _R_LIMITS
{
	BYTE tolerance;
	BYTE level;
}R_LIMITS;
typedef R_LIMITS far *  LPR_LIMITS; 

typedef struct _StructElement
{
				BYTE	**StrMask;		//:	Structuring Element
				int		Mheight;		//:	Structuring Element Height	
				int		Mwidth;			//:	Structuring Element	Width
				int		MPx;			//:	Structuring Element	Marked Point x coordinate
				int		MPy;			//:	Structuring Element Marked Point y coordinate
} StrE;

typedef enum enumOPER
{
    OPER_ADD,   /* 0    */
    OPER_SUB,   /* 1    */  
    OPER_MUL,   /* 2    */
    OPER_DIV,   /* 3    */
    OPER_AND,   /* 4    */
    OPER_NAND,  /* 5    */
    OPER_OR,    /* 6    */
    OPER_NOR,   /* 7    */
    OPER_XOR,   /* 8    */
    OPER_MIN,   /* 9    */
    OPER_MAX,   /* 10   */
    OPER_EXP,   /* 11   */
    OPER_LOG,   /* 12   */
} OPERATION; 

HDIB CALLBACK FilterLaplace(HDIB hDib, int iMode, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterGradient(HDIB hDib, int iMode, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterEnhance(HDIB hDib, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterUniform(HDIB hDib, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterGauss(HDIB hDib, int iShowProgress, HWND hParent);
int  CALLBACK GetLastFilterError();
HDIB CALLBACK RedEyeRemover(HDIB hDib, LPRECT rect, int iShowProgress, HWND hParent, LPR_LIMITS pLimits);
HDIB CALLBACK BinaryDilation(HDIB hDib, StrE *StrFunc, BOOL BackGrndisBlack, int iShowProgress, HWND hParent);
HDIB CALLBACK BinaryErosion(HDIB hDib, StrE *StrFunc, BOOL BackGrndisBlack, int iShowProgress, HWND hParent);
HDIB CALLBACK BinaryClosing(HDIB hDib, StrE *StrFunc, BOOL BackGrndisBlack, int iShowProgress, HWND hParent);
HDIB CALLBACK BinaryOpening(HDIB hDib, StrE *StrFunc, BOOL BackGrndisBlack, int iShowProgress, HWND hParent);
HDIB CALLBACK BinaryHitMiss(HDIB hDib, StrE *StrFunc1, StrE *StrFunc2,BOOL BackGrndisBlack, int iShowProgress, HWND hParent);
HDIB CALLBACK BinaryOutlining(HDIB hDib, StrE *StrFunc, BOOL OuterCont, BOOL BackGrndisBlack, int iShowProgress, HWND hParent);
HDIB CALLBACK BinarySkeleton(HDIB hDib, int MaxStep, BOOL BackGrndisBlack, int iShowProgress, HWND hParent);
HDIB CALLBACK BinaryThinning(HDIB hDib, BOOL BackGrndisBlack, int iShowProgress, HWND hParent);
HDIB CALLBACK BinaryThickening(HDIB hDib, BOOL BackGrndisBlack, int iShowProgress, HWND hParent);
HDIB CALLBACK GrayScaleDilation(HDIB hDib, StrE *StrFunc, int iShowProgress, HWND hParent);
HDIB CALLBACK GrayScaleErosion(HDIB hDib, StrE *StrFunc, int iShowProgress, HWND hParent);
HDIB CALLBACK GrayScaleClosing(HDIB hDib, StrE *StrFunc, int iShowProgress, HWND hParent);
HDIB CALLBACK GrayScaleOpening(HDIB hDib, StrE *StrFunc, int iShowProgress, HWND hParent);
HDIB CALLBACK GrayScaleTopHat(HDIB hDib, StrE *StrFunc, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterAlphaTrimmedMean(HDIB hDib, int N, int P, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterContraHarmonicMean(HDIB hDib, int N, int P, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterGeometricMean(HDIB hDib, int N, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterHarmonicMean(HDIB hDib, int N, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterMaximum(HDIB hDib, int N, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterMedian(HDIB hDib, int N, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterMidpoint(HDIB hDib, int N, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterMinimum(HDIB hDib, int N, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterRange(HDIB hDib, int N, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterWeightedMedian(HDIB hDib, StrE *StrFunc, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterYpMean(HDIB hDib, int N, int P, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterWeightedMean(HDIB hDib, StrE *StrFunc, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterAdaptiveDWMTM(HDIB hDib, int N, int Q, int C, int iShowProgress, HWND hParent);
HDIB CALLBACK FilterAdaptiveMMSE(HDIB hDib, int N, int NVAR, int iShowProgress, HWND hParent);

// Science functions
typedef struct
{
    int nDim;                   /* 1, 3    (3 for 24 bits/pixel, 1 for others) */
    int nColors;                /* 2, 16, 256 */                
    DWORD dwLowData[3];         /* Low  data */
    DWORD dwHighData[3];         /* High data */
    DWORD dwHistData[3][256];   /* Histogram data */
} HISTDATA;

typedef HISTDATA FAR *LPHISTDATA;   
#define FILTER_IDEAL            1
#define FILTER_BUTTERWORTH      2 

HANDLE CALLBACK ArithmeticDIB     (OPERATION oper, HANDLE hSrcDIB1, HANDLE hSrcDIB2, int iShowProgress, HWND hParent);
HANDLE CALLBACK ArithmeticDIBConst(OPERATION oper, HANDLE hSrcDIB,  WORD   wConst, int iShowProgress, HWND hParent);
HANDLE CALLBACK HistDIBComplement(HANDLE hSrcDIB, int iShowProgress, HWND hParent);
HANDLE CALLBACK HistDIBEqualization(HANDLE hSrcDIB, int iShowProgress, HWND hParent);
HANDLE CALLBACK HistDIBGen(HANDLE hDib, HWND hHisChild, BYTE nSelect);
HANDLE CALLBACK HistDIBModify(HANDLE hDib, int iShowProgress, HWND hParent);
HANDLE CALLBACK HistDIBSlide(HANDLE hDib, BYTE nBegin, BYTE nEnd, WORD nConst, int iShowProgress, HWND hParent);
HANDLE CALLBACK HistDIBStretch(HANDLE hDib, BYTE nBegin, BYTE nEnd, float fConst, int iShowProgress, HWND hParent);
HANDLE CALLBACK HistDIBThreshold(HANDLE hSrcDIB, WORD nConst, int iShowProgress, HWND hParent);

BOOL   CALLBACK HistDIBCreate(HANDLE hSrcDIB, LPHISTDATA lpHist);
BOOL    CALLBACK HistDispToDC(HDC hDC, LPHISTDATA lpHist, LPRECT lprc, int nSelect);
LRESULT CALLBACK HistDispWmPain(HWND hWnd, LPHISTDATA lpHist, int nSelect);
HANDLE   CALLBACK FreqDIBEnhance(HANDLE hSrcDIB, WORD nCutoff, float fAttenuate, BOOL bFFTMethod, BOOL bShowDialog);
HANDLE CALLBACK FreqDIBFFT(HANDLE hDib, BOOL bFFTMethod);
HANDLE CALLBACK FreqDIBHighpass(HANDLE hDib, WORD nCutoff, WORD nType, BOOL bFFTMethod, BOOL bShowDialog);
HANDLE CALLBACK FreqDIBHomomorphic(HANDLE hDib, WORD nCutoff, WORD nWidth, float fHigh, float fLow, BOOL bFFTMethod, BOOL bShowDialog);
HANDLE CALLBACK FreqDIBLowpass(HANDLE hDib, WORD nCutoff, WORD nType, BOOL bFFTMethod, BOOL bShowDialog);
HANDLE CALLBACK FreqDIBInverse(HANDLE hSrcDIB, HANDLE hDFDIB, BOOL bFFTMethod, int SpectMul);
HANDLE CALLBACK FreqDIBWiener(HANDLE hSrcDIB, HANDLE hDFDIB, double NSR, BOOL bFFTMethod, int SpectMul);
HANDLE   CALLBACK ApplyLUT(HANDLE, HANDLE, BOOL, LPINT);
HANDLE   CALLBACK ComputeLUT(HANDLE, int, HANDLE, int, int, LPINT);
HANDLE   CALLBACK ComputeHistogram(HANDLE, int, HANDLE, LPPOINT, LPINT);

void CALLBACK GetBiFilterVersion(LPSTR lpBuffer, int nMaxByte);

HANDLE CALLBACK FilterAutoContrast (HANDLE	hDib, int	iShowProgress, HWND	hParent);
HANDLE CALLBACK FilterParabolaTransformation (HANDLE	hDib, BOOL bInverse, int	iShowProgress, HWND	hParent);
HANDLE CALLBACK FilterSolarizing (HANDLE	hDib, int iThreshold, int	iShowProgress, HWND	hParent);
HANDLE CALLBACK FilterPosterizing (HANDLE	hDib, int iLevels, int	iShowProgress, HWND	hParent);
HANDLE CALLBACK FilterMotionBlur (HANDLE	hDib, int iAngle, int iDistance, int	iShowProgress, HWND	hParent);
HANDLE CALLBACK FilterCenterMotionBlur (HANDLE	hDib, int iFactor, int iDistance, int	iShowProgress, HWND	hParent);
HANDLE CALLBACK FilterLevels (HANDLE	hDib, int iInFrom, int iInTo, int iInMidtone, int iOutLow, int iOutHigh, int Channel , int	iShowProgress, HWND	hParent);
HANDLE CALLBACK FilterAutoLevels (HANDLE	hDib, int iPercent , int	iShowProgress, HWND	hParent);
HANDLE CALLBACK FilterDifference (HANDLE hDib, BYTE nDirection , int	iShowProgress, HWND	hParent);

HANDLE CALLBACK FilterMozaic(HANDLE	hDib, int iPixels , int	iShowProgress, HWND	hParent);
HANDLE CALLBACK FilterMultiply(HANDLE	hDib, int iFactor, int	iShowProgress, HWND	hParent);
HANDLE CALLBACK FilterCylinder(HANDLE	hDib, int iRadius, BOOL bHorizontal, int	iShowProgress, HWND	hParent);
HANDLE CALLBACK FilterAddNoise(HANDLE	hDib, int iLevel, int	iShowProgress, HWND	hParent);
HANDLE CALLBACK FilterPolar(HANDLE	hDib, int	iShowProgress, HWND	hParent);
HANDLE CALLBACK FilterImpressionist(HANDLE	hDib, int iHorizontal, int iVertical, int	iShowProgress, HWND	hParent);
HANDLE CALLBACK FilterAverage(HDIB hDib, int N, int iShowProgress, HWND hParent);
HANDLE CALLBACK FilterPuzzle(HANDLE	hDib, int iHorizontal, int iVertical, int	iShowProgress, HWND	hParent);
#endif