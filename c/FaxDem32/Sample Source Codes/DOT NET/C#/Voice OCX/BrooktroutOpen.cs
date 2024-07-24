using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace VoiceOCXDemo
{
	/// <summary>
	/// Summary description for BrooktroutOpen.
	/// </summary>
	public class BrooktroutOpen : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Button OKbutton;
		private System.Windows.Forms.Button Cancelbutton;
		private System.Windows.Forms.Button Testbutton;
		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.ListBox ChannelList;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.TextBox TypeTB;
		private System.Windows.Forms.CheckBox LogEnableCB;
		public Form1 parent;
		private bool m_bLogEnabled;
		private int m_iModemID, m_iModemInd;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public BrooktroutOpen()
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
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(BrooktroutOpen));
			this.OKbutton = new System.Windows.Forms.Button();
			this.Cancelbutton = new System.Windows.Forms.Button();
			this.Testbutton = new System.Windows.Forms.Button();
			this.groupBox1 = new System.Windows.Forms.GroupBox();
			this.ChannelList = new System.Windows.Forms.ListBox();
			this.label1 = new System.Windows.Forms.Label();
			this.TypeTB = new System.Windows.Forms.TextBox();
			this.LogEnableCB = new System.Windows.Forms.CheckBox();
			this.groupBox1.SuspendLayout();
			this.SuspendLayout();
			// 
			// OKbutton
			// 
			this.OKbutton.Location = new System.Drawing.Point(352, 16);
			this.OKbutton.Name = "OKbutton";
			this.OKbutton.TabIndex = 0;
			this.OKbutton.Text = "&OK";
			this.OKbutton.Click += new System.EventHandler(this.OKbutton_Click);
			// 
			// Cancelbutton
			// 
			this.Cancelbutton.Location = new System.Drawing.Point(352, 48);
			this.Cancelbutton.Name = "Cancelbutton";
			this.Cancelbutton.TabIndex = 1;
			this.Cancelbutton.Text = "&Cancel";
			this.Cancelbutton.Click += new System.EventHandler(this.Cancelbutton_Click);
			// 
			// Testbutton
			// 
			this.Testbutton.Location = new System.Drawing.Point(352, 80);
			this.Testbutton.Name = "Testbutton";
			this.Testbutton.TabIndex = 2;
			this.Testbutton.Text = "&Test";
			this.Testbutton.Click += new System.EventHandler(this.Testbutton_Click);
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.AddRange(new System.Windows.Forms.Control[] {
																					this.ChannelList});
			this.groupBox1.Location = new System.Drawing.Point(8, 8);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(160, 104);
			this.groupBox1.TabIndex = 3;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "Available Channels";
			// 
			// ChannelList
			// 
			this.ChannelList.Location = new System.Drawing.Point(8, 16);
			this.ChannelList.Name = "ChannelList";
			this.ChannelList.Size = new System.Drawing.Size(144, 82);
			this.ChannelList.TabIndex = 0;
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(176, 16);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(80, 16);
			this.label1.TabIndex = 4;
			this.label1.Text = "Modem Type:";
			// 
			// TypeTB
			// 
			this.TypeTB.Location = new System.Drawing.Point(176, 40);
			this.TypeTB.MaxLength = 51;
			this.TypeTB.Name = "TypeTB";
			this.TypeTB.ReadOnly = true;
			this.TypeTB.Size = new System.Drawing.Size(152, 20);
			this.TypeTB.TabIndex = 5;
			this.TypeTB.Text = "Unknown Modem";
			// 
			// LogEnableCB
			// 
			this.LogEnableCB.Location = new System.Drawing.Point(176, 72);
			this.LogEnableCB.Name = "LogEnableCB";
			this.LogEnableCB.Size = new System.Drawing.Size(80, 16);
			this.LogEnableCB.TabIndex = 6;
			this.LogEnableCB.Text = "Enable Log";
			// 
			// BrooktroutOpen
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(442, 119);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.LogEnableCB,
																		  this.TypeTB,
																		  this.label1,
																		  this.groupBox1,
																		  this.Testbutton,
																		  this.Cancelbutton,
																		  this.OKbutton});
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "BrooktroutOpen";
			this.Text = "Open Brooktrout Channel";
			this.Load += new System.EventHandler(this.BrooktroutOpen_Load);
			this.groupBox1.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		private void Testbutton_Click(object sender, System.EventArgs e)
		{
			string szType = null;
			
			if (ChannelList.SelectedIndex != -1)
			{
				parent.axVoiceOCX1.GetBrooktroutChannelType((short)ChannelList.SelectedIndex, ref szType, 50);
				TypeTB.Text = szType;
			}

		}

		private void Cancelbutton_Click(object sender, System.EventArgs e)
		{
			Close();
		}

		private void OKbutton_Click(object sender, System.EventArgs e)
		{
			m_bLogEnabled = LogEnableCB.Checked;
			int index = ChannelList.SelectedIndex;
			if (index != -1)
			{
				m_iModemID = parent.axVoiceOCX1.CreateModemObject(4);//Brooktrout
				if (m_iModemID != 0)
				{
					m_iModemInd = parent.AddNewModem(m_iModemID);
					if (m_iModemInd != 0)
					{
						parent.fModemID.SetValue(3, m_iModemInd, 1);
						if (parent.axVoiceOCX1.OpenPort(m_iModemID, (string)ChannelList.SelectedItem) == 0)
						{
							OKbutton.Enabled = false;
							Cancelbutton.Enabled = false;
						}
						else
							MessageBox.Show("Cannot open channel: " + (string)ChannelList.SelectedItem);
					}
				}
			}
		}

		public int GetSelectedChannel()
		{
			return m_iModemID;
		}

		public bool GetLogEnabled()
		{
			return m_bLogEnabled;
		}

		private void BrooktroutOpen_Load(object sender, System.EventArgs e)
		{
			int nChannels = 0;
			string szChannel, bcStr;

			for (int i = 0; i <= 96; ++i)
				if (parent.axVoiceOCX1.IsBrooktroutChannelFree((short)i))
				{
					szChannel = "CHANNEL";
					bcStr = Convert.ToString(i);
					bcStr = bcStr.Substring(bcStr.Length - 1);
					szChannel += bcStr;
					ChannelList.Items.Add(szChannel);
					++nChannels;
				}
			if (nChannels != 0)
			{
				Testbutton.Enabled = true;
				OKbutton.Enabled = true;
			}
		}
		
		public void VoiceOCX_PortOpen()
		{
			MessageBox.Show("Channel opened");
			Close();
		}

		public void VoiceOCX_ModemError()
		{
			MessageBox.Show("Open channel failed!", "Error");
			OKbutton.Enabled = true;
			Cancelbutton.Enabled = true;
			parent.DeleteModem(m_iModemID);
			parent.axVoiceOCX1.DestroyModemObject(m_iModemID);
		}
	}
}
