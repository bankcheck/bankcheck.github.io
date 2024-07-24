Public Class FaxConfig
    Inherits System.Windows.Forms.Form
    Public pparent As Form1

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents CancelBtn As System.Windows.Forms.Button
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents UntilRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents OnRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents OffRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents GroupBox3 As System.Windows.Forms.GroupBox
    Friend WithEvents HighRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents MediumRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents LowRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents BFTCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents ECMCheckBox As System.Windows.Forms.CheckBox
    Private WithEvents radio33600 As System.Windows.Forms.RadioButton
    Private WithEvents radio31200 As System.Windows.Forms.RadioButton
    Private WithEvents radio28800 As System.Windows.Forms.RadioButton
    Private WithEvents radio26400 As System.Windows.Forms.RadioButton
    Private WithEvents radio24000 As System.Windows.Forms.RadioButton
    Private WithEvents radio21600 As System.Windows.Forms.RadioButton
    Private WithEvents radio19200 As System.Windows.Forms.RadioButton
    Private WithEvents radio16800 As System.Windows.Forms.RadioButton
    Private WithEvents radio14400 As System.Windows.Forms.RadioButton
    Private WithEvents radio12000 As System.Windows.Forms.RadioButton
    Private WithEvents radio9600 As System.Windows.Forms.RadioButton
    Private WithEvents radio7200 As System.Windows.Forms.RadioButton
    Private WithEvents radio4800 As System.Windows.Forms.RadioButton
    Private WithEvents radio2400 As System.Windows.Forms.RadioButton
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.radio33600 = New System.Windows.Forms.RadioButton
        Me.radio31200 = New System.Windows.Forms.RadioButton
        Me.radio28800 = New System.Windows.Forms.RadioButton
        Me.radio26400 = New System.Windows.Forms.RadioButton
        Me.radio24000 = New System.Windows.Forms.RadioButton
        Me.radio21600 = New System.Windows.Forms.RadioButton
        Me.radio19200 = New System.Windows.Forms.RadioButton
        Me.radio16800 = New System.Windows.Forms.RadioButton
        Me.radio14400 = New System.Windows.Forms.RadioButton
        Me.radio12000 = New System.Windows.Forms.RadioButton
        Me.radio9600 = New System.Windows.Forms.RadioButton
        Me.radio7200 = New System.Windows.Forms.RadioButton
        Me.radio4800 = New System.Windows.Forms.RadioButton
        Me.radio2400 = New System.Windows.Forms.RadioButton
        Me.OKButton = New System.Windows.Forms.Button
        Me.CancelBtn = New System.Windows.Forms.Button
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.UntilRadioButton = New System.Windows.Forms.RadioButton
        Me.OnRadioButton = New System.Windows.Forms.RadioButton
        Me.OffRadioButton = New System.Windows.Forms.RadioButton
        Me.GroupBox3 = New System.Windows.Forms.GroupBox
        Me.HighRadioButton = New System.Windows.Forms.RadioButton
        Me.MediumRadioButton = New System.Windows.Forms.RadioButton
        Me.LowRadioButton = New System.Windows.Forms.RadioButton
        Me.BFTCheckBox = New System.Windows.Forms.CheckBox
        Me.ECMCheckBox = New System.Windows.Forms.CheckBox
        Me.GroupBox1.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        Me.GroupBox3.SuspendLayout()
        Me.SuspendLayout()
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.radio33600)
        Me.GroupBox1.Controls.Add(Me.radio31200)
        Me.GroupBox1.Controls.Add(Me.radio28800)
        Me.GroupBox1.Controls.Add(Me.radio26400)
        Me.GroupBox1.Controls.Add(Me.radio24000)
        Me.GroupBox1.Controls.Add(Me.radio21600)
        Me.GroupBox1.Controls.Add(Me.radio19200)
        Me.GroupBox1.Controls.Add(Me.radio16800)
        Me.GroupBox1.Controls.Add(Me.radio14400)
        Me.GroupBox1.Controls.Add(Me.radio12000)
        Me.GroupBox1.Controls.Add(Me.radio9600)
        Me.GroupBox1.Controls.Add(Me.radio7200)
        Me.GroupBox1.Controls.Add(Me.radio4800)
        Me.GroupBox1.Controls.Add(Me.radio2400)
        Me.GroupBox1.Location = New System.Drawing.Point(144, 8)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(136, 160)
        Me.GroupBox1.TabIndex = 2
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Baud Rate"
        '
        'radio33600
        '
        Me.radio33600.Location = New System.Drawing.Point(72, 139)
        Me.radio33600.Name = "radio33600"
        Me.radio33600.Size = New System.Drawing.Size(56, 16)
        Me.radio33600.TabIndex = 27
        Me.radio33600.Text = "33600"
        '
        'radio31200
        '
        Me.radio31200.Location = New System.Drawing.Point(72, 119)
        Me.radio31200.Name = "radio31200"
        Me.radio31200.Size = New System.Drawing.Size(56, 16)
        Me.radio31200.TabIndex = 26
        Me.radio31200.Text = "31200"
        '
        'radio28800
        '
        Me.radio28800.Location = New System.Drawing.Point(72, 99)
        Me.radio28800.Name = "radio28800"
        Me.radio28800.Size = New System.Drawing.Size(56, 16)
        Me.radio28800.TabIndex = 25
        Me.radio28800.Text = "28800"
        '
        'radio26400
        '
        Me.radio26400.Location = New System.Drawing.Point(72, 79)
        Me.radio26400.Name = "radio26400"
        Me.radio26400.Size = New System.Drawing.Size(56, 16)
        Me.radio26400.TabIndex = 24
        Me.radio26400.Text = "26400"
        '
        'radio24000
        '
        Me.radio24000.Location = New System.Drawing.Point(72, 59)
        Me.radio24000.Name = "radio24000"
        Me.radio24000.Size = New System.Drawing.Size(56, 16)
        Me.radio24000.TabIndex = 23
        Me.radio24000.Text = "24000"
        '
        'radio21600
        '
        Me.radio21600.Location = New System.Drawing.Point(72, 39)
        Me.radio21600.Name = "radio21600"
        Me.radio21600.Size = New System.Drawing.Size(56, 16)
        Me.radio21600.TabIndex = 22
        Me.radio21600.Text = "21600"
        '
        'radio19200
        '
        Me.radio19200.Location = New System.Drawing.Point(72, 19)
        Me.radio19200.Name = "radio19200"
        Me.radio19200.Size = New System.Drawing.Size(56, 16)
        Me.radio19200.TabIndex = 21
        Me.radio19200.Text = "19200"
        '
        'radio16800
        '
        Me.radio16800.Location = New System.Drawing.Point(8, 139)
        Me.radio16800.Name = "radio16800"
        Me.radio16800.Size = New System.Drawing.Size(56, 16)
        Me.radio16800.TabIndex = 20
        Me.radio16800.Text = "16800"
        '
        'radio14400
        '
        Me.radio14400.Location = New System.Drawing.Point(8, 119)
        Me.radio14400.Name = "radio14400"
        Me.radio14400.Size = New System.Drawing.Size(56, 16)
        Me.radio14400.TabIndex = 19
        Me.radio14400.Text = "14400"
        '
        'radio12000
        '
        Me.radio12000.Location = New System.Drawing.Point(8, 99)
        Me.radio12000.Name = "radio12000"
        Me.radio12000.Size = New System.Drawing.Size(56, 16)
        Me.radio12000.TabIndex = 18
        Me.radio12000.Text = "12000"
        '
        'radio9600
        '
        Me.radio9600.Location = New System.Drawing.Point(8, 79)
        Me.radio9600.Name = "radio9600"
        Me.radio9600.Size = New System.Drawing.Size(48, 16)
        Me.radio9600.TabIndex = 17
        Me.radio9600.Text = "9600"
        '
        'radio7200
        '
        Me.radio7200.Location = New System.Drawing.Point(8, 59)
        Me.radio7200.Name = "radio7200"
        Me.radio7200.Size = New System.Drawing.Size(48, 16)
        Me.radio7200.TabIndex = 16
        Me.radio7200.Text = "7200"
        '
        'radio4800
        '
        Me.radio4800.Location = New System.Drawing.Point(8, 39)
        Me.radio4800.Name = "radio4800"
        Me.radio4800.Size = New System.Drawing.Size(48, 16)
        Me.radio4800.TabIndex = 15
        Me.radio4800.Text = "4800"
        '
        'radio2400
        '
        Me.radio2400.Location = New System.Drawing.Point(8, 19)
        Me.radio2400.Name = "radio2400"
        Me.radio2400.Size = New System.Drawing.Size(48, 16)
        Me.radio2400.TabIndex = 14
        Me.radio2400.Text = "2400"
        '
        'OKButton
        '
        Me.OKButton.Location = New System.Drawing.Point(160, 224)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.TabIndex = 6
        Me.OKButton.Text = "OK"
        '
        'CancelBtn
        '
        Me.CancelBtn.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CancelBtn.Location = New System.Drawing.Point(56, 224)
        Me.CancelBtn.Name = "CancelBtn"
        Me.CancelBtn.TabIndex = 5
        Me.CancelBtn.Text = "Cancel"
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.UntilRadioButton)
        Me.GroupBox2.Controls.Add(Me.OnRadioButton)
        Me.GroupBox2.Controls.Add(Me.OffRadioButton)
        Me.GroupBox2.Location = New System.Drawing.Point(8, 8)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(128, 96)
        Me.GroupBox2.TabIndex = 0
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Speaker Mode"
        '
        'UntilRadioButton
        '
        Me.UntilRadioButton.Location = New System.Drawing.Point(16, 69)
        Me.UntilRadioButton.Name = "UntilRadioButton"
        Me.UntilRadioButton.Size = New System.Drawing.Size(104, 16)
        Me.UntilRadioButton.TabIndex = 2
        Me.UntilRadioButton.Text = "Until Connected"
        '
        'OnRadioButton
        '
        Me.OnRadioButton.Location = New System.Drawing.Point(16, 44)
        Me.OnRadioButton.Name = "OnRadioButton"
        Me.OnRadioButton.Size = New System.Drawing.Size(40, 16)
        Me.OnRadioButton.TabIndex = 1
        Me.OnRadioButton.Text = "On"
        '
        'OffRadioButton
        '
        Me.OffRadioButton.Location = New System.Drawing.Point(16, 19)
        Me.OffRadioButton.Name = "OffRadioButton"
        Me.OffRadioButton.Size = New System.Drawing.Size(48, 16)
        Me.OffRadioButton.TabIndex = 0
        Me.OffRadioButton.Text = "Off"
        '
        'GroupBox3
        '
        Me.GroupBox3.Controls.Add(Me.HighRadioButton)
        Me.GroupBox3.Controls.Add(Me.MediumRadioButton)
        Me.GroupBox3.Controls.Add(Me.LowRadioButton)
        Me.GroupBox3.Location = New System.Drawing.Point(8, 112)
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.Size = New System.Drawing.Size(128, 96)
        Me.GroupBox3.TabIndex = 1
        Me.GroupBox3.TabStop = False
        Me.GroupBox3.Text = "Speaker Volume"
        '
        'HighRadioButton
        '
        Me.HighRadioButton.Location = New System.Drawing.Point(16, 70)
        Me.HighRadioButton.Name = "HighRadioButton"
        Me.HighRadioButton.Size = New System.Drawing.Size(48, 16)
        Me.HighRadioButton.TabIndex = 2
        Me.HighRadioButton.Text = "High"
        '
        'MediumRadioButton
        '
        Me.MediumRadioButton.Location = New System.Drawing.Point(16, 46)
        Me.MediumRadioButton.Name = "MediumRadioButton"
        Me.MediumRadioButton.Size = New System.Drawing.Size(76, 16)
        Me.MediumRadioButton.TabIndex = 1
        Me.MediumRadioButton.Text = "Medium"
        '
        'LowRadioButton
        '
        Me.LowRadioButton.Location = New System.Drawing.Point(16, 22)
        Me.LowRadioButton.Name = "LowRadioButton"
        Me.LowRadioButton.Size = New System.Drawing.Size(48, 16)
        Me.LowRadioButton.TabIndex = 0
        Me.LowRadioButton.Text = "Low"
        '
        'BFTCheckBox
        '
        Me.BFTCheckBox.Location = New System.Drawing.Point(152, 192)
        Me.BFTCheckBox.Name = "BFTCheckBox"
        Me.BFTCheckBox.Size = New System.Drawing.Size(88, 16)
        Me.BFTCheckBox.TabIndex = 4
        Me.BFTCheckBox.Text = "Enable BFT"
        '
        'ECMCheckBox
        '
        Me.ECMCheckBox.Location = New System.Drawing.Point(152, 176)
        Me.ECMCheckBox.Name = "ECMCheckBox"
        Me.ECMCheckBox.Size = New System.Drawing.Size(104, 16)
        Me.ECMCheckBox.TabIndex = 3
        Me.ECMCheckBox.Text = "Enable ECM"
        '
        'FaxConfig
        '
        Me.AcceptButton = Me.OKButton
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.CancelBtn
        Me.ClientSize = New System.Drawing.Size(290, 255)
        Me.Controls.Add(Me.BFTCheckBox)
        Me.Controls.Add(Me.ECMCheckBox)
        Me.Controls.Add(Me.GroupBox3)
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.CancelBtn)
        Me.Controls.Add(Me.OKButton)
        Me.Controls.Add(Me.GroupBox1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "FaxConfig"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Fax Configuration"
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox3.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Declare Function GetProfileInt Lib "kernel32" Alias _
    "GetProfileIntA" _
    (ByVal lpszSection As String, _
    ByVal lpszEntry As String, _
    ByVal nDefault As Integer) As Integer
    Private Sub FaxConfig_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim index As Integer
        Dim nBaud As Integer

        index = pparent.SpeakerMode
        Select Case index
            Case 0 : OnRadioButton.Checked = True
            Case 1 : OffRadioButton.Checked = True
            Case 2 : UntilRadioButton.Checked = True
        End Select

        index = pparent.SpeakerVolume
        Select Case index
            Case 0 : LowRadioButton.Checked = True
            Case 1 : MediumRadioButton.Checked = True
            Case 2 : HighRadioButton.Checked = True
        End Select

        ' Baudrate
        nBaud = pparent.BaudRate - 2

        Select Case nBaud
            Case 0
                radio2400.Checked = True
            Case 1
                radio4800.Checked = True
            Case 2
                radio7200.Checked = True
            Case 3
                radio9600.Checked = True
            Case 4
                radio12000.Checked = True
            Case 5
                radio14400.Checked = True
            Case 6
                radio16800.Checked = True
            Case 7
                radio19200.Checked = True
            Case 8
                radio21600.Checked = True
            Case 9
                radio24000.Checked = True
            Case 10
                radio26400.Checked = True
            Case 11
                radio28800.Checked = True
            Case 12
                radio31200.Checked = True
            Case 13
                radio33600.Checked = True
        End Select

        If pparent.EnableECM = 3 Then
            ECMCheckBox.Checked = True
        ElseIf pparent.EnableECM = 2 Then
            ECMCheckBox.Checked = False
        End If

        If pparent.EnableBFT = 3 Then
            BFTCheckBox.Checked = True
        ElseIf pparent.EnableBFT = 2 Then
            BFTCheckBox.Checked = False
        End If

    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click
        Dim index As Integer

        If OffRadioButton.Checked Then
            index = 0
        ElseIf OnRadioButton.Checked Then
            index = 1
        ElseIf UntilRadioButton.Checked Then
            index = 2
        End If

        pparent.SpeakerMode = index

        If LowRadioButton.Checked Then
            index = 0
        ElseIf MediumRadioButton.Checked Then
            index = 1
        ElseIf HighRadioButton.Checked Then
            index = 2
        End If
        pparent.SpeakerVolume = index

        If ECMCheckBox.Checked Then
            pparent.EnableECM = 3
        Else
            pparent.EnableECM = 2
        End If

        If BFTCheckBox.Checked Then
            pparent.EnableBFT = 3
        Else
            pparent.EnableBFT = 2
        End If


        If (radio2400.Checked) Then
            index = 0
        ElseIf (radio4800.Checked) Then
            index = 1
        ElseIf (radio7200.Checked) Then
            index = 2
        ElseIf (radio9600.Checked) Then
            index = 3
        ElseIf (radio12000.Checked) Then
            index = 4
        ElseIf (radio14400.Checked) Then
            index = 5
        ElseIf (radio16800.Checked) Then
            index = 6
        ElseIf (radio19200.Checked) Then
            index = 7
        ElseIf (radio21600.Checked) Then
            index = 8
        ElseIf (radio24000.Checked) Then
            index = 9
        ElseIf (radio26400.Checked) Then
            index = 10
        ElseIf (radio28800.Checked) Then
            index = 11
        ElseIf (radio31200.Checked) Then
            index = 12
        ElseIf (radio33600.Checked) Then
            index = 13
        End If

        pparent.BaudRate = index + 2

        pparent.FAX1.SetSpeakerMode(pparent.ActualFaxPort, pparent.SpeakerMode, pparent.SpeakerVolume)
        pparent.FAX1.SetPortCapability(pparent.ActualFaxPort, 10, pparent.BaudRate)
        pparent.FAX1.SetPortCapability(pparent.ActualFaxPort, 3, pparent.EnableECM)
        pparent.FAX1.SetPortCapability(pparent.ActualFaxPort, 4, pparent.EnableBFT)

        Close()
    End Sub

    Private Sub CancelBtn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelBtn.Click
        Close()
    End Sub

End Class
