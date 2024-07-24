Option Strict Off
Option Explicit On
Imports VB = Microsoft.VisualBasic
Friend Class frmMain
	Inherits System.Windows.Forms.Form
	
	Private nProgressStatus As Short
	Private bConnEstab As Boolean
    Private nAutoScroll As Short
    Private FaxID As Integer
    Private isDTMFTerminated As Boolean
    Private isHangingUp As Boolean
	
	Private szVoiceFile As String
    Private Sub AddToLog(ByRef textRef As String)
        Dim itemcount As Integer

        lstEvents.Items.Add(textRef)
        itemcount = lstEvents.Items.Count
        If nAutoScroll = 1 Then
            lstEvents.TopIndex = itemcount - 1
        End If
    End Sub
	
	Private Sub Clear_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles Clear.Click
		lstEvents.Items.Clear()
	End Sub
	
	
    Private Sub CloseButton_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles CloseButton.Click
        If lModemID <> 0 Then
            VoiceOCX.ClosePort(lModemID)
            VoiceOCX.DestroyModemObject(lModemID)
            lModemID = 0
            EnableButtons(False, False)
            CloseButton.Enabled = False
            AddToLog("Port/channel closed.")
        End If
    End Sub
	
	Private Sub Exit_Renamed_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles Exit_Renamed.Click
        nProgressStatus = cnsExit
        AddToLog("Exiting...")
        If lModemID <> 0 Then
            VoiceOCX.ClosePort(lModemID)
        End If
        Me.Close()
    End Sub
	
	Private Sub Help_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles Help.Click
		Dim helpDlg As frmHelp
        helpDlg = New frmHelp
        helpDlg.ShowDialog(Me)
	End Sub
	
	Private Sub OpenBrooktrout_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles OpenBrooktrout.Click
        ' choose port
        If VoiceOCX.GetBrooktroutChannelNum() > 0 Then
            frmSelectBT = New frmOpenBrook
            frmSelectBT.ShowDialog(Me)
            If lModemID <> 0 Then
                ' user selected a brooktrout channel
                nPrStatus = cnsNoneAttached
                AddToLog("Modem/channel is ready to answer incoming calls")
                If frmSelectBT.LogEnabled = True Then
                    VoiceOCX.EnableLog(lModemID, True)
                End If

                nPrStatus = cnsOnline
                nProgressStatus = 0
                bConnEstab = False
                nAutoScroll = 1
                EnableButtons(True, False)
                VoiceOCX.WaitForRings(lModemID, 2)
            End If
        Else
            MsgBox("There is no available Brooktrout Channel!", MsgBoxStyle.OkOnly)
        End If
    End Sub
	
	Private Sub OpenCOM_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles OpenCOM.Click
		DoSelectModem()
	End Sub
	
	Private Sub frmMain_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
        Dim szConfigFile As String
        Dim szGreetingMessage As String
		
		Dim nOK As Short
		
		nPrStatus = cnsNoneAttached
		
		szVoiceCaps(1) = "Data"
		szVoiceCaps(2) = "Class1"
		szVoiceCaps(3) = "Class2"
		szVoiceCaps(4) = "Voice"
		szVoiceCaps(5) = "VoiceView"
		
		szVocExts(1) = ".VOC"
		szVocExts(2) = ".WAV"
		szVocExts(3) = ".WAV"
		szVocExts(4) = ".WAV"
		szVocExts(5) = ".WAV"
		szVocExts(6) = ".WAV"
		szVocExts(7) = ".WAV"
		szVocExts(8) = ".WAV"
		szVocExts(9) = ".WAV"
		
		szExePath = My.Application.Info.DirectoryPath
		szIniFile = szExePath & "\VOCXDEMO.INI"
		
		szGreetingMessage = New String(Chr(0), 256)
		nOK = GetPrivateProfileString("VOICE", "Greeting message", "", szGreetingMessage, Len(szGreetingMessage), szIniFile)
		
		VoiceOCX.SetLogDir(szExePath)
		
        szConfigFile = "BTCALL.CFG"
        isDTMFTerminated = False
        isHangingUp = False
		
		fMainForm = Me
		
		EnableButtons(False, False)
		CloseButton.Enabled = False
	End Sub
	
	Private Sub frmMain_FormClosed(ByVal eventSender As System.Object, ByVal eventArgs As System.Windows.Forms.FormClosedEventArgs) Handles Me.FormClosed
        Dim szBcmTones As String = ""
		WritePrivateProfileString("VOICE", "BCMTONES", szBcmTones, szIniFile)
		
		nPrStatus = cnsNoneAttached
		VoiceOCX.TerminateProcess(lModemID)
		If lModemID <> 0 Then
			VoiceOCX.DestroyModemObject(lModemID)
		End If
		lModemID = 0
	End Sub
	
	Private Sub DoSelectModem()
		' choose port
        frmSelect = New frmSelectPort
        frmSelect.ShowDialog(Me)
		
		If lModemID <> 0 Then
			' user selected a communication port
			nPrStatus = cnsNoneAttached
            AddToLog("Modem/channel is ready to answer incoming calls")
			If frmSelect.LogEnabled = True Then
				VoiceOCX.EnableLog(lModemID, True)
			End If
			
			nPrStatus = cnsOnline
			nProgressStatus = 0
			bConnEstab = False
			nAutoScroll = 1
            EnableButtons(True, False)
			VoiceOCX.WaitForRings(lModemID, 2)
		End If
	End Sub
	
	Private Sub OpenDialogic_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles OpenDialogic.Click
		
		' choose port
        If VoiceOCX.GetDialogicChannelNum(VoiceOCX.GetDialogicBoardNum) > 0 Then
            frmSelectDlg = New frmDialogicOpen
            frmSelectDlg.ShowDialog(Me)

            If lModemID <> 0 Then
                ' user selected a communication port
                nPrStatus = cnsNoneAttached
                AddToLog("Modem/channel is ready to answer incoming calls")

                nPrStatus = cnsOnline
                nProgressStatus = 0
                bConnEstab = False
                nAutoScroll = 1
                EnableButtons(True, False)
                VoiceOCX.WaitForRings(lModemID, 2)
            End If
        Else
            MsgBox("There is no available Dialogic Channel!", MsgBoxStyle.OkOnly)
        End If
	End Sub
	
	Private Sub OpenNMS_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles OpenNMS.Click
		' choose port
		If VoiceOCX.GetNMSBoardNum > 0 Then
            frmSelectNMS = New frmOpenNMS
            frmSelectNMS.ShowDialog(Me)
			
			If lModemID <> 0 Then
				' user selected a communication port
				nPrStatus = cnsNoneAttached
                AddToLog("Modem/channel is ready to answer incoming calls")
				
				If frmSelectNMS.LogEnabled = True Then
					VoiceOCX.EnableLog(lModemID, True)
				End If
				
				nPrStatus = cnsOnline
				nProgressStatus = 0
				bConnEstab = False
				nAutoScroll = 1
                EnableButtons(True, False)
				VoiceOCX.WaitForRings(lModemID, 2)
			End If
		Else
			MsgBox("There is no available NMS Channel!", MsgBoxStyle.OKOnly)
		End If
	End Sub
	
	Private Sub ReceiveFax_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles ReceiveFax.Click
        If VoiceOCX.ReceiveFaxNow(lModemID) = 0 Then
            nProgressStatus = cnsRecFax
            CloseButton.Enabled = False
        Else
            AddToLog("ReceiveFaxNow failed")
        End If
    End Sub
	
	Private Sub RecordMessage_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles RecordMessage.Click
        Dim nDF As Short
        Dim nSR As Short
        Dim bWAV As Boolean

        bWAV = cnsWAV
        nDF = MDF_PCM
        nSR = MSR_11KHZ

        szVoiceFile = szExePath & "\VOICE\MAIL_" & CStr(Year(Today)) & "_" & CStr(Month(Today)) & "_" & CStr(VB.Day(Today)) & "_" & CStr(Hour(TimeOfDay)) & "_" & CStr(Minute(TimeOfDay)) & "_" & CStr(Second(TimeOfDay))
        szVoiceFile = szVoiceFile & ".wav"

        If VoiceOCX.RecordVoiceExt(lModemID, szVoiceFile, MDM_LINE, 60, True, 10, bWAV, nDF, nSR, 5, Asc("#")) = 0 Then
            nProgressStatus = cnsRecord
        Else
            AddToLog("RecordVoice failed")
        End If
    End Sub
	
	
	Private Sub VoiceOCX_DTMFDigit(ByVal eventSender As System.Object, ByVal eventArgs As AxVOICEOCXLib._DVoiceOCXEvents_DTMFDigitEvent) Handles VoiceOCX.DTMFDigit
		nProgressStatus = 0
        AddToLog("Received DTMF digit(s): [" & Chr(eventArgs.digit) & "]")
		
		CloseButton.Enabled = True
	End Sub
	
	Private Sub VoiceOCX_DTMFReceived(ByVal eventSender As System.Object, ByVal eventArgs As AxVOICEOCXLib._DVoiceOCXEvents_DTMFReceivedEvent) Handles VoiceOCX.DTMFReceived
        AddToLog("Received DTMF digit(s): [" & VoiceOCX.GetReceivedDTMFDigits(lModemID) & "]")
        nPrStatus = cnsOnline
        isDTMFTerminated = True
		VoiceOCX.TerminateProcess(lModemID)
		nProgressStatus = 0
		CloseButton.Enabled = True
	End Sub
	
	Private Sub VoiceOCX_DTMFReceivedExt2(ByVal eventSender As System.Object, ByVal eventArgs As AxVOICEOCXLib._DVoiceOCXEvents_DTMFReceivedExt2Event) Handles VoiceOCX.DTMFReceivedExt2
        AddToLog("Received DTMF digit(s): [" & VoiceOCX.GetReceivedDTMFDigits(lModemID) & "]")
        AddToLog("Offset:" & Str(eventArgs.offset))
        nPrStatus = cnsOnline
        isDTMFTerminated = True
		VoiceOCX.TerminateProcess(lModemID)
		nProgressStatus = 0
		CloseButton.Enabled = True
	End Sub
	
	
	Private Sub VoiceOCX_EndReceive(ByVal eventSender As System.Object, ByVal eventArgs As AxVOICEOCXLib._DVoiceOCXEvents_EndReceiveEvent) Handles VoiceOCX.EndReceive
        Dim nIndex As Short
		nProgressStatus = 0
		
		
		Dim szFaxName As String
		Dim Append As Boolean
        Dim Color, Bitord, Comp, Width, nPageNum, Res, Length, Bin, Ecm, ClrType As Short
        If Not isHangingUp Then
            If FaxID <> 0 Then
                AddToLog("Fax was received.")
                szFaxName = szExePath & "\Fax.In\REC_" & CStr(Now.Year) & "_" & CStr(Now.Month) & "_" & CStr(Now.Day) & "_" & CStr(Now.Hour) & "_" & CStr(Now.Minute) & "_" & CStr(Now.Second) & ".TIF"
                If VB.Right(szFaxName, 4) <> ".TIF" Then
                    szFaxName = szFaxName & ".TIF"
                End If
                If Mid(szFaxName, 2, 1) <> ":" Then
                    szFaxName = szExePath & "\" & szFaxName
                End If
                If szFaxName <> "" Then

                    Append = False

                    VoiceOCX.GetFaxParam(FaxID, nPageNum, Res, Width, Length, Comp, Bin, Bitord, Ecm, Color, ClrType)
                    For nIndex = 0 To nPageNum - 1 Step 1
                        VoiceOCX.GetFaxImagePage(FaxID, nIndex, IMT_FILE_TIFF_NOCOMP, Append, szFaxName)
                        Append = True
                    Next
                End If

                MsgBox("Saving received fax as: " + szFaxName, MsgBoxStyle.OkOnly)
                VoiceOCX.ClearFaxObject(FaxID)
                FaxID = 0
            Else
                AddToLog("No fax was received")
            End If
        Else
            isHangingUp = False
        End If
        HangUp()
    End Sub
	
	
	
	Private Sub VoiceOCX_FaxReceived(ByVal eventSender As System.Object, ByVal eventArgs As AxVOICEOCXLib._DVoiceOCXEvents_FaxReceivedEvent) Handles VoiceOCX.FaxReceived
        'AddToLog("Fax was received")
        AddToLog("Remote Identifier:" & eventArgs.remoteID)
        FaxID = eventArgs.faxID
    End Sub
	
	Private Sub VoiceOCX_FaxTerminated(ByVal eventSender As System.Object, ByVal eventArgs As AxVOICEOCXLib._DVoiceOCXEvents_FaxTerminatedEvent) Handles VoiceOCX.FaxTerminated
        AddToLog("Fax termination status: [" & Str(eventArgs.tStatus) & "]")
        If eventArgs.tStatus <> 0 Then
            AddToLog("Modem is hanging up...")
            isHangingUp = True
        End If
        CloseButton.Enabled = True
	End Sub
	
	Private Sub VoiceOCX_ModemError(ByVal eventSender As System.Object, ByVal eventArgs As AxVOICEOCXLib._DVoiceOCXEvents_ModemErrorEvent) Handles VoiceOCX.ModemError
        '		Dim frmSelectBCM As Object
        '        Dim cnsSelectBCM As Short
		Select Case nPrStatus
			Case cnsNoneAttached
				MsgBox("Modem OK received on port: " & VoiceOCX.GetPortName(lModemID))
			Case cnsSelectPort ' select port
				frmSelect.VoiceOCX_ModemError()
			Case cnsSelectDlg
				frmSelectDlg.VoiceOCX_ModemError()
                '			Case cnsSelectBCM
                '               frmSelectBCM.VoiceOCX_ModemError()
			Case cnsSelectBT
				frmSelectBT.VoiceOCX_ModemError()
			Case cnsSelectNMS
				frmSelectNMS.VoiceOCX_ModemError()
            Case Else
                If Not isDTMFTerminated Then
                    AddToLog("Operation failed. Error message was received.")
                End If
                nProgressStatus = 0
                CloseButton.Enabled = True
        End Select
	End Sub
	
	Private Sub VoiceOCX_ModemOK(ByVal eventSender As System.Object, ByVal eventArgs As AxVOICEOCXLib._DVoiceOCXEvents_ModemOKEvent) Handles VoiceOCX.ModemOK
		Select Case nPrStatus
			Case cnsNoneAttached
				MsgBox("Modem OK received on port: " & VoiceOCX.GetPortName(lModemID))
			Case cnsSelectPort ' select port
				frmSelect.VoiceOCX_ModemOK()
		End Select
	End Sub
	
	
	Private Sub VoiceOCX_OffHookEvent(ByVal eventSender As System.Object, ByVal eventArgs As AxVOICEOCXLib._DVoiceOCXEvents_OffHookEvent) Handles VoiceOCX.OffHookEvent
        If nProgressStatus = cnsDial Or nProgressStatus = cnsAnswer Then ' dial or answer
            nProgressStatus = 0
            AddToLog("Voice connection was established")
            EnableButtons(True, True)
            bConnEstab = True
        End If

    End Sub
	
	Private Sub VoiceOCX_OnHook(ByVal eventSender As System.Object, ByVal eventArgs As AxVOICEOCXLib._DVoiceOCXEvents_OnHookEvent) Handles VoiceOCX.OnHook
        If nProgressStatus = cnsDial Or nProgressStatus = cnsAnswer Then ' dial or answer
            AddToLog("Pick up the phone!")
        ElseIf nProgressStatus = cnsHangup Or nProgressStatus = cnsPlay Or nProgressStatus = cnsRecord Or nProgressStatus = cnsWaitDTMF Then
            AddToLog("Remote side has disconnected. Hang up the line.")
        End If
    End Sub
	
	Private Sub VoiceOCX_PortOpen(ByVal eventSender As System.Object, ByVal eventArgs As AxVOICEOCXLib._DVoiceOCXEvents_PortOpenEvent) Handles VoiceOCX.PortOpen
        '		Dim frmSelectBCM As Object
        '        Dim cnsSelectBCM As Short
		Select Case nPrStatus
			Case cnsNoneAttached
				MsgBox("Modem OK received on port: " & VoiceOCX.GetPortName(lModemID))
			Case cnsSelectPort ' select port
				frmSelect.VoiceOCX_PortOpen()
			Case cnsSelectDlg
				frmSelectDlg.VoiceOCX_PortOpen()
                '			Case cnsSelectBCM
                '                frmSelectBCM.VoiceOCX_PortOpen()
			Case cnsSelectBT
				frmSelectBT.VoiceOCX_PortOpen()
			Case cnsSelectNMS
				frmSelectNMS.VoiceOCX_PortOpen()
		End Select
		CloseButton.Enabled = True
	End Sub
	
	Private Sub VoiceOCX_Ring(ByVal eventSender As System.Object, ByVal eventArgs As AxVOICEOCXLib._DVoiceOCXEvents_RingEvent) Handles VoiceOCX.Ring
        Select Case nPrStatus
            Case cnsNoneAttached
                MsgBox("Modem detected RING on port: " & VoiceOCX.GetPortName(lModemID))
            Case cnsOnline ' online port
                AddToLog("Incoming call was detected.")
                ' Get the caller ID information
                ' Read the information into a String buffer
                Dim strCID As String = VoiceOCX.GetCallerID(lModemID)
                ' With the help of a tokenizer, extract the information one by one
                Dim strToken As String = StrTok.StrTok(strCID, "\")
                AddToLog("Call Date: " + strToken)
                strToken = StrTok.StrTok("", "\")
                AddToLog("Call Time: " + strToken)
                strToken = StrTok.StrTok("", "\")
                AddToLog("Caller ID: " + strToken)
                strToken = StrTok.StrTok("", "\")
                AddToLog("Caller Name: " + strToken)
                strToken = StrTok.StrTok("", "\")
                AddToLog("Caller Number: " + strToken)
                strToken = StrTok.StrTok("", "\")
                AddToLog("Message: " + strToken)

                nProgressStatus = cnsAnswer
                VoiceOCX.OnlineAnswer(lModemID)
        End Select
    End Sub
	
	
	Private Sub VoiceOCX_VoiceConnect(ByVal eventSender As System.Object, ByVal eventArgs As AxVOICEOCXLib._DVoiceOCXEvents_VoiceConnectEvent) Handles VoiceOCX.VoiceConnect
		AddToLog("Voice connection was established")
		nProgressStatus = 0
		bConnEstab = True
        EnableButtons(True, True)
		CloseButton.Enabled = True
	End Sub
	
	
	
	Private Sub VoiceOCX_VoiceRecordFinished(ByVal eventSender As System.Object, ByVal eventArgs As AxVOICEOCXLib._DVoiceOCXEvents_VoiceRecordFinishedEvent) Handles VoiceOCX.VoiceRecordFinished
		nProgressStatus = 0
        AddToLog("Received DTMF digit(s): [" & VoiceOCX.GetReceivedDTMFDigits(lModemID) & "]")
		AddToLog("Recording voice message was finished")
		MsgBox("Voice file has saved to: " & szVoiceFile)
		CloseButton.Enabled = True
	End Sub
	
	Private Sub VoiceOCX_VoiceRecordStarted(ByVal eventSender As System.Object, ByVal eventArgs As AxVOICEOCXLib._DVoiceOCXEvents_VoiceRecordStartedEvent) Handles VoiceOCX.VoiceRecordStarted
		CloseButton.Enabled = False
		AddToLog("Recording voice message was started")
	End Sub
	
    Private Sub EnableButtons(ByVal bEnabled1 As Boolean, ByVal bEnabled2 As Boolean)

        ReceiveFax.Enabled = bEnabled2
        WaitForDTMF.Enabled = bEnabled2
        RecordMessage.Enabled = bEnabled2
        hangupButton.Enabled = bEnabled2

        OpenCOM.Enabled = Not bEnabled1
        OpenDialogic.Enabled = Not bEnabled1
        OpenBrooktrout.Enabled = Not bEnabled1
        OpenNMS.Enabled = Not bEnabled1
    End Sub
	
	
	Private Sub WaitForDTMF_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles WaitForDTMF.Click
        Dim nDelim As Short

        Dim dtmfWait As frmWaitforDTMF
        Dim nNum As Short

        isDTMFTerminated = False
        dtmfWait = New frmWaitforDTMF
        dtmfWait.ShowDialog(Me)
        nNum = dtmfWait.GetNumberOfDigits
        nDelim = dtmfWait.GetDelimiter

        If nNum > 0 Then
            If VoiceOCX.WaitForDTMF(lModemID, nNum, nDelim, 20) = 0 Then
                AddToLog("Wait for DTMF digits")
                CloseButton.Enabled = False
                nProgressStatus = cnsWaitDTMF
            Else
                AddToLog("WaitForDTMF failed")
            End If
        End If

    End Sub

    Private Sub hangupButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles hangupButton.Click
        HangUp()
    End Sub

    Private Sub HangUp()
        If nProgressStatus = 0 Then
            nProgressStatus = cnsHangup
            fMainForm.VoiceOCX.HangUp(lModemID)
        End If

        EnableButtons(True, False)
        CloseButton.Enabled = True
    End Sub

    Private Sub VoiceOCX_HangUpEvent(ByVal sender As System.Object, ByVal e As AxVOICEOCXLib._DVoiceOCXEvents_HangUpEvent) Handles VoiceOCX.HangUpEvent

        Select Case nProgressStatus
            Case cnsHangup      ' hang-up
                AddToLog("The call has been disconnected")
                nProgressStatus = 0
            Case cnsOffHook      ' off-hook
                AddToLog("Voice connection was established")
                nProgressStatus = 0
            Case cnsExit    ' exit
                Me.Close()
        End Select

        EnableButtons(True, False)
    End Sub
End Class