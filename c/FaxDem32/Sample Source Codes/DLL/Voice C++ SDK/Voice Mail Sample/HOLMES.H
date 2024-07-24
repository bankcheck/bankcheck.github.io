#ifndef	HOLMES_INCLUDED
#define	HOLMES_INCLUDED

#include	<stdio.h>
#include	<stdarg.h>

#define	MAX_BUFFER_LEN	1024
#define	ID_LEN			20

extern BOOL bDebugEnabled;

class	TCHolmes
{
public:
	TCHolmes();
	TCHolmes(const char *pszID);
	~TCHolmes();

	void	SetID(const char *pszID);
	inline void	DebugMsg(const char *pszFormat, ... );

protected:
	inline void	OutputDebugString();

	char	szDebugFile[MAX_PATH];
	char	szDebugBuffer[MAX_BUFFER_LEN];
	char	szID[ID_LEN];

	HANDLE	hDebugFree;
};

extern TCHolmes Holmes;
#define	DEBUGMSG Holmes.DebugMsg

inline void	TCHolmes::DebugMsg(const char *pszFormat, ... )
{
	if( bDebugEnabled )
	{
	va_list	pArg;

		WaitForSingleObject(hDebugFree,INFINITE);

		va_start(pArg,pszFormat);
		vsprintf( szDebugBuffer, pszFormat, pArg);
		OutputDebugString();
		va_end(pArg);

		SetEvent(hDebugFree);
	}
}

inline void	TCHolmes::OutputDebugString()
{
	::OutputDebugString(szID);
	::OutputDebugString(" - ");
	::OutputDebugString(szDebugBuffer);
	::OutputDebugString("\n");
}

#endif