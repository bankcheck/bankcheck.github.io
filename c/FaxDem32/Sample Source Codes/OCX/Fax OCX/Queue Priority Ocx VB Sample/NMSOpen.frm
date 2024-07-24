VERSION 5.00
Begin VB.Form NMSOpen 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Open NMS Channel"
   ClientHeight    =   3570
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4470
   Icon            =   "NMSOpen.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3570
   ScaleWidth      =   4470
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox DIDText 
      Height          =   285
      Left            =   1560
      MaxLength       =   5
      TabIndex        =   3
      Text            =   "3"
      Top             =   2950
      Width           =   855
   End
   Begin VB.ComboBox ProtocolCombo 
      Height          =   315
      ItemData        =   "NMSOpen.frx":000C
      Left            =   240
      List            =   "NMSOpen.frx":000E
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   2520
      Width           =   4095
   End
   Begin VB.Frame Frame1 
      Caption         =   "Available NMS Channels:"
      Height          =   1575
      Left            =   120
      TabIndex        =   6
      Top             =   240
      Width           =   2895
      Begin VB.ListBox ChannelList 
         Height          =   1230
         Left            =   120
         TabIndex        =   0
         Top             =   240
         Width           =   2655
      End
   End
   Begin VB.CheckBox HeaderCheckBox 
      Caption         =   "Create Header"
      Height          =   255
      Left            =   240
      TabIndex        =   1
      Top             =   1920
      Width           =   1455
   End
   Begin VB.CommandButton CommandOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   3240
      TabIndex        =   4
      Top             =   360
      Width           =   1095
   End
   Begin VB.CommandButton CommandCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   3240
      TabIndex        =   5
      Top             =   840
      Width           =   1095
   End
   Begin VB.Label Label2 
      Caption         =   "DNIS/DID digits:"
      Height          =   255
      Left            =   240
      TabIndex        =   8
      Top             =   3000
      Width           =   1215
   End
   Begin VB.Label Label1 
      Caption         =   "Nms Telephony Protocol:"
      Height          =   255
      Left            =   240
      TabIndex        =   7
      Top             =   2280
      Width           =   1815
   End
End
Attribute VB_Name = "NMSOpen"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Function GetSelectedProtocol(index As Integer)
     Select Case index
        Case 0
          protocol = "LPS0"
        Case 1
          protocol = "DID0"
        Case 2
          protocol = "OGT0"
        Case 3
          protocol = "WNK0"
        Case 4
          protocol = "WNK1"
        Case 5
          protocol = "LPS8"
        Case 6
          protocol = "FDI0"
        Case 7
          protocol = "LPS9"
        Case 8
          protocol = "GST8"
        Case 9
          protocol = "GST9"
        Case 10
          protocol = "ISD0"
        Case 11
          protocol = "MFC0"
     Case Else
          protocol = "LPS0"
     End Select
     GetSelectedProtocol = protocol
End Function

Private Sub CommandCancel_Click()
    Unload NMSOpen
End Sub

Private Sub CommandOK_Click()
    Static errcode As Long
    Static i As Integer
    Dim index As Integer
    
    'Set selected protocol
    index = ProtocolCombo.ListIndex
    protocol = GetSelectedProtocol(index)
    Form1.FAX1.NMSProtocoll = protocol
    
    'Set specified DID/DNIS digits
    didDigits = DIDText.Text
    Form1.FAX1.NMSDNISDigitNum = Val(didDigits)
    
    Screen.MousePointer = 11
    Form1.ActualFaxPort = ChannelList.List(ChannelList.ListIndex)
    Form1.FAX1.OpenPort ChannelList.List(ChannelList.ListIndex)
    errcode = Form1.FAX1.FaxError
    If (errcode <> 0) Then
        i = MsgBox(Form1.Errors(errcode), 0)
        Screen.MousePointer = 0
    Else
        Form1.ClosePort.Enabled = True
        Form1.HideManager.Enabled = True
        Form1.send.Enabled = True
        Form1.EventList.AddItem (ChannelList.List(ChannelList.ListIndex) + " was opened")
        Form1.FAX1.Header = HeaderCheckBox.Value
        Form1.FAX1.SetPortCapability Form1.ActualFaxPort, PC_MAX_BAUD_SEND, Form1.BaudRate
      
        If (Len(Form1.FAX1.AvailableNMSChannels) > 0) Then
            Form1.nmschannel.Enabled = True
        Else
            Form1.nmschannel.Enabled = False
        End If

        Screen.MousePointer = 0
        Unload NMSOpen
    End If
    Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
End Sub

Private Sub Form_Load()
    Static t1, t2 As String
    Static flag As Boolean
    Static i, j As Integer

    t1 = Form1.FAX1.AvailableNMSChannels
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
