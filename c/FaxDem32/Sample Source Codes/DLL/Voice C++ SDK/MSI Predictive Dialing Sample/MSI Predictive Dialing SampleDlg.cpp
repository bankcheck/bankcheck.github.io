// MSI Predictive Dialing SampleDlg.cpp : implementation file
//

#include "stdafx.h"
#include "MSI Predictive Dialing Sample.h"
#include "MSI Predictive Dialing SampleDlg.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

	MODEMOBJ MSIModemIDs[4], LineModemIDs[4];
	long MSIHandles[4], LineHandles[4], VoiceHandles[4];
	int MSIConnectedTo[4], LineConnectedTo[4];
	int MSIState[4], LineState[4];
	int MSIindex;

	const int stateOnHook = 1;
	const int stateOffHook = 2;
	const int stateDialing = 3;
	const int stateHangingUP = 4;
	const int stateConnected = 5;

	bool Started;
	bool Exiting;
	bool KeepDialing;

UINT VoiceMsg = RegisterWindowMessage(REG_FAXMESSAGE);
/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
	// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMSIPredictiveDialingSampleDlg dialog

CMSIPredictiveDialingSampleDlg::CMSIPredictiveDialingSampleDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CMSIPredictiveDialingSampleDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CMSIPredictiveDialingSampleDlg)
	m_Phone = _T("");
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CMSIPredictiveDialingSampleDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CMSIPredictiveDialingSampleDlg)
	DDX_Text(pDX, IDC_EDIT_PHONE, m_Phone);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CMSIPredictiveDialingSampleDlg, CDialog)
	//{{AFX_MSG_MAP(CMSIPredictiveDialingSampleDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON_EXIT, OnButtonExit)
	ON_BN_CLICKED(IDC_BUTTON_INPHONE, OnButtonInphone)
	ON_BN_CLICKED(IDC_BUTTON_OUTPHONE, OnButtonOutphone)
	ON_BN_CLICKED(IDC_BUTTON_START, OnButtonStart)
	ON_WM_DESTROY()
	ON_REGISTERED_MESSAGE(VoiceMsg,OnVoiceMsg)
	ON_WM_CREATE()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMSIPredictiveDialingSampleDlg message handlers

BOOL CMSIPredictiveDialingSampleDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here
	SetChanelsInComboBoxs();

    ((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("Predictive Dialing MSI Sample");
	((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("This sample will show how an agent can dial several preset numbers from a list by picking up the handset.");
	((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("If the dialed number is busy, the next number from the list will be automatically dialed.");
	((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("Note:");
    ((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("The sample is using up to four MSI stations. In the resource names, such as msiB1C1, dxxxB1C1,");
	((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("the B1C1 defines Board1 Channel1.");
	((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("To use the sample with a different Board or Channel number, modify the names of the resources in the edit boxes.");
	((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("If you do not want to use all the listed resources, clear the resource's edit box.");
	((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("To use the sample:");
	((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("1. Enter the phone numbers you want to dial and press ENTER to add the numbers to the list");
	((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("2. Add two or more numbers to the list");
	((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("3. Press the Start button to initialize the board.");
	((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("4. Pickup a handset to begin a call.");

    for (int i = 0; i < 4; i++)
	{
        LineState[i] = stateOnHook;
        MSIState[i] = stateOnHook;
    }

	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CMSIPredictiveDialingSampleDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CMSIPredictiveDialingSampleDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CMSIPredictiveDialingSampleDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CMSIPredictiveDialingSampleDlg::OnButtonExit() 
{
	OnOK();	
}

void CMSIPredictiveDialingSampleDlg::SetChanelsInComboBoxs()
{
	int buffersize=0;
	char * szBuffer=0;

	if(mdm_SCBUS_EnumerateResources(NULL, &buffersize, SCBUS_RESOURCE_TYPE_MSI)==SCBUS_SUCCESS)
	{
		szBuffer = new char[buffersize];
		szBuffer[0]=0;
		mdm_SCBUS_EnumerateResources(szBuffer, &buffersize, SCBUS_RESOURCE_TYPE_MSI);
 
		while (szBuffer[0] != '\0')
		{
			((CComboBox*)GetDlgItem(IDC_COMBO_MSI1))->AddString(szBuffer);
			((CComboBox*)GetDlgItem(IDC_COMBO_MSI2))->AddString(szBuffer);
			((CComboBox*)GetDlgItem(IDC_COMBO_MSI3))->AddString(szBuffer);
			((CComboBox*)GetDlgItem(IDC_COMBO_MSI4))->AddString(szBuffer);

			szBuffer=szBuffer + strlen(szBuffer)+1;

		}
	}
    else 
	{
        AfxMessageBox("No MSI Sation has been detected. In order to run this sample, you need to have at least one MSI Dialogic resource.");        
        OnCancel();
        return;
    }

	if(mdm_SCBUS_EnumerateResources(NULL, &buffersize, SCBUS_RESOURCE_TYPE_LINEINTERFACE)==SCBUS_SUCCESS)
	{
		szBuffer = new char[buffersize];
		szBuffer[0]=0;
		mdm_SCBUS_EnumerateResources(szBuffer, &buffersize, SCBUS_RESOURCE_TYPE_LINEINTERFACE);
 
		while (szBuffer[0] != '\0')
		{
			((CComboBox*)GetDlgItem(IDC_COMBO_LINE1))->AddString(szBuffer);
			((CComboBox*)GetDlgItem(IDC_COMBO_LINE2))->AddString(szBuffer);
			((CComboBox*)GetDlgItem(IDC_COMBO_LINE3))->AddString(szBuffer);
			((CComboBox*)GetDlgItem(IDC_COMBO_LINE4))->AddString(szBuffer);

			szBuffer=szBuffer + strlen(szBuffer)+1;

		}
	}
	else 
	{
		AfxMessageBox("No Line Interface has been detected. In order to run this sample, you need to have at least one Dialogic Voice resource.");        
		OnCancel();
		return;
	}
 
	if(mdm_SCBUS_EnumerateResources(NULL, &buffersize, SCBUS_RESOURCE_TYPE_VOICE)==SCBUS_SUCCESS)
	{
		szBuffer = new char[buffersize];
		szBuffer[0]=0;
		mdm_SCBUS_EnumerateResources(szBuffer, &buffersize, SCBUS_RESOURCE_TYPE_VOICE);
 
		while (szBuffer[0] != '\0')
		{
			((CComboBox*)GetDlgItem(IDC_COMBO_VOICE1))->AddString(szBuffer);
			((CComboBox*)GetDlgItem(IDC_COMBO_VOICE2))->AddString(szBuffer);
			((CComboBox*)GetDlgItem(IDC_COMBO_VOICE3))->AddString(szBuffer);
			((CComboBox*)GetDlgItem(IDC_COMBO_VOICE4))->AddString(szBuffer);

			szBuffer=szBuffer + strlen(szBuffer)+1;

		}
	}
	else 
	{
		AfxMessageBox("No Voice Resource has been detected. In order to run this sample, you need to have at least one Dialogic Voice resource.");        
		OnCancel();
		return;
	}
			((CComboBox*)GetDlgItem(IDC_COMBO_MSI1))->AddString("");
			((CComboBox*)GetDlgItem(IDC_COMBO_MSI2))->AddString("");
			((CComboBox*)GetDlgItem(IDC_COMBO_MSI3))->AddString("");
			((CComboBox*)GetDlgItem(IDC_COMBO_MSI4))->AddString("");
			((CComboBox*)GetDlgItem(IDC_COMBO_LINE1))->AddString("");
			((CComboBox*)GetDlgItem(IDC_COMBO_LINE2))->AddString("");
			((CComboBox*)GetDlgItem(IDC_COMBO_LINE3))->AddString("");
			((CComboBox*)GetDlgItem(IDC_COMBO_LINE4))->AddString("");
			((CComboBox*)GetDlgItem(IDC_COMBO_VOICE1))->AddString("");
			((CComboBox*)GetDlgItem(IDC_COMBO_VOICE2))->AddString("");
			((CComboBox*)GetDlgItem(IDC_COMBO_VOICE3))->AddString("");
			((CComboBox*)GetDlgItem(IDC_COMBO_VOICE4))->AddString("");
}

void CMSIPredictiveDialingSampleDlg::OnButtonInphone() 
{
	UpdateData(TRUE);
	if (m_Phone != "")
		((CListBox*)GetDlgItem(IDC_LIST_PHONE))->AddString(m_Phone);
	m_Phone = _T("");
	UpdateData(FALSE);
}

void CMSIPredictiveDialingSampleDlg::OnButtonOutphone() 
{
	int i;
	if ((i = ((CListBox*)GetDlgItem(IDC_LIST_PHONE))->GetCount()) != 0)
		if ((i = ((CListBox*)GetDlgItem(IDC_LIST_PHONE))->GetAnchorIndex()) != -1)
		{
			((CListBox*)GetDlgItem(IDC_LIST_PHONE))->GetText(((CListBox*)GetDlgItem(IDC_LIST_PHONE))->GetAnchorIndex(), m_Phone);
			if (m_Phone != "")
				((CListBox*)GetDlgItem(IDC_LIST_PHONE))->DeleteString(((CListBox*)GetDlgItem(IDC_LIST_PHONE))->GetAnchorIndex());
		}
	UpdateData(FALSE);	
}

void CMSIPredictiveDialingSampleDlg::OnButtonStart() 
{
	Exiting = FALSE;
	for (int i = 0; i < 4; i++)
	{
		if (GetComboMSITextLength(i) > 0)
		{
			if (mdm_SCBUS_GetResourceStatus(GetComboMSIText(i), SCBUS_RESOURCE_TYPE_MSI) == SCBUS_RESOURCE_AVAILABLE)
			{
                if (mdm_SCBUS_OpenResource(GetComboMSIText(i), &MSIHandles[i], SCBUS_RESOURCE_TYPE_MSI, 0,0) != SCBUS_RESOURCE_AVAILABLE)
                {
                    ((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("Resource " + GetComboMSIText(i) + " is open");
                    if ((MSIModemIDs[i] = mdm_CreateModemObject(2)) != NULL)
					{
                        mdm_SCBUS_AttachResourceToMODEMOBJ(MSIModemIDs[i], MSIHandles[i]);
                        
						MSIConnectedTo[i] = -1;
                    }
                }
			}
            else
                ((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("Resource " + GetComboMSIText(i) + " is not available");
		}
		if (GetComboLineTextLength(i) > 0)
		{
			if (mdm_SCBUS_GetResourceStatus(GetComboLineText(i), SCBUS_RESOURCE_TYPE_LINEINTERFACE) == SCBUS_RESOURCE_AVAILABLE)
			{
                if (mdm_SCBUS_OpenResource(GetComboLineText(i), &LineHandles[i], SCBUS_RESOURCE_TYPE_LINEINTERFACE, 0, 0) != SCBUS_RESOURCE_AVAILABLE)
				{
                    ((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("Resource " + GetComboLineText(i) + " is open");
                    if ((LineModemIDs[i] = mdm_CreateModemObject(2)) != NULL)
					{
                        mdm_SCBUS_AttachResourceToMODEMOBJ(LineModemIDs[i], LineHandles[i]);
                        
						LineConnectedTo[i] = -1;
                    }
                }
			}
            else
                ((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("Resource " + GetComboLineText(i) + " is not available");
		}
		if (GetComboVoiceTextLength(i) > 0)
		{
			if (mdm_SCBUS_GetResourceStatus(GetComboVoiceText(i), SCBUS_RESOURCE_TYPE_VOICE) == SCBUS_RESOURCE_AVAILABLE)
			{
                if (mdm_SCBUS_OpenResource(GetComboVoiceText(i), &VoiceHandles[i], SCBUS_RESOURCE_TYPE_VOICE, 0, 0) != SCBUS_RESOURCE_AVAILABLE)
                {
                    ((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("Resource " + GetComboVoiceText(i) + " is open");
                    if ((LineModemIDs[i] = mdm_CreateModemObject(2)) != NULL)
					{
                        mdm_SCBUS_ListenTo(VoiceHandles[i], LineHandles[i], 0);
                        mdm_SCBUS_AttachResourceToMODEMOBJ(LineModemIDs[i], VoiceHandles[i]);
                    }
                }
			}
            else
                ((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("Resource " + GetComboVoiceText(i) + " is not available");
		}
	}
	Started = TRUE;
	KeepDialing = TRUE;
	DialNumber(LineModemIDs[0]);

	if (KeepDialing)
		DialNumber(LineModemIDs[1]);
	if (KeepDialing)
		DialNumber(LineModemIDs[2]);
	if (KeepDialing)
		DialNumber(LineModemIDs[3]);
}



int CMSIPredictiveDialingSampleDlg::GetComboMSITextLength(int i)
{
	int x;
	if (i == 0)
	{
		x = ((CComboBox*)GetDlgItem(IDC_COMBO_MSI1))->GetLBTextLen(((CComboBox*)GetDlgItem(IDC_COMBO_MSI1))->GetCurSel());
		return x;
	}
	else if (i == 1)
		return ((CComboBox*)GetDlgItem(IDC_COMBO_MSI2))->GetLBTextLen(((CComboBox*)GetDlgItem(IDC_COMBO_MSI2))->GetCurSel());
	else if (i == 2)
		return ((CComboBox*)GetDlgItem(IDC_COMBO_MSI3))->GetLBTextLen(((CComboBox*)GetDlgItem(IDC_COMBO_MSI3))->GetCurSel());
	else
		return ((CComboBox*)GetDlgItem(IDC_COMBO_MSI4))->GetLBTextLen(((CComboBox*)GetDlgItem(IDC_COMBO_MSI4))->GetCurSel());
}

CString CMSIPredictiveDialingSampleDlg::GetComboMSIText(int i)
{
	CString s;
	if (i == 0)
	{
		((CComboBox*)GetDlgItem(IDC_COMBO_MSI1))->GetLBText(((CComboBox*)GetDlgItem(IDC_COMBO_MSI1))->GetCurSel(), s);
		return s;
	}
	else if (i == 1)
	{
		((CComboBox*)GetDlgItem(IDC_COMBO_MSI2))->GetLBText(((CComboBox*)GetDlgItem(IDC_COMBO_MSI2))->GetCurSel(), s);
		return s;
	}
	else if (i == 2)
	{
		((CComboBox*)GetDlgItem(IDC_COMBO_MSI3))->GetLBText(((CComboBox*)GetDlgItem(IDC_COMBO_MSI3))->GetCurSel(), s);
		return s;
	}
	else
	{
		((CComboBox*)GetDlgItem(IDC_COMBO_MSI4))->GetLBText(((CComboBox*)GetDlgItem(IDC_COMBO_MSI4))->GetCurSel(), s);
		return s;
	}
}

int CMSIPredictiveDialingSampleDlg::GetComboLineTextLength(int i)
{
	if (i == 0)
		return ((CComboBox*)GetDlgItem(IDC_COMBO_LINE1))->GetLBTextLen(((CComboBox*)GetDlgItem(IDC_COMBO_LINE1))->GetCurSel());
	else if (i == 1)
		return ((CComboBox*)GetDlgItem(IDC_COMBO_LINE2))->GetLBTextLen(((CComboBox*)GetDlgItem(IDC_COMBO_LINE2))->GetCurSel());
	else if (i == 2)
		return ((CComboBox*)GetDlgItem(IDC_COMBO_LINE3))->GetLBTextLen(((CComboBox*)GetDlgItem(IDC_COMBO_LINE3))->GetCurSel());
	else
		return ((CComboBox*)GetDlgItem(IDC_COMBO_LINE4))->GetLBTextLen(((CComboBox*)GetDlgItem(IDC_COMBO_LINE4))->GetCurSel());

}

int CMSIPredictiveDialingSampleDlg::GetComboVoiceTextLength(int i)
{
	if (i == 0)
		return ((CComboBox*)GetDlgItem(IDC_COMBO_VOICE1))->GetLBTextLen(((CComboBox*)GetDlgItem(IDC_COMBO_VOICE1))->GetCurSel());
	else if (i == 1)
		return ((CComboBox*)GetDlgItem(IDC_COMBO_VOICE2))->GetLBTextLen(((CComboBox*)GetDlgItem(IDC_COMBO_VOICE2))->GetCurSel());
	else if (i == 2)
		return ((CComboBox*)GetDlgItem(IDC_COMBO_VOICE3))->GetLBTextLen(((CComboBox*)GetDlgItem(IDC_COMBO_VOICE3))->GetCurSel());
	else
		return ((CComboBox*)GetDlgItem(IDC_COMBO_VOICE4))->GetLBTextLen(((CComboBox*)GetDlgItem(IDC_COMBO_VOICE4))->GetCurSel());

}

CString CMSIPredictiveDialingSampleDlg::GetComboLineText(int i)
{
	CString s;
	if (i == 0)
	{
		((CComboBox*)GetDlgItem(IDC_COMBO_LINE1))->GetLBText(((CComboBox*)GetDlgItem(IDC_COMBO_LINE1))->GetCurSel(), s);
		return s;
	}
	else if (i == 1)
	{
		((CComboBox*)GetDlgItem(IDC_COMBO_LINE2))->GetLBText(((CComboBox*)GetDlgItem(IDC_COMBO_LINE2))->GetCurSel(), s);
		return s;
	}
	else if (i == 2)
	{
		((CComboBox*)GetDlgItem(IDC_COMBO_LINE3))->GetLBText(((CComboBox*)GetDlgItem(IDC_COMBO_LINE3))->GetCurSel(), s);
		return s;
	}
	else
	{
		((CComboBox*)GetDlgItem(IDC_COMBO_LINE4))->GetLBText(((CComboBox*)GetDlgItem(IDC_COMBO_LINE4))->GetCurSel(), s);
		return s;
	}
}

CString CMSIPredictiveDialingSampleDlg::GetComboVoiceText(int i)
{
	CString s;
	if (i == 0)
	{
		((CComboBox*)GetDlgItem(IDC_COMBO_VOICE1))->GetLBText(((CComboBox*)GetDlgItem(IDC_COMBO_VOICE1))->GetCurSel(), s);
		return s;
	}
	else if (i == 1)
	{
		((CComboBox*)GetDlgItem(IDC_COMBO_VOICE2))->GetLBText(((CComboBox*)GetDlgItem(IDC_COMBO_VOICE2))->GetCurSel(), s);
		return s;
	}
	else if (i == 2)
	{
		((CComboBox*)GetDlgItem(IDC_COMBO_VOICE3))->GetLBText(((CComboBox*)GetDlgItem(IDC_COMBO_VOICE3))->GetCurSel(), s);
		return s;
	}
	else
	{
		((CComboBox*)GetDlgItem(IDC_COMBO_VOICE4))->GetLBText(((CComboBox*)GetDlgItem(IDC_COMBO_VOICE4))->GetCurSel(), s);
		return s;
	}
}


void CMSIPredictiveDialingSampleDlg::DialNumber(MODEMOBJ ModemID)
{
	if (Started)
	{
		int index = FindLineModemObject(ModemID);
		CString s;

		if (index != -1)
		{
			if (GetNotConnectedMSI() != -1)
			{
				if (((CListBox*)GetDlgItem(IDC_LIST_PHONE))->GetCount() != 0)
				{
					((CListBox*)GetDlgItem(IDC_LIST_PHONE))->GetText(0, s);
					if (! s.IsEmpty())
					{
						LineState[index] = stateDialing;
						mdm_DialInVoiceMode(ModemID, s, 0, TRUE);
						((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("Dialing on Line " + index+1);
						((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("Dialing on Line " + s);
						((CListBox*)GetDlgItem(IDC_LIST_PHONE))->DeleteString(0);
					}
					else
					{
						LineState[index] = stateOnHook;
						((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("No phone numbers in the list. Enter two or more phone numbers.");
						KeepDialing = FALSE;
					}
				}
			}
			else
			{
				LineState[index] = stateOnHook;
				KeepDialing = FALSE;
	        }
		}
	}

////Folytatas VB DialNumber
}

int CMSIPredictiveDialingSampleDlg::FindLineModemObject(MODEMOBJ ModemID)
{
	if (ModemID == LineModemIDs[0])
		return 0;
	else if (ModemID = LineModemIDs[1])
		return 1;
	else if (ModemID == LineModemIDs[2])
		return 2;
	else if (ModemID == LineModemIDs[3])
		return 3;
	else
		return -1;
}

int CMSIPredictiveDialingSampleDlg::GetNotConnectedMSI()
{
    for (int i = 0; i < 4; i++)
        if (MSIState[i] == stateOnHook)
            return i;
    ((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("There is no MSI station off hook. MSI station should be off hook in order to connect a call to it");
    ((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString("Pickup a handset to begin a call.");
    return -1;
}

long CMSIPredictiveDialingSampleDlg::OnVoiceMsg(WPARAM event, LPARAM lParam)
{
    switch(event)
    {
        case MFX_MODEM_OK:
			{
				Handle_MFX_MODEM_OK((MODEMOBJ)lParam);
				break;
			}
		case MFX_CALLING_TONE:
			{
				Handle_MFX_CALLING_TONE((MODEMOBJ)lParam);
				break;
			}
		case MFX_VOICE_CONNECT:
			{
				Handle_MFX_VOICE_CONNECT((MODEMOBJ)lParam);
				break;
			}
		case MFX_MSI_STATIONONHOOK:
			{
				Handle_MFX_MSI_STATIONONHOOK((MODEMOBJ)lParam);
				break;
			}
		case MFX_MSI_STATIONOFFHOOK:
			{
				Handle_MFX_MSI_STATIONOFFHOOK((MODEMOBJ)lParam);
				break;
			}
 		case MFX_ONHOOK:
			{
				Handle_MFX_ONHOOK((MODEMOBJ)lParam);
				break;
			}
		case MFX_ANSWER_TONE:
			{
				Handle_MFX_ANSWER_TONE((MODEMOBJ)lParam);
				break;
			}
		case MFX_BUSY:
			{
				Handle_MFX_BUSY((MODEMOBJ)lParam);
				break;
			}
		case MFX_HANGUP:
			{
				Handle_MFX_HANGUP((MODEMOBJ)lParam);
				break;
			}
		case MFX_NO_ANSWER:
			{
				Handle_MFX_NO_ANSWER((MODEMOBJ)lParam);
				break;
			}
		case MFX_NO_CARRIER:
			{
				Handle_MFX_NO_CARRIER((MODEMOBJ)lParam);
				break;
			}
		case MFX_NO_DIALTONE:
			{
				Handle_MFX_NO_DIALTONE((MODEMOBJ)lParam);
				break;
			}
		case MFX_SIT:
			{
				Handle_MFX_SIT((MODEMOBJ)lParam);
				break;
			}
	}
    return 0;
}

void CMSIPredictiveDialingSampleDlg::Handle_MFX_MSI_STATIONOFFHOOK(MODEMOBJ ModemID)
{
	int index = FindLineModemObject(ModemID);
    if (index != -1)
	{
		CString s;
		s.Insert(0, "Line ");
		s.Insert(s.GetLength(), numToStr(index + 1));
		s.Insert(s.GetLength(), " is OffHook");
	    ((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString(s);
        MSIState[index] = stateOffHook;
        if (GetIdleLine() != -1)
            DialNumber (LineModemIDs[GetIdleLine()]);
    }
}

int CMSIPredictiveDialingSampleDlg::GetIdleLine()
{
    for (int i = 0; i < 4; i++)
        if (LineState[i] == stateOnHook)
			return i;
    return -1;
}

void CMSIPredictiveDialingSampleDlg::Handle_MFX_ANSWER_TONE(MODEMOBJ ModemID)
{
	int index = FindLineModemObject(ModemID);
    if (index != -1)
	{
		CString s;
		s.Insert(0, "Answer tone on line ");
		s.Insert(s.GetLength(), numToStr(index + 1));
        ((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString(s);
        if (LineState[index] == stateDialing)
		{
            LineState[index] = stateHangingUP;
            Handle_MFX_HANGUP(ModemID);
        }
    }
}

void CMSIPredictiveDialingSampleDlg::Handle_MFX_BUSY(MODEMOBJ ModemID)
{
	int index = FindLineModemObject(ModemID);
    if (index != -1)
	{
		CString s;
		s.Insert(0, "Busy tone on line ");
		s.Insert(s.GetLength(), numToStr(index + 1));
        ((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString(s);
        if (LineState[index] == stateDialing)
		{
            LineState[index] = stateHangingUP;
            Handle_MFX_HANGUP(ModemID);
        }
    }
}

void CMSIPredictiveDialingSampleDlg::Handle_MFX_CALLING_TONE(MODEMOBJ ModemID)
{
	int index = FindLineModemObject(ModemID);
    if (index != -1)
	{
		CString s;
		s.Insert(0, "Calling tone on line ");
		s.Insert(s.GetLength(), numToStr(index + 1));
        ((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString(s);
        if (LineState[index] == stateDialing)
		{
            LineState[index] = stateHangingUP;
            Handle_MFX_HANGUP(ModemID);
        }
    }
}

void CMSIPredictiveDialingSampleDlg::Handle_MFX_HANGUP(MODEMOBJ ModemID)
{
	int index = FindLineModemObject(ModemID);
    if (index != -1)
	{
		if (LineState[index] == stateHangingUP)
		{
			LineState[index] = stateOnHook;
			CString s;
			s.Insert(0, "Line ");
			s.Insert(s.GetLength(), numToStr(index + 1));
 			s.Insert(s.GetLength(), " on hook");
			((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString(s);
            DialNumber(LineModemIDs[index]);
		}
	}
    if (Exiting)
        if (AreThereAnyActivePorts() != TRUE)
            CloseAllResources();
}

void CMSIPredictiveDialingSampleDlg::Handle_MFX_MODEM_OK(MODEMOBJ ModemID)
{
	int index = FindLineModemObject(ModemID);
    if (index != -1)
	{
		if (LineState[index] == stateHangingUP)
		{
			LineState[index] = stateOnHook;
			CString s;
			s.Insert(0, "Line ");
			s.Insert(s.GetLength(), numToStr(index + 1));
 			s.Insert(s.GetLength(), " on hook");
			((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString(s);
            DialNumber(LineModemIDs[index]);
		}
	}
}

void CMSIPredictiveDialingSampleDlg::Handle_MFX_MSI_STATIONONHOOK(MODEMOBJ ModemID)
{
	int index = FindLineModemObject(ModemID);
    if (index != -1)
	{
		CString s;
		s.Insert(0, "Line ");
		s.Insert(s.GetLength(), numToStr(index + 1));
		s.Insert(s.GetLength(), " is OnHook");
		((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString(s);
        if (MSIState[index] != stateConnected)
            MSIState[index] = stateOnHook;
        else
		{
            MSIState[index] = stateOnHook;
			mdm_SCBUS_StopListeningTo(MSIHandles[index], LineHandles[MSIConnectedTo[index]], 0);
            mdm_SCBUS_StopListeningTo(VoiceHandles[MSIConnectedTo[index]], LineHandles[MSIConnectedTo[index]], 1);
            mdm_SCBUS_ListenTo(VoiceHandles[MSIConnectedTo[index]], LineHandles[MSIConnectedTo[index]], 0);
            LineState[MSIConnectedTo[index]] = stateHangingUP;
            mdm_HangUp(LineModemIDs[MSIConnectedTo[index]]);
            LineConnectedTo[MSIConnectedTo[index]] = -1;
            MSIConnectedTo[index] = -1;
		}
    }
}

void CMSIPredictiveDialingSampleDlg::Handle_MFX_NO_ANSWER(MODEMOBJ ModemID)
{
	int index = FindLineModemObject(ModemID);
    if (index != -1)
	{
		CString s;
		s.Insert(0, "No answer on line ");
		s.Insert(s.GetLength(), numToStr(index + 1));
		((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString(s);
        if (LineState[index] == stateDialing)
		{
            LineState[index] = stateHangingUP;
            Handle_MFX_HANGUP(ModemID);
        }
    }
}

void CMSIPredictiveDialingSampleDlg::Handle_MFX_NO_CARRIER(MODEMOBJ ModemID)
{
	int index = FindLineModemObject(ModemID);
    if (index != -1)
	{
		CString s;
		s.Insert(0, "No carrier on line ");
		s.Insert(s.GetLength(), numToStr(index + 1));
		((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString(s);
		if (LineState[index] == stateDialing)
		{
            LineState[index] = stateHangingUP;
            Handle_MFX_HANGUP(ModemID);
        }
    }
}

void CMSIPredictiveDialingSampleDlg::Handle_MFX_NO_DIALTONE(MODEMOBJ ModemID)
{
	int index = FindLineModemObject(ModemID);
    if (index != -1)
	{
		CString s;
		s.Insert(0, "No dial tone on line ");
		s.Insert(s.GetLength(), numToStr(index + 1));
		((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString(s);
		if (LineState[index] == stateDialing)
		{
            LineState[index] = stateHangingUP;
            Handle_MFX_HANGUP(ModemID);
        }
    }
}

void CMSIPredictiveDialingSampleDlg::Handle_MFX_ONHOOK(MODEMOBJ ModemID)
{
	int index = FindLineModemObject(ModemID);
    if (index != -1)
	{
		CString s;
		s.Insert(0, "Remote hangup on line ");
		s.Insert(s.GetLength(), numToStr(index + 1));
		((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString(s);
        if (LineState[index] == stateConnected)
            if (LineConnectedTo[index] != -1)
			{
                MSIState[LineConnectedTo[index]] = stateOffHook;
                mdm_SCBUS_StopListeningTo(MSIHandles[MSIindex], LineHandles[index], 0);//MSIindexel valami kaka van.
                mdm_SCBUS_StopListeningTo(LineHandles[index], VoiceHandles[index], 1);
                mdm_SCBUS_ListenTo(VoiceHandles[index], LineHandles[index], 0);
                MSIConnectedTo[LineConnectedTo[index]] = -1;
                LineConnectedTo[index] = -1;
            }
		LineState[index] = stateHangingUP;
        Handle_MFX_HANGUP(ModemID);
    }
}

void CMSIPredictiveDialingSampleDlg::Handle_MFX_SIT(MODEMOBJ ModemID)
{
	int index = FindLineModemObject(ModemID);
    if (index != -1)
	{
		CString s;
		s.Insert(0, "SIT tone on line ");
		s.Insert(s.GetLength(), numToStr(index + 1));
		((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString(s);
        if (LineState[index] == stateDialing)
		{
            LineState[index] = stateHangingUP;
            Handle_MFX_HANGUP(ModemID);
        }
    }
}

void CMSIPredictiveDialingSampleDlg::Handle_MFX_VOICE_CONNECT(MODEMOBJ ModemID)
{
    int index = FindLineModemObject(ModemID);
    if (index != -1)
	{
		CString s;
		s.Insert(0, "Voice connection on line ");
		s.Insert(s.GetLength(), numToStr(index + 1));
		((CListBox*)GetDlgItem(IDC_LIST_MESSAGE))->AddString(s);
        MSIindex = GetNotConnectedMSI();
        if (MSIindex != -1)
		{
            MSIState[MSIindex] = stateConnected;
            LineState[index] = stateConnected;
            LineConnectedTo[index] = MSIindex;
            MSIConnectedTo[MSIindex] = index;
            mdm_MSI_GenerateZipTone(MSIModemIDs[MSIindex]);
            mdm_SCBUS_StopListeningTo(VoiceHandles[index], LineHandles[index], 0);
            mdm_SCBUS_ListenTo(MSIHandles[MSIindex], LineHandles[index], 0);
            mdm_SCBUS_ListenTo(LineHandles[index], VoiceHandles[index], 1);
        }
    }
}

void CMSIPredictiveDialingSampleDlg::OnDestroy() 
{
	CDialog::OnDestroy();
	
	// TODO: Add your message handler code here
    KillFaxMessage(this->m_hWnd);
    EndOfFaxDriver(TRUE);	
	
}

int CMSIPredictiveDialingSampleDlg::OnCreate(LPCREATESTRUCT lpCreateStruct) 
{
	if (CDialog::OnCreate(lpCreateStruct) == -1)
		return -1;
	
	SetupFaxDriver(NULL);
	SetupVoiceDriver(NULL);
	SetRuningMode(RNM_ALWAYSFREE);
	SetFaxMessage(m_hWnd);

	SetForegroundWindow();
    mdm_MSI_OpenBoard(1);
	mdm_SCBUS_SetResourceRoutingMode(SCBUS_RESOURCE_ROUTING_MANUAL);
	
	return 0;
}

BOOL CMSIPredictiveDialingSampleDlg::AreThereAnyActivePorts()
{
    for (int i = 0; i < 4; i++)
        if (LineState[i] != stateOnHook)
			return TRUE;
    return FALSE;
}

void CMSIPredictiveDialingSampleDlg::CloseAllResources()
{
    for (int i = 0; i < 4; i++)
	{
        mdm_SCBUS_StopListeningTo(VoiceHandles[i], LineHandles[i], 0);
        mdm_SCBUS_DetachResourceFromMODEMOBJ(LineModemIDs[i], VoiceHandles[i]);
        mdm_SCBUS_DetachResourceFromMODEMOBJ(LineModemIDs[i], LineHandles[i]);
        mdm_SCBUS_CloseResource(LineHandles[i]);
        mdm_SCBUS_CloseResource(VoiceHandles[i]);
        mdm_DestroyModemObject(LineModemIDs[i]);
        
        mdm_SCBUS_CloseResource(MSIHandles[i]);
        mdm_SCBUS_DetachResourceFromMODEMOBJ(MSIModemIDs[i], MSIHandles[i]);
        mdm_DestroyModemObject(LineModemIDs[i]);
    }
    OnOK();
}

char CMSIPredictiveDialingSampleDlg::numToStr(int i)
{
	if (i == 1)
		return '1';
	else if (i == 2)
		return '2';
	else if (i == 3)
		return '3';
	else if (i == 4)
		return '4';
	return ' ';
}
