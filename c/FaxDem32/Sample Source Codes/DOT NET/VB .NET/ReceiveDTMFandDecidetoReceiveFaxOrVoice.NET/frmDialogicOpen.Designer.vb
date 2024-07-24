<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class frmDialogicOpen
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
	Public WithEvents PAMD As System.Windows.Forms.CheckBox
	Public WithEvents Protocol As System.Windows.Forms.TextBox
	Public WithEvents LineType As System.Windows.Forms.ComboBox
	Public WithEvents btnCancel As System.Windows.Forms.Button
	Public WithEvents btnOK As System.Windows.Forms.Button
    Public WithEvents Label2 As System.Windows.Forms.Label
	Public WithEvents Label1 As System.Windows.Forms.Label
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmDialogicOpen))
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.PAMD = New System.Windows.Forms.CheckBox
        Me.Protocol = New System.Windows.Forms.TextBox
        Me.LineType = New System.Windows.Forms.ComboBox
        Me.btnCancel = New System.Windows.Forms.Button
        Me.btnOK = New System.Windows.Forms.Button
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.lvChannelList = New System.Windows.Forms.ListBox
        Me.SuspendLayout()
        '
        'PAMD
        '
        Me.PAMD.BackColor = System.Drawing.SystemColors.Control
        Me.PAMD.Cursor = System.Windows.Forms.Cursors.Default
        Me.PAMD.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.PAMD.ForeColor = System.Drawing.SystemColors.ControlText
        Me.PAMD.Location = New System.Drawing.Point(8, 184)
        Me.PAMD.Name = "PAMD"
        Me.PAMD.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.PAMD.Size = New System.Drawing.Size(345, 17)
        Me.PAMD.TabIndex = 7
        Me.PAMD.Text = "Enable answering machine detection"
        Me.PAMD.UseVisualStyleBackColor = False
        '
        'Protocol
        '
        Me.Protocol.AcceptsReturn = True
        Me.Protocol.BackColor = System.Drawing.SystemColors.Window
        Me.Protocol.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.Protocol.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Protocol.ForeColor = System.Drawing.SystemColors.WindowText
        Me.Protocol.Location = New System.Drawing.Point(264, 208)
        Me.Protocol.MaxLength = 0
        Me.Protocol.Name = "Protocol"
        Me.Protocol.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Protocol.Size = New System.Drawing.Size(129, 20)
        Me.Protocol.TabIndex = 6
        '
        'LineType
        '
        Me.LineType.BackColor = System.Drawing.SystemColors.Window
        Me.LineType.Cursor = System.Windows.Forms.Cursors.Default
        Me.LineType.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LineType.ForeColor = System.Drawing.SystemColors.WindowText
        Me.LineType.Items.AddRange(New Object() {"Analog", "ISDN PRI", "T1", "E1"})
        Me.LineType.Location = New System.Drawing.Point(72, 208)
        Me.LineType.Name = "LineType"
        Me.LineType.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.LineType.Size = New System.Drawing.Size(129, 22)
        Me.LineType.TabIndex = 4
        Me.LineType.Text = "Combo1"
        '
        'btnCancel
        '
        Me.btnCancel.BackColor = System.Drawing.SystemColors.Control
        Me.btnCancel.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancel.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnCancel.Location = New System.Drawing.Point(328, 40)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnCancel.Size = New System.Drawing.Size(65, 25)
        Me.btnCancel.TabIndex = 2
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = False
        '
        'btnOK
        '
        Me.btnOK.BackColor = System.Drawing.SystemColors.Control
        Me.btnOK.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnOK.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnOK.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnOK.Location = New System.Drawing.Point(328, 8)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnOK.Size = New System.Drawing.Size(65, 25)
        Me.btnOK.TabIndex = 1
        Me.btnOK.Text = "OK"
        Me.btnOK.UseVisualStyleBackColor = False
        '
        'Label2
        '
        Me.Label2.BackColor = System.Drawing.SystemColors.Control
        Me.Label2.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label2.Location = New System.Drawing.Point(208, 208)
        Me.Label2.Name = "Label2"
        Me.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label2.Size = New System.Drawing.Size(49, 17)
        Me.Label2.TabIndex = 5
        Me.Label2.Text = "Protocol:"
        '
        'Label1
        '
        Me.Label1.BackColor = System.Drawing.SystemColors.Control
        Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(8, 208)
        Me.Label1.Name = "Label1"
        Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label1.Size = New System.Drawing.Size(57, 17)
        Me.Label1.TabIndex = 3
        Me.Label1.Text = "Line Type:"
        '
        'lvChannelList
        '
        Me.lvChannelList.FormattingEnabled = True
        Me.lvChannelList.ItemHeight = 14
        Me.lvChannelList.Location = New System.Drawing.Point(12, 8)
        Me.lvChannelList.Name = "lvChannelList"
        Me.lvChannelList.Size = New System.Drawing.Size(284, 158)
        Me.lvChannelList.TabIndex = 8
        '
        'frmDialogicOpen
        '
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Inherit
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.ClientSize = New System.Drawing.Size(400, 240)
        Me.Controls.Add(Me.lvChannelList)
        Me.Controls.Add(Me.PAMD)
        Me.Controls.Add(Me.Protocol)
        Me.Controls.Add(Me.LineType)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Cursor = System.Windows.Forms.Cursors.Default
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Location = New System.Drawing.Point(3, 22)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmDialogicOpen"
        Me.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Open Dialogic Channel"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents lvChannelList As System.Windows.Forms.ListBox
#End Region
End Class