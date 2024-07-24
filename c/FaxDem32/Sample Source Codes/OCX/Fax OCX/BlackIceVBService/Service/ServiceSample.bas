Attribute VB_Name = "Sample"
Option Explicit

Public Const Service_Name = "SampleVB6Service"
Public Const INFINITE = -1&      '  Infinite timeout
Private Const WAIT_TIMEOUT = 258&

Public Type OSVERSIONINFO
    dwOSVersionInfoSize As Long
    dwMajorVersion As Long
    dwMinorVersion As Long
    dwBuildNumber As Long
    dwPlatformId As Long
    szCSDVersion(1 To 128) As Byte      '  Maintenance string for PSS usage
End Type

Public Const VER_PLATFORM_WIN32_NT = 2&

Private Declare Function GetVersionEx Lib "kernel32" Alias "GetVersionExA" (lpVersionInformation As OSVERSIONINFO) As Long
Private Declare Function MessageBox Lib "user32" Alias "MessageBoxA" (ByVal hWnd As Long, ByVal lpText As String, ByVal lpCaption As String, ByVal wType As Long) As Long

Public hStopEvent As Long, hStartEvent As Long, hStopPendingEvent
Public IsNT As Boolean, IsNTService As Boolean
Public ServiceName() As Byte, ServiceNamePtr As Long
Private FaxOcx As Object

Public Sub Sleep(Seconds As Single)
    Dim OldTimer As Single
    
    OldTimer = Timer
    Do While (Timer - OldTimer) < Seconds
    Loop
    Exit Sub
End Sub

Public Function WaitForFaxManagerReady(port As String)
Dim iStsCnt As Integer
Dim status As Integer
iStsCnt = 0
    status = FaxOcx.GetPortStatus(port)
    Do While status <> 0
        status = FaxOcx.GetPortStatus(port)
        If status = -1 Then Exit Function
        If (status And 4 = 0) Then
            iStsCnt = 0
            Sleep 4
        End If
        Sleep 1
        iStsCnt = iStsCnt + 1
        If (iStsCnt >= 130) Then
                Exit Function
        End If
    Loop
End Function

Private Sub Main()
    Dim hnd As Long
    Dim h(0 To 1) As Long
    Dim errcode As Long
    Dim PageNum As Long
    Dim FaxID As Long
    Dim i As Integer
    Dim bError As Boolean
    ' Only one instance
    If App.PrevInstance Then Exit Sub
    ' Check OS type
    IsNT = CheckIsNT()
    ' Creating events
    hStopEvent = CreateEvent(0, 1, 0, vbNullString)
    hStopPendingEvent = CreateEvent(0, 1, 0, vbNullString)
    hStartEvent = CreateEvent(0, 1, 0, vbNullString)
    ServiceName = StrConv(Service_Name, vbFromUnicode)
    ServiceNamePtr = VarPtr(ServiceName(LBound(ServiceName)))
    If IsNT Then
        ' Trying to start service
        hnd = StartAsService
        h(0) = hnd
        h(1) = hStartEvent
        ' Waiting for one of two events: sucsessful service start (1) or
        ' terminaton of service thread (0)
        IsNTService = WaitForMultipleObjects(2&, h(0), 0&, INFINITE) = 1&
        If Not IsNTService Then
            CloseHandle hnd
            'MsgBox "This program must be started as service."
            MessageBox 0&, "This program must be started as a service.", App.Title, vbInformation Or vbOKOnly Or vbMsgBoxSetForeground
        End If
    Else
        MessageBox 0&, "This program is only for Windows NT/2000/XP.", App.Title, vbInformation Or vbOKOnly Or vbMsgBoxSetForeground
    End If
    
    If IsNTService Then
        ' ******************
        ' Here you may initialize and start service's objects
        ' These objects must be event-driven and must return control
        ' immediately after starting.
        ' ******************
        SetServiceState SERVICE_RUNNING
        App.LogEvent "VB6 Service Sample started"
        Set FaxOcx = CreateObject("FAX.FAXCtrl.1")
        Dim port As String
        FaxOcx.CloseAllPorts
        '****************************Black Ice*******************************
        'Specify which Channel would you like to use.
        '********************************************************************
        port = "BChannel1"
        '****************************Black Ice*******************************
        'Specify the btcall.cfg file with full path if using Brooktrout card
        '********************************************************************
        FaxOcx.BrooktroutCFile = "D:\Program Files\Black Ice Software Inc\FaxVoiceCpp32\Bin\btcall.cfg"
        errcode = FaxOcx.OpenPort(port)
        WaitForFaxManagerReady (port)
        If (errcode) Then
                App.LogEvent Format(errcode)
            Else: App.LogEvent "Port was opened"
                FaxOcx.SetPortCapability port, 10, 7
        End If
        '****************************Black Ice*******************************
        'Specify with full path the file to be sent
        '********************************************************************
        FaxOcx.PageFileName = "D:\Program Files\Black Ice Software Inc\FaxVoiceCpp32\Bin\Test.tif"
        PageNum = FaxOcx.GetNumberOfImages(FaxOcx.PageFileName, 11)
        If PageNum > 0 Then
            FaxID = FaxOcx.CreateFaxObject(1, PageNum, 3, 2, 1, 2, 2, 3, 2, 1)
            WaitForFaxManagerReady (port)
            If (FaxID = 0) Then
                App.LogEvent "Cannot create fax object"
            Else
                    FaxOcx.SetFaxParam FaxID, 9, PageNum
        '****************************Black Ice*******************************
        'Specify the phone number you would like to send the fax to
        '********************************************************************
                    FaxOcx.SetPhoneNumber FaxID, "5"
            End If
            bError = False
            For i = 1 To PageNum
                If (FaxOcx.SetFaxPage(FaxID, i, 17, i)) Then
                    App.LogEvent "Can't set fax page ! "
                    bError = True
                   Exit For
                End If
            Next
            WaitForFaxManagerReady (port)
            If bError = False Then
                App.LogEvent "Fax must go"
            End If
            If bError = False Then
                FaxOcx.SetPortCapability port, 3, 3
                FaxOcx.SetPortCapability port, 4, 2
                FaxOcx.SetPortCapability port, 10, 15
                i = FaxOcx.SendNow(port, FaxID)
            End If
            WaitForFaxManagerReady (port)
            If i = 0 Then
                App.LogEvent "Fax started successfully"
            Else: App.LogEvent "Error: " + Format(i)
            End If
        End If
        
        Do
            ' ******************
            ' It is main service loop. Here you may place statements
            ' which perform useful functionality of this service.
            ' ******************
            ' Loop repeats every second. You may change this interval.
        Loop While WaitForSingleObject(hStopPendingEvent, 1000&) = WAIT_TIMEOUT
        ' ******************
        ' Here you may stop and destroy service's objects
        ' ******************
        SetServiceState SERVICE_STOPPED
        App.LogEvent "VB6 Service Sample stopped"
        Set FaxOcx = Nothing
        SetEvent hStopEvent
        ' Waiting for service thread termination
        WaitForSingleObject hnd, INFINITE
        CloseHandle hnd
    End If
    CloseHandle hStopEvent
    CloseHandle hStartEvent
    CloseHandle hStopPendingEvent
End Sub

' CheckIsNT() returns True, if the program runs
' under Windows NT or Windows 2000, and False
' otherwise.
Public Function CheckIsNT() As Boolean
    Dim OSVer As OSVERSIONINFO
    OSVer.dwOSVersionInfoSize = LenB(OSVer)
    GetVersionEx OSVer
    CheckIsNT = OSVer.dwPlatformId = VER_PLATFORM_WIN32_NT
End Function

