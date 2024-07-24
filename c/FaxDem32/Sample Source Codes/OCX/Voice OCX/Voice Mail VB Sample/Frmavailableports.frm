VERSION 5.00
Begin VB.Form frmAvailablePorts 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Choose Port"
   ClientHeight    =   1530
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3345
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1530
   ScaleWidth      =   3345
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton Command2 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   2160
      TabIndex        =   2
      Top             =   840
      Width           =   1095
   End
   Begin VB.CommandButton btnChoose 
      Caption         =   "&Choose"
      Default         =   -1  'True
      Height          =   375
      Left            =   2160
      TabIndex        =   1
      Top             =   240
      Width           =   1095
   End
   Begin VB.ListBox lstFreePorts 
      Height          =   1035
      Left            =   120
      TabIndex        =   0
      Top             =   240
      Width           =   1935
   End
   Begin VB.Label Label1 
      Caption         =   "Unused Ports:"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   0
      Width           =   1455
   End
End
Attribute VB_Name = "frmAvailablePorts"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private bNoDialogic As Boolean
Private nSelectedPort As Integer
Private bOpenedPorts As Boolean

Public Sub OnlyOpenedPorts(opened As Boolean)
    bOpenedPorts = opened
End Sub

Public Sub ExceptDialogic(dialogic As Boolean)
    bNoDialogic = dialogic
End Sub

Private Sub btnChoose_Click()
    nSelectedPort = lstFreePorts.ItemData(lstFreePorts.ListIndex)
    Unload Me
End Sub

Private Sub Command2_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    Dim nIndex As Integer
    
    nSelectedPort = -1
    
    For nIndex = 1 To 255 Step 1
        If fModemID(nIndex, 0) <> 0 Then
            If (bNoDialogic = False) Or _
                (bNoDialogic = True And fMainForm.VoiceOCX.GetModemType(fModemID(nIndex, 0)) <> cnsDialogic) Then
                If fModemID(nIndex, 1) = cnsNoneAttached Then
                    If bOpenedPorts = False Then
                        If fMainForm.VoiceOCX.IsPortUsed(fModemID(nIndex, 0)) = False Then
                            lstFreePorts.AddItem (fMainForm.VoiceOCX.GetPortName(fModemID(nIndex, 0)))
                            lstFreePorts.ItemData(lstFreePorts.ListCount - 1) = nIndex
                        End If
                    Else
                        lstFreePorts.AddItem (fMainForm.VoiceOCX.GetPortName(fModemID(nIndex, 0)))
                        lstFreePorts.ItemData(lstFreePorts.ListCount - 1) = nIndex
                    End If
                End If
            End If
        End If
    Next
    
    If lstFreePorts.ListCount > 0 Then
        lstFreePorts.ListIndex = 0
    Else
        MsgBox "The program hasn't found any open port. Please open a port first!"
        btnChoose.Enabled = False
    End If
End Sub

Public Function GetSelectedPort() As Integer
    GetSelectedPort = nSelectedPort
End Function
