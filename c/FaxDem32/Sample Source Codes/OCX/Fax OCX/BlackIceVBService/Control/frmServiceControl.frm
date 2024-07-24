VERSION 5.00
Begin VB.Form frmServiceControl 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "VB NT Service Sample"
   ClientHeight    =   1635
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6135
   Icon            =   "frmServiceControl.frx":0000
   MaxButton       =   0   'False
   ScaleHeight     =   1635
   ScaleWidth      =   6135
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer tmrCheck 
      Interval        =   1000
      Left            =   120
      Top             =   1080
   End
   Begin VB.CheckBox chkSystem 
      Caption         =   "System Account"
      Height          =   255
      Left            =   3840
      TabIndex        =   6
      Top             =   1200
      Value           =   1  'Checked
      Width           =   1575
   End
   Begin VB.TextBox txtPassword 
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   1680
      PasswordChar    =   "*"
      TabIndex        =   5
      Top             =   1200
      Width           =   1935
   End
   Begin VB.TextBox txtAccount 
      Height          =   285
      Left            =   1680
      TabIndex        =   3
      Top             =   840
      Width           =   3735
   End
   Begin VB.CommandButton cmdStart 
      Caption         =   "Start Service"
      Height          =   615
      Left            =   3360
      TabIndex        =   1
      Top             =   120
      Width           =   2055
   End
   Begin VB.CommandButton cmdInstall 
      Caption         =   "Install Service"
      Height          =   615
      Left            =   720
      TabIndex        =   0
      Top             =   120
      Width           =   2055
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00808080&
      BorderStyle     =   6  'Inside Solid
      Index           =   1
      X1              =   240
      X2              =   5910
      Y1              =   1910
      Y2              =   1910
   End
   Begin VB.Label lblPassword 
      Caption         =   "Password:"
      Height          =   255
      Left            =   720
      TabIndex        =   4
      Top             =   1200
      Width           =   855
   End
   Begin VB.Label lblAccount 
      Caption         =   "Account:"
      Height          =   255
      Left            =   720
      TabIndex        =   2
      Top             =   840
      Width           =   855
   End
End
Attribute VB_Name = "frmServiceControl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Type OSVERSIONINFO
    dwOSVersionInfoSize As Long
    dwMajorVersion As Long
    dwMinorVersion As Long
    dwBuildNumber As Long
    dwPlatformId As Long
    szCSDVersion(1 To 128) As Byte
End Type
Private Const VER_PLATFORM_WIN32_NT = 2&

Private Declare Function GetVersionEx Lib "kernel32" Alias "GetVersionExA" (lpVersionInformation As OSVERSIONINFO) As Long

Private Declare Function ShellExecute Lib "shell32" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

Private Const SW_SHOWNORMAL = 1&
Dim ServState As SERVICE_STATE, Installed As Boolean

Private Sub chkSystem_Click()
    If chkSystem Then
        txtAccount = "LocalSystem"
        txtAccount.Enabled = False
        txtPassword.Enabled = False
        lblAccount.Enabled = False
        lblPassword.Enabled = False
    Else
        txtAccount = vbNullString
        txtAccount.Enabled = True
        txtPassword.Enabled = True
        lblAccount.Enabled = True
        lblPassword.Enabled = True
    End If
End Sub

Private Sub cmdInstall_Click()
    CheckService
    If Not cmdInstall.Enabled Then Exit Sub
    cmdInstall.Enabled = False
    If Installed Then
        DeleteNTService
    Else
        SetNTService
        txtPassword = vbNullString
    End If
    CheckService
End Sub

' This sub checks service status
Private Sub CheckService()
    If GetServiceConfig() = 0 Then
        Installed = True
        cmdInstall.Caption = "Uninstall Service"
        txtAccount.Enabled = False
        txtPassword.Enabled = False
        lblAccount.Enabled = False
        lblPassword.Enabled = False
        chkSystem.Enabled = False
        ServState = GetServiceStatus()
        Select Case ServState
            Case SERVICE_RUNNING
                cmdInstall.Enabled = False
                cmdStart.Caption = "Stop Service"
                cmdStart.Enabled = True
            Case SERVICE_STOPPED
                cmdInstall.Enabled = True
                cmdStart.Caption = "Start Service"
                cmdStart.Enabled = True
            Case Else
                cmdInstall.Enabled = False
                cmdStart.Enabled = False
        End Select
    Else
        Installed = False
        cmdInstall.Caption = "Install Service"
        txtAccount.Enabled = chkSystem = 0
        txtPassword.Enabled = chkSystem = 0
        lblAccount.Enabled = chkSystem = 0
        lblPassword.Enabled = chkSystem = 0
        chkSystem.Enabled = True
        cmdStart.Enabled = False
        cmdInstall.Enabled = True
    End If
End Sub

Private Sub cmdStart_Click()
    CheckService
    If Not cmdStart.Enabled Then Exit Sub
    cmdStart.Enabled = False
    If ServState = SERVICE_RUNNING Then
        StopNTService
    ElseIf ServState = SERVICE_STOPPED Then
        StartNTService
    End If
    CheckService
End Sub

Private Sub Form_Load()
    If Not CheckIsNT() Then
        MsgBox "This program requires Windows NT/2000/XP"
        Unload Me
        Exit Sub
    End If
    AppPath = App.Path
    If Right$(AppPath, 1) <> "\" Then AppPath = AppPath & "\"
    chkSystem_Click
    CheckService
End Sub

' CheckIsNT() returns True, if the program runs
' under Windows NT or Windows 2000, and False
' otherwise.

Private Function CheckIsNT() As Boolean
    Dim OSVer As OSVERSIONINFO
    OSVer.dwOSVersionInfoSize = LenB(OSVer)
    GetVersionEx OSVer
    CheckIsNT = (OSVer.dwPlatformId = VER_PLATFORM_WIN32_NT)
End Function

Private Sub tmrCheck_Timer()
    CheckService
End Sub
