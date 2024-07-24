// MainFrm.cpp : implementation of the CMainFrame class
//

#include "stdafx.h"
#include "OCXDEMO.h"
#include "FaxConfig.h"

#include "MainFrm.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMainFrame

IMPLEMENT_DYNCREATE(CMainFrame, CFrameWnd)

BEGIN_MESSAGE_MAP(CMainFrame, CFrameWnd)
	//{{AFX_MSG_MAP(CMainFrame)
	ON_COMMAND(ID_HELP_FAXCOCXHELP, OnHelpFaxcocxhelp)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMainFrame construction/destruction

CMainFrame::CMainFrame()
{	
}

CMainFrame::~CMainFrame()
{
}

/////////////////////////////////////////////////////////////////////////////
// CMainFrame diagnostics

#ifdef _DEBUG
void CMainFrame::AssertValid() const
{
	CFrameWnd::AssertValid();
}

void CMainFrame::Dump(CDumpContext& dc) const
{
	CFrameWnd::Dump(dc);
}

#endif //_DEBUG


void CMainFrame::OnHelpFaxcocxhelp() 
{
	HMODULE hModule;
	hModule = GetModuleHandle("Fax.ocx");
	char		szFilename [MAX_PATH];
	char*		pStr;
	GetModuleFileName( hModule,   szFilename, MAX_PATH );
	pStr = strrchr(szFilename, 'Bin');
	pStr-=3;
	if (pStr)
	{
		strcpy(pStr, "\\Help\\Black_Ice_Fax_C++_OCX_Help.chm");
	}
	HINSTANCE hRet = ShellExecute( NULL, "open", szFilename,
		NULL, NULL, SW_SHOWNORMAL );	
	switch ((long)hRet)
	{
		case 0 : 
			AfxMessageBox("The operating system is out of memory or resources.");
			break;
		case ERROR_FILE_NOT_FOUND :
			AfxMessageBox("The specified file was not found.");
			break;
		case ERROR_PATH_NOT_FOUND :
			AfxMessageBox("The specified path was not found.");
			break;
		case ERROR_BAD_FORMAT :
			AfxMessageBox("The .exe file is invalid (non-Win32® .exe or error in .exe image).");
			break;
		case SE_ERR_ACCESSDENIED :
			AfxMessageBox("The operating system denied access to the specified file.");
			break;
		case SE_ERR_ASSOCINCOMPLETE :
			AfxMessageBox("The file name association is incomplete or invalid.");
			break;
		case SE_ERR_DDEBUSY :
			AfxMessageBox("The DDE transaction could not be completed because other DDE transactions were being processed.");
			break;
		case SE_ERR_DDEFAIL :
			AfxMessageBox("The DDE transaction failed.");
			break;
		case SE_ERR_DDETIMEOUT :
			AfxMessageBox("The DDE transaction could not be completed because the request timed out.");
			break;
		case SE_ERR_DLLNOTFOUND :
			AfxMessageBox("The specified dynamic-link library was not found.");
			break;
		case SE_ERR_NOASSOC :
			AfxMessageBox("There is no application associated with the given file name extension. This error will also be returned if you attempt to print a file that is not printable.");
			break;
		case SE_ERR_OOM :
			AfxMessageBox("There was not enough memory to complete the operation.");
			break;
		case SE_ERR_SHARE :
			AfxMessageBox("A sharing violation occurred.");
			break;
		case -1 : 
			AfxMessageBox("Invalid window state parameter.");
			break;
	}	
}



BOOL CMainFrame::PreCreateWindow(CREATESTRUCT& cs) 
{
	// TODO: Add your specialized code here and/or call the base class
	cs.cy = ::GetSystemMetrics(SM_CYSCREEN) / 3;
	cs.cx = ::GetSystemMetrics(SM_CXSCREEN) / 3;
	cs.y = ((cs.cy * 3) - cs.cy) / 2;
	cs.x = ((cs.cx * 3) - cs.cx) / 2;
	return CFrameWnd::PreCreateWindow(cs);
}
