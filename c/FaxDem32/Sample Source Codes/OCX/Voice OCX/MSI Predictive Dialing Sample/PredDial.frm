VERSION 5.00
Object = "{426F4282-5F31-11D1-A131-0040F614A5A0}#1.0#0"; "VoiceOCX.ocx"
Begin VB.Form PredictiveDial 
   Caption         =   "Voice C++ Predictive Dialing sample for Dialogic MSI boards"
   ClientHeight    =   5910
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   9615
   Icon            =   "PredDial.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5910
   ScaleWidth      =   9615
   StartUpPosition =   3  'Windows Default
   Begin VOICEOCXLib.VoiceOCX VoiceOCX1 
      Height          =   255
      Left            =   7335
      TabIndex        =   16
      Top             =   5475
      Width           =   255
      _Version        =   65536
      _ExtentX        =   450
      _ExtentY        =   450
      _StockProps     =   0
   End
   Begin VB.CommandButton btnExit 
      Cancel          =   -1  'True
      Caption         =   "E&xit"
      Height          =   372
      Left            =   5265
      TabIndex        =   15
      Top             =   5415
      Width           =   1452
   End
   Begin VB.CommandButton btnStart 
      Caption         =   "&Start"
      Height          =   372
      Left            =   2145
      TabIndex        =   14
      Top             =   5415
      Width           =   1452
   End
   Begin VB.Frame Frame3 
      Caption         =   "Messages"
      Height          =   3375
      Left            =   120
      TabIndex        =   12
      Top             =   1920
      Width           =   9375
      Begin VB.ListBox lstEvents 
         Height          =   2790
         Left            =   120
         TabIndex        =   13
         Top             =   240
         Width           =   9135
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "Phone numbers to call"
      Height          =   1692
      Left            =   7440
      TabIndex        =   9
      Top             =   120
      Width           =   2055
      Begin VB.TextBox EditPhoneNr 
         BeginProperty DataFormat 
            Type            =   0
            Format          =   "0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1033
            SubFormatType   =   0
         EndProperty
         Height          =   288
         Left            =   120
         TabIndex        =   11
         Top             =   240
         Width           =   1815
      End
      Begin VB.ListBox lstPhoneNumbers 
         Height          =   840
         ItemData        =   "PredDial.frx":0442
         Left            =   120
         List            =   "PredDial.frx":0444
         TabIndex        =   10
         Top             =   600
         Width           =   1815
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "SCBus Resources"
      Height          =   1692
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   7215
      Begin VB.ComboBox ComboMSIStation4 
         Height          =   315
         Left            =   1080
         Style           =   2  'Dropdown List
         TabIndex        =   32
         Top             =   1320
         Width           =   1095
      End
      Begin VB.ComboBox ComboMSIStation3 
         Height          =   315
         Left            =   1080
         Style           =   2  'Dropdown List
         TabIndex        =   31
         Top             =   960
         Width           =   1095
      End
      Begin VB.ComboBox ComboMSIStation2 
         Height          =   315
         Left            =   1080
         Style           =   2  'Dropdown List
         TabIndex        =   30
         Top             =   600
         Width           =   1095
      End
      Begin VB.ComboBox ComboMSIStation1 
         Height          =   315
         Left            =   1080
         Style           =   2  'Dropdown List
         TabIndex        =   29
         Top             =   240
         Width           =   1095
      End
      Begin VB.ComboBox ComboVoice4 
         Height          =   315
         Left            =   6000
         Style           =   2  'Dropdown List
         TabIndex        =   28
         Top             =   1320
         Width           =   1095
      End
      Begin VB.ComboBox ComboVoice3 
         Height          =   315
         Left            =   6000
         Style           =   2  'Dropdown List
         TabIndex        =   27
         Top             =   960
         Width           =   1095
      End
      Begin VB.ComboBox ComboVoice2 
         Height          =   315
         Left            =   6000
         Style           =   2  'Dropdown List
         TabIndex        =   26
         Top             =   600
         Width           =   1095
      End
      Begin VB.ComboBox ComboVoice1 
         Height          =   315
         Left            =   6000
         Style           =   2  'Dropdown List
         TabIndex        =   25
         Top             =   240
         Width           =   1095
      End
      Begin VB.ComboBox ComboLine4 
         Height          =   315
         Left            =   3480
         Style           =   2  'Dropdown List
         TabIndex        =   24
         Top             =   1320
         Width           =   1095
      End
      Begin VB.ComboBox ComboLine3 
         Height          =   315
         Left            =   3480
         Style           =   2  'Dropdown List
         TabIndex        =   23
         Top             =   960
         Width           =   1095
      End
      Begin VB.ComboBox ComboLine2 
         Height          =   315
         Left            =   3480
         Style           =   2  'Dropdown List
         TabIndex        =   22
         Top             =   600
         Width           =   1095
      End
      Begin VB.ComboBox ComboLine1 
         Height          =   315
         Left            =   3480
         Style           =   2  'Dropdown List
         TabIndex        =   21
         Top             =   240
         Width           =   1095
      End
      Begin VB.Label LabelVoice3 
         Caption         =   "Voice Resource 3:"
         Height          =   375
         Left            =   4680
         TabIndex        =   20
         Top             =   960
         Width           =   1335
      End
      Begin VB.Label LabelVoice4 
         Caption         =   "Voice Resource 4:"
         Height          =   255
         Left            =   4680
         TabIndex        =   19
         Top             =   1320
         Width           =   1335
      End
      Begin VB.Label LabelVoice2 
         Caption         =   "Voice Resource 2:"
         Height          =   255
         Left            =   4680
         TabIndex        =   18
         Top             =   600
         Width           =   1335
      End
      Begin VB.Label LabelVoice1 
         Caption         =   "Voice Resource 1:"
         Height          =   255
         Left            =   4680
         TabIndex        =   17
         Top             =   240
         Width           =   1335
      End
      Begin VB.Label LabelLine4 
         Caption         =   "Line Interface 4:"
         Height          =   255
         Left            =   2280
         TabIndex        =   8
         Top             =   1320
         Width           =   1215
      End
      Begin VB.Label LabelLine3 
         Caption         =   "Line Interface 3:"
         Height          =   255
         Left            =   2280
         TabIndex        =   7
         Top             =   960
         Width           =   1215
      End
      Begin VB.Label LabelLine2 
         Caption         =   "Line Interface 2:"
         Height          =   255
         Left            =   2280
         TabIndex        =   6
         Top             =   600
         Width           =   1215
      End
      Begin VB.Label LabelLine1 
         Caption         =   "Line Interface 1:"
         Height          =   255
         Left            =   2280
         TabIndex        =   5
         Top             =   240
         Width           =   1215
      End
      Begin VB.Label LabelMSIStation4 
         Caption         =   "MSI Station4:"
         Height          =   252
         Left            =   120
         TabIndex        =   4
         Top             =   1320
         Width           =   972
      End
      Begin VB.Label LabelMSIStation3 
         Caption         =   "MSI Station3:"
         Height          =   252
         Left            =   120
         TabIndex        =   3
         Top             =   960
         Width           =   972
      End
      Begin VB.Label LabelMSIStation2 
         Caption         =   "MSI Station2:"
         Height          =   252
         Left            =   120
         TabIndex        =   2
         Top             =   600
         Width           =   972
      End
      Begin VB.Label LabelMSIStation1 
         Caption         =   "MSI Station1:"
         Height          =   252
         Index           =   0
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Width           =   972
      End
   End
End
Attribute VB_Name = "PredictiveDial"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim MSIHandles(4) As Long
Dim LineHandles(4) As Long
Dim VoiceHandles(4) As Long
Dim MSIModemIDs(4) As Long
Dim LineModemIDs(4) As Long

Dim MSIStationConnectedTo(4) As Integer
Dim MSIState(4) As Integer
Dim LineConnectedTo(4) As Integer
Dim LineState(4) As Integer

Dim Started As Boolean
Dim Exiting As Boolean

Const stateOnHook = 1
Const stateOffHook = 2
Const stateDialing = 3
Const stateHangingUP = 4
Const stateConnected = 5

Public KeepDialing As Boolean

Private Sub AddToLog(text As String)
    lstEvents.AddItem text
    itemcount = lstEvents.ListCount
    lstEvents.TopIndex = itemcount - 1
End Sub


Private Sub DialANumber(ModemID As Long)
    Dim index As Integer
   
    If Started = True Then
        index = FindLineModemObject(ModemID)
    
        If index <> -1 Then
            If GetNotConnectedMSIStation() <> -1 Then
                If Len(lstPhoneNumbers.List(0)) > 0 Then
                    LineState(index) = stateDialing
                    VoiceOCX1.Dial ModemID, lstPhoneNumbers.List(0), 0
                    AddToLog ("Dialing on Line " + Str(index + 1))
                    AddToLog ("Dialing on Line " + lstPhoneNumbers.List(0))
                    lstPhoneNumbers.RemoveItem (0)
                Else
                    LineState(index) = stateOnHook
                    AddToLog ("No phone numbers in the list. Enter two or more phone numbers.")
                    KeepDialing = False
                End If
            Else
                LineState(index) = stateOnHook
                KeepDialing = False
            End If
        End If
    End If
End Sub
Function FindLineModemObject(ModemID As Long) As Long
If ModemID = LineModemIDs(0) Then
    FindLineModemObject = 0
    Exit Function
End If
If ModemID = LineModemIDs(1) Then
    FindLineModemObject = 1
    Exit Function
End If
If ModemID = LineModemIDs(2) Then
    FindLineModemObject = 2
    Exit Function
End If
If ModemID = LineModemIDs(3) Then
    FindLineModemObject = 3
    Exit Function
End If
FindLineModemObject = -1
End Function

Function FindMSIModemObject(ModemID As Long) As Long
    If ModemID = MSIModemIDs(0) Then
        FindMSIModemObject = 0
        Exit Function
    End If
    If ModemID = MSIModemIDs(1) Then
        FindMSIModemObject = 1
        Exit Function
    End If
    If ModemID = MSIModemIDs(2) Then
        FindMSIModemObject = 2
        Exit Function
    End If
    If ModemID = MSIModemIDs(3) Then
        FindMSIModemObject = 3
        Exit Function
    End If
    FindMSIModemObject = -1
End Function

Function GetEditMSIStationText(ByVal index As Byte) As String
    If index = 0 Then
        GetEditMSIStationText = ComboMSIStation1.text
        Exit Function
    End If
    If index = 1 Then
        GetEditMSIStationText = ComboMSIStation2.text
        Exit Function
    End If
    If index = 2 Then
        GetEditMSIStationText = ComboMSIStation3.text
        Exit Function
    End If
    If index = 3 Then
        GetEditMSIStationText = ComboMSIStation4.text
        Exit Function
    End If
End Function

Function GetEditLineText(ByVal index As Byte) As String
    If index = 0 Then
        GetEditLineText = ComboLine1.text
        Exit Function
    End If
    If index = 1 Then
        GetEditLineText = ComboLine2.text
        Exit Function
    End If
    If index = 2 Then
        GetEditLineText = ComboLine3.text
        Exit Function
    End If
    If index = 3 Then
        GetEditLineText = ComboLine4.text
        Exit Function
    End If
End Function
Function GetEditVoiceText(ByVal index As Byte) As String
    If index = 0 Then
        GetEditVoiceText = ComboVoice1.text
        Exit Function
    End If
    If index = 1 Then
        GetEditVoiceText = ComboVoice2.text
        Exit Function
    End If
    If index = 2 Then
        GetEditVoiceText = ComboVoice3.text
        Exit Function
    End If
    If index = 3 Then
        GetEditVoiceText = ComboVoice4.text
        Exit Function
    End If
End Function

Function GetNotConnectedMSIStation() As Integer
    Dim i As Integer
    For i = 0 To 3
        If MSIState(i) = stateOffHook Then
            GetNotConnectedMSIStation = i
            Exit Function
        End If
    Next
    AddToLog "There is no MSI station off hook. MSI station should be off hook in order to connect a call to it"
    AddToLog "Pickup a handset to begin a call."
    GetNotConnectedMSIStation = -1
End Function

Function GetIdleLine() As Integer
    Dim i As Integer
    For i = 0 To 3
        If LineState(i) = stateOnHook Then
            GetIdleLine = i
            Exit Function
        End If
    Next
    GetIdleLine = -1
End Function

Private Sub btnExit_Click()
    AbortAllOperations
    If AreThereAnyActivePorts <> True Then
        CloseAllResources
    End If
End Sub

Sub CloseAllResources()
    Dim i As Integer
    For i = 0 To 3
        VoiceOCX1.SCBUSStopListeningTo VoiceHandles(i), LineHandles(i), 0
        VoiceOCX1.SCBUSDetachResourceFromMODEMOBJ LineModemIDs(i), VoiceHandles(i)
        VoiceOCX1.SCBUSDetachResourceFromMODEMOBJ LineModemIDs(i), LineHandles(i)
        VoiceOCX1.SCBUSCloseResource LineHandles(i)
        VoiceOCX1.SCBUSCloseResource VoiceHandles(i)
        VoiceOCX1.DestroyModemObject LineModemIDs(i)
        
        VoiceOCX1.SCBUSCloseResource MSIHandles(i)
        VoiceOCX1.SCBUSDetachResourceFromMODEMOBJ MSIModemIDs(i), MSIHandles(i)
        VoiceOCX1.DestroyModemObject LineModemIDs(i)
    Next
    Unload Me
End Sub


Sub AbortAllOperations()
    Dim i As Integer
    For i = 0 To 3
        If LineState(i) <> stateOnHook Then
            If LineState(i) = stateConnected Then
                If LineConnectedTo(i) <> -1 Then
                    MSIState(LineConnectedTo(i)) = stateOffHook
                    VoiceOCX1.SCBUSStopListeningTo MSIHandles(MSIindex), LineHandles(index), 0
                    VoiceOCX1.SCBUSStopListeningTo VoiceHandles(index), LineHandles(index), 1
                    VoiceOCX1.SCBUSListenTo VoiceHandles(index), LineHandles(index), 0
                    MSIStationConnectedTo(LineConnectedTo(index)) = -1
                    LineConnectedTo(index) = -1
                End If
                LineState(index) = stateHangingUP
                VoiceOCX1.HangUp ModemID
            Else
                VoiceOCX1.TerminateProcess LineModemIDs(i)
            End If
        End If
    Next
    Exiting = True
End Sub

Function AreThereAnyActivePorts() As Boolean
    Dim i As Integer
    For i = 0 To 3
        If LineState(i) <> stateOnHook Then
            AreThereAnyActivePorts = True
            Exit Function
        End If
    Next
    AreThereAnyActivePorts = False
End Function

Private Sub EditPhoneNr_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = 13 Then
        If EditPhoneNr.text <> "" Then
            lstPhoneNumbers.AddItem EditPhoneNr.text
            EditPhoneNr.text = ""
            If GetIdleLine() <> -1 Then
                DialANumber (LineModemIDs(GetIdleLine()))
            End If
        End If
    End If
End Sub

Private Sub EditVoice1_Change()

End Sub
Private Sub Form_Load1()
    Static t1, t2 As String
    Static flag As Boolean
    Static i, j As Integer

    t1 = Form1.FAX1.AvailableDialogicChannels
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
        ChannelList.AddItem (t2)
    Wend
    
    ChannelList.ListIndex = 0
    
    If (Form1.FAX1.Header) Then
        HeaderCheckBox.Value = 1
    Else
        HeaderCheckBox.Value = 0
    End If
    
End Sub
Private Function SetCombo() As Integer 'ByGR
    Static t1, t2 As String
    Static flag As Boolean
    Static i, j, k As Integer

    For k = 0 To 3
        If k <> 2 Then
            t1 = VoiceOCX1.SCBUSEnumerateResources(k)
            If (Len(t1) = 0) Then
                MsgBox ("No MSI Sation has been detected. In order to run this sample, you need to have at least one MSI Dialogic resource.")
                SetCombo = -1
                Exit Function
            End If
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
                If k = 0 Then
                    ComboLine1.AddItem (t2)
                    ComboLine2.AddItem (t2)
                    ComboLine3.AddItem (t2)
                    ComboLine4.AddItem (t2)
                End If
                If k = 1 Then
                    ComboVoice1.AddItem (t2)
                    ComboVoice2.AddItem (t2)
                    ComboVoice3.AddItem (t2)
                    ComboVoice4.AddItem (t2)
                End If
                If k = 3 Then
                    ComboMSIStation1.AddItem (t2)
                    ComboMSIStation2.AddItem (t2)
                    ComboMSIStation3.AddItem (t2)
                    ComboMSIStation4.AddItem (t2)
                End If
            
            Wend
            If k = 0 Then
                ComboLine1.ListIndex = 0
                ComboLine2.ListIndex = 1
                ComboLine3.ListIndex = 2
                ComboLine4.ListIndex = 3
            End If
            If k = 1 Then
                ComboVoice1.ListIndex = 0
                ComboVoice2.ListIndex = 1
                ComboVoice3.ListIndex = 2
                ComboVoice4.ListIndex = 3
            End If
            If k = 3 Then
                ComboMSIStation1.ListIndex = 0
                ComboMSIStation2.ListIndex = 1
                ComboMSIStation3.ListIndex = 2
                ComboMSIStation4.ListIndex = 3
            End If
       End If
    Next
    SetCombo = 0
End Function


Private Sub Form_Load()
    Dim i As Integer
    
    AddToLog "Predictive Dialing MSI Sample"
    AddToLog "This sample will show how an agent can dial several preset numbers from a list by picking up the handset."
    AddToLog "If the dialed number is busy, the next number from the list will be automatically dialed."
    AddToLog "Note:"
    AddToLog "The sample is using up to four MSI stations. In the resource names, such as msiB1C1, dxxxB1C1,"
    AddToLog "the B1C1 defines Board1 Channel1."
    AddToLog "To use the sample with a different Board or Channel number, modify the names of the resources in the edit boxes."
    AddToLog "If you do not want to use all the listed resources, clear the resource's edit box."
    AddToLog " "
    AddToLog "To use the sample: "
    AddToLog "1. Enter the phone numbers you want to dial and press ENTER to add the numbers to the list"
    AddToLog "2. Add two or more numbers to the list"
    AddToLog "3. Press the Start button to initialize the board."
    AddToLog "4. Pickup a handset to begin a call."
    i = SetCombo
    If (i = -1) Then Unload Me
    
    For i = 0 To 3
        LineState(i) = stateOnHook
        MSIState(i) = stateOnHook
    Next
End Sub

Private Sub btnStart_Click()
    Dim i As Integer
    Dim err As Integer
    
    Exiting = False
    
    VoiceOCX1.SCBUSSetResourceRoutingMode 1
    For i = 0 To 3
        LineState(i) = stateOnHook
        MSIState(i) = stateOnHook
        If Len(GetEditMSIStationText(i)) > 0 Then
            If VoiceOCX1.SCBUSGetResourceStatus(GetEditMSIStationText(i), 3) = 1 Then
                MSIHandles(i) = VoiceOCX1.SCBUSOpenResource(GetEditMSIStationText(i), 3, 3, "")
                If MSIHandles(i) <> 0 Then
                    AddToLog "Resource " + GetEditMSIStationText(i) + " is open"
                    MSIModemIDs(i) = VoiceOCX1.CreateModemObject(2)
                    If MSIModemIDs(i) <> 0 Then
                        VoiceOCX1.SCBUSAttachResourceToMODEMOBJ MSIModemIDs(i), MSIHandles(i)
                        
                        MSIStationConnectedTo(i) = -1
                    End If
                End If
            Else
                AddToLog "Resource " + GetEditMSIStationText(i) + " is not available"
            End If
        End If
        If Len(GetEditLineText(i)) > 0 Then
            If VoiceOCX1.SCBUSGetResourceStatus(GetEditLineText(i), 0) = 1 Then
                LineHandles(i) = VoiceOCX1.SCBUSOpenResource(GetEditLineText(i), 0, 3, "")
                If LineHandles(i) <> 0 Then
                    AddToLog "Resource " + GetEditLineText(i) + " is open"
                    LineModemIDs(i) = VoiceOCX1.CreateModemObject(2)
                    If LineModemIDs(i) <> 0 Then
                        VoiceOCX1.SCBUSAttachResourceToMODEMOBJ LineModemIDs(i), LineHandles(i)
                        LineConnectedTo(i) = -1
                    End If
                End If
            Else
                AddToLog "Resource " + GetEditLineText(i) + " is not available"
            End If
        End If
        If Len(GetEditVoiceText(i)) > 0 Then
            If VoiceOCX1.SCBUSGetResourceStatus(GetEditVoiceText(i), 1) = 1 Then
                VoiceHandles(i) = VoiceOCX1.SCBUSOpenResource(GetEditVoiceText(i), 1, 3, "")
                If VoiceHandles(i) <> 0 Then
                    If LineModemIDs(i) <> 0 Then
                        VoiceOCX1.SCBUSListenTo VoiceHandles(i), LineHandles(i), 0
                        VoiceOCX1.SCBUSAttachResourceToMODEMOBJ LineModemIDs(i), VoiceHandles(i)
                    End If
                End If
            End If
        Else
            AddToLog "Resource " + GetEditVoiceText(i) + " is not available"
        End If
    Next
Started = True
KeepDialing = True
DialANumber LineModemIDs(0)

If KeepDialing Then
    DialANumber LineModemIDs(1)
End If
If KeepDialing Then
    DialANumber LineModemIDs(2)
End If

If KeepDialing Then
    DialANumber LineModemIDs(3)
End If


End Sub

Private Sub Label1_Click()

End Sub

Private Sub TextMSIStation1_Change()

End Sub

Private Sub VoiceOCX1_AnswerTone(ByVal ModemID As Long)
    Dim index As Integer
    index = FindLineModemObject(ModemID)
    If index <> -1 Then
        AddToLog "Answer tone on line " + Str(index + 1)
        If LineState(index) = stateDialing Then
            LineState(index) = stateHangingUP
            VoiceOCX1.HangUp ModemID
        End If
    End If
End Sub

Private Sub VoiceOCX1_Busy(ByVal ModemID As Long)
    Dim index As Integer
    index = FindLineModemObject(ModemID)
    If index <> -1 Then
        AddToLog "Busy tone on line " + Str(index + 1)
        If LineState(index) = stateDialing Then
            LineState(index) = stateHangingUP
            VoiceOCX1.HangUp ModemID
        End If
    End If
End Sub

Private Sub VoiceOCX1_CallingTone(ByVal ModemID As Long)
    Dim index As Integer
    index = FindLineModemObject(ModemID)
    If index <> -1 Then
        AddToLog "Calling tone on line " + Str(index + 1)
        If LineState(index) = stateDialing Then
            LineState(index) = stateHangingUP
            VoiceOCX1.HangUp ModemID
        End If
    End If
End Sub

Private Sub VoiceOCX1_HangUp(ByVal ModemID As Long)
    Dim index As Integer
    index = FindLineModemObject(ModemID)
    If index <> -1 Then
        If LineState(index) = stateHangingUP Then
            LineState(index) = stateOnHook
            AddToLog "Line " + Str(index + 1) + " on hook"
            DialANumber LineModemIDs(index)
        End If
    End If
    If Exiting Then
        If AreThereAnyActivePorts <> True Then
            CloseAllResources
        End If
    End If
End Sub

Private Sub VoiceOCX1_MSIStationOffHook(ByVal ModemID As Long)
    Dim index As Integer
    index = FindMSIModemObject(ModemID)
    If index <> -1 Then
        AddToLog ("Line " + Str(index + 1) + " is OffHook")
        MSIState(index) = stateOffHook
        If GetIdleLine() <> -1 Then
            DialANumber (LineModemIDs(GetIdleLine()))
        End If
    End If
End Sub

Private Sub VoiceOCX1_MSIStationOnHook(ByVal ModemID As Long)
    Dim index As Integer
    index = FindMSIModemObject(ModemID)
    If index <> -1 Then
        AddToLog ("Line " + Str(index + 1) + " is OnHook")
        If MSIState(index) <> stateConnected Then
            MSIState(index) = stateOnHook
        Else
            MSIState(index) = stateOnHook
            VoiceOCX1.SCBUSStopListeningTo MSIHandles(index), LineHandles(MSIStationConnectedTo(index)), 0
            VoiceOCX1.SCBUSStopListeningTo VoiceHandles(MSIStationConnectedTo(index)), LineHandles(MSIStationConnectedTo(index)), 1
            VoiceOCX1.SCBUSListenTo VoiceHandles(MSIStationConnectedTo(index)), LineHandles(MSIStationConnectedTo(index)), 0
            LineState(MSIStationConnectedTo(index)) = stateHangingUP
            VoiceOCX1.HangUp LineModemIDs(MSIStationConnectedTo(index))
            LineConnectedTo(MSIStationConnectedTo(index)) = -1
            MSIStationConnectedTo(index) = -1
        End If
    End If
End Sub

Private Sub VoiceOCX1_NoAnswer(ByVal ModemID As Long)
    Dim index As Integer
    index = FindLineModemObject(ModemID)
    If index <> -1 Then
        AddToLog "No answer on line " + Str(index + 1)
        If LineState(index) = stateDialing Then
            LineState(index) = stateHangingUP
            VoiceOCX1.HangUp ModemID
        End If
    End If
End Sub

Private Sub VoiceOCX1_NoCarrier(ByVal ModemID As Long)
    Dim index As Integer
    index = FindLineModemObject(ModemID)
    If index <> -1 Then
        AddToLog "No carrier on line " + Str(index + 1)
        If LineState(index) = stateDialing Then
            LineState(index) = stateHangingUP
            VoiceOCX1.HangUp ModemID
        End If
    End If
End Sub

Private Sub VoiceOCX1_NoDialTone(ByVal ModemID As Long)
    Dim index As Integer
    index = FindLineModemObject(ModemID)
    If index <> -1 Then
    AddToLog "No dial tone on line " + Str(index + 1)
        If LineState(index) = stateDialing Then
            LineState(index) = stateHangingUP
            VoiceOCX1.HangUp ModemID
        End If
    End If
End Sub

Private Sub VoiceOCX1_OnHook(ByVal ModemID As Long)
    Dim index As Integer
    index = FindLineModemObject(ModemID)
    If index <> -1 Then
        AddToLog "Remote hangup on line " + Str(index + 1)
        If LineState(index) = stateConnected Then
            If LineConnectedTo(index) <> -1 Then
                MSIState(LineConnectedTo(index)) = stateOffHook
                VoiceOCX1.SCBUSStopListeningTo MSIHandles(MSIindex), LineHandles(index), 0
                VoiceOCX1.SCBUSStopListeningTo LineHandles(index), VoiceHandles(index), 1
                VoiceOCX1.SCBUSListenTo VoiceHandles(index), LineHandles(index), 0
                MSIStationConnectedTo(LineConnectedTo(index)) = -1
                LineConnectedTo(index) = -1
            End If
        End If
        LineState(index) = stateHangingUP
        VoiceOCX1.HangUp ModemID
    End If
End Sub

Private Sub VoiceOCX1_SIT(ByVal ModemID As Long)
    Dim index As Integer
    index = FindLineModemObject(ModemID)
    If index <> -1 Then
        AddToLog "SIT tone on line " + Str(index)
        If LineState(index) = stateDialing Then
            LineState(index) = stateHangingUP
            VoiceOCX1.HangUp ModemID
        End If
    End If
End Sub

Private Sub VoiceOCX1_ModemOK(ByVal ModemID As Long)
    Dim index As Integer
    index = FindLineModemObject(ModemID)
    If index <> -1 Then
        If LineState(index) = stateHangingUP Then
            LineState(index) = stateOnHook
            AddToLog "Line " + Str(index + 1) + " on hook"
            DialANumber LineModemIDs(index)
        End If
    End If
End Sub

Private Sub VoiceOCX1_VoiceConnect(ByVal ModemID As Long)
    Dim index As Integer
    Dim MSIindex As Byte
    
    index = FindLineModemObject(ModemID)
    If index <> -1 Then
        AddToLog "Voice connection on line " + Str(index + 1)
        MSIindex = GetNotConnectedMSIStation()
        If MSIindex <> -1 Then
            MSIState(MSIindex) = stateConnected
            LineState(index) = stateConnected
            LineConnectedTo(index) = MSIindex
            MSIStationConnectedTo(MSIindex) = index
            VoiceOCX1.MSIGenerateZipTone MSIModemIDs(MSIindex)
            VoiceOCX1.SCBUSStopListeningTo VoiceHandles(index), LineHandles(index), 0
            VoiceOCX1.SCBUSListenTo MSIHandles(MSIindex), LineHandles(index), 0
            VoiceOCX1.SCBUSListenTo LineHandles(index), VoiceHandles(index), 1
        End If
    End If
End Sub
