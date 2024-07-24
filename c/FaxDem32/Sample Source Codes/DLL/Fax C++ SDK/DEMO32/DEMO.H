// img.h : main header file for the IMG application
//

#ifndef __AFXWIN_H__
    #error include 'stdafx.h' before including this file for PCH
#endif

#define WM_DOREALIZE    (WM_USER+0)
#ifndef WIN32
#define MAX_FAXPORTS    4
#else
#define MAX_COMPORTS    128
#define MAX_FAXCHANNELS 100 // Brooktrout
#define MAX_GAMMACHANNELS 70 // GammaLink
#define MAX_DIALOGICCHANNELS 64 // Dialogic
#define MAX_BICOMCHANNELS 64 //Bicom
#define MAX_CMTXCHANNELS 64 //Commetrex
#define MAX_NMSCHANNELS 128 //Nms
#define MAX_FAXPORTS    (MAX_COMPORTS+MAX_FAXCHANNELS+MAX_GAMMACHANNELS+MAX_DIALOGICCHANNELS+MAX_BICOMCHANNELS+MAX_CMTXCHANNELS+MAX_NMSCHANNELS)
#endif
//
// Image File Format.
//



#ifdef WIN32
        #include "stdafx.h"
        #include "faxtype.h"
#endif
#include "v_config.h"

#if JPEG_EXIST == 1

#define FORMAT_FIRST            1
#define FORMAT_GROUP            1
#define FORMAT_BITMAP           2
#define FORMAT_TIFF             3
#define FORMAT_CALS             4
#define FORMAT_JPEG             5
#define FORMAT_GAMMA                    6  //rz only for GammaLink save
#define FORMAT_ASCII            6
#define FORMAT_BICOM            7  //rz only for BICOM/NMS save
#define FORMAT_LAST             8

#else       /* JPEG_EXIST */

#define FORMAT_FIRST            1
#define FORMAT_GROUP            1
#define FORMAT_BITMAP           2
#define FORMAT_TIFF             3
#define FORMAT_CALS             4
#define FORMAT_ASCII            5
#define FORMAT_GAMMA            5  //rz only for GammaLink Save
#define FORMAT_BICOM            6  //rz only for BICOM/NMS save

#endif      /* JPEG_EXIST */

#define POLLING_OUTPUT             1000
/////////////////////////////////////////////////////////////////////////////
// CImgApp:
// See img.cpp for the implementation of this class
//
class CImgDoc;
class CFaxEvent;
class CImgApp : public CWinApp
{
public:
    CImgApp();

    HDC         GetPrinterDC();
    CDC        *GetPrinterCDC();

    int         MyDoPromptFileName(CString& fileName, UINT nIDSTitle, LPSTR lpFilter,
                                DWORD lFlags, BOOL bOpenFileDialog);

    int         MySaveFileName(CString& fileName, UINT nIDSTitle, LPSTR lpFilter,
                                DWORD lFlags, BOOL bOpenFileDialog, LPINT lpQuality);

    int         PromptFaxFileName(CString& fileName);
    BOOL        PromptFaxSaveFileName(CString& fileName);
    void        SaveWorkDir(CFileDialog *dlgFile);
    void        SetFaxTime( TSFaxTime *mytime, struct tm *wtime );
    void        SetWinTime( TSFaxTime *mytime, struct tm *wtime );

    void        ShowAllMagnifyWnd(int nShow);
    CImgDoc*    OnNewFaxGroupDocument();
    BOOL        CreateDirs();
    HFILE       GetFileName(CString &, CString &, CString &);
    void        ReadSendIniFile();
    void        SaveSendIniFile();
    void        ShowFaxBlock( int LogType, int BlockID, BOOL b, HFILE hb );
    void        NewImage();
    CString     csFaceName;
    int         nFontSize;
    char        szAppPath[_MAX_PATH];

    PORTFAX     FaxPorts[MAX_FAXPORTS];

    LPSTR       BrooktroutChannels;
    int         m_nGammaChannel;

    int         m_nDialogicBoard;

    int         m_nBicomBoard;
    int         m_nCmtxChannels;
    int         m_nNmsBoard;

    int         nRings[MAX_FAXPORTS];
    int         nComm[MAX_FAXPORTS];
    UINT        nMessage;
    BOOL        bShowEvent;
    BOOL        m_FirstCall;
    BOOL        m_DebugBrook;
    int         m_retries;
    int         m_retrytim;
    BOOL        m_bPulse;
    CFaxEvent  *dlgEvent;
    CString     m_szDemoPath;

         int                              m_nrUntitled;

    TESpeakerTurnOn SpeakerMode;
    TESpeakerVolume SpeakerVolume;
    TERuningMode    RunMode;

    int         nFaxSaveFormat;         /* 0=FAX group  1=TIFF */

    void        FaxEventText(int iPort, LPSTR buf);

    BOOL        m_zoom_flag;
    int         m_magnify;
 
    void        LoadZoomINIFile(void);
    void        SaveZoomINIFile(void);
    CDocument  *LogDocument[4];
	char		m_szClassName[MAX_PATH];

// Overrides
    virtual BOOL InitInstance();


    BOOL    m_bFaxManagerVisible;

// Implementation
    //{{AFX_MSG(CImgApp)
    afx_msg void OnAppAbout();
    afx_msg void OnHelpSearch();
    afx_msg void OnFileOpen();
    afx_msg void OnToolsFont();
    afx_msg void OnUpdateToolsFont(CCmdUI* pCmdUI);
    afx_msg void OnUpdatePortSetup(CCmdUI* pCmdUI);
    afx_msg void OnUpdateFaxPoll(CCmdUI* pCmdUI);
    afx_msg void OnExitApplication();
    afx_msg void OnFileNew();
    afx_msg void OnFaxPoll();
    afx_msg void OnPortsetup();
        afx_msg void OnUpdateSendascii(CCmdUI* pCmdUI);
        afx_msg void OnSendascii();
	afx_msg void OnHideFaxmanager();
	afx_msg void OnUpdateHideFaxmanager(CCmdUI* pCmdUI);
	afx_msg void OnHelpFaxcsdkhelp();
	//}}AFX_MSG
    DECLARE_MESSAGE_MAP()
};
/////////////////////////////////////////////////////////////////////////////

extern LPSTR SaveFilterBuff;
extern LPSTR AllFilterBuff;

extern LPSTR GroupFilterBuff;

extern LPSTR MakeFERText(int code);

