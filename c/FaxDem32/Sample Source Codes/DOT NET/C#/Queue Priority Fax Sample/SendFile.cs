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
			this.SuspendLayout();
			// 
			// OK_button
			// 
			this.OK_button.Location = new System.Drawing.Point(8, 168);
			this.OK_button.Name = "OK_button";
			this.OK_button.TabIndex = 4;
			this.OK_button.Text = "OK";
			this.OK_button.Click += new System.EventHandler(this.OK_button_Click);
			// 
			// Cancel_button
			// 
			this.Cancel_button.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.Cancel_button.Location = new System.Drawing.Point(99, 168);
			this.Cancel_button.Name = "Cancel_button";
			this.Cancel_button.TabIndex = 5;
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
			this.Phone_textBox.Size = new System.Drawing.Size(184, 20);
			this.Phone_textBox.TabIndex = 1;
			this.Phone_textBox.Text = "";
			// 
			// File_textBox
			// 
			this.File_textBox.Location = new System.Drawing.Point(80, 136);
			this.File_textBox.MaxLength = 255;
			this.File_textBox.Name = "File_textBox";
			this.File_textBox.Size = new System.Drawing.Size(184, 20);
			this.File_textBox.TabIndex = 2;
			this.File_textBox.Text = "";
			// 
			// Browse_button
			// 
			this.Browse_button.Location = new System.Drawing.Point(190, 168);
			this.Browse_button.Name = "Browse_button";
			this.Browse_button.TabIndex = 3;
			this.Browse_button.Text = "Browse";
			this.Browse_button.Click += new System.EventHandler(this.Browse_button_Click);
			// 
			// openFileDialog1
			// 
			this.openFileDialog1.DefaultExt = "tif";
			this.openFileDialog1.Filter = " Bitmap Format (*.bmp)|*.bmp|TIFF File Format (*.tif)|*.tif|JPEG Format (*.jpg)|*" +
				".jpg|ASCII Text File (*.txt)|*.txt|All Files (*.*)|*.*";
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
			this.FaxPortsListBox.Size = new System.Drawing.Size(256, 69);
			this.FaxPortsListBox.TabIndex = 0;
			// 
			// SendFile
			// 
			this.AcceptButton = this.OK_button;
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.CancelButton = this.Cancel_button;
			this.ClientSize = new System.Drawing.Size(274, 199);
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
			int FaxID, back;
			string strerr, ext, PhoneNum;
			short pageNum;
			char actualchar;
			bool bOK = true, notNumber=false;
			PhoneNum=Phone_textBox.Text;
			short i;
			int actPage;
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

			parent.axFAX1.PageFileName = File_textBox.Text;

			// Get the filename extension
			ext = File_textBox.Text.Substring(File_textBox.Text.Length-3, 3).ToUpper();

			if (ext == "TIF")
				pageNum = (short)parent.axFAX1.GetNumberOfImages(File_textBox.Text, (short)6);
			else
			{
				MessageBox.Show("You must specify a TIFF file.","Warning");
				File_textBox.SelectAll();
				File_textBox.Focus();
				return;
			}

			for(int loops=0;loops<10;loops++)
			{
				if (loops ==0) 
					actPage = pageNum;
				else
				{
					Random r = new Random();
					actPage=r.Next(1,pageNum);
				}
				FaxID = parent.axFAX1.CreateFaxObject(1, 1, 3, 2, 1, 2, 2, 3, 2, 1);
				if (FaxID == 0)
				{
					strerr = "Can't create fax object! Error string: " + Convert.ToString(parent.axFAX1.FaxError, 10);
					MessageBox.Show(strerr);
				}
				else
				{
					back = parent.axFAX1.SetFaxParam(FaxID, 9, 1);
					parent.axFAX1.SetFaxParam(FaxID, 12, (short)actPage);
					back = parent.axFAX1.SetPhoneNumber(FaxID, Phone_textBox.Text);
					parent.textBox1.Items.Add("Setup page " + Convert.ToString(actPage) + " for sending " + parent.axFAX1.PageFileName);
					if (parent.axFAX1.SetFaxPage(FaxID, 1, 11, (short)actPage) != 0)
						{
							strerr = "Can't set fax page! Error code: " + Convert.ToString(parent.axFAX1.FaxError, 10);
							MessageBox.Show(strerr);
							bOK = false;
							break;
						}
					if (bOK)
					{
						back = parent.axFAX1.SendFaxObj(FaxID);
						if (back != 0)
						{
							parent.axFAX1.ClearFaxObject(FaxID);
							strerr = "Can't send fax! Error code: " + Convert.ToString(parent.axFAX1.FaxError, 10);
							MessageBox.Show(strerr);
						}
						else
							parent.textBox1.Items.Add(parent.m_ActualFaxPort+ ": Fax has been sent to queue");
					}
				}
			}
			Close();
		}

		private void SendFile_Load(object sender, System.EventArgs e)
		{
			int j,portindex,spaceindex; 
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
				portindex=parent.PortsAndClasses.IndexOf(t2)+t2.Length+1;
				spaceindex=parent.PortsAndClasses.IndexOf(' ',portindex);
				t2=t2+':'+parent.axFAX1.GetLongName((short)(Convert.ToByte(parent.PortsAndClasses.Substring(portindex,spaceindex-portindex))));
                FaxPortsListBox.Items.Add(t2);
			}			
		}
        t1 = parent.axFAX1.BrooktroutChannelsOpen;
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

        t1 = parent.axFAX1.GammaChannelsOpen;
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

        t1 = parent.axFAX1.DialogicChannelsOpen;
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

        t1 = parent.axFAX1.NMSChannelsOpen;
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
		File_textBox.Text="Testqueue.tif";
		Phone_textBox.Focus();
		}

	}
}
