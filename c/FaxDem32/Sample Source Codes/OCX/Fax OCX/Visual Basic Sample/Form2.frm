VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form SendDlg 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Send a File"
   ClientHeight    =   3090
   ClientLeft      =   2130
   ClientTop       =   1905
   ClientWidth     =   6825
   Icon            =   "Form2.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   3090
   ScaleWidth      =   6825
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame Frame2 
      Caption         =   "Compression"
      Height          =   1335
      Left            =   3720
      TabIndex        =   17
      Top             =   1200
      Width           =   3015
      Begin VB.OptionButton Group4Button 
         Caption         =   "Group4"
         Height          =   195
         Left            =   1680
         TabIndex        =   10
         Top             =   600
         Width           =   1215
      End
      Begin VB.OptionButton Group32DButton 
         Caption         =   "Group3 2D"
         Height          =   195
         Left            =   1680
         TabIndex        =   9
         Top             =   240
         Width           =   1215
      End
      Begin VB.OptionButton ColorFaxButton 
         Caption         =   "Color Fax T.30-E"
         Height          =   195
         Left            =   120
         TabIndex        =   8
         Top             =   960
         Width           =   1575
      End
      Begin VB.OptionButton Group31DButton 
         Caption         =   "Group3 1D"
         Height          =   195
         Left            =   120
         TabIndex        =   7
         Top             =   600
         Value           =   -1  'True
         Width           =   1455
      End
      Begin VB.OptionButton NoCompressionButton 
         Caption         =   "No Compression"
         Height          =   195
         Left            =   120
         TabIndex        =   6
         Top             =   240
         Width           =   1575
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Send"
      Height          =   975
      Left            =   3720
      TabIndex        =   16
      Top             =   120
      Width           =   1815
      Begin VB.OptionButton ImmediateButton 
         Caption         =   "Immediate"
         Height          =   195
         Left            =   120
         TabIndex        =   5
         Top             =   600
         Width           =   1455
      End
      Begin VB.OptionButton QueueButton 
         Caption         =   "Queue"
         Height          =   195
         Left            =   120
         TabIndex        =   4
         Top             =   240
         Value           =   -1  'True
         Width           =   1455
      End
   End
   Begin VB.ListBox PortListBox 
      Height          =   1620
      Left            =   120
      TabIndex        =   3
      Top             =   360
      Width           =   3495
   End
   Begin VB.CommandButton CommandBrowse 
      Caption         =   "Browse"
      Height          =   330
      Left            =   5600
      TabIndex        =   2
      Top             =   2630
      Width           =   1140
   End
   Begin VB.CommandButton CommandCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   330
      Left            =   5600
      TabIndex        =   12
      Top             =   720
      Width           =   1140
   End
   Begin VB.CommandButton CommandOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   330
      Left            =   5640
      TabIndex        =   11
      Top             =   240
      Width           =   1140
   End
   Begin VB.TextBox EdFileName 
      Height          =   300
      Left            =   1320
      MaxLength       =   255
      TabIndex        =   1
      Top             =   2640
      Width           =   4215
   End
   Begin VB.TextBox EdPhoneNumber 
      Height          =   300
      Left            =   1320
      MaxLength       =   32
      TabIndex        =   0
      Top             =   2200
      Width           =   2295
   End
   Begin MSComDlg.CommonDialog BrowseDialog 
      Left            =   6000
      Top             =   2040
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Label Label2 
      Caption         =   "Fax Ports:"
      Height          =   255
      Left            =   120
      TabIndex        =   15
      Top             =   120
      Width           =   855
   End
   Begin VB.Label Label3 
      Caption         =   "File To Send:"
      Height          =   255
      Left            =   120
      TabIndex        =   14
      Top             =   2680
      Width           =   1215
   End
   Begin VB.Label Label1 
      Caption         =   "Fax Number:"
      Height          =   255
      Left            =   120
      TabIndex        =   13
      Top             =   2240
      Width           =   1095
   End
End
Attribute VB_Name = "SendDlg"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Private Sub CommandBrowse_Click()
    Dim szFilter$

    szFilter = "Bitmap Format (*.bmp)" + "|" + "*.bmp" + "|"
    szFilter = szFilter + "TIFF File Format (*.tif)" + "|" + "*.tif" + "|"
    szFilter = szFilter + "JPEG Format (*.jpg)" + "|" + "*.jpg" + "|"
    szFilter = szFilter + "ASCII Text Files (*.txt)" + "|" + "*.txt" + "|"
    szFilter = szFilter + "All Files(*.*)" + "|" + "*.*"
    BrowseDialog.FileName = ""
    BrowseDialog.Filter = szFilter
    BrowseDialog.FilterIndex = 7
    BrowseDialog.Flags = cdlOFNFileMustExist + cdlOFNPathMustExist
    BrowseDialog.ShowOpen
    
    If BrowseDialog.FileName <> "" Then
        EdFileName.Text = BrowseDialog.FileName
    End If
End Sub

Private Sub CommandCancel_Click()
    Unload SendDlg
End Sub

Private Sub CommandOK_Click()
    Static FaxID As Long
    Static back, back2 As Long
    Static errStr As String
    Static PageNum As Long
    Static i As Long
    Static bError As Boolean
    Static FileName As String
    Dim ext As String
    Dim PhoneNum As String
    Dim actualchar As Byte
    If (Len(EdPhoneNumber.Text) = 0) Then
        MsgBox ("You must specify the phone number.")
        EdPhoneNumber.SetFocus
        Exit Sub
    End If
    
    FileName = UCase(EdFileName.Text)
    If Len(FileName) >= 3 Then
        Dim pos
        pos = InStr(FileName, ".")
        If pos <> 0 Then
            ext = Right(FileName, Len(FileName) - pos)
        End If
        Else: ext = ""
    End If
    Dim checkFile As String
    If Len(ext) <> 0 And ext <> "   " Then
         checkFile = DIR(FileName)
        Else: checkFile = ""
    End If
    If checkFile = "" And FileName <> "TEST.TIF" Then
        MsgBox ("You must specify an existing file to send.")
        EdFileName.SetFocus
        EdFileName.SelStart = 0
        EdFileName.SelLength = Len(EdFileName.Text)
        Exit Sub
    End If
    
    If ext = "TIF" Then
        PageNum = Form1.FAX1.GetNumberOfImages(EdFileName.Text, PAGE_FILE_TIFF_G31D)
    Else
        PageNum = 1
    End If
    
    Form1.FAX1.PageFileName = EdFileName.Text
    
    If Form1.FAX1.IsDemoVersion() And (PageNum > 1) Then
        MsgBox "The DEMO version of the Fax OCX supports only 1 page faxes. ONLY the first page will be sent.", vbOKOnly + vbInformation
        PageNum = 1
    End If
    
    Dim compression As Integer
    If NoCompressionButton.Value = True Then
            compression = 4
        ElseIf Group31DButton.Value = True Or ColorFaxButton.Value = True Then
            compression = 2
        ElseIf Group32DButton.Value = True Then
            compression = 3
        ElseIf Group4Button.Value = True Then
            compression = 5
        Else: compression = 2
    End If
    
    Dim ftype, colorfax As Byte
    If ColorFaxButton.Value = True Then
        ftype = 2
        colorfax = 3
        If Form1.EnableBFT = 3 Then
           Form1.EnableBFT = 2
        End If
    Else
        colorfax = 2
        If Form1.EnableBFT = 3 Then
            ftype = 2
        Else: ftype = 1
        End If
    End If
    
    If PageNum > 0 Then
        FaxID = Form1.FAX1.CreateFaxObject(ftype, PageNum, 3, 2, 1, compression, Form1.EnableBFT, Form1.EnableECM, 2, 1)
        If (FaxID = 0) Then
            errStr = "Can't create fax object ! Error code : " + Str(Form1.FAX1.FaxError)
            back = MsgBox(errStr, vbOKOnly)
        Else
            back = Form1.FAX1.SetFaxParam(FaxID, FP_SEND, PageNum)
            back = Form1.FAX1.SetPhoneNumber(FaxID, EdPhoneNumber.Text)
            bError = False
            For i = 1 To PageNum
                If (Form1.FAX1.SetFaxPage(FaxID, i, PAGE_FILE_UNKNOWN, i)) Then
                    errStr = "Can't set fax page ! Error code : " + Str(Form1.FAX1.FaxError)
                    back = MsgBox(errStr, vbOKOnly)
                    bError = True
                    Exit For
                End If
            Next
           
            If bError <> True Then
                If ImmediateButton.Value = True Then
                    back = Form1.FAX1.SendNow(PortListBox.List(PortListBox.ListIndex), FaxID)
                ElseIf QueueButton.Value = True Then
                    back2 = Form1.FAX1.SendFaxObj(FaxID)
                End If
                If (back2) Then
                    Form1.FAX1.ClearFaxObject (FaxID)
                    errStr = "Can't send fax ! Error code : " + Str(back)
                    back = MsgBox(errStr, vbOKOnly)
                End If
            End If
        End If
    End If
    Unload SendDlg
End Sub

Private Sub EdPhoneNumber_KeyPress(KeyAscii As Integer)
    
    If (KeyAscii < 48 Or KeyAscii > 57) And Not KeyAscii = 8 And Not KeyAscii = 44 Then
        KeyAscii = 0
    End If

End Sub

Private Sub Form_Load()
    Dim j As Integer
    Dim t1, t2 As String
    Dim flag As Boolean
    
    
    
    t1 = Form1.FAX1.PortsOpen
    If (Len(t1) > 0) Then
        flag = True
        While flag
            j = InStr(1, t1, " ", 0)
            If (j = 0) Then
                t2 = t1
                flag = False
            Else
                t2 = Left(t1, j - 1)
                t1 = Right(t1, Len(t1) - j)
            End If
            PortListBox.AddItem (t2)
        Wend
    End If
    
    t1 = Form1.FAX1.BrooktroutChannelsOpen
        If (Len(t1) > 0) Then
        flag = True
        While flag
            j = InStr(1, t1, " ", 0)
            If (j = 0) Then
                t2 = t1
                flag = False
            Else
                t2 = Left(t1, j - 1)
                t1 = Right(t1, Len(t1) - j)
            End If
            PortListBox.AddItem (t2)
        Wend
    End If

        t1 = Form1.FAX1.GammaChannelsOpen
        If (Len(t1) > 0) Then
        flag = True
        While flag
            j = InStr(1, t1, " ", 0)
            If (j = 0) Then
                t2 = t1
                flag = False
            Else
                t2 = Left(t1, j - 1)
                t1 = Right(t1, Len(t1) - j)
            End If
            PortListBox.AddItem (t2)
        Wend
    End If

        t1 = Form1.FAX1.DialogicChannelsOpen
        If (Len(t1) > 0) Then
        flag = True
        While flag
            j = InStr(1, t1, " ", 0)
            If (j = 0) Then
                t2 = t1
                flag = False
            Else
                t2 = Left(t1, j - 1)
                t1 = Right(t1, Len(t1) - j)
            End If
            PortListBox.AddItem (t2)
        Wend
    End If

        t1 = Form1.FAX1.NMSChannelsOpen
        If (Len(t1) > 0) Then
        flag = True
        While flag
            j = InStr(1, t1, " ", 0)
            If (j = 0) Then
                t2 = t1
                flag = False
            Else
                t2 = Left(t1, j - 1)
                t1 = Right(t1, Len(t1) - j)
            End If
            PortListBox.AddItem (t2)
        Wend
    End If
    EdFileName.Text = "Test.tif"
    PortListBox.ListIndex = 0
End Sub

