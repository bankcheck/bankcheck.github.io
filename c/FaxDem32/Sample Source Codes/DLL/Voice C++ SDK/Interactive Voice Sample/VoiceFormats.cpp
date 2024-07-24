// VoiceFormats.cpp : implementation file
//

#include "stdafx.h"
#include "interactive voice sample.h"
#include "VoiceFormats.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CVoiceFormats dialog


CVoiceFormats::CVoiceFormats(CWnd* pParent /*=NULL*/)
	: CDialog(CVoiceFormats::IDD, pParent)
{
	//{{AFX_DATA_INIT(CVoiceFormats)
	m_szVoiceFormats = _T("");
	//}}AFX_DATA_INIT
}


void CVoiceFormats::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CVoiceFormats)
	DDX_Text(pDX, IDC_VOICEFORMATS, m_szVoiceFormats);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CVoiceFormats, CDialog)
	//{{AFX_MSG_MAP(CVoiceFormats)
		// NOTE: the ClassWizard will add message map macros here
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CVoiceFormats message handlers
