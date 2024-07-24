VERSION 5.00
Begin VB.Form COMClose 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Close Fax Channel"
   ClientHeight    =   2070
   ClientLeft      =   2520
   ClientTop       =   2550
   ClientWidth     =   3615
   Icon            =   "Form5.frx":0000
   LinkTopic       =   "Form5"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   2070
   ScaleWidth      =   3615
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.ListBox PortList 
      Height          =   1035
      Left            =   120
      TabIndex        =   0
      Top             =   360
      Width           =   3285
   End
   Begin VB.CommandButton CommandOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   350
      Left            =   480
      TabIndex        =   1
      Top             =   1560
      Width           =   1125
   End
   Begin VB.CommandButton CommandCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   350
      Left            =   1800
      TabIndex        =   2
      Top             =   1560
      Width           =   1125
   End
   Begin VB.Label Label1 
      Caption         =   "Fax Ports:"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   1215
   End
End
Attribute VB_Name = "COMClose"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub CommandCancel_Click()
    Unload COMClose
End Sub


Private Sub CommandOK_Click()

    Screen.MousePointer = 11
    
    If (Not Form1.FAX1.ClosePort(PortList.List(PortList.ListIndex))) Then
        If (PortList.ListCount = 1) Then
            Form1.ClosePort.Enabled = False
        End If
    End If
    
    Form1.EventList.AddItem (PortList.List(PortList.ListIndex) + " was closed")
        
    If (Len(Form1.FAX1.AvailableBrooktroutChannels) > 0) Then
        Form1.bchannel.Enabled = True
    End If
    
    If (Len(Form1.FAX1.AvailableDialogicChannels) > 0) Then
        Form1.dchannel.Enabled = True
    End If
    If (Len(Form1.FAX1.AvailableGammaChannels) > 0) Then
        Form1.gchannel.Enabled = True
    End If
    If (Len(Form1.FAX1.AvailableNMSChannels) > 0) Then
        Form1.nmschannel.Enabled = True
    End If

    Unload COMClose
    Screen.MousePointer = 0
    Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
End Sub

Private Sub Form_Load()
    Static t1, t2 As String
    Static flag As Boolean
    Static i As Integer
    
    t1 = Form1.FAX1.BrooktroutChannelsOpen
    flag = True
    i = 1
    If (Len(t1) > 0) Then
        While flag
            j = InStr(1, t1, " ", 0)
            If (j = 0) Then
                t2 = t1
                flag = False
            Else
                t2 = Left(t1, j - 1)
                t1 = Right(t1, Len(t1) - j)
            End If
            PortList.AddItem (t2)
        Wend
    End If

    t1 = Form1.FAX1.GammaChannelsOpen
    flag = True
    i = 1
    If (Len(t1) > 0) Then
        While flag
            j = InStr(1, t1, " ", 0)
            If (j = 0) Then
                t2 = t1
                flag = False
            Else
                t2 = Left(t1, j - 1)
                t1 = Right(t1, Len(t1) - j)
            End If
            PortList.AddItem (t2)
        Wend
    End If

t1 = Form1.FAX1.DialogicChannelsOpen
    flag = True
    i = 1
    If (Len(t1) > 0) Then
        While flag
            j = InStr(1, t1, " ", 0)
            If (j = 0) Then
                t2 = t1
                flag = False
            Else
                t2 = Left(t1, j - 1)
                t1 = Right(t1, Len(t1) - j)
            End If
            PortList.AddItem (t2)
        Wend
    End If
t1 = Form1.FAX1.NMSChannelsOpen
    flag = True
    i = 1
    If (Len(t1) > 0) Then
        While flag
            j = InStr(1, t1, " ", 0)
            If (j = 0) Then
                t2 = t1
                flag = False
            Else
                t2 = Left(t1, j - 1)
                t1 = Right(t1, Len(t1) - j)
            End If
            PortList.AddItem (t2)
        Wend
    End If

        PortList.ListIndex = 0

End Sub

