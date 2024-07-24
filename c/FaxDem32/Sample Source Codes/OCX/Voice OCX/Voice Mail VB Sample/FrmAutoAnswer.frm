VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "Comctl32.ocx"
Begin VB.Form frmAutoAnswer 
   Caption         =   "frmDocument"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   Icon            =   "FrmAutoAnswer.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   Begin ComctlLib.ListView lstEvents 
      Height          =   3015
      Left            =   0
      TabIndex        =   0
      Top             =   120
      Width           =   4695
      _ExtentX        =   8281
      _ExtentY        =   5318
      View            =   2
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   327682
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   3
      BeginProperty ColumnHeader(1) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
         Key             =   ""
         Object.Tag             =   ""
         Text            =   "Time"
         Object.Width           =   4939
      EndProperty
      BeginProperty ColumnHeader(2) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
         SubItemIndex    =   1
         Key             =   ""
         Object.Tag             =   ""
         Text            =   "Event"
         Object.Width           =   7937
      EndProperty
      BeginProperty ColumnHeader(3) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
         SubItemIndex    =   2
         Key             =   ""
         Object.Tag             =   ""
         Text            =   "Description"
         Object.Width           =   7937
      EndProperty
   End
End
Attribute VB_Name = "frmAutoAnswer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private ModemID As Long
Private nProgressStatus As Integer
Private bDTMFReceived As Boolean
Private FaxID As Long

Const cnsRings = 1

Const cnsAnswer = 1
Const cnsGreeting = 2
Const cnsRecFax = 3
Const cnsSendFax = 4
Const cnsChoose = 5
Const cnsHangUp = 6
Const cnsRecord = 7

Private Sub Form_Load()
    Form_Resize

    ' Set View property to List.
    lstEvents.View = lvwReport

    fMainForm.VoiceOCX.WaitForRings ModemID, cnsRings
    Caption = "Autoanswer on port: " + fMainForm.VoiceOCX.GetPortName(ModemID)
    
    nProgressStatus = 0
    AddNewItem "Voice Mail sample has been started.", "Modem is ready to answer incoming calls."
End Sub

Private Sub Form_Resize()
    On Error Resume Next
    lstEvents.Move 100, 100, Me.ScaleWidth - 200, Me.ScaleHeight - 200
End Sub


Private Sub Form_Unload(Cancel As Integer)
    Dim nIndex As Integer
    nIndex = FindTagToModemID(ModemID)
    fModemID(nIndex, 1) = cnsNoneAttached
    fMainForm.VoiceOCX.DestroyModemObject (ModemID)
    fModemID(nIndex, 0) = 0
End Sub

Public Sub VoiceOCX_ModemOK()
    'DestroyConnection
End Sub

Public Sub VoiceOCX_ModemError()
    AddNewItem "ERROR", "Last operation failed."
    DestroyConnection
End Sub

Public Sub VoiceOCX_Ring()
    AddNewItem "", ""
    AddNewItem "Incoming call was detected.", "Answering call..."
    nProgressStatus = 0
    If fMainForm.VoiceOCX.Answer(ModemID) = 0 Then
        nProgressStatus = cnsAnswer
    Else
        DestroyConnection
    End If
End Sub

Public Sub VoiceOCX_Answer()
    Dim szVoiceFile As String
    Dim szVoiceFormatCmd As String
    
    szVoiceFormatCmd = fMainForm.VoiceOCX.GetModemCommand(ModemID, 2)
    If fMainForm.VoiceOCX.GetModemType(ModemID) = cnsUSRobotics Then
        If szVoiceFormatCmd <> "AT#VSM=132,8000" + vbCrLf Then
            szVocExts(2) = ".USR"
            fMainForm.VoiceOCX.SetDefaultVoiceParams ModemID, MDF_ADPCM, 8000
            
            fMainForm.VoiceOCX.SetModemCommand ModemID, 2, "AT#VSM=129,8000" + vbCrLf
        End If
    End If
    szVoiceFile = szExePath + "\VOICE\VOICE"
    SetVocExtension ModemID, szVoiceFile

    AddNewItem "Answer", "Call was answered"
    
    If fMainForm.VoiceOCX.GetDIDDigits(ModemID) <> "" Then
        AddNewItem "Answer", "DID digits received:" + fMainForm.VoiceOCX.GetDIDDigits(ModemID)
    End If

    If fMainForm.VoiceOCX.PlayVoice(ModemID _
                                    , szVoiceFile _
                                    , MDM_LINE _
                                    , 20 _
                                    , 0 _
                                    , 1) = 0 Then
        nProgressStatus = cnsGreeting
    Else
        DestroyConnection
    End If
End Sub
Public Sub VoiceOCX_CallingTone()
    AddNewItem "Interrupt", "Calling tone was detected!"
    fMainForm.VoiceOCX.TerminateProcess Modem
End Sub
Public Sub VoiceOCX_AnswerTone()
    AddNewItem "Interrupt", "Answer tone was detected!"
    fMainForm.VoiceOCX.TerminateProcess Modem
End Sub
Public Sub VoiceOCX_DTMFReceived()
    bDTMFReceived = True
    fMainForm.VoiceOCX.TerminateProcess ModemID
End Sub

Public Sub VoiceOCX_EndReceive()
    If FaxID <> 0 Then
        Dim bAppend As Boolean
        Dim szFileName As String
        Dim nPageNum As Integer, Res  As Integer, Width  As Integer, Length  As Integer, Comp  As Integer, Bin  As Integer, Bitord As Integer, Ecm As Integer, Color As Integer, ClrType As Integer

        AddNewItem "EndReceive", "Saving received fax"

        szFileName = szExePath + "\FAX.IN\FAX_" + Format(Time, "hh_mm_ss_") + Format(Date, "mmm_dd_yyyy") + ".TIF"
        bAppend = False

        fMainForm.VoiceOCX.GetFaxParam FaxID, nPageNum, Res, Width, Length, Comp, Bin, Bitord, Ecm, Color, ClrType
        For nIndex = 0 To nPageNum - 1 Step 1
            fMainForm.VoiceOCX.GetFaxImagePage FaxID, nIndex, IMT_FILE_TIFF_NOCOMP, bAppend, szFileName
            bAppend = True
        Next

        fMainForm.VoiceOCX.ClearFaxObject FaxID
        FaxID = 0
    Else
        AddNewItem "EndReceive", "No fax was received"
    End If

    nProgressStatus = 0
    DestroyConnection
End Sub

Public Sub VoiceOCX_EndSend()
    nProgressStatus = 0
    AddNewItem "FaxSent", "Send fax operation has finished"
    DestroyConnection
End Sub

Public Sub VoiceOCX_FaxReceived(fax As Long, ByVal RemoteID As String)
    FaxID = fax
End Sub

Public Sub VoiceOCX_VoicePlayStarted()
    AddNewItem "VoicePlayStarted", ""
End Sub

Public Sub VoiceOCX_VoicePlayFinished()
    Dim szTemp As String
    Dim szDTMF As String

    If nProgressStatus = cnsGreeting Then
        If bDTMFReceived = True Then
            bDTMFReceived = False
            szDTMF = fMainForm.VoiceOCX.GetReceivedDTMFDigits(ModemID)
            szTemp = "DTMF received:" + szDTMF
        Else
            szTemp = "No acceptable DTMF digit was received!"
        End If
        AddNewItem "Playing greeting message was finished", szTemp

        Select Case szDTMF
            Case "0"
                RecordVoiceMail
            Case "1"
                ReceiveFax
            Case "2"
                PlayChooseMsg
            Case Else
                DestroyConnection
        End Select
    Else
        If bDTMFReceived = True Then
            szDTMF = fMainForm.VoiceOCX.GetReceivedDTMFDigits(ModemID)
            AddNewItem "DTMF Received" + szDTMF, "User chose fax: " + szDTMF
            Select Case szDTMF
                Case "0"
                    SendFax ("TEST.TIF")
                Case "1"
                    SendFax ("TEST.TIF")
                Case "2"
                    SendFax ("TEST.TIF")
                Case Else
                        DestroyConnection
            End Select
        End If
    End If
End Sub

Public Sub VoiceOCX_VoiceRecordStarted()
    AddNewItem "Recording voice mail was started", ""
End Sub

Public Sub VoiceOCX_VoiceRecordFinished()
    AddNewItem "Voice mail was recorded", ""
    DestroyConnection
End Sub

Public Sub VoiceOCX_FaxTerminated(Status As Long)
    AddNewItem "Fax was Terminated", "Termination status:" + Str(Status)
End Sub

Public Sub VoiceOCX_HangUp()
    nProgressStatus = 0
    fMainForm.VoiceOCX.WaitForRings ModemID, cnsRings
    AddNewItem "Hangup", "Modem was disconnected - answerphone operation complete"
End Sub

Public Sub VoiceOCX_OnHook()
    AddNewItem "Disconnect", "Remote side has disconnected"
    fMainForm.VoiceOCX.TerminateProcess ModemID
End Sub

Public Sub SetModemID(Modem As Long)
    ModemID = Modem
End Sub

Private Sub DestroyConnection()
    AddNewItem "-", "Disconnect line"
    fMainForm.VoiceOCX.HangUp ModemID
    nProgressStatus = cnsHangUp
    bDTMFReceived = False
End Sub

Private Sub RecordVoiceMail()
    Dim szVoiceFile As String
    Dim szVoiceFormatCmd As String
    
    szVoiceFormatCmd = fMainForm.VoiceOCX.GetModemCommand(ModemID, 2)
    If fMainForm.VoiceOCX.GetModemType(ModemID) = cnsUSRobotics Then
        If szVoiceFormatCmd <> "AT#VSM=132,8000" + vbCrLf Then
            szVocExts(2) = ".USR"
            fMainForm.VoiceOCX.SetDefaultVoiceParams ModemID, MDF_ADPCM, 8000
            
            fMainForm.VoiceOCX.SetModemCommand ModemID, 2, "AT#VSM=129,8000" + vbCrLf
        End If
    End If
    szVoiceFile = szExePath + "\VOICE\MAIL_" + Format(Time, "hh_mm_ss_") + Format(Date, "mmm_dd_yyyy")
    SetVocExtension ModemID, szVoiceFile
    AddNewItem "Record voice mail", "Filename: " + szVoiceFile

    If fMainForm.VoiceOCX.RecordVoice(ModemID _
                                        , szVoiceFile _
                                        , MDM_LINE _
                                        , 60 _
                                        , 10 _
                                        , 1) = 0 Then
        nProgressStatus = cnsRecord
    Else
        DestroyConnection
    End If
End Sub

Private Sub AddNewItem(modem_event As String, notice As String)
    Dim itmX As ListItem
    Dim szTemp As String

    szTemp = Format(Time, "Long Time") + " " + Format(Date, "Long Date")
    Set itmX = lstEvents.ListItems.Add(, , szTemp)

    itmX.SubItems(1) = modem_event
    itmX.SubItems(2) = notice
End Sub

Private Sub ReceiveFax()
    If fMainForm.VoiceOCX.ReceiveFaxNow(ModemID) = 0 Then
        nProgressStatus = cnsRecFax
    End If
End Sub

Private Sub PlayChooseMsg()
    Dim szVoiceFile As String
    Dim szVoiceFormatCmd As String
    
    szVoiceFormatCmd = fMainForm.VoiceOCX.GetModemCommand(ModemID, 2)
    If fMainForm.VoiceOCX.GetModemType(ModemID) = cnsUSRobotics Then
        If szVoiceFormatCmd <> "AT#VSM=132,8000" + vbCrLf Then
            szVocExts(2) = ".USR"
            fMainForm.VoiceOCX.SetDefaultVoiceParams ModemID, MDF_ADPCM, 8000
            
            fMainForm.VoiceOCX.SetModemCommand ModemID, 2, "AT#VSM=129,8000" + vbCrLf
        End If
    End If
    szVoiceFile = szExePath + "\VOICE\SENDFAX"
    SetVocExtension ModemID, szVoiceFile
    AddNewItem "Choose Fax", "Playing 'Choose Fax' message"

    If fMainForm.VoiceOCX.PlayVoice(ModemID _
                                    , szVoiceFile _
                                    , MDM_LINE _
                                    , 20 _
                                    , 0 _
                                    , 1) = 0 Then
        nProgressStatus = cnsChoose
    Else
        DestroyConnection
    End If
End Sub

Private Sub SendFax(szFaxFile As String)
    Dim FaxID As Long

    nProgressStatus = 0

    On Error GoTo ErrorHandler

    szFaxFile = szExePath + "\FAX.OUT\" + szFaxFile

    nNumOfImages = fMainForm.VoiceOCX.GetNumberOfImages(szFaxFile, IMT_FILE_TIFF_NOCOMP)
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
            For nIndex = 0 To nNumOfImages - 1 Step 1
                If fMainForm.VoiceOCX.SetFilePage(FaxID, nIndex, IMT_NOTHING, nIndex, szFaxFile) <> 0 Then
                    Err.Raise vbObjectError + 3
                End If
            Next

            If fMainForm.VoiceOCX.SendFaxNow(ModemID, FaxID) = 0 Then
                nProgressStatus = cnsSendFax
            Else
                Err.Raise vbObjectError + 2
            End If
        Else
            Err.Raise vbObjectError + 1
        End If
    Else
        Err.Raise vbObjectError + 0
    End If

    Exit Sub

ErrorHandler:
    Select Case Err.Number
        Case vbObjectError + 0
            AddNewItem "ERROR", "Error in GetNumberOfImages()"
        Case vbObjectError + 1
            AddNewItem "ERROR", "Error in CreateFaxObject()"
        Case vbObjectError + 2
            AddNewItem "ERROR", "Error in SendFaxNow()"
        Case vbObjectError + 3
            AddNewItem "ERROR", "Error in SetFilePage()"
    End Select

    DestroyConnection
End Sub
