using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace VoiceOCXDemo
{
	/// <summary>
	/// Summary description for AboutForm.
	/// </summary>
	public class AboutForm : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Button close_button;
		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.PictureBox pictureBox1;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.Label label5;
		private System.Windows.Forms.Label label6;
		private System.Windows.Forms.LinkLabel linkLabel1;
		private System.Windows.Forms.LinkLabel linkLabel2;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public AboutForm()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			this.linkLabel2.Links[0].LinkData = "http://www.blackice.com";
			this.linkLabel2.Links.Add(24, 9, "http://www.blackice.com");

			this.linkLabel1.Links[0].LinkData = "mailto:sales@blackice.com";
			this.linkLabel1.Links.Add(26, 9, "mailto:sales@blackice.com");

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
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(AboutForm));
			this.close_button = new System.Windows.Forms.Button();
			this.groupBox1 = new System.Windows.Forms.GroupBox();
			this.label5 = new System.Windows.Forms.Label();
			this.label4 = new System.Windows.Forms.Label();
			this.label3 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.pictureBox1 = new System.Windows.Forms.PictureBox();
			this.label1 = new System.Windows.Forms.Label();
			this.label6 = new System.Windows.Forms.Label();
			this.linkLabel1 = new System.Windows.Forms.LinkLabel();
			this.linkLabel2 = new System.Windows.Forms.LinkLabel();
			this.groupBox1.SuspendLayout();
			this.SuspendLayout();
			// 
			// close_button
			// 
			this.close_button.Location = new System.Drawing.Point(97, 221);
			this.close_button.Name = "close_button";
			this.close_button.Size = new System.Drawing.Size(72, 24);
			this.close_button.TabIndex = 0;
			this.close_button.Text = "&OK";
			this.close_button.Click += new System.EventHandler(this.close_button_Click);
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.linkLabel2);
			this.groupBox1.Controls.Add(this.linkLabel1);
			this.groupBox1.Controls.Add(this.label5);
			this.groupBox1.Controls.Add(this.label4);
			this.groupBox1.Controls.Add(this.label3);
			this.groupBox1.Controls.Add(this.label2);
			this.groupBox1.Location = new System.Drawing.Point(9, 95);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(248, 112);
			this.groupBox1.TabIndex = 1;
			this.groupBox1.TabStop = false;
			this.groupBox1.Enter += new System.EventHandler(this.groupBox1_Enter);
			// 
			// label5
			// 
			this.label5.Location = new System.Drawing.Point(32, 88);
			this.label5.Name = "label5";
			this.label5.Size = new System.Drawing.Size(56, 16);
			this.label5.TabIndex = 3;
			this.label5.Text = "Web site:";
			this.label5.TextAlign = System.Drawing.ContentAlignment.TopRight;
			this.label5.Click += new System.EventHandler(this.label5_Click);
			// 
			// label4
			// 
			this.label4.Location = new System.Drawing.Point(32, 64);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(56, 16);
			this.label4.TabIndex = 2;
			this.label4.Text = "E-mail:";
			this.label4.TextAlign = System.Drawing.ContentAlignment.TopRight;
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(64, 40);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(112, 16);
			this.label3.TabIndex = 1;
			this.label3.Text = "FAX: (603)882-1344";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(72, 16);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(104, 16);
			this.label2.TabIndex = 0;
			this.label2.Text = "Tel.: (603)882-7711";
			// 
			// pictureBox1
			// 
			this.pictureBox1.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox1.Image")));
			this.pictureBox1.Location = new System.Drawing.Point(117, 31);
			this.pictureBox1.Name = "pictureBox1";
			this.pictureBox1.Size = new System.Drawing.Size(32, 32);
			this.pictureBox1.TabIndex = 2;
			this.pictureBox1.TabStop = false;
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(17, 71);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(240, 16);
			this.label1.TabIndex = 0;
			this.label1.Text = "CopyRight Black Ice Software Inc., 1989-2004";
			// 
			// label6
			// 
			this.label6.Location = new System.Drawing.Point(57, 7);
			this.label6.Name = "label6";
			this.label6.Size = new System.Drawing.Size(160, 23);
			this.label6.TabIndex = 3;
			this.label6.Text = "C# .NET Voice Sample";
			this.label6.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			// 
			// linkLabel1
			// 
			this.linkLabel1.LinkArea = new System.Windows.Forms.LinkArea(0, 25);
			this.linkLabel1.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
			this.linkLabel1.Location = new System.Drawing.Point(88, 64);
			this.linkLabel1.Name = "linkLabel1";
			this.linkLabel1.Size = new System.Drawing.Size(128, 16);
			this.linkLabel1.TabIndex = 4;
			this.linkLabel1.TabStop = true;
			this.linkLabel1.Text = "sales@blackice.com";
			this.linkLabel1.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLabel1_LinkClicked);
			// 
			// linkLabel2
			// 
			this.linkLabel2.LinkArea = new System.Windows.Forms.LinkArea(0, 23);
			this.linkLabel2.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
			this.linkLabel2.Location = new System.Drawing.Point(88, 88);
			this.linkLabel2.Name = "linkLabel2";
			this.linkLabel2.Size = new System.Drawing.Size(128, 16);
			this.linkLabel2.TabIndex = 5;
			this.linkLabel2.TabStop = true;
			this.linkLabel2.Text = "http://www.blackice.com";
			this.linkLabel2.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLabel2_LinkClicked);
			// 
			// AboutForm
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(264, 255);
			this.Controls.Add(this.label6);
			this.Controls.Add(this.pictureBox1);
			this.Controls.Add(this.groupBox1);
			this.Controls.Add(this.close_button);
			this.Controls.Add(this.label1);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "AboutForm";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "About...";
			this.groupBox1.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		private void close_button_Click(object sender, System.EventArgs e)
		{
			Close();
		}

		private void groupBox1_Enter(object sender, System.EventArgs e)
		{
		
		}

		private void label5_Click(object sender, System.EventArgs e)
		{
		
		}

		private void linkLabel1_LinkClicked(object sender, System.Windows.Forms.LinkLabelLinkClickedEventArgs e)
		{
			// Determine which link was clicked within the LinkLabel.
			this.linkLabel1.Links[linkLabel1.Links.IndexOf(e.Link)].Visited = true;

			// Display the appropriate link based on the value of the 
			// LinkData property of the Link object.
			string target = e.Link.LinkData as string;

			// If the value looks like a URL, navigate to it.
			// Otherwise, display it in a message box.
			if(null != target)
			{
				System.Diagnostics.Process.Start(target);
			}
			else
			{    
				MessageBox.Show("Opening was not successfull: " + target);
			}
		}

		private void linkLabel2_LinkClicked(object sender, System.Windows.Forms.LinkLabelLinkClickedEventArgs e)
		{
			// Determine which link was clicked within the LinkLabel.
			this.linkLabel2.Links[linkLabel2.Links.IndexOf(e.Link)].Visited = true;

			// Display the appropriate link based on the value of the 
			// LinkData property of the Link object.
			string target = e.Link.LinkData as string;

			// If the value looks like a URL, navigate to it.
			// Otherwise, display it in a message box.
			if(null != target)
			{
				System.Diagnostics.Process.Start(target);
			}
			else
			{    
				MessageBox.Show("Opening was not successfull: " + target);
			}
		
		}
	}
}
