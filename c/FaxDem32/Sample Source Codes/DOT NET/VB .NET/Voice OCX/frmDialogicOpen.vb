Option Strict Off
Option Explicit On
Public Class frmDialogicOpen
    Inherits System.Windows.Forms.Form
#Region "Windows Form Designer generated code "
    Public Sub New()
        MyBase.New()
        If m_vb6FormDefInstance Is Nothing Then
            If m_InitializingDefInstance Then
                m_vb6FormDefInstance = Me
            Else
                Try
                    'For the start-up form, the first instance created is the default instance.
                    If System.Reflection.Assembly.GetExecutingAssembly.EntryPoint.DeclaringType Is Me.GetType Then
                        m_vb6FormDefInstance = Me
                    End If
                Catch
                End Try
            End If
        End If
        'This call is required by the Windows Form Designer.
        InitializeComponent()
    End Sub
    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal Disposing As Boolean)
        If Disposing Then
            If Not components Is Nothing Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(Disposing)
    End Sub
    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer
    Public ToolTip1 As System.Windows.Forms.ToolTip
    Public WithEvents Protocol As System.Windows.Forms.TextBox
    Public WithEvents LineType As System.Windows.Forms.ComboBox
    Public WithEvents btnCancel As System.Windows.Forms.Button
    Public WithEvents btnOK As System.Windows.Forms.Button
    Public WithEvents Label2 As System.Windows.Forms.Label
    Public WithEvents Label1 As System.Windows.Forms.Label
    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.
    'Do not modify it using the code editor.
    Friend WithEvents ChannelList As System.Windows.Forms.ListBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmDialogicOpen))
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.Protocol = New System.Windows.Forms.TextBox()
        Me.LineType = New System.Windows.Forms.ComboBox()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.btnOK = New System.Windows.Forms.Button()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.ChannelList = New System.Windows.Forms.ListBox()
        Me.SuspendLayout()
        '
        'Protocol
        '
        Me.Protocol.AcceptsReturn = True
        Me.Protocol.AutoSize = False
        Me.Protocol.BackColor = System.Drawing.SystemColors.Window
        Me.Protocol.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.Protocol.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Protocol.ForeColor = System.Drawing.SystemColors.WindowText
        Me.Protocol.Location = New System.Drawing.Point(256, 184)
        Me.Protocol.MaxLength = 0
        Me.Protocol.Name = "Protocol"
        Me.Protocol.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Protocol.Size = New System.Drawing.Size(137, 19)
        Me.Protocol.TabIndex = 6
        Me.Protocol.Text = ""
        '
        'LineType
        '
        Me.LineType.BackColor = System.Drawing.SystemColors.Window
        Me.LineType.Cursor = System.Windows.Forms.Cursors.Default
        Me.LineType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.LineType.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LineType.ForeColor = System.Drawing.SystemColors.WindowText
        Me.LineType.Items.AddRange(New Object() {"Analog", "ISDN PRI", "T1", "E1"})
        Me.LineType.Location = New System.Drawing.Point(72, 184)
        Me.LineType.Name = "LineType"
        Me.LineType.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.LineType.Size = New System.Drawing.Size(113, 22)
        Me.LineType.TabIndex = 4
        '
        'btnCancel
        '
        Me.btnCancel.BackColor = System.Drawing.SystemColors.Control
        Me.btnCancel.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancel.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnCancel.Location = New System.Drawing.Point(328, 40)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnCancel.Size = New System.Drawing.Size(65, 25)
        Me.btnCancel.TabIndex = 2
        Me.btnCancel.Text = "Cancel"
        '
        'btnOK
        '
        Me.btnOK.BackColor = System.Drawing.SystemColors.Control
        Me.btnOK.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnOK.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnOK.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnOK.Location = New System.Drawing.Point(328, 8)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnOK.Size = New System.Drawing.Size(65, 25)
        Me.btnOK.TabIndex = 1
        Me.btnOK.Text = "OK"
        '
        'Label2
        '
        Me.Label2.BackColor = System.Drawing.SystemColors.Control
        Me.Label2.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label2.Location = New System.Drawing.Point(200, 184)
        Me.Label2.Name = "Label2"
        Me.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label2.Size = New System.Drawing.Size(49, 17)
        Me.Label2.TabIndex = 5
        Me.Label2.Text = "Protocol:"
        '
        'Label1
        '
        Me.Label1.BackColor = System.Drawing.SystemColors.Control
        Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(8, 184)
        Me.Label1.Name = "Label1"
        Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label1.Size = New System.Drawing.Size(57, 17)
        Me.Label1.TabIndex = 3
        Me.Label1.Text = "Line Type:"
        '
        'ChannelList
        '
        Me.ChannelList.ItemHeight = 14
        Me.ChannelList.Location = New System.Drawing.Point(8, 8)
        Me.ChannelList.Name = "ChannelList"
        Me.ChannelList.Size = New System.Drawing.Size(296, 158)
        Me.ChannelList.TabIndex = 7
        '
        'frmDialogicOpen
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(400, 216)
        Me.Controls.AddRange(New System.Windows.Forms.Control() {Me.ChannelList, Me.Protocol, Me.LineType, Me.btnCancel, Me.btnOK, Me.Label2, Me.Label1})
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Location = New System.Drawing.Point(3, 22)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmDialogicOpen"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Open Dialogic Channel"
        Me.ResumeLayout(False)

    End Sub
#End Region
#Region "Upgrade Support "
    Private Shared m_vb6FormDefInstance As frmDialogicOpen
    Private Shared m_InitializingDefInstance As Boolean
    Public Shared Property DefInstance() As frmDialogicOpen
        Get
            If m_vb6FormDefInstance Is Nothing OrElse m_vb6FormDefInstance.IsDisposed Then
                m_InitializingDefInstance = True
                m_vb6FormDefInstance = New frmDialogicOpen()
                m_InitializingDefInstance = False
            End If
            DefInstance = m_vb6FormDefInstance
        End Get
        Set(ByVal Value As frmDialogicOpen)
            m_vb6FormDefInstance = Value
        End Set
    End Property
#End Region
    Private bLogEnabled As Boolean
    Private ModemID As Integer
    Private ModemInd As Short
    Public pparent As Form1

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Close()
    End Sub

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        Dim nIndex As Integer
        'Dim i As Integer

        nIndex = -1
        nIndex = ChannelList.SelectedIndex

        If nIndex <> -1 Then
            ModemID = pparent.VoiceOCX.CreateModemObject(2)
            If ModemID <> 0 Then
                ModemInd = pparent.AddNewModem(ModemID)
                If ModemInd <> 0 Then
                    pparent.fModemID(ModemInd, 1) = 2
                    If LineType.SelectedIndex = 0 Then
                        '3 is ANALOG
                        pparent.VoiceOCX.SetDialogicLineType(ModemID, 3)
                    ElseIf LineType.SelectedIndex = 1 Then
                        '2 is ISDN PRI
                        pparent.VoiceOCX.SetDialogicLineType(ModemID, 2)
                    ElseIf LineType.SelectedIndex = 2 Or LineType.SelectedIndex = 3 Then
                        '1 is T1/E1
                        pparent.VoiceOCX.SetDialogicLineType(ModemID, 1)
                        pparent.VoiceOCX.SetDialogicProtocol(ModemID, Protocol.Text)
                    End If

                    If pparent.VoiceOCX.OpenPort(ModemID, ChannelList.SelectedItem) = 0 Then
                        btnOK.Enabled = False
                        btnCancel.Enabled = False
                    Else
                        MsgBox("Cannot open channel: " + Str(ChannelList.SelectedItem))
                    End If
                End If
            End If
        End If
    End Sub

    Private Sub frmDialogicOpen_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim nBoards As Integer
        Dim nIndex As Integer
        Dim szChannel As String
        Dim i, j As Integer
        Dim szType As String = "", szManufact As String = "", szModel As String = ""
        Dim bcStr As String

        bLogEnabled = False
        ModemID = 0

        nIndex = 0
        nBoards = pparent.VoiceOCX.GetDialogicBoardNum
        For i = 1 To nBoards
            For j = 1 To pparent.VoiceOCX.GetDialogicChannelNum(i)
                If pparent.VoiceOCX.IsDialogicChannelFree(i, j) Then
                    szChannel = "dxxxB"
                    bcStr = Str(i)
                    bcStr = bcStr.Substring(bcStr.Length - 1)
                    szChannel = szChannel + bcStr + "C"
                    bcStr = Str(j)
                    bcStr = bcStr.Substring(bcStr.Length - 1)
                    szChannel = szChannel + bcStr

                    ChannelList.Items.Add(szChannel)
                End If
                nIndex = nIndex + 1
            Next
        Next
        LineType.SelectedIndex = 0
        Protocol.Enabled = False
    End Sub

    Public Sub VoiceOCX_PortOpen()
        MsgBox("Channel opened")
        Close()
    End Sub
    Public Sub VoiceOCX_ModemError()
        MsgBox("Open channel failed!")
        btnOK.Enabled = False
        btnCancel.Enabled = False
        pparent.fModemID(ModemInd, 1) = -1
    End Sub

    Public Function GetSelectedChannel() As Integer
        GetSelectedChannel = ModemID
    End Function

    Public Function LogEnabled() As Boolean
        LogEnabled = bLogEnabled
    End Function

    Private Sub LineType_Click()
        If LineType.SelectedIndex > 1 Then
            Protocol.Enabled = True
        Else
            Protocol.Enabled = False
        End If
    End Sub

End Class