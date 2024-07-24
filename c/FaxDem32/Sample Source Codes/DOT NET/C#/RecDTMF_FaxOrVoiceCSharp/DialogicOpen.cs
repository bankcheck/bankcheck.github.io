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
	public class DialogicOpen : System.Windows.Forms.Form
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;
		private System.Windows.Forms.Button OKbutton;
		private System.Windows.Forms.Button Cancelbutton;
		private System.Windows.Forms.ListBox ChannelList;
		private System.Windows.Forms.ComboBox LineTypeCB;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.TextBox ProtocolTB;
		public MainForm parent;
        private bool failed;

		public DialogicOpen()
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(DialogicOpen));
            this.OKbutton = new System.Windows.Forms.Button();
            this.Cancelbutton = new System.Windows.Forms.Button();
            this.ChannelList = new System.Windows.Forms.ListBox();
            this.LineTypeCB = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.ProtocolTB = new System.Windows.Forms.TextBox();
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
            // LineTypeCB
            // 
            this.LineTypeCB.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.LineTypeCB.Items.AddRange(new object[] {
            "Analog",
            "ISDN PRI",
            "T1",
            "E1"});
            this.LineTypeCB.Location = new System.Drawing.Point(72, 166);
            this.LineTypeCB.Name = "LineTypeCB";
            this.LineTypeCB.Size = new System.Drawing.Size(121, 21);
            this.LineTypeCB.TabIndex = 3;
            this.LineTypeCB.SelectedIndexChanged += new System.EventHandler(this.LineTypeCB_SelectedIndexChanged);
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(8, 168);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(64, 16);
            this.label1.TabIndex = 4;
            this.label1.Text = "Line Type:";
            // 
            // label2
            // 
            this.label2.Location = new System.Drawing.Point(8, 208);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(56, 16);
            this.label2.TabIndex = 5;
            this.label2.Text = "Protocol:";
            // 
            // ProtocolTB
            // 
            this.ProtocolTB.Location = new System.Drawing.Point(72, 206);
            this.ProtocolTB.Name = "ProtocolTB";
            this.ProtocolTB.Size = new System.Drawing.Size(152, 20);
            this.ProtocolTB.TabIndex = 6;
            // 
            // DialogicOpen
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
            this.ClientSize = new System.Drawing.Size(378, 239);
            this.Controls.Add(this.ProtocolTB);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.LineTypeCB);
            this.Controls.Add(this.ChannelList);
            this.Controls.Add(this.Cancelbutton);
            this.Controls.Add(this.OKbutton);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "DialogicOpen";
            this.Text = "Open Dialogic Channel";
            this.Load += new System.EventHandler(this.DialogicOpen_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

		}
		#endregion


		private void Cancelbutton_Click(object sender, System.EventArgs e)
		{
			Close();
		}

		private void DialogicOpen_Load(object sender, System.EventArgs e)
		{
			int nBoards;
			string szChannel, bcStr;

            parent.lModemID = 0;
			nBoards = parent.axVoiceOCX1.GetDialogicBoardNum();
			for (int i = 1; i <= nBoards; ++i)
				for (int j = 1; j <= parent.axVoiceOCX1.GetDialogicChannelNum((short)i); ++j)
					if (parent.axVoiceOCX1.IsDialogicChannelFree((short)i, (short)j))
					{
						szChannel = "dxxxB";
						bcStr = Convert.ToString(i);
						bcStr = bcStr.Substring(bcStr.Length - 1);
						szChannel += bcStr + "C";
						bcStr = Convert.ToString(j);
						bcStr = bcStr.Substring(bcStr.Length - 1);
						szChannel += bcStr;
						ChannelList.Items.Add(szChannel);
					}
			LineTypeCB.SelectedIndex = 0;
			ProtocolTB.Enabled = false;
		}

		private void OKbutton_Click(object sender, System.EventArgs e)
		{
			int index = -1;
            failed = false;

			for (int i = 0; i < ChannelList.Items.Count; ++i)
				if (ChannelList.GetSelected(i))
				{
					index = i;
					break;
				}

			if (index != -1)
			{
				parent.lModemID = parent.axVoiceOCX1.CreateModemObject(2);//2 == dialogic
				if (parent.lModemID != 0)
				{
                    parent.nPrStatus = MainForm.cnsSelectDlg;
						if (LineTypeCB.SelectedIndex == 0)//analog
							parent.axVoiceOCX1.SetDialogicLineType(parent.lModemID, 3);
						else if (LineTypeCB.SelectedIndex == 1)//ISDN PRI
							parent.axVoiceOCX1.SetDialogicLineType(parent.lModemID, 2);
						else if ((LineTypeCB.SelectedIndex == 2)||(LineTypeCB.SelectedIndex == 3))//E1/T1
						{
							parent.axVoiceOCX1.SetDialogicLineType(parent.lModemID, 1);
							parent.axVoiceOCX1.SetDialogicProtocol(parent.lModemID, ProtocolTB.Text);
						}
					if (parent.axVoiceOCX1.OpenPort(parent.lModemID, (string)ChannelList.SelectedItem) == 0)
					{
						OKbutton.Enabled = false;
						Cancelbutton.Enabled = false;
					}
					else
						MessageBox.Show("Cannot open channel: " + (string)ChannelList.SelectedItem);
				}
			}
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
		}

		private void LineTypeCB_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			if (LineTypeCB.SelectedIndex > 1)
				ProtocolTB.Enabled = true;
			else
				ProtocolTB.Enabled = false;
		}
	}
}
