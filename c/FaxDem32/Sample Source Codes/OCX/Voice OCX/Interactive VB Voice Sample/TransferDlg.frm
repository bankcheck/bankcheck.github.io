VERSION 5.00
Begin VB.Form frmTransferDlg 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Call transfer"
   ClientHeight    =   1320
   ClientLeft      =   2760
   ClientTop       =   3750
   ClientWidth     =   4110
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1320
   ScaleWidth      =   4110
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox edPhoneNr 
      Height          =   285
      Left            =   120
      MousePointer    =   3  'I-Beam
      TabIndex        =   3
      Text            =   "Text1"
      Top             =   360
      Width           =   3855
   End
   Begin VB.CommandButton CancelButton 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   2160
      TabIndex        =   1
      Top             =   840
      Width           =   1215
   End
   Begin VB.CommandButton OKButton 
      Caption         =   "OK"
      Height          =   375
      Left            =   600
      TabIndex        =   0
      Top             =   840
      Width           =   1215
   End
   Begin VB.Label Label1 
      Caption         =   "Extension/Phone number:"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   0
      Width           =   2055
   End
End
Attribute VB_Name = "frmTransferDlg"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private szPhoneNr As String
Option Explicit


Public Function GetPhoneNumber()
    GetPhoneNumber = szPhoneNr
End Function

Private Sub CancelButton_Click()
    szPhoneNr = ""
    Unload Me
End Sub

Private Sub Form_Activate()
    edPhoneNr.SetFocus
End Sub

Private Sub Form_Load()
    szPhoneNr = ""
    edPhoneNr.Text = ""
End Sub

Private Sub OKButton_Click()
    szPhoneNr = UCase(edPhoneNr.Text)
    Unload Me
End Sub
