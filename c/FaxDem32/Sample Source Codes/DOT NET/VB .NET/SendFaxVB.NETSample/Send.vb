Public Class Send
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
    Friend WithEvents Button2 As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents PhoneTextBox As System.Windows.Forms.TextBox
    Friend WithEvents FileTextBox As System.Windows.Forms.TextBox
    Friend WithEvents BrowseButton As System.Windows.Forms.Button
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog
    Friend WithEvents FaxPortsListBox As System.Windows.Forms.ListBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents SendOK As System.Windows.Forms.Button
    Friend WithEvents ImmediateButton As System.Windows.Forms.RadioButton
    Friend WithEvents QueueButton As System.Windows.Forms.RadioButton
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.SendOK = New System.Windows.Forms.Button
        Me.Button2 = New System.Windows.Forms.Button
        Me.Label1 = New System.Windows.Forms.Label
        Me.PhoneTextBox = New System.Windows.Forms.TextBox
        Me.FileTextBox = New System.Windows.Forms.TextBox
        Me.BrowseButton = New System.Windows.Forms.Button
        Me.OpenFileDialog1 = New System.Windows.Forms.OpenFileDialog
        Me.FaxPortsListBox = New System.Windows.Forms.ListBox
        Me.Label4 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.ImmediateButton = New System.Windows.Forms.RadioButton
        Me.QueueButton = New System.Windows.Forms.RadioButton
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SendOK
        '
        Me.SendOK.Location = New System.Drawing.Point(88, 176)
        Me.SendOK.Name = "SendOK"
        Me.SendOK.TabIndex = 5
        Me.SendOK.Text = "OK"
        '
        'Button2
        '
        Me.Button2.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Button2.Location = New System.Drawing.Point(189, 176)
        Me.Button2.Name = "Button2"
        Me.Button2.TabIndex = 6
        Me.Button2.Text = "Cancel"
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(8, 112)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(72, 16)
        Me.Label1.TabIndex = 2
        Me.Label1.Text = "Fax Number:"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'PhoneTextBox
        '
        Me.PhoneTextBox.Location = New System.Drawing.Point(80, 112)
        Me.PhoneTextBox.MaxLength = 32
        Me.PhoneTextBox.Name = "PhoneTextBox"
        Me.PhoneTextBox.Size = New System.Drawing.Size(184, 20)
        Me.PhoneTextBox.TabIndex = 0
        Me.PhoneTextBox.Text = ""
        '
        'FileTextBox
        '
        Me.FileTextBox.Location = New System.Drawing.Point(80, 144)
        Me.FileTextBox.MaxLength = 255
        Me.FileTextBox.Name = "FileTextBox"
        Me.FileTextBox.Size = New System.Drawing.Size(184, 20)
        Me.FileTextBox.TabIndex = 3
        Me.FileTextBox.Text = ""
        '
        'BrowseButton
        '
        Me.BrowseButton.Location = New System.Drawing.Point(272, 144)
        Me.BrowseButton.Name = "BrowseButton"
        Me.BrowseButton.Size = New System.Drawing.Size(88, 23)
        Me.BrowseButton.TabIndex = 4
        Me.BrowseButton.Text = "Browse"
        '
        'FaxPortsListBox
        '
        Me.FaxPortsListBox.Location = New System.Drawing.Point(8, 32)
        Me.FaxPortsListBox.Name = "FaxPortsListBox"
        Me.FaxPortsListBox.Size = New System.Drawing.Size(256, 69)
        Me.FaxPortsListBox.TabIndex = 1
        '
        'Label4
        '
        Me.Label4.Location = New System.Drawing.Point(8, 144)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(72, 16)
        Me.Label4.TabIndex = 11
        Me.Label4.Text = "File To Send:"
        Me.Label4.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label3
        '
        Me.Label3.Location = New System.Drawing.Point(8, 8)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(72, 16)
        Me.Label3.TabIndex = 15
        Me.Label3.Text = "Fax Ports:"
        Me.Label3.TextAlign = System.Drawing.ContentAlignment.BottomLeft
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.ImmediateButton)
        Me.GroupBox1.Controls.Add(Me.QueueButton)
        Me.GroupBox1.Location = New System.Drawing.Point(272, 28)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(88, 104)
        Me.GroupBox1.TabIndex = 2
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Send"
        '
        'ImmediateButton
        '
        Me.ImmediateButton.Location = New System.Drawing.Point(8, 61)
        Me.ImmediateButton.Name = "ImmediateButton"
        Me.ImmediateButton.Size = New System.Drawing.Size(75, 24)
        Me.ImmediateButton.TabIndex = 1
        Me.ImmediateButton.Text = "Immediate"
        '
        'QueueButton
        '
        Me.QueueButton.Checked = True
        Me.QueueButton.Location = New System.Drawing.Point(8, 24)
        Me.QueueButton.Name = "QueueButton"
        Me.QueueButton.Size = New System.Drawing.Size(56, 24)
        Me.QueueButton.TabIndex = 0
        Me.QueueButton.TabStop = True
        Me.QueueButton.Text = "Queue"
        '
        'Send
        '
        Me.AcceptButton = Me.SendOK
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.Button2
        Me.ClientSize = New System.Drawing.Size(370, 207)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.FaxPortsListBox)
        Me.Controls.Add(Me.BrowseButton)
        Me.Controls.Add(Me.FileTextBox)
        Me.Controls.Add(Me.PhoneTextBox)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.Button2)
        Me.Controls.Add(Me.SendOK)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "Send"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Send a File"
        Me.GroupBox1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button2.Click
        Close()
    End Sub

    Private Sub BrowseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BrowseButton.Click
        Dim szFilter$
        szFilter = "TIFF File Format (*.tif)" + "|" + "*.tif"
        OpenFileDialog1.Filter = szFilter
        If OpenFileDialog1.ShowDialog() = System.Windows.Forms.DialogResult.OK Then
            FileTextBox.Text = OpenFileDialog1.FileName
        End If
    End Sub

    Private Sub SendOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SendOK.Click
        Static FaxID As Long
        Static errorsend As Long
        Static errStr As String
        Static PageNum As Short
        Dim bOK As Boolean
        Dim ext As String
        Dim i As Short
        Dim notNumber As Boolean
        Dim PhoneNum As String
        Dim actualchar As Char
        bOK = True
        notNumber = False
        PhoneNum = PhoneTextBox.Text
        i = 0
        While (i < PhoneNum.Length And notNumber = False)
            actualchar = PhoneNum.Chars(i)
            If (Char.IsDigit(actualchar) = False And Not (actualchar.ToString = ",")) Then
                notNumber = True
            End If
            i += 1
        End While
        If (PhoneTextBox.Text.Length = 0 Or notNumber = True) Then
            If (notNumber = True) Then
                MsgBox("The given phone number is incorrect.")
            Else : MsgBox("You must specify the phone number.")
            End If
            PhoneTextBox.Focus()
            PhoneTextBox.SelectAll()
            Exit Sub
        End If

        If Not System.IO.File.Exists(FileTextBox.Text) Then
            MsgBox("You must specify an existing file to send.")
            FileTextBox.Focus()
            FileTextBox.SelectAll()
            Exit Sub
        End If

        ext = FileTextBox.Text.Substring(FileTextBox.Text.Length - 3, 3).ToUpper

        If ext = "TIF" Then
            PageNum = pparent.FAX1.GetNumberOfImages(FileTextBox.Text, 6)
        Else
            MsgBox("You must specify a TIFF file!")
            FileTextBox.Focus()
            FileTextBox.SelectAll()
            Exit Sub
        End If

        pparent.FAX1.PageFileName = FileTextBox.Text

        If pparent.FAX1.IsDemoVersion() And (PageNum > 1) Then
            MessageBox.Show("The DEMO version of the Fax OCX supports only 1 page faxes. ONLY the first page will be sent.", "Error")
            PageNum = 1
        End If

        FaxID = pparent.FAX1.CreateFaxObject(1, PageNum, 3, 2, 1, 2, 2, 1, 2, 1)
        If (FaxID = 0) Then
            errStr = "Can't create fax object ! Error code : " + Str(pparent.FAX1.FaxError)
            MsgBox(errStr, vbOKOnly)
        Else
            pparent.FAX1.SetFaxParam(FaxID, 9, PageNum)
            pparent.FAX1.SetPhoneNumber(FaxID, PhoneTextBox.Text)
            For i = 1 To PageNum
                If (pparent.FAX1.SetFaxPage(FaxID, i, 17, i)) Then
                    errStr = "Can't set fax page ! Error code : " + Str(pparent.FAX1.FaxError)
                    bOK = False
                    MsgBox(errStr, vbOKOnly)
                    Exit For
                End If
            Next i
            If bOK Then
                errorsend = 0
                If ImmediateButton.Checked = True Then
                    errorsend = pparent.FAX1.SendNow(FaxPortsListBox.SelectedItem, FaxID)
                ElseIf QueueButton.Checked = True Then
                    errorsend = pparent.FAX1.SendFaxObj(FaxID)
                    If (errorsend) Then
                        pparent.FAX1.ClearFaxObject(FaxID)
                        errStr = "Can't send fax ! Error code : " + Str(errorsend)
                        MsgBox(errStr, vbOKOnly)
                    End If
                End If

            End If
        End If
        Close()
    End Sub
    Friend WithEvents Label4 As System.Windows.Forms.Label

    Private Sub Send_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim j As Integer ', portindex, spaceindex As Integer
        Dim t1, t2 As String
        Dim flag As Boolean
        t1 = pparent.FAX1.PortsOpen
        If (Len(t1) > 0) Then
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
                FaxPortsListBox.Items.Add(t2)
            End While
        End If
        FileTextBox.Text = "Test.tif"
        FaxPortsListBox.SetSelected(0, True)
        PhoneTextBox.Focus()
    End Sub
End Class
