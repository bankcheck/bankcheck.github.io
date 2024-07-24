VERSION 5.00
Object = "{2E980300-C865-11CF-BA24-444553540000}#4.3#0"; "Fax.ocx"
Begin VB.Form Form1 
   Caption         =   " Fax ActiveX Control - Visual Basic SendFax Sample"
   ClientHeight    =   2895
   ClientLeft      =   2340
   ClientTop       =   2160
   ClientWidth     =   4905
   Icon            =   "main.frx":0000
   LinkTopic       =   "Form1"
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   2895
   ScaleWidth      =   4905
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
      Begin VB.Menu comport 
         Caption         =   "&Open Com Port..."
         Enabled         =   0   'False
      End
      Begin VB.Menu send 
         Caption         =   "&Send..."
         Enabled         =   0   'False
      End
      Begin VB.Menu closeport 
         Caption         =   "&Close Com Port..."
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

Private Sub ClosePort_Click()
    COMClose.Show vbModal
End Sub

Private Sub comport_Click()
    COMOpen.Show vbModal
End Sub

Private Sub exit_Click()
    Unload Me
End Sub

Private Sub FAX1_Dial(ByVal PortName As String)
    Static line As String
    line = "Dialing on " + PortName + "... "
    Form1.EventList.AddItem (line)
    Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
End Sub

Private Sub FAX1_EndPage(ByVal szPort As String, ByVal lPageNumber As Long)
    Static line As String

    line = "Ending page " + Str(lPageNumber) + " on port " + szPort
    Form1.EventList.AddItem (line)
    Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
End Sub

Private Sub FAX1_EndSend(ByVal PortName As String, ByVal FaxID As Long, ByVal RemoteID As String)
    Static line As String

    line = "Sending finished on " + PortName
    Form1.EventList.AddItem (line)
    line = "Remote ID : " + RemoteID
    Form1.EventList.AddItem (line)
    If (FAX1.ClearFaxObject(FaxID)) Then
        line = "  -  Error deleting faxobject! ID = " + Str(FaxID)
        Form1.EventList.AddItem (line)
    End If
    Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
End Sub

Private Sub FAX1_StartPage(ByVal szPort As String, ByVal lPageNumber As Long)
    Static line As String

    line = "Starting page " + Str(lPageNumber) + " on port " + szPort + "... "
    Form1.EventList.AddItem (line)
    Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
End Sub

Private Sub FAX1_StartSend(ByVal PortName As String)
    Static line As String
    line = "Starting to send on " + PortName + "... "
    Form1.EventList.AddItem (line)
    Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
   
End Sub

Private Sub FAX1_Terminate(ByVal lpPort As String, ByVal lStatus As Long, ByVal sPageNo As Integer, ByVal ConnectTime As Long, ByVal szDID As String, ByVal szDTMF As String)
 Static line As String
    line = "Transmission terminated on " + lpPort
    Form1.EventList.AddItem (line)
    line = lpPort + " termination status : " + Form1.FAX1.ReturnErrorString(lStatus)
    Form1.EventList.AddItem (line)
    line = lpPort + " connected for " + Str(ConnectTime) + " milliseconds"
    Form1.EventList.AddItem (line)
    If Len(szDID) > 0 Then
        line = "DID received on" + lpPort + ": " + szDID
        Form1.EventList.AddItem (line)
    End If
    If Len(szDTMF) > 0 Then
        line = "DTMF received on" + lpPort + ": " + szDTMF
        Form1.EventList.AddItem (line)
    End If
    Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
End Sub
Private Sub Form_Load()
    FAX1.CloseAllPorts
    Form1.EventList.AddItem ("This sample shows how to send a fax using a COM port.")
    Form1.EventList.AddItem ("To open a COM port choose Open Com Port... from Fax menu")
    Form1.EventList.AddItem ("and select from the available ports. To send a fax select Send...")
    Form1.EventList.AddItem ("from Fax menu, specify the file you would like to send and the")
    Form1.EventList.AddItem ("destination phone number. You can send the fax using the selected")
    Form1.EventList.AddItem ("port if checking Immediate radio button or put the fax in queue")
    Form1.EventList.AddItem ("by checking Queue button.")
    Form1.EventList.AddItem ("To close a port choose Close Com Port... from Fax menu and")
    Form1.EventList.AddItem ("select from the open ports.")
    If (Len(Form1.FAX1.AvailablePorts) > 0) Then
        comport.Enabled = True
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

Private Sub mnuClear_Click()
    EventList.Clear
End Sub

Private Sub mnuFax_Click()
If (Len(Form1.FAX1.AvailablePorts) > 0) Then
        comport.Enabled = True
    Else: comport.Enabled = False
    End If
End Sub

Private Sub mnuOnlineHelp_Click()
Dim ret As Long

ret = ShellExecute(Me.hwnd, "open", "..\Help\Black_Ice_Fax_C++_OCX_Help.chm", vbNullString, vbNullString, 1)
If ret <= 32 Then
        ret = ShellExecute(Me.hwnd, "open", "Black_Ice_Fax_C++_OCX_Help.chm", vbNullString, vbNullString, 1)
        If ret <= 32 Then MsgBox "The Black_Ice_Fax_C++_OCX_Help.chm help file not found."
End If

End Sub

Private Sub send_Click()
    SendDlg.Show vbModal
End Sub

