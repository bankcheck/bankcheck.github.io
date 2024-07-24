Public Class Form1
    Inherits System.Windows.Forms.Form
    Public szExePath As String
    Public szVoiceCaps(5) As String
    Public szIniFile As String
    Public szVocExts(10) As String
    Public fModemID(256, 1) As Long
    Public fAutoForms(256) As frmAutoAnswer
    Public frmSelect As frmSelectPort
    Public frmSelectDlg As frmDialogicOpen
    Public frmSelectBT As frmOpenBrook
    Public frmSelectNMS As frmOpenNMS

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
    Friend WithEvents MainMenu1 As System.Windows.Forms.MainMenu
    Friend WithEvents VoiceOCX As AxVOICEOCXLib.AxVoiceOCX
    Friend WithEvents MenuFile As System.Windows.Forms.MenuItem
    Friend WithEvents MenuExit As System.Windows.Forms.MenuItem
    Friend WithEvents MenuVoice As System.Windows.Forms.MenuItem
    Friend WithEvents MenuAbout As System.Windows.Forms.MenuItem
    Friend WithEvents MenuOpen As System.Windows.Forms.MenuItem
    Friend WithEvents MenuCom As System.Windows.Forms.MenuItem
    Friend WithEvents MenuDialogic As System.Windows.Forms.MenuItem
    Friend WithEvents MenuBrooktrout As System.Windows.Forms.MenuItem
    Friend WithEvents MenuNMS As System.Windows.Forms.MenuItem
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(Form1))
        Me.MainMenu1 = New System.Windows.Forms.MainMenu()
        Me.MenuFile = New System.Windows.Forms.MenuItem()
        Me.MenuExit = New System.Windows.Forms.MenuItem()
        Me.MenuVoice = New System.Windows.Forms.MenuItem()
        Me.MenuOpen = New System.Windows.Forms.MenuItem()
        Me.MenuCom = New System.Windows.Forms.MenuItem()
        Me.MenuDialogic = New System.Windows.Forms.MenuItem()
        Me.MenuBrooktrout = New System.Windows.Forms.MenuItem()
        Me.MenuNMS = New System.Windows.Forms.MenuItem()
        Me.MenuAbout = New System.Windows.Forms.MenuItem()
        Me.VoiceOCX = New AxVOICEOCXLib.AxVoiceOCX()
        CType(Me.VoiceOCX, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'MainMenu1
        '
        Me.MainMenu1.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.MenuFile, Me.MenuVoice, Me.MenuAbout})
        '
        'MenuFile
        '
        Me.MenuFile.Index = 0
        Me.MenuFile.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.MenuExit})
        Me.MenuFile.Text = "&File"
        '
        'MenuExit
        '
        Me.MenuExit.Index = 0
        Me.MenuExit.Shortcut = System.Windows.Forms.Shortcut.CtrlX
        Me.MenuExit.Text = "&Exit"
        '
        'MenuVoice
        '
        Me.MenuVoice.Index = 1
        Me.MenuVoice.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.MenuOpen})
        Me.MenuVoice.Text = "&Voice/Fax"
        '
        'MenuOpen
        '
        Me.MenuOpen.Index = 0
        Me.MenuOpen.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.MenuCom, Me.MenuDialogic, Me.MenuBrooktrout, Me.MenuNMS})
        Me.MenuOpen.Text = "&Open Port"
        '
        'MenuCom
        '
        Me.MenuCom.Index = 0
        Me.MenuCom.Text = "&Com port"
        '
        'MenuDialogic
        '
        Me.MenuDialogic.Index = 1
        Me.MenuDialogic.Text = "&Dialogic Channel"
        '
        'MenuBrooktrout
        '
        Me.MenuBrooktrout.Index = 2
        Me.MenuBrooktrout.Text = "&Brooktrout Channel"
        '
        'MenuNMS
        '
        Me.MenuNMS.Index = 3
        Me.MenuNMS.Text = "&NMS Channel"
        '
        'MenuAbout
        '
        Me.MenuAbout.Index = 2
        Me.MenuAbout.Shortcut = System.Windows.Forms.Shortcut.F1
        Me.MenuAbout.Text = "&About"
        '
        'VoiceOCX
        '
        Me.VoiceOCX.Enabled = True
        Me.VoiceOCX.Location = New System.Drawing.Point(120, 224)
        Me.VoiceOCX.Name = "VoiceOCX"
        Me.VoiceOCX.OcxState = CType(resources.GetObject("VoiceOCX.OcxState"), System.Windows.Forms.AxHost.State)
        Me.VoiceOCX.Size = New System.Drawing.Size(17, 17)
        Me.VoiceOCX.TabIndex = 0
        '
        'Form1
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(292, 273)
        Me.Controls.AddRange(New System.Windows.Forms.Control() {Me.VoiceOCX})
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MaximizeBox = False
        Me.Menu = Me.MainMenu1
        Me.MinimizeBox = False
        Me.Name = "Form1"
        Me.Text = "Voice OCX .NET VB Sample v1.0"
        CType(Me.VoiceOCX, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub MenuAbout_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuAbout.Click
        Dim dlgAbout As AboutDlg = New AboutDlg()

        dlgAbout.ShowDialog()
    End Sub

    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim nIndex As Integer

        For nIndex = 1 To 255 Step 1
            fModemID(nIndex, 0) = 0
            fModemID(nIndex, 1) = -1
        Next

        szExePath = Application.StartupPath
        szIniFile = szExePath + "\VOCXDEMO.INI"

        szVoiceCaps(1) = "Data"
        szVoiceCaps(2) = "Class1"
        szVoiceCaps(3) = "Class2"
        szVoiceCaps(4) = "Voice"
        szVoiceCaps(5) = "VoiceView"

        szVocExts(1) = ".VOC"
        szVocExts(2) = ".WAV"
        szVocExts(3) = ".WAV"
        szVocExts(4) = ".WAV"
        szVocExts(5) = ".WAV"
        szVocExts(6) = ".WAV"
        szVocExts(7) = ".WAV"
        szVocExts(8) = ".WAV"
        szVocExts(9) = ".WAV"

    End Sub

    Private Sub MenuExit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuExit.Click
        Close()
    End Sub

    Public Function FindTagToModemID(ByVal ModemID As Long) As Integer
        Dim Index As Integer

        If ModemID <> 0 Then
            For Index = 1 To 256 Step 1
                If fModemID(Index, 0) = ModemID Then
                    Exit For
                End If
            Next

            If Index <= 256 Then
                FindTagToModemID = Index
            Else
                FindTagToModemID = 0
            End If
        Else
            FindTagToModemID = 0
        End If
    End Function

    Public Sub SetVocExtension(ByVal ModemID As Long, ByRef pszFile As String)
        Dim nIndex As Short

        nIndex = VoiceOCX.GetModemType(ModemID) + 1
        If pszFile.Substring(pszFile.Length - 4).CompareTo(szVocExts(nIndex)) Then
            If (Mid(pszFile, Len(pszFile) - 4, 1)) = "." Then
                ChangeExt(pszFile, szVocExts(nIndex))
            Else
                pszFile = pszFile + szVocExts(nIndex)
            End If
        End If
    End Sub

    Public Sub ChangeExt(ByRef pszTemp As String, ByVal pszExt As String)
        pszTemp = pszTemp.Substring(pszTemp.Length - 4) + pszExt
    End Sub

    Private Sub Form1_Closed(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Closed
        Dim nIndex As Integer

        For nIndex = 1 To 256 Step 1
            If fModemID(nIndex, 0) <> 0 Then
                VoiceOCX.DestroyModemObject(fModemID(nIndex, 0))
            End If
        Next
    End Sub

    Private Sub DoSelectModem()
        Dim nIndex As Integer
        Dim ModemID As Long

        ' choose port
        frmSelect = New frmSelectPort()
        frmSelect.pparent = Me
        frmSelect.ShowDialog()

        ModemID = frmSelect.GetSelectedPort
        nIndex = FindTagToModemID(ModemID)
        If nIndex > 0 Then
            ' user selected a communication port
            CreateAutoAnswerChild(nIndex)

            If frmSelect.LogEnabled = True Then
                VoiceOCX.EnableLog(ModemID, True)
            End If
        End If
    End Sub

    Public Sub CreateAutoAnswerChild(ByVal nIndex As Integer)
        fAutoForms(nIndex) = New frmAutoAnswer()
        fAutoForms(nIndex).pparent = Me
        fModemID(nIndex, 1) = 1
        fAutoForms(nIndex).SetModemID(fModemID(nIndex, 0))
        fAutoForms(nIndex).Show()
    End Sub

    Private Sub MenuCom_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuCom.Click
        DoSelectModem()
    End Sub

    Public Function AddNewModem(ByVal ModemID As Long) As Integer
        Dim i As Integer

        For i = 1 To 256
            If fModemID(i, 0) = 0 Then
                fModemID(i, 0) = ModemID
                fModemID(i, 1) = -1
                Exit For
            End If
        Next
        If i < 257 Then
            AddNewModem = i
        Else
            AddNewModem = 0
        End If
    End Function

    Private Sub VoiceOCX_AnswerEvent(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_AnswerEvent) Handles VoiceOCX.AnswerEvent
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If (IndexTag <> -1) And (fModemID(IndexTag, 1) = 1) Then
            fAutoForms(IndexTag).VoiceOCX_Answer()
        End If
    End Sub

    Private Sub VoiceOCX_AnswerTone(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_AnswerToneEvent) Handles VoiceOCX.AnswerTone
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If (IndexTag <> -1) And (fModemID(IndexTag, 1) = 1) Then
            fAutoForms(IndexTag).VoiceOCX_AnswerTone()
        End If
    End Sub

    Private Sub VoiceOCX_CallingTone(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_CallingToneEvent) Handles VoiceOCX.CallingTone
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If (IndexTag <> -1) And (fModemID(IndexTag, 1) = 1) Then
            fAutoForms(IndexTag).VoiceOCX_CallingTone()
        End If
    End Sub

    Private Sub VoiceOCX_DTMFReceived(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_DTMFReceivedEvent) Handles VoiceOCX.DTMFReceived
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If (IndexTag <> -1) And (fModemID(IndexTag, 1) = 1) Then
            fAutoForms(IndexTag).VoiceOCX_DTMFReceived()
        End If
    End Sub

    Private Sub VoiceOCX_EndReceive(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_EndReceiveEvent) Handles VoiceOCX.EndReceive
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If (IndexTag <> -1) And (fModemID(IndexTag, 1) = 1) Then
            fAutoForms(IndexTag).VoiceOCX_EndReceive()
        End If
    End Sub

    Private Sub VoiceOCX_EndSend(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_EndSendEvent) Handles VoiceOCX.EndSend
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If (IndexTag <> -1) And (fModemID(IndexTag, 1) = 1) Then
            fAutoForms(IndexTag).VoiceOCX_EndSend()
        End If
    End Sub

    Private Sub VoiceOCX_FaxReceived(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_FaxReceivedEvent) Handles VoiceOCX.FaxReceived
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If (IndexTag <> -1) And (fModemID(IndexTag, 1) = 1) Then
            fAutoForms(IndexTag).VoiceOCX_FaxReceived(e.faxID, e.remoteID)
        End If
    End Sub

    Private Sub VoiceOCX_FaxTerminated(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_FaxTerminatedEvent) Handles VoiceOCX.FaxTerminated
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If (IndexTag <> -1) And (fModemID(IndexTag, 1) = 1) Then
            fAutoForms(IndexTag).VoiceOCX_FaxTerminated(e.tStatus)
        End If
    End Sub

    Private Sub VoiceOCX_HangUpEvent(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_HangUpEvent) Handles VoiceOCX.HangUpEvent
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If (IndexTag <> -1) And (fModemID(IndexTag, 1) = 1) Then
            fAutoForms(IndexTag).VoiceOCX_HangUp()
        End If
    End Sub

    Private Sub VoiceOCX_ModemError(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_ModemErrorEvent) Handles VoiceOCX.ModemError
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If IndexTag <> -1 Then
            Select Case fModemID(IndexTag, 1)
                Case -1
                    MsgBox("Modem OK received on port: " + VoiceOCX.GetPortName(e.modemID))
                Case 0  ' select port
                    frmSelect.VoiceOCX_ModemError()
                Case 1  ' answerphone
                    fAutoForms(IndexTag).VoiceOCX_ModemError()
                Case 2
                    frmSelectDlg.VoiceOCX_ModemError()
                Case 3
                    frmSelectBT.VoiceOCX_ModemError()
                Case 4
                    frmSelectNMS.VoiceOCX_ModemError()
            End Select
        End If
    End Sub

    Private Sub VoiceOCX_ModemOK(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_ModemOKEvent) Handles VoiceOCX.ModemOK
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If IndexTag <> -1 Then
            Select Case fModemID(IndexTag, 1)
                Case 0  ' select port
                    frmSelect.VoiceOCX_ModemOK()
                Case 1  ' answerphone
                    fAutoForms(IndexTag).VoiceOCX_ModemOK()
            End Select
        End If
    End Sub

    Private Sub VoiceOCX_OnHook(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_OnHookEvent) Handles VoiceOCX.OnHook
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If (IndexTag <> -1) And (fModemID(IndexTag, 1) = 1) Then
            fAutoForms(IndexTag).VoiceOCX_OnHook()
        End If
    End Sub

    Private Sub VoiceOCX_PortOpen(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_PortOpenEvent) Handles VoiceOCX.PortOpen
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If IndexTag <> -1 Then
            Select Case fModemID(IndexTag, 1)
                Case -1
                    MsgBox("Modem OK received on port: " + VoiceOCX.GetPortName(fModemID(IndexTag, 0)))
                Case 0  ' select port
                    frmSelect.VoiceOCX_PortOpen()
                Case 2
                    frmSelectDlg.VoiceOCX_PortOpen()
                Case 3
                    frmSelectBT.VoiceOCX_PortOpen()
                Case 4
                    frmSelectNMS.VoiceOCX_PortOpen()
            End Select
        End If
    End Sub

    Private Sub VoiceOCX_Ring(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_RingEvent) Handles VoiceOCX.Ring
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If IndexTag <> -1 Then
            Select Case fModemID(IndexTag, 1)
                Case -1
                    MsgBox("Modem detected RING on port: " + VoiceOCX.GetPortName(fModemID(IndexTag, 0)))
                Case 1 ' answerphone
                    fAutoForms(IndexTag).VoiceOCX_Ring()
            End Select
        End If
    End Sub

    Private Sub VoiceOCX_VoicePlayFinished(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_VoicePlayFinishedEvent) Handles VoiceOCX.VoicePlayFinished
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If (IndexTag <> -1) And (fModemID(IndexTag, 1) = 1) Then
            fAutoForms(IndexTag).VoiceOCX_VoicePlayFinished()
        End If

    End Sub

    Private Sub VoiceOCX_VoicePlayStarted(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_VoicePlayStartedEvent) Handles VoiceOCX.VoicePlayStarted
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If IndexTag <> -1 Then
            Select Case fModemID(IndexTag, 1)
                Case 1
                    fAutoForms(IndexTag).VoiceOCX_VoicePlayStarted()
            End Select
        End If
    End Sub

    Private Sub VoiceOCX_VoiceRecordFinished(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_VoiceRecordFinishedEvent) Handles VoiceOCX.VoiceRecordFinished
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If (IndexTag <> -1) And (fModemID(IndexTag, 1) = 1) Then
            fAutoForms(IndexTag).VoiceOCX_VoiceRecordFinished()
        End If
    End Sub

    Private Sub VoiceOCX_VoiceRecordStarted(ByVal sender As Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_VoiceRecordStartedEvent) Handles VoiceOCX.VoiceRecordStarted
        Dim IndexTag As Integer

        IndexTag = FindTagToModemID(e.modemID)
        If (IndexTag <> -1) And (fModemID(IndexTag, 1) = 1) Then
            fAutoForms(IndexTag).VoiceOCX_VoiceRecordStarted()
        End If
    End Sub

    Private Sub MenuDialogic_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuDialogic.Click
        Dim nIndex As Integer
        Dim ModemID As Long

        ' choose port
        frmSelectDlg = New frmDialogicOpen()
        frmSelectDlg.pparent = Me
        frmSelectDlg.ShowDialog()

        ModemID = frmSelectDlg.GetSelectedChannel
        nIndex = FindTagToModemID(ModemID)
        If nIndex > 0 Then
            ' user selected a communication port
            CreateAutoAnswerChild(nIndex)

            If frmSelectDlg.LogEnabled = True Then
                VoiceOCX.EnableLog(ModemID, True)
            End If
        End If
    End Sub

    Private Sub MenuBrooktrout_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuBrooktrout.Click
        Dim nIndex As Integer
        Dim ModemID As Long

        ' choose port
        frmSelectBT = New frmOpenBrook()
        frmSelectBT.pparent = Me
        frmSelectBT.ShowDialog()

        ModemID = frmSelectBT.GetSelectedChannel
        nIndex = FindTagToModemID(ModemID)
        If nIndex > 0 Then
            ' user selected a communication port
            CreateAutoAnswerChild(nIndex)

            If frmSelectBT.LogEnabled = True Then
                VoiceOCX.EnableLog(ModemID, True)
            End If
        End If
    End Sub

    Public Sub DeleteModem(ByVal ModemID As Long)
        Dim i As Integer

        For i = 1 To 255
            If fModemID(i, 0) = ModemID Then
                fModemID(i, 0) = 0
                fModemID(i, 0) = -1
            End If
        Next
    End Sub

    Private Sub MenuNMS_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuNMS.Click
        Dim nIndex As Integer
        Dim ModemID As Long

        ' choose port
        frmSelectNMS = New frmOpenNMS()
        frmSelectNMS.pparent = Me
        frmSelectNMS.ShowDialog()

        ModemID = frmSelectNMS.GetSelectedChannel
        nIndex = FindTagToModemID(ModemID)
        If nIndex > 0 Then
            CreateAutoAnswerChild(nIndex)

            If frmSelectNMS.LogEnabled = True Then
                VoiceOCX.EnableLog(ModemID, True)
            End If
        End If
    End Sub
End Class
