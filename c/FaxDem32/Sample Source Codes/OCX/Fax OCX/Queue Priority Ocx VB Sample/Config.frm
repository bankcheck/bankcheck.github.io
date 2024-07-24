VERSION 5.00
Begin VB.Form FaxConfigDlg 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Fax Configuration"
   ClientHeight    =   3915
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4365
   Icon            =   "Config.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3915
   ScaleWidth      =   4365
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.CheckBox OptionsCheckBox 
      Caption         =   "Enable ECM"
      Height          =   255
      Index           =   0
      Left            =   2280
      TabIndex        =   20
      Top             =   2600
      Width           =   1215
   End
   Begin VB.CheckBox OptionsCheckBox 
      Caption         =   "Enable BFT"
      Height          =   255
      Index           =   1
      Left            =   2280
      TabIndex        =   21
      Top             =   2880
      Width           =   1215
   End
   Begin VB.Frame SpeakerVolumeFrame 
      Caption         =   "Speaker Volume"
      Height          =   1455
      Left            =   120
      TabIndex        =   26
      Top             =   1680
      Width           =   1815
      Begin VB.OptionButton SpeakerVolumeOptionBtn 
         Caption         =   "Low"
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   3
         Top             =   360
         Width           =   855
      End
      Begin VB.OptionButton SpeakerVolumeOptionBtn 
         Caption         =   "Medium"
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   4
         Top             =   720
         Value           =   -1  'True
         Width           =   975
      End
      Begin VB.OptionButton SpeakerVolumeOptionBtn 
         Caption         =   "High"
         Height          =   255
         Index           =   2
         Left            =   120
         TabIndex        =   5
         Top             =   1080
         Width           =   855
      End
   End
   Begin VB.Frame SpeakerModeFrame 
      Caption         =   "Speaker Mode"
      Height          =   1455
      Left            =   120
      TabIndex        =   24
      Top             =   120
      Width           =   1815
      Begin VB.OptionButton SpeakerModeOptionBtn 
         Caption         =   "Off"
         Height          =   255
         Index           =   0
         Left            =   120
         Picture         =   "Config.frx":000C
         TabIndex        =   0
         Top             =   360
         Width           =   1095
      End
      Begin VB.OptionButton SpeakerModeOptionBtn 
         Caption         =   "On"
         Height          =   255
         Index           =   1
         Left            =   120
         Picture         =   "Config.frx":044E
         TabIndex        =   1
         Top             =   720
         Width           =   1095
      End
      Begin VB.OptionButton SpeakerModeOptionBtn 
         Caption         =   "Until Connected"
         Height          =   255
         Index           =   2
         Left            =   120
         Picture         =   "Config.frx":0890
         TabIndex        =   2
         Top             =   1080
         Value           =   -1  'True
         Width           =   1455
      End
   End
   Begin VB.Frame BaudRateFrame 
      Caption         =   "Baud Rate"
      Height          =   2415
      Left            =   2160
      TabIndex        =   25
      Top             =   120
      Width           =   2055
      Begin VB.OptionButton BaudRateOptionBtn 
         Caption         =   "14400"
         Height          =   255
         Index           =   5
         Left            =   120
         TabIndex        =   11
         Top             =   1800
         Width           =   855
      End
      Begin VB.OptionButton BaudRateOptionBtn 
         Caption         =   "12000"
         Height          =   255
         Index           =   4
         Left            =   120
         TabIndex        =   10
         Top             =   1500
         Width           =   855
      End
      Begin VB.OptionButton BaudRateOptionBtn 
         Caption         =   "9600"
         Height          =   255
         Index           =   3
         Left            =   120
         TabIndex        =   9
         Top             =   1200
         Width           =   735
      End
      Begin VB.OptionButton BaudRateOptionBtn 
         Caption         =   "7200"
         Height          =   255
         Index           =   2
         Left            =   120
         TabIndex        =   8
         Top             =   900
         Width           =   855
      End
      Begin VB.OptionButton BaudRateOptionBtn 
         Caption         =   "4800"
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   7
         Top             =   600
         Width           =   855
      End
      Begin VB.OptionButton BaudRateOptionBtn 
         Caption         =   "2400"
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   6
         Top             =   300
         Width           =   855
      End
      Begin VB.OptionButton BaudRateOptionBtn 
         Caption         =   "16800"
         Height          =   255
         Index           =   6
         Left            =   120
         TabIndex        =   12
         Top             =   2100
         Width           =   855
      End
      Begin VB.OptionButton BaudRateOptionBtn 
         Caption         =   "19200"
         Height          =   255
         Index           =   7
         Left            =   1080
         TabIndex        =   13
         Top             =   300
         Width           =   855
      End
      Begin VB.OptionButton BaudRateOptionBtn 
         Caption         =   "21600"
         Height          =   255
         Index           =   8
         Left            =   1080
         TabIndex        =   14
         Top             =   600
         Width           =   855
      End
      Begin VB.OptionButton BaudRateOptionBtn 
         Caption         =   "24000"
         Height          =   255
         Index           =   9
         Left            =   1080
         TabIndex        =   15
         Top             =   900
         Width           =   855
      End
      Begin VB.OptionButton BaudRateOptionBtn 
         Caption         =   "26400"
         Height          =   255
         Index           =   10
         Left            =   1080
         TabIndex        =   16
         Top             =   1200
         Width           =   855
      End
      Begin VB.OptionButton BaudRateOptionBtn 
         Caption         =   "28800"
         Height          =   255
         Index           =   11
         Left            =   1080
         TabIndex        =   17
         Top             =   1500
         Width           =   855
      End
      Begin VB.OptionButton BaudRateOptionBtn 
         Caption         =   "31200"
         Height          =   255
         Index           =   12
         Left            =   1080
         TabIndex        =   18
         Top             =   1800
         Width           =   855
      End
      Begin VB.OptionButton BaudRateOptionBtn 
         Caption         =   "33600"
         Height          =   255
         Index           =   13
         Left            =   1080
         TabIndex        =   19
         Top             =   2100
         Width           =   855
      End
   End
   Begin VB.CommandButton CommandCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   375
      Left            =   480
      TabIndex        =   22
      Top             =   3360
      Width           =   1095
   End
   Begin VB.CommandButton CommandOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   2280
      TabIndex        =   23
      Top             =   3360
      Width           =   1095
   End
End
Attribute VB_Name = "FaxConfigDlg"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Declare Function GetProfileInt Lib "kernel32.dll" Alias _
   "GetProfileIntA" (ByVal lpszSection As String, _
    ByVal lpszEntry As String, _
    ByVal nDefault As Integer) As Integer
Private Sub CommandCancel_Click()
Unload FaxConfigDlg
End Sub

Private Sub CommandOK_Click()
    Dim index As Integer
    
    index = 0
    While SpeakerModeOptionBtn(index).Value = False
        index = index + 1
    Wend
    Form1.SpeakerMode = index
    
    index = 0
    While SpeakerVolumeOptionBtn(index).Value = False
        index = index + 1
    Wend
    Form1.SpeakerVolume = index
    
    If OptionsCheckBox(0).Value Then
         Form1.EnableECM = EC_ENABLE
    Else
         Form1.EnableECM = EC_DISABLE
    End If

    If OptionsCheckBox(1).Value Then
         Form1.EnableBFT = BF_ENABLE
    Else
         Form1.EnableBFT = BF_DISABLE
    End If
    index = 0
    While BaudRateOptionBtn(index).Value = False
        index = index + 1
    Wend
    Form1.BaudRate = index + 2
    
    Form1.FAX1.SetSpeakerMode Form1.ActualFaxPort, Form1.SpeakerMode, Form1.SpeakerVolume
    Form1.FAX1.SetPortCapability Form1.ActualFaxPort, PC_ECM, Form1.EnableECM
    Form1.FAX1.SetPortCapability Form1.ActualFaxPort, PC_BINARY, Form1.EnableBFT
    Form1.FAX1.SetPortCapability Form1.ActualFaxPort, PC_MAX_BAUD_SEND, Form1.BaudRate
    
    Unload FaxConfigDlg
End Sub

Private Sub Form_Load()
    Dim index As Integer
    Dim nBaud As Integer
    
    index = Form1.SpeakerMode
    SpeakerModeOptionBtn(index).Value = True
    
    index = Form1.SpeakerVolume
    SpeakerVolumeOptionBtn(index).Value = True
    
    'BaudRate
    nBaud = Form1.BaudRate - 2
    
    BaudRateOptionBtn(nBaud).Value = True

    If Form1.EnableECM = EC_ENABLE Then
         OptionsCheckBox(0).Value = 1
    Else
         OptionsCheckBox(0).Value = 0
    End If
    
    If Form1.EnableBFT = BF_ENABLE Then
         OptionsCheckBox(1).Value = 1
    Else
         OptionsCheckBox(1).Value = 0
    End If
    

End Sub

