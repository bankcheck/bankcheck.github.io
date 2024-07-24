using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;

namespace RecDTMF_FaxOrVoiceCSharp
{
    public partial class MainForm : Form
    {
        public Array szVoiceCaps = Array.CreateInstance(typeof(string), 6);

        private int nProgressStatus;
        private const int cnsHangup  = 0;
        private const int cnsDial = 1;
        private const int cnsAnswer = 2;
        private const int cnsOffHook = 3;
        private const int cnsPlay = 4;
        private const int cnsRecord = 5;
        private const int cnsSendFax = 6;
        private const int cnsRecFax = 7;
        private const int cnsSendDTMF = 8;
        private const int cnsWaitDTMF = 9;
        private const int cnsSendSignal = 10;
        private const int cnsTransfer = 11;
        private const int cnsExit = 100;

        public const short cnsNoneAttached = -1;
        public const short cnsSelectPort = 0;
        public const short cnsOnline = 1;
        public const short cnsSelectDlg = 2;
        public const short cnsSelectBT = 3;
        public const short cnsSelectNMS = 4;

        private const bool cnsWAV = true;

        private const short MDF_PCM = 1;

        private const short MSR_11KHZ = 3;

        private const short MDM_LINE = 0;
        private const short IMT_FILE_TIFF_G4 = 19;
        private const short IMT_FILE_TIFF_NOCOMP = 11;

        private string szVoiceFile;
        private string szExePath;
        public string szIniFile;

        public short nPrStatus;
        public int lModemID = 0;
        private short nAutoScroll;
        private int FaxID;

        private ComOpen dlgCOM = null;
        private BrooktroutOpen dlgBrooktrout = null;
        private DialogicOpen dlgDialogic = null;
        private NMSOpen dlgNMS = null;

        private bool isDTMFTerminated;
        private bool isHangingUp;

        [DllImport("kernel32", EntryPoint = "GetPrivateProfileStringA", CharSet = CharSet.Ansi)]
        public static extern int GetPrivateProfileString(
            string sectionName,
            string keyName,
            string defaultValue,
            StringBuilder returnbuffer,
            Int32 bufferSize,
            string fileName);

        [DllImport("kernel32", EntryPoint = "WritePrivateProfileStringA", CharSet = CharSet.Ansi)]
        public static extern int WritePrivateProfileString(
            string sectionName,
            string keyName,
            string stringToWrite,
            string fileName);

        public MainForm()
        {
            InitializeComponent();		
		    EnableButtons(false, false);
            closeButton.Enabled = false;
            isDTMFTerminated = false;
            isHangingUp = false;
        }

        //other functions
        //completing statusBox
        private void AddToLog(string text)
        {
            int itemCount;
            statusBox.Items.Add(text);
            itemCount = statusBox.Items.Count;
            if (nAutoScroll == 1)
                statusBox.TopIndex = itemCount - 1;
        }

        //button enabling
        private void EnableButtons(bool bEnabled1, bool bEnabled2)
        { 		
		    receiveButton.Enabled = bEnabled2;
            DTMFButton.Enabled = bEnabled2;
            recordButton.Enabled = bEnabled2;
            HangUpbutton.Enabled = bEnabled2;
    		
		    portOpen.Enabled = !bEnabled1;
		    dialogicOpen.Enabled = !bEnabled1;
		    brookOpen.Enabled = !bEnabled1;
		    NMSOpen.Enabled = !bEnabled1;
        }

        //functions for events
        private void clearButton_Click(object sender, EventArgs e)
        {
            statusBox.Items.Clear();
        }

        private void exitButton_Click(object sender, EventArgs e)
        {
            nProgressStatus = cnsExit;
            AddToLog("Exiting...");
            if (lModemID != 0){
                axVoiceOCX1.ClosePort(lModemID);
            }
            Close();
        }

        private void helpButton_Click(object sender, EventArgs e)
        {
            Help dlgHelp = new Help();
            dlgHelp.ShowDialog();
        }

        private void closeButton_Click(object sender, EventArgs e)
        {
		    if (lModemID != 0) {
			    axVoiceOCX1.ClosePort(lModemID);
                AddToLog("Port/channel closed.");
			    axVoiceOCX1.DestroyModemObject(lModemID);
			    lModemID = 0;
                EnableButtons(false, false);
                closeButton.Enabled = false;
            }
        }

        private void portOpen_Click(object sender, EventArgs e)
        {
            dlgCOM = new ComOpen();
            dlgCOM.parent = this;
            dlgCOM.ShowDialog();

            if ( lModemID!=0 )
            {
                AddToLog("Modem/channel is ready to answer incoming calls");

                if (dlgCOM.GetLogEnabled())
                    axVoiceOCX1.EnableLog(lModemID, true);

                nPrStatus = cnsOnline;
                nProgressStatus = 0;
                nAutoScroll = 1;
                EnableButtons(true, false);
                axVoiceOCX1.WaitForRings(lModemID, 2);
            }
        }

        private void axVoiceOCX1_ModemError(object sender, AxVOICEOCXLib._DVoiceOCXEvents_ModemErrorEvent e)
        {
                switch (nPrStatus)
                {
                    case -1: //no modem attached
                        MessageBox.Show("Modem OK received on port: " + axVoiceOCX1.GetPortName(e.modemID));
                        break;
                    case 0: //select port
                        dlgCOM.VOICEOCX_ModemError(sender, e);
                        break;
                    case 2: //dialogic
                        dlgDialogic.VoiceOCX_ModemError();
                        break;
                    case 3: //Brooktrout
                        dlgBrooktrout.VoiceOCX_ModemError();
                        break;
                    case 4: //NMS
                        dlgNMS.VoiceOCX_ModemError();
                        break;
                    default:
                        if ( !isDTMFTerminated )
                            AddToLog("Operation failed. Error message was received.");
                        nProgressStatus = 0;
                        closeButton.Enabled = true;
                        break;
                }

        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            nPrStatus = cnsNoneAttached;
            szVoiceCaps.SetValue("Data", 1);
            szVoiceCaps.SetValue("Class1", 2);
            szVoiceCaps.SetValue("Class2", 3);
            szVoiceCaps.SetValue("Voice", 4);
            szVoiceCaps.SetValue("VoiceView", 5);

            szExePath = Application.StartupPath;
		    szIniFile = szExePath + "\\VOCXDEMO.INI";

		    EnableButtons(false, false);
            closeButton.Enabled = false;
        }

        private void axVoiceOCX1_ModemOK(object sender, AxVOICEOCXLib._DVoiceOCXEvents_ModemOKEvent e)
        {
            switch (nPrStatus)
            {
                case cnsNoneAttached:
                    MessageBox.Show("Modem OK received on port: " + axVoiceOCX1.GetPortName(lModemID));
                    break;
                case cnsSelectPort  :
                    dlgCOM.VOICEOCX_ModemOK(sender, e);
                    break;
            }
        }

        private void axVoiceOCX1_PortOpen(object sender, AxVOICEOCXLib._DVoiceOCXEvents_PortOpenEvent e)
        {
            switch (nPrStatus)
            { 
                case cnsNoneAttached:
                    MessageBox.Show("Modem OK received on port: " + axVoiceOCX1.GetPortName(lModemID));
                    break;
                case cnsSelectPort  :
                    dlgCOM.VOICEOCX_PortOpen(sender, e);
                    break;
                case cnsSelectDlg   :
                    dlgDialogic.VoiceOCX_PortOpen();
                    break;
                case cnsSelectBT    :
                    dlgBrooktrout.VoiceOCX_PortOpen();
                    break;
                case cnsSelectNMS   :
                    dlgNMS.VoiceOCX_PortOpen();
                    break;
            }
            closeButton.Enabled = true;
        }

        private void brookOpen_Click(object sender, EventArgs e)
        {
/*            int modemID, index;*/
            if (axVoiceOCX1.GetBrooktroutChannelNum() > 0)
            {
                dlgBrooktrout = new BrooktroutOpen();
                dlgBrooktrout.parent = this;
                dlgBrooktrout.ShowDialog();

                if (lModemID != 0)
                {
                    AddToLog("Modem/channel is ready to answer incoming calls");
                    if (dlgBrooktrout.GetLogEnabled())
                        axVoiceOCX1.EnableLog(lModemID, true);

                    nPrStatus = cnsOnline;
                    nProgressStatus = 0;
                    nAutoScroll = 1;
                    EnableButtons(true, false);
                    axVoiceOCX1.WaitForRings(lModemID, 2);
                }
            }
            else 
            {
                MessageBox.Show("There is no available Brooktrout channel!");
            }
        }

        private void MainForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            string szBcmTones = "";
		    WritePrivateProfileString("VOICE", "BCMTONES", szBcmTones, szIniFile);
    		
		    nPrStatus = cnsNoneAttached;
		    axVoiceOCX1.TerminateProcess(lModemID);
		    if ( lModemID!=0 )
			    axVoiceOCX1.DestroyModemObject(lModemID);
            lModemID = 0;
        }

        private void dialogicOpen_Click(object sender, EventArgs e)
        {
            if (axVoiceOCX1.GetDialogicChannelNum(axVoiceOCX1.GetDialogicBoardNum()) > 0)
            {
                dlgDialogic = new DialogicOpen();
                dlgDialogic.parent = this;
                dlgDialogic.ShowDialog();

                if (lModemID != 0)
                {
                    AddToLog("Modem/channel is ready to answer incoming calls");

                    nPrStatus = cnsOnline;
                    nProgressStatus = 0;
                    nAutoScroll = 1;
                    EnableButtons(true, false);
                    axVoiceOCX1.WaitForRings(lModemID, 2);
                }
            }
            else 
            {
                MessageBox.Show("There is no available Dialogic channel!");
            }
        }

        private void NMSOpen_Click(object sender, EventArgs e)
        {
            if (axVoiceOCX1.GetNMSBoardNum() > 0)
            {
                dlgNMS = new NMSOpen();
                dlgNMS.parent = this;
                dlgNMS.ShowDialog();

                if (lModemID != 0)
                {
                    AddToLog("Modem/channel is ready to answer incoming calls");
                    if (dlgNMS.GetLogEnabled())
                        axVoiceOCX1.EnableLog(lModemID, true);

                    nPrStatus = cnsOnline;
                    nProgressStatus = 0;
                    nAutoScroll = 1;
                    EnableButtons(true, false);
                    axVoiceOCX1.WaitForRings(lModemID, 2);
                }
            }
            else
            {
                MessageBox.Show("There is no available NMS channel!");
            }
        }

        private void axVoiceOCX1_DTMFDigit(object sender, AxVOICEOCXLib._DVoiceOCXEvents_DTMFDigitEvent e)
        {
            nProgressStatus = 0;
		    AddToLog("Received DTMF digit(s): [" + Convert.ToChar(e.digit) + "]");

            closeButton.Enabled = true;
        }

        private void axVoiceOCX1_DTMFReceived(object sender, AxVOICEOCXLib._DVoiceOCXEvents_DTMFReceivedEvent e)
        {
        	AddToLog("Received DTMF digit(s): [" + axVoiceOCX1.GetReceivedDTMFDigits(lModemID) + "]");
            nPrStatus = cnsOnline;
            isDTMFTerminated = true;
		    axVoiceOCX1.TerminateProcess(lModemID);
		    nProgressStatus = 0;
            closeButton.Enabled = true;
        }

        private void axVoiceOCX1_DTMFReceivedExt2(object sender, AxVOICEOCXLib._DVoiceOCXEvents_DTMFReceivedExt2Event e)
        {
          	AddToLog("Received DTMF digit(s): [" + axVoiceOCX1.GetReceivedDTMFDigits(lModemID) + "]");
		    AddToLog("Offset:" + Convert.ToChar(e.offset));
            nPrStatus = cnsOnline;
            isDTMFTerminated = true;
		    axVoiceOCX1.TerminateProcess(lModemID);
		    nProgressStatus = 0;
            closeButton.Enabled = true;
        }

        private void DTMFButton_Click(object sender, EventArgs e)
        {
            short nNum;
            short nDelim;

            isDTMFTerminated = false;
            WaitforDTMF dlgDTMF = new WaitforDTMF();
            dlgDTMF.ShowDialog();


            nNum = dlgDTMF.GetNumberOfDigits();
            nDelim = dlgDTMF.GetDelimiter();

            if ( nNum > 0 )
            {
                if ( axVoiceOCX1.WaitForDTMF(lModemID, nNum, nDelim, 20)==0 )
                {
                    AddToLog("Wait for DTMF digits");
                    closeButton.Enabled = false;
                    nProgressStatus = cnsWaitDTMF;
                }
                else
                    AddToLog("WaitForDTMF failed");
            }

        }

        private void axVoiceOCX1_OffHookEvent(object sender, AxVOICEOCXLib._DVoiceOCXEvents_OffHookEvent e)
        {
            if ( nProgressStatus == cnsDial || nProgressStatus == cnsAnswer ) // dial or answer
            {
                nProgressStatus = 0;
                AddToLog("Voice connection was established");
                EnableButtons(true, true);
            }
        }

        private void axVoiceOCX1_OnHook(object sender, AxVOICEOCXLib._DVoiceOCXEvents_OnHookEvent e)
        {
            if (nProgressStatus == cnsDial || nProgressStatus == cnsAnswer) // dial or answer
                AddToLog("Pick up the phone!");
            else if (nProgressStatus == cnsHangup || nProgressStatus == cnsPlay || nProgressStatus == cnsRecord || nProgressStatus == cnsWaitDTMF)
                AddToLog("Remote side has disconnected. Hang up the line.");
        }

        private void axVoiceOCX1_Ring(object sender, AxVOICEOCXLib._DVoiceOCXEvents_RingEvent e)
        {
            switch ( nPrStatus )
            {
                case cnsNoneAttached:
                    MessageBox.Show("Modem detected RING on port: " + axVoiceOCX1.GetPortName(lModemID));
                    break;
                case cnsOnline: // online port
                    AddToLog("Incoming call was detected.");
                    // Get the caller ID information
                    // Read the information into a String buffer
                    String strCID = axVoiceOCX1.GetCallerID(lModemID);
                    // With the help of a tokenizer, extract the information one by one
                    String strToken = CStrTok.StrTok(strCID, "\\");
                    AddToLog("Call Date: " + strToken);
                    strToken = CStrTok.StrTok("", "\\");
                    AddToLog("Call Time: " + strToken);
                    strToken = CStrTok.StrTok("", "\\");
                    AddToLog("Caller ID: " + strToken);
                    strToken = CStrTok.StrTok("", "\\");
                    AddToLog("Caller Name: " + strToken);
                    strToken = CStrTok.StrTok("", "\\");
                    AddToLog("Caller Number: " + strToken);
                    strToken = CStrTok.StrTok("", "\\");
                    AddToLog("Message: " + strToken);

                    nProgressStatus = cnsAnswer;
                    axVoiceOCX1.OnlineAnswer(lModemID);
                    break;
            }

        }

        private void axVoiceOCX1_VoiceConnect(object sender, AxVOICEOCXLib._DVoiceOCXEvents_VoiceConnectEvent e)
        {
            AddToLog("Voice connection was established");
		    nProgressStatus = 0;
            EnableButtons(true, true);
            closeButton.Enabled = true;
        }

        private void recordButton_Click(object sender, EventArgs e)
        {
            short nDF;
            short nSR;
            bool bWAV;

            bWAV = cnsWAV;
            nDF = MDF_PCM;
            nSR = MSR_11KHZ;

            DateTime dateTime = new DateTime();
            dateTime = DateTime.Now;
            szVoiceFile = szExePath + "\\VOICE\\MAIL_" + dateTime.Year.ToString() + "_" + dateTime.Month.ToString() + "_" + dateTime.Day.ToString() + "_" + Convert.ToString(dateTime.Hour) + "_" + Convert.ToString(dateTime.Minute) + "_" + Convert.ToString(dateTime.Second);
            szVoiceFile = szVoiceFile + ".wav";

            if ( axVoiceOCX1.RecordVoiceExt(lModemID, szVoiceFile, MDM_LINE, 60, true, 10, bWAV, nDF, nSR, 5, Convert.ToInt16('#')) == 0 )
                nProgressStatus = cnsRecord;
            else
                AddToLog("RecordVoice failed");
        }

        private void axVoiceOCX1_VoiceRecordFinished(object sender, AxVOICEOCXLib._DVoiceOCXEvents_VoiceRecordFinishedEvent e)
        {
            nProgressStatus = 0;
		    AddToLog("Received DTMF digit(s): [" + axVoiceOCX1.GetReceivedDTMFDigits(lModemID) + "]");
		    AddToLog("Recording voice message was finished");
		    MessageBox.Show("Voice file has saved to: " + szVoiceFile);
            closeButton.Enabled = true;
        }

        private void axVoiceOCX1_VoiceRecordStarted(object sender, AxVOICEOCXLib._DVoiceOCXEvents_VoiceRecordStartedEvent e)
        {
            closeButton.Enabled = false;
		    AddToLog("Recording voice message was started");
        }

        private void receiveButton_Click(object sender, EventArgs e)
        {
            if ( axVoiceOCX1.ReceiveFaxNow(lModemID)==0 )
            {
                nProgressStatus = cnsRecFax;
                closeButton.Enabled = false;
            }
            else
                AddToLog("ReceiveFaxNow failed");
        }

        private void axVoiceOCX1_EndReceive(object sender, AxVOICEOCXLib._DVoiceOCXEvents_EndReceiveEvent e)
        {
            short nIndex;
		    nProgressStatus = 0;
    		
		    closeButton.Enabled = true;
    		
		    string szFaxName;
		    bool Append;
            short Color=0, Bitord=0, Comp=0, Width=0, nPageNum=0, Res=0, Length=0, Bin=0, Ecm=0, ClrType=0;
            if (!isHangingUp)
            {
                if (FaxID != 0)
                {
                    AddToLog("Fax was received.");
                    DateTime dateTime = new DateTime();
                    dateTime = DateTime.Now;
                    szFaxName = szExePath + "\\Fax.In\\REC_" + dateTime.Year.ToString() + "_" + dateTime.Month.ToString() + "_" + dateTime.Day.ToString() + "_" + Convert.ToString(dateTime.Hour) + "_" + Convert.ToString(dateTime.Minute) + "_" + Convert.ToString(dateTime.Second) + ".TIF";
                    if (szFaxName.Substring(1, 1) != ":")
                        szFaxName = szExePath + "\\" + szFaxName;
                    if (szFaxName != "")
                    {
                        Append = false;

                        axVoiceOCX1.GetFaxParam(FaxID, ref nPageNum, ref Res, ref Width, ref Length, ref Comp, ref Bin, ref Bitord, ref Ecm, ref Color, ref ClrType);
                        for (nIndex = 0; nIndex < nPageNum; ++nIndex)
                        {
                            axVoiceOCX1.GetFaxImagePage(FaxID, nIndex, IMT_FILE_TIFF_NOCOMP, Append, szFaxName);
                            Append = true;
                        }
                    }

                    MessageBox.Show("Saving received fax as: " + szFaxName);
                    axVoiceOCX1.ClearFaxObject(FaxID);
                    FaxID = 0;
                }
                else
                    AddToLog("No fax was received");
            }
            else
                isHangingUp = false;
            HangUp();
        }

        private void axVoiceOCX1_FaxReceived(object sender, AxVOICEOCXLib._DVoiceOCXEvents_FaxReceivedEvent e)
        {
            //AddToLog("Fax was received");
            AddToLog("Remote Identifier:" + e.remoteID);
            FaxID = e.faxID;
        }

        private void axVoiceOCX1_FaxTerminated(object sender, AxVOICEOCXLib._DVoiceOCXEvents_FaxTerminatedEvent e)
        {
            AddToLog("Fax termination status: [" + Convert.ToString(e.tStatus) + "]");
            if ( e.tStatus != 0 )
            {
                AddToLog("Modem is hanging up...");
                isHangingUp = true;
            }
            closeButton.Enabled = true;
        }

        private void HangUpbutton_Click(object sender, EventArgs e)
        {
            HangUp();
        }

        private void HangUp()
        {
            if (nProgressStatus == 0)
            {
                nProgressStatus = cnsHangup;
                axVoiceOCX1.HangUp(lModemID);
            }
            EnableButtons(true, false);
            closeButton.Enabled = true;
        }

        private void axVoiceOCX1_HangUpEvent(object sender, AxVOICEOCXLib._DVoiceOCXEvents_HangUpEvent e)
        {            
            switch (nProgressStatus)
            {
                case cnsHangup:      // hang-up
                    AddToLog("The call has been disconnected");
                    nProgressStatus = 0;
                    break;
                case cnsOffHook:      // off-hook
                    AddToLog("Voice connection was established");
                    nProgressStatus = 0;
                    break;
                case cnsExit:    // exit
                    Close();
                    break;
            }

            EnableButtons(true, false);
        }
    }
}