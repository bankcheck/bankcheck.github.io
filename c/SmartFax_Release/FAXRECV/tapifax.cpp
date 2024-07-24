#include "stdafx.h"

#include "FAXRECV.h"
#include "FAXRECVDlg.h"
#include "..\\include\\SmarFaxh.h"
#include "tapifax.h"



time_t		g_tInitTime;
DWORD		g_dwNumDevs;
DWORD		g_dwTAPIVer= 0x00020000;
LINEINITIALIZEEXPARAMS lineInitializeExParams;
#define TAPI_MAX_VERSION 0x0FFF0FFF
// Public available define 
HANDLE    hIOCP;            /* handle for IO Completion port */
HLINEAPP	g_hLineApp = NULL;

BOOL g_bShuttingDown = FALSE;
BOOL g_bStoppingCall = FALSE;
BOOL g_bInitializing = FALSE;

// This sample only supports one call in progress at a time.
BOOL g_bTapiInUse = FALSE;


// Data needed per call.  This sample only supports one call.
HCALL g_hCall = NULL;
HLINE g_hLine = NULL;

BOOL  g_bConnected = FALSE;

DWORD dwAPIVersion;


int g_nFlag = 0 ;


#pragma comment(lib, "Tapi32.lib")




BOOL Initialize_TAPI(DWORD dwDeviceID)
{


	long lReturn;
    BOOL bTryReInit = TRUE;
	HINSTANCE hInstance;
    // If we're already initialized, then initialization succeeds.
    if (g_hLineApp)
        return TRUE;
	
	
	if(g_bTapiInUse)
		return TRUE;
	
    // If we're in the middle of initializing, then fail, we're not done.
    if (g_bInitializing)
        return FALSE;	   
	
	hInstance = GetModuleHandle(NULL);
	LPLINEDEVCAPS lpDevCaps = NULL;
	
	
	// Initialize TAPI
    do
    {
		
		
#if		TAPI_CURRENT_VERSION >= 0x00020000
		
		memset(&lineInitializeExParams, 0, sizeof(LINEINITIALIZEEXPARAMS));
		// Populate the options...
		lineInitializeExParams.dwTotalSize = sizeof(LINEINITIALIZEEXPARAMS);
		lineInitializeExParams.dwOptions = LINEINITIALIZEEXOPTION_USEHIDDENWINDOW;
		
		dwAPIVersion = TAPI_CURRENT_VERSION;
		lReturn = lineInitializeEx(&g_hLineApp, hInstance, lineCallbackFunc, 
			"SmartFaxSample", &g_dwNumDevs, 
			&dwAPIVersion, &lineInitializeExParams);
#else
		// Note that you can't use this function and be UNICODE
		lReturn = lineInitialize(&g_hLineApp, hInstance, 
			lineCallbackFunc, "SmartFaxSample", &g_dwNumDevs);
#endif
		
		
		
		
        // If we get this error, its because some other app has yet
        // to respond to the REINIT message.  Wait 5 seconds and try
        // again.  If it still doesn't respond, tell the user.
        if (lReturn == LINEERR_REINIT)
        {
            if (bTryReInit)
            {
                MSG msg; 
                DWORD dwTimeStarted;
				
                dwTimeStarted = GetTickCount();
				
                while(GetTickCount() - dwTimeStarted < 5000)
                {
                    if (PeekMessage(&msg, 0, 0, 0, PM_REMOVE))
                    {
                        TranslateMessage(&msg);
                        DispatchMessage(&msg);
                    }
                }
				
                bTryReInit = FALSE;
                continue;
            }
            else
            {
                AfxMessageBox("A change to the system configuration requires that "
                    "all Telephony applications relinquish their use of "
                    "Telephony before any can progress.  "
                    "Some have not yet done so.");
				
                g_bInitializing = FALSE;
                return FALSE;
            }
        }
		
        if (lReturn == LINEERR_NODEVICE)
        {
			
			AfxMessageBox("No devices installed.\n");
            g_bInitializing = FALSE;
            return FALSE;            
        }
        else if(lReturn != SUCCESS)
        {
            AfxMessageBox("lineInitialize  error: ");
            g_bInitializing = FALSE;
            return FALSE;
        }
		
    } while(lReturn != SUCCESS);
	
	
	LINEEXTENSIONID LineExtensionID;
	
	if (lReturn = lineNegotiateAPIVersion(g_hLineApp, dwDeviceID, 
		0x00010004, TAPI_MAX_VERSION, &dwAPIVersion, &LineExtensionID))
	{
		TRACE(TEXT("lineNegotiateAPIVersion failed: %s.\r\n"), FormatTapiError(lReturn));
		g_bInitializing = FALSE;
		return FALSE;
	}
	
	
	
	lpDevCaps = (LINEDEVCAPS *)malloc(sizeof(LINEDEVCAPS)+1000);	// Allocate a little extra memory...
	if(!lpDevCaps)
	{
		TRACE("Out of memory \n");
		g_bInitializing = FALSE;
		return FALSE;
	}
	
	memset(lpDevCaps, 0, sizeof(LINEDEVCAPS)+1000);
	lpDevCaps->dwTotalSize = sizeof(LINEDEVCAPS)+1000;
	
	
	if( (lReturn = lineGetDevCaps(g_hLineApp, dwDeviceID, dwAPIVersion,0,lpDevCaps)) != SUCCESS)
	{
		TRACE(TEXT("lineGetDevCaps failed: %s.\r\n"), FormatTapiError(lReturn));	 
		free(lpDevCaps);
		g_bInitializing = FALSE;
		return FALSE;   
	}
	
	
	if (!(lpDevCaps->dwMediaModes & LINEMEDIAMODE_DATAMODEM))
	{
		TRACE("The selected line doesn't support DATAMODEM capabilities\n");	   
		free(lpDevCaps);
		g_bInitializing = FALSE;
		return FALSE;   
	}
	
	g_bTapiInUse = TRUE;

    // If we're in the middle of initializing, then fail, we're not done.
    g_bInitializing = TRUE;

    free(lpDevCaps);	
	return TRUE;   	
  
}



BOOL LineOpen_TAPI(DWORD dwPrill,DWORD dwDeviceID)
{

	long lReturn;   	
	if (lReturn = lineOpen(g_hLineApp, dwDeviceID, &g_hLine, dwAPIVersion, 0, g_tInitTime,
		dwPrill,LINEMEDIAMODE_DATAMODEM, NULL))
	{
		TRACE(TEXT("lineOpen failed: %s.\r\n"), FormatTapiError(lReturn));
		if(0x80000048)
		{
			AfxMessageBox("TAPI modem is not accessiable,Modem may be in user.");
		}
		
		//g_bInitializing = FALSE;
		return FALSE;
	}
	
	
	if( (lReturn = lineSetStatusMessages(g_hLine, 0x1ffffff, 0) ) )
	{
		TRACE(TEXT("lineOpen failed: %s.\r\n"), FormatTapiError(lReturn));
		//g_bInitializing = FALSE;				
		return FALSE;
	}
	
	
	return TRUE;

}




long CallFor_PASSTHROUGH(void)
{

	LINECALLPARAMS CallParams;
	ZeroMemory(&CallParams, sizeof(LINECALLPARAMS));
	CallParams.dwTotalSize =  sizeof(LINECALLPARAMS);
	
	// This is where we configure the device to allow us direct access to the modem in command mode 
	CallParams.dwBearerMode = LINEBEARERMODE_PASSTHROUGH;
	CallParams.dwMediaMode = LINEMEDIAMODE_DATAMODEM;
	
	// This specifies that we want to use only IDLE calls and
	// don't want to cut into a call that might not be IDLE (ie, in use). 
	CallParams.dwCallParamFlags = LINECALLPARAMFLAGS_IDLE;
	
	// We will assume there is only one address and use it (normal modem) 
	CallParams.dwAddressMode = LINEADDRESSMODE_ADDRESSID;
	CallParams.dwAddressID = 0;
	
	// Unimodem ignores these values. 
	(CallParams.DialParams).dwDialSpeed = 0;
	(CallParams.DialParams).dwDigitDuration = 0;
	(CallParams.DialParams).dwDialPause = 0;
	(CallParams.DialParams).dwWaitForDialtone = 0;
	
		
	return lineMakeCall(g_hLine,      //  Handle to the open line device on which a call is to be originated.
		&g_hCall,     //  Long pointer to an HCALL handle.
		"",           //  the telephone number
		0,            //  Country Code
		&CallParams); //  the s

	
}




BOOL InitializeTAPI(DWORD dwDeviceID)
{


	long lReturn;
    BOOL bTryReInit = TRUE;
	HINSTANCE hInstance;
    // If we're already initialized, then initialization succeeds.
    if (g_hLineApp)
        return TRUE;


	if(g_bTapiInUse)
		return TRUE;

    // If we're in the middle of initializing, then fail, we're not done.
    if (g_bInitializing)
        return FALSE;

    g_bInitializing = TRUE;

	hInstance = GetModuleHandle(NULL);
	LPLINEDEVCAPS lpDevCaps = NULL;


	 // Initialize TAPI
    do
    {
			

#if		TAPI_CURRENT_VERSION >= 0x00020000
		
		memset(&lineInitializeExParams, 0, sizeof(LINEINITIALIZEEXPARAMS));
		// Populate the options...
		lineInitializeExParams.dwTotalSize = sizeof(LINEINITIALIZEEXPARAMS);
		lineInitializeExParams.dwOptions = LINEINITIALIZEEXOPTION_USEHIDDENWINDOW;
				
		dwAPIVersion = TAPI_CURRENT_VERSION;
		lReturn = lineInitializeEx(&g_hLineApp, hInstance, lineCallbackFunc, 
			"SmartFaxSample", &g_dwNumDevs, 
			&dwAPIVersion, &lineInitializeExParams);
#else
		// Note that you can't use this function and be UNICODE
		 lReturn = lineInitialize(&g_hLineApp, hInstance, 
			  lineCallbackFunc, "SmartFaxSample", &g_dwNumDevs);
#endif
		
		
				

        // If we get this error, its because some other app has yet
        // to respond to the REINIT message.  Wait 5 seconds and try
        // again.  If it still doesn't respond, tell the user.
        if (lReturn == LINEERR_REINIT)
        {
            if (bTryReInit)
            {
                MSG msg; 
                DWORD dwTimeStarted;

                dwTimeStarted = GetTickCount();

                while(GetTickCount() - dwTimeStarted < 5000)
                {
                    if (PeekMessage(&msg, 0, 0, 0, PM_REMOVE))
                    {
                        TranslateMessage(&msg);
                        DispatchMessage(&msg);
                    }
                }
            
                bTryReInit = FALSE;
                continue;
            }
            else
            {
                AfxMessageBox("A change to the system configuration requires that "
                    "all Telephony applications relinquish their use of "
                    "Telephony before any can progress.  "
                    "Some have not yet done so.");

                g_bInitializing = FALSE;
                return FALSE;
            }
        }

        if (lReturn == LINEERR_NODEVICE)
        {
          
			AfxMessageBox("No devices installed.\n");
            g_bInitializing = FALSE;
            return FALSE;            
        }
        else if(lReturn != SUCCESS)
        {
            AfxMessageBox("lineInitialize  error: ");
            g_bInitializing = FALSE;
            return FALSE;
        }

    } while(lReturn != SUCCESS);


	LINEEXTENSIONID LineExtensionID;

   if (lReturn = lineNegotiateAPIVersion(g_hLineApp, dwDeviceID, 
      0x00010004, TAPI_MAX_VERSION, &dwAPIVersion, &LineExtensionID))
   {
      TRACE(TEXT("lineNegotiateAPIVersion failed: %s.\r\n"), FormatTapiError(lReturn));
	  g_bInitializing = FALSE;
      return FALSE;
   }



   lpDevCaps = (LINEDEVCAPS *)malloc(sizeof(LINEDEVCAPS)+1000);	// Allocate a little extra memory...
   if(!lpDevCaps)
   {
		TRACE("Out of memory \n");
		g_bInitializing = FALSE;
		return FALSE;
   }

   memset(lpDevCaps, 0, sizeof(LINEDEVCAPS)+1000);
   lpDevCaps->dwTotalSize = sizeof(LINEDEVCAPS)+1000;

   
   if( (lReturn = lineGetDevCaps(g_hLineApp, dwDeviceID, dwAPIVersion,0,lpDevCaps)) != SUCCESS)
   {
		TRACE(TEXT("lineGetDevCaps failed: %s.\r\n"), FormatTapiError(lReturn));	 
		free(lpDevCaps);
		g_bInitializing = FALSE;
    	return FALSE;   
   }
   
   
   if (!(lpDevCaps->dwMediaModes & LINEMEDIAMODE_DATAMODEM))
   {
	   TRACE("The selected line doesn't support DATAMODEM capabilities\n");	   
	   free(lpDevCaps);
	   g_bInitializing = FALSE;
	   return FALSE;   
   }
   
    free(lpDevCaps);
  
   
	g_tInitTime = time(NULL);
	if (lReturn = lineOpen(g_hLineApp, dwDeviceID, &g_hLine, dwAPIVersion, 0, g_tInitTime,
		LINECALLPRIVILEGE_NONE,LINEMEDIAMODE_DATAMODEM, NULL))
	{
		TRACE(TEXT("lineOpen failed: %s.\r\n"), FormatTapiError(lReturn));
		if(0x80000048)
		{
			AfxMessageBox("TAPI modem is not accessiable,Modem may be in user.");
		}
		
		g_bInitializing = FALSE;
		return FALSE;
	}


   if( (lReturn = lineSetStatusMessages(g_hLine, 0x1ffffff, 0) ) )
   {
	   TRACE(TEXT("lineOpen failed: %s.\r\n"), FormatTapiError(lReturn));
	   g_bInitializing = FALSE;

	 
	   return FALSE;
   }

    g_bInitializing = FALSE;

	g_bTapiInUse = TRUE;
	return TRUE;
}



//
//  FUNCTION: BOOL ShutdownTAPI()
//
//  PURPOSE: Shuts down all use of TAPI
//
//  PARAMETERS:
//    None
//
//  RETURN VALUE:
//    True if TAPI successfully shut down.
//
//  COMMENTS:
//
//    If ShutdownTAPI fails, then its likely either a problem
//    with the service provider (and might require a system
//    reboot to correct) or the application ran out of memory.
//
//

BOOL ShutdownTAPI()
{
    long lReturn;

    // If we aren't initialized, then Shutdown is unnecessary.
    if (g_hLineApp == NULL)
        return TRUE;

    // Prevent ShutdownTAPI re-entrancy problems.
    if (g_bShuttingDown)
        return TRUE;

    g_bShuttingDown = TRUE;

	lineDrop(g_hCall, NULL, 0);
	lineDeallocateCall(g_hCall);
	lineClose(g_hLine);

    
    do
    {
        lReturn = lineShutdown(g_hLineApp);
              
		if(lReturn != SUCCESS )
			TRACE("lineShutdown unhandled error: ");
       
    } while(lReturn != SUCCESS);

    g_bTapiInUse = FALSE;
    g_bConnected = FALSE;
    g_hLineApp = NULL;
    g_hCall = NULL;
    g_hLine = NULL;
    g_bShuttingDown = FALSE;
	g_bInitializing = FALSE;
    TRACE("TAPI uninitialized.\n");
    return TRUE;
}


#define CHAN_DEBUG_PRINT TRACE

DWORD g_dwAsyncReply = 0 ;
bool  g_fReplyReceived = false;
DWORD g_dwRequestedId = 0 ;


DWORD DoLineReply(long Device,DWORD  P1,  DWORD P2, DWORD P3 )
{
	if (g_dwRequestedId = P1) 
	{
        g_fReplyReceived = true;
        g_dwAsyncReply = P2;
	}    

//	if(P3)
	//	lineClose((HLINE)P3);			
		
	return P3;
}



long WaitForReply(long ID,DWORD dwWaitTime  )
{	
	g_dwAsyncReply = -1;

	if( ID > 0)			
	{
		g_fReplyReceived = false;
		g_dwRequestedId = ID;		

		DWORD dwStart = GetTickCount();		

		while(!g_fReplyReceived )
		{			
			PeekAndPump();	
			if( ((GetTickCount() - dwStart) >= dwWaitTime))
				return -2; // timeout!
		}

	}
	

	return g_dwAsyncReply;
}



BOOL PeekAndPump()
{
	static MSG msg;

	while (::PeekMessage(&msg,NULL,0,0,PM_NOREMOVE)) {
		if (!AfxGetApp()->PumpMessage()) {
			::PostQuitMessage(0);
			return FALSE;
		}	
	}

	return TRUE;
}


VOID FAR PASCAL  lineCallbackFunc(DWORD dwDevice, DWORD dwMsg, DWORD dwCallbackInstance, DWORD dwParam1, DWORD dwParam2, DWORD dwParam3)
{
   
				

	TRACE(" get the dwDevice %d \n",dwDevice);	
	TRACE(" get the dwMessageID %d \n",dwMsg);
	TRACE(" get the dwCallbackInstance %d \n",dwCallbackInstance);
	TRACE(" get the dwParam1 %d \n",dwParam1);
	TRACE(" get the dwParam2 %d \n",dwParam2);
	TRACE(" get the dwParam3 %d \n",dwParam3);
	TRACE("----------------------------------------------\n");

	static int n_RingTimes = 0 ;
	if(g_tInitTime !=(time_t)dwCallbackInstance)
		return ;
	
	switch(dwMsg)
    {
		case LINE_REPLY:
		{
			//LINEERR_ADDRESSBLOCKED
			DoLineReply(dwDevice,dwParam1,dwParam2,dwParam3);
			break;
		}

        case LINE_CALLSTATE:
        {
		
            switch(dwParam1)
            {
               
				case LINECALLSTATE_IDLE:
				{
					CHAN_DEBUG_PRINT("get Tapi msg LINECALLSTATE_IDLE\n");				
					lineDeallocateCall((HCALL) dwDevice);
					n_RingTimes = 0;					

					if(g_FaxDialog&&IsWindow(g_FaxDialog->GetSafeHwnd()))
					{
						g_FaxDialog->PostMessage(WM_SMARTFAX,WM_FAXMONITORSTART,0);
					}
					                     
				}

				break;

				case LINECALLSTATE_CONNECTED:
				{
    				CHAN_DEBUG_PRINT("get Tapi msg LINECALLSTATE_CONNECTED\n");
					
					if(g_FaxDialog&&IsWindow(g_FaxDialog->GetSafeHwnd()))
					{
						g_FaxDialog->RecvFaxInTapi();					
						//if(g_nFlag == 0 )
						{
							//g_FaxDialog->TapiSendCMD(g_hCall,g_hLine,"ATE0V1\r");
							//lineClose(g_hLine);
							//g_nFlag++;
						}

					//	LineOpen_TAPI(LINECALLPRIVILEGE_OWNER,0);
						
					}												
				}

				break;

                case LINECALLSTATE_DISCONNECTED:
                {
					CHAN_DEBUG_PRINT("get Tapi msg LINECALLSTATE_DISCONNECTED\n");
					lineDrop((HCALL) dwDevice, NULL, 0);				
					n_RingTimes = 0;
                    
                }
				break;

                case LINECALLSTATE_CONFERENCED:
                {

					CHAN_DEBUG_PRINT("get Tapi msg LINECALLSTATE_CONFERENCED\n");	
					n_RingTimes = 0;
                    
                }
				break;						 
				case LINECALLSTATE_OFFERING:			
				{										
					g_hCall  =  (HCALL) dwDevice;						
					CHAN_DEBUG_PRINT("get Tapi msg LINECALLSTATE_OFFERING -------------------\n");
					n_RingTimes = 0;
					
				}
				break;

				case LINECALLSTATE_ACCEPTED:
				{
						CHAN_DEBUG_PRINT("get Tapi msg LINECALLSTATE_ACCEPTED\n");
						g_hCall  =  (HCALL) dwDevice;					
					
				}

				break;
            }

            break;
        }

        case LINE_CLOSE:			
			CHAN_DEBUG_PRINT("get Tapi msg LINE_CLOSE\n");
			n_RingTimes = 0;
            break;

        case LINE_LINEDEVSTATE:
        {
            
			switch(dwParam1)
            {

				case LINECALLSTATE_IDLE:
					{
						CHAN_DEBUG_PRINT("get Tapi msg LINECALLSTATE_IDLE ..........\n ");				
						n_RingTimes = 0;
					}
				
					break;

                case LINEDEVSTATE_RINGING:
					{
						CHAN_DEBUG_PRINT("get Tapi msg LINEDEVSTATE_RINGING\n");				
				
						if(g_FaxDialog&&IsWindow(g_FaxDialog->GetSafeHwnd()))
						{
							g_FaxDialog->PostMessage(WM_SMARTFAX,WM_FAXRING,n_RingTimes++);
						}
				
					}
					break;                
            }

            break;
        }      

    } // End switch(dwMsg)

	
}


// Turn a TAPI Line error into a printable string.
LPTSTR FormatTapiError (long lError)
{
   static LPTSTR pszLineError[] = 
   {
     TEXT("LINEERR No Error"),
     TEXT("LINEERR_ALLOCATED"),
     TEXT("LINEERR_BADDEVICEID"),
     TEXT("LINEERR_BEARERMODEUNAVAIL"),
     TEXT("LINEERR Unused constant, ERROR!!"),
     TEXT("LINEERR_CALLUNAVAIL"),
     TEXT("LINEERR_COMPLETIONOVERRUN"),
     TEXT("LINEERR_CONFERENCEFULL"),
     TEXT("LINEERR_DIALBILLING"),
     TEXT("LINEERR_DIALDIALTONE"),
     TEXT("LINEERR_DIALPROMPT"),
     TEXT("LINEERR_DIALQUIET"),
     TEXT("LINEERR_INCOMPATIBLEAPIVERSION"),
     TEXT("LINEERR_INCOMPATIBLEEXTVERSION"),
     TEXT("LINEERR_INIFILECORRUPT"),
     TEXT("LINEERR_INUSE"),
     TEXT("LINEERR_INVALADDRESS"),
     TEXT("LINEERR_INVALADDRESSID"),
     TEXT("LINEERR_INVALADDRESSMODE"),
     TEXT("LINEERR_INVALADDRESSSTATE"),
     TEXT("LINEERR_INVALAPPHANDLE"),
     TEXT("LINEERR_INVALAPPNAME"),
     TEXT("LINEERR_INVALBEARERMODE"),
     TEXT("LINEERR_INVALCALLCOMPLMODE"),
     TEXT("LINEERR_INVALCALLHANDLE"),
     TEXT("LINEERR_INVALCALLPARAMS"),
     TEXT("LINEERR_INVALCALLPRIVILEGE"),
     TEXT("LINEERR_INVALCALLSELECT"),
     TEXT("LINEERR_INVALCALLSTATE"),
     TEXT("LINEERR_INVALCALLSTATELIST"),
     TEXT("LINEERR_INVALCARD"),
     TEXT("LINEERR_INVALCOMPLETIONID"),
     TEXT("LINEERR_INVALCONFCALLHANDLE"),
     TEXT("LINEERR_INVALCONSULTCALLHANDLE"),
     TEXT("LINEERR_INVALCOUNTRYCODE"),
     TEXT("LINEERR_INVALDEVICECLASS"),
     TEXT("LINEERR_INVALDEVICEHANDLE"),
     TEXT("LINEERR_INVALDIALPARAMS"),
     TEXT("LINEERR_INVALDIGITLIST"),
     TEXT("LINEERR_INVALDIGITMODE"),
     TEXT("LINEERR_INVALDIGITS"),
     TEXT("LINEERR_INVALEXTVERSION"),
     TEXT("LINEERR_INVALGROUPID"),
     TEXT("LINEERR_INVALLINEHANDLE"),
     TEXT("LINEERR_INVALLINESTATE"),
     TEXT("LINEERR_INVALLOCATION"),
     TEXT("LINEERR_INVALMEDIALIST"),
     TEXT("LINEERR_INVALMEDIAMODE"),
     TEXT("LINEERR_INVALMESSAGEID"),
     TEXT("LINEERR Unused constant, ERROR!!"),
     TEXT("LINEERR_INVALPARAM"),
     TEXT("LINEERR_INVALPARKID"),
     TEXT("LINEERR_INVALPARKMODE"),
     TEXT("LINEERR_INVALPOINTER"),
     TEXT("LINEERR_INVALPRIVSELECT"),
     TEXT("LINEERR_INVALRATE"),
     TEXT("LINEERR_INVALREQUESTMODE"),
     TEXT("LINEERR_INVALTERMINALID"),
     TEXT("LINEERR_INVALTERMINALMODE"),
     TEXT("LINEERR_INVALTIMEOUT"),
     TEXT("LINEERR_INVALTONE"),
     TEXT("LINEERR_INVALTONELIST"),
     TEXT("LINEERR_INVALTONEMODE"),
     TEXT("LINEERR_INVALTRANSFERMODE"),
     TEXT("LINEERR_LINEMAPPERFAILED"),
     TEXT("LINEERR_NOCONFERENCE"),
     TEXT("LINEERR_NODEVICE"),
     TEXT("LINEERR_NODRIVER"),
     TEXT("LINEERR_NOMEM"),
     TEXT("LINEERR_NOREQUEST"),
     TEXT("LINEERR_NOTOWNER"),
     TEXT("LINEERR_NOTREGISTERED"),
     TEXT("LINEERR_OPERATIONFAILED"),
     TEXT("LINEERR_OPERATIONUNAVAIL"),
     TEXT("LINEERR_RATEUNAVAIL"),
     TEXT("LINEERR_RESOURCEUNAVAIL"),
     TEXT("LINEERR_REQUESTOVERRUN"),
     TEXT("LINEERR_STRUCTURETOOSMALL"),
     TEXT("LINEERR_TARGETNOTFOUND"),
     TEXT("LINEERR_TARGETSELF"),
     TEXT("LINEERR_UNINITIALIZED"),
     TEXT("LINEERR_USERUSERINFOTOOBIG"),
     TEXT("LINEERR_REINIT"),
     TEXT("LINEERR_ADDRESSBLOCKED"),
     TEXT("LINEERR_BILLINGREJECTED"),
     TEXT("LINEERR_INVALFEATURE"),
     TEXT("LINEERR_NOMULTIPLEINSTANCE")
   };

   _declspec(thread) static TCHAR szError[512];
   DWORD dwError;
   HMODULE hTapiUIMod = GetModuleHandle(TEXT("TAPIUI.DLL"));

   if (hTapiUIMod)
   {
      dwError = FormatMessage(FORMAT_MESSAGE_FROM_HMODULE,
                    (LPCVOID)hTapiUIMod, TAPIERROR_FORMATMESSAGE(lError),
                    0, szError, sizeof(szError)/sizeof(TCHAR), NULL);
      if (dwError)
         return szError;
   }

   // Strip off the high bit to make the error code positive.
   dwError = (DWORD)lError & 0x7FFFFFFF;

   if ((lError > 0) || (dwError > sizeof(pszLineError)/sizeof(pszLineError[0])))
   {
      wsprintf(szError, TEXT("Unknown TAPI error code: 0x%lx"), lError);
      return szError;
   }

   return pszLineError[dwError];
}