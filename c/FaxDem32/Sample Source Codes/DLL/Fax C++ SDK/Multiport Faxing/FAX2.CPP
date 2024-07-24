/******************************************************************************\
*       This is a part of the Black Ice Source Code Samples. 
*       Copyright (C) 2000 Black Ice Software, Inc.
*       All rights reserved. 
*       This source code is only intended as a supplement to 
*       Black Ice Development Tools.
*       See these sources for detailed information regarding the 
*       Black Ice samples programs.
\******************************************************************************/



// *********************************** INCLUDE FILES ***************************

#include "windows.h"         

#include <string.h>
#undef SetPort
#include "fax2.h"            
#include "faxcpp.h"        
#include "faxclass.h"
#include "commcl.h"
#include "stdio.h"
extern "C" {
    #include "bitiff.h"
	#include "bidib.h"
}



// *********************************** DEFINES *********************************

#define MAX_ERROR_LENGTH	MAX_CALLNUMBER+255
#define MAX_FAXPORTS		600
#define RESULT_FILE_PATH	"resultinfo.log"
#define SOURCE_FILE_PATH	"filelist.inf"



// *********************************** GLOBAL VARIABLES ************************

HANDLE		hInst;								//application instance handle

PORTFAX     FaxPorts[MAX_FAXPORTS];				//list of opened fax ports

int			nOpenFaxPorts=0;					//number of opened fax ports

FILE *		g_pFile					=	NULL;	//Pointer to information file.
												//This file contains information
												//about filenames and phone numbers
												//where the fax must be sent.

int			g_totalSent				= 0;		//Number of sent faxes

// *********************************** FUNCTIONS *******************************


void My_WriteResultInfo( 
						const char * strResult 
						)
{
	FILE * pFile = fopen( RESULT_FILE_PATH, "a+" );
	if( pFile )
	{
		fputs( strResult, pFile );
		fclose( pFile );
	}
}


int WINAPI WinMain(
				   HINSTANCE hInstance,
				   HINSTANCE hPrevInstance,
				   LPSTR lpCmdLine,
				   int nCmdShow)
{
    MSG msg;                     

    if ( !hPrevInstance )
        if ( !InitApplication(hInstance) )
			return ( FALSE );

    if( !InitInstance(hInstance, nCmdShow) )
        return (FALSE);

//To use the FAX C++ software package the FAX C++ driver mechanism must be
//initialized first with calling the SetupFaxDriver function.
    if ( !SetupFaxDriver( NULL ) ) 
	{

//Connects the ports to the fax hardware
	//COM port
        FaxPorts[nOpenFaxPorts] = ConnectPortExt("COM1", "GCLASS1(SFC)", "faxcpp1.ini");
		if( FaxPorts[nOpenFaxPorts] )
		{
			My_WriteResultInfo("COM1 port opened\n");
			nOpenFaxPorts++;
		}

		FaxPorts[nOpenFaxPorts] = ConnectPortExt("COM2", "GCLASS1(SFC)", "faxcpp1.ini");
		if( FaxPorts[nOpenFaxPorts] )
		{
			My_WriteResultInfo("COM2 port opened\n");
			nOpenFaxPorts++;
		}

	//Brooktrout board
		FaxPorts[nOpenFaxPorts] = ConnectPortExt("Channel0", NULL, "btcall.cfg");
		if( FaxPorts[nOpenFaxPorts] )
		{
			My_WriteResultInfo("Brooktrout 1st opened\n");
			nOpenFaxPorts++;
		}
		FaxPorts[nOpenFaxPorts] = ConnectPortExt("Channel1", "Brooktrout Channel", "btcall.cfg");
		if( FaxPorts[nOpenFaxPorts] )
		{
			My_WriteResultInfo("Brooktrout 2nd opened\n");
			nOpenFaxPorts++;
		}

	//NMS board
		NMS_SetProtocol( "LPS0" );
		//another NMS protocols: 
		//	LPS0, DID0, OGT0, WNK0, WNK1, LPS8, FDI0, LPS9, GST8, GST9
		NMS_SetDIDDigitNumber(4);
		//open the the 1st channel on 1st board
		FaxPorts[nOpenFaxPorts] = ConnectChannel( "NMS_B0CH0", NULL, BRD_NMS );
		if( FaxPorts[nOpenFaxPorts] )
		{
			My_WriteResultInfo("NMS 1st opened\n");
			nOpenFaxPorts++;
		}

		//open the the 2nd channel on 1st board
		FaxPorts[nOpenFaxPorts] = ConnectChannel( "NMS_B0CH1", NULL, BRD_NMS );
		if( FaxPorts[nOpenFaxPorts] )
		{
			My_WriteResultInfo("NMS 1st opened\n");
			nOpenFaxPorts++;
		}

	//GammaLink board
		FaxPorts[nOpenFaxPorts] = ConnectChannel( "Channel0", NULL, BRD_GAMMALINK );
		if( FaxPorts[nOpenFaxPorts] )
		{
			My_WriteResultInfo("GammaLink 1st opened\n");
			nOpenFaxPorts++;
		}

		FaxPorts[nOpenFaxPorts] = ConnectChannel( "Channel1", NULL, BRD_GAMMALINK );
		if( FaxPorts[nOpenFaxPorts] )
		{
			My_WriteResultInfo("GammaLink 2nd opened\n");
			nOpenFaxPorts++;
		}

	//Dialogic board
		//open the the 1st channel on 1st board
		FaxPorts[nOpenFaxPorts] = ConnectChannel( "dxxxB1C1", NULL, BRD_DIALOGIC );
		if( FaxPorts[nOpenFaxPorts] )
		{
			My_WriteResultInfo("Dialogic 1st opened\n");
			nOpenFaxPorts++;
		}

		//open the the 2nd channel on 1st board
		FaxPorts[nOpenFaxPorts] = ConnectChannel( "dxxxB1C2", NULL, BRD_DIALOGIC );
		if( FaxPorts[nOpenFaxPorts] )
		{
			My_WriteResultInfo("Dialogic 2nd opened\n");
			nOpenFaxPorts++;
		}

//Port connect summary:
//The FaxPorts array contains the opened FAX port pointer
//The nOpenFaxPorts variable contains the number of opened ports



		if( nOpenFaxPorts==0 || FaxPorts[0]==NULL )
		{
//Failed to open ports (at least one)
			return(FALSE);//close the application
		}

		for( int i=0; i<=nOpenFaxPorts; i++ )
		{
			if( FaxPorts[i] )
			{
//Specifies the number of rings waiting before the  fax port automatically picks up 
//the phone. If -1 is given as ring number, the fax port  will never pick up the phone.
				SetAutoAnswer(FaxPorts[i], 1);
			}
		}
	}

    while (GetMessage(&msg,   
        NULL,          
        NULL,          
        NULL))         
    {
		TranslateMessage(&msg);
		DispatchMessage(&msg);
    }
    return (msg.wParam);       
}


BOOL InitApplication(
					 HANDLE hInstance
					 )
{
    WNDCLASS  wc;
    
    wc.style			= NULL;                   
    wc.lpfnWndProc		= MainWndProc;      
    wc.cbClsExtra		= 0;                 
    wc.cbWndExtra		= 0;                 
    wc.hInstance		= (HINSTANCE)hInstance;          
    wc.hIcon			= LoadIcon(NULL, IDI_APPLICATION);
    wc.hCursor			= LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground	= (HBRUSH)GetStockObject(WHITE_BRUSH);
    wc.lpszMenuName		=  "GenericMenu";  
    wc.lpszClassName	= "BlIceWClass"; 

    return (RegisterClass(&wc));
}

BOOL InitInstance(
				  HANDLE hInstance,
				  int nCmdShow
				  )
{
    HWND	hWnd;             

    hInst = hInstance;

    hWnd = CreateWindow(
        "BlIceWClass",                
        "Multiport Faxing - Sample Application",   
        WS_OVERLAPPEDWINDOW,          
        CW_USEDEFAULT,                
        CW_USEDEFAULT,                
        CW_USEDEFAULT,                
        CW_USEDEFAULT,                
        NULL,                         
        NULL,                         
        (HINSTANCE)hInstance,                    
        NULL                          
    );

    if (!hWnd)
        return (FALSE);

    ShowWindow(hWnd, nCmdShow);  
    UpdateWindow(hWnd);          
    return (TRUE);               
}


bool My_GetNextFaxFromList(
					  char * callNumber,
					  char * fileName
					  )
{
	char	strRow[MAX_PATH+MAX_CALLNUMBER+3],
		 *	pScr								=	NULL;

	if( !g_pFile )
	{
//Try to open information file.
		g_pFile = fopen(SOURCE_FILE_PATH,"r");
		if( !g_pFile )
		{
			My_WriteResultInfo("Failed to open information file. Exit now.\n\n");
			exit(0);
		}
	}

//Read new row from file.
	if( fgets( strRow, MAX_PATH+MAX_CALLNUMBER+3, g_pFile ) == NULL )
	{
		char strResult[255];
		sprintf( strResult, "FINISHED (try to send %d faxes)\n\n", g_totalSent );
		My_WriteResultInfo(strResult);
		fclose( g_pFile );
		exit(1);
	}
//Get the file name and the phone number from the row.
	pScr = strchr( strRow, ' ' );
	if( pScr )
	{
		*pScr = '\0';
		strcpy( fileName, strRow );
		pScr++;
		strcpy( callNumber, pScr );
		pScr = strrchr( callNumber, '\n' );
		if( pScr )
			*pScr = '\0';
		return true;
	}
	return false;
}

int My_GetNumberOfImagesInFile( 
							   const char *fileName 
							   )
{
//Get the format of the image
	switch( GetImageFormat( (LPSTR)fileName ) )
	{
//If the format of the image is Tiff or FAX then the file may contains
//more then one pages.
	case TIFF_FILE:
		return GetNumberOfImagesInTiffFile( (LPSTR)fileName );
	case FAX_FILE:
		return GetNumberOfImagesInFaxFile( (LPSTR)fileName );
	default:
		return 1;
	}
}

PORTFAX My_GetFreeFaxPort()
{
	TSPortStatus sPortStatus;

	for( int iFreePort=0; iFreePort<=nOpenFaxPorts; iFreePort++ )
	{
//Detect if the communication port is in an open or closed state.
		if( FaxPorts[iFreePort]->IsOpen() )
		{
//Returns the state of the given port.
            GetPortStatus( 
							FaxPorts[iFreePort], 
							&sPortStatus);

            if(  sPortStatus.Status == CST_NOTHING &&			//If the port is used 
																	//for nothing
				!sPortStatus.Break &&							//If the port is not
																	//breaked
				 IsFaxPortEnabled(FaxPorts[iFreePort]) > 0 )	//If the port enabled in
																	//the Fax Driver
            {
                return FaxPorts[iFreePort];
            }
		}
	}
	return NULL;
}


FAXOBJ My_CreateFaxObject( 
						  const char * callNumber, 
						  const int nPage 
						  )
{
	TSFaxParam	sFaxParam;

//Fill TSFaxParam stcucture what store information about a fax.
	sFaxParam.PageNum		= nPage;		//Number of pages in a fax.
	sFaxParam.Width			= PWD_1728;		//Convert pages to 1728 pixel wide images.
    sFaxParam.Length		= PLN_NOCHANGE;	//Use default value (PLN_UNLIMITED).
    sFaxParam.Binary		= BFT_DISABLE;	//Disable Class 1 binary file transmission.
    sFaxParam.BitOrder		= BTO_FIRST_LSB;//The least significant bit will be sent first.
    sFaxParam.Resolut		= RES_NOCHANGE;	//Use default value.
    sFaxParam.Send			= TRUE;			//The data transmission is send.
    sFaxParam.DeleteFiles	= TRUE;			//Delete the temporary file if it is not used.
    sFaxParam.Ecm			= ECM_DISABLE;	//Disable Error correction mode (ECM).
    sFaxParam.Compress		= DCF_1DMH;		//Use 1 dimensional CCITT Group 3 compression.
	strcpy( sFaxParam.RemoteNumber, 
			callNumber);					//Identification string of the destination address.
	
//Creates a FAX object
	return CreateSendFax( REGTYPE_NORMALFAX, &sFaxParam );
}

FAXOBJ My_CreateFaxForSend( 
						   const char * callNumber, 
						   const char * fileName 
						   )
{
	char				strError[MAX_ERROR_LENGTH];
	FAXOBJ				faxObj						= NULL;
	HANDLE				hDibLoc						= NULL;
	union TUFaxImage	sFaxPage;
	int					iError						= 0;

//Get the number of page in the file
	const int			nPage	= My_GetNumberOfImagesInFile( fileName );

//Create the fax object
	faxObj = My_CreateFaxObject( callNumber, nPage );

	if( faxObj )
	{
		for ( int actualPage=0; actualPage<nPage; actualPage++ )
		{
//Load all the pages from the file to memory one by one.
			hDibLoc = LoadImageIntoDIB(
										(LPSTR)fileName,
										actualPage,
										&iError);
			if( hDibLoc )
			{
                LPBITMAPINFOHEADER lpDib = (LPBITMAPINFOHEADER)GlobalLock(hDibLoc);
				
                lpDib->biXPelsPerMeter = 7874;
                lpDib->biYPelsPerMeter = 7874;
				
                GlobalUnlock(hDibLoc);
				
				sFaxPage.Dib = hDibLoc;

//Sets the new page of the given fax.
				iError = SetFaxImagePage(
										faxObj,
										actualPage,
										IMT_MEM_DIB,
										&sFaxPage,
										0);
				GlobalFree( hDibLoc );
				hDibLoc = NULL;
				if( iError != 0 )
				{
					printf( strError, "Failed to set page (number %d).\n",actualPage );
					My_WriteResultInfo( strError );
				}
			}
			else
			{
				printf( strError, "Failed to load page (number %d) of the image.\n",actualPage );
				My_WriteResultInfo( strError );
			}
		}
	}
	return faxObj;
}


long CALLBACK MainWndProc(
								   HWND hWnd,
								   UINT message,
								   WPARAM wParam,
								   LPARAM lParam)
{
	static UINT FaxMsg;
    int i=0;

    switch (message) {
        
		case WM_CREATE:
//The RegisterWindowMessage function defines a new window message that is guaranteed
//to be unique throughout the system.
			FaxMsg = RegisterWindowMessage( REG_FAXMESSAGE );
//Registers the given window for receiving events of the fax transmission.
//This registered window will receive registered message.
			SetFaxMessage( hWnd );
			break;

        case WM_COMMAND:
            switch ( wParam ) {
				case IDM_ABOUT:
					DialogBox( (HINSTANCE)hInst, "AboutBox", hWnd, (DLGPROC)About );
					break;
				default:   
					return (DefWindowProc(hWnd, message, wParam, lParam));
			}
			break;

		case WM_DESTROY:  
//Removes the driver immediately from memory
			EndOfFaxDriver( TRUE );
			PostQuitMessage(0);
			break;
	}
    if ( message == FaxMsg ) {
//wParam contains the type of message
		switch( wParam ) {

			case MFX_ENDSEND:
			{
//The driver is finished sending the fax.
//The lParam parameter contains the address of the fax object.
				++g_totalSent;
                FAXOBJ fax=(FAXOBJ)lParam;
                if(fax) {
                    ClearFaxObj(fax);
                }
				break;
			}
			case MFX_TERMINATE:
//An error has occured. The lParam contains the address of the port object.
			{
				PORTFAX						port		= (PORTFAX)lParam;
				TSSessionParameters			theSession;
				
//Get information about the terminated fax session.
				if( GetSessionParameters(port,&theSession)==0 )
				{
					char	strError[MAX_ERROR_LENGTH];
					memset( strError, '\0', MAX_ERROR_LENGTH );

//Get status information in string
					sprintf( strError, "Phone number: %s - Status code: %d\n", theSession.DialNumber, theSession.TStatus );
					My_WriteResultInfo( strError );
				}

				break;
			}
			case MFX_IDLE:
//Port is in IDLE state, it is not used by anyone.
//The lParam parameter contains the port.
				if( lParam )
				{
					char	callNumber[MAX_CALLNUMBER];
					char	fileName[MAX_PATH];
					PORTFAX	faxPort						= (PORTFAX)lParam;

//Get the next filename and phone number what we want to send
					while(	!My_GetNextFaxFromList( callNumber, fileName ) )
						;

//Prepare fax for send
					FAXOBJ faxObject = My_CreateFaxForSend(
															callNumber,
															fileName );
					if( faxObject )
					{
//Send the fax through the given port immediately.
						int iError = SendFaxNow( faxPort, faxObject, FALSE );
						if( iError !=0 )
							My_WriteResultInfo("Failed to sendfax.\n");
					}
					else
						My_WriteResultInfo("Failed to create fax object. (Maybe not enought memory.)\n");
				}
				break;
		}
    }
    else
		return (DefWindowProc(hWnd, message, wParam, lParam));
    return (NULL);
}

//Open About bialog box
BOOL CALLBACK About(
							 HWND hDlg, 
							 unsigned message, 
							 WORD wParam, 
							 LONG lParam)
{
    switch ( message ) {
        case WM_INITDIALOG:	//message: initialize dialog box
            return (TRUE);
        case WM_COMMAND:	//message: received a command
            if (wParam == IDOK || wParam == IDCANCEL) {
                EndDialog(hDlg, TRUE);	//Exits the dialog box
                return (TRUE);
            }
            break;
    }
    return (FALSE);
}
