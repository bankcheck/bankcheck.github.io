unit DIALOGICOPENunit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfrmDialogicOpen = class(TForm)
    lvChannelList: TListView;
    LineType: TComboBox;
    Protocol: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvChannelListClick(Sender: TObject);
    procedure LineTypeChange(Sender: TObject);
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
  frmDialogicOpen: TfrmDialogicOpen;


implementation

{$R *.DFM}

Uses Mainunit;

procedure TfrmDialogicOpen.VoiceOCX_PortOpen;
begin
MessageDlg('Channel opened',mtInformation,[mbOK],0);
Modalresult:=mrOK;
end;

procedure TfrmDialogicOpen.VoiceOCX_ModemError;
begin
MessageDlg('Open channel failed!',mtInformation,[mbOK],0);
btnOK.Enabled:=false;
btnCancel.Enabled:=false;
frmMain.fModemID[ModemInd, 1]:=cnsNoneAttached;
end;

function TfrmDialogicOpen.GetSelectedChannel: Integer;
begin
GetSelectedChannel:=ModemID;
end;

function TfrmDialogicOpen.LogEnabled:Boolean;
begin
LogEnabled:=bLogEnabled;
end;


procedure TfrmDialogicOpen.btnOKClick(Sender: TObject);
var nIndex: Integer;
    i: Integer;
begin
nIndex:=(-1);
for i:=0 to lvChannelList.Items.Count-1 do
  begin
  if lvChannelList.Items.Item[i].Selected=true then
    begin
    nIndex:=i+1;
    break;
    end;
  end;
if nIndex<>-1 then
  begin
  ModemID:=frmMain.VoiceOCX.CreateModemObject(cnsDialogic);
  if ModemID <> 0 then
    begin
    ModemInd:=frmMain.AddNewModem(ModemID);
    if ModemInd<>0 then
      begin
      frmMain.fModemID[ModemInd, 1]:=cnsSelectDlg;
      if LineType.Text='Analog' then
        begin
        //3 is ANALOG
        frmMain.VoiceOCX.SetDialogicLineType(ModemID, 3);
        end
        else
        begin
        if LineType.Text='ISDN PRI' then
          begin
          //2 is ISDN PRI
          frmMain.VoiceOCX.SetDialogicLineType(ModemID, 2);
          end
          else
          begin
          if (LineType.Text='T1')or(LineType.Text='E1') then
            begin
            //1 is T1/E1
            frmMain.VoiceOCX.SetDialogicLineType(ModemID, 1);
            frmMain.VoiceOCX.SetDialogicProtocol(ModemID, Protocol.Text);
            end;
          end;
        end;
      if frmMain.VoiceOCX.OpenPort(ModemID,lvChannelList.Items.Item[nIndex-1].Caption)=0 then
        begin
        btnOK.Enabled:=false;
        btnCancel.Enabled:=false;
        end
        else
        begin
        MessageDlg('Cannot open channel: '+lvChannelList.Items.Item[nIndex].Caption ,mtError,[mbOK],0);
        end;
      end;
    end;
  end;
ModalResult:=mrOk;
end;

procedure TfrmDialogicOpen.btnCancelClick(Sender: TObject);
begin
ModalResult:=mrCancel;
end;

procedure TfrmDialogicOpen.FormShow(Sender: TObject);
var nBoards: Integer;
    i,j: Integer;
    szChannel: WideString;
    szType, szManufact, szModel: WideString;
    itmX: TListItem;
begin
bLogEnabled:=false;
ModemID:=0;
nBoards:=frmMain.VoiceOCX.GetDialogicBoardNum;
if lvChannelList.Items[0]=nil then
  begin
  LineType.ItemIndex:=0;
  for i:=1 to nBoards do
    begin
    for j:=1 to frmMain.VoiceOCX.GetDialogicChannelNum(i) do
      begin
      if frmMain.VoiceOCX.IsDialogicChannelFree(i, j) Then
        begin
        szChannel:='dxxxB';
        szChannel:=szChannel+IntToStr(i)+'C';
        szChannel:=szChannel+IntToStr(j);
        itmX:=lvChannelList.Items.Add;
        itmX.Caption:=szChannel;
        if frmMain.VoiceOCX.TestDialogic(szChannel, szType, szManufact, szModel) then
          begin
          itmX.SubItems.Add(szModel);
          end;
        end;
      end;
    end;
  end;
Protocol.Enabled:=false;
end;

procedure TfrmDialogicOpen.lvChannelListClick(Sender: TObject);
begin
if LineType.ItemIndex>1 then
  begin
  Protocol.Enabled:=true;
  end
  else
  begin
  Protocol.Enabled:=false;
  end;
end;

procedure TfrmDialogicOpen.LineTypeChange(Sender: TObject);
begin
if (LineType.ItemIndex=2) or (LineType.ItemIndex=3) then
  begin
  Label2.Enabled:=true;
  Protocol.Enabled:=true;
  end
  else
  begin
  Label2.Enabled:=false;
  Protocol.Enabled:=false;
  end;
end;

end.
