// RetrySample.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "RetrySample.h"
#include "RetrySampleDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CRetrySampleApp

BEGIN_MESSAGE_MAP(CRetrySampleApp, CWinApp)
	//{{AFX_MSG_MAP(CRetrySampleApp)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG
	ON_COMMAND(ID_HELP, CWinApp::OnHelp)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CRetrySampleApp construction

CRetrySampleApp::CRetrySampleApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CRetrySampleApp object

CRetrySampleApp theApp;

/////////////////////////////////////////////////////////////////////////////
// CRetrySampleApp initialization

BOOL CRetrySampleApp::InitInstance()
{
	AfxEnableControlContainer();

	// Standard initialization
	// If you are not using these features and wish to reduce the size
	//  of your final executable, you should remove from the following
	//  the specific initialization routines you do not need.

#ifdef _AFXDLL
	Enable3dControls();			// Call this when using MFC in a shared DLL
#else
	Enable3dControlsStatic();	// Call this when linking to MFC statically
#endif

	CRetrySampleDlg dlg;
	m_pMainWnd = &dlg;
	for(int jj=0; jj<MAX_COMPORTS; jj++) {
        FaxPorts[jj] = NULL;
    }
	fileName="Test.tif";
	retrylist=NULL;
	timerCount=0;
	nMessage=RegisterWindowMessage(REG_FAXMESSAGE);
	hMutex=CreateMutex(NULL,FALSE,NULL);
	int nResponse = dlg.DoModal();
	if (nResponse == IDOK)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with OK
	}
	else if (nResponse == IDCANCEL)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with Cancel
	}

	// Since the dialog has been closed, return FALSE so that we exit the
	//  application, rather than start the application's message pump.
	return FALSE;
}

bool CRetrySampleApp::AddToList(PORTFAX portfax_,FAXOBJ faxobj_)
{
/*Adds the fax object to the list. If portfax_ is NULL, the sample will try to resend it
  in case of remote numote number is busy by puting it back in the queue. 
  If portfax_ is specified the sample will try to resend the fax in that port.
*/

	WaitForSingleObject(hMutex,INFINITE);

	LPRETRYLIST temp = new RETRYLIST;

	if (temp)
	{
		temp->faxobj=faxobj_;
		temp->portfax=portfax_;
		temp->timerID=-1;
		temp->numberOfRetries=3;
		temp->pNext = retrylist;
		temp->currentlySending=false;
		retrylist=temp;
		ReleaseMutex(hMutex);
		return true;
	}
	ReleaseMutex(hMutex);
	return false;
}

bool CRetrySampleApp::SetTimerID(FAXOBJ faxobj_, UINT timerID_)
{
/* Sets the timer ID for the specified fax object if it is in the list.*/

	WaitForSingleObject(hMutex,INFINITE);
	
	if (!faxobj_)
	{
		ReleaseMutex(hMutex);
		return false;
	}
	if (!retrylist)
	{
		ReleaseMutex(hMutex);
		return false;
	}
	LPRETRYLIST temp=retrylist;
	while (temp)
	{
		if (temp->faxobj==faxobj_)
		{
			temp->timerID=timerID_;
			ReleaseMutex(hMutex);
			return true;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return false;
}

bool CRetrySampleApp::DeleteFromList(FAXOBJ faxobj_)
{
/* Deletes the list member containing faxobj_.*/

	WaitForSingleObject(hMutex,INFINITE);
	LPRETRYLIST temp=retrylist;
	LPRETRYLIST itemBeforeActual=NULL;
	if (!faxobj_ || !retrylist)
	{
		ReleaseMutex(hMutex);
		return false;
	}
	if (temp==NULL)
	{
		ReleaseMutex(hMutex);	
		return false;
	}
	while (temp->faxobj!=faxobj_ && temp!=NULL)
	{
		itemBeforeActual=temp;
		temp=temp->pNext;
	}
	if (temp==NULL)
	{
		ReleaseMutex(hMutex);
		return false;
	}
	if (itemBeforeActual==NULL)
	{
		retrylist=temp->pNext;
		delete temp;
		ReleaseMutex(hMutex);
		return true;
	}
	itemBeforeActual->pNext=temp->pNext;
	delete temp;
	ReleaseMutex(hMutex);
	return true;
}

int CRetrySampleApp::GetTimerID(FAXOBJ faxobj_)
{
/*Gets the timerID of the specified fax object.*/

	WaitForSingleObject(hMutex,INFINITE);
	if (!retrylist || !faxobj_)
	{
		ReleaseMutex(hMutex);
		return -1;
	}

	LPRETRYLIST temp = retrylist;
	while (temp)
	{
		if (temp->faxobj==faxobj_)
		{
			ReleaseMutex(hMutex);
			return temp->timerID;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return -1;
}

int CRetrySampleApp::GetRetryNumber(FAXOBJ faxobj_)
{
/*Gets the timerID of the specified fax object.*/

	WaitForSingleObject(hMutex,INFINITE);
	if (!retrylist || !faxobj_)
	{
		ReleaseMutex(hMutex);
		return -1;
	}

	LPRETRYLIST temp = retrylist;
	while (temp)
	{
		if (temp->faxobj==faxobj_)
		{
			ReleaseMutex(hMutex);
			return temp->numberOfRetries;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return -1;
}

bool CRetrySampleApp::IsFaxobjInList(FAXOBJ faxobj_)
{
/*Checks if fax object is in the list.*/

	WaitForSingleObject(hMutex,INFINITE);
	if (!retrylist || !faxobj_)
	{
		ReleaseMutex(hMutex);
		return false;
	}


	LPRETRYLIST temp = retrylist;

	while (temp)
	{
		if (temp->faxobj==faxobj_)
		{
			ReleaseMutex(hMutex);
			return true;
		}
		
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return false;

}

bool CRetrySampleApp::IsPortFaxInList(PORTFAX portfax_)
{
/*Checks if fax object is in the list.*/

	WaitForSingleObject(hMutex,INFINITE);
	if (!retrylist || !portfax_)
	{
		ReleaseMutex(hMutex);
		return false;
	}


	LPRETRYLIST temp = retrylist;

	while (temp)
	{
		if (temp->portfax==portfax_)
		{
			ReleaseMutex(hMutex);
			return true;
		}
		
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return false;

}

bool CRetrySampleApp::SetCurrentlySending(FAXOBJ faxobj_, bool cs_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!retrylist || !faxobj_)
	{
		ReleaseMutex(hMutex);
		return false;
	}

	LPRETRYLIST temp=retrylist;
	while (temp)
	{
		if (temp->faxobj==faxobj_)
		{
			temp->currentlySending=cs_;
			ReleaseMutex(hMutex);
			return true;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return false;
}
