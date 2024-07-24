Public Class OpenNMS
    Inherits System.Windows.Forms.Form
    Public pparent As Form1

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
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents PortList As System.Windows.Forms.ListBox
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents ProtocolCB As System.Windows.Forms.ComboBox
    Friend WithEvents CancelBtn As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.PortList = New System.Windows.Forms.ListBox
        Me.OKButton = New System.Windows.Forms.Button
        Me.CancelBtn = New System.Windows.Forms.Button
        Me.Label1 = New System.Windows.Forms.Label
        Me.ProtocolCB = New System.Windows.Forms.ComboBox
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.PortList)
        Me.GroupBox1.Location = New System.Drawing.Point(8, 8)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(152, 144)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Available NMS Channels"
        '
        'PortList
        '
        Me.PortList.Location = New System.Drawing.Point(8, 16)
        Me.PortList.Name = "PortList"
        Me.PortList.Size = New System.Drawing.Size(136, 121)
        Me.PortList.TabIndex = 0
        '
        'OKButton
        '
        Me.OKButton.Location = New System.Drawing.Point(176, 48)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(72, 23)
        Me.OKButton.TabIndex = 2
        Me.OKButton.Text = "&OK"
        '
        'CancelBtn
        '
        Me.CancelBtn.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CancelBtn.Location = New System.Drawing.Point(176, 88)
        Me.CancelBtn.Name = "CancelBtn"
        Me.CancelBtn.Size = New System.Drawing.Size(72, 23)
        Me.CancelBtn.TabIndex = 3
        Me.CancelBtn.Text = "&Cancel"
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(8, 160)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(136, 16)
        Me.Label1.TabIndex = 4
        Me.Label1.Text = "NMS Telephony Protocol:"
        '
        'ProtocolCB
        '
        Me.ProtocolCB.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ProtocolCB.Items.AddRange(New Object() {"Analog Loop Start (LPS0)", "Digital/Analog Wink Start (inbound only) (DID0)", "Digital/Analog Wink Start (outbound only) (OGT0)", "Digital/Analog Wink Start (WNK0)", "Analog Wink Start (WNK1)", "Digital Loop Start OPS-FX (LPS8)", "Feature Group D (inbound only) (FDI0)", "Digital Loop Start OPS-SA (LPS9)", "Digital Ground Start OPS-FX (GST8)", "Digital Ground Start OPS-SA (GST9)", "ISDN protocol (ISD0)", "MFC R2 protocol (MFC0)"})
        Me.ProtocolCB.Location = New System.Drawing.Point(7, 176)
        Me.ProtocolCB.Name = "ProtocolCB"
        Me.ProtocolCB.Size = New System.Drawing.Size(241, 21)
        Me.ProtocolCB.TabIndex = 1
        '
        'OpenNMS
        '
        Me.AcceptButton = Me.OKButton
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.CancelBtn
        Me.ClientSize = New System.Drawing.Size(258, 207)
        Me.Controls.Add(Me.ProtocolCB)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.CancelBtn)
        Me.Controls.Add(Me.OKButton)
        Me.Controls.Add(Me.GroupBox1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "OpenNMS"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Open NMS Channel"
        Me.GroupBox1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub OpenNMS_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Static t1, t2 As String
        Static flag As Boolean
        Static j As Integer

        t1 = pparent.FAX1.AvailableNMSChannels
        flag = True
        While flag
            j = t1.IndexOf(" ")
            If (j = -1) Then
                t2 = t1
                flag = False
            Else
                t2 = t1.Substring(0, j)
                t1 = t1.Remove(0, j + 1)
            End If
            PortList.Items.Add(t2)
        End While

        PortList.SetSelected(0, True)
        ProtocolCB.SelectedIndex = 0
    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click
        Static errcode As Long
        Static i As Integer
        Dim index As Integer
        Dim protocol As String

        'Set selected protocol
        index = ProtocolCB.SelectedIndex
        protocol = GetSelectedProtocol(index)
        pparent.FAX1.NMSProtocoll = protocol
        Cursor = Cursors.WaitCursor
        Enabled = False

        errcode = pparent.FAX1.OpenPort(PortList.SelectedItem)
        If errcode Then
            i = MsgBox(pparent.Errors(errcode), 0)
            Enabled = True
            Cursor = Cursors.Default
            Exit Sub
        Else
            pparent.MenuClosePort.Enabled = True
            pparent.MessageBox.Items.Add(PortList.SelectedItem + " was opened")
        End If

        If (Len(pparent.FAX1.AvailableNMSChannels) > 0) Then
            pparent.MenuNMS.Enabled = True
        Else
            pparent.MenuNMS.Enabled = False
        End If

        Cursor = Cursors.Default
        Enabled = True
        Close()
    End Sub

    Function GetSelectedProtocol(ByVal index As Integer) As String
        Dim protocol As String

        Select Case index
            Case 0
                protocol = "LPS0"
            Case 1
                protocol = "DID0"
            Case 2
                protocol = "OGT0"
            Case 3
                protocol = "WNK0"
            Case 4
                protocol = "WNK1"
            Case 5
                protocol = "LPS8"
            Case 6
                protocol = "FDI0"
            Case 7
                protocol = "LPS9"
            Case 8
                protocol = "GST8"
            Case 9
                protocol = "GST9"
            Case 10
                protocol = "ISD0"
            Case 11
                protocol = "MFC0"
            Case Else
                protocol = "LPS0"
        End Select
        GetSelectedProtocol = protocol
    End Function

    Private Sub CancelBtn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelBtn.Click
        Close()
    End Sub
End Class
