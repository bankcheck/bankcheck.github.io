VERSION 5.00
Begin VB.Form AboutDlg 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "About Voice/Fax Demo"
   ClientHeight    =   2055
   ClientLeft      =   2115
   ClientTop       =   1860
   ClientWidth     =   4170
   Icon            =   "frmAbout.frx":0000
   LinkTopic       =   "Form4"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   2055
   ScaleWidth      =   4170
   ShowInTaskbar   =   0   'False
   Begin VB.PictureBox Picture1 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   480
      Left            =   3480
      Picture         =   "frmAbout.frx":030A
      ScaleHeight     =   480
      ScaleWidth      =   480
      TabIndex        =   3
      Top             =   240
      Width           =   480
   End
   Begin VB.CommandButton Command1 
      Caption         =   "OK"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   450
      Left            =   1440
      TabIndex        =   2
      Top             =   1440
      Width           =   1170
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      Caption         =   "Copyright 1998 by Black Ice Software Inc."
      Height          =   255
      Left            =   480
      TabIndex        =   1
      Top             =   855
      Width           =   3135
   End
   Begin VB.Label Label1 
      Caption         =   "Voice/Fax OCX demo"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   16.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   3135
   End
End
Attribute VB_Name = "AboutDlg"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
    Unload AboutDlg
End Sub


