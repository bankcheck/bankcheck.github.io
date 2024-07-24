#define STRICT
#include	<windows.h>
#pragma	hdrstop

#include	<stdio.h>

#include	"codec.h"
#include	"resource.h"

#define	CLASSNAME	"CODEC by Black Ice"

bool		bASyncMode	= false;
HINSTANCE	hInst		= NULL;
UINT		unCodecMsg	= RegisterWindowMessage(CODEC_MESSAGE);

static	char	szSrcWAV[MAX_PATH];
static	char	szSrcVOC[MAX_PATH];

void	ConvertWAV2VOC(HWND hwnd)
{
OPENFILENAME	ofn;

	memset(&ofn,0,sizeof(ofn));
	ofn.lStructSize	= sizeof(ofn);
	ofn.hwndOwner	= hwnd;
	ofn.hInstance	= hInst;
	ofn.lpstrFilter	= "WAV Files\0*.WAV\0";
	ofn.lpstrFile	= szSrcWAV;
	ofn.nMaxFile	= MAX_PATH;
	ofn.lpstrTitle	= "Convert WAV to VOC";
	ofn.Flags		= OFN_FILEMUSTEXIST;
	ofn.lpstrDefExt	= "WAV";
	if( GetOpenFileName(&ofn) )
	{
	char	szTemp[50];
	char	szVocFile[MAX_PATH];
	char	*pC;

		strcpy(szVocFile,szSrcWAV);
		pC = strrchr(szVocFile,'.');
		strcpy(pC,".VOC");

		if( !bASyncMode )
		{
			OutputDebugString("Conversion from WAV to VOC started\n");
		}

		int nID = ConvertWAV2VOC(szSrcWAV,szVocFile,4,bASyncMode ? MODE_ASYNC : MODE_SYNC);

		if( !bASyncMode )
		{
			OutputDebugString("Conversion from WAV to VOC finished\n");
			sprintf(szTemp,"Conversion result: [%s]\n", nID ? "NOT COMPLETED" : "COMPLETED");
			OutputDebugString(szTemp);
		}
		else
		{
			sprintf(szTemp,"Conversion ID: [%d]\n", nID);
			OutputDebugString(szTemp);
		}
	}
}

void	ConvertVOC2WAV(HWND hwnd)
{
OPENFILENAME	ofn;

	memset(&ofn,0,sizeof(ofn));
	ofn.lStructSize	= sizeof(ofn);
	ofn.hwndOwner	= hwnd;
	ofn.hInstance	= hInst;
	ofn.lpstrFilter	= "VOC Files\0*.VOC\0";
	ofn.lpstrFile	= szSrcVOC;
	ofn.nMaxFile	= MAX_PATH;
	ofn.lpstrTitle	= "Convert VOC to WAV";
	ofn.Flags		= OFN_FILEMUSTEXIST;
	ofn.lpstrDefExt	= "WAV";
	if( GetOpenFileName(&ofn) )
	{
	char	szTemp[50];
	char	szWAVFile[MAX_PATH];
	char	*pC;

		strcpy(szWAVFile,szSrcVOC);
		pC = strrchr(szWAVFile,'.');
		strcpy(pC,".WAV");

		if( !bASyncMode )
		{
			OutputDebugString("Conversion from VOC to WAV started\n");
		}

		int nID = ConvertVOC2WAV(szSrcVOC,szWAVFile,4,FREQ_11025,bASyncMode ? MODE_ASYNC : MODE_SYNC);
		if( !bASyncMode )
		{
			OutputDebugString("Conversion from VOC to WAV finished\n");
			sprintf(szTemp,"Conversion result: [%s]\n", nID ? "NOT COMPLETED" : "COMPLETED");
			OutputDebugString(szTemp);
		}
		else
		{
			sprintf(szTemp,"Conversion ID: [%d]\n", nID);
			OutputDebugString(szTemp);
		}
	}
}

void	ConvertWAV2ImaADPCM(HWND hwnd)
{
OPENFILENAME	ofn;

	memset(&ofn,0,sizeof(ofn));
	ofn.lStructSize	= sizeof(ofn);
	ofn.hwndOwner	= hwnd;
	ofn.hInstance	= hInst;
	ofn.lpstrFilter	= "WAV Files\0*.WAV\0";
	ofn.lpstrFile	= szSrcWAV;
	ofn.nMaxFile	= MAX_PATH;
	ofn.lpstrTitle	= "Convert WAV to IMAADPCM";
	ofn.Flags		= OFN_FILEMUSTEXIST;
	ofn.lpstrDefExt	= "WAV";
	if( GetOpenFileName(&ofn) )
	{
	char	szTemp[50];
	char	szVocFile[MAX_PATH];
	char	*pC;

		strcpy(szVocFile,szSrcWAV);
		pC = strrchr(szVocFile,'.');
		strcpy(pC,".USR");

		if( !bASyncMode )
		{
			OutputDebugString("Conversion from WAV to IMAADPCM started\n");
		}

		int nID = ConvertPCMtoIMAADPCM(szSrcWAV,szVocFile,bASyncMode ? MODE_ASYNC : MODE_SYNC);

		if( !bASyncMode )
		{
			OutputDebugString("Conversion from WAV to IMAADPCM finished\n");
			sprintf(szTemp,"Conversion result: [%s]\n", nID ? "NOT COMPLETED" : "COMPLETED");
			OutputDebugString(szTemp);
		}
		else
		{
			sprintf(szTemp,"Conversion ID: [%d]\n", nID);
			OutputDebugString(szTemp);
		}
	}
}

void	ConvertImaADPCM2WAV(HWND hwnd)
{
OPENFILENAME	ofn;

	memset(&ofn,0,sizeof(ofn));
	ofn.lStructSize	= sizeof(ofn);
	ofn.hwndOwner	= hwnd;
	ofn.hInstance	= hInst;
	ofn.lpstrFilter	= "IMA ADPCM Files\0*.USR\0";
	ofn.lpstrFile	= szSrcWAV;
	ofn.nMaxFile	= MAX_PATH;
	ofn.lpstrTitle	= "Convert IMAADPCM to WAV";
	ofn.Flags		= OFN_FILEMUSTEXIST;
	ofn.lpstrDefExt	= "USR";
	if( GetOpenFileName(&ofn) )
	{
	char	szTemp[50];
	char	szVocFile[MAX_PATH];
	char	*pC;

		strcpy(szVocFile,szSrcWAV);
		pC = strrchr(szVocFile,'.');
		strcpy(pC,".WAV");

		if( !bASyncMode )
		{
			OutputDebugString("Conversion from IMAADPCM to WAV started\n");
		}

		int nID = ConvertIMAADPCMtoPCM(szSrcWAV,szVocFile,bASyncMode ? MODE_ASYNC : MODE_SYNC);

		if( !bASyncMode )
		{
			OutputDebugString("Conversion from IMAADPCM to WAV finished\n");
			sprintf(szTemp,"Conversion result: [%s]\n", nID ? "NOT COMPLETED" : "COMPLETED");
			OutputDebugString(szTemp);
		}
		else
		{
			sprintf(szTemp,"Conversion ID: [%d]\n", nID);
			OutputDebugString(szTemp);
		}
	}
}

void ConvertDialogicADPCMtoPCM(HWND hwnd)
{
OPENFILENAME	ofn;

	memset(&ofn,0,sizeof(ofn));
	ofn.lStructSize	= sizeof(ofn);
	ofn.hwndOwner	= hwnd;
	ofn.hInstance	= hInst;
	ofn.lpstrFilter	= "Dialogic ADPCM Files\0*.VOX\0";
	ofn.lpstrFile	= szSrcWAV;
	ofn.nMaxFile	= MAX_PATH;
	ofn.lpstrTitle	= "Convert Dialogic ADPCM to PCM";
	ofn.Flags		= OFN_FILEMUSTEXIST;
	ofn.lpstrDefExt	= "VOX";
	if( GetOpenFileName(&ofn) )
	{
	char	szTemp[50];
	char	szVocFile[MAX_PATH];
	char	*pC;

		strcpy(szVocFile,szSrcWAV);
		pC = strrchr(szVocFile,'.');
		strcpy(pC,".WAV");

		if( !bASyncMode )
		{
			OutputDebugString("Conversion from Dialogic ADPCM to PCM started\n");
		}

		int nID = ConvertDialogicADPCMtoPCM(szSrcWAV,szVocFile,bASyncMode ? MODE_ASYNC : MODE_SYNC);

		if( !bASyncMode )
		{
			OutputDebugString("Conversion from Dialogic ADPCM to PCM finished\n");
			sprintf(szTemp,"Conversion result: [%s]\n", nID ? "NOT COMPLETED" : "COMPLETED");
			OutputDebugString(szTemp);
		}
		else
		{
			sprintf(szTemp,"Conversion ID: [%d]\n", nID);
			OutputDebugString(szTemp);
		}
	}
}

void ConvertPCMtoDialogicADPCM(HWND hwnd)
{
OPENFILENAME	ofn;

	memset(&ofn,0,sizeof(ofn));
	ofn.lStructSize	= sizeof(ofn);
	ofn.hwndOwner	= hwnd;
	ofn.hInstance	= hInst;
	ofn.lpstrFilter	= "PCM WAVE Files\0*.WAV\0";
	ofn.lpstrFile	= szSrcWAV;
	ofn.nMaxFile	= MAX_PATH;
	ofn.lpstrTitle	= "Convert PCM to Dialogic ADPCM";
	ofn.Flags		= OFN_FILEMUSTEXIST;
	ofn.lpstrDefExt	= "WAV";
	if( GetOpenFileName(&ofn) )
	{
	char	szTemp[50];
	char	szVocFile[MAX_PATH];
	char	*pC;

		strcpy(szVocFile,szSrcWAV);
		pC = strrchr(szVocFile,'.');
		strcpy(pC,".VOX");

		if( !bASyncMode )
		{
			OutputDebugString("Conversion from PCM to Dialogic ADPCM started\n");
		}

		int nID = ConvertPCMtoDialogicADPCM(szSrcWAV,szVocFile,bASyncMode ? MODE_ASYNC : MODE_SYNC);

		if( !bASyncMode )
		{
			OutputDebugString("Conversion from PCM to Dialogic ADPCM finished\n");
			sprintf(szTemp,"Conversion result: [%s]\n", nID ? "NOT COMPLETED" : "COMPLETED");
			OutputDebugString(szTemp);
		}
		else
		{
			sprintf(szTemp,"Conversion ID: [%d]\n", nID);
			OutputDebugString(szTemp);
		}
	}
}



void	ConvertPCM8TOPCM11(HWND hwnd)
{
	OPENFILENAME	ofn;

	memset(&ofn,0,sizeof(ofn));
	ofn.lStructSize	= sizeof(ofn);
	ofn.hwndOwner	= hwnd;
	ofn.hInstance	= hInst;
	ofn.lpstrFilter	= "WAV Files\0*.WAV\0";
	ofn.lpstrFile	= szSrcWAV;
	ofn.nMaxFile	= MAX_PATH;
	ofn.lpstrTitle	= "Convert 8KHz PCM to 11KHz PCM";
	ofn.Flags		= OFN_FILEMUSTEXIST;
	ofn.lpstrDefExt	= "WAV";
	if( GetOpenFileName(&ofn) )
	{
		char	szTemp[50];
		char	szVocFile[MAX_PATH];
		char	*pC;

		strcpy(szVocFile,szSrcWAV);
		pC = strrchr(szVocFile,'.');
		strcpy(pC,"1.WAV");

		if( !bASyncMode )
		{
			OutputDebugString("Conversion from PCM8 to PCM11 started\n");
		}

		int nID = ConvertPCM8toPCM11(szSrcWAV,szVocFile,bASyncMode ? MODE_ASYNC : MODE_SYNC);

		if( !bASyncMode )
		{
			OutputDebugString("Conversion from PCM8 to PCM11 finished\n");
			sprintf(szTemp,"Conversion result: [%s]\n", nID ? "NOT COMPLETED" : "COMPLETED");
			OutputDebugString(szTemp);
		}
		else
		{
			sprintf(szTemp,"Conversion ID: [%d]\n", nID);
			OutputDebugString(szTemp);
		}
	}
}

void	ConvertPCM11TOPCM8(HWND hwnd)
{
OPENFILENAME	ofn;

	memset(&ofn,0,sizeof(ofn));
	ofn.lStructSize	= sizeof(ofn);
	ofn.hwndOwner	= hwnd;
	ofn.hInstance	= hInst;
	ofn.lpstrFilter	= "WAV Files\0*.WAV\0";
	ofn.lpstrFile	= szSrcWAV;
	ofn.nMaxFile	= MAX_PATH;
	ofn.lpstrTitle	= "Convert 11KHz PCM to 8KHz PCM";
	ofn.Flags		= OFN_FILEMUSTEXIST;
	ofn.lpstrDefExt	= "WAV";
	if( GetOpenFileName(&ofn) )
	{
	char	szTemp[50];
	char	szVocFile[MAX_PATH];
	char	*pC;

		strcpy(szVocFile,szSrcWAV);
		pC = strrchr(szVocFile,'.');
		strcpy(pC,"1.WAV");

		if( !bASyncMode )
		{
			OutputDebugString("Conversion from PCM11 to PCM8 started\n");
		}

		int nID = ConvertPCM11toPCM8(szSrcWAV,szVocFile,bASyncMode ? MODE_ASYNC : MODE_SYNC);

		if( !bASyncMode )
		{
			OutputDebugString("Conversion from PCM11 to PCM8 finished\n");
			sprintf(szTemp,"Conversion result: [%s]\n", nID ? "NOT COMPLETED" : "COMPLETED");
			OutputDebugString(szTemp);
		}
		else
		{
			sprintf(szTemp,"Conversion ID: [%d]\n", nID);
			OutputDebugString(szTemp);
		}
	}
}


LRESULT CALLBACK WindowProc( HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam ) 
{
	if( uMsg == unCodecMsg )
	{
	char	szTemp[50];

		if( wParam == CDC_STARTED )
		{
			OutputDebugString("Asynchronous conversion started\n");
		}
		else if( wParam == CDC_FINISHED )
		{
			OutputDebugString("Asynchronous conversion finished\n");
		}

		sprintf(szTemp,"Conversion ID: [%d]\n", lParam);
		OutputDebugString(szTemp);
		return 1;
	}
	else
	{
		switch(uMsg)
		{
			case	WM_INITMENUPOPUP:
				CheckMenuItem((HMENU) wParam,ID_CONVERT_ASYNCHRONOUS, MF_BYCOMMAND | bASyncMode ? MF_CHECKED : MF_UNCHECKED );
			break;

			case	WM_COMMAND:
				switch(wParam)
				{
					case	ID_EXIT:
						DestroyWindow(hwnd);
					break;

					case	ID_CONVERT_WAVTOVOC:
						ConvertWAV2VOC(hwnd);
					break;

					case	ID_CONVERT_VOCTOWAV: 
						ConvertVOC2WAV(hwnd);
					break;

                    case    ID_CONVERT_WAVTOIMAADPCM:
                        ConvertWAV2ImaADPCM(hwnd);
                    break;

                    case    ID_CONVERT_IMAADPCMTOWAV:
                        ConvertImaADPCM2WAV(hwnd);
                    break;

                    case    ID_CONVERT_DIALOGICADPCMTOPCM:
                        ConvertDialogicADPCMtoPCM(hwnd);
                    break;

                    case    ID_CONVERT_PCMTODIALOGICADPCM:
                        ConvertPCMtoDialogicADPCM(hwnd);
                    break;

					case	ID_CONVERT_ASYNCHRONOUS:
						bASyncMode = bASyncMode ^ 1;
					break;
					case    ID_CONVERT_PCM11PCM8:
                        ConvertPCM11TOPCM8(hwnd);
                    break;
                    case    ID_CONVERT_PCM8PCM11:
                        ConvertPCM8TOPCM11(hwnd);
                    break;
				}
			break;
		}
		return DefWindowProc( hwnd,uMsg,wParam,lParam);
	}
}
 
int WINAPI WinMain( HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow )
{
	*szSrcWAV	= 0;
	*szSrcVOC	= 0;
    hInst = hInstance;
	if( hPrevInstance == NULL )
	{
	WNDCLASS	wndClass;

		wndClass.style			= CS_HREDRAW | CS_VREDRAW ;
		wndClass.lpfnWndProc	= WindowProc; 
		wndClass.cbClsExtra		= 0; 
		wndClass.cbWndExtra		= 0;
		wndClass.hInstance		= hInst;
		wndClass.hIcon			= LoadIcon(hInstance, MAKEINTRESOURCE(IDI_ICON1));;
		wndClass.hCursor		= LoadCursor(NULL,IDC_ARROW);
		wndClass.hbrBackground	= (HBRUSH)GetStockObject(WHITE_BRUSH);
		wndClass.lpszMenuName	= MAKEINTRESOURCE(IDR_MAINMENU);
		wndClass.lpszClassName	= CLASSNAME;

		RegisterClass(&wndClass);
	}

    HWND	hwnd	= CreateWindow(CLASSNAME,"CODEC Example Program",
								WS_OVERLAPPEDWINDOW,
								0,0,320,200,
								NULL,
								NULL,
								hInst,
								NULL);

	if( hwnd )
	{
	MSG		msg;
	int		nExit = 0;

		ShowWindow(hwnd,SW_SHOW);
		UpdateWindow(hwnd);

		StartCODEC(hwnd, THREAD_PRIORITY_LOWEST);

		for(;;)
		{
			nExit = GetMessage(&msg,hwnd,0,0);
			if( !nExit || nExit == -1 )
			{
				break;
			}
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}

		TerminateCODEC();
	}

	return 0;
}
 
