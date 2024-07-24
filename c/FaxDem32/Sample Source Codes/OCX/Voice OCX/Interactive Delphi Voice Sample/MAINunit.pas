unit MAINunit;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, OleCtrls, VOICEOCXLib_TLB, IniFiles, Grids;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuWindow: TMenuItem;
    mnuHelp: TMenuItem;
    mnuFileExit: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    mnuHelpAbout: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    StatusBar: TStatusBar;
    ActionList1: TActionList;
    FileExit1: TAction;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowArrangeAll1: TWindowArrange;
    WindowMinimizeAll1: TWindowMinimizeAll;
    HelpAbout1: TAction;
    WindowTileVertical1: TWindowTileVertical;
    WindowTileItem2: TMenuItem;
    ImageList1: TImageList;
    mnuVoiceFax: TMenuItem;
    mnuVoiceFaxOpenPort: TMenuItem;
    mnuCOMPort: TMenuItem;
    mnuDialogicChanel: TMenuItem;
    mnuBrooktroutChanel: TMenuItem;
    mnuNMSChanel: TMenuItem;
    VoiceComPort: TAction;
    VoiceDialogicChanel: TAction;
    VoiceBrooktroutChanel: TAction;
    VoiceNMSChanel: TAction;
    N1: TMenuItem;
    Help1: TMenuItem;
    HelpHelp1: TAction;
    VoiceOCX: TVoiceOCX;
    procedure FileExit1Execute(Sender: TObject);
    procedure VoiceComPortExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VoiceDialogicChanelExecute(Sender: TObject);
    procedure VoiceBrooktroutChanelExecute(Sender: TObject);
    procedure VoiceNMSChanelExecute(Sender: TObject);
    procedure VoiceOCXAnswer(Sender: TObject; ModemID: Integer);
    procedure VoiceOCXAnswerTone(Sender: TObject; ModemID: Integer);
    procedure VoiceOCXCallingTone(Sender: TObject; ModemID: Integer);
    procedure VoiceOCXDTMFReceived(Sender: TObject; ModemID: Integer);
    procedure VoiceOCXEndReceive(Sender: TObject; ModemID: Integer);
    procedure VoiceOCXEndSend(Sender: TObject; ModemID: Integer);
    procedure VoiceOCXFaxReceived(Sender: TObject; ModemID, FaxID: Integer;
      const RemoteID: WideString);
    procedure VoiceOCXFaxTerminated(Sender: TObject; ModemID,
      TStatus: Integer);
    procedure VoiceOCXHangUp(Sender: TObject; ModemID: Integer);
    procedure VoiceOCXModemError(Sender: TObject; ModemID: Integer);
    procedure VoiceOCXModemOK(Sender: TObject; ModemID: Integer);
    procedure VoiceOCXHook(Sender: TObject; ModemID: Integer);
    procedure VoiceOCXPortOpen(Sender: TObject; ModemID: Integer);
    procedure VoiceOCXRing(Sender: TObject; ModemID: Integer);
    procedure VoiceOCXVoicePlayFinished(Sender: TObject; ModemID: Integer);
    procedure VoiceOCXVoicePlayStarted(Sender: TObject; ModemID: Integer);
    procedure VoiceOCXVoiceRecordFinished(Sender: TObject;
      ModemID: Integer);
    procedure VoiceOCXVoiceRecordStarted(Sender: TObject;
      ModemID: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HelpHelp1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
  private
    { Private declarations }
    procedure DoCloseModem;
    procedure DoSelectModem;
    procedure CreateMDIChild(nIndex: Integer);
  public
    szVocExts:array [1..10] of String;
    fModemID: array [1..256, 0..1] of LongInt;
    szIniFile: TIniFile;
    szVoiceCaps:array [1..5] of String;
    szExePath: String;
    szGreetingMessage: String;
    function AddNewModem(ModemID: LongInt):Integer;
    procedure DeleteModem(ModemID: Longint);
    procedure ChangeExt(var pszTemp: WideString; pszExt: String);
    function CheckIfValidModemID(ModemID: LongInt; bExtraCheck: Boolean):Integer;
    procedure SetVocExtension(ModemID: LongInt; var pszFile: WideString);
    function FindTagToModemID(ModemID: LongInt):Integer;
    { Public declarations }
  end;



Const MAX_BROOK_CHANNELS = 96;

Const cnsNoneAttached = -1;
Const cnsSelectPort = 0;
Const cnsAutoAnswer = 1;
Const cnsSelectDlg = 2;
Const cnsSelectBT = 3;
Const cnsSelectNMS = 4;

// supported modem types
Const cnsRockwell = 0;
Const cnsUSRobotics = 1;
Const cnsDialogic = 2;
Const cnsBrooktrout = 4;
Const cnsNMS = 5;
Const cnsLucent = 6;
Const cnsCirrus = 7;
Const cnsHCF = 8;

// voice file format
Const cnsVOX = False;
Const cnsWAV = True;

// voice line
Const MDM_LINE = 0;
Const MDM_HANDSET = 1;
Const MDM_SPEAKER = 2;
Const MDM_MICROPHONE = 3;

// voice file data format
Const MDF_ADPCM = 0;
Const MDF_PCM = 1;
Const MDF_MULAW = 2;
Const MDF_ALAW = 3;
Const MDF_OKI = 4;

// voice file sampling rate
Const MSR_6KHZ = 0;
Const MSR_7200 = 1;
Const MSR_8KHZ = 2;
Const MSR_11KHZ = 3;

// image resolution
Const RES_NOCHANGE = 0;
Const RES_98LPI = 1;
Const RES_196LPI = 2;

// image width
Const PWD_NOCHANGE = 0;
Const PWD_1728 = 1;
Const PWD_2048 = 2;
Const PWD_2432 = 3;
Const PWD_1216 = 4;
Const PWD_864 = 5;

// image length
Const PLN_NOCHANGE = 0;
Const PLN_A4 = 1;
Const PLN_B4 = 2;
Const PLN_UNLIMITED = 3;

// compression method
Const DCF_NOCHANGE = 0;
Const DCF_1DMH = 1;
Const DCF_2DMR = 2;
Const DCF_UNCOMPRESSED = 3;
Const DCF_2DMMR = 4;

// binary file transfer
Const BFT_NOCHANGE = 0;
Const BFT_DISABLE = 1;
Const BFT_ENABLE = 2;

// bit order
Const BTO_FIRST_LSB = 0;
Const BTO_LAST_LSB = 1;
Const BTO_BOTH = 2;

// ECM
Const ECM_NOCHANGE = 0;
Const ECM_DISABLE = 1;
Const ECM_ENABLE = 2;

// color fax
Const CFAX_NOCHANGE = 0;
Const CFAX_DISABLE = 1;
Const CFAX_ENABLE = 2;

// color type
Const CFAX_TRUECOLOR = 0;
Const CFAX_GRAYSCALE = 1;

Const IMT_NOTHING = 0;
Const IMT_MEM_DIRECT = 1;
Const IMT_MEM_BITMAP = 2;
Const IMT_MEM_DIB = 3;
Const IMT_MEM_END = 4;
Const IMT_FILE_DIRECT = 5;
Const IMT_FILE_BMP = 6;
Const IMT_FILE_PCX = 7;
Const IMT_FILE_DCX = 8;
Const IMT_FILE_GIF = 9;
Const IMT_FILE_TGA = 10;
Const IMT_FILE_TIFF_NOCOMP = 11;
Const IMT_FILE_TIFF_PACKBITS = 12;
Const IMT_FILE_TIFF_LZW = 13;
Const IMT_FILE_TIFF_LZDIFF = 14;
Const IMT_FILE_TIFF_G31DNOEOL = 15;
Const IMT_FILE_TIFF_G31D = 16;
Const IMT_FILE_TIFF_G31D_REV = 17;
Const IMT_FILE_TIFF_G32D = 18;
Const IMT_FILE_TIFF_G4 = 19;
Const IMT_FILE_CLS = 20;
Const IMT_FILE_JPEG = 21;
Const IMT_FILE_END = 22;
Const IMT_BFTOBJ = 23;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

uses ChildWinUnit, SELECTPORTunit, HELPunit, DIALOGICOPENunit,
  OPENBROOKunit, OPENNMSunit, About;

function AppPath(s:String):String;
var i:Integer;
begin
for i:=Length(s) downto 1 do
  begin
  if s[i]<>'\' then
    begin
    Delete(s,i,1);
    end
    else
    begin
    AppPath:=s;
    Exit;
    end;
  end;
end;


function TfrmMain.AddNewModem(ModemID: LongInt):Integer;
var i, tmp: Integer;
begin
tmp:=280;
for i:= 1 to 256 do
  begin
  if fModemID[i,0]=0 then
    begin
    fModemID[i,0]:=ModemID;
    fModemID[i,1]:=cnsNoneAttached;
    tmp:=i;
    break;
    end;
  end;
if tmp<257 then
  begin
  AddNewModem:=tmp;
  end
  else
  begin
  AddNewModem:=0;
  end;
end;

procedure TfrmMain.DeleteModem(ModemID: Longint);
var i: Integer;
begin
for i:=1 To 255 do
  begin
  if fModemID[i,0]=ModemID then
    begin
    fModemID[i,0]:=0;
    fModemID[i,0]:=cnsNoneAttached;
    end;
  end;
end;


procedure TfrmMain.ChangeExt(var pszTemp: WideString; pszExt: String);
begin
Delete(pszTemp,Length(pszTemp)-2,3);
pszTemp:=pszTemp+pszExt;
end;


function TfrmMain.CheckIfValidModemID(ModemID: LongInt; bExtraCheck: Boolean):Integer;
var i: Integer;
    tmp: Integer;
begin
tmp:=280;
for i:=1 to 256 do
  begin
  if fModemID[i,0]=ModemID then
    begin
    tmp:=i;
    break;
    end
  end;
if (tmp>0) then
  begin
  if bExtraCheck Then
    begin
    if fModemID[tmp,1]<>cnsNoneAttached then
      tmp:=0;
    end;
  end;
CheckIfValidModemID:=tmp;
end;


procedure TfrmMain.SetVocExtension(ModemID: LongInt; var pszFile: WideString);
var nIndex: Integer;
    s: String;
begin
nIndex:=VoiceOCX.GetModemType(ModemID)+1;
s:=pszFile;
Delete(s,1,Length(s)-4);
if s=szVocExts[nIndex] then
  begin
  ChangeExt(pszFile, szVocExts[nIndex]);
  end
  else
  begin
  pszFile:=pszFile+szVocExts[nIndex];
  end;
end;



function TfrmMain.FindTagToModemID(ModemID: LongInt):Integer;
var Index: Integer;
    tmp: Integer;
begin
tmp:=280;
if ModemID<>0 then
  begin
  for Index:=1 to 256 do
    begin
    if fModemID[Index,0]=ModemID then
      begin
      tmp:=Index;
      end;
    end;
  if tmp<=256 then
    begin
    FindTagToModemID:=tmp;
    end
    else
    begin
    FindTagToModemID:=0;
    end;
  end
  else
  begin
  FindTagToModemID:=0;
  end;
end;

procedure TfrmMain.DoCloseModem;
begin
MessageDlg('DoCloseModem',mtInformation,[mbOK],0);
end;

procedure TfrmMain.DoSelectModem;
var nIndex: Integer;
    ModemID: LongInt;
begin
// choose port
if frmSelectPort.Showmodal=mrOK then
  begin
  ModemID:=frmSelectPort.GetSelectedPort;
  nIndex:=FindTagToModemID(ModemID);
  if nIndex>0 then
    begin
    // user selected a communication port
    CreateMDIChild(nIndex);
    if frmSelectPort.LogEnabled=true Then
      begin
      VoiceOCX.EnableLog(ModemID,true);
      end;
    end;
  end;
end;


procedure TfrmMain.CreateMDIChild(nIndex: Integer);
var Child: TfrmChild;
begin
  { create a new MDI child window }
Child:=TfrmChild.Create(Application);
Child.Caption:='Autoanswer on port: '+frmMain.VoiceOCX.GetPortName(frmSelectPort.GetSelectedPort);
//Child.Caption:=Name;
Child.Width:=874;
Child.Height:=494;
fModemID[nIndex,1]:=cnsAutoAnswer;
Child.SetModemID(fModemID[nIndex, 0]);
VoiceOCX.WaitForRings(fModemID[nIndex, 0], cnsRings);
Child.nProgressStatus:=0;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var nIndex: Integer;
    nOK: String;
begin
//OnCreate
for nIndex:=1 To 255 do
  begin
  fModemID[nIndex,0]:=0;
  fModemID[nIndex,1]:=cnsNoneAttached;
  end;

szVoiceCaps[1]:='Data';
szVoiceCaps[2]:='Class1';
szVoiceCaps[3]:='Class2';
szVoiceCaps[4]:='Voice';
szVoiceCaps[5]:='VoiceView';

szVocExts[1]:='.VOC';
szVocExts[2]:='.WAV';
szVocExts[3]:='.WAV';
szVocExts[4]:='.WAV';
szVocExts[5]:='.WAV';
szVocExts[6]:='.WAV';
szVocExts[7]:='.WAV';
szVocExts[8]:='.WAV';
szVocExts[9]:='.WAV';

szExePath:=AppPath(Application.ExeName);
szIniFile:=TIniFile.Create(szExePath+'VOCXDEMO.INI');

//szGreetingMessage;
nOK:=szIniFile.ReadString('VOICE', 'Greeting message', '');
VoiceOCX.SetLogDir(szExePath);
//szConfigFile:='BTCALL.CFG'
end;


procedure TfrmMain.FileExit1Execute(Sender: TObject);
begin
Close;
end;

procedure TfrmMain.VoiceComPortExecute(Sender: TObject);
begin
DoSelectModem;
end;


procedure TfrmMain.VoiceDialogicChanelExecute(Sender: TObject);
var nIndex: Integer;
    ModemID: LongInt;
begin
//  choose port
if frmDialogicOpen.Showmodal=mrOK then
  begin
  ModemID:=frmDialogicOpen.GetSelectedChannel;
  nIndex:=FindTagToModemID(ModemID);
  if nIndex>0 then
    begin
    // user selected a communication port
    CreateMDIChild(nIndex);
    if frmDialogicOpen.LogEnabled=true then
      begin
      VoiceOCX.EnableLog(ModemID, true);
      end;
    end;
  end;
end;

procedure TfrmMain.VoiceBrooktroutChanelExecute(Sender: TObject);
var nIndex: Integer;
    ModemID: LongInt;
begin
//  choose port
if frmOpenBrook.Showmodal=mrOK then
  begin
  ModemID:=frmOpenBrook.GetSelectedChannel;
  nIndex:=FindTagToModemID(ModemID);
  if nIndex>0 then
    begin
    // user selected a communication port
    CreateMDIChild(nIndex);
    if frmOpenBrook.LogEnabled=true then
      begin
      VoiceOCX.EnableLog(ModemID, true);
      end;
    end;
  end;
end;


procedure TfrmMain.VoiceNMSChanelExecute(Sender: TObject);
var nIndex: Integer;
    ModemID: LongInt;
begin
//  choose port
if frmOpenNMS.Showmodal=mrOK then
  begin
  ModemID:=frmOpenNMS.GetSelectedChannel;
  nIndex:=FindTagToModemID(ModemID);
  if nIndex>0 then
    begin
    // user selected a communication port
    CreateMDIChild(nIndex);
    if frmOpenNMS.LogEnabled=true then
      begin
      VoiceOCX.EnableLog(ModemID, true);
      end;
    end;
  end;
end;

procedure TfrmMain.VoiceOCXAnswer(Sender: TObject; ModemID: Integer);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if (IndexTag<>-1)and(fModemID[IndexTag,1]=cnsAutoAnswer) then
  begin
  (ActiveMDIChild as TfrmChild).VoiceOCX_Answer;
  end;
end;

procedure TfrmMain.VoiceOCXAnswerTone(Sender: TObject; ModemID: Integer);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if (IndexTag<>-1)and(fModemID[IndexTag,1]=cnsAutoAnswer) then
  begin
  (ActiveMDIChild as TfrmChild).VoiceOCX_AnswerTone;
  end;
end;

procedure TfrmMain.VoiceOCXCallingTone(Sender: TObject; ModemID: Integer);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if (IndexTag<>-1)and(fModemID[IndexTag,1]=cnsAutoAnswer) then
  begin
  (ActiveMDIChild as TfrmChild).VoiceOCX_CallingTone;
  end;
end;

procedure TfrmMain.VoiceOCXDTMFReceived(Sender: TObject; ModemID: Integer);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if (IndexTag<>-1)and(fModemID[IndexTag,1]=cnsAutoAnswer) then
  begin
  (ActiveMDIChild as TfrmChild).VoiceOCX_DTMFReceived;
  end;
end;

procedure TfrmMain.VoiceOCXEndReceive(Sender: TObject; ModemID: Integer);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if (IndexTag<>-1)and(fModemID[IndexTag,1]=cnsAutoAnswer) then
  begin
  (ActiveMDIChild as TfrmChild).VoiceOCX_EndReceive;
  end;
end;

procedure TfrmMain.VoiceOCXEndSend(Sender: TObject; ModemID: Integer);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if (IndexTag<>-1)and(fModemID[IndexTag,1]=cnsAutoAnswer) then
  begin
  (ActiveMDIChild as TfrmChild).VoiceOCX_EndSend;
  end;
end;

procedure TfrmMain.VoiceOCXFaxReceived(Sender: TObject; ModemID,
  FaxID: Integer; const RemoteID: WideString);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if (IndexTag<>-1)and(fModemID[IndexTag,1]=cnsAutoAnswer) then
  begin
  (ActiveMDIChild as TfrmChild).VoiceOCX_FaxReceived(FaxID, RemoteID);
  end;
end;

procedure TfrmMain.VoiceOCXFaxTerminated(Sender: TObject; ModemID,
  TStatus: Integer);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if (IndexTag<>-1)and(fModemID[IndexTag,1]=cnsAutoAnswer) then
  begin
  (ActiveMDIChild as TfrmChild).VoiceOCX_FaxTerminated(TStatus);
  end;
end;

procedure TfrmMain.VoiceOCXHangUp(Sender: TObject; ModemID: Integer);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if (IndexTag<>-1)and(fModemID[IndexTag,1]=cnsAutoAnswer) then
  begin
  (ActiveMDIChild as TfrmChild).VoiceOCX_HangUp
  end;
end;



procedure TfrmMain.VoiceOCXModemError(Sender: TObject; ModemID: Integer);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if IndexTag<>-1 then
  begin
  case fModemID[IndexTag, 1] of
    cnsNoneAttached: MessageDlg('Modem OK received on port: '+VoiceOCX.GetPortName(ModemID),
                                mtInformation, [mbOK], 0);
    // select port
    cnsSelectPort: frmSelectPort.VoiceOCX_ModemError;
    // answerphone
    cnsAutoAnswer: (ActiveMDIChild as TfrmChild).VoiceOCX_ModemError;
    cnsSelectDlg: frmDialogicOpen.VoiceOCX_ModemError;
    cnsSelectBT: frmOpenBrook.VoiceOCX_ModemError;
    cnsSelectNMS: frmDialogicOpen.VoiceOCX_ModemError;
    end;
  end;
end;

procedure TfrmMain.VoiceOCXModemOK(Sender: TObject; ModemID: Integer);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if IndexTag<>-1 then
  begin
  case fModemID[IndexTag, 1] of
    // select port
    cnsSelectPort: frmSelectPort.VoiceOCX_ModemOK;
    // answerphone
    cnsAutoAnswer: (ActiveMDIChild as TfrmChild).VoiceOCX_ModemOK;
    end;
  end;
end;

procedure TfrmMain.VoiceOCXHook(Sender: TObject; ModemID: Integer);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if (IndexTag<>-1)and(fModemID[IndexTag,1]=cnsAutoAnswer) then
  begin
  (ActiveMDIChild as TfrmChild).VoiceOCX_OnHook;
  end;
end;

procedure TfrmMain.VoiceOCXPortOpen(Sender: TObject; ModemID: Integer);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if IndexTag<>-1 then
  begin
  case fModemID[IndexTag, 1] of
    cnsNoneAttached: MessageDlg('Modem OK received on port: '+VoiceOCX.GetPortName(fModemID[IndexTag,0]),
                                mtInformation, [mbOK], 0);
    cnsSelectPort: frmSelectPort.VoiceOCX_PortOpen;
    cnsSelectDlg: frmDialogicOpen.VoiceOCX_PortOpen;
    cnsSelectBT: frmOpenBrook.VoiceOCX_PortOpen;
    cnsSelectNMS: frmDialogicOpen.VoiceOCX_PortOpen;
    end;
  end;
end;

procedure TfrmMain.VoiceOCXRing(Sender: TObject; ModemID: Integer);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if IndexTag<>-1 then
  begin
  case fModemID[IndexTag, 1] of
    cnsNoneAttached:
      begin
      MessageDlg('Modem detected RING on port: '+VoiceOCX.GetPortName(fModemID[IndexTag, 0]),
                  mtInformation, [mbOK], 0);
      end;
    cnsAutoAnswer:  // answerphone
      begin
      (ActiveMDIChild as TfrmChild).VoiceOCX_Ring;
      end;
    end;
  end;
end;

procedure TfrmMain.VoiceOCXVoicePlayFinished(Sender: TObject;
  ModemID: Integer);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if (IndexTag<>-1)and(fModemID[IndexTag,1]=cnsAutoAnswer) then
  begin
  (ActiveMDIChild as TfrmChild).VoiceOCX_VoicePlayFinished;
  end;
end;

procedure TfrmMain.VoiceOCXVoicePlayStarted(Sender: TObject;
  ModemID: Integer);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if IndexTag<>-1 then
  begin
  case fModemID[IndexTag, 1] of
    cnsAutoAnswer: (ActiveMDIChild as TfrmChild).VoiceOCX_VoicePlayStarted;
    end;
  end;
end;

procedure TfrmMain.VoiceOCXVoiceRecordFinished(Sender: TObject;
  ModemID: Integer);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if (IndexTag<>-1)and(fModemID[IndexTag,1]=cnsAutoAnswer)then
  begin
  (ActiveMDIChild as TfrmChild).VoiceOCX_VoiceRecordFinished;
  end;
end;

procedure TfrmMain.VoiceOCXVoiceRecordStarted(Sender: TObject;
  ModemID: Integer);
var IndexTag: Integer;
begin
IndexTag:=FindTagToModemID(ModemID);
if (IndexTag<>-1)and(fModemID[IndexTag,1]=cnsAutoAnswer)then
  begin
  (ActiveMDIChild as TfrmChild).VoiceOCX_VoiceRecordStarted;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var nIndex: Integer;
begin
for nIndex:=1 to 256 do
  begin
  VoiceOCX.DestroyModemObject(fModemID[nIndex, 0]);
  end;
end;

procedure TfrmMain.HelpHelp1Execute(Sender: TObject);
begin
frmHelp.Show;
end;

procedure TfrmMain.HelpAbout1Execute(Sender: TObject);
begin
AboutBox.Showmodal;
end;

end.
