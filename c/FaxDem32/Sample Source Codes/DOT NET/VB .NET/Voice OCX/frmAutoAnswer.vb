Public Class frmAutoAnswer
    Inherits System.Windows.Forms.Form
    Private ModemID As Long
    Private nProgressStatus As Integer
    Private bDTMFReceived As Boolean
    Private FaxID As Long
    Public pparent As Form1

    Const cnsRings As Integer = 1

    Const cnsAnswer As Integer = 1
    Const cnsGreeting As Integer = 2
    Const cnsRecFax As Integer = 3
    Const cnsSendFax As Integer = 4
    Const cnsChoose As Integer = 5
    Const cnsHangUp As Integer = 6
    Const cnsRecord As Integer = 7

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
    Friend WithEvents lstEvents As System.Windows.Forms.ListBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmAutoAnswer))
        Me.lstEvents = New System.Windows.Forms.ListBox()
        Me.SuspendLayout()
        '
        'lstEvents
        '
        Me.lstEvents.Name = "lstEvents"
        Me.lstEvents.Size = New System.Drawing.Size(200, 121)
        Me.lstEvents.TabIndex = 0
        '
        'frmAutoAnswer
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(292, 273)
        Me.Controls.AddRange(New System.Windows.Forms.Control() {Me.lstEvents})
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "frmAutoAnswer"
        Me.Text = "frmAutoAnswer"
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub frmAutoAnswer_Resize(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Resize
        lstEvents.Left = 0
        lstEvents.Top = 0
        lstEvents.Width = ClientSize.Width
        lstEvents.Height = ClientSize.Height
    End Sub

    Private Sub frmAutoAnswer_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        lstEvents.Left = 0
        lstEvents.Top = 0
        lstEvents.Width = ClientSize.Width
        lstEvents.Height = ClientSize.Height

        pparent.VoiceOCX.WaitForRings(ModemID, cnsRings)
        Text = "Autoanswer on port: " + pparent.VoiceOCX.GetPortName(ModemID)

        nProgressStatus = 0
        AddNewItem("Voice Mail sample has been started. Modem is ready to answer incoming calls.")
    End Sub

    Private Sub AddNewItem(ByVal szText As String)
        lstEvents.Items.Add(szText)
    End Sub

    Private Sub frmAutoAnswer_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
        Dim nIndex As Integer
        nIndex = pparent.FindTagToModemID(ModemID)
        pparent.fModemID(nIndex, 1) = -1
        pparent.VoiceOCX.DestroyModemObject(ModemID)
        pparent.fModemID(nIndex, 0) = 0
    End Sub

    Public Sub VoiceOCX_ModemOK()
        'DestroyConnection
    End Sub

    Public Sub VoiceOCX_ModemError()
        AddNewItem("ERROR Last operation failed.")
        DestroyConnection()
    End Sub

    Private Sub DestroyConnection()
        AddNewItem("- Disconnect line")
        pparent.VoiceOCX.HangUp(ModemID)
        nProgressStatus = cnsHangUp
        bDTMFReceived = False
    End Sub

    Public Sub VoiceOCX_Ring()
        AddNewItem("")
        AddNewItem("Incoming call was detected. Answering call...")
        nProgressStatus = 0
        If pparent.VoiceOCX.Answer(ModemID) = 0 Then
            nProgressStatus = cnsAnswer
        Else
            DestroyConnection()
        End If
    End Sub

    Public Sub VoiceOCX_Answer()
        Dim szVoiceFile As String
        Dim szVoiceFormatCmd As String

        szVoiceFormatCmd = pparent.VoiceOCX.GetModemCommand(ModemID, 2)

        If szVoiceFormatCmd <> "AT#VSM=132,8000" + vbCrLf Then
            pparent.szVocExts(2) = ".USR"
            pparent.VoiceOCX.SetDefaultVoiceParams(ModemID, 0, 8000)

            pparent.VoiceOCX.SetModemCommand(ModemID, 2, "AT#VSM=129,8000" + vbCrLf)
        End If
        szVoiceFile = pparent.szExePath + "\VOICE\VOICE"
        pparent.SetVocExtension(ModemID, szVoiceFile)

        AddNewItem("Answer Call was answered")

        If pparent.VoiceOCX.GetDIDDigits(ModemID) <> "" Then
            AddNewItem("Answer DID digits received:" + pparent.VoiceOCX.GetDIDDigits(ModemID))
        End If

        If pparent.VoiceOCX.PlayVoice(ModemID _
                                        , szVoiceFile _
                                        , 0 _
                                        , 20 _
                                        , 0 _
                                        , 1) = 0 Then
            nProgressStatus = cnsGreeting
        Else
            DestroyConnection()
        End If
    End Sub

    Public Sub VoiceOCX_CallingTone()
        AddNewItem("Interrupt Calling tone was detected!")
        pparent.VoiceOCX.TerminateProcess(ModemID)
    End Sub

    Public Sub VoiceOCX_AnswerTone()
        AddNewItem("Interrupt Answer tone was detected!")
        pparent.VoiceOCX.TerminateProcess(ModemID)
    End Sub

    Public Sub VoiceOCX_DTMFReceived()
        bDTMFReceived = True
        pparent.VoiceOCX.TerminateProcess(ModemID)
    End Sub

    Public Sub VoiceOCX_EndReceive()
        If FaxID <> 0 Then
            Dim bAppend As Boolean
            Dim nIndex As Integer
            Dim szFileName As String
            Dim nPageNum As Integer, Res As Integer, Width As Integer, Length As Integer, Comp As Integer, Bin As Integer, Bitord As Integer, Ecm As Integer, Color As Integer, ClrType As Integer

            AddNewItem("EndReceive Saving received fax")

            szFileName = pparent.szExePath + "\FAX.IN\FAX_" + Convert.ToString(DateTime.Now.Year) _
     + Convert.ToString(DateTime.Now.Month) _
     + Convert.ToString(DateTime.Now.Day) _
     + Convert.ToString(DateTime.Now.Hour) _
     + Convert.ToString(DateTime.Now.Minute) _
     + Convert.ToString(DateTime.Now.Second) + ".TIF"
            bAppend = False

            pparent.VoiceOCX.GetFaxParam(FaxID, nPageNum, Res, Width, Length, Comp, Bin, Bitord, Ecm, Color, ClrType)
            For nIndex = 0 To nPageNum - 1 Step 1
                pparent.VoiceOCX.GetFaxImagePage(FaxID, nIndex, 11, bAppend, szFileName)
                bAppend = True
            Next

            pparent.VoiceOCX.ClearFaxObject(FaxID)
            FaxID = 0
        Else
            AddNewItem("EndReceive No fax was received")
        End If

        nProgressStatus = 0
        DestroyConnection()
    End Sub

    Public Sub VoiceOCX_EndSend()
        nProgressStatus = 0
        AddNewItem("FaxSent. Send fax operation has finished")
        DestroyConnection()
    End Sub

    Public Sub VoiceOCX_FaxReceived(ByVal fax As Long, ByVal RemoteID As String)
        FaxID = fax
    End Sub

    Public Sub VoiceOCX_VoicePlayStarted()
        AddNewItem("VoicePlayStarted")
    End Sub

    Public Sub VoiceOCX_VoicePlayFinished()
        Dim szTemp As String
        Dim szDTMF As String

        If nProgressStatus = cnsGreeting Then
            If bDTMFReceived = True Then
                bDTMFReceived = False
                szDTMF = pparent.VoiceOCX.GetReceivedDTMFDigits(ModemID)
                szTemp = "DTMF received:" + szDTMF
            Else
                szTemp = "No acceptable DTMF digit was received!"
            End If
            AddNewItem("Playing greeting message was finished " + szTemp)

            Select Case szDTMF
                Case "0"
                    RecordVoiceMail()
                Case "1"
                    ReceiveFax()
                Case "2"
                    PlayChooseMsg()
                Case Else
                    DestroyConnection()
            End Select
        Else
            If bDTMFReceived = True Then
                szDTMF = pparent.VoiceOCX.GetReceivedDTMFDigits(ModemID)
                AddNewItem("DTMF Received " + szDTMF + " User chose fax: " + szDTMF)
                Select Case szDTMF
                    Case "0"
                        SendFax("TEST.TIF")
                    Case "1"
                        SendFax("TEST.TIF")
                    Case "2"
                        SendFax("TEST.TIF")
                    Case Else
                        DestroyConnection()
                End Select
            End If
        End If
    End Sub

    Public Sub VoiceOCX_VoiceRecordStarted()
        AddNewItem("Recording voice mail was started")
    End Sub

    Public Sub VoiceOCX_VoiceRecordFinished()
        AddNewItem("Voice mail was recorded")
        DestroyConnection()
    End Sub

    Public Sub VoiceOCX_FaxTerminated(ByVal Status As Long)
        AddNewItem("Fax was Terminated Termination status:" + Str(Status))
    End Sub

    Public Sub VoiceOCX_HangUp()
        nProgressStatus = 0
        pparent.VoiceOCX.WaitForRings(ModemID, cnsRings)
        AddNewItem("Hangup" + " Modem was disconnected - answerphone operation complete")
    End Sub

    Public Sub VoiceOCX_OnHook()
        AddNewItem("Disconnect Remote side has disconnected")
        pparent.VoiceOCX.TerminateProcess(ModemID)
    End Sub

    Public Sub SetModemID(ByVal Modem As Long)
        ModemID = Modem
    End Sub

    Private Sub RecordVoiceMail()
        Dim szVoiceFile As String
        Dim szVoiceFormatCmd As String

        szVoiceFormatCmd = pparent.VoiceOCX.GetModemCommand(ModemID, 2)

        If szVoiceFormatCmd <> "AT#VSM=132,8000" + vbCrLf Then
            pparent.szVocExts(2) = ".USR"
            pparent.VoiceOCX.SetDefaultVoiceParams(ModemID, 0, 8000)

            pparent.VoiceOCX.SetModemCommand(ModemID, 2, "AT#VSM=129,8000" + vbCrLf)
        End If
        szVoiceFile = pparent.szExePath + "\VOICE\MAIL_" + Convert.ToString(DateTime.Now.Year) _
    + Convert.ToString(DateTime.Now.Month) _
    + Convert.ToString(DateTime.Now.Day) _
    + Convert.ToString(DateTime.Now.Hour) _
    + Convert.ToString(DateTime.Now.Minute) _
    + Convert.ToString(DateTime.Now.Second)
        pparent.SetVocExtension(ModemID, szVoiceFile)
        AddNewItem("Record voice mail Filename: " + szVoiceFile)

        If pparent.VoiceOCX.RecordVoice(ModemID _
                                            , szVoiceFile _
                                            , 0 _
                                            , 60 _
                                            , 10 _
                                            , 1) = 0 Then
            nProgressStatus = cnsRecord
        Else
            DestroyConnection()
        End If
    End Sub

    Private Sub ReceiveFax()
        If pparent.VoiceOCX.ReceiveFaxNow(ModemID) = 0 Then
            nProgressStatus = cnsRecFax
        End If
    End Sub

    Private Sub PlayChooseMsg()
        Dim szVoiceFile As String
        Dim szVoiceFormatCmd As String

        szVoiceFormatCmd = pparent.VoiceOCX.GetModemCommand(ModemID, 2)

        If szVoiceFormatCmd <> "AT#VSM=132,8000" + vbCrLf Then
            pparent.szVocExts(2) = ".USR"
            pparent.VoiceOCX.SetDefaultVoiceParams(ModemID, 0, 8000)

            pparent.VoiceOCX.SetModemCommand(ModemID, 2, "AT#VSM=129,8000" + vbCrLf)
        End If
        szVoiceFile = pparent.szExePath + "\VOICE\SENDFAX"
        pparent.SetVocExtension(ModemID, szVoiceFile)
        AddNewItem("Choose Fax Playing 'Choose Fax' message")

        If pparent.VoiceOCX.PlayVoice(ModemID _
                                        , szVoiceFile _
                                        , 0 _
                                        , 20 _
                                        , 0 _
                                        , 1) = 0 Then
            nProgressStatus = cnsChoose
        Else
            DestroyConnection()
        End If
    End Sub

    Private Sub SendFax(ByVal szFaxFile As String)
        Dim FaxID As Long
        Dim nNumOfImages, nIndex As Integer

        nProgressStatus = 0

        On Error GoTo ErrorHandler

        szFaxFile = pparent.szExePath + "\FAX.OUT\" + szFaxFile

        nNumOfImages = pparent.VoiceOCX.GetNumberOfImages(szFaxFile, 11)
        If nNumOfImages > -1 Then
            FaxID = pparent.VoiceOCX.CreateFaxObject(1 _
                                                        , nNumOfImages _
                                                        , 2 _
                                                        , 1 _
                                                        , 0 _
                                                        , 1 _
                                                        , 1 _
                                                        , 1 _
                                                        , 0, 0)
            If FaxID <> 0 Then
                For nIndex = 0 To nNumOfImages - 1 Step 1
                    If pparent.VoiceOCX.SetFilePage(FaxID, nIndex, 0, nIndex, szFaxFile) <> 0 Then
                        Err.Raise(vbObjectError + 3)
                    End If
                Next

                If pparent.VoiceOCX.SendFaxNow(ModemID, FaxID) = 0 Then
                    nProgressStatus = cnsSendFax
                Else
                    Err.Raise(vbObjectError + 2)
                End If
            Else
                Err.Raise(vbObjectError + 1)
            End If
        Else
            Err.Raise(vbObjectError + 0)
        End If

        Exit Sub

ErrorHandler:
        Select Case Err.Number
            Case vbObjectError + 0
                AddNewItem("ERROR Error in GetNumberOfImages()")
            Case vbObjectError + 1
                AddNewItem("ERROR Error in CreateFaxObject()")
            Case vbObjectError + 2
                AddNewItem("ERROR Error in SendFaxNow()")
            Case vbObjectError + 3
                AddNewItem("ERROR Error in SetFilePage()")
        End Select

        DestroyConnection()
    End Sub
End Class
