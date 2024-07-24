VERSION 5.00
Begin VB.Form COMOpen 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Open Com Port"
   ClientHeight    =   7290
   ClientLeft      =   1005
   ClientTop       =   1665
   ClientWidth     =   5145
   Icon            =   "Form3.frx":0000
   LinkTopic       =   "Form3"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   7290
   ScaleWidth      =   5145
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame Frame2 
      Caption         =   "Header Setup"
      Height          =   735
      Left            =   120
      TabIndex        =   14
      Top             =   5000
      Width           =   4935
      Begin VB.CheckBox ChbHeader 
         Caption         =   "Create Header"
         Height          =   255
         Left            =   120
         TabIndex        =   8
         Top             =   280
         Width           =   1815
      End
   End
   Begin VB.Frame Frame4 
      Caption         =   "Debug File Generation"
      Height          =   735
      Left            =   120
      TabIndex        =   15
      Top             =   5840
      Width           =   4935
      Begin VB.CheckBox ChkEnblDebug 
         Caption         =   "Enable Driver Debug"
         Height          =   255
         Left            =   120
         TabIndex        =   9
         Top             =   290
         Width           =   1935
      End
   End
   Begin VB.Frame Frame3 
      Caption         =   "Modem Setup"
      Height          =   1815
      Left            =   120
      TabIndex        =   13
      Top             =   3080
      Width           =   4935
      Begin VB.ListBox COMList 
         Height          =   840
         ItemData        =   "Form3.frx":000C
         Left            =   3840
         List            =   "Form3.frx":000E
         TabIndex        =   7
         Top             =   530
         Width           =   975
      End
      Begin VB.TextBox SetupStrTextBox 
         Height          =   315
         Left            =   1185
         MaxLength       =   25
         TabIndex        =   4
         Top             =   680
         Width           =   2535
      End
      Begin VB.TextBox ResetStrTextBox 
         Height          =   315
         Left            =   1185
         MaxLength       =   25
         TabIndex        =   3
         Top             =   320
         Width           =   2535
      End
      Begin VB.TextBox LocalIDEdit 
         Height          =   315
         Left            =   1665
         MaxLength       =   100
         TabIndex        =   5
         Top             =   1055
         Width           =   2055
      End
      Begin VB.TextBox NumberOfRingsEdit 
         Height          =   315
         Left            =   2145
         MaxLength       =   1
         TabIndex        =   6
         Top             =   1415
         Width           =   255
      End
      Begin VB.Label Label9 
         Caption         =   "Setup String:"
         Height          =   255
         Left            =   165
         TabIndex        =   27
         Top             =   710
         Width           =   1335
      End
      Begin VB.Label Label8 
         Caption         =   "Reset String:"
         Height          =   255
         Left            =   165
         TabIndex        =   26
         Top             =   350
         Width           =   1095
      End
      Begin VB.Label Label6 
         Caption         =   "Ports:"
         Height          =   255
         Left            =   3840
         TabIndex        =   24
         Top             =   320
         Width           =   615
      End
      Begin VB.Label Label2 
         Caption         =   "Identification String:"
         Height          =   255
         Left            =   165
         TabIndex        =   23
         Top             =   1085
         Width           =   1575
      End
      Begin VB.Label Label1 
         Caption         =   "Number of rings to answer:"
         Height          =   255
         Left            =   165
         TabIndex        =   22
         Top             =   1430
         Width           =   1935
      End
   End
   Begin VB.ComboBox FaxTypeCombo 
      Height          =   315
      ItemData        =   "Form3.frx":0010
      Left            =   120
      List            =   "Form3.frx":0012
      Style           =   2  'Dropdown List
      TabIndex        =   0
      Top             =   360
      Width           =   4935
   End
   Begin VB.Frame Frame1 
      Caption         =   "Modem Test"
      Height          =   2205
      Left            =   120
      TabIndex        =   12
      Top             =   800
      Width           =   4935
      Begin VB.CommandButton TestDialtoneButton 
         Caption         =   "Test Dialtone"
         Height          =   375
         Left            =   120
         TabIndex        =   2
         Top             =   1680
         Width           =   1095
      End
      Begin VB.CommandButton TestButton 
         Caption         =   "Test Modem"
         Height          =   375
         Left            =   120
         TabIndex        =   1
         Top             =   1200
         Width           =   1080
      End
      Begin VB.Label LabModel 
         Height          =   375
         Left            =   1320
         TabIndex        =   21
         Top             =   600
         Width           =   3435
      End
      Begin VB.Label LabManufact 
         Height          =   360
         Left            =   1320
         TabIndex        =   20
         Top             =   240
         Width           =   3435
      End
      Begin VB.Label LabClassType 
         Height          =   975
         Left            =   1320
         TabIndex        =   19
         Top             =   960
         Width           =   3435
      End
      Begin VB.Label Label5 
         Caption         =   "Model:"
         Height          =   255
         Left            =   225
         TabIndex        =   18
         Top             =   585
         Width           =   930
      End
      Begin VB.Label Label4 
         Caption         =   "Manufacturer:"
         Height          =   255
         Left            =   225
         TabIndex        =   17
         Top             =   240
         Width           =   1050
      End
      Begin VB.Label Label3 
         Caption         =   "Class type:"
         Height          =   255
         Left            =   225
         TabIndex        =   16
         Top             =   945
         Width           =   930
      End
   End
   Begin VB.CommandButton CommandCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   372
      Left            =   1200
      TabIndex        =   10
      Top             =   6800
      Width           =   1215
   End
   Begin VB.CommandButton CommandOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   372
      Left            =   2760
      TabIndex        =   11
      Top             =   6800
      Width           =   1215
   End
   Begin VB.Label Label7 
      Caption         =   "Fax Modem Settings:"
      Height          =   255
      Left            =   120
      TabIndex        =   25
      Top             =   120
      Width           =   3255
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
    err.Clear
End Sub



Private Sub CommandOK_Click()
    Static errcode As Long
    Dim IniFileName As String
    Dim nFax As Integer
    Dim szFaxName, szFaxName1 As String
    Dim SelectedFax As Integer
    Dim temp As Integer
    Screen.MousePointer = 11
        
    temp = Form1.FAX1.SetSetupString(SetupStrTextBox.Text, FaxTypeCombo.ListIndex + 1)
    temp = Form1.FAX1.SetResetString(ResetStrTextBox.Text, FaxTypeCombo.ListIndex + 1)
    
    If (ChbHeader.Value = 0) Then
        Form1.FAX1.Header = False
    Else
        Form1.FAX1.Header = True
        Form1.FAX1.HeaderHeight = 25
        Form1.FAX1.HeaderFaceName = "Arial"
        Form1.FAX1.HeaderFontSize = 10
    End If
    
    If ChkEnblDebug.Value Then
        Form1.EnableDebug = True
    Else
        Form1.EnableDebug = False
    End If
    IniFileName = "faxcpp1.ini"
    'Get fax name.
    nFax = FaxTypeCombo.ListIndex + 1
    szFaxName = "Fax" + CStr(nFax)
    szFaxName1 = Strings.String(256, Chr(0))
    temp = GetPrivateProfileString("Faxes", szFaxName, "", szFaxName1, 250, IniFileName)
    SelectedFax = nFax
    temp = WriteProfileString("Fax", "Selected", CStr(SelectedFax))
    Form1.FAX1.LocalID = LocalIDEdit.Text
    Form1.FAX1.Rings = Val(NumberOfRingsEdit.Text)
    temp = WriteProfileString("Fax", "Header", CStr(ChbHeader.Value))
    Form1.FAX1.FaxType = szFaxName1
    Form1.FAX1.TestModem (COMList.List(COMList.ListIndex))
    If Len(Form1.FAX1.ClassType) <> 0 Then

        If (Form1.FAX1.FaxType = "GCLASS1(SFC)") And ((InStr(Form1.FAX1.ClassType, "1") = 0) Or (InStr(Form1.FAX1.ClassType, "1.0") = InStr(Form1.FAX1.ClassType, "1"))) Then
            MsgBox "The selected modem does not support Class 1", 0
            Screen.MousePointer = 0
            Exit Sub
        ElseIf (Form1.FAX1.FaxType = "GCLASS1(HFC)") And ((InStr(Form1.FAX1.ClassType, "1") = 0) Or (InStr(Form1.FAX1.ClassType, "1.0") = InStr(Form1.FAX1.ClassType, "1"))) Then
            MsgBox "The selected modem does not support Class 1", 0
            Screen.MousePointer = 0
            Exit Sub
        ElseIf (Form1.FAX1.FaxType = "GCLASS1.0(SFC)") And (InStr(Form1.FAX1.ClassType, "1.0") = 0) Then
            MsgBox "The selected modem does not support Class 1.0", 0
            Screen.MousePointer = 0
            Exit Sub
        ElseIf (Form1.FAX1.FaxType = "GCLASS1.0(HFC)") And (InStr(Form1.FAX1.ClassType, "1.0") = 0) Then
            MsgBox "The selected modem does not support Class 1.0", 0
            Screen.MousePointer = 0
            Exit Sub
        ElseIf ((Form1.FAX1.FaxType = "GCLASS2S/RF/") Or (Form1.FAX1.FaxType = "GCLASS2R")) And ((InStr(Form1.FAX1.ClassType, "2") = 0) Or (InStr(Form1.FAX1.ClassType, "2.0") = InStr(Form1.FAX1.ClassType, "2"))) Then
            MsgBox "The selected modem does not support Class 2", 0
            Screen.MousePointer = 0
            Exit Sub
        ElseIf ((Form1.FAX1.FaxType = "GCLASS2.0") Or (Form1.FAX1.FaxType = "GCLASS2.0 MULTITECH")) And (InStr(Form1.FAX1.ClassType, "2.0") = 0) Then
            MsgBox "The selected modem does not support Class 2.0", 0
            Screen.MousePointer = 0
            Exit Sub
        ElseIf ((Form1.FAX1.FaxType = "GH14.4F(HFC)") Or (Form1.FAX1.FaxType = "GU.S.R14.4F(HFC)")) And ((InStr(Form1.FAX1.ClassType, "1") = 0) Or (InStr(Form1.FAX1.ClassType, "1.0") = InStr(Form1.FAX1.ClassType, "1"))) Then
                MsgBox "The selected modem does not support Class 1", 0
                Screen.MousePointer = 0
            Exit Sub
        End If
        
        Form1.ActualFaxPort = COMList.List(COMList.ListIndex)
        Form1.FAX1.SpeakerVolume = Form1.SpeakerVolume
        Form1.FAX1.SpeakerMode = Form1.SpeakerMode
        Sleep 2, False
        errcode = Form1.FAX1.OpenPort(COMList.List(COMList.ListIndex))
        
        If (errcode <> 0) Then
            i = MsgBox(Form1.Errors(errcode), 0)
        Else
            Form1.FAX1.RecvDTMF COMList.List(COMList.ListIndex), 3, 10
            Form1.ClosePort.Enabled = True
            Form1.send.Enabled = True
            Form1.HideManager.Enabled = True
            Form1.EventList.AddItem (COMList.List(COMList.ListIndex) + " was opened")
            Form1.FAX1.SetSpeakerMode Form1.ActualFaxPort, Form1.SpeakerMode, Form1.SpeakerVolume
            Form1.FAX1.SetPortCapability Form1.ActualFaxPort, PC_ECM, Form1.EnableECM
            Form1.FAX1.SetPortCapability Form1.ActualFaxPort, PC_BINARY, Form1.EnableBFT
            Form1.FAX1.SetPortCapability Form1.ActualFaxPort, PC_MAX_BAUD_SEND, Form1.BaudRate
            errcode = Form1.FAX1.EnableLog(Form1.ActualFaxPort, Form1.EnableDebug)
            Form1.FAX1.HeaderHeight = 25
        End If
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

Private Sub FaxTypeCombo_Click()
        ResetStrTextBox.Text = Form1.FAX1.GetResetString(FaxTypeCombo.ListIndex + 1)
        SetupStrTextBox.Text = Form1.FAX1.GetSetupString(FaxTypeCombo.ListIndex + 1)
End Sub

Private Sub Form_Load()
    Static t1, t2 As String
    Static flag As Boolean
    Static i, j As Integer

    

    If (Form1.FAX1.Header) Then
        ChbHeader.Value = 1
    Else
        ChbHeader.Value = 0
    End If
    
    If Form1.EnableDebug Then
        ChkEnblDebug.Value = 1
    Else
        ChkEnblDebug.Value = 0
    End If
    
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
        
    Dim szFax As String
    Dim szFaxName As String
    Dim szFaxName1 As String
    Dim nFaxes As Integer
    Dim IniFileName As String
    Dim szReset As String
    Dim LocalFax As Integer
    Dim headerInt As Integer
    Dim First As Boolean
    Dim wasThere1, wasThere2 As Boolean
    wasThere1 = False
    wasThere2 = False
    First = True
    LocalFax = 0
    IniFileName = "faxcpp1.ini"
    nFaxes = 1
    While nFaxes <> -1

            LocalFax = LocalFax + 1
            szFax = "Fax" + CStr(LocalFax)
            szFaxName = Strings.String(256, Chr(0))
            If (GetPrivateProfileString("Faxes", szFax, "", szFaxName, 250, IniFileName) = 0) Then
                wasThere1 = False
                If (First = False) Then
                    nFaxes = -1
                    wasThere1 = True
                Else
                    First = False
                    wasThere1 = True
                End If
            Else: wasThere1 = False
            End If
            If (wasThere1 = False) Then
                szFaxName1 = Strings.String(256, Chr(0))
                If (GetPrivateProfileString(szFaxName, "Long Name", "", szFaxName1, 250, IniFileName) = 0) Then
                    wasThere2 = False
                    If (First = False) Then
                        nFaxes = -1
                        wasThere2 = True
                    Else
                        First = False
                        wasThere2 = True
                    End If
                Else: wasThere2 = False
                End If
            End If
            If (wasThere1 = False And wasThere2 = False And nFaxes <> -1) Then
                FaxTypeCombo.AddItem (szFaxName1)
                nFaxes = nFaxes + 1
            End If
        Wend
    FaxTypeCombo.ListIndex = GetProfileInt("Fax", "Selected", 1) - 1
    FaxTypeCombo_Click
    LocalIDEdit.Text = Form1.FAX1.LocalID
    NumberOfRingsEdit.Text = Format(Form1.FAX1.Rings)
    End Sub

Private Sub NumberOfRingsEdit_KeyPress(KeyAscii As Integer)
   
    If (KeyAscii < 48 Or KeyAscii > 57) And Not KeyAscii = 8 Then
        KeyAscii = 0
    End If
End Sub

Private Sub TestButton_Click()
    Static Selected As String
    Static OutString As String
    Static err As Integer
    Dim iPosition As Integer
    Dim iBeginStr As Integer
    Dim S1 As String

    Selected = COMList.List(COMList.ListIndex)
    MousePointer = 11
    err = Form1.FAX1.TestModem(Selected)
    MousePointer = 0
    If (err = 0) Then
        OutString = ""
        iPosition = 1
        iBeginStr = 1
        If Len(Form1.FAX1.ClassType) > 0 Then
            Do While iPosition > 0
                iPosition = InStr(iBeginStr, Form1.FAX1.ClassType, ",")
                If iPosition = 0 Then
                    S1 = Mid(Form1.FAX1.ClassType, iBeginStr, Len(Form1.FAX1.ClassType) - iBeginStr + 1)
                Else
                    S1 = Mid(Form1.FAX1.ClassType, iBeginStr, iPosition - iBeginStr)
                End If
                iBeginStr = iPosition + 1
                If S1 = "0" Then
                    If Len(OutString) = 0 Then
                        OutString = OutString + "Data"
                    Else
                        OutString = OutString + ", Data"
                    End If
                ElseIf S1 = "1" Then
                    If Len(OutString) = 0 Then
                        OutString = OutString + "FAX Class 1"
                    Else
                        OutString = OutString + ", FAX Class 1"
                    End If
                ElseIf S1 = "1.0" Then
                    If Len(OutString) = 0 Then
                        OutString = OutString + "FAX Class 1.0"
                    Else
                        OutString = OutString + ", FAX Class 1.0"
                    End If
                ElseIf S1 = "2.0" Then
                    If Len(OutString) = 0 Then
                        OutString = OutString + "FAX Class 2.0"
                    Else
                        OutString = OutString + ", FAX Class 2.0"
                    End If
                ElseIf S1 = "2" Then
                    If Len(OutString) = 0 Then
                        OutString = OutString + "FAX Class 2"
                    Else
                        OutString = OutString + ", FAX Class 2"
                    End If
                ElseIf S1 = "2.1" Then
                    If Len(OutString) = 0 Then
                        OutString = OutString + "FAX Class 2.1"
                    Else
                        OutString = OutString + ", FAX Class 2.1"
                    End If
                ElseIf S1 = "8" Then
                    If Len(OutString) = 0 Then
                        OutString = OutString + "Class 8"
                    Else
                        OutString = OutString + ", Class 8"
                    End If
                ElseIf S1 = "80" Then
                    If Len(OutString) = 0 Then
                        OutString = OutString + "Class 80"
                    Else
                        OutString = OutString + ", Class 80"
                    End If
                ElseIf Len(S1) > 0 Then
                    If Len(OutString) = 0 Then
                        OutString = OutString + "Class " + S1
                    Else
                        OutString = OutString + ", Class " + S1
                    End If
                End If
'
            Loop
        End If
        
        LabClassType.Caption = OutString
        LabManufact.Caption = Form1.FAX1.Manufacturer
        LabModel.Caption = Form1.FAX1.Model
    Else
        LabClassType.Caption = "No modem on " + Selected
        LabManufact.Caption = ""
        LabModel.Caption = ""
    End If
End Sub


Private Sub TestDialtoneButton_Click()
        Dim szPortName As String
        Dim iError As Integer
        Dim i As Integer

        szPortName = COMList.List(COMList.ListIndex)
        MousePointer = vbHourglass
        iError = Form1.FAX1.DetectDialTone(szPortName)
        MousePointer = vbDefault
        If (1 = iError) Then
            i = MsgBox("Dialtone Detected. ", vbOKOnly, "Test Dialtone")
        ElseIf (0 = iError) Then
            i = MsgBox("No Dialtone!", vbOKOnly, "Test Dialtone")
        ElseIf (-1 = iError) Then
            i = MsgBox("No Modem on COM Port!", vbOKOnly, "Test Dialtone")
        End If

End Sub
