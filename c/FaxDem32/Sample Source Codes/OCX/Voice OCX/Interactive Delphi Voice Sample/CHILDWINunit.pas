unit CHILDWINunit;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls, Grids, AppEvnts,
  ComCtrls, Sysutils;

type
  TfrmChild = class(TForm)
    lstEvents: TListView;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    procedure AddNewItem(modem_event: String; notice: String);
    procedure DestroyConnection;
    procedure PlayChooseMsg;
    procedure ReceiveFax;
    procedure RecordVoiceMail;
    procedure SendFax(sz_FaxFile: String);
    { Private declarations }
  public
    ModemID: LongInt;
    nProgressStatus: Integer;
    bDTMFReceived: Boolean;
    FaxID: LongInt;
    procedure SetModemID(Modem:LongInt);
    procedure VoiceOCX_Answer;
    procedure VoiceOCX_AnswerTone;
    procedure VoiceOCX_CallingTone;
    procedure VoiceOCX_DTMFReceived;
    procedure VoiceOCX_EndReceive;
    procedure VoiceOCX_EndSend;
    procedure VoiceOCX_FaxReceived(fax: LongInt; RemoteID: String);
    procedure VoiceOCX_FaxTerminated(Status: LongInt);
    procedure VoiceOCX_HangUp;
    procedure VoiceOCX_ModemError;
    procedure VoiceOCX_ModemOK;
    procedure VoiceOCX_OnHook;
    procedure VoiceOCX_Ring;
    procedure VoiceOCX_VoicePlayFinished;
    procedure VoiceOCX_VoicePlayStarted;
    procedure VoiceOCX_VoiceRecordFinished;
    procedure VoiceOCX_VoiceRecordStarted;
    { Public declarations }
  end;

Const cnsRings = 1;
Const cnsAnswer = 1;
Const cnsGreeting = 2;
Const cnsRecFax = 3;
Const cnsSendFax = 4;
Const cnsChoose = 5;
Const cnsHangUp = 6;
Const cnsRecord = 7;


implementation

{$R *.DFM}

Uses Mainunit;


procedure TfrmChild.AddNewItem(modem_event: String; notice: String);
var ListItem: TListItem;
begin
ListItem:=lstEvents.Items.Add;
ListItem.Caption:=DateToStr(Date)+' '+TimeToStr(now);
ListItem.SubItems.Add(modem_event);
ListItem.SubItems.Add(notice);
end;

procedure TfrmChild.DestroyConnection;
begin
AddNewItem('-', 'Disconnect line');
frmMain.VoiceOCX.HangUp(ModemID);
nProgressStatus:=cnsHangUp;
bDTMFReceived:=false;
end;

procedure TfrmChild.PlayChooseMsg;
var szVoiceFile: WideString;
    szVoiceFormatCmd: String;
begin
szVoiceFormatCmd:=frmMain.VoiceOCX.GetModemCommand(ModemID, 2);
if frmMain.VoiceOCX.GetModemType(ModemID)=cnsUSRobotics then
  begin
  if szVoiceFormatCmd<>'AT#VSM=132,8000'+#13#10 then
    begin
    frmMain.szVocExts[2]:='.USR';
    frmMain.VoiceOCX.SetDefaultVoiceParams(ModemID, MDF_ADPCM, 8000);
    frmMain.VoiceOCX.SetModemCommand(ModemID, 2, 'AT#VSM=129,8000'+#13#10);
    end;
  end;
szVoiceFile:=frmMain.szExePath+'\VOICE\SENDFAX';
frmMain.SetVocExtension(ModemID, szVoiceFile);
AddNewItem('Choose Fax','Playing "Choose Fax" message');
if frmMain.VoiceOCX.PlayVoice(ModemID, szVoiceFile, MDM_LINE, 20, 0, 1)=0 then
  begin
  nProgressStatus:=cnsChoose;
  end
  else
  begin
  DestroyConnection;
  end;
end;

procedure TfrmChild.ReceiveFax;
begin
if frmMain.VoiceOCX.ReceiveFaxNow(ModemID)=0 then
  begin
  nProgressStatus:=cnsRecFax;
  end;
end;

procedure TfrmChild.RecordVoiceMail;
var szVoiceFile: WideString;
    szVoiceFormatCmd: String;
    tmp:String;
begin
szVoiceFormatCmd:=frmMain.VoiceOCX.GetModemCommand(ModemID, 2);
if frmMain.VoiceOCX.GetModemType(ModemID)=cnsUSRobotics Then
  begin
  if szVoiceFormatCmd<>'AT#VSM=132,8000'+#13#10 then
    begin
    frmMain.szVocExts[2]:='.USR';
    frmMain.VoiceOCX.SetDefaultVoiceParams(ModemID, MDF_ADPCM, 8000);
    frmMain.VoiceOCX.SetModemCommand(ModemID, 2, 'AT#VSM=129,8000'+#13#10);
    end;
  end;
DateTimeToString(tmp, 'hh_mm_ss_mmm_dd_yyyy',now);
szVoiceFile:=frmMain.szExePath+'\VOICE\MAIL_'+tmp;
frmMain.SetVocExtension(ModemID, szVoiceFile);
AddNewItem('Record voice mail', 'Filename: '+szVoiceFile);
if frmMain.VoiceOCX.RecordVoice(ModemID, szVoiceFile, MDM_LINE, 60, true, 1)=0 then
  begin
  nProgressStatus:=cnsRecord;
  end
  else
  begin
  DestroyConnection;
  end;
end;

procedure TfrmChild.SendFax(sz_FaxFile: String);
var FaxID: LongInt;
    nNumOfImages: Integer;
    nIndex: Integer;
    szFaxFile: String;
begin
nProgressStatus:=0;
szFaxFile:=frmMain.szExePath+'\FAX.OUT\'+sz_FaxFile;
nNumOfImages:=frmMain.VoiceOCX.GetNumberOfImages(szFaxFile, IMT_FILE_TIFF_NOCOMP);
if nNumOfImages>(-1) then
  begin
  FaxID:=frmMain.VoiceOCX.CreateFaxObject(1, nNumOfImages, RES_196LPI, PWD_1728, PLN_NOCHANGE, DCF_1DMH, BFT_DISABLE, ECM_DISABLE, 0, 0);
  if FaxID<>0 then
    begin
    for nIndex:=0 to nNumOfImages-1 do
      begin
      if frmMain.VoiceOCX.SetFilePage(FaxID, nIndex, IMT_NOTHING, nIndex, szFaxFile)<>0 then
        begin
        AddNewItem('ERROR', 'Error in SetFilePage()');
        DestroyConnection;
        end;
      end;
    if (frmMain.VoiceOCX.SendFaxNow(ModemID, FaxID)=0) then
      begin
      nProgressStatus:=cnsSendFax;
      end
      else
      begin
      AddNewItem('ERROR', 'Error in SendFaxNow()');
      DestroyConnection;
      end;
    end
    else
    begin
    AddNewItem('ERROR', 'Error in CreateFaxObject()');
    DestroyConnection;
    end;
  end
  else
  begin
  AddNewItem('ERROR', 'Error in GetNumberOfImages()');
  DestroyConnection;
  end;
end;

procedure TfrmChild.SetModemID(Modem:LongInt);
begin
ModemID:=Modem;
end;

procedure TfrmChild.VoiceOCX_Answer;
var szVoiceFile: WideString;
    szVoiceFormatCmd: String;
begin
szVoiceFormatCmd:=frmMain.VoiceOCX.GetModemCommand(ModemID, 2);
if frmMain.VoiceOCX.GetModemType(ModemID)=cnsUSRobotics then
  begin
  if szVoiceFormatCmd<>'AT#VSM=132,8000'+#13#10 then
    begin
    frmMain.szVocExts[2]:='.USR';
    frmMain.VoiceOCX.SetDefaultVoiceParams(ModemID, MDF_ADPCM, 8000);
    frmMain.VoiceOCX.SetModemCommand(ModemID, 2, 'AT#VSM=129,8000'+#13#10);
    end;
  end;
szVoiceFile:=frmMain.szExePath+'VOICE\VOICE';
frmMain.SetVocExtension(ModemID, szVoiceFile);
AddNewItem('Answer', 'Call was answered');

if frmMain.VoiceOCX.GetDIDDigits(ModemID)<>'' then
  begin
  AddNewItem('Answer', 'DID digits received:'+frmMain.VoiceOCX.GetDIDDigits(ModemID));
  end;

if frmMain.VoiceOCX.PlayVoice(ModemID, szVoiceFile, MDM_LINE, 20, 0, 1)=0 then
  begin
  nProgressStatus:=cnsGreeting;
  end
  else
  begin
  DestroyConnection
  end;
end;

procedure TfrmChild.VoiceOCX_AnswerTone;
begin
AddNewItem('Interrupt', 'Answer tone was detected!');
frmMain.VoiceOCX.TerminateProcess(ModemID);
end;

procedure TfrmChild.VoiceOCX_CallingTone;
begin
AddNewItem('Interrupt', 'Calling tone was detected!');
frmMain.VoiceOCX.TerminateProcess(ModemID);
end;

procedure TfrmChild.VoiceOCX_DTMFReceived;
begin
bDTMFReceived:=true;
frmMain.VoiceOCX.TerminateProcess(ModemID);
end;

procedure TfrmChild.VoiceOCX_EndReceive;
var bAppend: Boolean;
    szFileName: WideString;
    nPageNum, Res, Width, Length, Comp, Bin, Bitord, Ecm, Color, ClrType: SmallInt;
    tmp:String;
    nIndex:SmallInt;
begin
if FaxID<>0 then
  begin
  AddNewItem('EndReceive', 'Saving received fax');
  DateTimeToString(tmp, 'hh_mm_ss_mmm_dd_yyyy', now);
  szFileName:=frmMain.szExePath+'\FAX.IN\FAX_'+tmp+'.TIF';
  bAppend:=false;
  frmMain.VoiceOCX.GetFaxParam(FaxID, nPageNum, Res, Width, Length, Comp, Bin, Bitord, Ecm, Color, ClrType);
  for nIndex:=0 to nPageNum-1 do
    begin
    frmMain.VoiceOCX.GetFaxImagePage(FaxID, nIndex, IMT_FILE_TIFF_NOCOMP, bAppend, szFileName);
    bAppend:=true;
    end;
  frmMain.VoiceOCX.ClearFaxObject(FaxID);
  FaxID:=0;
  end
  else
  begin
  AddNewItem('EndReceive', 'No fax was received');
  end;
nProgressStatus:=0;
DestroyConnection;
end;

procedure TfrmChild.VoiceOCX_EndSend;
begin
nProgressStatus:=0;
AddNewItem('FaxSent', 'Send fax operation has finished');
DestroyConnection;
end;

procedure TfrmChild.VoiceOCX_FaxReceived(fax: LongInt; RemoteID: String);
begin
FaxID:=fax;
end;

procedure TfrmChild.VoiceOCX_FaxTerminated(Status: LongInt);
begin
AddNewItem('Fax was Terminated', 'Termination status:'+IntToStr(Status));
end;

procedure TfrmChild.VoiceOCX_HangUp;
begin
nProgressStatus:=0;
frmMain.VoiceOCX.WaitForRings(ModemID, cnsRings);
AddNewItem('Hangup', 'Modem was disconnected - answerphone operation complete');
end;

procedure TfrmChild.VoiceOCX_ModemError;
begin
AddNewItem('ERROR', 'Last operation failed.');
DestroyConnection;
end;

procedure TfrmChild.VoiceOCX_ModemOK;
begin
//DestroyConnection;
end;

procedure TfrmChild.VoiceOCX_OnHook;
begin
AddNewItem('Disconnect', 'Remote side has disconnected');
frmMain.VoiceOCX.TerminateProcess(ModemID);
end;

procedure TfrmChild.VoiceOCX_Ring;
begin
AddNewItem('', '');
AddNewItem('Incoming call was detected.', 'Answering call...');
nProgressStatus:=0;
if frmMain.VoiceOCX.Answer(ModemID)=0 then
  begin
  nProgressStatus:=cnsAnswer;
  end
  else
  begin
  DestroyConnection;
  end;
end;

procedure TfrmChild.VoiceOCX_VoicePlayFinished;
var szTemp: String;
    szDTMF: String;
begin
if nProgressStatus=cnsGreeting then
  begin
  if bDTMFReceived=true then
    begin
    bDTMFReceived:=false;
    szDTMF:=frmMain.VoiceOCX.GetReceivedDTMFDigits(ModemID);
    szTemp:='DTMF received:'+szDTMF;
    end
    else
    begin
    szTemp:='No acceptable DTMF digit was received!'
    end;
  AddNewItem('Playing greeting message was finished',szTemp);
  if szDTMF='' then szDTMF:='-1'; 
  case StrToInt(szDTMF) of
    0: RecordVoiceMail;
    1: ReceiveFax;
    2: PlayChooseMsg;
    else
    DestroyConnection;
    end;
  end
  else
  begin
  if bDTMFReceived=true then
    begin
    szDTMF:=frmMain.VoiceOCX.GetReceivedDTMFDigits(ModemID);
    AddNewItem('DTMF Received'+szDTMF, 'User chose fax: '+szDTMF);
    case StrToInt(szDTMF) of
      0: SendFax('TEST.TIF');
      1: SendFax('TEST.TIF');
      2: SendFax('TEST.TIF');
      else
      DestroyConnection;
      end;
    end;
  end;
end;

procedure TfrmChild.VoiceOCX_VoicePlayStarted;
begin
AddNewItem('VoicePlayStarted', '');
end;

procedure TfrmChild.VoiceOCX_VoiceRecordFinished;
begin
AddNewItem('Voice mail was recorded', '');
DestroyConnection;
end;

procedure TfrmChild.VoiceOCX_VoiceRecordStarted;
begin
AddNewItem('Recording voice mail was started', '');
end;

procedure TfrmChild.FormClose(Sender: TObject; var Action: TCloseAction);
var nIndex: Integer;
begin
Action:=caFree;
nIndex:=frmMain.FindTagToModemID(ModemID);
frmMain.fModemID[nIndex, 1]:=cnsNoneAttached;
frmMain.VoiceOCX.DestroyModemObject(ModemID);
frmMain.fModemID[nIndex, 0]:=0;
end;

procedure TfrmChild.FormShow(Sender: TObject);
begin
AddNewItem('Voice Mail sample has been started.', 'Modem is ready to answer incoming calls.')
end;

end.
