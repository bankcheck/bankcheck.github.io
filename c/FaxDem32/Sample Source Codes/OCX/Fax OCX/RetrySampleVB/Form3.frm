VERSION 5.00
Begin VB.Form COMOpen 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Open Com Port"
   ClientHeight    =   1380
   ClientLeft      =   1005
   ClientTop       =   1665
   ClientWidth     =   3390
   Icon            =   "Form3.frx":0000
   LinkTopic       =   "Form3"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   1380
   ScaleWidth      =   3390
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.ListBox COMList 
      Height          =   1035
      ItemData        =   "Form3.frx":000C
      Left            =   120
      List            =   "Form3.frx":000E
      TabIndex        =   0
      Top             =   120
      Width           =   1815
   End
   Begin VB.CommandButton CommandCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   372
      Left            =   2040
      TabIndex        =   2
      Top             =   720
      Width           =   1215
   End
   Begin VB.CommandButton CommandOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   372
      Left            =   2040
      TabIndex        =   1
      Top             =   240
      Width           =   1215
   End
End
Attribute VB_Name = "COMOpen"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
    
    Private Declare Function GetPrivateProfileString Lib "kernel32" Alias _
    "GetPrivateProfileStringA" _
    (ByVal lpApplicationName As String, _
    ByVal lpKeyName As String, _
    ByVal lpDefault As String, _
    ByVal lpRetunedString As String, _
    ByVal nSize As Integer, _
    ByVal lpFileName As String) As Integer

    Private Declare Function WritePrivateProfileString& Lib _
    "kernel32" Alias "WritePrivateProfileStringA" _
    (ByVal AppName$, ByVal KeyName$, ByVal _
    keydefault$, ByVal FileName$)


    Private Declare Function GetProfileString Lib "kernel32" Alias _
    "WriteProfileStringA" _
    (ByVal lpszSection As String, _
    ByVal lpszEntry As String, _
    ByVal lpszDefault As String) As String

    Private Declare Function GetProfileInt Lib "kernel32" Alias _
    "GetProfileIntA" _
    (ByVal lpszSection As String, _
    ByVal lpszEntry As String, _
    ByVal nDefault As Integer) As Integer

    Private Declare Function WriteProfileString Lib "kernel32" Alias _
    "WriteProfileStringA" _
    (ByVal lpszSection As String, _
    ByVal lpszEntry As String, _
    ByVal lpstring As String) As Boolean

Private Sub CommandCancel_Click()
    Unload COMOpen
End Sub


Public Sub Sleep(Seconds As Single, EventEnable As Boolean)
    On Error GoTo ErrHndl
    Dim OldTimer As Single
    
    OldTimer = Timer
    Do While (Timer - OldTimer) < Seconds
        If EventEnable Then DoEvents
    Loop

    Exit Sub
ErrHndl:
    Err.Clear
End Sub



Private Sub CommandOK_Click()
    Static errcode As Long
    Dim IniFileName As String
    Dim nFax As Integer
    Dim szFaxName, szFaxName1 As String
    Dim SelectedFax As Integer
    Dim temp As Integer
    Screen.MousePointer = 11
        
    IniFileName = "faxcpp1.ini"
    'Get fax name.
    
    Form1.FAX1.FaxType = "GCLASS1(SFC)"
    Form1.FAX1.TestModem (COMList.List(COMList.ListIndex))
    If Len(Form1.FAX1.ClassType) <> 0 Then
        Form1.ActualFaxPort = COMList.List(COMList.ListIndex)
        Sleep 2, False
        errcode = Form1.FAX1.OpenPort(COMList.List(COMList.ListIndex))
        
        If (errcode <> 0) Then
            i = MsgBox(Form1.Errors(errcode), 0)
        Else
            Form1.ClosePort.Enabled = True
            Form1.send.Enabled = True
            Form1.HideManager.Enabled = True
            Form1.EventList.AddItem (COMList.List(COMList.ListIndex) + " was opened")
            Form1.FAX1.SetRings COMList.List(COMList.ListIndex), 0
        End If
        Form1.FAX1.SetSpeakerMode Form1.ActualFaxPort, Form1.SpeakerMode, Form1.SpeakerVolume
        Form1.FAX1.SetPortCapability Form1.ActualFaxPort, PC_ECM, Form1.EnableECM
        Form1.FAX1.SetPortCapability Form1.ActualFaxPort, PC_BINARY, Form1.EnableBFT
        Form1.FAX1.SetPortCapability Form1.ActualFaxPort, PC_MAX_BAUD_SEND, Form1.BaudRate
                
    Else
         MsgBox "No Modem on " + COMList.List(COMList.ListIndex) + " port!", vbExclamation + vbOKOnly, "Warning", 0, 0
         Screen.MousePointer = 0
         Exit Sub
    End If
    
    If (Len(Form1.FAX1.AvailablePorts) > 0) Then
        Form1.comport.Enabled = True
    Else
        Form1.comport.Enabled = False
    End If
    
    Unload COMOpen
    Screen.MousePointer = 0
    Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
End Sub

Private Sub Form_Load()
    Static t1, t2 As String
    Static flag As Boolean
    Static i, j As Integer
    t1 = Form1.FAX1.AvailablePorts
    flag = True
    i = 1
    While flag
        j = InStr(1, t1, " ", 0)
        If (j = 0) Then
            t2 = t1
            flag = False
        Else
            t2 = Left(t1, j - 1)
            t1 = Right(t1, Len(t1) - j)
        End If
        COMList.AddItem (t2)
    Wend
    
    COMList.ListIndex = 0
        
    
End Sub
