<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class frmHelp
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
	Public WithEvents HelpList As System.Windows.Forms.ListBox
	Public WithEvents OKButton As System.Windows.Forms.Button
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.HelpList = New System.Windows.Forms.ListBox
        Me.OKButton = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'HelpList
        '
        Me.HelpList.BackColor = System.Drawing.SystemColors.Window
        Me.HelpList.Cursor = System.Windows.Forms.Cursors.Default
        Me.HelpList.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.HelpList.ForeColor = System.Drawing.SystemColors.WindowText
        Me.HelpList.ItemHeight = 14
        Me.HelpList.Location = New System.Drawing.Point(8, 8)
        Me.HelpList.Name = "HelpList"
        Me.HelpList.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.HelpList.Size = New System.Drawing.Size(617, 270)
        Me.HelpList.TabIndex = 1
        '
        'OKButton
        '
        Me.OKButton.BackColor = System.Drawing.SystemColors.Control
        Me.OKButton.Cursor = System.Windows.Forms.Cursors.Default
        Me.OKButton.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.OKButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.OKButton.Location = New System.Drawing.Point(272, 296)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.OKButton.Size = New System.Drawing.Size(89, 25)
        Me.OKButton.TabIndex = 0
        Me.OKButton.Text = "OK"
        Me.OKButton.UseVisualStyleBackColor = False
        '
        'frmHelp
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 14.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.ClientSize = New System.Drawing.Size(635, 331)
        Me.Controls.Add(Me.HelpList)
        Me.Controls.Add(Me.OKButton)
        Me.Cursor = System.Windows.Forms.Cursors.Default
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Location = New System.Drawing.Point(184, 250)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmHelp"
        Me.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.Manual
        Me.Text = "Interactive Voice Sample Help"
        Me.ResumeLayout(False)

    End Sub
#End Region 
End Class