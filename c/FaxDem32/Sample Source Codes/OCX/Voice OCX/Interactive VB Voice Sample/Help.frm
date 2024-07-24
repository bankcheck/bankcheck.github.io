VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Begin VB.Form frmHelp 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Interactive Voice Sample Help"
   ClientHeight    =   6420
   ClientLeft      =   2760
   ClientTop       =   3750
   ClientWidth     =   7350
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6420
   ScaleWidth      =   7350
   ShowInTaskbar   =   0   'False
   Begin RichTextLib.RichTextBox RichTextBox1 
      Height          =   5895
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   7335
      _ExtentX        =   12938
      _ExtentY        =   10398
      _Version        =   393217
      Enabled         =   -1  'True
      ScrollBars      =   2
      TextRTF         =   $"Help.frx":0000
   End
   Begin VB.CommandButton OKButton 
      Caption         =   "OK"
      Height          =   375
      Left            =   3120
      TabIndex        =   0
      Top             =   6000
      Width           =   1215
   End
End
Attribute VB_Name = "frmHelp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Sub Form_Load()
    RichTextBox1.LoadFile "ivsvbhelp.rtf"
    RichTextBox1.Locked = True
End Sub

Private Sub OKButton_Click()
    Unload Me
End Sub
