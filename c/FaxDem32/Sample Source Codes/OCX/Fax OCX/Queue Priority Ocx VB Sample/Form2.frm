VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form SendDlg 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Send a File"
   ClientHeight    =   2745
   ClientLeft      =   2130
   ClientTop       =   1905
   ClientWidth     =   3960
   Icon            =   "Form2.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   2745
   ScaleWidth      =   3960
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.ListBox PortListBox 
      Height          =   840
      Left            =   120
      TabIndex        =   0
      Top             =   360
      Width           =   3735
   End
   Begin VB.CommandButton CommandBrowse 
      Caption         =   "&Browse"
      Height          =   330
      Left            =   2730
      TabIndex        =   3
      Top             =   2280
      Width           =   1140
   End
   Begin VB.CommandButton CommandCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   330
      Left            =   1420
      TabIndex        =   5
      Top             =   2280
      Width           =   1140
   End
   Begin VB.CommandButton CommandOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   330
      Left            =   120
      TabIndex        =   4
      Top             =   2280
      Width           =   1140
   End
   Begin VB.TextBox EdFileName 
      Height          =   300
      Left            =   1200
      MaxLength       =   255
      TabIndex        =   2
      Top             =   1800
      Width           =   2655
   End
   Begin VB.TextBox EdPhoneNumber 
      Height          =   300
      Left            =   1200
      MaxLength       =   32
      TabIndex        =   1
      Top             =   1365
      Width           =   2655
   End
   Begin MSComDlg.CommonDialog BrowseDialog 
      Left            =   3360
      Top             =   1800
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Label Label2 
      Caption         =   "Fax Ports:"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   120
      Width           =   855
   End
   Begin VB.Label Label3 
      Caption         =   "File To Send:"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   1845
      Width           =   1215
   End
   Begin VB.Label Label1 
      Caption         =   "Fax Number:"
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   1395
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

    szFilter = "TIFF File Format (*.tif)" + "|" + "*.tif"
    BrowseDialog.FileName = ""
    BrowseDialog.Filter = szFilter
    BrowseDialog.FilterIndex = 1
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
    Dim loops, actPage As Integer
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
    If checkFile = "" Then
        MsgBox ("You must specify an existing file to send.")
        EdFileName.SetFocus
        EdFileName.SelStart = 0
        EdFileName.SelLength = Len(EdFileName.Text)
        Exit Sub
    End If
    
    If ext = "TIF" Then
        PageNum = Form1.FAX1.GetNumberOfImages(EdFileName.Text, PAGE_FILE_TIFF_G31D)
    Else
        MsgBox ("You must specify a TIFF file!")
        EdFileName.SetFocus
        EdFileName.SelStart = 0
        EdFileName.SelLength = Len(EdFileName.Text)
        Exit Sub
    End If
    
    Form1.FAX1.PageFileName = EdFileName.Text
    
    For loops = 1 To 10
    If loops = 1 Then
        actPage = PageNum
    Else
        Randomize
        actPage = Int((PageNum * Rnd) + 1)   ' Generate random value between 1 and 10.
    End If
    FaxID = Form1.FAX1.CreateFaxObject(1, 1, 3, 2, 1, 2, 2, 3, 2, 1)
    If (FaxID = 0) Then
        errStr = "Can't create fax object ! Error code : " + Str(Form1.FAX1.FaxError)
        back = MsgBox(errStr, vbOKOnly)
    Else
        Form1.FAX1.SetFaxParam FaxID, FP_SEND, 1
        Form1.FAX1.SetFaxParam FaxID, FP_PRIORITY, actPage
        Form1.FAX1.SetPhoneNumber FaxID, EdPhoneNumber.Text
        bError = False
        Form1.EventList.AddItem ("Setup page " + Str(actPage) + " for sending " + Form1.FAX1.PageFileName)
        If (Form1.FAX1.SetFaxPage(FaxID, 1, PAGE_FILE_TIFF_G31D, actPage)) Then
            errStr = "Can't set fax page ! Error code : " + Str(Form1.FAX1.FaxError)
            back = MsgBox(errStr, vbOKOnly)
            bError = True
            Exit For
        End If
        If bError <> True Then
            back2 = Form1.FAX1.SendFaxObj(FaxID)
        End If
        If (back2) Then
            Form1.FAX1.ClearFaxObject (FaxID)
            errStr = "Can't send fax ! Error code : " + Str(back)
            back = MsgBox(errStr, vbOKOnly)
        Else
            Form1.EventList.AddItem (Form1.ActualFaxPort + ": Fax has been sent to queue")
        End If
    End If
Next
    Unload SendDlg
End Sub

Private Sub EdPhoneNumber_KeyPress(KeyAscii As Integer)
    
    If (KeyAscii < 48 Or KeyAscii > 57) And Not KeyAscii = 44 Then
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
    EdFileName.Text = "Testqueue.tif"
    PortListBox.ListIndex = 0
End Sub

