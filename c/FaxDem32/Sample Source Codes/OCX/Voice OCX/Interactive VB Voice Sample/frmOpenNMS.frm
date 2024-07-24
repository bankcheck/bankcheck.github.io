VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Begin VB.Form frmOpenNMS 
   Caption         =   "Open NMS Channel"
   ClientHeight    =   4395
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5865
   Icon            =   "frmOpenNMS.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   4395
   ScaleWidth      =   5865
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox DIDText 
      Height          =   285
      Left            =   1440
      TabIndex        =   7
      Text            =   "3"
      Top             =   3675
      Width           =   735
   End
   Begin VB.ComboBox ProtocolCombo 
      Height          =   315
      Left            =   120
      TabIndex        =   5
      Text            =   "Combo1"
      Top             =   3240
      Width           =   4575
   End
   Begin VB.CheckBox chbLogEn 
      Caption         =   "Enable Log"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   2640
      Width           =   1695
   End
   Begin VB.CommandButton btnCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   375
      Left            =   4800
      TabIndex        =   1
      Top             =   480
      Width           =   975
   End
   Begin VB.CommandButton btnOK 
      Caption         =   "OK"
      Height          =   375
      Left            =   4800
      TabIndex        =   0
      Top             =   0
      Width           =   975
   End
   Begin ComctlLib.ListView lvChannelList 
      Height          =   2535
      Left            =   120
      TabIndex        =   3
      Top             =   0
      Width           =   4575
      _ExtentX        =   8070
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
      AutoSize        =   -1  'True
      Caption         =   "DID/DNIS digits:"
      Height          =   195
      Left            =   120
      TabIndex        =   6
      Top             =   3720
      Width           =   1200
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "NMS Telephony Protocol:"
      Height          =   195
      Left            =   120
      TabIndex        =   4
      Top             =   3000
      Width           =   1830
   End
End
Attribute VB_Name = "frmOpenNMS"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private bLogEnabled As Boolean
Private failed As Boolean
Function GetSelectedProtocol(index As Integer)
    Dim Protocol As String
    Select Case index
        Case 0
          Protocol = "LPS0"
        Case 1
          Protocol = "DID0"
        Case 2
          Protocol = "OGT0"
        Case 3
          Protocol = "WNK0"
        Case 4
          Protocol = "WNK1"
        Case 5
          Protocol = "LPS8"
        Case 6
          Protocol = "FDI0"
        Case 7
          Protocol = "LPS9"
        Case 8
          Protocol = "GST8"
        Case 9
          Protocol = "GST9"
        Case 10
          Protocol = "ISD0"
        Case 11
          Protocol = "MFC0"
    Case Else
          Protocol = "LPS0"
    End Select
    GetSelectedProtocol = Protocol
End Function
Private Sub btnCancel_Click()
    Unload Me
End Sub
Private Sub btnOK_Click()
    Dim nIndex As Integer
    Dim i As Integer
    Dim index As Integer
    Dim Protocol As String
        
    bLogEnabled = chbLogEn.Value
    failed = True
    nIndex = -1
    For i = 1 To lvChannelList.ListItems.Count
        If lvChannelList.ListItems.Item(i).Selected = True Then
            nIndex = i
            Exit For
        End If
    Next
    
    If nIndex = -1 Then
        lvChannelList.ListItems.Item(1).Selected = True
        nIndex = 1
    End If
    If nIndex <> -1 Then
        lModemID = fMainForm.VoiceOCX.CreateModemObject(cnsNMS)
        If lModemID <> 0 Then
            nPrStatus = cnsSelectNMS
            
            'Set selected protocol
            index = ProtocolCombo.ListIndex
            Protocol = GetSelectedProtocol(index)
            fMainForm.VoiceOCX.SetNMSProtocol Protocol
    
            'Set specified DID/DNIS digits
            didDigits = DIDText.text
            fMainForm.VoiceOCX.SetDIDDigitNumber lModemID, Val(didDigits)
            
            If fMainForm.VoiceOCX.OpenPort(lModemID, lvChannelList.ListItems.Item(nIndex).text) = 0 Then
                btnOK.Enabled = False
                btnCancel.Enabled = False
            Else
                MsgBox "Cannot open channel: " + lvChannelList.ListItems.Item(nIndex).Selected
            End If
        End If
    End If
End Sub
Private Sub Form_Load()
    Dim nBoards As Integer
    Dim nIndex As Integer
    Dim szChannel As String
    Dim szType As String, szManufact As String, szModel As String
    
    bLogEnabled = False
    lModemID = 0
    
    nIndex = 0
    nBoards = fMainForm.VoiceOCX.GetNMSBoardNum
    For i = 0 To nBoards
        For j = 0 To fMainForm.VoiceOCX.GetNMSChannelNum(i) - 1
            If fMainForm.VoiceOCX.IsNMSChannelFree(i, j) Then
                szChannel = "NMS_B"
                bcStr = Str(i)
                bcStr = Right(bcStr, Len(bcStr) - 1)
                szChannel = szChannel + bcStr + "CH"
                bcStr = Str(j)
                bcStr = Right(bcStr, Len(bcStr) - 1)
                szChannel = szChannel + bcStr

                Set itmX = lvChannelList.ListItems.Add(, , szChannel)
                If fMainForm.VoiceOCX.GetNMSChannelType(i, j, szModel, 50) Then
                    itmX.SubItems(1) = szModel
                End If
            End If
            nIndex = nIndex + 1
        Next
    Next
    
    ProtocolCombo.AddItem "Analog Loop Start (LPS0)", 0
    ProtocolCombo.AddItem "Digital/Analog Wink Start (inbound only) (DID0)", 1
    ProtocolCombo.AddItem "Digital/Analog Wink Start (outbound only) (OGT0)", 2
    ProtocolCombo.AddItem "Digital/Analog Wink Start (WNK0)", 3
    ProtocolCombo.AddItem "Analog Wink Start (WNK1)", 4
    ProtocolCombo.AddItem "Digital Loop Start OPS-FX (LPS8)", 5
    ProtocolCombo.AddItem "Feature Group D (inbound only) (FDI0)", 6
    ProtocolCombo.AddItem "Digital Loop Start OPS-SA (LPS9)", 7
    ProtocolCombo.AddItem "Digital Ground Start OPS-FX (GST8)", 8
    ProtocolCombo.AddItem "Digital Ground Start OPS-SA (GST9)", 9
    ProtocolCombo.AddItem "ISDN protocol (ISD0)", 10
    ProtocolCombo.AddItem "MFC R2 protocol (MFC0)", 11
    ProtocolCombo.ListIndex = 0
End Sub
Public Sub VoiceOCX_PortOpen()
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
Public Function LogEnabled()
    LogEnabled = bLogEnabled
End Function
