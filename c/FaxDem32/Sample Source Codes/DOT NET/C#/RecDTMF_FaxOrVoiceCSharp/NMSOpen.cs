using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace RecDTMF_FaxOrVoiceCSharp
{
	/// <summary>
	/// Summary description for DialogicOpen.
	/// </summary>
	public class NMSOpen : System.Windows.Forms.Form
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;
		private System.Windows.Forms.Button OKbutton;
		private System.Windows.Forms.Button Cancelbutton;
		private System.Windows.Forms.ListBox ChannelList;
		public MainForm parent;
		private System.Windows.Forms.CheckBox EnableLogCB;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.TextBox DNISTB;
		private System.Windows.Forms.ComboBox ProtocolCB;
		private bool m_bLogEnabled;
        private bool failed;

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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(NMSOpen));
            this.OKbutton = new System.Windows.Forms.Button();
            this.Cancelbutton = new System.Windows.Forms.Button();
            this.ChannelList = new System.Windows.Forms.ListBox();
            this.EnableLogCB = new System.Windows.Forms.CheckBox();
            this.label1 = new System.Windows.Forms.Label();
            this.ProtocolCB = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.DNISTB = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // OKbutton
            // 
            this.OKbutton.Location = new System.Drawing.Point(296, 48);
            this.OKbutton.Name = "OKbutton";
            this.OKbutton.Size = new System.Drawing.Size(75, 23);
            this.OKbutton.TabIndex = 0;
            this.OKbutton.Text = "&OK";
            this.OKbutton.Click += new System.EventHandler(this.OKbutton_Click);
            // 
            // Cancelbutton
            // 
            this.Cancelbutton.Location = new System.Drawing.Point(296, 88);
            this.Cancelbutton.Name = "Cancelbutton";
            this.Cancelbutton.Size = new System.Drawing.Size(75, 23);
            this.Cancelbutton.TabIndex = 1;
            this.Cancelbutton.Text = "&Cancel";
            this.Cancelbutton.Click += new System.EventHandler(this.Cancelbutton_Click);
            // 
            // ChannelList
            // 
            this.ChannelList.Location = new System.Drawing.Point(8, 8);
            this.ChannelList.Name = "ChannelList";
            this.ChannelList.Size = new System.Drawing.Size(280, 147);
            this.ChannelList.TabIndex = 2;
            // 
            // EnableLogCB
            // 
            this.EnableLogCB.Location = new System.Drawing.Point(8, 168);
            this.EnableLogCB.Name = "EnableLogCB";
            this.EnableLogCB.Size = new System.Drawing.Size(104, 16);
            this.EnableLogCB.TabIndex = 3;
            this.EnableLogCB.Text = "Enable Log";
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(8, 200);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(136, 16);
            this.label1.TabIndex = 4;
            this.label1.Text = "NMS Telephony Protocol:";
            // 
            // ProtocolCB
            // 
            this.ProtocolCB.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.ProtocolCB.Items.AddRange(new object[] {
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
            this.ProtocolCB.Location = new System.Drawing.Point(8, 216);
            this.ProtocolCB.Name = "ProtocolCB";
            this.ProtocolCB.Size = new System.Drawing.Size(328, 21);
            this.ProtocolCB.TabIndex = 5;
            // 
            // label2
            // 
            this.label2.Location = new System.Drawing.Point(8, 248);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(88, 16);
            this.label2.TabIndex = 6;
            this.label2.Text = "DNIS\\DID Digits:";
            // 
            // DNISTB
            // 
            this.DNISTB.Location = new System.Drawing.Point(104, 246);
            this.DNISTB.MaxLength = 32;
            this.DNISTB.Name = "DNISTB";
            this.DNISTB.Size = new System.Drawing.Size(56, 20);
            this.DNISTB.TabIndex = 7;
            this.DNISTB.Text = "3";
            // 
            // NMSOpen
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
            this.ClientSize = new System.Drawing.Size(378, 287);
            this.Controls.Add(this.DNISTB);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.ProtocolCB);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.EnableLogCB);
            this.Controls.Add(this.ChannelList);
            this.Controls.Add(this.Cancelbutton);
            this.Controls.Add(this.OKbutton);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "NMSOpen";
            this.Text = "Open NMS Channel";
            this.Load += new System.EventHandler(this.NMSOpen_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

		}
		#endregion

		private void Cancelbutton_Click(object sender, System.EventArgs e)
		{
			Close();
		}

		public void VoiceOCX_PortOpen()
		{
			MessageBox.Show("Channel opened");
			Close();
		}

		public void VoiceOCX_ModemError()
		{
            if (!failed)
            {
                MessageBox.Show("Open channel failed!", "Error");
                failed = true;
            }
			OKbutton.Enabled = true;
			Cancelbutton.Enabled = true;
            parent.nPrStatus = MainForm.cnsNoneAttached;
            parent.lModemID = 0;
//			parent.fModemID.SetValue(-1, m_iModemInd, 1);
		}

		private string GetSelectedProtocol(int index)
		{
			string retval = "";

			switch (index)
			{
				case 0 : retval = "LPS0";
					break;
				case 1 : retval = "DID0";
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

		private void OKbutton_Click(object sender, System.EventArgs e)
		{
			m_bLogEnabled = EnableLogCB.Checked;
            failed = true;
			int index = ChannelList.SelectedIndex;
			string protocol;

			if (index == -1)
			{
				ChannelList.SelectedIndex = 0;
				index = 0;
			}
			if (index != -1)
			{
				parent.lModemID = parent.axVoiceOCX1.CreateModemObject(5);//5 == NMS
				if (parent.lModemID != 0)
				{
                    parent.nPrStatus = MainForm.cnsSelectNMS;
						//Set selected protocol
						protocol = (string)ProtocolCB.SelectedItem;
						parent.axVoiceOCX1.SetNMSProtocol(protocol);
						//Set specified DID/DNIS digits
						parent.axVoiceOCX1.SetDIDDigitNumber(parent.lModemID, Convert.ToInt16(DNISTB.Text, 10));

						if (parent.axVoiceOCX1.OpenPort(parent.lModemID, (string)ChannelList.SelectedItem) == 0)
						{
							OKbutton.Enabled = false;
							Cancelbutton.Enabled = false;
						}
						else
							MessageBox.Show("Cannot open channel: " + (string)ChannelList.SelectedItem, "Error");
				}
			}

		}

		private void NMSOpen_Load(object sender, System.EventArgs e)
		{
			int nBoards;
			string szChannel, bcStr;
			
			parent.lModemID = 0;
			nBoards = parent.axVoiceOCX1.GetNMSBoardNum();
			for (int i = 0; i <= nBoards; ++i)
				for (int j = 0; j < parent.axVoiceOCX1.GetNMSChannelNum((short)i); ++j)
					if (parent.axVoiceOCX1.IsNMSChannelFree((short)i, (short)j))
					{
						szChannel = "NMS_B";
						bcStr = Convert.ToString(i);
						bcStr = bcStr.Substring(bcStr.Length - 1);
						szChannel += bcStr + "CH";
						bcStr = Convert.ToString(j);
						bcStr = bcStr.Substring(bcStr.Length - 1);
						szChannel += bcStr;
						ChannelList.Items.Add(szChannel);
					}
		    ProtocolCB.Items.Insert(0, "Analog Loop Start (LPS0)");
		    ProtocolCB.Items.Insert(1, "Digital/Analog Wink Start (inbound only) (DID0)");
		    ProtocolCB.Items.Insert(2, "Digital/Analog Wink Start (outbound only) (OGT0)");
		    ProtocolCB.Items.Insert(3, "Digital/Analog Wink Start (WNK0)");
		    ProtocolCB.Items.Insert(4, "Analog Wink Start (WNK1)");
		    ProtocolCB.Items.Insert(5, "Digital Loop Start OPS-FX (LPS8)");
		    ProtocolCB.Items.Insert(6, "Feature Group D (inbound only) (FDI0)");
		    ProtocolCB.Items.Insert(7, "Digital Loop Start OPS-SA (LPS9)");
		    ProtocolCB.Items.Insert(8, "Digital Ground Start OPS-FX (GST8)");
		    ProtocolCB.Items.Insert(9, "Digital Ground Start OPS-SA (GST9)");
		    ProtocolCB.Items.Insert(10, "ISDN protocol (ISD0)");
            ProtocolCB.Items.Insert(11, "MFC R2 protocol (MFC0)");
			ProtocolCB.SelectedIndex = 0;
		}

		public bool GetLogEnabled()
		{
			return m_bLogEnabled;
		}
	}
}