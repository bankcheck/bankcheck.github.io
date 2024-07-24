VERSION 5.00
Object = "{2E980300-C865-11CF-BA24-444553540000}#4.3#0"; "fax.ocx"
Begin VB.Form Form1 
   Caption         =   " Fax ActiveX Control - Visual Basic OpenFaxBoards Sample"
   ClientHeight    =   2895
   ClientLeft      =   2340
   ClientTop       =   2160
   ClientWidth     =   5145
   Icon            =   "main.frx":0000
   LinkTopic       =   "Form1"
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   2895
   ScaleWidth      =   5145
   StartUpPosition =   2  'CenterScreen
   Begin FAXLib.FAX FAX1 
      Height          =   240
      Left            =   960
      TabIndex        =   0
      Top             =   2040
      Width           =   240
      _Version        =   262147
      _ExtentX        =   423
      _ExtentY        =   423
      _StockProps     =   0
   End
   Begin VB.ListBox EventList 
      Height          =   1020
      IntegralHeight  =   0   'False
      ItemData        =   "main.frx":0442
      Left            =   240
      List            =   "main.frx":0444
      TabIndex        =   1
      Top             =   360
      Width           =   3795
   End
   Begin VB.Menu fax 
      Caption         =   "&File"
      Begin VB.Menu mnuClear 
         Caption         =   "&Clear"
      End
      Begin VB.Menu mnuSep1 
         Caption         =   "-"
      End
      Begin VB.Menu exit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuFax 
      Caption         =   "F&ax"
      Begin VB.Menu open 
         Caption         =   "&Open"
         Begin VB.Menu bchannel 
            Caption         =   "&Brooktrout Channel..."
            Enabled         =   0   'False
         End
         Begin VB.Menu dchannel 
            Caption         =   "&Dialogic Channel..."
            Enabled         =   0   'False
         End
         Begin VB.Menu gchannel 
            Caption         =   "&GammaLink Channel..."
            Enabled         =   0   'False
         End
         Begin VB.Menu nmschannel 
            Caption         =   "NM&S Channel..."
            Enabled         =   0   'False
         End
      End
      Begin VB.Menu closeport 
         Caption         =   "&Close Channel..."
         Enabled         =   0   'False
      End
   End
   Begin VB.Menu help 
      Caption         =   "&Help"
      Begin VB.Menu about 
         Caption         =   "&About..."
      End
      Begin VB.Menu mnuOnlineHelp 
         Caption         =   "&Fax C++ OCX Help"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Declare Function ShellExecute Lib "shell32.dll" Alias _
   "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As _
   String, ByVal lpFile As String, ByVal lpParameters As String, _
   ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

Private Const WebPage = "http://www.blackice.com/Help/Tools/Fax%20OCX%20webhelp/WebHelp/Black_Ice_Fax_C___OCX_Help.htm"

Public Function Errors(errcode As Long) As String

Select Case errcode
Case FAX_ERR_SEND_FILE_NOT_EXISTS
    Errors = "The specified file doesn’t exist."

Case FAX_ERR_NO_VALID_COMMPORT
    Errors = "The specified communication port is invalid."
    
Case FAX_ERR_COMMPORT_NOT_EXISTS
    Errors = "The specified communication port doesn’t exist."

Case FAX_ERR_CANNOT_CONNECT_PORT
    Errors = "Cannot connect to the port."

Case FAX_ERR_NO_FILE_TO_SEND
    Errors = "No file was specified for sending."

Case FAX_ERR_NO_FAX_CREATED
    Errors = "The creation of the fax object failed."

Case FAX_ERR_COMMPORT_ALREADY_INITIALIZED
    Errors = "The specified communication port was already initialized."

Case FAX_ERR_MODEM_NOT_EXISTS
    Errors = "An invalid fax modem type was specified."

Case FAX_ERR_NO_PHONE_NUMBER
    Errors = "No phone number was specified for SetPhoneNumber function."

Case FAX_ERR_BAD_FAX_ID
    Errors = "Invalid fax ID was specified."

Case FAX_ERR_BAD_IMAGE_TYPE
    Errors = "Invalid image type was specified for SetFaxPage method."

Case FAX_ERR_NO_FILENAME_SPECIFIED
    Errors = "Invalid image filename was specified for SetFaxPage method."

Case FAX_ERR_BAD_ASCII_FILE
    Errors = "The attempt to open or convert the ASCII data to image was unsuccessful."

Case FAX_ERR_NO_HANDLE_SPECIFIED
    Errors = "There was no DIB handle specified before SetFaxPage method."

Case FAX_ERR_BAD_DIB_HANDLE
    Errors = "Invalid DIB handle was specified before SetFaxPage method."

Case FAX_ERR_NO_PORTS_OPEN
    Errors = "There weren’t any ports open before an operation (SendFaxObj) which needed one."

Case FAX_ERR_UNRECOGNIZED_FILEFORMAT
    Errors = "The OCX wasn’t able to recognize the format of the specified image file."

Case FAX_ERR_TEST_FAILED
    Errors = "The modem test on the specified COM port was unsuccessful."

Case FAX_ERR_BAD_FILENAME
    Errors = "Invalid filename specified."

Case FAX_ERR_B_CHANNEL_BAD_TYPE
    Errors = "The specified Brooktrout fax channel has no faxing capability."

Case FAX_ERR_NO_CONFIG_FILE
    Errors = "No configuration file was specified before opening a Brooktrout or GammaLink fax channel."

Case FAX_ERR_DEMO_VERSION_IS_SINGLEPORT
    Errors = "The DEMO version of the Fax OCX supports only 4 fax ports."

Case FAX_ERR_DEMO_VERSION_IS_SINGLEPAGE
    Errors = "The DEMO version of the Fax OCX supports only 1 page faxes."

Case Else
    Errors = Str(errorcode)

End Select

End Function


Private Sub about_Click()
    AboutDlg.Show vbModal
End Sub

Private Sub bchannel_Click()
    BrooktroutOpen.Show vbModal
End Sub

Private Sub ClosePort_Click()
    COMClose.Show vbModal
End Sub


Private Sub dchannel_Click()
    DOpen.Show vbModal
End Sub

Private Sub exit_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    Dim DIR As String

    FAX1.CloseAllPorts
    EventList.AddItem ("This sample will show how to open and close a channel.")
    EventList.AddItem ("To open a channel choose one of the Open menu items from Fax menu")
    EventList.AddItem ("according to your board type and select from the available channels.")
    EventList.AddItem ("To close a channel choose Close Channel... from Fax menu")
    EventList.AddItem ("and select the channel to be closed if there is any open channel.")
    If (Len(FAX1.AvailableBrooktroutChannels) > 0) Then
        bchannel.Enabled = True
    End If
    If (Len(FAX1.AvailableGammaChannels) > 0) Then
        gchannel.Enabled = True
    End If
    If (Len(FAX1.AvailableDialogicChannels) > 0) Then
        dchannel.Enabled = True
    End If
   
    If (Len(FAX1.AvailableNMSChannels) > 0) Then
        nmschannel.Enabled = True
    End If
End Sub

Private Sub Form_Resize()
    EventList.Left = 0
    EventList.Top = 0
    If Width > 100 Then
        EventList.Width = Width - 100
    Else
        EventList.Width = 0
    End If
    If Height > 700 Then
        EventList.Height = Height - 700
    Else
        EventList.Height = 0
    End If
End Sub


Private Sub Form_Unload(Cancel As Integer)
  
    Screen.MousePointer = 11
    FAX1.CloseAllPorts
    Screen.MousePointer = 0
End Sub

Private Sub gchannel_Click()
    GOpen.Show vbModal
End Sub

Private Sub mnuClear_Click()
    EventList.Clear
End Sub

Private Sub mnuOnlineHelp_Click()
Dim ret As Long

ret = ShellExecute(Me.hwnd, "open", "..\Help\Black_Ice_Fax_C++_OCX_Help.chm", vbNullString, vbNullString, 1)
If ret <= 32 Then
        ret = ShellExecute(Me.hwnd, "open", "Black_Ice_Fax_C++_OCX_Help.chm", vbNullString, vbNullString, 1)
        If ret <= 32 Then MsgBox "The Black_Ice_Fax_C++_OCX_Help.chm help file not found."
End If

End Sub

Private Sub nmschannel_Click()
    NMSOpen.Show vbModal
End Sub
