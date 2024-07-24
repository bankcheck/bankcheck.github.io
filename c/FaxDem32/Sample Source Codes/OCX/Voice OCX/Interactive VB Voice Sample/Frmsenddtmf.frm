VERSION 5.00
Begin VB.Form frmSendDTMF 
   Caption         =   "Send DTMF Digits"
   ClientHeight    =   1335
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   Icon            =   "frmSendDTMF.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   1335
   ScaleWidth      =   4680
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton btnExit 
      Cancel          =   -1  'True
      Caption         =   "E&xit"
      Height          =   375
      Left            =   2453
      TabIndex        =   3
      Top             =   840
      Width           =   1215
   End
   Begin VB.CommandButton btnSend 
      Caption         =   "&Send"
      Default         =   -1  'True
      Height          =   375
      Left            =   1013
      TabIndex        =   2
      Top             =   840
      Width           =   1215
   End
   Begin VB.TextBox edDTMF 
      Height          =   375
      Left            =   0
      TabIndex        =   1
      Top             =   360
      Width           =   4695
   End
   Begin VB.Label Label1 
      Caption         =   "Please enter the dtmf digits you want to send:"
      Height          =   255
      Left            =   0
      TabIndex        =   0
      Top             =   120
      Width           =   3375
   End
End
Attribute VB_Name = "frmSendDTMF"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private szDTMF As String

Private Sub btnExit_Click()
    Unload Me
End Sub

Private Sub btnSend_Click()
    szDTMF = edDTMF.Text
    Unload Me
End Sub

Public Function GetDTMFDigits()
    GetDTMFDigits = szDTMF
End Function
