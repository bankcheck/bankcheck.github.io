VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{2E980300-C865-11CF-BA24-444553540000}#4.3#0"; "Fax.ocx"
Begin VB.Form Form1 
   Caption         =   " Fax ActiveX Control - Visual Basic ReceiveFax Sample"
   ClientHeight    =   2895
   ClientLeft      =   2340
   ClientTop       =   2160
   ClientWidth     =   4785
   Icon            =   "main.frx":0000
   LinkTopic       =   "Form1"
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   2895
   ScaleWidth      =   4785
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
   Begin MSComDlg.CommonDialog SavePictureDlg 
      Left            =   3240
      Top             =   1800
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.ListBox EventList 
      Height          =   1020
      IntegralHeight  =   0   'False
      ItemData        =   "main.frx":030A
      Left            =   240
      List            =   "main.frx":030C
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


Private Sub FAX1_EndPage(ByVal szPort As String, ByVal lPageNumber As Long)
    Static line As String

    line = "Ending page " + Str(lPageNumber) + " on port " + szPort
    Form1.EventList.AddItem (line)
    Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
End Sub

Private Sub FAX1_EndReceive(ByVal PortName As String, ByVal FaxID As Long, ByVal RemoteID As String)
    
    Dim Extension As String
    Dim FileType As Integer
    Dim i As Integer
    Dim NrOfReceivedPgs As Long
    Dim TotalPgs As Long
    Dim TempFaxObj As Long
    
    Static line As String
    line = "Receive finished on " + PortName
    Form1.EventList.AddItem (line)
    line = "Remote ID : " + RemoteID
    Form1.EventList.AddItem (line)

    If (FaxID <> 0) Then
        While FaxID <> 0
            NrOfReceivedPgs = FAX1.GetFaxParam(FaxID, FP_PAGENUM)
            
            line = "Received " + Str(NrOfReceivedPgs) + " pages"
            Form1.EventList.AddItem (line)
            If FAX1.IsDemoVersion And NrOfReceivedPgs > 1 Then
                NrOfReceivedPgs = 1
                MsgBox "The DEMO version of the Fax OCX supports single port faxes only. ONLY the first page will be saved!", vbOKOnly + vbExclamation
            End If
                Dim szFilter$
        
                szFilter = "Bitmap Format (*.bmp)" + "|" + "*.bmp" + "|"
                szFilter = szFilter + "TIFF File Format (*.tif)" + "|" + "*.tif"
                SavePictureDlg.FileName = ""
                SavePictureDlg.Filter = szFilter
                SavePictureDlg.FilterIndex = 7
                SavePictureDlg.Flags = cdlOFNPathMustExist + cdlOFNHideReadOnly
                SavePictureDlg.ShowSave
               
                FAX1.FaxFileName = SavePictureDlg.FileName
                Extension = Right(FAX1.FaxFileName, 3)
                If (UCase(Extension) = "TIF") Then
                    FileType = PAGE_FILE_TIFF_G31D
                End If
                
                If (UCase(Extension) = "BMP") Then
                    FileType = PAGE_FILE_BMP
                End If

                TotalPgs = TotalPgs + NrOfReceivedPgs
              If FileType <> 0 Then
                 For i = 1 To NrOfReceivedPgs
                     FAX1.GetFaxPage FaxID, i, FileType, True
                 Next
              Else
                MsgBox "Invalid Filename!", vbOKOnly + vbExclamation
              End If
            TempFaxObj = FAX1.GetNextFax(FaxID)
            If (FAX1.ClearFaxObject(FaxID)) Then
                line = "  -  Error deleting faxobject! ID = " + Str(FaxID)
                Form1.EventList.AddItem (line)
            End If
            FaxID = TempFaxObj
        Wend
        MsgBox "Number of received pages is:" + Str(TotalPgs), vbOKOnly + vbExclamation
    End If

    NrOfReceivedPgs = 0
    Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
End Sub


Private Sub FAX1_RemoteID(ByVal Port As String, ByVal RemoteID As String)
    Static line As String
    If Len(RemoteID) > 0 Then
        line = "Remote ID " + RemoteID + " was received on " + Port + "."
        Form1.EventList.AddItem (line)
        Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
    End If
End Sub

Private Sub FAX1_Ring(ByVal PortName As String)
    Static line As String
    line = "Ring detected on " + PortName + "... "
    Form1.EventList.AddItem (line)
    Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
End Sub

Private Sub FAX1_StartPage(ByVal szPort As String, ByVal lPageNumber As Long)
    Static line As String

    line = "Starting page " + Str(lPageNumber) + " on port " + szPort + "... "
    Form1.EventList.AddItem (line)
    Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
End Sub

Private Sub FAX1_StartReceive(ByVal PortName As String)
    Static line As String
    line = "Starting to receive on " + PortName + "... "
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
    Form1.EventList.ListIndex = Form1.EventList.ListCount - 1
End Sub
Private Sub Form_Load()
    Dim DIR As String
   
    FAX1.CloseAllPorts
    EventList.AddItem ("This sample shows how to receive a fax through COM port.")
    EventList.AddItem ("To receive a fax open a COM port by choosing Open Com Port...")
    EventList.AddItem ("from Fax menu and selecting from the available ports, then wait for")
    EventList.AddItem ("a fax to be received. The sample saves the received fax in the file")
    EventList.AddItem ("specified in the Save As... dialog. The dialog appears after")
    EventList.AddItem ("the fax was received. To close a port choose Close Com Port...")
    EventList.AddItem ("from Fax menu and select from the open ports.")
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
