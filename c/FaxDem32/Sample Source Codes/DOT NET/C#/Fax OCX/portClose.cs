using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace FaxcppDemo
{
	/// <summary>
	/// Summary description for portClose.
	/// </summary>
	public class portClose : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Button OK_button;
		private System.Windows.Forms.Button Cancel_button;
		public Form1 parent;
		private System.Windows.Forms.ListBox PortListBox;
		private System.Windows.Forms.Label label1;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public portClose()
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
			this.PortListBox = new System.Windows.Forms.ListBox();
			this.label1 = new System.Windows.Forms.Label();
			this.SuspendLayout();
			// 
			// OK_button
			// 
			this.OK_button.Location = new System.Drawing.Point(28, 128);
			this.OK_button.Name = "OK_button";
			this.OK_button.TabIndex = 1;
			this.OK_button.Text = "OK";
			this.OK_button.Click += new System.EventHandler(this.OK_button_Click);
			// 
			// Cancel_button
			// 
			this.Cancel_button.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.Cancel_button.Location = new System.Drawing.Point(124, 128);
			this.Cancel_button.Name = "Cancel_button";
			this.Cancel_button.TabIndex = 2;
			this.Cancel_button.Text = "Cancel";
			this.Cancel_button.Click += new System.EventHandler(this.Cancel_button_Click);
			// 
			// PortListBox
			// 
			this.PortListBox.Location = new System.Drawing.Point(9, 32);
			this.PortListBox.Name = "PortListBox";
			this.PortListBox.Size = new System.Drawing.Size(208, 82);
			this.PortListBox.TabIndex = 3;
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 10);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(72, 16);
			this.label1.TabIndex = 4;
			this.label1.Text = "Fax Ports:";
			this.label1.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// portClose
			// 
			this.AcceptButton = this.OK_button;
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.CancelButton = this.Cancel_button;
			this.ClientSize = new System.Drawing.Size(226, 159);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.PortListBox);
			this.Controls.Add(this.Cancel_button);
			this.Controls.Add(this.OK_button);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "portClose";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Close Fax Port";
			this.Load += new System.EventHandler(this.portClose_Load);
			this.ResumeLayout(false);

		}
		#endregion

		private void Cancel_button_Click(object sender, System.EventArgs e)
		{
			Close();
		}

		private void portClose_Load(object sender, System.EventArgs e)
		{
			string szString1, szString2 = null;
			bool flag;
			int j,portindex,spaceindex;
			
			szString1 = parent.axFAX1.PortsOpen;
			if (szString1.Length > 0)
			{
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
					portindex=parent.PortsAndClasses.IndexOf(szString2)+szString2.Length+1;
					spaceindex=parent.PortsAndClasses.IndexOf(' ',portindex);
					szString2=szString2+':'+parent.axFAX1.GetLongName(Convert.ToInt16(parent.PortsAndClasses.Substring(portindex,spaceindex-portindex)));
					PortListBox.Items.Add(szString2);
				}
			}

			szString1 = parent.axFAX1.BrooktroutChannelsOpen;
			if (szString1.Length > 0)
			{
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
			}

			szString1 = parent.axFAX1.GammaChannelsOpen;
			if (szString1.Length > 0)
			{
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
			}

			szString1 = parent.axFAX1.DialogicChannelsOpen;
			if (szString1.Length > 0)
			{
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
			}
			szString1 = parent.axFAX1.NMSChannelsOpen;
			if (szString1.Length > 0)
			{
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
			}
			PortListBox.SetSelected(0, true);
		}

		private void OK_button_Click(object sender, System.EventArgs e)
		{
			Enabled = false;
			Cursor = Cursors.WaitCursor;
			string port=((string)PortListBox.SelectedItem);
			int index=port.IndexOf(':');
			if (index!=-1)
				port=port.Substring(0,index);
			if (parent.axFAX1.ClosePort(port) == 0)
			{
				if (index!=-1)
				{
					int portindex=parent.PortsAndClasses.IndexOf(port);
					int spaceindex=parent.PortsAndClasses.IndexOf(' ',portindex);
					parent.PortsAndClasses=parent.PortsAndClasses.Substring(0,portindex)+parent.PortsAndClasses.Substring(spaceindex+1);
				}
				if (PortListBox.Items.Count == 1)
					parent.SetMenuItems(false);
			}
			parent.textBox1.Items.Add((string)PortListBox.SelectedItem + " was closed");
			if (parent.axFAX1.AvailablePorts.Length > 0)
				parent.SetComportMenu(true);
			if (parent.axFAX1.AvailableBrooktroutChannels.Length > 0)
				parent.SetBrooktroutMenu(true);
			if (parent.axFAX1.AvailableDialogicChannels.Length > 0)
				parent.SetDialogicMenu(true);
			if (parent.axFAX1.AvailableGammaChannels.Length > 0)
				parent.SetGammaMenu(true);
			if (parent.axFAX1.AvailableNMSChannels.Length > 0)
				parent.SetNMSMenu(true);

			Enabled = true;
			Cursor = Cursors.Default;
			Close();
		}
	}		


}
