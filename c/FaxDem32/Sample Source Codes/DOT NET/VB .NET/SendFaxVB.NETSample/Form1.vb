Public Class Form1
    Inherits System.Windows.Forms.Form
    Private currdir As String

    Friend WithEvents FAX1 As FAXLib.FAX

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
    Friend WithEvents MenuExit As System.Windows.Forms.MenuItem
    Friend WithEvents MenuClosePort As System.Windows.Forms.MenuItem
    Friend WithEvents MenuSend As System.Windows.Forms.MenuItem
    Friend WithEvents MenuHelp As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem4 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem1 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem3 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuItem2 As System.Windows.Forms.MenuItem
    Friend WithEvents MenuCom As System.Windows.Forms.MenuItem
    'Friend WithEvents FAX1 As AxFAXLib.AxFAX
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(Form1))
        Me.MainMenu1 = New System.Windows.Forms.MainMenu
        Me.MenuItem4 = New System.Windows.Forms.MenuItem
        Me.MenuItem1 = New System.Windows.Forms.MenuItem
        Me.MenuItem3 = New System.Windows.Forms.MenuItem
        Me.MenuExit = New System.Windows.Forms.MenuItem
        Me.MenuFax = New System.Windows.Forms.MenuItem
        Me.MenuCom = New System.Windows.Forms.MenuItem
        Me.MenuSend = New System.Windows.Forms.MenuItem
        Me.MenuClosePort = New System.Windows.Forms.MenuItem
        Me.MenuHelp = New System.Windows.Forms.MenuItem
        Me.MenuAbout = New System.Windows.Forms.MenuItem
        Me.MenuItem2 = New System.Windows.Forms.MenuItem
        Me.MessageBox = New System.Windows.Forms.ListBox
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
        Me.MenuFax.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.MenuCom, Me.MenuSend, Me.MenuClosePort})
        Me.MenuFax.Text = "F&ax"
        '
        'MenuCom
        '
        Me.MenuCom.Index = 0
        Me.MenuCom.Text = "&Open Com Port..."
        '
        'MenuSend
        '
        Me.MenuSend.Enabled = False
        Me.MenuSend.Index = 1
        Me.MenuSend.Text = "Sen&d..."
        '
        'MenuClosePort
        '
        Me.MenuClosePort.Enabled = False
        Me.MenuClosePort.Index = 2
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
        'Form1
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(328, 273)
        Me.Controls.Add(Me.MessageBox)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Menu = Me.MainMenu1
        Me.Name = "Form1"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Fax ActiveX Control - Visual Basic .NET SendFax Sample"
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub MenuAbout_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuAbout.Click
        Dim dlgAbout As About = New About()

        dlgAbout.ShowDialog()
    End Sub

    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        currdir = CurDir()
        FAX1 = CreateObject("Fax.FaxCtrl.1")
        FAX1.CloseAllPorts()
        MessageBox.Items.Add("This sample shows how to send a fax using a COM port.")
        MessageBox.Items.Add("To open a COM port choose Open Com Port... from Fax menu")
        MessageBox.Items.Add("and select from the available ports. To send a fax select Send...")
        MessageBox.Items.Add("from Fax menu, specify the file you would like to send and the")
        MessageBox.Items.Add("destination phone number. You can send the fax using the selected")
        MessageBox.Items.Add("port if checking Immediate radio button or put the fax in queue")
        MessageBox.Items.Add("by checking Queue button.")
        MessageBox.Items.Add("To close a port choose Close Com Port... from Fax menu and")
        MessageBox.Items.Add("select from the open ports.")
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

    Private Sub FAX1_Dial(ByVal sender As System.Object, ByVal e As AxFAXLib._DFAXEvents_DialEvent)
        MessageBox.Items.Add("Dialing on " + e.portName)
    End Sub

    Private Sub FAX1_EndPage(ByVal sender As System.Object, ByVal e As AxFAXLib._DFAXEvents_EndPageEvent)
        MessageBox.Items.Add("Ending page " + Str(e.lPageNumber) + " on port " + e.szPort)
    End Sub

    Private Sub FAX1_EndSend(ByVal sender As System.Object, ByVal e As AxFAXLib._DFAXEvents_EndSendEvent)
        MessageBox.Items.Add("Sending finished on " + e.portName)
        MessageBox.Items.Add("Remote ID : " + e.remoteID)
        If (FAX1.ClearFaxObject(e.faxID)) Then
            MessageBox.Items.Add("  -  Error deleting faxobject! ID = " + Str(e.faxID))
        End If
    End Sub

    Private Sub FAX1_Ring(ByVal sender As System.Object, ByVal e As AxFAXLib._DFAXEvents_RingEvent)
        MessageBox.Items.Add("Ring detected on " + e.portName)
    End Sub

    Private Sub FAX1_StartPage(ByVal sender As System.Object, ByVal e As AxFAXLib._DFAXEvents_StartPageEvent)
        MessageBox.Items.Add("Starting page " + Str(e.lPageNumber) + " on port " + e.szPort)
    End Sub

    Private Sub FAX1_StartSend(ByVal sender As System.Object, ByVal e As AxFAXLib._DFAXEvents_StartSendEvent)
        MessageBox.Items.Add("Starting to send on " + e.portName)
    End Sub

    Private Sub FAX1_TerminateExt(ByVal sender As System.Object, ByVal e As AxFAXLib._DFAXEvents_TerminateExtEvent)
        MessageBox.Items.Add("Transmission terminated on " + e.lpPort)
        MessageBox.Items.Add("   -  Termination status : " + FAX1.ReturnErrorString(e.lStatus) + ", Connected for " + Str(e.connectTime) + " milliseconds.")
    End Sub

    Private Sub Form1_Closed(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Closed
        Cursor = Cursors.WaitCursor
        Enabled = False
        FAX1.CloseAllPorts()
        Enabled = True
        Cursor = Cursors.Default
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
    Private Sub MenuFax_Popup(ByVal sender As Object, ByVal e As System.EventArgs) Handles MenuFax.Popup
        If Len(FAX1.AvailablePorts) > 0 Then
            MenuCom.Enabled = True
        Else : MenuCom.Enabled = False
        End If
    End Sub

    Private Sub MenuCom_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MenuCom.Click
        Dim dlgCom As OpenComPort = New OpenComPort
        dlgCom.pparent = Me
        dlgCom.ShowDialog()
    End Sub

    Private Sub FAX1_Terminate(ByVal sender As System.Object, ByVal e As AxFAXLib._DFAXEvents_TerminateEvent)
        MsgBox("Terminate Status: " + Convert.ToString(e.lStatus))
    End Sub
End Class
