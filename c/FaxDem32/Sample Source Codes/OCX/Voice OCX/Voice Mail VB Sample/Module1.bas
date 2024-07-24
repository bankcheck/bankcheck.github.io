Attribute VB_Name = "Module1"
Public szVocExts(10) As String
Public fMainForm As frmMain
Public fAutoForms(1 To 256) As frmAutoAnswer
Public fModemID(1 To 256, 1) As Long
Public frmSelect As frmSelectPort
Public frmSelectDlg As frmDialogicOpen
Public frmSelectBT As frmOpenBrook
Public frmSelectNMS As frmOpenNMS
Public szIniFile As String
Public szVoiceCaps(5) As String
Public szExePath As String
Public szGreetingMessage As String

Public Const MAX_BROOK_CHANNELS = 96

Public Const cnsNoneAttached = -1
Public Const cnsSelectPort = 0
Public Const cnsAutoAnswer = 1
Public Const cnsSelectDlg = 2
Public Const cnsSelectBT = 3
Public Const cnsSelectNMS = 4

' supported modem types
Public Const cnsRockwell = 0
Public Const cnsUSRobotics = 1
Public Const cnsDialogic = 2
Public Const cnsBrooktrout = 4
Public Const cnsNMS = 5
Public Const cnsLucent = 6
Public Const cnsCirrus = 7
Public Const cnsHCF = 8

' voice file format
Public Const cnsVOX = False
Public Const cnsWAV = True

' voice line
Public Const MDM_LINE = 0
Public Const MDM_HANDSET = 1
Public Const MDM_SPEAKER = 2
Public Const MDM_MICROPHONE = 3

' voice file data format
Public Const MDF_ADPCM = 0
Public Const MDF_PCM = 1
Public Const MDF_MULAW = 2
Public Const MDF_ALAW = 3
Public Const MDF_OKI = 4

' voice file sampling rate
Public Const MSR_6KHZ = 0
Public Const MSR_7200 = 1
Public Const MSR_8KHZ = 2
Public Const MSR_11KHZ = 3

' image resolution
Public Const RES_NOCHANGE = 0
Public Const RES_98LPI = 1
Public Const RES_196LPI = 2

' image width
Public Const PWD_NOCHANGE = 0
Public Const PWD_1728 = 1
Public Const PWD_2048 = 2
Public Const PWD_2432 = 3
Public Const PWD_1216 = 4
Public Const PWD_864 = 5

' image length
Public Const PLN_NOCHANGE = 0
Public Const PLN_A4 = 1
Public Const PLN_B4 = 2
Public Const PLN_UNLIMITED = 3

' compression method
Public Const DCF_NOCHANGE = 0
Public Const DCF_1DMH = 1
Public Const DCF_2DMR = 2
Public Const DCF_UNCOMPRESSED = 3
Public Const DCF_2DMMR = 4

' binary file transfer
Public Const BFT_NOCHANGE = 0
Public Const BFT_DISABLE = 1
Public Const BFT_ENABLE = 2

' bit order
Public Const BTO_FIRST_LSB = 0
Public Const BTO_LAST_LSB = 1
Public Const BTO_BOTH = 2

' ECM
Public Const ECM_NOCHANGE = 0
Public Const ECM_DISABLE = 1
Public Const ECM_ENABLE = 2

' color fax
Public Const CFAX_NOCHANGE = 0
Public Const CFAX_DISABLE = 1
Public Const CFAX_ENABLE = 2

' color type
Public Const CFAX_TRUECOLOR = 0
Public Const CFAX_GRAYSCALE = 1

Public Const IMT_NOTHING = 0
Public Const IMT_MEM_DIRECT = 1
Public Const IMT_MEM_BITMAP = 2
Public Const IMT_MEM_DIB = 3
Public Const IMT_MEM_END = 4
Public Const IMT_FILE_DIRECT = 5
Public Const IMT_FILE_BMP = 6
Public Const IMT_FILE_PCX = 7
Public Const IMT_FILE_DCX = 8
Public Const IMT_FILE_GIF = 9
Public Const IMT_FILE_TGA = 10
Public Const IMT_FILE_TIFF_NOCOMP = 11
Public Const IMT_FILE_TIFF_PACKBITS = 12
Public Const IMT_FILE_TIFF_LZW = 13
Public Const IMT_FILE_TIFF_LZDIFF = 14
Public Const IMT_FILE_TIFF_G31DNOEOL = 15
Public Const IMT_FILE_TIFF_G31D = 16
Public Const IMT_FILE_TIFF_G31D_REV = 17
Public Const IMT_FILE_TIFF_G32D = 18
Public Const IMT_FILE_TIFF_G4 = 19
Public Const IMT_FILE_CLS = 20
Public Const IMT_FILE_JPEG = 21
Public Const IMT_FILE_END = 22
Public Const IMT_BFTOBJ = 23

Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hWnd As Long, ByVal msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As String, ByVal lpDefault As String, ByVal lpRetunedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Declare Function GetPrivateProfileInt Lib "kernel32" Alias "GetPrivateProfileIntA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal nDefault As Long, ByVal lpFileName As String) As Long
Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As String, ByVal lpString As String, ByVal lpFileName As String) As Boolean
Declare Function Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Sub Main()
    Dim nIndex As Integer
    Dim nOK As Integer
    
    For nIndex = 1 To 255 Step 1
        fModemID(nIndex, 0) = 0
        fModemID(nIndex, 1) = cnsNoneAttached
    Next
    
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
    
    szExePath = App.Path
    szIniFile = szExePath + "\VOCXDEMO.INI"
    
    szGreetingMessage = String$(256, 0)
    nOK = GetPrivateProfileString("VOICE", "Greeting message", "", szGreetingMessage, Len(szGreetingMessage), szIniFile)
    
    Set fMainForm = New frmMain
    fMainForm.Show
End Sub

Public Sub ChangeExt(pszTemp As String, pszExt As String)
    pszTemp = Left(pszTemp, Len(pszTemp) - 3) + pszExt
End Sub

Public Sub DeleteModem(ModemID As Long)
    For i = 1 To 255
        If fModemID(i, 0) = ModemID Then
            fModemID(i, 0) = 0
            fModemID(i, 0) = cnsNoneAttached
        End If
    Next
End Sub

Public Sub SetVocExtension(ModemID As Long, pszFile As String)
    nIndex = fMainForm.VoiceOCX.GetModemType(ModemID) + 1
    If Right(pszFile, 4) <> szVocExts(nIndex) Then
        If (Mid(pszFile, Len(pszFile) - 4, 1)) = "." Then
            ChangeExt pszFile, szVocExts(nIndex)
        Else
            pszFile = pszFile + szVocExts(nIndex)
        End If
    End If
End Sub

Public Function FindTagToModemID(ModemID As Long) As Integer
    Dim Index As Integer
    
    If ModemID <> 0 Then
        For Index = 1 To 256 Step 1
            If fModemID(Index, 0) = ModemID Then
                Exit For
            End If
        Next
        
        If Index <= 256 Then
            FindTagToModemID = Index
        Else
            FindTagToModemID = 0
        End If
    Else
        FindTagToModemID = 0
    End If
End Function
Public Function AddNewModem(ModemID As Long) As Integer
    Dim i As Integer
    
    For i = 1 To 256
        If fModemID(i, 0) = 0 Then
            fModemID(i, 0) = ModemID
            fModemID(i, 1) = cnsNoneAttached
            Exit For
        End If
    Next
    If i < 257 Then
        AddNewModem = i
    Else
        AddNewModem = 0
    End If
End Function

Public Function CheckIfValidModemID(ModemID As Long, bExtraCheck As Boolean)
    Dim i As Integer
    
    For i = 0 To 255
        If fModemID(i + 1, 0) = ModemID Then
            i = i + 1
            Exit For
        End If
    Next

    If (i > 0) Then
        If bExtraCheck Then
            If fModemID(i, 1) <> cnsNoneAttached Then
                i = 0
            End If
        End If
    End If
    
    CheckIfValidModemID = i
End Function
