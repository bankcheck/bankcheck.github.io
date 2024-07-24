#include	"stdafx.h"
#pragma hdrstop

#include	"holmes.h"

TCHolmes Holmes("VMS");
BOOL	bDebugEnabled = GetProfileInt("BlackIce","VMS", 0);

TCHolmes::TCHolmes()
{
	hDebugFree = CreateEvent(NULL,FALSE,TRUE,NULL);
}

TCHolmes::TCHolmes(const char *pszID)
{
	hDebugFree = CreateEvent(NULL,FALSE,TRUE,NULL);
	if( pszID )
	{
		strncpy( szID, pszID, ID_LEN);
		szID[ID_LEN-1] = 0;
	}
	else
	{
		*szID = 0;
	}
}

TCHolmes::~TCHolmes()
{ 
	if( hDebugFree )
	{
		WaitForSingleObject(hDebugFree,INFINITE);
		CloseHandle( hDebugFree );
	}
}

void	TCHolmes::SetID(const char *pszID)
{
	if( pszID )
	{
		strncpy( szID, pszID, ID_LEN);
		szID[ID_LEN-1] = 0;
	}
	else
	{
		*szID = 0;
	}
}

