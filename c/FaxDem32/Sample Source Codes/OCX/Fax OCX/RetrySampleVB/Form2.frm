VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form SendDlg 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Send a File"
   ClientHeight    =   2685
   ClientLeft      =   2130
   ClientTop       =   1905
   ClientWidth     =   5745
   Icon            =   "Form2.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   2685
   ScaleWidth      =   5745
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame Frame1 
      Caption         =   "Send"
      Height          =   1335
      Left            =   4320
      TabIndex        =   8
      Top             =   270
      Width           =   1335
      Begin VB.OptionButton ImmediateButton 
         Caption         =   "Immediate"
         Height          =   195
         Left            =   120
         TabIndex        =   2
         Top             =   600
         Width           =   1095
      End
      Begin VB.OptionButton QueueButton 
         Caption         =   "Queue"
         Height          =   195
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Value           =   -1  'True
         Width           =   975
      End
   End
   Begin VB.ListBox PortListBox 
      Height          =   840
      Left            =   120
      TabIndex        =   0
      Top             =   360
      Width           =   4095
   End
   Begin VB.CommandButton CommandBrowse 
      Caption         =   "Browse"
      Height          =   330
      Left            =   4320
      TabIndex        =   5
      Top             =   1800
      Width           =   1140
   End
   Begin VB.CommandButton CommandCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   330
      Left            =   3080
      TabIndex        =   7
      Top             =   2280
      Width           =   1140
   End
   Begin VB.CommandButton CommandOK 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   330
      Left            =   1680
      TabIndex        =   6
      Top             =   2280
      Width           =   1140
   End
   Begin VB.TextBox EdFileName 
      Height          =   300
      Left            =   1200
      MaxLength       =   255
      TabIndex        =   4
      Top             =   1800
      Width           =   3015
   End
   Begin VB.TextBox EdPhoneNumber 
      Height          =   300
      Left            =   1200
      MaxLength       =   32
      TabIndex        =   3
      Top             =   1320
      Width           =   3015
   End
   Begin MSComDlg.CommonDialog BrowseDialog 
      Left            =   4560
      Top             =   2160
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Label Label2 
      Caption         =   "Fax Ports:"
      Height          =   255
      Left            =   120
      TabIndex        =   11
      Top             =   120
      Width           =   855
   End
   Begin VB.Label Label3 
      Caption         =   "File To Send:"
      Height          =   255
      Left            =   120
      TabIndex        =   10
      Top             =   1800
      Width           =   1215
   End
   Begin VB.Label Label1 
      Caption         =   "Fax Number:"
      Height          =   255
      Left            =   120
      TabIndex        =   9
      Top             =   1320
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
    Dim port As String
    port = PortListBox.List(PortListBox.ListIndex)
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
        MsgBox ("Please select a TIFF file!")
        EdFileName.SetFocus
        EdFileName.SelStart = 0
        EdFileName.SelLength = Len(EdFileName.Text)
        Exit Sub
    End If
    
    Form1.FAX1.PageFileName = EdFileName.Text
    
    If Form1.FAX1.IsDemoVersion() And (PageNum > 1) Then
        MsgBox "The DEMO version of the Fax OCX supports only 1 page faxes. ONLY the first page will be sent.", vbOKOnly + vbInformation
        PageNum = 1
    End If
         
    If PageNum > 0 Then
        FaxID = Form1.FAX1.CreateFaxObject(1, PageNum, 3, 2, 1, 2, 2, 3, 2, 1)
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
                back = 0
                back2 = 0
                If ImmediateButton.Value = True Then
                    back = Form1.FAX1.SendNow(PortListBox.List(PortListBox.ListIndex), FaxID)
                    If (back) Then
                        Form1.FAX1.ClearFaxObject (FaxID)
                        errStr = "Can't send fax ! Error code : " + Str(back)
                        back = MsgBox(errStr, vbOKOnly)
                    End If
                ElseIf QueueButton.Value = True Then
                    back2 = Form1.FAX1.SendFaxObj(FaxID)
                    If (back2) Then
                        Form1.FAX1.ClearFaxObject (FaxID)
                        errStr = "Can't send fax ! Error code : " + Str(back)
                        back = MsgBox(errStr, vbOKOnly)
                    End If
                    
                    
                        
                End If
            End If
        End If
    End If
    Unload SendDlg
End Sub

Private Sub EdPhoneNumber_KeyPress(KeyAscii As Integer)
    
    If (KeyAscii < 48 Or KeyAscii > 57) And Not KeyAscii = 8 Then
        KeyAscii = 0
    End If

End Sub

Private Sub Form_Activate()
    EdPhoneNumber.SetFocus
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
    
    EdFileName.Text = "Test.tif"
    PortListBox.ListIndex = 0
End Sub

