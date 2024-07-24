<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class frmMain
#Region "Windows Form Designer generated code "
	<System.Diagnostics.DebuggerNonUserCode()> Public Sub New()
		MyBase.New()
		'This call is required by the Windows Form Designer.
		InitializeComponent()
	End Sub
	'Form overrides dispose to clean up the component list.
	<System.Diagnostics.DebuggerNonUserCode()> Protected Overloads Overrides Sub Dispose(ByVal Disposing As Boolean)
		If Disposing Then
			If Not components Is Nothing Then
				components.Dispose()
			End If
		End If
		MyBase.Dispose(Disposing)
	End Sub
	'Required by the Windows Form Designer
	Private components As System.ComponentModel.IContainer
	Public ToolTip1 As System.Windows.Forms.ToolTip
	Public WithEvents VoiceOCX As AxVOICEOCXLib.AxVoiceOCX
	Public WithEvents Exit_Renamed As System.Windows.Forms.Button
	Public WithEvents Help As System.Windows.Forms.Button
	Public WithEvents CloseButton As System.Windows.Forms.Button
	Public WithEvents Clear As System.Windows.Forms.Button
	Public WithEvents lstEvents As System.Windows.Forms.ListBox
	Public WithEvents Frame3 As System.Windows.Forms.GroupBox
	Public WithEvents RecordMessage As System.Windows.Forms.Button
	Public WithEvents WaitForDTMF As System.Windows.Forms.Button
	Public WithEvents ReceiveFax As System.Windows.Forms.Button
	Public WithEvents Frame2 As System.Windows.Forms.GroupBox
	Public WithEvents OpenNMS As System.Windows.Forms.Button
	Public WithEvents OpenBrooktrout As System.Windows.Forms.Button
	Public WithEvents OpenDialogic As System.Windows.Forms.Button
	Public WithEvents OpenCOM As System.Windows.Forms.Button
	Public WithEvents Frame1 As System.Windows.Forms.GroupBox
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmMain))
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.VoiceOCX = New AxVOICEOCXLib.AxVoiceOCX
        Me.Exit_Renamed = New System.Windows.Forms.Button
        Me.Help = New System.Windows.Forms.Button
        Me.CloseButton = New System.Windows.Forms.Button
        Me.Frame3 = New System.Windows.Forms.GroupBox
        Me.hangupButton = New System.Windows.Forms.Button
        Me.Clear = New System.Windows.Forms.Button
        Me.lstEvents = New System.Windows.Forms.ListBox
        Me.Frame2 = New System.Windows.Forms.GroupBox
        Me.RecordMessage = New System.Windows.Forms.Button
        Me.WaitForDTMF = New System.Windows.Forms.Button
        Me.ReceiveFax = New System.Windows.Forms.Button
        Me.Frame1 = New System.Windows.Forms.GroupBox
        Me.OpenNMS = New System.Windows.Forms.Button
        Me.OpenBrooktrout = New System.Windows.Forms.Button
        Me.OpenDialogic = New System.Windows.Forms.Button
        Me.OpenCOM = New System.Windows.Forms.Button
        CType(Me.VoiceOCX, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Frame3.SuspendLayout()
        Me.Frame2.SuspendLayout()
        Me.Frame1.SuspendLayout()
        Me.SuspendLayout()
        '
        'VoiceOCX
        '
        Me.VoiceOCX.Enabled = True
        Me.VoiceOCX.Location = New System.Drawing.Point(144, 0)
        Me.VoiceOCX.Name = "VoiceOCX"
        Me.VoiceOCX.OcxState = CType(resources.GetObject("VoiceOCX.OcxState"), System.Windows.Forms.AxHost.State)
        Me.VoiceOCX.Size = New System.Drawing.Size(17, 17)
        Me.VoiceOCX.TabIndex = 15
        '
        'Exit_Renamed
        '
        Me.Exit_Renamed.BackColor = System.Drawing.SystemColors.Control
        Me.Exit_Renamed.Cursor = System.Windows.Forms.Cursors.Default
        Me.Exit_Renamed.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Exit_Renamed.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Exit_Renamed.Location = New System.Drawing.Point(240, 352)
        Me.Exit_Renamed.Name = "Exit_Renamed"
        Me.Exit_Renamed.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Exit_Renamed.Size = New System.Drawing.Size(81, 25)
        Me.Exit_Renamed.TabIndex = 14
        Me.Exit_Renamed.Text = "Exit"
        Me.Exit_Renamed.UseVisualStyleBackColor = False
        '
        'Help
        '
        Me.Help.BackColor = System.Drawing.SystemColors.Control
        Me.Help.Cursor = System.Windows.Forms.Cursors.Default
        Me.Help.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Help.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Help.Location = New System.Drawing.Point(152, 352)
        Me.Help.Name = "Help"
        Me.Help.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Help.Size = New System.Drawing.Size(81, 25)
        Me.Help.TabIndex = 13
        Me.Help.Text = "Help"
        Me.Help.UseVisualStyleBackColor = False
        '
        'CloseButton
        '
        Me.CloseButton.BackColor = System.Drawing.SystemColors.Control
        Me.CloseButton.Cursor = System.Windows.Forms.Cursors.Default
        Me.CloseButton.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.CloseButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.CloseButton.Location = New System.Drawing.Point(16, 352)
        Me.CloseButton.Name = "CloseButton"
        Me.CloseButton.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.CloseButton.Size = New System.Drawing.Size(121, 25)
        Me.CloseButton.TabIndex = 12
        Me.CloseButton.Text = "Close port/channel"
        Me.CloseButton.UseVisualStyleBackColor = False
        '
        'Frame3
        '
        Me.Frame3.BackColor = System.Drawing.SystemColors.Control
        Me.Frame3.Controls.Add(Me.hangupButton)
        Me.Frame3.Controls.Add(Me.Clear)
        Me.Frame3.Controls.Add(Me.lstEvents)
        Me.Frame3.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Frame3.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Frame3.Location = New System.Drawing.Point(8, 184)
        Me.Frame3.Name = "Frame3"
        Me.Frame3.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Frame3.Size = New System.Drawing.Size(321, 161)
        Me.Frame3.TabIndex = 9
        Me.Frame3.TabStop = False
        Me.Frame3.Text = "Port status"
        '
        'hangupButton
        '
        Me.hangupButton.Location = New System.Drawing.Point(216, 128)
        Me.hangupButton.Name = "hangupButton"
        Me.hangupButton.Size = New System.Drawing.Size(89, 25)
        Me.hangupButton.TabIndex = 12
        Me.hangupButton.Text = "Hang up"
        Me.hangupButton.UseVisualStyleBackColor = True
        '
        'Clear
        '
        Me.Clear.BackColor = System.Drawing.SystemColors.Control
        Me.Clear.Cursor = System.Windows.Forms.Cursors.Default
        Me.Clear.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Clear.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Clear.Location = New System.Drawing.Point(16, 128)
        Me.Clear.Name = "Clear"
        Me.Clear.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Clear.Size = New System.Drawing.Size(89, 25)
        Me.Clear.TabIndex = 11
        Me.Clear.Text = "Clear"
        Me.Clear.UseVisualStyleBackColor = False
        '
        'lstEvents
        '
        Me.lstEvents.BackColor = System.Drawing.SystemColors.Window
        Me.lstEvents.Cursor = System.Windows.Forms.Cursors.Default
        Me.lstEvents.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lstEvents.ForeColor = System.Drawing.SystemColors.WindowText
        Me.lstEvents.ItemHeight = 14
        Me.lstEvents.Location = New System.Drawing.Point(16, 24)
        Me.lstEvents.Name = "lstEvents"
        Me.lstEvents.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lstEvents.Size = New System.Drawing.Size(289, 88)
        Me.lstEvents.TabIndex = 10
        '
        'Frame2
        '
        Me.Frame2.BackColor = System.Drawing.SystemColors.Control
        Me.Frame2.Controls.Add(Me.RecordMessage)
        Me.Frame2.Controls.Add(Me.WaitForDTMF)
        Me.Frame2.Controls.Add(Me.ReceiveFax)
        Me.Frame2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Frame2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Frame2.Location = New System.Drawing.Point(8, 112)
        Me.Frame2.Name = "Frame2"
        Me.Frame2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Frame2.Size = New System.Drawing.Size(321, 65)
        Me.Frame2.TabIndex = 5
        Me.Frame2.TabStop = False
        Me.Frame2.Text = "Functions"
        '
        'RecordMessage
        '
        Me.RecordMessage.BackColor = System.Drawing.SystemColors.Control
        Me.RecordMessage.Cursor = System.Windows.Forms.Cursors.Default
        Me.RecordMessage.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.RecordMessage.ForeColor = System.Drawing.SystemColors.ControlText
        Me.RecordMessage.Location = New System.Drawing.Point(216, 24)
        Me.RecordMessage.Name = "RecordMessage"
        Me.RecordMessage.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.RecordMessage.Size = New System.Drawing.Size(97, 25)
        Me.RecordMessage.TabIndex = 8
        Me.RecordMessage.Text = "Record message"
        Me.RecordMessage.UseVisualStyleBackColor = False
        '
        'WaitForDTMF
        '
        Me.WaitForDTMF.BackColor = System.Drawing.SystemColors.Control
        Me.WaitForDTMF.Cursor = System.Windows.Forms.Cursors.Default
        Me.WaitForDTMF.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.WaitForDTMF.ForeColor = System.Drawing.SystemColors.ControlText
        Me.WaitForDTMF.Location = New System.Drawing.Point(112, 24)
        Me.WaitForDTMF.Name = "WaitForDTMF"
        Me.WaitForDTMF.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.WaitForDTMF.Size = New System.Drawing.Size(97, 25)
        Me.WaitForDTMF.TabIndex = 7
        Me.WaitForDTMF.Text = "Wait for DTMF"
        Me.WaitForDTMF.UseVisualStyleBackColor = False
        '
        'ReceiveFax
        '
        Me.ReceiveFax.BackColor = System.Drawing.SystemColors.Control
        Me.ReceiveFax.Cursor = System.Windows.Forms.Cursors.Default
        Me.ReceiveFax.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ReceiveFax.ForeColor = System.Drawing.SystemColors.ControlText
        Me.ReceiveFax.Location = New System.Drawing.Point(8, 24)
        Me.ReceiveFax.Name = "ReceiveFax"
        Me.ReceiveFax.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.ReceiveFax.Size = New System.Drawing.Size(97, 25)
        Me.ReceiveFax.TabIndex = 6
        Me.ReceiveFax.Text = "Receive Fax"
        Me.ReceiveFax.UseVisualStyleBackColor = False
        '
        'Frame1
        '
        Me.Frame1.BackColor = System.Drawing.SystemColors.Control
        Me.Frame1.Controls.Add(Me.OpenNMS)
        Me.Frame1.Controls.Add(Me.OpenBrooktrout)
        Me.Frame1.Controls.Add(Me.OpenDialogic)
        Me.Frame1.Controls.Add(Me.OpenCOM)
        Me.Frame1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Frame1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Frame1.Location = New System.Drawing.Point(8, 8)
        Me.Frame1.Name = "Frame1"
        Me.Frame1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Frame1.Size = New System.Drawing.Size(321, 97)
        Me.Frame1.TabIndex = 0
        Me.Frame1.TabStop = False
        Me.Frame1.Text = "Open port/channel"
        '
        'OpenNMS
        '
        Me.OpenNMS.BackColor = System.Drawing.SystemColors.Control
        Me.OpenNMS.Cursor = System.Windows.Forms.Cursors.Default
        Me.OpenNMS.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.OpenNMS.ForeColor = System.Drawing.SystemColors.ControlText
        Me.OpenNMS.Location = New System.Drawing.Point(168, 56)
        Me.OpenNMS.Name = "OpenNMS"
        Me.OpenNMS.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.OpenNMS.Size = New System.Drawing.Size(137, 25)
        Me.OpenNMS.TabIndex = 4
        Me.OpenNMS.Text = "Open NMS channel"
        Me.OpenNMS.UseVisualStyleBackColor = False
        '
        'OpenBrooktrout
        '
        Me.OpenBrooktrout.BackColor = System.Drawing.SystemColors.Control
        Me.OpenBrooktrout.Cursor = System.Windows.Forms.Cursors.Default
        Me.OpenBrooktrout.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.OpenBrooktrout.ForeColor = System.Drawing.SystemColors.ControlText
        Me.OpenBrooktrout.Location = New System.Drawing.Point(16, 56)
        Me.OpenBrooktrout.Name = "OpenBrooktrout"
        Me.OpenBrooktrout.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.OpenBrooktrout.Size = New System.Drawing.Size(137, 25)
        Me.OpenBrooktrout.TabIndex = 3
        Me.OpenBrooktrout.Text = "Open Brooktrout channel"
        Me.OpenBrooktrout.UseVisualStyleBackColor = False
        '
        'OpenDialogic
        '
        Me.OpenDialogic.BackColor = System.Drawing.SystemColors.Control
        Me.OpenDialogic.Cursor = System.Windows.Forms.Cursors.Default
        Me.OpenDialogic.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.OpenDialogic.ForeColor = System.Drawing.SystemColors.ControlText
        Me.OpenDialogic.Location = New System.Drawing.Point(168, 24)
        Me.OpenDialogic.Name = "OpenDialogic"
        Me.OpenDialogic.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.OpenDialogic.Size = New System.Drawing.Size(137, 25)
        Me.OpenDialogic.TabIndex = 2
        Me.OpenDialogic.Text = "Open Dialogic channel"
        Me.OpenDialogic.UseVisualStyleBackColor = False
        '
        'OpenCOM
        '
        Me.OpenCOM.BackColor = System.Drawing.SystemColors.Control
        Me.OpenCOM.Cursor = System.Windows.Forms.Cursors.Default
        Me.OpenCOM.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.OpenCOM.ForeColor = System.Drawing.SystemColors.ControlText
        Me.OpenCOM.Location = New System.Drawing.Point(16, 24)
        Me.OpenCOM.Name = "OpenCOM"
        Me.OpenCOM.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.OpenCOM.Size = New System.Drawing.Size(137, 25)
        Me.OpenCOM.TabIndex = 1
        Me.OpenCOM.Text = "Open COM port"
        Me.OpenCOM.UseVisualStyleBackColor = False
        '
        'frmMain
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 14.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.ClientSize = New System.Drawing.Size(338, 390)
        Me.Controls.Add(Me.VoiceOCX)
        Me.Controls.Add(Me.Exit_Renamed)
        Me.Controls.Add(Me.Help)
        Me.Controls.Add(Me.CloseButton)
        Me.Controls.Add(Me.Frame3)
        Me.Controls.Add(Me.Frame2)
        Me.Controls.Add(Me.Frame1)
        Me.Cursor = System.Windows.Forms.Cursors.Default
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Location = New System.Drawing.Point(4, 23)
        Me.Name = "frmMain"
        Me.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Text = "ReceiveDTMFandDecidetoReceiveFaxOrVoice"
        CType(Me.VoiceOCX, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Frame3.ResumeLayout(False)
        Me.Frame2.ResumeLayout(False)
        Me.Frame1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents hangupButton As System.Windows.Forms.Button
#End Region 
End Class