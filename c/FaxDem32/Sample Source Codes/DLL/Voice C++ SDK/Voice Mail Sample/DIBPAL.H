/* DIB constants */
///////////////////////////////////////////////////////////////////////////////////////
// dibpal.h  retrive palette information from a DIB and a TIFF file.

BOOL WINAPI CreateDIBPalette(HDIB hDIB, CPalette* pPal);
BOOL WINAPI	CreateDIBPaletteFromTiff(TIFFFILE hChain, int nImage, CPalette *cPal);
