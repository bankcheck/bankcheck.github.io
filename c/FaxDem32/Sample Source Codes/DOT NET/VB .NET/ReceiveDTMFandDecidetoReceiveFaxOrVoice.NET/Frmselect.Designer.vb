<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class frmSelectPort
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
	Public WithEvents btnVoiceFormats As System.Windows.Forms.Button
    Public WithEvents ModemCaps As System.Windows.Forms.TextBox
	Public WithEvents Model As System.Windows.Forms.TextBox
	Public WithEvents Manufacturer As System.Windows.Forms.TextBox
	Public WithEvents cbModemType As System.Windows.Forms.ComboBox
	Public WithEvents btnCancel As System.Windows.Forms.Button
	Public WithEvents btnTest As System.Windows.Forms.Button
	Public WithEvents btnOpenPort As System.Windows.Forms.Button
	Public WithEvents AllPorts As System.Windows.Forms.ComboBox
	Public WithEvents Label2 As System.Windows.Forms.Label
	Public WithEvents Label5 As System.Windows.Forms.Label
	Public WithEvents Label4 As System.Windows.Forms.Label
	Public WithEvents Label3 As System.Windows.Forms.Label
	Public WithEvents Label1 As System.Windows.Forms.Label
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmSelectPort))
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.btnVoiceFormats = New System.Windows.Forms.Button
        Me.ModemCaps = New System.Windows.Forms.TextBox
        Me.Model = New System.Windows.Forms.TextBox
        Me.Manufacturer = New System.Windows.Forms.TextBox
        Me.cbModemType = New System.Windows.Forms.ComboBox
        Me.btnCancel = New System.Windows.Forms.Button
        Me.btnTest = New System.Windows.Forms.Button
        Me.btnOpenPort = New System.Windows.Forms.Button
        Me.AllPorts = New System.Windows.Forms.ComboBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label5 = New System.Windows.Forms.Label
        Me.Label4 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'btnVoiceFormats
        '
        Me.btnVoiceFormats.BackColor = System.Drawing.SystemColors.Control
        Me.btnVoiceFormats.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnVoiceFormats.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnVoiceFormats.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnVoiceFormats.Location = New System.Drawing.Point(176, 232)
        Me.btnVoiceFormats.Name = "btnVoiceFormats"
        Me.btnVoiceFormats.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnVoiceFormats.Size = New System.Drawing.Size(97, 25)
        Me.btnVoiceFormats.TabIndex = 14
        Me.btnVoiceFormats.Text = "&Voice formats..."
        Me.btnVoiceFormats.UseVisualStyleBackColor = False
        '
        'ModemCaps
        '
        Me.ModemCaps.AcceptsReturn = True
        Me.ModemCaps.BackColor = System.Drawing.SystemColors.Window
        Me.ModemCaps.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.ModemCaps.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ModemCaps.ForeColor = System.Drawing.SystemColors.WindowText
        Me.ModemCaps.Location = New System.Drawing.Point(8, 200)
        Me.ModemCaps.MaxLength = 0
        Me.ModemCaps.Name = "ModemCaps"
        Me.ModemCaps.ReadOnly = True
        Me.ModemCaps.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.ModemCaps.Size = New System.Drawing.Size(265, 20)
        Me.ModemCaps.TabIndex = 5
        '
        'Model
        '
        Me.Model.AcceptsReturn = True
        Me.Model.BackColor = System.Drawing.SystemColors.Window
        Me.Model.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.Model.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Model.ForeColor = System.Drawing.SystemColors.WindowText
        Me.Model.Location = New System.Drawing.Point(8, 152)
        Me.Model.MaxLength = 0
        Me.Model.Name = "Model"
        Me.Model.ReadOnly = True
        Me.Model.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Model.Size = New System.Drawing.Size(265, 20)
        Me.Model.TabIndex = 4
        '
        'Manufacturer
        '
        Me.Manufacturer.AcceptsReturn = True
        Me.Manufacturer.BackColor = System.Drawing.SystemColors.Window
        Me.Manufacturer.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.Manufacturer.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Manufacturer.ForeColor = System.Drawing.SystemColors.WindowText
        Me.Manufacturer.Location = New System.Drawing.Point(8, 104)
        Me.Manufacturer.MaxLength = 0
        Me.Manufacturer.Name = "Manufacturer"
        Me.Manufacturer.ReadOnly = True
        Me.Manufacturer.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Manufacturer.Size = New System.Drawing.Size(265, 20)
        Me.Manufacturer.TabIndex = 3
        '
        'cbModemType
        '
        Me.cbModemType.BackColor = System.Drawing.SystemColors.Window
        Me.cbModemType.Cursor = System.Windows.Forms.Cursors.Default
        Me.cbModemType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cbModemType.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cbModemType.ForeColor = System.Drawing.SystemColors.WindowText
        Me.cbModemType.Items.AddRange(New Object() {"Auto detect modem type", "Rockwell Chipset Based Modem", "USRobotics Sportster", "Lucent Chipset Based Modem", "Cirrus Logic Chipset Based Modem", "Rockwell/Conexant HCF Chipset Modem"})
        Me.cbModemType.Location = New System.Drawing.Point(8, 64)
        Me.cbModemType.Name = "cbModemType"
        Me.cbModemType.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cbModemType.Size = New System.Drawing.Size(177, 22)
        Me.cbModemType.TabIndex = 2
        '
        'btnCancel
        '
        Me.btnCancel.BackColor = System.Drawing.SystemColors.Control
        Me.btnCancel.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancel.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnCancel.Location = New System.Drawing.Point(192, 72)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnCancel.Size = New System.Drawing.Size(81, 25)
        Me.btnCancel.TabIndex = 9
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = False
        '
        'btnTest
        '
        Me.btnTest.BackColor = System.Drawing.SystemColors.Control
        Me.btnTest.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnTest.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnTest.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnTest.Location = New System.Drawing.Point(192, 40)
        Me.btnTest.Name = "btnTest"
        Me.btnTest.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnTest.Size = New System.Drawing.Size(81, 25)
        Me.btnTest.TabIndex = 8
        Me.btnTest.Text = "&Test"
        Me.btnTest.UseVisualStyleBackColor = False
        '
        'btnOpenPort
        '
        Me.btnOpenPort.BackColor = System.Drawing.SystemColors.Control
        Me.btnOpenPort.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnOpenPort.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnOpenPort.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnOpenPort.Location = New System.Drawing.Point(192, 8)
        Me.btnOpenPort.Name = "btnOpenPort"
        Me.btnOpenPort.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnOpenPort.Size = New System.Drawing.Size(81, 25)
        Me.btnOpenPort.TabIndex = 7
        Me.btnOpenPort.Text = "&Open Port"
        Me.btnOpenPort.UseVisualStyleBackColor = False
        '
        'AllPorts
        '
        Me.AllPorts.BackColor = System.Drawing.SystemColors.Window
        Me.AllPorts.Cursor = System.Windows.Forms.Cursors.Default
        Me.AllPorts.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.AllPorts.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.AllPorts.ForeColor = System.Drawing.SystemColors.WindowText
        Me.AllPorts.Location = New System.Drawing.Point(8, 24)
        Me.AllPorts.Name = "AllPorts"
        Me.AllPorts.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.AllPorts.Size = New System.Drawing.Size(113, 22)
        Me.AllPorts.TabIndex = 1
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.BackColor = System.Drawing.SystemColors.Control
        Me.Label2.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label2.Location = New System.Drawing.Point(8, 48)
        Me.Label2.Name = "Label2"
        Me.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label2.Size = New System.Drawing.Size(71, 14)
        Me.Label2.TabIndex = 13
        Me.Label2.Text = "Modem Type:"
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.BackColor = System.Drawing.SystemColors.Control
        Me.Label5.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label5.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label5.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label5.Location = New System.Drawing.Point(8, 184)
        Me.Label5.Name = "Label5"
        Me.Label5.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label5.Size = New System.Drawing.Size(98, 14)
        Me.Label5.TabIndex = 12
        Me.Label5.Text = "Modem Capabilities"
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.BackColor = System.Drawing.SystemColors.Control
        Me.Label4.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label4.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label4.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label4.Location = New System.Drawing.Point(8, 136)
        Me.Label4.Name = "Label4"
        Me.Label4.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label4.Size = New System.Drawing.Size(35, 14)
        Me.Label4.TabIndex = 11
        Me.Label4.Text = "&Model"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.BackColor = System.Drawing.SystemColors.Control
        Me.Label3.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label3.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label3.Location = New System.Drawing.Point(8, 88)
        Me.Label3.Name = "Label3"
        Me.Label3.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label3.Size = New System.Drawing.Size(72, 14)
        Me.Label3.TabIndex = 10
        Me.Label3.Text = "Manufacturer"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.BackColor = System.Drawing.SystemColors.Control
        Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(8, 8)
        Me.Label1.Name = "Label1"
        Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label1.Size = New System.Drawing.Size(89, 14)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Serial port to use"
        '
        'frmSelectPort
        '
        Me.AcceptButton = Me.btnTest
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 14.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(281, 259)
        Me.Controls.Add(Me.btnVoiceFormats)
        Me.Controls.Add(Me.ModemCaps)
        Me.Controls.Add(Me.Model)
        Me.Controls.Add(Me.Manufacturer)
        Me.Controls.Add(Me.cbModemType)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnTest)
        Me.Controls.Add(Me.btnOpenPort)
        Me.Controls.Add(Me.AllPorts)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label5)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.Label1)
        Me.Cursor = System.Windows.Forms.Cursors.Default
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Location = New System.Drawing.Point(3, 22)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmSelectPort"
        Me.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Select Port/Modem"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
#End Region 
End Class