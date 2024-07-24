VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form GOpen 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Open GammaLink channel"
   ClientHeight    =   2745
   ClientLeft      =   5850
   ClientTop       =   3225
   ClientWidth     =   4470
   Icon            =   "GOpen.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   2745
   ScaleWidth      =   4470
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox CFile 
      Height          =   315
      Left            =   960
      MaxLength       =   255
      TabIndex        =   1
      Top             =   1920
      Width           =   3375
   End
   Begin MSComDlg.CommonDialog BrowseDialog 
      Left            =   3480
      Top             =   1320
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton CommandBrowse 
      Caption         =   "&Browse"
      Height          =   375
      Left            =   3240
      TabIndex        =   2
      Top             =   2300
      Width           =   1095
   End
   Begin VB.Frame Frame1 
      Caption         =   "Available Channels:"
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
   Begin VB.CommandButton CommandCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   380
      Left            =   3240
      TabIndex        =   4
      Top             =   840
      Width           =   1125
   End
   Begin VB.CommandButton CommandOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   380
      Left            =   3240
      TabIndex        =   3
      Top             =   360
      Width           =   1125
   End
   Begin VB.Label Label1 
      Caption         =   "Local ID:"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   3
      Width           =   855
   End
   Begin VB.Label Label2 
      Caption         =   "Config File:"
      Height          =   195
      Left            =   120
      TabIndex        =   5
      Top             =   1970
      Width           =   975
   End
End
Attribute VB_Name = "GOpen"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()

End Sub

Private Sub CommandBrowse_Click()
    Dim szFilter$

    szFilter = szFilter + "config files (*.cfg)" + "|" + "*.cfg" + "|"
    szFilter = szFilter + "All files(*.*)" + "|" + "*.*"
    BrowseDialog.FileName = ""
    BrowseDialog.Filter = szFilter
    BrowseDialog.FilterIndex = 0
 
    BrowseDialog.Flags = cdlOFNFileMustExist + cdlOFNPathMustExist
    BrowseDialog.ShowOpen

    If BrowseDialog.FileName <> "" Then
        CFile.Text = BrowseDialog.FileName
    End If

End Sub

Private Sub CommandCancel_Click()
    Unload GOpen
End Sub

Private Sub CommandOK_Click()
    Static errcode As Long
    Static i As Integer

    Screen.MousePointer = 11
    Form1.FAX1.GammaCFile = CFile.Text
    Form1.FAX1.OpenPort ChannelList.List(ChannelList.ListIndex)
    errcode = Form1.FAX1.FaxError
    If (errcode <> 0) Then
         i = MsgBox(Form1.Errors(errcode), 0)
         Screen.MousePointer = 0
         Exit Sub
    Else
        Form1.closeport.Enabled = True
        Form1.EventList.AddItem (ChannelList.List(ChannelList.ListIndex) + " was opened")
    End If
    
    If (Len(Form1.FAX1.AvailableGammaChannels) > 0) Then
        Form1.gchannel.Enabled = True
    Else
        Form1.gchannel.Enabled = False
    End If

    Screen.MousePointer = 0
    Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
    Unload GOpen
End Sub


Private Sub Form_Load()
    Static t1, t2 As String
    Static flag As Boolean
    Static i, j As Integer

    CFile.Text = Form1.FAX1.GammaCFile
    t1 = Form1.FAX1.AvailableGammaChannels
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
    
End Sub
