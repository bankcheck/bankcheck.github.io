#include "pbpos.h"
#if (defined _VISUALC7 || defined _VISUALC8)
#include <fstream>
using namespace std;
#else
#include <fstream.h>
class  ofstream;
#endif

class  CPhbookPerson;

/////////////////////////////////////////////////////////////////////////////
// CPhbookEdit dialog

class CPhbookEdit : public CDialog
{
// Construction
public:
    CPhbookEdit(CWnd* pParent = NULL);  // standard constructor
    CPhbookEdit::~CPhbookEdit();

// Dialog Data
    //{{AFX_DATA(CPhbookEdit)
    enum { IDD = IDD_PBEDIT };
    //}}AFX_DATA

// Implementation

	BOOL			user_not_cont;

    BOOL PETestExist1();
    BOOL PETestExist2();
    
    void PEImport();
    void PEExport();

protected:

    PB_DBHANDLE     m_hDB;
    PB_ERRORS       m_err;
    ofstream FAR   *m_os;
    int             m_bCompany;     /* 0: person, 1: comapny */

	int				pos_name;
	int				pos_company;
	int				pos_tel;

	BOOL			bShowGroupContent;
	int				GrpInList2;

	void PEDispError();
    void PESkipText(LPSTR buf);
    
    BOOL xPEImportBuf(LPSTR buf, CPBPos FAR *dlg);
    BOOL PEPromptTextFile(CString &fileName, BOOL bOpen, LPSTR lpTitle);

	void PEUpdateEnable();
    void PEUpdateList1(int index);
    void PEUpdateList2(PB_ITEMHANDLE hItem);
	int  PEGetIndexFromList2(PB_ITEMHANDLE hItem);
    
    int  PEAddPersonList(PB_LPITEMREC data, PB_ITEMHANDLE hItem, BOOL bSelect);
    int  PEAddGroupList (PB_LPGROUPNAME grpname, PB_GROUPHANDLE hGroup, BOOL bSelect);
    
    void PEGetFromCtrl(PB_LPITEMREC data, CPhbookPerson FAR *dlg);
    void PESetToCtrl(PB_LPITEMREC data, CPhbookPerson FAR *dlg, LPSTR title);
    
    void PEAddRemove(BOOL bAdd);
    
    static BOOL _export FAR PASCAL PEFillPerson(PB_ITEMHANDLE hItem, LPVOID lpPar);
    static BOOL _export FAR PASCAL PESavePerson(PB_ITEMHANDLE hItem, LPVOID lpPar);
    static BOOL _export FAR PASCAL PEFillGroup(PB_GROUPHANDLE hGroup, LPVOID lpPar);
    static BOOL _export FAR PASCAL PEItemsInGroup(PB_ITEMHANDLE hItem, LPVOID lpPar);

    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CPhbookEdit)
    afx_msg void OnNew1();
    afx_msg void OnAdd();
    afx_msg void OnDel1();
    afx_msg void OnDel2();
    afx_msg void OnEdit();
    afx_msg void OnNew2();
    afx_msg void OnRadio1();
    afx_msg void OnRadio2();
    afx_msg void OnRemove();
    afx_msg void OnSearch();
    afx_msg void OnShow();
    afx_msg void OnView();
    virtual BOOL OnInitDialog();
	afx_msg void OnSelchangeList2();
	afx_msg void OnSelchangeList1();
	afx_msg void OnDblclkList1();
	afx_msg void OnDblclkList2();
	afx_msg void OnShowall();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////
// CPhbookGroup dialog

class CPhbookGroup : public CDialog
{
// Construction
public:
    CPhbookGroup(CWnd* pParent = NULL); // standard constructor

// Dialog Data
    //{{AFX_DATA(CPhbookGroup)
    enum { IDD = IDD_PBGROUP };
    CString m_edit;
    //}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CPhbookGroup)
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////
// CPhbookPerson dialog

class CPhbookPerson : public CDialog
{
// Construction
public:
    CPhbookPerson(CWnd* pParent = NULL);    // standard constructor

// Dialog Data
    //{{AFX_DATA(CPhbookPerson)
    enum { IDD = IDD_PBPERSON };
    CString m_edit1;
    CString m_edit2;
    CString m_edit3;
    CString m_title;
    //}}AFX_DATA

// Implementation

	BOOL			tel_edit;

protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CPhbookPerson)
	virtual void OnOK();
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////
// CPhbookSearch dialog

class CPhbookSearch : public CDialog
{
// Construction
public:
    CPhbookSearch(CWnd* pParent = NULL);    // standard constructor

// Dialog Data
    //{{AFX_DATA(CPhbookSearch)
    enum { IDD = IDD_PBSEARCH };
    CString m_edit;
    //}}AFX_DATA

// Implementation
	BOOL			bCompany;

protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CPhbookSearch)
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////
// CPhbookView dialog

class CPhbookView : public CDialog
{
// Construction
public:
    CPhbookView(CWnd* pParent = NULL);  // standard constructor

// Dialog Data
    //{{AFX_DATA(CPhbookView)
    enum { IDD = IDD_PBVIEW };
    CString m_edit1;
    CString m_edit2;
    CString m_edit3;
    //}}AFX_DATA

// Implementation
protected:
    virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

    // Generated message map functions
    //{{AFX_MSG(CPhbookView)
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
