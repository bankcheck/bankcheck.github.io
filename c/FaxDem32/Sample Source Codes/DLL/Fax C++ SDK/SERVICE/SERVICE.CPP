/******************************************************************************\
*       This is a part of the Black Ice Source Code Samples. 
*       Copyright (C) 1996 Black Ice Inc.
*       All rights reserved. 
*       This source code is only intended as a supplement to 
*       Black Ice Development Tools.
*       See these sources for detailed information regarding the 
*       Black Ice samples programs.
\******************************************************************************/

#define REC
/******************************************************************************\
*		Because of the REC define above compiling this source in its
*		current state will produce a service for receiving faxes.
*		If you would like send a fax from the NT Service, you have
*		to recompile this code as a Console Application WITHOUT the
*		REC define.
*		If you want to receive you should define REC in order to
*		call the function ReceiveFaxMessage from WorkerThread.
*		Before compilation don't forget to change the DLL names,
*		directories, COM port and modem settings according to
*		your system.
\******************************************************************************/

#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <process.h>
#undef SetPort
#include "faxcpp.h"	  
#include "faxclass.h"							 

//#define RUNASEXE

HANDLE                  hServDoneEvent = NULL;

void 	WorkerThread(void);
void 	WaitForFaxManagerReady(PORTFAX	sFaxPort);
void ReceiveFaxMessage( void) ;

#ifdef RUNASEXE

void main()
{

	printf("Start service routine\n");
	WorkerThread();
 	while(!_kbhit())
		Sleep(500);

}

#else


// this event is signalled when the
//  worker thread ends
//
SERVICE_STATUS          ssStatus;       // current status of the service

SERVICE_STATUS_HANDLE   sshStatusHandle;
DWORD                   dwGlobalErr;
DWORD                   TID = 0;
HANDLE                  threadHandle = NULL;

//  declare the service threads:
//
VOID    service_main(DWORD dwArgc, LPTSTR *lpszArgv);
VOID    service_ctrl(DWORD dwCtrlCode);
BOOL    ReportStatusToSCMgr(DWORD dwCurrentState,
                            DWORD dwWin32ExitCode,
                            DWORD dwCheckPoint,
                            DWORD dwWaitHint);
VOID    StopSampleService(LPTSTR lpszMsg);
VOID    die(char *reason);
VOID    worker_thread(VOID *notUsed);
VOID    StopSimpleService(LPTSTR lpszMsg);



//  main() --
//      all main does is call StartServiceCtrlDispatcher
//      to register the main service thread.  When the
//      API returns, the service has stopped, so exit.
//
VOID
main()
{
    SERVICE_TABLE_ENTRY dispatchTable[] = {
        { TEXT("SimpleService"), (LPSERVICE_MAIN_FUNCTION)service_main },
        { NULL, NULL }
    };

    if (!StartServiceCtrlDispatcher(dispatchTable)) {
        StopSimpleService("StartServiceCtrlDispatcher failed.");
    }
}



//  service_main() --
//      this function takes care of actually starting the service,
//      informing the service controller at each step along the way.
//      After launching the worker thread, it waits on the event
//      that the worker thread will signal at its termination.
//
VOID
service_main(DWORD dwArgc, LPTSTR *lpszArgv)
{
    DWORD                   dwWait;
    PSECURITY_DESCRIPTOR    pSD;
    SECURITY_ATTRIBUTES     sa;

    // register our service control handler:
    //
    sshStatusHandle = RegisterServiceCtrlHandler(
                                    TEXT("SimpleService"),
                                    (LPHANDLER_FUNCTION)service_ctrl);

    if (!sshStatusHandle)
        goto cleanup;

    // SERVICE_STATUS members that don't change in example
    //
    ssStatus.dwServiceType = SERVICE_WIN32_OWN_PROCESS;
    ssStatus.dwServiceSpecificExitCode = 0;


    // report the status to Service Control Manager.
    //
    if (!ReportStatusToSCMgr(
        SERVICE_START_PENDING, // service state
        NO_ERROR,              // exit code
        1,                     // checkpoint
        3000))                 // wait hint
        goto cleanup;

    // create the event object. The control handler function signals
    // this event when it receives the "stop" control code.
    //
    hServDoneEvent = CreateEvent(
        NULL,    // no security attributes
        TRUE,    // manual reset event
        FALSE,   // not-signalled
        NULL);   // no name

    if (hServDoneEvent == (HANDLE)NULL)
        goto cleanup;

    // report the status to the service control manager.
    //
    if (!ReportStatusToSCMgr(
        SERVICE_START_PENDING, // service state
        NO_ERROR,              // exit code
        2,                     // checkpoint
        3000))                 // wait hint
        goto cleanup;

    //
    pSD = (PSECURITY_DESCRIPTOR) LocalAlloc(LPTR,
                SECURITY_DESCRIPTOR_MIN_LENGTH);

    if (pSD == NULL) {
        StopSimpleService("LocalAlloc pSD failed");
        return;
    }

    if (!InitializeSecurityDescriptor(pSD, SECURITY_DESCRIPTOR_REVISION)) {
        StopSimpleService("InitializeSecurityDescriptor failed");
        LocalFree((HLOCAL)pSD);
        return;
    }

    // add a NULL disc. ACL to the security descriptor.
    //
    if (!SetSecurityDescriptorDacl(pSD, TRUE, (PACL) NULL, FALSE)) {
        StopSimpleService("SetSecurityDescriptorDacl failed");
        LocalFree((HLOCAL)pSD);
        return;
    }

    sa.nLength = sizeof(sa);
    sa.lpSecurityDescriptor = pSD;
    sa.bInheritHandle = TRUE;       // why not...

    //
    threadHandle = CreateThread(
                    NULL,       // security attributes
                    0,          // stack size (0 means inherit parent's stack size)
                    (LPTHREAD_START_ROUTINE)WorkerThread,
                    NULL,       // argument to thread
                    0,          // thread creation flags
                    &TID);      // pointer to thread ID

    if (!threadHandle)
        goto cleanup;

    // report the status to the service control manager.
    //
    if (!ReportStatusToSCMgr(
        SERVICE_RUNNING, // service state
        NO_ERROR,        // exit code
        0,               // checkpoint
        0))              // wait hint
        goto cleanup;

    // wait indefinitely until hServDoneEvent is signaled.
    //
    dwWait = WaitForSingleObject(
        hServDoneEvent,  // event object
        INFINITE);       // wait indefinitely

cleanup:

    if (hServDoneEvent != NULL)
        CloseHandle(hServDoneEvent);


    // try to report the stopped status to the service control manager.
    //
    if (sshStatusHandle != 0)
        (VOID)ReportStatusToSCMgr(
                            SERVICE_STOPPED,
                            dwGlobalErr,
                            0,
                            0);

    // When SERVICE MAIN FUNCTION returns in a single service
    // process, the StartServiceCtrlDispatcher function in
    // the main thread returns, terminating the process.
    //
    return;
}



//  service_ctrl() --
//      this function is called by the Service Controller whenever
//      someone calls ControlService in reference to our service.
//
VOID
service_ctrl(DWORD dwCtrlCode)
{
    DWORD  dwState = SERVICE_RUNNING;

    // Handle the requested control code.
    //
    switch(dwCtrlCode) {

        // Pause the service if it is running.
        //
        case SERVICE_CONTROL_PAUSE:

            if (ssStatus.dwCurrentState == SERVICE_RUNNING) {
                SuspendThread(threadHandle);
                dwState = SERVICE_PAUSED;
            }
            break;

        // Resume the paused service.
        //
        case SERVICE_CONTROL_CONTINUE:

            if (ssStatus.dwCurrentState == SERVICE_PAUSED) {
                ResumeThread(threadHandle);
                dwState = SERVICE_RUNNING;
            }
            break;

        // Stop the service.
        //
        case SERVICE_CONTROL_STOP:

            dwState = SERVICE_STOP_PENDING;

            // Report the status, specifying the checkpoint and waithint,
            //  before setting the termination event.
            //
            ReportStatusToSCMgr(
                    SERVICE_STOP_PENDING, // current state
                    NO_ERROR,             // exit code
                    1,                    // checkpoint
                    3000);                // waithint

            SetEvent(hServDoneEvent);
            return;

        // Update the service status.
        //
        case SERVICE_CONTROL_INTERROGATE:
            break;

        // invalid control code
        //
        default:
            break;

    }

    // send a status response.
    //
    ReportStatusToSCMgr(dwState, NO_ERROR, 0, 0);
}



//  worker_thread() --
//      this function does the actual nuts and bolts work that
//      the service requires.  It will also Pause or Stop when
//      asked by the service_ctrl function.
//




// utility functions...



// ReportStatusToSCMgr() --
//      This function is called by the ServMainFunc() and
//      ServCtrlHandler() functions to update the service's status
//      to the service control manager.
//
BOOL
ReportStatusToSCMgr(DWORD dwCurrentState,
                    DWORD dwWin32ExitCode,
                    DWORD dwCheckPoint,
                    DWORD dwWaitHint)
{
    BOOL fResult;

    // Disable control requests until the service is started.
    //
    if (dwCurrentState == SERVICE_START_PENDING)
        ssStatus.dwControlsAccepted = 0;
    else
        ssStatus.dwControlsAccepted = SERVICE_ACCEPT_STOP |
            SERVICE_ACCEPT_PAUSE_CONTINUE;

    // These SERVICE_STATUS members are set from parameters.
    //
    ssStatus.dwCurrentState = dwCurrentState;
    ssStatus.dwWin32ExitCode = dwWin32ExitCode;
    ssStatus.dwCheckPoint = dwCheckPoint;

    ssStatus.dwWaitHint = dwWaitHint;

    // Report the status of the service to the service control manager.
    //
    if (!(fResult = SetServiceStatus(
                sshStatusHandle,    // service reference handle
                &ssStatus))) {      // SERVICE_STATUS structure

        // If an error occurs, stop the service.
        //
        StopSimpleService("SetServiceStatus");
    }
    return fResult;
}



// The StopSimpleService function can be used by any thread to report an
//  error, or stop the service.
//
VOID
StopSimpleService(LPTSTR lpszMsg)
{
    CHAR    chMsg[256];
    HANDLE  hEventSource;
    LPTSTR  lpszStrings[2];

    dwGlobalErr = GetLastError();

    // Use event logging to log the error.
    //
    hEventSource = RegisterEventSource(NULL,
                            TEXT("SimpleService"));

    sprintf(chMsg, "SimpleService error: %d", dwGlobalErr);
    lpszStrings[0] = chMsg;
    lpszStrings[1] = lpszMsg;

/*    if (hEventSource != NULL) {
        ReportEvent(hEventSource, // handle of event source
            EVENTLOG_ERROR_TYPE,  // event type
            0,                    // event category
            0,                    // event ID
            NULL,                 // current user's SID
            2,                    // strings in lpszStrings
            0,                    // no bytes of raw data
            lpszStrings,          // array of error strings
            NULL);                // no raw data

        (VOID) DeregisterEventSource(hEventSource);
    }
 */
    // Set a termination event to stop SERVICE MAIN FUNCTION.
    //
    SetEvent(hServDoneEvent);
}


#endif

//**********************************************


void WaitForFaxManagerReady(PORTFAX	sFaxPort)
{
	TSPortStatus		sPortStatus;
	int 				iStsCnt = 0;

	do{		GetPortStatus( sFaxPort, &sPortStatus); 
			if(sPortStatus.Status & CST_RECEIVE){
				iStsCnt = 0;
				Sleep(9000);
			}
			Sleep(1000);
			iStsCnt++;
			if(iStsCnt>=130){
			 	return;
			}
	}while( (sPortStatus.Status ) );

	if(iStsCnt>=30){
	 	return;
	}
}

/***********************************************************************/




void WorkerThread( void)
{
	FAXOBJ				foFax;
	union TUFaxImage	sFaxPage;
	TSPortStatus		sPortStatus;
	PORTFAX				sFaxPort;
	TSFaxParam			sFaxParam;
	int 				iError;
	FAXERROR			fErrorObj = 0;
	BOOL 				bSuccess;
	int 				jj;

#ifdef RUNASEXE
	printf("Start device...\n");
#endif

	
#ifdef RUNASEXE
	printf("Setup driver...\n");
#endif

	EnableFaxCPPDriverDebug( "c:\\temp\\debug.txt", FALSE );
	
#ifdef REC
	ReceiveFaxMessage();
	return;
#endif
	
	if( SetupFaxDriver("j:\\faxcpp32\\FAXMNG32.DLL")) {
		SetEvent(hServDoneEvent);
		ExitThread(0);
		return;
	}

#ifdef RUNASEXE
	printf("Connect to port...\n");
#endif

	sFaxPort = ConnectPortExt("COM2", "GCLASS1(SFC)",
						"C:\\temp\\FAXCPP1.INI");
	if(!sFaxPort){
		SetEvent(hServDoneEvent);
		ExitThread(0);
		return;
	}

	int sendcount =0;
	SetAutoAnswer( sFaxPort, -1);	 //never pick up the phone	   
	WaitForFaxManagerReady(sFaxPort);
		
#ifdef RUNASEXE
	printf("Start send procedure...\n");
#endif
	
		//do{												new
			sprintf( sPortStatus.PortName , "COM2");	
		 	sFaxParam.PageNum = 1;
			sFaxParam.Resolut = RES_196LPI;	   //Fine resolution		   
			sFaxParam.Width = PWD_1728;
			sFaxParam.Length = PLN_A4;
			sFaxParam.Compress = DCF_1DMH;
			sFaxParam.Binary = BFT_DISABLE;
			sFaxParam.BitOrder = BTO_FIRST_LSB;

			sprintf( sFaxParam.RemoteNumber, "5");	//103
			sFaxParam.Send = TRUE;

			foFax =  CreateSendFax( 'N', &sFaxParam);
			if(!foFax){
				SetEvent(hServDoneEvent);
				ExitThread(0);
				return;
			}
			
			sFaxPage.File = "c:\\test001.tif";

		sPortStatus.Fax = foFax;
		int pgCnt = 0;
			WaitForFaxManagerReady(sFaxPort);


#ifdef RUNASEXE
	printf("Set faximage page...\n");
#endif
	SetFaxObjDir( "c:\\temp" );
			for(jj = 0; jj < sFaxParam.PageNum; jj++){
				iError = SetFaxImagePage( foFax, jj, IMT_FILE_TIFF_G31D, &sFaxPage, 0);
				if(iError){
	
					SetEvent(hServDoneEvent);
					ExitThread(0);
					return;
				}
#ifdef RUNASEXE
	printf("Faximage page set.\n");
#endif
			}
			
			SetMyID( "Shaam");
		
		//	SetPortCapabilities( sFaxPort, FDC_BAUD_SEND, BDR_9600);
    		WaitForFaxManagerReady(sFaxPort);
			
			HANDLE 	hThread = GetCurrentThread();
		    if(SendFaxNow( sFaxPort, foFax, FALSE)){				
			}
			WaitForFaxManagerReady(sFaxPort);
			bSuccess = SetThreadPriority( hThread,	// handle to the thread 
								THREAD_PRIORITY_ABOVE_NORMAL); 	// thread priority level 
			

			if(hThread != INVALID_HANDLE_VALUE){
				bSuccess = SetThreadPriority( hThread,	// handle to the thread 
   									THREAD_PRIORITY_NORMAL);  // thread priority level
   			} 	 
    
 	Sleep(60000);
	
	
	iError = DisconnectPort( sFaxPort);
		if( iError){
			return;
		}
		sFaxPort = NULL;
		Sleep(5000);
        	
		EndOfFaxDriver( TRUE);
		MessageBeep( 100 );

// every function from here will never been executed

		ExitThread(0);
		return;
}


void ReceiveFaxMessage( void)
{
	union TUFaxImage	sFaxPage;
	int 				iError;
	FAXOBJ 				foFax;
    	BOOL				bAppend;

        PORTFAX                         sFaxPort;
        TSFaxParam                      sFaxParam;
        FAXERROR                        fErrorObj = 0;


	Sleep(5000);

        if( SetupFaxDriver("j:\\faxcpp32\\FAXMNG32.DLL")) {
                return;
        }
	Sleep(5000);

	
        sFaxPort = ConnectPortExt("COM2", "GU.S.R14.4F(HFC)", "C:\\temp\\FAXCPP1.INI");
        Sleep(10000);
		if(!sFaxPort){
                return;
        }
	
        int sendcount =0;
        SetAutoAnswer( sFaxPort, -1);    //never pick up the phone
        //Sleep(10000);

		WaitForFaxManagerReady(sFaxPort);

	foFax = NULL;
    for( foFax= GetObjFromReceiveQueue(); foFax; foFax = GetObjFromReceiveQueue()){
        ClearFaxObj( foFax);
    }

	SetFaxObjDir( "c:\\temp" );
	sFaxPage.File =  "c:\\rec.TIF";

	SetAutoAnswer( sFaxPort, 1);
	Sleep(60000);     //delay to make call from another machine
	 //second check, if eventcheck fails, check portstatus on receiving
	foFax = NULL;
	do{
		Sleep(1000);
//		GetPortStatus( sFaxPort, &sPortStatus);
		foFax = GetObjFromReceiveQueue();
	}while( !foFax );
//	}while(sPortStatus.Status & 0x1111);

	SetAutoAnswer( sFaxPort, -1);	   //don't pick up the phone anymore
//	foFax = GetObjFromReceiveQueue();
	if( foFax == NULL){	
		return;
	}


//-------------------------------------------------------------
			
	if( foFax != NULL){
        // process received fax
		iError = GetFaxParam( foFax, &sFaxParam);
		if(iError != 0){
			return;
		}

		if (sFaxParam.PageNum <= 0 ){										
			return;
    	}

		bAppend = TRUE;
        	    
		for(int i = 0; i < sFaxParam.PageNum; i++){
			iError = GetFaxImagePage( foFax, i, IMT_FILE_TIFF_G31D, 
											&sFaxPage, bAppend);
			if(iError != 0){
				return;
			}            
			bAppend = TRUE;
        }        
	}

// clear all objects after processed it
    for( foFax= GetObjFromReceiveQueue(); foFax; foFax = GetObjFromReceiveQueue())
    {
        ClearFaxObj( foFax);
    }    
    sFaxParam.DeleteFiles = TRUE;
    return;			
}
