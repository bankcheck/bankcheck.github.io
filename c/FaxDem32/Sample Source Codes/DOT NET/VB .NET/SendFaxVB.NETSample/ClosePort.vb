Public Class ClosePort
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
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents CancelBtn As System.Windows.Forms.Button
    Friend WithEvents PortList As System.Windows.Forms.ListBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.OKButton = New System.Windows.Forms.Button
        Me.CancelBtn = New System.Windows.Forms.Button
        Me.PortList = New System.Windows.Forms.ListBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'OKButton
        '
        Me.OKButton.Location = New System.Drawing.Point(28, 128)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.TabIndex = 1
        Me.OKButton.Text = "OK"
        '
        'CancelBtn
        '
        Me.CancelBtn.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CancelBtn.Location = New System.Drawing.Point(124, 128)
        Me.CancelBtn.Name = "CancelBtn"
        Me.CancelBtn.TabIndex = 2
        Me.CancelBtn.Text = "Cancel"
        '
        'PortList
        '
        Me.PortList.Location = New System.Drawing.Point(9, 32)
        Me.PortList.Name = "PortList"
        Me.PortList.Size = New System.Drawing.Size(208, 82)
        Me.PortList.TabIndex = 0
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(8, 17)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(80, 12)
        Me.Label1.TabIndex = 4
        Me.Label1.Text = "Fax Ports:"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.BottomLeft
        '
        'ClosePort
        '
        Me.AcceptButton = Me.OKButton
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.CancelBtn
        Me.ClientSize = New System.Drawing.Size(226, 159)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.PortList)
        Me.Controls.Add(Me.CancelBtn)
        Me.Controls.Add(Me.OKButton)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "ClosePort"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Close Com Port"
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub ClosePort_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Static t1, t2 As String
        Static flag As Boolean
        Static i, j As Integer ', portindex, spaceindex As Integer

        t1 = pparent.FAX1.PortsOpen
        flag = True
        i = 1
        If (Len(t1) > 0) Then
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
        End If

        PortList.SetSelected(0, True)
    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click
        Enabled = False
        Cursor = Cursors.WaitCursor
        If (pparent.FAX1.GetPortStatus(PortList.SelectedItem) = 0) Then
            If (Not pparent.FAX1.ClosePort(PortList.SelectedItem)) Then
                If (PortList.Items.Count = 1) Then
                    pparent.MenuClosePort.Enabled = False
                    pparent.MenuSend.Enabled = False
                End If
                pparent.MessageBox.Items.Add(PortList.SelectedItem + " was closed")
            End If
        Else : MessageBox.Show("Cannot close the port. Port is in use!")
        End If

        If (Len(pparent.FAX1.AvailablePorts) > 0) Then
            pparent.MenuCom.Enabled = True
        End If

        Enabled = True
        Cursor = Cursors.Default
        Close()
    End Sub

    Private Sub CancelBtn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelBtn.Click
        Close()
    End Sub
End Class