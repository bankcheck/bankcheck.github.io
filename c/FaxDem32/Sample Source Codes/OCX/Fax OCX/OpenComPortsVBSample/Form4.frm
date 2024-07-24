VERSION 5.00
Begin VB.Form AboutDlg 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "About..."
   ClientHeight    =   3450
   ClientLeft      =   2115
   ClientTop       =   1860
   ClientWidth     =   3735
   Icon            =   "Form4.frx":0000
   LinkTopic       =   "Form4"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   3450
   ScaleWidth      =   3735
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame Frame1 
      Height          =   1335
      Left            =   120
      TabIndex        =   3
      Top             =   1320
      Width           =   3495
      Begin VB.Label webLabel 
         Caption         =   "http://www.blackice.com"
         ForeColor       =   &H8000000D&
         Height          =   255
         Left            =   1200
         MouseIcon       =   "Form4.frx":000C
         MousePointer    =   99  'Custom
         TabIndex        =   9
         Top             =   960
         Width           =   1935
      End
      Begin VB.Label mailLabel 
         Caption         =   "sales@blackice.com"
         ForeColor       =   &H8000000D&
         Height          =   255
         Left            =   1200
         MouseIcon       =   "Form4.frx":0316
         MousePointer    =   99  'Custom
         TabIndex        =   8
         Top             =   720
         Width           =   1935
      End
      Begin VB.Label Label6 
         Alignment       =   1  'Right Justify
         Caption         =   "Web site:"
         Height          =   255
         Left            =   240
         TabIndex        =   7
         Top             =   960
         Width           =   855
      End
      Begin VB.Label Label5 
         Alignment       =   1  'Right Justify
         Caption         =   "E-mail:"
         Height          =   255
         Left            =   240
         TabIndex        =   6
         Top             =   720
         Width           =   855
      End
      Begin VB.Label Label4 
         Alignment       =   2  'Center
         Caption         =   "FAX: (603) 882-1344"
         Height          =   255
         Left            =   240
         TabIndex        =   5
         Top             =   480
         Width           =   3135
      End
      Begin VB.Label Label3 
         Alignment       =   2  'Center
         Caption         =   "Tel.: (603) 882-7711"
         Height          =   255
         Left            =   240
         TabIndex        =   4
         Top             =   240
         Width           =   3135
      End
   End
   Begin VB.CommandButton Command1 
      Cancel          =   -1  'True
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   1200
      TabIndex        =   2
      Top             =   2880
      Width           =   1215
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   1560
      Picture         =   "Form4.frx":0620
      Top             =   480
      Width           =   480
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      Caption         =   "Visual Basic OpenComPorts Sample"
      Height          =   255
      Left            =   600
      TabIndex        =   1
      Top             =   120
      Width           =   2535
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      Caption         =   "Copyright (c) Black Ice Software Inc., 2005"
      Height          =   240
      Left            =   120
      TabIndex        =   0
      Top             =   1095
      Width           =   3495
   End
End
Attribute VB_Name = "AboutDlg"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Declare Function ShellExecute Lib "shell32.dll" Alias _
   "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As _
   String, ByVal lpFile As String, ByVal lpParameters As String, _
   ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

Private Sub Command1_Click()
    Unload AboutDlg
End Sub

Private Sub mailLabel_Click()
 Dim ret As Long
    Dim mail As String
    mail = "mailto:" & mailLabel.Caption
    
    ret = ShellExecute(Me.hwnd, "open", mail, vbNullString, vbNullString, 1)
    If ret <= 32 Then
        MsgBox "Error opening " + mailLabel.Caption
    End If

End Sub

Private Sub webLabel_Click()
 Dim ret As Long
    
    ret = ShellExecute(Me.hwnd, "open", webLabel.Caption, vbNullString, vbNullString, 1)
    If ret <= 32 Then
        MsgBox "Error opening " + webLabel.Caption
    End If

End Sub
