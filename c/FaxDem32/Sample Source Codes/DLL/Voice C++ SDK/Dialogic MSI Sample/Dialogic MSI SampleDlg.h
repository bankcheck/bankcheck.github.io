// Dialogic MSI SampleDlg.h : header file
//

#if !defined(AFX_DIALOGICMSISAMPLEDLG_H__AC18CF08_77FA_4982_BE1C_7CD9F08DC2C5__INCLUDED_)
#define AFX_DIALOGICMSISAMPLEDLG_H__AC18CF08_77FA_4982_BE1C_7CD9F08DC2C5__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CDialogicMSISampleDlg dialog

enum StationState{ STATION_ONHOOK, STATION_OFFHOOK, STATION_RINGING, STATION_CONNECTED, STATION_CONFERENCE, STATION_ANSWERING, STATION_USED};


typedef struct __StationInfo
{
    SCBUSRES            MSIRes;
    SCBUSRES            LineRes;
    SCBUSRES            VoiceRes;
    int                 ConfID;
    enum StationState   State;
}STATION_INFO;

class CDialogicMSISampleDlg : public CDialog
{
// Construction
public:
	CDialogicMSISampleDlg(CWnd* pParent = NULL);	// standard constructor
    long OnVoiceMsg(WPARAM event,LPARAM lParam);
    void StatusMsg(LPCSTR msg,...);
    
    void        Handle_MFX_MSI_STATIONONHOOK(MODEMOBJ ModemObj);
    void        Handle_MFX_MSI_STATIONOFFHOOK(MODEMOBJ ModemObj);
    void        Handle_MFX_RING(MODEMOBJ ModemObj);
	void		Handle_MFX_ONHOOK(MODEMOBJ ModemObj);
    void        WaitForDTMF(MODEMOBJ ModemObj);
    BYTE        GetModemObjIndex(MODEMOBJ ModemObj);
    
    MODEMOBJ    GetModemObj(BYTE index);
    SCBUSRES    GetMSIResHandle(BYTE index);
    SCBUSRES    GetVoiceResHandle(BYTE index);
    SCBUSRES    GetLineResHandle(BYTE index);


    BYTE        GetVoiceResIndex(SCBUSRES ResHandle);

    DWORD       GetStationStatusID(BYTE index);
    DWORD       GetStationIconID(BYTE index);
    DWORD       GetConfButtonID(BYTE index);

    void        SetStationState(BYTE index, enum StationState);
    LPCSTR      GetStationName(BYTE index);
    
    void        AttachFreeVoiceRes(BYTE index);
    void        ConnectToFreeLineRes(BYTE index);
    void        RestoreVoiceRes(BYTE index);
    BYTE        FindVoiceRes(BYTE Index);

    void        CreateConference(BYTE index);
    void        AddToConference(BYTE index);
    void        RemoveFromConference(BYTE index);
// Dialog Data
	//{{AFX_DATA(CDialogicMSISampleDlg)
	enum { IDD = IDD_DIALOGICMSISAMPLE_DIALOG };
	CListBox	m_lbMessages;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDialogicMSISampleDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
    
	//}}AFX_VIRTUAL

    STATION_INFO StationInfo[8];
// Implementation
protected:
	HICON m_hIcon;

    DWORD m_dwVoiceResNum;
    DWORD m_dwLineResNum;
    DWORD m_dwMSIResNum;

    MODEMOBJ m_hModemObj1;
    MODEMOBJ m_hModemObj2;
    MODEMOBJ m_hModemObj3;
    MODEMOBJ m_hModemObj4;


    MODEMOBJ m_hMSIModemObj1;
    MODEMOBJ m_hMSIModemObj2;
    MODEMOBJ m_hMSIModemObj3;
    MODEMOBJ m_hMSIModemObj4;

    SCBUSRES m_hLineHandle1;
    SCBUSRES m_hLineHandle2;
    SCBUSRES m_hLineHandle3;
    SCBUSRES m_hLineHandle4;
    

    SCBUSRES m_hVoiceHandle1;
    SCBUSRES m_hVoiceHandle2;
    SCBUSRES m_hVoiceHandle3;
    SCBUSRES m_hVoiceHandle4;

    SCBUSRES m_hMSIHandle1;
    SCBUSRES m_hMSIHandle2;
    SCBUSRES m_hMSIHandle3;
    SCBUSRES m_hMSIHandle4;

    int      m_hMSIBoardHandle;
    
    HICON   m_hPhoneOffHook;
    HICON   m_hPhoneOnHook;
    HICON   m_hPhoneRing;
    HICON   m_hPhoneDisabled;


    BYTE    m_dwConfHostStation;

	// Generated message map functions
	//{{AFX_MSG(CDialogicMSISampleDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnClear();
	afx_msg void OnClipboard();
	afx_msg void OnButtonconf1();
	afx_msg void OnButtonconf2();
	afx_msg void OnButtonconf3();
	afx_msg void OnButtonconf4();
	afx_msg void OnButtonconf5();
	afx_msg void OnButtonconf6();
	afx_msg void OnButtonconf7();
	afx_msg void OnButtonconf8();
	afx_msg void OnDestroy();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DIALOGICMSISAMPLEDLG_H__AC18CF08_77FA_4982_BE1C_7CD9F08DC2C5__INCLUDED_)
