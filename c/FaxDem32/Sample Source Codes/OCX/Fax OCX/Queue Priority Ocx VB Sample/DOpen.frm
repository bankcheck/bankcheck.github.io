VERSION 5.00
Begin VB.Form DOpen 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Open Dialogic Fax Channel"
   ClientHeight    =   2295
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4470
   Icon            =   "DOpen.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2295
   ScaleWidth      =   4470
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame Frame1 
      Caption         =   "Available Dialogic Channels:"
      Height          =   1575
      Left            =   120
      TabIndex        =   4
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
   Begin VB.CommandButton CommandCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   3240
      TabIndex        =   3
      Top             =   840
      Width           =   1095
   End
   Begin VB.CommandButton CommandOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   3240
      TabIndex        =   2
      Top             =   360
      Width           =   1095
   End
End
Attribute VB_Name = "DOpen"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub CommandCancel_Click()
    Unload DOpen
End Sub

Private Sub CommandOK_Click()
    Static errcode As Long
    Static i As Integer

    Screen.MousePointer = 11
    Form1.ActualFaxPort = ChannelList.List(ChannelList.ListIndex)
    Form1.FAX1.OpenPort ChannelList.List(ChannelList.ListIndex)
    errcode = Form1.FAX1.FaxError
    If (errcode <> 0) Then
        i = MsgBox(Form1.Errors(errcode), 0)
    Else
        Form1.ClosePort.Enabled = True
        Form1.HideManager.Enabled = True
        Form1.send.Enabled = True
        Form1.EventList.AddItem (ChannelList.List(ChannelList.ListIndex) + " was opened")
        Form1.FAX1.Header = HeaderCheckBox.Value
        Form1.FAX1.SetPortCapability Form1.ActualFaxPort, PC_MAX_BAUD_SEND, Form1.BaudRate
        
        Unload DOpen
    End If
    
    If (Len(Form1.FAX1.AvailableDialogicChannels) > 0) Then
        Form1.dchannel.Enabled = True
    Else
        Form1.dchannel.Enabled = False
    End If

    Screen.MousePointer = 0
    Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
End Sub

Private Sub Form_Load()
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

