VERSION 5.00
Begin VB.Form frmSaveFax 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Save Received Fax as..."
   ClientHeight    =   1200
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   Icon            =   "frmSaveFax.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1200
   ScaleWidth      =   4680
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox edFaxFilename 
      Height          =   375
      Left            =   0
      TabIndex        =   0
      Top             =   240
      Width           =   4575
   End
   Begin VB.CommandButton btnOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   1028
      TabIndex        =   1
      Top             =   720
      Width           =   1095
   End
   Begin VB.CommandButton bntCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   375
      Left            =   2348
      TabIndex        =   2
      Top             =   720
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "Please enter TIFF filename:"
      Height          =   255
      Left            =   0
      TabIndex        =   3
      Top             =   0
      Width           =   2175
   End
End
Attribute VB_Name = "frmSaveFax"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private szFaxName As String

Private Sub bntCancel_Click()
szFaxName = ""
Unload Me
End Sub

Private Sub btnOK_Click()
    szFaxName = UCase(edFaxFilename.text)
    If szFaxName <> "" Then
        If Right(szFaxName, 4) <> ".TIF" Then
            szFaxName = szFaxName + ".TIF"
        End If
        If Mid(szFaxName, 2, 1) <> ":" Then
            szFaxName = szExePath + "\" + szFaxName
        End If
        Unload Me
    End If
End Sub

Private Sub Form_Load()
    szFaxName = ""
    edFaxFilename.text = szExePath + "\Received.tif"
End Sub

Public Function GetFaxName()
    GetFaxName = szFaxName
End Function
