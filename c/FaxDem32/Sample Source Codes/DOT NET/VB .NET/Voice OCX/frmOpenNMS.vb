Option Strict Off
Option Explicit On 
Public Class frmOpenNMS
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
    Public WithEvents DIDText As System.Windows.Forms.TextBox
    Public WithEvents ProtocolCombo As System.Windows.Forms.ComboBox
    Public WithEvents chbLogEn As System.Windows.Forms.CheckBox
    Public WithEvents btnCancel As System.Windows.Forms.Button
    Public WithEvents btnOK As System.Windows.Forms.Button
    Public WithEvents Label2 As System.Windows.Forms.Label
    Public WithEvents Label1 As System.Windows.Forms.Label
    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.
    'Do not modify it using the code editor.
    Friend WithEvents lvChannelList As System.Windows.Forms.ListBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmOpenNMS))
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.DIDText = New System.Windows.Forms.TextBox()
        Me.ProtocolCombo = New System.Windows.Forms.ComboBox()
        Me.chbLogEn = New System.Windows.Forms.CheckBox()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.btnOK = New System.Windows.Forms.Button()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.lvChannelList = New System.Windows.Forms.ListBox()
        Me.SuspendLayout()
        '
        'DIDText
        '
        Me.DIDText.AcceptsReturn = True
        Me.DIDText.AutoSize = False
        Me.DIDText.BackColor = System.Drawing.SystemColors.Window
        Me.DIDText.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.DIDText.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.DIDText.ForeColor = System.Drawing.SystemColors.WindowText
        Me.DIDText.Location = New System.Drawing.Point(96, 246)
        Me.DIDText.MaxLength = 0
        Me.DIDText.Name = "DIDText"
        Me.DIDText.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.DIDText.Size = New System.Drawing.Size(49, 19)
        Me.DIDText.TabIndex = 7
        Me.DIDText.Text = "3"
        '
        'ProtocolCombo
        '
        Me.ProtocolCombo.BackColor = System.Drawing.SystemColors.Window
        Me.ProtocolCombo.Cursor = System.Windows.Forms.Cursors.Default
        Me.ProtocolCombo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ProtocolCombo.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ProtocolCombo.ForeColor = System.Drawing.SystemColors.WindowText
        Me.ProtocolCombo.Items.AddRange(New Object() {"Analog Loop Start (LPS0)", "Digital/Analog Wink Start (inbound only) (DID0)", "Digital/Analog Wink Start (outbound only) (OGT0)", "Digital/Analog Wink Start (WNK0)", "Analog Wink Start (WNK1)", "Digital Loop Start OPS-FX (LPS8)", "Feature Group D (inbound only) (FDI0)", "Digital Loop Start OPS-SA (LPS9)", "Digital Ground Start OPS-FX (GST8)", "Digital Ground Start OPS-SA (GST9)", "ISDN protocol (ISD0)", "MFC R2 protocol (MFC0)"})
        Me.ProtocolCombo.Location = New System.Drawing.Point(8, 216)
        Me.ProtocolCombo.Name = "ProtocolCombo"
        Me.ProtocolCombo.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.ProtocolCombo.Size = New System.Drawing.Size(305, 22)
        Me.ProtocolCombo.TabIndex = 5
        '
        'chbLogEn
        '
        Me.chbLogEn.BackColor = System.Drawing.SystemColors.Control
        Me.chbLogEn.Cursor = System.Windows.Forms.Cursors.Default
        Me.chbLogEn.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.chbLogEn.ForeColor = System.Drawing.SystemColors.ControlText
        Me.chbLogEn.Location = New System.Drawing.Point(8, 176)
        Me.chbLogEn.Name = "chbLogEn"
        Me.chbLogEn.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.chbLogEn.Size = New System.Drawing.Size(113, 17)
        Me.chbLogEn.TabIndex = 2
        Me.chbLogEn.Text = "Enable Log"
        '
        'btnCancel
        '
        Me.btnCancel.BackColor = System.Drawing.SystemColors.Control
        Me.btnCancel.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancel.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnCancel.Location = New System.Drawing.Point(320, 32)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnCancel.Size = New System.Drawing.Size(65, 25)
        Me.btnCancel.TabIndex = 1
        Me.btnCancel.Text = "Cancel"
        '
        'btnOK
        '
        Me.btnOK.BackColor = System.Drawing.SystemColors.Control
        Me.btnOK.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnOK.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnOK.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnOK.Location = New System.Drawing.Point(320, 0)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnOK.Size = New System.Drawing.Size(65, 25)
        Me.btnOK.TabIndex = 0
        Me.btnOK.Text = "OK"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.BackColor = System.Drawing.SystemColors.Control
        Me.Label2.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label2.Location = New System.Drawing.Point(8, 248)
        Me.Label2.Name = "Label2"
        Me.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label2.Size = New System.Drawing.Size(84, 13)
        Me.Label2.TabIndex = 6
        Me.Label2.Text = "DID/DNIS digits:"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.BackColor = System.Drawing.SystemColors.Control
        Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(8, 200)
        Me.Label1.Name = "Label1"
        Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label1.Size = New System.Drawing.Size(129, 13)
        Me.Label1.TabIndex = 4
        Me.Label1.Text = "NMS Telephony Protocol:"
        '
        'lvChannelList
        '
        Me.lvChannelList.ItemHeight = 14
        Me.lvChannelList.Location = New System.Drawing.Point(8, 8)
        Me.lvChannelList.Name = "lvChannelList"
        Me.lvChannelList.Size = New System.Drawing.Size(288, 158)
        Me.lvChannelList.TabIndex = 8
        '
        'frmOpenNMS
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(391, 280)
        Me.Controls.AddRange(New System.Windows.Forms.Control() {Me.lvChannelList, Me.DIDText, Me.ProtocolCombo, Me.chbLogEn, Me.btnCancel, Me.btnOK, Me.Label2, Me.Label1})
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Location = New System.Drawing.Point(4, 23)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmOpenNMS"
        Me.Text = "Open NMS Channel"
        Me.ResumeLayout(False)

    End Sub
#End Region
#Region "Upgrade Support "
    Private Shared m_vb6FormDefInstance As frmOpenNMS
    Private Shared m_InitializingDefInstance As Boolean
    Public Shared Property DefInstance() As frmOpenNMS
        Get
            If m_vb6FormDefInstance Is Nothing OrElse m_vb6FormDefInstance.IsDisposed Then
                m_InitializingDefInstance = True
                m_vb6FormDefInstance = New frmOpenNMS()
                m_InitializingDefInstance = False
            End If
            DefInstance = m_vb6FormDefInstance
        End Get
        Set(ByVal Value As frmOpenNMS)
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
        Dim Index As Integer
        Dim Protocol As String
        Dim didDigits As String

        bLogEnabled = chbLogEn.Checked
        nIndex = -1
        nIndex = lvChannelList.SelectedIndex

        If nIndex = -1 Then
            lvChannelList.SelectedIndex = 0
            nIndex = 1
        End If
        If nIndex <> -1 Then
            ModemID = pparent.VoiceOCX.CreateModemObject(5)
            If ModemID <> 0 Then
                ModemInd = pparent.AddNewModem(ModemID)
                If ModemInd <> 0 Then
                    pparent.fModemID(ModemInd, 1) = 4

                    'Set selected protocol
                    Index = ProtocolCombo.SelectedIndex
                    Protocol = GetSelectedProtocol(Index)
                    pparent.VoiceOCX.SetNMSProtocol(Protocol)

                    'Set specified DID/DNIS digits
                    didDigits = DIDText.Text
                    pparent.VoiceOCX.SetDIDDigitNumber(ModemID, Val(didDigits))

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

    Function GetSelectedProtocol(ByVal Index As Integer) As String
        Dim Protocol As String
        Select Case Index
            Case 0
                Protocol = "LPS0"
            Case 1
                Protocol = "DID0"
            Case 2
                Protocol = "OGT0"
            Case 3
                Protocol = "WNK0"
            Case 4
                Protocol = "WNK1"
            Case 5
                Protocol = "LPS8"
            Case 6
                Protocol = "FDI0"
            Case 7
                Protocol = "LPS9"
            Case 8
                Protocol = "GST8"
            Case 9
                Protocol = "GST9"
            Case 10
                Protocol = "ISD0"
            Case 11
                Protocol = "MFC0"

            Case Else
                Protocol = "LPS0"
        End Select
        GetSelectedProtocol = Protocol
    End Function

    Public Sub VoiceOCX_PortOpen()
        MsgBox("Channel opened")
        Close()
    End Sub

    Public Sub VoiceOCX_ModemError()
        MsgBox("Open channel failed!")
        btnOK.Enabled = True
        btnCancel.Enabled = True
        pparent.fModemID(ModemInd, 1) = -1
    End Sub

    Public Function GetSelectedChannel() As Integer
        GetSelectedChannel = ModemID
    End Function

    Public Function LogEnabled() As Boolean
        LogEnabled = bLogEnabled
    End Function

    Private Sub frmOpenNMS_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim nBoards As Integer
        Dim nIndex As Integer
        Dim szChannel As String
        Dim nChannels As Integer = 0
        Dim i, j As Integer
        Dim bcStr As String

        bLogEnabled = False
        ModemID = 0


        nIndex = 0
        nBoards = pparent.VoiceOCX.GetNMSBoardNum
        For i = 0 To nBoards
            For j = 0 To pparent.VoiceOCX.GetNMSChannelNum(i) - 1
                If pparent.VoiceOCX.IsNMSChannelFree(i, j) Then
                    szChannel = "NMS_B"
                    bcStr = Str(i)
                    bcStr = bcStr.Substring(bcStr.Length - 1)
                    szChannel = szChannel + bcStr + "CH"
                    bcStr = Str(j)
                    bcStr = bcStr.Substring(bcStr.Length - 1)
                    szChannel = szChannel + bcStr

                    nChannels = nChannels + 1

                    lvChannelList.Items.Add(szChannel)
                End If
                nIndex = nIndex + 1
            Next
        Next

        If nChannels > 0 Then
            btnOK.Enabled = True
        Else
            btnOK.Enabled = False
        End If

        ProtocolCombo.SelectedIndex = 0
    End Sub
End Class