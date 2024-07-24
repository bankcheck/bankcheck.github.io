#include "resource.h"

extern "C" {
int WINAPI WinMain(HINSTANCE hInstance,HINSTANCE hPrevInstance,LPSTR lpCmdLine,int nCmdShow);
BOOL InitApplication(HANDLE);
BOOL InitInstance(HANDLE, int);
long CALLBACK MainWndProc(HWND, UINT, WPARAM, LPARAM);
BOOL CALLBACK About(HWND, unsigned, WORD, LONG);
};