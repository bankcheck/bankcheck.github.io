VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form BrooktroutOpen 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Open Brooktrout channel"
   ClientHeight    =   2970
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3960
   Icon            =   "BrooktroutInit.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2970
   ScaleWidth      =   3960
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin MSComDlg.CommonDialog BrowseDialog 
      Left            =   3360
      Top             =   1320
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton CommandBrowse 
      Caption         =   "&Browse"
      Height          =   375
      Left            =   2640
      TabIndex        =   1
      Top             =   2430
      Width           =   1095
   End
   Begin VB.TextBox ConfigFileEdit 
      Height          =   315
      Left            =   1320
      MaxLength       =   255
      TabIndex        =   0
      Top             =   2040
      Width           =   2415
   End
   Begin VB.CommandButton CommandCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   375
      Left            =   2760
      TabIndex        =   4
      Top             =   720
      Width           =   1095
   End
   Begin VB.CommandButton CommandOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   2760
      TabIndex        =   3
      Top             =   240
      Width           =   1095
   End
   Begin VB.Frame BrooktroutChannelsFrame 
      Caption         =   "Available Channels"
      Height          =   1575
      Left            =   120
      TabIndex        =   7
      Top             =   120
      Width           =   2415
      Begin VB.ListBox BrooktroutChannelsListBox 
         Height          =   1230
         ItemData        =   "BrooktroutInit.frx":000C
         Left            =   120
         List            =   "BrooktroutInit.frx":000E
         TabIndex        =   5
         Top             =   240
         Width           =   2175
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Channel settings"
      Height          =   1095
      Left            =   120
      TabIndex        =   6
      Top             =   1800
      Width           =   3760
      Begin VB.TextBox DTMFBrook 
         Height          =   315
         Left            =   1200
         MaxLength       =   1
         TabIndex        =   2
         Text            =   "4"
         Top             =   650
         Width           =   255
      End
      Begin VB.Label Label1 
         Caption         =   "DTMF Digits:"
         Height          =   255
         Left            =   120
         TabIndex        =   9
         Top             =   680
         Width           =   975
      End
      Begin VB.Label Label3 
         Caption         =   "Config file:"
         Height          =   255
         Left            =   120
         TabIndex        =   8
         Top             =   280
         Width           =   855
      End
   End
End
Attribute VB_Name = "BrooktroutOpen"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub CommandBrowse_Click()
    Dim szFilter$

    szFilter = szFilter + "Config files (*.cfg)" + "|" + "*.cfg" + "|"
    szFilter = szFilter + "All files(*.*)" + "|" + "*.*"
    BrowseDialog.FileName = ""
    BrowseDialog.Filter = szFilter
    BrowseDialog.FilterIndex = 0
 
    BrowseDialog.Flags = cdlOFNFileMustExist + cdlOFNPathMustExist
    BrowseDialog.ShowOpen

    If BrowseDialog.FileName <> "" Then
        ConfigFileEdit.Text = BrowseDialog.FileName
    End If
    
End Sub

Private Sub CommandCancel_Click()
Unload BrooktroutOpen
End Sub

Private Sub CommandOK_Click()
    Static errcode As Long
    Static i As Integer

    Form1.FAX1.BrooktroutCFile = ConfigFileEdit.Text
    If (Len(DTMFBrook.Text) = 0) Then
        MsgBox ("You must specify the number of the DTMF digits!")
        DTMFBrook.SetFocus
        Exit Sub
    End If
    Screen.MousePointer = 11
    errcode = Form1.FAX1.OpenPort(BrooktroutChannelsListBox.List(BrooktroutChannelsListBox.ListIndex))
    If (errcode) Then
        i = MsgBox(Form1.Errors(errcode), 0)
        Screen.MousePointer = 0
        Exit Sub
    Else
        Form1.FAX1.RecvDTMF BrooktroutChannelsListBox.List(BrooktroutChannelsListBox.ListIndex), CInt(DTMFBrook.Text), 20
        Form1.ClosePort.Enabled = True
        Form1.EventList.AddItem (BrooktroutChannelsListBox.List(BrooktroutChannelsListBox.ListIndex) + " was opened")
        Form1.FAX1.SetPortCapability BrooktroutChannelsListBox.List(BrooktroutChannelsListBox.ListIndex), PC_MAX_BAUD_SEND, BR_33600
    End If

    If (Len(Form1.FAX1.AvailableBrooktroutChannels) > 0) Then
        Form1.bchannel.Enabled = True
    Else
        Form1.bchannel.Enabled = False
    End If
    Screen.MousePointer = 0
    Unload BrooktroutOpen
    Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
End Sub
Private Sub DTMFBrook_KeyPress(KeyAscii As Integer)
    If (KeyAscii < 48 Or KeyAscii > 57) And Not KeyAscii = 8 Then
        KeyAscii = 0
    End If
End Sub

Private Sub Form_Load()
    Static t1, t2 As String
    Static flag As Boolean
    Static i, j As Integer
    
    t1 = Form1.FAX1.AvailableBrooktroutChannels
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
        BrooktroutChannelsListBox.AddItem (t2)
    Wend
    
    BrooktroutChannelsListBox.ListIndex = 0
    ConfigFileEdit.Text = Form1.FAX1.BrooktroutCFile
    
End Sub
