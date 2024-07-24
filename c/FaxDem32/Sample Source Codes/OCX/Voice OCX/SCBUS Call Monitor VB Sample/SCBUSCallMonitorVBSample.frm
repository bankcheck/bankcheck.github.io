VERSION 5.00
Object = "{426F4282-5F31-11D1-A131-0040F614A5A0}#1.0#0"; "voiceocx.ocx"
Begin VB.Form Form1 
   Caption         =   "Voice C++ SCBus Call Monitor Sample for Visual Basic"
   ClientHeight    =   4395
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   9045
   Icon            =   "SCBUSCallMonitorVBSample.frx":0000
   LinkTopic       =   "Form1"
   MouseIcon       =   "SCBUSCallMonitorVBSample.frx":0442
   ScaleHeight     =   4395
   ScaleWidth      =   9045
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame FrameOutgoing 
      Caption         =   "Incoming call2"
      Height          =   1470
      Left            =   4560
      TabIndex        =   24
      Top             =   15
      Width           =   4455
      Begin VB.ComboBox cbVoiceRes2 
         Height          =   315
         Left            =   1515
         TabIndex        =   8
         Top             =   1035
         Width           =   2835
      End
      Begin VB.TextBox edProtocol2 
         Enabled         =   0   'False
         Height          =   330
         Left            =   2970
         TabIndex        =   7
         Text            =   "us_mf_io"
         Top             =   630
         Width           =   1365
      End
      Begin VB.ComboBox cbLineType2 
         Height          =   315
         ItemData        =   "SCBUSCallMonitorVBSample.frx":0884
         Left            =   900
         List            =   "SCBUSCallMonitorVBSample.frx":0894
         TabIndex        =   6
         Top             =   630
         Width           =   1320
      End
      Begin VB.ComboBox cbLineRes2 
         Height          =   315
         Left            =   1980
         TabIndex        =   5
         Top             =   240
         Width           =   2370
      End
      Begin VB.Label LabelVoiceRes2 
         Caption         =   "Voice Resources:"
         Height          =   270
         Left            =   120
         TabIndex        =   11
         Top             =   1065
         Width           =   1320
      End
      Begin VB.Label LabelProtocol2 
         Caption         =   "Protocol:"
         Height          =   210
         Left            =   2265
         TabIndex        =   10
         Top             =   675
         Width           =   690
      End
      Begin VB.Label LabelLineType2 
         Caption         =   "Line Type:"
         Height          =   195
         Left            =   120
         TabIndex        =   9
         Top             =   675
         Width           =   825
      End
      Begin VB.Label LabelLineRes2 
         Caption         =   "Line Interface Resources:"
         Height          =   210
         Left            =   120
         TabIndex        =   0
         Top             =   270
         Width           =   1905
      End
   End
   Begin VB.Frame FrameIncoming 
      Caption         =   "Incoming call1"
      Height          =   1470
      Left            =   45
      TabIndex        =   19
      Top             =   15
      Width           =   4455
      Begin VB.ComboBox cbLineRes1 
         Height          =   315
         Left            =   1980
         TabIndex        =   1
         Top             =   240
         Width           =   2370
      End
      Begin VB.ComboBox cbLineType1 
         Height          =   315
         ItemData        =   "SCBUSCallMonitorVBSample.frx":08C1
         Left            =   900
         List            =   "SCBUSCallMonitorVBSample.frx":08D1
         TabIndex        =   2
         Top             =   630
         Width           =   1320
      End
      Begin VB.TextBox edProtocol1 
         Enabled         =   0   'False
         Height          =   330
         Left            =   2970
         TabIndex        =   3
         Text            =   "us_mf_io"
         Top             =   630
         Width           =   1380
      End
      Begin VB.ComboBox cbVoiceRes1 
         Height          =   315
         Left            =   1515
         TabIndex        =   4
         Top             =   1050
         Width           =   2835
      End
      Begin VB.Label LabelLineRes1 
         Caption         =   "Line Interface Resources:"
         Height          =   270
         Left            =   120
         TabIndex        =   23
         Top             =   270
         Width           =   1875
      End
      Begin VB.Label LabelLineType1 
         Caption         =   "Line Type:"
         Height          =   195
         Left            =   120
         TabIndex        =   22
         Top             =   675
         Width           =   825
      End
      Begin VB.Label LabelProtocol1 
         Caption         =   "Protocol:"
         Height          =   210
         Left            =   2265
         TabIndex        =   21
         Top             =   675
         Width           =   690
      End
      Begin VB.Label LabelVoiceRes1 
         Caption         =   "Voice Resources:"
         Height          =   270
         Left            =   120
         TabIndex        =   20
         Top             =   1065
         Width           =   1320
      End
   End
   Begin VOICEOCXLib.VoiceOCX VoiceOCX1 
      Height          =   255
      Left            =   240
      TabIndex        =   18
      Top             =   3960
      Width           =   255
      _Version        =   65536
      _ExtentX        =   450
      _ExtentY        =   450
      _StockProps     =   0
   End
   Begin VB.CommandButton btnExit 
      Caption         =   "E&xit"
      Height          =   345
      Left            =   6495
      TabIndex        =   17
      Top             =   3960
      Width           =   1245
   End
   Begin VB.CommandButton btnFinishConv 
      Caption         =   "&Finish Conversation"
      Enabled         =   0   'False
      Height          =   345
      Left            =   4800
      TabIndex        =   16
      Top             =   3960
      Width           =   1650
   End
   Begin VB.CommandButton btnStopWaitingForCalls 
      Caption         =   "&Stop Waiting For  Calls"
      Enabled         =   0   'False
      Height          =   345
      Left            =   2880
      TabIndex        =   15
      Top             =   3960
      Width           =   1875
   End
   Begin VB.CommandButton btnWaitforACall 
      Caption         =   "&Wait For Calls"
      Height          =   345
      Left            =   1320
      TabIndex        =   14
      Top             =   3960
      Width           =   1485
   End
   Begin VB.Frame FrameMessages 
      Caption         =   "Messages"
      Height          =   2205
      Left            =   45
      TabIndex        =   12
      Top             =   1560
      Width           =   8955
      Begin VB.CommandButton btnClear 
         Caption         =   "Cl&ear"
         Height          =   330
         Left            =   3615
         TabIndex        =   25
         Top             =   1755
         Width           =   1860
      End
      Begin VB.ListBox lstMessages 
         Height          =   1425
         Left            =   105
         TabIndex        =   13
         Top             =   210
         Width           =   8760
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim ModemID1 As Long
Dim ModemID2 As Long

Dim LineRes1 As Long
Dim LineRes2 As Long

Dim VoiceRes1 As Long
Dim VoiceRes2 As Long

Dim voicefile1 As String
Dim voicefile2 As String

Dim State As Long
Dim voicePath As String
Const StateClosed = 1
Const StateWaitingForCall1 = 2
Const StateAnsweringCall1 = 3
Const StateConnected = 4
Const StateClosing = 5
Const StateWaitingForCall2 = 6
Const StateAnsweringCall2 = 7
Public Sub Sleep(Seconds As Single)
    Dim OldTimer As Single
    
    OldTimer = Timer
    Do While (Timer - OldTimer) < Seconds
    Loop
End Sub

Private Sub EnableControls()
    If State = StateClosed Then
        cbLineRes1.Enabled = True
        cbLineRes2.Enabled = True
        cbVoiceRes1.Enabled = True
        cbVoiceRes2.Enabled = True
        cbLineType1.Enabled = True
        cbLineType2.Enabled = True
        edProtocol1.Enabled = True
        edProtocol2.Enabled = True
        btnWaitforACall.Enabled = True
        btnStopWaitingForCalls.Enabled = False
        btnFinishConv.Enabled = False
    End If
    If State = StateWaitingForCall1 Then
        cbLineRes1.Enabled = False
        cbLineRes2.Enabled = False
        cbVoiceRes1.Enabled = False
        cbVoiceRes2.Enabled = False
        cbLineType1.Enabled = False
        cbLineType2.Enabled = False
        edProtocol1.Enabled = False
        edProtocol2.Enabled = False
        btnWaitforACall.Enabled = False
        btnStopWaitingForCalls.Enabled = True
        btnFinishConv.Enabled = False
    End If
    If State = StateAnsweringCall1 Then
        cbLineRes1.Enabled = False
        cbLineRes2.Enabled = False
        cbVoiceRes1.Enabled = False
        cbVoiceRes2.Enabled = False
        cbLineType1.Enabled = False
        cbLineType2.Enabled = False
        edProtocol1.Enabled = False
        edProtocol2.Enabled = False
        btnWaitforACall.Enabled = False
        btnStopWaitingForCalls.Enabled = True
        btnFinishConv.Enabled = False
    End If
    If State = StateAnsweringCall2 Then
        cbLineRes1.Enabled = False
        cbLineRes2.Enabled = False
        cbVoiceRes1.Enabled = False
        cbVoiceRes2.Enabled = False
        cbLineType1.Enabled = False
        cbLineType2.Enabled = False
        edProtocol1.Enabled = False
        edProtocol2.Enabled = False
        btnWaitforACall.Enabled = False
        btnStopWaitingForCalls.Enabled = False
        btnFinishConv.Enabled = False
    End If
    If State = StateConnected Then
        cbLineRes1.Enabled = False
        cbLineRes2.Enabled = False
        cbVoiceRes1.Enabled = False
        cbVoiceRes2.Enabled = False
        cbLineType1.Enabled = False
        cbLineType2.Enabled = False
        edProtocol1.Enabled = False
        edProtocol2.Enabled = False
        btnWaitforACall.Enabled = False
        btnStopWaitingForCalls.Enabled = False
        btnFinishConv.Enabled = True
    End If
    If State = StateClosing Then
        cbLineRes1.Enabled = False
        cbLineRes2.Enabled = False
        cbVoiceRes1.Enabled = False
        cbVoiceRes2.Enabled = False
        cbLineType1.Enabled = False
        cbLineType2.Enabled = False
        edProtocol1.Enabled = False
        edProtocol2.Enabled = False
        btnWaitforACall.Enabled = False
        btnStopWaitingForCalls.Enabled = False
        btnFinishConv.Enabled = False
    End If
    
    If cbLineRes1.ListCount = 0 Then
        cbLineRes1.Enabled = False
        cbLineRes2.Enabled = False
        cbVoiceRes1.Enabled = False
        cbVoiceRes2.Enabled = False
        cbLineType1.Enabled = False
        cbLineType2.Enabled = False
        edProtocol1.Enabled = False
        edProtocol2.Enabled = False
        btnWaitforACall.Enabled = False
        btnStopWaitingForCalls.Enabled = False
        btnFinishConv.Enabled = False
    End If

End Sub


Function GetLineType1() As Long
    If cbLineType1.ListIndex = 0 Then
        GetLineType1 = 3
        Exit Function
    End If
    If cbLineType1.ListIndex = 1 Then
        GetLineType1 = 2
        Exit Function
    End If
    If cbLineType1.ListIndex = 2 Then
        GetLineType1 = 1
        Exit Function
    End If
    If cbLineType1.ListIndex = 3 Then
        GetLineType1 = 1
        Exit Function
    End If
    GetLineType1 = 3
End Function

Function GetLineType2() As Long
    If cbLineType2.ListIndex = 0 Then
        GetLineType2 = 3
        Exit Function
    End If
    If cbLineType2.ListIndex = 1 Then
        GetLineType2 = 2
        Exit Function
    End If
    If cbLineType2.ListIndex = 2 Then
        GetLineType2 = 1
        Exit Function
    End If
    If cbLineType2.ListIndex = 3 Then
        GetLineType2 = 1
        Exit Function
    End If
    GetLineType2 = 3
End Function

Private Sub CloseResources()
    AddToLog "Closing resources..."
    
    If ModemID1 <> 0 Then
        If VoiceRes1 <> 0 Then
            VoiceOCX1.SCBUSStopListeningTo LineRes1, VoiceRes1, 0
            VoiceOCX1.SCBUSDetachResourceFromMODEMOBJ ModemID1, VoiceRes1
            VoiceOCX1.SCBUSCloseResource VoiceRes1
            VoiceRes1 = 0
        End If
        If LineRes1 <> 0 Then
            VoiceOCX1.SCBUSDetachResourceFromMODEMOBJ ModemID1, LineRes1
            VoiceOCX1.SCBUSCloseResource LineRes1
            LineRes1 = 0
        End If
        VoiceOCX1.DestroyModemObject ModemID1
        ModemID1 = 0
    End If
    If ModemID2 <> 0 Then
        If VoiceRes2 <> 0 Then
            VoiceOCX1.SCBUSStopListeningTo LineRes2, VoiceRes2, 0
            VoiceOCX1.SCBUSDetachResourceFromMODEMOBJ ModemID2, VoiceRes2
            VoiceOCX1.SCBUSCloseResource VoiceRes2
            VoiceRes2 = 0
        End If
        If LineRes2 <> 0 Then
            VoiceOCX1.SCBUSDetachResourceFromMODEMOBJ ModemID2, LineRes2
            VoiceOCX1.SCBUSCloseResource LineRes2
            LineRes2 = 0
        End If
        VoiceOCX1.DestroyModemObject ModemID2
        ModemID2 = 0
    End If
    AddToLog "Resources have been closed..."
End Sub

Private Sub OpenResources()
    AddToLog "Opening resources..."
    If Len(cbLineRes1.Text) > 0 Then
        AddToLog "Opening Line interface " + cbLineRes1.Text + " ..."
        If VoiceOCX1.SCBUSGetResourceStatus(cbLineRes1.Text, 0) = 1 Then
            LineRes1 = VoiceOCX1.SCBUSOpenResource(cbLineRes1.Text, 0, GetLineType1, edProtocol1.Text)
            If LineRes1 = 0 Then
                AddToLog "Line interface resource " + cbLineRes1.Text + " cannot be opened. Please select another line interface resource."
                CloseResources
                State = StateClosed
                Exit Sub
            End If
            AddToLog "Line interface resource " + cbLineRes1.Text + " is open."
        Else
            AddToLog "Line interface resource " + cbLineRes1.Text + " is not available. Please select another line interface resource."
            CloseResources
            State = StateClosed
            Exit Sub
        End If
        
    End If
    If Len(cbLineRes2.Text) Then
        If cbLineRes1.Text = cbLineRes2.Text Then
            AddToLog "Please do not specify the same line interface resource for both incoming and outgoing calls."
            CloseResources
            State = StateClosed
            Exit Sub
        End If
        AddToLog "Opening Line interface " + cbLineRes2.Text + " ..."
        If VoiceOCX1.SCBUSGetResourceStatus(cbLineRes2.Text, 0) = 1 Then
            LineRes2 = VoiceOCX1.SCBUSOpenResource(cbLineRes2.Text, 0, GetLineType2, edProtocol2.Text)
            If LineRes2 = 0 Then
                AddToLog "Line interface resource " + cbLineRes2.Text + " cannot be opened. Please select another line interface resource."
                CloseResources
                State = StateClosed
                Exit Sub
            End If
            AddToLog "Line interface resource " + cbLineRes2.Text + " is open."
        Else
            AddToLog "Line interface resource " + cbLineRes2.Text + " is not available. Please select another line interface resource."
            CloseResources
            State = StateClosed
            Exit Sub
        End If
    End If
    If (Len(cbVoiceRes1.Text) > 0) And (cbVoiceRes1.Text <> "No voice resource needed") Then
        AddToLog "Opening Voice resource " + cbVoiceRes1.Text + " ..."
        If VoiceOCX1.SCBUSGetResourceStatus(cbVoiceRes1.Text, 1) = 1 Then
            VoiceRes1 = VoiceOCX1.SCBUSOpenResource(cbVoiceRes1.Text, 1, 0, "")
            If VoiceRes1 = 0 Then
                AddToLog "Voice resource " + cbVoiceRes1.Text + " cannot be opened. Please select another Voice resource."
                CloseResources
                State = StateClosed
                Exit Sub
            End If
            AddToLog "Voice resource " + cbVoiceRes1.Text + " is open."
            VoiceOCX1.SCBUSListenTo LineRes1, VoiceRes1, 0
        Else
            AddToLog "Voice resource " + cbVoiceRes1.Text + " is not available. Please select another Voice resource."
            CloseResources
            State = StateClosed
            Exit Sub
        End If
        
    End If
    If (Len(cbVoiceRes2.Text) > 0) And (cbVoiceRes2.Text <> "No voice resource needed") Then
        If cbVoiceRes1.Text = cbVoiceRes2.Text Then
            AddToLog "Please do not specify the same voice resource for both incoming and outgoing calls."
            CloseResources
            State = StateClosed
            Exit Sub
        End If
        AddToLog "Opening Voice resource " + cbVoiceRes2.Text + " ..."
        If VoiceOCX1.SCBUSGetResourceStatus(cbVoiceRes2.Text, 1) = 1 Then
            VoiceRes2 = VoiceOCX1.SCBUSOpenResource(cbVoiceRes2.Text, 1, 0, "")
            If VoiceRes2 = 0 Then
                AddToLog "Voice resource " + cbVoiceRes2.Text + " cannot be opened. Please select another Voice resource."
                CloseResources
                State = StateClosed
                Exit Sub
            End If
            AddToLog "Voice resource " + cbVoiceRes2.Text + " is open."
            VoiceOCX1.SCBUSListenTo LineRes2, VoiceRes2, 0
        Else
            AddToLog "Voice resource " + cbVoiceRes2.Text + " is not available. Please select another Voice resource."
            CloseResources
            State = StateClosed
            Exit Sub
        End If
    End If
    
    If LineRes1 <> 0 Then
        AddToLog "Creating modem object 1..."
        ModemID1 = VoiceOCX1.CreateModemObject(2)
        AddToLog "Attaching line interface " + cbLineRes1.Text + " to modem object 1..."
        VoiceOCX1.SCBUSAttachResourceToMODEMOBJ ModemID1, LineRes1
        If VoiceRes1 <> 0 Then
            AddToLog "Attaching voice resource " + cbVoiceRes1.Text + " to modem object 1..."
            VoiceOCX1.SCBUSAttachResourceToMODEMOBJ ModemID1, VoiceRes1
        End If
    End If
    
    If LineRes2 <> 0 Then
        AddToLog "Creating modem object 2...."
        ModemID2 = VoiceOCX1.CreateModemObject(2)
        AddToLog "Attaching line interface " + cbLineRes2.Text + " to modem object 2..."
        VoiceOCX1.SCBUSAttachResourceToMODEMOBJ ModemID2, LineRes2
        If VoiceRes2 <> 0 Then
            AddToLog "Attaching voice resource " + cbVoiceRes2.Text + " to modem object 2..."
            VoiceOCX1.SCBUSAttachResourceToMODEMOBJ ModemID2, VoiceRes2
        End If
    End If
    
    VoiceOCX1.SetFaxDetectionTimeout ModemID1, 0
    VoiceOCX1.WaitForRings ModemID1, 1
    VoiceOCX1.WaitForRings ModemID2, 1
    AddToLog "Waiting for a call on line interface " + cbLineRes1.Text
    State = StateWaitingForCall1
    EnableControls
End Sub
Private Sub EnumResources()
    Dim LineResources As String
    Dim VoiceResources As String
    Dim t2 As String
    Dim flag As Boolean
    Dim i, j As Integer
    
    LineResources = VoiceOCX1.SCBUSEnumerateResources(0)
    If Len(LineResources) <> 0 Then
        flag = True
        i = 1
        While flag
            j = InStr(1, LineResources, " ", 0)
            If (j = 0) Then
                t2 = LineResources
                flag = False
            Else
                t2 = Left(LineResources, j - 1)
                LineResources = Right(LineResources, Len(LineResources) - j)
            End If
            
            cbLineRes1.AddItem (t2)
            cbLineRes2.AddItem (t2)
        Wend
        cbLineRes1.ListIndex = 0
        cbLineRes2.ListIndex = 1
        
        cbVoiceRes1.AddItem ("No voice resource needed")
        cbVoiceRes2.AddItem ("No voice resource needed")
    End If
    
    
    VoiceResources = VoiceOCX1.SCBUSEnumerateResources(1)
    If Len(VoiceResources) <> 0 Then
        flag = True
        i = 1
        While flag
            j = InStr(1, VoiceResources, " ", 0)
            If (j = 0) Then
                t2 = VoiceResources
                flag = False
            Else
                t2 = Left(VoiceResources, j - 1)
                VoiceResources = Right(VoiceResources, Len(VoiceResources) - j)
            End If
            
            cbVoiceRes1.AddItem (t2)
            cbVoiceRes2.AddItem (t2)
        Wend
        cbVoiceRes1.ListIndex = 1
        cbVoiceRes2.ListIndex = 2
    End If
End Sub

Private Sub btnClear_Click()
    lstMessages.Clear
End Sub

Private Sub btnExit_Click()
    If State = StateConnected Then
        VoiceOCX1.SCBUSStopListeningTo LineRes1, LineRes2, 0
        If VoiceRes1 Then
            VoiceOCX1.SCBUSListenTo LineRes1, VoiceRes1, 0
        End If
        If VoiceRes2 Then
            VoiceOCX1.SCBUSListenTo LineRes2, VoiceRes2, 0
        End If
    End If
    CloseResources
    State = StateClosed
    Unload Me
    
End Sub

Private Sub btnFinishConv_Click()
Dim voiceToPlay As String
    If State = StateConnected Then
        VoiceOCX1.SCBUSStopListeningTo LineRes1, LineRes2, 0
        If VoiceRes1 Then
            VoiceOCX1.SCBUSListenTo LineRes1, VoiceRes1, 0
        End If
        If VoiceRes2 Then
            VoiceOCX1.SCBUSListenTo LineRes2, VoiceRes2, 0
        End If
    End If
    If State = StateConnected Then
        State = StateClosing
        VoiceOCX1.HangUp ModemID1
        VoiceOCX1.HangUp ModemID2
    Else
        CloseResources
        State = StateClosed
    End If
    EnableControls
End Sub

Private Sub btnStopWaitingForCalls_Click()
    Screen.MousePointer = 11
    If State = StateConnected Then
        VoiceOCX1.SCBUSStopListeningTo LineRes1, LineRes2, 0
        If VoiceRes1 Then
            VoiceOCX1.SCBUSListenTo LineRes1, VoiceRes1, 0
        End If
        If VoiceRes2 Then
            VoiceOCX1.SCBUSListenTo LineRes2, VoiceRes2, 0
        End If
    End If
    If State >= StateAnsweringCall1 Then
        State = StateClosing
        VoiceOCX1.HangUp ModemID1
        VoiceOCX1.HangUp ModemID2
    Else
        CloseResources
        State = StateClosed
    End If
    EnableControls
    Screen.MousePointer = 0
End Sub

Private Sub btnWaitforACall_Click()
    OpenResources
    EnableControls
End Sub

Private Sub cbLineType1_Click()
     If cbLineType1.ListIndex > 1 Then
        edProtocol1.Enabled = True
    Else
        edProtocol1.Enabled = False
    End If
    
End Sub

Private Sub cbLineType2_Click()
    If cbLineType2.ListIndex > 1 Then
        edProtocol2.Enabled = True
    Else
        edProtocol2.Enabled = False
    End If
End Sub

Private Sub Form_Load()

ModemID1 = 0
ModemID2 = 0
LineRes1 = 0
LineRes2 = 0
VoiceRes1 = 0
VoiceRes2 = 0
State = StateClosed

Call EnumResources
    
If cbLineRes1.ListCount = 0 Then
    MsgBox "There are no line interface resources available. This sample cannot run without line interface resources"
End If

cbLineType1.ListIndex = 2
cbLineType2.ListIndex = 2
EnableControls
voicePath = App.Path + "\Voice\"
End Sub

Private Sub AddToLog(Msg As String)
    lstMessages.AddItem Msg
    lstMessages.ListIndex = lstMessages.ListCount - 1
End Sub

Private Sub VoiceOCX1_Answer(ByVal ModemID As Long)
    Dim file As String
    file = voicePath + "waiting.wav"
    If ModemID = ModemID1 Then
        VoiceOCX1.PlayVoice ModemID, file, 0, 0, 0, 1
    End If
End Sub

Private Sub VoiceOCX1_HangUp(ByVal ModemID As Long)
    If State = StateClosing Then
        AddToLog "Calls disconnected..."
        CloseResources
        State = StateClosed
        EnableControls
    End If
End Sub

Private Sub VoiceOCX1_ModemError(ByVal ModemID As Long)
    AddToLog "Error detected in the last operation. Closing resources ..."
    
    If State = StateConnected Then
        VoiceOCX1.SCBUSStopListeningTo LineRes1, LineRes2, 0
        If VoiceRes1 Then
            VoiceOCX1.SCBUSListenTo LineRes1, VoiceRes1, 0
        End If
        If VoiceRes2 Then
            VoiceOCX1.SCBUSListenTo LineRes2, VoiceRes2, 0
        End If
    End If
    If State >= StateAnsweringCall1 Then
        State = StateClosing
        VoiceOCX1.HangUp ModemID1
        VoiceOCX1.HangUp ModemID2
    Else
        CloseResources
        State = StateClosed
    End If
    
    EnableControls
End Sub

Private Sub VoiceOCX1_OnHook(ByVal ModemID As Long)
    AddToLog "Remote hangup detected. Disconnecting..."
    If State = StateConnected Then
        VoiceOCX1.SCBUSStopListeningTo LineRes1, LineRes2, 0
        If VoiceRes1 Then
            VoiceOCX1.SCBUSListenTo LineRes1, VoiceRes1, 0
        End If
        If VoiceRes2 Then
            VoiceOCX1.SCBUSListenTo LineRes2, VoiceRes2, 0
        End If
    End If
    If State = StateConnected Then
        State = StateClosing
        VoiceOCX1.HangUp ModemID1
        VoiceOCX1.HangUp ModemID2
    Else
        CloseResources
        State = StateClosed
    End If
    EnableControls
End Sub

Private Sub VoiceOCX1_Ring(ByVal ModemID As Long)
    AddToLog "Incoming call was detected. Answering call..."
    If (State = StateWaitingForCall1) Then
        State = StateAnsweringCall1
    ElseIf (State = StateWaitingForCall2) Then
        State = StateAnsweringCall2
    End If
    VoiceOCX1.Answer ModemID
    EnableControls
End Sub


Private Sub VoiceOCX1_VoiceConnect(ByVal ModemID As Long)
    If State = StateAnsweringCall1 Then
        AddToLog "First voice connection established."
        AddToLog "Waiting for a call on line interface " + cbLineRes2.Text
        State = StateWaitingForCall2
        EnableControls
        Exit Sub
    End If
    Dim voicefile1 As String
    Dim voicefile2 As String
    voicefile1 = voicePath + "caller1_" + Format(Time, "hh_mm_ss_") + Format(Date, "mmm_dd_yyyy") + ".wav"
    voicefile2 = voicePath + "caller2_" + Format(Time, "hh_mm_ss_") + Format(Date, "mmm_dd_yyyy") + ".wav"
    If State = StateAnsweringCall2 Then
        AddToLog "Second voice connection established. Connecting calls..."
        State = StateConnected
        If VoiceRes1 Then
            VoiceOCX1.SCBUSStopListeningTo LineRes1, VoiceRes1, 0
        End If
        If VoiceRes2 Then
            VoiceOCX1.SCBUSStopListeningTo LineRes2, VoiceRes2, 0
        End If
        VoiceOCX1.SCBUSListenTo LineRes1, LineRes2, 0
        If VoiceRes1 Then
            VoiceOCX1.SCBUSListenTo VoiceRes1, LineRes1, 1
            VoiceOCX1.RecordVoice ModemID1, voicefile1, 0, 60, True, 1
        End If
        If VoiceRes2 Then
            VoiceOCX1.SCBUSListenTo VoiceRes2, LineRes2, 1
            VoiceOCX1.RecordVoice ModemID2, voicefile2, 0, 60, True, 1
        End If
        EnableControls
    End If
End Sub
