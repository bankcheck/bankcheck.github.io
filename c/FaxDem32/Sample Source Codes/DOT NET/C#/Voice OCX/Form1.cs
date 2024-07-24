using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;

namespace VoiceOCXDemo
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class Form1 : System.Windows.Forms.Form
	{
		private System.Windows.Forms.MainMenu mainMenu1;
		private System.Windows.Forms.MenuItem menuItem1;
		private System.Windows.Forms.MenuItem Exitmenu;
		private System.Windows.Forms.MenuItem menuItem2;
		public Array fModemID = Array.CreateInstance(typeof(int), 257, 2);
		public Array szVoiceCaps = Array.CreateInstance(typeof(string), 6);
		public Array fAutoForms = Array.CreateInstance(typeof(AutoAnswer), 257);
		public Array szVocExts = Array.CreateInstance(typeof(string), 10);
		private System.Windows.Forms.MenuItem VoiceFaxmenu;
		private System.Windows.Forms.MenuItem OpenPortmenu;
		private System.Windows.Forms.MenuItem menuItem3;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;
		private System.Windows.Forms.MenuItem menuDialogic;
		private ComOpen dlgCOM = null;
		private DialogicOpen dlgDialogic = null;
		private System.Windows.Forms.MenuItem menuItem4;
		private System.Windows.Forms.MenuItem menuNMS;
		private BrooktroutOpen dlgBrooktrout = null;
		private NMSOpen dlgNMS = null;
		public AxVOICEOCXLib.AxVoiceOCX axVoiceOCX1;
		public string szExePath;
		public Form1()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
			szVoiceCaps.SetValue("Data" , 0); 
			szVoiceCaps.SetValue("Class1", 1);
			szVoiceCaps.SetValue("Class2", 2); 
			szVoiceCaps.SetValue("Voice", 3);
			szVoiceCaps.SetValue("VoiceView", 4);
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
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
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(Form1));
			this.mainMenu1 = new System.Windows.Forms.MainMenu();
			this.menuItem1 = new System.Windows.Forms.MenuItem();
			this.Exitmenu = new System.Windows.Forms.MenuItem();
			this.VoiceFaxmenu = new System.Windows.Forms.MenuItem();
			this.OpenPortmenu = new System.Windows.Forms.MenuItem();
			this.menuItem3 = new System.Windows.Forms.MenuItem();
			this.menuDialogic = new System.Windows.Forms.MenuItem();
			this.menuItem4 = new System.Windows.Forms.MenuItem();
			this.menuNMS = new System.Windows.Forms.MenuItem();
			this.menuItem2 = new System.Windows.Forms.MenuItem();
			this.axVoiceOCX1 = new AxVOICEOCXLib.AxVoiceOCX();
			((System.ComponentModel.ISupportInitialize)(this.axVoiceOCX1)).BeginInit();
			this.SuspendLayout();
			// 
			// mainMenu1
			// 
			this.mainMenu1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.menuItem1,
																					  this.VoiceFaxmenu,
																					  this.menuItem2});
			// 
			// menuItem1
			// 
			this.menuItem1.Index = 0;
			this.menuItem1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.Exitmenu});
			this.menuItem1.Text = "&File";
			// 
			// Exitmenu
			// 
			this.Exitmenu.Index = 0;
			this.Exitmenu.Shortcut = System.Windows.Forms.Shortcut.CtrlX;
			this.Exitmenu.Text = "&Exit";
			this.Exitmenu.Click += new System.EventHandler(this.Exitmenu_Click);
			// 
			// VoiceFaxmenu
			// 
			this.VoiceFaxmenu.Index = 1;
			this.VoiceFaxmenu.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																						 this.OpenPortmenu});
			this.VoiceFaxmenu.Text = "&Voice/Fax";
			// 
			// OpenPortmenu
			// 
			this.OpenPortmenu.Index = 0;
			this.OpenPortmenu.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																						 this.menuItem3,
																						 this.menuDialogic,
																						 this.menuItem4,
																						 this.menuNMS});
			this.OpenPortmenu.Text = "&Open Port";
			// 
			// menuItem3
			// 
			this.menuItem3.Index = 0;
			this.menuItem3.Text = "&Com Port";
			this.menuItem3.Click += new System.EventHandler(this.menuItem3_Click);
			// 
			// menuDialogic
			// 
			this.menuDialogic.Index = 1;
			this.menuDialogic.Text = "&Dialogic Channel";
			this.menuDialogic.Click += new System.EventHandler(this.menuDialogic_Click);
			// 
			// menuItem4
			// 
			this.menuItem4.Index = 2;
			this.menuItem4.Text = "&Brooktrout Channel";
			this.menuItem4.Click += new System.EventHandler(this.menuItem4_Click);
			// 
			// menuNMS
			// 
			this.menuNMS.Index = 3;
			this.menuNMS.Text = "&NMS Channel";
			this.menuNMS.Click += new System.EventHandler(this.menuNMS_Click);
			// 
			// menuItem2
			// 
			this.menuItem2.Index = 2;
			this.menuItem2.Shortcut = System.Windows.Forms.Shortcut.F1;
			this.menuItem2.Text = "&About";
			this.menuItem2.Click += new System.EventHandler(this.menuItem2_Click);
			// 
			// axVoiceOCX1
			// 
			this.axVoiceOCX1.Enabled = true;
			this.axVoiceOCX1.Location = new System.Drawing.Point(88, 192);
			this.axVoiceOCX1.Name = "axVoiceOCX1";
			this.axVoiceOCX1.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("axVoiceOCX1.OcxState")));
			this.axVoiceOCX1.Size = new System.Drawing.Size(17, 17);
			this.axVoiceOCX1.TabIndex = 1;
			this.axVoiceOCX1.DTMFReceived += new AxVOICEOCXLib._DVoiceOCXEvents_DTMFReceivedEventHandler(this.axVoiceOCX1_DTMFReceived);
			this.axVoiceOCX1.AnswerEvent += new AxVOICEOCXLib._DVoiceOCXEvents_AnswerEventHandler(this.axVoiceOCX1_AnswerEvent);
			this.axVoiceOCX1.CallingTone += new AxVOICEOCXLib._DVoiceOCXEvents_CallingToneEventHandler(this.axVoiceOCX1_CallingTone);
			this.axVoiceOCX1.ModemError += new AxVOICEOCXLib._DVoiceOCXEvents_ModemErrorEventHandler(this.axVoiceOCX1_ModemError);
			this.axVoiceOCX1.FaxTerminated += new AxVOICEOCXLib._DVoiceOCXEvents_FaxTerminatedEventHandler(this.axVoiceOCX1_FaxTerminated);
			this.axVoiceOCX1.FaxReceived += new AxVOICEOCXLib._DVoiceOCXEvents_FaxReceivedEventHandler(this.axVoiceOCX1_FaxReceived);
			this.axVoiceOCX1.PortOpen += new AxVOICEOCXLib._DVoiceOCXEvents_PortOpenEventHandler(this.axVoiceOCX1_PortOpen);
			this.axVoiceOCX1.Ring += new AxVOICEOCXLib._DVoiceOCXEvents_RingEventHandler(this.axVoiceOCX1_Ring);
			this.axVoiceOCX1.VoicePlayStarted += new AxVOICEOCXLib._DVoiceOCXEvents_VoicePlayStartedEventHandler(this.axVoiceOCX1_VoicePlayStarted);
			this.axVoiceOCX1.OnHook += new AxVOICEOCXLib._DVoiceOCXEvents_OnHookEventHandler(this.axVoiceOCX1_OnHook);
			this.axVoiceOCX1.VoiceRecordStarted += new AxVOICEOCXLib._DVoiceOCXEvents_VoiceRecordStartedEventHandler(this.axVoiceOCX1_VoiceRecordStarted);
			this.axVoiceOCX1.HangUpEvent += new AxVOICEOCXLib._DVoiceOCXEvents_HangUpEventHandler(this.axVoiceOCX1_HangUpEvent);
			this.axVoiceOCX1.VoicePlayFinished += new AxVOICEOCXLib._DVoiceOCXEvents_VoicePlayFinishedEventHandler(this.axVoiceOCX1_VoicePlayFinished);
			this.axVoiceOCX1.AnswerTone += new AxVOICEOCXLib._DVoiceOCXEvents_AnswerToneEventHandler(this.axVoiceOCX1_AnswerTone);
			this.axVoiceOCX1.EndSend += new AxVOICEOCXLib._DVoiceOCXEvents_EndSendEventHandler(this.axVoiceOCX1_EndSend);
			this.axVoiceOCX1.ModemOK += new AxVOICEOCXLib._DVoiceOCXEvents_ModemOKEventHandler(this.axVoiceOCX1_ModemOK);
			this.axVoiceOCX1.VoiceRecordFinished += new AxVOICEOCXLib._DVoiceOCXEvents_VoiceRecordFinishedEventHandler(this.axVoiceOCX1_VoiceRecordFinished);
			this.axVoiceOCX1.EndReceive += new AxVOICEOCXLib._DVoiceOCXEvents_EndReceiveEventHandler(this.axVoiceOCX1_EndReceive);
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(292, 273);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.axVoiceOCX1});
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.Menu = this.mainMenu1;
			this.Name = "Form1";
			this.Text = "Voice OCX C# Demo v1.0";
			this.Resize += new System.EventHandler(this.Form1_Resize);
			this.Load += new System.EventHandler(this.Form1_Load);
			this.Closed += new System.EventHandler(this.Form1_Closed);
			((System.ComponentModel.ISupportInitialize)(this.axVoiceOCX1)).EndInit();
			this.ResumeLayout(false);

		}
		#endregion

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new Form1());
		}

		private void Exitmenu_Click(object sender, System.EventArgs e)
		{
			Close();
		}

		private void menuItem2_Click(object sender, System.EventArgs e)
		{
			AboutForm dlgAbout = new AboutForm();
			dlgAbout.ShowDialog();
		}

		private void Form1_Resize(object sender, System.EventArgs e)
		{
			System.Drawing.Rectangle	formSize;
			formSize = ClientRectangle;
			/*MsgBox.Left = 0;
			MsgBox.Top = 0;
			MsgBox.Width = formSize.Width;
			MsgBox.Height = formSize.Height;*/
		}

		private void Form1_Closed(object sender, System.EventArgs e)
		{
			for (int i = 1; i < 257; ++i)
				if ((int)fModemID.GetValue(i, 0) != 0)
					axVoiceOCX1.DestroyModemObject((int)fModemID.GetValue(i, 0));
		}

		private void Form1_Load(object sender, System.EventArgs e)
		{
			Array.Clear(fModemID, 0, fModemID.Length);
			/*for (int i = 1; i <= 255; ++i)
			{
				fModemID.SetValue(-1, i, 1);
				fModemID.SetValue(0, i, 0);
			}*/

			szExePath = Application.StartupPath;

			szVoiceCaps.SetValue("Data", 1);
			szVoiceCaps.SetValue("Class1", 2);
			szVoiceCaps.SetValue("Class2", 3);
			szVoiceCaps.SetValue("Voice", 4);
			szVoiceCaps.SetValue("VoiceView", 5);
    
			szVocExts.SetValue(".VOC",1);
			szVocExts.SetValue(".WAV", 2);
			szVocExts.SetValue(".WAV", 3);
			szVocExts.SetValue(".WAV", 4);
			szVocExts.SetValue(".WAV", 5);
			szVocExts.SetValue(".WAV", 6);
			szVocExts.SetValue(".WAV", 7);
			szVocExts.SetValue(".WAV", 8);
			szVocExts.SetValue(".WAV", 9);
		}

		private void menuItem3_Click(object sender, System.EventArgs e)
		{
			int modemID, index;
			
			dlgCOM = new ComOpen();
			dlgCOM.parent = this;
			dlgCOM.ShowDialog();
		
			modemID = dlgCOM.GetSelectedPort();
			index = FindTagToModemID(modemID);
			if (index > 0)
			{
				//user selected a communication port
				CreateAutoAnswerChild(index);
				if (dlgCOM.GetLogEnabled())
					axVoiceOCX1.EnableLog(modemID, true);
			}
		}

		public int FindTagToModemID(int modem)
		{
			int retval = 0, i = 1;

			if (modem != 0)
			{
				for (; i < 257; ++i)
					if ((int)fModemID.GetValue(i, 0) == modem)
						break;
				if (i < 257)
					retval = i;
				else 
					retval = 0;
			}
			return retval;
		}

		public int AddNewModem(int modem)
		{
			int retval = 0, i = 1;

			for (; i < 257; ++i)
				if ((int)fModemID.GetValue(i, 1) == 0)
				{
					fModemID.SetValue(modem, i, 0);
					fModemID.SetValue(-1, i, 1);
					break;
				}
			if (i < 257)
				retval = i;
			else 
				retval = 0;
			return retval;
		}

		private void axVoiceOCX1_AnswerTone(object sender, AxVOICEOCXLib._DVoiceOCXEvents_AnswerToneEvent e)
		{
			int index = FindTagToModemID(e.modemID);

			if ((index != -1) && ((int)fModemID.GetValue(index, 1) == 1))
				((AutoAnswer)fAutoForms.GetValue(index)).VoiceOCX_AnswerTone(); 		
		}

		private void axVoiceOCX1_ModemError(object sender, AxVOICEOCXLib._DVoiceOCXEvents_ModemErrorEvent e)
		{
			int index = FindTagToModemID(e.modemID);

			if (index != -1)
				switch ((int)fModemID.GetValue(index, 1))
				{
					case -1 : //no modem attached
						MessageBox.Show("Modem OK received on port: " + axVoiceOCX1.GetPortName(e.modemID));
						break;
					case 0 : //select port
						dlgCOM.VOICEOCX_ModemError(sender, e);
						break;
					case 1 : //autoanswer
						((AutoAnswer)fAutoForms.GetValue(index)).VoiceOCX_ModemError();
						break;
					case 2 : //dialogic
						dlgDialogic.VoiceOCX_ModemError();
						break;
					case 3 : //Brooktrout
						dlgBrooktrout.VoiceOCX_ModemError();
						break;
					case 4 : //NMS
						dlgNMS.VoiceOCX_ModemError();
						break;
				}
		}

		private void axVoiceOCX1_ModemOK(object sender, AxVOICEOCXLib._DVoiceOCXEvents_ModemOKEvent e)
		{
			int index = FindTagToModemID(e.modemID);

			if (index != -1)
				switch ((int)fModemID.GetValue(index, 1))
				{
					case 0 : //select port
						dlgCOM.VOICEOCX_ModemOK(sender, e);
						break;
					case 1 : //autoanswer
						((AutoAnswer)fAutoForms.GetValue(index)).VoiceOCX_ModemOK();
						break;
				}
		}

		private void axVoiceOCX1_PortOpen(object sender, AxVOICEOCXLib._DVoiceOCXEvents_PortOpenEvent e)
		{
			
			int index = FindTagToModemID(e.modemID);

			if (index != -1)
				switch ((int)fModemID.GetValue(index, 1))
				{
					case -1 : //no modem attached
						MessageBox.Show("Modem OK received on port: " + axVoiceOCX1.GetPortName(e.modemID));
						break;
					case 0 : //select port
						dlgCOM.VOICEOCX_PortOpen(sender, e);
						break;
					case 2 : //dialogic
						dlgDialogic.VoiceOCX_PortOpen();
						break;
					case 3 : //Brooktrout
						dlgBrooktrout.VoiceOCX_PortOpen();
						break;
					case 4 : //NMS
						dlgNMS.VoiceOCX_PortOpen();
						break;
				}
		}

		private void axVoiceOCX1_AnswerEvent(object sender, AxVOICEOCXLib._DVoiceOCXEvents_AnswerEvent e)
		{
			int index = FindTagToModemID(e.modemID);

			if ((index != -1) && ((int)fModemID.GetValue(index, 1) == 1))
				((AutoAnswer)fAutoForms.GetValue(index)).VoiceOCX_Answer(); 
		}

		private void menuDialogic_Click(object sender, System.EventArgs e)
		{
			int modemID, index;

			dlgDialogic = new DialogicOpen();
			dlgDialogic.parent = this;
			dlgDialogic.ShowDialog();

			modemID = dlgDialogic.GetSelectedChannel();
			index = FindTagToModemID(modemID);
			if (index > 0)
			{
				//user selected a communication port
				CreateAutoAnswerChild(index);
			}
		}

		public void CreateAutoAnswerChild(int index)
		{
			fAutoForms.SetValue(new AutoAnswer(), index);
			fModemID.SetValue(1, index, 1);		//autoanswer
			((AutoAnswer)fAutoForms.GetValue(index)).parent = this;
			((AutoAnswer)fAutoForms.GetValue(index)).SetModemID((int)fModemID.GetValue(index , 0));
			((AutoAnswer)fAutoForms.GetValue(index)).Show();
		}

		public void DeleteModem(int modem)
		{
			for (int i = 1; i <= 255; ++i)
				if ((int)fModemID.GetValue(i, 0) == modem)	
				{
					fModemID.SetValue(0, i, 0);
					fModemID.SetValue(-1, i, 1);
				}
		}

		private void menuItem4_Click(object sender, System.EventArgs e)
		{
			int modemID, index;
			
			dlgBrooktrout = new BrooktroutOpen();
			dlgBrooktrout.parent = this;
			dlgBrooktrout.ShowDialog();
		
			modemID = dlgBrooktrout.GetSelectedChannel();
			index = FindTagToModemID(modemID);
			if (index > 0)
			{
				//user selected a communication port
				CreateAutoAnswerChild(index);
				if (dlgBrooktrout.GetLogEnabled())
					axVoiceOCX1.EnableLog(modemID, true);
			}
		}

		private void menuNMS_Click(object sender, System.EventArgs e)
		{
			int modemID, index;
			
			dlgNMS = new NMSOpen();
			dlgNMS.parent = this;
			dlgNMS.ShowDialog();
		
			modemID = dlgNMS.GetSelectedChannel();
			index = FindTagToModemID(modemID);
			if (index > 0)
			{
				//user selected a communication port
				CreateAutoAnswerChild(index);
				if (dlgNMS.GetLogEnabled())
					axVoiceOCX1.EnableLog(modemID, true);
			}
		}

		public void SetVocExtension(int modem, ref string szFile)
		{
			int index = axVoiceOCX1.GetModemType(modem) + 1;

			if (szFile.Substring(szFile.Length - 4).CompareTo((string)szVocExts.GetValue(index)) != 0)
			{
				if (szFile.Substring(szFile.Length - 4, 1) == ".")
					ChangeExt(ref szFile, (string)szVocExts.GetValue(index));
				else
					szFile += szVocExts.GetValue(index);
			}
		}

		public void ChangeExt(ref string szFile, string szExt)
		{
			szFile = szFile.Substring(szFile.Length - 4) + szExt;
		}

		private void axVoiceOCX1_CallingTone(object sender, AxVOICEOCXLib._DVoiceOCXEvents_CallingToneEvent e)
		{
			int index = FindTagToModemID(e.modemID);

			if ((index != -1) && ((int)fModemID.GetValue(index, 1) == 1))
				((AutoAnswer)fAutoForms.GetValue(index)).VoiceOCX_CallingTone(); 
		}

		private void axVoiceOCX1_DTMFReceived(object sender, AxVOICEOCXLib._DVoiceOCXEvents_DTMFReceivedEvent e)
		{
			int index = FindTagToModemID(e.modemID);

			if ((index != -1) && ((int)fModemID.GetValue(index, 1) == 1))
				((AutoAnswer)fAutoForms.GetValue(index)).VoiceOCX_DTMFReceived(); 
		}

		private void axVoiceOCX1_EndReceive(object sender, AxVOICEOCXLib._DVoiceOCXEvents_EndReceiveEvent e)
		{
			int index = FindTagToModemID(e.modemID);

			if ((index != -1) && ((int)fModemID.GetValue(index, 1) == 1))
				((AutoAnswer)fAutoForms.GetValue(index)).VoiceOCX_EndReceive(); 
		}

		private void axVoiceOCX1_EndSend(object sender, AxVOICEOCXLib._DVoiceOCXEvents_EndSendEvent e)
		{
			int index = FindTagToModemID(e.modemID);

			if ((index != -1) && ((int)fModemID.GetValue(index, 1) == 1))
				((AutoAnswer)fAutoForms.GetValue(index)).VoiceOCX_EndSend(); 
		}

		private void axVoiceOCX1_FaxReceived(object sender, AxVOICEOCXLib._DVoiceOCXEvents_FaxReceivedEvent e)
		{
			int index = FindTagToModemID(e.modemID);

			if ((index != -1) && ((int)fModemID.GetValue(index, 1) == 1))
				((AutoAnswer)fAutoForms.GetValue(index)).VoiceOCX_FaxReceived(e.faxID, e.remoteID); 
		}

		private void axVoiceOCX1_FaxTerminated(object sender, AxVOICEOCXLib._DVoiceOCXEvents_FaxTerminatedEvent e)
		{
			int index = FindTagToModemID(e.modemID);

			if ((index != -1) && ((int)fModemID.GetValue(index, 1) == 1))
				((AutoAnswer)fAutoForms.GetValue(index)).VoiceOCX_FaxTerminated(e.tStatus); 
		}

		private void axVoiceOCX1_HangUpEvent(object sender, AxVOICEOCXLib._DVoiceOCXEvents_HangUpEvent e)
		{
			int index = FindTagToModemID(e.modemID);

			if ((index != -1) && ((int)fModemID.GetValue(index, 1) == 1))
				((AutoAnswer)fAutoForms.GetValue(index)).VoiceOCX_HangUp();
		}

		private void axVoiceOCX1_OnHook(object sender, AxVOICEOCXLib._DVoiceOCXEvents_OnHookEvent e)
		{
			int index = FindTagToModemID(e.modemID);

			if ((index != -1) && ((int)fModemID.GetValue(index, 1) == 1))
				((AutoAnswer)fAutoForms.GetValue(index)).VoiceOCX_OnHook(); 
		}

		private void axVoiceOCX1_Ring(object sender, AxVOICEOCXLib._DVoiceOCXEvents_RingEvent e)
		{
			int index = FindTagToModemID(e.modemID);

			if (index != -1)
				switch ((int)fModemID.GetValue(index, 1))
				{
					case -1 : 
						MessageBox.Show("Modem detected RING on port: " + axVoiceOCX1.GetPortName((int)fModemID.GetValue(index, 0)));
						break;
					case 1 : //autoanswer
						((AutoAnswer)fAutoForms.GetValue(index)).VoiceOCX_Ring();
						break;
				}		
		}

		private void axVoiceOCX1_VoicePlayFinished(object sender, AxVOICEOCXLib._DVoiceOCXEvents_VoicePlayFinishedEvent e)
		{
			int index = FindTagToModemID(e.modemID);

			if ((index != -1) && ((int)fModemID.GetValue(index, 1) == 1))
				((AutoAnswer)fAutoForms.GetValue(index)).VoiceOCX_VoicePlayFinished(); 
		}

		private void axVoiceOCX1_VoicePlayStarted(object sender, AxVOICEOCXLib._DVoiceOCXEvents_VoicePlayStartedEvent e)
		{
			int index = FindTagToModemID(e.modemID);

			if ((index != -1) && ((int)fModemID.GetValue(index, 1) == 1))
				((AutoAnswer)fAutoForms.GetValue(index)).VoiceOCX_VoicePlayStarted();
		}

		private void axVoiceOCX1_VoiceRecordFinished(object sender, AxVOICEOCXLib._DVoiceOCXEvents_VoiceRecordFinishedEvent e)
		{
			int index = FindTagToModemID(e.modemID);

			if ((index != -1) && ((int)fModemID.GetValue(index, 1) == 1))
				((AutoAnswer)fAutoForms.GetValue(index)).VoiceOCX_VoiceRecordFinished();
		}

		private void axVoiceOCX1_VoiceRecordStarted(object sender, AxVOICEOCXLib._DVoiceOCXEvents_VoiceRecordStartedEvent e)
		{
			int index = FindTagToModemID(e.modemID);

			if ((index != -1) && ((int)fModemID.GetValue(index, 1) == 1))
				((AutoAnswer)fAutoForms.GetValue(index)).VoiceOCX_VoiceRecordStarted();
		}
	}
}
