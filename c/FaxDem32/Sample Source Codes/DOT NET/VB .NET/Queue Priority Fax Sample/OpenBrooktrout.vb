Public Class OpenBrooktrout
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
    Friend WithEvents PortList As System.Windows.Forms.ListBox
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog
    Friend WithEvents CancelBtn As System.Windows.Forms.Button
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents FileName As System.Windows.Forms.TextBox
    Friend WithEvents BrowseButton As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents DTMFCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents HeaderCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents BrLocalID As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.PortList = New System.Windows.Forms.ListBox
        Me.OKButton = New System.Windows.Forms.Button
        Me.CancelBtn = New System.Windows.Forms.Button
        Me.OpenFileDialog1 = New System.Windows.Forms.OpenFileDialog
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.BrLocalID = New System.Windows.Forms.TextBox
        Me.BrowseButton = New System.Windows.Forms.Button
        Me.Label1 = New System.Windows.Forms.Label
        Me.DTMFCheckBox = New System.Windows.Forms.CheckBox
        Me.HeaderCheckBox = New System.Windows.Forms.CheckBox
        Me.FileName = New System.Windows.Forms.TextBox
        Me.GroupBox1.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        Me.SuspendLayout()
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.PortList)
        Me.GroupBox1.Location = New System.Drawing.Point(8, 8)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(176, 128)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Available Channels"
        '
        'PortList
        '
        Me.PortList.Location = New System.Drawing.Point(8, 24)
        Me.PortList.Name = "PortList"
        Me.PortList.Size = New System.Drawing.Size(160, 95)
        Me.PortList.TabIndex = 0
        '
        'OKButton
        '
        Me.OKButton.Location = New System.Drawing.Point(192, 16)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.TabIndex = 6
        Me.OKButton.Text = "&OK"
        '
        'CancelBtn
        '
        Me.CancelBtn.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CancelBtn.Location = New System.Drawing.Point(192, 48)
        Me.CancelBtn.Name = "CancelBtn"
        Me.CancelBtn.TabIndex = 7
        Me.CancelBtn.Text = "&Cancel"
        '
        'OpenFileDialog1
        '
        Me.OpenFileDialog1.DefaultExt = "cfg"
        Me.OpenFileDialog1.Filter = "Config File (*.cfg)|*.cfg|All Files (*.*)|*.*"
        Me.OpenFileDialog1.Title = "Open Config File"
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.Label2)
        Me.GroupBox2.Controls.Add(Me.BrLocalID)
        Me.GroupBox2.Controls.Add(Me.BrowseButton)
        Me.GroupBox2.Controls.Add(Me.Label1)
        Me.GroupBox2.Controls.Add(Me.DTMFCheckBox)
        Me.GroupBox2.Controls.Add(Me.HeaderCheckBox)
        Me.GroupBox2.Controls.Add(Me.FileName)
        Me.GroupBox2.Location = New System.Drawing.Point(8, 144)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(272, 128)
        Me.GroupBox2.TabIndex = 8
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Channel settings"
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(10, 77)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(51, 16)
        Me.Label2.TabIndex = 13
        Me.Label2.Text = "Local ID:"
        '
        'BrLocalID
        '
        Me.BrLocalID.Location = New System.Drawing.Point(76, 75)
        Me.BrLocalID.MaxLength = 60
        Me.BrLocalID.Name = "BrLocalID"
        Me.BrLocalID.Size = New System.Drawing.Size(184, 20)
        Me.BrLocalID.TabIndex = 3
        Me.BrLocalID.Text = ""
        '
        'BrowseButton
        '
        Me.BrowseButton.Location = New System.Drawing.Point(186, 45)
        Me.BrowseButton.Name = "BrowseButton"
        Me.BrowseButton.TabIndex = 2
        Me.BrowseButton.Text = "&Browse"
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(10, 21)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(64, 16)
        Me.Label1.TabIndex = 10
        Me.Label1.Text = "Config File:"
        '
        'DTMFCheckBox
        '
        Me.DTMFCheckBox.Location = New System.Drawing.Point(212, 101)
        Me.DTMFCheckBox.Name = "DTMFCheckBox"
        Me.DTMFCheckBox.Size = New System.Drawing.Size(56, 16)
        Me.DTMFCheckBox.TabIndex = 5
        Me.DTMFCheckBox.Text = "DTMF"
        '
        'HeaderCheckBox
        '
        Me.HeaderCheckBox.Location = New System.Drawing.Point(76, 101)
        Me.HeaderCheckBox.Name = "HeaderCheckBox"
        Me.HeaderCheckBox.Size = New System.Drawing.Size(104, 16)
        Me.HeaderCheckBox.TabIndex = 4
        Me.HeaderCheckBox.Text = "Create Header"
        '
        'FileName
        '
        Me.FileName.Location = New System.Drawing.Point(76, 19)
        Me.FileName.MaxLength = 255
        Me.FileName.Name = "FileName"
        Me.FileName.Size = New System.Drawing.Size(184, 20)
        Me.FileName.TabIndex = 1
        Me.FileName.Text = ""
        '
        'OpenBrooktrout
        '
        Me.AcceptButton = Me.OKButton
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.CancelBtn
        Me.ClientSize = New System.Drawing.Size(290, 279)
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.CancelBtn)
        Me.Controls.Add(Me.OKButton)
        Me.Controls.Add(Me.GroupBox1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "OpenBrooktrout"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Open Brooktrout Channel"
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox2.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Declare Function GetPrivateProfileString Lib "kernel32" Alias _
    "GetPrivateProfileStringA" _
    (ByVal lpApplicationName As String, _
    ByVal lpKeyName As String, _
    ByVal lpDefault As String, _
    ByVal lpReturnedString As String, _
    ByVal nSize As Integer, _
    ByVal lpFileName As String) As Integer

    Declare Function WritePrivateProfileString Lib "kernel32" Alias _
    "WritePrivateProfileStringA" _
    (ByVal lpApplicationName As String, _
    ByVal lpKeyName As String, _
    ByVal lpString As String, _
    ByVal lpFileName As String) As Integer

    Private Sub OpenBrooktrout_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Static t1, t2 As String
        Static flag As Boolean
        Static j As Integer
        Dim configFile As String

        t1 = pparent.FAX1.AvailableBrooktroutChannels
        flag = True
        While flag
            j = t1.IndexOf(" ")
            If (j = -1) Then
                t2 = t1
                flag = False
            Else
                t2 = t1.Substring(0, j)
                t1 = t1.Remove(0, j + 1)
            End If
            PortList.Items.Add(t2)
        End While

        PortList.SetSelected(0, True)

        If (pparent.FAX1.Header) Then
            HeaderCheckBox.Checked = 1
        Else
            HeaderCheckBox.Checked = 0
        End If
        If (pparent.EnableDTMF) Then
            DTMFCheckBox.Checked = True
        Else
            DTMFCheckBox.Checked = False
        End If
        BrLocalID.Text = pparent.FAX1.LocalID
        configFile = New String(Chr(0), 200)
        GetPrivateProfileString("Brooktrout", "Config file", "btcall.cfg", configFile, 200, "Demo32.ini")
        FileName.Text = configFile
    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click
        Static errcode As Long
        Static i As Integer

        Cursor = Cursors.WaitCursor
        Enabled = False
        If (DTMFCheckBox.Checked = True) Then
            pparent.EnableDTMF = True
        Else
            pparent.EnableDTMF = False
        End If
        pparent.FAX1.LocalID = BrLocalID.Text
        pparent.FAX1.BrooktroutCFile = FileName.Text
        WritePrivateProfileString("Brooktrout", "Config file", pparent.FAX1.BrooktroutCFile, "Demo32.ini")
        pparent.ActualFaxPort = PortList.SelectedItem
        errcode = pparent.FAX1.OpenPort(PortList.SelectedItem)
        If errcode Then
            i = MsgBox(pparent.Errors(errcode), 0)
            Enabled = True
            Cursor = Cursors.Default
            Exit Sub
        Else
            If DTMFCheckBox.Checked = 1 Then
                pparent.FAX1.RecvDTMF(PortList.SelectedItem, 5, 20)
            End If
            pparent.MenuClosePort.Enabled = True
            pparent.MenuShowManager.Enabled = True
            pparent.MenuSend.Enabled = True
            pparent.MessageBox.Items.Add(PortList.SelectedItem + " was opened")
            pparent.FAX1.Header = HeaderCheckBox.Checked
            pparent.FAX1.SetPortCapability(pparent.ActualFaxPort, 10, pparent.BaudRate)
        End If

        If (Len(pparent.FAX1.AvailableBrooktroutChannels) > 0) Then
            pparent.MenuBrooktrout.Enabled = True
        Else
            pparent.MenuBrooktrout.Enabled = False
        End If

        Cursor = Cursors.Default
        Enabled = True
        Close()
    End Sub

    Private Sub CancelBtn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelBtn.Click
        Close()
    End Sub

    Private Sub BrowseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BrowseButton.Click
        If OpenFileDialog1.ShowDialog() = System.Windows.Forms.DialogResult.OK Then
            FileName.Text = OpenFileDialog1.FileName
        End If
    End Sub
End Class
