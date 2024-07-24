<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class frmWaitforDTMF
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
	Public WithEvents btnCancel As System.Windows.Forms.Button
	Public WithEvents btnOK As System.Windows.Forms.Button
	Public WithEvents edDelimiter As System.Windows.Forms.TextBox
	Public WithEvents edDigits As System.Windows.Forms.TextBox
	Public WithEvents Label2 As System.Windows.Forms.Label
	Public WithEvents Label1 As System.Windows.Forms.Label
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmWaitforDTMF))
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.btnCancel = New System.Windows.Forms.Button
        Me.btnOK = New System.Windows.Forms.Button
        Me.edDelimiter = New System.Windows.Forms.TextBox
        Me.edDigits = New System.Windows.Forms.TextBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'btnCancel
        '
        Me.btnCancel.BackColor = System.Drawing.SystemColors.Control
        Me.btnCancel.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnCancel.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancel.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnCancel.Location = New System.Drawing.Point(112, 72)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnCancel.Size = New System.Drawing.Size(81, 25)
        Me.btnCancel.TabIndex = 5
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = False
        '
        'btnOK
        '
        Me.btnOK.BackColor = System.Drawing.SystemColors.Control
        Me.btnOK.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnOK.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnOK.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnOK.Location = New System.Drawing.Point(16, 72)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnOK.Size = New System.Drawing.Size(81, 25)
        Me.btnOK.TabIndex = 2
        Me.btnOK.Text = "OK"
        Me.btnOK.UseVisualStyleBackColor = False
        '
        'edDelimiter
        '
        Me.edDelimiter.AcceptsReturn = True
        Me.edDelimiter.BackColor = System.Drawing.SystemColors.Window
        Me.edDelimiter.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.edDelimiter.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.edDelimiter.ForeColor = System.Drawing.SystemColors.WindowText
        Me.edDelimiter.Location = New System.Drawing.Point(128, 40)
        Me.edDelimiter.MaxLength = 1
        Me.edDelimiter.Name = "edDelimiter"
        Me.edDelimiter.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.edDelimiter.Size = New System.Drawing.Size(73, 25)
        Me.edDelimiter.TabIndex = 1
        '
        'edDigits
        '
        Me.edDigits.AcceptsReturn = True
        Me.edDigits.BackColor = System.Drawing.SystemColors.Window
        Me.edDigits.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.edDigits.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.edDigits.ForeColor = System.Drawing.SystemColors.WindowText
        Me.edDigits.Location = New System.Drawing.Point(128, 8)
        Me.edDigits.MaxLength = 3
        Me.edDigits.Name = "edDigits"
        Me.edDigits.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.edDigits.Size = New System.Drawing.Size(73, 25)
        Me.edDigits.TabIndex = 0
        '
        'Label2
        '
        Me.Label2.BackColor = System.Drawing.SystemColors.Control
        Me.Label2.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label2.Location = New System.Drawing.Point(8, 40)
        Me.Label2.Name = "Label2"
        Me.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label2.Size = New System.Drawing.Size(97, 17)
        Me.Label2.TabIndex = 4
        Me.Label2.Text = "Delimiter digit:"
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
        Me.Label1.Size = New System.Drawing.Size(121, 17)
        Me.Label1.TabIndex = 3
        Me.Label1.Text = "Number of DTMF digits:"
        '
        'frmWaitforDTMF
        '
        Me.AcceptButton = Me.btnOK
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 14.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.ClientSize = New System.Drawing.Size(209, 105)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.edDelimiter)
        Me.Controls.Add(Me.edDigits)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Cursor = System.Windows.Forms.Cursors.Default
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Location = New System.Drawing.Point(3, 22)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmWaitforDTMF"
        Me.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Wait for DTMF digits"
        Me.ResumeLayout(False)

    End Sub
#End Region 
End Class