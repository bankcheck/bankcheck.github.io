Option Strict Off
Option Explicit On
Imports VB = Microsoft.VisualBasic
Friend Class frmOpenBrook
	Inherits System.Windows.Forms.Form
	Private bLogEnabled As Boolean
	
    Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpAppName As String, ByVal lpKey As String, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Integer, ByVal lpFileName As String) As Integer
	
    Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As String, ByVal lpString As String, ByVal lpFileName As String) As Short

    Private failed As Boolean

	Private Sub btnOK_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnOK.Click
		Dim nIndex As Short
		Dim assist As Integer
		bLogEnabled = chbLogEn.CheckState

        failed = False
		fMainForm.VoiceOCX.SetBrooktroutConfigFile(ConfigFile.Text)
		assist = WritePrivateProfileString("Brooktrout", "Config file", ConfigFile.Text, "Demo32.ini")
		nIndex = lvChannelList.SelectedIndex
		If nIndex <> -1 Then
			lModemID = fMainForm.VoiceOCX.CreateModemObject(cnsBrooktrout)
			If lModemID <> 0 Then
				nPrStatus = cnsSelectBT
                If fMainForm.VoiceOCX.OpenPort(lModemID, lvChannelList.Items(nIndex).ToString) = 0 Then
                    btnOK.Enabled = False
                    btnCancel.Enabled = False
                Else
                    MsgBox("Cannot open channel: " & lvChannelList.Items(nIndex).ToString)
                End If
            Else
                MsgBox("Config file is not valid!")
			End If
		End If
	End Sub
	Private Sub btnCancel_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnCancel.Click
		Me.Close()
	End Sub
	
	Private Sub btnTest_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnTest.Click
        Dim szType As String = ""
		
		If lvChannelList.SelectedIndex <> -1 Then
			fMainForm.VoiceOCX.GetBrooktroutChannelType(lvChannelList.SelectedIndex, szType, 50)
			ModemType.Text = szType
		End If
	End Sub
	
	Private Sub frmOpenBrook_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
        Dim bcStr As String
		Dim nChannels As Short
		Dim szChannel As String
		Dim nIndex As Short
		Dim assist As Integer
		Dim ConfigFileStr As String
		
		nChannels = 0
		
		For nIndex = 0 To MAX_BROOK_CHANNELS
			If fMainForm.VoiceOCX.IsBrooktroutChannelFree(nIndex) <> False Then
				szChannel = "CHANNEL"
				bcStr = Str(nIndex)
				bcStr = VB.Right(bcStr, Len(bcStr) - 1)
				szChannel = szChannel + bcStr
				lvChannelList.Items.Insert(nChannels, szChannel)
				nChannels = nChannels + 1
			End If
		Next 
		
		
		ConfigFileStr = New String(Chr(0), 200)
		assist = GetPrivateProfileString("Brooktrout", "Config file", "btcall.cfg", ConfigFileStr, 200, "Demo32.ini")
		ConfigFile.Text = ConfigFileStr
		
		If nChannels > 0 Then
			btnOK.Enabled = True
			btnTest.Enabled = True
		End If
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
        fMainForm.VoiceOCX.DestroyModemObject(lModemID)
        lModemID = 0
    End Sub
    Public Function LogEnabled() As Boolean
        LogEnabled = bLogEnabled
    End Function

End Class