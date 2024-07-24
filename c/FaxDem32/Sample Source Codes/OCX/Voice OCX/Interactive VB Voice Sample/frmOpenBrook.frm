VERSION 5.00
Begin VB.Form frmOpenBrook 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Open Brooktrout Channel"
   ClientHeight    =   1905
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5640
   Icon            =   "frmOpenBrook.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1905
   ScaleWidth      =   5640
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox ConfigFile 
      Height          =   285
      Left            =   1800
      TabIndex        =   9
      Top             =   480
      Width           =   2655
   End
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
      Top             =   1440
      Width           =   2535
   End
   Begin VB.CheckBox chbLogEn 
      Caption         =   "Enable Log"
      Height          =   255
      Left            =   1800
      TabIndex        =   2
      Top             =   840
      Width           =   1575
   End
   Begin VB.ListBox lvChannelList 
      Height          =   1230
      Left            =   120
      TabIndex        =   1
      Top             =   360
      Width           =   1575
   End
   Begin VB.Label Label2 
      Caption         =   "ConfigFile"
      Height          =   255
      Left            =   1920
      TabIndex        =   8
      Top             =   120
      Width           =   1215
   End
   Begin VB.Label Label3 
      Caption         =   "Modem Type"
      Height          =   255
      Left            =   1800
      TabIndex        =   3
      Top             =   1200
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

Private Declare Function GetPrivateProfileString Lib "kernel32" _
Alias "GetPrivateProfileStringA" _
(ByVal lpAppName As String, _
ByVal lpKey As Any, _
ByVal lpDefault As String, _
ByVal lpReturnedString As String, _
ByVal nSize As Long, ByVal _
lpFileName As String) As Long

Private Declare Function WritePrivateProfileString Lib "kernel32" Alias _
"WritePrivateProfileStringA" _
(ByVal lpApplicationName As String, _
ByVal lpKeyName As String, _
ByVal lpString As String, _
ByVal lpFileName As String) As Integer

Private failed As Boolean
Private Sub btnOK_Click()
    Dim nIndex As Integer
    Dim assist As Long
    bLogEnabled = chbLogEn.Value
    
    failed = False
    fMainForm.VoiceOCX.SetBrooktroutConfigFile ConfigFile.text
    assist = WritePrivateProfileString("Brooktrout", "Config file", ConfigFile.text, "Demo32.ini")
    nIndex = lvChannelList.ListIndex
    If nIndex <> -1 Then
        lModemID = fMainForm.VoiceOCX.CreateModemObject(cnsBrooktrout)
        If lModemID <> 0 Then
            nPrStatus = cnsSelectBT
            If fMainForm.VoiceOCX.OpenPort(lModemID, lvChannelList.List(nIndex)) = 0 Then
                btnOK.Enabled = False
                btnCancel.Enabled = False
            Else
                MsgBox "Cannot open channel: " + lvChannelList.List(nIndex)
            End If
        Else
            MsgBox "Config file is not valid!", vbOKOnly
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
        ModemType.text = szType
    End If
End Sub

Private Sub Form_Load()
    Dim nChannels As Integer
    Dim szChannel As String
    Dim nIndex As Integer
    Dim assist As Long
    Dim ConfigFileStr As String
    
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
    
    ConfigFileStr = String$(200, 0)
    assist = GetPrivateProfileString("Brooktrout", "Config file", "btcall.cfg", ConfigFileStr, 200, "Demo32.ini")
    ConfigFile.text = ConfigFileStr
    
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
    If Not failed Then
        failed = True
        MsgBox "Open channel failed!"
        btnOK.Enabled = True
        btnCancel.Enabled = True
        fMainForm.VoiceOCX.DestroyModemObject (lModemID)
        lModemID = 0
    End If
End Sub
Public Function LogEnabled()
    LogEnabled = bLogEnabled
End Function


