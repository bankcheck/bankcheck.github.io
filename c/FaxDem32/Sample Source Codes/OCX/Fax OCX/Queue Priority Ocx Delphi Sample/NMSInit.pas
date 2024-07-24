unit NMSInit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TNMS = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    GammaLinkChannelsGroupBox: TGroupBox;
    NMSChannelsListBox: TListBox;
    HeaderCheckBox: TCheckBox;
    NumberOfRingsEdit: TEdit;
    OKButton: TButton;
    CancelButton: TButton;
    LocalIDEdit: TEdit;
    OpenDialog: TOpenDialog;
    ProtocolComboBox: TComboBox;
    Label2: TLabel;
    Label4: TLabel;
    DIDEdit: TEdit;
    procedure OnOK(Sender: TObject);
    procedure NrRingsChange(Sender: TObject);
    procedure LocalIDChange(Sender: TObject);
    procedure HeaderClick(Sender: TObject);
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

implementation

uses Main, FaxDlg;

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
   protocol, didText:string;
begin
     Screen.Cursor:=-11;
     MainForm.ActualFaxPort:=NMSChannelsListBox.Items[NMSChannelsListBox.ItemIndex];

     //Set Selected Protocol
     protocolIndex := ProtocolComboBox.ItemIndex;
     protocol := GetSelectedProtocol( protocolIndex );
     MainForm.FAX1.NMSProtocoll := protocol;

     //Set specified DID/DNIS digits
     didText := DIDEdit.Text;
     MainForm.FAX1.NMSDNISDigitNum := StrToInt(didText);

     errorOpenPort:=MainForm.FAX1.OpenPort(MainForm.ActualFaxPort);
     if errorOPenPort<>0 then
        begin
//              MessageDlg('Unable to open NMS channel '+MainForm.ActualFaxPort+' Error code:'+IntToStr(errorOpenPort),mtWarning,[mbOK],0)
                  MessageDlg(MainForm.Errors(errorOpenPort),mtWarning,[mbOK],0);
                  Screen.Cursor:=-2;
                  Exit;
        end
     else
     begin
//     MainForm.FAX1.SetSpeakerMode(MainForm.ActualFaxPort,FaxConfigDlg.SpeakerModeRadioGroup.ItemIndex,FaxConfigDlg.SpeakerVolumeRadioGroup.ItemIndex);
        MainForm.EventListBox.Items.Add(NMSChannelsListBox.Items[NMSChannelsListBox.ItemIndex] + ' was opened');

        if HeaderCheckBox.Checked then
            MainForm.FAX1.Header := True
        else
            MainForm.FAX1.Header := False;

        MainForm.FAX1.SetPortCapability(MainForm.ActualFaxPort, PC_MAX_BAUD_SEND, MainForm.BaudRate);

     end;

     if (Length(MainForm.FAX1.NMSChannelsOpen)>0) then
     begin
        MainForm.Close1.Enabled:=True;
        MainForm.ShowFaxManager1.Enabled:=True;
        MainForm.Send1.Enabled:=True;
     end;
     Close;

    if Length(MainForm.FAX1.AvailableNMSChannels) > 0 then
        MainForm.NMSchannel1.Enabled := True
    else
        MainForm.NMSchannel1.Enabled := False;

     Screen.Cursor:=-2;
end;

procedure TNMS.NrRingsChange(Sender: TObject);
begin
     MainForm.Fax1.Rings:=StrToIntDef(NumberOfRingsEdit.Text,0);
     NumberOfRingsEdit.Text:=IntToStr(MainForm.Fax1.Rings);
end;

procedure TNMS.LocalIDChange(Sender: TObject);
begin
     MainForm.Fax1.LocalID:=LocalIDEdit.Text+' ';
end;

procedure TNMS.HeaderClick(Sender: TObject);
begin
    MainForm.FAX1.Header:=HeaderCheckBox.Checked;
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
     LocalIDEdit.Text:=MainForm.Fax1.LocalID;
     NumberOfRingsEdit.Text:=IntToStr(MainForm.Fax1.Rings);
     HeaderCheckBox.Checked:=MainForm.FAX1.Header;

     ProtocolComboBox.ItemIndex:=0;
     DIDEdit.Text:='3';
end;

end.
