/****************************************************************************/
/*            (c) Copyright Black Ice Software Inc.  1996.                  */
/*                   All Rights Reserved                                    */
/*                   Unpublished and confidential material.                 */
/*                   --- Do not Reproduce or Disclose ---                   */
/*                                                                          */
/****************************************************************************/
#ifndef __QUEUE_H
#define __QUEUE_H
//****************************************************************************
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Include
#include "port32.h"
#ifdef _VISUALC7
#include <fstream>
using namespace std;
#endif
#ifdef _VISUALC8
#include <fstream>
#else
#include <fstream.h>
#endif

#include "faxtype.h"
#include "globerr.h"

#pragma pack(4)

//****************************************************************************
class far TCQueue;
typedef TCQueue far * PTCQueue;

class far TCQueueItem;
typedef TCQueueItem far * PTCQueueItem;

//---------------------------------------------------------------------------
class FAXAPI TCQueueItem 
{
friend TCQueue;
public:
    //-------------------------------------------------------------
    EXPDEF  TCQueueItem ();
    virtual EXPDEF ~TCQueueItem();

    virtual void EXPDEF ChainInItem (PTCQueueItem BeforeObj, TCQueue far *QueueObj=NULL);
    virtual void EXPDEF ChainOutItem();

    virtual PTCQueueItem  EXPDEF GetPrevItem() {return Before;};
    virtual PTCQueueItem  EXPDEF GetNextItem() {return Next;};
    virtual TCQueue far * EXPDEF GetQueueForItem(){return Queue;};

    virtual char EXPDEF    GetFaxType () = 0;
	
	// Priority handling
	DWORD	GetPriority(void) { return m_dwPriority;};
	void	SetPriority(DWORD dwPriority); 


protected:
	void SetQueue(PTCQueue pQueue){Queue=pQueue;}
    PTCQueueItem Before;
    PTCQueueItem Next;
    PTCQueue     Queue;
	DWORD		 m_dwPriority;	//EA the item's priority in the queue
};

//****************************************************************************
// TCQueue Class
class FAXAPI far TCQueue
{
public:
    EXPDEF TCQueue (int Type);
    virtual EXPDEF ~TCQueue ();

    int          EXPDEF  GetQueueType() {return QueueType;}
    virtual int  EXPDEF  GetItemNumber () {return ItemNumber;}

    virtual void EXPDEF  ChainInFirst (PTCQueueItem Item);
    virtual void EXPDEF  ChainInEnd   (PTCQueueItem Item);
	virtual void EXPDEF  ChainInItem  (PTCQueueItem pBeforeObj, PTCQueueItem pItem);
	virtual void EXPDEF  ChainInItemByPriority(PTCQueueItem pItem);
	virtual void EXPDEF  ChainOutItem (PTCQueueItem pItem);

    PTCQueueItem EXPDEF   GetFirstItem();
    PTCQueueItem EXPDEF   GetEndItem();

    PTCQueueItem EXPDEF   ChainOutFirstItem();
    static void  EXPDEF    RegistEvent (ProcEvent lpProc);

	void DumpQueue(LPCSTR szName);
protected:
    int QueueType;

private:
    PTCQueueItem First;
    PTCQueueItem End;
    int     ItemNumber;
    static ProcEvent   farProcEvent;
    //#ifdef  _THREAD
    HANDLE      hMutex ;
    //#endif
};
//*****************************************************************************
#ifdef __cplusplus
extern "C" {
#endif

FAXAPI void far EXPDEF SetAllQueues(PTCQueue pSendQueue, PTCQueue pReceiveQueue);
FAXAPI PTCQueue EXPDEF GetSendQueue();
FAXAPI PTCQueue EXPDEF GetReceiveQueue();

#ifdef __cplusplus
}
#endif
//*****************************************************************************
#pragma pack()
#endif  // __QUEUE_H
 
