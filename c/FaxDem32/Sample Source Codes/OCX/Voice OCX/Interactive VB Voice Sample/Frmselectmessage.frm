VERSION 5.00
Begin VB.Form frmSelectMessage 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Select Voice Message"
   ClientHeight    =   1950
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6075
   Icon            =   "frmSelectMessage.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1950
   ScaleWidth      =   6075
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton btnExit 
      Cancel          =   -1  'True
      Caption         =   "E&xit"
      Height          =   375
      Left            =   4800
      TabIndex        =   2
      Top             =   720
      Width           =   1215
   End
   Begin VB.CommandButton btnSelect 
      Caption         =   "&Select"
      Default         =   -1  'True
      Enabled         =   0   'False
      Height          =   375
      Left            =   4800
      TabIndex        =   1
      Top             =   240
      Width           =   1215
   End
   Begin VB.ListBox lstVoiceFiles 
      Height          =   1620
      Left            =   0
      TabIndex        =   0
      Top             =   240
      Width           =   4695
   End
End
Attribute VB_Name = "frmSelectMessage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private szVoiceFile As String
Private ModemID As Long

Public Sub SetModemID(Modem As Long)
    ModemID = Modem
End Sub

Public Function GetSelectedVoiceFile()
    GetSelectedVoiceFile = szVoiceFile
End Function

Private Sub btnExit_Click()
    Unload Me
End Sub

Private Sub btnSelect_Click()
    szVoiceFile = szExePath + "\VOICE\" + lstVoiceFiles.List(lstVoiceFiles.ListIndex)
    Unload Me
End Sub

Private Sub Form_Load()
    szVoiceFile = ""
    Dim MyPath As String
    
    MyPath = szExePath + "\VOICE\*"
    SetVocExtension ModemID, MyPath
    
    lstVoiceFiles.Clear
    
    MyName = Dir(MyPath, vbDirectory)
    Do While MyName <> ""
        If (GetAttr(szExePath & "\VOICE\" & MyName) And vbDirectory) <> vbDirectory Then
                    lstVoiceFiles.AddItem MyName
        End If
        MyName = Dir
    Loop
    
    If lstVoiceFiles.ListCount > 0 Then
        lstVoiceFiles.ListIndex = 0
        btnSelect.Enabled = True
    End If
End Sub
