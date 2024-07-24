Public Class Form1
    Inherits System.Windows.Forms.Form
    Public BaudRate As Byte
    Public SpeakerMode As Byte
    Public SpeakerVolume As Byte
    Public EnableECM As Byte
    Public EnableBFT As Byte
    Public ActualFaxPort As String
    Public EnableDebug As Boolean
    Public retrylist As ArrayList
    Public ArrayA As ArrayList
    Public ArrayB As ArrayList
    Private currdir As String

    Private Declare Function ShellExecute Lib "shell32.dll" Alias _
   "ShellExecuteA" (ByVal hwnd As IntPtr, ByVal lpOperation As _
   String, ByVal lpFile As String, ByVal lpParameters As String, _
   ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

    Private Const WebPage As String = "http://www.blackice.com/Help/Tools/Fax%20OCX%20webhelp/WebHelp/Black_Ice_Fax_C___OCX_Help.htm"
#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents MainMenu1 As System.Windows.Forms.MainMenu
    Friend WithEvents MenuFax As System.Windows.Forms.MenuItem
    Friend WithEvents MenuAbout As System.Windows.Forms.MenuItem
    Friend WithEvents MessageBox As System.Windows.Forms.ListBox
    Friend WithEvents FAX1 As AxFAXLib.AxFAX
    Friend WithEvents MenuExit As System.Windows.Forms.MenuItem
    Friend WithEvents MenuShowManager As System.Windows.Forms.MenuItem
    Friend WithEvents SaveFileDialog1 As System.Windows.Forms.SaveFileDialog
    Friend WithEvents MenuClosePort As System.Windows.Forms.MenuItem
    Friend WithEvents MenuSend As System.Windows.Forms.MenuItem
    Friend WithEvents MenuHelp As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem4 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem1 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem3 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem2 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuCom As System.Windows.Forms.MenuItem
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(Form1))
        Me.MainMenu1 = New System.Windows.Forms.MainMenu
        Me.MenuItem4 = New System.Windows.Forms.MenuItem
        Me.MenuItem1 = New System.Windows.Forms.MenuItem
        Me.MenuItem3 = New System.Windows.Forms.MenuItem
        Me.MenuExit = New System.Windows.Forms.MenuItem
        Me.MenuFax = New System.Windows.Forms.MenuItem
        Me.MenuCom = New System.Windows.Forms.MenuItem
        Me.MenuShowManager = New System.Windows.Forms.MenuItem
        Me.MenuSend = New System.Windows.Forms.MenuItem
        Me.MenuClosePort = New System.Windows.Forms.MenuItem
        Me.MenuHelp = New System.Windows.Forms.MenuItem
        Me.MenuAbout = New System.Windows.Forms.MenuItem
        Me.MenuItem2 = New System.Windows.Forms.MenuItem
        Me.MessageBox = New System.Windows.Forms.ListBox
        Me.FAX1 = New AxFAXLib.AxFAX
        Me.SaveFileDialog1 = New System.Windows.Forms.SaveFileDialog
        CType(Me.FAX1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'MainMenu1
        '
        Me.MainMenu1.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.MenuItem4, Me.MenuFax, Me.MenuHelp})
        '
        'MenuItem4
        '
        Me.MenuItem4.Index = 0
        Me.MenuItem4.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.MenuItem1, Me.MenuItem3, Me.MenuExit})
        Me.MenuItem4.Text = "&File"
        '
        'MenuItem1
        '
        Me.MenuItem1.Index = 0
        Me.MenuItem1.Text = "&Clear"
        '
        'MenuItem3
        '
        Me.MenuItem3.Index = 1
        Me.MenuItem3.Text = "-"
        '
        'MenuExit
        '
        Me.MenuExit.Index = 2
        Me.MenuExit.Shortcut = System.Windows.Forms.Shortcut.CtrlX
        Me.MenuExit.Text = "&Exit"
        '
        'MenuFax
        '
        Me.MenuFax.Index = 1
        Me.MenuFax.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.MenuCom, Me.MenuShowManager, Me.MenuSend, Me.MenuClosePort})
        Me.MenuFax.Text = "F&ax"
        '
        'MenuCom
        '
        Me.MenuCom.Index = 0
        Me.MenuCom.Text = "&Open Com Port..."
        '
        'MenuShowManager
        '
        Me.MenuShowManager.Checked = True
        Me.MenuShowManager.Enabled = False
        Me.MenuShowManager.Index = 1
        Me.MenuShowManager.Text = "&Show Fax Manager"
        '
        'MenuSend
        '
        Me.MenuSend.Enabled = False
        Me.MenuSend.Index = 2
        Me.MenuSend.Text = "Sen&d..."
        '
        'MenuClosePort
        '
        Me.MenuClosePort.Enabled = False
        Me.MenuClosePort.Index = 3
        Me.MenuClosePort.Text = "C&lose Com Port..."
        '
        'MenuHelp
        '
        Me.MenuHelp.Index = 2
        Me.MenuHelp.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.MenuAbout, Me.MenuItem2})
        Me.MenuHelp.Text = "&Help"
        '
        'MenuAbout
        '
        Me.MenuAbout.Index = 0
        Me.MenuAbout.Shortcut = System.Windows.Forms.Shortcut.F1
        Me.MenuAbout.Text = "&About..."
        '
        'MenuItem2
        '
        Me.MenuItem2.Index = 1
        Me.MenuItem2.Text = "&Fax C++ OCX Help"
        '
        'MessageBox
        '
        Me.MessageBox.IntegralHeight = False
        Me.MessageBox.Location = New System.Drawing.Point(200, 72)
        Me.MessageBox.Name = "MessageBox"
        Me.MessageBox.Size = New System.Drawing.Size(48, 95)
        Me.MessageBox.TabIndex = 0
        '
        'FAX1
        '
        Me.FAX1.Enabled = True
        Me.FAX1.Location = New System.Drawing.Point(184, 208)
        Me.FAX1.Name = "FAX1"
        Me.FAX1.OcxState = CType(resources.GetObject("FAX1.OcxState"), System.Windows.Forms.AxHost.State)
        Me.FAX1.Size = New System.Drawing.Size(16, 16)
        Me.FAX1.TabIndex = 1
        '
        'SaveFileDialog1
        '
        Me.SaveFileDialog1.Filter = "Bitmap Format (*.bmp)|*.bmp|TIFF File Format(*.tif)|*.tif"
        '
        'Form1
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(328, 273)
        Me.Controls.Add(Me.FAX1)
        Me.Controls.Add(Me.MessageBox)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Menu = Me.MainMenu1
        Me.Name = "Form1"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Fax ActiveX Control - Visual Basic .NET Retry Sample"
        CType(Me.FAX1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub MenuAbout_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuAbout.Click
        Dim dlgAbout As About = New About()

        dlgAbout.ShowDialog()
    End Sub

    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Dim DIR As String
        FAX1.FaxType = "GCLASS1(SFC)"
        BaudRate = 15
        SpeakerMode = 2
        SpeakerVolume = 1
        FAX1.SpeakerMode = 2
        FAX1.SpeakerVolume = 1
        FAX1.ToneDial = True
        EnableECM = 3
        EnableBFT = 2
        EnableDebug = False
        retrylist = New ArrayList
        ArrayA = New ArrayList
        ArrayB = New ArrayList
        currdir = CurDir()
        FAX1.CloseAllPorts()
        MessageBox.Items.Add("This sample shows how to try to resend a fax if the remote number")
        MessageBox.Items.Add("is busy. The sample will try to resend the three minutes later.")
        MessageBox.Items.Add("If sending the fax is unsuccessfull four times the sample will not try")
        MessageBox.Items.Add("to send the fax again.")
        MessageBox.Items.Add("To use the sample open a com port by choosing Open Com Port...")
        MessageBox.Items.Add("from Fax menu and select from available ports.")
        MessageBox.Items.Add("To send a fax select Send... from Fax menu, then specify the file")
        MessageBox.Items.Add("to be sent and the remote phone number.")
        MessageBox.Items.Add("To close a com port choose Close Com Port... from Fax menu and")
        MessageBox.Items.Add("select from the ports open.")
        If (Len(FAX1.AvailablePorts) > 0) Then
            MenuCom.Enabled = True
        End If
    End Sub

    Private Sub Form1_Resize(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Resize
        MessageBox.Top = 0
        MessageBox.Left = 0
        MessageBox.Width = Me.ClientSize.Width
        MessageBox.Height = Me.ClientSize.Height
    End Sub

    Public Function Errors(ByVal errcode As Long) As String

        Select Case errcode
            Case -150
                Errors = "The specified file doesn’t exist."

            Case -151
                Errors = "The specified communication port is invalid."

            Case -152
                Errors = "The specified communication port doesn’t exist."

            Case -153
                Errors = "The connect to the port was unsuccessful."

            Case -154
                Errors = "No file was specified for sending."

            Case -155
                Errors = "The creation of the fax object failed."

            Case -156
                Errors = "The specified communication port was already initialized."

            Case -157
                Errors = "An invalid fax modem type was specified."

            Case -158
                Errors = "No phone number was specified for SetPhoneNumber function."

            Case -159
                Errors = "Invalid fax ID was specified."

            Case -160
                Errors = "Invalid image type was specified for SetFaxPage method."

            Case -161
                Errors = "Invalid image filename was specified for SetFaxPage method."

            Case -162
                Errors = "The attempt to open or convert the ASCII data to image was unsuccessful."

            Case -163
                Errors = "There was no DIB handle specified before SetFaxPage method."

            Case -164
                Errors = "Invalid DIB handle was specified before SetFaxPage method."

            Case -165
                Errors = "There weren’t any ports open before an operation (SendFaxObj) which needed one."

            Case -166
                Errors = "The OCX wasn’t able to recognize the format of the specified image file."

            Case -167
                Errors = "The modem test on the specified COM port was unsuccessful."

            Case -168
                Errors = "Invalid filename specified."

            Case -169
                Errors = "The specified Brooktrout fax channel has no faxing capability."

            Case -170
                Errors = "No configuration file was specified before opening a Brooktrout or GammaLink fax channel."

            Case -171
                Errors = "The DEMO version of the Fax OCX supports only 1 fax port."

            Case -172
                Errors = "The DEMO version of the Fax OCX supports only 1 page faxes."

            Case Else
                Errors = Str(errcode)

        End Select

    End Function

    Private Sub MenuExit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuExit.Click
        Close()
    End Sub

    Private Sub FAX1_Dial(ByVal sender As Object, ByVal e As AxFAXLib._DFAXEvents_DialEvent) Handles FAX1.Dial
        MessageBox.Items.Add("Dialing on " + e.portName)
    End Sub

    Private Sub FAX1_EndPage(ByVal sender As Object, ByVal e As AxFAXLib._DFAXEvents_EndPageEvent) Handles FAX1.EndPage
        MessageBox.Items.Add("Ending page " + Str(e.lPageNumber) + " on port " + e.szPort)
        MessageBox.Items.Add("Page in file " + FAX1.GetLastPageFile(e.szPort))
    End Sub

    Private Sub FAX1_EndSend(ByVal sender As Object, ByVal e As AxFAXLib._DFAXEvents_EndSendEvent) Handles FAX1.EndSend
        Dim status As Long
        SetCurrentlySending(e.faxID, False)
        AddToArrayA(e.portName, e.faxID)
        status = GetStatus(e.portName)
        If (status <> -1) Then
            If (status = 6) Then
                If (IsFaxObjInList(e.faxID) = False) Then
                    AddToList(e.faxID, e.portName)
                    Static t As System.Timers.Timer
                    t = New System.Timers.Timer(180000)
                    t.Interval = 180000
                    t.Enabled = True
                    AddHandler t.Elapsed, New _
                    System.Timers.ElapsedEventHandler(AddressOf Me.timer_Elapsed)
                    SetTimerID(e.faxID, t)
                    MessageBox.Items.Add("Remote number was busy. Trying to send the fax three minutes later.")
                Else
                    If GetRetryNumber(e.faxID) <= 0 Then
                        Dim t2 As Object

                        t2 = GetTimerID(e.faxID)
                        If (t2 <> vbNull) Then
                            CType(t2, System.Timers.Timer).Close()
                        End If
                        DeleteFromList(e.faxID)
                        FAX1.ClearFaxObject(e.faxID)
                    End If
                    End If
            Else
                '       Dim i As Integer
                Dim t1 As Object
                t1 = GetTimerID(e.faxID)
                If (t1 <> vbNull) Then
                    CType(t1, System.Timers.Timer).Close()
                End If
                DeleteFromList(e.faxID)
                FAX1.ClearFaxObject(e.faxID)
            End If
            DeleteFromArrayA(e.portName, e.faxID)
            DeleteFromArrayB(e.portName, status)
        End If
        MessageBox.Items.Add("FaxID: " + e.faxID.ToString())
        MessageBox.Items.Add("Sending finished on " + e.portName)
        MessageBox.Items.Add("Remote ID : " + e.remoteID)
    End Sub

    Private Sub FAX1_Ring(ByVal sender As Object, ByVal e As AxFAXLib._DFAXEvents_RingEvent) Handles FAX1.Ring
        MessageBox.Items.Add("Ring detected on " + e.portName)
    End Sub

    Private Sub FAX1_StartPage(ByVal sender As Object, ByVal e As AxFAXLib._DFAXEvents_StartPageEvent) Handles FAX1.StartPage
        MessageBox.Items.Add("Starting page " + Str(e.lPageNumber) + " on port " + e.szPort)
    End Sub

    Private Sub FAX1_StartSend(ByVal sender As Object, ByVal e As AxFAXLib._DFAXEvents_StartSendEvent) Handles FAX1.StartSend
        MessageBox.Items.Add("Starting to send on " + e.portName)
    End Sub

    Private Sub FAX1_TerminateExt(ByVal sender As Object, ByVal e As AxFAXLib._DFAXEvents_TerminateExtEvent) Handles FAX1.TerminateExt
        Dim FaxID As Long
        FaxID = GetFaxID(e.lpPort)
        SetCurrentlySending(FaxID, False)
        AddToArrayB(e.lpPort, e.lStatus)
        If (FaxID <> 0) Then
            If (e.lStatus = 6) Then
                If (IsFaxObjInList(FaxID) = False) Then
                    AddToList(FaxID, e.lpPort)
                    Static t As System.Timers.Timer
                    t = New System.Timers.Timer(180000)
                    t.Interval = 180000
                    t.Enabled = True
                    AddHandler t.Elapsed, New _
                    System.Timers.ElapsedEventHandler(AddressOf Me.timer_Elapsed)
                    SetTimerID(FaxID, t)
                    MessageBox.Items.Add("Remote number was busy. Trying to send the fax three minutes later.")
                Else
                    If GetRetryNumber(FaxID) <= 0 Then
                        Dim t2 As Object
                        t2 = GetTimerID(FaxID)
                        If (t2 <> vbNull) Then
                            CType(t2, System.Timers.Timer).Close()
                        End If
                        DeleteFromList(FaxID)
                        FAX1.ClearFaxObject(FaxID)
                    End If
                    End If
            Else
                'Dim i As Integer
                Dim t1 As Object
                t1 = GetTimerID(FaxID)
                If (t1 <> vbNull) Then
                    CType(t1, System.Timers.Timer).Close()
                End If
                DeleteFromList(FaxID)
                FAX1.ClearFaxObject(FaxID)
                End If
                DeleteFromArrayA(e.lpPort, FaxID)
                DeleteFromArrayB(e.lpPort, e.lStatus)
        End If
        MessageBox.Items.Add("Transmission terminated on " + e.lpPort)
        MessageBox.Items.Add("   -  Termination status : " + FAX1.ReturnErrorString(e.lStatus) + ", Connected for " + Str(e.connectTime) + " milliseconds.")
        If (e.szDID.Length > 0) Then MessageBox.Items.Add("DID received on " + e.lpPort + ": " + e.szDID)
        If (e.szDTMF.Length > 0) Then MessageBox.Items.Add("DTMF received on " + e.lpPort + ": " + e.szDTMF)

    End Sub

    Private Sub Form1_Closed(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Closed
        Cursor = Cursors.WaitCursor
        Enabled = False
        FAX1.CloseAllPorts()
        Enabled = True
        Cursor = Cursors.Default
    End Sub

    Private Sub MenuShowManager_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuShowManager.Click
        FAX1.DisplayFaxManager = Not FAX1.DisplayFaxManager
        If (FAX1.DisplayFaxManager) Then
            MenuShowManager.Checked = True
        Else
            MenuShowManager.Checked = False
        End If
    End Sub

    Private Sub MenuItem4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuClosePort.Click
        Dim dlgClose As ClosePort = New ClosePort
        dlgClose.pparent = Me
        dlgClose.ShowDialog()
    End Sub

    Private Sub MenuSend_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuSend.Click
        Dim dlgSend As Send = New Send

        dlgSend.pparent = Me
        dlgSend.ShowDialog()
    End Sub

    Private Sub MenuItem1_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuItem1.Click
        MessageBox.Items.Clear()
    End Sub

    Private Sub MenuItem2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuItem2.Click
        Dim cdir As String
        cdir = currdir
        cdir = cdir + "\..\Help\Black_Ice_Fax_C++_OCX_Help.chm"
        If (Dir(cdir) <> vbNullString) Then
            Help.ShowHelp(Me, cdir)
        Else
            cdir = currdir
            cdir = cdir + "\Black_Ice_Fax_C++_OCX_Help.chm"
            If (Dir(cdir) <> vbNullString) Then
                Help.ShowHelp(Me, cdir)
            Else : MsgBox("The Black_Ice_Fax_C++_OCX_Help.chm help file was not found.")
            End If
        End If
    End Sub

    Public Sub AddToList(ByVal FaxID_ As Long, ByVal PortName_ As String)
        Dim tempretry As retry
        tempretry = New retry(FaxID_, PortName_)
        retrylist.Add(tempretry)
    End Sub
    Public Function SetTimerID(ByVal FaxID_ As Long, ByVal TimerID_ As Object) As Boolean
        Dim i As Integer
        If (retrylist.Count >= 0) Then
            For i = 0 To retrylist.Count - 1
                If retrylist.Item(i).FaxID = FaxID_ Then
                    retrylist.Item(i).TimerID = TimerID_
                    Return True
                End If
            Next i
        End If
        Return False
    End Function

    Public Function GetTimerID(ByVal FaxID_ As Long) As Object
        Dim i As Integer
        If (retrylist.Count >= 0) Then
            For i = 0 To retrylist.Count - 1
                If retrylist.Item(i).FaxID = FaxID_ Then
                    Return retrylist.Item(i).TimerID
                End If
            Next i
        End If
        Return vbNull
    End Function

    Public Function IsFaxObjInList(ByVal FaxID_ As Long) As Boolean
        Dim i As Integer
        If (retrylist.Count >= 0) Then
            For i = 0 To retrylist.Count - 1
                If retrylist.Item(i).FaxID = FaxID_ Then
                    Return True
                End If
            Next i
        End If
        Return False
    End Function
    Public Function GetRetryNumber(ByVal FaxID_ As Long) As Integer
        Dim i As Integer
        If (retrylist.Count >= 0) Then
            For i = 0 To retrylist.Count - 1
                If retrylist.Item(i).FaxID = FaxID_ Then
                    Return retrylist.Item(i).numberOfRetries
                End If
            Next i
        End If
        Return -1
    End Function

    Public Function SetCurrentlySending(ByVal FaxID_ As Long, ByVal cr_ As Boolean) As Boolean
        Dim i As Integer
        If (retrylist.Count >= 0) Then
            For i = 0 To retrylist.Count - 1
                If retrylist.Item(i).FaxID = FaxID_ Then
                    retrylist.Item(i).currentlySending = cr_
                    Return True
                End If
            Next i
        End If
        Return False
    End Function

    Public Function DeleteFromList(ByVal FaxID_ As Long) As Boolean
        Dim i As Integer
        If (retrylist.Count >= 0) Then
            For i = 0 To retrylist.Count - 1
                If retrylist.Item(i).FaxID = FaxID_ Then
                    retrylist.RemoveAt(i)
                    Return True
                End If
            Next i
        End If
        Return False
    End Function

    Private Sub timer_Elapsed(ByVal sender As System.Object, ByVal e As System.Timers.ElapsedEventArgs)
        Dim iError As Integer
        Dim i As Integer
        iError = 0
        If (Not retrylist.Equals(vbNull)) Then
            For i = 0 To retrylist.Count - 1
                If (retrylist.Item(i).TimerID.Equals(sender)) Then
                    If (retrylist.Item(i).numberOfRetries > 0 And retrylist.Item(i).currentlySending = False) Then
                        FAX1.ChainOutItem(retrylist.Item(i).FaxID)
                        iError = FAX1.SendFaxObj(retrylist.Item(i).FaxID)
                        If (iError <> 0) Then
                            DeleteFromList(retrylist.Item(i).FaxID)
                            MsgBox("Cannot add the following fax object to queue: " + CStr(retrylist.Item(i).FaxID))
                            Exit For
                        Else : retrylist.Item(i).currentlySending = True
                        End If
                        retrylist.Item(i).numberOfRetries = retrylist.Item(i).numberOfRetries - 1
                    End If
                    Exit For
                End If
            Next i
        End If
    End Sub
    Public Sub AddToArrayA(ByVal PortName_ As String, ByVal FaxID_ As Long)
        ArrayA.Add(New ArrayAType(PortName_, FaxID_))
    End Sub
    Public Sub AddToArrayB(ByVal PortName_ As String, ByVal status_ As Long)
        ArrayB.Add(New ArrayBType(PortName_, status_))
    End Sub
    Public Sub DeleteFromArrayA(ByVal PortName_ As String, ByVal FaxID_ As Long)
        Dim i As Integer
        If (ArrayA.Count >= 0) Then
            For i = 0 To ArrayA.Count - 1
                If ArrayA.Item(i).PortName = PortName_ And ArrayA.Item(i).FaxID = FaxID_ Then
                    ArrayA.RemoveAt(i)
                End If
            Next i
        End If
    End Sub
    Public Sub DeleteFromArrayB(ByVal PortName_ As String, ByVal status_ As Long)
        Dim i As Integer
        If (ArrayB.Count >= 0) Then
            For i = 0 To ArrayB.Count - 1
                If ArrayB.Item(i).PortName = PortName_ And ArrayB.Item(i).status = status_ Then
                    ArrayB.RemoveAt(i)
                End If
            Next i
        End If
    End Sub
    Public Function GetFaxID(ByVal PortName_ As String) As Long
        Dim i As Integer
        If (ArrayA.Count >= 0) Then
            For i = 0 To ArrayA.Count - 1
                If ArrayA.Item(i).PortName = PortName_ Then
                    Return ArrayA.Item(i).FaxID
                End If
            Next i
        End If
        Return 0
    End Function
    Public Function GetStatus(ByVal PortName_ As String) As Long
        Dim i As Integer
        If (ArrayB.Count >= 0) Then
            For i = 0 To ArrayB.Count - 1
                If ArrayB.Item(i).PortName = PortName_ Then
                    Return ArrayB.Item(i).status
                End If
            Next i
        End If
        Return -1
    End Function
    Private Sub MenuFax_Popup(ByVal sender As Object, ByVal e As System.EventArgs) Handles MenuFax.Popup
        If (FAX1.DisplayFaxManager) Then
            MenuShowManager.Checked = True
        Else
            MenuShowManager.Checked = False
        End If
        If (Len(FAX1.AvailablePorts) > 0) Then
            MenuCom.Enabled = True
        Else : MenuCom.Enabled = False
        End If
    End Sub

    Private Sub MenuCom_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuCom.Click
        Dim dlgCom As OpenComPort = New OpenComPort
        dlgCom.pparent = Me
        dlgCom.ShowDialog()
    End Sub
End Class
Public Class retry
    Public FaxID As Long
    Public PortName As String
    Public TimerID As Object
    Public numberOfRetries As Integer
    Public currentlySending As Boolean
    Public Sub New(ByVal FaxID_ As Long, ByVal PortName_ As String)
        FaxID = FaxID_
        PortName = PortName_
        TimerID = vbNull
        numberOfRetries = 3
        currentlySending = False
    End Sub
End Class
Public Class ArrayAType
    Public PortName As String
    Public FaxID As Long
    Public Sub New(ByVal PortName_ As String, ByVal FaxID_ As Long)
        PortName = PortName_
        FaxID = FaxID_
    End Sub
End Class
Public Class ArrayBType
    Public PortName As String
    Public status As Long
    Public Sub New(ByVal PortName_ As String, ByVal status_ As Long)
        PortName = PortName_
        status = status_
    End Sub
End Class