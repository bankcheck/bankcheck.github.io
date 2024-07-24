Option Strict Off
Option Explicit On
Friend Class frmHelp
	Inherits System.Windows.Forms.Form
	
	
	Private Sub frmHelp_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
		HelpList.Items.Add("The sample shows how you can receive DTMF digits, receive faxes and record voices.")
		HelpList.Items.Add("")
		HelpList.Items.Add("You can open a COM port or a channel of three different card type with the ""Open"" buttons")
		HelpList.Items.Add("")
		HelpList.Items.Add("After open a port or a channel the sample answers automatically to a remote dialing and then you can choose one of the following:")
		HelpList.Items.Add("  Click on ""Receive Fax"" button to switch to fax mode, and then create a fax port and wait for a fax receiving on this port.")
		HelpList.Items.Add("  After a fax sent to this port this feature can automatically receive the fax object and then save it automatically to the")
		HelpList.Items.Add("  directory appears in a Message Box after end receiving. At the end of the receiving mode turns back to voice mode.")
		HelpList.Items.Add("")
		HelpList.Items.Add("  Click on ""Wait for DTMF"" button to set how many DTMF digits you like to get and the delimiter digit.")
		HelpList.Items.Add("  After this settings the sample waits for DTMF digits until those arrive.")
		HelpList.Items.Add("  When receive, digits behind the delimiter will be left.")
		HelpList.Items.Add("")
		HelpList.Items.Add("  Click on ""Record message"" button to record a voice message.")
		HelpList.Items.Add("  After the click it waits for some time for a voice format message. In both case (voice received or not received)")
		HelpList.Items.Add("  it creates a .wav file. If no voice format message received this file will contain nothing worthy, only some noise.")
		HelpList.Items.Add("  In the other case it will contain the voice sent to this port.")
		HelpList.Items.Add("")
		HelpList.Items.Add("  Click on the ""Close port/channel"" to automatically close the opened port or channel")
	End Sub
	
	Private Sub OKButton_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles OKButton.Click
		Me.Close()
	End Sub
	
End Class