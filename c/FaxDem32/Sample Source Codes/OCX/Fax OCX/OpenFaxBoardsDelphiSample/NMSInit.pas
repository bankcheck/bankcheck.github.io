unit NMSInit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TNMS = class(TForm)
    GammaLinkChannelsGroupBox: TGroupBox;
    NMSChannelsListBox: TListBox;
    OKButton: TButton;
    CancelButton: TButton;
    ProtocolComboBox: TComboBox;
    Label2: TLabel;
    procedure OnOK(Sender: TObject);
    procedure OnCancel(Sender: TObject);
    procedure OnShowNMS(Sender: TObject);
    function GetSelectedProtocol(index:integer):string;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NMS: TNMS;
  DID: string;

implementation

uses Main;

{$R *.DFM}
function TNMS.GetSelectedProtocol(index:integer):String;
var
   protocol:String;
begin
     case index of
          0:
          protocol:='LPS0';
          1:
          protocol:='DID0';
          2:
          protocol:='OGT0';
          3:
          protocol:='WNK0';
          4:
          protocol:='WNK1';
          5:
          protocol:='LPS8';
          6:
          protocol:='FDI0';
          7:
          protocol:='LPS9';
          8:
          protocol:='GST8';
          9:
          protocol:='GST9';
          10:
          protocol:='ISD0';
          11:
          protocol:='MFC0';
     else
          protocol:='LPS0';
     end;
     GetSelectedProtocol := protocol;
end;

procedure TNMS.OnOK(Sender: TObject);
var
   errorOpenPort,protocolIndex:integer;
   protocol:string;
begin
     Screen.Cursor:=-11;
     //Set Selected Protocol
     protocolIndex := ProtocolComboBox.ItemIndex;
     protocol := GetSelectedProtocol( protocolIndex );
     MainForm.FAX1.NMSProtocoll := protocol;

     errorOpenPort:=MainForm.FAX1.OpenPort(NMSChannelsListBox.Items[NMSChannelsListBox.ItemIndex]);
     if errorOPenPort<>0 then
        begin
                  MessageDlg(MainForm.Errors(errorOpenPort),mtWarning,[mbOK],0);
                  Screen.Cursor:=-2;
                  Exit;
        end
     else
     begin
        MainForm.EventListBox.Items.Add(NMSChannelsListBox.Items[NMSChannelsListBox.ItemIndex] + ' was opened');
     end;

     if (Length(MainForm.FAX1.NMSChannelsOpen)>0) then
     begin
        MainForm.Close1.Enabled:=True;
     end;

    if Length(MainForm.FAX1.AvailableNMSChannels) > 0 then
        MainForm.NMSchannel1.Enabled := True
    else
        MainForm.NMSchannel1.Enabled := False;

     Screen.Cursor:=-2;
     Close;

end;

procedure TNMS.OnCancel(Sender: TObject);
begin
     Close;
end;

procedure TNMS.OnShowNMS(Sender: TObject);
var
   NMSChannels,temp:string;
   index:byte;
begin
     NMSChannelsListBox.Clear;
     NMSChannels:=MainForm.FAX1.AvailableNMSChannels+' ';
     index:=Pos(' ',NMSChannels);
     while index<>0 do
     begin
          temp:=copy(NMSChannels,1,index-1);
          NMSChannelsListBox.Items.Add(temp);
          delete(NMSChannels,1,index);
          index:=Pos(' ',NMSChannels);
     end;
     NMSChannelsListBox.ItemIndex:=0;
     ProtocolComboBox.ItemIndex:=0;
end;
end.
