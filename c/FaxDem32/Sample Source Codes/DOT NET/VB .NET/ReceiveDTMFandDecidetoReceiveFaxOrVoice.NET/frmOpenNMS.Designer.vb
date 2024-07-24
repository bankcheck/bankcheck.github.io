<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class frmOpenNMS
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
	Public WithEvents DIDText As System.Windows.Forms.TextBox
	Public WithEvents ProtocolCombo As System.Windows.Forms.ComboBox
	Public WithEvents chbLogEn As System.Windows.Forms.CheckBox
	Public WithEvents btnCancel As System.Windows.Forms.Button
	Public WithEvents btnOK As System.Windows.Forms.Button
	Public WithEvents lvChannelList As AxComctlLib.AxListView
	Public WithEvents Label2 As System.Windows.Forms.Label
	Public WithEvents Label1 As System.Windows.Forms.Label
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmOpenNMS))
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.DIDText = New System.Windows.Forms.TextBox
        Me.ProtocolCombo = New System.Windows.Forms.ComboBox
        Me.chbLogEn = New System.Windows.Forms.CheckBox
        Me.btnCancel = New System.Windows.Forms.Button
        Me.btnOK = New System.Windows.Forms.Button
        Me.lvChannelList = New AxComctlLib.AxListView
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        CType(Me.lvChannelList, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'DIDText
        '
        Me.DIDText.AcceptsReturn = True
        Me.DIDText.BackColor = System.Drawing.SystemColors.Window
        Me.DIDText.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.DIDText.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.DIDText.ForeColor = System.Drawing.SystemColors.WindowText
        Me.DIDText.Location = New System.Drawing.Point(96, 245)
        Me.DIDText.MaxLength = 0
        Me.DIDText.Name = "DIDText"
        Me.DIDText.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.DIDText.Size = New System.Drawing.Size(49, 19)
        Me.DIDText.TabIndex = 7
        Me.DIDText.Text = "3"
        '
        'ProtocolCombo
        '
        Me.ProtocolCombo.BackColor = System.Drawing.SystemColors.Window
        Me.ProtocolCombo.Cursor = System.Windows.Forms.Cursors.Default
        Me.ProtocolCombo.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ProtocolCombo.ForeColor = System.Drawing.SystemColors.WindowText
        Me.ProtocolCombo.Location = New System.Drawing.Point(8, 216)
        Me.ProtocolCombo.Name = "ProtocolCombo"
        Me.ProtocolCombo.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.ProtocolCombo.Size = New System.Drawing.Size(305, 22)
        Me.ProtocolCombo.TabIndex = 5
        Me.ProtocolCombo.Text = "Combo1"
        '
        'chbLogEn
        '
        Me.chbLogEn.BackColor = System.Drawing.SystemColors.Control
        Me.chbLogEn.Cursor = System.Windows.Forms.Cursors.Default
        Me.chbLogEn.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.chbLogEn.ForeColor = System.Drawing.SystemColors.ControlText
        Me.chbLogEn.Location = New System.Drawing.Point(8, 176)
        Me.chbLogEn.Name = "chbLogEn"
        Me.chbLogEn.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.chbLogEn.Size = New System.Drawing.Size(113, 17)
        Me.chbLogEn.TabIndex = 2
        Me.chbLogEn.Text = "Enable Log"
        Me.chbLogEn.UseVisualStyleBackColor = False
        '
        'btnCancel
        '
        Me.btnCancel.BackColor = System.Drawing.SystemColors.Control
        Me.btnCancel.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancel.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnCancel.Location = New System.Drawing.Point(320, 32)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnCancel.Size = New System.Drawing.Size(65, 25)
        Me.btnCancel.TabIndex = 1
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = False
        '
        'btnOK
        '
        Me.btnOK.BackColor = System.Drawing.SystemColors.Control
        Me.btnOK.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnOK.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnOK.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnOK.Location = New System.Drawing.Point(320, 0)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnOK.Size = New System.Drawing.Size(65, 25)
        Me.btnOK.TabIndex = 0
        Me.btnOK.Text = "OK"
        Me.btnOK.UseVisualStyleBackColor = False
        '
        'lvChannelList
        '
        Me.lvChannelList.Location = New System.Drawing.Point(8, 0)
        Me.lvChannelList.Name = "lvChannelList"
        Me.lvChannelList.OcxState = CType(resources.GetObject("lvChannelList.OcxState"), System.Windows.Forms.AxHost.State)
        Me.lvChannelList.Size = New System.Drawing.Size(305, 169)
        Me.lvChannelList.TabIndex = 3
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.BackColor = System.Drawing.SystemColors.Control
        Me.Label2.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label2.Location = New System.Drawing.Point(8, 248)
        Me.Label2.Name = "Label2"
        Me.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label2.Size = New System.Drawing.Size(80, 14)
        Me.Label2.TabIndex = 6
        Me.Label2.Text = "DID/DNIS digits:"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.BackColor = System.Drawing.SystemColors.Control
        Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(8, 200)
        Me.Label1.Name = "Label1"
        Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label1.Size = New System.Drawing.Size(127, 14)
        Me.Label1.TabIndex = 4
        Me.Label1.Text = "NMS Telephony Protocol:"
        '
        'frmOpenNMS
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 14.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(391, 293)
        Me.Controls.Add(Me.DIDText)
        Me.Controls.Add(Me.ProtocolCombo)
        Me.Controls.Add(Me.chbLogEn)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.lvChannelList)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Cursor = System.Windows.Forms.Cursors.Default
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Location = New System.Drawing.Point(4, 23)
        Me.Name = "frmOpenNMS"
        Me.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Text = "Open NMS Channel"
        CType(Me.lvChannelList, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
#End Region 
End Class