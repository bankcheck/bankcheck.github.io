'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'                                                                   '
'  Black Ice ReceiveDTMFandDecideToReceiveFaxOrVoice VB.NET Sample  '
'                                                                   '
'  StrTok.vb                                                        '
'                                                                   '
'  (c) Copyright Black Ice Software Inc. 2007                       '
'                                                                   '
'  All Rights Reserved                                              '
'                                                                   '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Module StrTok
    Public Function StrTok( _
          ByVal ScanString As String, _
          ByVal Token As String) _
          As String

        Static Stored As String

        Dim i, sLen As Integer, _
            vCh As String, _
            OutStr As String = ""

        On Error Resume Next

        If (Token = "") Then
            Return ""
        End If

        If ScanString <> vbNullString Then
            Stored = ScanString
        End If

        If Stored = vbNullString Then
            Return ""
        End If

        If (Stored.Length >= Token.Length) Then
            If Stored.Substring(0, Token.Length - 1) = Token Then
                Stored = Stored.Substring(Token.Length - 1)
                Return ""
            End If
        End If

        sLen = Stored.Length - 1

        For i = 0 To sLen
            vCh = Stored.Substring(i, Len(Token))

            If (vCh = Token) Then
                If ((i + Len(Token)) <= sLen) Then
                    Stored = Stored.Substring(i + Len(Token))
                    Return OutStr
                Else
                    Exit For
                End If
            Else
                vCh = Stored.Substring(i, 1)
                OutStr += vCh
            End If
        Next i

        Stored = ""
        Return OutStr
    End Function
End Module
