Public Class OpenComPort
    Inherits System.Windows.Forms.Form
    Public pparent As Form1
    Public rings As String



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
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents HeaderCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents TestButton As System.Windows.Forms.Button
    Friend WithEvents TypeLabel As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents CancelBtn As System.Windows.Forms.Button
    Friend WithEvents ManuLabel As System.Windows.Forms.Label
    Friend WithEvents ModelLabel As System.Windows.Forms.Label
    Friend WithEvents ClassTypeLabel As System.Windows.Forms.Label
    Friend WithEvents ComboBox1 As System.Windows.Forms.ComboBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents GroupBox3 As System.Windows.Forms.GroupBox
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents PortList As System.Windows.Forms.ListBox
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents SetupStrTextbox As System.Windows.Forms.TextBox
    Friend WithEvents ResetStrTextbox As System.Windows.Forms.TextBox
    Friend WithEvents groupBox5 As System.Windows.Forms.GroupBox
    Friend WithEvents chkEnableDebug As System.Windows.Forms.CheckBox
    Friend WithEvents DialtoneButton As System.Windows.Forms.Button
    Friend WithEvents IDTextBox As System.Windows.Forms.TextBox
    Friend WithEvents RingTextBox As System.Windows.Forms.TextBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.OKButton = New System.Windows.Forms.Button
        Me.CancelBtn = New System.Windows.Forms.Button
        Me.HeaderCheckBox = New System.Windows.Forms.CheckBox
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.DialtoneButton = New System.Windows.Forms.Button
        Me.ClassTypeLabel = New System.Windows.Forms.Label
        Me.ModelLabel = New System.Windows.Forms.Label
        Me.ManuLabel = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.TypeLabel = New System.Windows.Forms.Label
        Me.TestButton = New System.Windows.Forms.Button
        Me.ComboBox1 = New System.Windows.Forms.ComboBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.GroupBox3 = New System.Windows.Forms.GroupBox
        Me.IDTextBox = New System.Windows.Forms.TextBox
        Me.RingTextBox = New System.Windows.Forms.TextBox
        Me.SetupStrTextbox = New System.Windows.Forms.TextBox
        Me.ResetStrTextbox = New System.Windows.Forms.TextBox
        Me.Label8 = New System.Windows.Forms.Label
        Me.PortList = New System.Windows.Forms.ListBox
        Me.Label7 = New System.Windows.Forms.Label
        Me.Label6 = New System.Windows.Forms.Label
        Me.Label5 = New System.Windows.Forms.Label
        Me.Label4 = New System.Windows.Forms.Label
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.groupBox5 = New System.Windows.Forms.GroupBox
        Me.chkEnableDebug = New System.Windows.Forms.CheckBox
        Me.GroupBox2.SuspendLayout()
        Me.GroupBox3.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.groupBox5.SuspendLayout()
        Me.SuspendLayout()
        '
        'OKButton
        '
        Me.OKButton.Location = New System.Drawing.Point(188, 472)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.TabIndex = 6
        Me.OKButton.Text = "&OK"
        '
        'CancelBtn
        '
        Me.CancelBtn.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CancelBtn.Location = New System.Drawing.Point(92, 472)
        Me.CancelBtn.Name = "CancelBtn"
        Me.CancelBtn.TabIndex = 5
        Me.CancelBtn.Text = "&Cancel"
        '
        'HeaderCheckBox
        '
        Me.HeaderCheckBox.Location = New System.Drawing.Point(16, 24)
        Me.HeaderCheckBox.Name = "HeaderCheckBox"
        Me.HeaderCheckBox.Size = New System.Drawing.Size(104, 16)
        Me.HeaderCheckBox.TabIndex = 0
        Me.HeaderCheckBox.Text = "Create Header"
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.DialtoneButton)
        Me.GroupBox2.Controls.Add(Me.ClassTypeLabel)
        Me.GroupBox2.Controls.Add(Me.ModelLabel)
        Me.GroupBox2.Controls.Add(Me.ManuLabel)
        Me.GroupBox2.Controls.Add(Me.Label3)
        Me.GroupBox2.Controls.Add(Me.Label2)
        Me.GroupBox2.Controls.Add(Me.TypeLabel)
        Me.GroupBox2.Controls.Add(Me.TestButton)
        Me.GroupBox2.Location = New System.Drawing.Point(8, 64)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(336, 152)
        Me.GroupBox2.TabIndex = 1
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Modem Test"
        '
        'DialtoneButton
        '
        Me.DialtoneButton.Location = New System.Drawing.Point(8, 124)
        Me.DialtoneButton.Name = "DialtoneButton"
        Me.DialtoneButton.Size = New System.Drawing.Size(88, 23)
        Me.DialtoneButton.TabIndex = 1
        Me.DialtoneButton.Text = "Test Dialtone"
        '
        'ClassTypeLabel
        '
        Me.ClassTypeLabel.Location = New System.Drawing.Point(104, 72)
        Me.ClassTypeLabel.Name = "ClassTypeLabel"
        Me.ClassTypeLabel.Size = New System.Drawing.Size(224, 48)
        Me.ClassTypeLabel.TabIndex = 6
        '
        'ModelLabel
        '
        Me.ModelLabel.Location = New System.Drawing.Point(104, 48)
        Me.ModelLabel.Name = "ModelLabel"
        Me.ModelLabel.Size = New System.Drawing.Size(224, 16)
        Me.ModelLabel.TabIndex = 5
        '
        'ManuLabel
        '
        Me.ManuLabel.Location = New System.Drawing.Point(104, 24)
        Me.ManuLabel.Name = "ManuLabel"
        Me.ManuLabel.Size = New System.Drawing.Size(224, 16)
        Me.ManuLabel.TabIndex = 4
        '
        'Label3
        '
        Me.Label3.Location = New System.Drawing.Point(16, 23)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(80, 16)
        Me.Label3.TabIndex = 3
        Me.Label3.Text = "Manufacturer:"
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(16, 47)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(40, 16)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "Model:"
        '
        'TypeLabel
        '
        Me.TypeLabel.Location = New System.Drawing.Point(16, 71)
        Me.TypeLabel.Name = "TypeLabel"
        Me.TypeLabel.Size = New System.Drawing.Size(64, 16)
        Me.TypeLabel.TabIndex = 1
        Me.TypeLabel.Text = "Class Type:"
        '
        'TestButton
        '
        Me.TestButton.Location = New System.Drawing.Point(8, 96)
        Me.TestButton.Name = "TestButton"
        Me.TestButton.Size = New System.Drawing.Size(88, 23)
        Me.TestButton.TabIndex = 0
        Me.TestButton.Text = "Test Modem"
        '
        'ComboBox1
        '
        Me.ComboBox1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ComboBox1.Location = New System.Drawing.Point(8, 32)
        Me.ComboBox1.Name = "ComboBox1"
        Me.ComboBox1.Size = New System.Drawing.Size(336, 21)
        Me.ComboBox1.TabIndex = 0
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(8, 8)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(136, 16)
        Me.Label1.TabIndex = 7
        Me.Label1.Text = "Fax Modem Settings:"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.BottomLeft
        '
        'GroupBox3
        '
        Me.GroupBox3.Controls.Add(Me.IDTextBox)
        Me.GroupBox3.Controls.Add(Me.RingTextBox)
        Me.GroupBox3.Controls.Add(Me.SetupStrTextbox)
        Me.GroupBox3.Controls.Add(Me.ResetStrTextbox)
        Me.GroupBox3.Controls.Add(Me.Label8)
        Me.GroupBox3.Controls.Add(Me.PortList)
        Me.GroupBox3.Controls.Add(Me.Label7)
        Me.GroupBox3.Controls.Add(Me.Label6)
        Me.GroupBox3.Controls.Add(Me.Label5)
        Me.GroupBox3.Controls.Add(Me.Label4)
        Me.GroupBox3.Location = New System.Drawing.Point(8, 224)
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.Size = New System.Drawing.Size(336, 128)
        Me.GroupBox3.TabIndex = 2
        Me.GroupBox3.TabStop = False
        Me.GroupBox3.Text = "Modem Setup"
        '
        'IDTextBox
        '
        Me.IDTextBox.Location = New System.Drawing.Point(120, 72)
        Me.IDTextBox.MaxLength = 100
        Me.IDTextBox.Name = "IDTextBox"
        Me.IDTextBox.Size = New System.Drawing.Size(136, 20)
        Me.IDTextBox.TabIndex = 2
        Me.IDTextBox.Text = ""
        '
        'RingTextBox
        '
        Me.RingTextBox.Location = New System.Drawing.Point(160, 96)
        Me.RingTextBox.MaxLength = 1
        Me.RingTextBox.Name = "RingTextBox"
        Me.RingTextBox.Size = New System.Drawing.Size(16, 20)
        Me.RingTextBox.TabIndex = 3
        Me.RingTextBox.Text = ""
        '
        'SetupStrTextbox
        '
        Me.SetupStrTextbox.Location = New System.Drawing.Point(96, 48)
        Me.SetupStrTextbox.MaxLength = 25
        Me.SetupStrTextbox.Name = "SetupStrTextbox"
        Me.SetupStrTextbox.Size = New System.Drawing.Size(160, 20)
        Me.SetupStrTextbox.TabIndex = 1
        Me.SetupStrTextbox.Text = ""
        '
        'ResetStrTextbox
        '
        Me.ResetStrTextbox.Location = New System.Drawing.Point(96, 24)
        Me.ResetStrTextbox.MaxLength = 25
        Me.ResetStrTextbox.Name = "ResetStrTextbox"
        Me.ResetStrTextbox.Size = New System.Drawing.Size(160, 20)
        Me.ResetStrTextbox.TabIndex = 0
        Me.ResetStrTextbox.Text = ""
        '
        'Label8
        '
        Me.Label8.Location = New System.Drawing.Point(264, 20)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(40, 16)
        Me.Label8.TabIndex = 5
        Me.Label8.Text = "Ports:"
        Me.Label8.TextAlign = System.Drawing.ContentAlignment.BottomLeft
        '
        'PortList
        '
        Me.PortList.Location = New System.Drawing.Point(264, 36)
        Me.PortList.Name = "PortList"
        Me.PortList.Size = New System.Drawing.Size(64, 56)
        Me.PortList.TabIndex = 4
        '
        'Label7
        '
        Me.Label7.Location = New System.Drawing.Point(16, 97)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(144, 16)
        Me.Label7.TabIndex = 3
        Me.Label7.Text = "Number of rings to answer:"
        Me.Label7.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label6
        '
        Me.Label6.Location = New System.Drawing.Point(16, 73)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(104, 16)
        Me.Label6.TabIndex = 2
        Me.Label6.Text = "Identification String:"
        Me.Label6.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label5
        '
        Me.Label5.Location = New System.Drawing.Point(16, 49)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(72, 16)
        Me.Label5.TabIndex = 1
        Me.Label5.Text = "Setup String:"
        Me.Label5.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label4
        '
        Me.Label4.Location = New System.Drawing.Point(16, 25)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(72, 16)
        Me.Label4.TabIndex = 0
        Me.Label4.Text = "Reset String:"
        Me.Label4.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.HeaderCheckBox)
        Me.GroupBox1.Location = New System.Drawing.Point(8, 360)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(336, 48)
        Me.GroupBox1.TabIndex = 3
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Header Setup"
        '
        'groupBox5
        '
        Me.groupBox5.Controls.Add(Me.chkEnableDebug)
        Me.groupBox5.Location = New System.Drawing.Point(8, 416)
        Me.groupBox5.Name = "groupBox5"
        Me.groupBox5.Size = New System.Drawing.Size(336, 48)
        Me.groupBox5.TabIndex = 4
        Me.groupBox5.TabStop = False
        Me.groupBox5.Text = "Debug File Generation"
        '
        'chkEnableDebug
        '
        Me.chkEnableDebug.Location = New System.Drawing.Point(16, 24)
        Me.chkEnableDebug.Name = "chkEnableDebug"
        Me.chkEnableDebug.Size = New System.Drawing.Size(136, 16)
        Me.chkEnableDebug.TabIndex = 0
        Me.chkEnableDebug.Text = "Enable Driver Debug"
        '
        'OpenComPort
        '
        Me.AcceptButton = Me.OKButton
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.CancelBtn
        Me.ClientSize = New System.Drawing.Size(354, 503)
        Me.Controls.Add(Me.groupBox5)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.GroupBox3)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.ComboBox1)
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.CancelBtn)
        Me.Controls.Add(Me.OKButton)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "OpenComPort"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Open Com Port"
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox3.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        Me.groupBox5.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region
    Declare Function GetPrivateProfileString Lib "kernel32" Alias _
    "GetPrivateProfileStringA" _
    (ByVal lpApplicationName As String, _
    ByVal lpKeyName As String, _
    ByVal lpDefault As String, _
    ByVal lpRetunedString As String, _
    ByVal nSize As Integer, _
    ByVal lpFileName As String) As Integer

    Declare Sub WritePrivateProfileString Lib "kernel32" Alias _
    "WritePrivateProfileStringA" _
    (ByVal lpApplicationName As String, _
    ByVal lpKeyName As String, _
    ByVal lpString As String, _
    ByVal lpFileName As String)

    Declare Function GetProfileString Lib "kernel32" Alias _
    "WriteProfileStringA" _
    (ByVal lpszSection As String, _
    ByVal lpszEntry As String, _
    ByVal lpszDefault As String) As String

    Declare Function GetProfileInt Lib "kernel32" Alias _
    "GetProfileIntA" _
    (ByVal lpszSection As String, _
    ByVal lpszEntry As String, _
    ByVal nDefault As Integer) As Integer

    Declare Function WriteProfileString Lib "kernel32" Alias _
    "WriteProfileStringA" _
    (ByVal lpszSection As String, _
    ByVal lpszEntry As String, _
    ByVal lpstring As String) As Boolean

    Private Sub OpenComPort_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Static t1, t2 As String
        Static flag As Boolean
        Static j As Integer

        If pparent.EnableDebug Then
            chkEnableDebug.Checked = True
        Else
            chkEnableDebug.Checked = False
        End If
        If (pparent.FAX1.Header) Then
            HeaderCheckBox.Checked = 1
        Else
            HeaderCheckBox.Checked = 0
        End If
        t1 = pparent.FAX1.AvailablePorts
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

        Dim szFax As String
        Dim szFaxName As String
        Dim SzFaxName1 As String
        Dim nFaxes As Integer
        Dim IniFileName As String
        Dim LocalFax As Integer
        '        Dim headerInt As Integer
        Dim First As Boolean
        Dim wasThere1, wasThere2 As Boolean
        wasThere1 = False
        wasThere2 = False
        First = True
        LocalFax = 0
        IniFileName = "faxcpp1.ini"
        nFaxes = 1
        While nFaxes <> -1

            LocalFax = LocalFax + 1
            szFax = "Fax" + Convert.ToString(LocalFax)
            szFaxName = New String(Chr(0), 256)
            If (GetPrivateProfileString("Faxes", szFax, "", szFaxName, 250, IniFileName) = 0) Then
                wasThere1 = False
                If (First = False) Then
                    nFaxes = -1
                    wasThere1 = True
                Else
                    First = False
                    wasThere1 = True
                End If
            Else : wasThere1 = False
            End If
            If (wasThere1 = False) Then
                SzFaxName1 = New String(Chr(0), 256)
                If (GetPrivateProfileString(szFaxName, "Long Name", "", SzFaxName1, 250, IniFileName) = 0) Then
                    wasThere2 = False
                    If (First = False) Then
                        nFaxes = -1
                        wasThere2 = True
                    Else
                        First = False
                        wasThere2 = True
                    End If
                Else : wasThere2 = False
                End If
            End If
            If (wasThere1 = False And wasThere2 = False And nFaxes <> -1) Then
                ComboBox1.Items.Add(SzFaxName1)
                nFaxes = nFaxes + 1
            End If
        End While
        ComboBox1.SelectedIndex = GetProfileInt("Fax", "Selected", 1) - 1
        ComboBox1_SelectedIndexChanged(sender, e)
        IDTextBox.Text = pparent.FAX1.LocalID
        RingTextBox.Text = pparent.FAX1.Rings
        HeaderCheckBox.CheckState = GetProfileInt("Fax", "Header", 1)
        chkEnableDebug.CheckState = 0
    End Sub

    Private Sub TestButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TestButton.Click
        Static Selected As String
        Static OutString As String
        Static err As Integer
        Dim iPosition As Integer
        Dim iBeginStr As Integer
        Dim S1 As String

        Cursor = Cursors.WaitCursor
        Enabled = False
        Selected = PortList.SelectedItem
        err = pparent.FAX1.TestModem(Selected)

        If (err = 0) Then

            OutString = ""
            iPosition = 0
            iBeginStr = 0
            If pparent.FAX1.ClassType.Length > 0 Then
                Do While iPosition > -1
                    S1 = ""
                    iPosition = pparent.FAX1.ClassType.IndexOf(",", iBeginStr)
                    If iPosition > -1 Then
                        S1 = pparent.FAX1.ClassType.Substring(iBeginStr, iPosition - iBeginStr)
                        iBeginStr = iPosition + 1
                    Else
                        S1 = pparent.FAX1.ClassType.Substring(iBeginStr, pparent.FAX1.ClassType.Length - iBeginStr)
                    End If
                    If S1 = "0" Then
                        If OutString.Length = 0 Then
                            OutString = OutString + "Data"
                        Else
                            OutString = OutString + ", Data"
                        End If

                    ElseIf S1 = "1" Then
                        If OutString.Length = 0 Then
                            OutString = OutString + "FAX Class 1"
                        Else
                            OutString = OutString + ", FAX Class 1"
                        End If

                    ElseIf S1 = "1.0" Then
                        If OutString.Length = 0 Then
                            OutString = OutString + "FAX Class 1.0"
                        Else
                            OutString = OutString + ", FAX Class 1.0"
                        End If

                    ElseIf S1 = "2.0" Then
                        If OutString.Length = 0 Then
                            OutString = OutString + "FAX Class 2.0"
                        Else
                            OutString = OutString + ", FAX Class 2.0"
                        End If

                    ElseIf S1 = "2" Then
                        If OutString.Length = 0 Then
                            OutString = OutString + "FAX Class 2"
                        Else
                            OutString = OutString + ", FAX Class 2"
                        End If

                    ElseIf S1 = "2.1" Then
                        If OutString.Length = 0 Then
                            OutString = OutString + "FAX Class 2.1"
                        Else
                            OutString = OutString + ", FAX Class 2.1"
                        End If

                    ElseIf S1 = "8" Then
                        If OutString.Length = 0 Then
                            OutString = OutString + "Class 8"
                        Else
                            OutString = OutString + ", Class 8"
                        End If

                    ElseIf S1 = "80" Then
                        If OutString.Length = 0 Then
                            OutString = OutString + "Class 80"
                        Else
                            OutString = OutString + ", Class 80"
                        End If
                    ElseIf S1.Length > 0 Then
                        If OutString.Length = 0 Then
                            OutString = OutString + "Class " + S1
                        Else
                            OutString = OutString + ", Class " + S1
                        End If
                    End If

                Loop
            End If
            If (OutString.Length > 0) Then
                ClassTypeLabel.Text = OutString
            Else
                ClassTypeLabel.Text = pparent.FAX1.ClassType
            End If
            ManuLabel.Text = pparent.FAX1.Manufacturer
            ModelLabel.Text = pparent.FAX1.Model
        Else
            ClassTypeLabel.Text = "No modem on " + Selected
            ManuLabel.Text = ""
            ModelLabel.Text = ""
        End If
        Enabled = True
        Cursor = Cursors.Default
    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click
        Static errcode As Long
        Dim IniFileName As String
        Dim nFax As Integer
        Dim szFaxName, szFaxName1 As String
        Dim SelectedFax As Integer
        '        Dim StationID As String
        '        Dim nRing As Integer

        Cursor = Cursors.WaitCursor
        Enabled = False
        pparent.FAX1.SetSetupString(SetupStrTextbox.Text, ComboBox1.SelectedIndex + 1)
        pparent.FAX1.SetResetString(ResetStrTextbox.Text, ComboBox1.SelectedIndex + 1)

        If (HeaderCheckBox.Checked = 0) Then
            pparent.FAX1.Header = False
        Else
            pparent.FAX1.Header = True
            pparent.FAX1.HeaderHeight = 25
            pparent.FAX1.HeaderFaceName = "Arial"
            pparent.FAX1.HeaderFontSize = 10
        End If
        If chkEnableDebug.Checked Then
            pparent.EnableDebug = True
        Else
            pparent.EnableDebug = False
        End If

        IniFileName = "faxcpp1.ini"
        'Get fax name.
        nFax = ComboBox1.SelectedIndex + 1
        szFaxName = "Fax" + Convert.ToString(nFax)
        szFaxName1 = New String(Chr(0), 256)
        GetPrivateProfileString("Faxes", szFaxName, "", szFaxName1, 250, IniFileName)
        SelectedFax = nFax
        WriteProfileString("Fax", "Selected", Convert.ToString(SelectedFax))
        pparent.FAX1.LocalID = IDTextBox.Text
        pparent.FAX1.Rings = Val(RingTextBox.Text)
        WriteProfileString("Fax", "Header", Convert.ToString(Convert.ToByte(HeaderCheckBox.Checked)))
        pparent.FAX1.FaxType = szFaxName1
        pparent.FAX1.TestModem(PortList.SelectedItem)
        If Len(pparent.FAX1.ClassType) <> 0 Then
            If (pparent.FAX1.FaxType = "GCLASS1(SFC)") And ((InStr(pparent.FAX1.ClassType, "1") = 0) Or (InStr(pparent.FAX1.ClassType, "1.0") = InStr(pparent.FAX1.ClassType, "1"))) Then
                MsgBox("The selected modem does not support Class 1", 0)
                Enabled = True
                Cursor = Cursors.Default
                Exit Sub
            ElseIf (pparent.FAX1.FaxType = "GCLASS1(HFC)") And ((InStr(pparent.FAX1.ClassType, "1") = 0) Or (InStr(pparent.FAX1.ClassType, "1.0") = InStr(pparent.FAX1.ClassType, "1"))) Then
                MsgBox("The selected modem does not support Class 1", 0)
                Enabled = True
                Cursor = Cursors.Default
                Exit Sub
            ElseIf (pparent.FAX1.FaxType = "GCLASS1.0(SFC)") And (InStr(pparent.FAX1.ClassType, "1.0") = 0) Then
                MsgBox("The selected modem does not support Class 1.0", 0)
                Enabled = True
                Cursor = Cursors.Default
                Exit Sub
            ElseIf (pparent.FAX1.FaxType = "GCLASS1.0(HFC)") And (InStr(pparent.FAX1.ClassType, "1.0") = 0) Then
                MsgBox("The selected modem does not support Class 1.0", 0)
                Enabled = True
                Cursor = Cursors.Default
                Exit Sub
            ElseIf ((pparent.FAX1.FaxType = "GCLASS2S/RF/") Or (pparent.FAX1.FaxType = "GCLASS2R")) And ((InStr(pparent.FAX1.ClassType, "2") = 0) Or (InStr(pparent.FAX1.ClassType, "2.0") = InStr(pparent.FAX1.ClassType, "2"))) Then
                MsgBox("The selected modem does not support Class 2", 0)
                Enabled = True
                Cursor = Cursors.Default
                Exit Sub
            ElseIf ((pparent.FAX1.FaxType = "GCLASS2.0") Or (pparent.FAX1.FaxType = "GCLASS2.0 MULTITECH")) And (InStr(pparent.FAX1.ClassType, "2.0") = 0) Then
                MsgBox("The selected modem does not support Class 2.0", 0)
                Enabled = True
                Cursor = Cursors.Default
                Exit Sub
            ElseIf ((pparent.FAX1.FaxType = "GH14.4F(HFC)") Or (pparent.FAX1.FaxType = "GU.S.R14.4F(HFC)")) And ((InStr(pparent.FAX1.ClassType, "1") = 0) Or (InStr(pparent.FAX1.ClassType, "1.0") = InStr(pparent.FAX1.ClassType, "1"))) Then
                MsgBox("The selected modem does not support Class 1", 0)
                Enabled = True
                Cursor = Cursors.Default
                Exit Sub
            End If
            pparent.ActualFaxPort = PortList.SelectedItem
            pparent.FAX1.SpeakerVolume = pparent.SpeakerVolume
            pparent.FAX1.SpeakerMode = pparent.SpeakerMode
            System.Threading.Thread.Sleep(2000)
            errcode = pparent.FAX1.OpenPort(PortList.SelectedItem)
            If (errcode <> 0) Then
                MsgBox(pparent.Errors(errcode), 0)
            Else
                pparent.PortsAndClasses = pparent.PortsAndClasses + PortList.SelectedItem + ":" + Convert.ToString((ComboBox1.SelectedIndex + 1)) + " "
                pparent.MenuClosePort.Enabled = True
                pparent.MenuSend.Enabled = True
                pparent.MenuShowManager.Enabled = True
                pparent.MessageBox.Items.Add(PortList.SelectedItem + ":" + pparent.FAX1.GetLongName(ComboBox1.SelectedIndex + 1) + " was opened")
            End If
            pparent.FAX1.SetSpeakerMode(pparent.ActualFaxPort, pparent.SpeakerMode, pparent.SpeakerVolume)
            pparent.FAX1.SetPortCapability(pparent.ActualFaxPort, 3, pparent.EnableECM)
            pparent.FAX1.SetPortCapability(pparent.ActualFaxPort, 4, pparent.EnableBFT)
            pparent.FAX1.SetPortCapability(pparent.ActualFaxPort, 10, pparent.BaudRate)
            pparent.FAX1.EnableLog(pparent.ActualFaxPort, pparent.EnableDebug)
            pparent.FAX1.HeaderHeight = 25
        Else
            MsgBox("No Modem on " + PortList.SelectedItem + " port!", vbExclamation + vbOKOnly, "Warning")
            Enabled = True
            Cursor = Cursors.Default
            Exit Sub
        End If

        If (Len(pparent.FAX1.AvailablePorts) > 0) Then
            pparent.MenuCom.Enabled = True
        Else
            pparent.MenuCom.Enabled = False
        End If

        Enabled = True
        Cursor = Cursors.Default
        Close()
    End Sub

    Private Sub CancelBtn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelBtn.Click
        Close()
    End Sub

    Private Sub ComboBox1_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ComboBox1.SelectedIndexChanged
        Dim nFax As Integer
        nFax = ComboBox1.SelectedIndex + 1
        ResetStrTextbox.Text = pparent.FAX1.GetResetString(nFax)
        SetupStrTextbox.Text = pparent.FAX1.GetSetupString(nFax)
    End Sub

    Private Sub DialtoneButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DialtoneButton.Click
        Dim szPortName As String
        Dim iError As Integer

        szPortName = PortList.SelectedItem
        Cursor = Cursors.WaitCursor
        iError = pparent.FAX1.DetectDialTone(szPortName)
        Cursor = Cursors.Default
        If (1 = iError) Then
            MessageBox.Show("Dialtone Detected. ", "Test Dialtone", MessageBoxButtons.OK, MessageBoxIcon.Information)
        ElseIf (0 = iError) Then
            MessageBox.Show("No Dialtone! ", "Test Dialtone", MessageBoxButtons.OK, MessageBoxIcon.Stop)
        ElseIf (-1 = iError) Then
            MessageBox.Show("No Modem on COM Port! ", "Test Dialtone", MessageBoxButtons.OK, MessageBoxIcon.Stop)
        End If

    End Sub

    Private Sub RingTextBox_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RingTextBox.TextChanged
        If (RingTextBox.Text.Length > 0) Then
            If (Not Char.IsDigit(RingTextBox.Text.Chars(0))) Then
                RingTextBox.Text = rings
                RingTextBox.SelectAll()
            End If
        End If
    End Sub
    Private Sub RingTextBox_KeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) Handles RingTextBox.KeyPress
        rings = RingTextBox.Text
    End Sub
End Class
