VERSION 5.00
Begin VB.Form frmOpenBrook 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Open Brooktrout Channel"
   ClientHeight    =   1590
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5640
   Icon            =   "frmOpenBrook.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1590
   ScaleWidth      =   5640
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton btnTest 
      Caption         =   "&Test"
      Enabled         =   0   'False
      Height          =   375
      Left            =   4560
      TabIndex        =   7
      Top             =   1080
      Width           =   975
   End
   Begin VB.CommandButton btnCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   375
      Left            =   4560
      TabIndex        =   6
      Top             =   600
      Width           =   975
   End
   Begin VB.CommandButton btnOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Enabled         =   0   'False
      Height          =   375
      Left            =   4560
      TabIndex        =   5
      Top             =   120
      Width           =   975
   End
   Begin VB.TextBox ModemType 
      Height          =   285
      Left            =   1800
      TabIndex        =   4
      Text            =   "Unknown Modem"
      Top             =   360
      Width           =   2535
   End
   Begin VB.CheckBox chbLogEn 
      Caption         =   "Enable Log"
      Height          =   255
      Left            =   1800
      TabIndex        =   2
      Top             =   720
      Width           =   1575
   End
   Begin VB.ListBox lvChannelList 
      Height          =   1035
      Left            =   120
      TabIndex        =   1
      Top             =   360
      Width           =   1575
   End
   Begin VB.Label Label3 
      Caption         =   "Modem Type"
      Height          =   255
      Left            =   1800
      TabIndex        =   3
      Top             =   120
      Width           =   1455
   End
   Begin VB.Label Label1 
      Caption         =   "Available Channels"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1455
   End
End
Attribute VB_Name = "frmOpenBrook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private bLogEnabled As Boolean
Private ModemID As Long
Private ModemInd As Integer
Private Sub btnOK_Click()
    Dim nIndex As Integer
    Dim i As Integer
    
    bLogEnabled = chbLogEn.Value
    
    nIndex = lvChannelList.ListIndex
    If nIndex <> -1 Then
        ModemID = fMainForm.VoiceOCX.CreateModemObject(cnsBrooktrout)
        If ModemID <> 0 Then
            ModemInd = AddNewModem(ModemID)
            If ModemInd <> 0 Then
                fModemID(ModemInd, 1) = cnsSelectBT
                If fMainForm.VoiceOCX.OpenPort(ModemID, lvChannelList.List(nIndex)) = 0 Then
                    btnOK.Enabled = False
                    btnCancel.Enabled = False
                Else
                    MsgBox "Cannot open channel: " + lvChannelList.List(nIndex)
                End If
            End If
        End If
    End If
End Sub
Private Sub btnCancel_Click()
    Unload Me
End Sub

Private Sub btnTest_Click()
    Dim szType As String
    
    If lvChannelList.ListIndex <> -1 Then
        fMainForm.VoiceOCX.GetBrooktroutChannelType lvChannelList.ListIndex, szType, 50
        ModemType.Text = szType
    End If
End Sub

Private Sub Form_Load()
    Dim nChannels As Integer
    Dim szChannel As String
    Dim nIndex As Integer
    
    nChannels = 0
    
    For nIndex = 0 To MAX_BROOK_CHANNELS
        If fMainForm.VoiceOCX.IsBrooktroutChannelFree(nIndex) <> False Then
            szChannel = "CHANNEL"
            bcStr = Str(nIndex)
            bcStr = Right(bcStr, Len(bcStr) - 1)
            szChannel = szChannel + bcStr
            lvChannelList.AddItem szChannel, nChannels
            nChannels = nChannels + 1
        End If
    Next
    
    If nChannels > 0 Then
        btnOK.Enabled = True
        btnTest.Enabled = True
    End If
End Sub
Public Sub VoiceOCX_PortOpen()
    MsgBox "Channel opened"
    Unload Me
End Sub
Public Sub VoiceOCX_ModemError()
    MsgBox "Open channel failed!"
    btnOK.Enabled = True
    btnCancel.Enabled = True
    DeleteModem (ModemID)
    fMainForm.VoiceOCX.DestroyModemObject (ModemID)
End Sub
Public Function GetSelectedChannel()
    GetSelectedChannel = ModemID
End Function
Public Function LogEnabled()
    LogEnabled = bLogEnabled
End Function


