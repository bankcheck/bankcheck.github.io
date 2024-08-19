using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Runtime.InteropServices; 
using System.IO;

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
		private System.Windows.Forms.MenuItem menuOpen;
		private System.Windows.Forms.MenuItem menuClosePort;
		private System.Windows.Forms.MenuItem menuBrooktrout;
		private System.Windows.Forms.MenuItem menuGammalink;
		private System.Windows.Forms.MenuItem menuDialogic;
		private System.Windows.Forms.MenuItem menuNMS;
		public AxFAXLib.AxFAX axFAX1;
		private System.Windows.Forms.MenuItem menuItem5;
		private System.Windows.Forms.MenuItem menuItem6;
		private string currdir;
		public System.Windows.Forms.ListBox textBox1;
		private System.Windows.Forms.MenuItem menuItem7;
		private System.Windows.Forms.MenuItem menuItem8;
		private System.Windows.Forms.MenuItem menuItem9;
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
			this.menuOpen = new System.Windows.Forms.MenuItem();
			this.menuBrooktrout = new System.Windows.Forms.MenuItem();
			this.menuGammalink = new System.Windows.Forms.MenuItem();
			this.menuDialogic = new System.Windows.Forms.MenuItem();
			this.menuNMS = new System.Windows.Forms.MenuItem();
			this.menuClosePort = new System.Windows.Forms.MenuItem();
			this.menuItem7 = new System.Windows.Forms.MenuItem();
			this.menuItem3 = new System.Windows.Forms.MenuItem();
			this.menuItem8 = new System.Windows.Forms.MenuItem();
			this.axFAX1 = new AxFAXLib.AxFAX();
			this.textBox1 = new System.Windows.Forms.ListBox();
			this.menuItem9 = new System.Windows.Forms.MenuItem();
			((System.ComponentModel.ISupportInitialize)(this.axFAX1)).BeginInit();
			this.SuspendLayout();
			// 
			// mainMenu1
			// 
			this.mainMenu1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.menuItem1,
																					  this.menuItem4,
																					  this.menuItem7,
																					  this.menuItem9});
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
																					  this.menuOpen,
																					  this.menuClosePort});
			this.menuItem4.Text = "F&ax";
			// 
			// menuOpen
			// 
			this.menuOpen.Index = 0;
			this.menuOpen.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					 this.menuBrooktrout,
																					 this.menuGammalink,
																					 this.menuDialogic,
																					 this.menuNMS});
			this.menuOpen.Text = "&Open";
			// 
			// menuBrooktrout
			// 
			this.menuBrooktrout.Enabled = false;
			this.menuBrooktrout.Index = 0;
			this.menuBrooktrout.Text = "&Brooktrout Channel...";
			this.menuBrooktrout.Click += new System.EventHandler(this.menuBrooktrout_Click);
			// 
			// menuGammalink
			// 
			this.menuGammalink.Enabled = false;
			this.menuGammalink.Index = 1;
			this.menuGammalink.Text = "&Gammalink Channel...";
			this.menuGammalink.Click += new System.EventHandler(this.menuGammalink_Click);
			// 
			// menuDialogic
			// 
			this.menuDialogic.Enabled = false;
			this.menuDialogic.Index = 2;
			this.menuDialogic.Text = "&Dialogic Channel...";
			this.menuDialogic.Click += new System.EventHandler(this.menuDialogic_Click);
			// 
			// menuNMS
			// 
			this.menuNMS.Enabled = false;
			this.menuNMS.Index = 3;
			this.menuNMS.Text = "&NMS Channel...";
			this.menuNMS.Click += new System.EventHandler(this.menuNMS_Click);
			// 
			// menuClosePort
			// 
			this.menuClosePort.Enabled = false;
			this.menuClosePort.Index = 1;
			this.menuClosePort.Text = "&Close Channel...";
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
			// 
			// textBox1
			// 
			this.textBox1.IntegralHeight = false;
			this.textBox1.Location = new System.Drawing.Point(184, 40);
			this.textBox1.Name = "textBox1";
			this.textBox1.Size = new System.Drawing.Size(48, 69);
			this.textBox1.TabIndex = 2;
			// 
			// menuItem9
			// 
			this.menuItem9.Index = 3;
			this.menuItem9.Text = "";
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(344, 273);
			this.Controls.Add(this.textBox1);
			this.Controls.Add(this.axFAX1);
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.Menu = this.mainMenu1;
			this.Name = "Form1";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Fax ActiveX Control - C# .NET OpenFaxBoards Sample";
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
			menuClosePort.Enabled = par;
		}
	
		public void SetBrooktroutMenu(bool par)
		{
			menuBrooktrout.Enabled = par;
		}

		public void SetDialogicMenu(bool par)
		{
			menuDialogic.Enabled = par;
		}
		
		public void SetGammaMenu(bool par)
		{
			menuGammalink.Enabled = par;
		}

		public void SetNMSMenu(bool par)
		{
			menuNMS.Enabled = par;
		}

		private void Form1_Load(object sender, System.EventArgs e)
		{
			currdir=Directory.GetCurrentDirectory();
			axFAX1.CloseAllPorts();
			textBox1.Items.Add("This sample will show how to open and close a channel.");
			textBox1.Items.Add("To open a channel choose one of the Open menu items from Fax menu");
			textBox1.Items.Add("according to your board type and select from the available channels.");
			textBox1.Items.Add("To close a channel choose \"Close Channel...\" from Fax menu");
			textBox1.Items.Add("and select the channel to be closed if there is any open channel.");
			if (axFAX1.AvailableBrooktroutChannels.Length > 0)
				menuBrooktrout.Enabled = true;
			if (axFAX1.AvailableGammaChannels.Length > 0)
				menuGammalink.Enabled = true;
			if (axFAX1.AvailableDialogicChannels.Length > 0)
				menuDialogic.Enabled = true;
			if (axFAX1.AvailableNMSChannels.Length > 0)
				menuNMS.Enabled = true;
		}

		private void Form1_Closed(object sender, System.EventArgs e)
		{
			this.Cursor = Cursors.WaitCursor;
			this.Enabled = false;
			axFAX1.CloseAllPorts();
			this.Cursor = Cursors.Default;
		}

		private void menuBrooktrout_Click(object sender, System.EventArgs e)
		{
			BrokktroutOpen dlgBrooktrout = new BrokktroutOpen();
			dlgBrooktrout.parent = this;
			dlgBrooktrout.ShowDialog();
		}

		private void menuClosePort_Click(object sender, System.EventArgs e)
		{
			portClose dlgportClose = new portClose();
			dlgportClose.parent = this;
			dlgportClose.ShowDialog();
		}

		private void menuDialogic_Click(object sender, System.EventArgs e)
		{
			DialogicOpen dlgDialogic = new DialogicOpen();
			dlgDialogic.parent = this;
			dlgDialogic.ShowDialog();
		}

		private void menuGammalink_Click(object sender, System.EventArgs e)
		{
			GammalinkOpen dlgGamma = new GammalinkOpen();
			dlgGamma.parent = this;
			dlgGamma.ShowDialog();
		}

		private void menuNMS_Click(object sender, System.EventArgs e)
		{
			NMSOpen dlgNMS = new NMSOpen();
			dlgNMS.parent = this;
			dlgNMS.ShowDialog();
		}
		public string GetError(int errorCode)
		{
			string retval = null;
			switch (errorCode)
			{
				case -150 : retval = "The specified file doesn�t exist.";
								break;
				case -151 : retval = "The specified communication port is invalid.";
								break;
				case -152 : retval = "The specified communication port doesn�t exist.";
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
				case -165 : retval = "There weren�t any ports open before an operation (SendFaxObj) which needed one.";
					break;
				case -166 : retval =  "The OCX wasn�t able to recognize the format of the specified image file.";
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
	}
}