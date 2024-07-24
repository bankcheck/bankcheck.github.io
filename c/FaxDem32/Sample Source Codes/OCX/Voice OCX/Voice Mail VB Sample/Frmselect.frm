VERSION 5.00
Begin VB.Form frmSelectPort 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Select Port/Modem"
   ClientHeight    =   3825
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4560
   Icon            =   "Frmselect.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3825
   ScaleWidth      =   4560
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CheckBox btnLog 
      Caption         =   "Enable &Log"
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   3480
      Width           =   1215
   End
   Begin VB.TextBox ModemCaps 
      Height          =   375
      Left            =   120
      Locked          =   -1  'True
      TabIndex        =   5
      Top             =   3000
      Width           =   4335
   End
   Begin VB.TextBox Model 
      Height          =   375
      Left            =   120
      Locked          =   -1  'True
      TabIndex        =   4
      Top             =   2280
      Width           =   4335
   End
   Begin VB.TextBox Manufacturer 
      Height          =   375
      Left            =   120
      Locked          =   -1  'True
      TabIndex        =   3
      Top             =   1560
      Width           =   4335
   End
   Begin VB.ComboBox cbModemType 
      Height          =   315
      ItemData        =   "Frmselect.frx":030A
      Left            =   120
      List            =   "Frmselect.frx":0320
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   960
      Width           =   3015
   End
   Begin VB.CommandButton btnCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   375
      Left            =   3240
      TabIndex        =   9
      Top             =   1080
      Width           =   1215
   End
   Begin VB.CommandButton btnTest 
      Caption         =   "&Test"
      Default         =   -1  'True
      Height          =   375
      Left            =   3240
      TabIndex        =   8
      Top             =   600
      Width           =   1215
   End
   Begin VB.CommandButton btnOpenPort 
      Caption         =   "&Open Port"
      Height          =   375
      Left            =   3240
      TabIndex        =   7
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
      TabIndex        =   13
      Top             =   720
      Width           =   975
   End
   Begin VB.Label Label5 
      AutoSize        =   -1  'True
      Caption         =   "Modem Capabilities"
      Height          =   195
      Left            =   120
      TabIndex        =   12
      Top             =   2760
      Width           =   1365
   End
   Begin VB.Label Label4 
      AutoSize        =   -1  'True
      Caption         =   "&Model"
      Height          =   195
      Left            =   120
      TabIndex        =   11
      Top             =   2040
      Width           =   435
   End
   Begin VB.Label Label3 
      AutoSize        =   -1  'True
      Caption         =   "Manufacturer"
      Height          =   195
      Left            =   120
      TabIndex        =   10
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
Private Modem As Long
Private nSelPort As Integer
Private bLogEnabled As Boolean
Private bTesting As Boolean
Private bTested As Boolean
Private ActualPort As Integer
Private bAutoOpen As Boolean

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
    DestroyModem
    Unload Me
End Sub
Private Sub btnOpenPort_Click()
    Dim nPort As Integer
    Dim szPort As String
    Dim nIndex
    bTesting = False
    If bTested = False Then
        nIndex = cbModemType.ListIndex
    If nIndex = 3 Then
        nIndex = 7
    End If
    If nIndex = 4 Then
        nIndex = 8
    End If
    If nIndex = 5 Then
        nIndex = 9
    End If
    If nIndex = 0 Then
        ActualPort = 8
        nIndex = 9
        bAutoOpen = True
    Else
        bAutoOpen = False
        ActualPort = nIndex - 1
    End If

        Modem = fMainForm.VoiceOCX.CreateModemObject(nIndex - 1)
        If Modem <> 0 Then
            szPort = AllPorts.Text
            nIndex = AddNewModem(Modem)
            If nIndex > 0 Then
                fModemID(nIndex, 1) = cnsSelectPort
                If fMainForm.VoiceOCX.OpenPort(Modem, szPort) = 0 Then
                    btnTest.Enabled = False
                    btnCancel.Enabled = False
                Else
                    MsgBox "Couldn't open modem port!"
                    DestroyModem
                End If
            End If
        Else
            MsgBox "Couldn't create modem object!", vbCritical
        End If
    End If
    btnTest.Enabled = False
    btnOpenPort.Enabled = False
    nSelPort = AllPorts.ItemData(AllPorts.ListIndex)

    If btnLog.Value = 1 Then
        bLogEnabled = True
    Else
        bLogEnabled = False
    End If
    If bTested = True Then
        Unload Me
    End If


End Sub

Private Sub btnTest_Click()
    Dim nPort As Integer, szPort As String
    Dim nIndex
    bTesting = True
    nIndex = cbModemType.ListIndex
    If nIndex = 3 Then
        nIndex = 7
    End If
    If nIndex = 4 Then
        nIndex = 8
    End If
    If nIndex = 5 Then
        nIndex = 9
    End If
    If nIndex = 0 Then
        ActualPort = 8
        nIndex = 9
        bAutoOpen = True
    Else
        bAutoOpen = False
        ActualPort = nIndex - 1
    End If
    Modem = fMainForm.VoiceOCX.CreateModemObject(nIndex - 1)
    bTested = True
    If Modem <> 0 Then
        szPort = AllPorts.Text
        nIndex = AddNewModem(Modem)
        If nIndex > 0 Then
            fModemID(nIndex, 1) = cnsSelectPort
            If fMainForm.VoiceOCX.OpenPort(Modem, szPort) = 0 Then
                btnTest.Enabled = False
                btnCancel.Enabled = False
            Else
                MsgBox "Couldn't open modem port!"
                DestroyModem
            End If
        End If
    Else
        MsgBox "Couldn't create modem object!", vbCritical
    End If
    btnTest.Enabled = False
End Sub

Private Sub cbModemType_Change()
    bTested = False
    DestroyModem
End Sub

Private Sub Form_Load()
    Dim szPorts As String
    Dim t1, t2 As String
    Dim bFlag As Boolean
    Dim j As Integer
    Dim nPort As Integer
    bTested = False
    Modem = 0
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
    If cbModemType.ListCount > 0 Then
        cbModemType.ListIndex = 0
    End If
End Sub

Public Sub VoiceOCX_ModemOK()
    Dim szManufacturer As String
    Dim szModel As String
    Dim szModes As String
    Dim Caps As String
    Dim nIndex As Integer
    Dim bStarted As Boolean

    bStarted = False

    fMainForm.VoiceOCX.GetTestResult Modem, szManufacturer, szModel, szModes

    Manufacturer.Text = szManufacturer
    Model.Text = szModel
    For nIndex = 1 To 5 Step 1
        If Mid(szModes, nIndex, 1) = "1" Then
            If bStarted = True Then
                Caps = Caps + "/"
            End If
            Caps = Caps + szVoiceCaps(nIndex)
            bStarted = True
        End If
    Next
    ModemCaps.Text = Caps

    btnTest.Enabled = False
    btnOpenPort.Enabled = True
    btnCancel.Enabled = True
    If ActualPort = 0 Then
        cbModemType.ListIndex = 1
    Else
        If ActualPort = 1 Then
            cbModemType.ListIndex = 2
        Else
            If ActualPort = 6 Then
                cbModemType.ListIndex = 3
            Else
                If ActualPort = 7 Then
                    cbModemType.ListIndex = 4
                Else
                    If ActualPort = 8 Then
                        cbModemType.ListIndex = 5
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
                
        Modem = fMainForm.VoiceOCX.CreateModemObject(ActualPort)
        bTested = True
        If Modem <> 0 Then
            szPort = AllPorts.Text
            nIndex = AddNewModem(Modem)
            If nIndex > 0 Then
                fModemID(nIndex, 1) = cnsSelectPort
                If fMainForm.VoiceOCX.OpenPort(Modem, szPort) = 0 Then
                    btnTest.Enabled = False
                    btnCancel.Enabled = False
                Else
                    MsgBox "Couldn't open modem port!"
                    DestroyModem
                End If
            End If
        Else
            MsgBox "Couldn't create modem object!", vbCritical
        End If
        btnTest.Enabled = False
        btnOpenPort.Enabled = False
    Else
        btnTest.Enabled = False
        btnOpenPort.Enabled = False
        btnCancel.Enabled = True

        MsgBox "Modem ERROR message received"
        bTested = False

        DestroyModem
    End If

    
End Sub

Public Sub VoiceOCX_PortOpen()
    If fMainForm.VoiceOCX.TestVoiceModem(Modem) <> 0 Then
        MsgBox "Modem test failed!", vbCritical
        DestroyModem
    End If
End Sub

Public Sub DestroyModem()
    Dim nIndex As Integer

    If Modem <> 0 Then
        nIndex = FindTagToModemID(Modem)
        If nIndex > 0 Then
            fModemID(nIndex, 0) = 0
            fModemID(nIndex, 1) = cnsNoneAttached
        End If
        
        fMainForm.VoiceOCX.ClosePort (Modem)
        fMainForm.VoiceOCX.DestroyModemObject Modem
        Modem = 0
    End If

    btnTest.Enabled = True
    btnOpenPort.Enabled = True

    Manufacturer.Text = ""
    Model.Text = ""
    ModemCaps.Text = ""
End Sub
