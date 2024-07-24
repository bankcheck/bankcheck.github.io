Option Strict Off
Option Explicit On
Imports VB = Microsoft.VisualBasic
Friend Class frmOpenNMS
	Inherits System.Windows.Forms.Form
    Private bLogEnabled As Boolean
    Private failed As Boolean
    Function GetSelectedProtocol(ByRef index As Short) As String
        Dim Protocol As String
        Select Case index
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
	Private Sub btnCancel_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnCancel.Click
		Me.Close()
	End Sub
	Private Sub btnOK_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnOK.Click
        Dim didDigits As String
		Dim nIndex As Short
		Dim i As Short
		Dim index As Short
		Dim Protocol As String
		
        bLogEnabled = chbLogEn.CheckState
        failed = True
		nIndex = -1
		For i = 1 To lvChannelList.ListItems.Count
			If lvChannelList.ListItems.Item(i).Selected = True Then
				nIndex = i
				Exit For
			End If
		Next 
		
		If nIndex = -1 Then
			lvChannelList.ListItems.Item(1).Selected = True
			nIndex = 1
		End If
		If nIndex <> -1 Then
			lModemID = fMainForm.VoiceOCX.CreateModemObject(cnsNMS)
			If lModemID <> 0 Then
				nPrStatus = cnsSelectNMS
				
				'Set selected protocol
				index = ProtocolCombo.SelectedIndex
				Protocol = GetSelectedProtocol(index)
				fMainForm.VoiceOCX.SetNMSProtocol(Protocol)
				
				'Set specified DID/DNIS digits
				didDigits = DIDText.Text
				fMainForm.VoiceOCX.SetDIDDigitNumber(lModemID, Val(didDigits))
				
				If fMainForm.VoiceOCX.OpenPort(lModemID, lvChannelList.ListItems.Item(nIndex).text) = 0 Then
					btnOK.Enabled = False
					btnCancel.Enabled = False
				Else
					MsgBox(CDbl("Cannot open channel: ") + lvChannelList.ListItems.Item(nIndex).Selected)
				End If
			End If
		End If
	End Sub
	Private Sub frmOpenNMS_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
        Dim itmX As ListViewItem
        Dim bcStr As String
        Dim j As Short
        Dim i As Short
		Dim nBoards As Short
		Dim nIndex As Short
		Dim szChannel As String
        Dim szModel As String = ""
		
		bLogEnabled = False
		lModemID = 0
		
		nIndex = 0
		nBoards = fMainForm.VoiceOCX.GetNMSBoardNum
		For i = 0 To nBoards
            For j = 0 To fMainForm.VoiceOCX.GetNMSChannelNum(i) - 1
                If fMainForm.VoiceOCX.IsNMSChannelFree(i, j) Then
                    szChannel = "NMS_B"
                    bcStr = Str(i)
                    bcStr = VB.Right(bcStr, Len(bcStr) - 1)
                    szChannel = szChannel + bcStr + "CH"
                    bcStr = Str(j)
                    bcStr = VB.Right(bcStr, Len(bcStr) - 1)
                    szChannel = szChannel + bcStr

                    itmX = lvChannelList.ListItems.Add(, , szChannel)
                    If fMainForm.VoiceOCX.GetNMSChannelType(i, j, szModel, 50) Then
                        itmX.SubItems(1).Text = szModel
                    End If
                End If
                nIndex = nIndex + 1
            Next
        Next
		
		ProtocolCombo.Items.Insert(0, "Analog Loop Start (LPS0)")
		ProtocolCombo.Items.Insert(1, "Digital/Analog Wink Start (inbound only) (DID0)")
		ProtocolCombo.Items.Insert(2, "Digital/Analog Wink Start (outbound only) (OGT0)")
		ProtocolCombo.Items.Insert(3, "Digital/Analog Wink Start (WNK0)")
		ProtocolCombo.Items.Insert(4, "Analog Wink Start (WNK1)")
		ProtocolCombo.Items.Insert(5, "Digital Loop Start OPS-FX (LPS8)")
		ProtocolCombo.Items.Insert(6, "Feature Group D (inbound only) (FDI0)")
		ProtocolCombo.Items.Insert(7, "Digital Loop Start OPS-SA (LPS9)")
		ProtocolCombo.Items.Insert(8, "Digital Ground Start OPS-FX (GST8)")
		ProtocolCombo.Items.Insert(9, "Digital Ground Start OPS-SA (GST9)")
		ProtocolCombo.Items.Insert(10, "ISDN protocol (ISD0)")
		ProtocolCombo.Items.Insert(11, "MFC R2 protocol (MFC0)")
		ProtocolCombo.SelectedIndex = 0
	End Sub
	Public Sub VoiceOCX_PortOpen()
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
    Public Function LogEnabled() As Boolean
        LogEnabled = bLogEnabled
    End Function
End Class