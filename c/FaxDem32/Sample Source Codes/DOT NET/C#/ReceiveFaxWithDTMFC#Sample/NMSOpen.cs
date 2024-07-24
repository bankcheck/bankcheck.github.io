using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace FaxcppDemo
{
	/// <summary>
	/// Summary description for NMSOpen.
	/// </summary>
	public class NMSOpen : System.Windows.Forms.Form
	{
		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.ListBox Channel_listBox;
		private System.Windows.Forms.Button OK_button;
		private System.Windows.Forms.Button Cancel_button;
		public Form1 parent;
		private string DTMF;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.ComboBox Protocol_comboBox;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.TextBox DTMFNMS;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public NMSOpen()
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
			this.Channel_listBox = new System.Windows.Forms.ListBox();
			this.OK_button = new System.Windows.Forms.Button();
			this.Cancel_button = new System.Windows.Forms.Button();
			this.label1 = new System.Windows.Forms.Label();
			this.Protocol_comboBox = new System.Windows.Forms.ComboBox();
			this.label2 = new System.Windows.Forms.Label();
			this.DTMFNMS = new System.Windows.Forms.TextBox();
			this.groupBox1.SuspendLayout();
			this.SuspendLayout();
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.Channel_listBox);
			this.groupBox1.Location = new System.Drawing.Point(8, 8);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(176, 136);
			this.groupBox1.TabIndex = 0;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "Available NMS Channels";
			// 
			// Channel_listBox
			// 
			this.Channel_listBox.Location = new System.Drawing.Point(8, 16);
			this.Channel_listBox.Name = "Channel_listBox";
			this.Channel_listBox.Size = new System.Drawing.Size(160, 108);
			this.Channel_listBox.TabIndex = 0;
			// 
			// OK_button
			// 
			this.OK_button.Location = new System.Drawing.Point(192, 16);
			this.OK_button.Name = "OK_button";
			this.OK_button.Size = new System.Drawing.Size(80, 24);
			this.OK_button.TabIndex = 3;
			this.OK_button.Text = "OK";
			this.OK_button.Click += new System.EventHandler(this.OK_button_Click);
			// 
			// Cancel_button
			// 
			this.Cancel_button.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.Cancel_button.Location = new System.Drawing.Point(192, 52);
			this.Cancel_button.Name = "Cancel_button";
			this.Cancel_button.Size = new System.Drawing.Size(80, 24);
			this.Cancel_button.TabIndex = 4;
			this.Cancel_button.Text = "Cancel";
			this.Cancel_button.Click += new System.EventHandler(this.Cancel_button_Click);
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 152);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(136, 16);
			this.label1.TabIndex = 4;
			this.label1.Text = "NMS Telephony Protocol:";
			// 
			// Protocol_comboBox
			// 
			this.Protocol_comboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.Protocol_comboBox.Items.AddRange(new object[] {
																   "Analog Loop Start (LPS0)",
																   "Digital/Analog Wink Start (inbound only) (DID0)",
																   "Digital/Analog Wink Start (outbound only) (OGT0)",
																   "Digital/Analog Wink Start (WNK0)",
																   "Analog Wink Start (WNK1)",
																   "Digital Loop Start OPS-FX (LPS8)",
																   "Feature Group D (inbound only) (FDI0)",
																   "Digital Loop Start OPS-SA (LPS9)",
																   "Digital Ground Start OPS-FX (GST8)",
																   "Digital Ground Start OPS-SA (GST9)",
																   "ISDN protocol (ISD0)",
																   "MFC R2 protocol (MFC0)"});
			this.Protocol_comboBox.Location = new System.Drawing.Point(8, 168);
			this.Protocol_comboBox.Name = "Protocol_comboBox";
			this.Protocol_comboBox.Size = new System.Drawing.Size(264, 21);
			this.Protocol_comboBox.TabIndex = 1;
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(8, 196);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(72, 16);
			this.label2.TabIndex = 16;
			this.label2.Text = "DTMF Digits:";
			// 
			// DTMFNMS
			// 
			this.DTMFNMS.Location = new System.Drawing.Point(75, 194);
			this.DTMFNMS.MaxLength = 1;
			this.DTMFNMS.Name = "DTMFNMS";
			this.DTMFNMS.Size = new System.Drawing.Size(17, 20);
			this.DTMFNMS.TabIndex = 2;
			this.DTMFNMS.Text = "4";
			this.DTMFNMS.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.DTMFNMS_KeyPress);
			this.DTMFNMS.TextChanged += new System.EventHandler(this.DTMFNMS_TextChanged);
			// 
			// NMSOpen
			// 
			this.AcceptButton = this.OK_button;
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.CancelButton = this.Cancel_button;
			this.ClientSize = new System.Drawing.Size(282, 223);
			this.Controls.Add(this.DTMFNMS);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.Protocol_comboBox);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.Cancel_button);
			this.Controls.Add(this.OK_button);
			this.Controls.Add(this.groupBox1);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "NMSOpen";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Open NMS Channel";
			this.Load += new System.EventHandler(this.NMSOpen_Load);
			this.groupBox1.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		private void NMSOpen_Load(object sender, System.EventArgs e)
		{
			string szString1, szString2 = null;
			bool flag;
			int j;
			
			szString1 = parent.axFAX1.AvailableNMSChannels;
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
				Channel_listBox.Items.Add(szString2);
			}
			Channel_listBox.SetSelected(0, true);
			Protocol_comboBox.SelectedIndex=0;
		}

		private void Cancel_button_Click(object sender, System.EventArgs e)
		{
			Close();
		}

		private void OK_button_Click(object sender, System.EventArgs e)
		{
			int errcode;
			string protocol;

			Enabled = false;
			Cursor = Cursors.WaitCursor;

			protocol = GetSelectedProtocol(Protocol_comboBox.SelectedIndex);
			parent.axFAX1.NMSProtocoll = protocol;
			if (DTMFNMS.Text.Length==0)
			{
				MessageBox.Show("You must specify the number of the DTMF Digits!","Warning");
				DTMFNMS.Focus();
				Enabled=true;
				Cursor = Cursors.Default;
				return;
			}

			parent.axFAX1.OpenPort((string)Channel_listBox.SelectedItem);
			errcode = parent.axFAX1.FaxError;
			if (errcode != 0)
			{
				MessageBox.Show(parent.GetError(errcode), "Error");
				this.Cursor = Cursors.Default;
				this.Enabled = true;
				return;
			}
			else
			{
				parent.axFAX1.RecvDTMF((string)Channel_listBox.SelectedItem, Convert.ToInt16(DTMFNMS.Text), 20);
				parent.SetMenuItems(true);
				parent.textBox1.Items.Add((string)Channel_listBox.SelectedItem + " was opened");
				parent.axFAX1.SetPortCapability((string)Channel_listBox.SelectedItem, 10, 15);
			}
			if (parent.axFAX1.AvailableNMSChannels.Length > 0)
				parent.SetNMSMenu(true);
			else
				parent.SetNMSMenu(false);

			Enabled = true;
			Cursor = Cursors.Default;
			Close();
		}

		private string GetSelectedProtocol(int index)
		{
			string retval = null;
			switch (index)
			{
				case 0 : retval = "LPS0";
					break;
				case 1 : retval =  "DID0";
					break;
				case 2 : retval = "OGT0";
					break;
				case 3 : retval = "WNK0";
					break;
				case 4 : retval = "WNK1";
					break;
				case 5 : retval = "LPS8";
					break;
				case 6 : retval = "FDI0";
					break;
				case 7 : retval = "LPS9";
					break;
				case 8 : retval = "GST8";
					break;
				case 9 : retval = "GST9";
					break;
				case 10 : retval = "ISD0";
					break;
				case 11 : retval = "MFC0";
					break;
				default : retval = "LPS0";
					break;
			}
			return retval;
		}

		private void DTMFNMS_TextChanged(object sender, System.EventArgs e)
		{
			if (DTMFNMS.Text.Length>0)
			{
				if (DTMFNMS.Text[0]<48 || DTMFNMS.Text[0] > 57)
				{
					if (DTMF!=null)	DTMFNMS.Text=DTMF;
					DTMFNMS.SelectAll();
				}
			}
		}

		private void DTMFNMS_KeyPress(object sender, System.Windows.Forms.KeyPressEventArgs e)
		{
			DTMF=DTMFNMS.Text;
		}
	}
}
