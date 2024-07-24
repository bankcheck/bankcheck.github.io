VERSION 5.00
Object = "{426F4282-5F31-11D1-A131-0040F614A5A0}#1.0#0"; "VoiceOCX.ocx"
Begin VB.Form frmMain 
   Caption         =   "ReceiveDTMFandDecidetoReceiveFaxOrVoice"
   ClientHeight    =   5850
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5070
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5850
   ScaleWidth      =   5070
   StartUpPosition =   3  'Windows Default
   Begin VOICEOCXLib.VoiceOCX VoiceOCX 
      Height          =   255
      Left            =   2160
      TabIndex        =   15
      Top             =   0
      Width           =   255
      _Version        =   65536
      _ExtentX        =   450
      _ExtentY        =   450
      _StockProps     =   0
   End
   Begin VB.CommandButton Exit 
      Caption         =   "Exit"
      Height          =   375
      Left            =   3600
      TabIndex        =   14
      Top             =   5280
      Width           =   1215
   End
   Begin VB.CommandButton Help 
      Caption         =   "Help"
      Height          =   375
      Left            =   2280
      TabIndex        =   13
      Top             =   5280
      Width           =   1215
   End
   Begin VB.CommandButton CloseButton 
      Caption         =   "Close port/channel"
      Height          =   375
      Left            =   240
      TabIndex        =   12
      Top             =   5280
      Width           =   1815
   End
   Begin VB.Frame Frame3 
      Caption         =   "Port status"
      Height          =   2415
      Left            =   120
      TabIndex        =   9
      Top             =   2760
      Width           =   4815
      Begin VB.CommandButton HangUpButton 
         Caption         =   "Hang up"
         Height          =   375
         Left            =   3240
         TabIndex        =   16
         Top             =   1920
         Width           =   1335
      End
      Begin VB.CommandButton Clear 
         Caption         =   "Clear"
         Height          =   375
         Left            =   240
         TabIndex        =   11
         Top             =   1920
         Width           =   1335
      End
      Begin VB.ListBox lstEvents 
         Height          =   1425
         Left            =   240
         TabIndex        =   10
         Top             =   360
         Width           =   4335
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "Functions"
      Height          =   975
      Left            =   120
      TabIndex        =   5
      Top             =   1680
      Width           =   4815
      Begin VB.CommandButton RecordMessage 
         Caption         =   "Record message"
         Height          =   375
         Left            =   3240
         TabIndex        =   8
         Top             =   360
         Width           =   1455
      End
      Begin VB.CommandButton WaitForDTMF 
         Caption         =   "Wait for DTMF"
         Height          =   375
         Left            =   1680
         TabIndex        =   7
         Top             =   360
         Width           =   1455
      End
      Begin VB.CommandButton ReceiveFax 
         Caption         =   "Receive Fax"
         Height          =   375
         Left            =   120
         TabIndex        =   6
         Top             =   360
         Width           =   1455
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Open port/channel"
      Height          =   1455
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4815
      Begin VB.CommandButton OpenNMS 
         Caption         =   "Open NMS channel"
         Height          =   375
         Left            =   2520
         TabIndex        =   4
         Top             =   840
         Width           =   1935
      End
      Begin VB.CommandButton OpenBrooktrout 
         Caption         =   "Open Brooktrout channel"
         Height          =   375
         Left            =   360
         TabIndex        =   3
         Top             =   840
         Width           =   1935
      End
      Begin VB.CommandButton OpenDialogic 
         Caption         =   "Open Dialogic channel"
         Height          =   375
         Left            =   2520
         TabIndex        =   2
         Top             =   360
         Width           =   1935
      End
      Begin VB.CommandButton OpenCOM 
         Caption         =   "Open COM port"
         Height          =   375
         Left            =   360
         TabIndex        =   1
         Top             =   360
         Width           =   1935
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
 
Private nProgressStatus As Integer
Private bConnEstab As Boolean
Private nAutoScroll As Integer

Private isDTMFTerminated As Boolean
Private isHangingUp As Boolean
Private szVoiceFile As String
Private Sub AddToLog(text As String)

    lstEvents.AddItem text
    itemcount = lstEvents.ListCount
    If nAutoScroll = 1 Then
        lstEvents.TopIndex = itemcount - 1
    End If
End Sub

Private Sub Clear_Click()
    lstEvents.Clear
End Sub


Private Sub CloseButton_Click()
    If lModemID <> 0 Then
        VoiceOCX.ClosePort lModemID
        AddToLog "Port/channel closed."
        VoiceOCX.DestroyModemObject lModemID
        lModemID = 0
        EnableButtons False, False
        CloseButton.Enabled = False
    End If
End Sub

Private Sub Exit_Click()
    nProgressStatus = cnsExit
    AddToLog "Exiting..."
    If lModemID <> 0 Then
        VoiceOCX.ClosePort lModemID
    End If
    Unload Me
End Sub

Private Sub HangUpButton_Click()
    If nProgressStatus = 0 Then
        nProgressStatus = cnsHangup
        fMainForm.VoiceOCX.HangUp lModemID
    End If

    EnableButtons True, False
    CloseButton.Enabled = True
End Sub


Private Sub Help_Click()
    Dim helpDlg As frmHelp
    Set helpDlg = New frmHelp
    helpDlg.Show vbModal, Me
End Sub

Private Sub OpenBrooktrout_Click()
    ' choose port
    If VoiceOCX.GetBrooktroutChannelNum > 0 Then
        Set frmSelectBT = New frmOpenBrook
            frmSelectBT.Show vbModal, Me
        If lModemID <> 0 Then
            ' user selected a brooktrout channel
            nPrStatus = cnsNoneAttached
            AddToLog "Modem/channel is ready to answer incoming calls"
            If frmSelectBT.LogEnabled = True Then
                VoiceOCX.EnableLog lModemID, True
            End If
    
            nPrStatus = cnsOnline
            nProgressStatus = 0
            bConnEstab = False
            nAutoScroll = 1
            EnableButtons True, False
            VoiceOCX.WaitForRings lModemID, 2
        End If
    Else
        MsgBox "There is no available Brooktrout channel!", vbOKOnly
    End If
End Sub

Private Sub OpenCOM_Click()
    DoSelectModem
End Sub

Private Sub Form_Load()
    
    Dim nIndex As Integer
    Dim nOK As Integer
    
    nPrStatus = cnsNoneAttached
    
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
    
    szExePath = App.Path
    szIniFile = szExePath + "\VOCXDEMO.INI"
    
    szGreetingMessage = String$(256, 0)
    nOK = GetPrivateProfileString("VOICE", "Greeting message", "", szGreetingMessage, Len(szGreetingMessage), szIniFile)
    
    VoiceOCX.SetLogDir szExePath

    szConfigFile = "BTCALL.CFG"
    
    isDTMFTerminated = False
    isHangingUp = False

    Set fMainForm = Me
    
    EnableButtons False, False
    CloseButton.Enabled = False
End Sub

Private Sub Form_Unload(Cancel As Integer)
    WritePrivateProfileString "VOICE", "BCMTONES", szBcmTones, szIniFile
    
    nPrStatus = cnsNoneAttached
    VoiceOCX.TerminateProcess lModemID
    If lModemID <> 0 Then
        VoiceOCX.DestroyModemObject lModemID
    End If
    lModemID = 0
End Sub

Private Sub DoSelectModem()
    ' choose port
    Set frmSelect = New frmSelectPort
    frmSelect.Show 1, Me

    If lModemID <> 0 Then
        ' user selected a communication port
        nPrStatus = cnsNoneAttached
        AddToLog ("Modem/channel is ready to answer incoming calls")
        If frmSelect.LogEnabled = True Then
            VoiceOCX.EnableLog lModemID, True
        End If

        nPrStatus = cnsOnline
        nProgressStatus = 0
        bConnEstab = False
        nAutoScroll = 1
        EnableButtons True, False
        VoiceOCX.WaitForRings lModemID, 2
    End If
End Sub

Private Sub OpenDialogic_Click()

    ' choose port
    If VoiceOCX.GetDialogicChannelNum(VoiceOCX.GetDialogicBoardNum) > 0 Then
        Set frmSelectDlg = New frmDialogicOpen
        frmSelectDlg.Show vbModal, Me
    
        If lModemID <> 0 Then
            ' user selected a communication port
            nPrStatus = cnsNoneAttached
            AddToLog ("Modem/channel is ready to answer incoming calls")

            nPrStatus = cnsOnline
            nProgressStatus = 0
            bConnEstab = False
            nAutoScroll = 1
            EnableButtons True, False
            VoiceOCX.WaitForRings lModemID, 2
        End If
    Else
        MsgBox "There is no available Dialogic Channel!", vbOKOnly
    End If
End Sub

Private Sub OpenNMS_Click()
    ' choose port
    If VoiceOCX.GetNMSBoardNum > 0 Then
        Set frmSelectNMS = New frmOpenNMS
            frmSelectNMS.Show vbModal, Me
    
        If lModemID <> 0 Then
            ' user selected a communication port
            nPrStatus = cnsNoneAttached
            AddToLog ("Modem/channel is ready to answer incoming calls")
            
            If frmSelectNMS.LogEnabled = True Then
                VoiceOCX.EnableLog lModemID, True
            End If

            nPrStatus = cnsOnline
            nProgressStatus = 0
            bConnEstab = False
            nAutoScroll = 1
            EnableButtons True, False
            VoiceOCX.WaitForRings lModemID, 2
        End If
    Else
        MsgBox "There is no available NMS Channel!", vbOKOnly
    End If
End Sub

Private Sub ReceiveFax_Click()
    If VoiceOCX.ReceiveFaxNow(lModemID) = 0 Then
        nProgressStatus = cnsRecFax
        CloseButton.Enabled = False
    Else
        AddToLog "ReceiveFaxNow failed"
    End If
End Sub

Private Sub RecordMessage_Click()
    Dim nDF As Integer
    Dim nSR As Integer
    Dim bWAV As Boolean
            
    bWAV = cnsWAV
    nDF = MDF_PCM
    nSR = MSR_11KHZ
    
    szVoiceFile = szExePath + "\VOICE\MAIL_" + Conversion.CStr(Year(DateTime.Date)) + "_" _
                                                     + Conversion.CStr(Month(DateTime.Date)) + "_" _
                                                     + Conversion.CStr(Day(DateTime.Date)) + "_" _
                                                     + Conversion.CStr(Hour(DateTime.Time)) + "_" _
                                                     + Conversion.CStr(Minute(DateTime.Time)) + "_" _
                                                     + Conversion.CStr(Second(DateTime.Time))
    szVoiceFile = szVoiceFile + ".wav"

    If VoiceOCX.RecordVoiceExt(lModemID _
                                        , szVoiceFile _
                                        , MDM_LINE _
                                        , 60 _
                                        , True _
                                        , 10 _
                                        , bWAV _
                                        , nDF _
                                        , nSR _
                                        , 5 _
                                        , Asc("#") _
                                        ) = 0 Then
         nProgressStatus = cnsRecord
     Else
         AddToLog "RecordVoice failed"
     End If
End Sub


Private Sub VoiceOCX_DTMFDigit(ByVal ModemID As Long, ByVal Digit As Integer)
    nProgressStatus = 0
    AddToLog ("Received DTMF digit(s): [" + Chr(Digit) + "]")

    CloseButton.Enabled = True
End Sub

Private Sub VoiceOCX_DTMFReceived(ByVal ModemID As Long)
    AddToLog ("Received DTMF digit(s): [" + VoiceOCX.GetReceivedDTMFDigits(lModemID) + "]")
    nPrStatus = cnsOnline
    isDTMFTerminated = True
    VoiceOCX.TerminateProcess lModemID
    nProgressStatus = 0
    CloseButton.Enabled = True
End Sub

Private Sub VoiceOCX_DTMFReceivedExt2(ByVal ModemID As Long, ByVal Offset As Long)
    AddToLog ("Received DTMF digit(s): [" + VoiceOCX.GetReceivedDTMFDigits(lModemID) + "]")
    AddToLog ("Offset:" + Str(Offset))
    nPrStatus = cnsOnline
    isDTMFTerminated = True
    VoiceOCX.TerminateProcess lModemID
    nProgressStatus = 0
    CloseButton.Enabled = True
End Sub


Private Sub VoiceOCX_EndReceive(ByVal ModemID As Long)
    nProgressStatus = 0


    If Not isHangingUp Then
        If localFaxID <> 0 Then
            AddToLog "Fax was received."
            Dim szFaxName As String
            szFaxName = szExePath + "\Fax.In\REC_" + Conversion.CStr(Year(DateTime.Date)) + "_" _
                                                         + Conversion.CStr(Month(DateTime.Date)) + "_" _
                                                         + Conversion.CStr(Day(DateTime.Date)) + "_" _
                                                         + Conversion.CStr(Hour(DateTime.Time)) + "_" _
                                                         + Conversion.CStr(Minute(DateTime.Time)) + "_" _
                                                         + Conversion.CStr(Second(DateTime.Time)) + ".TIF"
            If Right(szFaxName, 4) <> ".TIF" Then
                szFaxName = szFaxName + ".TIF"
            End If
            If Mid(szFaxName, 2, 1) <> ":" Then
                szFaxName = szExePath + "\" + szFaxName
            End If
            If szFaxName <> "" Then
                Dim nPageNum As Integer, Res  As Integer, Width  As Integer, Length  As Integer, Comp  As Integer, Bin  As Integer, Bitord As Integer, Ecm As Integer, Color As Integer, ClrType As Integer
                Dim Append As Boolean
    
                Append = False
    
                VoiceOCX.GetFaxParam localFaxID, nPageNum, Res, Width, Length, Comp, Bin, Bitord, Ecm, Color, ClrType
                For nIndex = 0 To nPageNum - 1 Step 1
                    VoiceOCX.GetFaxImagePage localFaxID, nIndex, IMT_FILE_TIFF_NOCOMP, Append, szFaxName
                    Append = True
                Next
            End If
    
            MsgBox "Saving received fax as: " + szFaxName, vbOKOnly
    
            VoiceOCX.ClearFaxObject localFaxID
            localFaxID = 0
        Else
            AddToLog ("No fax was received")
        End If
    Else
        isHangingUp = False
    End If
    HangUpButton_Click
End Sub



Private Sub VoiceOCX_FaxReceived(ByVal ModemID As Long, ByVal FaxID As Long, ByVal RemoteID As String)
'    AddToLog "Fax was received"
    AddToLog "Remote Identifier:" + RemoteID
    localFaxID = FaxID
End Sub

Private Sub VoiceOCX_FaxTerminated(ByVal ModemID As Long, ByVal Status As Long)
    AddToLog "Fax termination status: [" + Str(Status) + "]"
    If Status <> 0 Then
        AddToLog "Modem is hanging up..."
        isHangingUp = True
    End If
    CloseButton.Enabled = True
End Sub

Private Sub VoiceOCX_HangUp(ByVal ModemID As Long)

    Select Case nProgressStatus
        Case cnsHangup      ' hang-up
            AddToLog "The call has been disconnected"
            nProgressStatus = 0
            bConnEstab = False
        Case cnsOffHook      ' off-hook
            AddToLog "Voice connection was established"
            nProgressStatus = 0
            bConnEstab = True
        Case cnsExit    ' exit
            Unload Me
    End Select

    EnableButtons True, False
End Sub


Private Sub VoiceOCX_ModemError(ByVal ModemID As Long)
    Select Case nPrStatus
        Case cnsNoneAttached
            MsgBox "Modem OK received on port: " + VoiceOCX.GetPortName(lModemID)
        Case cnsSelectPort  ' select port
            frmSelect.VoiceOCX_ModemError
        Case cnsSelectDlg
            frmSelectDlg.VoiceOCX_ModemError
        Case cnsSelectBCM
            frmSelectBCM.VoiceOCX_ModemError
        Case cnsSelectBT
            frmSelectBT.VoiceOCX_ModemError
        Case cnsSelectNMS
            frmSelectNMS.VoiceOCX_ModemError
        Case Else
            If isDTMFTerminated = False Then
                AddToLog "Operation failed. Error message was received."
            End If
            nProgressStatus = 0
            CloseButton.Enabled = True
    End Select
End Sub

Private Sub VoiceOCX_ModemOK(ByVal ModemID As Long)
    Select Case nPrStatus
        Case cnsNoneAttached
            MsgBox "Modem OK received on port: " + VoiceOCX.GetPortName(lModemID)
        Case cnsSelectPort  ' select port
            frmSelect.VoiceOCX_ModemOK
    End Select
End Sub


Private Sub VoiceOCX_OffHook(ByVal ModemID As Long)
    If nProgressStatus = cnsDial Or nProgressStatus = cnsAnswer Then ' dial or answer
        nProgressStatus = 0
        AddToLog "Voice connection was established"
        EnableButtons True, True
        bConnEstab = True
    End If

End Sub

Private Sub VoiceOCX_OnHook(ByVal ModemID As Long)
    If nProgressStatus = cnsDial Or nProgressStatus = cnsAnswer Then ' dial or answer
        AddToLog "Pick up the phone!"
    ElseIf nProgressStatus = cnsHangup Or nProgressStatus = cnsPlay Or nProgressStatus = cnsRecord Or nProgressStatus = cnsWaitDTMF Then
        AddToLog "Remote side has disconnected. Hang up the line."
    End If
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
    CloseButton.Enabled = True
End Sub

Private Sub VoiceOCX_Ring(ByVal ModemID As Long)
    Select Case nPrStatus
        Case cnsNoneAttached
            MsgBox "Modem detected RING on port: " + VoiceOCX.GetPortName(lModemID)
        Case cnsOnline   ' online port
            Dim CallerIDInf As String
            Dim bFlag As Boolean
            Dim j As Integer
            Dim i As Integer
            Dim t1, t2 As String
           
            AddToLog "Incoming call was detected."
            nProgressStatus = cnsAnswer
            VoiceOCX.OnlineAnswer lModemID

    End Select
End Sub


Private Sub VoiceOCX_VoiceConnect(ByVal ModemID As Long)
    AddToLog "Voice connection was established"
    nProgressStatus = 0
    bConnEstab = True
    EnableButtons True, True

    CloseButton.Enabled = True
End Sub



Private Sub VoiceOCX_VoiceRecordFinished(ByVal ModemID As Long)
    nProgressStatus = 0
    AddToLog ("Received DTMF digit(s): [" + VoiceOCX.GetReceivedDTMFDigits(lModemID) + "]")
    AddToLog "Recording voice message was finished"
    MsgBox "Voice file has saved to: " + szVoiceFile
    CloseButton.Enabled = True
End Sub

Private Sub VoiceOCX_VoiceRecordStarted(ByVal ModemID As Long)
    CloseButton.Enabled = False
    AddToLog "Recording voice message was started"
End Sub

Private Sub EnableButtons(ByVal bEnabled1 As Boolean, ByVal bEnabled2 As Boolean)

    ReceiveFax.Enabled = bEnabled2
    WaitForDTMF.Enabled = bEnabled2
    RecordMessage.Enabled = bEnabled2
    HangUpButton.Enabled = bEnabled2
    
    OpenCOM.Enabled = Not bEnabled1
    OpenDialogic.Enabled = Not bEnabled1
    OpenBrooktrout.Enabled = Not bEnabled1
    OpenNMS.Enabled = Not bEnabled1
End Sub


Private Sub WaitForDTMF_Click()

    Dim dtmfWait As frmWaitforDTMF
    Dim nNum As Integer
    Dim nDelim As Integer

    isDTMFTerminated = False
    Set dtmfWait = New frmWaitforDTMF
    dtmfWait.Show vbModal, Me
    nNum = dtmfWait.GetNumberOfDigits
    nDelim = dtmfWait.GetDelimiter
    Set dtmfWait = Nothing

    If nNum > 0 Then
        If VoiceOCX.WaitForDTMF(lModemID, nNum, nDelim, 20) = 0 Then
            AddToLog ("Wait for DTMF digits")
            CloseButton.Enabled = False
            nProgressStatus = cnsWaitDTMF
        Else
            AddToLog ("WaitForDTMF failed")
        End If
    End If

End Sub
