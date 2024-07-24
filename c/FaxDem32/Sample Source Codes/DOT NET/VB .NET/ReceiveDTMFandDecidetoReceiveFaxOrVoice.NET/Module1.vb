Option Strict Off
Option Explicit On
Module Module1
	Public Const cnsMDM_ENABLE_ANSVERING_MACHINE_DETECTION As Short = 1
	
	Public szVocExts(10) As String
	Public fMainForm As frmMain
	Public frmSelect As frmSelectPort
	Public frmSelectDlg As frmDialogicOpen
	Public frmSelectBT As frmOpenBrook
	Public frmSelectNMS As frmOpenNMS
	Public szIniFile As String
	Public szVoiceCaps(5) As String
	Public szExePath As String
	Public nPrStatus As Short
	Public lModemID As Integer
	
	Public Const MAX_BROOK_CHANNELS As Short = 96

    Public Const cnsHangup As Short = 0
    Public Const cnsDial As Short = 1
    Public Const cnsAnswer As Short = 2
    Public Const cnsOffHook As Short = 3
    Public Const cnsPlay As Short = 4
    Public Const cnsRecord As Short = 5
    Public Const cnsSendFax As Short = 6
    Public Const cnsRecFax As Short = 7
    Public Const cnsSendDTMF As Short = 8
    Public Const cnsWaitDTMF As Short = 9
    Public Const cnsSendSignal As Short = 10
    Public Const cnsTransfer As Short = 11
    Public Const cnsExit As Short = 100

	Public Const cnsNoneAttached As Short = -1
	Public Const cnsSelectPort As Short = 0
	Public Const cnsOnline As Short = 1
	Public Const cnsSelectDlg As Short = 2
	Public Const cnsSelectBT As Short = 3
	Public Const cnsSelectNMS As Short = 4
	
	' supported modem types
	Public Const cnsRockwell As Short = 0
	Public Const cnsUSRobotics As Short = 1
	Public Const cnsDialogic As Short = 2
	Public Const cnsBrooktrout As Short = 4
	Public Const cnsNMS As Short = 5
	Public Const cnsLucent As Short = 6
	Public Const cnsCirrus As Short = 6
	Public Const cnsHCF As Short = 8
	
	' voice file format
	Public Const cnsVOX As Boolean = False
	Public Const cnsWAV As Boolean = True
	
	' voice line
	Public Const MDM_LINE As Short = 0
	Public Const MDM_HANDSET As Short = 1
	Public Const MDM_SPEAKER As Short = 2
	Public Const MDM_MICROPHONE As Short = 3
	
	' voice file data format
	Public Const MDF_ADPCM As Short = 0
	Public Const MDF_PCM As Short = 1
	Public Const MDF_MULAW As Short = 2
	Public Const MDF_ALAW As Short = 3
	Public Const MDF_OKI As Short = 4
	
	' voice file sampling rate
	Public Const MSR_6KHZ As Short = 0
	Public Const MSR_7200 As Short = 1
	Public Const MSR_8KHZ As Short = 2
	Public Const MSR_11KHZ As Short = 3
	
	' image resolution
	Public Const RES_NOCHANGE As Short = 0
	Public Const RES_98LPI As Short = 1
	Public Const RES_196LPI As Short = 2
	
	' image width
	Public Const PWD_NOCHANGE As Short = 0
	Public Const PWD_1728 As Short = 1
	Public Const PWD_2048 As Short = 2
	Public Const PWD_2432 As Short = 3
	Public Const PWD_1216 As Short = 4
	Public Const PWD_864 As Short = 5
	
	' image length
	Public Const PLN_NOCHANGE As Short = 0
	Public Const PLN_A4 As Short = 1
	Public Const PLN_B4 As Short = 2
	Public Const PLN_UNLIMITED As Short = 3
	
	' compression method
	Public Const DCF_NOCHANGE As Short = 0
	Public Const DCF_1DMH As Short = 1
	Public Const DCF_2DMR As Short = 2
	Public Const DCF_UNCOMPRESSED As Short = 3
	Public Const DCF_2DMMR As Short = 4
	
	' binary file transfer
	Public Const BFT_NOCHANGE As Short = 0
	Public Const BFT_DISABLE As Short = 1
	Public Const BFT_ENABLE As Short = 2
	
	' bit order
	Public Const BTO_FIRST_LSB As Short = 0
	Public Const BTO_LAST_LSB As Short = 1
	Public Const BTO_BOTH As Short = 2
	
	' ECM
	Public Const ECM_NOCHANGE As Short = 0
	Public Const ECM_DISABLE As Short = 1
	Public Const ECM_ENABLE As Short = 2
	
	' color fax
	Public Const CFAX_NOCHANGE As Short = 0
	Public Const CFAX_DISABLE As Short = 1
	Public Const CFAX_ENABLE As Short = 2
	
	' color type
	Public Const CFAX_TRUECOLOR As Short = 0
	Public Const CFAX_GRAYSCALE As Short = 1
	
	Public Const IMT_NOTHING As Short = 0
	Public Const IMT_MEM_DIRECT As Short = 1
	Public Const IMT_MEM_BITMAP As Short = 2
	Public Const IMT_MEM_DIB As Short = 3
	Public Const IMT_MEM_END As Short = 4
	Public Const IMT_FILE_DIRECT As Short = 5
	Public Const IMT_FILE_BMP As Short = 6
	Public Const IMT_FILE_PCX As Short = 7
	Public Const IMT_FILE_DCX As Short = 8
	Public Const IMT_FILE_GIF As Short = 9
	Public Const IMT_FILE_TGA As Short = 10
	Public Const IMT_FILE_TIFF_NOCOMP As Short = 11
	Public Const IMT_FILE_TIFF_PACKBITS As Short = 12
	Public Const IMT_FILE_TIFF_LZW As Short = 13
	Public Const IMT_FILE_TIFF_LZDIFF As Short = 14
	Public Const IMT_FILE_TIFF_G31DNOEOL As Short = 15
	Public Const IMT_FILE_TIFF_G31D As Short = 16
	Public Const IMT_FILE_TIFF_G31D_REV As Short = 17
	Public Const IMT_FILE_TIFF_G32D As Short = 18
	Public Const IMT_FILE_TIFF_G4 As Short = 19
	Public Const IMT_FILE_CLS As Short = 20
	Public Const IMT_FILE_JPEG As Short = 21
	Public Const IMT_FILE_END As Short = 22
	Public Const IMT_BFTOBJ As Short = 23
	
	Declare Function SendMessage Lib "user32"  Alias "SendMessageA"(ByVal hWnd As Integer, ByVal msg As Integer, ByVal wParam As Integer, ByVal lParam As Integer) As Integer
	Declare Function GetPrivateProfileString Lib "kernel32"  Alias "GetPrivateProfileStringA"(ByVal lpApplicationName As String, ByVal lpKeyName As String, ByVal lpDefault As String, ByVal lpRetunedString As String, ByVal nSize As Integer, ByVal lpFileName As String) As Integer
    Declare Function GetPrivateProfileInt Lib "kernel32" Alias "GetPrivateProfileIntA" (ByVal lpApplicationName As String, ByVal lpKeyName As String, ByVal nDefault As Integer, ByVal lpFileName As String) As Integer
	Declare Function WritePrivateProfileString Lib "kernel32"  Alias "WritePrivateProfileStringA"(ByVal lpApplicationName As String, ByVal lpKeyName As String, ByVal lpString As String, ByVal lpFileName As String) As Boolean
	Declare Function Sleep Lib "kernel32" (ByVal dwMilliseconds As Integer) As Object
	
	Public Sub ChangeExt(ByRef pszTemp As String, ByRef pszExt As String)
		pszTemp = Left(pszTemp, Len(pszTemp) - 3) & pszExt
	End Sub
	
	Public Sub SetVocExtension(ByRef ModemID As Integer, ByRef pszFile As String)
        Dim nIndex As Short
		nIndex = fMainForm.VoiceOCX.GetModemType(ModemID) + 1
		If Right(pszFile, 4) <> szVocExts(nIndex) Then
			If (Mid(pszFile, Len(pszFile) - 4, 1)) = "." Then
                ChangeExt(pszFile, szVocExts(nIndex))
            Else
                pszFile = pszFile & szVocExts(nIndex)
            End If
		End If
	End Sub
End Module