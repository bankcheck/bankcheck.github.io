// dialogs.cpp : implementation file
//

#include "stdafx.h"
#include <direct.h>
#include <stdlib.h>

extern "C" {
    #include    "pbook.h"
};
#include "resource.h"
#include "faxcpp.h"
#include "bitiff.h"
#include "imgdoc.h"
#include "dialogs.h"
#include "faxdlg.h"
//#include "faxdoc.h"
#include "demo.h"
#include "phbdlg.h"

#ifdef WIN32
#define _fstrspn strspn
#define _fstrupr strupr
#define _fstrstr strstr
#endif

#define PHB_SECTION "Logs"
#define PHB_PATH    "Database Path"

static char pbook_fname[250] = "CF";

static char err_nofile1[] =
{
    "The Phonebook database does not exist or damaged.\n"
    "Do you want to create a new phonebook?"
};

static char err_nofile2[] =
{
    "The Phonebook database does not exist or demaged."
};

static char err_phone[] =
{
        "The phone number is not correct."
};

static char *err_tab[] =
{
    "Phone book: No Error",
    "Phone book: IO Error",
    "Phone book: Out Of Memory",
    "Phone book: Out Of Disk",
    "Phone book: Unknown Error",
};
const int MAX_PBERROR = 4;

static char qu_del1[] =
{
        "Are you sure want to delete the selected group?"
};

static char qu_del2[] =
{
        "Are you sure want to delete the selected item(s)?"
};

void SetPhbookFileName(LPSTR lpPhonePath)
{
    char fpath[255], DefPath[_MAX_DIR];
    char fdrive[_MAX_DRIVE], fdir[_MAX_DIR];
    LPSTR bs;

        GetModuleFileName( AfxGetInstanceHandle(), DefPath, _MAX_DIR );
        bs = _fstrrchr( DefPath, '\\' );
        if ( !bs )
                _fstrrchr( DefPath, ':' );
        *bs = 0;

    fpath[0] = '"';
    lstrcpy( fpath, AfxGetApp()->GetProfileString(PHB_SECTION, PHB_PATH, DefPath) );
    int ln = lstrlen(fpath);
    if(ln > 0 && fpath[ln-1]!='\\')
    { 
		fpath[ln] = '\\';
        fpath[ln+1] = 0;
    }
    _splitpath(fpath, fdrive, fdir, NULL, NULL);
    _makepath(lpPhonePath, fdrive, fdir, "CF", NULL);
}

/*>>>>>>>>>>>>>  Test Phone Number        <<<<<<<<<<<<<<<<< */
static BOOL TestPhoneNumber(LPSTR lpPhone)
{
        int ii = _fstrspn(lpPhone, "0123456789-");
        int ln = lstrlen(lpPhone);
        BOOL bOK = (ii>=ln && ln) ? TRUE : FALSE;
        return bOK;
}


/////////////////////////////////////////////////////////////////////////////
// CPhbookGroup dialog
CPhbookGroup::CPhbookGroup(CWnd* pParent /*=NULL*/)
    : CDialog(CPhbookGroup::IDD, pParent)
{
    //{{AFX_DATA_INIT(CPhbookGroup)
    m_edit = "";
    //}}AFX_DATA_INIT

}

void CPhbookGroup::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CPhbookGroup)
    DDX_Text(pDX, IDC_EDIT, m_edit);
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPhbookGroup, CDialog)
    //{{AFX_MSG_MAP(CPhbookGroup)
        //}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPhbookGroup message handlers

/////////////////////////////////////////////////////////////////////////////
// CPhbookPerson dialog
CPhbookPerson::CPhbookPerson(CWnd* pParent /*=NULL*/)
    : CDialog(CPhbookPerson::IDD, pParent)
{
    //{{AFX_DATA_INIT(CPhbookPerson)
    m_edit1 = "";
    m_edit2 = "";
    m_edit3 = "";
    //}}AFX_DATA_INIT
}

void CPhbookPerson::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CPhbookPerson)
    DDX_Text(pDX, IDC_EDIT1, m_edit1);
    DDX_Text(pDX, IDC_EDIT2, m_edit2);
    DDX_Text(pDX, IDC_EDIT3, m_edit3);
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPhbookPerson, CDialog)
    //{{AFX_MSG_MAP(CPhbookPerson)
        //}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPhbookPerson message handlers

void CPhbookPerson::OnOK()
{
        // TODO: Add extra validation here
        CEdit *wedit = (CEdit *)GetDlgItem(IDC_EDIT3);
        if(wedit==NULL)
                return;

        char buf[100];
        wedit->GetWindowText( buf, sizeof(buf) );

        BOOL bOK;
        bOK = TestPhoneNumber(buf);
        if(bOK)
        {
                CDialog::OnOK();
        }
        else
        {
                AfxMessageBox(err_phone);
                wedit->SetFocus();
        }
}

BOOL CPhbookPerson::OnInitDialog()
{
        CDialog::OnInitDialog();

        // TODO: Add extra initialization here

        if( m_title.GetLength() )
        {
                SetWindowText(m_title);
        }

        ((CEdit *)GetDlgItem(IDC_EDIT1))->LimitText(30);
        ((CEdit *)GetDlgItem(IDC_EDIT2))->LimitText(30);
        ((CEdit *)GetDlgItem(IDC_EDIT3))->LimitText(60);

        if(tel_edit)
        {
                CEdit *wedit;
                wedit = (CEdit *)GetDlgItem(IDC_EDIT3);
                wedit->SetFocus();
                wedit->SendMessage(EM_SETSEL, 0, -1);
                return FALSE;
        }

        return TRUE;  // return TRUE  unless you set the focus to a control
}

/////////////////////////////////////////////////////////////////////////////
// CPhbookSearch dialog
CPhbookSearch::CPhbookSearch(CWnd* pParent /*=NULL*/)
    : CDialog(CPhbookSearch::IDD, pParent)
{
    //{{AFX_DATA_INIT(CPhbookSearch)
    m_edit = "";
    //}}AFX_DATA_INIT
}

void CPhbookSearch::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CPhbookSearch)
    DDX_Text(pDX, IDC_EDIT, m_edit);
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPhbookSearch, CDialog)
    //{{AFX_MSG_MAP(CPhbookSearch)
        //}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPhbookSearch message handlers


/////////////////////////////////////////////////////////////////////////////
// CPhbookView dialog
CPhbookView::CPhbookView(CWnd* pParent /*=NULL*/)
    : CDialog(CPhbookView::IDD, pParent)
{
    //{{AFX_DATA_INIT(CPhbookView)
    m_edit1 = "";
    m_edit2 = "";
    m_edit3 = "";
    //}}AFX_DATA_INIT
}

void CPhbookView::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CPhbookView)
    DDX_Text(pDX, IDC_EDIT1, m_edit1);
    DDX_Text(pDX, IDC_EDIT2, m_edit2);
    DDX_Text(pDX, IDC_EDIT3, m_edit3);
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPhbookView, CDialog)
    //{{AFX_MSG_MAP(CPhbookView)
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPhbookView message handlers

/////////////////////////////////////////////////////////////////////////////
// CPhbookEdit dialog
CPhbookEdit::CPhbookEdit(CWnd* pParent /*=NULL*/)
    : CDialog(CPhbookEdit::IDD, pParent)
{
    //{{AFX_DATA_INIT(CPhbookEdit)
        // NOTE: the ClassWizard will add member initialization here
    //}}AFX_DATA_INIT

    m_os = NULL;
    m_hDB = NULL;
    m_err = PB_NOERROR;
    m_bCompany = 0;

        SetPhbookFileName(pbook_fname);
}

CPhbookEdit::~CPhbookEdit()
{
    if(m_hDB)
    {
        PB_ClosePhoneBook(m_hDB);
        m_hDB = NULL;
    }

    if(m_os)
    {
        delete m_os;
        m_os = NULL;
    }
}

void CPhbookEdit::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    //{{AFX_DATA_MAP(CPhbookEdit)
        // NOTE: the ClassWizard will add DDX and DDV calls here
    //}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPhbookEdit, CDialog)
    //{{AFX_MSG_MAP(CPhbookEdit)
    ON_BN_CLICKED(IDC_NEW1, OnNew1)
    ON_BN_CLICKED(IDC_ADD, OnAdd)
    ON_BN_CLICKED(IDC_DEL1, OnDel1)
    ON_BN_CLICKED(IDC_DEL2, OnDel2)
    ON_BN_CLICKED(IDC_EDIT, OnEdit)
    ON_BN_CLICKED(IDC_NEW2, OnNew2)
    ON_BN_CLICKED(IDC_RADIO1, OnRadio1)
    ON_BN_CLICKED(IDC_RADIO2, OnRadio2)
    ON_BN_CLICKED(IDC_REMOVE, OnRemove)
    ON_BN_CLICKED(IDC_SEARCH, OnSearch)
    ON_BN_CLICKED(IDC_SHOW, OnShow)
    ON_BN_CLICKED(IDC_VIEW, OnView)
        ON_LBN_SELCHANGE(IDC_LIST2, OnSelchangeList2)
        ON_LBN_SELCHANGE(IDC_LIST1, OnSelchangeList1)
        ON_LBN_DBLCLK(IDC_LIST1, OnDblclkList1)
        ON_LBN_DBLCLK(IDC_LIST2, OnDblclkList2)
        ON_BN_CLICKED(IDC_SHOWALL, OnShowall)
        //}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPhbookEdit message handlers

void CPhbookEdit::OnSelchangeList1()
{
        // TODO: Add your control notification handler code here
        PEUpdateEnable();
}

void CPhbookEdit::OnSelchangeList2()
{
        // TODO: Add your control notification handler code here
        PEUpdateEnable();
}

void CPhbookEdit::OnDblclkList1()
{
        // TODO: Add your control notification handler code here
        OnShow();
}

void CPhbookEdit::OnDblclkList2()
{
        // TODO: Add your control notification handler code here
        OnView();
}

void CPhbookEdit::OnNew1()
{
    // TODO: Add your control notification handler code here
    CPhbookGroup dlg;
    int nret = dlg.DoModal();
    if(nret!=IDOK || m_hDB==NULL)
    {
        return;
    }
    PB_GROUPNAME grpname;
    int ln = sizeof(grpname);
    lstrcpyn( grpname, dlg.m_edit.GetBuffer(ln+1), ln );

        if(grpname[0]=='\0')
        {
                AfxMessageBox("Group name must be at least one character long!");
                return;
        }

        int jj;
        int ii = 0;
        int mm = strlen(grpname);

        // Remove leading spaces
        while(grpname[ii]==' ' && ii<mm)
                ii++;
        if(ii==mm)
        {
                AfxMessageBox("You typed only whitespaces!");
                return;
        }
        if(ii!=0)
                for(jj=ii;jj<=mm;jj++)
                        grpname[jj-ii] = grpname[jj];

        // Remove final spaces
        ii = strlen(grpname)-1;
        while(grpname[ii]==' ' && ii>=0)
        {
                grpname[ii] = '\0';
                ii--;
        }

        if(grpname[0]=='\0')
        {
                AfxMessageBox("You typed only whitespaces!");
                return;
        }

        CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
        int nn = lst1->GetCount();
        mm = strlen(grpname);
        for(ii=0;ii<nn;ii++)
        {
                if(lst1->SendMessage(LB_GETTEXTLEN,ii)==mm)
                {
                        char tmp_buf[32];
                        lst1->SendMessage(LB_GETTEXT,(WPARAM)ii,(LPARAM)(LPCTSTR)tmp_buf);
                        if(strcmp(grpname,tmp_buf)==0)
                        {
                                AfxMessageBox("Existing group name!");
                                return;
                        }
                }

        }

    PB_GROUPHANDLE hGroup = PB_CreateGroup(m_hDB, &grpname, &m_err);
    if(m_err)
    {
        PEDispError();
    }
    else
    {
        PEAddGroupList(&grpname, hGroup, TRUE);
                if(bShowGroupContent)
                        PEUpdateList2(0);
    }
}

void CPhbookEdit::OnAdd()
{
    // TODO: Add your control notification handler code here
    PEAddRemove(TRUE);
}

void CPhbookEdit::OnDel1()
{
    // TODO: Add your control notification handler code here
    CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
    if(lst1==NULL || m_hDB==NULL)
        return;

    int index = lst1->GetCurSel();
    if(index < 0)
        return;

        int nret = AfxMessageBox(qu_del1, MB_YESNO);
        if(nret!=IDYES)
                return;

    PB_GROUPHANDLE hGroup = (PB_GROUPHANDLE)lst1->GetItemData(index);

    m_err = PB_DeleteGroup(m_hDB, hGroup);
    if(m_err)
    {
        PEDispError();
    }

        BOOL tmp_show = bShowGroupContent;
        bShowGroupContent = FALSE;

    int nn = lst1->GetCount();
    if(nn==1)
    {
        lst1->ResetContent();
                if(tmp_show)
                        PEUpdateList2(0);
                else
                        PEUpdateEnable();
                GetDlgItem(IDC_NEW1)->SetFocus();
    }
    else
    {
                if(tmp_show)
                        PEUpdateList2(0);
        if(index==nn-1)
                index--;
        PEUpdateList1(index);
    }
}

void CPhbookEdit::OnDel2()
{
    // TODO: Add your control notification handler code here
    CListBox *lst2 = (CListBox *)GetDlgItem(IDC_LIST2);
    if(lst2==NULL || m_hDB==NULL)
        return;

    int nNum = lst2->GetSelCount();
    if(nNum<1)
        return;

        int nret = AfxMessageBox(qu_del2, MB_YESNO);
        if(nret!=IDYES)
                return;

    LPINT ibuf = new int[nNum+2];

    int nn = lst2->GetSelItems(nNum, ibuf);

    PB_ITEMHANDLE  hItem;
    int index;

    for(int jj=0; jj<nn; jj++)
    {
        index = ibuf[jj];
        hItem = (PB_ITEMHANDLE)lst2->GetItemData(index);
        m_err = PB_DeleteItem(m_hDB, hItem);
        if(m_err)
        {
            PEDispError();
            break;
        }
    }
    delete ibuf;
    PEUpdateList2(0);
        if(lst2->GetCount()<1)
                GetDlgItem(IDC_NEW2)->SetFocus();
}

void CPhbookEdit::OnEdit()
{
    // TODO: Add your control notification handler code here
    PB_ITEMREC data;
    CPhbookPerson dlg;

    CListBox *lst2 = (CListBox *)GetDlgItem(IDC_LIST2);
    if(lst2==NULL || m_hDB==NULL)
        return;

    int nNum = lst2->GetSelCount();
    if(nNum !=1 )
        return;

    LPINT ibuf = new int[2];
    int nn = lst2->GetSelItems(1, ibuf);

    int index = ibuf[0];
    if(index < 0)
    {
        delete ibuf;
        return;
    }
    PB_ITEMHANDLE hItem = (PB_ITEMHANDLE)lst2->GetItemData(index);

    _fmemset(&data, 0, sizeof(data) );
    m_err = PB_GetItem(m_hDB, hItem, &data);
    if(m_err)
    {
        PEDispError();
    }
    else
    {
        PESetToCtrl(&data, &dlg, "Edit Person");
                dlg.tel_edit = FALSE;
        int nret = dlg.DoModal();
        if(nret==IDOK)
        {
            PEGetFromCtrl(&data, &dlg);

            m_err = PB_ModifyItem(m_hDB, hItem, &data);
            if(m_err)
            {
                PEDispError();
            }
            else
            {
                PEUpdateList2(hItem);
            }
        }
    }
    delete ibuf;
}

void CPhbookEdit::OnNew2()
{
    // TODO: Add your control notification handler code here
    PB_ITEMREC data;
    CPhbookPerson dlg;

    _fmemset(&data, 0, sizeof(data) );
    PESetToCtrl(&data, &dlg, "Add New Person");
        dlg.tel_edit = FALSE;
    int nret = dlg.DoModal();
    if(nret!=IDOK || m_hDB==NULL)
        return;

    PEGetFromCtrl(&data, &dlg);

    PB_ITEMHANDLE hItem = PB_AddItem(m_hDB, &data, &m_err);
    if(m_err)
    {
        PEDispError();
    }
    else
    {
        if(bShowGroupContent)
                {
                        CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
                        int tmp_sel = lst1->GetCurSel();
                        if(tmp_sel>=0 && tmp_sel==GrpInList2)
                        {
                                PEAddPersonList(&data, hItem, TRUE);
                                OnAdd();
                        }
                }
                else
                        PEAddPersonList(&data, hItem, TRUE);
    }
}

void CPhbookEdit::OnRadio1()
{
    // TODO: Add your control notification handler code here
    m_bCompany = 0;
    PEUpdateList2(0);
}

void CPhbookEdit::OnRadio2()
{
    // TODO: Add your control notification handler code here
    m_bCompany = 1;
    PEUpdateList2(0);
}

void CPhbookEdit::OnRemove()
{
    // TODO: Add your control notification handler code here
    PEAddRemove(FALSE);
}

void CPhbookEdit::OnSearch()
{
    // TODO: Add your control notification handler code here
    CPhbookSearch dlg;

    CListBox *lst2 = (CListBox *)GetDlgItem(IDC_LIST2);
    if(lst2==NULL || m_hDB==NULL)
        return;

    int nNum = lst2->GetCount();
    if(nNum < 1)
        return;

        if(m_bCompany)
                dlg.bCompany = TRUE;
        else
                dlg.bCompany = FALSE;
    int nret = dlg.DoModal();
    if(nret!=IDOK)
        return;

        dlg.m_edit.MakeUpper();
    LPSTR lpsearch = NULL;
    int ln = dlg.m_edit.GetLength();
    if(ln)
    {
        lpsearch = dlg.m_edit.GetBuffer(ln+1);
    }
    if(lpsearch==NULL)
        return;

    int nn;
    char buf[100];
    for(int jj=0; jj<nNum; jj++)
    {
        nn = lst2->GetText(jj, buf);
        if(nn < 1)
            continue;
                _fstrupr(buf);
        LPSTR lpFind = _fstrstr(buf, lpsearch);
        BOOL bSel = (lpFind==buf) ? TRUE : FALSE;
        lst2->SetSel(jj, bSel);
    }
    PEUpdateEnable();
}

void CPhbookEdit::OnShow()
{
    // TODO: Add your control notification handler code here
        CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
        CListBox *lst2 = (CListBox *)GetDlgItem(IDC_LIST2);
    if(lst1==NULL || lst2==NULL || m_hDB==NULL)
        return;

    int index = lst1->GetCurSel();
    if(index < 0)
        return;

        bShowGroupContent = TRUE;
        GrpInList2 = index;
    lst2->ResetContent();

    PB_GROUPHANDLE hGroup = (PB_GROUPHANDLE)lst1->GetItemData(index);

    m_err = PB_EnumItemsInGroup(m_hDB, hGroup, DOWN, 0, PEItemsInGroup, this);
    if(m_err && m_err != PB_IOERROR)
    {
        PEDispError();
    }
    PEUpdateEnable();
}

void CPhbookEdit::OnShowall()
{
    // TODO: Add your control notification handler code here
    bShowGroupContent = FALSE;
        GrpInList2 = -1;
        PEUpdateList2(0);
}

void CPhbookEdit::OnView()
{
    PB_ITEMREC data;
    CPhbookView dlg;

    CListBox *lst2 = (CListBox *)GetDlgItem(IDC_LIST2);
    if(lst2==NULL || m_hDB==NULL)
        return;

    int nNum = lst2->GetSelCount();
    if(nNum !=1 )
        return;

    LPINT ibuf = new int[2];
    int nn = lst2->GetSelItems(1, ibuf);

    int index = ibuf[0];
    PB_ITEMHANDLE hItem = (PB_ITEMHANDLE)lst2->GetItemData(index);

    _fmemset(&data, 0, sizeof(data) );
    m_err = PB_GetItem(m_hDB, hItem, &data);
    if(m_err)
    {
        PEDispError();
    }
    else
    {
        dlg.m_edit1 = data.szName;
        dlg.m_edit2 = data.szCompanyName;
        dlg.m_edit3 = data.szPhoneNum;
        dlg.DoModal();
    }
    delete ibuf;
}

BOOL CPhbookEdit::OnInitDialog()
{
    CDialog::OnInitDialog();

    // TODO: Add extra initialization here

    if(m_hDB)
    {
        PB_ClosePhoneBook(m_hDB);
        m_hDB = NULL;
    }

    m_hDB = PB_OpenPhoneBook(pbook_fname, &m_err);
    if(m_err)
    {
        PEDispError();
        return FALSE;
    }

        bShowGroupContent = FALSE;
        GrpInList2 = -1;
    PEUpdateList1(0);
    PEUpdateList2(0);

    int ract = m_bCompany ? IDC_RADIO2 : IDC_RADIO1;
        CheckRadioButton(IDC_RADIO1, IDC_RADIO2, ract);

        return TRUE;  // return TRUE  unless you set the focus to a control
}

/*>>>>>>>>>>>>>  DispError and Test functions          <<<<<<<<<<<<<<<<< */

void CPhbookEdit::PEDispError()
{
    if(m_err<0 || m_err>MAX_PBERROR)
    {
        m_err = (PB_ERRORS)MAX_PBERROR;
    }
    AfxMessageBox(err_tab[m_err]);
}

BOOL CPhbookEdit::PETestExist1()
{
    BOOL bOK = PB_PhoneBookExists(pbook_fname);
    if(bOK)
    {
        return TRUE;
    }
    int nret = AfxMessageBox(err_nofile1, MB_YESNO);
    if(nret!=IDYES)
    {
        return FALSE;
    }
    m_err = PB_CreatePhoneBook(pbook_fname);
    if(m_err)
    {
        PEDispError();
        return FALSE;
    }
    return TRUE;
}

BOOL CPhbookEdit::PETestExist2()
{
    BOOL bOK = PB_PhoneBookExists(pbook_fname);
    if(bOK==FALSE)
    {
        AfxMessageBox(err_nofile2, MB_OK);
        return FALSE;
    }
    return TRUE;
}

/*>>>>>>>>>>>>>  LOW level LISTBOX functions        <<<<<<<<<<<<<<<<< */

void CPhbookEdit::PEUpdateEnable()
{
        int nn;
        char buf[30];
        BOOL b10, b20, b21, b30;

//      ONLY LIST-1
        b10 = FALSE;
    CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
    if(lst1)
    {
                b10 = (lst1->GetCurSel()>=0) ? TRUE : FALSE;
        }
        GetDlgItem(IDC_DEL1)->EnableWindow(b10);

//      ONLY LIST-2
        nn = 0;
    CListBox *lst2 = (CListBox *)GetDlgItem(IDC_LIST2);
    if(lst2)
    {
                nn = lst2->GetSelCount();
        }
        sprintf(buf, "%2i selected", nn);
        SetDlgItemText(IDC_TEXT, buf);
        b20 = (nn!=0) ? TRUE : FALSE;
        b21 = (nn==1) ? TRUE : FALSE;
        GetDlgItem(IDC_DEL2)->EnableWindow(b20);
        GetDlgItem(IDC_EDIT)->EnableWindow(b21);
        GetDlgItem(IDC_VIEW)->EnableWindow(b21);

        if(lst2->GetCount()<1)
                GetDlgItem(IDC_SEARCH)->EnableWindow(FALSE);
        else
                GetDlgItem(IDC_SEARCH)->EnableWindow(TRUE);

//      LIST-1 and LIST-2
        b30 = b10 & b20;

        if(bShowGroupContent)
        {
                if(lst1->GetCurSel()==GrpInList2)
                {
                        GetDlgItem(IDC_ADD)->EnableWindow(FALSE);
                        GetDlgItem(IDC_REMOVE)->EnableWindow(b30);
                        GetDlgItem(IDC_SHOW)->EnableWindow(FALSE);
                }
                else
                {
                        GetDlgItem(IDC_ADD)->EnableWindow(b30);
                        GetDlgItem(IDC_REMOVE)->EnableWindow(FALSE);
                        GetDlgItem(IDC_SHOW)->EnableWindow(b10);
                }
                GetDlgItem(IDC_SHOWALL)->EnableWindow(TRUE);

                GetDlgItem(IDC_TEXT2)->SetWindowText("Show mode: Show a group");
        }
        else
        {
                GetDlgItem(IDC_ADD)->EnableWindow(b30);
                GetDlgItem(IDC_REMOVE)->EnableWindow(b30);
                GetDlgItem(IDC_SHOW)->EnableWindow(b10);
                GetDlgItem(IDC_SHOWALL)->EnableWindow(FALSE);

                GetDlgItem(IDC_TEXT2)->SetWindowText("Show mode: Show all");
        }
}

void CPhbookEdit::PEUpdateList1(int index)
{
    CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
    if(lst1)
    {
        lst1->ResetContent();
            m_err = PB_EnumGroupsInDB(m_hDB, DOWN, 0l, PEFillGroup, this);
        if(m_err)
        {
            PEDispError();
        }
        lst1->SetCurSel(index);
        PEUpdateEnable();
    }
}

int CPhbookEdit::PEGetIndexFromList2(PB_ITEMHANDLE hItem)
{
    CListBox *lst2 = (CListBox *)GetDlgItem(IDC_LIST2);
    if(lst2==NULL)
        return -1;

    int nNum = lst2->GetCount();
    if(nNum < 1)
        return -1;

        PB_ITEMHANDLE hItem2;
        for(int jj=0; jj<nNum; jj++)
        {
            hItem2 = (PB_ITEMHANDLE)lst2->GetItemData(jj);
            if(hItem2==hItem)
            {
                return jj;
            }
        }
        return -1;
}

void CPhbookEdit::PEUpdateList2(PB_ITEMHANDLE hItem)
{
        if(bShowGroupContent)
                OnShow();
        else
        {
                CListBox *lst2 = (CListBox *)GetDlgItem(IDC_LIST2);
                if(lst2==NULL)
                return;

                lst2->ResetContent();
                m_err = PB_EnumItemsInDB(m_hDB, DOWN, 0l, PEFillPerson, this);
                if(m_err)
                {
                        PEDispError();
                }
                int index = 0;
                if(hItem)
                {
                index = PEGetIndexFromList2(hItem);
                }
                if(index>=0)
                {
                        lst2->SetSel(index, TRUE);
                }
                PEUpdateEnable();
        }
}

int CPhbookEdit::PEAddPersonList(PB_LPITEMREC data, PB_ITEMHANDLE hItem, BOOL bSelect)
{
    int index;
    CListBox *lst2 = (CListBox *)GetDlgItem(IDC_LIST2);
    if(lst2==NULL)
        return -1;

    if(m_bCompany)
    {
                if(data->szCompanyName[0]!='\0')
                        index = lst2->AddString(data->szCompanyName);
                else
                        index = lst2->AddString("[EMPTY FIELD]");
    }
    else
    {
                if(data->szName[0]!='\0')
                        index = lst2->AddString(data->szName);
                else
                        index = lst2->AddString("[EMPTY FIELD]");
    }

    if(index>=0)
    {
        lst2->SetItemData(index, hItem);
    }

    if(bSelect)
    {
        lst2->SetSel(-1, FALSE);                /* unselect all */
                lst2->SetSel(index, TRUE);
                PEUpdateEnable();
    }

    return index;
}

int CPhbookEdit::PEAddGroupList(PB_LPGROUPNAME grpname, PB_GROUPHANDLE hGroup, BOOL bSelect)
{
    CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
    if(lst1==NULL)
        return -1;

    int index = lst1->AddString(*grpname);
    if(index>=0)
    {
        lst1->SetItemData(index, hGroup);
    }
    if(bSelect)
    {
        lst1->SetCurSel(index);
                PEUpdateEnable();
    }

    return index;
}

/*>>>>>>>>>>>>>  LOW level PERSON edit functions        <<<<<<<<<<<<<<<<< */

void CPhbookEdit::PEGetFromCtrl(PB_LPITEMREC data, CPhbookPerson FAR *dlg)
{
    int ln;

    ln = sizeof(data->szName);
    lstrcpyn( data->szName, dlg->m_edit1.GetBuffer(ln+1), ln);

    ln = sizeof(data->szCompanyName);
    lstrcpyn( data->szCompanyName, dlg->m_edit2.GetBuffer(ln+1), ln);

    ln = sizeof(data->szPhoneNum);
    lstrcpyn( data->szPhoneNum, dlg->m_edit3.GetBuffer(ln+1), ln);
}

void CPhbookEdit::PESetToCtrl(PB_LPITEMREC data, CPhbookPerson FAR *dlg, LPSTR title)
{
    dlg->m_title = title;
    dlg->m_edit1 = data->szName;
    dlg->m_edit2 = data->szCompanyName;
    dlg->m_edit3 = data->szPhoneNum;
}


/*>>>>>>>>>>>>>  LOW level Add or Remove function        <<<<<<<<<<<<<<<<< */

void CPhbookEdit::PEAddRemove(BOOL bAdd)
{
    CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
    CListBox *lst2 = (CListBox *)GetDlgItem(IDC_LIST2);
    if(lst1==NULL || lst2==NULL || m_hDB==NULL)
        return;

    int iGrp = lst1->GetCurSel();
    if(iGrp < 0)
        return;

    int nNum = lst2->GetSelCount();
    if(nNum<1)
        return;

    LPINT ibuf = new int[nNum+2];

    int nn = lst2->GetSelItems(nNum, ibuf);

    PB_GROUPHANDLE hGroup = (PB_GROUPHANDLE)lst1->GetItemData(iGrp);
    PB_ITEMHANDLE  hItem;
    int index;

    for(int jj=0; jj<nn; jj++)
    {
        index = ibuf[jj];
        hItem = (PB_ITEMHANDLE)lst2->GetItemData(index);
        if(bAdd)
        {
            m_err = PB_AddItemToGroup(m_hDB, hGroup, hItem);
        }
        else
        {
            PB_ERRORS tmp_err = PB_DeleteItemFromGroup(m_hDB, hGroup, hItem);
                        if(bShowGroupContent)
                                PEUpdateList2(0);
                        m_err = tmp_err;
        }
        if(m_err)
        {
            PEDispError();
            break;
        }
    }
    delete ibuf;
}

/*>>>>>>>>>>>>>  IMPORT functions            <<<<<<<<<<<<<<<<< */

BOOL CPhbookEdit::xPEImportBuf(LPSTR buf, CPBPos *dlg)
{
    PB_ITEMREC data;
        int miss_count = 0;

    _fmemset(&data, 0, sizeof(data));

        if(!dlg->LoadRecords(buf))
                return(TRUE);

        if(pos_name != -1)
        {
                if(pos_name>dlg->c_field || dlg->fields[pos_name][0]=='\0')
                {
                        dlg->missing_fields++;
                        miss_count++;
                }
                else
                {
                        if(lstrlen(dlg->fields[pos_name])>30)
                        {
                                dlg->truncated_fields++;
                                dlg->fields[pos_name][30] = '\0';
                        }
                        lstrcpy(data.szName, dlg->fields[pos_name]);
                }
        }
        else
                miss_count++;
        if(pos_company != -1)
        {
                if(pos_company>dlg->c_field || dlg->fields[pos_company][0]=='\0')
                {
                        dlg->missing_fields++;
                        miss_count++;
                }
                else
                {
                        if(lstrlen(dlg->fields[pos_company])>30)
                        {
                                dlg->truncated_fields++;
                                dlg->fields[pos_company][30] = '\0';
                        }
                        lstrcpy(data.szCompanyName, dlg->fields[pos_company]);
                }
        }
        else
                miss_count++;
        if(pos_tel != -1)
        {
                if(pos_tel>dlg->c_field || dlg->fields[pos_tel][0]=='\0')
                {
                        dlg->missing_fields++;
                        miss_count++;
                }
                else
                        lstrcpy(data.szPhoneNum, dlg->fields[pos_tel]);
        }
        else
                miss_count++;

        if(miss_count==3)
        {
                return TRUE;
        }
        else
        {
                BOOL bOK = TestPhoneNumber(data.szPhoneNum);
                if(bOK==FALSE)
                {
                        UINT sel = AfxMessageBox("The phone number is not valid.\nWould you like to continue?", MB_YESNO | MB_ICONQUESTION);
                        if(sel==IDNO)
                        {
                                user_not_cont = TRUE;
                                return FALSE;
                        }
                        CPhbookPerson dlg;
                        PESetToCtrl(&data, &dlg, "Edit Imported Person");
                        dlg.tel_edit = TRUE;
                        int nret = dlg.DoModal();
                        if(nret==IDOK)
                        {
                                PEGetFromCtrl(&data, &dlg);
                        }
                        else
                        {
                                AfxMessageBox("Phone number was not recorded into the phonebook.");
                                data.szPhoneNum[0] = '\0';
                                miss_count++;
                        }
                }

                if(miss_count<3)
                {
                        PB_ITEMHANDLE hItem;

                        hItem = PB_AddItem(m_hDB, &data, &m_err);
                        if(m_err)
                        {
                                PEDispError();
                                return FALSE;
                        }
                }
                return TRUE;
        }
}

static CPBPos dlg;

void CPhbookEdit::PEImport()
{
    CString fname;
    BOOL bOK;
    char *lpTextFile;

    if( PETestExist1()==FALSE )
        return;

    bOK = PEPromptTextFile(fname, TRUE, "Phonebook Import");
    if(bOK==FALSE)
        return;

    int ln = fname.GetLength();
    lpTextFile = fname.GetBuffer(ln+2);

    if(m_hDB)
    {
        PB_ClosePhoneBook(m_hDB);
        m_hDB = NULL;
    }
    m_hDB = PB_OpenPhoneBook(pbook_fname, &m_err);
    if(m_err)
    {
        PEDispError();
        return;
    }

        dlg.empty_records = 0;
        dlg.truncated_fields = 0;
        dlg.missing_fields = 0;
        user_not_cont = FALSE;
        
        char buf[1000];

        ifstream is(lpTextFile);
		    	
        do
        {
                is.getline(buf, sizeof(buf)-2);
                if( is.bad() )
                {
                        AfxMessageBox("Error during reading Import File.");
                        return;
                }
                bOK = dlg.LoadRecords(buf);
        } while(!bOK && !is.eof());
    
        if(!bOK && is.eof())
        {
                AfxMessageBox("Only empty records found.");
                return;
        }
    
        int nret = dlg.DoModal();
    if(nret!=IDOK)
        return;
                
        char pos_buf[5];        
        if(dlg.bCustom)
        {
                
                lstrcpyn( pos_buf, dlg.m_name.GetBuffer(4), 3);
                pos_name = atoi(pos_buf)-1;

                lstrcpyn( pos_buf, dlg.m_company.GetBuffer(4), 3);
                pos_company = atoi(pos_buf)-1;

                lstrcpyn( pos_buf, dlg.m_tel.GetBuffer(4), 3);
                pos_tel = atoi(pos_buf)-1;
        }
        else
        {
                pos_name = 0;
                pos_company = 1;
                pos_tel = 2;
        }
     
    for(;;)
    {
        bOK = xPEImportBuf(buf, &dlg);
        if(bOK==FALSE || is.eof())
            break;

                is.getline(buf, sizeof(buf)-2);

                if( is.bad() )
       {
                        bOK = FALSE;
                AfxMessageBox("Error during reading Import File.");
            break;
       }
    }
 
        // Printing import statistics
        char stat_buf[200];
        sprintf(stat_buf, "Empty records: %d\nMissing fields: %d\nTruncated fields: %d             \n", dlg.empty_records, dlg.missing_fields, dlg.truncated_fields);
        if(user_not_cont)
                lstrcat(stat_buf,"\nImport process terminated by user.             ");
        else if(!bOK)
                lstrcat(stat_buf,"\nImport process terminated by an error.             ");
        MessageBox(stat_buf,"Import Statistics",MB_ICONINFORMATION);

//  destructor close PB
}

/*>>>>>>>>>>>>>  EXPORT functions          <<<<<<<<<<<<<<<<< */

void CPhbookEdit::PEExport()
{
    CString fname;
    BOOL bOK;
    LPSTR lpTextFile = NULL;

    if( PETestExist2()==FALSE )
    {
        return;
    }

    bOK = PEPromptTextFile(fname, FALSE, "Phonebook Export");
    if(bOK==FALSE)
    {
        return;
    }

    int ln = fname.GetLength();
    lpTextFile = fname.GetBuffer(ln+2);
    if(strchr(lpTextFile,'.')==NULL)
        {
                strcat(lpTextFile,".txt");
                fname.ReleaseBuffer();
                lpTextFile = fname.GetBuffer(ln+2);
        }


    if(m_hDB)
    {
        PB_ClosePhoneBook(m_hDB);
        m_hDB = NULL;
    }

    m_hDB = PB_OpenPhoneBook(pbook_fname, &m_err);
    if(m_err)
    {
        PEDispError();
        return;
    }

    if(m_os)
    {
        delete m_os;
        m_os = NULL;
    }

    m_os = new ofstream(lpTextFile);

    PB_EnumItemsInDB(m_hDB, DOWN, 0l, PESavePerson, this);

//  destructor delete m_os and close PB
};

/*>>>>>>>>>>>>>  COMMON DLG for EXPORT and IMPORT       <<<<<<<<<<<<<<<<< */

BOOL CPhbookEdit::PEPromptTextFile(CString &fileName, BOOL bOpen, LPSTR lpTitle)
{
    int dlgret;
    BOOL bOK;
    static char lpFilter[] = 
        "ASCII Files (*.txt)\0*.txt\0"
        "All Files (*.*)\0*.*\0";

    CFileDialog *dlgFile = new CFileDialog(bOpen);

    dlgFile->m_ofn.nFilterIndex = 0;
    dlgFile->m_ofn.lpstrFilter = lpFilter;
    dlgFile->m_ofn.hwndOwner = AfxGetApp()->m_pMainWnd->GetSafeHwnd();
    dlgFile->m_ofn.lpstrTitle = lpTitle;
    dlgFile->m_ofn.lpstrFile = fileName.GetBuffer(_MAX_PATH);
    dlgFile->m_ofn.Flags &= ~OFN_SHOWHELP;

    dlgret = dlgFile->DoModal();

    bOK = (dlgret==IDOK) ? TRUE : FALSE;
    delete dlgFile;
    fileName.ReleaseBuffer();

    return bOK;
}

/*>>>>>>>>>>>>>  CALLBACK functions            <<<<<<<<<<<<<<<<< */

/*  static member function   Fill the person list box */
BOOL _export FAR PASCAL CPhbookEdit::PEFillPerson(PB_ITEMHANDLE hItem, LPVOID lpPar)
{
    PB_ERRORS  err;
    PB_ITEMREC data;
    CPhbookEdit FAR *cb = (CPhbookEdit FAR *)lpPar;    /* this pointer */

        if(hItem==NULL)
        {
                return TRUE;
        }

    err = PB_GetItem(cb->m_hDB, hItem, &data);
    if(err)
    {
        return FALSE;
    }

    cb->PEAddPersonList(&data, hItem, FALSE);
    return TRUE;
}

/*  static member function   Show items in group */
BOOL _export FAR PASCAL CPhbookEdit::PEItemsInGroup(PB_ITEMHANDLE hItem, LPVOID lpPar)
{
    CPhbookEdit FAR *cb = (CPhbookEdit FAR *)lpPar;    /* this pointer */

    CListBox *lst2 = (CListBox *)cb->GetDlgItem(IDC_LIST2);
    if(lst2==NULL)
        return FALSE;

    if(PEFillPerson(hItem, lpPar))
                return TRUE;
        else
                return FALSE;
}

/*  static member function   Fill the group list box */
BOOL _export FAR PASCAL CPhbookEdit::PEFillGroup(PB_GROUPHANDLE hGroup, LPVOID lpPar)
{
    PB_ERRORS  err;
    PB_GROUPNAME grpname;
    CPhbookEdit FAR *cb = (CPhbookEdit FAR *)lpPar;    /* this pointer */

    err = PB_GetGroupName(cb->m_hDB, hGroup, grpname);
    if(err)
    {
        return FALSE;
    }

    cb->PEAddGroupList(&grpname, hGroup, FALSE);
    return TRUE;
}

/*  static member function   for EXPORT */
BOOL _export FAR PASCAL CPhbookEdit::PESavePerson(PB_ITEMHANDLE hItem, LPVOID lpPar)
{
    PB_ERRORS  err;
    PB_ITEMREC data;
    CPhbookEdit FAR *cb = (CPhbookEdit FAR *)lpPar;    /* this pointer */

    err = PB_GetItem(cb->m_hDB, hItem, &data);
    if(err)
    {
        return FALSE;
    }

    if(cb->m_os)
    {
        *cb->m_os << '"' << data.szName        << '"' << ","
                  << '"' << data.szCompanyName << '"' << ","
                  << '"' << data.szPhoneNum    << '"' << "\n";
    }

    return TRUE;
}



BOOL CPhbookGroup::OnInitDialog()
{
        CDialog::OnInitDialog();

        // TODO: Add extra initialization here

        ((CEdit *)GetDlgItem(IDC_EDIT))->LimitText(30);

        return TRUE;  // return TRUE  unless you set the focus to a control
}

BOOL CPhbookSearch::OnInitDialog()
{
        CDialog::OnInitDialog();

        // TODO: Add extra initialization here

        ((CEdit *)GetDlgItem(IDC_EDIT))->LimitText(30);

        if(bCompany)
                GetDlgItem(IDC_TEXT1)->SetWindowText("Company &name");
        else
                GetDlgItem(IDC_TEXT1)->SetWindowText("&Person");

        return TRUE;  // return TRUE  unless you set the focus to a control
}

