unit OPENBROOKunit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles;

type
  TfrmOpenBrook = class(TForm)
    lvChannelList: TListBox;
    chbLogEn: TCheckBox;
    ModemType: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    btnTest: TButton;
    Label3: TLabel;
    ConfigFile: TEdit;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    bLogEnabled: Boolean;
    ModemID: LongInt;
    ModemInd: Integer;
    { Private declarations }
  public
    procedure VoiceOCX_PortOpen;
    procedure VoiceOCX_ModemError;
    function GetSelectedChannel: Integer;
    function LogEnabled:Boolean;
    { Public declarations }
  end;

var
  frmOpenBrook: TfrmOpenBrook;

implementation

{$R *.DFM}

Uses Mainunit;

procedure TfrmOpenBrook.VoiceOCX_PortOpen;
begin
MessageDlg('Channel opened',mtInformation,[mbOK],0);
Modalresult:=mrOK;
end;

procedure TfrmOpenBrook.VoiceOCX_ModemError;
begin
MessageDlg('Open channel failed!',mtInformation,[mbOK],0);
btnOK.Enabled:=false;
btnCancel.Enabled:=true;
frmMain.DeleteModem(ModemID);
frmMain.VoiceOCX.DestroyModemObject(ModemID);
frmMain.fModemID[ModemInd, 1]:=cnsNoneAttached;
end;

function TfrmOpenBrook.GetSelectedChannel: Integer;
begin
GetSelectedChannel:=ModemID;
end;

function TfrmOpenBrook.LogEnabled:Boolean;
begin
LogEnabled:=bLogEnabled;
end;



procedure TfrmOpenBrook.btnOKClick(Sender: TObject);
var nIndex: Integer;

Ini:TIniFile;

begin
bLogEnabled:=chbLogEn.Checked;
nIndex:=lvChannelList.ItemIndex;
Ini:=TIniFile.Create('Demo32.ini');
try
  frmMain.VoiceOCX.SetBrooktroutConfigFile(ConfigFile.Text);
  Ini.WriteString('Brooktrout','Config file',ConfigFile.Text);
finally
	Ini.Free;
end;
if nIndex<>-1 then
  begin
  ModemID:=frmMain.VoiceOCX.CreateModemObject(cnsBrooktrout);
  if ModemID<>0 then
    begin
    ModemInd:=frmMain.AddNewModem(ModemID);
    if ModemInd<>0 then
      begin
      frmMain.fModemID[ModemInd, 1]:=cnsSelectBT;
      if frmMain.VoiceOCX.OpenPort(ModemID, lvChannelList.Items[nIndex])=0 then
        begin
        btnOK.Enabled:=false;
        btnCancel.Enabled:=false;
        ModalResult:=mrOk;
        end
        else
        begin
        MessageDlg('Cannot open channel: '+lvChannelList.Items[nIndex],mtError,[mbOK],0);
        ModalResult:=mrCancel;
        end;
  	  end;
    end
    else
	  	begin
   	  	MessageDlg('Config file is not valid!',mtError,[mbOK],0);
     	end;
  end;
end;

procedure TfrmOpenBrook.btnCancelClick(Sender: TObject);
begin
ModalResult:=mrCancel;
end;

procedure TfrmOpenBrook.btnTestClick(Sender: TObject);
var szType: WideString;
begin
if lvChannelList.ItemIndex<>-1 then
  begin
  frmMain.VoiceOCX.GetBrooktroutChannelType(lvChannelList.ItemIndex,szType,50);
  ModemType.Text:=szType;
  end;
end;

procedure TfrmOpenBrook.FormShow(Sender: TObject);
var nChannels: Integer;
    szChannel: String;
    nIndex: Integer;
    Ini: TIniFile;
begin
nChannels:=0;
for nIndex:=0 to MAX_BROOK_CHANNELS do
  begin
  if frmMain.VoiceOCX.IsBrooktroutChannelFree(nIndex)<>false then
    begin
    szChannel:='CHANNEL';
    szChannel:=szChannel+IntToStr(nIndex);
    lvChannelList.Items.Insert(nChannels,szChannel);
    nChannels:=nChannels+1;
    end;
  end;

try
	Ini:=TIniFile.Create('Demo32.ini');
  ConfigFile.Text:=Ini.ReadString('Brooktrout','Config file','');
finally
	Ini.Free;
end;
if nChannels>0 then
  begin
  btnOK.Enabled:=true;
  btnTest.Enabled:=true;
  end;
end;

procedure TfrmOpenBrook.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
	lvChannelList.Items.Clear;
end;

end.
