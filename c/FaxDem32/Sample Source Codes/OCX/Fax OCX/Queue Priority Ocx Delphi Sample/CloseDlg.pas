unit CloseDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TClosePort = class(TForm)
    ClosePortButton: TButton;
    OpenPortListBox: TListBox;
    Label1: TLabel;
    Button1: TButton;
    procedure ShowClosePort(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClosePort: TClosePort;

implementation

uses Main;

{$R *.DFM}

procedure TClosePort.ShowClosePort(Sender: TObject);
var
   OpenPorts,temp:string;
   index:integer;
begin
     OpenPortListBox.Clear;
     OpenPorts:=MainForm.FAX1.PortsOpen+' '+MainForm.FAX1.GammaChannelsOpen+' '+MainForm.FAX1.BrooktroutChannelsOpen+' '+MainForm.FAX1.DialogicChannelsOpen+' '+MainForm.FAX1.CmtrxChannelsOpen+' '+MainForm.FAX1.NMSChannelsOpen+' ';
     index:=Pos(' ',OpenPorts);
     while index<>0 do
     begin
      if index>1 then
     begin
          temp:=copy(OpenPorts,1,index-1);
          OpenPortListBox.Items.Add(temp);
     end;
          delete(OpenPorts,1,index);
          index:=Pos(' ',OpenPorts);
     end;

     OpenPortListBox.ItemIndex:=0;
end;

procedure TClosePort.OKButtonClick(Sender: TObject);
begin
     Screen.Cursor:=-11;
     if OpenPortListBox.ItemIndex<>-1 then
     begin
          MainForm.FAx1.ClosePort(OpenPortListBox.Items[OpenPortListBox.ItemIndex]);
        {  MessageDlg('Close:'+IntToStr(code)+MAinForm.ActualFaxPort,mtWarning,[mbOK],0);}
          {OpenPortListBox.Items.Clear;}
          OpenPortListBox.ItemIndex:=0;
     end;
     if (Length(MainForm.Fax1.PortsOpen)=0)and(Length(MainForm.Fax1.GammaChannelsOpen)=0)and(Length(MainForm.FAX1.BrooktroutChannelsOpen)=0)and(Length(MainForm.FAX1.DialogicChannelsOpen)=0)and(Length(MainForm.FAX1.CmtrxChannelsOpen)=0)and(Length(MainForm.FAX1.NMSChannelsOpen)=0) then
     begin
          MainForm.Close1.Enabled:=False;
          MainForm.ShowFaxManager1.Enabled:=False;
          MainForm.Send1.Enabled:=False;
          MainForm.ActualFaxport:=''
     end
     else
         MainForm.ActualFaxPort:=OpenPortListBox.Items[OpenPortListBox.ItemIndex];
     MainForm.EventListBox.Items.Add(OpenPortListBox.Items[OpenPortListBox.ItemIndex] + ' was closed');

     if (Length(MainForm.FAX1.AvailablePorts) > 0) then
        MainForm.Comm1.Enabled := True;

     if (Length(MainForm.FAX1.AvailableBrooktroutChannels) > 0) then
        MainForm.Brooktroutchannel1.Enabled := True;

     if (Length(MainForm.FAX1.AvailableGammaChannels) > 0) then
        MainForm.Gammalinkchannel1.Enabled := True;

     if (Length(MainForm.FAX1.AvailableDialogicChannels) > 0) then
        MainForm.Dialogicchannel1.Enabled := True;

     if (Length(MainForm.FAX1.AvailableNMSChannels) > 0) then
        MainForm.NMSchannel1.Enabled := True;
     Screen.Cursor:=-2;
     Close;
end;

procedure TClosePort.Button1Click(Sender: TObject);
begin
Close;
end;

end.
