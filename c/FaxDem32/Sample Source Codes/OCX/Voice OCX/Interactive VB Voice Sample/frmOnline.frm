VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "Comdlg32.ocx"
Begin VB.Form frmOnline 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Online Functions"
   ClientHeight    =   6630
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4830
   ControlBox      =   0   'False
   Icon            =   "frmOnline.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6630
   ScaleWidth      =   4830
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton btHelp 
      Caption         =   "Help"
      Height          =   375
      Left            =   3600
      TabIndex        =   23
      Top             =   6120
      Width           =   1095
   End
   Begin MSComDlg.CommonDialog cmdDlg 
      Left            =   0
      Top             =   6120
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton btnExit 
      Cancel          =   -1  'True
      Caption         =   "E&xit (Closes port)"
      Height          =   375
      Left            =   1920
      TabIndex        =   16
      Top             =   6120
      Width           =   1335
   End
   Begin VB.ListBox lstEvents 
      Height          =   1230
      Left            =   120
      TabIndex        =   10
      TabStop         =   0   'False
      Top             =   4080
      Width           =   4575
   End
   Begin VB.Frame Frame2 
      Caption         =   "Online Functions"
      Height          =   2175
      Left            =   0
      TabIndex        =   6
      Top             =   1560
      Width           =   4815
      Begin VB.CommandButton DetectTone 
         Caption         =   "Detect Tone"
         Height          =   375
         Left            =   120
         TabIndex        =   25
         Top             =   1680
         Width           =   1455
      End
      Begin VB.CheckBox btnBlindTransfer 
         Caption         =   "Blind Transfer"
         Enabled         =   0   'False
         Height          =   255
         Left            =   3240
         TabIndex        =   24
         Top             =   1735
         Width           =   1455
      End
      Begin VB.CommandButton btnTransfer 
         Caption         =   "Transfer Call"
         Height          =   375
         Left            =   1680
         TabIndex        =   18
         Top             =   1680
         Width           =   1455
      End
      Begin VB.CommandButton btnSendTone 
         Caption         =   "Send Signal"
         Height          =   375
         Left            =   3240
         TabIndex        =   17
         Top             =   1200
         Width           =   1455
      End
      Begin VB.CommandButton btnWaitforDTMF 
         Caption         =   "Wait for DTMF"
         Height          =   375
         Left            =   1680
         TabIndex        =   15
         Top             =   1200
         Width           =   1455
      End
      Begin VB.CommandButton btnSendDTMF 
         Caption         =   "Send DTMF"
         Height          =   375
         Left            =   120
         TabIndex        =   14
         Top             =   1200
         Width           =   1455
      End
      Begin VB.CommandButton btnHangUp 
         Caption         =   "Hang Up"
         Height          =   375
         Left            =   3240
         TabIndex        =   13
         Top             =   720
         Width           =   1455
      End
      Begin VB.CommandButton btnReceiveFax 
         Caption         =   "Receive Fax"
         Height          =   375
         Left            =   1680
         TabIndex        =   12
         Top             =   720
         Width           =   1455
      End
      Begin VB.CommandButton btnRecord 
         Caption         =   "Record Message"
         Height          =   375
         Left            =   120
         TabIndex        =   11
         Top             =   720
         Width           =   1455
      End
      Begin VB.CommandButton btnStop 
         Caption         =   "STOP"
         Height          =   375
         Left            =   3240
         TabIndex        =   9
         Top             =   240
         Width           =   1455
      End
      Begin VB.CommandButton btnSendFax 
         Caption         =   "Send Fax"
         Height          =   375
         Left            =   1680
         TabIndex        =   8
         Top             =   240
         Width           =   1455
      End
      Begin VB.CommandButton btnPlay 
         Caption         =   "Play Message"
         Height          =   375
         Left            =   120
         TabIndex        =   7
         Top             =   240
         Width           =   1455
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Dial/Answer"
      Height          =   1455
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   4815
      Begin VB.CommandButton btnOffHook 
         Caption         =   "Off-Hook"
         Height          =   375
         Left            =   1680
         TabIndex        =   5
         Top             =   960
         Visible         =   0   'False
         Width           =   1455
      End
      Begin VB.CommandButton btnAnswer 
         Caption         =   "&Answer"
         Height          =   375
         Left            =   3240
         TabIndex        =   4
         Top             =   960
         Width           =   1455
      End
      Begin VB.CommandButton btnDial 
         Caption         =   "&Dial"
         Height          =   375
         Left            =   120
         TabIndex        =   3
         Top             =   960
         Width           =   1455
      End
      Begin VB.TextBox edDialNumber 
         Height          =   375
         Left            =   120
         TabIndex        =   2
         Top             =   480
         Width           =   4575
      End
      Begin VB.Label Label1 
         Caption         =   "Enter the phone number"
         Height          =   255
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Width           =   1815
      End
   End
   Begin VB.Frame Frame3 
      Caption         =   "Port status"
      Height          =   2055
      Left            =   0
      TabIndex        =   19
      Top             =   3840
      Width           =   4815
      Begin VB.CheckBox btnAutoScroll 
         Caption         =   "Auto scroll"
         Height          =   375
         Left            =   3600
         TabIndex        =   22
         Top             =   1560
         Value           =   1  'Checked
         Width           =   1095
      End
      Begin VB.CommandButton btnClear 
         Caption         =   "Clear"
         Height          =   375
         Left            =   2160
         TabIndex        =   21
         Top             =   1560
         Width           =   1095
      End
      Begin VB.CommandButton btnCopyToClipboard 
         Caption         =   "Copy To Clipboard"
         Height          =   375
         Left            =   240
         TabIndex        =   20
         Top             =   1560
         Width           =   1575
      End
   End
End
Attribute VB_Name = "frmOnline"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' last nProgressStatus = 8
Private bConnEstab As Boolean
Private nProgressStatus As Integer
Private FaxID As Long
Private nAutoScroll As Integer
Private nBlindTransfer As Integer
Private ToneID As Long
Private isDTMFTerminated As Boolean
Private isHangingUp As Boolean
Private savingVoiceFile As String

Const cnsHangup = 0
Const cnsDial = 1
Const cnsAnswer = 2
Const cnsOffHook = 3
Const cnsPlay = 4
Const cnsRecord = 5
Const cnsSendFax = 6
Const cnsRecFax = 7
Const cnsSendDTMF = 8
Const cnsWaitDTMF = 9
Const cnsSendSignal = 10
Const cnsTransfer = 11
Const cnsExit = 100

Private Sub AddToLog(text As String)

lstEvents.AddItem text
itemcount = lstEvents.ListCount
If nAutoScroll = 1 Then
    lstEvents.TopIndex = itemcount - 1
End If
End Sub

Private Sub btHelp_Click()
    Dim helpDlg As frmHelp
    Set helpDlg = New frmHelp
    helpDlg.Show vbModal, Me
End Sub

Private Sub btnAnswer_Click()
    nProgressStatus = cnsAnswer
    fMainForm.VoiceOCX.OnlineAnswer lModemID

    EnableButtons
End Sub

Private Sub btnAutoScroll_Click()
    If btnAutoScroll.Value = 0 Then
        nAutoScroll = 0
    Else
        nAutoScroll = 1
    End If
End Sub

Private Sub btnBlindTransfer_Click()
    If btnBlindTransfer.Value = 0 Then
        nBlindTransfer = 0
    Else
        nBlindTransfer = 1
    End If
End Sub

Private Sub btnClear_Click()
    lstEvents.Clear
End Sub

Private Sub btnCopyToClipboard_Click()
    Dim szText As String
    Dim itemcount As Integer

    itemcount = lstEvents.ListCount
    For i = 1 To itemcount
        szText = szText + lstEvents.List(i - 1)
        szText = szText + vbCrLf
    Next

    Clipboard.Clear

    Clipboard.SetText szText
End Sub

Private Sub btnDial_Click()
    nProgressStatus = cnsDial
    AddToLog "Dialing..."
    fMainForm.VoiceOCX.Dial lModemID, edDialNumber, 20

    EnableButtons
End Sub

Private Sub btnExit_Click()
    nProgressStatus = cnsExit
    AddToLog "Exiting..."
    fMainForm.VoiceOCX.HangUp lModemID
    If lModemID <> 0 Then
        If fMainForm.VoiceOCX.ClosePort(lModemID) = 0 Then
            AddToLog "Port/channel closed."
        End If
    End If

    EnableButtons
End Sub
Public Sub VoiceOCX_Busy()
    If nProgressStatus = cnsTransfer Then
        AddToLog "Call transfer was not successful."
        AddToLog "Extension is busy."
        nProgressStatus = 0
    Else
        nProgressStatus = 0
        AddToLog ("Busy tone was detected.")
    End If
    bConnEstab = False
    EnableButtons
End Sub
Public Sub VoiceOCX_SIT()
    nProgressStatus = 0
    AddToLog ("SIT tone was detected.")
    bConnEstab = True
    EnableButtons
End Sub

Public Sub VoiceOCX_NoAnswer()
    If nProgressStatus = cnsTransfer Then
        AddToLog "Call transfer was not successful."
        AddToLog "There is no answer."
        nProgressStatus = 0
    Else
        nProgressStatus = 0
        AddToLog ("No answer.")

    End If
    bConnEstab = True
    EnableButtons
End Sub
Public Sub VoiceOCX_NoCarrier()
    nProgressStatus = 0
    AddToLog ("No Carrier was detected.")
    
    EnableButtons
End Sub
Public Sub VoiceOCX_CallingTone()
    nProgressStatus = 0

    AddToLog ("Fax calling tone was detected!")
    fMainForm.VoiceOCX.TerminateProcess lModemID

    bConnEstab = True
    EnableButtons
End Sub
Public Sub VoiceOCX_AnswerTone()
    nProgressStatus = 0

    AddToLog ("Fax answer tone was detected!")
    fMainForm.VoiceOCX.TerminateProcess lModemID

    bConnEstab = True
    EnableButtons
End Sub
Public Sub VoiceOCX_AnsweringMachine()
    nProgressStatus = 0

    AddToLog ("Answering machine was detected!")
    fMainForm.VoiceOCX.TerminateProcess lModemID

    bConnEstab = True
    EnableButtons
End Sub
Public Sub VoiceOCX_CustomToneON(ToneID As Long)
    AddToLog "Custom tone " + Str(ToneID) + " TONE_ON event was detected"
End Sub

Public Sub VoiceOCX_CustomToneOFF(ToneID As Long)
    AddToLog "Custom tone " + Str(ToneID) + " TONE_OFF event was detected"
End Sub

Public Sub VoiceOCX_DTMFDigit(Digit As Integer)
    nProgressStatus = 0
    AddToLog ("Received DTMF digit(s): [" + Chr(Digit) + "]")

    EnableButtons
End Sub

Public Sub VoiceOCX_DTMFReceived()
    AddToLog ("Received DTMF digit(s): [" + fMainForm.VoiceOCX.GetReceivedDTMFDigits(lModemID) + "]")
    isDTMFTerminated = True
    fMainForm.VoiceOCX.TerminateProcess lModemID
    nProgressStatus = 0
    EnableButtons
End Sub

Public Sub VoiceOCX_DTMFReceivedExt2(ByVal Offset As Long)

    AddToLog ("Received DTMF digit(s): [" + fMainForm.VoiceOCX.GetReceivedDTMFDigits(lModemID) + "]")
    AddToLog ("Offset:" + Str(Offset))
    isDTMFTerminated = True
    fMainForm.VoiceOCX.TerminateProcess lModemID
    nProgressStatus = 0
    EnableButtons
End Sub

Public Sub VoiceOCX_DTMFSent()
    nProgressStatus = 0
    AddToLog "DTMF tones were successfully sent"

    EnableButtons
End Sub

Public Sub VoiceOCX_EndReceive()
    nProgressStatus = 0

    EnableButtons

    If Not isHangingUp Then
        If FaxID <> 0 Then
            AddToLog "Fax was received."
            Dim szFaxName As String
            Dim saveFax As frmSaveFax
    
            Set saveFax = New frmSaveFax
            saveFax.Show vbModal, Me
            szFaxName = saveFax.GetFaxName
            Set saveFax = Nothing
            If szFaxName <> "" Then
                Dim nPageNum As Integer, Res  As Integer, Width  As Integer, Length  As Integer, Comp  As Integer, Bin  As Integer, Bitord As Integer, Ecm As Integer, Color As Integer, ClrType As Integer
                Dim Append As Boolean
    
                Append = False
    
                fMainForm.VoiceOCX.GetFaxParam FaxID, nPageNum, Res, Width, Length, Comp, Bin, Bitord, Ecm, Color, ClrType
                For nIndex = 0 To nPageNum - 1 Step 1
                    fMainForm.VoiceOCX.GetFaxImagePage FaxID, nIndex, IMT_FILE_TIFF_G4, Append, szFaxName
                    Append = True
                Next
            End If
    
            MsgBox "Saving received fax as: " + szFaxName, vbOKOnly
    
            fMainForm.VoiceOCX.ClearFaxObject FaxID
            FaxID = 0
        Else
            AddToLog ("No fax was received")
        End If
    Else
        isHangingUp = False
    End If
    btnHangUp_Click
End Sub

Public Sub VoiceOCX_EndSend()
    nProgressStatus = 0
    AddToLog "Fax was sent"

    EnableButtons
    btnHangUp_Click
End Sub

Public Sub VoiceOCX_FaxReceived(fax As Long, ByVal RemoteID As String)
    AddToLog "Remote Identifier:" + RemoteID
    FaxID = fax
End Sub

Public Sub VoiceOCX_FaxTerminated(Status As Long)
    AddToLog "Fax termination status: [" + Str(Status) + "]"
    If Status <> 0 Then
        AddToLog "Modem is hanging up..."
        isHangingUp = True
    End If
End Sub

Public Sub VoiceOCX_NoDialTone()
    If nProgressStatus = cnsTransfer Then
        AddToLog "Call transfer was not successful."
        AddToLog "There is no dial tone."
        nProgressStatus = 0
        EnableButtons
    Else
        AddToLog "There is no dial tone!"

        nProgressStatus = 0
        btnHangUp_Click
    End If

End Sub

Public Sub VoiceOCX_OnHook()
    If nProgressStatus = cnsDial Or nProgressStatus = cnsAnswer Then ' dial or answer
        AddToLog "Pick up the phone!"
    ElseIf nProgressStatus = cnsHangup Or nProgressStatus = cnsPlay Or nProgressStatus = cnsRecord Or nProgressStatus = cnsWaitDTMF Then
        AddToLog "Remote side has disconnected. Hang up the line."
    End If
End Sub

Public Sub VoiceOCX_OffHook()
    If nProgressStatus = cnsDial Or nProgressStatus = cnsAnswer Then ' dial or answer
        nProgressStatus = 0
        AddToLog "Voice connection was established"
        bConnEstab = True
    End If

    EnableButtons
End Sub

Public Sub VoiceOCX_Ring()

    Dim CallerIDInf As String
    Dim bFlag As Boolean
    Dim j As Integer
    Dim i As Integer
    Dim t1, t2 As String
    
    AddToLog "Incoming call was detected. Press the answer button"
    CallerIDInf = fMainForm.VoiceOCX.GetCallerID(lModemID)
    If CallerIDInf <> "" Then
        AddToLog "Caller ID information:"
        bFlag = True
        i = 1
        While bFlag
            j = InStr(1, CallerIDInf, "\", 0)
            If j = 0 Then
                t1 = CallerIDInf
                bFlag = False
            Else
                t1 = Left(CallerIDInf, j - 1)
                CallerIDInf = Right(CallerIDInf, Len(CallerIDInf) - j)
            End If
            Select Case i
            Case 1
                If Len(t1) > 1 Then
                    AddToLog "Calling Date:" + t1
                End If
            Case 2
                If Len(t1) > 1 Then
                    AddToLog "Calling Time:" + t1
                End If
            Case 3
                If Len(t1) > 1 Then
                    AddToLog "Caller ID:" + t1
                End If
            Case 4
                If Len(t1) > 1 Then
                    AddToLog "Caller Name:" + t1
                End If
            Case 5
                If Len(t1) > 1 Then
                    AddToLog "Called Number:" + t1
                End If
            Case 6
                If Len(t1) > 1 Then
                    AddToLog "Message:" + t1
            End If
            End Select
            i = i + 1
        Wend
    End If
    
    
    
End Sub

Public Sub VoiceOCX_ToneSent()
    AddToLog "Tone signal was sent"
    nProgressStatus = 0

    EnableButtons
End Sub

Public Sub VoiceOCX_VoiceConnect()
    AddToLog "Voice connection was established"
    AddToLog "Regular voice modems cannot detect if the called party"
    AddToLog "answered a call or hanged up the line."
    AddToLog "When you want to hang up the line, "
    AddToLog "please press the HangUp button."
    nProgressStatus = 0
    bConnEstab = True

    EnableButtons
End Sub

Public Sub VoiceOCX_HangUp()
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

    EnableButtons
End Sub

Public Sub VoiceOCX_ModemError()
    If nProgressStatus = cnsTransfer Then
        AddToLog "Call transfer was not successful"
        nProgressStatus = 0
        bConnEstab = False
    Else
        nProgressStatus = 0
        If isDTMFTerminated = False Then
            AddToLog "Operation failed. Error message was received."
        End If
    End If
    EnableButtons
End Sub

Public Sub VoiceOCX_ModemOK()
    If nProgressStatus = cnsTransfer Then
        AddToLog "Call transfer was successful."
        nProgressStatus = 0
        bConnEstab = False
        EnableButtons
    End If
End Sub

Public Sub VoiceOCX_VoicePlayFinished()
    nProgressStatus = 0
    AddToLog "Playing voice message was finished"
    EnableButtons
End Sub

Public Sub VoiceOCX_VoicePlayFinishedExt2(ByVal Offset As Long)
    nProgressStatus = 0
    AddToLog ("Received DTMF digit(s): [" + fMainForm.VoiceOCX.GetReceivedDTMFDigits(lModemID) + "]")
    AddToLog ("Offset:" + Str(Offset))
    AddToLog "Playing voice message was finished"
    EnableButtons
End Sub

Public Sub VoiceOCX_VoicePlayStarted()
    AddToLog "Playing voice message was started"
End Sub

Public Sub VoiceOCX_VoiceRecordFinished()
    nProgressStatus = 0
    AddToLog ("Received DTMF digit(s): [" + fMainForm.VoiceOCX.GetReceivedDTMFDigits(lModemID) + "]")
    AddToLog "Recording voice message was finished"
    MsgBox "Voice file has saved to: " + savingVoiceFile
    EnableButtons
End Sub

Public Sub VoiceOCX_VoiceRecordStarted()
    AddToLog "Recording voice message was started"
End Sub

Private Sub btnHangUp_Click()
    If nProgressStatus = 0 Then
        nProgressStatus = cnsHangup
        fMainForm.VoiceOCX.HangUp lModemID
    End If

    EnableButtons
End Sub

Private Sub btnOffHook_Click()
    nProgressStatus = cnsOffHook
    fMainForm.VoiceOCX.OffHook lModemID
    EnableButtons
End Sub

Private Sub btnPlay_Click()
    Dim szVoiceFile As String
    Dim szVoiceFormatCmd As String
    
    szVoiceFormatCmd = fMainForm.VoiceOCX.GetModemCommand(lModemID, 2)

    AddToLog "Modem command" + fMainForm.VoiceOCX.GetModemCommand(lModemID, 2)
    If fMainForm.VoiceOCX.GetModemType(lModemID) = cnsUSRobotics Then
        If szVoiceFormatCmd <> "AT#VSM=132,8000" + vbCrLf Then
            szVocExts(2) = ".USR"
            fMainForm.VoiceOCX.SetDefaultVoiceParams lModemID, MDF_ADPCM, 8000
            
            fMainForm.VoiceOCX.SetModemCommand lModemID, 2, "AT#VSM=129,8000" + vbCrLf
        End If
    End If
    szVoiceFile = ChooseVoiceMessage
    If szVoiceFile <> "" Then
        If fMainForm.VoiceOCX.PlayVoice(lModemID _
                                        , szVoiceFile _
                                        , MDM_LINE _
                                        , 0 _
                                        , 0 _
                                        , 0) = 0 Then
        'If fMainForm.VoiceOCX.PlayVoiceExt2(lModemID, szVoiceFile, MDM_LINE, _
        '                                    10, Asc("*"), 5, True, 1, 3, _
        '                                    22050, 55125) = 0 Then
            nProgressStatus = cnsPlay
        Else
            AddToLog "PlayVoice failed"
        End If
    End If

    EnableButtons
End Sub

Private Sub btnReceiveFax_Click()
    If fMainForm.VoiceOCX.ReceiveFaxNow(lModemID) = 0 Then
        nProgressStatus = cnsRecFax
    Else
        AddToLog "ReceiveFaxNow failed"
    End If

    EnableButtons
End Sub

Private Sub btnRecord_Click()
    Dim recordName As frmRecordName
    Dim szVoiceFile As String
    Dim nDF As Integer
    Dim nSR As Integer
    Dim bWAV As Boolean
    Dim szVoiceFormatCmd As String
    
    szVoiceFormatCmd = fMainForm.VoiceOCX.GetModemCommand(lModemID, 2)

    AddToLog "Modem command" + fMainForm.VoiceOCX.GetModemCommand(lModemID, 2)
    If fMainForm.VoiceOCX.GetModemType(lModemID) = cnsUSRobotics Then
        If szVoiceFormatCmd <> "AT#VSM=132,8000" + vbCrLf Then
            szVocExts(2) = ".USR"
            fMainForm.VoiceOCX.SetDefaultVoiceParams lModemID, MDF_ADPCM, 8000
            
            fMainForm.VoiceOCX.SetModemCommand lModemID, 2, "AT#VSM=129,8000" + vbCrLf
        End If
    End If
    Set recordName = New frmRecordName
    recordName.SetModemID lModemID
    recordName.Show vbModal, Me
    szVoiceFile = recordName.GetVoiceFilename
    bWAV = recordName.GetFileFormat
    nDF = recordName.GetDataFormat
    nSR = recordName.GetSamplingRate
    Set recordName = Nothing


    If szVoiceFile <> "" Then
        If bWAV Then
            szVoiceFile = szExePath + "\VOICE\" + szVoiceFile + ".wav"
        Else
            szVoiceFile = szExePath + "\VOICE\" + szVoiceFile
            SetVocExtension lModemID, szVoiceFile
        End If

        ' use Asc("#") to specify delimiter in the last parameter

        If fMainForm.VoiceOCX.RecordVoiceExt(lModemID _
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
    End If

    savingVoiceFile = szVoiceFile
    EnableButtons
End Sub

Private Sub btnSendDTMF_Click()
    Dim sendDTMF As frmSendDTMF
    Dim szDTMF As String

    Set sendDTMF = New frmSendDTMF
    sendDTMF.Show vbModal, Me
    szDTMF = sendDTMF.GetDTMFDigits
    Set sendDTMF = Nothing

    If fMainForm.VoiceOCX.sendDTMF(lModemID, szDTMF, 2) = 0 Then
        AddToLog ("Sending DTMF digits: " + szDTMF)
        nProgressStatus = cnsSendDTMF
    Else
        AddToLog ("SendDTMF failed")
    End If

    EnableButtons
End Sub

Private Sub btnSendFax_Click()
    cmdDlg.FileName = ""
    cmdDlg.DefaultExt = "TIF"
    cmdDlg.Flags = cdlOFNHideReadOnly
    cmdDlg.DialogTitle = "Select a File To be Sent"
    cmdDlg.InitDir = szExePath
    cmdDlg.Filter = "TIFF Files (*.TIF)|*.TIF"
    cmdDlg.ShowOpen
    If cmdDlg.FileName <> "" Then
        Dim FaxID As Long
        Dim nNumOfImages As Long

        Err.Clear
        On Error GoTo ErrorHandler

        fMainForm.VoiceOCX.bHeader = True
        fMainForm.VoiceOCX.EnableLog lModemID, True
        nNumOfImages = fMainForm.VoiceOCX.GetNumberOfImages(cmdDlg.FileName, IMT_FILE_TIFF_NOCOMP)
        If nNumOfImages > -1 Then
            FaxID = fMainForm.VoiceOCX.CreateFaxObject(1 _
                                                        , nNumOfImages _
                                                        , RES_196LPI _
                                                        , PWD_1728 _
                                                        , PLN_NOCHANGE _
                                                        , DCF_1DMH _
                                                        , BFT_DISABLE _
                                                        , ECM_DISABLE _
                                                        , 0, 0)
            If FaxID <> 0 Then
                Dim lError As Long
                Dim nIndex As Integer

                lError = 0
                nIndex = 0

                Do While nIndex < nNumOfImages And lError = 0
                    lError = fMainForm.VoiceOCX.SetFilePage(FaxID, nIndex, IMT_NOTHING, nIndex, cmdDlg.FileName)
                    If lError <> 0 Then
                        AddToLog "SetFilePage failed"
                    End If
                    nIndex = nIndex + 1
                Loop

                If lError = 0 Then
                    If fMainForm.VoiceOCX.SendFaxNow(lModemID, FaxID) = 0 Then
                        nProgressStatus = cnsSendFax
                    Else
                        Err.Raise vbObjectError + 3
                    End If
                Else
                    Err.Raise vbObjectError + 2
                End If
            Else
                Err.Raise vbObjectError + 1
            End If
        Else
            Err.Raise vbObjectError + 0
        End If

        EnableButtons
        Exit Sub

ErrorHandler:
        Select Case Err.Number
            Case vbObjectError + 0
                AddToLog "Error in GetNumberOfImages() - Does file exist?"
                AddToLog "Filename:" + szFaxFile
            Case vbObjectError + 1
                AddToLog "Error in CreateFaxObject() - check parameters"
            Case vbObjectError + 2
                AddToLog "Error in SetFilePage()"
            Case vbObjectError + 3
                AddToLog "Error in SendFaxNow()"
        End Select

        nProgressStatus = 0
        EnableButtons
    End If
End Sub
Private Sub btnSendTone_Click()
    Dim ToneSignal As frmToneSignal
    Dim FFreq As Integer, SFreq As Integer, Duration As Integer

    If fMainForm.VoiceOCX.GetModemType(lModemID) <> cnsBrooktrout Then
        Set ToneSignal = New frmToneSignal
        ToneSignal.Show vbModal, Me
        ToneSignal.GetFreqValues FFreq, SFreq, Duration

        If Duration <> 0 Then
            If fMainForm.VoiceOCX.GenerateToneSignal(lModemID, FFreq, SFreq, 0, 0, Duration, MDM_LINE) = 0 Then
                nProgressStatus = cnsSendSignal
            Else
                AddToLog ("SendTone failed")
            End If
        End If

        Set ToneSignal = Nothing
    Else
        AddToLog ("Brooktrout boards do not support tone generation")
    End If


    EnableButtons
End Sub

Private Sub btnStop_Click()
    If nProgressStatus <> 0 Then
        fMainForm.VoiceOCX.TerminateProcess lModemID
    End If
End Sub

Private Sub btnTransfer_Click()
    Dim transferDlg As frmTransferDlg
    Dim PhoneNr As String

    Set transferDlg = New frmTransferDlg
    transferDlg.Show vbModal, Me

    PhoneNr = transferDlg.GetPhoneNumber

    If PhoneNr <> "" Then
        If nBlindTransfer = 1 Then
            If fMainForm.VoiceOCX.BlindTransferInboundCall(lModemID, PhoneNr, "&", "&") = True Then
                AddToLog ("Transferring call(Blind transfer)...")
                nProgressStatus = cnsTransfer
            Else
                AddToLog ("Error while transfering call.")
            End If
        Else
            If fMainForm.VoiceOCX.TransferInboundCall(lModemID, PhoneNr, "&", "&") = True Then
                AddToLog ("Transferring call(Supervised Transfer)...")
                nProgressStatus = cnsTransfer
            Else
                AddToLog ("Error while transfering call.")
            End If
        End If
    Else
        AddToLog ("Invalid extension number was entered.")
    End If

    EnableButtons
End Sub

Private Sub btnWaitforDTMF_Click()
    Dim dtmfWait As frmWaitforDTMF
    Dim nNum As Integer
    Dim nDelmi As Integer

    Set dtmfWait = New frmWaitforDTMF
    dtmfWait.Show vbModal, Me
    nNum = dtmfWait.GetNumberOfDigits
    nDelim = dtmfWait.GetDelimiter
    Set dtmfWait = Nothing

    If nNum > 0 Then
        If fMainForm.VoiceOCX.WaitForDTMF(lModemID, nNum, nDelim, 20) = 0 Then
            AddToLog ("Wait for DTMF digits")
            nProgressStatus = cnsWaitDTMF
        Else
            AddToLog ("WaitForDTMF failed")
        End If
    End If

    EnableButtons
End Sub

Private Sub DetectTone_Click()
    Dim DetectTone As frmDetectTone
    If fMainForm.VoiceOCX.GetModemType(lModemID) = cnsDialogic Then
        Set DetectTone = New frmDetectTone
        DetectTone.pToneID = ToneID
        DetectTone.SetModemID lModemID
        DetectTone.Show vbModal
        If DetectTone.pOK Then
            ToneID = DetectTone.pToneID
            AddToLog "Custom tone " + Str(ToneID - 1) + " has been added to the channel's tone list"
        End If
        Set DetectTone = Nothing
    Else
        AddToLog ("Custom tone detection is supported with Dialogic boards only")
    End If
    
End Sub

Private Sub Form_Load()
    fMainForm.VoiceOCX.EnableLog lModemID, True
    nProgressStatus = 0
    bConnEstab = False
    nAutoScroll = 1
    nBlindTransfer = 0
    isDTMFTerminated = False
    isHangingUp = False
    fMainForm.VoiceOCX.WaitForRings lModemID, 2
    ToneID = 1
    EnableButtons
    Caption = "Online functions on port " + fMainForm.VoiceOCX.GetPortName(lModemID)
End Sub

Private Function ChooseVoiceMessage()
    Dim szVoiceFile As String
    Dim selectDlg As frmSelectMessage

    Set selectDlg = New frmSelectMessage
    selectDlg.SetModemID lModemID
    selectDlg.Show vbModal, Me
    szVoiceFile = selectDlg.GetSelectedVoiceFile
    Set selectDlg = Nothing

    ChooseVoiceMessage = szVoiceFile
End Function

Private Sub EnableButtons()
    Dim nBoardType As Integer
    If bConnEstab = False Then
        If nProgressStatus = 0 Then
            btnDial.Enabled = True
            btnAnswer.Enabled = True
            btnOffHook.Enabled = True
        Else
            btnDial.Enabled = False
            btnAnswer.Enabled = False
            If nProgressStatus = 1 Then
                btnOffHook.Enabled = True
            End If
        End If
        btnPlay.Enabled = False
        btnRecord.Enabled = False
        btnSendFax.Enabled = False
        btnReceiveFax.Enabled = False
        btnHangUp.Enabled = False
        btnSendDTMF.Enabled = False
        btnWaitforDTMF.Enabled = False
        btnSendTone.Enabled = False
        btnSendTone.Enabled = False
        btnTransfer.Enabled = False
        btnBlindTransfer.Enabled = False
        DetectTone.Enabled = False
    Else
        If nProgressStatus = 0 Then
            btnPlay.Enabled = True
            btnRecord.Enabled = True
            btnSendFax.Enabled = True
            btnReceiveFax.Enabled = True
            btnHangUp.Enabled = True
            btnSendDTMF.Enabled = True
            btnWaitforDTMF.Enabled = True
            btnSendTone.Enabled = True
            nBoardType = fMainForm.VoiceOCX.GetModemType(lModemID)
            If nBoardType = cnsDialogic Then
                btnTransfer.Enabled = True
                btnBlindTransfer.Enabled = True
            ElseIf nBoardType = cnsNMS Then
                btnTransfer.Enabled = True
                btnBlindTransfer.Enabled = False
            ElseIf nBoardType = cnsBrooktrout Then
                btnTransfer.Enabled = True
                btnBlindTransfer.Enabled = False
            Else
                btnTransfer.Enabled = False
                btnBlindTransfer.Enabled = False
            End If
            DetectTone.Enabled = True
        Else
            btnPlay.Enabled = False
            btnRecord.Enabled = False
            btnSendFax.Enabled = False
            btnReceiveFax.Enabled = False
            btnHangUp.Enabled = False
            btnSendDTMF.Enabled = False
            btnWaitforDTMF.Enabled = False
            btnSendTone.Enabled = False
            btnTransfer.Enabled = False
            btnBlindTransfer.Enabled = False
            DetectTone.Enabled = False
        End If
        btnDial.Enabled = False
        btnAnswer.Enabled = False
        btnOffHook.Enabled = False
    End If

    If nProgressStatus = 0 Then ' no action
        btnExit.Enabled = True
        btnStop.Enabled = False
    Else
        btnExit.Enabled = False
        btnStop.Enabled = True
    End If
End Sub

