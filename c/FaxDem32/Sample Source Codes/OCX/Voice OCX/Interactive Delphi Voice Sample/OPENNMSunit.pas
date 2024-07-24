unit OPENNMSunit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfrmOpenNMS = class(TForm)
    lvChannelList: TListView;
    chbLogEn: TCheckBox;
    Edit1: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ProtocolCombo: TComboBox;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    bLogEnabled: Boolean;
    ModemID: LongInt;
    ModemInd: Integer;
    { Private declarations }
  public
    procedure VoiceOCX_PortOpen;
    procedure VoiceOCX_ModemError;
    function GetSelectedChannel: Integer;
    function GetSelectedProtocol(Index: Integer):String;
    function LogEnabled:Boolean;
    { Public declarations }
  end;

var
  frmOpenNMS: TfrmOpenNMS;

implementation

{$R *.DFM}

Uses Mainunit;

procedure TfrmOpenNMS.VoiceOCX_PortOpen;
begin
MessageDlg('Channel opened',mtInformation,[mbOK],0);
Modalresult:=mrOK;
end;

procedure TfrmOpenNMS.VoiceOCX_ModemError;
begin
MessageDlg('Open channel failed!',mtInformation,[mbOK],0);
btnOK.Enabled:=true;
btnCancel.Enabled:=true;
frmMain.fModemID[ModemInd, 1]:=cnsNoneAttached;
end;

function TfrmOpenNMS.GetSelectedChannel: Integer;
begin
GetSelectedChannel:=ModemID;
end;

function TfrmOpenNMS.GetSelectedProtocol(Index: Integer):String;
var Protocol: String;
begin
case Index of
  0: Protocol:='LPS0';
  1: Protocol:='DID0';
  2: Protocol:='OGT0';
  3: Protocol:='WNK0';
  4: Protocol:='WNK1';
  5: Protocol:='LPS8';
  6: Protocol:='FDI0';
  7: Protocol:='LPS9';
  8: Protocol:='GST8';
  9: Protocol:='GST9';
  10: Protocol:='ISD0';
  11: Protocol:='MFC0';
  else Protocol:='LPS0';
  end;// Select
GetSelectedProtocol:=Protocol;
end;

function TfrmOpenNMS.LogEnabled:Boolean;
begin
LogEnabled:=bLogEnabled;
end;




procedure TfrmOpenNMS.btnOKClick(Sender: TObject);
var nIndex: Integer;
    i: Integer;
    Index: Integer;
    Protocol: String;
    didDigits: Integer;
begin
bLogEnabled:=chbLogEn.Checked;
nIndex:=(-1);
for i:=1 to lvChannelList.Items.Count do
  begin
  if lvChannelList.Items.Item[i].Selected=true then
    begin
    nIndex:=i;
    break;
    end;
  end;
{if nIndex=(-1) then
  begin
  lvChannelList.Items.Item[1].Selected:=true;
  nIndex:=1
  end;}

if nIndex<>(-1) then
  begin
  ModemID:=frmMain.VoiceOCX.CreateModemObject(cnsNMS);
  if ModemID<>0 then
    begin
    ModemInd:=frmMain.AddNewModem(ModemID);
    if ModemInd<>0 then
      begin
      frmMain.fModemID[ModemInd, 1]:=cnsSelectNMS;
      //Set selected protocol
      Index:=ProtocolCombo.ItemIndex;
      Protocol:=GetSelectedProtocol(Index);
      frmMain.VoiceOCX.SetNMSProtocol(Protocol);
      //Set specified DID/DNIS digits
      didDigits:=StrToInt(Edit1.Text);
      frmMain.VoiceOCX.SetDIDDigitNumber(ModemID,didDigits);
      if frmMain.VoiceOCX.OpenPort(ModemID, lvChannelList.Items.Item[nIndex].Caption)=0 then
        begin
        btnOK.Enabled:=false;
        btnCancel.Enabled:=false;
        Modalresult:=mrOK;
        end
        else
        begin
        MessageDlg('Cannot open channel: '+lvChannelList.Items.Item[nIndex].Caption,mtError, [mbOK],0);
        Modalresult:=mrCancel;
        end;
      end;
    end;
  end;
end;

procedure TfrmOpenNMS.btnCancelClick(Sender: TObject);
begin
Modalresult:=mrCancel;
end;

procedure TfrmOpenNMS.FormShow(Sender: TObject);
var nBoards: Integer;
    i,j: Integer;
    szChannel: String;
    szModel: WideString;
    itmX: TListItem;
begin
bLogEnabled:=false;
ModemID:=0;
nBoards:=frmMain.VoiceOCX.GetNMSBoardNum;
for i:= 0 to nBoards do
  begin
  for j:=0 to frmMain.VoiceOCX.GetNMSChannelNum(i)-1 do
    begin
    if frmMain.VoiceOCX.IsNMSChannelFree(i, j) then
      begin
      szChannel:='NMS_B';
      szChannel:=szChannel+IntToStr(i)+'CH';
      szChannel:=szChannel+IntToStr(j);
      itmX:=lvChannelList.Items.Add;
      itmX.Caption:=szChannel;
      if frmMain.VoiceOCX.GetNMSChannelType(i, j, szModel, 50)>0 then
        begin
        itmX.SubItems.Add(szModel);
        end;
      end;
    end;
  end;
ProtocolCombo.Items.Add('Analog Loop Start (LPS0)');
ProtocolCombo.Items.Add('Digital/Analog Wink Start (inbound only) (DID0)');
ProtocolCombo.Items.Add('Digital/Analog Wink Start (outbound only) (OGT0)');
ProtocolCombo.Items.Add('Digital/Analog Wink Start (WNK0)');
ProtocolCombo.Items.Add('Analog Wink Start (WNK1)');
ProtocolCombo.Items.Add('Digital Loop Start OPS-FX (LPS8)');
ProtocolCombo.Items.Add('Feature Group D (inbound only) (FDI0)');
ProtocolCombo.Items.Add('Digital Loop Start OPS-SA (LPS9)');
ProtocolCombo.Items.Add('Digital Ground Start OPS-FX (GST8)');
ProtocolCombo.Items.Add('Digital Ground Start OPS-SA (GST9)');
ProtocolCombo.Items.Add('ISDN protocol (ISD0)');
ProtocolCombo.Items.Add('MFC R2 protocol (MFC0)');
ProtocolCombo.ItemIndex:=0;
end;

end.
