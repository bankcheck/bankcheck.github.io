*****************************************************************************
* Black Ice Software, Inc.                                                  *
*                                                                           *
*                                  Fax C++/OCX                              *
*                                                                           *
*                                 Voice C++/OCX                             *
*                                                                           *
* Latest changes                                                            *
*                                                                           *
***************************************************************************
12.60 (07-26-2007)
Fax/Voice C++	: Application shortcuts changed
		: Updated Brooktrout SDK (5.1.3) & Drivers (5.3)

12.51 (06-26-2007)
Fax/Voice C++	: Internet Faxing sample- Send Fax is added to FaxCPP installs, Cabs also 			added.
12.50 (06-14-2007)
Fax/Voice C++   : Vista Support
	  	: Vista detection added for Brooktrout drivers
		: Installshield 12 migration

12.40 (04-11-2007)
Fax/Voice C++   : 5.0.4 Brooktrout SDK upgrades

12.33 (03-29-2007)
Fax/Voice C++   : Added Brooktrout CallerID support into voice.dll
		: Added CallerID support into samples

12.32 (02-27-2007)
Fax/Voice C++   : InstallSheild 12 migration
		: Caller ID bug fix

12.31 (12-14-2006)
Fax/Voice C++   : Fixed Brooktrout abort error on sending side.

12.30 (11-29-2006)
Fax/Voice C++	: Added Brooktrout 5.0 SDK support
		: Interactive VB Voice Sample VB, Voice Mail VB Sample fixes

12.24 (10-30-2006)
Fax/Voice C++	: Fixed OCX 1-port issue in DEMO

12.23 (10-04-2006)
Fax/Voice C++	: Abort fax issue fixed.
		: Some other bugs fixed in VoiceDLL and voice samples.
		

12.22 (09-15-2006)
Fax/Voice C++	: Hang up button to all ReceiveDTMFandDecideToReceiveFaxOrVoice (Dll, VB, VB.NET, C#) sample
		: Interactive VB Voice Sample can now open Brootktrout TR1034 channel
		: DTMF digits are emptied from the boards buffer after receiving
		: Interactive Voice samples (VB and Dll) and ReceiveDTMFandDecideToReceiveFaxOrVoice samples hangs up after sending or receiving fax
		: Interactive Voice samples (VB and Dll) and ReceiveDTMFandDecideToReceiveFaxOrVoice samples are more stable,
		  a lot of bug are repaired

12.21 (08-01-2006)
Fax/Voice C++	: New ReceiveDTMFandDecideToReceiveFaxOrVoice VB.NET sample
		: New RecDTMF_FaxOrVoice C# sample

12.20 (07-14-2006)
Voice C++	: ReceiveDTMFandDecideToReceiveFaxOrVoice samples
                : Works using Brooktrout TR1034 boards
Fax/VoiceC++    : Dll, C# and VB.NET sample source codes converted to VS2005

12.18 (06-02-2006)
Voice C++	: WaitCommEvent function fix

12.17 (05-22-2006)
Fax C++		: Implementation of the GetFaxCapability function used by the PortCapabilities function

12.16 (04-26-2006)
Fax C++		: Improved Brooktrout Installation Proceedure
		
12.15 (04-11-2006)
Fax C++		: Refresh MyDll file in install project
		: Add SetBTCALLpath() funcion to script
		: Take out TAPI samples (exe, shortcut, source)
		: Add TempfileInfo sample (exe, shortcut, source)
		: Add util folder to start menu items
		: Updated features.url for Fax C++ & Voice C++

12.14 (03-30-2006)
Fax C++		: Updated Brooktrout installation proceedure
		  

12.13 (02-10-2006)
Fax C++		: Fixed problem with BfvLineTerminate and BfvLineReset functions.
		  Added Brooktrout debug info to Fax OCX Samples

12.11 (02-02-2006)
Fax C++		: Added Brooktrout SDK 4.0.0 to the Fax C++
		  Multiple channel testing, opening and closing for Brooktrout
		  Added TempFileInfo Sample


12.10 (01-04-2006)
Fax C++		: Added Brooktrout SDK 4.1.0 to the Fax C++


12.00 (01-03-2006)
Fax C++		: Added Brooktrout SDK 4.0.0 to the Fax C++


11.40 (12-09-2005)
Fax C++		: Fixed memory leaks at BrooktroutTR1000.dll and FaxWithBrooktrout 		  Sample


11.30 (09-12-2005)	
Fax C++		: Added support for the Brooktrout TR1000 3.3.2 drivers 4.9.0.1


11.22 (07-11-2005)	 
Fax C++		: Fixed problem with channels hanging when an outgoing 
		  fax is aborted using Brooktrout TR1034 board.

11.21 (06-15-2005)	 
Fax C++		: Fixed problem with TR1034 Brooktrout boards not 
		  picking up the call after 3 rings


11.20 (06-08-2005)	 
Fax C++		: Fixed call collision problem with TR1034 boards
Voice C++	: Fixed crash in MSI Predictive Dialing VB sample if 
		  no MSI board is present.

11.12 (06-01-2005)	
Fax C++		: New samples added
		: Sample source codes directory structure changed
Voice C++	: New MSI Predictive Dialing C++ Sample added.
		: Sample source codes directory structure changed


11.11 (04-07-2005)	
Fax C++		: Fixed problem when quickly opening and closing COM ports using 
		  the fax.ocx

11.10 (03-18-2005)	
Fax C++		: Solved problem with opening COM ports when a Brooktrout board
		  is present in the PC. 
Fax C++		: Workaround for the problem with aswering calls using Dialogic 
		  D41 boards when calls come in in the same time. 


11.09 (03-03-2005)	
Fax C++ 	: New samples added
Voice C++ 	: New samples added


11.08 (02-22-2005)	
Fax C++		: Fixed problem with Brooktrout TR1034 port hunging
                  when dialing fails.
		: New Retry samples added

11.07 (02-01-2005)	
Fax C++		: Sending fax using Brooktrout TR1034 board will send the 
                  start page and endpage events.


11.06 (01-31-2005)	
Fax C++		: Solved problem with Visual Basic service not finding the 
		  callctrl.cfg file.
		: Ring detection has been disabled when waiting for a call 
		  times out

11.05 (01-04-2005)	
Fax C++		: Fixed memory leak in the GetFaxImagePage function. 
Voice OCX	: Problem with GetNumberOfLicensedPorts fixed


11.04 (12-20-2004)	
Fax C++		: Added priority level to the fax object in the fax queue
		: Added user strings to the fax object

11.03 (12-14-2004)	
Fax C++		: The location of the callctrl.cfg will be read from the
 		  btcall.cfg file for Brooktrout boards. 
		: Fax C++ will call BfvLineTerminateCall if BfvLineSetup fails
		: Updated fax samples


11.02 (12-07-2004)	
Fax C++		: fixed problem with sending color fax in Class 1.0

11.01 (11-16-2004)	
Fax C++		: new methods added to the Fax.OCX to retreive and change 
		  modem setup string and reset string.
		: Improved VB, C#.NET, VB.NET and Delphi samples. 


11.00 (10-27-2004)	
		: New imaging components (dlls) with several fixes
		: Licensing has been added
                : Cover page components removed (CoverPage SDK can be purchased)
                : Additional file format support removed (Image SDK can be purchased)

10.11 (10-01-2004)	
Fax C++		: "Command not received" problem fixed in CLASS 1
		: Fixed crash when calling the GetNumberofLicensedPorts method
                : Fixed problem with Fax.ocx not sending the Brooktrout channel
                  name at the Terminate event.
		: Fixed problem with returning "Session not terminated" error string 
                  on success from the Fax.ocx 

Voice C++ 	: Opening COM ports fixed in the Delphi and VB.NET samples


10.10 (08-30-2004)
Fax C++		: Added support for Brooktrout TR1034 Analog boards
		  and for the Brooktrout TR1000/1034 Drivers version 4.9.0.0
		: V.34 on the Brooktrout boards can be disabled using 
		  the btcall.cfg config file


10.07 (06-17-2004)
Fax C++		: Test modem feature improved.
		: Dialogic boards: dx_initcallp called when channel is opened
		: DetectDialtone() function added
		: ## will be converted to # in the fax number

Voice C++ 	: MSI Predictive dialing sample inmproved. 
		: Fixed problem with detecting analog Dialogic D41 and 
		  D240 digital boards in the same PC.


10.06 (06-14-2004)
Fax C++		: workaround for the "Training down to 2400" error.

10.05 (05-03-2004)
Fax C++		: C++ projects modified to compile with Visual C++ .NET 2003
		: FCR=0 problem fixed. 

10.04 (04-09-2004)
Voice C++	: Fixed problem with Voice OCX not sending events when 
		  receiving a fax. 
		: Solves timing problem in Voice OCX with receiving ERROR 
		  after fax tone is detected (with Dialogic VFX boards).
		: InitModemcapabiliti function name (loading) corrected to 
                  InitModemcapability
FaxC++		: TRM_XXXXXXX termination code descriptions in faxtype.h 
		  were updated.
FaxC++ samples	: Annotation features have been taken out from the samples.
		: Scanning features have been taken out from the samples



10.03 (1-23-2004)

Fax C++		: Fax OCX VB sample was expanded and improved.
Fax C++		: Fixed error in ReturnErrorString method

10.02 (1-7-2043)

Fax C++		: Fixed dialing problem with Brooktrout TR1034 ISDN boards.
Fax C++		: Fixed minor fax header problem with SetFaxImagePage.
Fax C++		: Fixed problem with opening Dialogic VFX41JCT channels.
Fax C++		: Fixed fax manager display problem.


10.01 (12-10-2003)
Voice C++	: Added new method / function: mdm_D_MakeCalISDN / MakeCallISDN.
Fax C++		: Minor fix in the Class 1.0 fax reception.

10.00 (12-01-2003)
FaxC++		: Class1.0 support for V.34 (33.6k) faxing for modems has been added
		: Answering the call with Dialogic board fixed in the 
		  Voice Mail Sample


9.19 (10-14-2003)
FaxC++		: Problem fixed with Brooktrout cards answering the call during send.
		: Problem solved with fax queuing
VoiceC++	: Problem solved with hangup
 
9.18 (08-20-2003)
		: BFT support added to the Fax.OCX 


9.17 (08-06-2003)
		: OnHook problem fixed in the Voice.dll

9.16 (05-24-2003)
		: Hangup is now detected during wait from dtmf with 
		  Brooktrout boards.
		: problem fixed: When opening a channel an incoming call can 
		  block the channel.

9.15 (05-15-2003)
		: The PEX files for the Brooktrout boards are included in the
		  Redist folder

9.14 (05-07-2003)
- Fax C++	: Fixed timeout problem when queueing multiple faxes with 
		  Brooktrout boards
		  Brooktrout firmware files and sample telepf.cfg files has 
		  been added.
		: The OCX controls can be used without a form


9.13 (04-16-2003)
- Fax C++	: Sleep() method added to the Fax.OCX.
- Fax C++	: Added DNIS member to the TSSessionParameters structure.
- Fax C++	: Added GetDNISDigits function to the TCFaxClass class.

9.12 (04-09-2003)
- Fax C++	: Sending and receiving faxes using Brooktrout TR114 
		  NetAccess (BTNA) has been fixed

9.11 (03-11-2003)
- Fax C++	: Fixed problem with receiving fine resolution 
		  faxes with the Gammalink boards.
- Fax C++	: Fixed problem with detecting multiple Dialogic VFX boards.
- Fax OCX	: Added ASP compatibility.
- Fax C++	: The Demo32 sample can be compiled using  Visual C++ 7.0
- Voice C++	: Interactive Voice Sample and Interactive VoiceMail Sample 
		  can be compiled using Visual C++ 7.0
- FaxC++	: Improved the way how FaxC++ sets the no answare/receive mode
		  with Gammalink boards

9.10 (03-11-2003)
- FAX C++ 	: Brooktrout TR1000 support has been added.

9.09 (02-26-2003)
- FAX C++	: Brooktrout 4.3 dlls are installed in the "Bin" folder too
- VOICE C++     : Interactive Delphi Sample added

9.08 (01-09-2003)
- FAX C++	:DTMF digits are now returned in the FAXOBJ.

9.07 (11-22-2002)
- FAX C++	: Fixed issue with setting the maximum baud rate.

9.06 (11-08-2002)
- FAX C++	: Fax.OCX has been modified to support more 
                  than 64 Gammalink channels
- FAX C++	: problem fixed with receiving the StartPage, EndPage with 
                  Gammalink boards.

9.05 (10-07-2002)
- Voice C++	: The WaitForDTMF function/method now will report the received DTMF digits even when not all the
		requested digits have arrived.
- Voice C++	: Minor improvements in the sample applications.

9.04 (09-16-2002)
- Voice C++	: Now the application can set the modem command sent by Voice C++ to the modem to set the 
		voice encoding format used during playback and recording.
- Codec library	: PCM 11 KHZ to PCM 8 KHz conversion added
		: PCM 8 KHZ to PCM 11 KHz conversion added
- Voice C++	: New functions/methods: PlayVoiceExt2, RecordVoiceExt2


9.03 (09-03-2002)
- FaxC++	: Gammalink support has been improved. 
- FAX/Voice C++	: Dialogic SR 5.1.1 SP1 drivers supported.
- Voice C++	: Digital Dialogic boards now can abort the dial command.
 		: Fixed crash in the SCBUS Call monitoring sample.


9.02 (08-07-2002)
- New licensing policy


9.01 (07-26-2002)
- Fax OCX	: Solved problem with receiving event when the form with the 
                  OCX is unloaded/reloded
		: Fixed isssue with the VB FAX.OCX sample for page 
		  length for some faxmachines

9.00 (06-26-2002)

- NEW MSI Support
- New VB sample for SCBUS
- New C++ and VB sample for MSI boards
- New functions : SetHook(), GenericToneSignalDTMF(), 
- GetNextFax methos added to the Fax OCX
- Fixed event receiving for SCBUS in the Voice OCX

---------------------------------------------------------------------------------

8.64 (06-04-2002)
- Voice C++	: Caller ID support has been added for Rockwell, Lucent, 
                  Cirrus Logic, Conexant/HCF chipset modems.
- Voice OCX	: PlayVoiceEx Method added.
- Fax C++	: The FaxC++ internal queue handling has been totally 
		  rewritten, improved.
- FAX OCX	: Queue handling methods added.
- Fax C++	: ANI support for Brooktrout PRI boards added.
- Fax C++	: DEMO 32 sample improved, now the Local ID can be set 
                  for Gammalink and Brooktrout boards


8.63 (05-08-2002)
- Gammalink and Brooktrout CSID retreive problem solved
- Solved problem with Dialogic board with handling unsuccessfull faxes
- Solved minor problem with playing a voice message with Dialogic board
- Solved problem with detecting Dialogic channel when the board is not present
- Port detection fixed in the 4 port version of the voice.dll

8.62 (02-12-2002)
- Added custom tone detection and cadence detection
- minor problem fixes in the Dialogic and US Robotics drivers
- Faxcpp32.dll:Solved timing problem when closing the COM port.
- Added support for Brooktrout drivers version 4.3

8.61 (01-10-2002)
- Added support for Dialogic SR 5.1 driver
- Added answering machine detection
- Voice.dll: new function SetParameters
- Voice.dll: new function GetParameters
- Voice.ocx: new method SetParameters
- Voice.ocx: new method GetParameters
- Voice.ocx: new event AnsweringMachine


8.60 (08-14-01)
-FaxCpp32.DLL: New function: ReturnErrorString
-Fax.OCX: New method: ReturnErrorString
-Voice.DLL: New function: BlindTransferInboundCall
-VoiceOCX.OCX: New method: BlindTransferInboundCall
8.59 (07-24-01)
-FaxCpp32.dll: Solved problem with locked channels with GammaLink boards.
-FaxCpp32.dll: The cd_timeout parameter in the GammaLink queue record now is set to 70 seconds.
8.58 (06-06-01)
-Voice.dll port closing problem solved.
8.57 (05-24-01)
-4 port version
8.56 (05-04-01)
-solved problem with the received fax's resolution
-OCX controls renamed
8.55(03-23-01)
-Solved problem with using MEMDIB
-Solved fax queue synchronization problem.
-Solved problem with missing source files from the Fax OCX CPP sample.
8.54(03-06-01)
-Added CodecOCX.ocx.
-Added VB and Delphi sample for the CodecOCX.
8.53(01-15-01)
-FaxCpp32.dll: Fixed problem with detecting some DM3 Dialogic boards.
-Voice.dll: Improved Brooktrout PRI board support.
-Fax.ocx: Added demo Fax OCX. Now the demo version includes an OCX which supports 1 fax
port and is capabla to send and receive single page faxes only. The demo version now
includes the license file, so the demo OCX can be used for development.
8.52(12-21-00)
-Faxcpp32.dll: Solved problem with retriving the connection time from the FAXOBJ.
-Voice.dll: Added CallerID support for NMS boards.
-Voice.dll: Added three new SCBUS samples.
v8.51(11-14-00)
-Faxcpp32.dll: Solved Class 2 receive problem.
-Faxcpp32.dll: Solved problem with GammLink boards: after receiving a fax there was
an undeleted record in the receive queue.
-Faxcpp32.dll: Solved problem with setting the number of rings to 0 with GammaLink boards.
-Faxcpp32.dll & Voice.dll: Solved problem with setting the number of DNIS digits with
NMS boards when the MFC protocol has been used.
v8.50(11-02-00)
-Voice.dll: SCBus support added for Voice C++
-Voice.dll: Two new samples have been added: SCSendFax and SCReceiveFax
-Voice.dll: Added support for Brooktrout PRI NetAccess boards
-Voice.dll: Voice C++ now reports caller ID and ANI with Dialogic boards
v8.14(11-08-00)
-Fixed problem occurred when faxing with Class 2 modems.
v8.13(10-31-00)
-DNIS digit number now can be set for the MFC protocol (for NMS boards).
v8.12(10-25-00)
-Faxcpp32.dll: Added support for Brooktrout PRI NetAccess boards
v8.11(10-02-2000)
-Sample applications now support the MF R2 (MFC0) NMS protocol.
v8.10(09-26-2000)
-solved problem with detecting modem speeds with some wireless modems.
v8.09(09-11-2000)
-Voice C++ samples ahve been improved.
-Help added to the Voice C++ samples
-Installation was improved.
-Added ISD0 protocol support for every NMS sample.
v8.08(09-05-2000)
-Voiceocx.ocx: New method: TransferInboundCall.
-Improved Interactive VB Voice sample: added call transfer support.
-Voice.ocx:Default values used with the RecordVoice method have been changed.
v8.07(08-29-2000)
-FaxCpp32.dll: Solved problem with receiving multidocument faxes with
some PANASONIC fax machines.
-Faxcpp32.dll: Solved problem with receiving high volume faxes using
Brooktout boards.
-Faxcpp32.dll: Solved EOP resending problem with class 1 modems.

v8.06(08-23-2000)
-Voice.dll - improved fax tone detection using voice modems.
v8.05(08-14-2000)
-FaxCpp32.dll: Fixed problem with faxing using GammaLink SC/x boards.
-FaxCpp32.dll: GammaLink support was improved.
-FaxCpp32.dll: Fixed problem with setting the number of rings to answer a call.
-FaxCpp32.dll: FIxed problem with receiving standard resolution faxes
with Dialogic boards.
-Voice.dll: Improved busy tone and fax answer tone detection with voice modems.

v8.04(07-06-2000)
-Fixed problem with temp file concatenation when using GammaLink boards.
-Added Multiport Faxing sample application (Visual C++ 5.0)

v8.03(06-21-2000)
-Fixed problem with receiving CCITT Group 4 page data real time.
-Fixed temp file generation problem with NMS Boards.
-Now Voice C++ is capable to record voice message while a voice
     message is being played.
-The fax and voice sample applications were improved:
     When opening NMS channels the Telephony protocol and the
     number of DNIS digits can be specified on the Open NMS channel
     dialog box.

v8.02(05-08-2000)
-Added new message: MFX_PAGE_DATA_RECEIVED.
-Added new structure: TSReceivedPageData.
-Solved minor problem with the Fax OCX VB sample.
-New TIFF32.dll.


v8.01(04-20-2000)
-Voice.dll: Added switching support for NMS boards.
-Implemented new Bitmani.dll.

v8.00(03-22-2000)
-Voice.dll: Added DNIS support for Dialogic high density digital boards(using  the Global Call API).
-Voice OCX: Added DNIS support for Dialogic high density digital boards(using  the Global Call API).
-Added support for new Brooktrout board drivers, version 4.11. Both Fax C++ and Voice C++ will
not work with earlier versions of the Brooktrout drivers.
-voice.dll: Brooktrout boards now can detect if a incomming call is fax or voice.
-Added support for TAPI 3.0 under Windows 2000.
-New sample named "TAPIsample" which demonstrates how to use Fax ++ with TAPI 3.

v7.59(02-22-2000)
-Fixed problem with detecting some Dialogic E1 board.

v7.58(02-21-2000)
-VB sample for Fax OCX was rewritten.
-Delphi sample for Fax OCX was improved.
-voice.dll - Minor changes in the Connexant/HCF driver (silence detection fix).

v7.57(01-18-2000)
-FaxCpp32.dll: Solved problem with sending faxes after a fax was
received using Dialogic boards.
-Voice.dll: Solved "No dialtone" problem with Dialogic boards.
-FaxCpp32.dll: Solved problem with aborting faxes using Dialogic boards.
-Voice.dll: Using Brooktrout boards, Voice C++ now detects SIT tones.
-Voice.dll: Solved RING problem with Brooktrout boards.
-Fax.ocx: Added new property: DisplayFaxManager

v7.56(01-12-2000)
-Voice.dll: Added support for Rockwell/Conexant HCF chipset modems.
-Voice.ocx: Added support for Rockwell/Conexant HCF chipset modems.
-Solved problem with the CPP OCX demo and the TAPI OCX demo when they was started without
the faxctrl.lic file.
-Demo32.exe: Solved bad date problem.

v7.55(12-22-99)
-FaxCpp32.dll - Added support for Dialogic DNA 3.2 drivers.
-FaxCpp32.dll - Solved problem with MFX_RING messages with Brooktrout board.
-VoiceOCX - Solved problem with the LocalID property.

v7.54(12-13-99)
-FaxCpp32.dll - NMS driver improved.
-FaxCpp32.dll - Added support for multidocument sending/receiving in
Class 2 and Class 2.0 modes.

v7.53(11-19-99)
-FaxCpp32.dll- Fixed problem with returning channel numbers with NMS boards.
-Voice.dll- Fixed problem with returning channel numbers with NMS boards.
-TAPI - Fixed problems with sending and receiving faxes with Lucent, Cirrus Logic
chipset modems using TAPI.
v7.52(10-15-99)
-Voice.dll: Added support for NMS QX series boards.
-Voiceocx.ocx: Modified FaxReceived event: new parameter RemoteID.
-Voice.dll, Voice.ocx: Added DID and DNIS routing support for Brooktrout
boards.
-Fax Manager: Added "Hide Fax manager" button.
-FaxCpp32.dll: Solved problem with sending MMR faxes when the receiver cannot
receive MMR.

v7.51(09-30-99)
-Voice.dll: Solved problem with recording voice message using handsets.
-Voice.dll: Solved some syncronization problems.
-Faxcpp32.dll: Solved problem with using IMT_FILE_DIRECT with color faxes.

v7.50(08-20-99)
-FaxMng32.dll: Solved problem with accessing the fax queue bu multiple
ports on the same time.
-Voice.dll: Added support for Lucent and Cirrus Logic chipset modems.
-FaxCpp32.dll:  Some minor problems solved.
-FaxCpp32.dll: Color Fax capability improved.

v7.20(08-09-99)
-Solved problem with sending the same fax page several times.

v7.11(07-27-99)
-Voice.dll: The Rockwell driver was rewritten, improved.
-The Voice C++ sample applications were improved.

v7.10(07-15-99)
-Voice.dll: The US Robotics driver was rewritten, improved.
-Voice.dll: New function: mdm_SetSilenceDetectionParams
-Voiceocx.ocx: New method: SetSilenceDetectionParms
-Voiceocx.ocx: New event: NoAnswer
-Voiceocx.ocx: New event: CallingTone
-Voiceocx.ocx: Improved event handling with NMS, Dialogic, Brooktrout boards.
-Voice.dll: Improved event handling with NMS, Dialogic, Brooktrout boards.
-Voiceocx.ocx: Dialogic and NMS boards and USR modems now reports fax calling
tones (CNG) after the call was answered.
-Fax.ocx: New event: TerminateExt. Reports the received subaddress also.

v7.00(06-22-99)
-The VocDemo Voice C++ sample was completely replaced and rewritten.
New samples were added.
-The VoiceOCX Visual Basic sample application was rewritten. New VB samples
were added.
-Minor changes in the NMS voice driver.
-Solved faxing problem with Dialogic boards using Voice C++.
-Solved ConnectPort problem with Brooktrout boards.
-Demo edition manuals added to the demo version of Fax/Voice C++.
-New NMS.TXT file which illustrates how to install NMS boards.
-Fixed problem with Brooktrout T1 and DID boards.
-Fixed problem with Dialogic boards when sending multiple pages.

v6.84
-FaxCpp32.dll: With Dialogic boards now a voice message can be played while
FaxCpp waits for DTMF tones before receiving a fax.
-FaxCpp32.dll: Solved problem with the ConnectTime member from the
TSSessionParameters structure when using Brooktrout boards.
-TAPI.EXE and TAPICOMM.EXE samples:  the fax objects now are created
before dialing.
v6.83
-FaxCpp32.dll: Solved problem with receiving MMR faxes from Toshiba
fax machines.
-Added support for Brooktrout P16V boards.
v6.82
-Faxcpp32.dll: Solved problem with Brother MFC 6550MC fax machines.
v6.81
-Voice.dll : Fixed problem with detecting fax answer tones.
-faxcpp32.dll : Fixed problem with Gammalink boards, when a dial number
prefix is specified.
-Voice.ocx : Fixed problem with detecting fax answer tones.

v6.80
-Fax.ocx  : Added support for NMS boards.
-Voice.dll: Added support for NMS boards.
-voice.ocx: Added support for NMS boards.
-The TAPI.EXE and TAPICOMM.EXE samples were improved.
-Fax.ocx: Solved problem with with ENDSEND and ENDRECEIVE event.
-Voice.dll: Solved problem receiving DTMF tones with USRobotics modems.

v6.75
-Fax.ocx: Solved problem with Creative modems working with TAPI.
v6.74
-Fax.ocx: Solved problem with with ENDSEND event.
-Fax.ocx: Added TAPI support.
v6.73
-Demo32.exe: fixed problem with sending MMR faxes
v6.72
-FaxCpp32.dll: Failed dial attempts now are handled correctly with Brooktrout
boards.

v6.71
-FaxCpp32.dll: Added support for Natural Micro Systems boards.

v6.65
-Solved problem with receiving faxes from some Samsung fax machines.
These fax machines did set bit 34 in the T.30 DCS frame to 1.
If the bit 34 is set to 1, according to the T.30 specification from 1993,
the fax image will be sent with 1216 pixel width. The T.30 specification
from 1997 describes this bit as a reserved bit, and always should be 0.
These fax machines did set bit 34 to 1, but the sent image was 1728 pixel
width not 1216.
-Voice.ocx:New events: StartPage, EndPage

v6.64
-Added multidocument sending with Class 2 modems.
-Occasional send failure with GammaLink boards solved.

v6.63
-Solved problem with filename generation for received faxes with
GammaLink boards.

v6.62
-Added support for Dialogic DNA 3R drivers.
-Faxcpp32.dll:New functions: IsSubaddressEnabled, EnableSubaddress. These
function enable/disable the # sign checkin in the dial string. If subaddressing
is enabled and the dial string contains a # sign, the string on the rigth of the
# sign is interpreted and sent as subaddress. By default the subaddressing
is disabled.
-Fixed problem with sending chained faxes with ECM.

v6.61
-Voice.dll: Improved call signal detection with Bicom boards
-Voice.dll: Solved problem with Dialogic D/41H boards
v6.60
-Voice.dll: Added support for Brooktrout boards.
-Voice.ocx: Added support for Brooktrout boards.
-FaxCpp.dll: Added G5 Messaging.
v6.50
-FaxCpp32.dll:Solved problem with sending ECM faxes.
-Fax.Ocx: New property: HeaderFontFace
-Fax.Ocx: New property: HeaderFontSize
-Fax.Ocx: New property: GammaCfgNeeded
-Fax.Ocx: New method  : DisablePort
-Fax.Ocx: New method  : IsPortDisabled
-Fax.Ocx: New method  : GetLastGammaStatus
-New Codec.dll to convert Rockwell WAV files into Windows WAV files.
-Voice.dll- New function: mdm_TransferInboundCall
-Solved problem with opening ports with ConnectPortExt when
the port is already used.

v6.01
-Solved problem with sending subaddress with Brooktrout TR114 cards.
-Solved problem with sending faxes more than 1728 pixels wide.

v6.00
-FaxCpp32.dll: Added support for Commetrex boards.
-Fax.ocx: Added support for Commetrex boards.
-Voice.dll: Added support for Bicom boards.
-VoiceOcx.ocx: Added support for Bicom boards.
-FaxCpp32.dll: Solved problem with sending MFX_IDLE event with GammaLink cards
-New sample code to illustrate how to use Voice C++ with TAPI (for more
information please read the readme.txt file located in the Tapicomm directory)

v5.28
-FaxCpp:Solved problem with receiving IDLE event from GammaLink cards.
-Voice.dll:Improved tone detection
-FaxCpp:Solved problem with Brooktrout cards reading the name of the
digital config file.
v5.27
-FaxCpp32.dll: New function DisablePort.
-FaxCpp32.dll: The Status member of the TSPortStatus structure has
a new bit value CST_DISABLED
-FaxCpp32.dll: The TSHeaderContext structure has a new member: Height
-FaxCpp32.dll: The TSSessionParameters structure has a new member: FaxPort
-FaxMng32.dll: New function ShowDialogWindow
-Fax.ocx: Solved problem with receiving DTMF codes with GammaLink cards
-FaxCpp32.dll: Class1 modems, Brooktrout and GammaLink cards now can send
and receive subaddress and password(the password only with Class1 modems)
fields in the T.30 fax header.
-FaxCpp32.dll: The TSFaxParam structure now has a new member: Password
-Fax.ocx: New property: HeaderHeight
-Fax.ocx: Solved problem with receiving duplicate FaxIDs.
-FaxCpp32.dll is now compatible with the GammaLink driver version 3.0

v5.26
-Voice.dll: For mdm_WaitForDTMF function now can be set a timeout value.
-Faxcpp32.dll: Dialing problem with Brooktrout TR114 and the
 4.0 Brooktrout driver was fixed.
-Memory leek when opening and closing COM ports was removed.

v5.25
-Voice.dll: Added voice support for Dialogic cards.

v5.21
-FaxCpp now supports the Brooktrout API 4.0 for ISA and PCI Brooktrout
cards under Windows NT 4.0 and Windows 95.
You should install the new Brooktrout drivers located in the BFAX_NT
or BFAX_95 directories. Please read the Brooktrout.txt file for
information regarding how to install these drivers.

v5.20
-Voice.dll: now supports US Robotics Sportser modems.
-FaxCpp32.dll: now supports the Bicom Sonic C4 cards.(beta prerelease)
-Fax C++ Demo: Improved phonebook import from text files.
-Fax OCX: The OCX now supports Bicom Sonic C4 and Dialogic
cards.(beta prerelease).
-FAX OCX Visual Basic Sample: supports Bicom Sonic C4 and Dialogic
cards.
-FaxCpp32.dll: When receiving faxes with Brooktrout or GammaLink
cards the MFX_RING event is sent for each ring.
-FaxCpp32.dll: Now the fax manager sends the MFX_IDRECEIVED event when
the remote Id is available.
-FaxOcx: Now the ocx sends the RemoteID event when the remote Id is
available.
-FaxCpp32.dll: Fixed problem with appending header to a Reverse Bit
Order TIFF image.
-FaxCpp32.dll: Improved Cover Page functionality.


v5.12
- New termination code TRM_HUMANVOICE to detect the human answer.
This functionality works only with modems capable to detect if human
answer occured.(ie.US Robotics Courier V.Everything ). The X6 command
must be added to the modem's setup string.
- Fax OCX: Remote ID problem solved for Brooktrout cards.
- Fax OCX: Solved problem with WD_NOCHANGE prameter.

v5.11
- Fixed problem with GammaLink emptying queues.
- Fixed the exiting problem with Fax OCX.

v5.10
- New: Added Voice OCX and a Visual Basic 5.0 sample application to
demonstrate the using of Voice OCX.
- Fixed some problems with annotation.
- FaxCpp Demo: New file format: Bicom/NMS.

Important:
The Demo application for Voice OCX is written in Visual Basic 5.0 and needs
the following files to be in your system directory:
    MSVBVM50.DLL
    COMCTL32.OCX
    COMDLG32.OCX
    COMCTL32.DLL
    COMDLG32.DLL
These files are shipped with VB 5.0. If you don't have Visual Basic 5.0
you can download these files from ftp://blackice.sendfax.com.

When you are using the Voice OCX demo program in autoanswer mode and you
are selecting 2 ( retrieve a fax document ) the valid document codes
are 0, 1, 2.

v5.02
- Fixed the resolution problem of receiving faxes with a GammaLink card.
- FEV_RING events are sent by FaxCpp even in case of manual answer
- when sending page-length isn't set to UNLIMITED automatically any more

v5.01
- The Faxcpp32.dll loads the functions of the BrookTrout, GammaLink and
  Dialogic API dinamically. This means that you have distribute those dlls
  only which correspond to the fax card(s) used by your application.
  These are:
      For Gammalink:   NTGDK.DLL    (NT version only)

      For Brooktrout:  BTDLLS.DLL   (the BTDLLS95 and BTDLLSNT contain
                                     the proper versions for Windows 95 and
                                     NT respectively)

      For Dialogic:
           Windows 95: DLGVXD32.DLL  (can be found in the
                       LIBDXXMT.DLL   Dialogic\Win95 directory)
                       LIBFAXMT.DLL
                       LIBSRLMT.DLL
                   NT: LIBDXXMT.DLL  (can be found in the
                       LIBFAXMT.DLL   Dialogic\NT directory)
                       LIBSRLMT.DLL

- Now FaxCpp supports GammaLink Development Kit 2.1
- FaxCpp Demo: Fixed bug with sending color images.
- FaxCpp Demo: Fixed bug with saving fax groups.

v 5.00
- Add Voice functionality (see the Voice.txt file) and VocDemo.exe
  demo program.
- Add Dialogic VFX boards support.
- Fix problem with faxing more then 7000 faxes.
- The demo sends the annotation with the page without burning it into the page
- The demo resends any faxes from the Send, Receive, Outbox, Poll Output logs.
- New Delphi sample program for the Fax C++ OCX.
- New GammaLink fax file format in the Fax C++ Demo.

v 4.30
- ConnectTime is now 0 after an unsuccesful connection attempt
- modems described in faxcpp2.ini are now accessable from the Fax OCX
- Fax OCX may open com ports greater than COM9:
- Bit order is determined correctly for received images with class 2 fax modems
  which report the incoming page line number incorrecly (e.g. Rockwell chipset modems)
- TAPI, it is possible now to 'attach' FaxC++ to an already opened COM port.
- Fax C++ demo is integrated with Annotation SDK.

v 4.22
- Station ID is now correctly chopped of at 20 charachters length
- FaxC++ does not generate a General Protection Fault when initializing
  twice (e.g. calling SetupFaxDriver(NULL);...EndOfFaxDriver(TRUE); twice)
- Fax page header parsing & automatic alignment
- the demo program displays the images sent to BlackIce printer driver
  under Windows 95 on a FAX port

v 4.21
- bugfix: SetFaxPage returned -80 when called from service
- DTMF & DID info available for GammaLink cards
- DTMF & DID info available through the OCX control
- OCX changes: - StartPage & EndPage event parameter list changed
                 to ByVal szPort as String, ByVal lPageNumber as Long
               - GetPortStatus now returns correct value
               - OpenPort reports if no .pex file was found while
                 trying to open a Brooktrout channel.
- faxmng.dll message changes: MFX_STARTPAGE & MFX_ENDPAGE now sends
  port object pointer as lParam

v 4.20
- The demo program intercepts the output of the BlackIce printer driver under Win95 & NT
- Some OCX custom control events changed in parameters:
  EndSend & EndReceive does not have the ConnectTime parameter
  Terminate gives the processed page number and the connection time parameter
- Terminate is generated every time at end of send or receive
- dwConnectTime member of TSSessionParamteres always returns the right value
- local CSID is allways set correctly for GammaLink channels
- sent & received fax records are allways deleted from the GFAX.$QU GammaLink queue file

Following are the new features or bug fixes we have made for the Fax C++ 4.XX series:
v 4.19X
- Fax OCX custom control is added only for the 32-bit version.
- The SetDialMode function has changed. Now it has 2 parameteres.
- Fix problem with fax header used with MEM_DIRECT.
- Fix problem in Pulse dial option.
- Fix GetFaxImagePage with DCX file format.
- Added Visual Basic 4.0 sample code for OCX, and located  at "sample\ocx\basic".
- Added Visual C++ 4.XX sample code for OCX, and located at "sample\ocx\cpp".
- Added Brooktrout support for Trufax 200. Ver:4.191 01-13-1997
- Added Brooktrout support for Win95. Ver:4.191 01-13-1997
- Fix memory leaks in Fax Driver. Ver:4.191 01-13-1997
- Fix fax header generation for Group 2d faxes. Ver:4.192 01-30-1997
- Add auto detection of Group 3 2D and Group 4. Ver:4.193 02-04-1997
- Add fax cover page for demo application. Ver:4.193 02-04-1997

v 4.18
- For Brooktrout : GetDID function to get DID digits in a character array.
- C++ function calls 'SetNextFax' and 'GetNextFax' made public to C.
- Color faxobject will automatically send monochrome image when the remote
  end doesn't support colorfaxing.

v 4.17
- Bug fixed for Brooktrout: the status output at the end of the document
  wasn't handled correctly.
- When sending with Brooktrout, the page counter in the Session structure is
  incremented and the FEV_ENDPAGE event is sent only when the faxcard
  finished sending the page.

v 4.16;
- The debug file SetLogDir() function is fixed.
- GammaLink support is added for 32-bit version only.
- Changed the name of support DLL's for the 32-bit version only.

v 4.15;
- Fixed bug in Class 2 regarding maximum and minimum page size.
- Polling.

v 4.14;
- The fax banner generation is rewritten to increase performance, which will provide a more efficient
  way for generating banners.
- Fixed bugs in Class 1.
- Users can set the minimum Fax Transmission Speed.
- The driver will handle the TIFF file in native TIFF form with reverse fill order without conversation.

v 4.13;
- Brooktrout Support is added for 32-bit only.
- PNG File Format added.
- Twain works with 32 bit mode.

v 4.12;
- File left open with GetFaxImagePage( )   IMT_File_Direct.
- FEV_STARTRECEIVE added.
- Class 2.0 busy.
- Timer is fixed for sending empty page.
- ECM send.

v 4.11;
- Remote Station ID.
- ECM receive.
- Color Fax T.30 added
- JPEG added.

v 4.10;
- Caller ID.
- Polling.
- Group 4 Faxing.
- Subaddressing.
- Phone Book.
- Send & Receive Queue.
- Remote Fax Retrieval with Password Protection.
- Built in Fax Protocol Analyzer.

//-----------------------------------------------------------------
The new debugging tool FaxSpy is a command and fax
protocol analyzer. The output file name F_COMMXX.LOG
where the XX stand for the fax port number. This file
can be e-mailed to us for analysis.
