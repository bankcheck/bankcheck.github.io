using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace FaxcppDemo
{
	/// <summary>
	/// Summary description for BicomOpen.
	/// </summary>
	public class DialogicOpen : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Button OK_button;
		private System.Windows.Forms.Button Cancel_button;
		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.ListBox Channel_listBox;
		public Form1 parent;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

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
			this.OK_button = new System.Windows.Forms.Button();
			this.Cancel_button = new System.Windows.Forms.Button();
			this.groupBox1 = new System.Windows.Forms.GroupBox();
			this.Channel_listBox = new System.Windows.Forms.ListBox();
			this.groupBox1.SuspendLayout();
			this.SuspendLayout();
			// 
			// OK_button
			// 
			this.OK_button.Location = new System.Drawing.Point(192, 56);
			this.OK_button.Name = "OK_button";
			this.OK_button.TabIndex = 1;
			this.OK_button.Text = "&OK";
			this.OK_button.Click += new System.EventHandler(this.OK_button_Click);
			// 
			// Cancel_button
			// 
			this.Cancel_button.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.Cancel_button.Location = new System.Drawing.Point(192, 88);
			this.Cancel_button.Name = "Cancel_button";
			this.Cancel_button.TabIndex = 2;
			this.Cancel_button.Text = "&Cancel";
			this.Cancel_button.Click += new System.EventHandler(this.button2_Click);
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.Channel_listBox);
			this.groupBox1.Location = new System.Drawing.Point(8, 8);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(168, 144);
			this.groupBox1.TabIndex = 2;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "Available Dialogic Channels";
			// 
			// Channel_listBox
			// 
			this.Channel_listBox.Location = new System.Drawing.Point(8, 16);
			this.Channel_listBox.Name = "Channel_listBox";
			this.Channel_listBox.Size = new System.Drawing.Size(152, 121);
			this.Channel_listBox.TabIndex = 0;
			// 
			// DialogicOpen
			// 
			this.AcceptButton = this.OK_button;
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.CancelButton = this.Cancel_button;
			this.ClientSize = new System.Drawing.Size(274, 159);
			this.Controls.Add(this.groupBox1);
			this.Controls.Add(this.Cancel_button);
			this.Controls.Add(this.OK_button);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "DialogicOpen";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Open Dialogic Channel";
			this.Load += new System.EventHandler(this.DialogicOpen_Load);
			this.groupBox1.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		private void button2_Click(object sender, System.EventArgs e)
		{
			Close();
		}

		private void DialogicOpen_Load(object sender, System.EventArgs e)
		{
			string szString1, szString2 = null;
			bool flag;
			int j;

			szString1 = parent.axFAX1.AvailableDialogicChannels;
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
		}

		private void OK_button_Click(object sender, System.EventArgs e)
		{
			int errcode;

			Enabled = false;
			Cursor = Cursors.WaitCursor;

			errcode=parent.axFAX1.OpenPort((string)Channel_listBox.SelectedItem);
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
				parent.textBox1.Items.Add((string)Channel_listBox.SelectedItem + " was opened");
			}

			if (parent.axFAX1.AvailableDialogicChannels.Length > 0)
				parent.SetDialogicMenu(true);
			else
				parent.SetDialogicMenu(false);

			Enabled = true;
			Cursor = Cursors.Default;
			Close();
		}
	}
}
