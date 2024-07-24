VERSION 5.00
Begin VB.Form frmHelp 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Interactive Voice Sample Help"
   ClientHeight    =   4965
   ClientLeft      =   2760
   ClientTop       =   3750
   ClientWidth     =   9525
   Icon            =   "Help.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4965
   ScaleWidth      =   9525
   ShowInTaskbar   =   0   'False
   Begin VB.ListBox HelpList 
      Height          =   4155
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   9255
   End
   Begin VB.CommandButton OKButton 
      Caption         =   "OK"
      Height          =   375
      Left            =   4080
      TabIndex        =   0
      Top             =   4440
      Width           =   1335
   End
End
Attribute VB_Name = "frmHelp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Sub Form_Load()
    HelpList.AddItem "The sample shows how you can receive DTMF digits, receive faxes and record voices."
    HelpList.AddItem ""
    HelpList.AddItem "You can open a COM port or a channel of three different card type with the ""Open"" buttons"
    HelpList.AddItem ""
    HelpList.AddItem "After open a port or a channel the sample answers automatically to a remote dialing and then you can choose one of the following:"
    HelpList.AddItem "  Click on ""Receive Fax"" button to switch to fax mode, and then create a fax port and wait for a fax receiving on this port."
    HelpList.AddItem "  After a fax sent to this port this feature can automatically receive the fax object and then save it automatically to the"
    HelpList.AddItem "  directory appears in a Message Box after end receiving. At the end of the receiving mode turns back to voice mode."
    HelpList.AddItem ""
    HelpList.AddItem "  Click on ""Wait for DTMF"" button to set how many DTMF digits you like to get and the delimiter digit."
    HelpList.AddItem "  After this settings the sample waits for DTMF digits until those arrive."
    HelpList.AddItem "  When receive, digits behind the delimiter will be left."
    HelpList.AddItem ""
    HelpList.AddItem "  Click on ""Record message"" button to record a voice message."
    HelpList.AddItem "  After the click it waits for some time for a voice format message. In both case (voice received or not received)"
    HelpList.AddItem "  it creates a .wav file. If no voice format message received this file will contain nothing worthy, only some noise."
    HelpList.AddItem "  In the other case it will contain the voice sent to this port."
    HelpList.AddItem ""
    HelpList.AddItem "  Click on the ""Close port/channel"" to automatically close the opened port or channel"
End Sub

Private Sub OKButton_Click()
    Unload Me
End Sub

Private Sub RichTextBox1_Change()

End Sub
