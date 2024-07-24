VERSION 5.00
Begin VB.Form frmVoiceManager 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Voice Manager"
   ClientHeight    =   3255
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6600
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3255
   ScaleWidth      =   6600
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   375
      Left            =   5640
      TabIndex        =   13
      Top             =   2760
      Width           =   855
   End
   Begin VB.Frame Frame2 
      Caption         =   "Output Device"
      Height          =   615
      Left            =   2880
      TabIndex        =   10
      Top             =   2520
      Width           =   2415
      Begin VB.OptionButton chbOutHandset 
         Caption         =   "Handset"
         Height          =   255
         Left            =   120
         TabIndex        =   12
         Top             =   240
         Value           =   -1  'True
         Width           =   1095
      End
      Begin VB.OptionButton chbSpeaker 
         Caption         =   "Speaker"
         Height          =   255
         Left            =   1200
         TabIndex        =   11
         Top             =   240
         Width           =   1095
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Input Device"
      Height          =   615
      Left            =   120
      TabIndex        =   7
      Top             =   2520
      Width           =   2655
      Begin VB.OptionButton chbInpHandset 
         Caption         =   "Handset"
         Height          =   255
         Left            =   120
         TabIndex        =   9
         Top             =   240
         Value           =   -1  'True
         Width           =   975
      End
      Begin VB.OptionButton chbMic 
         Caption         =   "Microphone"
         Height          =   255
         Left            =   1200
         TabIndex        =   8
         Top             =   240
         Width           =   1215
      End
   End
   Begin VB.ListBox lstVoiceFiles 
      Height          =   2205
      Left            =   120
      TabIndex        =   5
      Top             =   240
      Width           =   5175
   End
   Begin VB.CommandButton btnExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   5400
      TabIndex        =   4
      Top             =   2040
      Width           =   1095
   End
   Begin VB.CommandButton btnDelete 
      Caption         =   "&Delete"
      Height          =   375
      Left            =   5400
      TabIndex        =   3
      Top             =   1560
      Width           =   1095
   End
   Begin VB.CommandButton btnStop 
      Caption         =   "&STOP"
      Height          =   375
      Left            =   5400
      TabIndex        =   2
      Top             =   1080
      Width           =   1095
   End
   Begin VB.CommandButton btnRecord 
      Caption         =   "&Record"
      Height          =   375
      Left            =   5400
      TabIndex        =   1
      Top             =   600
      Width           =   1095
   End
   Begin VB.CommandButton btnPlay 
      Caption         =   "&Play"
      Default         =   -1  'True
      Height          =   375
      Left            =   5400
      TabIndex        =   0
      Top             =   120
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "Voice Files:"
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   0
      Width           =   1815
   End
End
Attribute VB_Name = "frmVoiceManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Modem As Long
Private nProgressStatus As Integer

Public Sub SetModemID(nPortNumber As Integer)
    Modem = fModemID(nPortNumber, 0)
End Sub

Private Sub btnDelete_Click()
    Dim szVoiceFile As String
    
    szVoiceFile = szExePath + "\VOICE\" + lstVoiceFiles.List(lstVoiceFiles.ListIndex)
    Kill szVoiceFile
    UpdateVoiceList
End Sub

Private Sub btnExit_Click()
    nProgressStatus = 100
    EnableButtons
    fMainForm.VoiceOCX.HangUp Modem
End Sub

Private Sub btnPlay_Click()
    Dim nDevice As Integer
    Dim szVoiceFile As String
    
    szVoiceFile = szExePath + "\VOICE\" + lstVoiceFiles.List(lstVoiceFiles.ListIndex)
    
    If chbOutHandset.Value = True Then
        nDevice = MDM_HANDSET
    Else
        nDevice = MDM_SPEAKER
    End If
    
    If fMainForm.VoiceOCX.PlayVoice(Modem _
                                    , szVoiceFile _
                                    , nDevice _
                                    , 0 _
                                    , 0 _
                                    , 0) = 0 Then
        nProgressStatus = 1
        EnableButtons
    Else
        MsgBox "Error in PlayVoice"
    End If
End Sub

Private Sub btnRecord_Click()
    Dim recordName As frmRecordName
    Dim szVoiceFile As String
    Dim nDevice As Integer
    
    If chbInpHandset.Value = True Then
        nDevice = MDM_HANDSET
    Else
        nDevice = MDM_MICROPHONE
    End If
    
    Set recordName = New frmRecordName
    recordName.Show vbModal, Me
    szVoiceFile = recordName.GetVoiceFilename
    Set recordName = Nothing
    
    If szVoiceFile <> "" Then
        szVoiceFile = szExePath + "\VOICE\" + szVoiceFile
        SetVocExtension Modem, szVoiceFile
        If fMainForm.VoiceOCX.RecordVoice(Modem _
                                            , szVoiceFile _
                                            , nDevice _
                                            , 60 _
                                            , 5 _
                                            , 1) = 0 Then
            nProgressStatus = 2
            EnableButtons
        Else
            MsgBox "Error in RecordVoice"
        End If
    End If
End Sub

Private Sub btnStop_Click()
    fMainForm.VoiceOCX.TerminateProcess Modem
End Sub

Public Sub Form_Load()
    UpdateVoiceList
End Sub

Private Sub UpdateVoiceList()
    Dim nIndex
    
    nIndex = fMainForm.VoiceOCX.GetModemType(Modem)
    MyPath = szExePath + "\VOICE\*" + szVocExts(nIndex + 1)
    
    lstVoiceFiles.Clear
    
    MyName = Dir(MyPath, vbDirectory)
    Do While MyName <> ""
        If (GetAttr(szExePath & "\VOICE\" & MyName) And vbDirectory) <> vbDirectory Then
                    lstVoiceFiles.AddItem MyName
        End If
        MyName = Dir
    Loop
    
    If lstVoiceFiles.ListCount > 0 Then
        lstVoiceFiles.ListIndex = 0
    End If
    
    EnableButtons
End Sub

Private Sub EnableButtons()
    Dim bEnable As Boolean
    
    If lstVoiceFiles.ListCount > 0 And nProgressStatus = 0 Then
        bEnable = True
    Else
        bEnable = False
    End If
    
    btnPlay.Enabled = bEnable
    btnStop.Enabled = Not bEnable
    btnDelete.Enabled = bEnable

    If nProgressStatus = 0 Then
        bEnable = True
    Else
        bEnable = False
    End If

    btnRecord.Enabled = bEnable
    btnExit.Enabled = bEnable
End Sub

Public Sub VoiceOCX_HangUp()
    Unload Me
End Sub

Public Sub VoiceOCX_ModemOK()
    nProgressStatus = 0
    UpdateVoiceList
End Sub

Public Sub VoiceOCX_ModemError()
    nProgressStatus = 0
    UpdateVoiceList
End Sub

Public Sub VoiceOCX_OffHook()
    If nProgressStatus <> 0 Then
        MsgBox "Hang up the handset!"
    End If
End Sub

Public Sub VoiceOCX_OnHook()
    If nProgressStatus <> 0 Then
        MsgBox "Pick up the handset!"
    End If
End Sub

Public Sub VoiceOCX_VoicePlayFinished()
    nProgressStatus = 0
    EnableButtons
End Sub

Public Sub VoiceOCX_VoiceRecordFinished()
    nProgressStatus = 0
    UpdateVoiceList
End Sub

