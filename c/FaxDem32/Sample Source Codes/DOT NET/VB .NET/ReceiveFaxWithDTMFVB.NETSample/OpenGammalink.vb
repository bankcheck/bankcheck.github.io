Public Class OpenGammalink
    Inherits System.Windows.Forms.Form
    Public pparent As Form1
    Private DTMF As String

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
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents FileTextBox As System.Windows.Forms.TextBox
    Friend WithEvents BrowseButton As System.Windows.Forms.Button
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog
    Friend WithEvents CancelBtn As System.Windows.Forms.Button
    Friend WithEvents DTMFGamma As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.PortList = New System.Windows.Forms.ListBox
        Me.OKButton = New System.Windows.Forms.Button
        Me.CancelBtn = New System.Windows.Forms.Button
        Me.Label1 = New System.Windows.Forms.Label
        Me.FileTextBox = New System.Windows.Forms.TextBox
        Me.BrowseButton = New System.Windows.Forms.Button
        Me.OpenFileDialog1 = New System.Windows.Forms.OpenFileDialog
        Me.DTMFGamma = New System.Windows.Forms.TextBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.PortList)
        Me.GroupBox1.Location = New System.Drawing.Point(8, 8)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(184, 104)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Available Channels"
        '
        'PortList
        '
        Me.PortList.Location = New System.Drawing.Point(8, 16)
        Me.PortList.Name = "PortList"
        Me.PortList.Size = New System.Drawing.Size(168, 82)
        Me.PortList.TabIndex = 0
        '
        'OKButton
        '
        Me.OKButton.Location = New System.Drawing.Point(200, 16)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(80, 24)
        Me.OKButton.TabIndex = 4
        Me.OKButton.Text = "OK"
        '
        'CancelBtn
        '
        Me.CancelBtn.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CancelBtn.Location = New System.Drawing.Point(200, 52)
        Me.CancelBtn.Name = "CancelBtn"
        Me.CancelBtn.Size = New System.Drawing.Size(80, 24)
        Me.CancelBtn.TabIndex = 5
        Me.CancelBtn.Text = "Cancel"
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(8, 122)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(64, 16)
        Me.Label1.TabIndex = 4
        Me.Label1.Text = "Config File:"
        '
        'FileTextBox
        '
        Me.FileTextBox.Location = New System.Drawing.Point(80, 120)
        Me.FileTextBox.MaxLength = 255
        Me.FileTextBox.Name = "FileTextBox"
        Me.FileTextBox.Size = New System.Drawing.Size(200, 20)
        Me.FileTextBox.TabIndex = 1
        Me.FileTextBox.Text = ""
        '
        'BrowseButton
        '
        Me.BrowseButton.Location = New System.Drawing.Point(200, 146)
        Me.BrowseButton.Name = "BrowseButton"
        Me.BrowseButton.Size = New System.Drawing.Size(80, 24)
        Me.BrowseButton.TabIndex = 2
        Me.BrowseButton.Text = "&Browse"
        '
        'OpenFileDialog1
        '
        Me.OpenFileDialog1.DefaultExt = "cfg"
        Me.OpenFileDialog1.Filter = "Config Files (*.cfg)|*.cfg|All Files (*.*)|*.*"
        Me.OpenFileDialog1.Title = "Open the Config File"
        '
        'DTMFGamma
        '
        Me.DTMFGamma.Location = New System.Drawing.Point(80, 146)
        Me.DTMFGamma.MaxLength = 1
        Me.DTMFGamma.Name = "DTMFGamma"
        Me.DTMFGamma.Size = New System.Drawing.Size(17, 20)
        Me.DTMFGamma.TabIndex = 3
        Me.DTMFGamma.Text = "4"
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(8, 148)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(72, 16)
        Me.Label2.TabIndex = 16
        Me.Label2.Text = "DTMF Digits:"
        '
        'OpenGammalink
        '
        Me.AcceptButton = Me.OKButton
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.CancelBtn
        Me.ClientSize = New System.Drawing.Size(290, 183)
        Me.Controls.Add(Me.DTMFGamma)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.FileTextBox)
        Me.Controls.Add(Me.BrowseButton)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.CancelBtn)
        Me.Controls.Add(Me.OKButton)
        Me.Controls.Add(Me.GroupBox1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "OpenGammalink"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Open Gammalink Channel"
        Me.GroupBox1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub OpenGammalink_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Static t1, t2 As String
        Static flag As Boolean
        Static j As Integer

        FileTextBox.Text = pparent.FAX1.GammaCFile
        t1 = pparent.FAX1.AvailableGammaChannels
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
    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click
        Static errcode As Long
        Static i As Integer

        Cursor = Cursors.WaitCursor
        Enabled = False
        If (Len(DTMFGamma.Text) = 0) Then
            MsgBox("You must specify the number of the DTMF digits!")
            DTMFGamma.Focus()
            Enabled = True
            Cursor = Cursors.Default
            Exit Sub
        End If
        pparent.FAX1.GammaCFile = FileTextBox.Text
        errcode = pparent.FAX1.OpenPort(PortList.SelectedItem)
        If errcode Then
            i = MsgBox(pparent.Errors(errcode), 0)
            Enabled = True
            Cursor = Cursors.Default
            Exit Sub
        Else
            pparent.FAX1.RecvDTMF(PortList.SelectedItem, CShort(DTMFGamma.Text), 20)
            pparent.MenuClosePort.Enabled = True
            pparent.MessageBox.Items.Add(PortList.SelectedItem + " was opened")
            pparent.FAX1.SetPortCapability(PortList.SelectedItem, 10, 15)
        End If

        If (Len(pparent.FAX1.AvailableGammaChannels) > 0) Then
            pparent.MenuGammalink.Enabled = True
        Else
            pparent.MenuGammalink.Enabled = False
        End If

        Cursor = Cursors.Default
        Enabled = True
        Close()
    End Sub

    Private Sub BrowseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BrowseButton.Click
        If OpenFileDialog1.ShowDialog() = System.Windows.Forms.DialogResult.OK Then
            FileTextBox.Text = OpenFileDialog1.FileName
        End If
    End Sub

    Private Sub CancelBtn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelBtn.Click
        Close()
    End Sub

    Private Sub DTMFGamma_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DTMFGamma.TextChanged
        If (DTMFGamma.Text.Length > 0) Then
            If (Not Char.IsDigit(DTMFGamma.Text.Chars(0))) Then
                DTMFGamma.Text = DTMF
                DTMFGamma.SelectAll()
            End If
        End If
    End Sub

    Private Sub DTMFGamma_KeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) Handles DTMFGamma.KeyPress
        DTMF = DTMFGamma.Text
    End Sub
End Class
