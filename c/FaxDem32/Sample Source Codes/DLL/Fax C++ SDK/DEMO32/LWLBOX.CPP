// LWLBox.cpp : implementation file
//

#include "stdafx.h"
#include "limits.h"

#include "port32.h"
#include "v_config.h"
#include "LWLBox.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CLWListBox

CLWListBox::CLWListBox()
{
}

CLWListBox::~CLWListBox()
{
}


BEGIN_MESSAGE_MAP(CLWListBox, CListBox)
	//{{AFX_MSG_MAP(CLWListBox)
		// NOTE - the ClassWizard will add and remove mapping macros here.
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CLWListBox message handlers

void CLWListBox::DrawItem(LPDRAWITEMSTRUCT lpDrawItemStruct) 
{
	// TODO: Add your code to draw the specified item
	CDC     DC;
    int     y= lpDrawItemStruct->rcItem.top;

    DC.Attach(lpDrawItemStruct->hDC);

    CBrush br(DC.GetBkColor());
    DC.FillRect(&lpDrawItemStruct->rcItem, &br);
        
	int lastMode= DC.SetBkMode (TRANSPARENT);

    if (lpDrawItemStruct->itemState & ODS_SELECTED) 
	{
        CBrush br(RGB(0, 0xFF, 0));
        DC.FillRect(&lpDrawItemStruct->rcItem, &br);
        DC.DrawFocusRect(&lpDrawItemStruct->rcItem);
    }

    DC.SetBkMode (lastMode);

	if (lpDrawItemStruct->itemData != NULL && lpDrawItemStruct->itemData != DWORD(-1)) 
	{
        int nWidth = lpDrawItemStruct->itemData ;
        char Data[10];
		CRect	rc;
        CPen    pen( PS_SOLID, nWidth, RGB(0,0,0));
        CPen * oldPen;
        oldPen = DC.SelectObject( &pen );
        rc = lpDrawItemStruct->rcItem;
        DC.MoveTo( rc.left, (rc.top + rc.bottom)/2 );
        DC.LineTo( rc.right, (rc.top + rc.bottom)/2 );
        sprintf(Data,"%3d point ", nWidth );
    	DC.DrawText( Data, -1, &rc, DT_CENTER | DT_VCENTER );
        DC.SelectObject( oldPen );
    }
    DC.Detach();
}

int CLWListBox::CompareItem(LPCOMPAREITEMSTRUCT ) 
{
	// TODO: Add your code to determine the sorting order of the specified items
	// return -1 = item 1 sorts before item 2
	// return 0 = item 1 and item 2 sort the same
	// return 1 = item 1 sorts after item 2
	
	return 0;
}

void CLWListBox::MeasureItem(LPMEASUREITEMSTRUCT ) 
{
	// TODO: Add your code to determine the size of specified item
	
}
