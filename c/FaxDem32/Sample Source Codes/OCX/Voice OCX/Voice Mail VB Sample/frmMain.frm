VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Object = "{426F4282-5F31-11D1-A131-0040F614A5A0}#1.0#0"; "VoiceOCX.ocx"
Begin VB.MDIForm frmMain 
   BackColor       =   &H8000000C&
   Caption         =   "Voice Mail Sample"
   ClientHeight    =   4230
   ClientLeft      =   165
   ClientTop       =   450
   ClientWidth     =   7800
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   2  'CenterScreen
   WindowState     =   2  'Maximized
   Begin ComctlLib.Toolbar Toolbar1 
      Align           =   1  'Align Top
      Height          =   420
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Visible         =   0   'False
      Width           =   7800
      _ExtentX        =   13758
      _ExtentY        =   741
      Appearance      =   1
      _Version        =   327682
      Begin VOICEOCXLib.VoiceOCX VoiceOCX 
         Height          =   255
         Left            =   6840
         TabIndex        =   2
         Top             =   0
         Width           =   255
         _Version        =   65536
         _ExtentX        =   450
         _ExtentY        =   450
         _StockProps     =   0
      End
   End
   Begin ComctlLib.StatusBar sbStatusBar 
      Align           =   2  'Align Bottom
      Height          =   270
      Left            =   0
      TabIndex        =   0
      Top             =   3960
      Width           =   7800
      _ExtentX        =   13758
      _ExtentY        =   476
      SimpleText      =   ""
      _Version        =   327682
      BeginProperty Panels {0713E89E-850A-101B-AFC0-4210102A8DA7} 
         NumPanels       =   3
         BeginProperty Panel1 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            AutoSize        =   1
            Object.Width           =   8123
            Text            =   "Status"
            TextSave        =   "Status"
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel2 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Style           =   6
            AutoSize        =   2
            TextSave        =   "2/21/2006"
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
         BeginProperty Panel3 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Style           =   5
            AutoSize        =   2
            TextSave        =   "12:06 PM"
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComDlg.CommonDialog dlgCommonDialog 
      Left            =   240
      Top             =   1080
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin ComctlLib.ImageList imlIcons 
      Left            =   840
      Top             =   1080
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   327682
      BeginProperty Images {0713E8C2-850A-101B-AFC0-4210102A8DA7} 
         NumListImages   =   2
         BeginProperty ListImage1 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":030A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {0713E8C3-850A-101B-AFC0-4210102A8DA7} 
            Picture         =   "frmMain.frx":0368
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuFileExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuVoice 
      Caption         =   "&Voice/Fax"
      Begin VB.Menu mnuOpenPort 
         Caption         =   "&Open port"
         Begin VB.Menu mnuOpenCOMPort 
            Caption         =   "&COM Port"
         End
         Begin VB.Menu mnuOpenDChannel 
            Caption         =   "&Dialogic Channel"
         End
         Begin VB.Menu mnuOpenBTChannel 
            Caption         =   "Br&ooktrout Channel"
         End
         Begin VB.Menu mnuNMSOpenChannel 
            Caption         =   "&NMS Channel"
         End
      End
   End
   Begin VB.Menu mnuWindow 
      Caption         =   "&Window"
      WindowList      =   -1  'True
      Begin VB.Menu mnuWindowCascade 
         Caption         =   "&Cascade"
      End
      Begin VB.Menu mnuWindowTileHorizontal 
         Caption         =   "Tile &Horizontal"
      End
      Begin VB.Menu mnuWindowTileVertical 
         Caption         =   "Tile &Vertical"
      End
      Begin VB.Menu mnuWindowArrangeIcons 
         Caption         =   "&Arrange Icons"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      Begin VB.Menu Help 
         Caption         =   "&Help"
      End
      Begin VB.Menu mnuHelpAbout 
         Caption         =   "&About VoiceOCXDemo..."
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Declare Function OSWinHelp% Lib "user32" Alias "WinHelpA" (ByVal hWnd&, ByVal HelpFile$, ByVal wCommand%, dwData As Any)

Private Sub Help_Click()
    If Dir$("vmvbhelp.rtf") = "vmvbhelp.rtf" Then
        Dim helpDlg As frmHelp
        Set helpDlg = New frmHelp
        helpDlg.Show vbModal, Me
    Else
        MsgBox "Error, cannot find the help file!", vbCritical + vbOKOnly, "Error"
    End If
End Sub

Private Sub MDIForm_Load()

    Me.Left = GetSetting(App.Title, "Settings", "MainLeft", 1000)
    Me.Top = GetSetting(App.Title, "Settings", "MainTop", 1000)
    Me.Width = GetSetting(App.Title, "Settings", "MainWidth", 6500)
    Me.Height = GetSetting(App.Title, "Settings", "MainHeight", 6500)
    
    VoiceOCX.SetLogDir szExePath
    
    szConfigFile = "BTCALL.CFG"
    
End Sub
Private Sub MDIForm_Unload(Cancel As Integer)
    Dim nIndex As Integer
    
    If Me.WindowState <> vbMinimized Then
        SaveSetting App.Title, "Settings", "MainLeft", Me.Left
        SaveSetting App.Title, "Settings", "MainTop", Me.Top
        SaveSetting App.Title, "Settings", "MainWidth", Me.Width
        SaveSetting App.Title, "Settings", "MainHeight", Me.Height
    End If
    
    For nIndex = 1 To 256 Step 1
        If fModemID(nIndex, 0) <> 0 Then
            VoiceOCX.DestroyModemObject fModemID(nIndex, 0)
        End If
    Next
End Sub
Private Sub mnuDTMFEditor_Click()
    frmDTMF.Show vbModal, Me
End Sub
Private Sub mnuHelpAbout_Click()
    AboutDlg.Show vbModal, Me
End Sub
Private Sub mnuNMSOpenChannel_Click()
    Dim nIndex As Integer
    Dim ModemID As Long
    
    ' choose port
    Set frmSelectNMS = New frmOpenNMS
        frmSelectNMS.Show vbModal, Me

    ModemID = frmSelectNMS.GetSelectedChannel
    nIndex = FindTagToModemID(ModemID)
    If nIndex > 0 Then
        CreateAutoAnswerChild (nIndex)
        
        If frmSelectNMS.LogEnabled = True Then
            VoiceOCX.EnableLog ModemID, True
        End If
    End If

End Sub
Private Sub mnuOpenBTChannel_Click()
    Dim nIndex As Integer
    Dim ModemID As Long
    
    ' choose port
    Set frmSelectBT = New frmOpenBrook
        frmSelectBT.Show vbModal, Me

    ModemID = frmSelectBT.GetSelectedChannel
    nIndex = FindTagToModemID(ModemID)
    If nIndex > 0 Then
        ' user selected a communication port
        CreateAutoAnswerChild (nIndex)
        
        If frmSelectBT.LogEnabled = True Then
            VoiceOCX.EnableLog ModemID, True
        End If
    End If
End Sub

Private Sub mnuOpenCOMPort_Click()
    DoSelectModem
End Sub

Private Sub mnuOpenDChannel_Click()
    Dim nIndex As Integer
    Dim ModemID As Long
    
    ' choose port
    Set frmSelectDlg = New frmDialogicOpen
    frmSelectDlg.Show vbModal, Me

    ModemID = frmSelectDlg.GetSelectedChannel
    nIndex = FindTagToModemID(ModemID)
    If nIndex > 0 Then
        ' user selected a communication port
        CreateAutoAnswerChild (nIndex)
        
        If frmSelectDlg.LogEnabled = True Then
            VoiceOCX.EnableLog ModemID, True
        End If
    End If
End Sub
Private Sub mnuFileOpen_Click()
    Dim sFile As String


    With dlgCommonDialog
        'To Do
        'set the flags and attributes of the
        'common dialog control
        .Filter = "All Files (*.*)|*.*"
        .ShowOpen
        If Len(.FileName) = 0 Then
            Exit Sub
        End If
        sFile = .FileName
    End With
    'To Do
    'process the opened file
End Sub


Private Sub mnuFileClose_Click()
    'To Do
    MsgBox "Close Code goes here!"
End Sub

Private Sub mnuFileSaveAs_Click()
    'To Do
    'Setup the common dialog control
    'prior to calling ShowSave
    dlgCommonDialog.ShowSave
End Sub


Private Sub mnuFilePageSetup_Click()
    dlgCommonDialog.ShowPrinter
End Sub

Private Sub mnuFilePrint_Click()
    'To Do
    MsgBox "Print Code goes here!"
End Sub

Private Sub mnuFileExit_Click()
    'unload the form
    Unload Me
End Sub

Private Sub DoSelectModem()
    Dim nIndex As Integer
    Dim ModemID As Long
    
    ' choose port
    Set frmSelect = New frmSelectPort
    frmSelect.Show 1, Me

    ModemID = frmSelect.GetSelectedPort
    nIndex = FindTagToModemID(ModemID)
    If nIndex > 0 Then
        ' user selected a communication port
        CreateAutoAnswerChild (nIndex)
        
        If frmSelect.LogEnabled = True Then
            VoiceOCX.EnableLog ModemID, True
        End If
    End If
End Sub

Private Sub DoCloseModem()
    MsgBox "DoCloseModem"
End Sub
Private Sub VoiceOCX_Answer(ByVal ModemID As Long)
    Dim IndexTag As Integer
    
    IndexTag = FindTagToModemID(ModemID)
    If (IndexTag <> -1) And (fModemID(IndexTag, 1) = cnsAutoAnswer) Then
        fAutoForms(IndexTag).VoiceOCX_Answer
    End If
End Sub

Private Sub VoiceOCX_AnswerTone(ByVal ModemID As Long)
    IndexTag = FindTagToModemID(ModemID)
    If (IndexTag <> -1) And (fModemID(IndexTag, 1) = cnsAutoAnswer) Then
        fAutoForms(IndexTag).VoiceOCX_AnswerTone
    End If
End Sub
Private Sub VoiceOCX_CallingTone(ByVal ModemID As Long)
    Dim IndexTag As Integer
    
    IndexTag = FindTagToModemID(ModemID)
    If (IndexTag <> -1) And (fModemID(IndexTag, 1) = cnsAutoAnswer) Then
        fAutoForms(IndexTag).VoiceOCX_CallingTone
    End If
End Sub
Private Sub VoiceOCX_DTMFReceived(ByVal ModemID As Long)
    Dim IndexTag As Integer
    
    IndexTag = FindTagToModemID(ModemID)
    If (IndexTag <> -1) And (fModemID(IndexTag, 1) = cnsAutoAnswer) Then
        fAutoForms(IndexTag).VoiceOCX_DTMFReceived
    End If
End Sub
Private Sub VoiceOCX_EndReceive(ByVal ModemID As Long)
    Dim IndexTag As Integer
    
    IndexTag = FindTagToModemID(ModemID)
    If (IndexTag <> -1) And (fModemID(IndexTag, 1) = cnsAutoAnswer) Then
        fAutoForms(IndexTag).VoiceOCX_EndReceive
    End If
End Sub
Private Sub VoiceOCX_EndSend(ByVal ModemID As Long)
    Dim IndexTag As Integer
    
    IndexTag = FindTagToModemID(ModemID)
    If (IndexTag <> -1) And (fModemID(IndexTag, 1) = cnsAutoAnswer) Then
        fAutoForms(IndexTag).VoiceOCX_EndSend
    End If
End Sub

Private Sub VoiceOCX_FaxReceived(ByVal ModemID As Long, ByVal FaxID As Long, ByVal RemoteID As String)
    Dim IndexTag As Integer
    
    IndexTag = FindTagToModemID(ModemID)
    If (IndexTag <> -1) And (fModemID(IndexTag, 1) = cnsAutoAnswer) Then
        fAutoForms(IndexTag).VoiceOCX_FaxReceived FaxID, RemoteID
    End If

End Sub

Private Sub VoiceOCX_FaxTerminated(ByVal ModemID As Long, ByVal Status As Long)
    Dim IndexTag As Integer
    
    IndexTag = FindTagToModemID(ModemID)
    If (IndexTag <> -1) And (fModemID(IndexTag, 1) = cnsAutoAnswer) Then
        fAutoForms(IndexTag).VoiceOCX_FaxTerminated Status
    End If
End Sub
Private Sub VoiceOCX_HangUp(ByVal ModemID As Long)
    Dim IndexTag As Integer
    
    IndexTag = FindTagToModemID(ModemID)
    If (IndexTag <> -1) And (fModemID(IndexTag, 1) = cnsAutoAnswer) Then
        fAutoForms(IndexTag).VoiceOCX_HangUp
    End If
End Sub
Private Sub VoiceOCX_ModemError(ByVal ModemID As Long)
    Dim IndexTag As Integer
    
    IndexTag = FindTagToModemID(ModemID)
    If IndexTag <> -1 Then
        Select Case fModemID(IndexTag, 1)
            Case cnsNoneAttached
                MsgBox "Modem OK received on port: " + VoiceOCX.GetPortName(ModemID)
            Case cnsSelectPort  ' select port
                frmSelect.VoiceOCX_ModemError
            Case cnsAutoAnswer  ' answerphone
                fAutoForms(IndexTag).VoiceOCX_ModemError
            Case cnsSelectDlg
                frmSelectDlg.VoiceOCX_ModemError
            Case cnsSelectBT
                frmSelectBT.VoiceOCX_ModemError
            Case cnsSelectNMS
                frmSelectNMS.VoiceOCX_ModemError
        End Select
    End If
End Sub
Private Sub VoiceOCX_ModemOK(ByVal ModemID As Long)
    Dim IndexTag As Integer
    
    IndexTag = FindTagToModemID(ModemID)
    If IndexTag <> -1 Then
        Select Case fModemID(IndexTag, 1)
            Case cnsSelectPort  ' select port
                frmSelect.VoiceOCX_ModemOK
            Case cnsAutoAnswer  ' answerphone
                fAutoForms(IndexTag).VoiceOCX_ModemOK
        End Select
    End If
End Sub
Private Sub VoiceOCX_OnHook(ByVal ModemID As Long)
    IndexTag = FindTagToModemID(ModemID)
    If (IndexTag <> -1) And (fModemID(IndexTag, 1) = cnsAutoAnswer) Then
        fAutoForms(IndexTag).VoiceOCX_OnHook
    End If
End Sub
Private Sub VoiceOCX_PortOpen(ByVal ModemID As Long)
    Dim IndexTag As Integer
    
    IndexTag = FindTagToModemID(ModemID)
    If IndexTag <> -1 Then
        Select Case fModemID(IndexTag, 1)
            Case cnsNoneAttached
                MsgBox "Modem OK received on port: " + VoiceOCX.GetPortName(fModemID(IndexTag, 0))
            Case cnsSelectPort  ' select port
                frmSelect.VoiceOCX_PortOpen
            Case cnsSelectDlg
                frmSelectDlg.VoiceOCX_PortOpen
            Case cnsSelectBT
                frmSelectBT.VoiceOCX_PortOpen
            Case cnsSelectNMS
                frmSelectNMS.VoiceOCX_PortOpen
        End Select
    End If
End Sub
Private Sub VoiceOCX_Ring(ByVal ModemID As Long)
    Dim IndexTag As Integer
    
    IndexTag = FindTagToModemID(ModemID)
    If IndexTag <> -1 Then
        Select Case fModemID(IndexTag, 1)
            Case cnsNoneAttached
                MsgBox "Modem detected RING on port: " + VoiceOCX.GetPortName(fModemID(IndexTag, 0))
            Case cnsAutoAnswer  ' answerphone
                fAutoForms(IndexTag).VoiceOCX_Ring
        End Select
    End If
End Sub
Public Sub CreateAutoAnswerChild(nIndex As Integer)
    Set fAutoForms(nIndex) = New frmAutoAnswer
    fModemID(nIndex, 1) = cnsAutoAnswer
    fAutoForms(nIndex).SetModemID (fModemID(nIndex, 0))
    fAutoForms(nIndex).Show
End Sub
Private Sub VoiceOCX_VoicePlayFinished(ByVal ModemID As Long)
    Dim IndexTag As Integer
    
    IndexTag = FindTagToModemID(ModemID)
    If (IndexTag <> -1) And (fModemID(IndexTag, 1) = cnsAutoAnswer) Then
        fAutoForms(IndexTag).VoiceOCX_VoicePlayFinished
    End If
End Sub
Private Sub VoiceOCX_VoicePlayStarted(ByVal ModemID As Long)
    Dim IndexTag As Integer
    
    IndexTag = FindTagToModemID(ModemID)
    If IndexTag <> -1 Then
        Select Case fModemID(IndexTag, 1)
            Case cnsAutoAnswer
                fAutoForms(IndexTag).VoiceOCX_VoicePlayStarted
        End Select
    End If
End Sub
Private Sub VoiceOCX_VoiceRecordFinished(ByVal ModemID As Long)
    Dim IndexTag As Integer
    
    IndexTag = FindTagToModemID(ModemID)
    If (IndexTag <> -1) And (fModemID(IndexTag, 1) = cnsAutoAnswer) Then
        fAutoForms(IndexTag).VoiceOCX_VoiceRecordFinished
    End If
End Sub
Private Sub VoiceOCX_VoiceRecordStarted(ByVal ModemID As Long)
    Dim IndexTag As Integer
    
    IndexTag = FindTagToModemID(ModemID)
    If (IndexTag <> -1) And (fModemID(IndexTag, 1) = cnsAutoAnswer) Then
        fAutoForms(IndexTag).VoiceOCX_VoiceRecordStarted
    End If
End Sub
