VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Begin VB.Form frmDialogicOpen 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Open Dialogic Channel"
   ClientHeight    =   3600
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6000
   Icon            =   "frmDialogicOpen.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3600
   ScaleWidth      =   6000
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CheckBox PAMD 
      Caption         =   "Enable answering machine detection"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   2760
      Width           =   5175
   End
   Begin VB.TextBox Protocol 
      Height          =   285
      Left            =   3960
      TabIndex        =   6
      Top             =   3120
      Width           =   1935
   End
   Begin VB.ComboBox LineType 
      Height          =   315
      ItemData        =   "frmDialogicOpen.frx":030A
      Left            =   1080
      List            =   "frmDialogicOpen.frx":031A
      TabIndex        =   4
      Text            =   "Combo1"
      Top             =   3120
      Width           =   1935
   End
   Begin VB.CommandButton btnCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   375
      Left            =   4920
      TabIndex        =   2
      Top             =   600
      Width           =   975
   End
   Begin VB.CommandButton btnOK 
      Caption         =   "OK"
      Height          =   375
      Left            =   4920
      TabIndex        =   1
      Top             =   120
      Width           =   975
   End
   Begin ComctlLib.ListView lvChannelList 
      Height          =   2535
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4695
      _ExtentX        =   8281
      _ExtentY        =   4471
      View            =   3
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   327682
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   2
      BeginProperty ColumnHeader(1) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
         Key             =   ""
         Object.Tag             =   ""
         Text            =   "Name"
         Object.Width           =   2540
      EndProperty
      BeginProperty ColumnHeader(2) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
         SubItemIndex    =   1
         Key             =   ""
         Object.Tag             =   ""
         Text            =   "Type"
         Object.Width           =   2540
      EndProperty
   End
   Begin VB.Label Label2 
      Caption         =   "Protocol:"
      Height          =   255
      Left            =   3120
      TabIndex        =   5
      Top             =   3120
      Width           =   735
   End
   Begin VB.Label Label1 
      Caption         =   "Line Type:"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   3120
      Width           =   855
   End
End
Attribute VB_Name = "frmDialogicOpen"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private bLogEnabled As Boolean
Private failed As Boolean
Private Sub btnCancel_Click()
    Unload Me
End Sub
Private Sub btnOK_Click()
    Dim nIndex As Integer
    Dim i As Integer
    
    failed = False
    nIndex = -1
    For i = 1 To lvChannelList.ListItems.Count
        If lvChannelList.ListItems.Item(i).Selected = True Then
            nIndex = i
            Exit For
        End If
    Next
    
    If nIndex <> -1 Then
        lModemID = fMainForm.VoiceOCX.CreateModemObject(cnsDialogic)
        If lModemID <> 0 Then
            nPrStatus = cnsSelectDlg
            If LineType.ListIndex = 0 Then
                '3 is ANALOG
                fMainForm.VoiceOCX.SetDialogicLineType lModemID, 3
            ElseIf LineType.ListIndex = 1 Then
                '2 is ISDN PRI
                fMainForm.VoiceOCX.SetDialogicLineType lModemID, 2
            ElseIf LineType.ListIndex = 2 Or LineType.ListIndex = 3 Then
                '1 is T1/E1
                fMainForm.VoiceOCX.SetDialogicLineType lModemID, 1
                fMainForm.VoiceOCX.SetDialogicProtocol lModemID, Protocol.text
            End If
                    
                
            If fMainForm.VoiceOCX.OpenPort(lModemID, lvChannelList.ListItems.Item(nIndex).text) = 0 Then
                btnOK.Enabled = False
                btnCancel.Enabled = False
            Else
                MsgBox "Cannot open channel: " + lvChannelList.ListItems.Item(nIndex).Selected
            End If
        End If
    End If
End Sub

Private Sub Combo1_Change()

End Sub

Private Sub Form_Load()
    Dim nBoards As Integer
    Dim nIndex As Integer
    Dim szChannel As String
    Dim szType As String, szManufact As String, szModel As String
    
    bLogEnabled = False
    lModemID = 0
    
    nIndex = 0
    nBoards = fMainForm.VoiceOCX.GetDialogicBoardNum
    For i = 1 To nBoards
        For j = 1 To fMainForm.VoiceOCX.GetDialogicChannelNum(i)
            If fMainForm.VoiceOCX.IsDialogicChannelFree(i, j) Then
                szChannel = "dxxxB"
                bcStr = Str(i)
                bcStr = Right(bcStr, Len(bcStr) - 1)
                szChannel = szChannel + bcStr + "C"
                bcStr = Str(j)
                bcStr = Right(bcStr, Len(bcStr) - 1)
                szChannel = szChannel + bcStr

                Set itmX = lvChannelList.ListItems.Add(, , szChannel)
                If fMainForm.VoiceOCX.TestDialogic(szChannel, szType, szManufact, szModel) Then
                    itmX.SubItems(1) = szModel
                End If
            End If
            nIndex = nIndex + 1
        Next
    Next
    LineType.ListIndex = 0
    Protocol.Enabled = False
    Protocol.text = "us_mf_io"
End Sub
Public Sub VoiceOCX_PortOpen()
    
    If PAMD.Value = 0 Then
        fMainForm.VoiceOCX.SetParameters lModemID, cnsMDM_ENABLE_ANSVERING_MACHINE_DETECTION, False
    Else
        fMainForm.VoiceOCX.SetParameters lModemID, cnsMDM_ENABLE_ANSVERING_MACHINE_DETECTION, True
    End If
    
    MsgBox "Channel opened"
    
    Unload Me
End Sub
Public Sub VoiceOCX_ModemError()
    If Not failed Then
        failed = True
        MsgBox "Open channel failed!"
    End If
    btnOK.Enabled = True
    btnCancel.Enabled = True
    nPrStatus = cnsNoneAttached
    lModemID = 0
End Sub

Private Sub LineType_Click()
    If LineType.ListIndex > 1 Then
        Protocol.Enabled = True
    Else
        Protocol.Enabled = False
    End If
End Sub
