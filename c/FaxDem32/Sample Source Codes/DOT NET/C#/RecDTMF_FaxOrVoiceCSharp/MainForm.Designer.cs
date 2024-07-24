namespace RecDTMF_FaxOrVoiceCSharp
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
            this.axVoiceOCX1 = new AxVOICEOCXLib.AxVoiceOCX();
            this.openPort = new System.Windows.Forms.GroupBox();
            this.NMSOpen = new System.Windows.Forms.Button();
            this.brookOpen = new System.Windows.Forms.Button();
            this.dialogicOpen = new System.Windows.Forms.Button();
            this.portOpen = new System.Windows.Forms.Button();
            this.functions = new System.Windows.Forms.GroupBox();
            this.recordButton = new System.Windows.Forms.Button();
            this.DTMFButton = new System.Windows.Forms.Button();
            this.receiveButton = new System.Windows.Forms.Button();
            this.portStatus = new System.Windows.Forms.GroupBox();
            this.clearButton = new System.Windows.Forms.Button();
            this.statusBox = new System.Windows.Forms.ListBox();
            this.closeButton = new System.Windows.Forms.Button();
            this.helpButton = new System.Windows.Forms.Button();
            this.exitButton = new System.Windows.Forms.Button();
            this.HangUpbutton = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.axVoiceOCX1)).BeginInit();
            this.openPort.SuspendLayout();
            this.functions.SuspendLayout();
            this.portStatus.SuspendLayout();
            this.SuspendLayout();
            // 
            // axVoiceOCX1
            // 
            this.axVoiceOCX1.Enabled = true;
            this.axVoiceOCX1.Location = new System.Drawing.Point(4, 5);
            this.axVoiceOCX1.Name = "axVoiceOCX1";
            this.axVoiceOCX1.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("axVoiceOCX1.OcxState")));
            this.axVoiceOCX1.Size = new System.Drawing.Size(17, 17);
            this.axVoiceOCX1.TabIndex = 1;
            this.axVoiceOCX1.FaxReceived += new AxVOICEOCXLib._DVoiceOCXEvents_FaxReceivedEventHandler(this.axVoiceOCX1_FaxReceived);
            this.axVoiceOCX1.EndReceive += new AxVOICEOCXLib._DVoiceOCXEvents_EndReceiveEventHandler(this.axVoiceOCX1_EndReceive);
            this.axVoiceOCX1.VoiceRecordFinished += new AxVOICEOCXLib._DVoiceOCXEvents_VoiceRecordFinishedEventHandler(this.axVoiceOCX1_VoiceRecordFinished);
            this.axVoiceOCX1.VoiceConnect += new AxVOICEOCXLib._DVoiceOCXEvents_VoiceConnectEventHandler(this.axVoiceOCX1_VoiceConnect);
            this.axVoiceOCX1.OnHook += new AxVOICEOCXLib._DVoiceOCXEvents_OnHookEventHandler(this.axVoiceOCX1_OnHook);
            this.axVoiceOCX1.OffHookEvent += new AxVOICEOCXLib._DVoiceOCXEvents_OffHookEventHandler(this.axVoiceOCX1_OffHookEvent);
            this.axVoiceOCX1.DTMFReceived += new AxVOICEOCXLib._DVoiceOCXEvents_DTMFReceivedEventHandler(this.axVoiceOCX1_DTMFReceived);
            this.axVoiceOCX1.Ring += new AxVOICEOCXLib._DVoiceOCXEvents_RingEventHandler(this.axVoiceOCX1_Ring);
            this.axVoiceOCX1.ModemError += new AxVOICEOCXLib._DVoiceOCXEvents_ModemErrorEventHandler(this.axVoiceOCX1_ModemError);
            this.axVoiceOCX1.VoiceRecordStarted += new AxVOICEOCXLib._DVoiceOCXEvents_VoiceRecordStartedEventHandler(this.axVoiceOCX1_VoiceRecordStarted);
            this.axVoiceOCX1.PortOpen += new AxVOICEOCXLib._DVoiceOCXEvents_PortOpenEventHandler(this.axVoiceOCX1_PortOpen);
            this.axVoiceOCX1.FaxTerminated += new AxVOICEOCXLib._DVoiceOCXEvents_FaxTerminatedEventHandler(this.axVoiceOCX1_FaxTerminated);
            this.axVoiceOCX1.HangUpEvent += new AxVOICEOCXLib._DVoiceOCXEvents_HangUpEventHandler(this.axVoiceOCX1_HangUpEvent);
            this.axVoiceOCX1.DTMFDigit += new AxVOICEOCXLib._DVoiceOCXEvents_DTMFDigitEventHandler(this.axVoiceOCX1_DTMFDigit);
            this.axVoiceOCX1.ModemOK += new AxVOICEOCXLib._DVoiceOCXEvents_ModemOKEventHandler(this.axVoiceOCX1_ModemOK);
            this.axVoiceOCX1.DTMFReceivedExt2 += new AxVOICEOCXLib._DVoiceOCXEvents_DTMFReceivedExt2EventHandler(this.axVoiceOCX1_DTMFReceivedExt2);
            // 
            // openPort
            // 
            this.openPort.Controls.Add(this.NMSOpen);
            this.openPort.Controls.Add(this.brookOpen);
            this.openPort.Controls.Add(this.dialogicOpen);
            this.openPort.Controls.Add(this.portOpen);
            this.openPort.Controls.Add(this.axVoiceOCX1);
            this.openPort.Location = new System.Drawing.Point(9, 10);
            this.openPort.Name = "openPort";
            this.openPort.Size = new System.Drawing.Size(320, 91);
            this.openPort.TabIndex = 1;
            this.openPort.TabStop = false;
            this.openPort.Text = "Open port/channel";
            // 
            // NMSOpen
            // 
            this.NMSOpen.Location = new System.Drawing.Point(167, 49);
            this.NMSOpen.Name = "NMSOpen";
            this.NMSOpen.Size = new System.Drawing.Size(132, 24);
            this.NMSOpen.TabIndex = 4;
            this.NMSOpen.Text = "Open NMS channel";
            this.NMSOpen.UseVisualStyleBackColor = true;
            this.NMSOpen.Click += new System.EventHandler(this.NMSOpen_Click);
            // 
            // brookOpen
            // 
            this.brookOpen.Location = new System.Drawing.Point(16, 49);
            this.brookOpen.Name = "brookOpen";
            this.brookOpen.Size = new System.Drawing.Size(136, 24);
            this.brookOpen.TabIndex = 3;
            this.brookOpen.Text = "Open Brooktrout channel";
            this.brookOpen.UseVisualStyleBackColor = true;
            this.brookOpen.Click += new System.EventHandler(this.brookOpen_Click);
            // 
            // dialogicOpen
            // 
            this.dialogicOpen.Location = new System.Drawing.Point(165, 19);
            this.dialogicOpen.Name = "dialogicOpen";
            this.dialogicOpen.Size = new System.Drawing.Size(134, 24);
            this.dialogicOpen.TabIndex = 2;
            this.dialogicOpen.Text = "Open Dialogic channel";
            this.dialogicOpen.UseVisualStyleBackColor = true;
            this.dialogicOpen.Click += new System.EventHandler(this.dialogicOpen_Click);
            // 
            // portOpen
            // 
            this.portOpen.Location = new System.Drawing.Point(16, 19);
            this.portOpen.Name = "portOpen";
            this.portOpen.Size = new System.Drawing.Size(136, 24);
            this.portOpen.TabIndex = 1;
            this.portOpen.Text = "Open COM port";
            this.portOpen.UseVisualStyleBackColor = true;
            this.portOpen.Click += new System.EventHandler(this.portOpen_Click);
            // 
            // functions
            // 
            this.functions.Controls.Add(this.recordButton);
            this.functions.Controls.Add(this.DTMFButton);
            this.functions.Controls.Add(this.receiveButton);
            this.functions.Location = new System.Drawing.Point(9, 107);
            this.functions.Name = "functions";
            this.functions.Size = new System.Drawing.Size(320, 65);
            this.functions.TabIndex = 3;
            this.functions.TabStop = false;
            this.functions.Text = "Functions";
            // 
            // recordButton
            // 
            this.recordButton.Location = new System.Drawing.Point(219, 23);
            this.recordButton.Name = "recordButton";
            this.recordButton.Size = new System.Drawing.Size(95, 27);
            this.recordButton.TabIndex = 2;
            this.recordButton.Text = "Record message";
            this.recordButton.UseVisualStyleBackColor = true;
            this.recordButton.Click += new System.EventHandler(this.recordButton_Click);
            // 
            // DTMFButton
            // 
            this.DTMFButton.Location = new System.Drawing.Point(112, 23);
            this.DTMFButton.Name = "DTMFButton";
            this.DTMFButton.Size = new System.Drawing.Size(101, 27);
            this.DTMFButton.TabIndex = 1;
            this.DTMFButton.Text = "Wait for DTMF";
            this.DTMFButton.UseVisualStyleBackColor = true;
            this.DTMFButton.Click += new System.EventHandler(this.DTMFButton_Click);
            // 
            // receiveButton
            // 
            this.receiveButton.Location = new System.Drawing.Point(6, 23);
            this.receiveButton.Name = "receiveButton";
            this.receiveButton.Size = new System.Drawing.Size(100, 27);
            this.receiveButton.TabIndex = 0;
            this.receiveButton.Text = "Receive Fax";
            this.receiveButton.UseVisualStyleBackColor = true;
            this.receiveButton.Click += new System.EventHandler(this.receiveButton_Click);
            // 
            // portStatus
            // 
            this.portStatus.Controls.Add(this.HangUpbutton);
            this.portStatus.Controls.Add(this.clearButton);
            this.portStatus.Controls.Add(this.statusBox);
            this.portStatus.Location = new System.Drawing.Point(8, 178);
            this.portStatus.Name = "portStatus";
            this.portStatus.Size = new System.Drawing.Size(321, 145);
            this.portStatus.TabIndex = 4;
            this.portStatus.TabStop = false;
            this.portStatus.Text = "Port status";
            // 
            // clearButton
            // 
            this.clearButton.Location = new System.Drawing.Point(17, 110);
            this.clearButton.Name = "clearButton";
            this.clearButton.Size = new System.Drawing.Size(99, 28);
            this.clearButton.TabIndex = 1;
            this.clearButton.Text = "Clear";
            this.clearButton.UseVisualStyleBackColor = true;
            this.clearButton.Click += new System.EventHandler(this.clearButton_Click);
            // 
            // statusBox
            // 
            this.statusBox.FormattingEnabled = true;
            this.statusBox.Location = new System.Drawing.Point(17, 22);
            this.statusBox.Name = "statusBox";
            this.statusBox.Size = new System.Drawing.Size(283, 82);
            this.statusBox.TabIndex = 0;
            // 
            // closeButton
            // 
            this.closeButton.Location = new System.Drawing.Point(25, 329);
            this.closeButton.Name = "closeButton";
            this.closeButton.Size = new System.Drawing.Size(126, 27);
            this.closeButton.TabIndex = 5;
            this.closeButton.Text = "Close port/channel";
            this.closeButton.UseVisualStyleBackColor = true;
            this.closeButton.Click += new System.EventHandler(this.closeButton_Click);
            // 
            // helpButton
            // 
            this.helpButton.Location = new System.Drawing.Point(173, 329);
            this.helpButton.Name = "helpButton";
            this.helpButton.Size = new System.Drawing.Size(75, 27);
            this.helpButton.TabIndex = 6;
            this.helpButton.Text = "Help";
            this.helpButton.UseVisualStyleBackColor = true;
            this.helpButton.Click += new System.EventHandler(this.helpButton_Click);
            // 
            // exitButton
            // 
            this.exitButton.Location = new System.Drawing.Point(254, 329);
            this.exitButton.Name = "exitButton";
            this.exitButton.Size = new System.Drawing.Size(75, 27);
            this.exitButton.TabIndex = 7;
            this.exitButton.Text = "Exit";
            this.exitButton.UseVisualStyleBackColor = true;
            this.exitButton.Click += new System.EventHandler(this.exitButton_Click);
            // 
            // HangUpbutton
            // 
            this.HangUpbutton.Location = new System.Drawing.Point(212, 110);
            this.HangUpbutton.Name = "HangUpbutton";
            this.HangUpbutton.Size = new System.Drawing.Size(88, 28);
            this.HangUpbutton.TabIndex = 2;
            this.HangUpbutton.Text = "Hang up";
            this.HangUpbutton.UseVisualStyleBackColor = true;
            this.HangUpbutton.Click += new System.EventHandler(this.HangUpbutton_Click);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(341, 363);
            this.Controls.Add(this.exitButton);
            this.Controls.Add(this.helpButton);
            this.Controls.Add(this.closeButton);
            this.Controls.Add(this.portStatus);
            this.Controls.Add(this.functions);
            this.Controls.Add(this.openPort);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "MainForm";
            this.Text = "RecDTMF_FaxOrVoice";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.MainForm_FormClosed);
            this.Load += new System.EventHandler(this.MainForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.axVoiceOCX1)).EndInit();
            this.openPort.ResumeLayout(false);
            this.functions.ResumeLayout(false);
            this.portStatus.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        public AxVOICEOCXLib.AxVoiceOCX axVoiceOCX1;
        private System.Windows.Forms.GroupBox openPort;
        private System.Windows.Forms.GroupBox functions;
        private System.Windows.Forms.GroupBox portStatus;
        private System.Windows.Forms.ListBox statusBox;
        private System.Windows.Forms.Button clearButton;
        public System.Windows.Forms.Button closeButton;
        private System.Windows.Forms.Button helpButton;
        private System.Windows.Forms.Button exitButton;
        private System.Windows.Forms.Button dialogicOpen;
        private System.Windows.Forms.Button portOpen;
        private System.Windows.Forms.Button NMSOpen;
        private System.Windows.Forms.Button brookOpen;
        private System.Windows.Forms.Button recordButton;
        private System.Windows.Forms.Button DTMFButton;
        private System.Windows.Forms.Button receiveButton;
        private System.Windows.Forms.Button HangUpbutton;

    }
}

