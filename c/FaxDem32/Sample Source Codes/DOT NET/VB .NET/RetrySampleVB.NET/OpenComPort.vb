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
    Friend WithEvents CancelBtn As System.Windows.Forms.Button
    Friend WithEvents PortList As System.Windows.Forms.ListBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.OKButton = New System.Windows.Forms.Button
        Me.CancelBtn = New System.Windows.Forms.Button
        Me.PortList = New System.Windows.Forms.ListBox
        Me.SuspendLayout()
        '
        'OKButton
        '
        Me.OKButton.Location = New System.Drawing.Point(128, 16)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.TabIndex = 1
        Me.OKButton.Text = "&OK"
        '
        'CancelBtn
        '
        Me.CancelBtn.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CancelBtn.Location = New System.Drawing.Point(128, 48)
        Me.CancelBtn.Name = "CancelBtn"
        Me.CancelBtn.TabIndex = 2
        Me.CancelBtn.Text = "&Cancel"
        '
        'PortList
        '
        Me.PortList.Location = New System.Drawing.Point(8, 8)
        Me.PortList.Name = "PortList"
        Me.PortList.Size = New System.Drawing.Size(112, 69)
        Me.PortList.TabIndex = 0
        '
        'OpenComPort
        '
        Me.AcceptButton = Me.OKButton
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.CancelBtn
        Me.ClientSize = New System.Drawing.Size(210, 87)
        Me.Controls.Add(Me.PortList)
        Me.Controls.Add(Me.CancelBtn)
        Me.Controls.Add(Me.OKButton)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "OpenComPort"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Open Com Port"
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

    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click
        Static errcode As Long
        Dim IniFileName As String
        '        Dim nFax As Integer
        '        Dim szFaxName, szFaxName1 As String
        '        Dim SelectedFax As Integer
        '        Dim StationID As String
        'Dim nRing As Integer

        Cursor = Cursors.WaitCursor
        Enabled = False

        IniFileName = "faxcpp1.ini"
        pparent.FAX1.FaxType = "GCLASS1(SFC)"
        pparent.FAX1.TestModem(PortList.SelectedItem)
        If Len(pparent.FAX1.ClassType) <> 0 Then
            pparent.ActualFaxPort = PortList.SelectedItem
            pparent.FAX1.SpeakerVolume = pparent.SpeakerVolume
            pparent.FAX1.SpeakerMode = pparent.SpeakerMode
            System.Threading.Thread.Sleep(2000)
            errcode = pparent.FAX1.OpenPort(PortList.SelectedItem)
            If (errcode <> 0) Then
                MsgBox(pparent.Errors(errcode), 0)
            Else
                pparent.MenuClosePort.Enabled = True
                pparent.MenuSend.Enabled = True
                pparent.MenuShowManager.Enabled = True
                pparent.MessageBox.Items.Add(PortList.SelectedItem + " was opened")
                pparent.FAX1.SetRings(pparent.ActualFaxPort, 0)
            End If
            pparent.FAX1.SetSpeakerMode(pparent.ActualFaxPort, pparent.SpeakerMode, pparent.SpeakerVolume)
            pparent.FAX1.SetPortCapability(pparent.ActualFaxPort, 3, pparent.EnableECM)
            pparent.FAX1.SetPortCapability(pparent.ActualFaxPort, 4, pparent.EnableBFT)
            pparent.FAX1.SetPortCapability(pparent.ActualFaxPort, 10, pparent.BaudRate)
            pparent.FAX1.EnableLog(pparent.ActualFaxPort, pparent.EnableDebug)
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
End Class
