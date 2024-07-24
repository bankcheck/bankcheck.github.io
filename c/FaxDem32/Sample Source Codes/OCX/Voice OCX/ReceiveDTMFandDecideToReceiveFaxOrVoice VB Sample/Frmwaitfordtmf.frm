VERSION 5.00
Begin VB.Form frmWaitforDTMF 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Wait for DTMF digits"
   ClientHeight    =   1575
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3135
   Icon            =   "Frmwaitfordtmf.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1575
   ScaleWidth      =   3135
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton btnCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   1680
      TabIndex        =   5
      Top             =   1080
      Width           =   1215
   End
   Begin VB.CommandButton btnOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   240
      TabIndex        =   2
      Top             =   1080
      Width           =   1215
   End
   Begin VB.TextBox edDelimiter 
      Height          =   375
      Left            =   1920
      MaxLength       =   1
      TabIndex        =   1
      Top             =   600
      Width           =   1095
   End
   Begin VB.TextBox edDigits 
      Height          =   375
      Left            =   1920
      MaxLength       =   3
      TabIndex        =   0
      Top             =   120
      Width           =   1095
   End
   Begin VB.Label Label2 
      Caption         =   "Delimiter digit:"
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   600
      Width           =   1455
   End
   Begin VB.Label Label1 
      Caption         =   "Number of DTMF digits:"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   1815
   End
End
Attribute VB_Name = "frmWaitforDTMF"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private nDTMFNum As Integer
Private nDelimiter As Integer

Private Sub btnCancel_Click()
    Unload Me
End Sub

Private Sub btnOK_Click()
    If edDigits.text <> "" Then
        nDTMFNum = Val(edDigits.text)
        If edDelimiter.text <> "" Then
            nDelimiter = Asc(edDelimiter.text)
            Unload Me
        Else
            nDelimiter = 0
            Unload Me
        End If
    Else
        MsgBox "Please specify the maximum number of acceptable DTMF digits!"
    End If
End Sub

Public Function GetNumberOfDigits()
    GetNumberOfDigits = nDTMFNum
End Function

Public Function GetDelimiter()
    GetDelimiter = nDelimiter
End Function

