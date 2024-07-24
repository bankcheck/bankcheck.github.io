// PBPos.cpp : implementation file
//

#include "stdafx.h"
//#include "fstream.h"

#include <direct.h>

extern "C" {
	#include "bitiff.h"
    #include	"pbook.h"
};
#include "resource.h"
#include "faxcpp.h"        
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

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPBPos dialog


CPBPos::CPBPos(CWnd* pParent /*=NULL*/)
	: CDialog(CPBPos::IDD, pParent)
{
	//{{AFX_DATA_INIT(CPBPos)
	m_company = _T("");
	m_name = _T("");
	m_tel = _T("");
	//}}AFX_DATA_INIT
}


void CPBPos::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPBPos)
	DDX_Text(pDX, IDC_COMPANY, m_company);
	DDX_Text(pDX, IDC_NAME, m_name);
	DDX_Text(pDX, IDC_TEL, m_tel);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CPBPos, CDialog)
	//{{AFX_MSG_MAP(CPBPos)
	ON_BN_CLICKED(IDC_CUSTOM, OnCustom)
	ON_BN_CLICKED(IDC_DEFAULT, OnDefault)
	ON_BN_CLICKED(IDC_CHECK1, OnCheck1)
	ON_LBN_SELCHANGE(IDC_LIST1, OnSelchangeList1)
	ON_BN_CLICKED(IDC_BUTTON1, OnButton1)
	ON_BN_CLICKED(IDC_BUTTON2, OnButton2)
	ON_BN_CLICKED(IDC_BUTTON3, OnButton3)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPBPos message handlers


BOOL CPBPos::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	// TODO: Add extra initialization here
	CheckRadioButton(IDC_CUSTOM,IDC_DEFAULT,IDC_DEFAULT);
	((CEdit *)GetDlgItem(IDC_NAME))->LimitText(3);
	((CEdit *)GetDlgItem(IDC_COMPANY))->LimitText(3);
	((CEdit *)GetDlgItem(IDC_TEL))->LimitText(3);
	bItemsInListbox = FALSE;

	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CPBPos::OnCustom() 
{
	// TODO: Add your control notification handler code here
	GetDlgItem(IDC_NAME)->EnableWindow(TRUE);
	GetDlgItem(IDC_COMPANY)->EnableWindow(TRUE);
	GetDlgItem(IDC_TEL)->EnableWindow(TRUE);

	GetDlgItem(IDC_CHECK1)->EnableWindow(TRUE);

	OnCheck1();
}

void CPBPos::OnDefault() 
{
	// TODO: Add your control notification handler code here
	GetDlgItem(IDC_NAME)->EnableWindow(FALSE);
	GetDlgItem(IDC_COMPANY)->EnableWindow(FALSE);
	GetDlgItem(IDC_TEL)->EnableWindow(FALSE);

	GetDlgItem(IDC_CHECK1)->EnableWindow(FALSE);

	GetDlgItem(IDC_BUTTON1)->EnableWindow(FALSE);
	GetDlgItem(IDC_BUTTON2)->EnableWindow(FALSE);
	GetDlgItem(IDC_BUTTON3)->EnableWindow(FALSE);

	GetDlgItem(IDC_LIST1)->EnableWindow(FALSE);
	((CListBox *)GetDlgItem(IDC_LIST1))->SetCurSel(-1);
}

BOOL CPBPos::TestPositionNumber(CEdit *lpBoxNumber, int *conv_buf)
{
	char buf[5];		
	lpBoxNumber->GetWindowText( buf, sizeof(buf) );
	
	int ii = _fstrspn(buf, "0123456789");
	int ln = lstrlen(buf);
	if(ii<ln)
	{
		AfxMessageBox("Only numbers allowed!");
		lpBoxNumber->SetFocus();
		return FALSE;
	}
	else if(!ln)
	{
		AfxMessageBox("You must specify the position!");
		lpBoxNumber->SetFocus();
		return FALSE;
	}
	*conv_buf = atoi(buf);
	return TRUE;
}

void CPBPos::OnOK() 
{
	// TODO: Add extra validation here
	CEdit *wedit1;
	CEdit *wedit2;
	CEdit *wedit3;
	int tmp_name;		// because 1 = 01 = 001 and so on for 2,3...
	int tmp_company;
	int tmp_tel;

	if(GetCheckedRadioButton(IDC_CUSTOM,IDC_DEFAULT)==IDC_CUSTOM)
	{
		wedit1 = (CEdit *)GetDlgItem(IDC_NAME);
		if(TestPositionNumber(wedit1, &tmp_name))
		{
			wedit2 = (CEdit *)GetDlgItem(IDC_COMPANY);
			if(TestPositionNumber(wedit2, &tmp_company))
			{
				wedit3 = (CEdit *)GetDlgItem(IDC_TEL);
				if(TestPositionNumber(wedit3, &tmp_tel))
				{
					if(tmp_name==tmp_company || tmp_name==tmp_tel)
					{
						AfxMessageBox("Multiplicated field positions!");
						wedit1->SetFocus();
					}
					else if(tmp_company==tmp_tel)
					{
						AfxMessageBox("Multiplicated field positions!");
						wedit2->SetFocus();
					}
					else
					{
						bCustom = TRUE;
						CDialog::OnOK();
					}
				}
			}
		}
	}
	else
	{
		bCustom = FALSE;
		CDialog::OnOK();
	}
}

void CPBPos::OnCheck1() 
{
	// TODO: Add your control notification handler code here
#ifdef WIN32	
	if(GetDlgItem(IDC_CHECK1)->SendMessage(BM_GETCHECK)!=BST_CHECKED)
#else
	if(GetDlgItem(IDC_CHECK1)->SendMessage(BM_GETCHECK)!=1)	
#endif	
	{
		GetDlgItem(IDC_BUTTON1)->EnableWindow(FALSE);
		GetDlgItem(IDC_BUTTON2)->EnableWindow(FALSE);
		GetDlgItem(IDC_BUTTON3)->EnableWindow(FALSE);

		GetDlgItem(IDC_LIST1)->EnableWindow(FALSE);
		((CListBox *)GetDlgItem(IDC_LIST1))->SetCurSel(-1);
	}
	else
	{
		GetDlgItem(IDC_LIST1)->EnableWindow(TRUE);

		if(!bItemsInListbox)
		{
			CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
			int ii;

			lst1->AddString("[NONE]");
			for(ii=0;ii<c_field;ii++)
			{
				if(fields[ii][0]!='\0')
					lst1->AddString(fields[ii]);
				else
					lst1->AddString("[EMPTY]");
			}
			bItemsInListbox = TRUE;
		}
	}
}

BOOL CPBPos::LoadRecords(LPSTR buf)
{
	int ii;
	int f_pos = 0;
	int c_char = 0;

	c_field = 0;

	for(ii=0;ii<MAX_FIELD;ii++)
		fields[ii][0] = '\0';

	if(buf[0]=='\0')
	{
		empty_records++;
		return FALSE;
	}
	while(buf[f_pos]!='\0')
	{
		while(buf[f_pos]==' ' || buf[f_pos]=='\t')
			f_pos++;
		if(buf[f_pos]==',')
		{
			if(c_char==0)
			{
				fields[c_field][c_char] = '\0';
				c_field++;
			}
			else
				c_char=0;
			f_pos++;
		}

		if(c_field>999)
			break;

		if(buf[f_pos]=='"')
		{
			f_pos++;
			c_char = 0;
			while(buf[f_pos]!='"' && buf[f_pos]!='\0' && c_char<MAX_WORD-1)
			{
				fields[c_field][c_char] = buf[f_pos];
				f_pos++;
				c_char++;
			}
			if(c_char==MAX_WORD-1)
			{
				truncated_fields++;
				while(buf[f_pos]!='"' && buf[f_pos]!='\0')
					f_pos++;
			}
			fields[c_field][c_char] = '\0';
			c_field++;
			c_char++;		// for ""
			if(buf[f_pos]!='\0')
				f_pos++;
			continue;
		}

		if(c_field>999)
			break;

		if(buf[f_pos]!='"' && buf[f_pos]!='\0')
		{
			c_char = 0;
			while(buf[f_pos]!=' ' && buf[f_pos]!='\t' && buf[f_pos]!=',' && buf[f_pos]!='\0' && c_char<MAX_WORD-1)
			{
				fields[c_field][c_char] = buf[f_pos];
				f_pos++;
				c_char++;
			}
			if(c_char==MAX_WORD-1)
			{
				truncated_fields++;
				while(buf[f_pos]!=' ' && buf[f_pos]!='\t' && buf[f_pos]!=',' && buf[f_pos]!='\0')
					f_pos++;
			}
			fields[c_field][c_char] = '\0';
			c_field++;
			c_char++;		// for ""
			if(buf[f_pos]!='\0')
				f_pos++;
		}

		if(c_field>999)
			break;
	}

	return TRUE;
}

void CPBPos::OnSelchangeList1() 
{
	// TODO: Add your control notification handler code here
	CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
	
	if(lst1->GetCurSel()>=0)
	{
		GetDlgItem(IDC_BUTTON1)->EnableWindow(TRUE);
		GetDlgItem(IDC_BUTTON2)->EnableWindow(TRUE);
		GetDlgItem(IDC_BUTTON3)->EnableWindow(TRUE);
	}
	else
	{
		GetDlgItem(IDC_BUTTON1)->EnableWindow(FALSE);
		GetDlgItem(IDC_BUTTON2)->EnableWindow(FALSE);
		GetDlgItem(IDC_BUTTON3)->EnableWindow(FALSE);
	}
}

void CPBPos::OnButton1() 
{
	// TODO: Add your control notification handler code here
	CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
	int index = lst1->GetCurSel();
    if(index < 0)
        return;

	char tmp_buf[5];
	itoa(index,tmp_buf,10);

	GetDlgItem(IDC_NAME)->SetWindowText(tmp_buf);
}

void CPBPos::OnButton2() 
{
	// TODO: Add your control notification handler code here
	CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
	int index = lst1->GetCurSel();
    if(index < 0)
        return;

	char tmp_buf[5];
	itoa(index,tmp_buf,10);

	GetDlgItem(IDC_COMPANY)->SetWindowText(tmp_buf);
}

void CPBPos::OnButton3() 
{
	// TODO: Add your control notification handler code here
	CListBox *lst1 = (CListBox *)GetDlgItem(IDC_LIST1);
	int index = lst1->GetCurSel();
    if(index < 0)
        return;

	char tmp_buf[5];
	itoa(index,tmp_buf,10);

	GetDlgItem(IDC_TEL)->SetWindowText(tmp_buf);
}
