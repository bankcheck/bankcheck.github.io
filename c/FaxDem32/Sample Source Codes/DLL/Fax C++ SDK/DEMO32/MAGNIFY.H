
void CALLBACK    M_SetSizes(int X,int Y);
void CALLBACK    M_CopyBitmap(HWND hWnd,int X,int Y);
void CALLBACK    M_StartMagnify(HWND hWnd,HPALETTE hPal);   
void CALLBACK    M_StopMagnify();
void CALLBACK    M_StretchBitmap(HBITMAP hBitmap,int X,int Y,int nWidth,int nHeight);
int  CALLBACK    M_GetWidth();
int  CALLBACK    M_GetHeight(); 
BOOL CALLBACK    M_CalcRect(int X,int Y,LPRECT lpScale,LPRECT lpOut);


