using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Runtime.InteropServices; 
using System.IO;
using System.Threading;
using System.Timers;

namespace FaxcppDemo
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	
	public class Form1 : System.Windows.Forms.Form
	{
		private System.Windows.Forms.MainMenu mainMenu1;
		private System.Windows.Forms.MenuItem menuItem1;
		private System.Windows.Forms.MenuItem menuItem2;
		private System.Windows.Forms.MenuItem menuItem3;
		private System.Windows.Forms.MenuItem menuItem4;
		private System.Windows.Forms.MenuItem menuShowFaxman;
		private System.Windows.Forms.MenuItem menuSend;
		private System.Windows.Forms.MenuItem menuClosePort;
		public AxFAXLib.AxFAX axFAX1;
		private System.Windows.Forms.MenuItem menuItem5;
		private System.Windows.Forms.MenuItem menuItem6;
		public int BaudRate, m_SpeakerMode, m_SpeakerVolume, m_EnableECM, m_EnableBTF;
		public bool m_bDialMode;
		public bool m_bEnblDebug;
		public bool m_bDTMF;
		public string m_ActualFaxPort;
		private ArrayList retrylist;
		private ArrayList ArrayA;
		private ArrayList ArrayB;
		private Mutex hMutex;
		private string currdir;
		public System.Windows.Forms.ListBox textBox1;
		private System.Windows.Forms.SaveFileDialog saveFileDialog1;
		private System.Windows.Forms.MenuItem menuItem7;
		private System.Windows.Forms.MenuItem menuItem8;
		private System.Windows.Forms.PageSetupDialog pageSetupDialog1;
		private System.Windows.Forms.MenuItem menuComPort;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public Form1()
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
			this.menuItem5 = new System.Windows.Forms.MenuItem();
			this.menuItem6 = new System.Windows.Forms.MenuItem();
			this.menuItem2 = new System.Windows.Forms.MenuItem();
			this.menuItem4 = new System.Windows.Forms.MenuItem();
			this.menuComPort = new System.Windows.Forms.MenuItem();
			this.menuShowFaxman = new System.Windows.Forms.MenuItem();
			this.menuSend = new System.Windows.Forms.MenuItem();
			this.menuClosePort = new System.Windows.Forms.MenuItem();
			this.menuItem7 = new System.Windows.Forms.MenuItem();
			this.menuItem3 = new System.Windows.Forms.MenuItem();
			this.menuItem8 = new System.Windows.Forms.MenuItem();
			this.axFAX1 = new AxFAXLib.AxFAX();
			this.textBox1 = new System.Windows.Forms.ListBox();
			this.saveFileDialog1 = new System.Windows.Forms.SaveFileDialog();
			this.pageSetupDialog1 = new System.Windows.Forms.PageSetupDialog();
			((System.ComponentModel.ISupportInitialize)(this.axFAX1)).BeginInit();
			this.SuspendLayout();
			// 
			// mainMenu1
			// 
			this.mainMenu1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.menuItem1,
																					  this.menuItem4,
																					  this.menuItem7});
			// 
			// menuItem1
			// 
			this.menuItem1.Index = 0;
			this.menuItem1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.menuItem5,
																					  this.menuItem6,
																					  this.menuItem2});
			this.menuItem1.Text = "&File";
			// 
			// menuItem5
			// 
			this.menuItem5.Index = 0;
			this.menuItem5.Shortcut = System.Windows.Forms.Shortcut.Del;
			this.menuItem5.Text = "&Clear";
			this.menuItem5.Click += new System.EventHandler(this.menuItem5_Click);
			// 
			// menuItem6
			// 
			this.menuItem6.Index = 1;
			this.menuItem6.Text = "-";
			// 
			// menuItem2
			// 
			this.menuItem2.Index = 2;
			this.menuItem2.Shortcut = System.Windows.Forms.Shortcut.CtrlX;
			this.menuItem2.Text = "&Exit";
			this.menuItem2.Click += new System.EventHandler(this.menuItem2_Click);
			// 
			// menuItem4
			// 
			this.menuItem4.Index = 1;
			this.menuItem4.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.menuComPort,
																					  this.menuShowFaxman,
																					  this.menuSend,
																					  this.menuClosePort});
			this.menuItem4.Text = "F&ax";
			this.menuItem4.Popup += new System.EventHandler(this.menuItem4_Popup);
			// 
			// menuComPort
			// 
			this.menuComPort.Index = 0;
			this.menuComPort.Text = "&Open Com Port...";
			this.menuComPort.Click += new System.EventHandler(this.menuComPort_Click);
			// 
			// menuShowFaxman
			// 
			this.menuShowFaxman.Checked = true;
			this.menuShowFaxman.Enabled = false;
			this.menuShowFaxman.Index = 1;
			this.menuShowFaxman.Text = "&Show Fax Manager";
			this.menuShowFaxman.Click += new System.EventHandler(this.menuShowFaxman_Click);
			// 
			// menuSend
			// 
			this.menuSend.Enabled = false;
			this.menuSend.Index = 2;
			this.menuSend.Text = "S&end...";
			this.menuSend.Click += new System.EventHandler(this.menuSend_Click);
			// 
			// menuClosePort
			// 
			this.menuClosePort.Enabled = false;
			this.menuClosePort.Index = 3;
			this.menuClosePort.Text = "&Close Com Port...";
			this.menuClosePort.Click += new System.EventHandler(this.menuClosePort_Click);
			// 
			// menuItem7
			// 
			this.menuItem7.Index = 2;
			this.menuItem7.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.menuItem3,
																					  this.menuItem8});
			this.menuItem7.Text = "&Help";
			// 
			// menuItem3
			// 
			this.menuItem3.Index = 0;
			this.menuItem3.Shortcut = System.Windows.Forms.Shortcut.F1;
			this.menuItem3.Text = "&About...";
			this.menuItem3.Click += new System.EventHandler(this.menuItem3_Click);
			// 
			// menuItem8
			// 
			this.menuItem8.Index = 1;
			this.menuItem8.Text = "&Fax C++ OCX Help";
			this.menuItem8.Click += new System.EventHandler(this.menuItem8_Click);
			// 
			// axFAX1
			// 
			this.axFAX1.Enabled = true;
			this.axFAX1.Location = new System.Drawing.Point(200, 168);
			this.axFAX1.Name = "axFAX1";
			this.axFAX1.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("axFAX1.OcxState")));
			this.axFAX1.Size = new System.Drawing.Size(16, 16);
			this.axFAX1.TabIndex = 1;
			this.axFAX1.StartSend += new AxFAXLib._DFAXEvents_StartSendEventHandler(this.axFAX1_StartSend);
			this.axFAX1.TerminateExt += new AxFAXLib._DFAXEvents_TerminateExtEventHandler(this.axFAX1_TerminateExt);
			this.axFAX1.Dial += new AxFAXLib._DFAXEvents_DialEventHandler(this.axFAX1_Dial);
			this.axFAX1.StartPage += new AxFAXLib._DFAXEvents_StartPageEventHandler(this.axFAX1_StartPage);
			this.axFAX1.EndSend += new AxFAXLib._DFAXEvents_EndSendEventHandler(this.axFAX1_EndSend);
			this.axFAX1.EndPage += new AxFAXLib._DFAXEvents_EndPageEventHandler(this.axFAX1_EndPage);
			// 
			// textBox1
			// 
			this.textBox1.IntegralHeight = false;
			this.textBox1.Location = new System.Drawing.Point(184, 40);
			this.textBox1.Name = "textBox1";
			this.textBox1.Size = new System.Drawing.Size(48, 69);
			this.textBox1.TabIndex = 2;
			// 
			// saveFileDialog1
			// 
			this.saveFileDialog1.DefaultExt = "tif";
			this.saveFileDialog1.Filter = "Bitmap Format (*.bmp)|*.bmp|TIFF File Format(*.tif)|*.tif";
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(328, 273);
			this.Controls.Add(this.textBox1);
			this.Controls.Add(this.axFAX1);
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.Menu = this.mainMenu1;
			this.Name = "Form1";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Fax ActiveX Control - C# .NET Retry Sample";
			this.Resize += new System.EventHandler(this.Form1_Resize);
			this.Load += new System.EventHandler(this.Form1_Load);
			this.Closed += new System.EventHandler(this.Form1_Closed);
			((System.ComponentModel.ISupportInitialize)(this.axFAX1)).EndInit();
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

		/* Exit */
		private void menuItem2_Click(object sender, System.EventArgs e)
		{
			this.Close();
		}

		/* Show About form */
		private void menuItem3_Click(object sender, System.EventArgs e)
		{
			AboutForm formAbout = new AboutForm();
			formAbout.ShowDialog();
		}

		/* Form1 resize event handler */
		private void Form1_Resize(object sender, System.EventArgs e)
		{
			System.Drawing.Rectangle	formSize;
			formSize = this.ClientRectangle;
			textBox1.Left = 0;
			textBox1.Top = 0;
			textBox1.Width = formSize.Width;
			textBox1.Height = formSize.Height;
		}

		private void menuItem5_Click(object sender, System.EventArgs e)
		{
			textBox1.Items.Clear();
		}
		
		public void SetMenuItems(bool par)
		{
			menuShowFaxman.Enabled = par;
			menuSend.Enabled = par;
			menuClosePort.Enabled = par;
		}

		public void SetComportMenu(bool par)
		{
			menuComPort.Enabled = par;
		}

		const long INFINITE = 0xFFFFFFFF;

		private void Form1_Load(object sender, System.EventArgs e)
		{
			BaudRate = 15;
			m_SpeakerMode = 2;
			m_SpeakerVolume = 0;
			axFAX1.SpeakerMode = FAXLib.enumSpeakerMode.UntilConnected;
			axFAX1.SpeakerVolume = FAXLib.enumSpeakerVolume.Medium;
			axFAX1.ToneDial = true;
			m_bDialMode = true;
			axFAX1.ToneDial = true;
			m_EnableECM = 3;
			m_EnableBTF = 2;
			m_bEnblDebug = false;
			m_bDTMF = false;
			axFAX1.CloseAllPorts();
			textBox1.Items.Add("This sample shows how to try to resend a fax if the remote number");
			textBox1.Items.Add("is busy. The sample will try to resend the three minutes later.");
			textBox1.Items.Add("If sending the fax is unsuccessfull four times the sample will not try");
			textBox1.Items.Add("to send the fax again.");
			textBox1.Items.Add("To use the sample open a com port by choosing \"Open Com Port...\"");
			textBox1.Items.Add("from Fax menu and select from available ports.");
			textBox1.Items.Add("To send a fax select \"Send...\" from Fax menu, then specify the file");
			textBox1.Items.Add("to be sent and the remote phone number.");
			textBox1.Items.Add("To close a com port choose \"Close Com Port...\" from Fax menu and");
			textBox1.Items.Add("select from the ports open.");
			retrylist=new ArrayList();
			ArrayA=new ArrayList();
			ArrayB= new ArrayList();
			hMutex=new Mutex(false);
			currdir=Directory.GetCurrentDirectory();
			if (axFAX1.AvailablePorts.Length > 0)
				menuComPort.Enabled = true;
		}

		private void Form1_Closed(object sender, System.EventArgs e)
		{
			this.Cursor = Cursors.WaitCursor;
			this.Enabled = false;
			axFAX1.CloseAllPorts();
			this.Cursor = Cursors.Default;
		}

		private void menuShowFaxman_Click(object sender, System.EventArgs e)
		{
			axFAX1.DisplayFaxManager = !axFAX1.DisplayFaxManager;
			if (axFAX1.DisplayFaxManager)
				menuShowFaxman.Checked = true;
			else
				menuShowFaxman.Checked = false;
		}

		private void menuClosePort_Click(object sender, System.EventArgs e)
		{
			portClose dlgportClose = new portClose();
			dlgportClose.parent = this;
			dlgportClose.ShowDialog();
		}

		private void menuSend_Click(object sender, System.EventArgs e)
		{
			SendFile dlgSend = new SendFile();
			dlgSend.parent = this;
			dlgSend.ShowDialog();
		}

		private void axFAX1_Dial(object sender, AxFAXLib._DFAXEvents_DialEvent e)
		{
			textBox1.Items.Add("Dialing on " + e.portName);
		}

		private void axFAX1_EndPage(object sender, AxFAXLib._DFAXEvents_EndPageEvent e)
		{
			textBox1.Items.Add("Ending page " + Convert.ToString(e.lPageNumber, 10) + " on port " + e.szPort);
			textBox1.Items.Add("Page in file " + axFAX1.GetLastPageFile(e.szPort));
		}

		private void axFAX1_EndSend(object sender, AxFAXLib._DFAXEvents_EndSendEvent e)
		{	
			hMutex.WaitOne();
			setCurrentlySending(e.faxID,false);
			AddToArrayA(e.portName,e.faxID);
			long status=GetStatus(e.portName);
			if (status!=-1)
			{
				if (status==6)
				{
					if (IsFaxObjInList(e.faxID)==false)
					{
						AddToList(e.faxID,e.portName);
						System.Timers.Timer t=new System.Timers.Timer(180000);
						t.Enabled=true;
						t.AutoReset=true;
						t.Elapsed += new System.Timers.ElapsedEventHandler(this.timer1_Elapsed);
						SetTimerID(e.faxID,t);
						textBox1.Items.Add("Remote number was busy. Trying to send the fax three minutes later.");
					}
					else
						if (GetRetryNumber(e.faxID)<=0)
					{
						object tempTimer= GetTimerID(e.faxID);
						if (tempTimer!= null) 
						{
							((System.Timers.Timer) tempTimer).Close();
						}
						DeleteFromList(e.faxID);
						axFAX1.ClearFaxObject((int)e.faxID);
					}
				}
				else
				{
					object tempTimer= GetTimerID(e.faxID);
					if (tempTimer!= null) 
					{
							((System.Timers.Timer) tempTimer).Close();
					}
					DeleteFromList(e.faxID);		
					axFAX1.ClearFaxObject((int)e.faxID);
				}
				DeleteFromArrayA(e.portName,e.faxID);
				DeleteFromArrayB(e.portName,status);
			}
			hMutex.ReleaseMutex();
			textBox1.Items.Add("FaxID: "+e.faxID.ToString());
			textBox1.Items.Add("Sending finished on " + e.portName);
			textBox1.Items.Add("Remote ID : " + e.remoteID);
		}

		private void axFAX1_StartPage(object sender, AxFAXLib._DFAXEvents_StartPageEvent e)
		{
			textBox1.Items.Add("Starting page " + Convert.ToString(e.lPageNumber) + " on port " + e.szPort);
		}

		private void axFAX1_StartSend(object sender, AxFAXLib._DFAXEvents_StartSendEvent e)
		{
			textBox1.Items.Add("Starting to send on " + e.portName);
		}

		private void axFAX1_TerminateExt(object sender, AxFAXLib._DFAXEvents_TerminateExtEvent e)
		{
			hMutex.WaitOne();
			long FaxID=GetFaxID(e.lpPort);
			setCurrentlySending(FaxID,false);
			AddToArrayB(e.lpPort,e.lStatus);
			if (FaxID!=0)
			{
				if (e.lStatus==6)
				{
					if (IsFaxObjInList(FaxID)==false)
					{
						AddToList(FaxID,e.lpPort);
						System.Timers.Timer t=new System.Timers.Timer(180000);
						t.Enabled=true;
						t.AutoReset=true;
						t.Elapsed += new System.Timers.ElapsedEventHandler(this.timer1_Elapsed);
						SetTimerID(FaxID,t);
						textBox1.Items.Add("Remote number was busy. Trying to send the fax three minutes later.");
					}
					else
					if (GetRetryNumber(FaxID)<=0)
					{
						object tempTimer= GetTimerID(FaxID);
						if (tempTimer!= null) 
						{
							((System.Timers.Timer) tempTimer).Close();
						}
						DeleteFromList(FaxID);
						axFAX1.ClearFaxObject((int)FaxID);
					}
				}
				else
				{
					object tempTimer= GetTimerID(FaxID);
					if (tempTimer!= null) 
					{
						((System.Timers.Timer) tempTimer).Close();
					}
					DeleteFromList(FaxID);		
					axFAX1.ClearFaxObject((int)FaxID);
				}
				DeleteFromArrayA(e.lpPort,FaxID);
				DeleteFromArrayB(e.lpPort,e.lStatus);
			}
			hMutex.ReleaseMutex();
			textBox1.Items.Add("Transmission terminated on " + e.lpPort);
			textBox1.Items.Add(" - Termination status: " + axFAX1.ReturnErrorString(ref e.lStatus) + ", Connected for " + Convert.ToString(e.connectTime) + " milliseconds.");
			if (e.szDID.Length>0) textBox1.Items.Add("DID received on " + e.lpPort +": "+ e.szDID);
			if (e.szDTMF.Length>0) textBox1.Items.Add("DTMF received on " + e.lpPort +": "+ e.szDTMF);
		}

		public string GetError(int errorCode)
		{
			string retval = null;
			switch (errorCode)
			{
				case -150 : retval = "The specified file doesn’t exist.";
					break;
				case -151 : retval = "The specified communication port is invalid.";
					break;
				case -152 : retval = "The specified communication port doesn’t exist.";
					break;
				case -153 : retval = "Cannot connect to the port.";
					break;
				case -154 : retval = "No file was specified for sending.";
					break;
				case -155 : retval = "The creation of the fax object failed.";
					break;
				case -156 : retval = "The specified communication port was already initialized.";
					break;
				case -157 : retval = "An invalid fax modem type was specified.";
					break;
				case -158 : retval = "No phone number was specified for SetPhoneNumber function.";
					break;
				case -159 : retval = "Invalid fax ID was specified.";
					break;
				case -160 : retval = "Invalid image type was specified for SetFaxPage method.";
					break;
				case -161 : retval = "Invalid image filename was specified for SetFaxPage method.";
					break;
				case -162 : retval = "The attempt to open or convert the ASCII data to image was unsuccessful.";
					break;
				case -163 : retval = "There was no DIB handle specified before SetFaxPage method.";
					break;
				case -164 : retval = "Invalid DIB handle was specified before SetFaxPage method.";
					break;
				case -165 : retval = "There weren’t any ports open before an operation (SendFaxObj) which needed one.";
					break;
				case -166 : retval =  "The OCX wasn’t able to recognize the format of the specified image file.";
					break;
				case -167 : retval = "The modem test on the specified COM port was unsuccessful.";
					break;
				case -168 : retval = "Invalid filename specified.";
					break;
				case -169 : retval =  "The specified Brooktrout fax channel has no faxing capability.";
					break;
				case -170 : retval =  "No configuration file was specified before opening a Brooktrout or GammaLink fax channel.";
					break;
				case  -171 :  retval =  "The DEMO version of the Fax OCX supports only 1 fax port.";
					break;
				case  -172 : retval =  "The DEMO version of the Fax OCX supports only 1 page faxes.";
					break;
				default : retval = Convert.ToString(errorCode, 10);
					break;
			}
			return retval;
		}

		[DllImport("shell32.dll")]
		public static extern IntPtr ShellExecute(IntPtr hwnd,string lpOperation,
			string lpFile, string lpParameters, string lpDirectory, int nShowCmd);

		private void menuItem8_Click(object sender, System.EventArgs e)
		{
			string cdir=currdir;
			cdir=cdir + "\\..\\Help\\Black_Ice_Fax_C++_OCX_Help.chm";
			if (File.Exists(cdir))	
				Help.ShowHelp(this, cdir);
			else 
			{
				cdir=currdir;
				cdir=cdir+"\\Black_Ice_Fax_C++_OCX_Help.chm";
				if (File.Exists(cdir))
					Help.ShowHelp(this, cdir);
				else MessageBox.Show("The Black_Ice_Fax_C++_OCX_Help.chm help file was not found");
			}
		}

		private void menuItem4_Popup(object sender, System.EventArgs e)
		{
			if (axFAX1.DisplayFaxManager)
				menuShowFaxman.Checked = true;
			else
				menuShowFaxman.Checked = false;
			if (axFAX1.AvailablePorts.Length>0)
				SetComportMenu(true);
			else SetComportMenu(false);
		}

		public bool AddToList(long FaxID_,string PortName_)
		{
			hMutex.WaitOne();
			retry tempretry=new retry(FaxID_,PortName_);
			if (!tempretry.Equals(null))
			{
				retrylist.Add(tempretry);
				hMutex.ReleaseMutex();
				return true;
			}
			hMutex.ReleaseMutex();
			return false;
		}

		public bool SetTimerID(long FaxID_,object TimerID_)
		{
			hMutex.WaitOne();
			if (!retrylist.Equals(null))
			{
				for(int i=0;i<retrylist.Count;i++)
					if (((retry) retrylist[i]).FaxID==FaxID_)
					{
						((retry) retrylist[i]).TimerID=TimerID_;
						hMutex.ReleaseMutex();
						return true;
					}
			}
			hMutex.ReleaseMutex();
			return false;
		}
		public object GetTimerID(long FaxID_)
		{
			hMutex.WaitOne();
			if (!retrylist.Equals(null))
			{
				for(int i=0;i<retrylist.Count;i++)
					if (((retry) retrylist[i]).FaxID==FaxID_)
					{
						hMutex.ReleaseMutex();
						return ((retry) retrylist[i]).TimerID;
					}
			}
			hMutex.ReleaseMutex();
			return null;
		}

		public int GetRetryNumber(long FaxID_)
		{
			hMutex.WaitOne();
			if (!retrylist.Equals(null))
			{
				for(int i=0;i<retrylist.Count;i++)
					if (((retry) retrylist[i]).FaxID==FaxID_)
					{
						hMutex.ReleaseMutex();
						return ((retry) retrylist[i]).numberOfRetries;
					}
			}
			hMutex.ReleaseMutex();
			return -1;
		}

		public bool IsFaxObjInList(long FaxID_)
		{
			hMutex.WaitOne();
			if (!retrylist.Equals(null))
			{
				for(int i=0;i<retrylist.Count;i++)
					if (((retry) retrylist[i]).FaxID==FaxID_)
					{
						hMutex.ReleaseMutex();
						return true;
					}
			}
			hMutex.ReleaseMutex();
			return false;
		}

		public bool setCurrentlySending(long FaxID_,bool cr_)
		{
			hMutex.WaitOne();
			if (!retrylist.Equals(null))
			{
				for(int i=0;i<retrylist.Count;i++)
					if (((retry) retrylist[i]).FaxID==FaxID_)
					{
						((retry) retrylist[i]).currentlySending=cr_;
						hMutex.ReleaseMutex();
						return true;
					}
			}
			hMutex.ReleaseMutex();
			return false;
		}
		public bool DeleteFromList(long FaxID_)
		{
			hMutex.WaitOne();
			if (!retrylist.Equals(null))
			{
			 for(int i=0;i<retrylist.Count;i++)
				 if (((retry) retrylist[i]).FaxID==FaxID_)
				 {
					retrylist.RemoveAt(i);
					 hMutex.ReleaseMutex();
					 return true;
				 }
			}
			hMutex.ReleaseMutex();
			return false;
		}

		private void timer1_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
		{
			int iError=0;
			hMutex.WaitOne();
			if (!retrylist.Equals(null))
			{
				for(int i=0;i<retrylist.Count;i++)
					if (((retry) retrylist[i]).TimerID.Equals(sender))
					{
						if (((retry) retrylist[i]).numberOfRetries>0 && ((retry) retrylist[i]).currentlySending==false)
						{
							axFAX1.ChainOutItem((int)((retry) retrylist[i]).FaxID);
							iError=axFAX1.SendFaxObj((int)((retry) retrylist[i]).FaxID);
							if (iError!=0)
							{
								DeleteFromList(((retry) retrylist[i]).FaxID);
								MessageBox.Show("Cannot add the following fax object to queue: " + ((retry) retrylist[i]).FaxID.ToString());
								break;
							}
							else ((retry) retrylist[i]).currentlySending=true;
							((retry) retrylist[i]).numberOfRetries--;
						}
					break;
					}
			}
			hMutex.ReleaseMutex();
		}

		public void AddToArrayA(string PortName_,long FaxID_)
		{
			ArrayAType arrayAItem=new ArrayAType(PortName_,FaxID_);
			if (!arrayAItem.Equals(null))
			{
				ArrayA.Add(arrayAItem);
			}
		}
		public void AddToArrayB(string PortName_,long status_)
		{
			ArrayBType arrayBItem=new ArrayBType(PortName_,status_);
			if (!arrayBItem.Equals(null))
			{
				ArrayB.Add(arrayBItem);
			}
		}
		public void DeleteFromArrayA(string PortName_,long FaxID_)
		{
			if (!ArrayA.Equals(null))
			{
				for(int i=0;i<ArrayA.Count;i++)
					if (((ArrayAType) ArrayA[i]).PortName==PortName_ &&((ArrayAType) ArrayA[i]).FaxID==FaxID_)
					{
						ArrayA.RemoveAt(i);
						break;
					}
			}
		}
		public void DeleteFromArrayB(string PortName_,long status_)
		{
			if (!ArrayB.Equals(null))
			{
				for(int i=0;i<ArrayB.Count;i++)
					if (((ArrayBType) ArrayB[i]).PortName==PortName_ &&((ArrayBType) ArrayB[i]).status==status_)
					{
						ArrayB.RemoveAt(i);
						break;
					}
			}
		}
		public long GetFaxID(string PortName_)
		{
			if (!ArrayA.Equals(null))
			{
				for(int i=0;i<ArrayA.Count;i++)
					if (((ArrayAType) ArrayA[i]).PortName==PortName_)
					{
						return ((ArrayAType) ArrayA[i]).FaxID;
					}
			}
			return 0;
		}

		public long GetStatus(string PortName_)
		{
			if (!ArrayB.Equals(null))
			{
				for(int i=0;i<ArrayB.Count;i++)
					if (((ArrayBType) ArrayB[i]).PortName==PortName_)
					{
						return ((ArrayBType) ArrayB[i]).status;
					}
			}
			return -1;
		}

		private void menuComPort_Click(object sender, System.EventArgs e)
		{
			ComPort dlgComPort = new ComPort();
			dlgComPort.parent = this;
			dlgComPort.ShowDialog();
		}
	}
	public class retry
	{
		public long FaxID;
		public string PortName;
		public object TimerID;
		public int numberOfRetries;
		public bool currentlySending;
		public retry(long FaxID_,string PortName_)
		{
			FaxID=FaxID_;
			PortName=PortName_;
			TimerID=null;
			numberOfRetries=3;
			currentlySending=false;
		}
	}
	
	public class ArrayAType
	{
		public string PortName;
		public long FaxID;
		public ArrayAType(string PortName_,long FaxID_)
		{
			PortName=PortName_;
			FaxID=FaxID_;
		}
	}
	public class ArrayBType
	{
		public string PortName;
		public long status;
		public ArrayBType(string PortName_,long status_)
		{
			PortName=PortName_;
			status=status_;
		}
	}
	

}