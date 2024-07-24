VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Begin VB.Form frmHelp 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Dialog Caption"
   ClientHeight    =   6435
   ClientLeft      =   2760
   ClientTop       =   3750
   ClientWidth     =   7875
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6435
   ScaleWidth      =   7875
   ShowInTaskbar   =   0   'False
   Begin RichTextLib.RichTextBox RichTextBox1 
      Height          =   5895
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   7815
      _ExtentX        =   13785
      _ExtentY        =   10398
      _Version        =   393217
      Enabled         =   -1  'True
      ScrollBars      =   2
      TextRTF         =   $"frmHelp.frx":0000
   End
   Begin VB.CommandButton OKButton 
      Caption         =   "OK"
      Height          =   375
      Left            =   3240
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
    RichTextBox1.LoadFile "vmvbhelp.rtf"
    RichTextBox1.Locked = True
End Sub

Private Sub OKButton_Click()
    Unload Me
End Sub

