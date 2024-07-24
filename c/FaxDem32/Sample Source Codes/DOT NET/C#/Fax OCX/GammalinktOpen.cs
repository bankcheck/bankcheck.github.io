using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace FaxcppDemo
{
	/// <summary>
	/// Summary description for BrokktroutOpen.
	/// </summary>
	public class GammalinkOpen : System.Windows.Forms.Form
	{
		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.ListBox PortListBox;
		private System.Windows.Forms.Button OK_button;
		private System.Windows.Forms.Button Cancel_button;
		private System.Windows.Forms.Button Browse_button;
		private System.Windows.Forms.CheckBox Header_checkBox;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.TextBox File_textBox;
		public Form1 parent;
		private System.Windows.Forms.OpenFileDialog openFileDialog1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label ChannelTypeLabel;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.TextBox LocalIDTextBox;
		private System.Windows.Forms.Button button1;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public GammalinkOpen()
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
			this.Browse_button = new System.Windows.Forms.Button();
			this.Header_checkBox = new System.Windows.Forms.CheckBox();
			this.label1 = new System.Windows.Forms.Label();
			this.File_textBox = new System.Windows.Forms.TextBox();
			this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
			this.label2 = new System.Windows.Forms.Label();
			this.ChannelTypeLabel = new System.Windows.Forms.Label();
			this.label3 = new System.Windows.Forms.Label();
			this.LocalIDTextBox = new System.Windows.Forms.TextBox();
			this.button1 = new System.Windows.Forms.Button();
			this.groupBox1.SuspendLayout();
			this.SuspendLayout();
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.PortListBox);
			this.groupBox1.Location = new System.Drawing.Point(8, 8);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(184, 104);
			this.groupBox1.TabIndex = 0;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "Available Channels";
			// 
			// PortListBox
			// 
			this.PortListBox.Location = new System.Drawing.Point(8, 16);
			this.PortListBox.Name = "PortListBox";
			this.PortListBox.Size = new System.Drawing.Size(168, 82);
			this.PortListBox.TabIndex = 0;
			// 
			// OK_button
			// 
			this.OK_button.Location = new System.Drawing.Point(200, 16);
			this.OK_button.Name = "OK_button";
			this.OK_button.Size = new System.Drawing.Size(80, 23);
			this.OK_button.TabIndex = 1;
			this.OK_button.Text = "OK";
			this.OK_button.Click += new System.EventHandler(this.OK_button_Click);
			// 
			// Cancel_button
			// 
			this.Cancel_button.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.Cancel_button.Location = new System.Drawing.Point(200, 52);
			this.Cancel_button.Name = "Cancel_button";
			this.Cancel_button.Size = new System.Drawing.Size(80, 23);
			this.Cancel_button.TabIndex = 2;
			this.Cancel_button.Text = "Cancel";
			this.Cancel_button.Click += new System.EventHandler(this.Cancel_button_Click);
			// 
			// Browse_button
			// 
			this.Browse_button.Location = new System.Drawing.Point(200, 212);
			this.Browse_button.Name = "Browse_button";
			this.Browse_button.Size = new System.Drawing.Size(80, 23);
			this.Browse_button.TabIndex = 3;
			this.Browse_button.Text = "&Browse";
			this.Browse_button.Click += new System.EventHandler(this.Browse_button_Click);
			// 
			// Header_checkBox
			// 
			this.Header_checkBox.Location = new System.Drawing.Point(8, 214);
			this.Header_checkBox.Name = "Header_checkBox";
			this.Header_checkBox.Size = new System.Drawing.Size(104, 16);
			this.Header_checkBox.TabIndex = 4;
			this.Header_checkBox.Text = "Create Header";
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 186);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(64, 16);
			this.label1.TabIndex = 6;
			this.label1.Text = "Config File:";
			// 
			// File_textBox
			// 
			this.File_textBox.Location = new System.Drawing.Point(64, 184);
			this.File_textBox.MaxLength = 255;
			this.File_textBox.Name = "File_textBox";
			this.File_textBox.Size = new System.Drawing.Size(216, 20);
			this.File_textBox.TabIndex = 7;
			this.File_textBox.Text = "";
			// 
			// openFileDialog1
			// 
			this.openFileDialog1.DefaultExt = "cfg";
			this.openFileDialog1.Filter = "Config File (*.cfg)|*.cfg|All Files (*.*)|*.*";
			this.openFileDialog1.Title = "Open Config File";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(8, 128);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(80, 16);
			this.label2.TabIndex = 8;
			this.label2.Text = "Channel Type:";
			// 
			// ChannelTypeLabel
			// 
			this.ChannelTypeLabel.Location = new System.Drawing.Point(88, 128);
			this.ChannelTypeLabel.Name = "ChannelTypeLabel";
			this.ChannelTypeLabel.Size = new System.Drawing.Size(184, 16);
			this.ChannelTypeLabel.TabIndex = 9;
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(8, 154);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(56, 16);
			this.label3.TabIndex = 10;
			this.label3.Text = "Local ID:";
			// 
			// LocalIDTextBox
			// 
			this.LocalIDTextBox.Location = new System.Drawing.Point(64, 152);
			this.LocalIDTextBox.MaxLength = 60;
			this.LocalIDTextBox.Name = "LocalIDTextBox";
			this.LocalIDTextBox.Size = new System.Drawing.Size(216, 20);
			this.LocalIDTextBox.TabIndex = 11;
			this.LocalIDTextBox.Text = "";
			// 
			// button1
			// 
			this.button1.Location = new System.Drawing.Point(200, 88);
			this.button1.Name = "button1";
			this.button1.Size = new System.Drawing.Size(80, 23);
			this.button1.TabIndex = 12;
			this.button1.Text = "Test Channel";
			this.button1.Click += new System.EventHandler(this.button1_Click);
			// 
			// GammalinkOpen
			// 
			this.AcceptButton = this.OK_button;
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.CancelButton = this.Cancel_button;
			this.ClientSize = new System.Drawing.Size(290, 239);
			this.Controls.Add(this.button1);
			this.Controls.Add(this.LocalIDTextBox);
			this.Controls.Add(this.File_textBox);
			this.Controls.Add(this.label3);
			this.Controls.Add(this.ChannelTypeLabel);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.Header_checkBox);
			this.Controls.Add(this.Browse_button);
			this.Controls.Add(this.Cancel_button);
			this.Controls.Add(this.OK_button);
			this.Controls.Add(this.groupBox1);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "GammalinkOpen";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Open GammaLink channel";
			this.Load += new System.EventHandler(this.GammaLinkOpen_Load);
			this.groupBox1.ResumeLayout(false);
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

			parent.axFAX1.GammaCFile = File_textBox.Text;
			parent.axFAX1.LocalID=LocalIDTextBox.Text;
			parent.m_ActualFaxPort = (string)PortListBox.SelectedItem;
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
				parent.SetMenuItems(true);
				parent.textBox1.Items.Add((string)PortListBox.SelectedItem + " was opened");
				parent.axFAX1.Header = Header_checkBox.Checked;
				parent.axFAX1.SetPortCapability((string)PortListBox.SelectedItem, 10, (short)parent.BaudRate);
			}
			if (parent.axFAX1.AvailableGammaChannels.Length > 0)
				parent.SetGammaMenu(true);
			else
				parent.SetGammaMenu(false);

			Cursor = Cursors.Default;
			Enabled = true;
			Close();
		}

		private void GammaLinkOpen_Load(object sender, System.EventArgs e)
		{
			string szString1, szString2 = null;
			bool flag;
			int j;
			
			if (parent.axFAX1.Header)
				Header_checkBox.Checked = true;
			else
				Header_checkBox.Checked = false;

			File_textBox.Text = parent.axFAX1.GammaCFile;
			LocalIDTextBox.Text=parent.axFAX1.LocalID;
			szString1 = parent.axFAX1.AvailableGammaChannels;
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

		private void button1_Click(object sender, System.EventArgs e)
		{
			int error;
			this.Cursor = Cursors.WaitCursor;
			this.Enabled = false;
			error=parent.axFAX1.TestModem((string)PortListBox.SelectedItem);
			if (error==0)
				ChannelTypeLabel.Text=parent.axFAX1.Model;
			else ChannelTypeLabel.Text="Error code: "+error.ToString();
			this.Enabled=true;
			this.Cursor=Cursors.Default;

		}
	}
}
