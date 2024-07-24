///////////////////////////////////////////////////////////////////////////////////////
// dibpal.h  retrive palette information from a DIB.
typedef HANDLE HDIB;
BOOL WINAPI CreateDIBPalette(HDIB hDIB, CPalette* pPal);
