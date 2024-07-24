// faxdlg.h : header file
//
extern "C" {
#include "pbook.h"
}
/////////////////////////////////////////////////////////////////////////////
// CDlgFaxPortSetup dialog

class CDlgFaxPortSetup : public CDlg
{
// Construction
public:
    CDlgFaxPortSetup(CWnd* pParent = NULL); // standard constructor

// Dialog Data
    //{{AFX_DATA(CDlgFaxPortSetup)
    enum { IDD = IDD_PORTSETUP };
        // NOTE: the ClassWizard will add data members here
    //}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
    int FaxFileOne;
    // Generated message map functions
    //{{AFX_MSG(CDlgFaxPortSetup)
    virtual BOOL OnInitDialog();
    virtual void OnOK();
    afx_msg void OnSelchangeFaxlist();
    afx_msg void OnChangeSetup();
    afx_msg void OnClickedDebug();
    afx_msg void OnClickedDrDebug();
    afx_msg void OnTestmodem();
    afx_msg void OnChangeReset();
	afx_msg void OnTestdialtone();
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CDlgSendFax dialog

class CImgApp;

class CDlgSendFax : public CDlg
{
// Construction
public:
    PB_DBHANDLE     m_hDB;
    PB_ERRORS       m_err;
    CDlgSendFax(CWnd* pParent = NULL);  // standard constructor

// Dialog Data
    //{{AFX_DATA(CDlgSendFax)
    enum { IDD = IDD_SENDFAX };
    CString m_phonenum;
    CString m_name;
    //}}AFX_DATA

// Implementation
protected:

    BOOL    bAllPage;       // Send all pages
    int     iPort;          // port number for debug output              
    BOOL    bBFTenable;     // enable BFT
    int     m_nSendMode;    // IDC_SENDQUEUE, IDC_SENDIMMEDIATE, IDC_SEND_MANUAL
    BOOL    m_bGroup;    
    PORTFAX m_faxport;      // portfax
    CString m_szDName, m_szDComp, m_szDTelephone;

    int     qryActPage();
    int     qryOneFaxType(int jj);
    int     qryFaxType(int pagefrom, int &pageto, int pagenum, BOOL &bNext, int &LastType);
    int     qryMaxPage();
    HANDLE  qrySendPage(int iPage, CString &strFileName, BOOL bLoad);
    BOOL    SendNormalFax(int pagefrom, int pageto);
    BOOL    SendBFTFax(int pagefrom, int pageto);
    BOOL    SendAllPage(FAXOBJ faxobj, int pagefrom, int pageto, BOOL bBFTflag);
    BOOL    SendFaxObj(FAXOBJ faxobj);
    BOOL    SendFaxObject(FAXOBJ faxobj, BOOL bRealSend);
    void    xSendFax();
    void    ClosePhoneBook();
    int     AddPersonList(PB_LPITEMREC data, PB_ITEMHANDLE hItem);
    static BOOL _export FAR PASCAL FillPerson(PB_ITEMHANDLE hItem, LPVOID lpPar);
    void    FillPhoneBook(void);
    BOOL    TestPhoneNumber();
    BOOL    TestDate();

    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CDlgSendFax)
    virtual BOOL OnInitDialog();
    virtual void OnOK();
    afx_msg void OnSelchangeList1();
    virtual void OnCancel();
	afx_msg void OnChangeFaxnumber();
	afx_msg void OnSendManual();
	afx_msg void OnSendPolling();
	afx_msg void OnSendimmediate();
	afx_msg void OnSendqueue();
	afx_msg void OnChangeMonth();
	afx_msg void OnChangeDay();
	afx_msg void OnChangeYear();
	afx_msg void OnChangeHour();
	afx_msg void OnChangeMinute();
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CDlgFaxClose dialog

class CDlgFaxClose : public CDlg
{
// Construction
public:
    CDlgFaxClose(CWnd* pParent = NULL); // standard constructor

// Dialog Data
    //{{AFX_DATA(CDlgFaxClose)
    enum { IDD = IDD_CLOSEFAX };
        // NOTE: the ClassWizard will add data members here
    //}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CDlgFaxClose)
    virtual BOOL OnInitDialog();
    virtual void OnOK();
	afx_msg void OnSelchangeFaxports();
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CDlgAbortFax dialog

class CDlgAbortFax : public CDlg
{
// Construction
public:
    CDlgAbortFax(CWnd* pParent = NULL); // standard constructor

// Dialog Data
    //{{AFX_DATA(CDlgAbortFax)
    enum { IDD = IDD_ABORT_FAX };
        // NOTE: the ClassWizard will add data members here
    //}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CDlgAbortFax)
    virtual BOOL OnInitDialog();
    virtual void OnOK();
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CFaxEvent dialog

class CFaxEvent : public CDlg
{
// Construction
public:
    CFaxEvent(CWnd* pParent = NULL);    // standard constructor
    
    void RecFaxMessage(WPARAM wParam , LPARAM lParam);
    void SetEventText(int iPort, LPSTR buf);
    
// Dialog Data
    //{{AFX_DATA(CFaxEvent)
    enum { IDD = IDD_FAXEVENT };
        // NOTE: the ClassWizard will add data members here
    //}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CFaxEvent)
    virtual BOOL OnInitDialog();
    virtual void OnOK();
    afx_msg void OnFclear();
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CFaxRec dialog

class CFaxRec : public CDialog
{
// Construction
public:
    CFaxRec(CWnd* pParent = NULL);  // standard constructor

// Dialog Data
    //{{AFX_DATA(CFaxRec)
    enum { IDD = IDD_RECFAX };
        // NOTE: the ClassWizard will add data members here
    //}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CFaxRec)
    virtual BOOL OnInitDialog();
    afx_msg void OnAutoansw();
    afx_msg void OnKillfocusRings();
    afx_msg void OnSelchangeFaxports();
    virtual void OnOK();
    afx_msg void OnRecManual();
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CFaxConfig dialog

class CFaxConfig : public CDlg
{
// Construction
public:
    CFaxConfig(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
    //{{AFX_DATA(CFaxConfig)
    enum { IDD = IDD_FAXCONFIG };
        // NOTE: the ClassWizard will add data members here
    //}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CFaxConfig)
    virtual BOOL OnInitDialog();
    virtual void OnOK();
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CEnablePort dialog

class CEnablePort : public CDlg
{
// Construction
public:
    CEnablePort(CWnd* pParent = NULL);  // standard constructor

// Dialog Data
    //{{AFX_DATA(CEnablePort)
    enum { IDD = IDD_PORTENABLE };
    //}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CEnablePort)
    virtual BOOL OnInitDialog();
    afx_msg void OnDisable();
    afx_msg void OnSelchangeFaxports();
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CPortSet dialog

class CPortSet : public CDialog
{
// Construction
public:
    CPortSet(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
    //{{AFX_DATA(CPortSet)
    enum { IDD = IDD_PORTSET };
    CComboBox   m_NameList;
    CString m_szTime;
    CString m_szComm;
    //}}AFX_DATA
    CStringArray    m_CommArr;
    CStringArray    m_TimeArr;
    WORD    m_wArrSize;
    WORD    m_wPortNr;
    int     m_actual;

// Overrides
    // ClassWizard generated virtual function overrides
    //{{AFX_VIRTUAL(CPortSet)
    protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
    //}}AFX_VIRTUAL

// Implementation
protected:

    // Generated message map functions
    //{{AFX_MSG(CPortSet)
    virtual BOOL OnInitDialog();
    afx_msg void OnSelChangeCombo1();
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CPortSelect dialog

class CPortSelect : public CDialog
{
// Construction
public:
    CPortSelect(CWnd* pParent = NULL);  // standard constructor

// Dialog Data
    //{{AFX_DATA(CPortSelect)
    enum { IDD = IDD_PORTSEL };
    CListBox    m_PortList;
    //}}AFX_DATA
    WORD    m_wPort;

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CPortSelect)
    virtual BOOL OnInitDialog();
    virtual void OnOK();
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////
// CPolling dialog

class CPolling : public CDialog
{
// Construction
public:
    CPolling(CWnd* pParent = NULL); // standard constructor

// Dialog Data
    //{{AFX_DATA(CPolling)
    enum { IDD = IDD_POLLING };
    CString m_name;
    CString m_phonenum;
    //}}AFX_DATA
    PB_DBHANDLE     m_hDB;
    PB_ERRORS       m_err;
    PORTFAX         m_faxport;
    int     iPort;
    
    BOOL    SendNormalFax();
    void    ClosePhoneBook();
    int     AddPersonList(PB_LPITEMREC data, PB_ITEMHANDLE hItem);
    static BOOL _export FAR PASCAL FillPerson(PB_ITEMHANDLE hItem, LPVOID lpPar);
    void    FillPhoneBook();
    BOOL    TestPhoneNumber();
    void    xSendFax();

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CPolling)
    virtual BOOL OnInitDialog();
    virtual void OnOK();
    virtual void OnCancel();
    afx_msg void OnSelchangeList1();
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
#if defined(WIN32)
/////////////////////////////////////////////////////////////////////////////
// CBOpen dialog

class CBOpen : public CDialog
{
// Construction
public:
    CBOpen(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
    //{{AFX_DATA(CBOpen)
    enum { IDD = IDD_OPENBCHANNEL };
        // NOTE: the ClassWizard will add data members here
    //}}AFX_DATA


// Overrides
    // ClassWizard generated virtual function overrides
    //{{AFX_VIRTUAL(CBOpen)
    protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
    //}}AFX_VIRTUAL

// Implementation
protected:

    // Generated message map functions
    //{{AFX_MSG(CBOpen)
    virtual BOOL OnInitDialog();
    afx_msg void OnTest();
    virtual void OnOK();
    afx_msg void OnSelchangeChannels();
	afx_msg void OnBrowse();
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////
// CDlgGOpen dialog

class CDlgGOpen : public CDialog
{
// Construction
public:
    CDlgGOpen(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
    //{{AFX_DATA(CDlgGOpen)
    enum { IDD = IDD_OPENGCHANNEL };
        // NOTE: the ClassWizard will add data members here
    //}}AFX_DATA


// Overrides
    // ClassWizard generated virtual function overrides
    //{{AFX_VIRTUAL(CDlgGOpen)
    protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
    //}}AFX_VIRTUAL

// Implementation
protected:

    // Generated message map functions
    //{{AFX_MSG(CDlgGOpen)
    virtual BOOL OnInitDialog();
    virtual void OnOK();
    afx_msg void OnTest();
    afx_msg void OnChangeConfig();
    afx_msg void OnSelchangeChannels();
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
#endif
