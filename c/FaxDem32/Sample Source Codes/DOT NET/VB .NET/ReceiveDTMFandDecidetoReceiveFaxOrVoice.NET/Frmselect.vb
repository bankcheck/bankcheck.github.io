Option Strict Off
Option Explicit On
Imports VB = Microsoft.VisualBasic
Friend Class frmSelectPort
	Inherits System.Windows.Forms.Form
	Private nSelPort As Short
	Private bLogEnabled As Boolean
	Private bTesting As Boolean
	Private bTested As Boolean
	Private ActualPort As Short
	Private bAutoOpen As Boolean
	
	Private modemLucent As Short
	Private modemCLogic As Short
	Private modemConexant As Short
	
	Private listAuto As Short
	Private listRockwell As Short
	Private listUSRobotics As Short
	Private listLucent As Short
	Private listCLogic As Short
	Private listConexant As Short
	
	Private szEncodingModes As String
	
	
	Public Function GetSelectedPort() As Integer
        Dim Modem As Integer
		GetSelectedPort = Modem
	End Function
	
    Public Function LogEnabled() As Boolean
        LogEnabled = bLogEnabled
    End Function
	
	Private Sub AllPorts_SelectedIndexChanged(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles AllPorts.SelectedIndexChanged
		bTested = False
		DestroyModem()
	End Sub
	
	Private Sub btnCancel_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnCancel.Click
		nPrStatus = cnsNoneAttached
        DestroyModem()
        fMainForm.CloseButton.Enabled = False
		Me.Close()
	End Sub
	
	Private Sub btnOpenPort_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnOpenPort.Click
        Dim szPort As String
        Dim nIndex As Integer
        bTesting = False
        If bTested = False Then
            nIndex = cbModemType.SelectedIndex
            If nIndex = listLucent Then
                nIndex = modemLucent
            End If
            If nIndex = listCLogic Then
                nIndex = modemCLogic
            End If
            If nIndex = listConexant Then
                nIndex = modemConexant
            End If
            If nIndex = listAuto Then
                ActualPort = 8
                nIndex = 9
                bAutoOpen = True
            Else
                bAutoOpen = False
                ActualPort = nIndex - 1
            End If
            lModemID = fMainForm.VoiceOCX.CreateModemObject(nIndex - 1)
            If lModemID <> 0 Then
                szPort = AllPorts.Text
                nPrStatus = cnsSelectPort
                If fMainForm.VoiceOCX.OpenPort(lModemID, szPort) = 0 Then
                    btnVoiceFormats.Enabled = False
                    btnTest.Enabled = False
                    btnCancel.Enabled = False
                Else
                    MsgBox("Couldn't open modem port!")
                    nPrStatus = cnsNoneAttached
                    DestroyModem()
                End If
            Else
                MsgBox("Couldn't create modem object!", MsgBoxStyle.Critical)
            End If
        End If
        btnTest.Enabled = False
        btnVoiceFormats.Enabled = False
        btnOpenPort.Enabled = False
        nSelPort = VB6.GetItemData(AllPorts, AllPorts.SelectedIndex)

        bLogEnabled = True
        If bTested = True Then
            Me.Close()
        End If
    End Sub
	
	Private Sub btnTest_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnTest.Click
        Dim szPort As String
        Dim nIndex As Integer
        bTesting = True
        nIndex = cbModemType.SelectedIndex
        If nIndex = listLucent Then
            nIndex = modemLucent
        End If
        If nIndex = listCLogic Then
            nIndex = modemCLogic
        End If
        If nIndex = listConexant Then
            nIndex = modemConexant
        End If
        If nIndex = listAuto Then
            ActualPort = 8
            nIndex = 9
            bAutoOpen = True
        Else
            bAutoOpen = False
            ActualPort = nIndex - 1
        End If
        DestroyModem()
        lModemID = fMainForm.VoiceOCX.CreateModemObject(nIndex - 1)
        bTested = True
        If lModemID <> 0 Then
            szPort = AllPorts.Text
            nPrStatus = cnsSelectPort
            If fMainForm.VoiceOCX.OpenPort(lModemID, szPort) = 0 Then
                btnOpenPort.Enabled = False
                btnTest.Enabled = False
                btnCancel.Enabled = False
                btnVoiceFormats.Enabled = False
            Else
                MsgBox("Couldn't open modem port!")
                nPrStatus = cnsNoneAttached
                DestroyModem()
            End If
        Else
            MsgBox("Couldn't create modem object!", MsgBoxStyle.Critical)
        End If
        btnTest.Enabled = False
        btnVoiceFormats.Enabled = False
    End Sub
	
    Private Sub btnVoiceFormats_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnVoiceFormats.Click
        If szEncodingModes <> "" Then
            MsgBox(szEncodingModes)
        Else
            MsgBox("No opened modem!")
        End If
    End Sub
	
	Private Sub cbModemType_SelectedIndexChanged(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cbModemType.SelectedIndexChanged
		btnTest.Enabled = True
		btnOpenPort.Enabled = True
		btnVoiceFormats.Enabled = True
	End Sub
	
	Private Sub frmSelectPort_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
		Dim szPorts As String
        Dim t1 As String
		Dim bFlag As Boolean
		Dim j As Short
		Dim nPort As Short
		
		listAuto = 0
		listRockwell = 1
		listUSRobotics = 2
		listLucent = 3
		listCLogic = 4
		listConexant = 5
		modemLucent = 7
		modemCLogic = 8
		modemConexant = 9
		
		bTested = False
		lModemID = 0
		szPorts = fMainForm.VoiceOCX.AvailablePorts()
		
		If szPorts <> "" Then
			bFlag = True
			While bFlag
				j = InStr(1, szPorts, " ", 0)
				If j = 0 Then
                    t1 = szPorts
                    bFlag = False
                Else
                    t1 = VB.Left(szPorts, j - 1)
                    szPorts = VB.Right(szPorts, Len(szPorts) - j)
                End If
				AllPorts.Items.Add((t1))
				nPort = Val(VB.Right(t1, Len(t1) - 3))
				VB6.SetItemData(AllPorts, AllPorts.Items.Count - 1, nPort)
			End While
		End If
		
		If AllPorts.Items.Count > 0 Then
			AllPorts.SelectedIndex = 0
		Else
			AllPorts.Enabled = False
			btnTest.Enabled = False
		End If
		btnOpenPort.Enabled = True
		btnVoiceFormats.Enabled = True
		cbModemType.SelectedIndex = 0
		
	End Sub
	
	Public Sub VoiceOCX_ModemOK()
        Dim szManufacturer As String = ""
        Dim szModel As String = ""
        Dim szModes As String = ""
        Dim Caps As String = ""
		Dim nIndex As Short
		Dim bStarted As Boolean
		
		bStarted = False
		
		fMainForm.VoiceOCX.GetTestResultExt(lModemID, szManufacturer, szModel, szModes, szEncodingModes)
		
		Manufacturer.Text = szManufacturer
		Model.Text = szModel
		For nIndex = 1 To 5 Step 1
			If Mid(szModes, nIndex, 1) = "1" Then
				If bStarted = True Then
					Caps = Caps & "/"
				End If
				Caps = Caps & szVoiceCaps(nIndex)
				bStarted = True
			End If
		Next 
		ModemCaps.Text = Caps
		
		btnTest.Enabled = False
		btnOpenPort.Enabled = True
		btnCancel.Enabled = True
		btnVoiceFormats.Enabled = True
		
		If ActualPort = 0 Then
			cbModemType.SelectedIndex = listRockwell
		Else
			If ActualPort = 1 Then
				cbModemType.SelectedIndex = listUSRobotics
			Else
				If ActualPort = 6 Then
					cbModemType.SelectedIndex = listLucent
				Else
					If ActualPort = 7 Then
						cbModemType.SelectedIndex = listCLogic
					Else
						If ActualPort = 8 Then
							cbModemType.SelectedIndex = listConexant
						End If
					End If
				End If
			End If
		End If
		If bTesting = False Then
			Me.Close()
		End If
		
		
	End Sub
	
	Public Sub VoiceOCX_ModemError()
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
			
			lModemID = fMainForm.VoiceOCX.CreateModemObject(ActualPort)
			If lModemID <> 0 Then
                szPort = AllPorts.Text
                If fMainForm.VoiceOCX.OpenPort(lModemID, szPort) = 0 Then
                    btnOpenPort.Enabled = False
                    btnTest.Enabled = False
                    btnCancel.Enabled = False
                    btnVoiceFormats.Enabled = False
                Else
                    MsgBox("Couldn't open modem port!")
                    nPrStatus = cnsNoneAttached
                    DestroyModem()
                End If
            Else
                MsgBox("Couldn't create modem object!", MsgBoxStyle.Critical)
            End If
		Else
			'nPrStatus = cnsNoneAttached
			DestroyModem()
            btnTest.Enabled = True
			btnVoiceFormats.Enabled = False
            btnOpenPort.Enabled = True
			btnCancel.Enabled = True
			
			MsgBox("Modem ERROR message received")
			bTested = False
		End If
	End Sub
	
	Public Sub VoiceOCX_PortOpen()
		If fMainForm.VoiceOCX.TestVoiceModem(lModemID) <> 0 Then
			MsgBox("Modem test failed!", MsgBoxStyle.Critical)
			nPrStatus = cnsNoneAttached
			DestroyModem()
		End If
	End Sub
	
	Public Sub DestroyModem()

        If lModemID <> 0 Then
            'If bAutoOpen = True Then
            fMainForm.VoiceOCX.ClosePort(lModemID)
            'End If
            fMainForm.VoiceOCX.DestroyModemObject(lModemID)
            lModemID = 0
        End If

        btnTest.Enabled = True
        btnOpenPort.Enabled = True
        btnVoiceFormats.Enabled = True
        Manufacturer.Text = ""
        Model.Text = ""
        ModemCaps.Text = ""
    End Sub
End Class