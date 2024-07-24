VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "COM Logger"
   ClientHeight    =   7290
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   7635
   Icon            =   "NecSimulator.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   7290
   ScaleWidth      =   7635
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton btnStart 
      Caption         =   "Start"
      Height          =   495
      Left            =   3240
      TabIndex        =   0
      Top             =   3360
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub btnStart_Click()
    Dim InFile As String
    Dim OutFile As String
    Dim data As String
    Dim message As String
    Dim Pos As Integer
    
    btnStart.Enabled = False
    btnStart.Caption = "Process..."
    InFile = "log.txt"
    OutFile = "out.txt"
    
    Open InFile For Input As #1
    Open OutFile For Output As #2
    Do Until EOF(1)
        Line Input #1, data
        Pos = InStr(1, data, "1>")
        If Pos > 0 Then
            message = message & Right(data, Len(data) - Pos - 1)
        Else
            If Len(message) > 0 Then
                Print #2, "1>" & message
            End If
            Print #2, data
            message = ""
        End If
    Loop
    Close #1
    Close #2
    
    btnStart.Caption = "Start"
    btnStart.Enabled = True
End Sub
