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
	/// Summary description for commport.
	/// </summary>
	public class ComPort : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Button OK_button;
		private System.Windows.Forms.Button Cancel_button;
		public Form1 parent;
		private System.Windows.Forms.ListBox port_listBox;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;
		
		public ComPort()
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
			this.port_listBox = new System.Windows.Forms.ListBox();
			this.SuspendLayout();
			// 
			// OK_button
			// 
			this.OK_button.Location = new System.Drawing.Point(136, 16);
			this.OK_button.Name = "OK_button";
			this.OK_button.Size = new System.Drawing.Size(80, 24);
			this.OK_button.TabIndex = 1;
			this.OK_button.Text = "&OK";
			this.OK_button.Click += new System.EventHandler(this.OK_button_Click);
			// 
			// Cancel_button
			// 
			this.Cancel_button.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.Cancel_button.Location = new System.Drawing.Point(136, 56);
			this.Cancel_button.Name = "Cancel_button";
			this.Cancel_button.Size = new System.Drawing.Size(80, 24);
			this.Cancel_button.TabIndex = 2;
			this.Cancel_button.Text = "&Cancel";
			this.Cancel_button.Click += new System.EventHandler(this.Cancel_button_Click);
			// 
			// port_listBox
			// 
			this.port_listBox.Location = new System.Drawing.Point(8, 8);
			this.port_listBox.Name = "port_listBox";
			this.port_listBox.Size = new System.Drawing.Size(120, 82);
			this.port_listBox.TabIndex = 0;
			// 
			// ComPort
			// 
			this.AcceptButton = this.OK_button;
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.CancelButton = this.Cancel_button;
			this.ClientSize = new System.Drawing.Size(226, 95);
			this.Controls.Add(this.port_listBox);
			this.Controls.Add(this.Cancel_button);
			this.Controls.Add(this.OK_button);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "ComPort";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Open Com Port";
			this.Load += new System.EventHandler(this.ComPort_Load);
			this.ResumeLayout(false);

		}
		#endregion

		private void Cancel_button_Click(object sender, System.EventArgs e)
		{
			this.Close();
		}

		private void OK_button_Click(object sender, System.EventArgs e)
		{
			this.Cursor = Cursors.WaitCursor;
			this.Enabled = false;
			int errcode;
			parent.axFAX1.FaxType = "GCLASS1(SFC)";

			parent.axFAX1.TestModem((string)port_listBox.SelectedItem);
			if (parent.axFAX1.ClassType.Length != 0)
			{
				errcode=parent.axFAX1.OpenPort((string)port_listBox.SelectedItem);
				if (errcode != 0)
					MessageBox.Show(parent.GetError(errcode), "Error");
				else
				{
					parent.SetMenuItems(true);
					parent.textBox1.Items.Add((string)port_listBox.SelectedItem+" was opened");
					parent.axFAX1.SetPortCapability((string)port_listBox.SelectedItem, 3, 3);
					parent.axFAX1.SetPortCapability((string)port_listBox.SelectedItem, 10, 15);
				}				
			}
			else
			{
				string szText = "No modem on " + (string)port_listBox.SelectedItem + " port.";
				MessageBox.Show(szText, "Error");
				this.Cursor = Cursors.Default;
				this.Enabled = true;
				return;
			}

			if (parent.axFAX1.AvailablePorts.Length > 0)
				parent.SetComportMenu(true);
			else
				parent.SetComportMenu(false);
			this.Cursor = Cursors.Default;
			this.Enabled = true;
			this.Close();
		}

		private void ComPort_Load(object sender, System.EventArgs e)
		{
			string szString1, szString2 = null;
			bool flag;
			int j;
			
			szString1 = parent.axFAX1.AvailablePorts;
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
				port_listBox.Items.Add(szString2);
			}
			port_listBox.SetSelected(0, true);
		}
	}
}
