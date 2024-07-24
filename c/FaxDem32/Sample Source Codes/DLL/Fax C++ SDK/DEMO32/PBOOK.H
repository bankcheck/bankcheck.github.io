/****************************************************************************/
/*            (c) Copyright Black Ice Software Inc.  1992.                  */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/****************************************************************************/

/****************************************************************************/
/*																			*/
/*		Modul : PBOOK.H														*/
/*																			*/
/*		Function :															*/
/*			External definitions of Phonebook DLL		 					*/
/*																			*/
/*		Written by Fily¢ Zolt n												*/
/*																			*/
/*		Last modified : 1992.08.26.											*/
/*																			*/
/****************************************************************************/

#ifndef PBOOK_H
#define PBOOK_H

#define PB_NAMELEN		32
#define PB_PHONENRLEN	64
#define PB_COMPNAMELEN	32

typedef enum {
	PB_NOERROR,
	PB_IOERROR,
	PB_NOMEMORY,
	PB_OUTOFDISK
} PB_ERRORS;
typedef PB_ERRORS FAR * PB_LPERRORS;

typedef enum {
	UP,
	DOWN
} PB_DIRECTION;

typedef HANDLE PB_DBHANDLE;
typedef DWORD PB_ITEMHANDLE;
typedef DWORD PB_GROUPHANDLE;

typedef PB_ITEMHANDLE FAR * PB_LPITEMHANDLE;

typedef char PB_PERSONNAME [PB_NAMELEN];
typedef char PB_PHONENUMBER [PB_PHONENRLEN];
typedef char PB_COMPANYNAME [PB_COMPNAMELEN];
typedef char PB_GROUPNAME [PB_NAMELEN];

typedef PB_GROUPNAME FAR * PB_LPGROUPNAME;

typedef struct {
	PB_PERSONNAME szName;
	PB_COMPANYNAME szCompanyName;
	PB_PHONENUMBER szPhoneNum;
} PB_ITEMREC;
typedef PB_ITEMREC FAR * PB_LPITEMREC;

typedef BOOL FAR PASCAL PB_ENUMGROUPFUNC (PB_GROUPHANDLE, LPVOID);
typedef BOOL FAR PASCAL PB_ENUMITEMFUNC (PB_ITEMHANDLE, LPVOID);

typedef PB_ENUMITEMFUNC FAR * PB_LPENUMITEMFUNC;
typedef PB_ENUMGROUPFUNC FAR * PB_LPENUMGROUPFUNC;

BOOL FAR PASCAL PB_PhoneBookExists (LPSTR lpszFileName);
PB_ERRORS FAR PASCAL PB_CreatePhoneBook (LPSTR lpszFileName);
PB_DBHANDLE FAR PASCAL PB_OpenPhoneBook (LPSTR, PB_LPERRORS);
PB_ERRORS FAR PASCAL PB_ClosePhoneBook (PB_DBHANDLE);

PB_ITEMHANDLE FAR PASCAL PB_AddItem (PB_DBHANDLE, PB_LPITEMREC,   PB_LPERRORS);
PB_ERRORS FAR PASCAL PB_ModifyItem (PB_DBHANDLE, PB_ITEMHANDLE, PB_LPITEMREC);
PB_ERRORS FAR PASCAL PB_DeleteItem (PB_DBHANDLE, PB_ITEMHANDLE);
PB_ERRORS FAR PASCAL PB_GetItem (PB_DBHANDLE, PB_ITEMHANDLE, PB_LPITEMREC);

PB_GROUPHANDLE FAR PASCAL PB_CreateGroup (PB_DBHANDLE, PB_LPGROUPNAME, PB_LPERRORS);
PB_ERRORS FAR PASCAL PB_DeleteGroup (PB_DBHANDLE, PB_GROUPHANDLE);
PB_ERRORS FAR PASCAL PB_AddItemToGroup (PB_DBHANDLE, PB_GROUPHANDLE, PB_ITEMHANDLE);
PB_ERRORS FAR PASCAL PB_DeleteItemFromGroup (PB_DBHANDLE, PB_GROUPHANDLE,
PB_ITEMHANDLE);
PB_ERRORS FAR PASCAL PB_GetGroupName (PB_DBHANDLE, PB_GROUPHANDLE, LPSTR);

PB_ERRORS FAR PASCAL PB_EnumItemsInDB (PB_DBHANDLE, PB_DIRECTION,
PB_ITEMHANDLE, PB_LPENUMITEMFUNC, LPVOID);
PB_ERRORS FAR PASCAL PB_EnumGroupsInDB (PB_DBHANDLE, PB_DIRECTION,
PB_GROUPHANDLE, PB_LPENUMGROUPFUNC, LPVOID);
PB_ERRORS FAR PASCAL PB_EnumItemsInGroup (PB_DBHANDLE, PB_GROUPHANDLE,
	PB_DIRECTION, PB_ITEMHANDLE, PB_LPENUMITEMFUNC, LPVOID);
	
#endif
