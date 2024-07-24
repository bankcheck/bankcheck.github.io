VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{2E980300-C865-11CF-BA24-444553540000}#4.3#0"; "fax.ocx"
Begin VB.Form Form1 
   Caption         =   " Fax ActiveX Control - Visual Basic Retry Sample"
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
   Begin VB.Timer FaxTimer 
      Enabled         =   0   'False
      Index           =   0
      Interval        =   60000
      Left            =   1800
      Top             =   1920
   End
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
      Begin VB.Menu HideManager 
         Caption         =   "Sho&w Fax Manager"
         Checked         =   -1  'True
         Enabled         =   0   'False
      End
      Begin VB.Menu send 
         Caption         =   "&Send..."
         Enabled         =   0   'False
      End
      Begin VB.Menu closeport 
         Caption         =   "&Close Port..."
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
   
Private Const INFINITE As Long = &HFFFFFFFF
Private Declare Function CreateMutexSimple Lib "kernel32.dll" Alias _
"CreateMutexA" ( _
      ByVal lpMutexAttributes As Long, _
      ByVal bInitialOwner As Long, _
      ByVal lpName As String) As Long
        
Private Declare Function ReleaseMutex Lib "kernel32.dll" ( _
      ByVal hMutex As Long) As Long
      
Private Declare Function WaitForSingleObject Lib "kernel32.dll" ( _
      ByVal hHandle As Long, _
      ByVal dwMilliseconds As Long) As Long
    
Private Type retry
   FaxID As Long
   PortName As String
   numberOfRetries As Integer
   TimerID As Integer
   CurrentlySending As Boolean
End Type
Private Type ArrayAType
    PortName As String
    FaxID As Long
End Type
Private Type ArrayBType
    PortName As String
    status As Long
End Type

Public BaudRate As Byte
Public SpeakerMode As Byte
Public SpeakerVolume As Byte
Public EnableECM As Byte
Public EnableBFT As Byte
Public ActualFaxPort As String
Private retrylist() As retry
Private ArrayA() As ArrayAType
Private ArrayB() As ArrayBType
Private retryListItemNumber As Integer
Private ArrayAItemNumber As Integer
Private ArrayBItemNumber As Integer
Private timerCount As Integer
Private hMutex As Long
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
Dim status As Long
Dim i As Integer
Dim TemptimerID As Integer
WaitForSingleObject hMutex, INFINITE
SetCurrentlySending FaxID, False
AddToArrayA PortName, FaxID
status = GetStatus(PortName)
If status <> -1 Then
    If (status = 6) Then 'Busy
        If IsFaxIDInList(FaxID) = False Then
            AddToList FaxID, PortName
            timerCount = timerCount + 1
            Load Form1.FaxTimer(timerCount)
            Form1.FaxTimer(timerCount).Enabled = True
            SetTimerID FaxID, timerCount
            EventList.AddItem ("Remote number was busy. Trying to send the fax three minutes later.")
        Else
            If GetRetryNumber(FaxID) <= 0 Then
                  TemptimerID = GetTimerID(FaxID)
                  Unload Form1.FaxTimer(TemptimerID)
                  DeleteFromList (FaxID)
                  FAX1.ClearFaxObject (FaxID)
            End If
        End If
    Else
        TemptimerID = GetTimerID(FaxID)
        If TemptimerID > 0 Then
            Unload Form1.FaxTimer(TemptimerID)
        End If
        DeleteFromList (FaxID)
        FAX1.ClearFaxObject (FaxID)
    End If
    DeleteFromArrayA PortName, FaxID
    DeleteFromArrayB PortName, status
End If
ReleaseMutex hMutex


    Form1.EventList.AddItem "FaxID:" + CStr(FaxID)
    line = "Sending finished on " + PortName
    Form1.EventList.AddItem (line)
    line = "Remote ID : " + RemoteID
    Form1.EventList.AddItem (line)
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

Private Sub FAX1_Terminate(ByVal lpPort As String, ByVal lstatus As Long, ByVal sPageNo As Integer, ByVal ConnectTime As Long, ByVal szDID As String, ByVal szDTMF As String)
 Static line As String
Dim FaxID As Long
Dim i As Integer
Dim TemptimerID As Integer
WaitForSingleObject hMutex, INFINITE
FaxID = GetFaxID(lpPort)
SetCurrentlySending FaxID, False
AddToArrayB lpPort, lstatus
If FaxID <> 0 Then
    If (lstatus = 6) Then 'Busy
        If IsFaxIDInList(FaxID) = False Then
            AddToList FaxID, lpPort
            timerCount = timerCount + 1
            Load Form1.FaxTimer(timerCount)
            Form1.FaxTimer(timerCount).Enabled = True
            SetTimerID FaxID, timerCount
            EventList.AddItem ("Remote number was busy. Trying to send the fax three minutes later.")
        Else
            If GetRetryNumber(FaxID) <= 0 Then
                  TemptimerID = GetTimerID(FaxID)
                  Unload Form1.FaxTimer(TemptimerID)
                  FAX1.ClearFaxObject (FaxID)
                  DeleteFromList (FaxID)
            End If
        End If
    Else
        TemptimerID = GetTimerID(FaxID)
        If TemptimerID > 0 Then
            Unload Form1.FaxTimer(TemptimerID)
        End If
        DeleteFromList (FaxID)
        FAX1.ClearFaxObject (FaxID)
    End If
    DeleteFromArrayA lpPort, FaxID
    DeleteFromArrayB lpPort, lstatus
End If
ReleaseMutex hMutex
    line = "Transmission terminated on " + lpPort
    Form1.EventList.AddItem (line)
    line = lpPort + " termination status : " + Form1.FAX1.ReturnErrorString(lstatus)
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

Private Sub FaxTimer_Timer(index As Integer)
Dim iError As Integer
Dim i As Integer
WaitForSingleObject hMutex, INFINITE
ReDim tempretry(retryListItemNumber) As retry
Dim tempRetryNumber As Integer
tempRetryNumber = retryListItemNumber
For i = 1 To retryListItemNumber
    tempretry(i) = retrylist(i)
Next i
If tempRetryNumber > 0 Then
    For i = 1 To tempRetryNumber
        With tempretry(i)
            If .TimerID = index Then
                If .numberOfRetries > 0 And .CurrentlySending = False Then
                        FAX1.ChainOutItem (.FaxID)
                        iError = FAX1.SendFaxObj(.FaxID)
                        If iError <> 0 Then
                            DeleteFromList (.FaxID)
                            MsgBox "Cannot add the following fax object to queue: " + CStr(.FaxID)
                        Else: retrylist(i).CurrentlySending = True
                        End If
                    retrylist(i).numberOfRetries = retrylist(i).numberOfRetries - 1
                End If
            Exit For
            End If
        End With
    Next
End If
ReleaseMutex hMutex
End Sub

Private Sub Form_Load()
    Dim DIR As String

    BaudRate = BR_33600
    SpeakerMode = SMO_DIAL
    SpeakerVolume = SVO_MEDIUM
    FAX1.SpeakerMode = SMO_DIAL
    FAX1.SpeakerVolume = SVO_MEDIUM
    FAX1.ToneDial = True
    EnableECM = EC_ENABLE
    EnableBFT = BF_DISABLE
    FAX1.CloseAllPorts
    EventList.AddItem ("This sample shows how to try to resend a fax if the remote number")
    EventList.AddItem ("is busy. The sample will try to resend the three minutes later.")
    EventList.AddItem ("If sending the fax is unsuccessfull four times the sample will not try")
    EventList.AddItem ("to send the fax again.")
    EventList.AddItem ("To use the sample open a com port by choosing Open Com Port...")
    EventList.AddItem ("from Fax menu and select from available ports.")
    EventList.AddItem ("To send a fax select Send... from Fax menu, then specify the file")
    EventList.AddItem ("to be sent and the remote phone number.")
    EventList.AddItem ("To close a com port choose Close Com Port... from Fax menu and")
    EventList.AddItem ("select from the ports open.")
    retryListItemNumber = 0
    timerCount = 0
    hMutex = CreateMutexSimple(0, 0, vbNullString)
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

Private Sub HideManager_Click()
    FAX1.DisplayFaxManager = Not FAX1.DisplayFaxManager
 If (FAX1.DisplayFaxManager) Then
    Form1.HideManager.Checked = True
 Else
    Form1.HideManager.Checked = False
 End If
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

Public Sub AddToList(ByVal FaxID_ As Long, PortName_ As String)
Dim i As Integer
WaitForSingleObject hMutex, INFINITE
If (retryListItemNumber > 0) Then
    ReDim temp(retryListItemNumber) As retry
    For i = 1 To retryListItemNumber
        temp(i) = retrylist(i)
    Next i
End If
retryListItemNumber = retryListItemNumber + 1
ReDim retrylist(retryListItemNumber)
If (retryListItemNumber > 1) Then
    For i = 1 To retryListItemNumber - 1
        retrylist(i) = temp(i)
    Next i
End If
retrylist(retryListItemNumber).FaxID = FaxID_
retrylist(retryListItemNumber).PortName = PortName_
retrylist(retryListItemNumber).numberOfRetries = 3
retrylist(retryListItemNumber).TimerID = -1
ReleaseMutex hMutex
End Sub

Public Function SetTimerID(ByVal FaxID_ As Long, ByVal TimerID_ As Integer) As Boolean
Dim i As Integer
WaitForSingleObject hMutex, INFINITE
SetTimerID = False
If retryListItemNumber > 0 Then
    For i = 1 To retryListItemNumber
        If (retrylist(i).FaxID = FaxID_) Then
            retrylist(i).TimerID = TimerID_
            SetTimerID = True
            Exit For
        End If
    Next i
End If
ReleaseMutex hMutex
End Function

Public Function GetTimerID(ByVal FaxID_ As Long) As Integer
Dim i As Integer
WaitForSingleObject hMutex, INFINITE
GetTimerID = -1
If retryListItemNumber > 0 Then
    For i = 1 To retryListItemNumber
        If (retrylist(i).FaxID = FaxID_) Then
            GetTimerID = retrylist(i).TimerID
            Exit For
        End If
    Next i
End If
ReleaseMutex hMutex
End Function

Public Function GetRetryNumber(ByVal FaxID_ As Long) As Integer
Dim i As Integer
WaitForSingleObject hMutex, INFINITE
GetRetryNumber = -1
If retryListItemNumber > 0 Then
    For i = 1 To retryListItemNumber
        If (retrylist(i).FaxID = FaxID_) Then
            GetRetryNumber = retrylist(i).numberOfRetries
            Exit For
        End If
    Next i
End If
ReleaseMutex hMutex
End Function
Public Function IsFaxIDInList(ByVal FaxID_ As Long) As Boolean
Dim i As Integer
WaitForSingleObject hMutex, INFINITE
IsFaxIDInList = False
If retryListItemNumber > 0 Then
    For i = 1 To retryListItemNumber
        If (retrylist(i).FaxID = FaxID_) Then
            IsFaxIDInList = True
            Exit For
        End If
    Next i
End If
ReleaseMutex hMutex
End Function

Public Function DeleteFromList(ByVal FaxID_ As Long) As Boolean
Dim i, j As Integer
Dim itemToDelete As Integer
WaitForSingleObject hMutex, INFINITE
DeleteFromList = False
itemToDelete = 0
If retryListItemNumber > 0 Then
    For i = 1 To retryListItemNumber
       If retrylist(i).FaxID = FaxID_ Then
            itemToDelete = i
            Exit For
       End If
    Next i
    If itemToDelete > 0 Then
        If retryListItemNumber = 1 Then
            If itemToDelete = 1 Then
                ReDim retrylist(0)
                retryListItemNumber = 0
            End If
        Else
            ReDim temp(retryListItemNumber - 1) As retry
            For i = 1 To retryListItemNumber
                If i <> itemToDelete Then
                    j = j + 1
                    temp(j) = retrylist(i)
                End If
            Next i
            retryListItemNumber = retryListItemNumber - 1
            ReDim retrylist(retryListItemNumber)
            For i = 1 To retryListItemNumber
                retrylist(i) = temp(i)
            Next i
        End If
    End If
End If
ReleaseMutex hMutex
End Function

Public Function SetCurrentlySending(ByVal FaxID_ As Long, ByVal cr_ As Boolean) As Boolean
Dim i As Integer
WaitForSingleObject hMutex, INFINITE
SetCurrentlySending = False
If retryListItemNumber > 0 Then
    For i = 1 To retryListItemNumber
        If (retrylist(i).FaxID = FaxID_) Then
            retrylist(i).CurrentlySending = cr_
            SetCurrentlySending = True
            Exit For
        End If
    Next i
End If
ReleaseMutex hMutex
End Function

Public Sub AddToArrayA(PortName_ As String, ByVal FaxID_ As Long)
Dim size As Integer
Dim i As Integer
    If (ArrayAItemNumber > 0) Then
    ReDim temp(ArrayAItemNumber) As ArrayAType
    For i = 1 To ArrayAItemNumber
        temp(i) = ArrayA(i)
    Next i
End If
ArrayAItemNumber = ArrayAItemNumber + 1
ReDim ArrayA(ArrayAItemNumber)
If (ArrayAItemNumber > 1) Then
    For i = 1 To ArrayAItemNumber - 1
        ArrayA(i) = temp(i)
    Next i
End If
ArrayA(ArrayAItemNumber).FaxID = FaxID_
ArrayA(ArrayAItemNumber).PortName = PortName_
End Sub

Public Sub DeleteFromArrayA(PortName_ As String, ByVal FaxID_ As Long)
Dim i, j As Integer
Dim itemToDelete As Integer
itemToDelete = 0
If ArrayAItemNumber > 0 Then
    For i = 1 To ArrayAItemNumber
       If ArrayA(i).FaxID = FaxID_ And ArrayA(i).PortName = PortName_ Then
            itemToDelete = i
            Exit For
       End If
    Next i
    If itemToDelete > 0 Then
        If ArrayAItemNumber = 1 Then
            If itemToDelete = 1 Then
                ReDim ArrayA(0)
                ArrayAItemNumber = 0
            End If
        Else
            ReDim temp(ArrayAItemNumber - 1) As ArrayAType
            For i = 1 To ArrayAItemNumber
                If i <> itemToDelete Then
                    j = j + 1
                    temp(j) = ArrayA(i)
                End If
            Next i
            ArrayAItemNumber = ArrayAItemNumber - 1
            ReDim ArrayA(ArrayAItemNumber)
            For i = 1 To ArrayAItemNumber
                ArrayA(i) = temp(i)
            Next i
        End If
    End If
End If

End Sub

Public Function GetFaxID(PortName_ As String)
Dim i As Integer
GetFaxID = 0
If ArrayAItemNumber > 0 Then
    For i = 1 To ArrayAItemNumber
        If ArrayA(i).PortName = PortName_ Then
            GetFaxID = ArrayA(i).FaxID
            Exit For
        End If
    Next i
End If
End Function

Public Sub AddToArrayB(PortName_ As String, ByVal status_ As Long)
Dim size, i As Integer
If (ArrayBItemNumber > 0) Then
    ReDim temp(ArrayBItemNumber) As ArrayBType
    For i = 1 To ArrayBItemNumber
       temp(i) = ArrayB(i)
    Next i
End If
ArrayBItemNumber = ArrayBItemNumber + 1
ReDim ArrayB(ArrayBItemNumber)
If (ArrayBItemNumber > 1) Then
    For i = 1 To ArrayBItemNumber - 1
        ArrayB(i) = temp(i)
    Next i
End If
ArrayB(ArrayBItemNumber).PortName = PortName_
ArrayB(ArrayBItemNumber).status = status_
End Sub

Public Sub DeleteFromArrayB(PortName_ As String, ByVal status_ As Long)
Dim i, j As Integer
Dim itemToDelete As Integer
itemToDelete = 0
If ArrayBItemNumber > 0 Then
    For i = 1 To ArrayBItemNumber
       If ArrayB(i).PortName = PortName_ And ArrayB(i).status = status_ Then
            itemToDelete = i
            Exit For
       End If
    Next i
    If itemToDelete > 0 Then
        If ArrayBItemNumber = 1 Then
            If itemToDelete = 1 Then
                ReDim ArrayB(0)
                ArrayBItemNumber = 0
            End If
        Else
            ReDim temp(ArrayBItemNumber - 1) As ArrayBType
            For i = 1 To ArrayBItemNumber
                If i <> itemToDelete Then
                    j = j + 1
                    temp(j) = ArrayB(i)
                End If
            Next i
            ArrayBItemNumber = ArrayBItemNumber - 1
            ReDim ArrayB(ArrayBItemNumber)
            For i = 1 To ArrayBItemNumber
                ArrayB(i) = temp(i)
            Next i
        End If
    End If
End If

End Sub

Public Function GetStatus(PortName_ As String)
Dim i As Integer
GetStatus = -1
If ArrayBItemNumber > 0 Then
    For i = 1 To ArrayBItemNumber
        If ArrayB(i).PortName = PortName_ Then
            GetStatus = ArrayB(i).status
            Exit For
        End If
    Next i
End If
End Function
