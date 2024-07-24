// HelpDialog.cpp : implementation file
//

#include "stdafx.h"
#include "ReceiveDTMFandDecideToReceiveFaxOrVoice.h"
#include "HelpDialog.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CHelpDialog dialog


CHelpDialog::CHelpDialog(CWnd* pParent /*=NULL*/)
	: CDialog(CHelpDialog::IDD, pParent)
{
	//{{AFX_DATA_INIT(CHelpDialog)
	//}}AFX_DATA_INIT
}


void CHelpDialog::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CHelpDialog)
	DDX_Control(pDX, IDC_LIST1, m_list1);
	//}}AFX_DATA_MAP
}

BOOL CHelpDialog::OnInitDialog()
{
	CDialog::OnInitDialog();

	m_list1.AddString("The sample shows how you can receive DTMF digits, receive faxes and record voices.");
	m_list1.AddString("");
	m_list1.AddString("You can open a COM port or a channel of three different card type with the \"Open\" buttons");
	m_list1.AddString("");
	m_list1.AddString("After open a port or a channel the sample answers automatically to a remote dialing and then you can choose one of the following:");
	m_list1.AddString("  Click on \"Receive Fax\" button to switch to fax mode, and then create a fax port and wait for a fax receiving on this port.");
	m_list1.AddString("  After a fax sent to this port this feature can automatically receive the fax object and then save it automatically to the");
	m_list1.AddString("  directory appears in a Message Box after end receiving. At the end of the receiving mode turns back to voice mode.");
	m_list1.AddString("");
	m_list1.AddString("  Click on \"Wait for DTMF\" button to set how many DTMF digits you like to get and the delimiter digit.");
	m_list1.AddString("  After this settings the sample waits for DTMF digits until those arrive.");
	m_list1.AddString("  When receive, digits behind the delimiter will be left.");
	m_list1.AddString("");
	m_list1.AddString("  Click on \"Record message\" button to record a voice message.");
	m_list1.AddString("  After the click it waits for some time for a voice format message. In both case (voice received or not received)");
	m_list1.AddString("  it creates a .wav file. If no voice format message received this file will contain nothing worthy, only some noise.");
	m_list1.AddString("  In the other case it will contain the voice sent to this port.");
	m_list1.AddString("");
	m_list1.AddString("  Click on the \"Close port/channel\" to automatically close the opened port or channel");

	return TRUE;
}

BEGIN_MESSAGE_MAP(CHelpDialog, CDialog)
	//{{AFX_MSG_MAP(CHelpDialog)
		// NOTE: the ClassWizard will add message map macros here
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CHelpDialog message handlers
