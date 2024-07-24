/****************************************************************************/
/*            (c) Copyright Black Ice Software Inc.  1994.                  */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/****************************************************************************/

//#include "windows.h"
#include <afxwin.h>
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

#include "faxcpp.h"
#include "faxtype.h"

//
// Change settings
//



#ifndef _BROOKTROUT
#define COM_PORT            "COM4"
#define MODEM_SHORT_NAME    "GCLASS1(SFC)"
#define INIFILE_NAME        "FAXCPP1.INI"
#define BMP_FILENAME        "test.tif"
#define PHONE_NUMBER        "1"

#else

#define COM_PORT            "Channel2"
#define MODEM_SHORT_NAME    NULL
#define INIFILE_NAME        "btcall.cfg"
#define BMP_FILENAME        "\\faxsrc40\\demo41\\cover.tif"
#define PHONE_NUMBER        "t6724112"
#endif

void SendFax(void);
void WaitForModem(PORTFAX       faxport , DWORD dwMaxTime );

int PASCAL WinMain(HINSTANCE hinstCurrent,HINSTANCE  hinstPrevious,LPSTR  lpCmdLine, int nCmdShow)
{
    SendFax();
    return 0 ;
}

//
// This simple application contains the minimum amount of code to send a fax.
//
void SendFax()
{
    struct TSHeaderContext header;
    struct tm       ctm;
    time_t          CurTime=time(NULL);
    PORTFAX         faxport = 0;
    FAXOBJ          fax;
    struct TSFaxParam  sFaxParam ;
    union TUFaxImage  FaxPage ;
    char            FaxFile[256] ;
    int             stat = 99 , i;

#ifdef _DEBUG
    assert(SetupFaxDriver(NULL)==0);
#else
    SetupFaxDriver(NULL);
#endif

    SetRuningMode(RNM_ALWAYSFREE);

#ifdef _DEBUG
    assert((faxport= ConnectPortExt(COM_PORT,MODEM_SHORT_NAME,INIFILE_NAME)) != 0 );	//itt elszall, ha nyitva van a megadott port!
//	if (!ConnectPortExt(COM_PORT,MODEM_SHORT_NAME,INIFILE_NAME))
//		return;
    assert(SetSpeaker(faxport,STO_COMM,SPV_MEDIUM) == 0 );
#else
    faxport= ConnectPortExt(COM_PORT,MODEM_SHORT_NAME,INIFILE_NAME);
    SetSpeaker(faxport,STO_COMM,SPV_MEDIUM);
#endif

#ifndef _BROOKTROUT
    WaitForModem(faxport,60000 * 3); // Max 3 min
#endif
    sFaxParam.PageNum =1;
    sFaxParam.Resolut = RES_196LPI ;
    sFaxParam.Width = PWD_1728;
    sFaxParam.Length = PLN_NOCHANGE ;
    sFaxParam.Compress = DCF_1DMH ;
    sFaxParam.Binary   = BFT_DISABLE;
    sFaxParam.BitOrder = BTO_FIRST_LSB ;
    strcpy(sFaxParam.RemoteNumber,PHONE_NUMBER);
    sFaxParam.DeleteFiles = TRUE ;
    sFaxParam.Send = TRUE ;
    sFaxParam.Ecm = ECM_DISABLE;

#ifdef _DEBUG
    assert((fax = CreateSendFax('N',&sFaxParam) ) != 0);
#else
    fax = CreateSendFax('N',&sFaxParam);
#endif
    EnableLog( faxport, TRUE );
    strcpy( FaxFile, BMP_FILENAME );
    memset(&FaxPage,0,sizeof(FaxPage));
    FaxPage.File = FaxFile ;
    if ( fax ) {
        ctm = *localtime( &CurTime );
        wsprintf( header.lpszFrom, "From : %s ", "Fax C++ test source" );
        wsprintf( header.lpszTo, "To : %s", sFaxParam.RemoteNumber+1 );
        wsprintf( header.lpszDateTimePage, "On : %s", asctime( &ctm ) );
        for ( i=0 ; i<3 ; i++ ) {
            strcpy( header.Record[i].FontFaceName , "Courier_New" );
            header.Record[i].FontSize = 8;
            header.Record[i].Weight = 0;
            header.Record[i].Italic = 0;
            header.Record[i].Underline = 0;
            header.Record[i].StrikeOut = 0;
        }
        SetRect( &header.Record[0].Position,0,50, 52,100 );
        SetRect( &header.Record[1].Position, 662,50, 1211,100 );
        SetRect( &header.Record[2].Position, 1212,50, 1212+600,100 );
        SetFaxHeader( fax, &header );
        stat = SetFaxImagePage( fax, 0, IMT_FILE_TIFF_G31D, &FaxPage, 0 );

		int ret,ret2;

        ret = SendFaxNow( faxport, fax, FALSE );
		CString str;
		str.Format("%d",ret);
		AfxMessageBox(str);
		WaitForModem( faxport, 60000 * 15 );     // Max 15 min
#ifdef _DEBUG
        assert(DisconnectPort(faxport)==0);
#else
        DisconnectPort( faxport );
#endif
        ClearFaxObj( fax );
        EndOfFaxDriver( TRUE );
		OutputDebugString("*** END ***");
    }
}

// timer for modem
void WaitForModem( PORTFAX faxport, DWORD dwMaxTime )
{
    MSG     msg ;
    BOOL    bMsg ;
    DWORD   dwEndTime ;
    struct TSPortStatus PortStatus ;

    dwEndTime = GetCurrentTime()+dwMaxTime ;

    for(;;) {
        bMsg = PeekMessage(&msg,NULL,NULL,NULL,PM_REMOVE);
        if (bMsg) {
            DispatchMessage(&msg);
        }
        GetPortStatus (faxport,&PortStatus);
		char sz[128];
		sprintf(sz, "*** Status: %d", PortStatus.Status);
		//OutputDebugString(sz);
        if (PortStatus.Status == 0) {
            // Port operation completed

            break ;
        }
        if (GetCurrentTime() > dwEndTime   ) {
            // Port operation timeout
            break ;
        }
    }
}

