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
    Friend WithEvents Group4Button As System.Windows.Forms.RadioButton
    Friend WithEvents Group32DButton As System.Windows.Forms.RadioButton
    Friend WithEvents ColorFaxButton As System.Windows.Forms.RadioButton
    Friend WithEvents Group31DButton As System.Windows.Forms.RadioButton
    Friend WithEvents NoCompressionButton As System.Windows.Forms.RadioButton
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
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.Group4Button = New System.Windows.Forms.RadioButton
        Me.Group32DButton = New System.Windows.Forms.RadioButton
        Me.ColorFaxButton = New System.Windows.Forms.RadioButton
        Me.Group31DButton = New System.Windows.Forms.RadioButton
        Me.NoCompressionButton = New System.Windows.Forms.RadioButton
        Me.Label3 = New System.Windows.Forms.Label
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.ImmediateButton = New System.Windows.Forms.RadioButton
        Me.QueueButton = New System.Windows.Forms.RadioButton
        Me.GroupBox2.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SendOK
        '
        Me.SendOK.Location = New System.Drawing.Point(380, 16)
        Me.SendOK.Name = "SendOK"
        Me.SendOK.TabIndex = 1
        Me.SendOK.Text = "OK"
        '
        'Button2
        '
        Me.Button2.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Button2.Location = New System.Drawing.Point(380, 48)
        Me.Button2.Name = "Button2"
        Me.Button2.TabIndex = 1
        Me.Button2.Text = "Cancel"
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(8, 136)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(72, 16)
        Me.Label1.TabIndex = 2
        Me.Label1.Text = "Fax Number:"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'PhoneTextBox
        '
        Me.PhoneTextBox.Location = New System.Drawing.Point(80, 136)
        Me.PhoneTextBox.MaxLength = 32
        Me.PhoneTextBox.Name = "PhoneTextBox"
        Me.PhoneTextBox.Size = New System.Drawing.Size(160, 20)
        Me.PhoneTextBox.TabIndex = 0
        Me.PhoneTextBox.Text = ""
        '
        'FileTextBox
        '
        Me.FileTextBox.Location = New System.Drawing.Point(80, 176)
        Me.FileTextBox.MaxLength = 255
        Me.FileTextBox.Name = "FileTextBox"
        Me.FileTextBox.Size = New System.Drawing.Size(288, 20)
        Me.FileTextBox.TabIndex = 5
        Me.FileTextBox.Text = ""
        '
        'BrowseButton
        '
        Me.BrowseButton.Location = New System.Drawing.Point(380, 175)
        Me.BrowseButton.Name = "BrowseButton"
        Me.BrowseButton.TabIndex = 6
        Me.BrowseButton.Text = "Browse"
        '
        'FaxPortsListBox
        '
        Me.FaxPortsListBox.Location = New System.Drawing.Point(8, 32)
        Me.FaxPortsListBox.Name = "FaxPortsListBox"
        Me.FaxPortsListBox.Size = New System.Drawing.Size(232, 82)
        Me.FaxPortsListBox.TabIndex = 7
        '
        'Label4
        '
        Me.Label4.Location = New System.Drawing.Point(8, 176)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(72, 16)
        Me.Label4.TabIndex = 11
        Me.Label4.Text = "File To Send:"
        Me.Label4.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.Group4Button)
        Me.GroupBox2.Controls.Add(Me.Group32DButton)
        Me.GroupBox2.Controls.Add(Me.ColorFaxButton)
        Me.GroupBox2.Controls.Add(Me.Group31DButton)
        Me.GroupBox2.Controls.Add(Me.NoCompressionButton)
        Me.GroupBox2.Location = New System.Drawing.Point(248, 80)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(208, 88)
        Me.GroupBox2.TabIndex = 12
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Compression"
        '
        'Group4Button
        '
        Me.Group4Button.Location = New System.Drawing.Point(120, 40)
        Me.Group4Button.Name = "Group4Button"
        Me.Group4Button.Size = New System.Drawing.Size(80, 16)
        Me.Group4Button.TabIndex = 4
        Me.Group4Button.Text = "Group4"
        '
        'Group32DButton
        '
        Me.Group32DButton.Location = New System.Drawing.Point(120, 16)
        Me.Group32DButton.Name = "Group32DButton"
        Me.Group32DButton.Size = New System.Drawing.Size(80, 16)
        Me.Group32DButton.TabIndex = 3
        Me.Group32DButton.Text = "Group3 2D"
        '
        'ColorFaxButton
        '
        Me.ColorFaxButton.Location = New System.Drawing.Point(8, 64)
        Me.ColorFaxButton.Name = "ColorFaxButton"
        Me.ColorFaxButton.Size = New System.Drawing.Size(112, 16)
        Me.ColorFaxButton.TabIndex = 2
        Me.ColorFaxButton.Text = "Color Fax T.30-E"
        '
        'Group31DButton
        '
        Me.Group31DButton.Checked = True
        Me.Group31DButton.Location = New System.Drawing.Point(8, 40)
        Me.Group31DButton.Name = "Group31DButton"
        Me.Group31DButton.Size = New System.Drawing.Size(104, 16)
        Me.Group31DButton.TabIndex = 1
        Me.Group31DButton.TabStop = True
        Me.Group31DButton.Text = "Group3 1D"
        '
        'NoCompressionButton
        '
        Me.NoCompressionButton.Location = New System.Drawing.Point(8, 16)
        Me.NoCompressionButton.Name = "NoCompressionButton"
        Me.NoCompressionButton.Size = New System.Drawing.Size(112, 16)
        Me.NoCompressionButton.TabIndex = 0
        Me.NoCompressionButton.Text = "No Compression"
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
        Me.GroupBox1.Location = New System.Drawing.Point(248, 8)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(120, 64)
        Me.GroupBox1.TabIndex = 16
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Send"
        '
        'ImmediateButton
        '
        Me.ImmediateButton.Location = New System.Drawing.Point(8, 38)
        Me.ImmediateButton.Name = "ImmediateButton"
        Me.ImmediateButton.TabIndex = 1
        Me.ImmediateButton.Text = "Immediate"
        '
        'QueueButton
        '
        Me.QueueButton.Checked = True
        Me.QueueButton.Location = New System.Drawing.Point(8, 15)
        Me.QueueButton.Name = "QueueButton"
        Me.QueueButton.TabIndex = 0
        Me.QueueButton.TabStop = True
        Me.QueueButton.Text = "Queue"
        '
        'Send
        '
        Me.AcceptButton = Me.SendOK
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.Button2
        Me.ClientSize = New System.Drawing.Size(458, 207)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.GroupBox2)
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
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button2.Click
        Close()
    End Sub

    Private Sub BrowseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BrowseButton.Click
        Dim szFilter$

        szFilter = "Bitmap Format (*.bmp)" + "|" + "*.bmp" + "|"
        szFilter = szFilter + "TIFF File Format (*.tif)" + "|" + "*.tif" + "|"
        szFilter = szFilter + "JPEG Format (*.jpg)" + "|" + "*.jpg" + "|"
        szFilter = szFilter + "ASCII Text File (*.txt)" + "|" + "*.txt" + "|"
        szFilter = szFilter + "All Files(*.*)" + "|" + "*.*"
        OpenFileDialog1.Filter = szFilter
        If OpenFileDialog1.ShowDialog() = System.Windows.Forms.DialogResult.OK Then
            FileTextBox.Text = OpenFileDialog1.FileName
        End If
    End Sub

    Private Sub SendOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SendOK.Click
        Static FaxID As Long
        Static back, back2 As Long
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
        
        If FileTextBox.Text.Length >= 3 Then
            ext = FileTextBox.Text.Substring(FileTextBox.Text.Length - 3, 3).ToUpper
        Else : ext = ""
        End If
        Dim checkFile As String
        If ext.Length <> 0 And ext <> "   " Then
            checkFile = Dir(FileTextBox.Text)
        Else : checkFile = ""
        End If
        If checkFile = "" And FileTextBox.Text.ToUpper <> "TEST.TIF" Then
            MsgBox("You must specify an existing file to send.")
            FileTextBox.Focus()
            FileTextBox.SelectAll()
            Exit Sub
        End If


        pparent.FAX1.PageFileName = FileTextBox.Text


        If ext = "TIF" Then
            PageNum = pparent.FAX1.GetNumberOfImages(FileTextBox.Text, 6)
        Else
            PageNum = 1
        End If

        If pparent.FAX1.IsDemoVersion() And (PageNum > 1) Then
            MessageBox.Show("The DEMO version of the Fax OCX supports only 1 page faxes. ONLY the first page will be sent.", "Error")
            PageNum = 1
        End If
        Dim compression As Integer
        If NoCompressionButton.Checked = True Then
            compression = 4
        ElseIf Group31DButton.Checked = True Or ColorFaxButton.Checked = True Then
            compression = 2
        ElseIf Group32DButton.Checked = True Then
            compression = 3
        ElseIf Group4Button.Checked = True Then
            compression = 5
        Else : compression = 2
        End If
        Dim type, colorfax As Byte

        If ColorFaxButton.Checked = True Then
            type = 2
            colorfax = 3
            If pparent.EnableBFT = 3 Then
                pparent.EnableBFT = 2
            End If
        Else
            colorfax = 2
            If pparent.EnableBFT = 3 Then
                type = 2
            Else : type = 1
            End If
        End If
        FaxID = pparent.FAX1.CreateFaxObject(type, PageNum, 3, 2, 1, compression, pparent.EnableBFT, pparent.EnableECM, 2, 1)
        If (FaxID = 0) Then
            errStr = "Can't create fax object ! Error code : " + Str(pparent.FAX1.FaxError)
            back = MsgBox(errStr, vbOKOnly)
        Else
            back = pparent.FAX1.SetFaxParam(FaxID, 9, PageNum)
            back = pparent.FAX1.SetPhoneNumber(FaxID, PhoneTextBox.Text)
            For i = 1 To PageNum
                If (pparent.FAX1.SetFaxPage(FaxID, i, 17, i)) Then
                    errStr = "Can't set fax page ! Error code : " + Str(pparent.FAX1.FaxError)
                    bOK = False
                    MsgBox(errStr, vbOKOnly)
                    Exit For
                End If
            Next i
            If bOK Then
                If ImmediateButton.Checked = True Then
                    Dim port As String
                    Dim index As Integer
                    port = (FaxPortsListBox.SelectedItem)
                    index = port.IndexOf(":")
                    If (index <> -1) Then
                        port = port.Substring(0, index)
                    End If
                    back = pparent.FAX1.SendNow(port, FaxID)
                ElseIf QueueButton.Checked = True Then
                    back2 = pparent.FAX1.SendFaxObj(FaxID)
                    If (back2) Then
                        pparent.FAX1.ClearFaxObject(FaxID)
                        errStr = "Can't send fax ! Error code : " + Str(back)
                        back = MsgBox(errStr, vbOKOnly)
                    End If
                End If

            End If
        End If
        Close()
    End Sub
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents Label4 As System.Windows.Forms.Label

    Private Sub Send_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim j, portindex, spaceindex As Integer
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
                portindex = pparent.PortsAndClasses.IndexOf(t2) + t2.Length + 1
                spaceindex = pparent.PortsAndClasses.IndexOf(" ", portindex)
                t2 = t2 + ":" + pparent.FAX1.GetLongName((Convert.ToInt16(pparent.PortsAndClasses.Substring(portindex, spaceindex - portindex))))
                FaxPortsListBox.Items.Add(t2)
            End While
        End If

        t1 = pparent.FAX1.BrooktroutChannelsOpen
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

        t1 = pparent.FAX1.GammaChannelsOpen
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

        t1 = pparent.FAX1.DialogicChannelsOpen
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

        t1 = pparent.FAX1.NMSChannelsOpen
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
    End Sub
End Class
