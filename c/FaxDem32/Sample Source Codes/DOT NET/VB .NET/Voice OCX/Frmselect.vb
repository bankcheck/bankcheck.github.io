Option Strict Off
Option Explicit On
Public Class frmSelectPort
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
    Public WithEvents btnLog As System.Windows.Forms.CheckBox
    Public WithEvents ModemCaps As System.Windows.Forms.TextBox
    Public WithEvents Model As System.Windows.Forms.TextBox
    Public WithEvents Manufacturer As System.Windows.Forms.TextBox
    Public WithEvents cbModemType As System.Windows.Forms.ComboBox
    Public WithEvents btnCancel As System.Windows.Forms.Button
    Public WithEvents btnTest As System.Windows.Forms.Button
    Public WithEvents btnOpenPort As System.Windows.Forms.Button
    Public WithEvents AllPorts As System.Windows.Forms.ComboBox
    Public WithEvents Label2 As System.Windows.Forms.Label
    Public WithEvents Label5 As System.Windows.Forms.Label
    Public WithEvents Label4 As System.Windows.Forms.Label
    Public WithEvents Label3 As System.Windows.Forms.Label
    Public WithEvents Label1 As System.Windows.Forms.Label
    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmSelectPort))
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.btnLog = New System.Windows.Forms.CheckBox()
        Me.ModemCaps = New System.Windows.Forms.TextBox()
        Me.Model = New System.Windows.Forms.TextBox()
        Me.Manufacturer = New System.Windows.Forms.TextBox()
        Me.cbModemType = New System.Windows.Forms.ComboBox()
        Me.btnCancel = New System.Windows.Forms.Button()
        Me.btnTest = New System.Windows.Forms.Button()
        Me.btnOpenPort = New System.Windows.Forms.Button()
        Me.AllPorts = New System.Windows.Forms.ComboBox()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.SuspendLayout()
        '
        'btnLog
        '
        Me.btnLog.BackColor = System.Drawing.SystemColors.Control
        Me.btnLog.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnLog.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnLog.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnLog.Location = New System.Drawing.Point(8, 232)
        Me.btnLog.Name = "btnLog"
        Me.btnLog.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnLog.Size = New System.Drawing.Size(81, 17)
        Me.btnLog.TabIndex = 6
        Me.btnLog.Text = "Enable &Log"
        '
        'ModemCaps
        '
        Me.ModemCaps.AcceptsReturn = True
        Me.ModemCaps.AutoSize = False
        Me.ModemCaps.BackColor = System.Drawing.SystemColors.Window
        Me.ModemCaps.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.ModemCaps.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ModemCaps.ForeColor = System.Drawing.SystemColors.WindowText
        Me.ModemCaps.Location = New System.Drawing.Point(8, 200)
        Me.ModemCaps.MaxLength = 0
        Me.ModemCaps.Name = "ModemCaps"
        Me.ModemCaps.ReadOnly = True
        Me.ModemCaps.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.ModemCaps.Size = New System.Drawing.Size(289, 25)
        Me.ModemCaps.TabIndex = 5
        Me.ModemCaps.Text = ""
        '
        'Model
        '
        Me.Model.AcceptsReturn = True
        Me.Model.AutoSize = False
        Me.Model.BackColor = System.Drawing.SystemColors.Window
        Me.Model.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.Model.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Model.ForeColor = System.Drawing.SystemColors.WindowText
        Me.Model.Location = New System.Drawing.Point(8, 152)
        Me.Model.MaxLength = 0
        Me.Model.Name = "Model"
        Me.Model.ReadOnly = True
        Me.Model.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Model.Size = New System.Drawing.Size(289, 25)
        Me.Model.TabIndex = 4
        Me.Model.Text = ""
        '
        'Manufacturer
        '
        Me.Manufacturer.AcceptsReturn = True
        Me.Manufacturer.AutoSize = False
        Me.Manufacturer.BackColor = System.Drawing.SystemColors.Window
        Me.Manufacturer.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.Manufacturer.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Manufacturer.ForeColor = System.Drawing.SystemColors.WindowText
        Me.Manufacturer.Location = New System.Drawing.Point(8, 104)
        Me.Manufacturer.MaxLength = 0
        Me.Manufacturer.Name = "Manufacturer"
        Me.Manufacturer.ReadOnly = True
        Me.Manufacturer.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Manufacturer.Size = New System.Drawing.Size(289, 25)
        Me.Manufacturer.TabIndex = 3
        Me.Manufacturer.Text = ""
        '
        'cbModemType
        '
        Me.cbModemType.BackColor = System.Drawing.SystemColors.Window
        Me.cbModemType.Cursor = System.Windows.Forms.Cursors.Default
        Me.cbModemType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cbModemType.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cbModemType.ForeColor = System.Drawing.SystemColors.WindowText
        Me.cbModemType.Items.AddRange(New Object() {"Auto detect modem type", "Rockwell Chipset Based Modem", "USRobotics Sportster Modem", "Lucent Chipset Based Modem", "Cirrus Logic Chipset Based Modem", "Rockwell/Conexant HCF modem"})
        Me.cbModemType.Location = New System.Drawing.Point(8, 64)
        Me.cbModemType.Name = "cbModemType"
        Me.cbModemType.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cbModemType.Size = New System.Drawing.Size(201, 22)
        Me.cbModemType.TabIndex = 2
        '
        'btnCancel
        '
        Me.btnCancel.BackColor = System.Drawing.SystemColors.Control
        Me.btnCancel.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancel.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnCancel.Location = New System.Drawing.Point(216, 72)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnCancel.Size = New System.Drawing.Size(81, 25)
        Me.btnCancel.TabIndex = 9
        Me.btnCancel.Text = "Cancel"
        '
        'btnTest
        '
        Me.btnTest.BackColor = System.Drawing.SystemColors.Control
        Me.btnTest.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnTest.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnTest.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnTest.Location = New System.Drawing.Point(216, 40)
        Me.btnTest.Name = "btnTest"
        Me.btnTest.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnTest.Size = New System.Drawing.Size(81, 25)
        Me.btnTest.TabIndex = 8
        Me.btnTest.Text = "&Test"
        '
        'btnOpenPort
        '
        Me.btnOpenPort.BackColor = System.Drawing.SystemColors.Control
        Me.btnOpenPort.Cursor = System.Windows.Forms.Cursors.Default
        Me.btnOpenPort.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnOpenPort.ForeColor = System.Drawing.SystemColors.ControlText
        Me.btnOpenPort.Location = New System.Drawing.Point(216, 8)
        Me.btnOpenPort.Name = "btnOpenPort"
        Me.btnOpenPort.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.btnOpenPort.Size = New System.Drawing.Size(81, 25)
        Me.btnOpenPort.TabIndex = 7
        Me.btnOpenPort.Text = "&Open Port"
        '
        'AllPorts
        '
        Me.AllPorts.BackColor = System.Drawing.SystemColors.Window
        Me.AllPorts.Cursor = System.Windows.Forms.Cursors.Default
        Me.AllPorts.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.AllPorts.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.AllPorts.ForeColor = System.Drawing.SystemColors.WindowText
        Me.AllPorts.Location = New System.Drawing.Point(8, 24)
        Me.AllPorts.Name = "AllPorts"
        Me.AllPorts.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.AllPorts.Size = New System.Drawing.Size(113, 22)
        Me.AllPorts.TabIndex = 1
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.BackColor = System.Drawing.SystemColors.Control
        Me.Label2.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label2.Location = New System.Drawing.Point(8, 48)
        Me.Label2.Name = "Label2"
        Me.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label2.Size = New System.Drawing.Size(71, 13)
        Me.Label2.TabIndex = 13
        Me.Label2.Text = "Modem Type:"
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.BackColor = System.Drawing.SystemColors.Control
        Me.Label5.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label5.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label5.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label5.Location = New System.Drawing.Point(8, 184)
        Me.Label5.Name = "Label5"
        Me.Label5.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label5.Size = New System.Drawing.Size(101, 13)
        Me.Label5.TabIndex = 12
        Me.Label5.Text = "Modem Capabilities"
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.BackColor = System.Drawing.SystemColors.Control
        Me.Label4.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label4.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label4.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label4.Location = New System.Drawing.Point(8, 136)
        Me.Label4.Name = "Label4"
        Me.Label4.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label4.Size = New System.Drawing.Size(34, 13)
        Me.Label4.TabIndex = 11
        Me.Label4.Text = "&Model"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.BackColor = System.Drawing.SystemColors.Control
        Me.Label3.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label3.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label3.Location = New System.Drawing.Point(8, 88)
        Me.Label3.Name = "Label3"
        Me.Label3.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label3.Size = New System.Drawing.Size(69, 13)
        Me.Label3.TabIndex = 10
        Me.Label3.Text = "Manufacturer"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.BackColor = System.Drawing.SystemColors.Control
        Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(8, 8)
        Me.Label1.Name = "Label1"
        Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label1.Size = New System.Drawing.Size(87, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Serial port to use"
        '
        'frmSelectPort
        '
        Me.AcceptButton = Me.btnTest
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(304, 255)
        Me.Controls.AddRange(New System.Windows.Forms.Control() {Me.btnLog, Me.ModemCaps, Me.Model, Me.Manufacturer, Me.cbModemType, Me.btnCancel, Me.btnTest, Me.btnOpenPort, Me.AllPorts, Me.Label2, Me.Label5, Me.Label4, Me.Label3, Me.Label1})
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Location = New System.Drawing.Point(3, 22)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmSelectPort"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Select Port/Modem"
        Me.ResumeLayout(False)

    End Sub
#End Region
#Region "Upgrade Support "
    Private Shared m_vb6FormDefInstance As frmSelectPort
    Private Shared m_InitializingDefInstance As Boolean
    Public Shared Property DefInstance() As frmSelectPort
        Get
            If m_vb6FormDefInstance Is Nothing OrElse m_vb6FormDefInstance.IsDisposed Then
                m_InitializingDefInstance = True
                m_vb6FormDefInstance = New frmSelectPort()
                m_InitializingDefInstance = False
            End If
            DefInstance = m_vb6FormDefInstance
        End Get
        Set(ByVal Value As frmSelectPort)
            m_vb6FormDefInstance = Value
        End Set
    End Property
#End Region
    Private Modem As Integer
    'Private nSelPort As Short
    Private bLogEnabled As Boolean
    Private bTesting As Boolean
    Private bTested As Boolean
    Private ActualPort As Short
    Private bAutoOpen As Boolean
    Public pparent As Form1

    Public Function GetSelectedPort() As Long
        GetSelectedPort = Modem
    End Function

    Public Function LogEnabled() As Boolean
        LogEnabled = bLogEnabled
    End Function

    Private Overloads Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        DestroyModem()
        Close()
    End Sub

    Private Sub btnTest_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnTest.Click
        'Dim nPort As Integer,
        Dim szPort As String
        Dim nIndex As Integer
        bTesting = True
        nIndex = cbModemType.SelectedIndex
        If nIndex = 3 Then
            nIndex = 7
        End If
        If nIndex = 4 Then
            nIndex = 8
        End If
        If nIndex = 5 Then
            nIndex = 9
        End If
        If nIndex = 0 Then
            ActualPort = 8
            nIndex = 9
            bAutoOpen = True
        Else
            bAutoOpen = False
            ActualPort = nIndex - 1
        End If
        Modem = pparent.VoiceOCX.CreateModemObject(nIndex - 1)
        bTested = True
        If Modem <> 0 Then
            szPort = AllPorts.Text
            nIndex = pparent.AddNewModem(Modem)
            If nIndex > 0 Then
                pparent.fModemID(nIndex, 1) = 0
                If pparent.VoiceOCX.OpenPort(Modem, szPort) = 0 Then
                    btnTest.Enabled = False
                    btnCancel.Enabled = False
                Else
                    MsgBox("Couldn't open modem port!")
                    DestroyModem()
                End If
            End If
        Else
            MsgBox("Couldn't create modem object!", vbCritical)
        End If
        btnTest.Enabled = False
    End Sub

    Private Sub btnOpenPort_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOpenPort.Click
        '        Dim nPort As Integer
        Dim szPort As String
        Dim nIndex As Integer
        bTesting = False
        If bTested = False Then
            nIndex = cbModemType.SelectedIndex
            If nIndex = 3 Then
                nIndex = 7
            End If
            If nIndex = 4 Then
                nIndex = 8
            End If
            If nIndex = 5 Then
                nIndex = 9
            End If
            If nIndex = 0 Then
                ActualPort = 8
                nIndex = 9
                bAutoOpen = True
            Else
                bAutoOpen = False
                ActualPort = nIndex - 1
            End If

            Modem = pparent.VoiceOCX.CreateModemObject(nIndex - 1)
            If Modem <> 0 Then
                szPort = AllPorts.Text
                nIndex = pparent.AddNewModem(Modem)
                If nIndex > 0 Then
                    pparent.fModemID(nIndex, 1) = 0
                    If pparent.VoiceOCX.OpenPort(Modem, szPort) = 0 Then
                        btnTest.Enabled = False
                        btnCancel.Enabled = False
                    Else
                        MsgBox("Couldn't open modem port!")
                        DestroyModem()
                    End If
                End If
            Else
                MsgBox("Couldn't create modem object!", vbCritical)
            End If
        End If
        btnTest.Enabled = False
        btnOpenPort.Enabled = False
        'nSelPort = AllPorts.ItemData(AllPorts.ListIndex)

        If btnLog.Checked = 1 Then
            bLogEnabled = True
        Else
            bLogEnabled = False
        End If
        If bTested = True Then
            Close()
        End If
    End Sub

    Private Sub AllPorts_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AllPorts.SelectedIndexChanged
        bTested = False
        DestroyModem()
    End Sub

    Public Sub DestroyModem()
        Dim nIndex As Integer

        If Modem <> 0 Then
            nIndex = pparent.FindTagToModemID(Modem)
            If nIndex > 0 Then
                pparent.fModemID(nIndex, 0) = 0
                pparent.fModemID(nIndex, 1) = -1
            End If

            pparent.VoiceOCX.ClosePort(Modem)
            pparent.VoiceOCX.DestroyModemObject(Modem)
            Modem = 0
        End If

        btnTest.Enabled = True
        btnOpenPort.Enabled = True

        Manufacturer.Text = ""
        Model.Text = ""
        ModemCaps.Text = ""
    End Sub

    Private Sub frmSelectPort_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim szPorts As String
        Dim t1 As String
        Dim bFlag As Boolean
        Dim j As Integer
        '        Dim nPort As Integer
        bTested = False
        Modem = 0
        szPorts = pparent.VoiceOCX.AvailablePorts()

        If szPorts <> "" Then
            bFlag = True
            While bFlag
                j = InStr(1, szPorts, " ", 0)
                If j = 0 Then
                    t1 = szPorts
                    bFlag = False
                Else
                    t1 = szPorts.Substring(0, j - 1)
                    szPorts = szPorts.Remove(0, j)
                End If
                AllPorts.Items.Add(t1)
            End While
        End If

        If AllPorts.Items.Count > 0 Then
            AllPorts.SelectedIndex = 0
        Else
            AllPorts.Enabled = False
            btnTest.Enabled = False
        End If
        btnOpenPort.Enabled = True
        If cbModemType.Items.Count > 0 Then
            cbModemType.SelectedIndex = 0
        End If
    End Sub

    Public Sub VoiceOCX_ModemOK()
        Dim szManufacturer As String = ""
        Dim szModel As String = ""
        Dim szModes As String = ""
        Dim Caps As String = ""
        Dim nIndex As Integer
        Dim bStarted As Boolean

        bStarted = False

        pparent.VoiceOCX.GetTestResult(Modem, szManufacturer, szModel, szModes)

        Manufacturer.Text = szManufacturer
        Model.Text = szModel
        For nIndex = 1 To 5 Step 1
            If Mid(szModes, nIndex, 1) = "1" Then
                If bStarted = True Then
                    Caps = Caps + "/"
                End If
                Caps = Caps + pparent.szVoiceCaps(nIndex)
                bStarted = True
            End If
        Next
        ModemCaps.Text = Caps

        btnTest.Enabled = False
        btnOpenPort.Enabled = True
        btnCancel.Enabled = True
        If ActualPort = 0 Then
            cbModemType.SelectedIndex = 1
        Else
            If ActualPort = 1 Then
                cbModemType.SelectedIndex = 2
            Else
                If ActualPort = 6 Then
                    cbModemType.SelectedIndex = 3
                Else
                    If ActualPort = 7 Then
                        cbModemType.SelectedIndex = 4
                    Else
                        If ActualPort = 8 Then
                            cbModemType.SelectedIndex = 5
                        End If
                    End If
                End If
            End If
        End If

        If bTesting = False Then
            Close()
        End If
    End Sub

    Public Sub VoiceOCX_ModemError()
        Dim nIndex As Integer
        Dim szPort As String

        If (bAutoOpen = True) And (ActualPort <> 7) Then
            DestroyModem()
            If ActualPort = 1 Then
                ActualPort = 6
            Else
                If ActualPort = 8 Then
                    ActualPort = 0
                Else
                    ActualPort = ActualPort + 1
                End If
            End If

            Modem = pparent.VoiceOCX.CreateModemObject(ActualPort)
            bTested = True
            If Modem <> 0 Then
                szPort = AllPorts.Text
                nIndex = pparent.AddNewModem(Modem)
                If nIndex > 0 Then
                    pparent.fModemID(nIndex, 1) = 0
                    If pparent.VoiceOCX.OpenPort(Modem, szPort) = 0 Then
                        btnTest.Enabled = False
                        btnCancel.Enabled = False
                    Else
                        MsgBox("Couldn't open modem port!")
                        DestroyModem()
                    End If
                End If
            Else
                MsgBox("Couldn't create modem object!", vbCritical)
            End If
            btnTest.Enabled = False
            btnOpenPort.Enabled = False
        Else
            btnTest.Enabled = False
            btnOpenPort.Enabled = False
            btnCancel.Enabled = True

            MsgBox("Modem ERROR message received")
            bTested = False

            DestroyModem()
        End If
    End Sub

    Public Sub VoiceOCX_PortOpen()
        If pparent.VoiceOCX.TestVoiceModem(Modem) <> 0 Then
            MsgBox("Modem test failed!", vbCritical)
            DestroyModem()
        End If
    End Sub
End Class