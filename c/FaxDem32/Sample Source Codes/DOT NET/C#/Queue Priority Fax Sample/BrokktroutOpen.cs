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
	/// Summary description for BrokktroutOpen.
	/// </summary>
	public class BrokktroutOpen : System.Windows.Forms.Form
	{
		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.ListBox PortListBox;
		private System.Windows.Forms.Button OK_button;
		private System.Windows.Forms.Button Cancel_button;
		public Form1 parent;
		private System.Windows.Forms.OpenFileDialog openFileDialog1;
		private System.Windows.Forms.GroupBox groupBox2;
		private System.Windows.Forms.TextBox File_textBox;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.CheckBox DTMF_checkBox;
		private System.Windows.Forms.CheckBox Header_checkBox;
		private System.Windows.Forms.Button Browse_button;
		private System.Windows.Forms.TextBox BrLocalID;
		private System.Windows.Forms.Label label2;
		private StringBuilder outbuffer;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public BrokktroutOpen()
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
			this.PortListBox = new System.Windows.Forms.ListBox();
			this.OK_button = new System.Windows.Forms.Button();
			this.Cancel_button = new System.Windows.Forms.Button();
			this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
			this.groupBox2 = new System.Windows.Forms.GroupBox();
			this.label2 = new System.Windows.Forms.Label();
			this.BrLocalID = new System.Windows.Forms.TextBox();
			this.File_textBox = new System.Windows.Forms.TextBox();
			this.label1 = new System.Windows.Forms.Label();
			this.DTMF_checkBox = new System.Windows.Forms.CheckBox();
			this.Header_checkBox = new System.Windows.Forms.CheckBox();
			this.Browse_button = new System.Windows.Forms.Button();
			this.groupBox1.SuspendLayout();
			this.groupBox2.SuspendLayout();
			this.SuspendLayout();
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.PortListBox);
			this.groupBox1.Location = new System.Drawing.Point(8, 8);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(176, 112);
			this.groupBox1.TabIndex = 0;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "Available Channels";
			// 
			// PortListBox
			// 
			this.PortListBox.Location = new System.Drawing.Point(8, 16);
			this.PortListBox.Name = "PortListBox";
			this.PortListBox.Size = new System.Drawing.Size(160, 82);
			this.PortListBox.TabIndex = 0;
			// 
			// OK_button
			// 
			this.OK_button.Location = new System.Drawing.Point(192, 16);
			this.OK_button.Name = "OK_button";
			this.OK_button.Size = new System.Drawing.Size(75, 24);
			this.OK_button.TabIndex = 6;
			this.OK_button.Text = "&OK";
			this.OK_button.Click += new System.EventHandler(this.OK_button_Click);
			// 
			// Cancel_button
			// 
			this.Cancel_button.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.Cancel_button.Location = new System.Drawing.Point(192, 48);
			this.Cancel_button.Name = "Cancel_button";
			this.Cancel_button.TabIndex = 7;
			this.Cancel_button.Text = "&Cancel";
			this.Cancel_button.Click += new System.EventHandler(this.Cancel_button_Click);
			// 
			// openFileDialog1
			// 
			this.openFileDialog1.DefaultExt = "cfg";
			this.openFileDialog1.Filter = "Config File (*.cfg)|*.cfg|All Files (*.*)|*.*";
			this.openFileDialog1.Title = "Open Config File";
			// 
			// groupBox2
			// 
			this.groupBox2.Controls.Add(this.label2);
			this.groupBox2.Controls.Add(this.BrLocalID);
			this.groupBox2.Controls.Add(this.File_textBox);
			this.groupBox2.Controls.Add(this.label1);
			this.groupBox2.Controls.Add(this.DTMF_checkBox);
			this.groupBox2.Controls.Add(this.Header_checkBox);
			this.groupBox2.Controls.Add(this.Browse_button);
			this.groupBox2.Location = new System.Drawing.Point(8, 128);
			this.groupBox2.Name = "groupBox2";
			this.groupBox2.Size = new System.Drawing.Size(272, 128);
			this.groupBox2.TabIndex = 3;
			this.groupBox2.TabStop = false;
			this.groupBox2.Text = "Channel settings";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(8, 75);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(64, 16);
			this.label2.TabIndex = 14;
			this.label2.Text = "Local ID:";
			// 
			// BrLocalID
			// 
			this.BrLocalID.Location = new System.Drawing.Point(75, 72);
			this.BrLocalID.MaxLength = 60;
			this.BrLocalID.Name = "BrLocalID";
			this.BrLocalID.Size = new System.Drawing.Size(184, 20);
			this.BrLocalID.TabIndex = 3;
			this.BrLocalID.Text = "";
			// 
			// File_textBox
			// 
			this.File_textBox.Location = new System.Drawing.Point(75, 16);
			this.File_textBox.MaxLength = 255;
			this.File_textBox.Name = "File_textBox";
			this.File_textBox.Size = new System.Drawing.Size(184, 20);
			this.File_textBox.TabIndex = 1;
			this.File_textBox.Text = "";
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 19);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(64, 16);
			this.label1.TabIndex = 11;
			this.label1.Text = "Config File:";
			// 
			// DTMF_checkBox
			// 
			this.DTMF_checkBox.Location = new System.Drawing.Point(211, 104);
			this.DTMF_checkBox.Name = "DTMF_checkBox";
			this.DTMF_checkBox.Size = new System.Drawing.Size(56, 16);
			this.DTMF_checkBox.TabIndex = 5;
			this.DTMF_checkBox.Text = "DTMF";
			// 
			// Header_checkBox
			// 
			this.Header_checkBox.Location = new System.Drawing.Point(75, 104);
			this.Header_checkBox.Name = "Header_checkBox";
			this.Header_checkBox.Size = new System.Drawing.Size(104, 16);
			this.Header_checkBox.TabIndex = 4;
			this.Header_checkBox.Text = "Create Header";
			// 
			// Browse_button
			// 
			this.Browse_button.Location = new System.Drawing.Point(184, 42);
			this.Browse_button.Name = "Browse_button";
			this.Browse_button.TabIndex = 2;
			this.Browse_button.Text = "&Browse";
			this.Browse_button.Click += new System.EventHandler(this.Browse_button_Click);
			// 
			// BrokktroutOpen
			// 
			this.AcceptButton = this.OK_button;
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.CancelButton = this.Cancel_button;
			this.ClientSize = new System.Drawing.Size(290, 263);
			this.Controls.Add(this.groupBox2);
			this.Controls.Add(this.Cancel_button);
			this.Controls.Add(this.OK_button);
			this.Controls.Add(this.groupBox1);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "BrokktroutOpen";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Open Brooktrout Channel";
			this.Load += new System.EventHandler(this.BrokktroutOpen_Load);
			this.groupBox1.ResumeLayout(false);
			this.groupBox2.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		private void Cancel_button_Click(object sender, System.EventArgs e)
		{
			this.Close();
		}

		private void OK_button_Click(object sender, System.EventArgs e)
		{
			int errcode;

			Cursor = Cursors.WaitCursor;
			Enabled = false;
			if (DTMF_checkBox.Checked)
				parent.m_bDTMF = true;
			else parent.m_bDTMF = false;
			parent.axFAX1.BrooktroutCFile = File_textBox.Text;
			WritePrivateProfileString("Brooktrout","Config file",parent.axFAX1.BrooktroutCFile,"Demo32.ini");
			parent.axFAX1.LocalID = BrLocalID.Text;
			parent.m_ActualFaxPort = (string)PortListBox.SelectedItem;
			System.Threading.Thread.Sleep(2000);
			errcode = parent.axFAX1.OpenPort((string)PortListBox.SelectedItem);
			if (errcode != 0)
			{
				MessageBox.Show(parent.GetError(errcode), "Error");
				this.Cursor = Cursors.Default;
				this.Enabled = true;
				return;
			}
			else
			{
				if (DTMF_checkBox.Checked)
					parent.axFAX1.RecvDTMF((string)PortListBox.SelectedItem, 5, 20);
				parent.SetMenuItems(true);
				parent.textBox1.Items.Add((string)PortListBox.SelectedItem + " was opened");
				parent.axFAX1.Header = Header_checkBox.Checked;
				parent.axFAX1.SetPortCapability((string)PortListBox.SelectedItem, 10, (short)parent.BaudRate);
			}
			if (parent.axFAX1.AvailableBrooktroutChannels.Length > 0)
				parent.SetBrooktroutMenu(true);
			else
				parent.SetBrooktroutMenu(false);

			Cursor = Cursors.Default;
			Enabled = true;
			Close();
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

		[DllImport("kernel32", EntryPoint="WritePrivateProfileStringA",
			 CharSet=CharSet.Ansi)]
		private static extern int WritePrivateProfileString(
			string sectionName,
			string keyName,
			string stringToWrite,
			string fileName);

		private void BrokktroutOpen_Load(object sender, System.EventArgs e)
		{
			string szString1, szString2 = null;
			bool flag;
			int j;
			if (parent.m_bDTMF)
				DTMF_checkBox.Checked=true;
			else 
				DTMF_checkBox.Checked = false;
			if (parent.axFAX1.Header)
				Header_checkBox.Checked = true;
			else
				Header_checkBox.Checked = false;

			outbuffer = new StringBuilder(200);
			GetPrivateProfileString("Brooktrout", "Config file", "btcall.cfg", outbuffer, 200, "Demo32.ini");
			File_textBox.Text = outbuffer.ToString();
			BrLocalID.Text=parent.axFAX1.LocalID;
			szString1 = parent.axFAX1.AvailableBrooktroutChannels;
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
				PortListBox.Items.Add(szString2);
			}
			PortListBox.SetSelected(0, true);
		}

		private void Browse_button_Click(object sender, System.EventArgs e)
		{
			if (openFileDialog1.ShowDialog() == System.Windows.Forms.DialogResult.OK)
			{
				File_textBox.Text = openFileDialog1.FileName;
			}
		}
	}
}