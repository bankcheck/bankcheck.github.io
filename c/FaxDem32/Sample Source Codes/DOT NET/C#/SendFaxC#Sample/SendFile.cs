using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.IO;

namespace FaxcppDemo
{
	/// <summary>
	/// Summary description for SendFile.
	/// </summary>
	public class SendFile : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Button OK_button;
		private System.Windows.Forms.Button Cancel_button;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.TextBox Phone_textBox;
		private System.Windows.Forms.TextBox File_textBox;
		private System.Windows.Forms.Button Browse_button;
		private System.Windows.Forms.OpenFileDialog openFileDialog1;
		public Form1 parent;
		internal System.Windows.Forms.Label Label3;
		internal System.Windows.Forms.ListBox FaxPortsListBox;
		internal System.Windows.Forms.GroupBox GroupBox1;
		internal System.Windows.Forms.RadioButton ImmediateButton;
		internal System.Windows.Forms.RadioButton QueueButton;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public SendFile()
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
			this.label1 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.Phone_textBox = new System.Windows.Forms.TextBox();
			this.File_textBox = new System.Windows.Forms.TextBox();
			this.Browse_button = new System.Windows.Forms.Button();
			this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
			this.Label3 = new System.Windows.Forms.Label();
			this.FaxPortsListBox = new System.Windows.Forms.ListBox();
			this.GroupBox1 = new System.Windows.Forms.GroupBox();
			this.ImmediateButton = new System.Windows.Forms.RadioButton();
			this.QueueButton = new System.Windows.Forms.RadioButton();
			this.GroupBox1.SuspendLayout();
			this.SuspendLayout();
			// 
			// OK_button
			// 
			this.OK_button.Location = new System.Drawing.Point(80, 163);
			this.OK_button.Name = "OK_button";
			this.OK_button.TabIndex = 6;
			this.OK_button.Text = "OK";
			this.OK_button.Click += new System.EventHandler(this.OK_button_Click);
			// 
			// Cancel_button
			// 
			this.Cancel_button.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.Cancel_button.Location = new System.Drawing.Point(181, 163);
			this.Cancel_button.Name = "Cancel_button";
			this.Cancel_button.TabIndex = 7;
			this.Cancel_button.Text = "Cancel";
			this.Cancel_button.Click += new System.EventHandler(this.Cancel_button_Click);
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 104);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(88, 16);
			this.label1.TabIndex = 2;
			this.label1.Text = "Fax Number:";
			this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(8, 136);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(72, 16);
			this.label2.TabIndex = 3;
			this.label2.Text = "File To Send:";
			this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			// 
			// Phone_textBox
			// 
			this.Phone_textBox.Location = new System.Drawing.Point(80, 104);
			this.Phone_textBox.MaxLength = 32;
			this.Phone_textBox.Name = "Phone_textBox";
			this.Phone_textBox.Size = new System.Drawing.Size(176, 20);
			this.Phone_textBox.TabIndex = 0;
			this.Phone_textBox.Text = "";
			// 
			// File_textBox
			// 
			this.File_textBox.Location = new System.Drawing.Point(80, 136);
			this.File_textBox.MaxLength = 255;
			this.File_textBox.Name = "File_textBox";
			this.File_textBox.Size = new System.Drawing.Size(176, 20);
			this.File_textBox.TabIndex = 4;
			this.File_textBox.Text = "";
			// 
			// Browse_button
			// 
			this.Browse_button.Location = new System.Drawing.Point(264, 136);
			this.Browse_button.Name = "Browse_button";
			this.Browse_button.Size = new System.Drawing.Size(88, 23);
			this.Browse_button.TabIndex = 5;
			this.Browse_button.Text = "Browse";
			this.Browse_button.Click += new System.EventHandler(this.Browse_button_Click);
			// 
			// openFileDialog1
			// 
			this.openFileDialog1.DefaultExt = "tif";
			this.openFileDialog1.Filter = "TIFF File Format (*.tif)|*.tif";
			// 
			// Label3
			// 
			this.Label3.Location = new System.Drawing.Point(8, 3);
			this.Label3.Name = "Label3";
			this.Label3.Size = new System.Drawing.Size(72, 16);
			this.Label3.TabIndex = 16;
			this.Label3.Text = "Fax Ports:";
			this.Label3.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// FaxPortsListBox
			// 
			this.FaxPortsListBox.Location = new System.Drawing.Point(8, 24);
			this.FaxPortsListBox.Name = "FaxPortsListBox";
			this.FaxPortsListBox.Size = new System.Drawing.Size(248, 69);
			this.FaxPortsListBox.TabIndex = 1;
			// 
			// GroupBox1
			// 
			this.GroupBox1.Controls.Add(this.ImmediateButton);
			this.GroupBox1.Controls.Add(this.QueueButton);
			this.GroupBox1.Location = new System.Drawing.Point(264, 20);
			this.GroupBox1.Name = "GroupBox1";
			this.GroupBox1.Size = new System.Drawing.Size(88, 100);
			this.GroupBox1.TabIndex = 4;
			this.GroupBox1.TabStop = false;
			this.GroupBox1.Text = "Send";
			// 
			// ImmediateButton
			// 
			this.ImmediateButton.Location = new System.Drawing.Point(8, 56);
			this.ImmediateButton.Name = "ImmediateButton";
			this.ImmediateButton.Size = new System.Drawing.Size(75, 24);
			this.ImmediateButton.TabIndex = 3;
			this.ImmediateButton.Text = "Immediate";
			// 
			// QueueButton
			// 
			this.QueueButton.Checked = true;
			this.QueueButton.Location = new System.Drawing.Point(8, 24);
			this.QueueButton.Name = "QueueButton";
			this.QueueButton.Size = new System.Drawing.Size(72, 24);
			this.QueueButton.TabIndex = 2;
			this.QueueButton.TabStop = true;
			this.QueueButton.Text = "Queue";
			// 
			// SendFile
			// 
			this.AcceptButton = this.OK_button;
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.CancelButton = this.Cancel_button;
			this.ClientSize = new System.Drawing.Size(359, 191);
			this.Controls.Add(this.GroupBox1);
			this.Controls.Add(this.FaxPortsListBox);
			this.Controls.Add(this.Label3);
			this.Controls.Add(this.Browse_button);
			this.Controls.Add(this.File_textBox);
			this.Controls.Add(this.Phone_textBox);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.Cancel_button);
			this.Controls.Add(this.OK_button);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "SendFile";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Send a File";
			this.Load += new System.EventHandler(this.SendFile_Load);
			this.GroupBox1.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		private void Cancel_button_Click(object sender, System.EventArgs e)
		{
			Close();
		}

		private void Browse_button_Click(object sender, System.EventArgs e)
		{
			if (openFileDialog1.ShowDialog() == System.Windows.Forms.DialogResult.OK)
				File_textBox.Text = openFileDialog1.FileName;
		}

		private void OK_button_Click(object sender, System.EventArgs e)
		{
			int FaxID, errorsend;
			string strerr, ext, PhoneNum;
			short pageNum;
			char actualchar;
			bool bOK = true, notNumber=false;
			PhoneNum=Phone_textBox.Text;
			short i;
			i = 0;
			while (i < PhoneNum.Length && notNumber == false)
			{
				actualchar = PhoneNum[i];
				if ((actualchar<48 || actualchar>57)&&(actualchar!=44)) notNumber = true;
				i++;
			}
			if (Phone_textBox.Text.Length == 0 || notNumber == true)
			{
				if (notNumber) MessageBox.Show("The given phone number is incorrect.","Warning");
				else MessageBox.Show("You must specify the phone number.","Warning");
				Phone_textBox.SelectAll();
				Phone_textBox.Focus();
				return;
			}
			if (!File.Exists(File_textBox.Text))
			{
				MessageBox.Show("You must specify an existing file to send.","Warning");
				File_textBox.SelectAll();
				File_textBox.Focus();
				return;
			}

			// Get the filename extension
			ext = File_textBox.Text.Substring(File_textBox.Text.Length-3, 3).ToUpper();

			if (ext == "TIF")
				pageNum = (short)parent.axFAX1.GetNumberOfImages(File_textBox.Text, (short)6);
			else
			{
				MessageBox.Show("You must specify a TIFF file!","Warning");
				File_textBox.SelectAll();
				File_textBox.Focus();
				return;
			}

			parent.axFAX1.PageFileName = File_textBox.Text;

			if (parent.axFAX1.IsDemoVersion() && pageNum > 1)
			{
				MessageBox.Show("The DEMO version of the Fax OCX supports only 1 page faxes. ONLY the first page will be sent.", "Error");
				pageNum = 1;
			}

			FaxID = parent.axFAX1.CreateFaxObject(1, pageNum, 3, 2, 1, 2, 2, 1, 2, 1);
			if (FaxID == 0)
			{
				strerr = "Can't create fax object! Error string: " + Convert.ToString(parent.axFAX1.FaxError, 10);
				MessageBox.Show(strerr);
			}
			else
			{
				parent.axFAX1.SetFaxParam(FaxID, 9, pageNum);
				parent.axFAX1.SetPhoneNumber(FaxID, Phone_textBox.Text);
				for (i = 1; i <= pageNum; ++i)
				{
					if (parent.axFAX1.SetFaxPage(FaxID, (short)i, 17, (short)i) != 0)
					{
						strerr = "Can't set fax page! Error code: " + Convert.ToString(parent.axFAX1.FaxError, 10);
						MessageBox.Show(strerr);
						bOK = false;
						break;
					}
				}
				if (bOK)
				{
					errorsend=0;
					if (ImmediateButton.Checked)
					{
						errorsend = parent.axFAX1.SendNow((string)FaxPortsListBox.SelectedItem, FaxID);
					}
					else if (QueueButton.Checked)
						errorsend = parent.axFAX1.SendFaxObj(FaxID);
					if (errorsend != 0)
					{
						parent.axFAX1.ClearFaxObject(FaxID);
						strerr = "Can't send fax! Error code: " + Convert.ToString(parent.axFAX1.FaxError, 10);
						MessageBox.Show(strerr);
					}
				}
			}
			Close();
		}

		private void SendFile_Load(object sender, System.EventArgs e)
		{
			int j; 
			string t1, t2;
			bool flag;
        t1=parent.axFAX1.PortsOpen;
		
		if (t1.Length > 0)
		{
            flag = true;
            while (flag)
			{
                j = t1.IndexOf(" ");
				if (j == -1)
				{
					t2 = t1;
					flag = false;
				}
				else
				{
					t2 = t1.Substring(0, j);
					t1 = t1.Remove(0, j + 1);
				}
                FaxPortsListBox.Items.Add(t2);
			}			
		}
        FaxPortsListBox.SetSelected(0, true);
		File_textBox.Text="Test.tif";
		Phone_textBox.Focus();
		}

	}
}
