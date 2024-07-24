VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Object = "{426F4282-5F31-11D1-A131-0040F614A5A0}#1.0#0"; "VoiceOCX.ocx"
Begin VB.MDIForm frmMain 
   BackColor       =   &H8000000C&
   Caption         =   "Interactive Voice Sample"
   ClientHeight    =   4425
   ClientLeft      =   165
   ClientTop       =   450
   ClientWidth     =   8070
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
      Width           =   8070
      _ExtentX        =   14235
      _ExtentY        =   741
      Appearance      =   1
      _Version        =   327682
      Begin VOICEOCXLib.VoiceOCX VoiceOCX 
         Height          =   255
         Left            =   2760
         TabIndex        =   2
         Top             =   120
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
      Top             =   4155
      Width           =   8070
      _ExtentX        =   14235
      _ExtentY        =   476
      SimpleText      =   ""
      _Version        =   327682
      BeginProperty Panels {0713E89E-850A-101B-AFC0-4210102A8DA7} 
         NumPanels       =   3
         BeginProperty Panel1 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            AutoSize        =   1
            Object.Width           =   8599
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
            TextSave        =   "12:00 PM"
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
            Caption         =   "&COM Port..."
         End
         Begin VB.Menu mnuOpenDChannel 
            Caption         =   "&Dialogic Channel..."
         End
         Begin VB.Menu mnuOpenBTChannel 
            Caption         =   "Br&ooktrout Channel..."
         End
         Begin VB.Menu mnuNMSOpenChannel 
            Caption         =   "&NMS Channel..."
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
         Caption         =   "&About Interactive Voice Sample..."
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
    If Dir$("ivsvbhelp.rtf") = "ivsvbhelp.rtf" Then
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
    WritePrivateProfileString "VOICE", "BCMTONES", szBcmTones, szIniFile
    
    If Me.WindowState <> vbMinimized Then
        SaveSetting App.Title, "Settings", "MainLeft", Me.Left
        SaveSetting App.Title, "Settings", "MainTop", Me.Top
        SaveSetting App.Title, "Settings", "MainWidth", Me.Width
        SaveSetting App.Title, "Settings", "MainHeight", Me.Height
    End If
    
    VoiceOCX.DestroyModemObject lModemID
End Sub

Private Sub mnuDTMFEditor_Click()
    frmDTMF.Show vbModal, Me
End Sub

Private Sub mnuHelpAbout_Click()
    AboutDlg.Show vbModal, Me
End Sub

Private Sub mnuNMSOpenChannel_Click()
    ' choose port
    If VoiceOCX.GetNMSBoardNum > 0 Then
        Set frmSelectNMS = New frmOpenNMS
            frmSelectNMS.Show vbModal, Me
    
        If lModemID <> 0 Then
            ' user selected a communication port
            nPrStatus = cnsNoneAttached
            
            If frmSelectNMS.LogEnabled = True Then
                VoiceOCX.EnableLog lModemID, True
            End If
            
            DoOnline
        End If
    Else
        MsgBox "There is no available NMS Channel!", vbOKOnly
    End If

End Sub

Private Sub mnuOnline_Click()
    DoOnline
End Sub

Private Sub mnuOpenBTChannel_Click()
    ' choose port
    If VoiceOCX.GetBrooktroutChannelNum > 0 Then
        Set frmSelectBT = New frmOpenBrook
            frmSelectBT.Show vbModal, Me
    
        If lModemID <> 0 Then
            ' user selected a brooktrout channel
            nPrStatus = cnsNoneAttached
            
            If frmSelectBT.LogEnabled = True Then
                VoiceOCX.EnableLog lModemID, True
            End If
            
            DoOnline
        End If
    Else
        MsgBox "There is no available Brooktrout channel!", vbOKOnly
    End If
End Sub

Private Sub mnuOpenCOMPort_Click()
    DoSelectModem
End Sub

Private Sub mnuOpenDChannel_Click()
    ' choose port
    If VoiceOCX.GetDialogicChannelNum(VoiceOCX.GetDialogicBoardNum) > 0 Then
        Set frmSelectDlg = New frmDialogicOpen
        frmSelectDlg.Show vbModal, Me
    
        If lModemID <> 0 Then
            ' user selected a communication port
            nPrStatus = cnsNoneAttached
            
           
            DoOnline
        End If
    Else
        MsgBox "There is no available Dialogic Channel!", vbOKOnly
    End If
End Sub

Private Sub mnuFileExit_Click()
    'unload the form
    If lModemID <> 0 Then
        VoiceOCX.ClosePort lModemID
    End If
    Unload Me
End Sub

Private Sub DoSelectModem()
    ' choose port
    Set frmSelect = New frmSelectPort
    frmSelect.Show 1, Me

    If lModemID <> 0 Then
        ' user selected a communication port
        nPrStatus = cnsNoneAttached
        
        If frmSelect.LogEnabled = True Then
            VoiceOCX.EnableLog lModemID, True
        End If
        
        DoOnline
    End If
End Sub

Private Sub DoOnline()
    Set fOnline = New frmOnline
    nPrStatus = cnsOnline
    fOnline.Show vbModal, Me
    Set fOnline = Nothing
    
    nPrStatus = cnsNoneAttached
    fMainForm.VoiceOCX.TerminateProcess lModemID
    VoiceOCX.DestroyModemObject lModemID
    lModemID = 0
End Sub

Private Sub VoiceOCX_AnsweringMachine(ByVal ModemID As Long)
    fOnline.VoiceOCX_AnsweringMachine
End Sub

Private Sub VoiceOCX_AnswerTone(ByVal ModemID As Long)
    fOnline.VoiceOCX_AnswerTone
End Sub

Private Sub VoiceOCX_Busy(ByVal ModemID As Long)
    fOnline.VoiceOCX_Busy
End Sub

Private Sub VoiceOCX_CallingTone(ByVal ModemID As Long)
    fOnline.VoiceOCX_CallingTone
End Sub

Private Sub VoiceOCX_CustomToneOFF(ByVal ModemID As Long, ByVal ToneID As Long)
    fOnline.VoiceOCX_CustomToneOFF ToneID
End Sub

Private Sub VoiceOCX_CustomToneON(ByVal ModemID As Long, ByVal ToneID As Long)
    fOnline.VoiceOCX_CustomToneON ToneID
End Sub

Private Sub VoiceOCX_DTMFDigit(ByVal ModemID As Long, ByVal Digit As Integer)
    fOnline.VoiceOCX_DTMFDigit Digit
End Sub

Private Sub VoiceOCX_DTMFReceived(ByVal ModemID As Long)
    fOnline.VoiceOCX_DTMFReceived
End Sub

Private Sub VoiceOCX_DTMFReceivedExt2(ByVal ModemID As Long, ByVal Offset As Long)
    fOnline.VoiceOCX_DTMFReceivedExt2 Offset
End Sub

Private Sub VoiceOCX_DTMFSent(ByVal ModemID As Long)
    fOnline.VoiceOCX_DTMFSent
End Sub

Private Sub VoiceOCX_EndReceive(ByVal ModemID As Long)
    fOnline.VoiceOCX_EndReceive
End Sub

Private Sub VoiceOCX_EndSend(ByVal ModemID As Long)
    fOnline.VoiceOCX_EndSend
End Sub


Private Sub VoiceOCX_FaxReceived(ByVal ModemID As Long, ByVal FaxID As Long, ByVal RemoteID As String)
    fOnline.VoiceOCX_FaxReceived FaxID, RemoteID
End Sub

Private Sub VoiceOCX_FaxTerminated(ByVal ModemID As Long, ByVal Status As Long)
    fOnline.VoiceOCX_FaxTerminated Status
End Sub

Private Sub VoiceOCX_HangUp(ByVal ModemID As Long)
    fOnline.VoiceOCX_HangUp
End Sub

Private Sub VoiceOCX_ModemError(ByVal ModemID As Long)
    Select Case nPrStatus
        Case cnsNoneAttached
            If lModemID <> 0 Then
                MsgBox "Modem OK received on port: " + VoiceOCX.GetPortName(lModemID)
            End If
        Case cnsSelectPort  ' select port
            frmSelect.VoiceOCX_ModemError
        Case cnsOnline  ' online port
            fOnline.VoiceOCX_ModemError
        Case cnsSelectDlg
            frmSelectDlg.VoiceOCX_ModemError
        Case cnsSelectBCM
            frmSelectBCM.VoiceOCX_ModemError
        Case cnsSelectBT
            frmSelectBT.VoiceOCX_ModemError
        Case cnsSelectNMS
            frmSelectNMS.VoiceOCX_ModemError
    End Select
End Sub

Private Sub VoiceOCX_ModemOK(ByVal ModemID As Long)
    Select Case nPrStatus
        Case cnsNoneAttached
            If lModemID <> 0 Then
                MsgBox "Modem OK received on port: " + VoiceOCX.GetPortName(lModemID)
            End If
        Case cnsSelectPort  ' select port
            frmSelect.VoiceOCX_ModemOK
        Case cnsOnline  ' online port
            fOnline.VoiceOCX_ModemOK
    End Select
End Sub

Private Sub VoiceOCX_NoAnswer(ByVal ModemID As Long)
    fOnline.VoiceOCX_NoAnswer
End Sub

Private Sub VoiceOCX_NoCarrier(ByVal ModemID As Long)
    fOnline.VoiceOCX_NoCarrier
End Sub

Private Sub VoiceOCX_NoDialTone(ByVal ModemID As Long)
    fOnline.VoiceOCX_NoDialTone
End Sub

Private Sub VoiceOCX_OffHook(ByVal ModemID As Long)
    fOnline.VoiceOCX_OffHook
End Sub

Private Sub VoiceOCX_OnHook(ByVal ModemID As Long)
    fOnline.VoiceOCX_OnHook
End Sub

Private Sub VoiceOCX_PortOpen(ByVal ModemID As Long)
    Select Case nPrStatus
        Case cnsNoneAttached
            MsgBox "Modem OK received on port: " + VoiceOCX.GetPortName(lModemID)
        Case cnsSelectPort  ' select port
            frmSelect.VoiceOCX_PortOpen
        Case cnsSelectDlg
            frmSelectDlg.VoiceOCX_PortOpen
        Case cnsSelectBCM
            frmSelectBCM.VoiceOCX_PortOpen
        Case cnsSelectBT
            frmSelectBT.VoiceOCX_PortOpen
        Case cnsSelectNMS
            frmSelectNMS.VoiceOCX_PortOpen
    End Select
End Sub

Private Sub VoiceOCX_Ring(ByVal ModemID As Long)
    Select Case nPrStatus
        Case cnsNoneAttached
            MsgBox "Modem detected RING on port: " + VoiceOCX.GetPortName(lModemID)
        Case cnsOnline   ' online port
            fOnline.VoiceOCX_Ring
    End Select
End Sub

Private Sub VoiceOCX_SIT(ByVal ModemID As Long)
    fOnline.VoiceOCX_SIT
End Sub

Private Sub VoiceOCX_ToneSent(ByVal ModemID As Long)
    fOnline.VoiceOCX_ToneSent
End Sub

Private Sub VoiceOCX_VoiceConnect(ByVal ModemID As Long)
    fOnline.VoiceOCX_VoiceConnect
End Sub

Private Sub VoiceOCX_VoicePlayFinished(ByVal ModemID As Long)
    fOnline.VoiceOCX_VoicePlayFinished
End Sub

Private Sub VoiceOCX_VoicePlayFinishedExt2(ByVal ModemID As Long, ByVal Offset As Long)
    fOnline.VoiceOCX_VoicePlayFinishedExt2 Offset
End Sub

Private Sub VoiceOCX_VoicePlayStarted(ByVal ModemID As Long)
    fOnline.VoiceOCX_VoicePlayStarted
End Sub


Private Sub VoiceOCX_VoiceRecordFinished(ByVal ModemID As Long)
    fOnline.VoiceOCX_VoiceRecordFinished
End Sub

Private Sub VoiceOCX_VoiceRecordStarted(ByVal ModemID As Long)
    fOnline.VoiceOCX_VoiceRecordStarted
End Sub

