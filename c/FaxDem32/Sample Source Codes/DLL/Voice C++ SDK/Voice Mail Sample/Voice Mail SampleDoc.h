// Voice Mail SampleDoc.h : interface of the CVoiceMailSampleDoc class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_VOICEMAILSAMPLEDOC_H__D4F3B00E_1CB1_11D3_AFB3_0040F614A5A0__INCLUDED_)
#define AFX_VOICEMAILSAMPLEDOC_H__D4F3B00E_1CB1_11D3_AFB3_0040F614A5A0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000


class CVoiceMailSampleDoc : public CDocument
{
    enum{vsd_RING,
         vsd_ANSWER,
         vsd_GREETING,
         vsd_RECORD,
         vsd_RECEIVE,
         vsd_SENDFAX,
         vsd_DISCONNECT,
         vsd_REINIT
    };

    enum{rec_SWITCH,
         rec_CONNECT,
         rec_RECEIVING,
         rec_RETURN
    };

    enum{snd_SWITCH,
         snd_CONNECT,
         snd_SENDING,
         snd_RETURN
    };

protected: 
	CVoiceMailSampleDoc();
	DECLARE_DYNCREATE(CVoiceMailSampleDoc)

// Attributes
public:
    inline  MODEMOBJ  GetModem()const{ return m_Modem; };
            void      SetModem(MODEMOBJ modem);
// Operations
public:
    void    OnVoiceMsg(int event);
    void    OnWaitForRings(int event);
    void    OnAnswer(int event);
    void    OnPlayGreetingMessage(int event);
    void    OnRecordMessage(int event);
    void    OnReceiveFax(int event);
    void    OnSendFax(int event);
    void    OnDisconnect(int event);
    void    OnReInitialize(int event);

    void    OnFaxReceived(FAXOBJ faxObj);

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CVoiceMailSampleDoc)
	public:
	virtual BOOL OnNewDocument();
	virtual void Serialize(CArchive& ar);
	virtual void OnCloseDocument();
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CVoiceMailSampleDoc();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:
    void    PlayMessage(int status,int time = 0,int digits = 1);
    void    RecordMessage();
    void    ReceiveFax();
    void    SendFax();
    void    Disconnect();
    void    ReInitializePort();
    void    Return2Voice();

    // receive fax functions
    void    OnReceiveSwitch(int event);
    void    OnReceiveConnect(int event);
    void    OnReceivingFax(int event);
    void    OnReturn2Voice(int event);

    void    OnSendSwitch(int event);
    void    OnSendConnect(int event);
    void    OnSendingFax(int event);

    inline  LPCSTR  GetVoiceFileName()const{ return m_szVocFile; };
            void    SetVoiceFileName(LPCSTR lpszVoc);

    void    StatusMsg(LPCSTR msg,...);

    MODEMOBJ    m_Modem;
    int         m_nPrStatus;
    int         m_nSubStatus;
    char        m_szVocFile[MAX_PATH];
    BOOL        m_bDisconnected;
    BOOL        m_bRecFax;
    BOOL        m_bDTMFRec;
    PORTFAX     m_pPortFax;
    FAXOBJ      m_SendFaxObj;
    BOOL        m_bDoExit;

// Generated message map functions
protected:
	//{{AFX_MSG(CVoiceMailSampleDoc)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_VOICEMAILSAMPLEDOC_H__D4F3B00E_1CB1_11D3_AFB3_0040F614A5A0__INCLUDED_)
