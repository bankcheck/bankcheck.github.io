using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace FaxcppDemo
{
	/// <summary>
	/// Summary description for FaxConfig.
	/// </summary>
	public class FaxConfig : System.Windows.Forms.Form
	{
		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.GroupBox groupBox2;
		private System.Windows.Forms.RadioButton radio_Off;
		private System.Windows.Forms.RadioButton radio_On;
		private System.Windows.Forms.RadioButton radio_until;
		private System.Windows.Forms.RadioButton radio_Low;
		private System.Windows.Forms.RadioButton radio_Med;
		private System.Windows.Forms.RadioButton radio_High;
		private System.Windows.Forms.Button button_OK;
		private System.Windows.Forms.Button button_Cancel;
		public Form1 parent;
		private System.Windows.Forms.GroupBox groupBox6;
		private System.Windows.Forms.RadioButton radio14400;
		private System.Windows.Forms.RadioButton radio12000;
		private System.Windows.Forms.RadioButton radio9600;
		private System.Windows.Forms.RadioButton radio7200;
		private System.Windows.Forms.RadioButton radio4800;
		private System.Windows.Forms.RadioButton radio2400;
		private System.Windows.Forms.RadioButton radio16800;
		private System.Windows.Forms.RadioButton radio33600;
		private System.Windows.Forms.RadioButton radio31200;
		private System.Windows.Forms.RadioButton radio28800;
		private System.Windows.Forms.RadioButton radio26400;
		private System.Windows.Forms.RadioButton radio24000;
		private System.Windows.Forms.RadioButton radio21600;
		private System.Windows.Forms.RadioButton radio19200;
		private System.Windows.Forms.CheckBox checkBoxBTF;
		private System.Windows.Forms.CheckBox checkBox_ECM;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public FaxConfig()
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
			this.groupBox1 = new System.Windows.Forms.GroupBox();
			this.radio_until = new System.Windows.Forms.RadioButton();
			this.radio_On = new System.Windows.Forms.RadioButton();
			this.radio_Off = new System.Windows.Forms.RadioButton();
			this.groupBox2 = new System.Windows.Forms.GroupBox();
			this.radio_High = new System.Windows.Forms.RadioButton();
			this.radio_Med = new System.Windows.Forms.RadioButton();
			this.radio_Low = new System.Windows.Forms.RadioButton();
			this.button_OK = new System.Windows.Forms.Button();
			this.button_Cancel = new System.Windows.Forms.Button();
			this.groupBox6 = new System.Windows.Forms.GroupBox();
			this.radio33600 = new System.Windows.Forms.RadioButton();
			this.radio31200 = new System.Windows.Forms.RadioButton();
			this.radio28800 = new System.Windows.Forms.RadioButton();
			this.radio26400 = new System.Windows.Forms.RadioButton();
			this.radio24000 = new System.Windows.Forms.RadioButton();
			this.radio21600 = new System.Windows.Forms.RadioButton();
			this.radio19200 = new System.Windows.Forms.RadioButton();
			this.radio16800 = new System.Windows.Forms.RadioButton();
			this.radio14400 = new System.Windows.Forms.RadioButton();
			this.radio12000 = new System.Windows.Forms.RadioButton();
			this.radio9600 = new System.Windows.Forms.RadioButton();
			this.radio7200 = new System.Windows.Forms.RadioButton();
			this.radio4800 = new System.Windows.Forms.RadioButton();
			this.radio2400 = new System.Windows.Forms.RadioButton();
			this.checkBoxBTF = new System.Windows.Forms.CheckBox();
			this.checkBox_ECM = new System.Windows.Forms.CheckBox();
			this.groupBox1.SuspendLayout();
			this.groupBox2.SuspendLayout();
			this.groupBox6.SuspendLayout();
			this.SuspendLayout();
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.radio_until);
			this.groupBox1.Controls.Add(this.radio_On);
			this.groupBox1.Controls.Add(this.radio_Off);
			this.groupBox1.Location = new System.Drawing.Point(8, 8);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(120, 96);
			this.groupBox1.TabIndex = 0;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "Speaker mode";
			// 
			// radio_until
			// 
			this.radio_until.Location = new System.Drawing.Point(8, 72);
			this.radio_until.Name = "radio_until";
			this.radio_until.Size = new System.Drawing.Size(104, 16);
			this.radio_until.TabIndex = 2;
			this.radio_until.Text = "Until Connected";
			// 
			// radio_On
			// 
			this.radio_On.Location = new System.Drawing.Point(8, 47);
			this.radio_On.Name = "radio_On";
			this.radio_On.Size = new System.Drawing.Size(40, 16);
			this.radio_On.TabIndex = 1;
			this.radio_On.Text = "On";
			// 
			// radio_Off
			// 
			this.radio_Off.Location = new System.Drawing.Point(8, 22);
			this.radio_Off.Name = "radio_Off";
			this.radio_Off.Size = new System.Drawing.Size(40, 16);
			this.radio_Off.TabIndex = 0;
			this.radio_Off.Text = "Off";
			// 
			// groupBox2
			// 
			this.groupBox2.Controls.Add(this.radio_High);
			this.groupBox2.Controls.Add(this.radio_Med);
			this.groupBox2.Controls.Add(this.radio_Low);
			this.groupBox2.Location = new System.Drawing.Point(8, 112);
			this.groupBox2.Name = "groupBox2";
			this.groupBox2.Size = new System.Drawing.Size(120, 96);
			this.groupBox2.TabIndex = 1;
			this.groupBox2.TabStop = false;
			this.groupBox2.Text = "Speaker volume";
			// 
			// radio_High
			// 
			this.radio_High.Location = new System.Drawing.Point(8, 71);
			this.radio_High.Name = "radio_High";
			this.radio_High.Size = new System.Drawing.Size(48, 16);
			this.radio_High.TabIndex = 2;
			this.radio_High.Text = "High";
			// 
			// radio_Med
			// 
			this.radio_Med.Location = new System.Drawing.Point(8, 46);
			this.radio_Med.Name = "radio_Med";
			this.radio_Med.Size = new System.Drawing.Size(64, 16);
			this.radio_Med.TabIndex = 1;
			this.radio_Med.Text = "Medium";
			// 
			// radio_Low
			// 
			this.radio_Low.Location = new System.Drawing.Point(8, 21);
			this.radio_Low.Name = "radio_Low";
			this.radio_Low.Size = new System.Drawing.Size(48, 16);
			this.radio_Low.TabIndex = 0;
			this.radio_Low.Text = "Low";
			// 
			// button_OK
			// 
			this.button_OK.Location = new System.Drawing.Point(168, 224);
			this.button_OK.Name = "button_OK";
			this.button_OK.TabIndex = 6;
			this.button_OK.Text = "OK";
			this.button_OK.Click += new System.EventHandler(this.button_OK_Click);
			// 
			// button_Cancel
			// 
			this.button_Cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.button_Cancel.Location = new System.Drawing.Point(56, 224);
			this.button_Cancel.Name = "button_Cancel";
			this.button_Cancel.TabIndex = 5;
			this.button_Cancel.Text = "Cancel";
			this.button_Cancel.Click += new System.EventHandler(this.button_Cancel_Click);
			// 
			// groupBox6
			// 
			this.groupBox6.Controls.Add(this.radio33600);
			this.groupBox6.Controls.Add(this.radio31200);
			this.groupBox6.Controls.Add(this.radio28800);
			this.groupBox6.Controls.Add(this.radio26400);
			this.groupBox6.Controls.Add(this.radio24000);
			this.groupBox6.Controls.Add(this.radio21600);
			this.groupBox6.Controls.Add(this.radio19200);
			this.groupBox6.Controls.Add(this.radio16800);
			this.groupBox6.Controls.Add(this.radio14400);
			this.groupBox6.Controls.Add(this.radio12000);
			this.groupBox6.Controls.Add(this.radio9600);
			this.groupBox6.Controls.Add(this.radio7200);
			this.groupBox6.Controls.Add(this.radio4800);
			this.groupBox6.Controls.Add(this.radio2400);
			this.groupBox6.Location = new System.Drawing.Point(136, 8);
			this.groupBox6.Name = "groupBox6";
			this.groupBox6.Size = new System.Drawing.Size(152, 160);
			this.groupBox6.TabIndex = 2;
			this.groupBox6.TabStop = false;
			this.groupBox6.Text = "Baud Rate";
			// 
			// radio33600
			// 
			this.radio33600.Location = new System.Drawing.Point(80, 136);
			this.radio33600.Name = "radio33600";
			this.radio33600.Size = new System.Drawing.Size(56, 16);
			this.radio33600.TabIndex = 13;
			this.radio33600.Text = "33600";
			// 
			// radio31200
			// 
			this.radio31200.Location = new System.Drawing.Point(80, 117);
			this.radio31200.Name = "radio31200";
			this.radio31200.Size = new System.Drawing.Size(56, 16);
			this.radio31200.TabIndex = 12;
			this.radio31200.Text = "31200";
			// 
			// radio28800
			// 
			this.radio28800.Location = new System.Drawing.Point(80, 98);
			this.radio28800.Name = "radio28800";
			this.radio28800.Size = new System.Drawing.Size(56, 16);
			this.radio28800.TabIndex = 11;
			this.radio28800.Text = "28800";
			// 
			// radio26400
			// 
			this.radio26400.Location = new System.Drawing.Point(80, 79);
			this.radio26400.Name = "radio26400";
			this.radio26400.Size = new System.Drawing.Size(56, 16);
			this.radio26400.TabIndex = 10;
			this.radio26400.Text = "26400";
			// 
			// radio24000
			// 
			this.radio24000.Location = new System.Drawing.Point(80, 60);
			this.radio24000.Name = "radio24000";
			this.radio24000.Size = new System.Drawing.Size(56, 16);
			this.radio24000.TabIndex = 9;
			this.radio24000.Text = "24000";
			// 
			// radio21600
			// 
			this.radio21600.Location = new System.Drawing.Point(80, 41);
			this.radio21600.Name = "radio21600";
			this.radio21600.Size = new System.Drawing.Size(64, 16);
			this.radio21600.TabIndex = 8;
			this.radio21600.Text = "21600";
			// 
			// radio19200
			// 
			this.radio19200.Location = new System.Drawing.Point(80, 22);
			this.radio19200.Name = "radio19200";
			this.radio19200.Size = new System.Drawing.Size(56, 16);
			this.radio19200.TabIndex = 7;
			this.radio19200.Text = "19200";
			// 
			// radio16800
			// 
			this.radio16800.Location = new System.Drawing.Point(16, 136);
			this.radio16800.Name = "radio16800";
			this.radio16800.Size = new System.Drawing.Size(56, 16);
			this.radio16800.TabIndex = 6;
			this.radio16800.Text = "16800";
			// 
			// radio14400
			// 
			this.radio14400.Location = new System.Drawing.Point(16, 117);
			this.radio14400.Name = "radio14400";
			this.radio14400.Size = new System.Drawing.Size(56, 16);
			this.radio14400.TabIndex = 5;
			this.radio14400.Text = "14400";
			// 
			// radio12000
			// 
			this.radio12000.Location = new System.Drawing.Point(16, 98);
			this.radio12000.Name = "radio12000";
			this.radio12000.Size = new System.Drawing.Size(56, 16);
			this.radio12000.TabIndex = 4;
			this.radio12000.Text = "12000";
			// 
			// radio9600
			// 
			this.radio9600.Location = new System.Drawing.Point(16, 79);
			this.radio9600.Name = "radio9600";
			this.radio9600.Size = new System.Drawing.Size(48, 16);
			this.radio9600.TabIndex = 3;
			this.radio9600.Text = "9600";
			// 
			// radio7200
			// 
			this.radio7200.Location = new System.Drawing.Point(16, 60);
			this.radio7200.Name = "radio7200";
			this.radio7200.Size = new System.Drawing.Size(48, 16);
			this.radio7200.TabIndex = 2;
			this.radio7200.Text = "7200";
			// 
			// radio4800
			// 
			this.radio4800.Location = new System.Drawing.Point(16, 41);
			this.radio4800.Name = "radio4800";
			this.radio4800.Size = new System.Drawing.Size(48, 16);
			this.radio4800.TabIndex = 1;
			this.radio4800.Text = "4800";
			// 
			// radio2400
			// 
			this.radio2400.Location = new System.Drawing.Point(16, 22);
			this.radio2400.Name = "radio2400";
			this.radio2400.Size = new System.Drawing.Size(48, 16);
			this.radio2400.TabIndex = 0;
			this.radio2400.Text = "2400";
			// 
			// checkBoxBTF
			// 
			this.checkBoxBTF.Location = new System.Drawing.Point(152, 191);
			this.checkBoxBTF.Name = "checkBoxBTF";
			this.checkBoxBTF.Size = new System.Drawing.Size(88, 16);
			this.checkBoxBTF.TabIndex = 4;
			this.checkBoxBTF.Text = "Enable BFT";
			// 
			// checkBox_ECM
			// 
			this.checkBox_ECM.Location = new System.Drawing.Point(152, 173);
			this.checkBox_ECM.Name = "checkBox_ECM";
			this.checkBox_ECM.Size = new System.Drawing.Size(88, 16);
			this.checkBox_ECM.TabIndex = 3;
			this.checkBox_ECM.Text = "Enable ECM";
			// 
			// FaxConfig
			// 
			this.AcceptButton = this.button_OK;
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.CancelButton = this.button_Cancel;
			this.ClientSize = new System.Drawing.Size(298, 263);
			this.Controls.Add(this.checkBoxBTF);
			this.Controls.Add(this.checkBox_ECM);
			this.Controls.Add(this.groupBox6);
			this.Controls.Add(this.button_Cancel);
			this.Controls.Add(this.button_OK);
			this.Controls.Add(this.groupBox2);
			this.Controls.Add(this.groupBox1);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "FaxConfig";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Fax Configuration";
			this.Load += new System.EventHandler(this.FaxConfig_Load);
			this.groupBox1.ResumeLayout(false);
			this.groupBox2.ResumeLayout(false);
			this.groupBox6.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		private void button_Cancel_Click(object sender, System.EventArgs e)
		{
			this.Close();
		}

		private void button_OK_Click(object sender, System.EventArgs e)
		{
			int index = 0;

			if (radio_Off.Checked)
				index = 0;
			else if (radio_On.Checked)
				index = 1;
			else if (radio_until.Checked)
				index = 2;
			parent.m_SpeakerMode = index;

			index = 0;
			if (radio_Low.Checked)
				index = 0;
			else if (radio_Med.Checked)
				index = 1;
			else if (radio_High.Checked)
				index = 2;
			parent.m_SpeakerVolume = index;

			if (checkBox_ECM.Checked)
				parent.m_EnableECM = 3;
			else
				parent.m_EnableECM = 2;

			if (checkBoxBTF.Checked)
				parent.m_EnableBTF = 3;
			else 
				parent.m_EnableBTF = 2;

			if (radio2400.Checked)
				index = 0;
			else if (radio4800.Checked)
				index = 1;
			else if (radio7200.Checked)
				index = 2;
			else if (radio9600.Checked)
				index = 3;
			else if (radio12000.Checked)
				index = 4;
			else if (radio14400.Checked)
				index = 5;
			else if (radio16800.Checked)
				index = 6;
			else if (radio19200.Checked)
				index = 7;
			else if (radio21600.Checked)
				index = 8;
			else if (radio24000.Checked)
				index = 9;
			else if (radio26400.Checked)
				index = 10;
			else if (radio28800.Checked)
				index = 11;
			else if (radio31200.Checked)
				index = 12;
			else if (radio33600.Checked)
				index = 13;

			parent.BaudRate = index + 2;

			parent.axFAX1.SetSpeakerMode(parent.m_ActualFaxPort, (short)parent.m_SpeakerMode, (short)parent.m_SpeakerVolume);
			parent.axFAX1.SetPortCapability(parent.m_ActualFaxPort, 3, (short)parent.m_EnableECM);
			parent.axFAX1.SetPortCapability(parent.m_ActualFaxPort, 4, (short)parent.m_EnableBTF);
			parent.axFAX1.SetPortCapability(parent.m_ActualFaxPort, 10, (short)parent.BaudRate);

			this.Close();
		}

		private void FaxConfig_Load(object sender, System.EventArgs e)
		{
			// Speaker mode
			switch (parent.m_SpeakerMode)
			{
				case 0 :
					radio_Off.Checked = true;
					break;
				case 1 :
					radio_On.Checked = true;
					break;
				case 2:
					radio_until.Checked = true;
					break;
			}

			// Speaker volume
			switch (parent.m_SpeakerVolume)
			{
				case 0 : 
					radio_Low.Checked = true;
					break;
				case 1 :
					radio_Med.Checked = true;
					break;
				case 2 : 
					radio_High.Checked = true;
					break;
			}
						
			// Baudrate
			int ivalue = parent.BaudRate - 2;

			switch (ivalue)
			{
				case 0 :
					radio2400.Checked = true;
					break;
				case 1 :
					radio4800.Checked = true;
					break;
				case 2 :
					radio7200.Checked = true;
					break;
				case 3 :
					radio9600.Checked = true;
					break;
				case 4 :
					radio12000.Checked = true;
					break;
				case 5 :
					radio14400.Checked = true;
					break;
				case 6 :
					radio16800.Checked = true;
					break;
				case 7 :
					radio19200.Checked = true;
					break;
				case 8 :
					radio21600.Checked = true;
					break;
				case 9 :
					radio24000.Checked = true;
					break;
				case 10 :
					radio26400.Checked = true;
					break;
				case 11 :
					radio28800.Checked = true;
					break;
				case 12 :
					radio31200.Checked = true;
					break;
				case 13 :
					radio33600.Checked = true;
					break;
			}
			
			if (parent.m_EnableECM==3)
				checkBox_ECM.Checked=true;
			else if (parent.m_EnableECM==2)
				checkBox_ECM.Checked=false;

			if (parent.m_EnableBTF == 3)
				checkBoxBTF.Checked = true;
			else if (parent.m_EnableBTF == 2)
				checkBoxBTF.Checked = false;

			
		}

	}
}
