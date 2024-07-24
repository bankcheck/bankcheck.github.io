Option Strict Off
Option Explicit On
Public Class frmOpenBrook
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
    Public WithEvents btnTest As System.Windows.Forms.Button
    Public WithEvents btnCancel As System.Windows.Forms.Button
    Public WithEvents btnOK As System.Windows.Forms.Button
    Public WithEvents ModemType As System.Windows.Forms.TextBox
    Public WithEvents chbLogEn As System.Windows.Forms.CheckBox
    Public WithEvents lvChannelList As System.Windows.Forms.ListBox
    Public WithEvents Label3 As System.Windows.Forms.Label
    Public WithEvents Label1 As System.Windows.Forms.Label
    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmOpenBrook))
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.btnTest = New System.Windows.Forms.Button()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.btnOK = New System.Windows.Forms.Button()
        Me.ModemType = New System.Windows.Forms.TextBox()
        Me.chbLogEn = New System.Windows.Forms.CheckBox()
        Me.lvChannelList = New System.Windows.Forms.ListBox()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.SuspendLayout()
        '
        'btnTest
        '
        Me.btnTest.BackColor = System.Drawing.SystemColors.Control
        Me.btnTest.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnTest.Enabled = False
        Me.btnTest.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnTest.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnTest.Location = New System.Drawing.Point(304, 72)
        Me.btnTest.Name = "btnTest"
        Me.btnTest.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnTest.Size = New System.Drawing.Size(65, 25)
        Me.btnTest.TabIndex = 7
        Me.btnTest.Text = "&Test"
        '
        'btnCancel
        '
        Me.btnCancel.BackColor = System.Drawing.SystemColors.Control
        Me.btnCancel.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancel.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnCancel.Location = New System.Drawing.Point(304, 40)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnCancel.Size = New System.Drawing.Size(65, 25)
        Me.btnCancel.TabIndex = 6
        Me.btnCancel.Text = "Cancel"
        '
        'btnOK
        '
        Me.btnOK.BackColor = System.Drawing.SystemColors.Control
        Me.btnOK.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnOK.Enabled = False
        Me.btnOK.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnOK.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnOK.Location = New System.Drawing.Point(304, 8)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnOK.Size = New System.Drawing.Size(65, 25)
        Me.btnOK.TabIndex = 5
        Me.btnOK.Text = "OK"
        '
        'ModemType
        '
        Me.ModemType.AcceptsReturn = True
        Me.ModemType.AutoSize = False
        Me.ModemType.BackColor = System.Drawing.SystemColors.Window
        Me.ModemType.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.ModemType.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ModemType.ForeColor = System.Drawing.SystemColors.WindowText
        Me.ModemType.Location = New System.Drawing.Point(120, 24)
        Me.ModemType.MaxLength = 0
        Me.ModemType.Name = "ModemType"
        Me.ModemType.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.ModemType.Size = New System.Drawing.Size(169, 19)
        Me.ModemType.TabIndex = 4
        Me.ModemType.Text = "Unknown Modem"
        '
        'chbLogEn
        '
        Me.chbLogEn.BackColor = System.Drawing.SystemColors.Control
        Me.chbLogEn.Cursor = System.Windows.Forms.Cursors.Default
        Me.chbLogEn.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.chbLogEn.ForeColor = System.Drawing.SystemColors.ControlText
        Me.chbLogEn.Location = New System.Drawing.Point(120, 48)
        Me.chbLogEn.Name = "chbLogEn"
        Me.chbLogEn.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.chbLogEn.Size = New System.Drawing.Size(105, 17)
        Me.chbLogEn.TabIndex = 2
        Me.chbLogEn.Text = "Enable Log"
        '
        'lvChannelList
        '
        Me.lvChannelList.BackColor = System.Drawing.SystemColors.Window
        Me.lvChannelList.Cursor = System.Windows.Forms.Cursors.Default
        Me.lvChannelList.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lvChannelList.ForeColor = System.Drawing.SystemColors.WindowText
        Me.lvChannelList.ItemHeight = 14
        Me.lvChannelList.Location = New System.Drawing.Point(8, 40)
        Me.lvChannelList.Name = "lvChannelList"
        Me.lvChannelList.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lvChannelList.Size = New System.Drawing.Size(105, 60)
        Me.lvChannelList.TabIndex = 1
        '
        'Label3
        '
        Me.Label3.BackColor = System.Drawing.SystemColors.Control
        Me.Label3.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label3.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label3.Location = New System.Drawing.Point(120, 8)
        Me.Label3.Name = "Label3"
        Me.Label3.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label3.Size = New System.Drawing.Size(97, 17)
        Me.Label3.TabIndex = 3
        Me.Label3.Text = "Modem Type"
        '
        'Label1
        '
        Me.Label1.BackColor = System.Drawing.SystemColors.Control
        Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(8, 8)
        Me.Label1.Name = "Label1"
        Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label1.Size = New System.Drawing.Size(97, 24)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Available Channels"
        '
        'frmOpenBrook
        '
        Me.AcceptButton = Me.btnOK
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(376, 106)
        Me.Controls.AddRange(New System.Windows.Forms.Control() {Me.btnTest, Me.btnCancel, Me.btnOK, Me.ModemType, Me.chbLogEn, Me.lvChannelList, Me.Label3, Me.Label1})
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Location = New System.Drawing.Point(3, 22)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmOpenBrook"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Open Brooktrout Channel"
        Me.ResumeLayout(False)

    End Sub
#End Region
#Region "Upgrade Support "
    Private Shared m_vb6FormDefInstance As frmOpenBrook
    Private Shared m_InitializingDefInstance As Boolean
    Public Shared Property DefInstance() As frmOpenBrook
        Get
            If m_vb6FormDefInstance Is Nothing OrElse m_vb6FormDefInstance.IsDisposed Then
                m_InitializingDefInstance = True
                m_vb6FormDefInstance = New frmOpenBrook()
                m_InitializingDefInstance = False
            End If
            DefInstance = m_vb6FormDefInstance
        End Get
        Set(ByVal Value As frmOpenBrook)
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

        bLogEnabled = chbLogEn.Checked

        nIndex = lvChannelList.SelectedIndex
        If nIndex <> -1 Then
            ModemID = pparent.VoiceOCX.CreateModemObject(4)
            If ModemID <> 0 Then
                ModemInd = pparent.AddNewModem(ModemID)
                If ModemInd <> 0 Then
                    pparent.fModemID(ModemInd, 1) = 3
                    If pparent.VoiceOCX.OpenPort(ModemID, lvChannelList.SelectedItem) = 0 Then
                        btnOK.Enabled = False
                        btnCancel.Enabled = False
                    Else
                        MsgBox("Cannot open channel: " + Str(lvChannelList.SelectedItem))
                    End If
                End If
            End If
        End If
    End Sub

    Private Sub btnTest_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnTest.Click
        Dim szType As String

        If lvChannelList.SelectedIndex <> -1 Then
            pparent.VoiceOCX.GetBrooktroutChannelType(lvChannelList.SelectedIndex, szType, 50)
            ModemType.Text = szType
        End If
    End Sub

    Public Sub VoiceOCX_PortOpen()
        MsgBox("Channel opened")
        Close()
    End Sub

    Public Sub VoiceOCX_ModemError()
        MsgBox("Open channel failed!")
        btnOK.Enabled = True
        btnCancel.Enabled = True
        pparent.DeleteModem(ModemID)
        pparent.VoiceOCX.DestroyModemObject(ModemID)
    End Sub

    Public Function GetSelectedChannel() As Integer
        GetSelectedChannel = ModemID
    End Function

    Public Function LogEnabled() As Boolean
        LogEnabled = bLogEnabled
    End Function

    Private Sub frmOpenBrook_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim nChannels As Integer
        Dim szChannel As String
        Dim nIndex As Integer
        Dim bcStr As String

        nChannels = 0

        For nIndex = 0 To 96
            If pparent.VoiceOCX.IsBrooktroutChannelFree(nIndex) <> False Then
                szChannel = "CHANNEL"
                bcStr = Str(nIndex)
                bcStr = bcStr.Substring(bcStr.Length - 1)
                szChannel = szChannel + bcStr
                lvChannelList.Items.Add(szChannel)
                nChannels = nChannels + 1
            End If
        Next

        If nChannels > 0 Then
            btnOK.Enabled = True
            btnTest.Enabled = True
        End If
    End Sub
End Class