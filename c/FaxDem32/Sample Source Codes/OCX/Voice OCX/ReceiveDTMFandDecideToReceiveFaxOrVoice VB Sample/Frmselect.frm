VERSION 5.00
Begin VB.Form frmSelectPort 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Select Port/Modem"
   ClientHeight    =   3885
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4215
   Icon            =   "Frmselect.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3885
   ScaleWidth      =   4215
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton btnVoiceFormats 
      Caption         =   "&Voice formats..."
      Height          =   375
      Left            =   2640
      TabIndex        =   13
      Top             =   3480
      Width           =   1455
   End
   Begin VB.TextBox ModemCaps 
      Height          =   375
      Left            =   120
      Locked          =   -1  'True
      TabIndex        =   5
      Top             =   3000
      Width           =   3975
   End
   Begin VB.TextBox Model 
      Height          =   375
      Left            =   120
      Locked          =   -1  'True
      TabIndex        =   4
      Top             =   2280
      Width           =   3975
   End
   Begin VB.TextBox Manufacturer 
      Height          =   375
      Left            =   120
      Locked          =   -1  'True
      TabIndex        =   3
      Top             =   1560
      Width           =   3975
   End
   Begin VB.ComboBox cbModemType 
      Height          =   315
      ItemData        =   "Frmselect.frx":030A
      Left            =   120
      List            =   "Frmselect.frx":0320
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   960
      Width           =   2655
   End
   Begin VB.CommandButton btnCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   375
      Left            =   2880
      TabIndex        =   8
      Top             =   1080
      Width           =   1215
   End
   Begin VB.CommandButton btnTest 
      Caption         =   "&Test"
      Default         =   -1  'True
      Height          =   375
      Left            =   2880
      TabIndex        =   7
      Top             =   600
      Width           =   1215
   End
   Begin VB.CommandButton btnOpenPort 
      Caption         =   "&Open Port"
      Height          =   375
      Left            =   2880
      TabIndex        =   6
      Top             =   120
      Width           =   1215
   End
   Begin VB.ComboBox AllPorts 
      Height          =   315
      Left            =   120
      Style           =   2  'Dropdown List
      TabIndex        =   1
      Top             =   360
      Width           =   1695
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      Caption         =   "Modem Type:"
      Height          =   195
      Left            =   120
      TabIndex        =   12
      Top             =   720
      Width           =   975
   End
   Begin VB.Label Label5 
      AutoSize        =   -1  'True
      Caption         =   "Modem Capabilities"
      Height          =   195
      Left            =   120
      TabIndex        =   11
      Top             =   2760
      Width           =   1365
   End
   Begin VB.Label Label4 
      AutoSize        =   -1  'True
      Caption         =   "&Model"
      Height          =   195
      Left            =   120
      TabIndex        =   10
      Top             =   2040
      Width           =   435
   End
   Begin VB.Label Label3 
      AutoSize        =   -1  'True
      Caption         =   "Manufacturer"
      Height          =   195
      Left            =   120
      TabIndex        =   9
      Top             =   1320
      Width           =   945
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Serial port to use"
      Height          =   195
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1185
   End
End
Attribute VB_Name = "frmSelectPort"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private nSelPort As Integer
Private bLogEnabled As Boolean
Private bTesting As Boolean
Private bTested As Boolean
Private ActualPort As Integer
Private bAutoOpen As Boolean

Private modemLucent As Integer
Private modemCLogic As Integer
Private modemConexant As Integer

Private listAuto As Integer
Private listRockwell As Integer
Private listUSRobotics As Integer
Private listLucent As Integer
Private listCLogic As Integer
Private listConexant As Integer

Private szEncodingModes As String


Public Function GetSelectedPort() As Long
    GetSelectedPort = Modem
End Function

Public Function LogEnabled()
    LogEnabled = bLogEnabled
End Function

Private Sub AllPorts_Click()
    bTested = False
    DestroyModem
End Sub

Private Sub btnCancel_Click()
    nPrStatus = cnsNoneAttached
    DestroyModem
    fMainForm.CloseButton.Enabled = False
    Unload Me
End Sub

Private Sub btnOpenPort_Click()
    Dim nPort As Integer
    Dim szPort As String
    Dim nIndex
    bTesting = False
    If bTested = False Then
        nIndex = cbModemType.ListIndex
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
            szPort = AllPorts.text
            nPrStatus = cnsSelectPort
            If fMainForm.VoiceOCX.OpenPort(lModemID, szPort) = 0 Then
                btnVoiceFormats.Enabled = False
                btnTest.Enabled = False
                btnCancel.Enabled = False
            Else
                MsgBox "Couldn't open modem port!"
                nPrStatus = cnsNoneAttached
                DestroyModem
            End If
        Else
            MsgBox "Couldn't create modem object!", vbCritical
        End If
    End If
    btnTest.Enabled = False
    btnVoiceFormats.Enabled = False
    btnOpenPort.Enabled = False
    nSelPort = AllPorts.ItemData(AllPorts.ListIndex)

    bLogEnabled = True
    If bTested = True Then
        Unload Me
    End If
End Sub

Private Sub btnTest_Click()
    Dim nPort As Integer, szPort As String
    Dim nIndex
    bTesting = True
    nIndex = cbModemType.ListIndex
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
    DestroyModem
    lModemID = fMainForm.VoiceOCX.CreateModemObject(nIndex - 1)
    bTested = True
    If lModemID <> 0 Then
        szPort = AllPorts.text
        nPrStatus = cnsSelectPort
        If fMainForm.VoiceOCX.OpenPort(lModemID, szPort) = 0 Then
            btnOpenPort.Enabled = False
            btnTest.Enabled = False
            btnCancel.Enabled = False
            btnVoiceFormats.Enabled = False
        Else
            MsgBox "Couldn't open modem port!"
            nPrStatus = cnsNoneAttached
            DestroyModem
        End If
    Else
        MsgBox "Couldn't create modem object!", vbCritical
    End If
    btnTest.Enabled = False
    btnVoiceFormats.Enabled = False
End Sub

Private Sub btnVoiceFormats_Click()
    If szEncodingModes <> "" Then
        MsgBox szEncodingModes
    Else
        MsgBox "No opened modem!"
    End If
End Sub

Private Sub cbModemType_Click()
    btnTest.Enabled = True
    btnOpenPort.Enabled = True
    btnVoiceFormats.Enabled = True
End Sub

Private Sub Form_Load()
    Dim szPorts As String
    Dim t1, t2 As String
    Dim bFlag As Boolean
    Dim j As Integer
    Dim nPort As Integer
    
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
                t1 = Left(szPorts, j - 1)
                szPorts = Right(szPorts, Len(szPorts) - j)
            End If
            AllPorts.AddItem (t1)
            nPort = Val(Right(t1, Len(t1) - 3))
            AllPorts.ItemData(AllPorts.ListCount - 1) = nPort
        Wend
    End If

    If AllPorts.ListCount > 0 Then
        AllPorts.ListIndex = 0
    Else
        AllPorts.Enabled = False
        btnTest.Enabled = False
    End If
    btnOpenPort.Enabled = True
    btnVoiceFormats.Enabled = True
    cbModemType.ListIndex = 0
    
End Sub

Public Sub VoiceOCX_ModemOK()
    Dim szManufacturer As String
    Dim szModel As String
    Dim szModes As String
    Dim Caps As String
    Dim nIndex As Integer
    Dim bStarted As Boolean

    bStarted = False

    fMainForm.VoiceOCX.GetTestResultExt lModemID, szManufacturer, szModel, szModes, szEncodingModes

    Manufacturer.text = szManufacturer
    Model.text = szModel
    For nIndex = 1 To 5 Step 1
        If Mid(szModes, nIndex, 1) = "1" Then
            If bStarted = True Then
                Caps = Caps + "/"
            End If
            Caps = Caps + szVoiceCaps(nIndex)
            bStarted = True
        End If
    Next
    ModemCaps.text = Caps

    btnTest.Enabled = False
    btnOpenPort.Enabled = True
    btnCancel.Enabled = True
    btnVoiceFormats.Enabled = True
    
    If ActualPort = 0 Then
        cbModemType.ListIndex = listRockwell
    Else
        If ActualPort = 1 Then
            cbModemType.ListIndex = listUSRobotics
        Else
            If ActualPort = 6 Then
                cbModemType.ListIndex = listLucent
            Else
                If ActualPort = 7 Then
                    cbModemType.ListIndex = listCLogic
                Else
                    If ActualPort = 8 Then
                        cbModemType.ListIndex = listConexant
                    End If
                End If
            End If
        End If
    End If
    If bTesting = False Then
        Unload Me
    End If
    
    
End Sub

Public Sub VoiceOCX_ModemError()
    
    If (bAutoOpen = True) And (ActualPort <> 7) Then
        DestroyModem
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
            szPort = AllPorts.text
            If fMainForm.VoiceOCX.OpenPort(lModemID, szPort) = 0 Then
                btnOpenPort.Enabled = False
                btnTest.Enabled = False
                btnCancel.Enabled = False
                btnVoiceFormats.Enabled = False
            Else
                MsgBox "Couldn't open modem port!"
                nPrStatus = cnsNoneAttached
                DestroyModem
            End If
        Else
            MsgBox "Couldn't create modem object!", vbCritical
        End If
    Else
        'nPrStatus = cnsNoneAttached
        DestroyModem
        btnTest.Enabled = True
        btnVoiceFormats.Enabled = False
        btnOpenPort.Enabled = True
        btnCancel.Enabled = True
    
        MsgBox "Modem ERROR message received"
        bTested = False
    End If
End Sub

Public Sub VoiceOCX_PortOpen()
    If fMainForm.VoiceOCX.TestVoiceModem(lModemID) <> 0 Then
        MsgBox "Modem test failed!", vbCritical
        nPrStatus = cnsNoneAttached
        DestroyModem
    End If
End Sub

Public Sub DestroyModem()
    Dim nIndex As Integer

    If lModemID <> 0 Then
        'If bAutoOpen = True Then
            fMainForm.VoiceOCX.ClosePort (lModemID)
        'End If
        fMainForm.VoiceOCX.DestroyModemObject lModemID
        lModemID = 0
    End If

    btnTest.Enabled = True
    btnOpenPort.Enabled = True
    btnVoiceFormats.Enabled = True
    Manufacturer.text = ""
    Model.text = ""
    ModemCaps.text = ""
End Sub
