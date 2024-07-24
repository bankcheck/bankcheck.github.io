// FaxWithBrooktrout.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "FaxWithBrooktrout.h"
#include "FaxWithBrooktroutDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CFaxWithBrooktroutApp

BEGIN_MESSAGE_MAP(CFaxWithBrooktroutApp, CWinApp)
	//{{AFX_MSG_MAP(CFaxWithBrooktroutApp)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG
	ON_COMMAND(ID_HELP, CWinApp::OnHelp)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFaxWithBrooktroutApp construction

CFaxWithBrooktroutApp::CFaxWithBrooktroutApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CFaxWithBrooktroutApp object

CFaxWithBrooktroutApp theApp;

/////////////////////////////////////////////////////////////////////////////
// CFaxWithBrooktroutApp initialization

BOOL CFaxWithBrooktroutApp::InitInstance()
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

	CFaxWithBrooktroutDlg dlg;
	m_pMainWnd = &dlg;
	for(int jj=0; jj<MAX_FAXCHANNELS; jj++) {
        FaxPorts[jj] = NULL;
    }
	list=NULL;
	Aborted=false;
	nMessage=RegisterWindowMessage(REG_FAXMESSAGE);
	hMutex=CreateMutex(NULL,FALSE,NULL);
	timerCount=0;
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

void CFaxWithBrooktroutApp::AddToList(PORTFAX portfax_,CString channelName_, FAXOBJ faxobj_, short SR_, bool currentlySending_)
{
	WaitForSingleObject(hMutex,INFINITE);
	LPLIST temp = new LIST;
	
	if (temp)
	{
		temp->faxobj=faxobj_;
		temp->portfax=portfax_;
		temp->pNext = list;
		temp->SR=SR_;
		temp->channelName=channelName_;
		temp->currentlySending=currentlySending_;
		temp->timerID = ++timerCount;
		temp->receivedERROR=0;
		temp->receivedOK=0;
		temp->sentERROR=0;
		temp->sentOK=0;
		list=temp;
	}
	ReleaseMutex(hMutex);
}

void CFaxWithBrooktroutApp::DeleteList()
{
	WaitForSingleObject(hMutex,INFINITE);	
	if (list) {
		LPLIST temp;
		while (list->pNext) {
			temp=list;
			list=list->pNext;		
			delete temp;
		}
		delete list;
		list=NULL;
	}
	ReleaseMutex(hMutex);
}

void CFaxWithBrooktroutApp::ChangeSR(PORTFAX portfax_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->portfax==portfax_)
		{
			temp->SR=1-temp->SR;
			ReleaseMutex(hMutex);
			return;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
}

short CFaxWithBrooktroutApp::GetSR(PORTFAX portfax_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return -1;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->portfax==portfax_)
		{
			ReleaseMutex(hMutex);
			return temp->SR;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return -1;
}

FAXOBJ CFaxWithBrooktroutApp::GetFaxObj(PORTFAX portfax_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return NULL;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->portfax==portfax_)
		{
			ReleaseMutex(hMutex);
			return temp->faxobj;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return NULL;
}

FAXOBJ CFaxWithBrooktroutApp::GetFaxObj(UINT timerID)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return NULL;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->timerID==timerID)
		{
			ReleaseMutex(hMutex);
			return temp->faxobj;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return NULL;
}

CString CFaxWithBrooktroutApp::GetChannelName(PORTFAX portfax_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return "";
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->portfax==portfax_)
		{
			ReleaseMutex(hMutex);
			return temp->channelName;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return "";
}


CString CFaxWithBrooktroutApp::GetChannelName(FAXOBJ faxobj_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return "";
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->faxobj==faxobj_)
		{
			ReleaseMutex(hMutex);
			return temp->channelName;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return "";
}

void CFaxWithBrooktroutApp::FaxEventText(LPSTR buf)
{
    if(m_pMainWnd)
        ((CFaxWithBrooktroutDlg*)m_pMainWnd)->SetEventText(buf);
}

UINT CFaxWithBrooktroutApp::GetTimerID(PORTFAX portfax_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return -1;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->portfax==portfax_)
		{
			ReleaseMutex(hMutex);
			return temp->timerID;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return -1;
}

void CFaxWithBrooktroutApp::SetTimerID(PORTFAX portfax_,UINT timerID_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->portfax==portfax_)
		{
			temp->timerID=timerID_;
			ReleaseMutex(hMutex);
			return;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
}

UINT CFaxWithBrooktroutApp::GetTimerCount()
{
	timerCount++;
	if (timerCount>100)
	{
		char buf[100];
		sprintf(buf,"Timer count reset to 1");
		FaxEventText(buf);
		timerCount=1;
	}

	return timerCount-1;
}

PORTFAX CFaxWithBrooktroutApp::GetPortFax(UINT timerID_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return NULL;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->timerID==timerID_)
		{
			ReleaseMutex(hMutex);
			return temp->portfax;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return NULL;
}

PORTFAX CFaxWithBrooktroutApp::GetPortFax(FAXOBJ faxobj_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return NULL;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->faxobj==faxobj_)
		{
			ReleaseMutex(hMutex);
			return temp->portfax;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return NULL;
}


bool CFaxWithBrooktroutApp::GetCurrentlySending(PORTFAX portfax_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return false;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->portfax==portfax_)
		{
			ReleaseMutex(hMutex);
			return temp->currentlySending;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return false;
}

void CFaxWithBrooktroutApp::SetCurrentlySending(PORTFAX portfax_, bool currentlySending_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->portfax==portfax_)
		{
			temp->currentlySending=currentlySending_;
			ReleaseMutex(hMutex);
			return;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
}

void CFaxWithBrooktroutApp::IncrementSentOK(PORTFAX portfax_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->portfax==portfax_)
		{
			++temp->sentOK;
			ReleaseMutex(hMutex);
			return;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
}

void CFaxWithBrooktroutApp::IncrementReceivedOK(PORTFAX portfax_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->portfax==portfax_)
		{
			++temp->receivedOK;
			ReleaseMutex(hMutex);
			return;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
}

void CFaxWithBrooktroutApp::IncrementSentERROR(PORTFAX portfax_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->portfax==portfax_)
		{
			++temp->sentERROR;
			ReleaseMutex(hMutex);
			return;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
}

void CFaxWithBrooktroutApp::IncrementReceivedERROR(PORTFAX portfax_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->portfax==portfax_)
		{
			++temp->receivedERROR;
			ReleaseMutex(hMutex);
			return;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
}

long  CFaxWithBrooktroutApp::GetSentOK(PORTFAX portfax_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return -1;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->portfax==portfax_)
		{
			ReleaseMutex(hMutex);
			return temp->sentOK;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return -1;
}

long  CFaxWithBrooktroutApp::GetReceivedOK(PORTFAX portfax_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return -1;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->portfax==portfax_)
		{
			ReleaseMutex(hMutex);
			return temp->receivedOK;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return -1;
}

long  CFaxWithBrooktroutApp::GetReceivedERROR(PORTFAX portfax_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return -1;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->portfax==portfax_)
		{
			ReleaseMutex(hMutex);
			return temp->receivedERROR;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return -1;
}

long  CFaxWithBrooktroutApp::GetSentERROR(PORTFAX portfax_)
{
	WaitForSingleObject(hMutex,INFINITE);
	if (!list)
	{
		ReleaseMutex(hMutex);
		return -1;
	}
	LPLIST temp=list;
	while (temp)
	{
		if (temp->portfax==portfax_)
		{
			ReleaseMutex(hMutex);
			return temp->sentERROR;
		}
		temp = temp->pNext;
	}
	ReleaseMutex(hMutex);
	return -1;
}