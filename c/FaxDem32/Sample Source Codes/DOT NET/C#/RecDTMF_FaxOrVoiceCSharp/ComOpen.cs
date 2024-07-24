using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace RecDTMF_FaxOrVoiceCSharp
{
	/// <summary>
	/// Summary description for ComOpen.
	/// </summary>
	public class ComOpen : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Button Openbutton;
		private System.Windows.Forms.Button Cancelbutton;
		private System.Windows.Forms.Button Testbutton;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.ComboBox PortcomboBox;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.ComboBox TypecomboBox;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.TextBox ManutextBox;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.TextBox ModeltextBox;
		private System.Windows.Forms.Label label5;
		private int m_iActualPort;
		private bool m_bAutoOpen, m_bTested, m_bTesting;
		private bool m_bModemFound;
		private bool m_bLogEnabled;
		public MainForm parent;
        private System.Windows.Forms.TextBox CaptextBox;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;
        private Button voiceFormats;

        private string szEncodingModes = "";
		
		

		public ComOpen()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			m_bTested = false;
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(ComOpen));
            this.Openbutton = new System.Windows.Forms.Button();
            this.Cancelbutton = new System.Windows.Forms.Button();
            this.Testbutton = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.PortcomboBox = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.TypecomboBox = new System.Windows.Forms.ComboBox();
            this.label3 = new System.Windows.Forms.Label();
            this.ManutextBox = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.ModeltextBox = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.CaptextBox = new System.Windows.Forms.TextBox();
            this.voiceFormats = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // Openbutton
            // 
            this.Openbutton.Location = new System.Drawing.Point(288, 24);
            this.Openbutton.Name = "Openbutton";
            this.Openbutton.Size = new System.Drawing.Size(75, 23);
            this.Openbutton.TabIndex = 0;
            this.Openbutton.Text = "&Open Port";
            this.Openbutton.Click += new System.EventHandler(this.Openbutton_Click);
            // 
            // Cancelbutton
            // 
            this.Cancelbutton.Location = new System.Drawing.Point(288, 64);
            this.Cancelbutton.Name = "Cancelbutton";
            this.Cancelbutton.Size = new System.Drawing.Size(75, 23);
            this.Cancelbutton.TabIndex = 1;
            this.Cancelbutton.Text = "&Cancel";
            this.Cancelbutton.Click += new System.EventHandler(this.Cancelbutton_Click);
            // 
            // Testbutton
            // 
            this.Testbutton.Location = new System.Drawing.Point(288, 104);
            this.Testbutton.Name = "Testbutton";
            this.Testbutton.Size = new System.Drawing.Size(75, 23);
            this.Testbutton.TabIndex = 2;
            this.Testbutton.Text = "&Test";
            this.Testbutton.Click += new System.EventHandler(this.Testbutton_Click);
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(8, 8);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(96, 16);
            this.label1.TabIndex = 3;
            this.label1.Text = "Serial Port to Use:";
            // 
            // PortcomboBox
            // 
            this.PortcomboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.PortcomboBox.Location = new System.Drawing.Point(8, 32);
            this.PortcomboBox.Name = "PortcomboBox";
            this.PortcomboBox.Size = new System.Drawing.Size(88, 21);
            this.PortcomboBox.TabIndex = 4;
            this.PortcomboBox.MouseUp += new System.Windows.Forms.MouseEventHandler(this.PortcomboBox_MouseUp);
            // 
            // label2
            // 
            this.label2.Location = new System.Drawing.Point(8, 72);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(80, 16);
            this.label2.TabIndex = 5;
            this.label2.Text = "Modem Type:";
            // 
            // TypecomboBox
            // 
            this.TypecomboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.TypecomboBox.Items.AddRange(new object[] {
            "Auto detect modem type",
            "Rockwell chipset based modem",
            "USRobotics Sportster",
            "Lucent chipset based modem",
            "Cirrus Logic chipset based modem",
            "Rockwell/Conexant HCF chipset based modem"});
            this.TypecomboBox.Location = new System.Drawing.Point(8, 96);
            this.TypecomboBox.Name = "TypecomboBox";
            this.TypecomboBox.Size = new System.Drawing.Size(256, 21);
            this.TypecomboBox.TabIndex = 6;
            this.TypecomboBox.TextChanged += new System.EventHandler(this.TypecomboBox_TextChanged);
            // 
            // label3
            // 
            this.label3.Location = new System.Drawing.Point(8, 136);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(80, 16);
            this.label3.TabIndex = 7;
            this.label3.Text = "Manufacturer:";
            // 
            // ManutextBox
            // 
            this.ManutextBox.Location = new System.Drawing.Point(8, 160);
            this.ManutextBox.Name = "ManutextBox";
            this.ManutextBox.ReadOnly = true;
            this.ManutextBox.Size = new System.Drawing.Size(256, 20);
            this.ManutextBox.TabIndex = 8;
            // 
            // label4
            // 
            this.label4.Location = new System.Drawing.Point(8, 200);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(40, 16);
            this.label4.TabIndex = 9;
            this.label4.Text = "Model:";
            // 
            // ModeltextBox
            // 
            this.ModeltextBox.Location = new System.Drawing.Point(8, 224);
            this.ModeltextBox.Name = "ModeltextBox";
            this.ModeltextBox.ReadOnly = true;
            this.ModeltextBox.Size = new System.Drawing.Size(256, 20);
            this.ModeltextBox.TabIndex = 10;
            // 
            // label5
            // 
            this.label5.Location = new System.Drawing.Point(8, 264);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(112, 16);
            this.label5.TabIndex = 11;
            this.label5.Text = "Modem Capabilities:";
            // 
            // CaptextBox
            // 
            this.CaptextBox.Location = new System.Drawing.Point(8, 288);
            this.CaptextBox.Name = "CaptextBox";
            this.CaptextBox.ReadOnly = true;
            this.CaptextBox.Size = new System.Drawing.Size(256, 20);
            this.CaptextBox.TabIndex = 12;
            // 
            // voiceFormats
            // 
            this.voiceFormats.Location = new System.Drawing.Point(286, 193);
            this.voiceFormats.Name = "voiceFormats";
            this.voiceFormats.Size = new System.Drawing.Size(82, 23);
            this.voiceFormats.TabIndex = 14;
            this.voiceFormats.Text = "Voice Formats";
            this.voiceFormats.UseVisualStyleBackColor = true;
            this.voiceFormats.Click += new System.EventHandler(this.voiceFormats_Click);
            // 
            // ComOpen
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
            this.ClientSize = new System.Drawing.Size(370, 319);
            this.Controls.Add(this.voiceFormats);
            this.Controls.Add(this.CaptextBox);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.ModeltextBox);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.ManutextBox);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.TypecomboBox);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.PortcomboBox);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.Testbutton);
            this.Controls.Add(this.Cancelbutton);
            this.Controls.Add(this.Openbutton);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "ComOpen";
            this.Text = "Select Port/Modem";
            this.TextChanged += new System.EventHandler(this.TypecomboBox_TextChanged);
            this.Load += new System.EventHandler(this.ComOpen_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

		}
		#endregion

		private void Cancelbutton_Click(object sender, System.EventArgs e)
		{
            parent.nPrStatus = MainForm.cnsNoneAttached;
            Enabled = false;
			Cursor = Cursors.WaitCursor;
			DestroyModem();
            parent.closeButton.Enabled = false;
			Enabled = true;
			Cursor = Cursors.Default;
			Close();
		}

		private void ComOpen_Load(object sender, System.EventArgs e)
		{
			string szString1, szString2 = null;
			bool flag;
			int j;

			m_bModemFound=false;
            parent.lModemID = 0;
			m_bTested = false;
			//retrieves the name of the COM ports available on the system
			szString1 = parent.axVoiceOCX1.AvailablePorts();
			if (szString1.Length > 0)
			{
				flag = true;
				//the COM port names are separated by spaces. We have to parse them...
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
					//fill up the combo box with COM port names
					PortcomboBox.Items.Add(szString2);
				}
				//if there is at least 1 COM port in the list select the first one.
				if (PortcomboBox.Items.Count > 0)
				{
					PortcomboBox.SelectedIndex = 0;
					Openbutton.Enabled = true;
					Testbutton.Enabled = true;
				}
				else
				{
					//there are no COM ports available, disable buttons
					PortcomboBox.Enabled = false;
					Testbutton.Enabled = false;
				}
				if (TypecomboBox.Items.Count > 0)
					TypecomboBox.SelectedIndex = 0;
			}
		}
		//Destroys the current modem object
        private void DestroyModem()
		{
			if (parent.lModemID != 0)
			{
				//close the port
				parent.axVoiceOCX1.ClosePort(parent.lModemID);
				//destroy the modem object
				parent.axVoiceOCX1.DestroyModemObject(parent.lModemID);
				parent.lModemID = 0;
			}
			Testbutton.Enabled = true;
			Openbutton.Enabled = true;

        }
		//This method is called when the user click on the Test button
        private void Testbutton_Click(object sender, System.EventArgs e)
		{
			//get the selected modem type
			int index = TypecomboBox.SelectedIndex;
			string szPort;

			m_bModemFound=false;
			m_bTesting = true;
			ManutextBox.Clear();
			ModeltextBox.Clear();
			CaptextBox.Clear();

			//index holds the modem type.If it is 0 then the modem type is auto detect.
			//if index is not zero then it should hold one of the following values:
			//Rockwell = 1
			//USRobotics = 2
			//Lucent = 7
			//Cirrus = 8
			//HCF = 9
			//if the selected item in the modem type list is 3,4,5 then we have to change
			// the modem type to 7,8,9 because Voice C++ uses the values for Brooktrout
			// NM and Dialogic. 

			switch (index)
			{
				case 3 : index = 7;
					break;
				case 4 : index = 8;
					break;
				case 5 : index = 9;
					break;
			}
			//modem type is auto detect
			if (index == 0)
			{
				index = 9;
				m_bAutoOpen = true;
				m_iActualPort = 8;
			}
			else
			{
				m_bAutoOpen = false;
				m_iActualPort = index - 1;
			}
			//create a modem object of the requested type
			parent.lModemID = parent.axVoiceOCX1.CreateModemObject((short)(index - 1));
			m_bTested = true;
			if (parent.lModemID != 0)
			{
				//modem object created
				szPort = PortcomboBox.Text;
                parent.nPrStatus = MainForm.cnsSelectPort;
				if (index > 0)
				{
					//open the port
					if (parent.axVoiceOCX1.OpenPort(parent.lModemID, szPort) == 0)
					{
						//open port process started
						//wait for the ModemError or PortOpen events
						Testbutton.Enabled = false;
						Cancelbutton.Enabled = false;
					}
					else
					{
						//port cannot be opened
						DestroyModem();
						MessageBox.Show("Couldn't open modem port!" , "Error");
                        parent.nPrStatus = MainForm.cnsNoneAttached;
					}
				}
			}
			else
				MessageBox.Show("Couldn't create modem object!", "Error");
			Testbutton.Enabled = false;

        }
        public void VOICEOCX_PortOpen(object sender, AxVOICEOCXLib._DVoiceOCXEvents_PortOpenEvent e)
		{
			//port has been opened successfully
			//start testing the modem, wait for ModemOK
			if( parent.axVoiceOCX1.TestVoiceModem(parent.lModemID) != 0 )
			{
				MessageBox.Show("Modem test failed!", "Error");
                parent.nPrStatus = MainForm.cnsNoneAttached;
				DestroyModem();
			}
		}
		//modem testing was successfull
		public void VOICEOCX_ModemOK(object sender, AxVOICEOCXLib._DVoiceOCXEvents_ModemOKEvent e)
		{
                        			string szManufacturer="";
                                    string szModel="";
                                    string szModes="";
                                    string Caps="";
                                    int nIndex=0;
                                    bool bStarted=false;

                                    //get test results and update dialog box
                                    parent.axVoiceOCX1.GetTestResultExt(parent.lModemID, ref szManufacturer, ref szModel, ref szModes, ref szEncodingModes);

                                    ManutextBox.Text = szManufacturer;
                                    ModeltextBox.Text = szModel;
                                    for( nIndex = 0 ; nIndex<5; ++nIndex)
                                    {
                                        if( szModes[nIndex]=='1')
                                        {
                                            if( bStarted )
                                                Caps = Caps + "/";
					
                                            Caps = Caps + parent.szVoiceCaps.GetValue(nIndex);
                                            bStarted = true;
                                        }
                                    }
                                    CaptextBox.Text = Caps;

                                    Testbutton.Enabled = false;
                                    Openbutton.Enabled = true;
                                    Cancelbutton.Enabled = true;

                                    m_bModemFound=true;

                                    if( m_iActualPort == 0 )
                                        TypecomboBox.SelectedIndex = 1;
                                    else
                                    {
                                        if(m_iActualPort == 1)
                                            TypecomboBox.SelectedIndex = 2;
                                        else
                                            if(m_iActualPort == 6 )
                                            TypecomboBox.SelectedIndex = 3;
                                        else
                                            if(m_iActualPort == 7)
                                            TypecomboBox.SelectedIndex = 4;
                                        else
                                            if(m_iActualPort == 8)
                                            TypecomboBox.SelectedIndex = 5;
                                    }
                                    //m_bTested = true;
                                    if( !m_bTesting )
                                        Close(); 
                                }
                    //port cannot be openedor other error happened
        public void VOICEOCX_ModemError(object sender, AxVOICEOCXLib._DVoiceOCXEvents_ModemErrorEvent e)
                    {
            			string szPort;
                        //the current modem type is not correct
                        //we have to try the nex modem type
                        if(m_bAutoOpen  && (m_iActualPort!=7))
                        {
                            //destroy the current modem object
                            DestroyModem();
                            //select the next modem type
                            if( m_iActualPort == 1 )
                                m_iActualPort = 6;
                            else
                            {
                                if (m_iActualPort == 8)
                                    m_iActualPort = 0;
                                else
                                    m_iActualPort = m_iActualPort + 1;
                            }
                            //create the next modem object	
                            parent.lModemID = parent.axVoiceOCX1.CreateModemObject((short)m_iActualPort);
                            m_bTested = true;
                            if( parent.lModemID != 0 )
                            {
                                szPort = PortcomboBox.Text;
                                //try to open the port
                                    if( parent.axVoiceOCX1.OpenPort(parent.lModemID, szPort) == 0)
                                    {
                                        Testbutton.Enabled = false;
                                        Cancelbutton.Enabled = false;
    
                                    }
                                    else
                                    {
                                        MessageBox.Show("Couldn't open modem port!", "Error");
                                        parent.nPrStatus = MainForm.cnsNoneAttached;
                                        DestroyModem();
                                    }
              //                  }
                            }
                            else
                                MessageBox.Show("Couldn't create modem object!", "Error");
		
                            Testbutton.Enabled = false;
                            Openbutton.Enabled = false;				
                        }
                        else
                        {
                            Testbutton.Enabled = true;
                            Openbutton.Enabled = true;
                            Cancelbutton.Enabled = true;

                            MessageBox.Show("Modem ERROR message received", "Error");
                            m_bTested = false;

                            DestroyModem();
                        }
            
        }
		//open button was clicked
		private void Openbutton_Click(object sender, System.EventArgs e)
		{
			string szPort;
			int nIndex = 0;
			
			ManutextBox.Clear();
			ModeltextBox.Clear();
			CaptextBox.Clear();
			
			m_bModemFound=false;
			m_bTesting = false;

            if (!m_bTested)
            {
                nIndex = TypecomboBox.SelectedIndex;

                if (nIndex == 3)
                    nIndex = 7;

                if (nIndex == 4)
                    nIndex = 8;

                if (nIndex == 5)
                    nIndex = 9;

                if (nIndex == 0)
                {
                    m_iActualPort = 8;
                    nIndex = 9;
                    m_bAutoOpen = true;
                }
                else
                {
                    m_bAutoOpen = false;
                    m_iActualPort = nIndex - 1;
                }

                parent.lModemID = parent.axVoiceOCX1.CreateModemObject((short)(nIndex - 1));
                if (parent.lModemID != 0)
                {
                    szPort = PortcomboBox.Text;
                    parent.nPrStatus = MainForm.cnsSelectPort;
                    if (nIndex > 0)
                    {
                        if (parent.axVoiceOCX1.OpenPort(parent.lModemID, szPort) == 0)
                        {
                            Testbutton.Enabled = false;
                            Cancelbutton.Enabled = false;
                        }
                        else
                        {
                            MessageBox.Show("Couldn't open modem port!", "Error");
                            parent.nPrStatus = MainForm.cnsNoneAttached;
                            DestroyModem();
                        }
                    }
                }
                else
                    MessageBox.Show("Couldn't create modem object!", "Error");
            }
			Testbutton.Enabled = false;
			Openbutton.Enabled = false;

    		m_bLogEnabled = true;

			//if the port was already tested, then the port is open and we can close this dialog box
			if(m_bTested)
				Close();

        }

		private void TypecomboBox_TextChanged(object sender, System.EventArgs e)
		{
			if(!m_bModemFound)
			{
				m_bTested = false;
				DestroyModem();
			}
		}


		public bool GetLogEnabled()
		{
			return m_bLogEnabled;
		}

		private void PortcomboBox_MouseUp(object sender, System.Windows.Forms.MouseEventArgs e)
		{
			m_bTested = false;
			DestroyModem();
		}

        private void voiceFormats_Click(object sender, EventArgs e)
        {
            if (szEncodingModes != "")
                MessageBox.Show(szEncodingModes);
            else
                MessageBox.Show("No opened modem!");
        }
	}
}
