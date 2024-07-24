unit SELECTPORTunit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmSelectPort = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    AllPorts: TComboBox;
    cbModemType: TComboBox;
    Manufacturer: TEdit;
    Model: TEdit;
    ModemCaps: TEdit;
    btnLog: TCheckBox;
    btnOpenPort: TButton;
    btnTest: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure AllPortsChange(Sender: TObject);
    procedure cbModemTypeChange(Sender: TObject);
    procedure btnOpenPortClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Modem: LongInt;
    nSelPort: Integer;
    bLogEnabled: Boolean;
    bTesting: Boolean;
    bTested: Boolean;
    ActualPort: Integer;
    bAutoOpen: Boolean;
    { Private declarations }
  public
    procedure DestroyModem;
    function GetSelectedPort: LongInt;
    function LogEnabled:Boolean;
    procedure VoiceOCX_ModemError;
    procedure VoiceOCX_ModemOK;
    procedure VoiceOCX_PortOpen;
    { Public declarations }
  end;


var
  frmSelectPort: TfrmSelectPort;

implementation

uses Mainunit, ChildWinUnit;

{$R *.DFM}

procedure TfrmSelectPort.DestroyModem;
var nIndex: Integer;
begin
if Modem<>0 then
  begin
  nIndex:=frmMain.FindTagToModemID(Modem);
  if nIndex>0 then
    begin
    frmMain.fModemID[nIndex,0]:=0;
    frmMain.fModemID[nIndex,1]:=cnsNoneAttached;
    end;

  frmMain.VoiceOCX.ClosePort(Modem);
  frmMain.VoiceOCX.DestroyModemObject(Modem);
  Modem:=0;
  end;
btnTest.Enabled:=true;
btnOpenPort.Enabled:=true;
Manufacturer.Text:='';
Model.Text:='';
ModemCaps.Text:='';
end;

function TfrmSelectPort.GetSelectedPort:LongInt;
begin
GetSelectedPort:=Modem;
end;

function TfrmSelectPort.LogEnabled:Boolean;
begin
LogEnabled:=bLogEnabled;
end;

procedure TfrmSelectPort.VoiceOCX_ModemError;
var nIndex: Integer;
    szPort: String;
begin
if (bAutoOpen = True)and(ActualPort <> 7) Then
  begin
  DestroyModem;
  if ActualPort=1 then
    begin
    ActualPort:=6;
    end
    else
    begin
    if ActualPort=8 then
      begin
      ActualPort:=0;
      end
      else
      begin
      ActualPort:=ActualPort+1;
      end;
    end;
  Modem:=frmMain.VoiceOCX.CreateModemObject(ActualPort);
  bTested:=true;
  if Modem<>0 then
    begin
    szPort:=AllPorts.Text;
    nIndex:=frmMain.AddNewModem(Modem);
    if nIndex>0 then
      begin
      frmMain.fModemID[nIndex,1]:=cnsSelectPort;
      if frmMain.VoiceOCX.OpenPort(Modem, szPort)=0 then
        begin
        btnTest.Enabled:=false;
        btnCancel.Enabled:=false;
        end
        else
        begin
        MessageDlg('Couldn'+''''+'t open modem port!',mtError,[mbOK],0);
        DestroyModem;
        end;
      end;
    end
    else
    begin
    MessageDlg('Couldn'+''''+'t create modem object!',mtError,[mbOK],0);
    end;
  btnTest.Enabled:=false;
  btnOpenPort.Enabled:=false;
  end
  else
  begin
  btnTest.Enabled:=false;
  btnOpenPort.Enabled:=false;
  btnCancel.Enabled:=true;
  MessageDlg('Modem ERROR message received',mtError,[mbOK],0);
  bTested:=false;
  DestroyModem;
  end;
end;

procedure TfrmSelectPort.VoiceOCX_ModemOK;
var szManufacturer: WideString;
    szModel: WideString;
    szModes: WideString;
    Caps: String;
    nIndex: Integer;
    bStarted: Boolean;
begin
bStarted:=false;

frmMain.VoiceOCX.GetTestResult(Modem, szManufacturer, szModel, szModes);
Manufacturer.Text:=szManufacturer;
Model.Text:=szModel;
for nIndex:=1 to 5 do
  begin
  if isDelimiter('1',szModes,nIndex) then
    begin
    if bStarted=true then
      begin
      Caps:=Caps+'/';
      end;
    Caps:=Caps+frmMain.szVoiceCaps[nIndex];
    bStarted:=true;
    end;
  end;
ModemCaps.Text:=Caps;
btnTest.Enabled:=false;
btnOpenPort.Enabled:=true;
btnCancel.Enabled:=true;
if ActualPort=0 then
  begin
  cbModemType.ItemIndex:=1;
  end
  else
  begin
  if ActualPort=1 then
    begin
    cbModemType.ItemIndex:=2;
    end
    else
    begin
    if ActualPort=6 then
      begin
      cbModemType.ItemIndex:=3;
      end
      else
      begin
      if ActualPort=7 then
        begin
        cbModemType.ItemIndex:=4;
        end
        else
        begin
        if ActualPort=8 then
          begin
          cbModemType.ItemIndex:=5;
          end;
        end;
      end;
    end;
  end;
if bTesting=false then
  ModalResult:=mrOK;
end;

procedure TfrmSelectPort.VoiceOCX_PortOpen;
begin
if frmMain.VoiceOCX.TestVoiceModem(Modem)<>0 then
  begin
  MessageDlg('Modem test failed!', mtError, [mbOK], 0);
  DestroyModem;
  end
end;

procedure TfrmSelectPort.FormCreate(Sender: TObject);
var szPorts: String;
    t1: String;
    j: Integer;
begin
//Create
bTested:=false;
Modem:=0;
szPorts:=frmMain.VoiceOCX.AvailablePorts+' ';
j:=Pos(' ',szPorts);
while j<>0 do
begin
        t1:=copy(szPorts,1,j-1);
        AllPorts.Items.Add(t1);
        delete(szPorts,1,j);
        j:=Pos(' ',szPorts);
end;

{if szPorts<>'' then
  begin
  bFlag:=true;
  j:=0;
  While bFlag do
    begin
    if isDelimiter(' ',szPorts,j) then
      begin
      t1:=szPorts;
      Delete(t1,j,Length(t1)-j);
      Delete(t1,1,j-4);
      AllPorts.Items.Add(t1);
      Delete(t1,1,Length(t1)-1);
      end;
    Inc(j);
    if j>Length(szPorts) then
      begin
      bFlag:=false;
      if Length(szPorts)<5 then
        begin
        t1:=szPorts;
        AllPorts.Items.Add(t1);
        Delete(t1,1,Length(t1)-1);
        end;
      end;
    end;
  end;
  {New code for getting the port names - Levente Nemethy}

if AllPorts.Items.Count>0 then
  begin
  AllPorts.ItemIndex:=0;
  end
  else
  begin
  AllPorts.Enabled:=false;
  btnTest.Enabled:=false;
  end;
btnOpenPort.Enabled:=true;
if cbModemType.Items.Count>0 then
  begin
  cbModemType.ItemIndex:=0;
  end;

end;

procedure TfrmSelectPort.AllPortsChange(Sender: TObject);
begin
//AllPortsChange
bTested:=false;
DestroyModem;
end;

procedure TfrmSelectPort.cbModemTypeChange(Sender: TObject);
begin
//ModemTypeChange
bTested:=false;
DestroyModem;
end;

procedure TfrmSelectPort.btnOpenPortClick(Sender: TObject);
var szPort: String;
    nIndex: Integer;
begin
//OpenPort
bTesting:=false;
if bTested=false then
  begin
  nIndex:=cbModemType.ItemIndex;
  if nIndex=3 then
    begin
    nIndex:=7;
    end;
  if nIndex=4 then
    begin
    nIndex:=8;
    end;
  if nIndex=5 then
    begin
    nIndex:=9;
    end;
  if nIndex=0 then
    begin
    ActualPort:=8;
    nIndex:=9;
    bAutoOpen:=true;
    end
    else
    begin
    bAutoOpen:=false;
    ActualPort:=nIndex-1;
    end;

  Modem:=frmMain.VoiceOCX.CreateModemObject(nIndex-1);
  if Modem<>0 then
    begin
    szPort:=AllPorts.Text;
    nIndex:=frmMAin.AddNewModem(Modem);
    if nIndex>0 then
      begin
      frmMain.fModemID[nIndex,1]:=cnsSelectPort;
      if frmMain.VoiceOCX.OpenPort(Modem, szPort)=0 then
        begin
        btnTest.Enabled:=false;
        btnCancel.Enabled:=false;
//        bTested:=true;
        end
        else
        begin
        MessageDlg('Couldn'+''''+'t open modem port!', mtError, [mbOK], 0);
        DestroyModem;
        end;
      end;
    end
    else
    begin
    MessageDlg('Couldn'+''''+'t create modem object!', mtError, [mbOK], 0);
    end;
  end;
btnTest.Enabled:=false;
btnOpenPort.Enabled:=false;
//KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
//KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
//KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
//KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
nSelPort:=AllPorts.ItemIndex+1;
if btnLog.Checked then
  begin
  bLogEnabled:=true;
  end
  else
  begin
  bLogEnabled:=false;
  end;
if bTested=true then
  begin
  ModalResult:=mrOK;
  end;
end;

procedure TfrmSelectPort.btnTestClick(Sender: TObject);
var szPort: String;
    nIndex: Integer;
begin
//Test
bTesting:=true;
nIndex:=cbModemType.ItemIndex;
if nIndex=3 then
  nIndex:=7;
if nIndex=4 then
  nIndex:=8;
if nIndex=5 then
  nIndex:=9;
if nIndex=0 then
  begin
  ActualPort:=8;
  nIndex:= 9;
  bAutoOpen:=true;
  end
  else
  begin
  bAutoOpen:=false;
  ActualPort:=nIndex-1;
  end;
Modem:=frmMain.VoiceOCX.CreateModemObject(nIndex-1);
bTested:=true;
if Modem<>0 then
  begin
  szPort:=AllPorts.Text;
  nIndex:=frmMain.AddNewModem(Modem);
  if nIndex>0 then
    begin
    frmMain.fModemID[nIndex, 1]:=cnsSelectPort;
    if frmMain.VoiceOCX.OpenPort(Modem, szPort)=0 then
      begin
      btnTest.Enabled:=false;
      btnCancel.Enabled:=false;
      end
      else
      begin
      MessageDlg('Couldn'+''''+'t open modem port!',mtError,[mbOK],0);
      DestroyModem;
      end;
    end;
  end
  else
  begin
  MessageDlg('Couldn'+''''+'t create modem object!',mtError,[mbOK],0);
  end;
btnTest.Enabled:=false;
end;

procedure TfrmSelectPort.btnCancelClick(Sender: TObject);
begin
//Cancel
DestroyModem;
ModalResult:=mrCancel;
end;

procedure TfrmSelectPort.FormShow(Sender: TObject);
begin
//kj
end;

end.
