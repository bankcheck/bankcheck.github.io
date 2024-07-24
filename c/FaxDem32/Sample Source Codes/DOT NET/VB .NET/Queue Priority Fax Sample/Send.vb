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
        Me.Label3 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'SendOK
        '
        Me.SendOK.Location = New System.Drawing.Point(11, 176)
        Me.SendOK.Name = "SendOK"
        Me.SendOK.TabIndex = 4
        Me.SendOK.Text = "OK"
        '
        'Button2
        '
        Me.Button2.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Button2.Location = New System.Drawing.Point(100, 176)
        Me.Button2.Name = "Button2"
        Me.Button2.TabIndex = 5
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
        Me.PhoneTextBox.TabIndex = 1
        Me.PhoneTextBox.Text = ""
        '
        'FileTextBox
        '
        Me.FileTextBox.Location = New System.Drawing.Point(80, 144)
        Me.FileTextBox.MaxLength = 255
        Me.FileTextBox.Name = "FileTextBox"
        Me.FileTextBox.Size = New System.Drawing.Size(184, 20)
        Me.FileTextBox.TabIndex = 2
        Me.FileTextBox.Text = ""
        '
        'BrowseButton
        '
        Me.BrowseButton.Location = New System.Drawing.Point(189, 176)
        Me.BrowseButton.Name = "BrowseButton"
        Me.BrowseButton.TabIndex = 3
        Me.BrowseButton.Text = "Browse"
        '
        'FaxPortsListBox
        '
        Me.FaxPortsListBox.Location = New System.Drawing.Point(8, 32)
        Me.FaxPortsListBox.Name = "FaxPortsListBox"
        Me.FaxPortsListBox.Size = New System.Drawing.Size(256, 69)
        Me.FaxPortsListBox.TabIndex = 0
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
        'Send
        '
        Me.AcceptButton = Me.SendOK
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.Button2
        Me.ClientSize = New System.Drawing.Size(274, 207)
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
        Static back, back2 As Long
        Static errStr As String
        Static PageNum As Short
        Dim rnd As Random
        Dim bOK As Boolean
        Dim ext As String
        Dim i As Short
        Dim notNumber As Boolean
        Dim PhoneNum As String
        Dim actualchar As Char
        Dim loops, actPage As Integer
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
            MsgBox("You must specify a TIFF file!")
            FileTextBox.Focus()
            FileTextBox.SelectAll()
            Exit Sub
        End If

        For loops = 1 To 10
            If (loops = 1) Then
                actPage = PageNum
            Else
                rnd = New Random
                actPage = rnd.Next(1, PageNum)
            End If

            FaxID = pparent.FAX1.CreateFaxObject(1, 1, 3, 2, 1, 2, 2, 3, 2, 1)
            If (FaxID = 0) Then
                errStr = "Can't create fax object ! Error code : " + Str(pparent.FAX1.FaxError)
                back = MsgBox(errStr, vbOKOnly)
            Else
                back = pparent.FAX1.SetFaxParam(FaxID, 9, 1)
                pparent.FAX1.SetFaxParam(FaxID, 12, actPage)
                back = pparent.FAX1.SetPhoneNumber(FaxID, PhoneTextBox.Text)
                pparent.MessageBox.Items.Add("Setup page " + Convert.ToString(actPage) + " for sending " + pparent.FAX1.PageFileName)
                If (pparent.FAX1.SetFaxPage(FaxID, 1, 11, actPage)) Then
                    errStr = "Can't set fax page ! Error code : " + Str(pparent.FAX1.FaxError)
                    bOK = False
                    MsgBox(errStr, vbOKOnly)
                    Exit For
                End If
                If bOK Then
                    back2 = pparent.FAX1.SendFaxObj(FaxID)
                    If (back2) Then
                        pparent.FAX1.ClearFaxObject(FaxID)
                        errStr = "Can't send fax ! Error code : " + Str(back)
                        back = MsgBox(errStr, vbOKOnly)
                    Else
                        pparent.MessageBox.Items.Add(pparent.ActualFaxPort + ": Fax has been sent to queue")
                    End If
                End If
            End If
        Next
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

        FileTextBox.Text = "Testqueue.tif"
        FaxPortsListBox.SetSelected(0, True)
    End Sub
End Class
