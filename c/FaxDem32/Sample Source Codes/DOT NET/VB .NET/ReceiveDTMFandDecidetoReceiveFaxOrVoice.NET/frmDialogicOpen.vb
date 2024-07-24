Option Strict Off
Option Explicit On
Imports VB = Microsoft.VisualBasic
Friend Class frmDialogicOpen
	Inherits System.Windows.Forms.Form
    Private bLogEnabled As Boolean
    Private failed As Boolean
	Private Sub btnCancel_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnCancel.Click
		Me.Close()
	End Sub
	Private Sub btnOK_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnOK.Click
		Dim nIndex As Short
        '		Dim i As Short

        failed = False
        nIndex = lvChannelList.SelectedIndex
        '        For i = 1 To lvChannelList.Items.Count
        ' If lvChannelList.Items.Item(i).Selected = True Then
        'nIndex = i
        'Exit For
        'End If
        'Next

        If nIndex <> -1 Then
            lModemID = fMainForm.VoiceOCX.CreateModemObject(cnsDialogic)
            If lModemID <> 0 Then
                nPrStatus = cnsSelectDlg
                If LineType.SelectedIndex = 0 Then
                    '3 is ANALOG
                    fMainForm.VoiceOCX.SetDialogicLineType(lModemID, 3)
                ElseIf LineType.SelectedIndex = 1 Then
                    '2 is ISDN PRI
                    fMainForm.VoiceOCX.SetDialogicLineType(lModemID, 2)
                ElseIf LineType.SelectedIndex = 2 Or LineType.SelectedIndex = 3 Then
                    '1 is T1/E1
                    fMainForm.VoiceOCX.SetDialogicLineType(lModemID, 1)
                    fMainForm.VoiceOCX.SetDialogicProtocol(lModemID, Protocol.Text)
                End If


                If fMainForm.VoiceOCX.OpenPort(lModemID, lvChannelList.SelectedItem) = 0 Then
                    btnOK.Enabled = False
                    btnCancel.Enabled = False
                Else
                    MsgBox(CDbl("Cannot open channel: ") + lvChannelList.SelectedItem)
                End If
            End If
        End If
	End Sub
	
	Private Sub Combo1_Change()
		
	End Sub
	
	Private Sub frmDialogicOpen_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
        '        Dim itmX As ListViewItem
        Dim bcStr As String
        Dim j As Short
        Dim i As Short
		Dim nBoards As Short
		Dim nIndex As Short
		Dim szChannel As String
        Dim szManufact As String = ""
        Dim szType As String = ""
        Dim szModel As String = ""
		
		bLogEnabled = False
		lModemID = 0
		
		nIndex = 0
		nBoards = fMainForm.VoiceOCX.GetDialogicBoardNum
		For i = 1 To nBoards
            For j = 1 To fMainForm.VoiceOCX.GetDialogicChannelNum(i)
                If fMainForm.VoiceOCX.IsDialogicChannelFree(i, j) Then
                    szChannel = "dxxxB"
                    bcStr = Str(i)
                    bcStr = VB.Right(bcStr, Len(bcStr) - 1)
                    szChannel = szChannel + bcStr + "C"
                    bcStr = Str(j)
                    bcStr = VB.Right(bcStr, Len(bcStr) - 1)
                    szChannel = szChannel + bcStr

                    lvChannelList.Items.Add(szChannel)
                    '                    If fMainForm.VoiceOCX.TestDialogic(szChannel, szType, szManufact, szModel) Then
                    '                    itmX.SubItems(1).Text = szModel
                    '                End If
                End If
                nIndex = nIndex + 1
            Next
        Next
		LineType.SelectedIndex = 0
		Protocol.Enabled = False
		Protocol.Text = "us_mf_io"
	End Sub
	Public Sub VoiceOCX_PortOpen()
		
		If PAMD.CheckState = 0 Then
			fMainForm.VoiceOCX.SetParameters(lModemID, cnsMDM_ENABLE_ANSVERING_MACHINE_DETECTION, False)
		Else
			fMainForm.VoiceOCX.SetParameters(lModemID, cnsMDM_ENABLE_ANSVERING_MACHINE_DETECTION, True)
		End If
		
		MsgBox("Channel opened")
		
		Me.Close()
	End Sub
    Public Sub VoiceOCX_ModemError()
        If Not failed Then
            MsgBox("Open channel failed!")
            failed = True
        End If
        btnOK.Enabled = True
        btnCancel.Enabled = True
        nPrStatus = cnsNoneAttached
        lModemID = 0
    End Sub
	
	Private Sub LineType_SelectedIndexChanged(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles LineType.SelectedIndexChanged
		If LineType.SelectedIndex > 1 Then
			Protocol.Enabled = True
		Else
			Protocol.Enabled = False
		End If
	End Sub
End Class