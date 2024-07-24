using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Text;
using System.Runtime.InteropServices;

namespace FaxcppDemo
{
	/// <summary>
	/// Summary description for commport.
	/// </summary>
	public class ComPort : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Button OK_button;
		private System.Windows.Forms.Button Cancel_button;
		private System.Windows.Forms.CheckBox Header_checkBox;
		private System.Windows.Forms.GroupBox groupBox2;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.Label Type_label;
		private System.Windows.Forms.Label Manu_label;
		private System.Windows.Forms.Label Model_label;
		private System.Windows.Forms.Button button1;
		public Form1 parent;
		private string rings;
		private System.Windows.Forms.GroupBox groupBox5;
		private System.Windows.Forms.CheckBox chkEnableDebug;
		private System.Windows.Forms.TextBox localID;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.TextBox numberOfRings;
		private System.Windows.Forms.Label label5;
		private System.Windows.Forms.Label label6;
		private System.Windows.Forms.ListBox port_listBox;
		private System.Windows.Forms.ComboBox comboBox1;
		private System.Windows.Forms.Button DialtoneButton;
		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.Label label7;
		internal System.Windows.Forms.Label label8;
		internal System.Windows.Forms.Label label9;
		internal System.Windows.Forms.TextBox SetupStrTextbox;
		internal System.Windows.Forms.TextBox ResetStrTextbox;
		private System.Windows.Forms.GroupBox groupBox3;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;
		
		public ComPort()
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
			this.OK_button = new System.Windows.Forms.Button();
			this.Cancel_button = new System.Windows.Forms.Button();
			this.Header_checkBox = new System.Windows.Forms.CheckBox();
			this.groupBox2 = new System.Windows.Forms.GroupBox();
			this.DialtoneButton = new System.Windows.Forms.Button();
			this.button1 = new System.Windows.Forms.Button();
			this.Model_label = new System.Windows.Forms.Label();
			this.Manu_label = new System.Windows.Forms.Label();
			this.Type_label = new System.Windows.Forms.Label();
			this.label3 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.label1 = new System.Windows.Forms.Label();
			this.groupBox5 = new System.Windows.Forms.GroupBox();
			this.chkEnableDebug = new System.Windows.Forms.CheckBox();
			this.localID = new System.Windows.Forms.TextBox();
			this.label4 = new System.Windows.Forms.Label();
			this.numberOfRings = new System.Windows.Forms.TextBox();
			this.label5 = new System.Windows.Forms.Label();
			this.label6 = new System.Windows.Forms.Label();
			this.port_listBox = new System.Windows.Forms.ListBox();
			this.comboBox1 = new System.Windows.Forms.ComboBox();
			this.groupBox1 = new System.Windows.Forms.GroupBox();
			this.ResetStrTextbox = new System.Windows.Forms.TextBox();
			this.SetupStrTextbox = new System.Windows.Forms.TextBox();
			this.label9 = new System.Windows.Forms.Label();
			this.label8 = new System.Windows.Forms.Label();
			this.label7 = new System.Windows.Forms.Label();
			this.groupBox3 = new System.Windows.Forms.GroupBox();
			this.groupBox2.SuspendLayout();
			this.groupBox5.SuspendLayout();
			this.groupBox1.SuspendLayout();
			this.groupBox3.SuspendLayout();
			this.SuspendLayout();
			// 
			// OK_button
			// 
			this.OK_button.Location = new System.Drawing.Point(176, 448);
			this.OK_button.Name = "OK_button";
			this.OK_button.Size = new System.Drawing.Size(80, 24);
			this.OK_button.TabIndex = 6;
			this.OK_button.Text = "&OK";
			this.OK_button.Click += new System.EventHandler(this.OK_button_Click);
			// 
			// Cancel_button
			// 
			this.Cancel_button.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.Cancel_button.Location = new System.Drawing.Point(83, 448);
			this.Cancel_button.Name = "Cancel_button";
			this.Cancel_button.Size = new System.Drawing.Size(80, 24);
			this.Cancel_button.TabIndex = 5;
			this.Cancel_button.Text = "&Cancel";
			this.Cancel_button.Click += new System.EventHandler(this.Cancel_button_Click);
			// 
			// Header_checkBox
			// 
			this.Header_checkBox.Location = new System.Drawing.Point(8, 16);
			this.Header_checkBox.Name = "Header_checkBox";
			this.Header_checkBox.TabIndex = 4;
			this.Header_checkBox.Text = "Create Header";
			// 
			// groupBox2
			// 
			this.groupBox2.Controls.Add(this.DialtoneButton);
			this.groupBox2.Controls.Add(this.button1);
			this.groupBox2.Controls.Add(this.Model_label);
			this.groupBox2.Controls.Add(this.Manu_label);
			this.groupBox2.Controls.Add(this.Type_label);
			this.groupBox2.Controls.Add(this.label3);
			this.groupBox2.Controls.Add(this.label2);
			this.groupBox2.Controls.Add(this.label1);
			this.groupBox2.Location = new System.Drawing.Point(8, 48);
			this.groupBox2.Name = "groupBox2";
			this.groupBox2.Size = new System.Drawing.Size(320, 152);
			this.groupBox2.TabIndex = 1;
			this.groupBox2.TabStop = false;
			this.groupBox2.Text = "Modem Test";
			// 
			// DialtoneButton
			// 
			this.DialtoneButton.Location = new System.Drawing.Point(8, 120);
			this.DialtoneButton.Name = "DialtoneButton";
			this.DialtoneButton.Size = new System.Drawing.Size(88, 24);
			this.DialtoneButton.TabIndex = 1;
			this.DialtoneButton.Text = "Test Dialtone";
			this.DialtoneButton.Click += new System.EventHandler(this.DialtoneButton_Click);
			// 
			// button1
			// 
			this.button1.Location = new System.Drawing.Point(8, 90);
			this.button1.Name = "button1";
			this.button1.Size = new System.Drawing.Size(88, 23);
			this.button1.TabIndex = 0;
			this.button1.Text = "Test modem";
			this.button1.Click += new System.EventHandler(this.button1_Click);
			// 
			// Model_label
			// 
			this.Model_label.Location = new System.Drawing.Point(112, 48);
			this.Model_label.Name = "Model_label";
			this.Model_label.Size = new System.Drawing.Size(200, 16);
			this.Model_label.TabIndex = 5;
			// 
			// Manu_label
			// 
			this.Manu_label.Location = new System.Drawing.Point(112, 18);
			this.Manu_label.Name = "Manu_label";
			this.Manu_label.Size = new System.Drawing.Size(200, 22);
			this.Manu_label.TabIndex = 4;
			// 
			// Type_label
			// 
			this.Type_label.Location = new System.Drawing.Point(112, 72);
			this.Type_label.Name = "Type_label";
			this.Type_label.Size = new System.Drawing.Size(200, 48);
			this.Type_label.TabIndex = 3;
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(24, 46);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(48, 16);
			this.label3.TabIndex = 2;
			this.label3.Text = "Model:";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(24, 18);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(80, 16);
			this.label2.TabIndex = 1;
			this.label2.Text = "Manufacturer:";
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(24, 71);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(64, 16);
			this.label1.TabIndex = 0;
			this.label1.Text = "Class type:";
			// 
			// groupBox5
			// 
			this.groupBox5.Controls.Add(this.chkEnableDebug);
			this.groupBox5.Location = new System.Drawing.Point(8, 392);
			this.groupBox5.Name = "groupBox5";
			this.groupBox5.Size = new System.Drawing.Size(320, 48);
			this.groupBox5.TabIndex = 4;
			this.groupBox5.TabStop = false;
			this.groupBox5.Text = "Debug File Generation";
			// 
			// chkEnableDebug
			// 
			this.chkEnableDebug.Location = new System.Drawing.Point(8, 21);
			this.chkEnableDebug.Name = "chkEnableDebug";
			this.chkEnableDebug.Size = new System.Drawing.Size(136, 16);
			this.chkEnableDebug.TabIndex = 0;
			this.chkEnableDebug.Text = "Enable Driver Debug";
			// 
			// localID
			// 
			this.localID.Location = new System.Drawing.Point(120, 72);
			this.localID.MaxLength = 100;
			this.localID.Name = "localID";
			this.localID.Size = new System.Drawing.Size(120, 20);
			this.localID.TabIndex = 2;
			this.localID.Text = "";
			// 
			// label4
			// 
			this.label4.Location = new System.Drawing.Point(8, 73);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(104, 16);
			this.label4.TabIndex = 11;
			this.label4.Text = "Identification String:";
			this.label4.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			// 
			// numberOfRings
			// 
			this.numberOfRings.Location = new System.Drawing.Point(152, 96);
			this.numberOfRings.MaxLength = 1;
			this.numberOfRings.Name = "numberOfRings";
			this.numberOfRings.Size = new System.Drawing.Size(16, 20);
			this.numberOfRings.TabIndex = 3;
			this.numberOfRings.Text = "";
			this.numberOfRings.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.numberOfRings_KeyPress);
			this.numberOfRings.TextChanged += new System.EventHandler(this.numberOfRings_TextChanged);
			// 
			// label5
			// 
			this.label5.Location = new System.Drawing.Point(8, 97);
			this.label5.Name = "label5";
			this.label5.Size = new System.Drawing.Size(144, 16);
			this.label5.TabIndex = 9;
			this.label5.Text = "Number of rings to answer:";
			this.label5.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			// 
			// label6
			// 
			this.label6.Location = new System.Drawing.Point(8, 4);
			this.label6.Name = "label6";
			this.label6.Size = new System.Drawing.Size(112, 16);
			this.label6.TabIndex = 12;
			this.label6.Text = "Fax Modem Settings:";
			this.label6.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// port_listBox
			// 
			this.port_listBox.Location = new System.Drawing.Point(248, 36);
			this.port_listBox.Name = "port_listBox";
			this.port_listBox.Size = new System.Drawing.Size(64, 56);
			this.port_listBox.TabIndex = 4;
			// 
			// comboBox1
			// 
			this.comboBox1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.comboBox1.Location = new System.Drawing.Point(8, 24);
			this.comboBox1.Name = "comboBox1";
			this.comboBox1.Size = new System.Drawing.Size(320, 21);
			this.comboBox1.TabIndex = 0;
			this.comboBox1.SelectedIndexChanged += new System.EventHandler(this.comboBox1_SelectedIndexChanged);
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.ResetStrTextbox);
			this.groupBox1.Controls.Add(this.SetupStrTextbox);
			this.groupBox1.Controls.Add(this.label9);
			this.groupBox1.Controls.Add(this.label8);
			this.groupBox1.Controls.Add(this.label7);
			this.groupBox1.Controls.Add(this.port_listBox);
			this.groupBox1.Controls.Add(this.label5);
			this.groupBox1.Controls.Add(this.numberOfRings);
			this.groupBox1.Controls.Add(this.label4);
			this.groupBox1.Controls.Add(this.localID);
			this.groupBox1.Location = new System.Drawing.Point(8, 208);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(320, 128);
			this.groupBox1.TabIndex = 2;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "Modem Setup";
			// 
			// ResetStrTextbox
			// 
			this.ResetStrTextbox.Location = new System.Drawing.Point(80, 24);
			this.ResetStrTextbox.MaxLength = 25;
			this.ResetStrTextbox.Name = "ResetStrTextbox";
			this.ResetStrTextbox.Size = new System.Drawing.Size(160, 20);
			this.ResetStrTextbox.TabIndex = 0;
			this.ResetStrTextbox.Text = "";
			// 
			// SetupStrTextbox
			// 
			this.SetupStrTextbox.Location = new System.Drawing.Point(80, 48);
			this.SetupStrTextbox.MaxLength = 25;
			this.SetupStrTextbox.Name = "SetupStrTextbox";
			this.SetupStrTextbox.Size = new System.Drawing.Size(160, 20);
			this.SetupStrTextbox.TabIndex = 1;
			this.SetupStrTextbox.Text = "";
			// 
			// label9
			// 
			this.label9.Location = new System.Drawing.Point(8, 49);
			this.label9.Name = "label9";
			this.label9.Size = new System.Drawing.Size(72, 16);
			this.label9.TabIndex = 16;
			this.label9.Text = "Setup String:";
			this.label9.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			// 
			// label8
			// 
			this.label8.Location = new System.Drawing.Point(8, 25);
			this.label8.Name = "label8";
			this.label8.Size = new System.Drawing.Size(72, 16);
			this.label8.TabIndex = 15;
			this.label8.Text = "Reset String:";
			this.label8.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			// 
			// label7
			// 
			this.label7.Location = new System.Drawing.Point(248, 21);
			this.label7.Name = "label7";
			this.label7.Size = new System.Drawing.Size(64, 16);
			this.label7.TabIndex = 14;
			this.label7.Text = "Ports:";
			this.label7.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// groupBox3
			// 
			this.groupBox3.Controls.Add(this.Header_checkBox);
			this.groupBox3.Location = new System.Drawing.Point(8, 340);
			this.groupBox3.Name = "groupBox3";
			this.groupBox3.Size = new System.Drawing.Size(320, 48);
			this.groupBox3.TabIndex = 3;
			this.groupBox3.TabStop = false;
			this.groupBox3.Text = "Header Setup";
			// 
			// ComPort
			// 
			this.AcceptButton = this.OK_button;
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.CancelButton = this.Cancel_button;
			this.ClientSize = new System.Drawing.Size(338, 479);
			this.Controls.Add(this.groupBox3);
			this.Controls.Add(this.groupBox1);
			this.Controls.Add(this.comboBox1);
			this.Controls.Add(this.label6);
			this.Controls.Add(this.groupBox5);
			this.Controls.Add(this.groupBox2);
			this.Controls.Add(this.Cancel_button);
			this.Controls.Add(this.OK_button);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "ComPort";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Open Com Port";
			this.Load += new System.EventHandler(this.ComPort_Load);
			this.groupBox2.ResumeLayout(false);
			this.groupBox5.ResumeLayout(false);
			this.groupBox1.ResumeLayout(false);
			this.groupBox3.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		private void Cancel_button_Click(object sender, System.EventArgs e)
		{
			this.Close();
		}

		[DllImport("kernel32", EntryPoint="WriteProfileStringA",
			 CharSet=CharSet.Ansi)]
		private static extern int WriteProfileString(
			string sectionName,
			string keyName,
			string defaultValue);

		private void OK_button_Click(object sender, System.EventArgs e)
		{
			int errcode,nFax,headerInt;
			string szFaxName;
			StringBuilder szFaxName1;

			this.Cursor = Cursors.WaitCursor;
			this.Enabled = false;
			parent.axFAX1.SetSetupString(SetupStrTextbox.Text,(short)(comboBox1.SelectedIndex+1));
			parent.axFAX1.SetResetString(ResetStrTextbox.Text,(short)(comboBox1.SelectedIndex+1));

			if (Header_checkBox.Checked)
			{
				parent.axFAX1.Header = true;
				parent.axFAX1.HeaderHeight = 25;
				parent.axFAX1.HeaderFaceName = "Arial";
				parent.axFAX1.HeaderFontSize = 10;
				headerInt=1;
			}
			else
			{
				parent.axFAX1.Header = false;
				headerInt=0;
			}

			if (chkEnableDebug.Checked)
				parent.m_bEnblDebug = true;
			else
				parent.m_bEnblDebug = false;

			nFax = comboBox1.SelectedIndex + 1;
			WriteProfileString("Fax", "Selected", nFax.ToString());
			WriteProfileString("Fax", "Header", headerInt.ToString());
			szFaxName = "Fax" + Convert.ToString(nFax);
			szFaxName1 = new StringBuilder(250,500);
			GetPrivateProfileString("Faxes", szFaxName, "", szFaxName1, 250, "faxcpp1.ini");
			parent.axFAX1.FaxType = szFaxName1.ToString();
			parent.axFAX1.LocalID = localID.Text;
			try
			{
				parent.axFAX1.Rings = Convert.ToInt16(numberOfRings.Text);
			}
			catch(FormatException)
			{
				parent.axFAX1.Rings = 1;
			}

			parent.axFAX1.TestModem((string)port_listBox.SelectedItem);
			if (parent.axFAX1.ClassType.Length != 0)
			{

				if (parent.axFAX1.FaxType == "GCLASS1(SFC)" && (parent.axFAX1.ClassType.IndexOf("1") == -1 || parent.axFAX1.ClassType.IndexOf("1.0") == parent.axFAX1.ClassType.IndexOf("1")))
				{
					MessageBox.Show("The selected modem does not support Class 1");
					this.Cursor = Cursors.Default;
					this.Enabled = true;
					return;
				}
				else if (parent.axFAX1.FaxType == "GCLASS1(HFC)" && (parent.axFAX1.ClassType.IndexOf("1") == -1 || parent.axFAX1.ClassType.IndexOf("1.0") == parent.axFAX1.ClassType.IndexOf("1")))
				{
					MessageBox.Show("The selected modem does not support Class 1");
					this.Cursor = Cursors.Default;
					this.Enabled = true;
					return;
				}
				else if (parent.axFAX1.FaxType == "GCLASS1.0(SFC)" && parent.axFAX1.ClassType.IndexOf("1.0") == -1)
				{
					MessageBox.Show("The selected modem does not support Class 1.0");
					this.Cursor = Cursors.Default;
					this.Enabled = true;
					return;
				}
				else if (parent.axFAX1.FaxType == "GCLASS1.0(HFC)" && parent.axFAX1.ClassType.IndexOf("1.0")==-1)
				{
					MessageBox.Show("The selected modem does not support Class 1.0");
					this.Cursor = Cursors.Default;
					this.Enabled = true;
					return;
				}
				else if ((parent.axFAX1.FaxType == "GCLASS2S/RF/" || parent.axFAX1.FaxType == "GCLASS2R") && (parent.axFAX1.ClassType.IndexOf("2")==-1 || parent.axFAX1.ClassType.IndexOf("2.0") == parent.axFAX1.ClassType.IndexOf("2")))
				{
					MessageBox.Show("The selected modem does not support Class 2");
					this.Cursor = Cursors.Default;
					this.Enabled = true;
					return;
				}
				else if ((parent.axFAX1.FaxType == "GCLASS2.0" || parent.axFAX1.FaxType == "GCLASS2.0 MULTITECH") && parent.axFAX1.ClassType.IndexOf( "2.0") == -1)
				{
					MessageBox.Show("The selected modem does not support Class 2.0");
					this.Cursor = Cursors.Default;
					this.Enabled = true;
					return;
				}
				else if ((parent.axFAX1.FaxType == "GH14.4F(HFC)" || parent.axFAX1.FaxType == "GU.S.R14.4F(HFC)") && (parent.axFAX1.ClassType.IndexOf("1") == -1) || parent.axFAX1.ClassType.IndexOf("1.0") == parent.axFAX1.ClassType.IndexOf("1")) 
				{
					MessageBox.Show("The selected modem does not support Class 1");
					this.Cursor = Cursors.Default;
					this.Enabled = true;
					return;
				}
				parent.m_ActualFaxPort = (string)port_listBox.SelectedItem;
				switch (parent.m_SpeakerVolume)
				{
					case 0 : parent.axFAX1.SpeakerVolume = FAXLib.enumSpeakerVolume.Low;
						break;
					case 1 : parent.axFAX1.SpeakerVolume = FAXLib.enumSpeakerVolume.Medium;
						break;
					case 2 : parent.axFAX1.SpeakerVolume = FAXLib.enumSpeakerVolume.High;
						break;
				}
				switch (parent.m_SpeakerMode)
				{
					case 0 : parent.axFAX1.SpeakerMode = FAXLib.enumSpeakerMode.Never;
						break;
					case 1 : parent.axFAX1.SpeakerMode = FAXLib.enumSpeakerMode.Always;
						break;
					case 2 : parent.axFAX1.SpeakerMode = FAXLib.enumSpeakerMode.UntilConnected;
						break;
				}
				System.Threading.Thread.Sleep(2000);
				errcode=parent.axFAX1.OpenPort((string)port_listBox.SelectedItem);
				if (errcode != 0)
					MessageBox.Show(parent.GetError(errcode), "Error");
				else
				{
					parent.PortsAndClasses=parent.PortsAndClasses+(string)port_listBox.SelectedItem+':'+(comboBox1.SelectedIndex+1)+' ';
					parent.SetMenuItems(true);
					parent.textBox1.Items.Add((string)port_listBox.SelectedItem +":"+parent.axFAX1.GetLongName((short)(comboBox1.SelectedIndex+1))+ " was opened");
				}
				parent.axFAX1.SetSpeakerMode(parent.m_ActualFaxPort, (short)parent.m_SpeakerMode, (short)parent.m_SpeakerVolume);
				parent.axFAX1.SetPortCapability(parent.m_ActualFaxPort, 3, (short)parent.m_EnableECM);
				parent.axFAX1.SetPortCapability(parent.m_ActualFaxPort, 4, (short)parent.m_EnableBTF);
				parent.axFAX1.SetPortCapability(parent.m_ActualFaxPort, 10, (short)parent.BaudRate);
				parent.axFAX1.EnableLog(parent.m_ActualFaxPort, parent.m_bEnblDebug);
				parent.axFAX1.HeaderHeight=25;
			}
			else
			{
				string szText = "No modem on " + (string)port_listBox.SelectedItem + " port.";
				MessageBox.Show(szText, "Error");
				this.Cursor = Cursors.Default;
				this.Enabled = true;
				return;
			}

			if (parent.axFAX1.AvailablePorts.Length > 0)
				parent.SetComportMenu(true);
			else
				parent.SetComportMenu(false);
			this.Cursor = Cursors.Default;
			this.Enabled = true;
			this.Close();
		}

		private void Config_button_Click(object sender, System.EventArgs e)
		{
			FaxConfig dlgFax = new FaxConfig();
			dlgFax.parent = parent;
			dlgFax.ShowDialog();
		}
		[DllImport("kernel32", EntryPoint="GetPrivateProfileStringA",
			 CharSet=CharSet.Ansi)]
		private static extern int GetPrivateProfileString(
			string sectionName,
			string keyName,
			string defaultValue,
			StringBuilder returnbuffer,
			Int32 bufferSize,
			string fileName);

		[DllImport("kernel32", EntryPoint="GetProfileIntA",
			 CharSet=CharSet.Ansi)]
		private static extern int GetProfileInt(
			string sectionName,
			string keyName,
			int  defaultValue);

		private void ComPort_Load(object sender, System.EventArgs e)
		{
			string szString1, szString2 = null;
			bool flag;
			int j;
			
			// Enable Debug
			if (parent.m_bEnblDebug)
				chkEnableDebug.Checked = true;
			else
				chkEnableDebug.Checked = false;

			if (parent.axFAX1.Header)
				Header_checkBox.Checked = true;
			else
				Header_checkBox.Checked = false;

			szString1 = parent.axFAX1.AvailablePorts;
			flag = true;
			while (flag)
			{
				j = szString1.IndexOf(" ");
				if (j == -1)
				{
					szString2 = szString1;
					flag = false;
				}
				else
				{
					szString2 = szString1.Substring(0, j);
					szString1 = szString1.Remove(0, j + 1);
				}
				port_listBox.Items.Add(szString2);
			}
			port_listBox.SetSelected(0, true);

		string szFax,IniFileName;
		StringBuilder szFaxName,SzFaxName1;
        int nFaxes,LocalFax;
        bool First,wasThere1,wasThere2;
        wasThere1 = false;
        wasThere2 = false;
        First = true;
        LocalFax = 0;
        IniFileName = "faxcpp1.ini";
        nFaxes = 1;
        while (nFaxes != -1)
		{
            LocalFax +=1;
            szFax = "Fax" + Convert.ToString(LocalFax);
            szFaxName = new StringBuilder(250, 500);
			if (GetPrivateProfileString("Faxes", szFax, "", szFaxName, 250, IniFileName) == 0)
			{
				wasThere1 = false;
				if (First == false)
				{
					nFaxes = -1;
					wasThere1 = true;
				}
				else
				{
					First = false;
					wasThere1 = true;
				}
			}
            else wasThere1 = false;
			SzFaxName1 = new StringBuilder(250,500);
			if (wasThere1 == false)
			{
				if (GetPrivateProfileString(szFaxName.ToString(), "Long Name", "", SzFaxName1, 250, IniFileName) == 0)
				{
					wasThere2 = false;
					if (First == false)
					{ 
						nFaxes = -1;
						wasThere2 = true;
					}
					else
					{
						First = false;
						wasThere2 = true;
					}
				}
				else wasThere2 = false;
			}
            if (wasThere1 == false && wasThere2 == false && nFaxes != -1) 
			{
				comboBox1.Items.Add(SzFaxName1);	
				nFaxes += 1;
			}
		}
		comboBox1.SelectedIndex = GetProfileInt("Fax", "Selected", 1)-1;

		localID.Text = parent.axFAX1.LocalID;
		numberOfRings.Text=parent.axFAX1.Rings.ToString();

		}

		private void button1_Click(object sender, System.EventArgs e)
		{
			string szSelected, OutString = "", Str1;
			int err, iBeginStr, iPosition;			
			szSelected = (string)port_listBox.SelectedItem;
			this.Cursor = Cursors.WaitCursor;
			this.Enabled = false;

			err = parent.axFAX1.TestModem(szSelected);
			if (err == 0)
			{	
				iPosition=0;
				iBeginStr=0;
				while(iPosition > -1 && parent.axFAX1.ClassType.Length > 0 )
				{
					Str1= "";
					iPosition=parent.axFAX1.ClassType.IndexOf(",",iBeginStr);
					if(iPosition > -1)
					{
						Str1=parent.axFAX1.ClassType.Substring(iBeginStr,iPosition - iBeginStr);
						iBeginStr=iPosition+1;
					}
					else
						Str1=parent.axFAX1.ClassType.Substring(iBeginStr,parent.axFAX1.ClassType.Length - iBeginStr);				
					if (Str1 == "0")
						if (OutString.Length == 0)
							OutString += "Data";
						else
							OutString += ", Data";
					else if (Str1=="1")
						if (OutString.Length == 0)
							OutString += "FAX Class 1";
						else
							OutString += ", FAX Class 1";
					else if (Str1=="1.0")
						if (OutString.Length == 0)
							OutString += "FAX Class 1.0";
						else
							OutString += ", FAX Class 1.0";
					else if (Str1=="2.0")
						if (OutString.Length == 0)
							OutString += "FAX Class 2.0";
						else
							OutString += ", FAX Class 2.0";
					else if (Str1=="2.1")
						if (OutString.Length == 0)
							OutString += "FAX Class 2.1";
						else
							OutString += ", FAX Class 2.1";
					else if (Str1=="2")
						if (OutString.Length == 0)
							OutString += "FAX Class 2";	
						else
							OutString += ", FAX Class 2";
					else if (Str1=="80")
						if (OutString.Length == 0)
							OutString += "Class 80";
						else
							OutString += ", Class 80";
					else if (Str1=="8")
						if (OutString.Length == 0)
							OutString += "Class 8";
						else
							OutString += ", Class 8";
					else if (Str1.Length > 0)
						if (OutString.Length == 0)
							OutString += "Class " + Str1;
						else
							OutString += ", Class " + Str1;

				}
				if (OutString.Length > 0) 
					Type_label.Text = OutString;
				else 
					Type_label.Text = parent.axFAX1.ClassType;
				Manu_label.Text = parent.axFAX1.Manufacturer;
				Model_label.Text = parent.axFAX1.Model;
			}
			else
			{
				Type_label.Text = "No modem on " + szSelected;
				Manu_label.Text = "";
				Model_label.Text = "";
			}
			this.Enabled = true;
			this.Cursor = Cursors.Default;
		}

		private void comboBox1_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			short index=(short)(comboBox1.SelectedIndex+1);
			ResetStrTextbox.Text = parent.axFAX1.GetResetString(index);
			SetupStrTextbox.Text = parent.axFAX1.GetSetupString(index);
		}

		private void DialtoneButton_Click(object sender, System.EventArgs e)
		{
			string szPortName;
			 int iError;

			szPortName = (string)port_listBox.SelectedItem;
			Cursor = Cursors.WaitCursor;
			iError = parent.axFAX1.DetectDialTone(szPortName);
			Cursor = Cursors.Default;
			if (1 == iError)
				MessageBox.Show("Dialtone Detected. ", "Test Dialtone");
			else if (0 == iError)
            MessageBox.Show("No Dialtone! ", "Test Dialtone");
			else if (-1 == iError)
            MessageBox.Show("No Modem on COM Port! ", "Test Dialtone");
        
		}

		private void numberOfRings_KeyPress(object sender, System.Windows.Forms.KeyPressEventArgs e)
		{
			rings=numberOfRings.Text;
		}

		private void numberOfRings_TextChanged(object sender, System.EventArgs e)
		{
			if (numberOfRings.Text.Length>0)
			{
				if (numberOfRings.Text[0]<48 || numberOfRings.Text[0] > 57)
				{
					if (rings!=null)	numberOfRings.Text=rings;
					numberOfRings.SelectAll();
				}
	
			}
		}

	}
}
