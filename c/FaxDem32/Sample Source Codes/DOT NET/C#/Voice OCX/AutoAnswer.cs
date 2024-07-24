using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace VoiceOCXDemo
{
	/// <summary>
	/// Summary description for AutoAnswer.
	/// </summary>
	public class AutoAnswer : System.Windows.Forms.Form
	{
		private System.Windows.Forms.ListBox EventList;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;
		private int m_iModemID, nProgressStatus, m_iFaxID;
		private bool m_bDTMFReceived;
		public Form1 parent;

		public AutoAnswer()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if(components != null)
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(AutoAnswer));
			this.EventList = new System.Windows.Forms.ListBox();
			this.SuspendLayout();
			// 
			// EventList
			// 
			this.EventList.Name = "EventList";
			this.EventList.Size = new System.Drawing.Size(184, 95);
			this.EventList.TabIndex = 0;
			// 
			// AutoAnswer
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(292, 273);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.EventList});
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.Name = "AutoAnswer";
			this.Text = "AutoAnswer";
			this.Resize += new System.EventHandler(this.AutoAnswer_Resize);
			this.Closing += new System.ComponentModel.CancelEventHandler(this.AutoAnswer_Closing);
			this.Load += new System.EventHandler(this.AutoAnswer_Load);
			this.ResumeLayout(false);

		}
		#endregion

		private void AutoAnswer_Resize(object sender, System.EventArgs e)
		{
			EventList.Width = ClientSize.Width;
			EventList.Height = ClientSize.Height;
		}

		public void SetModemID(int modemID)
		{
			m_iModemID = modemID;
		}

		public void VoiceOCX_DTMFReceived()
		{
			m_bDTMFReceived = true;
			parent.axVoiceOCX1.TerminateProcess(m_iModemID);
		}

		private void AutoAnswer_Load(object sender, System.EventArgs e)
		{
			parent.axVoiceOCX1.WaitForRings(m_iModemID, 1);
			Text = "Autoanswer on port: " + parent.axVoiceOCX1.GetPortName(m_iModemID);
			nProgressStatus = 0;
			AddNewItem("Voice Mail sample has been started. Modem is ready to answer incoming calls.");
			EventList.Width = ClientSize.Width;
			EventList.Height = ClientSize.Height;
		}

		private void AutoAnswer_Closing(object sender, System.ComponentModel.CancelEventArgs e)
		{
			int index = parent.FindTagToModemID(m_iModemID);
			parent.fModemID.SetValue(-1, index, 1);
			parent.axVoiceOCX1.DestroyModemObject(m_iModemID);
			parent.fModemID.SetValue(0, index, 0);
		}

		public void VoiceOCX_ModemError()
		{
			AddNewItem ("ERROR Last operation failed.");
			DestroyConnection();
		}

		public void VoiceOCX_Ring()
		{
			AddNewItem("");
			AddNewItem("Incoming call was detected. Answering call...");
			nProgressStatus = 0;
			if (parent.axVoiceOCX1.Answer(m_iModemID) == 0)
				nProgressStatus = 1;
			else
				DestroyConnection();
		}

		public void VoiceOCX_Answer()
		{
			string szVoiceFile, szVoiceFormatCmd;

			szVoiceFormatCmd = parent.axVoiceOCX1.GetModemCommand(m_iModemID, 2);
			if (szVoiceFormatCmd.IndexOf("AT#VSM=132,8000" + "\r\n") == -1)
			{
				parent.szVocExts.SetValue(".USR", 2);
				parent.axVoiceOCX1.SetDefaultVoiceParams(m_iModemID, 0, 8000);
				parent.axVoiceOCX1.SetModemCommand(m_iModemID, 2, "AT#VSM=129,8000\r\n");
			}
			szVoiceFile = parent.szExePath + "\\VOICE\\VOICE";
			parent.SetVocExtension(m_iModemID, ref szVoiceFile);
			AddNewItem("Answer Call was answered");
			if (parent.axVoiceOCX1.GetDIDDigits(m_iModemID).Length > 0)
				AddNewItem("Answer DID digits received: " + parent.axVoiceOCX1.GetDIDDigits(m_iModemID));
			if (parent.axVoiceOCX1.PlayVoice(m_iModemID, ref szVoiceFile, 0, 20, 0, 1) == 0)
				nProgressStatus = 2;
			else
				DestroyConnection();
		}

		public void VoiceOCX_CallingTone()
		{
			AddNewItem("Interrupt Calling tone was detected!");
			parent.axVoiceOCX1.TerminateProcess(m_iModemID);
		}

		public void VoiceOCX_AnswerTone()
		{
			AddNewItem("Interrupt Answer tone was detected!");
			parent.axVoiceOCX1.TerminateProcess(m_iModemID);
		}

		public void VoiceOCX_EndReceive()
		{
			bool bAppend;
			string szFileName;
			short nPageNum = 0, Res = 0, Width = 0, Length = 0, Comp = 0, Bin = 0, Bitord = 0, Ecm = 0, Color = 0, ClrType = 0;
			if (m_iFaxID != 0)
			{
				AddNewItem("EndReceive Saving received fax");
				szFileName = parent.szExePath + "\\FAX.IN\\FAX_" + Convert.ToString(DateTime.Now.Year)
					+ Convert.ToString(DateTime.Now.Month)
					+ Convert.ToString(DateTime.Now.Day)
					+ Convert.ToString(DateTime.Now.Hour)
					+ Convert.ToString(DateTime.Now.Minute)
					+ Convert.ToString(DateTime.Now.Second)
					+ ".tif";
				bAppend = false;
				parent.axVoiceOCX1.GetFaxParam(m_iFaxID, ref nPageNum, ref Res, ref Width, ref Length, ref Comp, ref Bin, 
					ref Bitord, ref Ecm, ref Color, ref ClrType);
				for (int i = 0; i < nPageNum; ++i)
				{
					parent.axVoiceOCX1.GetFaxImagePage(m_iFaxID, (short)i, 11, bAppend, szFileName);
					bAppend = true;
				}
				parent.axVoiceOCX1.ClearFaxObject(m_iFaxID);
				m_iFaxID = 0;
			}
			else
				AddNewItem("EndReceive No fax was received");
			nProgressStatus = 0;
			DestroyConnection();
		}

		public void VoiceOCX_EndSend()
		{
			nProgressStatus = 0;
			AddNewItem("FaxSent Send fax operation has finished");
			DestroyConnection();
		}

		public void VoiceOCX_FaxReceived(int fax, string remoteID)
		{
			m_iFaxID = fax;
		}

		public void VoiceOCX_VoicePlayStarted()
		{
			AddNewItem("VoicePlayStarted");
		}

		public void  VoiceOCX_VoicePlayFinished()
		{
			string szTemp, szDTMF = "";

			if (nProgressStatus == 2)
			{
				if (m_bDTMFReceived)
				{
					m_bDTMFReceived = false;
					szDTMF = parent.axVoiceOCX1.GetReceivedDTMFDigits(m_iModemID);
					szTemp = "DTMF received:" + szDTMF;
				}
				else
					szTemp = "No acceptable DTMF digit was received!";
				AddNewItem ("Playing greeting message was finished " + szTemp);
				switch (szDTMF)
				{
					case "0" : RecordVoiceMail();
						break;
					case "1" : ReceiveFax();
						break;
					case "2" : PlayChooseMsg();
						break;
					default : DestroyConnection();
						break;
				}
			}
			else if (m_bDTMFReceived)
			{
				szDTMF = parent.axVoiceOCX1.GetReceivedDTMFDigits(m_iModemID);
				AddNewItem("DTMF Received" + szDTMF + " User chose fax: " + szDTMF);
				switch (szDTMF)
				{
					case "0" : SendFax("TEST.TIF");
						break;
					case "1" : SendFax("TEST.TIF");
						break;
					case "2" : SendFax("TEST.TIF");
						break;
					default : DestroyConnection();
						break;
				}
			}
		}

		public void VoiceOCX_VoiceRecordStarted()
		{
			AddNewItem("Recording voice mail was started");
		}

		public void VoiceOCX_VoiceRecordFinished()
		{
		AddNewItem("Voice mail was recorded");
		DestroyConnection();
		}

		public void VoiceOCX_FaxTerminated(int status)
		{
			AddNewItem("Fax was Terminated Termination status: " + Convert.ToString(status));
		}

		public void VoiceOCX_HangUp()
		{
			nProgressStatus = 0;
			parent.axVoiceOCX1.WaitForRings(m_iModemID, 1);
			AddNewItem("Hangup Modem was disconnected - answerphone operation complete");
		}

		public void VoiceOCX_OnHook()
		{
			AddNewItem("Disconnect Remote side has disconnected");
			parent.axVoiceOCX1.TerminateProcess(m_iModemID);
		}

		private void DestroyConnection()
		{
			AddNewItem("- Disconnect line");
			parent.axVoiceOCX1.HangUp(m_iModemID);
			nProgressStatus = 6;
			m_bDTMFReceived = false;
		}

		private void RecordVoiceMail()
		{
			string szVoiceFile, szVoiceFormatCmd;

			szVoiceFormatCmd = parent.axVoiceOCX1.GetModemCommand(m_iModemID, 2);
			if (szVoiceFormatCmd.IndexOf("AT#VSM=132,8000" + "\r\n") != -1)
			{
				parent.szVocExts.SetValue(".USR", 2);
				parent.axVoiceOCX1.SetDefaultVoiceParams(m_iModemID, 0, 8000);
				parent.axVoiceOCX1.SetModemCommand(m_iModemID, 2, "AT#VSM=129,8000\r\n");
			}
			szVoiceFile = parent.szExePath + "\\VOICE\\MAIL_" + Convert.ToString(DateTime.Now.Year)
				+ Convert.ToString(DateTime.Now.Month)
				+ Convert.ToString(DateTime.Now.Day)
				+ Convert.ToString(DateTime.Now.Hour)
				+ Convert.ToString(DateTime.Now.Minute)
				+ Convert.ToString(DateTime.Now.Second);
			parent.SetVocExtension(m_iModemID, ref szVoiceFile);
			AddNewItem("Record voice mail Filename: " + szVoiceFile);
			if (parent.axVoiceOCX1.RecordVoice(m_iModemID, szVoiceFile, 0, 60, true, 1) == 0)
				nProgressStatus = 7;
			else
				DestroyConnection();
		}

		private void AddNewItem(string text)
		{
			EventList.Items.Add(text);
		}

		private void ReceiveFax()
		{
			if (parent.axVoiceOCX1.ReceiveFaxNow(m_iModemID) == 0)
				nProgressStatus = 3;
		}

		private void PlayChooseMsg()
		{
			string szVoiceFile, szVoiceFormatCmd;

			szVoiceFormatCmd = parent.axVoiceOCX1.GetModemCommand(m_iModemID, 2);
			if (szVoiceFormatCmd.IndexOf("AT#VSM=132,8000" + "\r\n") != -1)
			{
				parent.szVocExts.SetValue(".USR", 2);
				parent.axVoiceOCX1.SetDefaultVoiceParams(m_iModemID, 0, 8000);
				parent.axVoiceOCX1.SetModemCommand(m_iModemID, 2, "AT#VSM=129,8000\r\n");
			}
			szVoiceFile = parent.szExePath + "\\VOICE\\SENDFAX";
			parent.SetVocExtension(m_iModemID, ref szVoiceFile);
			AddNewItem("Choose Fax Playing 'Choose Fax' message");
			if (parent.axVoiceOCX1.PlayVoice(m_iModemID, ref szVoiceFile, 0, 20, 0, 1) == 0)
				nProgressStatus = 5;
			else
				DestroyConnection();
		}

		private void SendFax(string szFaxFile)
		{
			int FaxID, err = -1;
			nProgressStatus = 0;
			szFaxFile = parent.szExePath + "\\FAX.OUT\\" + szFaxFile;
			int nNumOfImages = parent.axVoiceOCX1.GetNumberOfImages(szFaxFile, 11);
			if (nNumOfImages > -1)
			{
				FaxID = parent.axVoiceOCX1.CreateFaxObject(1, (short)nNumOfImages, 2,
					1,//width: 1728
					0,//image length
					1,//commpression method
					1,//binary file transfer disable
					1,//ECM disable
					0, 0);
				if (FaxID != 0)
				{
					for (int i = 0; i < nNumOfImages; ++i)
						if (parent.axVoiceOCX1.SetFilePage(FaxID, (short)i, 0, (short)i, szFaxFile) != 0)
							err = 1;
					if (parent.axVoiceOCX1.SendFaxNow(m_iModemID, FaxID) == 0)
						nProgressStatus = 4;
					else
						err = 2;
				}
				else 
					err = 3;
			}
			else
				err = 4;

			switch (err)
			{
				case 4 : AddNewItem("ERROR Error in GetNumberOfImages()");
					DestroyConnection();
					break;
				case 3 : AddNewItem("ERROR Error in CreateFaxObject()");
					DestroyConnection();
					break;
				case 2: AddNewItem("ERROR Error in SendFaxNow()");
					DestroyConnection();
					break;
				case 1 : AddNewItem("ERROR Error in SetFilePage()");
					DestroyConnection();
					break;
			}
		}

		public void VoiceOCX_ModemOK()
		{
		}
	}
}
