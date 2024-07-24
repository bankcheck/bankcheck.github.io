Option Strict Off
Option Explicit On
Friend Class frmWaitforDTMF
	Inherits System.Windows.Forms.Form
	Private nDTMFNum As Short
	Private nDelimiter As Short
	
	Private Sub btnCancel_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnCancel.Click
		Me.Close()
	End Sub
	
	Private Sub btnOK_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnOK.Click
		If edDigits.Text <> "" Then
			nDTMFNum = Val(edDigits.Text)
			If edDelimiter.Text <> "" Then
				nDelimiter = Asc(edDelimiter.Text)
				Me.Close()
			Else
				nDelimiter = 0
				Me.Close()
			End If
		Else
			MsgBox("Please specify the maximum number of acceptable DTMF digits!")
		End If
	End Sub
	
    Public Function GetNumberOfDigits() As Short
        GetNumberOfDigits = nDTMFNum
    End Function
	
    Public Function GetDelimiter() As Short
        GetDelimiter = nDelimiter
    End Function
End Class