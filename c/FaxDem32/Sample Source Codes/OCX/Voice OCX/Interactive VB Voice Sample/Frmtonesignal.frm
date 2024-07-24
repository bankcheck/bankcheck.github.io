VERSION 5.00
Begin VB.Form frmToneSignal 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Tone Signal"
   ClientHeight    =   1785
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3705
   Icon            =   "frmToneSignal.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1785
   ScaleWidth      =   3705
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox Duration 
      Height          =   285
      Left            =   1680
      TabIndex        =   2
      Top             =   840
      Width           =   1095
   End
   Begin VB.TextBox SecondFreq 
      Height          =   285
      Left            =   1680
      TabIndex        =   1
      Top             =   480
      Width           =   1095
   End
   Begin VB.TextBox FirstFreq 
      Height          =   285
      Left            =   1680
      TabIndex        =   0
      Top             =   120
      Width           =   1095
   End
   Begin VB.CommandButton btnCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   375
      Left            =   1680
      TabIndex        =   4
      Top             =   1320
      Width           =   1095
   End
   Begin VB.CommandButton bnOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   360
      TabIndex        =   3
      Top             =   1320
      Width           =   1095
   End
   Begin VB.Label Label6 
      Caption         =   "* 100 ms"
      Height          =   255
      Left            =   2880
      TabIndex        =   10
      Top             =   960
      Width           =   975
   End
   Begin VB.Label Label5 
      Caption         =   "Hz"
      Height          =   255
      Left            =   2880
      TabIndex        =   9
      Top             =   600
      Width           =   855
   End
   Begin VB.Label Label4 
      Caption         =   "Hz"
      Height          =   255
      Left            =   2880
      TabIndex        =   8
      Top             =   240
      Width           =   855
   End
   Begin VB.Label Label3 
      Caption         =   "Duration:"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   840
      Width           =   1455
   End
   Begin VB.Label Label2 
      Caption         =   "Second Frequency:"
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   480
      Width           =   1455
   End
   Begin VB.Label Label1 
      Caption         =   "First Frequency:"
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   120
      Width           =   1215
   End
End
Attribute VB_Name = "frmToneSignal"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Freq1 As Integer
Private Freq2 As Integer
Private Dur As Integer

Private Sub bnOK_Click()
    Freq1 = Val(FirstFreq.Text)
    Freq2 = Val(SecondFreq.Text)
    Dur = Val(Duration.Text)
    
    If Freq1 = 0 Or (Freq1 >= 200 And Freq1 <= 3000) Then
        If Freq2 = 0 Or (Freq2 >= 200 And Freq2 <= 3000) Then
            If Dur > 0 And Dur < 41 Then
            Else
                MsgBox "Value must be 1 through 40", vbOKOnly, "Error"
                Duration.SetFocus
            End If
        Else
            MsgBox "Value must be 0 or 200 through 3000", vbOKOnly, "Error"
            SecondFreq.SetFocus
        End If
    Else
        MsgBox "Value must be 0 or 200 through 3000", vbOKOnly, "Error"
        FirstFreq.SetFocus
    End If
    
    Unload Me
End Sub

Private Sub btnCancel_Click()
    Unload Me
End Sub

Public Sub GetFreqValues(FFreq As Integer, SFreq As Integer, Duration As Integer)
    FFreq = Freq1
    SFreq = Freq2
    Duration = Dur
End Sub

Private Sub Form_Load()
    Freq1 = 0
    Freq2 = 0
    Dur = 0
End Sub
