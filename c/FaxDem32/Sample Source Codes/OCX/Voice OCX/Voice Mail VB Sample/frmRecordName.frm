VERSION 5.00
Begin VB.Form frmRecordName 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Voice Record "
   ClientHeight    =   1875
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7080
   Icon            =   "frmRecordName.frx":0000
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1875
   ScaleWidth      =   7080
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame Frame3 
      Caption         =   "Sampling Rate"
      Height          =   975
      Left            =   3960
      TabIndex        =   12
      Top             =   720
      Width           =   1815
      Begin VB.OptionButton rb11KHz 
         Caption         =   "11KHz"
         Enabled         =   0   'False
         Height          =   255
         Left            =   840
         TabIndex        =   15
         Top             =   240
         Width           =   855
      End
      Begin VB.OptionButton rb8KHZ 
         Caption         =   "8KHz"
         Enabled         =   0   'False
         Height          =   255
         Left            =   120
         TabIndex        =   14
         Top             =   600
         Value           =   -1  'True
         Width           =   975
      End
      Begin VB.OptionButton rb6KHZ 
         Caption         =   "6KHz"
         Enabled         =   0   'False
         Height          =   255
         Left            =   120
         TabIndex        =   13
         Top             =   240
         Width           =   975
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "Data Format"
      Height          =   1095
      Left            =   1440
      TabIndex        =   7
      Top             =   720
      Width           =   2415
      Begin VB.OptionButton rbOKI 
         Caption         =   "OKI"
         Enabled         =   0   'False
         Height          =   195
         Left            =   120
         TabIndex        =   16
         Top             =   720
         Width           =   735
      End
      Begin VB.OptionButton rbMULAW 
         Caption         =   "MULAW"
         Enabled         =   0   'False
         Height          =   255
         Left            =   1080
         TabIndex        =   11
         Top             =   480
         Width           =   975
      End
      Begin VB.OptionButton rbALAW 
         Caption         =   "ALAW"
         Enabled         =   0   'False
         Height          =   255
         Left            =   1080
         TabIndex        =   10
         Top             =   240
         Width           =   975
      End
      Begin VB.OptionButton rbPCM 
         Caption         =   "PCM"
         Enabled         =   0   'False
         Height          =   255
         Left            =   120
         TabIndex        =   9
         Top             =   480
         Width           =   975
      End
      Begin VB.OptionButton rbADPCM 
         Caption         =   "ADPCM"
         Enabled         =   0   'False
         Height          =   255
         Left            =   120
         TabIndex        =   8
         Top             =   240
         Value           =   -1  'True
         Width           =   1095
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "File Format"
      Height          =   975
      Left            =   120
      TabIndex        =   4
      Top             =   720
      Width           =   1215
      Begin VB.OptionButton rbVOX 
         Caption         =   "VOX"
         Enabled         =   0   'False
         Height          =   255
         Left            =   120
         TabIndex        =   6
         Top             =   600
         Value           =   -1  'True
         Width           =   735
      End
      Begin VB.OptionButton rbWAV 
         Caption         =   "WAV"
         Enabled         =   0   'False
         Height          =   255
         Left            =   120
         TabIndex        =   5
         Top             =   240
         Width           =   735
      End
   End
   Begin VB.CommandButton bntCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   375
      Left            =   5880
      TabIndex        =   3
      Top             =   720
      Width           =   1095
   End
   Begin VB.CommandButton btnOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   5880
      TabIndex        =   2
      Top             =   240
      Width           =   1095
   End
   Begin VB.TextBox VoiceFilename 
      Height          =   375
      Left            =   120
      TabIndex        =   1
      Top             =   240
      Width           =   5655
   End
   Begin VB.Label Label1 
      Caption         =   "Please enter voice filename:"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   0
      Width           =   2175
   End
End
Attribute VB_Name = "frmRecordName"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private ModemID As Long
Private bFileFormat As Boolean
Private nDataFormat As Integer
Private nSmpRate As Integer
Private szVoiceFilename As String

Private Sub bntCancel_Click()
    szVoiceFilename = ""
    Unload Me
End Sub

Private Sub btnOK_Click()
    szVoiceFilename = VoiceFilename.Text
    szVoiceFilename = UCase(szVoiceFilename)
    Unload Me
End Sub

Public Sub SetModemID(Modem As Long)
    ModemID = Modem
End Sub

Public Function GetVoiceFilename() As String
    GetVoiceFilename = szVoiceFilename
End Function

Public Function GetFileFormat() As Boolean
    GetFileFormat = bFileFormat
End Function

Public Function GetDataFormat() As Integer
    GetDataFormat = nDataFormat
End Function

Public Function GetSamplingRate() As Integer
    GetSamplingRate = nSmpRate
End Function

Private Sub Form_Load()
    szVoiceFilename = ""
    bFileFormat = cnsVOX
    nDataFormat = MDF_ADPCM
    nSmpRate = MSR_8KHZ
    
    If fMainForm.VoiceOCX.GetModemType(ModemID) = cnsDialogic Then
        rbWAV.Enabled = True
        rbVOX.Enabled = True
        rbPCM.Enabled = True
        rbADPCM.Enabled = True
        rbALAW.Enabled = True
        rbMULAW.Enabled = True
        rb6KHZ.Enabled = True
        rb8KHZ.Enabled = True
        rb11KHz.Enabled = True
    ElseIf fMainForm.VoiceOCX.GetModemType(ModemID) = cnsBicom Then
        rbADPCM.Enabled = True
        rbVOX.Enabled = True
        rbVOX.Value = True
        rbPCM.Enabled = True
        rbPCM.Value = True
        rbOKI.Enabled = True
        rb6KHZ.Enabled = True
        rb8KHZ.Enabled = True
    ElseIf fMainForm.VoiceOCX.GetModemType(ModemID) = cnsNMS Then
        rbADPCM.Enabled = True
        rbVOX.Enabled = True
        rbVOX.Value = True
        rbPCM.Enabled = True
        rbPCM.Value = True
        rbOKI.Enabled = True
        rb6KHZ.Enabled = True
        rb8KHZ.Enabled = True
        rb11KHz.Enabled = True
    ElseIf fMainForm.VoiceOCX.GetModemType(ModemID) = cnsHCF Then
        szVoiceFilename = ""
        bFileFormat = cnsWAV
        nDataFormat = MDF_PCM
        nSmpRate = MSR_8KHZ
        rbWAV.Enabled = False
        rbADPCM.Enabled = False
        rbADPCM.Value = False
        rbVOX.Enabled = False
        rbVOX.Value = False
        rbPCM.Enabled = False
        rbOKI.Enabled = False
        rb6KHZ.Enabled = False
        rb8KHZ.Enabled = False
        rb8KHZ.Value = False
        rb11KHz.Enabled = False
    ElseIf fMainForm.VoiceOCX.GetModemType(ModemID) = cnsLucent Then
        szVoiceFilename = ""
        bFileFormat = cnsWAV
        nDataFormat = MDF_PCM
        nSmpRate = MSR_8KHZ
        rbWAV.Enabled = False
        rbADPCM.Enabled = False
        rbADPCM.Value = False
        rbVOX.Enabled = False
        rbVOX.Value = False
        rbPCM.Enabled = False
        rbOKI.Enabled = False
        rb6KHZ.Enabled = False
        rb8KHZ.Enabled = False
        rb8KHZ.Value = False
        rb11KHz.Enabled = False
    ElseIf fMainForm.VoiceOCX.GetModemType(ModemID) = cnsRockwell Then
        szVoiceFilename = ""
        bFileFormat = cnsVOX
        nDataFormat = MDF_ADPCM
        nSmpRate = MSR_7200
        rbWAV.Enabled = False
        rbADPCM.Enabled = False
        rbADPCM.Value = False
        rbVOX.Enabled = False
        rbVOX.Value = False
        rbPCM.Enabled = False
        rbOKI.Enabled = False
        rb6KHZ.Enabled = False
        rb8KHZ.Enabled = False
        rb8KHZ.Value = False
        rb11KHz.Enabled = False
ElseIf fMainForm.VoiceOCX.GetModemType(ModemID) = cnsUSRobotics Then
        szVoiceFilename = ""
        bFileFormat = cnsWAV
        nDataFormat = MDF_PCM
        nSmpRate = MSR_8KHZ
        rbWAV.Enabled = False
        rbADPCM.Enabled = False
        rbADPCM.Value = False
        rbVOX.Enabled = False
        rbVOX.Value = False
        rbPCM.Enabled = False
        rbOKI.Enabled = False
        rb6KHZ.Enabled = False
        rb8KHZ.Enabled = False
        rb8KHZ.Value = False
        rb11KHz.Enabled = False
        szVoiceFormatCmd = fMainForm.VoiceOCX.GetModemCommand(ModemID, 2)
        If szVoiceFormatCmd = "AT#VSM=129,8000" + vbCrLf Then
            bFileFormat = cnsVOX
            nDataFormat = MDF_ADPCM
        End If
        If szVoiceFormatCmd = "AT#VSM=130,8000" + vbCrLf Then
            bFileFormat = cnsVOX
            nDataFormat = MDF_IMAADPCM
        End If

End If
    
    
End Sub

Private Sub rb11KHz_Click()
    nSmpRate = MSR_11KHZ
End Sub

Private Sub rb6KHZ_Click()
    nSmpRate = MSR_6KHZ
End Sub

Private Sub rb8KHZ_Click()
    nSmpRate = MSR_8KHZ
End Sub

Private Sub rbADPCM_Click()
    nDataFormat = MDF_ADPCM
End Sub

Private Sub rbALAW_Click()
    nDataFormat = MDF_ALAW
End Sub

Private Sub rbMULAW_Click()
    nDataFormat = MDF_MULAW
End Sub

Private Sub rbOKI_Click()
    nDataFormat = MDF_OKI
End Sub

Private Sub rbPCM_Click()
    nDataFormat = MDF_PCM
End Sub

Private Sub rbVOX_Click()
    bFileFormat = cnsVOX
End Sub

Private Sub rbWAV_Click()
    bFileFormat = cnsWAV
End Sub
