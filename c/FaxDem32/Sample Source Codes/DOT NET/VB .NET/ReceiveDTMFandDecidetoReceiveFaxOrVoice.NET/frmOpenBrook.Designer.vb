<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class frmOpenBrook
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
	Public WithEvents ConfigFile As System.Windows.Forms.TextBox
	Public WithEvents btnTest As System.Windows.Forms.Button
	Public WithEvents btnCancel As System.Windows.Forms.Button
	Public WithEvents btnOK As System.Windows.Forms.Button
	Public WithEvents ModemType As System.Windows.Forms.TextBox
	Public WithEvents chbLogEn As System.Windows.Forms.CheckBox
	Public WithEvents lvChannelList As System.Windows.Forms.ListBox
	Public WithEvents Label2 As System.Windows.Forms.Label
	Public WithEvents Label3 As System.Windows.Forms.Label
	Public WithEvents Label1 As System.Windows.Forms.Label
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmOpenBrook))
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.ConfigFile = New System.Windows.Forms.TextBox
        Me.btnTest = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.btnOK = New System.Windows.Forms.Button
        Me.ModemType = New System.Windows.Forms.TextBox
        Me.chbLogEn = New System.Windows.Forms.CheckBox
        Me.lvChannelList = New System.Windows.Forms.ListBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'ConfigFile
        '
        Me.ConfigFile.AcceptsReturn = True
        Me.ConfigFile.BackColor = System.Drawing.SystemColors.Window
        Me.ConfigFile.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.ConfigFile.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ConfigFile.ForeColor = System.Drawing.SystemColors.WindowText
        Me.ConfigFile.Location = New System.Drawing.Point(120, 28)
        Me.ConfigFile.MaxLength = 0
        Me.ConfigFile.Name = "ConfigFile"
        Me.ConfigFile.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.ConfigFile.Size = New System.Drawing.Size(177, 20)
        Me.ConfigFile.TabIndex = 9
        '
        'btnTest
        '
        Me.btnTest.BackColor = System.Drawing.SystemColors.Control
        Me.btnTest.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnTest.Enabled = False
        Me.btnTest.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnTest.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnTest.Location = New System.Drawing.Point(304, 72)
        Me.btnTest.Name = "btnTest"
        Me.btnTest.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnTest.Size = New System.Drawing.Size(65, 25)
        Me.btnTest.TabIndex = 7
        Me.btnTest.Text = "&Test"
        Me.btnTest.UseVisualStyleBackColor = False
        '
        'btnCancel
        '
        Me.btnCancel.BackColor = System.Drawing.SystemColors.Control
        Me.btnCancel.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancel.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnCancel.Location = New System.Drawing.Point(304, 40)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnCancel.Size = New System.Drawing.Size(65, 25)
        Me.btnCancel.TabIndex = 6
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = False
        '
        'btnOK
        '
        Me.btnOK.BackColor = System.Drawing.SystemColors.Control
        Me.btnOK.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnOK.Enabled = False
        Me.btnOK.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnOK.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnOK.Location = New System.Drawing.Point(304, 8)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnOK.Size = New System.Drawing.Size(65, 25)
        Me.btnOK.TabIndex = 5
        Me.btnOK.Text = "OK"
        Me.btnOK.UseVisualStyleBackColor = False
        '
        'ModemType
        '
        Me.ModemType.AcceptsReturn = True
        Me.ModemType.BackColor = System.Drawing.SystemColors.Window
        Me.ModemType.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.ModemType.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ModemType.ForeColor = System.Drawing.SystemColors.WindowText
        Me.ModemType.Location = New System.Drawing.Point(120, 97)
        Me.ModemType.MaxLength = 0
        Me.ModemType.Name = "ModemType"
        Me.ModemType.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.ModemType.Size = New System.Drawing.Size(169, 20)
        Me.ModemType.TabIndex = 4
        Me.ModemType.Text = "Unknown Modem"
        '
        'chbLogEn
        '
        Me.chbLogEn.BackColor = System.Drawing.SystemColors.Control
        Me.chbLogEn.Cursor = System.Windows.Forms.Cursors.Default
        Me.chbLogEn.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.chbLogEn.ForeColor = System.Drawing.SystemColors.ControlText
        Me.chbLogEn.Location = New System.Drawing.Point(120, 60)
        Me.chbLogEn.Name = "chbLogEn"
        Me.chbLogEn.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.chbLogEn.Size = New System.Drawing.Size(105, 17)
        Me.chbLogEn.TabIndex = 2
        Me.chbLogEn.Text = "Enable Log"
        Me.chbLogEn.UseVisualStyleBackColor = False
        '
        'lvChannelList
        '
        Me.lvChannelList.BackColor = System.Drawing.SystemColors.Window
        Me.lvChannelList.Cursor = System.Windows.Forms.Cursors.Default
        Me.lvChannelList.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lvChannelList.ForeColor = System.Drawing.SystemColors.WindowText
        Me.lvChannelList.ItemHeight = 14
        Me.lvChannelList.Location = New System.Drawing.Point(9, 28)
        Me.lvChannelList.Name = "lvChannelList"
        Me.lvChannelList.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lvChannelList.Size = New System.Drawing.Size(105, 88)
        Me.lvChannelList.TabIndex = 1
        '
        'Label2
        '
        Me.Label2.BackColor = System.Drawing.SystemColors.Control
        Me.Label2.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label2.Location = New System.Drawing.Point(120, 8)
        Me.Label2.Name = "Label2"
        Me.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label2.Size = New System.Drawing.Size(113, 17)
        Me.Label2.TabIndex = 8
        Me.Label2.Text = "ConfigFile"
        '
        'Label3
        '
        Me.Label3.BackColor = System.Drawing.SystemColors.Control
        Me.Label3.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label3.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label3.Location = New System.Drawing.Point(120, 80)
        Me.Label3.Name = "Label3"
        Me.Label3.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label3.Size = New System.Drawing.Size(97, 17)
        Me.Label3.TabIndex = 3
        Me.Label3.Text = "Modem Type"
        '
        'Label1
        '
        Me.Label1.BackColor = System.Drawing.SystemColors.Control
        Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(8, 8)
        Me.Label1.Name = "Label1"
        Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label1.Size = New System.Drawing.Size(106, 17)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Available Channels"
        '
        'frmOpenBrook
        '
        Me.AcceptButton = Me.btnOK
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 14.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(376, 133)
        Me.Controls.Add(Me.ConfigFile)
        Me.Controls.Add(Me.btnTest)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.ModemType)
        Me.Controls.Add(Me.chbLogEn)
        Me.Controls.Add(Me.lvChannelList)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.Label1)
        Me.Cursor = System.Windows.Forms.Cursors.Default
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Location = New System.Drawing.Point(3, 22)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmOpenBrook"
        Me.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Open Brooktrout Channel"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
#End Region 
End Class