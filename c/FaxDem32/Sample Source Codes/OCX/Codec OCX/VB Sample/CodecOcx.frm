VERSION 5.00
Object = "{DE55E915-F7B1-11D4-B2EF-0040053DA77D}#1.0#0"; "CodecOCX.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form CodecOCX 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "CodecOCX voice conversion sample"
   ClientHeight    =   5580
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6945
   Icon            =   "CodecOcx.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5580
   ScaleWidth      =   6945
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.OptionButton PCM82PCM11 
      Caption         =   "PCM 8 KHh to PCM 11 KHz"
      Height          =   255
      Index           =   0
      Left            =   240
      TabIndex        =   21
      Top             =   2520
      Width           =   2535
   End
   Begin VB.OptionButton PCM112PCM8 
      Caption         =   "PCM 11 KHz to PCM 8 KHz"
      Height          =   255
      Index           =   0
      Left            =   240
      TabIndex        =   20
      Top             =   2760
      Width           =   2535
   End
   Begin VB.Frame MsgFrame 
      Caption         =   "Messages:"
      Height          =   1455
      Left            =   120
      TabIndex        =   17
      Top             =   3480
      Width           =   6735
      Begin VB.ListBox Messages 
         Height          =   1035
         Left            =   120
         TabIndex        =   18
         Top             =   240
         Width           =   6495
      End
   End
   Begin MSComDlg.CommonDialog CMDialog1 
      Left            =   6360
      Top             =   5040
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton START 
      Caption         =   "&Start conversion"
      Height          =   375
      Left            =   2520
      TabIndex        =   16
      Top             =   5040
      Width           =   2055
   End
   Begin VB.Frame CONVMODE 
      Caption         =   "Conversion mode:"
      Height          =   615
      Left            =   3240
      TabIndex        =   13
      Top             =   1920
      Width           =   3615
      Begin VB.OptionButton ASYNC 
         Caption         =   "Asynchronous"
         Height          =   255
         Index           =   1
         Left            =   2040
         TabIndex        =   15
         Top             =   240
         Width           =   1455
      End
      Begin VB.OptionButton SYNC 
         Caption         =   "Synchronous"
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   14
         Top             =   240
         Value           =   -1  'True
         Width           =   1575
      End
   End
   Begin VB.Frame DESTFILE 
      Caption         =   "Destination file name:"
      Height          =   735
      Left            =   3240
      TabIndex        =   10
      Top             =   960
      Width           =   3615
      Begin VB.CommandButton BROWSEDEST 
         Caption         =   "&Browse"
         Height          =   375
         Left            =   2520
         TabIndex        =   12
         Top             =   240
         Width           =   975
      End
      Begin VB.TextBox EDITDESTFILE 
         Height          =   375
         Left            =   120
         TabIndex        =   11
         Top             =   240
         Width           =   2295
      End
   End
   Begin VB.TextBox EDITFILEFROM 
      Height          =   375
      Left            =   3360
      TabIndex        =   7
      Top             =   360
      Width           =   2295
   End
   Begin VB.OptionButton WAV2VOC 
      Caption         =   "WAV to VOC"
      Height          =   255
      Index           =   0
      Left            =   240
      TabIndex        =   1
      Top             =   360
      Value           =   -1  'True
      Width           =   2175
   End
   Begin VB.OptionButton DIALOGIC2WAV 
      Caption         =   "Dialogic ADPCM to WAV"
      Height          =   255
      Index           =   5
      Left            =   240
      TabIndex        =   6
      Top             =   2040
      Width           =   2175
   End
   Begin VB.OptionButton WAV2DIALOGIC 
      Caption         =   "WAV to Dialogic ADPCM"
      Height          =   255
      Index           =   4
      Left            =   240
      TabIndex        =   5
      Top             =   1800
      Width           =   2175
   End
   Begin VB.OptionButton IMAADPCM2WAV 
      Caption         =   "IMA ADPCM to WAV"
      Height          =   255
      Index           =   3
      Left            =   240
      TabIndex        =   4
      Top             =   1320
      Width           =   2175
   End
   Begin VB.OptionButton WAV2IMAADPCM 
      Caption         =   "Wav to IMA ADPCM"
      Height          =   255
      Index           =   2
      Left            =   240
      TabIndex        =   3
      Top             =   1080
      Width           =   2175
   End
   Begin VB.OptionButton VOC2WAV 
      Caption         =   "VOC to WAV"
      Height          =   255
      Index           =   1
      Left            =   240
      TabIndex        =   2
      Top             =   600
      Width           =   2175
   End
   Begin VB.Frame Convert 
      Caption         =   "Convert:"
      Height          =   3135
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   2895
   End
   Begin VB.Frame FILEFROM 
      Caption         =   "Source file name:"
      Height          =   735
      Left            =   3240
      TabIndex        =   8
      Top             =   120
      Width           =   3615
      Begin VB.CommandButton BROWSEFROM 
         Caption         =   "&Browse"
         Height          =   375
         Left            =   2520
         TabIndex        =   9
         Top             =   240
         Width           =   975
      End
   End
   Begin CODECOCXLib.CodecOCX CodecOCX1 
      Height          =   240
      Left            =   120
      TabIndex        =   19
      Top             =   5040
      Visible         =   0   'False
      Width           =   240
      _Version        =   65536
      _ExtentX        =   423
      _ExtentY        =   423
      _StockProps     =   0
   End
End
Attribute VB_Name = "CodecOCX"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim iFormat As Long
Dim bSynch As Boolean
Private Sub AddMessage(Text As String)
    Messages.AddItem (Text)
    Messages.ListIndex = Messages.ListCount - 1
End Sub

Private Sub BROWSEDEST_Click()
    Dim szFilter$
    szFilter = "All files(*.*)|*.*|"
        
    CMDialog1.Filter = szFilter
    CMDialog1.FilterIndex = nIndex
    CMDialog1.Flags = cdlOFNOverwritePrompt + cdlOFNHideReadOnly + cdlOFNPathMustExist
    CMDialog1.CancelError = True
    CMDialog1.ShowSave
    
    If CMDialog1.FileName <> "" Then
        EDITDESTFILE.Text = CMDialog1.FileName
    End If
End Sub

Private Sub BROWSEFROM_Click()
    Dim szFilter$
    szFilter = "All files(*.*)|*.*|"
    CMDialog1.FileName = ""
    CMDialog1.Filter = szFilter
    CMDialog1.FilterIndex = 0
    CMDialog1.Flags = cdlOFNHideReadOnly + cdlOFNFileMustExist + cdlOFNPathMustExist
    CMDialog1.CancelError = False
    CMDialog1.ShowOpen
    
    If CMDialog1.FileName <> "" Then
        EDITFILEFROM.Text = CMDialog1.FileName
    End If
End Sub

Private Sub CodecOCX1_ConversionFinished(ByVal ConversionID As Long)
    AddMessage ("Conversion finished! Conversion ID:" + Str(ConversionID))
End Sub

Private Sub CodecOCX1_ConversionStarted(ByVal ConversionID As Long)
   AddMessage ("Conversion was started! Conversion ID:" + Str(ConversionID))
End Sub

Private Sub Form_Load()
    bSynch = True
    iFormat = 0
End Sub


Private Sub PCM112PCM8_Click(Index As Integer)
    AddMessage "PCM 11 KHz to PCM 8 KHz conversion was selected"
    iFormat = 6

End Sub

Private Sub PCM82PCM11_Click(Index As Integer)
    AddMessage "PCM 8 KHz to PCM 11 KHz conversion was selected"
    iFormat = 7

End Sub

Private Sub START_Click()
    Dim ret As Long
    If EDITFILEFROM.Text = "" Then
        AddMessage "No source file was selected!"
        Exit Sub
    End If
    If EDITDESTFILE.Text = "" Then
        AddMessage "No destination file was selected!"
        Exit Sub
    End If
    Select Case iFormat
        Case 0
            AddMessage "Converting WAV to VOC... "
            ret = CodecOCX1.ConvertWAVToVOC(EDITFILEFROM.Text, EDITDESTFILE.Text, bSynch)
        Case 1
            AddMessage "Converting VOC to WAV... "
            ret = CodecOCX1.ConvertVOCToWAV(EDITFILEFROM.Text, EDITDESTFILE.Text, bSynch)
        Case 2
            AddMessage "Converting WAV to IMA ADPCM... "
            ret = CodecOCX1.ConvertWAVToIMAADPCM(EDITFILEFROM.Text, EDITDESTFILE.Text, bSynch)
        Case 3
            AddMessage "Converting IMA ADPCM To WAV... "
            ret = CodecOCX1.ConvertIMAADPCMToWAV(EDITFILEFROM.Text, EDITDESTFILE.Text, bSynch)
        Case 4
            AddMessage "Converting WAV To Dialogic ADPCM... "
            ret = CodecOCX1.ConvertWAVToDialogicADPCM(EDITFILEFROM.Text, EDITDESTFILE.Text, bSynch)
        Case 5
            AddMessage "Converting Dialogic ADPCM To WAV... "
            ret = CodecOCX1.ConvertDialogicADPCMToWAV(EDITFILEFROM.Text, EDITDESTFILE.Text, bSynch)
        Case 6
            AddMessage "Converting PCM 11 KHz To PCM 8 KHz... "
            ret = CodecOCX1.ConvertPCM11ToPCM8(EDITFILEFROM.Text, EDITDESTFILE.Text, bSynch)
        Case 7
            AddMessage "Converting PCM 8 KHz To PCM 11 KHz... "
            ret = CodecOCX1.ConvertPCM8ToPCM11(EDITFILEFROM.Text, EDITDESTFILE.Text, bSynch)
        End Select
       
    If bSynch Then
        If ret = 0 Then
            AddMessage "Conversion failed!"
        Else
            AddMessage "Conversion finished successfully!"
        End If
    Else
        If ret <> 0 Then
            AddMessage ("Conversion job has been created! Conversion ID:" + Str(ret))
        Else
            AddMessage "Conversion failed!"
        End If
    End If
End Sub
Private Sub ASYNC_Click(Index As Integer)
    bSynch = False
End Sub
Private Sub SYNC_Click(Index As Integer)
    bSynch = True
End Sub


Private Sub WAV2VOC_Click(Index As Integer)
    AddMessage "WAV to VOC conversion was selected"
    iFormat = 0
End Sub
Private Sub VOC2WAV_Click(Index As Integer)
    AddMessage "VOC to WAV conversion was selected"
    iFormat = 1
End Sub
Private Sub WAV2IMAADPCM_Click(Index As Integer)
    AddMessage "WAV to IMA ADPCM conversion was selected"
    iFormat = 2
End Sub
Private Sub IMAADPCM2WAV_Click(Index As Integer)
    AddMessage "IMA ADPCM to WAV conversion was selected"
    iFormat = 3
End Sub
Private Sub WAV2DIALOGIC_Click(Index As Integer)
    AddMessage "WAV to DIALOGIC ADPCM conversion was selected"
    iFormat = 4
End Sub
Private Sub DIALOGIC2WAV_Click(Index As Integer)
    AddMessage "DIALOGIC ADPCM to WAV conversion was selected"
    iFormat = 5
End Sub
