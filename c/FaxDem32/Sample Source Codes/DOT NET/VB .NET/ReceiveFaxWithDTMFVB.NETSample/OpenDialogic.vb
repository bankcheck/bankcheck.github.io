Public Class OpenDialogic
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
    Friend WithEvents CancelBtn As System.Windows.Forms.Button
    Friend WithEvents DTMFDialogic As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.PortList = New System.Windows.Forms.ListBox
        Me.OKButton = New System.Windows.Forms.Button
        Me.CancelBtn = New System.Windows.Forms.Button
        Me.DTMFDialogic = New System.Windows.Forms.TextBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.PortList)
        Me.GroupBox1.Location = New System.Drawing.Point(8, 8)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(168, 144)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Available Dialogic Channels"
        '
        'PortList
        '
        Me.PortList.Location = New System.Drawing.Point(8, 16)
        Me.PortList.Name = "PortList"
        Me.PortList.Size = New System.Drawing.Size(152, 121)
        Me.PortList.TabIndex = 0
        '
        'OKButton
        '
        Me.OKButton.Location = New System.Drawing.Point(184, 48)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.TabIndex = 2
        Me.OKButton.Text = "&OK"
        '
        'CancelBtn
        '
        Me.CancelBtn.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CancelBtn.Location = New System.Drawing.Point(184, 88)
        Me.CancelBtn.Name = "CancelBtn"
        Me.CancelBtn.TabIndex = 3
        Me.CancelBtn.Text = "&Cancel"
        '
        'DTMFDialogic
        '
        Me.DTMFDialogic.Location = New System.Drawing.Point(80, 158)
        Me.DTMFDialogic.MaxLength = 1
        Me.DTMFDialogic.Name = "DTMFDialogic"
        Me.DTMFDialogic.Size = New System.Drawing.Size(17, 20)
        Me.DTMFDialogic.TabIndex = 1
        Me.DTMFDialogic.Text = "4"
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(8, 160)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(72, 16)
        Me.Label2.TabIndex = 14
        Me.Label2.Text = "DTMF Digits:"
        '
        'OpenDialogic
        '
        Me.AcceptButton = Me.OKButton
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.CancelBtn
        Me.ClientSize = New System.Drawing.Size(266, 183)
        Me.Controls.Add(Me.DTMFDialogic)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.CancelBtn)
        Me.Controls.Add(Me.OKButton)
        Me.Controls.Add(Me.GroupBox1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "OpenDialogic"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Open Dialogic Channel"
        Me.GroupBox1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub OpenDialogic_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Static t1, t2 As String
        Static flag As Boolean
        Static j As Integer

        t1 = pparent.FAX1.AvailableDialogicChannels
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

        If (DTMFDialogic.Text.Length = 0) Then
            MsgBox("You must specify the number of the DTMF digits!")
            DTMFDialogic.Focus()
            Cursor = Cursors.Default
            Enabled = True
            Exit Sub
        End If
        errcode = pparent.FAX1.OpenPort(PortList.SelectedItem)
        If errcode Then
            i = MsgBox(pparent.Errors(errcode), 0)
            Enabled = True
            Cursor = Cursors.Default
            Exit Sub
        Else
            pparent.FAX1.RecvDTMF(PortList.SelectedItem, CShort(DTMFDialogic.Text), 20)
            pparent.MenuClosePort.Enabled = True
            pparent.MessageBox.Items.Add(PortList.SelectedItem + " was opened")
            pparent.FAX1.SetPortCapability(PortList.SelectedItem, 10, 15)
        End If

        If (Len(pparent.FAX1.AvailableDialogicChannels) > 0) Then
            pparent.MenuDialogic.Enabled = True
        Else
            pparent.MenuDialogic.Enabled = False
        End If

        Cursor = Cursors.Default
        Enabled = True
        Close()
    End Sub

    Private Sub CancelBtn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelBtn.Click
        Close()
    End Sub

    Private Sub DTMFDialogic_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DTMFDialogic.TextChanged
        If (DTMFDialogic.Text.Length > 0) Then
            If (Not Char.IsDigit(DTMFDialogic.Text.Chars(0))) Then
                DTMFDialogic.Text = DTMF
                DTMFDialogic.SelectAll()
            End If
        End If
    End Sub

    Private Sub DTMFDialogic_KeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) Handles DTMFDialogic.KeyPress
        DTMF = DTMFDialogic.Text
    End Sub
End Class
