VERSION 5.00
Begin VB.Form frmDetectTone 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Dialog Caption"
   ClientHeight    =   3480
   ClientLeft      =   2760
   ClientTop       =   3750
   ClientWidth     =   4920
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3480
   ScaleWidth      =   4920
   ShowInTaskbar   =   0   'False
   Begin VB.Frame Frame2 
      Caption         =   "Tone parameters"
      Height          =   2055
      Left            =   120
      TabIndex        =   3
      Top             =   840
      Width           =   4695
      Begin VB.ComboBox DetectionMode 
         Height          =   315
         ItemData        =   "frmDetectTone.frx":0000
         Left            =   1680
         List            =   "frmDetectTone.frx":000A
         TabIndex        =   15
         Top             =   1560
         Width           =   2895
      End
      Begin VB.TextBox Freq2Dev 
         Height          =   285
         Left            =   3720
         TabIndex        =   13
         Top             =   1080
         Width           =   855
      End
      Begin VB.TextBox Freq1Dev 
         Height          =   315
         Left            =   3720
         TabIndex        =   12
         Top             =   720
         Width           =   855
      End
      Begin VB.TextBox Freq2 
         Height          =   285
         Left            =   1080
         TabIndex        =   11
         Top             =   1080
         Width           =   855
      End
      Begin VB.TextBox Freq1 
         Height          =   285
         Left            =   1080
         TabIndex        =   10
         Top             =   720
         Width           =   855
      End
      Begin VB.Label Label6 
         Caption         =   "Detection mode:"
         Height          =   255
         Left            =   120
         TabIndex        =   14
         Top             =   1560
         Width           =   1215
      End
      Begin VB.Label Label5 
         Caption         =   "Frequency 2 deviation:"
         Height          =   255
         Left            =   2040
         TabIndex        =   9
         Top             =   1080
         Width           =   1695
      End
      Begin VB.Label Label4 
         Caption         =   "Frequency 1 deviation:"
         Height          =   255
         Left            =   2040
         TabIndex        =   8
         Top             =   720
         Width           =   1695
      End
      Begin VB.Label Label3 
         Caption         =   "Frequency 2:"
         Height          =   255
         Left            =   120
         TabIndex        =   7
         Top             =   1080
         Width           =   975
      End
      Begin VB.Label Label2 
         Caption         =   "Frequency 1:"
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   6
         Top             =   720
         Width           =   1095
      End
      Begin VB.Label ToneID 
         Height          =   255
         Left            =   840
         TabIndex        =   5
         Top             =   360
         Width           =   1095
      End
      Begin VB.Label Label1 
         Caption         =   "Tone ID:"
         Height          =   255
         Left            =   120
         TabIndex        =   4
         Top             =   360
         Width           =   735
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Custom tone type"
      Height          =   615
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   4695
      Begin VB.OptionButton ToneType 
         Caption         =   "Dual frequency tone"
         Height          =   255
         Index           =   1
         Left            =   2520
         TabIndex        =   17
         Top             =   240
         Width           =   1815
      End
      Begin VB.OptionButton ToneType 
         Caption         =   "Single frequency tone"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   16
         Top             =   240
         Value           =   -1  'True
         Width           =   1935
      End
   End
   Begin VB.CommandButton CancelButton 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   2880
      TabIndex        =   1
      Top             =   3000
      Width           =   1215
   End
   Begin VB.CommandButton OKButton 
      Caption         =   "OK"
      Height          =   375
      Left            =   840
      TabIndex        =   0
      Top             =   3000
      Width           =   1215
   End
End
Attribute VB_Name = "frmDetectTone"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private ModemID As Long
Public pToneID As Long
Public pOK As Boolean

Public Sub SetModemID(Modem As Long)
    ModemID = Modem
End Sub

Private Sub CancelButton_Click()
    Unload Me
End Sub

Private Sub Form_Load()
Freq1 = 300
Freq1Dev = 30
Freq2 = 1000
Freq2Dev = 100
ToneID = pToneID
DetectionMode.ListIndex = 0
ToneType(0).Value = True
Freq2.Enabled = False
Freq2Dev.Enabled = False
pOK = False

End Sub

Private Sub OKButton_Click()
    If ToneType(0).Value = True Then
        If DetectionMode.ListIndex = 0 Then
            fMainForm.VoiceOCX.CreateSingleFrequencyTone ModemID, pToneID, Val(Freq1), Val(Freq1Dev), 2
        Else
            fMainForm.VoiceOCX.CreateSingleFrequencyTone ModemID, pToneID, Val(Freq1), Val(Freq1Dev), 4
        End If
    Else
        If DetectionMode.ListIndex = 0 Then
            fMainForm.VoiceOCX.CreateDualFrequencyTone ModemID, pToneID, Val(Freq1), Val(Freq1Dev), Val(Freq2), Val(Freq2Dev), 2
        Else
            fMainForm.VoiceOCX.CreateDualFrequencyTone ModemID, pToneID, Val(Freq1), Val(Freq1Dev), Val(Freq2), Val(Freq2Dev), 4
        End If
    End If
    pToneID = pToneID + 1
    pOK = True
    Unload Me
End Sub

Private Sub ToneType_Click(index As Integer)
    If ToneType(0).Value = True Then
        Freq2.Enabled = False1
        Freq2Dev.Enabled = False
    Else
        Freq2.Enabled = True
        Freq2Dev.Enabled = True
    End If
End Sub


