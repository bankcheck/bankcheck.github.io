// Voice Mail SampleDoc.cpp : implementation of the CVoiceMailSampleDoc class
//

#include "stdafx.h"
#include <io.h>
#include <time.h>
#include <direct.h>

extern "C"
{
#include "bitiff.h"
#include "bidib.h"
}

#include "Voice Mail Sample.h"
#include "codec.h"
#include "Voice Mail SampleDoc.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#define MODEM_SHORT_NAME    "GCLASS1(VOICE)"

typedef void(CVoiceMailSampleDoc::*VOCMSG)(int);

VOCMSG DocMems[] = {
    &CVoiceMailSampleDoc::OnWaitForRings,
    &CVoiceMailSampleDoc::OnAnswer,
    &CVoiceMailSampleDoc::OnPlayGreetingMessage,
    &CVoiceMailSampleDoc::OnRecordMessage,
    &CVoiceMailSampleDoc::OnReceiveFax,
    &CVoiceMailSampleDoc::OnSendFax,
    &CVoiceMailSampleDoc::OnDisconnect,
    &CVoiceMailSampleDoc::OnReInitialize
};

void SetExt(char *pszFile, const char *pszExt)
{
    if( *pszFile )
    {
                char *pC = strrchr(pszFile,'.');

        if( pC )
        {
            strcpy( ++pC, pszExt);
        }
        else
        {
            strcat(pszFile,".");
            strcat(pszFile,pszExt);
        }
    }
}

/////////////////////////////////////////////////////////////////////////////
// CVoiceMailSampleDoc

IMPLEMENT_DYNCREATE(CVoiceMailSampleDoc, CDocument)

BEGIN_MESSAGE_MAP(CVoiceMailSampleDoc, CDocument)
        //{{AFX_MSG_MAP(CVoiceMailSampleDoc)
                // NOTE - the ClassWizard will add and remove mapping macros here.
                //    DO NOT EDIT what you see in these blocks of generated code!
        //}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CVoiceMailSampleDoc construction/destruction

CVoiceMailSampleDoc::CVoiceMailSampleDoc()
{
    m_nPrStatus     = 0;
    m_nSubStatus    = 0;
    m_Modem         = NULL;
    m_bRecFax       = FALSE;
    m_bDTMFRec      = FALSE;
    m_pPortFax      = NULL;
    m_SendFaxObj    = NULL;
    m_bDoExit       = FALSE;
}

CVoiceMailSampleDoc::~CVoiceMailSampleDoc()
{
    if( m_SendFaxObj )
    {
        ClearFaxObj(m_SendFaxObj);
        m_SendFaxObj = NULL;
    }


    GetModem()->ClosePort();
    mdm_DestroyModemObject( GetModem() );
}

BOOL CVoiceMailSampleDoc::OnNewDocument()
{
    if (!CDocument::OnNewDocument())
            return FALSE;

    StatusMsg("Voice mail sample has been started. Modem is ready to receive calls.");

    return TRUE;
}



/////////////////////////////////////////////////////////////////////////////
// CVoiceMailSampleDoc serialization

void CVoiceMailSampleDoc::Serialize(CArchive& ar)
{
    if (ar.IsStoring())
    {

    }
    else
    {

    }
}

/////////////////////////////////////////////////////////////////////////////
// CVoiceMailSampleDoc diagnostics

#ifdef _DEBUG
void CVoiceMailSampleDoc::AssertValid() const
{
    CDocument::AssertValid();
}

void CVoiceMailSampleDoc::Dump(CDumpContext& dc) const
{
    CDocument::Dump(dc);
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CVoiceMailSampleDoc commands
void CVoiceMailSampleDoc::SetModem(MODEMOBJ modem)
{
        CString title;

    m_Modem = modem;
    GetModem()->SetModemLong((LONG)this);

    title.Format("Connected to port/channel: [%s]", GetModem()->GetPortName());
    SetTitle(title);
}

void CVoiceMailSampleDoc::OnVoiceMsg(int event)
{
    (this->*DocMems[m_nPrStatus])(event);
}

void CVoiceMailSampleDoc::OnWaitForRings(int event)
{
    if( event == MFX_MODEM_RING )
    {
        StatusMsg("Incoming call was detected. Answering call.");
        m_nPrStatus = vsd_ANSWER;
        GetModem()->Answer();
    }
}

void CVoiceMailSampleDoc::OnAnswer(int event)
{
    if( event == MFX_VOICE_CONNECT )
    {
                BYTE* pb = NULL;
                UINT nLen = 0;
                CString szName;

        StatusMsg("Voice connection was established");
        szName = theApp.GetProfileString(g_szSection,g_szGreeting,"");

        if( szName.GetLength() )
        {
            SetVoiceFileName(szName);
        }
        else
        {
            CString str;

            str.Format("%s\\VOICE\\VOICE.WAV",g_szExePath);

            SetVoiceFileName(str);
        }
        Sleep(1000);
        PlayMessage(vsd_GREETING,10);
    }
    else
    {
        StatusMsg("Answering call failed");
        Disconnect();
    }
}

void CVoiceMailSampleDoc::OnPlayGreetingMessage(int event)
{
    if( event == MFX_VPLAY_STARTED )
    {
        StatusMsg("Playing greeting message was started");
    }
    else if( event == MFX_DTMF_RECEIVED )
    {
        m_bDTMFRec = TRUE;
        GetModem()->TerminateWait();
        DEBUGMSG("DTMF digit was received");
    }
    else if( event == MFX_ONHOOK )
    {
        StatusMsg("Caller has hanged up the line");
        m_bDisconnected = TRUE;
        GetModem()->TerminateWait();
    }
    else if( event == MFX_CALLING_TONE )
    {
        if( !m_bRecFax )
        {
            GetModem()->TerminateWait();
            StatusMsg("Calling tone was detected");
            m_bRecFax = TRUE;
        }
    }
    else if( event == MFX_VPLAY_FINISHED )
    {
        StatusMsg("Playing greeting message was finished");
        if( GetModem()->GetModemType() == MOD_STANDARD_ROCKWELL)
        {
            unlink(GetVoiceFileName());
        }
        if( (GetModem()->GetModemType() == MOD_USR_SPORSTER) )
        {
            char VoiceCmd[128];
            GetModem()->GetVoiceFormatCommand(VoiceCmd, 128);
            if(!stricmp(VoiceCmd, "AT#VSM=130,8000"MDM_ENTER))
                unlink(GetVoiceFileName());
        }
        if( m_bDoExit )
        {
            Disconnect();
        }
        else if( m_bRecFax )
        {
            ReceiveFax();
        }
        else if(m_bDTMFRec && m_nPrStatus == vsd_GREETING)
        {
            DTMFINFO        dtmfInfo;

            GetModem()->GetReceivedDTMF(&dtmfInfo);

            if( *DTMF_DTMF((&dtmfInfo)) == '0' )
            // leave a message
            {
                StatusMsg("Caller wants to leave a message");
                RecordMessage();
            }
            else if( *DTMF_DTMF((&dtmfInfo)) == '1' )
            // caller wants to send a fax
            {
                StatusMsg("Caller wants to send a fax.");
                ReceiveFax();
            }
            else if( *DTMF_DTMF((&dtmfInfo)) == '2' )
            // caller downloads a fax
            {
                StatusMsg("Caller wants to download a fax.");
                SendFax();
            }
            else
            {
                StatusMsg("Caller selected an invalid menu item.");
                Disconnect();
            }
        }
        else
        {
            Disconnect();
        }
    }
    else if( event == MFX_ERROR )
    {
        StatusMsg("Playing greeting message failed");
        if( GetModem()->GetModemType() == MOD_STANDARD_ROCKWELL)
        {
            unlink(GetVoiceFileName());
        }
        if( (GetModem()->GetModemType() == MOD_USR_SPORSTER) )
        {
            char VoiceCmd[128];
            GetModem()->GetVoiceFormatCommand(VoiceCmd, 128);
            if(!stricmp(VoiceCmd, "AT#VSM=130,8000"MDM_ENTER))
                unlink(GetVoiceFileName());
        }
        Disconnect();
    }
}

void CVoiceMailSampleDoc::OnRecordMessage(int event)
{
    if( event == MFX_VREC_STARTED )
    {
        StatusMsg("Recording voice mail was started");
    }
    else if( event == MFX_ONHOOK )
    {
        StatusMsg("Remote side has disconnected.");
        GetModem()->TerminateWait();
        m_bDisconnected = TRUE;
    }
    else if( event == MFX_DTMF_RECEIVED )
    {
        GetModem()->TerminateWait();
        StatusMsg("DTMF digit received");
    }
    else if( event == MFX_VREC_FINISHED )
    {
        StatusMsg("Recording voice mail was finished.");
        if( GetModem()->GetModemType() == MOD_STANDARD_ROCKWELL )
        // convert this message to wav
        {
                char    szTemp[MAX_PATH];

            strcpy(szTemp,GetVoiceFileName());
            SetExt(szTemp,"VOC");

            DEBUGMSG("VOC2WAV: [%s]-[%s]",GetVoiceFileName(),szTemp);
            ConvertVOC2WAV(GetVoiceFileName(),szTemp,4,FREQ_11025,MODE_SYNC);
            if( access(szTemp,04) == 0 )
            {
                unlink(GetVoiceFileName());
                MoveFile(szTemp,GetVoiceFileName());
            }
        }
        if( (m_Modem->GetModemType() == MOD_USR_SPORSTER) )
        {
            char VoiceCmd[128];
            m_Modem->GetVoiceFormatCommand(VoiceCmd, 128);
            if(!stricmp(VoiceCmd, "AT#VSM=130,8000"MDM_ENTER))
            {
                char    szTemp[MAX_PATH];
                strcpy(szTemp,GetVoiceFileName());
                SetExt(szTemp,"USR");

                DEBUGMSG("IMAADPCM2WAV: [%s]-[%s]",GetVoiceFileName(),szTemp);
                ConvertIMAADPCMtoPCM(GetVoiceFileName(),szTemp,MODE_SYNC);
                if( access(szTemp,04) == 0 )
                {
                    unlink(GetVoiceFileName());
                    MoveFile(szTemp,GetVoiceFileName());
                }
            }
        }
            Disconnect();
    }
    else if( event == MFX_ERROR )
    {
                StatusMsg("Recording voice mail failed");
        Disconnect();
    }
}

void CVoiceMailSampleDoc::OnReceiveFax(int event)
{
    switch(m_nSubStatus)
    {
                case    rec_SWITCH:
                        OnReceiveSwitch(event);
                break;
                case    rec_CONNECT:
                        OnReceiveConnect(event);
                        break;
                case    rec_RECEIVING:
                        OnReceivingFax(event);
                        break;
                case    rec_RETURN:
                        OnReturn2Voice(event);
                        break;
    }
}

void CVoiceMailSampleDoc::OnSendFax(int event)
{
    switch(m_nSubStatus)
    {
                case    snd_SWITCH:
                        OnSendSwitch(event);
                break;

                case    snd_CONNECT:
                        OnSendConnect(event);
                        break;
                case    snd_SENDING:
                        OnSendingFax(event);
                        break;
                case    snd_RETURN:
                        OnReturn2Voice(event);
                        break;
    }
}

void CVoiceMailSampleDoc::OnDisconnect(int event)
{
    if( event == MFX_MODEM_OK )
    {
        StatusMsg("Call was disconnected");
        if( !m_bDoExit )
        {
            ReInitializePort();
        }
        else
        {
            CDocument::OnCloseDocument();
        }
    }
}

void CVoiceMailSampleDoc::OnReInitialize(int event)
{
    if( event == MFX_MODEM_OK )
    {
        m_pPortFax = NULL;
        *m_szVocFile = 0;
        m_bDisconnected = FALSE;
        m_bRecFax = FALSE;
        m_bDTMFRec = FALSE;
        m_SendFaxObj = NULL;

        StatusMsg("Modem was successfully reinitialized.");
        StatusMsg("============================================");
        if( !m_bDoExit )
        {
            GetModem()->WaitForRings( theApp.GetProfileInt(g_szSection,g_szRings,1) );
            m_nPrStatus = vsd_RING;
        }
        else
        {
            CDocument::OnCloseDocument();
        }
    }
    else
    {
        StatusMsg("Reinitializing modem failed");
        CDocument::OnCloseDocument();
    }
}

void CVoiceMailSampleDoc::PlayMessage(int status,int time,int digits)
{
        VOICEINFO   voiceInfo;
        char        szVocFile[MAX_PATH];

    strcpy(szVocFile,GetVoiceFileName());
    if( GetModem()->GetModemType() == MOD_STANDARD_ROCKWELL )
    {
        SetExt(szVocFile,"VOC");

        DEBUGMSG("WAV2VOC: [%s]-[%s]",GetVoiceFileName(),szVocFile);
        ConvertWAV2VOC(GetVoiceFileName(),szVocFile,4,MODE_SYNC);
        if( access(szVocFile,04) == 0 )
        {
                SetVoiceFileName(szVocFile);
        }
        else
        {
                Disconnect();
                return;
        }
    }
    if( (GetModem()->GetModemType() == MOD_USR_SPORSTER) )
    {
        char VoiceCmd[128];
        GetModem()->GetVoiceFormatCommand(VoiceCmd, 128);
        if(!stricmp(VoiceCmd, "AT#VSM=130,8000"MDM_ENTER))
        {
            SetExt(szVocFile,"USR");

            DEBUGMSG("WAV2IMAADPCM: [%s]-[%s]",GetVoiceFileName(),szVocFile);
            ConvertPCMtoIMAADPCM(GetVoiceFileName(),szVocFile,MODE_SYNC);
            if( access(szVocFile,04) == 0 )
            {
                SetVoiceFileName(szVocFile);
            }
            else
            {
                Disconnect();
                return;
            }
        }
    }
    
    memset(&voiceInfo,0,sizeof(voiceInfo));
    strcpy(voiceInfo.szFilename,GetVoiceFileName());
    VOICE_NUM((&voiceInfo))     = digits;
    VOICE_TIME((&voiceInfo))    = time;
    VOICE_DEVICE((&voiceInfo))  = MDM_LINE;
 
    if( GetModem()->PlayVoice(&voiceInfo) )
    {
        m_bDTMFRec  = FALSE;
        m_nPrStatus = status;
        m_bRecFax   = FALSE;
    }
    else
    {
        StatusMsg("PlayVoice() failed.");
        Disconnect();
    }
}

void CVoiceMailSampleDoc::RecordMessage()
{
        VOICEINFO       voiceInfo;
        char            szVocFile[MAX_PATH];
        DWORD           dwRetVal        = 0;
        BOOL            bOK             = TRUE;
        BOOL            bResult         = TRUE;
        time_t          lTime;
        struct  tm      *localTime;

    memset(&voiceInfo,0,sizeof(voiceInfo));

    time( &lTime );
    localTime = localtime( &lTime );

    memset(&voiceInfo,0,sizeof(voiceInfo));
    VOICE_DEVICE((&voiceInfo))      = MDM_LINE;
    VOICE_DELIM((&voiceInfo)) = '#';
    VOICE_TIME((&voiceInfo))        = theApp.GetProfileInt(g_szSection,g_szRecTime,60);

    sprintf(szVocFile,"%s\\VOICE\\MAIL_%d_%02d_%02d_%02d_%02d_%02d.WAV",
                g_szExePath,
                localTime->tm_year + 1900,
                localTime->tm_mon + 1,
                localTime->tm_mday,
                localTime->tm_hour,
                localTime->tm_min,
                localTime->tm_sec);


    SetVoiceFileName(szVocFile);

    strcpy(VOICE_FILE((&voiceInfo)), GetVoiceFileName());

    if( GetModem()->RecordVoice(&voiceInfo) )
    {
        m_nPrStatus = vsd_RECORD;
    }
    else
    {
    StatusMsg("RecordVoice() failed");
            Disconnect();
    }
}

void CVoiceMailSampleDoc::SendFax()
{
    try
    {
                struct TSFaxParam   sFaxParam ;
                union TUFaxImage    FaxPage ;
                int                                 nImages;
                CString             szFaxFile;

        szFaxFile = theApp.GetProfileString(g_szSection, "FAXOUT", "");
        if( !szFaxFile.GetLength() )
        {
            szFaxFile.Format("%s\\Fax.out\\TEST.TIF",g_szExePath);
        }

        nImages = GetNumberOfImagesInTiffFile((char*)LPCSTR(szFaxFile));
        StatusMsg("Fax document:");
        StatusMsg("[%s]",LPCSTR(szFaxFile));
        StatusMsg("Creating fax object. Number of pages: [%d]", nImages);

        if( nImages < 1 )
        {
            StatusMsg("TIFF file is empty!");
            throw 1;
        }

        memset(&sFaxParam,0,sizeof(sFaxParam));
        sFaxParam.PageNum       = nImages;
        sFaxParam.Resolut       = RES_196LPI ;
        sFaxParam.Width         = PWD_1728;
        sFaxParam.Length        = PLN_NOCHANGE ;
        sFaxParam.Compress      = DCF_1DMH ;
        sFaxParam.Binary        = BFT_DISABLE;
        sFaxParam.BitOrder      = BTO_FIRST_LSB ;
        sFaxParam.DeleteFiles       = TRUE ;
        sFaxParam.Send          = TRUE ;
        sFaxParam.Ecm           = ECM_DISABLE;
        m_SendFaxObj = CreateSendFax('N',&sFaxParam);

        memset(&FaxPage,0,sizeof(FaxPage));
        FaxPage.File = szFaxFile;
        if ( m_SendFaxObj )
        {
                        int             iError;
                        bool    bOK = true;

            for( int iPage=0; iPage<nImages; iPage++ )
            {
                    FaxPage.Dib = LoadImageIntoDIB( (char*)LPCSTR(szFaxFile), iPage, &iError );
                    iError              = SetFaxImagePage(m_SendFaxObj, iPage, IMT_MEM_DIB, &FaxPage,  0);
                    if( iError < 0 )
                    {
                            MessageBeep( MB_ICONSTOP );
                            StatusMsg("SetFaxImagePage() failed" );
            throw 1;
                    }
            }
        }

        if( m_Modem->SetFaxSendMode(1) )
        {
            m_nPrStatus = vsd_SENDFAX;
            m_nSubStatus = snd_SWITCH;
        }
        else
        {
            StatusMsg("SetFaxSendMode() failed!");
            throw 1;
        }
    }
    catch(int)
    {
        if( m_SendFaxObj )
        {
            ClearFaxObj( m_SendFaxObj );
            m_SendFaxObj = NULL;
        }

        Disconnect();
    }
}

void CVoiceMailSampleDoc::OnSendSwitch(int event)
{
    if( event == MFX_VOICE_CONNECT )
    {
            char    szFaxIniFile[MAX_PATH];

        if( m_Modem->GetModemType() != MOD_BROOKTROUT )
        {
                sprintf(szFaxIniFile, "%s\\FAXCPP.INI", g_szExePath);
        }
        else
        {
                strcpy(szFaxIniFile,g_szBrookCfgFile);
        }

        StatusMsg("Creating fax port [%s].", szFaxIniFile);
                m_pPortFax = (PORTFAX)m_Modem->ConnectVoicePort(MODEM_SHORT_NAME,szFaxIniFile);

        if( m_pPortFax )
        {
            m_nSubStatus = snd_CONNECT;
        }
        else
        {
            Return2Voice();
        }
    }
    else
    {
        StatusMsg("Cannot switch to fax mode!");
        Return2Voice();
    }
}

void CVoiceMailSampleDoc::OnSendConnect(int event)
{
        if( event == MFX_IDLE )
        {
                        TSModemCapabiliti       MCap;

                        StatusMsg("Fax port idles");

                        GetModemCapabiliti( m_pPortFax, &MCap );
                        MCap.Ecm = ECM_DISABLE;
                        SetupPortCapabilities( m_pPortFax, &MCap );

                        if( GetModem()->SendFaxNow((LONG)m_SendFaxObj) )
                        {
                                m_nSubStatus = snd_SENDING;
                        }
                        else
                        {
                                StatusMsg("SendFaxNow() failed");
                                Return2Voice();
            }
        }
        else
        {
                        Return2Voice();
        }
}

void CVoiceMailSampleDoc::OnSendingFax(int event)
{
    if(event == MFX_STARTSEND)
    {
        StatusMsg("Sending fax started.");
    }
    else if(event == MFX_IDLE)
    {
        Return2Voice();
    }
    else if( event == MFX_ENDSEND )
    {
        StatusMsg("End send - destroying fax object.");
        ClearFaxObj(m_SendFaxObj);
        m_SendFaxObj = NULL;
    }
    else if(event == MFX_TERMINATE)
    {
        TSSessionParameters Params;

        GetSessionParameters(m_pPortFax,&Params);
        StatusMsg("Termination status: [%d]", Params.TStatus);
    }
}

void CVoiceMailSampleDoc::Disconnect()
{
    StatusMsg("Hanging up the line");
    m_nPrStatus = vsd_DISCONNECT;
    GetModem()->HangUp();
}

void CVoiceMailSampleDoc::ReInitializePort()
{
    StatusMsg("Reinitializing modem");
    m_nPrStatus = vsd_REINIT;
    GetModem()->InitializeModem();
}

void CVoiceMailSampleDoc::Return2Voice()
{
    StatusMsg("Returning to voice mode");
    m_nSubStatus = rec_RETURN;
    GetModem()->DisconnectVoicePort();
}

void CVoiceMailSampleDoc::SetVoiceFileName(LPCSTR lpszVoc)
{
    ASSERT(strlen(lpszVoc)<MAX_PATH);
    strcpy(m_szVocFile,lpszVoc);
}

void CVoiceMailSampleDoc::OnCloseDocument()
{
    if( m_pPortFax )
    {
        StatusMsg("Close action - terminating current fax process");
        GetModem()->TerminateWait();
        m_bDoExit = TRUE;
    }
    else if( m_nPrStatus != vsd_RING )
    {
        StatusMsg("Close action - terminating current voice process");
        GetModem()->TerminateWait();
        m_bDoExit = TRUE;
    }
    else
    {
        CDocument::OnCloseDocument();
    }
}

void CVoiceMailSampleDoc::ReceiveFax()
{
    if( m_Modem->SetFaxReceiveMode(1) )
    {
        m_nPrStatus = vsd_RECEIVE;
        m_nSubStatus = rec_SWITCH;
    }
    else
    {
        Return2Voice();
    }
}

void CVoiceMailSampleDoc::OnReceiveSwitch(int event)
{
    if( event == MFX_VOICE_CONNECT )
    {
                char    szFaxIniFile[MAX_PATH];

                if( m_Modem->GetModemType() != MOD_BROOKTROUT )
                {
                        sprintf(szFaxIniFile, "%s\\FAXCPP.INI", g_szExePath);
                }
                else
                {
                        strcpy(szFaxIniFile,g_szBrookCfgFile);
                }

        StatusMsg("Creating fax port.");
        m_pPortFax = (PORTFAX)m_Modem->ConnectVoicePort(MODEM_SHORT_NAME,szFaxIniFile);

        if( m_pPortFax )
        {
            m_nSubStatus = rec_CONNECT;
        }
        else
        {
            m_Modem->DisconnectVoicePort();
        }
    }
    else
    {
        StatusMsg("Cannot switch to fax mode!");
        Return2Voice();
    }
}

void CVoiceMailSampleDoc::OnReceiveConnect(int event)
{
        if( event == MFX_IDLE )
        {
                TSModemCapabiliti       MCap;

            StatusMsg("Receiving fax now");

            GetModemCapabiliti( m_pPortFax, &MCap );
            MCap.Ecm = ECM_DISABLE;
            SetupPortCapabilities( m_pPortFax, &MCap );

            if( GetModem()->ReceiveFaxNow() )
            {
                    m_nSubStatus = rec_RECEIVING;
            }
            else
            {
                StatusMsg("ReveiveFaxNow() failed");
                        Return2Voice();
            }
            }
        else
        {
                        StatusMsg("Fax port is not in idle state.");
                        Return2Voice();
        }
}

void CVoiceMailSampleDoc::OnReceivingFax(int event)
{
    if(event == MFX_STARTRECEIVE)
    {
        StatusMsg("Receiving fax started");
    }
    else if(event == MFX_IDLE)
    {
        StatusMsg("Fax port idles.");
        Return2Voice();
    }
    else if(event == MFX_TERMINATE)
    {
        TSSessionParameters Params;

        GetSessionParameters(m_pPortFax,&Params);
        StatusMsg("Termination status: [%d]", Params.TStatus);
    }
}

void CVoiceMailSampleDoc::OnFaxReceived(FAXOBJ faxObj)
{
        TSFaxParam      FaxParam;

    if( GetFaxParam(faxObj,&FaxParam) == 0 )
    {
        StatusMsg("Number of fax pages: [%d]", FaxParam.PageNum);
        if( FaxParam.PageNum > 0 )
        {
            time_t          lTime;
            struct  tm      *localTime;
                        CString                 szFaxFile;
            TUFaxImage      faxImage;
            bool            bAppend = false;
            bool            bOK     = true;

            szFaxFile = g_szExePath;
            szFaxFile += "\\Fax.In";
            _mkdir(szFaxFile);

            time( &lTime );
            localTime = localtime( &lTime );
            szFaxFile.Format("%s\\Fax.in\\REC_%d_%02d_%02d_%02d_%02d_%02d.TIF",
                                    g_szExePath,
                                    localTime->tm_year + 1900,
                                    localTime->tm_mon + 1,
                                    localTime->tm_mday,
                                    localTime->tm_hour,
                                    localTime->tm_min,
                                    localTime->tm_sec);

            unlink(szFaxFile);

            StatusMsg("Received fax filename:");
            StatusMsg( szFaxFile );
            faxImage.File   = szFaxFile;

            for(int nPage = 0; bOK && nPage < FaxParam.PageNum; nPage++ )
            {
                if( GetFaxImagePage(faxObj,nPage,IMT_FILE_TIFF_NOCOMP,&faxImage,bAppend) )
                {
                    StatusMsg( "Error occured while writing received fax image!" );
                    bOK = false;
                }
                bAppend = true;
            }
        }
    }

    ClearFaxObj(faxObj);
}

void CVoiceMailSampleDoc::OnReturn2Voice(int event)
{
    switch(event)
    {
                case    MFX_CONNECT:
                        StatusMsg("Fax port destroyed");
                break;

                case    MFX_IDLE:
                case    MFX_ONHOOK:
                case    MFX_OFFHOOK:
                        break;

                case    MFX_MODEM_OK:
                        StatusMsg("Modem is in voice mode again.");
                        Disconnect();
                        break;

                default:
                        StatusMsg("Modem couldn't return to voice mode!");
                        Disconnect();
    }
}

void CVoiceMailSampleDoc::StatusMsg(LPCSTR msg,...)
{
        va_list pArg;
        char    szTemp[1024];

    va_start(pArg,msg);
    vsprintf(szTemp,msg,pArg);
    UpdateAllViews(NULL,-1,(CObject*)szTemp);
    va_end(pArg);

    DEBUGMSG(szTemp);
}
