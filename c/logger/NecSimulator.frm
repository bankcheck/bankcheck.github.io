VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
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
   Begin VB.CommandButton send2 
      Caption         =   "send to 2"
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   11.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   5160
      TabIndex        =   4
      Top             =   120
      Width           =   1575
   End
   Begin VB.CommandButton send1 
      Caption         =   "send to 1"
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   11.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   3480
      TabIndex        =   3
      Top             =   120
      Width           =   1575
   End
   Begin VB.TextBox txtSend 
      BeginProperty Font 
         Name            =   "Terminal"
         Size            =   9
         Charset         =   255
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   2
      Top             =   600
      Width           =   7335
   End
   Begin VB.CommandButton cmdHex 
      Caption         =   "add hex"
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   11.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   1335
   End
   Begin MSCommLib.MSComm MSComm2 
      Left            =   5520
      Top             =   6600
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   -1  'True
      ParityReplace   =   0
      RThreshold      =   1
      RTSEnable       =   -1  'True
      SThreshold      =   1
   End
   Begin MSCommLib.MSComm MSComm1 
      Left            =   6240
      Top             =   6600
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   -1  'True
      ParityReplace   =   0
      RThreshold      =   1
      RTSEnable       =   -1  'True
      SThreshold      =   1
   End
   Begin VB.ListBox List1 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   5820
      ItemData        =   "NecSimulator.frx":0CFF
      Left            =   120
      List            =   "NecSimulator.frx":0D01
      TabIndex        =   0
      Top             =   1080
      Width           =   7335
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Declare Function GetPrivateProfileStringByKeyName Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName$, ByVal lpszKey$, ByVal lpszDefault$, ByVal lpszReturnBuffer$, ByVal cchReturnBuffer&, ByVal lpszFile$) As Long
Private Declare Function WritePrivateProfileStringByKeyName Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As String, ByVal lpString As String, ByVal lplFileName As String) As Long
Private Declare Function GetPrivateProfileStringKeys Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName$, ByVal lpszKey&, ByVal lpszDefault$, ByVal lpszReturnBuffer$, ByVal cchReturnBuffer&, ByVal lpszFile$) As Long
Private Declare Function GetPrivateProfileStringSections Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName&, ByVal lpszKey&, ByVal lpszDefault$, ByVal lpszReturnBuffer$, ByVal cchReturnBuffer&, ByVal lpszFile$) As Long

Private Const SA = 49
Private Const UA = 33
Private Const EI = 76  'L
Private msSTX As String * 1
Private msETX As String * 1
Private msACK As String * 1
Private msNAK As String * 1
Private msEnq As String * 1
Private msDLE As String * 1
Private mbBCCEnable As Boolean
Private aRetChr() As String

Private buffer1 As String
Private buffer2 As String
Private AutoAck As String
Private AckChar As String


Private Sub cmdHex_Click()
    Form2.Show
End Sub

Private Sub Form_Load()
    Dim sComPort As String
    Dim sSetting As String
    Dim sMode As String
    Dim i As Integer
    Dim timeInv As Integer

    msSTX = Chr$(2)
    msETX = Chr$(3)
    msACK = Chr$(6)
    msNAK = Chr$(21)
    msEnq = Chr$(5)
    msDLE = Chr$(16)
    
    mbBCCEnable = True

    sComPort = RetrieveFileValue("config", "ComPort1", "1", App.Path & "\logger.ini")
    sSetting = RetrieveFileValue("config", "Setting", "1200,e,7,1", App.Path & "\logger.ini")
    sMode = RetrieveFileValue("config", "mode", "0", App.Path & "\logger.ini")
    aRetChr = Split(RetrieveFileValue("config", "RetChr", "", App.Path & "\logger.ini"), ",")
    AutoAck = RetrieveFileValue("config", "AutoAck", "1", App.Path & "\logger.ini")
    AckChar = Chr(RetrieveFileValue("config", "AckChar", "6", App.Path & "\logger.ini"))
    
    
    With Me.MSComm1
        .CommPort = val(sComPort)
        .Settings = sSetting
        .InputLen = 0
        .PortOpen = True
        .Handshaking = sMode
    End With
    ShowData List1, "ComPort1:" & sComPort & "," & sSetting & " Opened." & " Mode:" & sMode, Me
    
    sComPort = RetrieveFileValue("config", "ComPort2", "2", App.Path & "\logger.ini")
    With Me.MSComm2
        .CommPort = val(sComPort)
        .Settings = sSetting
        .InputLen = 0
        .PortOpen = True
        .Handshaking = sMode
    End With
    ShowData List1, "ComPort2:" & sComPort & "," & sSetting & " Opened." & " Mode:" & sMode, Me
End Sub


Public Function RetrieveFileValue(sSection As String, sField As String, sDefault As String, sFileLoc As String) As String
  Dim lRet As Long, sValue As String
  
  sValue = Space(150)
  
  
  lRet = GetPrivateProfileStringByKeyName(sSection, sField, "", sValue, 149, sFileLoc)
  If lRet > 0 Then
    sValue = Trim(sValue)
    sValue = Left(sValue, Len(sValue) - 1)
  Else
    sValue = sDefault
    lRet = WritePrivateProfileStringByKeyName(sSection, sField, sDefault, sFileLoc)
  End If
  RetrieveFileValue = sValue
End Function


Sub ShowData(Term As Control, sDta As String, FRM As Form)
  On Error Resume Next
  Dim nCtrlChr As Integer
  Dim sOutChar As String, sOutString As String

  'execute this routine only debug mode is on!
  'If FRM.mnuOptDebugMode.Checked = False Then Exit Sub
  'only keeps the last 300 items
  If Term.ListCount >= 300 Then Term.RemoveItem 0
  
  ' Filter/handle BACKSPACE characters.
  i = 1
  Do
    i = InStr(i, sDta, vbBack)
    If i Then
      If i = 1 Then
        sDta = Mid$(sDta, i + 1)
      Else
        sDta = Left$(sDta, i - 2) & Mid$(sDta, i + 1)
      End If
    End If
  Loop While i

    ' Eliminate line feeds.
  i = 1
  Do
    i = InStr(i, sDta, vbLf)
    If i Then
      sDta = Left$(sDta, i - 1) & Mid$(sDta, i + 1)
    End If
    Loop While i

    ' Take care of control characters
    sOutString = ""
    For i = 1 To Len(sDta)
       nCtrlChr = Asc(Mid$(sDta, i, 1))
       'If (nCtrlChr < 32 Or nCtrlChr > 126) And nCtrlChr <> 10 And nCtrlChr <> 13 Then
       If (nCtrlChr < 32 Or nCtrlChr > 126) Then
          sOutChar = "[" & CStr(nCtrlChr) & "]"
       Else
          sOutChar = Mid$(sDta, i, 1)
       End If
       sOutString = sOutString & sOutChar
    Next i
    ' Add the filtered data to the ListBox property.
    Term.AddItem RTrim$(Now() & " " & sOutString)
    WriteLog "textlog.txt", sOutString
    'If Timer - lTimer > 3 Or Timer < lTimer Then 'last scroll event was 2 seconds ago, OK to highlight
    '  Term.ListIndex = Term.ListCount - 1
    'End If
    
End Sub


Private Sub Form_Unload(Cancel As Integer)
    Me.MSComm1.PortOpen = False
    Me.MSComm2.PortOpen = False
End Sub

Private Sub List1_DblClick()
    'Me.List1.Clear
End Sub

Private Sub MSComm1_OnComm()
  Dim sEVMsg As String, sERMsg As String
  Dim sDisplayStr As String
  Dim sRecChar As String * 1
  Dim i, j As Integer
  Static bDLE As Boolean 'see DLE character, need to get the next character ('<')
  Dim sIn As String
  
  Select Case MSComm1.CommEvent
    ' Event messages.
    Case comEvReceive
        sIn = MSComm1.Input
              
        If UBound(aRetChr) < 0 Then
            MSComm2.Output = sIn
            WriteLog "hexlog.txt", "1>" & sIn
            ShowData List1, "1>" & sIn, Me
        Else
            j = Len(sIn)
            For i = 1 To j
                sRecChar = Mid$(sIn, i, 1)
                buffer1 = buffer1 & sRecChar
                If checkChr(sRecChar) Then
                    MSComm2.Output = buffer1
                    WriteLog "hexlog.txt", "1>" & buffer1
                    ShowData List1, "1>" & buffer1, Me
                    If AutoAck = "1" Then
                        MSComm1.Output = AckChar
                        WriteLog "hexlog.txt", "T>ACK"
                        ShowData List1, "T>ACK", Me
                    End If
                    buffer1 = ""
                End If
            Next i
        End If

    Case comEvSend

    Case comEvCTS
      sEVMsg = "Change in CTS Detected"
    Case comEvDSR
      sEVMsg = "Change in DSR Detected"
    Case comEvCD
      sEVMsg = "Change in CD Detected"
    Case comEvRing
      sEVMsg = "The Phone is Ringing"
    Case comEvEOF
      sEVMsg = "End of File Detected"

    ' Error messages.
    Case comEventBreak
      sEVMsg = "Break Received"
    Case comEventCTSTO
      sERMsg = "CTS Timeout"
    Case comEventDSRTO
      sERMsg = "DSR Timeout"
    Case comEventFrame
      sEVMsg = "Framing Error"
    Case comEventOverrun
      sERMsg = "Overrun Error"
    Case comEventCDTO
      sERMsg = "Carrier Detect Timeout"
    Case comEventRxOver
      sERMsg = "Receive Buffer Overflow"
    Case comEventRxParity
      sEVMsg = "Parity Error"
    Case comEventTxFull
      sERMsg = "Transmit Buffer Full"
    Case Else
      sERMsg = "Unknown error or event"
  End Select

End Sub

Private Sub MSComm2_OnComm()
  Dim sEVMsg As String, sERMsg As String
  Dim sDisplayStr As String
  Dim sRecChar As String * 1
  Dim i, j As Integer
  Static bDLE As Boolean 'see DLE character, need to get the next character ('<')
  Dim sIn As String
  
  Select Case MSComm2.CommEvent
    ' Event messages.
    Case comEvReceive
        sIn = MSComm2.Input
      
        If UBound(aRetChr) < 0 Then
            MSComm1.Output = sIn
            WriteLog "hexlog.txt", "2>" & sIn
            ShowData List1, "2>" & sIn, Me
        Else
            j = Len(sIn)
            For i = 1 To j
                sRecChar = Mid$(sIn, i, 1)
                buffer2 = buffer2 & sRecChar
                If checkChr(sRecChar) Then
                    MSComm1.Output = buffer2
                    WriteLog "hexlog.txt", "2>" & buffer2
                    ShowData List1, "2>" & buffer2, Me
                    If AutoAck = "1" Then
                        MSComm2.Output = AckChar
                        WriteLog "hexlog.txt", "T>ACK"
                        ShowData List1, "T>ACK", Me
                    End If
                    buffer2 = ""
                End If
            Next i
        End If

    Case comEvSend

    Case comEvCTS
      sEVMsg = "Change in CTS Detected"
    Case comEvDSR
      sEVMsg = "Change in DSR Detected"
    Case comEvCD
      sEVMsg = "Change in CD Detected"
    Case comEvRing
      sEVMsg = "The Phone is Ringing"
    Case comEvEOF
      sEVMsg = "End of File Detected"

    ' Error messages.
    Case comEventBreak
      sEVMsg = "Break Received"
    Case comEventCTSTO
      sERMsg = "CTS Timeout"
    Case comEventDSRTO
      sERMsg = "DSR Timeout"
    Case comEventFrame
      sEVMsg = "Framing Error"
    Case comEventOverrun
      sERMsg = "Overrun Error"
    Case comEventCDTO
      sERMsg = "Carrier Detect Timeout"
    Case comEventRxOver
      sERMsg = "Receive Buffer Overflow"
    Case comEventRxParity
      sEVMsg = "Parity Error"
    Case comEventTxFull
      sERMsg = "Transmit Buffer Full"
    Case Else
      sERMsg = "Unknown error or event"
  End Select

End Sub

Private Sub WriteLog(fname As String, message As String)
    Open fname For Append As #1
    Print #1, Now() & " " & message
    Close #1
End Sub

Private Function checkChr(char As String) As Boolean
    Dim i As Integer
    Dim val As Boolean
    
    'If UBound(aRetChr) < 0 Then
    '    val = True
    'Else
        val = False
    'End If
    For i = 0 To UBound(aRetChr)
        If Asc(Left(char, 1)) = aRetChr(i) Then
            val = True
        End If
    Next i
    checkChr = val
End Function

Private Sub send1_Click()
    MSComm1.Output = Trim(Me.txtSend.Text)
    WriteLog "hexlog.txt", "T1>" & Me.txtSend.Text
    ShowData List1, "T1>" & Me.txtSend.Text, Me
    txtSend.Text = ""
End Sub

Private Sub send2_Click()
    MSComm2.Output = Trim(Me.txtSend.Text)
    WriteLog "hexlog.txt", "T2>" & Me.txtSend.Text
    ShowData List1, "T2>" & Me.txtSend.Text, Me
    txtSend.Text = ""
End Sub

